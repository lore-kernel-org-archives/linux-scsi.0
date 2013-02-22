From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [Patch][RFC] st: provide tape statistics via sysfs
Date: Fri, 22 Feb 2013 02:11:22 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:42875 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3BVCNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2013 21:13:39 -0500
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t0015.houston.hp.com (Postfix) with ESMTPS id 62D5A838D
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2013 02:13:38 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

=46irst forgive me for using outlook for this, if there are any issues =
with what I sent let me know and I'll send it again from gmail. This is=
 also my first attempt at a kernel patch so please be gentle.

This patch was written to enable tape statistics via sysfs for the dt d=
river based on kernel 3.8.0-rc6. It creates two new files in sysfs and =
is based on work done previously in 2005 by Kai M=E4kisara. Any feedbac=
k would be greatly appreciated.

Assuming sysfs is mounted at /sys the first file is /sys/bus/scsi/drive=
rs/st/drives which gives a single number indicating what the largest ta=
pe drive instance assigned by st_probe in the st module is. If it's 4 i=
t possible that st0, st1, st2, and st3 exist on the system. Since tape =
drives can later be disconnected they don't have to exist, the count is=
 a hint so it's possible to gather statistics in a loop with an upper b=
ound. This makes it easier in iostat to gather statistcs.

The second file is /sys/class/scsi_tape/stxx/stat where xx is the insta=
nce of the tape drive. The file contents are almost the same as the sta=
t file for disks except the merge statistics are always 0 (since tape d=
rives are sequential merged I/Os don't make sense) and the inflight val=
ue is either a 0 or 1 since the st module always only has either one re=
ad or write outstanding. I've also added one field to the end of the fi=
le - a count other I/Os - this could be commands issued by the driver w=
ithin the kernel (e.g. rewind) or via an ioctl from user space. For tap=
e drives some commands involving actions like tape movement can take a =
long time, it's important to keep track of scsi requests sent to the ta=
pe drive other than reads and writes so when delays happen they can be =
explained.

With some future patches to iostat this figure will be reported and use=
d to calculate an average wait for all I/Os (a_await and oio/s in this =
output):

tape:   wr/s   KiB_write/s    rd/s  KiB_read/s  r_await  w_await  a_awa=
it  oio/s
st0   186.50         46.75    0.00        0.00    0.000    0.276    0.2=
76   0.00
st1   186.00         93.00    0.00        0.00    0.000    0.180    0.1=
80   0.00
st2     0.00          0.00  181.50       45.50    0.347    0.000    0.3=
47   0.00
st3     0.00          0.00  183.00       45.75    0.224    0.000    0.2=
24   0.00

Q: Does anyone have strong objections to extending the stat format to i=
nclude another field (a count of scsi commands issue to the target othe=
r than reads or writes), or should the format stay in common with disks=
 and a new device class specific file be created that provides extra st=
atistics that may be useful only for a specific class of SCSI device? F=
or example called stat-tape, stat-st or something else?

Onto justification we have a customer using virtual tape libraries (lot=
s of drives) and they wanted to be able to monitor the activity and per=
formance of their backups. Because of a lack of functionality they reso=
rted to using a publicly available SystemTap script (created by RedHat =
presumably when they received similar requests from other customers):

http://sourceware.org/systemtap/wiki/WSiostatSCSI

Unfortunately, using this script occasionally results in kernel panics =
on older kernels, those issues have been addressed but most customers s=
till don't end up running the SystemTap script unless they have to and =
they still wait to monitor performance of their tape drives.

Just googling: linux tape throughput statistics is enough to yield many=
 hits on the topic including these:

1. http://www.ibm.com/developerworks/forums/thread.jspa?messageID=3D147=
75056
2. http://h30499.www3.hp.com/t5/System-Administration/How-to-get-tape-d=
rive-performance-stats/td-p/3880235#.UKoJxNGloUo
3. http://docs.oracle.com/cd/E19455-01/816-3319/6m9k06r58/index.html

The first two are asking about getting tape stats on Linux, the reply f=
or 1. is that you can get the information on AIX. 2. is similar but the=
 reply is that you can get the information for HP-UX 11.31. The last on=
e is the iostat manual page for Solaris which can report tape stats as =
well. All 3 point out that iostat can print tape statistics on the larg=
est of the commercial unix operating systems.

Q: Does anyone have any general feedback about things that need to chan=
ge or demands about changing the implementation before being accepted?

The checkpatch.pl script generates warnings for the diffs because of Ca=
melToe however the CamelToe warnings are because I wanted to stay consi=
stent with the module (look for things like STp).

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
Signed-off-by: Darren Lavender <dcl@hppine99.gbr.hp.com>
Tested-by: Shane Seymour <shane.seymour@hp.com>
Tested-by: Darren Lavender <dcl@hppine99.gbr.hp.com>
---
diff -uprN -X linux-3.8-rc6-vanilla/Documentation/dontdiff linux-3.8-rc=
6-vanilla/drivers/scsi/st.c linux-3.8-rc6/drivers/scsi/st.c
--- linux-3.8-rc6-vanilla/drivers/scsi/st.c	2013-02-08 14:35:27.0000000=
00 +0000
+++ linux-3.8-rc6/drivers/scsi/st.c	2013-02-22 00:06:50.000000000 +0000
@@ -174,6 +174,9 @@ static int debugging =3D DEBUG;
 static int st_fixed_buffer_size =3D ST_FIXED_BUFFER_SIZE;
 static int st_max_sg_segs =3D ST_MAX_SG;
=20
+/* This is the highest drive number plus one */
+static int st_last_drive;
+
 static int modes_defined;
=20
 static int enlarge_buffer(struct st_buffer *, int, int);
@@ -458,10 +461,19 @@ static void st_scsi_execute_end(struct r
 	struct st_request *SRpnt =3D req->end_io_data;
 	struct scsi_tape *STp =3D SRpnt->stp;
 	struct bio *tmp;
+	u64 ticks =3D get_jiffies_64();
=20
 	STp->buffer->cmdstat.midlevel_result =3D SRpnt->result =3D req->error=
s;
 	STp->buffer->cmdstat.residual =3D req->resid_len;
=20
+	STp->in_flight--;
+	ticks -=3D STp->stamp;
+	STp->io_ticks +=3D ticks;
+	if (req->cmd[0] =3D=3D WRITE_6)
+		STp->write_ticks +=3D ticks;
+	else if (req->cmd[0] =3D=3D READ_6)
+		STp->read_ticks +=3D ticks;
+
 	tmp =3D SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
@@ -478,6 +490,7 @@ static int st_scsi_execute(struct st_req
 	struct rq_map_data *mdata =3D &SRpnt->stp->buffer->map_data;
 	int err =3D 0;
 	int write =3D (data_direction =3D=3D DMA_TO_DEVICE);
+	struct scsi_tape *STp =3D SRpnt->stp;
=20
 	req =3D blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
@@ -498,6 +511,18 @@ static int st_scsi_execute(struct st_req
 		}
 	}
=20
+	if (cmd[0] =3D=3D WRITE_6) {
+		STp->write_cnt++;
+		STp->write_byte_cnt +=3D bufflen;
+	} else if (cmd[0] =3D=3D READ_6) {
+		STp->read_cnt++;
+		STp->read_byte_cnt +=3D bufflen;
+	} else {
+		STp->other_cnt++;
+	}
+	STp->stamp =3D get_jiffies_64();
+	STp->in_flight++;
+
 	SRpnt->bio =3D req->bio;
 	req->cmd_len =3D COMMAND_SIZE(cmd[0]);
 	memset(req->cmd, 0, BLK_MAX_CDB);
@@ -1241,6 +1266,16 @@ static int st_open(struct inode *inode,
 	}
 	STp->try_dio_now =3D STp->try_dio;
 	STp->recover_count =3D 0;
+	STp->read_byte_cnt =3D 0;
+	STp->write_byte_cnt =3D 0;
+	STp->read_cnt =3D 0;
+	STp->write_cnt =3D 0;
+	STp->other_cnt =3D 0;
+	STp->in_flight =3D 0;
+	STp->read_ticks =3D 0;
+	STp->write_ticks =3D 0;
+	STp->io_ticks =3D 0;
+
 	DEB( STp->nbr_waits =3D STp->nbr_finished =3D 0;
 	     STp->nbr_requests =3D STp->nbr_dio =3D STp->nbr_pages =3D 0; )
=20
@@ -4123,6 +4158,17 @@ static int st_probe(struct device *dev)
 	tpnt->buffer =3D buffer;
 	tpnt->buffer->last_SRpnt =3D NULL;
=20
+	tpnt->read_byte_cnt =3D 0;
+	tpnt->write_byte_cnt =3D 0;
+	tpnt->read_cnt =3D 0;
+	tpnt->write_cnt =3D 0;
+	tpnt->other_cnt =3D 0;
+	tpnt->in_flight =3D 0;
+	tpnt->read_ticks =3D 0;
+	tpnt->write_ticks =3D 0;
+	tpnt->io_ticks =3D 0;
+	tpnt->stamp =3D 0;
+
 	tpnt->inited =3D 0;
 	tpnt->dirty =3D 0;
 	tpnt->in_use =3D 0;
@@ -4208,6 +4254,13 @@ static int st_probe(struct device *dev)
 		goto out_remove_devs;
 	scsi_autopm_put_device(SDp);
=20
+/* If there are no tape drives or one leaving st_last_drive at 0 would=
 be
+   confusing when read from user space so it contains the highest driv=
e
+   number plus one - zero means no drives controlled by this driver. *=
/
+
+	if (dev_num+1 > st_last_drive)
+		st_last_drive =3D dev_num+1;
+
 	sdev_printk(KERN_NOTICE, SDp,
 		    "Attached scsi tape %s\n", tape_name(tpnt));
 	sdev_printk(KERN_INFO, SDp, "%s: try direct i/o: %s (alignment %d B)\=
n",
@@ -4364,6 +4417,12 @@ static ssize_t st_version_show(struct de
 }
 static DRIVER_ATTR(version, S_IRUGO, st_version_show, NULL);
=20
+static ssize_t st_drives_show(struct device_driver *ddp, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", st_last_drive);
+}
+static DRIVER_ATTR(drives, S_IRUGO, st_drives_show, NULL);
+
 static int do_create_sysfs_files(void)
 {
 	struct device_driver *sysfs =3D &st_template.gendrv;
@@ -4381,9 +4440,14 @@ static int do_create_sysfs_files(void)
 	err =3D driver_create_file(sysfs, &driver_attr_version);
 	if (err)
 		goto err_attr_max_sg;
+	err =3D driver_create_file(sysfs, &driver_attr_drives);
+	if (err)
+		goto err_attr_drives;
=20
 	return 0;
=20
+err_attr_drives:
+	driver_remove_file(sysfs, &driver_attr_drives);
 err_attr_max_sg:
 	driver_remove_file(sysfs, &driver_attr_max_sg_segs);
 err_attr_fixed_buf:
@@ -4397,6 +4461,7 @@ static void do_remove_sysfs_files(void)
 {
 	struct device_driver *sysfs =3D &st_template.gendrv;
=20
+	driver_remove_file(sysfs, &driver_attr_drives);
 	driver_remove_file(sysfs, &driver_attr_version);
 	driver_remove_file(sysfs, &driver_attr_max_sg_segs);
 	driver_remove_file(sysfs, &driver_attr_fixed_buffer_size);
@@ -4478,12 +4543,30 @@ options_show(struct device *dev, struct
 	return l;
 }
=20
+static ssize_t
+stat_show(struct device *dev, struct device_attribute *attr, char *buf=
)
+{
+	struct st_modedef *STm =3D dev_get_drvdata(dev);
+	struct scsi_tape *STp =3D STm->tape;
+
+/* io_ticks includes time spent doing internal commands that are requi=
red
+   for the tape driver to work like rewinding the tape drive for a
+   rewind device. */
+	return snprintf(buf, PAGE_SIZE, "%llu 0 %llu %u %llu 0 %llu %u %llu %=
u %u %llu",
+		STp->read_cnt, STp->read_byte_cnt >> 9,
+		jiffies_to_msecs(STp->read_ticks), STp->write_cnt,
+		STp->write_byte_cnt >> 9, jiffies_to_msecs(STp->write_ticks),
+		STp->in_flight, jiffies_to_msecs(STp->io_ticks),
+		jiffies_to_msecs(STp->io_ticks), STp->other_cnt);
+}
+
 static struct device_attribute st_dev_attrs[] =3D {
 	__ATTR_RO(defined),
 	__ATTR_RO(default_blksize),
 	__ATTR_RO(default_density),
 	__ATTR_RO(default_compression),
 	__ATTR_RO(options),
+	__ATTR_RO(stat),
 	__ATTR_NULL,
 };
=20
diff -uprN -X linux-3.8-rc6-vanilla/Documentation/dontdiff linux-3.8-rc=
6-vanilla/drivers/scsi/st.h linux-3.8-rc6/drivers/scsi/st.h
--- linux-3.8-rc6-vanilla/drivers/scsi/st.h	2013-02-08 14:35:18.0000000=
00 +0000
+++ linux-3.8-rc6/drivers/scsi/st.h	2013-02-22 00:08:42.000000000 +0000
@@ -158,6 +158,19 @@ struct scsi_tape {
 	int max_block;
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
+/* Tape stats */
+	u64 read_byte_cnt;	/* bytes read since tape open */
+	u64 write_byte_cnt;	/* bytes written since tape open */
+	u64 in_flight;		/* Number of I/Os in flight */
+	u64 read_cnt;		/* Count of read requests since tape open */
+	u64 write_cnt;		/* Count of write requests since tape open */
+	u64 other_cnt;		/* Count of other requests since tape open
+				   either implicit (from driver) or from
+				   user space via ioctl. */
+	u64 read_ticks;		/* Ticks spent completing read requests */
+	u64 write_ticks;	/* Ticks spent completing write requests */
+	u64 io_ticks;		/* Ticks spent doing any I/O */
+	u64 stamp;		/* holds time request was queued */
=20
 #if DEBUG
 	unsigned char write_pending;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
