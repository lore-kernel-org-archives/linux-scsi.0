From: Robert Sertic <robert@philosys.de>
Subject: Re: [PATCH][RFC] ST Tape assignement
Date: Wed, 24 Jul 2002 16:30:34 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.21.0207241623140.990-100000@ftp.philosys.de>
References: <Pine.LNX.4.21.0207191901010.7412-200000@ftp.philosys.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.21.0207191901010.7412-200000@ftp.philosys.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert.Sertic@gmx.net




Hi Everybody,

i rewrote my patch so that is applyable to a 
2.5.27 Kernel. Do you remember???

With this patch you can make an assingement between
a certain Tape and a device file, so for example
Tape on ScsiHost 1 Channel 0 ID 5 Lun0 should be 
st31.

Feel free to try or comment it.

Greetings,
	Robert

p.s. This is my first try to get something into the Linux-Kernel, so 
     i would really appreciate at least commenting the patch;)

--Start--Patch--




diff -u linux/drivers/scsi/README.st
linux-2.5.27.changed/drivers/scsi/README.st
--- linux/drivers/scsi/README.st        Sat Jul 20 21:11:10 2002
+++ linux-2.5.27.changed/drivers/scsi/README.st Wed Jul 24 17:12:41 2002
@@ -168,11 +168,21 @@
 The buffer size, write threshold, and the maximum number of allocated
buffers
 are configurable when the driver is loaded as a module. The keywords are:

-buffer_kbs=xxx             the buffer size in kilobytes is set to xxx
-write_threshold_kbs=xxx    the write threshold in kilobytes set to xxx
-max_buffers=xxx            the maximum number of tape buffer set to xxx
-max_sg_segs=xxx                   the maximum number of scatter/gather
-                          segments
+buffer_kbs=xxx                         the buffer size in kilobytes is
set to xxx
+write_threshold_kbs=xxx                the write threshold in kilobytes
set to xxx
+max_buffers=xxx                        the maximum number of tape buffer
set to xxx
+max_sg_segs=xxx                                the maximum number of
scatter/gather
+                                       segments
+
+tape_ordering="a-b-c-d-e[;a-b-c-d-e]"   the presetting of the device to a
+                                        certain tape where
+
+                                        a = scsi host
+                                        b = scsi channel
+                                        c = scsi id
+                                        d = scsi lun
+                                        e = wanted device number
+

 Note that if the buffer size is changed but the write threshold is not
 set, the write threshold is set to the new buffer size - 2 kB.
Common subdirectories: linux/drivers/scsi/aic7xxx and
linux-2.5.27.changed/drivers/scsi/aic7xxx
Common subdirectories: linux/drivers/scsi/aic7xxx_old and
linux-2.5.27.changed/drivers/scsi/aic7xxx_old
Common subdirectories: linux/drivers/scsi/dpt and
linux-2.5.27.changed/drivers/scsi/dpt
Common subdirectories: linux/drivers/scsi/pcmcia and
linux-2.5.27.changed/drivers/scsi/pcmcia
diff -u linux/drivers/scsi/st.c linux-2.5.27.changed/drivers/scsi/st.c
--- linux/drivers/scsi/st.c     Sat Jul 20 21:11:25 2002
+++ linux-2.5.27.changed/drivers/scsi/st.c      Wed Jul 24 17:11:13 2002
@@ -40,7 +40,7 @@

 /* The driver prints some debugging information on the console if DEBUG
    is defined and non-zero. */
-#define DEBUG 0
+#define DEBUG 1

 #if DEBUG
 /* The message level for the debug messages is currently set to
KERN_NOTICE
@@ -70,6 +70,7 @@
 static int buffer_kbs;
 static int write_threshold_kbs;
 static int max_sg_segs;
+static char *tape_ordering = NULL;

 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI Tape Driver");
@@ -81,7 +82,8 @@
 MODULE_PARM_DESC(write_threshold_kbs, "Asynchronous write threshold
(KB; 30)");
 MODULE_PARM(max_sg_segs, "i");
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments
to use (32)");
-
+MODULE_PARM(tape_ordering, "s");
+MODULE_PARM_DESC(tape_ordering, "Ordering of the scsi adresses to the
device numbers");
 #ifndef MODULE
 static struct st_dev_parm {
        char *name;
@@ -95,6 +97,9 @@
        },
        {
                "max_sg_segs", &max_sg_segs
+       },
+        {
+                "tape_ordering", NULL
        }
 };
 #endif
@@ -167,6 +172,8 @@

 static int st_int_ioctl(Scsi_Tape *, unsigned int, unsigned long);

+static ST_table st_device_entry[ST_MAX_TAPES];
+
 ^L
 #include "osst_detect.h"
 #ifndef SIGS_FROM_OSST
@@ -308,7 +315,7 @@

        st_nbr = TAPE_NR(SCpnt->request->rq_dev);
        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[st_nbr];
+       STp = scsi_tapes[st_device_entry[st_nbr].index];
        read_unlock(&st_dev_arr_lock);
        if ((STp->buffer)->writing &&
            (SCpnt->sense_buffer[0] & 0x70) == 0x70 &&
@@ -912,7 +919,8 @@

        write_lock(&st_dev_arr_lock);
        if (dev >= st_template.dev_max || scsi_tapes == NULL ||
-           ((STp = scsi_tapes[dev]) == NULL)) {
+            (st_device_entry[dev].state != ENTRY_USED) ||
+           ((STp = scsi_tapes[st_device_entry[dev].index]) == NULL)) {
                write_unlock(&st_dev_arr_lock);
                return (-ENXIO);
        }
@@ -995,7 +1003,7 @@

        dev = TAPE_NR(devt);
        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[dev];
+       STp = scsi_tapes[st_device_entry[dev].index];
        read_unlock(&st_dev_arr_lock);
        STm = &(STp->modes[STp->current_mode]);
        STps = &(STp->ps[STp->partition]);
@@ -1107,7 +1115,7 @@

        dev = TAPE_NR(devt);
        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[dev];
+       STp = scsi_tapes[st_device_entry[dev].index];
        read_unlock(&st_dev_arr_lock);

        if (STp->door_locked == ST_LOCKED_AUTO)
@@ -1237,7 +1245,7 @@
        int dev = TAPE_NR(inode->i_rdev);

        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[dev];
+       STp = scsi_tapes[st_device_entry[dev].index];
        read_unlock(&st_dev_arr_lock);

        if (down_interruptible(&STp->lock))
@@ -1690,7 +1698,7 @@
        int dev = TAPE_NR(inode->i_rdev);

        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[dev];
+       STp = scsi_tapes[st_device_entry[dev].index];
        read_unlock(&st_dev_arr_lock);

        if (down_interruptible(&STp->lock))
@@ -2982,7 +2990,7 @@
        int dev = TAPE_NR(inode->i_rdev);

        read_lock(&st_dev_arr_lock);
-       STp = scsi_tapes[dev];
+       STp = scsi_tapes[st_device_entry[dev].index];
        read_unlock(&st_dev_arr_lock);

        if (down_interruptible(&STp->lock))
@@ -3470,6 +3478,83 @@
        return 0;
 }

+/* Check if preset tape-ordering is used, if not just increment the
+   device numbers as usually */
+
+int check_table(ST_adress tape)
+{
+       int device;
+       int busy = -1;
+
+       for (device = 0; device < ST_MAX_TAPES; device++) {
+               if (busy < 0 &&
+                   st_device_entry[device].state == ENTRY_EMPTY)
+                       busy = device;
+
+               if ( (st_device_entry[device].state == ENTRY_INIT) && 
+                    (tape.cmp == st_device_entry[device].adress.cmp)) {
+                       st_device_entry[device].state= ENTRY_USED;
+                       return device;
+                }
+       }
+       st_device_entry[busy].adress = tape;
+       st_device_entry[busy].state = ENTRY_USED;
+
+       return busy;
+}
+
+
+/* Initialize the preset tape-ordering array */
+void init_table(void)
+{
+       char *begin = tape_ordering;
+       char *next, *end, *white;
+       int i, tmp = 1, len;
+       ST_adress entry;
+
+       if (!(end = strstr(tape_ordering, ",")))
+               len = strnlen (tape_ordering, 375);
+       else
+               len = end - begin;
+
+       do {
+               if (!(end = (strstr(begin, ";")))) {
+                       if (begin == tape_ordering)
+                               break;
+                       else
+                               end = tape_ordering + len;
+               }
+
+               for (white = begin; white < end; white++) {
+                       if (((*white  < '0') || (*white   > '9')) &&
+                            (*white != '-'))  {
+                               tmp = 0;
+                               break;
+                       }
+               }
+               i = 0;
+               if (tmp) {
+                       do {
+                               if (!(next = (strstr(begin, "-"))))
+                                       next = end;
+                               tmp = simple_strtoul(begin, &next, 0);
+                               if ( i <  4 )
+                                       entry.val[i++] = (unsigned
char) tmp;
+
+                               begin = next + 1;
+                       } while ((begin < end) && (i < 5) );
+
+                       if ( (tmp < ST_MAX_TAPES) &&
+                            (st_device_entry[tmp].state ==
ENTRY_EMPTY)) {
+                               st_device_entry[tmp].adress = entry;
+                               st_device_entry[tmp].state  = ENTRY_INIT;
+                       }
+               }
+               tmp = 1;
+               begin = end + 1;
+       } while (begin < (tape_ordering + len));
+}
+

 /* Validate the options from command line or module parameters */
 static void validate_options(void)
@@ -3487,6 +3572,8 @@
        }
        if (max_sg_segs >= ST_FIRST_SG)
                st_max_sg_segs = max_sg_segs;
+       if (tape_ordering)
+               init_table();
 }

 #ifndef MODULE
@@ -3508,7 +3595,10 @@
                                len = strlen(parms[i].name);
                                if (!strncmp(stp, parms[i].name, len) &&
                                    (*(stp + len) == ':' || *(stp +
len) == '=')) {
-                                       *parms[i].val =
+                                       if (i == 4) {
+                                               tape_ordering = stp + len
+ 1;
+                                       } else
+                                               *parms[i].val =
                                                 simple_strtoul(stp + len
+ 1, NULL, 0);
                                        break;
                                }
@@ -3576,6 +3666,7 @@
        ST_buffer *buffer;
        int i, mode, dev_num;
        char *stp;
+       ST_adress tape;

        if (SDp->type != TYPE_TAPE)
                return 1;
@@ -3649,7 +3740,12 @@
        }
        memset(tpnt, 0, sizeof(Scsi_Tape));
        scsi_tapes[i] = tpnt;
-       dev_num = i;
+       tape.val[ST_HOST]    = (unsigned char ) SDp->host->host_no;
+       tape.val[ST_CHANNEL] = (unsigned char ) SDp->channel;
+       tape.val[ST_ID]      = (unsigned char ) SDp->id;
+       tape.val[ST_LUN]     = (unsigned char ) SDp->lun;
+       dev_num = check_table(tape);
+       st_device_entry[dev_num].index = i;

        for (mode = 0; mode < ST_NBR_MODES; ++mode) {
            char name[8];
@@ -3664,14 +3760,14 @@
            tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
            tpnt->driverfs_dev_r[mode].bus = &scsi_driverfs_bus_type;
            tpnt->driverfs_dev_r[mode].driver_data =
-                       (void *)__mkdev(MAJOR_NR, i + (mode << 5));
+                       (void *)__mkdev(MAJOR_NR, dev_num + (mode << 5));
            device_register(&tpnt->driverfs_dev_r[mode]);
            device_create_file(&tpnt->driverfs_dev_r[mode],
                               &st_device_type_file);
            device_create_file(&tpnt->driverfs_dev_r[mode],
&st_device_kdev_file);
            tpnt->de_r[mode] =
                devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-                               MAJOR_NR, i + (mode << 5),
+                               MAJOR_NR, dev_num + (mode << 5),
                                S_IFCHR | S_IRUGO | S_IWUGO,
                                &st_fops, NULL);
            /*  No-rewind entry  */
@@ -3683,7 +3779,7 @@
            tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
            tpnt->driverfs_dev_n[mode].bus = &scsi_driverfs_bus_type;
            tpnt->driverfs_dev_n[mode].driver_data =
-                       (void *)__mkdev(MAJOR_NR, i + (mode << 5) + 128);
+                       (void *)__mkdev(MAJOR_NR, dev_num + (mode << 5) +
128);
            device_register(&tpnt->driverfs_dev_n[mode]);
            device_create_file(&tpnt->driverfs_dev_n[mode],
                        &st_device_type_file);
@@ -3691,7 +3787,7 @@
                        &st_device_kdev_file);
            tpnt->de_n[mode] =
                devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-                               MAJOR_NR, i + (mode << 5) + 128,
+                               MAJOR_NR, dev_num + (mode << 5) + 128,
                                S_IFCHR | S_IRUGO | S_IWUGO,
                                &st_fops, NULL);
        }
@@ -3706,7 +3802,7 @@
        tpnt->buffer = buffer;

         tpnt->inited = 0;
-       tpnt->devt = mk_kdev(SCSI_TAPE_MAJOR, i);
+       tpnt->devt = mk_kdev(SCSI_TAPE_MAJOR, dev_num);
        tpnt->dirty = 0;
        tpnt->in_use = 0;
        tpnt->drv_buffer = 1;   /* Try buffering if no mode sense */
@@ -3782,7 +3878,7 @@

        write_lock(&st_dev_arr_lock);
        for (i = 0; i < st_template.dev_max; i++) {
-               tpnt = scsi_tapes[i];
+               tpnt = scsi_tapes[st_device_entry[i].index];
                if (tpnt != NULL && tpnt->device == SDp) {
                        tpnt->device = NULL;
                        for (mode = 0; mode < ST_NBR_MODES; ++mode) {
@@ -3807,7 +3903,9 @@
                                kfree(tpnt->buffer);
                        }
                        kfree(tpnt);
-                       scsi_tapes[i] = 0;
+                       scsi_tapes[st_device_entry[i].index] = 0;
+                       st_device_entry[i].index = 0;
+                       st_device_entry[i].state = ENTRY_EMPTY;
                        SDp->attached--;
                        st_template.nr_dev--;
                        st_template.dev_noticed--;
diff -u linux/drivers/scsi/st.h linux-2.5.27.changed/drivers/scsi/st.h
--- linux/drivers/scsi/st.h     Sat Jul 20 21:11:11 2002
+++ linux-2.5.27.changed/drivers/scsi/st.h      Wed Jul 24 17:11:29 2002
@@ -132,6 +132,28 @@
 #endif
 } Scsi_Tape;

+typedef union {
+       int cmp;
+       unsigned char val[4];
+} ST_adress;
+
+typedef struct {
+       int state;
+       int index;
+       ST_adress adress;
+} ST_table;
+
+/* Values for adress array */
+#define ST_HOST         0
+#define ST_CHANNEL      1
+#define ST_ID           2
+#define ST_LUN          3
+
+/* Values of busy state */
+#define ENTRY_EMPTY     0
+#define ENTRY_INIT      1
+#define ENTRY_USED      2
+
 /* Bit masks for use_pf */
 #define USE_PF      1
 #define PF_TESTED   2
Common subdirectories: linux/drivers/scsi/sym53c8xx_2 and
linux-2.5.27.changed/drivers/scsi/sym53c8xx_2


