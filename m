From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 14:33:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067376788.1056.5.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310281526251.6609-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-MjcsPcOgqiaDbzOYLGlA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:23812 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S261437AbTJ1VeE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 16:34:04 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310281526251.6609-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>


--=-MjcsPcOgqiaDbzOYLGlA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2003-10-28 at 13:29, Alan Stern wrote: 
> On Tue, 28 Oct 2003, Ronald Kuetemeier wrote:
> 
> > Right, so the questions is where is it. Since usb-storage-debug was/is
> > turned on before the test.
> > I looked at my  messages file again and can't find anything. This flag
> > should be on for some time in my kernels, and I have used different gcc
> > to compile these but there never seems to be any output from usb-storage
> > in my kept history of messages. And the camera seems to work just fine
> > if there is no 3f test. I  even copied to and from the camera at the
> > test8 time frame, with slightly modified sd.c to avoid the tests.
> > Any ideas where my usb-storage debug info might go, checked my
> > syslog.conf, standard ... Oh well maybe some more printk tonight, it has
> > to go somewhere. 
> > Please let me know if you have an idea.
> > Got to be some misconfiguration somewhere, sorry. I will let you know
> > after I find the output.
> > Ronald
> 
> If your syslog.conf is standard, it probably ignores debugging messages.  
> You will need to add a line that says something like:
> 
> kern.debug		/var/log/debug
Ah, now that makes sense, should have looked at the code ...
Fixed it with a *.debug to messages.
Anyhow,quick test.
1st. (which works and is now in my rc.local): mount successes 
echo "Sony:Sony DSC:0x4000" > /proc/scsi/device_info
into succ-usb_messages.txt.

2nd. tried to mount without success, i.e error
after reboot and no rc.local entry
into err-usb_messages.txt
echo "Sony:Sony DSC:0x0000" > /proc/scsi/device_inf
didn't do the trick.

Hope this helps,
Ronald


> Alan Stern
> 

--=-MjcsPcOgqiaDbzOYLGlA
Content-Disposition: attachment; filename=succ-usb_messages.txt
Content-Type: text/plain; name=succ-usb_messages.txt; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Oct 28 13:55:55 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: wakeup_hc
Oct 28 13:55:55 ronald kernel: hub 1-0:1.0: port 2, status 101, change 1, 12 Mb/s
Oct 28 13:55:55 ronald kernel: hub 1-0:1.0: debounce: port 2: delay 100ms stable 4 status 0x101
Oct 28 13:55:55 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 28 13:55:55 ronald kernel: usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Oct 28 13:55:55 ronald kernel: drivers/usb/core/message.c: USB device number 2 default language ID 0x409
Oct 28 13:55:55 ronald kernel: usb 1-2: Product: Sony DSC
Oct 28 13:55:55 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 28 13:55:55 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 13:55:55 ronald kernel: usb 1-2: registering 1-2:1.0 (config #1, interface 0)
Oct 28 13:55:55 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 13:55:55 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface
Oct 28 13:55:55 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface - got id
Oct 28 13:55:55 ronald kernel: usb-storage: USB Mass Storage device detected
Oct 28 13:55:55 ronald kernel: usb-storage: act_altsetting is 0, id_index is 23
Oct 28 13:55:55 ronald kernel: usb-storage: -- associate_dev
Oct 28 13:55:55 ronald kernel: usb-storage: Vendor: Sony
Oct 28 13:55:55 ronald kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Oct 28 13:55:55 ronald kernel: usb-storage: Transport: Control/Bulk
Oct 28 13:55:55 ronald kernel: usb-storage: Protocol: Transparent SCSI
Oct 28 13:55:55 ronald kernel: usb-storage: Endpoints: In: 0xc96367b4 Out: 0xc96367a0 Int: 0xc96367c8 (Period 255)
Oct 28 13:55:55 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:55 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 28 13:55:55 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:55 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:55 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 28 13:55:55 ronald kernel: usb-storage:  12 00 00 00 24 00
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 36/36
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:55 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:55 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:55 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:55 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 13:55:55 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:55 ronald kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Oct 28 13:55:55 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 13:55:55 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:55 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 28 13:55:55 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 28 13:55:55 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:55 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:55 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 13:55:55 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:55 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:55 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:55 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:55 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:55 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:55 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:55 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:55 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 13:55:55 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:55 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 13:55:55 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:55 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 13:55:56 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:56 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 13:55:56 ronald kernel: sda: assuming  read_Write 0 1 
Oct 28 13:55:56 ronald kernel: sda: assuming Write Enabled
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Command MODE_SENSE (6 bytes)
Oct 28 13:55:56 ronald kernel: usb-storage:  1a 00 08 00 04 00
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code -32; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- stall on control pipe
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Oct 28 13:55:56 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:56 ronald kernel: usb-storage: -- transport indicates command failure
Oct 28 13:55:56 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: sda: cache data unavailable
Oct 28 13:55:56 ronald kernel: sda: assuming drive cache: write through
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 13:55:56 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:56 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 28 13:55:56 ronald kernel: usb-storage:  1e 00 00 00 01 00
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code -32; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- stall on control pipe
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Oct 28 13:55:56 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:56 ronald kernel: usb-storage: -- transport indicates command failure
Oct 28 13:55:56 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel:  sda:<7>usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 28 13:55:56 ronald kernel: usb-storage:  28 00 00 00 00 00 00 00 08 00
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 4096/4096
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 13:55:56 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 13:55:56 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 13:55:56 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 13:55:56 ronald kernel: usb-storage: -- transfer complete
Oct 28 13:55:56 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 13:55:56 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 13:55:56 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel:  sda1
Oct 28 13:55:56 ronald kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Oct 28 13:55:56 ronald kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Bad target number (1:0)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Bad target number (2:0)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Bad target number (3:0)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:56 ronald kernel: usb-storage: Bad target number (4:0)
Oct 28 13:55:56 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:56 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:56 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:57 ronald kernel: usb-storage: Bad target number (5:0)
Oct 28 13:55:57 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:57 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:57 ronald kernel: usb-storage: Bad target number (6:0)
Oct 28 13:55:57 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:57 ronald kernel: usb-storage: queuecommand called
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:55:57 ronald kernel: usb-storage: Bad target number (7:0)
Oct 28 13:55:57 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 13:55:57 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 13:55:57 ronald kernel: WARNING: USB Mass Storage data integrity not assured
Oct 28 13:55:57 ronald kernel: USB Mass Storage device found at 2
Oct 28 13:56:08 ronald kernel: hub 1-0:1.0: port 2, status 100, change 3, 12 Mb/s
Oct 28 13:56:08 ronald kernel: usb 1-2: USB disconnect, address 2
Oct 28 13:56:08 ronald kernel: usb 1-2: usb_disable_device nuking all URBs
Oct 28 13:56:08 ronald kernel: usb 1-2: unregistering interface 1-2:1.0
Oct 28 13:56:08 ronald kernel: usb-storage: storage_disconnect() called
Oct 28 13:56:08 ronald kernel: usb-storage: usb_stor_stop_transport called
Oct 28 13:56:08 ronald kernel: usb-storage: -- dissociate_dev
Oct 28 13:56:08 ronald kernel: usb-storage: -- sending exit command to thread
Oct 28 13:56:08 ronald kernel: usb-storage: *** thread awakened.
Oct 28 13:56:08 ronald kernel: usb-storage: -- exit command received
Oct 28 13:56:08 ronald kernel: usb-storage: -- usb_stor_release_resources finished
Oct 28 13:56:08 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 13:56:08 ronald kernel: usb 1-2: unregistering device
Oct 28 13:56:08 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 13:56:08 ronald kernel: hub 1-0:1.0: port 2 enable change, status 100
Oct 28 13:56:09 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: suspend_hc

--=-MjcsPcOgqiaDbzOYLGlA
Content-Disposition: attachment; filename=err-usb_messages.txt
Content-Type: text/plain; name=err-usb_messages.txt; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Oct 28 14:25:57 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: wakeup_hc
Oct 28 14:25:57 ronald kernel: hub 1-0:1.0: port 2, status 101, change 1, 12 Mb/s
Oct 28 14:25:57 ronald kernel: hub 1-0:1.0: debounce: port 2: delay 100ms stable 4 status 0x101
Oct 28 14:25:57 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 28 14:25:57 ronald kernel: usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Oct 28 14:25:57 ronald kernel: drivers/usb/core/message.c: USB device number 2 default language ID 0x409
Oct 28 14:25:57 ronald kernel: usb 1-2: Product: Sony DSC
Oct 28 14:25:57 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 28 14:25:57 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 14:25:57 ronald kernel: usb 1-2: registering 1-2:1.0 (config #1, interface 0)
Oct 28 14:25:57 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 14:25:57 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface
Oct 28 14:25:57 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface - got id
Oct 28 14:25:57 ronald kernel: usb-storage: USB Mass Storage device detected
Oct 28 14:25:57 ronald kernel: usb-storage: act_altsetting is 0, id_index is 23
Oct 28 14:25:57 ronald kernel: usb-storage: -- associate_dev
Oct 28 14:25:57 ronald kernel: usb-storage: Vendor: Sony
Oct 28 14:25:57 ronald kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Oct 28 14:25:57 ronald kernel: usb-storage: Transport: Control/Bulk
Oct 28 14:25:57 ronald kernel: usb-storage: Protocol: Transparent SCSI
Oct 28 14:25:57 ronald kernel: usb-storage: Endpoints: In: 0xc2869e74 Out: 0xc2869e60 Int: 0xc2869e88 (Period 255)
Oct 28 14:25:57 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:57 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 28 14:25:57 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:57 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:57 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 28 14:25:57 ronald kernel: usb-storage:  12 00 00 00 24 00
Oct 28 14:25:57 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:57 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:57 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:57 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:57 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Oct 28 14:25:57 ronald kernel: usb-storage: Status code 0; transferred 36/36
Oct 28 14:25:57 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:57 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:57 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:58 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:58 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:58 ronald kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 28 14:25:58 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:58 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:58 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:58 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:58 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:25:58 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 14:25:58 ronald kernel: sda: assuming  read_Write 1 0 
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- babble
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:58 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:58 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- babble
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:58 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:58 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- babble
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:58 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:58 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- babble
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:58 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:58 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:58 ronald kernel: usb-storage: -- babble
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:58 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:58 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:58 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:58 ronald kernel: sda: Write Protect is off
Oct 28 14:25:58 ronald kernel: sda: Mode Sense: 00 32 00 00
Oct 28 14:25:58 ronald kernel: sda: assuming drive cache: write through
Oct 28 14:25:58 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:58 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:58 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:25:58 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:58 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:58 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:58 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:58 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:58 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:59 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: SCSI device (ioctl) reports ILLEGAL REQUEST.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:59 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:59 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:25:59 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:25:59 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:25:59 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 14:25:59 ronald kernel: sda: assuming  read_Write 1 0 
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- babble
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:59 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:59 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- babble
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:59 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:59 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- babble
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:59 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:59 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- babble
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:59 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:59 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:25:59 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:25:59 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:25:59 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:25:59 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:25:59 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:25:59 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:25:59 ronald kernel: usb-storage: -- babble
Oct 28 14:25:59 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:25:59 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:25:59 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:25:59 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:25:59 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:25:59 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:25:59 ronald kernel: sda: Write Protect is off
Oct 28 14:25:59 ronald kernel: sda: Mode Sense: 00 32 00 00
Oct 28 14:25:59 ronald kernel: sda: assuming drive cache: write through
Oct 28 14:25:59 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  1e 00 00 00 01 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -32; transferred 6/6
Oct 28 14:26:00 ronald kernel: usb-storage: -- stall on control pipe
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Oct 28 14:26:00 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates command failure
Oct 28 14:26:00 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:00 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:00 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:00 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:00 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:00 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:00 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 14:26:00 ronald kernel: sda: assuming  read_Write 1 0 
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- babble
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:00 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- babble
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:00 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- babble
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:00 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- babble
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:00 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:00 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:00 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:00 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:00 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:00 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:00 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:00 ronald kernel: usb-storage: -- babble
Oct 28 14:26:00 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:00 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:00 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:00 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:00 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: sda: Write Protect is off
Oct 28 14:26:01 ronald kernel: sda: Mode Sense: 00 32 00 00
Oct 28 14:26:01 ronald kernel: sda: assuming drive cache: write through
Oct 28 14:26:01 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 28 14:26:01 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 28 14:26:01 ronald kernel:  unable to read partition table
Oct 28 14:26:01 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 28 14:26:01 ronald kernel:  unable to read partition table
Oct 28 14:26:01 ronald kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Oct 28 14:26:01 ronald kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (1:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (2:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (3:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (4:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (5:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (6:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:01 ronald kernel: usb-storage: Bad target number (7:0)
Oct 28 14:26:01 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 28 14:26:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:01 ronald kernel: WARNING: USB Mass Storage data integrity not assured
Oct 28 14:26:01 ronald kernel: USB Mass Storage device found at 2
Oct 28 14:26:04 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:04 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:04 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:26:04 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:04 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:04 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:04 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:04 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Oct 28 14:26:04 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:04 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 14:26:04 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:04 ronald kernel: SCSI device (ioctl) reports ILLEGAL REQUEST.
Oct 28 14:26:04 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:04 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:04 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:26:04 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:04 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:04 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:04 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:04 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:04 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:04 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:04 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:04 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:04 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:05 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:05 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 14:26:05 ronald kernel: sda: assuming  read_Write 1 0 
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- babble
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:05 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:05 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- babble
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:05 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:05 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- babble
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:05 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:05 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- babble
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:05 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:05 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:05 ronald kernel: usb-storage: -- babble
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:05 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:05 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: sda: Write Protect is off
Oct 28 14:26:05 ronald kernel: sda: Mode Sense: 00 32 00 00
Oct 28 14:26:05 ronald kernel: sda: assuming drive cache: write through
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:05 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:05 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:05 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:05 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:05 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:05 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 28 14:26:05 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:05 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:05 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:05 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:05 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:05 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:05 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:05 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 28 14:26:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 28 14:26:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 28 14:26:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 28 14:26:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 28 14:26:06 ronald kernel: sda: assuming  read_Write 1 0 
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- babble
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:06 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:06 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- babble
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:06 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:06 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- babble
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:06 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:06 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- babble
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:06 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:06 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: usb-storage: queuecommand called
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:06 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 28 14:26:06 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 28 14:26:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 28 14:26:06 ronald kernel: usb-storage: -- transfer complete
Oct 28 14:26:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 28 14:26:06 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 28 14:26:06 ronald kernel: usb-storage: -- babble
Oct 28 14:26:06 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 28 14:26:06 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 28 14:26:06 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 28 14:26:06 ronald kernel: usb-storage: Soft reset failed: -32
Oct 28 14:26:06 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 28 14:26:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 28 14:26:06 ronald kernel: sda: Write Protect is off
Oct 28 14:26:06 ronald kernel: sda: Mode Sense: 00 32 00 00
Oct 28 14:26:06 ronald kernel: sda: assuming drive cache: write through
Oct 28 14:26:06 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 28 14:26:06 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 28 14:26:06 ronald kernel:  unable to read partition table
Oct 28 14:26:09 ronald kernel: hub 1-0:1.0: port 2, status 100, change 3, 12 Mb/s
Oct 28 14:26:09 ronald kernel: usb 1-2: USB disconnect, address 2
Oct 28 14:26:09 ronald kernel: usb 1-2: usb_disable_device nuking all URBs
Oct 28 14:26:09 ronald kernel: usb 1-2: unregistering interface 1-2:1.0
Oct 28 14:26:09 ronald kernel: usb-storage: storage_disconnect() called
Oct 28 14:26:09 ronald kernel: usb-storage: usb_stor_stop_transport called
Oct 28 14:26:09 ronald kernel: usb-storage: -- dissociate_dev
Oct 28 14:26:09 ronald kernel: usb-storage: -- sending exit command to thread
Oct 28 14:26:09 ronald kernel: usb-storage: *** thread awakened.
Oct 28 14:26:09 ronald kernel: usb-storage: -- exit command received
Oct 28 14:26:09 ronald kernel: usb-storage: -- usb_stor_release_resources finished
Oct 28 14:26:09 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 14:26:09 ronald kernel: usb 1-2: unregistering device
Oct 28 14:26:09 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 28 14:26:09 ronald kernel: hub 1-0:1.0: port 2 enable change, status 100
Oct 28 14:26:10 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: suspend_hc

--=-MjcsPcOgqiaDbzOYLGlA--

