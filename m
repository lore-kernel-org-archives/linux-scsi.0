From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 23:43:03 -0700
Message-ID: <20081015064303.GA17391@akamai.com>
References: <20081014025504.GA10518@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com> <20081014184226.GB20297@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay03.akamai.com ([72.247.150.167]:47685 "EHLO
	prod-mail-xrelay03.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYJOGnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2008 02:43:04 -0400
Content-Disposition: inline
In-Reply-To: <20081014184226.GB20297@akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Does this look like it could be useful upstream?

Abhijit

> Signed-off-by: Abhijit Paithankar <apaithan@akamai.com>
> 
> Index: linux-2.6.27/drivers/message/fusion/mptsas.c
> ===================================================================
> --- linux-2.6.27.orig/drivers/message/fusion/mptsas.c	2008-10-13 17:31:57.000000000 -0700
> +++ linux-2.6.27/drivers/message/fusion/mptsas.c	2008-10-14 11:36:36.000000000 -0700
> @@ -839,11 +839,15 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
>  static int
>  mptsas_slave_configure(struct scsi_device *sdev)
>  {
> +	struct sas_rphy *rphy;
>  
>  	if (sdev->channel == MPTSAS_RAID_CHANNEL)
>  		goto out;
>  
> -	sas_read_port_mode_page(sdev);
> +	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
> +	if (rphy->identify.device_type == SAS_END_DEVICE &&
> +	   (rphy->identify.target_port_protocols & SAS_PROTOCOL_SSP))
> +		sas_read_port_mode_page(sdev);
>  
>   out:
>  	return mptscsih_slave_configure(sdev);
