From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [PATCH/RFT] check non-scsi part of status in
	scsi_status_is_good
Date: Wed, 29 Oct 2003 10:53:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067449993.1168.15.camel@ronald.kuetemeier.com>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com>
	 <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
	 <20031028071637.B8503@beaverton.ibm.com>
	 <1067355769.1102.17.camel@ronald.kuetemeier.com>
	 <20031029084656.B18130@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-a+OHs45+SI3OucBvnsh3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:4101 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S261152AbTJ2Ryj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:54:39 -0500
In-Reply-To: <20031029084656.B18130@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>


--=-a+OHs45+SI3OucBvnsh3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Patrick,
here is the test (didn't work).
BTW, your scsi.h is different from the test-9 file, I had to patch by
hand.

My steps.

1st. apply the patch (compile ...)
reboot, no 3f flag
attach camera
try to mount
file: err-pat-scsi.h_messages.txt

2nd. just in case
reboot, 
echo "Sony:Sony DSC:0x4000" > /proc/scsi/device_info
mount
file: succ-reboot-3f_messages.txt

Ronald


On Wed, 2003-10-29 at 09:46, Patrick Mansfield wrote:
> Ronald can you test this out, and send usb storage logs?
> 
> For your device I assume we will now send a MODE SENSE page 0x0 that will
> get a bogus ILLEGAL REQUEST, but then the following MODE SENSE page 0x3f
> with a longer length might work.
> 
> I test booted, but do not have any removable media or USB storage
> attached.
> 
> ----------------
> 
> Only the scsi status byte is being checked for all callers of
> scsi_status_is_good. This means non-scsi errors are treated as no error at
> all without this fix.
> 
> diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi.h status-fix-bl-2.5/include/scsi/scsi.h
> --- bl-25/include/scsi/scsi.h	Mon Sep 29 12:21:10 2003
> +++ status-fix-bl-2.5/include/scsi/scsi.h	Wed Oct 29 07:19:56 2003
> @@ -126,6 +126,8 @@ extern const unsigned char scsi_command_
>   */
>  static inline int scsi_status_is_good(int status)
>  {
> +	if (status & 0xffffff00)
> +		return 0;
>  	/*
>  	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
>  	 * significant in SCSI-3.  For now, we follow the SCSI-2
> 
> -- Patrick Mansfield
> 

--=-a+OHs45+SI3OucBvnsh3
Content-Disposition: attachment; filename=err-pat-scsi.h_messages.txt
Content-Type: text/plain; name=err-pat-scsi.h_messages.txt; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Oct 29 10:09:52 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: wakeup_hc
Oct 29 10:09:52 ronald kernel: hub 1-0:1.0: port 2, status 101, change 1, 12 Mb/s
Oct 29 10:09:52 ronald kernel: hub 1-0:1.0: debounce: port 2: delay 100ms stable 4 status 0x101
Oct 29 10:09:52 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 29 10:09:52 ronald kernel: usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Oct 29 10:09:52 ronald kernel: drivers/usb/core/message.c: USB device number 2 default language ID 0x409
Oct 29 10:09:52 ronald kernel: usb 1-2: Product: Sony DSC
Oct 29 10:09:52 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 29 10:09:52 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 29 10:09:52 ronald kernel: usb 1-2: registering 1-2:1.0 (config #1, interface 0)
Oct 29 10:09:52 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 29 10:09:52 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface
Oct 29 10:09:52 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface - got id
Oct 29 10:09:52 ronald kernel: usb-storage: USB Mass Storage device detected
Oct 29 10:09:52 ronald kernel: usb-storage: act_altsetting is 0, id_index is 23
Oct 29 10:09:52 ronald kernel: usb-storage: -- associate_dev
Oct 29 10:09:52 ronald kernel: usb-storage: Vendor: Sony
Oct 29 10:09:52 ronald kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Oct 29 10:09:52 ronald kernel: usb-storage: Transport: Control/Bulk
Oct 29 10:09:52 ronald kernel: usb-storage: Protocol: Transparent SCSI
Oct 29 10:09:52 ronald kernel: usb-storage: Endpoints: In: 0xcfb88874 Out: 0xcfb88860 Int: 0xcfb88888 (Period 255)
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:52 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 29 10:09:52 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:52 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 29 10:09:52 ronald kernel: usb-storage:  12 00 00 00 24 00
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 36/36
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:09:52 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:09:52 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:09:52 ronald kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Oct 29 10:09:52 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:52 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 29 10:09:52 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 29 10:09:52 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:52 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 29 10:09:52 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:09:52 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:09:52 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:09:52 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:52 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:52 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 29 10:09:52 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:09:52 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:09:52 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:09:52 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:09:52 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:52 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 29 10:09:52 ronald kernel: sda: assuming  read_Write 1 0 
Oct 29 10:09:52 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:52 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:52 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:52 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:52 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:52 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:52 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:52 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:52 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 29 10:09:52 ronald kernel: usb-storage: -- babble
Oct 29 10:09:52 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 29 10:09:52 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:09:53 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:09:53 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:53 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:53 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 29 10:09:53 ronald kernel: usb-storage: -- babble
Oct 29 10:09:53 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 29 10:09:53 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:09:53 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:09:53 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:53 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:53 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 29 10:09:53 ronald kernel: usb-storage: -- babble
Oct 29 10:09:53 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 29 10:09:53 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:09:53 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:09:53 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:53 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:53 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 29 10:09:53 ronald kernel: usb-storage: -- babble
Oct 29 10:09:53 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 29 10:09:53 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:09:53 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:09:53 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:53 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 3f 00 00 00 00 00 08 00
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:09:53 ronald kernel: usb-storage: Status code -75; transferred 8/8
Oct 29 10:09:53 ronald kernel: usb-storage: -- babble
Oct 29 10:09:53 ronald kernel: usb-storage: CB data stage result is 0x3
Oct 29 10:09:53 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:09:53 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:09:53 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:09:53 ronald kernel: usb-storage: queuecommand called
Oct 29 10:09:53 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:09:53 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 29 10:09:53 ronald kernel: usb-storage:  5a 00 00 00 00 00 00 00 08 00
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:09:53 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:09:53 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:09:53 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:09:53 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:10:22 ronald kernel: usb-storage: command_abort called
Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_stop_transport called
Oct 29 10:10:22 ronald kernel: usb-storage: -- cancelling URB
Oct 29 10:10:22 ronald kernel: usb-storage: Status code -104; transferred 0/8
Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer cancelled
Oct 29 10:10:22 ronald kernel: usb-storage: CB data stage result is 0x4
Oct 29 10:10:22 ronald kernel: usb-storage: -- command was aborted
Oct 29 10:10:22 ronald kernel: usb-storage: scsi command aborted
Oct 29 10:10:22 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:10:22 ronald kernel: usb-storage: queuecommand called
Oct 29 10:10:22 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:10:22 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 29 10:10:22 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:10:22 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:10:22 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:10:22 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:10:22 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:10:22 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:10:22 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:10:32 ronald kernel: usb-storage: command_abort called
Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_stop_transport called
Oct 29 10:10:32 ronald kernel: usb-storage: -- cancelling URB
Oct 29 10:10:32 ronald kernel: usb-storage: Status code -104; transferred 0/18
Oct 29 10:10:32 ronald kernel: usb-storage: -- transfer cancelled
Oct 29 10:10:32 ronald kernel: usb-storage: CB data stage result is 0x4
Oct 29 10:10:32 ronald kernel: usb-storage: -- auto-sense aborted
Oct 29 10:10:32 ronald kernel: usb-storage: scsi command aborted
Oct 29 10:10:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:10:32 ronald kernel: usb-storage: device_reset called
Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 29 10:10:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 29 10:10:32 ronald kernel: usb-storage: Soft reset failed: -32
Oct 29 10:10:32 ronald kernel: usb-storage: bus_reset called

--=-a+OHs45+SI3OucBvnsh3
Content-Disposition: attachment; filename=succ-reboot-3f_messages.txt
Content-Type: text/plain; name=succ-reboot-3f_messages.txt; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Oct 29 10:24:05 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: wakeup_hc
Oct 29 10:24:05 ronald kernel: hub 1-0:1.0: debounce: port 2: delay 100ms stable 4 status 0x101
Oct 29 10:24:05 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 29 10:24:05 ronald kernel: usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Oct 29 10:24:05 ronald kernel: drivers/usb/core/message.c: USB device number 2 default language ID 0x409
Oct 29 10:24:05 ronald kernel: usb 1-2: Product: Sony DSC
Oct 29 10:24:05 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 29 10:24:05 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 29 10:24:05 ronald kernel: usb 1-2: registering 1-2:1.0 (config #1, interface 0)
Oct 29 10:24:05 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 29 10:24:05 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface
Oct 29 10:24:05 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface - got id
Oct 29 10:24:05 ronald kernel: usb-storage: USB Mass Storage device detected
Oct 29 10:24:05 ronald kernel: usb-storage: act_altsetting is 0, id_index is 23
Oct 29 10:24:05 ronald kernel: usb-storage: -- associate_dev
Oct 29 10:24:05 ronald kernel: usb-storage: Vendor: Sony
Oct 29 10:24:05 ronald kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Oct 29 10:24:05 ronald kernel: usb-storage: Transport: Control/Bulk
Oct 29 10:24:05 ronald kernel: usb-storage: Protocol: Transparent SCSI
Oct 29 10:24:05 ronald kernel: usb-storage: Endpoints: In: 0xcfda83f4 Out: 0xcfda83e0 Int: 0xcfda8408 (Period 255)
Oct 29 10:24:05 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:05 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 29 10:24:05 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:05 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:05 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  12 00 00 00 24 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 36/36
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 29 10:24:06 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 29 10:24:06 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 29 10:24:06 ronald kernel: sda: assuming  read_Write 0 1 
Oct 29 10:24:06 ronald kernel: sda: assuming Write Enabled
Oct 29 10:24:06 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command MODE_SENSE (6 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  1a 00 08 00 04 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code -32; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- stall on control pipe
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: -- transport indicates command failure
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel: sda: cache data unavailable
Oct 29 10:24:06 ronald kernel: sda: assuming drive cache: write through
Oct 29 10:24:06 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  1e 00 00 00 01 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code -32; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- stall on control pipe
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: -- transport indicates command failure
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x2
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel:  sda:<7>usb-storage: queuecommand called
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:06 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:06 ronald kernel: usb-storage:  28 00 00 00 00 00 00 00 08 00
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 4096/4096
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:06 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:06 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:06 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:06 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:06 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:06 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:06 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:06 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:06 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:06 ronald kernel:  sda1
Oct 29 10:24:06 ronald kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Oct 29 10:24:06 ronald kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (1:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (2:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (3:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (4:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (5:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (6:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:07 ronald kernel: usb-storage: Bad target number (7:0)
Oct 29 10:24:07 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 29 10:24:07 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:07 ronald kernel: WARNING: USB Mass Storage data integrity not assured
Oct 29 10:24:07 ronald kernel: USB Mass Storage device found at 2
Oct 29 10:24:42 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:42 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:42 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 29 10:24:42 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:42 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:42 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:42 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:42 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:42 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:42 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:42 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:42 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:42 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:42 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:42 ronald kernel: usb-storage:  28 00 00 00 00 13 00 00 01 00
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:42 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:42 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:42 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:42 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:42 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:42 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:42 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:42 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:42 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:42 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:42 ronald kernel: usb-storage:  28 00 00 00 00 14 00 00 01 00
Oct 29 10:24:42 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:42 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:42 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:42 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 28 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:43 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 29 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:43 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 2a 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:43 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 2b 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:43 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 2c 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:43 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:43 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:43 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:43 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:43 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:43 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:43 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:43 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:43 ronald kernel: usb-storage:  28 00 00 00 00 2d 00 00 01 00
Oct 29 10:24:43 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:43 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:43 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 2e 00 00 01 00
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 2f 00 00 01 00
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 30 00 00 01 00
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 31 00 00 01 00
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 32 00 00 01 00
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:44 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:44 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:44 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:44 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:44 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:44 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:44 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:44 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:44 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:44 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:44 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:44 ronald kernel: usb-storage:  28 00 00 00 00 33 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 34 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 35 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 36 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 37 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 38 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:45 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:45 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:45 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:45 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:45 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:45 ronald kernel: usb-storage:  28 00 00 00 00 39 00 00 01 00
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:45 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:45 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:45 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:45 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:45 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:45 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:46 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:46 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:46 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:46 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:46 ronald kernel: usb-storage:  28 00 00 00 00 3a 00 00 01 00
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:46 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:46 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:46 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:46 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:46 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:46 ronald kernel: usb-storage:  28 00 00 00 00 3b 00 00 01 00
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:46 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:46 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:46 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:46 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:46 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:46 ronald kernel: usb-storage:  28 00 00 00 00 3c 00 00 01 00
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:46 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:46 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:46 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:46 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:46 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:46 ronald kernel: usb-storage:  28 00 00 00 00 3d 00 00 01 00
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:46 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:46 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:46 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:46 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:46 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:46 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:46 ronald kernel: usb-storage:  28 00 00 00 00 3e 00 00 01 00
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:46 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:46 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:46 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:46 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:46 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:46 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:47 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:47 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:47 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:47 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:47 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:47 ronald kernel: usb-storage: *** thread sleeping.
Oct 29 10:24:47 ronald kernel: usb-storage: queuecommand called
Oct 29 10:24:47 ronald kernel: usb-storage: *** thread awakened.
Oct 29 10:24:47 ronald kernel: usb-storage: Command READ_10 (10 bytes)
Oct 29 10:24:47 ronald kernel: usb-storage:  28 00 00 00 00 3f 00 00 01 00
Oct 29 10:24:47 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:47 ronald kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 512/512
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:47 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 29 10:24:47 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 29 10:24:47 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 29 10:24:47 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 29 10:24:47 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 29 10:24:47 ronald kernel: usb-storage: -- transfer complete
Oct 29 10:24:47 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 29 10:24:47 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 29 10:24:47 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 29 10:24:47 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 29 10:24:47 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 29 10:24:47 ronald kernel: usb-storage: *** thread sleeping.

--=-a+OHs45+SI3OucBvnsh3--

