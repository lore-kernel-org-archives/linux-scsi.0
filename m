From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH RFC] use struct scsi_lun in generic code
Date: Mon, 24 Oct 2005 08:27:30 -0700
Message-ID: <20051024152730.GA28341@us.ibm.com>
References: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:4287 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751340AbVJXWCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:02:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j9OM2hdc012630
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:02:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j9OM3eNM538640
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 16:03:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j9OM2ghI014145
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 16:02:43 -0600
Content-Disposition: inline
In-Reply-To: <20051023043301.GA22615@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Nice work Jeff ...

On Sun, Oct 23, 2005 at 12:33:01AM -0400, Jeff Garzik wrote:

> * export scsilun_to_int()
> 
> * create scsilun_to_str() helper

> -	if (sdev->scsi_level <= SCSI_2)
> +	if (sdev->scsi_level <= SCSI_2) {
> +		unsigned int tmp_lun = scsilun_to_int(&sdev->lun);
>  		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
> -			(sdev->lun << 5 & 0xe0);
> +			(tmp_lun << 5 & 0xe0);
> +	}

Why convert the lun value for every IO? Not efficient here and in the
driver code.

Instead call scsilun_to_int once per sdev, and store the value in
sdev->lun, sort of like James earlier patch, but only do so based on a
shost->opaque_lun_value or better if we could call a transport function
once to setup sdev->lun as needed by the driver, except we have transports
that include drivers/HBA's that use different sized LUNs.

Then struct scsi_lun has to be a u64 or another sXXX_lun(XXX).

>  	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
> -		 "%d:%d:%d:%d", sdev->host->host_no,
> -		 sdev_channel(sdev), sdev_id(sdev), sdev->lun);
> +		 "%d:%d:%d:%s", sdev->host->host_no,
> +		 sdev_channel(sdev), sdev_id(sdev),
> +		scsilun_to_str(sdev, lunstr));

BUS_ID_SIZE is KOBJ_NAME_LEN is still 20. I thought we were moving to hex
for the bus_id value?

> +static inline char *scsilun_to_str(struct scsi_device *sdev, char *s)
> +{
> +	sprintf(s, "%d", scsilun_to_int(&sdev->lun));
> +	return s;

And format the LUN output based on the shost->opaque_luns. IMO for
!opaque_lun_value print LUN in the same order as today, else print 8 byte
hex string.

Some (probably most) users of drivers/transports with 8 byte LUN support
will be confused one way or another. Yes, most will expect to see 1 for
LUN 0001000000000000. We can't always display the LUN the same as used by
storage vendors in their setup/administration tools.

Perhaps base parsing of user space LUN values on the shost->opaque_lun_value,
I don't know how we can support 8 byte LUNs from user space and be
backwards compatible without adding another attribute or interface.

Note that current SAM (sam4r02) sort of allows for different sized LUNs,
it says "A logical unit number shall contain 64 bits or 16 bits, with the
size being defined by the SCSI transport protocol.  For SCSI transport
protocols that define 16-bit logical unit numbers, the two bytes shall be
formatted as described for the FIRST LEVEL ADDRESSING field (see table 5
in 4.9.5)."

-- Patrick Mansfield
