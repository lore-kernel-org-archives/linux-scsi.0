Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757FEFA3740
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 01:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiJ0BfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 21:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJ0BfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 21:35:10 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D954F2A429
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666834492; x=1698370492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mfvs68MMxP21OfOV+MNKT20Qml7kPOHQBwE5n8aakKc=;
  b=ZYqIQTyIXNGBzz/AU63jnWJTnkrdOdAg6vYNfBPHTl9wdwqSXiA9iXKM
   NcSuAQTEJvxROpvRk15DZzxYSGRmqvw9r4B/Ovptby+OkAOhsGBRRPSP6
   SM/pAxhIzNZaeoToPkK6FYU1axjSdUjIZV651/Ht46KCyoF81s48OAQ97
   KKgxN3+fRv15gaHK8EYdqC+kRzeApjiPJ98SWrrnVeiGvRqyepPvZKdRy
   f44Wz13UUq9FZ6RTJMZi6PTU++zcVA1Ps6zu0D1tTNKuENFXYWwyzORJM
   s/Y+Tn124VtKHFUBkUpjpz10N8RWNPIEJuxRohRP73VQ2JiBZ+6ed0Vcv
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="326938341"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 09:34:51 +0800
IronPort-SDR: mcAXkZGyDnaKi2TVYI/54Ck/l+n4JQu0xIJZmD6BpsLlV2WOp0wTHVqRgtgmnRXkYZAmNg+/AB
 CBEZbi4gL9/9N80bG882GONE1jOZJbLiJiJXI6g5Q7r+vRhqVAI+wVKlYXTyeqRiMl68o4+vIC
 m5B9wqsL18hrY8xol/8IbznNeyakDTtU/9rmk90Q5D9hXA9ybxrJOWIxJivRM5EIJSImi7y8SL
 oFZlr8Ny/HubRWnjXnLx2KDA1ptl6YiaYF6lrqpBkQt2tRZGAs2uCUOmY+3sF28ZyvfJ4e2yft
 fyjacwStsGhvfBr+GJ/coa8M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 17:54:11 -0700
IronPort-SDR: yrS8aAmwLwiaxh2No3v7pnlNBgki2cC6VeojPBEDhUKhsO46cC0Oa1JGPAaXs9oQJvQ/nzm5Ng
 GIxwkLz0FEey7s1g2Jb0aW95G944H8rRYxa98zqUPAK9lAYZp8E2eJRd0hFzow2Lg+4wuyJd73
 /eZUOwvaNQKeX1t0Mr3/NFRKolXW+V5FqTuAufsHckQ02pw0J9jYl1TC5KSVHmPje6PtjdBj/b
 bBjgficivdjqFUlEbdQOKSlJLOGLjuGP9pnB1Pn1QDPlIwtw4vCgDiiE/FEAyd/3IZGW5zh3U8
 VYg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 18:34:49 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MySsN6Tp7z1Rwtl
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:34:48 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666834488; x=1669426489; bh=Mfvs68MMxP21OfOV+MNKT20Qml7kPOHQBwE
        5n8aakKc=; b=fW97wt3r9y9/lOrYtVV0Egx8UF6ziqwbwV+rAXI3MxPlaJd6Crr
        8hMZcX1xoxp9IgZxe+2q39EHqN7Y/TmslPZ1sa1to4f+3YK/5enULv8MWWWFvnfT
        AIk+qofdk6P2CRVxK2VNZEu50I6/DMr0hZT7DnYtqPqEIx2GjleEH48U+RdYoWuU
        VDaPxj38s8NhJjfWHwd/8HgmDfOcoQ22L5XWu9Abg/xrBpzWVc2BDpJ0ZyC/FTnD
        Ih/f7iHv+Oq0Vp8pDJYDEupY9iAHJbn9yt4iyB2xGlRrPmn1QtHoRjSX6o+PJ+m8
        TBoNxbLdywMGPMD2/jgG/mtEVs7yB4GrqmQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l2fqYnfrh3DG for <linux-scsi@vger.kernel.org>;
        Wed, 26 Oct 2022 18:34:48 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MySsK2k8Kz1RvLy;
        Wed, 26 Oct 2022 18:34:45 -0700 (PDT)
Message-ID: <6c0a4a75-786a-c946-57f2-c511bd765bcc@opensource.wdc.com>
Date:   Thu, 27 Oct 2022 10:34:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH RFC v3 16/22] ata: libata-scsi: Allocate sdev early in
 port probe
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@cloud.ionos.com, hare@suse.de, bvanassche@acm.org,
        hch@lst.de, ming.lei@redhat.com, niklas.cassel@wdc.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
 <1666693096-180008-17-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1666693096-180008-17-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/22 19:18, John Garry wrote:
> Currently the per-ata device sdev is allocated as part of the scsi target
> scan, which is after the ata port probe.
> 
> However it is useful to have the sdev available in the port probe. As an
> example of an advantage, if the request queue is available in the probe
> (which it would be if the sdev is available), then it is possible to use
> a SCSI cmnd for ATA internal commands. The benefit of this is then we can
> put the ATA qc structure in the SCSI cmnd private data. It will also be
> useful if we want to send ATA internal commands as requests.
> 
> Export scsi_target_reap() so that it can be used to put the extra
> reference we get when allocating the sdev.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/ata/libata-eh.c   |  1 +
>  drivers/ata/libata-scsi.c | 23 +++++++++--------------
>  drivers/scsi/scsi_scan.c  |  1 +
>  3 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 08e11bc312c2..1ed5b1b64792 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -3446,6 +3446,7 @@ static int ata_eh_schedule_probe(struct ata_device *dev)
>  
>  	ata_eh_detach_dev(dev);
>  	ata_dev_init(dev);
> +	ata_scsi_setup_sdev(dev);
>  	ehc->did_probe_mask |= (1 << dev->devno);
>  	ehc->i.action |= ATA_EH_RESET;
>  	ehc->saved_xfer_mode[dev->devno] = 0;
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index efdba852e363..476e0ef4bd29 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1109,7 +1109,12 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>  	if (dev->flags & ATA_DFLAG_TRUSTED)
>  		sdev->security_supported = 1;
>  
> -	dev->sdev = sdev;
> +	/*
> +	 * Put extra reference which we get when allocating the starget
> +	 * initially
> +	 */
> +	scsi_target_reap(scsi_target(sdev));
> +
>  	return 0;
>  }
>  
> @@ -4289,26 +4294,16 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>   repeat:
>  	ata_for_each_link(link, ap, EDGE) {
>  		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev;
> +			struct Scsi_Host *shost = ap->scsi_host;
>  			int channel = 0, id = 0;
>  
> -			if (dev->sdev)
> -				continue;
> -
>  			if (ata_is_host_link(link))
>  				id = dev->devno;
>  			else
>  				channel = link->pmp;
>  
> -			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
> -						 NULL);
> -			if (!IS_ERR(sdev)) {
> -				dev->sdev = sdev;
> -				ata_scsi_assign_ofnode(dev, ap);

Is there something equivalent to what this function does inside
scsi_scan_target() ? I had a quick look but did not see anything...

> -				scsi_device_put(sdev);
> -			} else {
> -				dev->sdev = NULL;
> -			}
> +			scsi_scan_target(&shost->shost_gendev, channel, id,
> +					 0, SCSI_SCAN_INITIAL);
>  		}
>  	}
>  
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index b795c138f2c1..da7bc14b030c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -598,6 +598,7 @@ void scsi_target_reap(struct scsi_target *starget)
>  	BUG_ON(starget->state == STARGET_DEL);
>  	scsi_target_reap_ref_put(starget);
>  }
> +EXPORT_SYMBOL_GPL(scsi_target_reap);
>  
>  /**
>   * scsi_sanitize_inquiry_string - remove non-graphical chars from an

-- 
Damien Le Moal
Western Digital Research

