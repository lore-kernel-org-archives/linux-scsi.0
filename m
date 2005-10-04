From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1+
Date: Tue, 04 Oct 2005 07:40:38 -0400
Message-ID: <43426A36.8050605@pobox.com>
References: <432E7C48.8060205@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:42662 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932294AbVJDLko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 07:40:44 -0400
In-Reply-To: <432E7C48.8060205@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

Douglas Gilbert wrote:
> Jeff,
> This patch adds support for the ATA Information VPD page
> defined in sat-r05.pdf (at www.t10.org). This VPD page
> contains the response to the IDENTIFY (PACKET) DEVICE
> ATA command amongst of data.
> 
> It is against lk 2.6.14-rc1 plus my "libata: scsi error
> handling" patch that I just sent.
> 
> The patch can be exercised with "sg_inq -a /dev/sda"
> (from sg3_utils-1.17 beta at http://www.torque.net/sg )
> or "sdparm --page=ai /dev/sda" (from the sdparm-0.95
> beta at http://www.torque.net/sg/sdparm.html ).
> smartmontools could use this information if it was
> available from linux.
> 
> As required by the sat-r05 draft, the code executes an
> IDENTIFY (PACKET) DEVICE ATA command to get the most
> recent values in dev->id . I know Tejun has been working
> in this area and may have a better way of doing this
> (e.g. the inside out spinlocks are a worry). The
> "signature" part is a hack; registers need to be read
> after a device reset and held.
> 
> Changelog:
>   - add support for the ATA Information VPD page [0x89]
>   - add function to redo IDENTIFY (PACKET) DEVICE ATA
>     command to update the array dev->id, assumes
>     ata_dev_identify() has been called.

Basic idea OK, patch rejected due to the following concerns.  Please 
resend an updated patch.


> @@ -1059,6 +1137,79 @@
>  }
>  
>  /**
> + *	ata_scsiop_inq_89 - Simulate INQUIRY EVPD page 83, ATA information
> + *	@args: device IDENTIFY data / SCSI command of interest.
> + *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
> + *	@buflen: Response buffer length.
> + *
> + *	Yields ATA (and SAT layer) information. Defined per sat-r05
> + *	This function should also be called for S-ATAPI devices.
> + *
> + *	LOCKING:
> + *	spin_lock_irqsave(host_set lock)
> + */
> +
> +unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
> +			       unsigned int buflen)
> +{
> +	struct ata_port *ap;
> +	struct ata_device *dev;
> +	struct scsi_cmnd *cmd = args->cmd;
> +	struct scsi_device *scsidev = cmd->device;
> +	u8 *scsicmd = cmd->cmnd;
> +	unsigned int out_len;
> +	int res;
> +	const int spec_page_len = 568;
> +	u8 b[60];
> +	int is_atapi_dev = 0;
> +
> +	out_len = (scsicmd[3] << 8) + scsicmd[4];
> +	out_len = (buflen < out_len) ? buflen : out_len;
> +	memset(b, 0, sizeof(b));
> +	ap = (struct ata_port *)&scsidev->host->hostdata[0];
> +	if (ap) {
> +		dev = ata_scsi_find_dev(ap, scsidev);
> +		if (dev && (dev->class != ATA_DEV_ATA)) {

test dev->class == ATA_DEV_ATAPI, as we may soon add port multiplier 
device classes, breaking the assumption you're making here.


> +			is_atapi_dev = 1;
> +			b[0] = 0x5;	/* assume MMC device, dubious */
> +		}
> +	} else
> +		dev = NULL;
> +	b[1] = 0x89;			/* this page code */
> +	b[2] = (spec_page_len >> 8) & 0xff;
> +	b[3] = spec_page_len & 0xff;
> +	strncpy(b + 8, "linux   ", 8);
> +	strncpy(b + 16, "libata          ", 16);

can we stuff DRV_VERSION in there too?


> +	strncpy(b + 32, "0001", 4);
> +	/* signature stuff goes here, where to fetch it from? */
> +	b[36] = 0x34;		/* FIS type */
> +	b[36 + 1] = 0x0;	/* interrupt + PM port */
> +	b[36 + 4] = 0x1;	/* lba low */
> +	b[36 + 5] = is_atapi_dev ? 0x14 : 0x0;	/* lba mid */
> +	b[36 + 6] = is_atapi_dev ? 0xeb : 0x0;	/* lba high */
> +	b[36 + 12] = 0x1;	/* sector count */

this is a sufficient simulation for now.  for the future, when other 
devices such as enclosure, port multipliers, and such are supported, 
we'll probably want to cache the signature returned by the device.


> +	b[56] = is_atapi_dev ? 0xa1 : 0xec;	/* command code */
> +
> +	memcpy(rbuf, b, ((sizeof(b) < out_len) ? sizeof(b) : out_len));
> +	if ((out_len <= sizeof(b)) || (! ap) || (! dev))
> +	    return 0;
> +	
> +	spin_unlock_irq(&ap->host_set->lock);
> +	res = ata_dev_redo_identify(ap, scsidev->id);
> +	spin_lock_irq(&ap->host_set->lock);
> +	if (res) {
> +		/* sat-r05 says ok, leave IDENTIFY response all zeroes */
> +		DPRINTK("ata_dev_redo_identify failed\n");
> +		return 0;
> +	}

Just eliminate this.  dev->id should be considered always current.  If 
it is not, that should be fixed elsewhere in libata.

The rest of the patch is OK.

	Jeff


