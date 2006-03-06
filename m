From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Mon, 06 Mar 2006 15:08:16 -0500
Message-ID: <440C96B0.7040404@pobox.com>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com> <43BDDCAE.7000506@torque.net> <43BE6506.7090901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:47012 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751200AbWCFUIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 15:08:31 -0500
In-Reply-To: <43BE6506.7090901@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: patman@aracnet.com, Chris Paulson-Ellis <chris@edesix.com>, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Douglas Gilbert wrote:

> Changelog:
>   - make existing libata VPD device identification page (0x83)
>     supply the ATA serial number in the libata "vendor
>     specific" designator (from Chris Paulson-Ellis)
>   - add a "t10 vendor id based" designator as defined in
>     SAT rev 07a (section 10.3.4.2.3) that supplies ATA
>     model and serial numbers
>   - make the libata VPD page 0x83 more extensible (for
>     adding more designators in the future).
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

> ------------------------------------------------------------------------
> 
> --- linux/drivers/scsi/libata-scsi.c	2006-01-04 08:50:42.000000000 +1000
> +++ linux/drivers/scsi/libata-scsi.c2615vpd	2006-01-06 20:16:25.000000000 +1000
> @@ -1532,16 +1532,16 @@
>  	return 0;
>  }
>  
> -static const char *inq_83_str = "Linux ATA-SCSI simulator";
> -
>  /**
>   *	ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
>   *	@args: device IDENTIFY data / SCSI command of interest.
>   *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
>   *	@buflen: Response buffer length.
>   *
> - *	Returns device identification.  Currently hardcoded to
> - *	return "Linux ATA-SCSI simulator".
> + *	Yields two logocal unit device identification designators:
> + *	  - vendor specific ASCII containing the ATA serial number
> + *	  - SAT defined "t10 vendor id based" containing ASCII vendor
> + *	    name ("ATA     "), model and serial numbers.
>   *
>   *	LOCKING:
>   *	spin_lock_irqsave(host_set lock)
> @@ -1550,16 +1550,39 @@
>  unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
>  			      unsigned int buflen)
>  {
> +	int num;
> +	const int sat_model_serial_desc_len = 68;
> +	const int ata_model_byte_len = 40;
> +
>  	rbuf[1] = 0x83;			/* this page code */
> -	rbuf[3] = 4 + strlen(inq_83_str);	/* page len */
> +	num = 4;
>  
> -	/* our one and only identification descriptor (vendor-specific) */
> -	if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
> -		rbuf[4 + 0] = 2;	/* code set: ASCII */
> -		rbuf[4 + 3] = strlen(inq_83_str);
> -		memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
> +	if (buflen > (ATA_SERNO_LEN + num + 3)) {
> +		/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
> +		rbuf[num + 0] = 2;	
> +		rbuf[num + 3] = ATA_SERNO_LEN;
> +		num += 4;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
> +		num += ATA_SERNO_LEN;
>  	}
> -
> +	if (buflen > (sat_model_serial_desc_len + num + 3)) {
> +		/* SAT defined lu model and serial numbers descriptor */
> +		/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
> +		rbuf[num + 0] = 2;	
> +		rbuf[num + 1] = 1;	
> +		rbuf[num + 3] = sat_model_serial_desc_len;
> +		num += 4;
> +		strncpy(rbuf + num, "ATA     ", 8);
> +		num += 8;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_PROD_OFS, ata_model_byte_len);
> +		num += ata_model_byte_len;
> +		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
> +				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
> +		num += ATA_SERNO_LEN;
> +	}
> +	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
>  	return 0;


This removes the identifier that has existed since libata was created, 
which could break something.

At the very least, update the existing code to indicate assoc=port, and 
then append the other descriptor data you wish to add after that.

	Jeff


