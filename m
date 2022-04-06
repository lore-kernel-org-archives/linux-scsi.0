Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1236C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 13:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiDFNG3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 09:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiDFNFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 09:05:45 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE81CFE8
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 18:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649209152; x=1680745152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TT9Q4isZap5oDHSGhYBaqGSoWrgP4fin4Czsfd9WOAQ=;
  b=py1kEZljWT6FX4K5toAHwytSn+7VfhyNavQ2psQ97k5Z9fNsEhlT8E6H
   H7bbSLhLK/5VBZ3+26NITUFash9tb18j1uvORzNCaiiDYdHhEBMIDcr59
   bwko0QFPPEtCqL26MzD6VVo6OGACbqjBBwbZ8fpPuP4LjTMP5ZokXBEhE
   ScSsYV6L0A7e07LaS4Xki6wKbwksnZ9/87RlGb5XEqQok46EPacwuCgVb
   76FJGT8Pv0QoTj7KmgjpiMeOW2+/eVngPwYDnsUgzszd707ZqfMjIDdA4
   YG3xHtJJpfwS5tk0t3g3nTLjjjNdDK/X+JO2L2iLOba6+o84cykrSG2qT
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,238,1643644800"; 
   d="scan'208";a="301359982"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 09:39:08 +0800
IronPort-SDR: m49l6XOofOzjMPU4OkVBSDLFTEGIvqJeUqBnFSounz3WaQrsfSwSFG/4I9G8WV4V9IXMIy4nCa
 MkJbSvQ/atkIBAjUHCiOmqtRsVI3XQax90dC734ZnR5Fy6tn1xXEREfPb+5boRJjrlA+JG04qE
 IixKv37PV+lj1YVt0BnxL6Uaw2kRohttCqE/aLx+4lkGa7m1swLrW19bGfNiQDk0MOw5ikkauM
 2QXiBcdRXfA8eg85BHQyQjqCNopHpLwxthr1GxWZU3J/JdsPKfUJVmHZtWNsNVeQJLbooGFhJX
 nB2ujqRnlQBrrzOPwC7mlTQl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 18:10:40 -0700
IronPort-SDR: 77ZQVLW8NsRjViNiDw+ZhE+NHqIbtl1tXzaJzkjq/JJF8w3YobJxKgDkAc7PMqvUVIvbPAupW1
 Wkod38nivy+jOw/BapmgliOFDV+ZJ6xWT9owskC0dNoDSiL+mEJPshAlDo4ekOd7Hv1bSBqVrM
 yIoIKRcuiFRcEF4Vzqz6Vl16u95ZDs7oSFN+cKjOS7BYmSBtg5YzqEzpAd7Osck4AwGAussoi2
 YPK17RHjwK3FaBq0DtV/YGHZz9bEwl+NxLFGAZWoWP+shafgjC0/RfBzh0oiMWbGnhdNIx3dc1
 kKk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 18:39:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KY6cW3dgMz1SVp2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 18:39:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649209146; x=1651801147; bh=TT9Q4isZap5oDHSGhYBaqGSoWrgP4fin4Cz
        sfd9WOAQ=; b=WRW4DVvNBMFGKtulHYkhDYUO8cUtSlv2Z6c4RPattYWACJpHRzh
        U5l3AhjRTEaGABj2wJVaAdvg8oi9n9YfxwtbBTWuinQKQefbQbfE8FrPObuLyI46
        AVjb65oOtG1lYbym+3/7mRr2evI84bo32sZienDORA5jGgOPV+92EzhJ6wB77PZK
        ZmS3yLbQS3rj6yPyUlDjKJfOXchZRZgEsFO/D4pNFuEa2+U8eHmofHuGf84me0w/
        XhIM8rm1LQn6N4gLJTpROC9aHrOrnL/QdgdbTHIK+lt1t77kf7XdO9NG/7talRUQ
        /54J6vBjrTsI4m/XvfaLHiB+0kaH/YrzpQw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Aqj8N22OIOf6 for <linux-scsi@vger.kernel.org>;
        Tue,  5 Apr 2022 18:39:06 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KY6cT5d2wz1Rvlx;
        Tue,  5 Apr 2022 18:39:05 -0700 (PDT)
Message-ID: <a3cce73f-2e91-309d-bee0-a34a30335a18@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 10:39:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] libata: Use scsi cmnd budget token for qc tag for
 SAS host
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, hch@lst.de
Cc:     linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com>
 <1649083990-207133-2-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1649083990-207133-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/22 23:53, John Garry wrote:
> For attaining a qc tag for a SAS host we need to allocate a bit in
> ata_port.sas_tag_allocated bitmap.
> 
> However we already have a unique tag per device in range
> [0, ATA_MAX_QUEUE) in the scsi cmnd budget token, so just use that
> instead.

The valid range is [0, ATA_MAX_QUEUE - 1]. Tag ATA_MAX_QUEUE is 
ATA_TAG_INTERNAL which is never allocated as a valid device tag but used 
directly in ata_exec_internal().

> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/ata/libata-core.c | 14 +++++---------
>   drivers/ata/libata-sata.c | 25 ++++---------------------
>   drivers/ata/libata-scsi.c |  2 +-
>   drivers/ata/libata.h      |  7 +++----
>   include/linux/libata.h    |  1 -
>   5 files changed, 13 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index cceedde51126..1067b2e2be28 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4566,14 +4566,15 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
>   /**
>    *	ata_qc_new_init - Request an available ATA command, and initialize it
>    *	@dev: Device from whom we request an available command structure
> - *	@tag: tag
> + *	@scmd: scmd for which to get qc
>    *
>    *	LOCKING:
>    *	None.
>    */
>   
> -struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
> +struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, struct scsi_cmnd *scmd)
>   {
> +	int tag = scsi_cmd_to_rq(scmd)->tag;
>   	struct ata_port *ap = dev->link->ap;
>   	struct ata_queued_cmd *qc;
>   
> @@ -4583,7 +4584,7 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
>   
>   	/* libsas case */
>   	if (ap->flags & ATA_FLAG_SAS_HOST) {
> -		tag = ata_sas_allocate_tag(ap);
> +		tag = ata_sas_get_tag(scmd);
>   		if (tag < 0)
>   			return NULL;
>   	}
> @@ -4611,19 +4612,14 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
>    */
>   void ata_qc_free(struct ata_queued_cmd *qc)
>   {
> -	struct ata_port *ap;
>   	unsigned int tag;
>   
>   	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
> -	ap = qc->ap;
>   
>   	qc->flags = 0;
>   	tag = qc->tag;
> -	if (ata_tag_valid(tag)) {
> +	if (ata_tag_valid(tag))
>   		qc->tag = ATA_TAG_POISON;
> -		if (ap->flags & ATA_FLAG_SAS_HOST)
> -			ata_sas_free_tag(tag, ap);
> -	}
>   }
>   
>   void __ata_qc_complete(struct ata_queued_cmd *qc)
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 044a16daa2d4..c3e9fd7d920c 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1268,29 +1268,12 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
>   }
>   EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
>   
> -int ata_sas_allocate_tag(struct ata_port *ap)
> +int ata_sas_get_tag(struct scsi_cmnd *scmd)
>   {
> -	unsigned int max_queue = ap->host->n_tags;
> -	unsigned int i, tag;
> +	if (WARN_ON_ONCE(scmd->budget_token >= ATA_MAX_QUEUE))
> +		return -1;
>   
> -	for (i = 0, tag = ap->sas_last_tag + 1; i < max_queue; i++, tag++) {
> -		tag = tag < max_queue ? tag : 0;
> -
> -		/* the last tag is reserved for internal command. */
> -		if (ata_tag_internal(tag))
> -			continue;
> -
> -		if (!test_and_set_bit(tag, &ap->sas_tag_allocated)) {
> -			ap->sas_last_tag = tag;
> -			return tag;
> -		}
> -	}
> -	return -1;
> -}
> -
> -void ata_sas_free_tag(unsigned int tag, struct ata_port *ap)
> -{
> -	clear_bit(tag, &ap->sas_tag_allocated);
> +	return scmd->budget_token;
>   }
>   
>   /**
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 06c9d90238d9..61dd7f7c7743 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -640,7 +640,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>   {
>   	struct ata_queued_cmd *qc;
>   
> -	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
> +	qc = ata_qc_new_init(dev, cmd);
>   	if (qc) {
>   		qc->scsicmd = cmd;
>   		qc->scsidone = scsi_done;
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index c9c2496d91ea..92e52090165b 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -44,7 +44,7 @@ static inline void ata_force_cbl(struct ata_port *ap) { }
>   #endif
>   extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
>   extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
> -extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
> +extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, struct scsi_cmnd *scmd);
>   extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
>   			   u64 block, u32 n_block, unsigned int tf_flags,
>   			   unsigned int tag, int class);
> @@ -93,10 +93,9 @@ extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>   
>   /* libata-sata.c */
>   #ifdef CONFIG_SATA_HOST
> -int ata_sas_allocate_tag(struct ata_port *ap);
> -void ata_sas_free_tag(unsigned int tag, struct ata_port *ap);
> +int ata_sas_get_tag(struct scsi_cmnd *scmd);
>   #else
> -static inline int ata_sas_allocate_tag(struct ata_port *ap)
> +static inline int ata_sas_get_tag(struct scsi_cmnd *scmd)
>   {
>   	return -EOPNOTSUPP;
>   }
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 9b1d3d8b1252..16107122e587 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -820,7 +820,6 @@ struct ata_port {
>   	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
>   
>   	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE + 1];
> -	unsigned long		sas_tag_allocated; /* for sas tag allocation only */
>   	u64			qc_active;
>   	int			nr_active_links; /* #links with active qcs */
>   	unsigned int		sas_last_tag;	/* track next tag hw expects */


-- 
Damien Le Moal
Western Digital Research
