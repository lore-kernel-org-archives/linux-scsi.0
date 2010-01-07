From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH,RESEND] scsi: use __uX types for headers exported to user
 space
Date: Thu, 07 Jan 2010 16:59:17 +0200
Message-ID: <4B45F6C5.2040101@panasas.com>
References: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk> <1262875229.3025.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:18614 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752430Ab0AGO7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2010 09:59:22 -0500
In-Reply-To: <1262875229.3025.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, james.smart@emulex.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On 01/07/2010 04:40 PM, James Bottomley wrote:
> On Thu, 2010-01-07 at 15:20 +0100, Peter Korsgaard wrote:
>> Commit 9e4f5e29 (FC Pass Thru support) exported a number of header f=
iles
>> in include/scsi to user space, but didn't change the uX types to the
>> userspace-compatible __uX types. Without that you'll get compile err=
ors
>> when including them - E.G.:
>>
>> /tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-li=
st
>> before =E2=80=98u8=E2=80=99
>>
>> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
>> ---
>>  No feedback since 27/11, resending.
>=20
> OK, so to summarise the list discussion, the current status is that t=
he
> SCSI exports are irrelevant because glibc currently ignores the
> include/scsi namespace provided by the kernel.  So, we have three
> options:
>=20
>      1. Bring our exports up to the point where they can replace glib=
c's
>         include/scsi/scsi.h and the rest.  This requires a line by li=
ne
>         analysis of what's in glibc and an update to our include to
>         provide or remove as necessary.  After this is done we can tr=
y
>         to persuade the glibc people to turn over the include/scsi
>         namespace to us.
>      2. Kill the kbuild exports and make everyone go via the glibc tr=
ee
>         (current state).
>      3. Move the kernel include/scsi to a more conventional namespace
>         (like inside include/linux) so glibc will pick it up.
>=20
> So far we've had people supporting all three.  I'm inclined to say th=
at
> I'd favour 1, but the first patch trying to do any of them would be t=
he
> best starting ground for a discussion.
>=20
> James
>=20

Below is a diff of make headers_check on current scsi.h
(After my patch, see other mail in thread)
And /usr/include/scsi.h from a Fedora12 system.
Clearly this is an old version of a Linux header.

Except one minor name conflict I do not see any problems at all
It is all additions (+) to that old version.

The single existing issue is:
-#define ABORT               0x06
+#define ABORT_TASK_SET      0x06

Which is correct surly "#define ABORT" is a disastrous name space
pollution.

Boaz
---
diff -Nurp -Nurp /usr/include/scsi/scsi.h .build_x86_64/usr/include/scs=
i/scsi.h
--- /usr/include/scsi/scsi.h	2010-01-04 15:50:26.000000000 +0200
+++ .build_x86_64/usr/include/scsi/scsi.h	2010-01-07 16:47:45.943919303=
 +0200
@@ -1,30 +1,14 @@
-/* Copyright (C) 1998, 1999 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful=
,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, write to the Free
-   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-   02111-1307 USA.  */
-
 /*
  * This header file contains public constants and structures used by
  * the scsi code for linux.
+ *
+ * For documentation on the OPCODES, MESSAGES, and SENSE values,
+ * please consult the SCSI standard.
  */
-
 #ifndef _SCSI_SCSI_H
-#define _SCSI_SCSI_H	1
+#define _SCSI_SCSI_H
=20
-#include <features.h>
+#include <linux/types.h>
=20
 /*
  *      SCSI opcodes
@@ -36,6 +20,7 @@
 #define FORMAT_UNIT           0x04
 #define READ_BLOCK_LIMITS     0x05
 #define REASSIGN_BLOCKS       0x07
+#define INITIALIZE_ELEMENT_STATUS 0x07
 #define READ_6                0x08
 #define WRITE_6               0x0a
 #define SEEK_6                0x0b
@@ -60,6 +45,7 @@
 #define READ_10               0x28
 #define WRITE_10              0x2a
 #define SEEK_10               0x2b
+#define POSITION_TO_ELEMENT   0x2b
 #define WRITE_VERIFY          0x2e
 #define VERIFY                0x2f
 #define SEARCH_HIGH           0x30
@@ -81,16 +67,23 @@
 #define WRITE_LONG            0x3f
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
+#define UNMAP		      0x42
 #define READ_TOC              0x43
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
+#define XDWRITEREAD_10        0x53
 #define MODE_SELECT_10        0x55
 #define RESERVE_10            0x56
 #define RELEASE_10            0x57
 #define MODE_SENSE_10         0x5a
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
+#define VARIABLE_LENGTH_CMD   0x7f
+#define REPORT_LUNS           0xa0
+#define MAINTENANCE_IN        0xa3
+#define MAINTENANCE_OUT       0xa4
 #define MOVE_MEDIUM           0xa5
+#define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
 #define WRITE_12              0xaa
 #define WRITE_VERIFY_12       0xae
@@ -100,9 +93,93 @@
 #define READ_ELEMENT_STATUS   0xb8
 #define SEND_VOLUME_TAG       0xb6
 #define WRITE_LONG_2          0xea
+#define READ_16               0x88
+#define WRITE_16              0x8a
+#define VERIFY_16	      0x8f
+#define WRITE_SAME_16	      0x93
+#define SERVICE_ACTION_IN     0x9e
+/* values for service action in */
+#define	SAI_READ_CAPACITY_16  0x10
+#define SAI_GET_LBA_STATUS    0x12
+/* values for maintenance in */
+#define MI_REPORT_TARGET_PGS  0x0a
+/* values for maintenance out */
+#define MO_SET_TARGET_PGS     0x0a
+/* values for variable length command */
+#define READ_32		      0x09
+#define WRITE_32	      0x0b
+#define WRITE_SAME_32	      0x0d
+
+/* Values for T10/04-262r7 */
+#define	ATA_16		      0x85	/* 16-byte pass-thru */
+#define	ATA_12		      0xa1	/* 12-byte pass-thru */
+
+/*
+ *	SCSI command lengths
+ */
+
+#define SCSI_MAX_VARLEN_CDB_SIZE 260
+
+/* defined in T10 SCSI Primary Commands-2 (SPC2) */
+struct scsi_varlen_cdb_hdr {
+	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
+	__be16 service_action;
+	/* service specific data follows */
+};
+
+static __inline__ unsigned
+scsi_varlen_cdb_length(const void *hdr)
+{
+	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8=
;
+}
+
+/*
+ *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
+ *  T10/1561-D Revision 4 Draft dated 7th November 2002.
+ */
+#define SAM_STAT_GOOD            0x00
+#define SAM_STAT_CHECK_CONDITION 0x02
+#define SAM_STAT_CONDITION_MET   0x04
+#define SAM_STAT_BUSY            0x08
+#define SAM_STAT_INTERMEDIATE    0x10
+#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
+#define SAM_STAT_RESERVATION_CONFLICT 0x18
+#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
+#define SAM_STAT_TASK_SET_FULL   0x28
+#define SAM_STAT_ACA_ACTIVE      0x30
+#define SAM_STAT_TASK_ABORTED    0x40
+
+/** scsi_status_is_good - check the status return.
+ *
+ * @status: the status passed up from the driver (including host and
+ *          driver components)
+ *
+ * This returns true for known good conditions that may be treated as
+ * command completed normally
+ */
+static __inline__ int scsi_status_is_good(int status)
+{
+	/*
+	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
+	 * significant in SCSI-3.  For now, we follow the SCSI-2
+	 * behaviour and ignore reserved bits.
+	 */
+	status &=3D 0xfe;
+	return ((status =3D=3D SAM_STAT_GOOD) ||
+		(status =3D=3D SAM_STAT_INTERMEDIATE) ||
+		(status =3D=3D SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
+		/* FIXME: this is obsolete in SAM-3 */
+		(status =3D=3D SAM_STAT_COMMAND_TERMINATED));
+}
=20
 /*
- *  Status codes
+ *  Status codes. These are deprecated as they are shifted 1 bit right
+ *  from those found in the SCSI standards. This causes confusion for
+ *  applications that are ported to several OSes. Prefer SAM Status co=
des
+ *  above.
  */
=20
 #define GOOD                 0x00
@@ -114,8 +191,10 @@
 #define RESERVATION_CONFLICT 0x0c
 #define COMMAND_TERMINATED   0x11
 #define QUEUE_FULL           0x14
+#define ACA_ACTIVE           0x18
+#define TASK_ABORTED         0x20
=20
-#define STATUS_MASK          0x3e
+#define STATUS_MASK          0xfe
=20
 /*
  *  SENSE KEYS
@@ -138,43 +217,79 @@
=20
 /*
  *  DEVICE TYPES
+ *  Please keep them in 0x%02x format for $MODALIAS to work
  */
=20
 #define TYPE_DISK           0x00
 #define TYPE_TAPE           0x01
+#define TYPE_PRINTER        0x02
 #define TYPE_PROCESSOR      0x03    /* HP scanners use this */
 #define TYPE_WORM           0x04    /* Treated as ROM by our system */
 #define TYPE_ROM            0x05
 #define TYPE_SCANNER        0x06
-#define TYPE_MOD            0x07    /* Magneto-optical disk -
+#define TYPE_MOD            0x07    /* Magneto-optical disk -=20
 				     * - treated as TYPE_DISK */
 #define TYPE_MEDIUM_CHANGER 0x08
-#define TYPE_ENCLOSURE	    0x0d    /* Enclosure Services Device */
+#define TYPE_COMM           0x09    /* Communications device */
+#define TYPE_RAID           0x0c
+#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
+#define TYPE_RBC	    0x0e
+#define TYPE_OSD            0x11
 #define TYPE_NO_LUN         0x7f
=20
+/* SCSI protocols; these are taken from SPC-3 section 7.5 */
+enum scsi_protocol {
+	SCSI_PROTOCOL_FCP =3D 0,	/* Fibre Channel */
+	SCSI_PROTOCOL_SPI =3D 1,	/* parallel SCSI */
+	SCSI_PROTOCOL_SSA =3D 2,	/* Serial Storage Architecture - Obsolete */
+	SCSI_PROTOCOL_SBP =3D 3,	/* firewire */
+	SCSI_PROTOCOL_SRP =3D 4,	/* Infiniband RDMA */
+	SCSI_PROTOCOL_ISCSI =3D 5,
+	SCSI_PROTOCOL_SAS =3D 6,
+	SCSI_PROTOCOL_ADT =3D 7,	/* Media Changers */
+	SCSI_PROTOCOL_ATA =3D 8,
+	SCSI_PROTOCOL_UNSPEC =3D 0xf, /* No specific protocol */
+};
+
 /*
  * standard mode-select header prepended to all mode-select commands
- *
- * moved here from cdrom.h -- kraxel
  */
=20
-struct ccs_modesel_head
-  {
-    unsigned char _r1;			/* reserved.  */
-    unsigned char medium;		/* device-specific medium type.  */
-    unsigned char _r2;			/* reserved.  */
-    unsigned char block_desc_length;	/* block descriptor length.  */
-    unsigned char density;		/* device-specific density code.  */
-    unsigned char number_blocks_hi;	/* number of blocks in this block
-					   desc.  */
-    unsigned char number_blocks_med;
-    unsigned char number_blocks_lo;
-    unsigned char _r3;
-    unsigned char block_length_hi;	/* block length for blocks in this
-					   desc.  */
-    unsigned char block_length_med;
-    unsigned char block_length_lo;
-  };
+struct ccs_modesel_head {
+	__u8 _r1;			/* reserved */
+	__u8 medium;		/* device-specific medium type */
+	__u8 _r2;			/* reserved */
+	__u8 block_desc_length;	/* block descriptor length */
+	__u8 density;		/* device-specific density code */
+	__u8 number_blocks_hi;	/* number of blocks in this block desc */
+	__u8 number_blocks_med;
+	__u8 number_blocks_lo;
+	__u8 _r3;
+	__u8 block_length_hi;	/* block length for blocks in this desc */
+	__u8 block_length_med;
+	__u8 block_length_lo;
+};
+
+/*
+ * ScsiLun: 8 byte LUN.
+ */
+struct scsi_lun {
+	__u8 scsi_lun[8];
+};
+
+/*
+ * The Well Known LUNS (SAM-3) in our int representation of a LUN
+ */
+#define SCSI_W_LUN_BASE 0xc100
+#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
+#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
+#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
+
+static __inline__ int scsi_is_wlun(unsigned int lun)
+{
+	return (lun & 0xff00) =3D=3D SCSI_W_LUN_BASE;
+}
+
=20
 /*
  *  MESSAGE CODES
@@ -186,41 +301,179 @@ struct ccs_modesel_head
 #define     EXTENDED_SDTR                   0x01
 #define     EXTENDED_EXTENDED_IDENTIFY      0x02    /* SCSI-I only */
 #define     EXTENDED_WDTR                   0x03
+#define     EXTENDED_PPR                    0x04
+#define     EXTENDED_MODIFY_BIDI_DATA_PTR   0x05
 #define SAVE_POINTERS       0x02
 #define RESTORE_POINTERS    0x03
 #define DISCONNECT          0x04
 #define INITIATOR_ERROR     0x05
-#define ABORT               0x06
+#define ABORT_TASK_SET      0x06
 #define MESSAGE_REJECT      0x07
 #define NOP                 0x08
 #define MSG_PARITY_ERROR    0x09
 #define LINKED_CMD_COMPLETE 0x0a
 #define LINKED_FLG_CMD_COMPLETE 0x0b
-#define BUS_DEVICE_RESET    0x0c
-
+#define TARGET_RESET        0x0c
+#define ABORT_TASK          0x0d
+#define CLEAR_TASK_SET      0x0e
 #define INITIATE_RECOVERY   0x0f            /* SCSI-II only */
 #define RELEASE_RECOVERY    0x10            /* SCSI-II only */
-
+#define CLEAR_ACA           0x16
+#define LOGICAL_UNIT_RESET  0x17
 #define SIMPLE_QUEUE_TAG    0x20
 #define HEAD_OF_QUEUE_TAG   0x21
 #define ORDERED_QUEUE_TAG   0x22
+#define IGNORE_WIDE_RESIDUE 0x23
+#define ACA                 0x24
+#define QAS_REQUEST         0x55
+
+/* Old SCSI2 names, don't use in new code */
+#define BUS_DEVICE_RESET    TARGET_RESET
+#define ABORT               ABORT_TASK_SET
+
+/*
+ * Host byte codes
+ */
+
+#define DID_OK          0x00	/* NO error                              =
  */
+#define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period=
  */
+#define DID_BUS_BUSY    0x02	/* BUS stayed busy through time out perio=
d */
+#define DID_TIME_OUT    0x03	/* TIMED OUT for other reason            =
  */
+#define DID_BAD_TARGET  0x04	/* BAD target.                           =
  */
+#define DID_ABORT       0x05	/* Told to abort for some other reason   =
  */
+#define DID_PARITY      0x06	/* Parity error                          =
  */
+#define DID_ERROR       0x07	/* Internal error                        =
  */
+#define DID_RESET       0x08	/* Reset by somebody.                    =
  */
+#define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.=
  */
+#define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer          =
  */
+#define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry=
  */
+#define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count=
  */
+#define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
+				 * without decrementing the retry count	   */
+#define DID_TRANSPORT_DISRUPTED 0x0e /* Transport error disrupted exec=
ution
+				      * and the driver blocked the port to
+				      * recover the link. Transport class will
+				      * retry or fail IO */
+#define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the =
io */
+#define DRIVER_OK       0x00	/* Driver status                         =
  */
+
+/*
+ *  These indicate the error that occurred, and what is available.
+ */
+
+#define DRIVER_BUSY         0x01
+#define DRIVER_SOFT         0x02
+#define DRIVER_MEDIA        0x03
+#define DRIVER_ERROR        0x04
+
+#define DRIVER_INVALID      0x05
+#define DRIVER_TIMEOUT      0x06
+#define DRIVER_HARD         0x07
+#define DRIVER_SENSE	    0x08
+
+/*
+ * Internal return values.
+ */
+
+#define NEEDS_RETRY     0x2001
+#define SUCCESS         0x2002
+#define FAILED          0x2003
+#define QUEUED          0x2004
+#define SOFT_ERROR      0x2005
+#define ADD_TO_MLQUEUE  0x2006
+#define TIMEOUT_ERROR   0x2007
+#define SCSI_RETURN_NOT_HANDLED   0x2008
+
+/*
+ * Midlevel queue return values.
+ */
+#define SCSI_MLQUEUE_HOST_BUSY   0x1055
+#define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
+#define SCSI_MLQUEUE_EH_RETRY    0x1057
+#define SCSI_MLQUEUE_TARGET_BUSY 0x1058
+
+/*
+ *  Use these to separate status msg and our bytes
+ *
+ *  These are set by:
+ *
+ *      status byte =3D set from target device
+ *      msg_byte    =3D return status from host adapter itself.
+ *      host_byte   =3D set by low-level driver to indicate status.
+ *      driver_byte =3D set by mid-level.
+ */
+#define status_byte(result) (((result) >> 1) & 0x7f)
+#define msg_byte(result)    (((result) >> 8) & 0xff)
+#define host_byte(result)   (((result) >> 16) & 0xff)
+#define driver_byte(result) (((result) >> 24) & 0xff)
+
+#define sense_class(sense)  (((sense) >> 4) & 0x7)
+#define sense_error(sense)  ((sense) & 0xf)
+#define sense_valid(sense)  ((sense) & 0x80);
+
+/*
+ * default timeouts
+*/
+#define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
+#define START_STOP_TIMEOUT		(60 * HZ)
+#define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
+#define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
+#define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
+
+
+#define IDENTIFY_BASE       0x80
+#define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
+		     ((can_disconnect) ?  0x40 : 0) |\
+		     ((lun) & 0x07))
+
+/*
+ *  struct scsi_device::scsi_level values. For SCSI devices other than=
 those
+ *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + =
1)
+ *  where "resp" is a byte array of the response to an INQUIRY. The sc=
si_level
+ *  variable is visible to the user via sysfs.
+ */
+
+#define SCSI_UNKNOWN    0
+#define SCSI_1          1
+#define SCSI_1_CCS      2
+#define SCSI_2          3
+#define SCSI_3          4        /* SPC */
+#define SCSI_SPC_2      5
+#define SCSI_SPC_3      6
+
+/*
+ * INQ PERIPHERAL QUALIFIERS
+ */
+#define SCSI_INQ_PQ_CON         0x00
+#define SCSI_INQ_PQ_NOT_CON     0x01
+#define SCSI_INQ_PQ_NOT_CAP     0x03
+
=20
 /*
  * Here are some scsi specific ioctl commands which are sometimes usef=
ul.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
  */
-/* These are a few other constants only used by scsi devices.  */
=20
-#define SCSI_IOCTL_GET_IDLUN 0x5382
+/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ *=
/
+#define SCSI_IOCTL_GET_IDLUN		0x5382
+
+/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} =
*/
+
+/* Used to obtain the host number of a device. */
+#define SCSI_IOCTL_PROBE_HOST		0x5385
=20
-/* Used to turn on and off tagged queuing for scsi devices.  */
+/* Used to obtain the bus number for a device */
+#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
=20
-#define SCSI_IOCTL_TAGGED_ENABLE 0x5383
-#define SCSI_IOCTL_TAGGED_DISABLE 0x5384
+/* Used to obtain the PCI location of a device */
+#define SCSI_IOCTL_GET_PCI		0x5387
=20
-/* Used to obtain the host number of a device.  */
-#define SCSI_IOCTL_PROBE_HOST 0x5385
+/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
+static __inline__ __u32 scsi_to_u32(__u8 *ptr)
+{
+	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
+}
=20
-/* Used to get the bus number for a device.  */
-#define SCSI_IOCTL_GET_BUS_NUMBER 0x5386
=20
-#endif /* scsi/scsi.h */
+#endif /* _SCSI_SCSI_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
