From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 02:44:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620004442.GA19824@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

Hi Linus,

find attached a patch (against 2.5.23-dj2) to the SCSI subsystem which=20
adds a file /proc/scsi/map, which provides a listing of SCSI devices,
enumerated by the CBTU/HCIL tuple and the high-level devices attached t=
o
them.=20

This information is useful for=20
* the user who wants to find out to what high-level interfaces the SCSI=
=20
  devices in /proc/scsi/scsi list
* userspace tools that want to collect information about the SCSI devic=
es
  in order to provide persistent device naming and need to use the=20
  corresponding sg devices for this.
  In case the admin ensures the stability of the CBTU nexus, the includ=
ed
  script is even enough to provide persistent naming.
* allowing boot=3D/dev/scsi/sdcXbXtXuXpX parameter (even without devfs)=
,
  extra patch required, will be send by separate mail
* reporting major:minor pairs to userspace for dynamic device allocatio=
n
  that's needed to support > 128 disks.

garloff@pckurt:~ $ cat /proc/scsi/map
0,0,00,00       0x05    1       sg0     c:15:00 sr0     b:0b:00
1,0,01,00       0x05    1       sg1     c:15:01 sr1     b:0b:01
1,0,02,00       0x01    1       sg2     c:15:02 osst0   c:ce:00
1,0,03,00       0x05    1       sg3     c:15:03 sr2     b:0b:02
1,0,05,00       0x00    1       sg4     c:15:04 sda     b:08:00
1,0,09,00       0x00    1       sg5     c:15:05 sdb     b:08:10
2,0,01,00       0x05    1       sg6     c:15:06 sr3     b:0b:03
2,0,02,00       0x01    1       sg7     c:15:07 osst1   c:ce:01
2,0,03,00       0x05    1       sg8     c:15:08 sr4     b:0b:04
2,0,05,00       0x00    1       sg9     c:15:09 sdc     b:08:20
2,0,09,00       0x00    1       sg10    c:15:0a sdd     b:08:30
3,0,10,00       0x00    1       sg11    c:15:0b sde     b:08:40
3,0,12,00       0x00    1       sg12    c:15:0c sdf     b:08:50

Compared to the patch against 2.4.19-pre10, which has been discussed on
LKML, I removed the header line from the map file and added a text file
documenting the format of /proc/scsi/map.

The patch has been ported to 2.5 by Andries Brouwer. I have removed mos=
t=20
of his formatting cleanups (to unrelated code in the same files) that h=
e
has done. Doug Gilbert has given a lot of useful feedback. Thx!

Please apply!

diff -uNr linux-2.5.23-dj2/Documentation/scsi-devs.sh linux-2.5.23-dj2-=
scsimap/Documentation/scsi-devs.sh
--- linux-2.5.23-dj2/Documentation/scsi-devs.sh	Thu Jan  1 01:00:00 197=
0
+++ linux-2.5.23-dj2-scsimap/Documentation/scsi-devs.sh	Fri Jun 14 22:3=
7:11 2002
@@ -0,0 +1,154 @@
+#!/bin/bash
+# Script to create SCSI device nodes according to their physical
+# address (host controller no,bus/channel,target SCSI ID,unit SCSI LUN=
)
+# using the /proc/scsi/map introduced in Linux 2.4.20pre/2.5.2x
+# (c) Kurt Garloff <garloff@suse.de>, 2002-06-13
+# License: GNU GPL v2
+
+# Settings
+
+# Target directory for device nodes/links
+TDIR=3D/dev/scsi
+
+# Make symbolic links or create fresh nodes in $TDIR
+# For link mode, the dev nodes will still be made if needed
+MODE=3D
+
+# In link mode, where is the real /dev dir ?
+DEVDIR=3D..
+
+# Ownership and permissions of newly created device nodes
+OWNER=3D"root.disk"
+PERM=3D"0660"
+SDIRPERM=3D"0755"
+
+# Make scsi disk partitions (0 =3D off)
+SDPART=3D15
+
+# End of settings
+
+# Options
+# -f: Remove all old devs
+if test "$1" =3D "-f"; then
+  rm -f $TDIR/*
+  shift
+fi
+# -l: Make links=20
+if test "$1" =3D "-l"; then
+  MODE=3DLINK
+  shift
+fi
+
+# Sanitize environment
+export LANG=3Dposix
+unset IFS
+#umask `printf %o $[0777-$PERM]`
+PATH=3D/bin:/usr/bin:/sbin:/usr/sbin
+
+# Functions
+function exit_fail=20
+{
+  echo $1
+  exit $2
+}
+
+# Build new scsi name based on oldname (prefix) and=20
+# append host,channel,id,lun numbers that are unique
+# and persistent identifiers for the device.
+function builddevnm
+{=20
+  if test "${5:0:2}" =3D "sd"; then
+    NM=3D"sdc$1b$2t${3#0}u${4#0}"
+  else
+    NM=3D"${5%%[0-9]*}c$1b$2t${3#0}u${4#0}"
+  fi
+}
+
+# Make device node
+# Parameters filename type maj(hex) min(hex) minadd(dec)
+function mk_nod
+{
+  rm -f $1
+  mknod -m $PERM $1 $2 $[0x$3] $[0x$4+$5]
+  chown $OWNER $1
+}
+
+# Make device by creating node or symlinking
+# Parameters oldname device(tp:maj:min) newname minadd
+function mk_dev=20
+{
+  IFS=3D":"
+  if test "$MODE" =3D "LINK"; then
+    if test ! -e $TDIR/$DEVDIR/$1; then
+      mk_nod $TDIR/$DEVDIR/$1 $2 $4
+    fi
+    ln -sf $DEVDIR/$1 $TDIR/$3
+  else
+    mk_nod $TDIR/$3 $2 $4
+  fi
+  unset IFS
+}
+
+# Make multiple devices in case we do have sd partitions
+# Parameters oldname device(tp:maj:min) newname
+function mk_devs
+{
+  mk_dev $1 $2 $3 0
+  # Handle partitions
+  if test "${1:0:2}" =3D "sd" -a "$SDPART" !=3D "0"; then
+    #unset IFS
+    for no in `seq 1 $SDPART`; do
+      mk_dev $1$no $2 $3p$no $no
+    done
+  fi
+  # Handle nst/nosst
+  if test "${1:0:2}" =3D "st" -o "${1:0:4}" =3D "osst"; then
+    mk_dev n$1 $2 n$3 128
+  fi
+}
+
+# Main() Script
+if ! test -e /proc/scsi/map; then
+  exit_fail "/proc/scsi/map does not exist" 1
+fi
+if ! test -d $TDIR; then
+  mkdir -m $SDIRMODE $TDIR || exit_fail "Failed to create $TDIR" 2
+  chown $OWNER $TDIR
+fi
+
+# We might have been called by some sort of hotplug event
+# and are only support to add a single device
+# Syntax for this is [-l] add host channel id lun
+if test "$1" =3D "add"; then
+  CMPAGAINST=3D"$2,$3,`printf %02i $4`,`printf %02i $5`"
+else
+  unset CMPAGAINST
+fi
+# The main processing loop
+while read cbtu tp onl sgnm sgdev othnm othdev oothnm oothdev rest; do
+  # Skip comment line(s)
+  if test "${cbtu:0:1}" =3D "#"; then continue; fi
+  # If we're just dealing with one device, do skip the others
+  if test ! -z "$CMPAGAINST" -a "$CMPAGAINST" !=3D "$cbtu"; then conti=
nue; fi
+  # now parse line
+  IFS=3D","
+  # Test for validity of sg device
+  if test "$sgnm" !=3D "sg?"; then
+    builddevnm $cbtu $sgnm
+    mk_dev $sgnm $sgdev $NM 0
+  fi
+  # There is possibly a second device
+  if test ! -z "$othnm" -a ! "$othnm" =3D "none"; then
+    IFS=3D","
+    builddevnm $cbtu $othnm
+    mk_devs $othnm $othdev $NM
+    # Maybe even a third one
+    if test ! -z "$oothnm" -a ! "$oothnm" =3D "none"; then
+      IFS=3D","
+      builddevnm $cbtu $oothnm
+      mk_devs $oothnm $oothdev $NM
+    fi
+  fi
+  unset IFS
+done < /proc/scsi/map
+
diff -uNr linux-2.5.23-dj2/Documentation/scsi-map.txt linux-2.5.23-dj2-=
scsimap/Documentation/scsi-map.txt
--- linux-2.5.23-dj2/Documentation/scsi-map.txt	Thu Jan  1 01:00:00 197=
0
+++ linux-2.5.23-dj2-scsimap/Documentation/scsi-map.txt	Wed Jun 19 18:5=
8:30 2002
@@ -0,0 +1,61 @@
+/proc/scsi/map file format
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+The file /proc/scsi/map reports the mapping of SCSI devices to high-le=
vel
+drivers (sg,sr,sd,st,osst) in Linux. The SCSI devices are identified b=
y
+Controller/host number, bus/channel number, SCSI Target ID and SCSI Un=
it/LUN
+number.
+
+The output looks as following:
+
+garloff@pckurt:/raid5/Kernel $ head -18 /proc/scsi/map=20
+0,0,00,00       0x05    1       sg0     c:15:00 sr0     b:0b:00
+1,0,01,00       0x05    1       sg1     c:15:01 sr1     b:0b:01
+1,0,02,00       0x01    1       sg2     c:15:02 osst0   c:ce:00
+1,0,03,00       0x05    1       sg3     c:15:03 sr2     b:0b:02
+1,0,05,00       0x00    1       sg4     c:15:04 sda     b:08:00
+1,0,09,00       0x00    1       sg5     c:15:05 sdb     b:08:10
+2,0,01,00       0x05    1       sg6     c:15:06 sr3     b:0b:03
+2,0,02,00       0x01    1       sg7     c:15:07 osst1   c:ce:01
+2,0,03,00       0x05    1       sg8     c:15:08 sr4     b:0b:04
+2,0,05,00       0x00    1       sg9     c:15:09 sdc     b:08:20
+2,0,09,00       0x00    1       sg10    c:15:0a sdd     b:08:30
+3,0,10,00       0x00    1       sg11    c:15:0b sde     b:08:40
+3,0,12,00       0x00    1       sg12    c:15:0c sdf     b:08:50
+
+The format contains a variable number of columns, separated by a TAB '=
\t'
+character.
+
+1st column: The Controller, Bus, Target, Unit (or call it Host, Channe=
l, ID,
+            LUN) tuple that identifies a SCSI device. The numbers are =
all
+	    in decimal format and separated by commas.
+2nd column: Device type as reported in the peripheral device type fiel=
d
+	    as reported by SCSI INQUIRY. Hexadecimal.
+3rd column: Flag whether the device is online.
+
+These columns are followed by pairs of columns, depending on how many
+high-level drivers are attached to the device:
+
+Nth column: Driver name with an index attached. This co=EFncides with =
the old
+	    style device naming used on SCSI distributions and documented
+	    in devices.txt. For disks, therefore the index is composed of
+	    characters to produce the names sda ... sdz, sdaa ... sdaz,
+	    sdba ... etc.
+(N+1)th c.: Device node that belongs to this device. First character i=
s
+	    identifying whether we deal with a character device (c) or a=20
+	    block device(b). The major and minor numbers follow in hexa-
+	    decimal formast, separated with colons (:).
+
+The sg devices are reported first.
+If there is no sg device, sg? c:NN:NN will be reported.
+For the other devices the columns are just left empty.
+
+The reason for this special ahndling of sg is that sg is special in
+that it can drive all devices and can be used by userspace tools=20
+to inquire extra information (by sending SCSI commands or doing ioctls=
)=20
+in order to provide persistent device naming.
+
+Note that only loaded drivers (modules) can attach to the devices, so
+you e.g. won't see "sr" output, unless you have the sr driver compiled=
=20
+into your kernel or loaded as module.
+
+				Kurt Garloff <garloff@suse.de>, 2002-06-19
diff -uNr linux-2.5.23-dj2/drivers/scsi/hosts.h linux-2.5.23-dj2-scsima=
p/drivers/scsi/hosts.h
--- linux-2.5.23-dj2/drivers/scsi/hosts.h	Thu Jun 20 01:44:47 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/hosts.h	Thu Jun 20 02:03:21 2=
002
@@ -486,6 +486,7 @@
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code=
=2E=20
                                            Selects command for blkdevs=
 */
+    int (*find_kdev)(Scsi_Device *, char*, kdev_t*);  /* find back dev=
=2E */
 };
=20
 void  scsi_initialize_queue(Scsi_Device * SDpnt, struct Scsi_Host * SH=
pnt);
diff -uNr linux-2.5.23-dj2/drivers/scsi/osst.c linux-2.5.23-dj2-scsimap=
/drivers/scsi/osst.c
--- linux-2.5.23-dj2/drivers/scsi/osst.c	Wed Jun 19 04:11:54 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/osst.c	Thu Jun 20 02:03:21 20=
02
@@ -155,6 +155,7 @@
 static int osst_attach(Scsi_Device *);
 static int osst_detect(Scsi_Device *);
 static void osst_detach(Scsi_Device *);
+static int osst_find_kdev(Scsi_Device *, char*, kdev_t*);
=20
 struct Scsi_Device_Template osst_template =3D
 {
@@ -166,7 +167,8 @@
        detect:		osst_detect,
        init:		osst_init,
        attach:		osst_attach,
-       detach:		osst_detach
+       detach:		osst_detach,
+       find_kdev:	osst_find_kdev,
 };
=20
 static int osst_int_ioctl(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, u=
nsigned int cmd_in,unsigned long arg);
@@ -5417,6 +5419,24 @@
 	return 0;
 }
=20
+static int osst_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	int i;
+	OS_Scsi_Tape *ostp;
+=09
+	if (sdp && sdp->type =3D=3D TYPE_TAPE && osst_supports(sdp)) {
+		for (ostp =3D os_scsi_tapes[i =3D 0]; i < osst_template.dev_max;
+		     ostp =3D os_scsi_tapes[++i]) {
+			if (ostp && ostp->device =3D=3D sdp) {
+				sprintf (nm, "osst%i", i);
+				*dev =3D mk_kdev(OSST_MAJOR, i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 static int osst_attach(Scsi_Device * SDp)
 {
 	OS_Scsi_Tape * tpnt;
diff -uNr linux-2.5.23-dj2/drivers/scsi/scsi.c linux-2.5.23-dj2-scsimap=
/drivers/scsi/scsi.c
--- linux-2.5.23-dj2/drivers/scsi/scsi.c	Wed Jun 19 04:11:55 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/scsi.c	Thu Jun 20 02:06:34 20=
02
@@ -78,6 +78,7 @@
=20
 #ifdef CONFIG_PROC_FS
 static int scsi_proc_info(char *buffer, char **start, off_t offset, in=
t length);
+static int scsi_proc_map (char *buffer, char **start, off_t offset, in=
t length);
 static void scsi_dump_status(int level);
 #endif
=20
@@ -1545,6 +1546,71 @@
 }
=20
 #ifdef CONFIG_PROC_FS
+/*=20
+ * Output the mapping of physical devices (contorller,channel.id,lun)
+ * to devices (sg and other highlevel drivers) to /proc/scsi/map.
+ * Caveat: No locking is done, so if your scsi config changes during
+ * reading this file, you may read garbled data.	KG, 2002-06-14
+ */
+static int scsi_proc_map(char *buffer, char **start, off_t offset, int=
 length)
+{
+	Scsi_Device *scd;
+	struct Scsi_Host *HBA_ptr;
+	int size =3D 0, len =3D 0;
+	off_t begin =3D 0;
+	off_t pos =3D 0;
+#ifdef CONFIG_KMOD
+	int repeat =3D 0;
+#endif
+
+	struct Scsi_Device_Template *sg_t;
+	do {
+		sg_t =3D scsi_devicelist;
+		while (sg_t && !(sg_t->tag && !strcmp(sg_t->tag, "sg")))
+			sg_t =3D sg_t->next;
+#ifdef CONFIG_KMOD
+		if (!repeat && !sg_t)
+			request_module("sg");
+	} while (!repeat++);
+#else
+	} while (0);
+#endif=09
+	/*
+	 * First, see if there are any attached devices or not.
+	 */
+	for (HBA_ptr =3D scsi_hostlist; HBA_ptr; HBA_ptr =3D HBA_ptr->next) {
+		if (HBA_ptr->host_queue !=3D NULL) {
+			break;
+		}
+	}
+	if (!HBA_ptr)
+		goto stop_map_output;
+=09
+	pos =3D begin;
+
+	for (HBA_ptr =3D scsi_hostlist; HBA_ptr; HBA_ptr =3D HBA_ptr->next) {
+		for (scd =3D HBA_ptr->host_queue; scd; scd =3D scd->next) {
+			proc_print_scsimap(scd, buffer, &size, len, sg_t);
+			len +=3D size;
+			pos =3D begin + len;
+
+			if (pos < offset) {
+				len =3D 0;
+				begin =3D pos;
+			}
+			if (pos > offset + length)
+				goto stop_map_output;
+		}
+	}
+
+ stop_map_output:
+	*start =3D buffer + (offset - begin);	/* Start of wanted data */
+	len -=3D (offset - begin);	/* Start slop */
+	if (len > length)
+		len =3D length;	/* Ending slop */
+	return (len);
+}
+
 static int scsi_proc_info(char *buffer, char **start, off_t offset, in=
t length)
 {
 	Scsi_Device *scd;
@@ -2505,6 +2571,7 @@
 static int __init init_scsi(void)
 {
 	struct proc_dir_entry *generic;
+	struct proc_dir_entry *map;
 	int i;
=20
 	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");
@@ -2541,6 +2608,13 @@
 		return -ENOMEM;
 	}
 	generic->write_proc =3D proc_scsi_gen_write;
+=09
+	map =3D create_proc_info_entry ("scsi/map", 0, 0, scsi_proc_map);
+	if (!map) {
+		printk (KERN_ERR "cannot init /proc/scsi/map\n");
+		remove_proc_entry("scsi", 0);
+		return -ENOMEM;
+	}
 #endif
=20
         scsi_devfs_handle =3D devfs_mk_dir (NULL, "scsi", NULL);
@@ -2571,6 +2645,7 @@
=20
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
+	remove_proc_entry ("scsi/map", 0);
 	remove_proc_entry ("scsi/scsi", 0);
 	remove_proc_entry ("scsi", 0);
 #endif
diff -uNr linux-2.5.23-dj2/drivers/scsi/scsi.h linux-2.5.23-dj2-scsimap=
/drivers/scsi/scsi.h
--- linux-2.5.23-dj2/drivers/scsi/scsi.h	Thu Jun 20 01:44:48 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/scsi.h	Thu Jun 20 02:03:21 20=
02
@@ -523,6 +523,8 @@
  * Prototypes for functions in scsi_proc.c
  */
 extern void proc_print_scsidevice(Scsi_Device *, char *, int *, int);
+extern void proc_print_scsimap(Scsi_Device *, char *, int *, int,=20
+			       struct Scsi_Device_Template *);
 extern struct proc_dir_entry *proc_scsi;
=20
 /*
diff -uNr linux-2.5.23-dj2/drivers/scsi/scsi_proc.c linux-2.5.23-dj2-sc=
simap/drivers/scsi/scsi_proc.c
--- linux-2.5.23-dj2/drivers/scsi/scsi_proc.c	Wed Jun 19 04:11:47 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/scsi_proc.c	Thu Jun 20 02:03:=
21 2002
@@ -300,29 +301,54 @@
 	return;
 }
=20
+
+void proc_print_scsimap(Scsi_Device *scd, char *buffer, int *size, int=
 len,
+			struct Scsi_Device_Template *sg_t)
+{
+	int y, err;
+	char nm[16];
+	kdev_t kdev;=20
+	int att =3D scd->attached;
+	struct Scsi_Device_Template *sd_t =3D scsi_devicelist;
+
+	y =3D sprintf(buffer + len,
+	     "%i,%i,%02i,%02i\t0x%02x\t%i",
+		    scd->host->host_no, scd->channel, scd->id, scd->lun,
+		    scd->type, scd->online);
+	if (sg_t && sg_t->find_kdev && !(sg_t->find_kdev(scd, nm, &kdev))) {
+		y +=3D sprintf(buffer + len + y,
+			     "\t%s\tc:%02x:%02x",
+			     nm, major(kdev), minor(kdev));
+		--att;
+	} else {
+		y +=3D sprintf(buffer + len + y,
+			     "\tsg?\tc:NN:NN");
+	}
+	while (att && sd_t) {
+		if (sd_t->scsi_type !=3D 0xff && sd_t->find_kdev) {
+			err =3D sd_t->find_kdev(scd, nm, &kdev);
+			if (!err) {
+				y +=3D sprintf(buffer + len + y,
+					     "\t%s\t%c:%02x:%02x",
+					     nm, (sd_t->blk? 'b': 'c'),
+					     major(kdev), minor(kdev));
+				--att;
+			}
+		}
+		sd_t =3D sd_t->next;
+	}
+
+	y +=3D sprintf(buffer + len + y, "\n");
+	*size =3D y;
+}
+
 #else				/* if !CONFIG_PROC_FS */
=20
 void proc_print_scsidevice(Scsi_Device * scd, char *buffer, int *size,=
 int len)
 {
 }
+void proc_print_scsimap(Scsi_Device *scd, char *buffer, int *size, int=
 len)
+{
+}
=20
 #endif				/* CONFIG_PROC_FS */
-
-/*
- * Overrides for Emacs so that we get a uniform tabbing style.
- * Emacs will notice this stuff at the end of the file and automatical=
ly
- * adjust the settings for this buffer only.  This must remain at the =
end
- * of the file.
- * -------------------------------------------------------------------=
--------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
diff -uNr linux-2.5.23-dj2/drivers/scsi/sd.c linux-2.5.23-dj2-scsimap/d=
rivers/scsi/sd.c
--- linux-2.5.23-dj2/drivers/scsi/sd.c	Thu Jun 20 01:44:48 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/sd.c	Thu Jun 20 02:03:21 2002
@@ -103,6 +103,7 @@
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
 static int sd_init_command(Scsi_Cmnd *);
+static int sd_find_kdev(Scsi_Device*, char*, kdev_t*);
=20
 static struct Scsi_Device_Template sd_template =3D {
 	module:THIS_MODULE,
@@ -122,6 +123,7 @@
 	attach:sd_attach,
 	detach:sd_detach,
 	init_command:sd_init_command,
+	find_kdev:sd_find_kdev,
 };
=20
 static void sd_rw_intr(Scsi_Cmnd * SCpnt);
@@ -285,6 +287,24 @@
 	}
 }
=20
+static int sd_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	Scsi_Disk *sdkp;
+	int dsk_nr;
+
+	if (sdp && (sdp->type =3D=3D TYPE_DISK || sdp->type =3D=3D TYPE_MOD))=
 {
+		for (dsk_nr =3D 0; dsk_nr < sd_template.dev_max; ++dsk_nr) {
+			sdkp =3D sd_dsk_arr[dsk_nr];
+			if (sdkp->device =3D=3D sdp) {
+				sd_dskname(dsk_nr, nm);
+				*dev =3D MKDEV_SD(dsk_nr);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 /**
  *	sd_find_queue - yields queue associated with device
  *	@dev: kernel device descriptor (kdev_t)
diff -uNr linux-2.5.23-dj2/drivers/scsi/sg.c linux-2.5.23-dj2-scsimap/d=
rivers/scsi/sg.c
--- linux-2.5.23-dj2/drivers/scsi/sg.c	Wed Jun 19 04:11:54 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/sg.c	Thu Jun 20 02:03:21 2002
@@ -111,6 +111,7 @@
 static void sg_finish(void);
 static int sg_detect(Scsi_Device *);
 static void sg_detach(Scsi_Device *);
+static int sg_find_kdev(Scsi_Device *, char*, kdev_t*);
=20
 static Scsi_Request * dummy_cmdp;	/* only used for sizeof */
=20
@@ -120,6 +121,7 @@
 static struct Scsi_Device_Template sg_template =3D
 {
       module:THIS_MODULE,
+      name:"generic",
       tag:"sg",
       scsi_type:0xff,
       major:SCSI_GENERIC_MAJOR,
@@ -127,7 +129,8 @@
       init:sg_init,
       finish:sg_finish,
       attach:sg_attach,
-      detach:sg_detach
+      detach:sg_detach,
+      find_kdev:sg_find_kdev
 };
=20
=20
@@ -2632,6 +2635,37 @@
 }
=20
 #ifdef CONFIG_PROC_FS
+static int sg_find_kdev(Scsi_Device* sdp, char *nm, kdev_t *dev)
+{
+    unsigned long iflags;
+    int err =3D 1;=20
+
+    if (sdp && sg_dev_arr) {
+	int k;
+	read_lock_irqsave(&sg_dev_arr_lock, iflags);
+	for (k =3D 0; k < sg_template.dev_max; ++k) {
+	    if (sg_dev_arr[k] && sg_dev_arr[k]->device =3D=3D sdp) {
+		sprintf (nm, "sg%i", k);
+	        *dev =3D sg_dev_arr[k]->i_rdev;
+		err =3D 0;
+		break;
+	    }
+	}
+	read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+    }
+    return err;
+}
+#else
+/* Not needed without procfs support */
+static int sg_find_kdev(Scsi_Device* sdp, char *nm, kdev_t *dev)
+{
+    *nm =3D 0;
+    *kdev =3D NODEV;
+    return 1;
+}
+#endif
+
+#ifdef CONFIG_PROC_FS
=20
 static struct proc_dir_entry * sg_proc_sgp =3D NULL;
=20
diff -uNr linux-2.5.23-dj2/drivers/scsi/sr.c linux-2.5.23-dj2-scsimap/d=
rivers/scsi/sr.c
--- linux-2.5.23-dj2/drivers/scsi/sr.c	Wed Jun 19 04:11:50 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/sr.c	Thu Jun 20 02:03:21 2002
@@ -71,6 +71,8 @@
=20
 static int sr_init_command(Scsi_Cmnd *);
=20
+static int sr_find_kdev(Scsi_Device*, char*, kdev_t*);
+
 static struct Scsi_Device_Template sr_template =3D
 {
 	module:THIS_MODULE,
@@ -84,7 +86,8 @@
 	finish:sr_finish,
 	attach:sr_attach,
 	detach:sr_detach,
-	init_command:sr_init_command
+	init_command:sr_init_command,
+	find_kdev:sr_find_kdev,
 };
=20
 Scsi_CD *scsi_CDs;
@@ -471,6 +474,23 @@
 	return 0;
 }
=20
+static int sr_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	Scsi_CD *srp;
+	int i;
+=09
+	if (sdp && (sdp->type =3D=3D TYPE_ROM || sdp->type =3D=3D TYPE_WORM))=
 {
+		for (srp =3D scsi_CDs, i =3D 0; i < sr_template.dev_max;
+		     ++i, ++srp) {
+			if (srp->device =3D=3D sdp) {
+				sprintf(nm, "sr%i", i);
+				*dev =3D mk_kdev(SCSI_CDROM_MAJOR,i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
=20
 void get_sectorsize(int i)
 {
diff -uNr linux-2.5.23-dj2/drivers/scsi/st.c linux-2.5.23-dj2-scsimap/d=
rivers/scsi/st.c
--- linux-2.5.23-dj2/drivers/scsi/st.c	Wed Jun 19 04:11:56 2002
+++ linux-2.5.23-dj2-scsimap/drivers/scsi/st.c	Thu Jun 20 02:03:21 2002
@@ -148,6 +148,7 @@
 static int st_attach(Scsi_Device *);
 static int st_detect(Scsi_Device *);
 static void st_detach(Scsi_Device *);
+static int st_find_kdev(Scsi_Device*, char*, kdev_t*);
=20
 static struct Scsi_Device_Template st_template =3D {
 	module:		THIS_MODULE,
@@ -157,7 +158,8 @@
 	major:		SCSI_TAPE_MAJOR,=20
 	detect:		st_detect,=20
 	attach:		st_attach,=20
-	detach:		st_detach
+	detach:		st_detach,
+	find_kdev:	st_find_kdev
 };
=20
 static int st_compression(Scsi_Tape *, int);
@@ -3760,6 +3762,24 @@
 	return;
 }
=20
+static int st_find_kdev(Scsi_Device * sdp, char* nm, kdev_t *dev)
+{
+	int i;
+	Scsi_Tape *stp;
+
+	if (sdp && sdp->type =3D=3D TYPE_TAPE && !st_incompatible(sdp)) {
+		for (stp =3D scsi_tapes[0], i =3D 0; i < st_template.dev_max;
+		     stp =3D scsi_tapes[++i]) {
+			if (stp && stp->device =3D=3D sdp) {
+				sprintf(nm, "st%i", i);
+				*dev =3D mk_kdev(SCSI_TAPE_MAJOR, i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 static int __init init_st(void)
 {
 	validate_options();


--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL=
]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL=
]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE=
]
 (See mail header or public key servers for PGP2 and GPG public keys.)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
