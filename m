From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RESEND 1/2] SCSI: use scsi_device->timeout consistently
Date: Mon, 20 Nov 2006 00:01:10 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611192353590.4946@kai.makisara.local>
References: <20061119125115.GJ2184@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:38318 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S933400AbWKSWAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 17:00:06 -0500
In-Reply-To: <20061119125115.GJ2184@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sun, 19 Nov 2006, Tejun Heo wrote:

> Each high level driver uses scsi_device->timeout diffrently.
> 
...
> Index: scsi-misc-2.6/drivers/scsi/st.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/st.c
> +++ scsi-misc-2.6/drivers/scsi/st.c
> @@ -3986,7 +3986,8 @@ static int st_probe(struct device *dev)
>  	tpnt->partition = 0;
>  	tpnt->new_partition = 0;
>  	tpnt->nbr_partitions = 0;
> -	tpnt->device->timeout = ST_TIMEOUT;
> +	if (!SDp->timeout)
> +		SDp->timeout = ST_TIMEOUT;

I don't think this should be done. It probably makes the default timeout 
way too short. The error recovery with tapes takes a long time. The user 
can change the timeout if the default (900 seconds) seems too long (or 
short).

I don't think there is anything in the midlevel or low-level code to set 
the timeout based on the device characteristics. This is left to the ULD.

-- 
Kai
