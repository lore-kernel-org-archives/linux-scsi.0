From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 12:25:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067541899.1141.4.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-OdFSdpWTR08cYzibov4y"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:2566 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S262709AbTJ3T0S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 14:26:18 -0500
In-Reply-To: <20031030100501.A7250@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com


--=-OdFSdpWTR08cYzibov4y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Sorry Patrick,
didn't work.

Applied patch (compile ...)
reboot no 3f
mount camera.
file: err-pat-scsi-1.patch_messages.txt
Ronald


On Thu, 2003-10-30 at 11:05, Patrick Mansfield wrote:
> Here's a patch, per Pat Lavarre's suggestion, this can't go in without
> others verifying and testing it, and without input or comment from others
> (at least James).
> 
> Again no USB testing here, tested on 2 sets of SPI attached disks, and 2
> sets of FCP attached disks. It really needs testing on removable media to
> actually hit the write protect check.
> 
> Ronald does this work for you?
> 
> ------
> 
> Use MODE SENSE page 8 whether asking for write protect information or
> cache type.  Always use the exact size of the expected result.
> 
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_lib.c use_page8_always-bl-2.5/drivers/scsi/scsi_lib.c
> --- bl-25/drivers/scsi/scsi_lib.c	Mon Sep 29 12:21:09 2003
> +++ use_page8_always-bl-2.5/drivers/scsi/scsi_lib.c	Thu Oct 30 09:23:19 2003
> @@ -1377,6 +1377,11 @@ __scsi_mode_sense(struct scsi_request *s
>  	if (use_10_for_ms) {
>  		if (len < 8)
>  			len = 8;
> +		else if (len > 28)
> +			/*
> +			 * 20 bytes + 8 byte header
> +			 */
> +			len = 28;
>  
>  		cmd[0] = MODE_SENSE_10;
>  		cmd[8] = len;
> @@ -1384,6 +1389,11 @@ __scsi_mode_sense(struct scsi_request *s
>  	} else {
>  		if (len < 4)
>  			len = 4;
> +		else if (len > 24)
> +			/*
> +			 * 20 bytes + 4 byte header
> +			 */
> +			len = 24;
>  
>  		cmd[0] = MODE_SENSE;
>  		cmd[4] = len;
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sd.c use_page8_always-bl-2.5/drivers/scsi/sd.c
> --- bl-25/drivers/scsi/sd.c	Mon Oct 27 14:28:18 2003
> +++ use_page8_always-bl-2.5/drivers/scsi/sd.c	Thu Oct 30 09:35:53 2003
> @@ -1085,8 +1085,10 @@ sd_do_mode_sense(struct scsi_request *SR
>   */
>  static void
>  sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer) 
> +{
>  	int res;
> +	int len;
>  	struct scsi_mode_data data;
>  
>  	if (sdkp->device->skip_ms_page_3f) {
> @@ -1094,26 +1096,16 @@ sd_read_write_protect_flag(struct scsi_d
>  		return;
>  	}
>  
> -	/*
> -	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
> -	 * We have to start carefully: some devices hang if we ask
> -	 * for more than is available.
> -	 */
> -	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
> -
> -	/*
> -	 * Second attempt: ask for page 0
> -	 * When only page 0 is implemented, a request for page 3F may return
> -	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
> -	 */
> -	if (!scsi_status_is_good(res))
> -		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
> -
> -	/*
> -	 * Third attempt: ask 255 bytes, as we did earlier.
> -	 */
> -	if (!scsi_status_is_good(res))
> -		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
> +	if (sdkp->device->use_10_for_ms)
> +		/*
> +		 * __mode_sense auto-retries with a size of 24 if it
> +		 * switches to a 6 byte command.
> +		 */
> +		len = 28; /* 20 + 8 byte header */
> +	else
> +		len = 24; /* 20 + 4 byte header */
> +
> +	res = sd_do_mode_sense(SRpnt, 0, 8, buffer, len, &data);
>  
>  	if (!scsi_status_is_good(res)) {
>  		printk(KERN_WARNING
> @@ -1130,42 +1122,36 @@ sd_read_write_protect_flag(struct scsi_d
>  /*
>   * sd_read_cache_type - called only from sd_revalidate_disk()
>   * called with buffer of length 512
> + *
> + * XXX Combine this with sd_read_write_protect_flag, so we only get the
> + * page once.
>   */
>  static void
>  sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer) 
> +{
>  	int len = 0, res;
> -
> -	const int dbd = 0;	   /* DBD */
> -	const int modepage = 0x08; /* current values, cache page */
>  	struct scsi_mode_data data;
>  
> -	if (sdkp->device->skip_ms_page_8)
> -		goto defaults;
> -
> -	/* cautiously ask */
> -	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
> -
> -	if (!scsi_status_is_good(res))
> -		goto bad_sense;
> +	sdkp->WCE = 0;
> +	sdkp->RCD = 0;
>  
> -	/* that went OK, now ask for the proper length */
> -	len = data.length;
> -
> -	/*
> -	 * We're only interested in the first three bytes, actually.
> -	 * But the data cache page is defined for the first 20.
> -	 */
> -	if (len < 3)
> -		goto bad_sense;
> -	if (len > 20)
> -		len = 20;
> +	if (sdkp->device->skip_ms_page_8) {
> +		printk(KERN_ERR "%s: assuming drive cache: write through\n",
> +		       diskname);
> +		return;
> +	}
>  
> -	/* Take headers and block descriptors into account */
> -	len += data.header_length + data.block_descriptor_length;
> +	if (sdkp->device->use_10_for_ms)
> +		/*
> +		 * __mode_sense auto-retries with a size of 24 if it
> +		 * switches to a 6 byte command.
> +		 */
> +		len = 28; /* 20 + 8 byte header */
> +	else
> +		len = 24; /* 20 + 4 byte header */
>  
> -	/* Get the data */
> -	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
> +	res = sd_do_mode_sense(SRpnt, 0, 8, buffer, len, &data);
>  
>  	if (scsi_status_is_good(res)) {
>  		const char *types[] = {
> @@ -1185,10 +1171,7 @@ sd_read_cache_type(struct scsi_disk *sdk
>  		       diskname, types[ct]);
>  
>  		return;
> -	}
> -
> -bad_sense:
> -	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
> +	} else if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
>  	     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
>  	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
>  	     && SRpnt->sr_sense_buffer[12] == 0x24
> @@ -1199,12 +1182,6 @@ bad_sense:
>  		printk(KERN_ERR "%s: asking for cache data failed\n",
>  		       diskname);
>  	}
> -
> -defaults:
> -	printk(KERN_ERR "%s: assuming drive cache: write through\n",
> -	       diskname);
> -	sdkp->WCE = 0;
> -	sdkp->RCD = 0;
>  }
>  
>  /**
> 

--=-OdFSdpWTR08cYzibov4y
Content-Disposition: attachment; filename=err-pat-scsi-1.patch_messages.txt
Content-Type: text/plain; name=err-pat-scsi-1.patch_messages.txt; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Oct 30 12:11:00 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: wakeup_hc
Oct 30 12:11:00 ronald kernel: hub 1-0:1.0: port 2, status 101, change 1, 12 Mb/s
Oct 30 12:11:00 ronald kernel: hub 1-0:1.0: debounce: port 2: delay 100ms stable 4 status 0x101
Oct 30 12:11:00 ronald kernel: hub 1-0:1.0: new USB device on port 2, assigned address 2
Oct 30 12:11:00 ronald kernel: usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Oct 30 12:11:00 ronald kernel: drivers/usb/core/message.c: USB device number 2 default language ID 0x409
Oct 30 12:11:00 ronald kernel: usb 1-2: Product: Sony DSC
Oct 30 12:11:00 ronald kernel: usb 1-2: Manufacturer: Sony
Oct 30 12:11:00 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 30 12:11:00 ronald kernel: usb 1-2: registering 1-2:1.0 (config #1, interface 0)
Oct 30 12:11:00 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 30 12:11:00 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface
Oct 30 12:11:00 ronald kernel: usb-storage 1-2:1.0: usb_probe_interface - got id
Oct 30 12:11:00 ronald kernel: usb-storage: USB Mass Storage device detected
Oct 30 12:11:00 ronald kernel: usb-storage: act_altsetting is 0, id_index is 23
Oct 30 12:11:00 ronald kernel: usb-storage: -- associate_dev
Oct 30 12:11:00 ronald kernel: usb-storage: Vendor: Sony
Oct 30 12:11:00 ronald kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Oct 30 12:11:00 ronald kernel: usb-storage: Transport: Control/Bulk
Oct 30 12:11:00 ronald kernel: usb-storage: Protocol: Transparent SCSI
Oct 30 12:11:00 ronald kernel: usb-storage: Endpoints: In: 0xc64b08f4 Out: 0xc64b08e0 Int: 0xc64b0908 (Period 255)
Oct 30 12:11:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:00 ronald kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Oct 30 12:11:00 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:00 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:00 ronald kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 30 12:11:00 ronald kernel: usb-storage:  12 00 00 00 24 00
Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 30 12:11:00 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Oct 30 12:11:00 ronald kernel: usb-storage: Status code 0; transferred 36/36
Oct 30 12:11:00 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 30 12:11:00 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 30 12:11:00 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 30 12:11:00 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:00 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 30 12:11:00 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 30 12:11:00 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:00 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 30 12:11:00 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 30 12:11:00 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 30 12:11:00 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 30 12:11:00 ronald kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Oct 30 12:11:00 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 30 12:11:00 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:00 ronald kernel:   Vendor: Sony      Model: Sony DSC          Rev: 2.10
Oct 30 12:11:00 ronald kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Oct 30 12:11:00 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:00 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:00 ronald kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Oct 30 12:11:00 ronald kernel: usb-storage:  00 00 00 00 00 00
Oct 30 12:11:00 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:00 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:01 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 30 12:11:01 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 30 12:11:01 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 30 12:11:01 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 30 12:11:01 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 30 12:11:01 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 30 12:11:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:01 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:01 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:01 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:01 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 8/8
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 30 12:11:01 ronald kernel: usb-storage: -- CB transport device requiring auto-sense
Oct 30 12:11:01 ronald kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 6/6
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 18/18
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: CB data stage result is 0x0
Oct 30 12:11:01 ronald kernel: usb-storage: -- Result from auto-sense is 0
Oct 30 12:11:01 ronald kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Oct 30 12:11:01 ronald kernel: usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Oct 30 12:11:01 ronald kernel: usb-storage: scsi cmd done, result=0x0
Oct 30 12:11:01 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:01 ronald kernel: SCSI device sda: 63424 512-byte hdwr sectors (32 MB)
Oct 30 12:11:01 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:01 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:01 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:01 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:01 ronald kernel: usb-storage: Status code 0; transferred 10/10
Oct 30 12:11:01 ronald kernel: usb-storage: -- transfer complete
Oct 30 12:11:01 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Oct 30 12:11:01 ronald kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 28 bytes
Oct 30 12:11:30 ronald kernel: usb-storage: Status code -84; transferred 0/28
Oct 30 12:11:30 ronald kernel: usb-storage: -- unknown error
Oct 30 12:11:30 ronald kernel: usb-storage: CB data stage result is 0x4
Oct 30 12:11:30 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:30 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:30 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5080)
Oct 30 12:11:30 ronald kernel:   0: [cfde5080] link (0fde50c0) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:30 ronald kernel:   1: [cfde50c0] link (0fde5100) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:30 ronald kernel:   2: [cfde5100] link (0fde5140) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:30 ronald kernel:   3: [cfde5140] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:30 ronald kernel: 
Oct 30 12:11:30 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:30 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:30 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:30 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:30 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:30 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:30 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:30 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:30 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:30 ronald kernel:   0: [cfde5040] link (0fde5180) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:30 ronald kernel:   1: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0ab1f4)
Oct 30 12:11:30 ronald kernel:   2: [cfde51c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0ab1fc)
Oct 30 12:11:30 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:30 ronald kernel: 
Oct 30 12:11:30 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:30 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:30 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:30 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:30 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:30 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5080)
Oct 30 12:11:30 ronald kernel:   0: [cfde5080] link (0fde50c0) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:30 ronald kernel:   1: [cfde50c0] link (0fde5100) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:30 ronald kernel:   2: [cfde5100] link (0fde5140) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:30 ronald kernel:   3: [cfde5140] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:30 ronald kernel: 
Oct 30 12:11:30 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:30 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:30 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:30 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:30 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:30 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:30 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:30 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:30 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:30 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:30 ronald kernel:   0: [cfde5040] link (0fde5180) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0ab1f4)
Oct 30 12:11:31 ronald kernel:   2: [cfde51c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0ab1fc)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5080)
Oct 30 12:11:31 ronald kernel:   0: [cfde5080] link (0fde50c0) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde50c0] link (0fde5100) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5100] link (0fde5140) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde5140] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5180) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=7 D
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:31 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:31 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:31 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:31 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:31 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:31 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:31 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:31 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:31 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:31 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:31 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:31 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:31 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:31 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:31 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:31 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:31 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:31 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:31 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:31 ronald kernel: 
Oct 30 12:11:31 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:31 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:31 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:31 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:31 ronald kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Oct 30 12:11:31 ronald kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Oct 30 12:11:31 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:31 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: sda : READ CAPACITY failed.
Oct 30 12:11:32 ronald kernel: sda : status=0, message=00, host=7, driver=00 
Oct 30 12:11:32 ronald kernel: sda : sense not available. 
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command MODE_SENSE_10 (10 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  5a 00 08 00 00 00 00 00 1c 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (0fde5200) e3 SPD Active Length=0 MaxLen=1 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd3c)
Oct 30 12:11:32 ronald kernel:   3: [cfde5200] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/10
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:32 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:32 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:32 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:32 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:32 ronald kernel: sda: test WP failed, assume Write Enabled
Oct 30 12:11:32 ronald kernel: sda: assuming drive cache: write through
Oct 30 12:11:32 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 30 12:11:32 ronald kernel: Buffer I/O error on device sda, logical block 0
Oct 30 12:11:32 ronald kernel:  unable to read partition table
Oct 30 12:11:32 ronald kernel:  sda:<3>Buffer I/O error on device sda, logical block 0
Oct 30 12:11:32 ronald kernel:  unable to read partition table
Oct 30 12:11:32 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:32 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:32 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 30 12:11:32 ronald kernel: usb-storage:  1e 00 00 00 00 00
Oct 30 12:11:32 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:32 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:32 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:32 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:32 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=5 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:32 ronald kernel:   2: [cfde50c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:32 ronald kernel: 
Oct 30 12:11:32 ronald kernel: usb-storage: Status code -110; transferred 0/6
Oct 30 12:11:32 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:32 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:32 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:33 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:33 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:33 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 30 12:11:33 ronald kernel: usb-storage:  1e 00 00 00 00 00
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:33 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=5 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:33 ronald kernel:   2: [cfde50c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Status code -110; transferred 0/6
Oct 30 12:11:33 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:33 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:33 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:33 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:33 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:33 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 30 12:11:33 ronald kernel: usb-storage:  1e 00 00 00 00 00
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:33 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=5 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:33 ronald kernel:   2: [cfde50c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Status code -110; transferred 0/6
Oct 30 12:11:33 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:33 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:33 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:33 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:33 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:33 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 30 12:11:33 ronald kernel: usb-storage:  1e 00 00 00 00 00
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:33 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=5 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:33 ronald kernel:   2: [cfde50c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Status code -110; transferred 0/6
Oct 30 12:11:33 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:33 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:33 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:33 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:33 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:33 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Oct 30 12:11:33 ronald kernel: usb-storage:  1e 00 00 00 00 00
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4240] link (0fde41e2) element (0fde5040)
Oct 30 12:11:33 ronald kernel:   0: [cfde5040] link (0fde5080) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5080] link (0fde50c0) e3 SPD Active Length=0 MaxLen=5 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=0f0abd34)
Oct 30 12:11:33 ronald kernel:   2: [cfde50c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Status code -110; transferred 0/6
Oct 30 12:11:33 ronald kernel: usb-storage: -- timeout or NAK
Oct 30 12:11:33 ronald kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 4
Oct 30 12:11:33 ronald kernel: usb-storage: -- transport indicates error, resetting
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_CB_reset called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_control_msg: rq=00 rqtype=21 value=0000 index=00 len=12
Oct 30 12:11:33 ronald kernel: drivers/usb/host/uhci-hcd.c: uhci_result_control() failed with status 440000
Oct 30 12:11:33 ronald kernel: [cfde4270] link (0fde41e2) element (0fde5100)
Oct 30 12:11:33 ronald kernel:   0: [cfde5100] link (0fde5140) e0 Stalled CRC/Timeo Length=7 MaxLen=7 DT0 EndPt=0 Dev=2, PID=2d(SETUP) (buf=0fddd020)
Oct 30 12:11:33 ronald kernel:   1: [cfde5140] link (0fde5180) e3 SPD Active Length=0 MaxLen=7 DT1 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4000)
Oct 30 12:11:33 ronald kernel:   2: [cfde5180] link (0fde51c0) e3 SPD Active Length=0 MaxLen=3 DT0 EndPt=0 Dev=2, PID=e1(OUT) (buf=05be4008)
Oct 30 12:11:33 ronald kernel:   3: [cfde51c0] link (00000001) e3 IOC Active Length=0 MaxLen=7ff DT1 EndPt=0 Dev=2, PID=69(IN) (buf=00000000)
Oct 30 12:11:33 ronald kernel: 
Oct 30 12:11:33 ronald kernel: usb-storage: Soft reset failed: -110
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x70000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Oct 30 12:11:33 ronald kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (1:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (2:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (3:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (4:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (5:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (6:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: usb-storage: queuecommand called
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: Bad target number (7:0)
Oct 30 12:11:33 ronald kernel: usb-storage: scsi cmd done, result=0x40000
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread sleeping.
Oct 30 12:11:33 ronald kernel: WARNING: USB Mass Storage data integrity not assured
Oct 30 12:11:33 ronald kernel: USB Mass Storage device found at 2
Oct 30 12:11:33 ronald kernel: hub 1-0:1.0: port 2, status 100, change 3, 12 Mb/s
Oct 30 12:11:33 ronald kernel: usb 1-2: USB disconnect, address 2
Oct 30 12:11:33 ronald kernel: usb 1-2: usb_disable_device nuking all URBs
Oct 30 12:11:33 ronald kernel: usb 1-2: unregistering interface 1-2:1.0
Oct 30 12:11:33 ronald kernel: usb-storage: storage_disconnect() called
Oct 30 12:11:33 ronald kernel: usb-storage: usb_stor_stop_transport called
Oct 30 12:11:33 ronald kernel: usb-storage: -- dissociate_dev
Oct 30 12:11:33 ronald kernel: usb-storage: -- sending exit command to thread
Oct 30 12:11:33 ronald kernel: usb-storage: *** thread awakened.
Oct 30 12:11:33 ronald kernel: usb-storage: -- exit command received
Oct 30 12:11:33 ronald kernel: usb-storage: -- usb_stor_release_resources finished
Oct 30 12:11:33 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 30 12:11:33 ronald kernel: usb 1-2: unregistering device
Oct 30 12:11:34 ronald kernel: drivers/usb/core/usb.c: usb_hotplug
Oct 30 12:11:34 ronald kernel: hub 1-0:1.0: port 2 enable change, status 100
Oct 30 12:11:34 ronald kernel: drivers/usb/host/uhci-hcd.c: ef80: suspend_hc

--=-OdFSdpWTR08cYzibov4y--

