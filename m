From: Patrick Mansfield <patmans@us.ibm.com>
Subject: adding flag for 192 byte mode sense
Date: Sat, 13 Mar 2004 17:46:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040313174651.A3054@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:11959 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263247AbUCNBuD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 20:50:03 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Following are patches to support a flag for a 192 byte MODE SENSE, for use
by USB.

First patch replaces the scsi_host flags with a per sdev bflag, and sets
values in a new USB slave_alloc rather than the scsi_host template. I
grepped code for other users of scsi_host flags, and did not find any, and
do not recall seeing any added (flags is a bad name). slave_alloc is used
so that if needed the devinfo code can overwrite any settings.

Second patch adds the 192 flag.

With both patches we should get the exact behaviour we have now.

USB patches are still needed to set the BLIST_MS_192_BYTES_FOR_3F flag,
and to conditionally use the BLIST_USE_10_BYTE_MS based on the transparent
scsi versus all others. Alan or Matthew - can you send patches for that?

The scsi core usage of use_10_for_ms might need to change to behave the
way usb wants, though it probably will not matter. It currently demotes
from 10 byte to 6 byte if there is an illegal request on the 10 byte
command. Based on Alan's information, it sounds like USB wants the
commands to always be 6 or 10 bytes, with no change on an illegal request.

I tested with these usb mass storage devices: sony camera, olympus camera,
and dazzle card reader with no problems. I thought the sony used to choke
on the MODE SENSE, but it worked for both the short 8 byte and long 192
byte requests (did get sense key Illegal Request but no hang on allow
medium removal).

Some log output with command logging (sysctl -w dev.scsi.logging_level=0x2400)
on as follows.

Default USB behaviour, no MODE SENSE is sent:

kernel: scsi <1:0:0:0> send                  Inquiry 00 00 00 24 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Inquiry 00 00 00 24 00 
kernel:   Vendor: OLYMPUS   Model: C750UZ            Rev: 1.00
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: scsi <1:0:0:0> send                  Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> send                  Read Capacity 00 00 00 00 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Read Capacity 00 00 00 00 00 00 00 00 00 
kernel: SCSI device sda: 512000 512-byte hdwr sectors (262 MB)
kernel: sda: assuming Write Enabled
kernel: sda: assuming drive cache: write through
kernel: scsi <1:0:0:0> send                  Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> send                  Prevent/Allow Medium Removal 00 00 00 01 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Prevent/Allow Medium Removal 00 00 00 01 00 
kernel:  sda:<6>scsi <1:0:0:0> send                  Read (10) 00 00 00 00 00 00 00 08 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Read (10) 00 00 00 00 00 00 00 08 00 
kernel:  sda1
kernel: scsi <1:0:0:0> send                  Prevent/Allow Medium Removal 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Prevent/Allow Medium Removal 00 00 00 00 00 

Command logs using 192 (0xc0) byte MODE SENSE - tested via addition of
a devinfo entry using:

	echo "OLYMPUS:C750UZ:0x1a000" > /proc/scsi/device_info


kernel: scsi <1:0:0:0> send                  Inquiry 00 00 00 24 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Inquiry 00 00 00 24 00 
kernel:   Vendor: OLYMPUS   Model: C750UZ            Rev: 1.00
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
kernel: scsi <1:0:0:0> send                  Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> send                  Read Capacity 00 00 00 00 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Read Capacity 00 00 00 00 00 00 00 00 00 
kernel: SCSI device sda: 512000 512-byte hdwr sectors (262 MB)
kernel: scsi <1:0:0:0> send                  Mode Sense (10) 00 3f 00 00 00 00 00 c0 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Mode Sense (10) 00 3f 00 00 00 00 00 c0 00 
kernel: sda: Write Protect is off
kernel: sda: assuming drive cache: write through
kernel: scsi <1:0:0:0> send                  Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Test Unit Ready 00 00 00 00 00 
kernel: scsi <1:0:0:0> send                  Prevent/Allow Medium Removal 00 00 00 01 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Prevent/Allow Medium Removal 00 00 00 01 00 
kernel:  sda:<6>scsi <1:0:0:0> send                  Read (10) 00 00 00 00 00 00 00 08 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Read (10) 00 00 00 00 00 00 00 08 00 
kernel:  sda1
kernel: scsi <1:0:0:0> send                  Prevent/Allow Medium Removal 00 00 00 00 00 
kernel: scsi <1:0:0:0> done SUCCESS        0 Prevent/Allow Medium Removal 00 00 00 00 00 

-- Patrick Mansfield
