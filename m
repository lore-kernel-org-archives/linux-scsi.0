From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Thu, 09 Feb 2006 00:39:20 +0100
Message-ID: <43EA8128.9000205@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:13997 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1422639AbWBHXjg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 18:39:36 -0500
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Al Viro <viro@ftp.linux.org.uk>, linux1394-devel@lists.sourceforge.net

Al Viro wrote:
> 	a) TYPE_SDAD renamed to TYPE_RBC and taken to scsi.h
> 	b) in sbp2.c remapping of TYPE_RPB to TYPE_DISK turned off
> 	c) relevant places in midlayer and sd.c taught to accept TYPE_RBC
> 	d) sd.c::sd_read_cache_type() looks into page 6 when dealing with
> TYPE_RBC - these guys have writeback cache flag there and are not guaranteed
> to have page 8 at all.
> 	e) sd_read_cache_type() got an extra sanity check - it checks that
> it got the page it asked for before using its contents.  And screams if
> mismatch had happened.  Rationale: there are broken devices out there that
> are "helpful" enough to go for "I don't have a page you've asked for, here,
> have another one".  For example, PL3507 had been caught doing just that...
> 	f) sbp2 sets sdev->use_10_for_rw and sdev->use_10_for_ms instead
> of bothering to remap READ6/WRITE6/MOD_SENSE, so most of the conversions
> in there are gone now.
> 
> 	Incidentally, I wonder if USB storage devices that have no
> mode page 8 are simply RBC ones.  I haven't touched that, but it might
> be interesting to check...
> 	
> Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
> ----

While I was testing Al Viro's sbp2 patch from today, I also tested the 
one disk which was broken by this "TYPE_RBC cache fixes" patch back in 
mid 2005. (Release history: The TYPE_RBC patch went into Linus' tree but 
we reverted the sbp2 part of the patch shortly thereafter. The sbp2 part 
was finally merged this January in linux-2.6.16-rc1.)

The device whose support was broken by the patch is a noname (actually 
AVLAB) 2.5" 1394b enclosure based on Initio INIC-2430F, clad in black 
aluminium. http://www.linux1394.org/view_device.php?id=917

On top of an early 2.6.13-rc kernel, this patch caused Linux to *reboot* 
immediately after the disk was attached.

Curiously enough, the device worked again with this patch on top of 
2.6.14.x.

Now I tested the disk again the first time after I moved on to 2.6.15.x 
(again with the "TYPE_RBC cache fixes" patch, which is not available in 
2.6.15 but has been merged in 2.6.16-rc1). Again, the machine 
immediately rebooted when the disk was attached. Like I reported in 
July, the problem seems to arise from the disk's response to 
MODE_SENSE_10. http://marc.theaimsgroup.com/?l=linux-scsi&m=112128914912105

Could the fact that Linux reboots (if sbp2 does not mangle the SCSI 
commands) mean that the SBP-2 target is overwriting memory outside of a 
data buffer? Or does the SCSI stack perform reckless things like jumps 
based on pointer tables, using unchecked data? Or...?

Vanilla 2.6.15.x works with this device. I did not boot into 2.6.16-rcX yet.


> diff -urN RC12-rc4-base/drivers/ieee1394/sbp2.c RC12-rc4-rbc/drivers/ieee1394/sbp2.c
> --- RC12-rc4-base/drivers/ieee1394/sbp2.c	2005-05-07 04:04:56.000000000 -0400
> +++ RC12-rc4-rbc/drivers/ieee1394/sbp2.c	2005-05-15 12:17:39.716295613 -0400
> @@ -1070,7 +1070,7 @@
>  static __inline__ int sbp2_command_conversion_device_type(u8 device_type)
>  {
>  	return (((device_type == TYPE_DISK) ||
> -		 (device_type == TYPE_SDAD) ||
> +		 (device_type == TYPE_RBC) ||
>  		 (device_type == TYPE_ROM)) ? 1:0);
>  }
>  
> @@ -2111,102 +2111,6 @@
>   */
>  static void sbp2_check_sbp2_command(struct scsi_id_instance_data *scsi_id, unchar *cmd)
>  {
> -	unchar new_cmd[16];
> -	u8 device_type = SBP2_DEVICE_TYPE (scsi_id->sbp2_device_type_and_lun);
> -
> -	SBP2_DEBUG("sbp2_check_sbp2_command");
> -
> -	switch (*cmd) {
> -
> -		case READ_6:
> -
> -			if (sbp2_command_conversion_device_type(device_type)) {
> -
> -				SBP2_DEBUG("Convert READ_6 to READ_10");
> -
> -				/*
> -				 * Need to turn read_6 into read_10
> -				 */
> -				new_cmd[0] = 0x28;
> -				new_cmd[1] = (cmd[1] & 0xe0);
> -				new_cmd[2] = 0x0;
> -				new_cmd[3] = (cmd[1] & 0x1f);
> -				new_cmd[4] = cmd[2];
> -				new_cmd[5] = cmd[3];
> -				new_cmd[6] = 0x0;
> -				new_cmd[7] = 0x0;
> -				new_cmd[8] = cmd[4];
> -				new_cmd[9] = cmd[5];
> -
> -				memcpy(cmd, new_cmd, 10);
> -
> -			}
> -
> -			break;
> -
> -		case WRITE_6:
> -
> -			if (sbp2_command_conversion_device_type(device_type)) {
> -
> -				SBP2_DEBUG("Convert WRITE_6 to WRITE_10");
> -
> -				/*
> -				 * Need to turn write_6 into write_10
> -				 */
> -				new_cmd[0] = 0x2a;
> -				new_cmd[1] = (cmd[1] & 0xe0);
> -				new_cmd[2] = 0x0;
> -				new_cmd[3] = (cmd[1] & 0x1f);
> -				new_cmd[4] = cmd[2];
> -				new_cmd[5] = cmd[3];
> -				new_cmd[6] = 0x0;
> -				new_cmd[7] = 0x0;
> -				new_cmd[8] = cmd[4];
> -				new_cmd[9] = cmd[5];
> -
> -				memcpy(cmd, new_cmd, 10);
> -
> -			}
> -
> -			break;
> -
> -		case MODE_SENSE:
> -
> -			if (sbp2_command_conversion_device_type(device_type)) {
> -
> -				SBP2_DEBUG("Convert MODE_SENSE_6 to MODE_SENSE_10");
> -
> -				/*
> -				 * Need to turn mode_sense_6 into mode_sense_10
> -				 */
> -				new_cmd[0] = 0x5a;
> -				new_cmd[1] = cmd[1];
> -				new_cmd[2] = cmd[2];
> -				new_cmd[3] = 0x0;
> -				new_cmd[4] = 0x0;
> -				new_cmd[5] = 0x0;
> -				new_cmd[6] = 0x0;
> -				new_cmd[7] = 0x0;
> -				new_cmd[8] = cmd[4];
> -				new_cmd[9] = cmd[5];
> -
> -				memcpy(cmd, new_cmd, 10);
> -
> -			}
> -
> -			break;
> -
> -		case MODE_SELECT:
> -
> -			/*
> -			 * TODO. Probably need to change mode select to 10 byte version
> -			 */
> -
> -		default:
> -			break;
> -	}
> -
> -	return;
>  }
>  
>  /*
> @@ -2272,14 +2176,6 @@
>  			}
>  
>  			/*
> -			 * Check for Simple Direct Access Device and change it to TYPE_DISK
> -			 */
> -			if ((scsi_buf[0] & 0x1f) == TYPE_SDAD) {
> -				SBP2_DEBUG("Changing TYPE_SDAD to TYPE_DISK");
> -				scsi_buf[0] &= 0xe0;
> -			}
> -
> -			/*
>  			 * Fix ansi revision and response data format
>  			 */
>  			scsi_buf[2] |= 2;
> @@ -2287,27 +2183,6 @@
>  
>  			break;
>  
> -		case MODE_SENSE:
> -
> -			if (sbp2_command_conversion_device_type(device_type)) {
> -
> -				SBP2_DEBUG("Modify mode sense response (10 byte version)");
> -
> -				scsi_buf[0] = scsi_buf[1];	/* Mode data length */
> -				scsi_buf[1] = scsi_buf[2];	/* Medium type */
> -				scsi_buf[2] = scsi_buf[3];	/* Device specific parameter */
> -				scsi_buf[3] = scsi_buf[7];	/* Block descriptor length */
> -				memcpy(scsi_buf + 4, scsi_buf + 8, scsi_buf[0]);
> -			}
> -
> -			break;
> -
> -		case MODE_SELECT:
> -
> -			/*
> -			 * TODO. Probably need to change mode select to 10 byte version
> -			 */
> -
>  		default:
>  			break;
>  	}
> @@ -2690,7 +2565,8 @@
>  static int sbp2scsi_slave_configure (struct scsi_device *sdev)
>  {
>  	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
> -
> +	sdev->use_10_for_rw = 1;
> +	sdev->use_10_for_ms = 1;
>  	return 0;
>  }
>  
> diff -urN RC12-rc4-base/drivers/ieee1394/sbp2.h RC12-rc4-rbc/drivers/ieee1394/sbp2.h
> --- RC12-rc4-base/drivers/ieee1394/sbp2.h	2005-05-07 04:04:56.000000000 -0400
> +++ RC12-rc4-rbc/drivers/ieee1394/sbp2.h	2005-05-15 12:17:39.716295613 -0400
> @@ -266,10 +266,6 @@
>  #define SBP2_MAX_UDS_PER_NODE		16	/* Maximum scsi devices per node */
>  #define SBP2_MAX_SECTORS		255	/* Max sectors supported */
>  
> -#ifndef TYPE_SDAD
> -#define TYPE_SDAD			0x0e	/* simplified direct access device */
> -#endif
> -
>  /*
>   * SCSI direction table...
>   * (now used as a back-up in case the direction passed down from above is "unknown")
> diff -urN RC12-rc4-base/drivers/scsi/scsi_scan.c RC12-rc4-rbc/drivers/scsi/scsi_scan.c
> --- RC12-rc4-base/drivers/scsi/scsi_scan.c	2005-05-07 04:05:00.000000000 -0400
> +++ RC12-rc4-rbc/drivers/scsi/scsi_scan.c	2005-05-15 12:17:39.717295419 -0400
> @@ -625,6 +625,7 @@
>  	case TYPE_MEDIUM_CHANGER:
>  	case TYPE_ENCLOSURE:
>  	case TYPE_COMM:
> +	case TYPE_RBC:
>  		sdev->writeable = 1;
>  		break;
>  	case TYPE_WORM:
> diff -urN RC12-rc4-base/drivers/scsi/sd.c RC12-rc4-rbc/drivers/scsi/sd.c
> --- RC12-rc4-base/drivers/scsi/sd.c	2005-05-07 04:05:00.000000000 -0400
> +++ RC12-rc4-rbc/drivers/scsi/sd.c	2005-05-15 12:30:38.769387199 -0400
> @@ -1368,17 +1368,26 @@
>   */
>  static void
>  sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer)
> +{
>  	int len = 0, res;
>  
> -	const int dbd = 0;	   /* DBD */
> -	const int modepage = 0x08; /* current values, cache page */
> +	int dbd;
> +	int modepage;
>  	struct scsi_mode_data data;
>  	struct scsi_sense_hdr sshdr;
>  
>  	if (sdkp->device->skip_ms_page_8)
>  		goto defaults;
>  
> +	if (sdkp->device->type == TYPE_RBC) {
> +		modepage = 6;
> +		dbd = 8;
> +	} else {
> +		modepage = 8;
> +		dbd = 0;
> +	}
> +
>  	/* cautiously ask */
>  	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
>  
> @@ -1409,11 +1418,20 @@
>  			"write back, no read (daft)"
>  		};
>  		int ct = 0;
> -		int offset = data.header_length +
> -			data.block_descriptor_length + 2;
> +		int offset = data.header_length + data.block_descriptor_length;
>  
> -		sdkp->WCE = ((buffer[offset] & 0x04) != 0);
> -		sdkp->RCD = ((buffer[offset] & 0x01) != 0);
> +		if ((buffer[offset] & 0x3f) != modepage) {
> +			printk(KERN_ERR "%s: got wrong page\n", diskname);
> +			goto defaults;
> +		}
> +
> +		if (modepage == 8) {
> +			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
> +			sdkp->RCD = ((buffer[offset + 2] & 0x01) != 0);
> +		} else {
> +			sdkp->WCE = ((buffer[offset + 2] & 0x01) == 0);
> +			sdkp->RCD = 0;
> +		}
>  
>  		ct =  sdkp->RCD + 2*sdkp->WCE;
>  
> @@ -1533,7 +1551,7 @@
>  	int error;
>  
>  	error = -ENODEV;
> -	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
> +	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
>  		goto out;
>  
>  	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
> @@ -1570,7 +1588,7 @@
>  	sdkp->openers = 0;
>  
>  	if (!sdp->timeout) {
> -		if (sdp->type == TYPE_DISK)
> +		if (sdp->type != TYPE_MOD)
>  			sdp->timeout = SD_TIMEOUT;
>  		else
>  			sdp->timeout = SD_MOD_TIMEOUT;
> diff -urN RC12-rc4-base/include/scsi/scsi.h RC12-rc4-rbc/include/scsi/scsi.h
> --- RC12-rc4-base/include/scsi/scsi.h	2005-05-07 04:05:05.000000000 -0400
> +++ RC12-rc4-rbc/include/scsi/scsi.h	2005-05-15 12:17:39.718295225 -0400
> @@ -210,6 +210,7 @@
>  #define TYPE_COMM           0x09    /* Communications device */
>  #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
>  #define TYPE_RAID           0x0c
> +#define TYPE_RBC	    0x0e
>  #define TYPE_NO_LUN         0x7f
>  
>  /*
> 
> 
> -------------------------------------------------------
> This SF.Net email is sponsored by Oracle Space Sweepstakes
> Want to be the first software developer in space?
> Enter now for the Oracle Space Sweepstakes!
> http://ads.osdn.com/?ad_id=7412&alloc_id=16344&op=click
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel


-- 
Stefan Richter
-=====-=-==- --=- -=--=
http://arcgraph.de/sr/
