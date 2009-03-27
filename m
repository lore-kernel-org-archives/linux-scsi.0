From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] PM port setting and attached SATA port selector in
	discover
Date: Fri, 27 Mar 2009 16:52:21 +0000
Message-ID: <1238172741.3292.17.camel@localhost.localdomain>
References: <20090317184151.22987.73806.stgit@fritz>
	 <20090324231914.25065.44829.stgit@fritz>
	 <FE3F06125A99254E8D92161AA4569C6F06A98AF5@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40376 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250AbZC0QwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 12:52:25 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F06A98AF5@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>

On Wed, 2009-03-25 at 20:03 -0700, Andy Yan wrote:
> >From 9937ccded1e182b50f1128e80d70768b16d2b5e7 Mon Sep 17 00:00:00 2001
> From: Andy Yan <ayan@marvell.com>
> Date: Thu, 26 Mar 2009 18:32:31 +0800
> Subject: [PATCH] PM port setting and attached SATA port selector in
> discover
> 
> Default PM port should be set 0 other than 1.For most SATA disk, it is
> ignored,
> But I got that some expander reports attached SATA port selector 1 and
> won't clear it. Host should pass this check and send command with PMport
> 0.
> 
> ---
>  drivers/scsi/libsas/sas_ata.c      |    2 +-
>  drivers/scsi/libsas/sas_expander.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c
> b/drivers/scsi/libsas/sas_ata.c
> index e155011..bea3deb 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -174,7 +174,7 @@ static unsigned int sas_ata_qc_issue(struct
> ata_queued_cmd *qc)
>  		qc->tf.nsect = 0;
>  	}
>  
> -	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
> +	ata_tf_to_fis(&qc->tf, 0, 0, (u8*)&task->ata_task.fis);
>  	task->uldd_task = qc;
>  	if (ata_is_atapi(qc->tf.protocol)) {
>  		memcpy(task->ata_task.atapi_packet, qc->cdb,
> qc->dev->cdb_len);
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index 3da02e4..75ca00b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -642,7 +642,7 @@ static struct domain_device
> *sas_ex_discover_end_dev(
>  	struct sas_rphy *rphy;
>  	int res;
>  
> -	if (phy->attached_sata_host || phy->attached_sata_ps)
> +	if (phy->attached_sata_host)

In general this looks OK.  What it's going to cause to happen is that we
now try to discover SATA port selectors, which aren't supported in
libsas ... can you check that nothing nasty happens when libsas finds
one?

James


