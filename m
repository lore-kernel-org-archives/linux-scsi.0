From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] consolidate and log scsi command on send and completion
Date: Tue, 30 Sep 2003 17:23:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030930172339.A10629@beaverton.ibm.com>
References: <20030930172134.A10611@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:6872 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261842AbTJAAYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 20:24:04 -0400
Content-Disposition: inline
In-Reply-To: <20030930172134.A10611@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 30, 2003 at 05:21:34PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Some sample output showing the command logging (with CONFIG_SCSI_CONSTANTS
enabled).

Of course after shutting off syslogd :-(

And with scsi logging for ml queue of 2 and ml complete of 2 via:

	sysctl -w dev.scsi.logging_level=0x2400

FYI, if you want both ml queue and ml complete both set:

	to 	use scsi_logging_level
	1		0x1200
	2		0x2400
	3		0x3600
	4		0x4800

Output for scanning host3 id 0, a0 is REPORT LUNS, interspersed with writes 
to the root disk <0:0:0:0>, and partition information:

scsi <3:0:0:0> send                  UNKNOWN(0xa0) 00 00 00 00 00 00 00 04 08 00 00 
scsi <3:0:0:0> done SUCCESS        0 UNKNOWN(0xa0) 00 00 00 00 00 00 00 04 08 00 00 
scsi <3:0:0:1> send                  Inquiry 00 00 00 24 00 
scsi <3:0:0:1> done SUCCESS        0 Inquiry 00 00 00 24 00 
  Vendor: IBM       Model: 3542              Rev: 0520
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(3:0:0:1): Enabled tagged queuing, queue depth 64.
scsi <3:0:0:1> send                  Test Unit Ready 00 00 00 00 00 
scsi <3:0:0:1> done SUCCESS        0 Test Unit Ready 00 00 00 00 00 
scsi <3:0:0:1> send                  Read Capacity 00 00 00 00 00 00 00 00 00 
scsi <3:0:0:1> done SUCCESS        0 Read Capacity 00 00 00 00 00 00 00 00 00 
SCSI device sdi: 11087872 512-byte hdwr sectors (5677 MB)
scsi <3:0:0:1> send                  Mode Sense 00 08 00 04 00 
scsi <3:0:0:1> done SUCCESS        0 Mode Sense 00 08 00 04 00 
scsi <3:0:0:1> send                  Mode Sense 00 08 00 20 00 
scsi <3:0:0:1> done SUCCESS<6>scsi <0:0:0:0> send                  Write (10) 00 00 28 00 47 00 00 08 00 
scsi <0:0:0:0> done SUCCESS        0 Write (10) 00 00 28 00 47 00 00 08 00 
scsi <0:0:0:0> send                  Write (10) 00 00 28 02 67 00 00 08 00 
scsi <0:0:0:0> done SUCCESS        0 Write (10) 00 00 28 02 67 00 00 08 00 
scsi <0:0:0:0> send                  Write (10) 00 00 28 18 3f 00 00 08 00 
scsi <0:0:0:0> done SUCCESS        0 Write (10) 00 00 28 18 3f 00 00 08 00 
scsi <0:0:0:0> send                  Write (10) 00 00 34 00 a7 00 00 08 00 
        0 Mode Sense 00 08 00 20 00 
scsi <0:0:0:0> done <5>SCSI device sdi: drive cache: write back
 sdi:<6>scsi <3:0:0:1> send                  Read (10) 00 00 00 00 00 00 00 08 00 
scsi <3:0:0:1> done SUCCESS        0 Read (10) 00 00 00 00 00 00 00 08 00 
 unknown partition table
Attached scsi disk sdi at scsi3, channel 0, id 0, lun 1
SUCCESS        0 Write (10) 00 00 34 00 a7 00 00 08 00 


Example of a device not supporting INQUIRY page code 0x83 (with sense data
dump):

scsi <0:0:0:0> send                  Inquiry 01 83 00 ff 00 
scsi <0:0:0:0> done SUCCESS        2 Inquiry 01 83 00 ff 00 
Current sda: sense key Illegal Request
Additional sense: Invalid field in cdb
scsi <0:0:0:0> done SUCCESS        2 Inquiry 01 83 00 ff 00 
Current sda: sense key Illegal Request
Additional sense: Invalid field in cdb


Ard example output on timeout, with scsi logging for ml queue of 3 and ml
complete of 3:


scsi <2:0:0:0> done 0xf4abd560 TIMEOUT        0 Read (10) 00 00 00 00 00 00 00 80 00 
scsi <2:0:0:0> send 0xf4abd560                  Test Unit Ready 00 00 00 00 00 
scsi <2:0:0:0> done 0xf4abd560 SUCCESS        0 Test Unit Ready 00 00 00 00 00 
Inserting command f4abd560 into mlqueue
scsi <2:0:0:0> send 0xf4abd560                  Read (10) 00 00 00 00 00 00 00 80 00 
scsi <2:0:0:0> done 0xf4abd560 SUCCESS        0 Read (10) 00 00 00 00 00 00 00 80 00 
