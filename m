From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: Sat, 21 Aug 2004 00:41:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4126D268.4060208@pobox.com>
References: <1093053368.3318.569.camel@mulgrave> 	<4126BFCC.2000702@pobox.com> <1093061216.2688.710.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41195 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268845AbUHUElZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 00:41:25 -0400
In-Reply-To: <1093061216.2688.710.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> +/* accessor functions for the SCSI parameters */
> +static inline int scsi_device_sync(struct scsi_device *sdev)
> +{
> +	return sdev->sdtr;
> +}
> +static inline int scsi_device_wide(struct scsi_device *sdev)
> +{
> +	return sdev->wdtr;
> +}
> +static inline int scsi_device_dt(struct scsi_device *sdev)
> +{
> +	return sdev->ppr;
> +}
> +static inline int scsi_device_dt_only(struct scsi_device *sdev)
> +{
> +	if (sdev->inquiry_len < 57)
> +		return 0;
> +	return (sdev->inquiry[56] & 0x0c) == 0x04;
> +}
> +static inline int scsi_device_ius(struct scsi_device *sdev)
> +{
> +	if (sdev->inquiry_len < 57)
> +		return 0;
> +	return sdev->inquiry[56] & 0x01;
> +}
> +static inline int scsi_device_qas(struct scsi_device *sdev)
> +{
> +	if (sdev->inquiry_len < 57)
> +		return 0;
> +	return sdev->inquiry[56] & 0x02;


Very nice.  Two nits (of course),
* my fingers would prefer scsidev_foo or scsi_inq_foo
* might as well take the opportunity to kill sdtr/wdtr/ppr :)

