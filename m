From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi for lk 2.5.51
Date: Sun, 15 Dec 2002 12:51:07 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFBE00B.1070805@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000009040407020403090805"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: patmans@us.ibm.com

This is a multi-part message in MIME format.
--------------000009040407020403090805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Since sysfs now contains a reasonable amount of data about
scsi devices, it is possible to write an application
that scans this information and presents it in a "ls"
form (akin to lspci and lsusb).

Attached is a toy program called lsssci that could
grow into something more useful. It requires lk 2.5.51
or later.

$ lsscsi
[4:0:0:0]  CDROM   CREATIVE CD5233E          1.00  /dev/sr0
[3:0:0:0]  disk    Linux    scsi_debug       0004  /dev/sdb
[2:0:6:0]  tape    SONY     SDT-7000         0192
[0:0:8:0]  disk    FUJITSU  MAM3184MP        0105  /dev/sda


This output corresponds to my system which has these "scsi"
devices:

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 08 Lun: 00
   Vendor: FUJITSU  Model: MAM3184MP        Rev: 0105
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: CREATIVE Model: CD5233E          Rev: 1.00
   Type:   CD-ROM                           ANSI SCSI revision: 02


sysfs doesn't provide the ANSI SCSI revision number associated
with each device (hopefully Pat can add that in the future).
Otherwise, all the information that /proc/scsi/scsi uses 3
lines per device for, can be compressed onto one line. Putting
the device node (e.g. /dev/sda) seems a useful addition.
[That latter addition is only done currently for block scsi
devices (hence it doesn't appear for the tape).]

Doug Gilbert

--------------000009040407020403090805
Content-Type: application/x-gzip;
 name="lsscsi.c.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="lsscsi.c.gz"

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
yX8ASxjt+kIaAAA=
--------------000009040407020403090805--

