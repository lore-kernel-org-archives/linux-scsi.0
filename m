From: Steven Dake <sdake@mvista.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Fri, 24 Oct 2003 14:33:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067031185.4772.48.camel@persist.az.mvista.com>
References: <20031021165857.A8240@beaverton.ibm.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-S6PYG/w4Mf8oWS2fXspo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:61384 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S262659AbTJXVdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2003 17:33:08 -0400
In-Reply-To: <20031021165857.A8240@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org


--=-S6PYG/w4Mf8oWS2fXspo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 2003-10-21 at 16:58, Patrick Mansfield wrote:
> Attached is version 0.1 of scsi_id, a program to generate a SCSI unique
> identifier for a given SCSI device.
> 
> It is primarily for use with udev callout config entries. It could also be
> used for automatic multi-path configuration.
> 
Patrick,
Here is a quick hack I wrote to do automatic multipath configuration
some time ago.  It works with devfs only but could be modified by
someone interested to work with other device names.

It also uses the extended inquiry page 83 to retrieve a IEEE id.

Cheers
-steve

> It generates and uses a temporary dev entry based on the values found in
> sysfs dev attributes. This means it does not support SCSI drivers that do
> are not currently creating dev entries (st or sg). In addition, for this
> to function with st (assuming you have a tape drive that supports page 0x80
> or page 0x83) st would have to support SG_IO.
> 
> It uses the SG_IO ioctl to send SCSI INQUIRY page 0x80 or page 0x83
> commands to the SCSI device.
> 
> Requires:
> 
> - Linux kernel 2.6
> 
> - libsysfs 
> 
> No man page yet.
> 
> libsysfs 0_2_0 was not installing libsysfs.h or dlist.h, manually copy
> those files to /usr/include/sys before compiling.
> 
> Build via make and make install.
> 
> To use with udev, in short:
> 
> Run scsi_id to dump a value, for example, for sda, run:
> 
> 	scsi_id  -s /block/sda
> 
> Take the resulting value (including white space) and use it as the ID in a
> udev CALLOUT entry, an exmample /etc/udev/namedev.config entry for one of
> my disk drives:
> 
> CALLOUT, PROGRAM="/sbin/scsi_id" BUS="scsi", ID="SIBM OEM DCHS09X 68078621" NAME="disk-1"
> 
> I have not tried using scsi_id (or udev) via initramfs or initrd.
> 
> Please send me any questions, comments or patches.
> 
> Thanks!
> 
> -- Patrick Mansfield

--=-S6PYG/w4Mf8oWS2fXspo
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
#include <errno.h>

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

printf ("errno and result %d %d\n", errno, result);
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

--=-S6PYG/w4Mf8oWS2fXspo--

