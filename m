From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] - mpt fusion - mptspi - host reset, kick off domain
	validation again.
Date: Wed, 19 Apr 2006 14:36:07 -0500
Message-ID: <1145475367.3460.9.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70081384@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23456 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751195AbWDSTgM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 15:36:12 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70081384@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-04-19 at 13:20 -0600, Moore, Eric wrote:
> +static void
> +mptspi_renegotiate(struct scsi_device *sdev)
> +{
> +       struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST
> *)sdev->host->hostdata;
> +
> +       if (sdev->channel == 1 ||
> +            !(hd->ioc->raid_data.isRaid & (1 << sdev->id)))

The equivalent of this check is *already* in mptspi_dv_device(), so you
don't need to check it again.  Simply replacing mptspi_renegotiate with
mptspi_dv_device() should work fine.

James


