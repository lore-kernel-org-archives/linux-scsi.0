Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499D0C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiI2CRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiI2CRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:17:48 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611212386B
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664417867; x=1695953867;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CIUQjZuJ5S1tNEwYC3STQUqYEIydxzUEzl4M0ki1vaY=;
  b=MlBtbcJMEW5tTlNWYeN8HJDss/PksuJbRFOHSHKcW+GPI4E+1SjpAWHc
   GQzlRtQvbMw9XS5Rvxzr8x2T8s8xh6TdSUlqBrEJ3RDdfPFaYJAkYtFq5
   +fFiDlAR1i9snxuEaFMIgOskaY2yi7XxLPEs1BNDaRjmtyC0LbfuEekKn
   8wtasmL7mrUKOFZmhw15bNZ8mCOVSJ+oCUhSNUUV/Af5AMPufoyorPntd
   6M44AzG9M9MD2QaPuZ70C4RCgvqNIOEtl/EzzZX+3ZXdEEGzoFBa4hMZp
   N8Us2oNw3XPHsOu9MeguOYQi44iaTLjsRCsQYhZsdnex1LP9DpJIYbQJZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,353,1654531200"; 
   d="scan'208";a="324642463"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2022 10:17:46 +0800
IronPort-SDR: IDI/Y+MPIxQoygg+OU3vvH73tBov/qxqnwNnJMkmDqp9zc7MiQI2KWMXih8jvxzkFt+awamssl
 wpKSshMXzKrgiB/CEF0BStRrBF/l18IESr0xL1XK1hwMs1fgCWD+hOv3/7ni2AM0qPAGoVCezI
 rkjdUwfeewi4AX7wUwVKerfhRmhImB89LBZY6kFJ1F07dpORRjvpzCyL7fHNZoVQdHBIknkLAN
 FAY/U+eXgUD885uEGkBwTEhhBlR6d7+UVFGIQifNlnzg+tgaxZtAN59797hxLSF0o5BF1+86sx
 Cma1PpIqwhV/ONWwd8enJn1O
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 18:37:40 -0700
IronPort-SDR: Amcn8ud5XNYnOhk7AqmezzOuVTLuC+jhP1JiWNoyg0Rxi1/An9bNFfbR0OVzwGVmUPOS/G3s0E
 qulBND5GUHs6XVnT91V2qvhLqt7A+zQ6WLecP9+S3HsOfIWPnmMUgXpEBDmtMi6HK1+M20S452
 Lp27QlG8gCWYZ3iavN5V27OWpAosVTuvXdjF5iOT2TGcdJ5Ec39VWg+y6JSHSfzELzQYg7XqFc
 y0Ag07Nt88fcUn2TMLWoVnFfc/2OzPT8mrnS4Eyx8gDC6+VfAkA/ChusQQleT6Z8q5eH2iuQCk
 q64=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 19:17:46 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MdH7s3K3Wz1RWxq
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:17:45 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664417864; x=1667009865; bh=CIUQjZuJ5S1tNEwYC3STQUqYEIydxzUEzl4
        M0ki1vaY=; b=Sak3A4pmtNnrn74yjqbromsKmtjgOhVPa8JGyclEia44LycuvwM
        c9TA/iOtKIGNUuysdPRKku062NmEYnCbRwBtylSVBbgjN58Zl8PxXjT4pLd4xHzt
        jrQY5w4dPt8VMzOV1LI9ZES1/WhWICF/4TRmb74rIQQaPAurqukqjs3LPAumwTal
        +VHjlSxXYMCxUr5HRzrbkeCpykfkLuSk6q9t77eaKA4KP0Si0Dz6CzVA9fFO+2+1
        kEmpYkq1Q0OJ+06PhiIclWfZ+uccLURB1MxlyOW4Zky1TRxixBXumPQmyTBlgh/4
        UR+iThnaBS4gLF+DAIJt9qhETqLEblGcnqg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LqFnvwUKdosa for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 19:17:44 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MdH7p2N8Rz1RvLy;
        Wed, 28 Sep 2022 19:17:42 -0700 (PDT)
Message-ID: <1303aefc-6a06-371d-5fc0-828bbce29ad4@opensource.wdc.com>
Date:   Thu, 29 Sep 2022 11:17:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 4/6] scsi: pm8001: Use sas_task_find_rq() for tagging
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        damien.lemoal@wdc.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        ipylypiv@google.com, changyuanl@google.com, hch@lst.de
References: <1664368034-114991-1-git-send-email-john.garry@huawei.com>
 <1664368034-114991-5-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1664368034-114991-5-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 21:27, John Garry wrote:
> The request associated with a scsi command coming from the block layer
> has a unique tag, so use that when possible for getting a CCB.
> 
> Unfortunately we don't support reserved commands in the SCSI midlayer yet,
> so in the interim continue to manage those tags internally (along with
> tags for private commands).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 10 ++++------
>  drivers/scsi/pm8001/pm8001_sas.c  |  8 ++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |  6 +++++-
>  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 0edc9857a8bd..0868836e7391 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1208,17 +1208,14 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha)
>  	struct Scsi_Host *shost = pm8001_ha->shost;
>  	struct device *dev = pm8001_ha->dev;
>  	u32 max_out_io, ccb_count;
> -	u32 can_queue;
>  	int i;
>  
>  	max_out_io = pm8001_ha->main_cfg_tbl.pm80xx_tbl.max_out_io;
>  	ccb_count = min_t(int, PM8001_MAX_CCB, max_out_io);
>  
> -	/* Update to the scsi host*/
> -	can_queue = ccb_count - PM8001_RESERVE_SLOT;
> -	shost->can_queue = can_queue;
> +	shost->can_queue = ccb_count - PM8001_RESERVE_SLOT;
>  
> -	pm8001_ha->tags = bitmap_zalloc(ccb_count, GFP_KERNEL);
> +	pm8001_ha->tags = bitmap_zalloc(PM8001_RESERVE_SLOT, GFP_KERNEL);

The "tags" name for this field is really confusing as it seems to be
implying "all tags". Could we rename that to reserved_tags or similar ?

>  	if (!pm8001_ha->tags)
>  		goto err_out;
>  
> @@ -1244,9 +1241,10 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha)
>  		pm8001_ha->ccb_info[i].task = NULL;
>  		pm8001_ha->ccb_info[i].ccb_tag = PM8001_INVALID_TAG;
>  		pm8001_ha->ccb_info[i].device = NULL;
> -		++pm8001_ha->tags_num;
>  	}
>  
> +	pm8001_ha->tags_num = PM8001_RESERVE_SLOT;

Same here. reserved_tags_num ?
But given that this seems to always be equal to PM8001_RESERVE_SLOT, do
we even need this field at all ?

> +
>  	return 0;
>  
>  err_out_noccb:
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 066dfa9f4683..9d25855af657 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -68,6 +68,11 @@ void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
>  	void *bitmap = pm8001_ha->tags;
>  	unsigned long flags;
>  
> +	if (tag < pm8001_ha->shost->can_queue)
> +		return;
> +
> +	tag -= pm8001_ha->shost->can_queue;
> +
>  	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
>  	__clear_bit(tag, bitmap);
>  	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
> @@ -92,6 +97,9 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
>  	}
>  	__set_bit(tag, bitmap);
>  	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
> +
> +	/* reserved tags are in the upper region of the tagset */
> +	tag += pm8001_ha->shost->can_queue;
>  	*tag_out = tag;
>  	return 0;
>  }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 9acaadf02150..9ff8d1fa84b0 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -737,9 +737,13 @@ pm8001_ccb_alloc(struct pm8001_hba_info *pm8001_ha,
>  		 struct pm8001_device *dev, struct sas_task *task)
>  {
>  	struct pm8001_ccb_info *ccb;
> +	struct request *rq = NULL;

I do not think you need the NULL initialization...

>  	u32 tag;
>  
> -	if (pm8001_tag_alloc(pm8001_ha, &tag)) {
> +	rq = sas_task_find_rq(task);
> +	if (rq) {
> +		tag = rq->tag;
> +	} else if (pm8001_tag_alloc(pm8001_ha, &tag)) {
>  		pm8001_dbg(pm8001_ha, FAIL, "Failed to allocate a tag\n");
>  		return NULL;
>  	}

-- 
Damien Le Moal
Western Digital Research

