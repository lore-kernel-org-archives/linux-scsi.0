From: Steven Dake <sdake@mvista.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Wed, 06 Aug 2003 13:26:41 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1060201601.25773.30.camel@persist.az.mvista.com>
References: <1060042082.1985.53.camel@fuzzy>
	 <20030805171416.A7963@beaverton.ibm.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NBZ8Qu2M0fcTrP+HK9On"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030805171416.A7963@beaverton.ibm.com>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-NBZ8Qu2M0fcTrP+HK9On
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2003-08-05 at 17:14, Patrick Mansfield wrote:
> James -
> 
> Thanks for the summary.
> 
> On Mon, Aug 04, 2003 at 08:54:55PM -0700, James Bottomley wrote:
> 
> > 1. Multi-path is relevant to more layers of the I/O stack than just
> > SCSI. Thus, it makes sense to do it at the layer just above bio.  This
> > would either be md/multipath or the Device Mapper multi-path module.
> 
> I was hoping for linux scsi to evolve into a "native queueing driver" [1],
> adding multi-path to such a driver would be appropriate (of course IMO),
> users of the native queueing driver would then get multi-path support.
> (This is what I meant when referencing the "packet command interface" at
> the SCSI BOF, sorry if the name made no sense, I thought there had been
> earlier references to a common "packet interface" driver or such.)
> 
> Given the consensus for md/dm, I'm not planning any further work on a scsi
> mid-level solution, though technically I prefer the mid-level approach.
> 
Patrick,

There are problems with multipath in the md driver, specifically how to
manage partitions.  Each partition requires a seperate multipath. 
Changing partition sizes is quite difficult after multipaths are setup. 
One could argue that partitions should be managed by device mapper, but
unfortunately all firmware doesn't know about device mapper devices,
requiring the use of partitions.  Also most people don't want to mess
with device mapper.

I like the idea of a generic queueing interface for block commands
integrated with multipathing as it solves the partitioning problem quite
nicely.

As an example of the problems associated with multipath in the md
driver, I've attached a small program that automatically configures SCSI
multipaths using the md layer driver (requires devfs, but should be easy
for you:) to modify).  But after this, it becomes incredibly difficult
to manage multipaths during partition changes.

There are solutions to manage this (online change of multipath size
during fdisk), but it would be better if multipath didn't have to
multipath the partitions as well.

After running the program, look at /proc/mdstat to see all of the
multipaths automatically configured.  While its pretty neat, it makes
managing partitions impossible (or does someone have a way??).

Thanks
-steve


> One other issue discussed at the multi-path BOF is the lack of character
> device (tape) support - dm does not work for such devices. (We do not need
> a multi-ported tape device to see multi-path in linux, multiple
> initiators on the same transport/bus/etc. also show up as multi-path).
> 
> Some other points following.
> 
> > 3.  It was noted that symmetric active multi-path in this scheme is not
> > possible without the ability to place a proper elevator above the
> > multi-pathing driver (and have a simple queue only noop elevator
> > below).  This should help alleviate the current fragmentation issues
> > where symmetric active multi-path produces I/O in decidedly non-optimal
> > page sized chunks.
> 
> Related to queueing - we also need to queue commands (in dm) to avoid
> sending too many commands to the actual device: dm should not send more
> than scsi_device->queue_depth commands.
> 
> queue_depth changes via user (sysfs) or kernel space should eventually be
> addressed (right now only one LLDD is using the scsi_track_queue_full).
> 
> We should eventually export scsi_host attributes (i.e. host_busy reached
> can_queue limit, and host_blocked) such that dm can avoid congested or
> blocked hosts.
> 
> We need to ensure that scsi_device fields (generally the per device state-like)
> function properly when used with multi-path dm, including:
> 
> 	access_count - probably OK with latest ref count changes, so a
> 	call to the release function by dm should remove a scsi_device (if
> 	scsi_remove_device was called on an active scsi_device), I don't
> 	know dm/md enough as to when/how it might release a path/device
> 
> 	online - more below
> 
> 	was_reset - probably OK, since it is somewhat path specific
> 
> 	expecting_cc_ua - probably OK, same as was_reset
> 
> 	device_blocked - QUEUE FULL was seen, we don't want commands
> 	on a given path to be starved out
> 
> 	sdev_state - Mike's changes, I haven't looked at if/how it's
> 	affected relative to dm multi-path
> 
> For the online flag: on timeout, if we fast fail and do not try to recover
> the device or transport, the device could be left online, and leave it to
> dm to not send any further IO requests. This also might protect us from device
> resets (other paths might have active IO). But this means a timeout might
> take a dm path offline, and retrying on a separate path could offline all
> paths to the device.
> 
> > infrastructure for us (in 2.6.0-test2).  The attached patch should add
> > the fast fail capability to SCSI (although without the upwards/downwards
> > failure indications) and we should be able to build the rest of the
> > infrastructure on this framework.
> 
> What about a MEDIUM_ERROR - will all sectors be seen as completed with no
> error for partial completion of IO (uptodate is 1 in scsi_end_request,
> but your patch sets sectors = req->hard_nr_sectors)?
> 
> Per above the error handler (cmd timeout) should not requeue/retry if fast
> fail is set (in scsi_eh_flush_done_q). And, should the error handler
> recovery/resetting run for fast fail?
> 
> [1] http://marc.theaimsgroup.com/?l=linux-kernel&m=105400909207359&w=2
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--=-NBZ8Qu2M0fcTrP+HK9On
Content-Disposition: attachment; filename=automp.c
Content-Type: text/x-c; name=automp.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/*
 * Copyright (C) 2003 MontaVista Software, Inc.
 *
 *	Author: Steven Dake (sdake@mvista.com)
 *
 * GPL v2 License
 */
#include <sys/sysmacros.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/major.h>
#include <string.h>
#include <linux/list.h>
#include <scsi/scsi.h>
#include <scsi/scsi_ioctl.h>
#include <dirent.h>
#include <stdio.h>

#include <linux/fs.h>
#include <linux/raid/md_u.h>


struct scsi_device_strings {
	char vendor[9];
	char model[17];
	char rev[5];
	char serial[9];
};

union ieee_id_map {
	unsigned long long ieee_id;
	unsigned char ieee_id_u8[8];
};

struct scsi_device {
	struct scsi_device_strings scsi_device_strings;
	unsigned long long ieee_id;
	unsigned char lun;
	unsigned char host;
	unsigned char bus;
	unsigned char id;
	unsigned int partmap;
};

struct scsi_get_idlun {
	unsigned char id;
	unsigned char lun;
	unsigned char bus;
	unsigned char host;
	unsigned int host_unique_id;
};

struct device_number {
	int number;
	struct device_number *next;
};

struct multipath {
	struct device_number *device_number_head;
	struct scsi_device *scsi_device;
	int paths;
};

struct inquiry_command {
	unsigned int input_size;
	unsigned int output_size;
	char cmd[6];
};

struct inquiry_result {
	unsigned int input_size;
	unsigned int output_size;
	unsigned char device_type;
	unsigned char device_modifier;
	unsigned char version;
	unsigned char data_format;
	unsigned char length;
	unsigned char reserved1;
	unsigned char reserved2;
	unsigned char state;
	unsigned char vendor[8];
	unsigned char model[16];
	unsigned char rev[4];
	unsigned char serial[12];
	unsigned char reserved[39];
};

struct extended_inquiry_result {
	unsigned int input_size;
	unsigned int output_size;
	unsigned char junk[8];
	unsigned char ieee_id[8];
};


int get_scsi_device (int minor, struct scsi_device *device)
{
unsigned char ioctl_data[256];
struct inquiry_command *inquiry_command;
struct inquiry_result *inquiry_result;
struct extended_inquiry_result *extended_inquiry_result;
int fd;
int i, j;
int result;
unsigned char *p;
struct scsi_get_idlun scsi_get_idlun;
union ieee_id_map ieee_id_map;

	result = mknod ("this", 0600 | S_IFCHR, makedev (SCSI_GENERIC_MAJOR, minor));
	if (result) {
		return (-1);
	}

	fd = open ("this", O_RDWR);
	if (fd == -1) {
		unlink ("this");
		return (-1);
	}

	memset (ioctl_data, 0, sizeof (ioctl_data));
	
	/*
	 * Execute inquiry command to get SCSI serial number
	 */
	inquiry_command = ioctl_data;
	inquiry_command->input_size = 0;
	inquiry_command->output_size = sizeof (struct inquiry_result);
	inquiry_command->cmd[0] = 0x12;
	inquiry_command->cmd[1] = 0x00;
	inquiry_command->cmd[2] = 0x00;
	inquiry_command->cmd[3] = 0x00;
	inquiry_command->cmd[4] = 96;
	inquiry_command->cmd[5] = 0x00;

	result = ioctl (fd, 1, inquiry_command);

	inquiry_result = ioctl_data;
	strncpy (device->scsi_device_strings.vendor, inquiry_result->vendor, 8);
	strncpy (device->scsi_device_strings.model, inquiry_result->model, 16);
	strncpy (device->scsi_device_strings.rev, inquiry_result->rev, 4);
	strncpy (device->scsi_device_strings.serial, inquiry_result->serial, 12);

	/*
	 * Get IEEE unique ID (FibreChannel WWN) from EVPD page 0x83
	 */
	inquiry_command->input_size = 0;
	inquiry_command->output_size = sizeof (struct extended_inquiry_result);
	inquiry_command->cmd[0] = 0x12;
	inquiry_command->cmd[1] = 0x01;
	inquiry_command->cmd[2] = 0x83;
	inquiry_command->cmd[3] = 0x00;
	inquiry_command->cmd[4] = 96;
	inquiry_command->cmd[5] = 0x00;

	extended_inquiry_result = ioctl_data;

	result = ioctl (fd, 1, inquiry_command);

	for (i = 0, j = 7; i < 8; i++, j--) {
		ieee_id_map.ieee_id_u8[j] = extended_inquiry_result->ieee_id[i];
	}

	device->ieee_id = ieee_id_map.ieee_id;

for (i = 0; i < 30; i++) {
	printf ("%02x,", extended_inquiry_result->ieee_id[i]);
}
printf ("\n\n");

	
	/*
	 * Get path to device
	 */
	result = ioctl (fd, SCSI_IOCTL_GET_IDLUN, &scsi_get_idlun);
	device->host = scsi_get_idlun.host;
	device->bus = scsi_get_idlun.bus;
	device->id = scsi_get_idlun.id;
	device->lun = scsi_get_idlun.lun;

	close (fd);

	unlink ("this");

	return (0);
}

int sd_major (int devno) {
	return (8);
}
int sd_minor (int devno) {
	return (16 * devno);
}

int g_md_minor = 255;

int get_md_minor (void) {
	return (g_md_minor--);
}

int configure_path (struct multipath *path)
{
	mdu_param_t mdu_p;
	mdu_version_t mdu_v;
	mdu_array_info_t mdu_a;
	mdu_disk_info_t mdu_d;
	int fd;
	int disk_fd;
	int result;
	char path_to_md[256];
	char path_to_disk[256];
	struct device_number *device_number;
	int i;
	int part;
	int disk_size;
	int md_minor;

	for (part = 0; part < 16; part++) {
		/*
		 * Skip when partition map bit not set
		 */
		if (part > 0 && ((path->scsi_device->partmap & (1 << part - 1)) == 0)) {
			continue;
		}
		md_minor = get_md_minor ();

		sprintf (path_to_md, "/dev/md/%d", md_minor);
		fd = open (path_to_md, O_RDONLY);

		result = ioctl (fd, RAID_VERSION, &mdu_v);

		if (part == 0) {
		sprintf (path_to_disk, "/dev/scsi/host%d/bus%d/target%d/lun%d/disc",
			path->scsi_device->host,
			path->scsi_device->bus,
			path->scsi_device->id,
			path->scsi_device->lun);
		} else {
		sprintf (path_to_disk, "/dev/scsi/host%d/bus%d/target%d/lun%d/part%d",
			path->scsi_device->host,
			path->scsi_device->bus,
			path->scsi_device->id,
			path->scsi_device->lun,
			part);
		}

		disk_fd = open (path_to_disk, O_RDONLY);
		result = ioctl (disk_fd, BLKGETSIZE, &disk_size);
		disk_size = disk_size / 2;
		close (disk_fd);
		
		mdu_a.active_disks = path->paths;
		mdu_a.working_disks = path->paths;
		mdu_a.level = -4;
		mdu_a.size = disk_size;
		mdu_a.raid_disks = path->paths;
		mdu_a.md_minor = md_minor;
		mdu_a.not_persistent = 1;
		mdu_a.state = 0;
		mdu_a.spare_disks = 0;
		mdu_a.failed_disks = path->paths;
		mdu_a.nr_disks = 2;
		mdu_a.layout = 0;
		mdu_a.chunk_size = 0;
		result = ioctl (fd, SET_ARRAY_INFO, &mdu_a);

		device_number = path->device_number_head;
		for (i = 0; i < path->paths; i++) {
			mdu_d.number = i;
			mdu_d.raid_disk = i;
			mdu_d.state = 6;
		mdu_d.major = sd_major (device_number->number);
		mdu_d.minor = sd_minor (device_number->number) + part;

		result = ioctl (fd, ADD_NEW_DISK, &mdu_d);
		device_number = device_number->next;
		}

		memset (&mdu_p, 0, sizeof (mdu_param_t));
		mdu_p.personality = -4;
		mdu_p.chunk_size = 0;

		result = ioctl (fd, RUN_ARRAY, &mdu_p);
		printf ("Multipath created: /dev/md/%d.\n", md_minor);
	}
}

int main (void)
{
struct scsi_device scsi_device_array[256];
struct multipath mp_table[256];
int i, j, next_loc, new_entry;
int result;
int scsi_device_count;
struct device_number *devno;
int print_device_list = 0;
int print_mp_list = 1;
DIR *dir;
off_t basep;
unsigned char buffer[1024];
char path_to_device[128];
struct dirent *dirent;
int part;
int part_count;
int fd;

	for (i = 0; i < 256; i++) {
		result = get_scsi_device (i, &scsi_device_array[j]);
		if (result == 0) {
			j++;
		}
	}

print_device_list = 1;
	if (print_device_list) {
		for (i = 0; i < j; i++) {
			printf ("device [%d] vendor [%s] model [%s] rev [%s] serial [%s]",
				i,
				scsi_device_array[i].scsi_device_strings.vendor,
				scsi_device_array[i].scsi_device_strings.model,
				scsi_device_array[i].scsi_device_strings.rev,
				scsi_device_array[i].scsi_device_strings.serial
			);
			if (scsi_device_array[i].ieee_id) {
				printf (" IEEE ID [%llx]\n", scsi_device_array[i].ieee_id);
			} else {
				printf ("\n");
			}
		}
	}

	scsi_device_count = j;

	/*
	 * Build multipath information
	 */
	for (next_loc = 0, i = 0; i < scsi_device_count; i++) {
		mp_table[next_loc].scsi_device = &scsi_device_array[i];
		mp_table[next_loc].device_number_head = 0;
		mp_table[next_loc].paths = 0;

		for (j = i; j < scsi_device_count; j++) {
			if (i == j) {
				continue;
			}
			if (memcmp (&scsi_device_array[i].scsi_device_strings, &scsi_device_array[j].scsi_device_strings, sizeof (struct scsi_device_strings)) == 0) {
				/*
				 * If this is the first found multiple path, create first link
				 */
				if (mp_table[next_loc].device_number_head == 0) {
					devno = (struct device_number *)malloc (sizeof (struct device_number));
					devno->next = 0;
					devno->number = i;
					mp_table[next_loc].device_number_head = devno;
					mp_table[next_loc].paths = 1;
				}

				/* * Create link for this new path
				 */
				devno = (struct device_number *)malloc (sizeof (struct device_number));
				devno->next = mp_table[next_loc].device_number_head;
				mp_table[next_loc].device_number_head = devno;
				devno->number = j;
				new_entry = 1;

				mp_table[next_loc].paths++;
			}
		}
		if (new_entry) {
			new_entry = 0;
			next_loc += 1;
		}
	}

	if (print_mp_list) {
		printf ("Multiple paths found:\n");
	}
	for (i = 0; i < next_loc; i++) {
		if (print_mp_list) {
			printf ("vendor [%s] model [%s] rev [%s] serial [%s]\n",
				scsi_device_array[i].scsi_device_strings.vendor,
				scsi_device_array[i].scsi_device_strings.model,
				scsi_device_array[i].scsi_device_strings.rev,
				scsi_device_array[i].scsi_device_strings.serial);
		}

		for (devno = mp_table[i].device_number_head; devno; devno = devno->next) {
			if (print_mp_list) {
				printf ("\tdevice no %d: /dev/scsi/host%d/bus%d/target%d/lun%d\t",
					devno->number,
					scsi_device_array[devno->number].host,
					scsi_device_array[devno->number].bus,
					scsi_device_array[devno->number].id,
					scsi_device_array[devno->number].lun);
			}

			sprintf (path_to_device, "/dev/scsi/host%d/bus%d/target%d/lun%d", 
				scsi_device_array[devno->number].host,
				scsi_device_array[devno->number].bus,
				scsi_device_array[devno->number].id,
				scsi_device_array[devno->number].lun);

			dir = opendir (path_to_device);
			part_count = 0;
			do {
				dirent = readdir (dir);
				if (dirent) {
					if (strncmp (dirent->d_name, "part", 4) == 0) {
						part = atoi (&dirent->d_name[4]);
						scsi_device_array[devno->number].partmap |= (1 << part - 1);
						part_count++;
					}
				}
			} while (dirent);
			closedir (dir);
			if (print_mp_list) {
				printf ("[1 disc, %d partitions]\n", part_count);
			}
		}

		printf ("\n");
	}

	for (i = 0; i < next_loc; i++) {
		configure_path (&mp_table[i]);
	}
}

--=-NBZ8Qu2M0fcTrP+HK9On--

