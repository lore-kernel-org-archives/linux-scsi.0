From: Adam Radford <aradford@3WARE.com>
Subject: RE: [PATCH] 3w-xxxx: additional ata->sense codes, avoid driver lo
	ckup
Date: Wed, 13 Nov 2002 13:57:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <A1964EDB64C8094DA12D2271C04B812672C867@tabby>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: 'Luben Tuikov' <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luben,

Thanks for submitting the patch, however, it appears part of it is wrong:

-               if ((command->status == 0xc7) || (command->status == 0xcb))
{
+               if (command->status & 0xC1) {

What makes you think you should not check for c7 or cb, and only check c1? 
Do you have the controller firmware spec in front of you?

-Adam

-----Original Message-----
From: Luben Tuikov [mailto:luben@splentec.com]
Sent: Wednesday, November 13, 2002 1:01 PM
To: linux-scsi; linux-kernel
Subject: [PATCH] 3w-xxxx: additional ata->sense codes, avoid driver
lockup


A few of our IDE hds were generating those errors.

The first one locks up the 3w-xxxx driver (into an inf. loop)
when the error register = 0x11; this also resulted sometimes
in kernel lockup, also when doing raidstop...

The second one (0x51 move) is for completely broken
sectors/medium -- this makes SCSI core figure this one out
quickly and do the appropriate action, rather than retry
the command several times + timeout, of course without
success.

For the status byte, we're more generous (actually only interested
in the error bit); if found, good, else the effect is the same.

-- 
Luben

--- linux-2.5.47/drivers/scsi/3w-xxxx.h Sun Nov 10 22:28:06 2002
+++ linux/drivers/scsi/3w-xxxx.h        Wed Nov 13 15:07:28 2002
@@ -108,7 +108,9 @@
   {0x01, 0x03, 0x13, 0x00}, // Address mark not found       Address mark
not found for data field
   {0x04, 0x0b, 0x00, 0x00}, // Aborted command              Aborted command
   {0x10, 0x0b, 0x14, 0x00}, // ID not found                 Recorded entity
not found
+  {0x11, 0x0b, 0x12, 0x00}, // Address Mark Not Found       Address Mark
Not Found For ID Field
   {0x40, 0x03, 0x11, 0x00}, // Uncorrectable ECC error      Unrecovered
read error
+  {0x51, 0x03, 0x31, 0x00}, // Uncorrectable Data Error     Medium Format
Corrupted  
   {0x61, 0x04, 0x00, 0x00}, // Device fault                 Hardware error
   {0x84, 0x0b, 0x47, 0x00}, // Data CRC error               SCSI parity
error
   {0xd0, 0x0b, 0x00, 0x00}, // Device busy                  Aborted command
@@ -118,7 +120,6 @@
                             // 3ware Error                  SCSI Error
   {0x09, 0x0b, 0x00, 0x00}, // Unrecovered disk error       Aborted command
   {0x37, 0x0b, 0x04, 0x00}, // Unit offline                 Logical unit
not ready
-  {0x51, 0x0b, 0x00, 0x00}  // Unspecified                  Aborted command
 };
 
 /* Control register bit definitions */
--- linux-2.5.47/drivers/scsi/3w-xxxx.c Sun Nov 10 22:28:30 2002
+++ linux/drivers/scsi/3w-xxxx.c        Wed Nov 13 15:07:28 2002
@@ -716,7 +716,7 @@
 
        /* Attempt to return intelligent sense information */
        if (fill_sense) {
-               if ((command->status == 0xc7) || (command->status == 0xcb))
{
+               if (command->status & 0xC1) {
                        for
(i=0;i<(sizeof(tw_sense_table)/sizeof(tw_sense_table[0]));i++) {
                                if (command->flags == tw_sense_table[i][0])
{
