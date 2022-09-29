Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B38DC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiI2CLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiI2CLl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:11:41 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA5C109113
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664417500; x=1695953500;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EZZKvbac486IIAN23kbUEoaUH8EfeBcildhXhph5gaw=;
  b=Sc/BEQoB59LvS0DkbUY2Mr3MEDoWZUEHuLIinFXM7i4P3beH109qqTal
   jU7vnkp5EottxMMHnAydrHCSFJsWPsbM13k7jMIk/AqhfO45gOoKHtbDj
   kTfY7n98++UxRRSZ81dwrit2xwenMVvC5kCnrbN9hnZIeT636GXwRC3ZW
   FS7eWI1RpAmhHGtquFu9koHOcD5H1Mzz8qbKwNCLXhpPS51BKorubXHTN
   0RPGJctVBnFzrFvtSuT8MAu5az0iLtjQdFqidp42y52FRHg8QFkYm7gri
   WfqlBr1NIRHg7PtLPKDWmgSW7C3rlkw3WOnQYL+9gTB3Mrf26CaNbamdl
   g==;
X-IronPort-AV: E=Sophos;i="5.93,353,1654531200"; 
   d="scan'208";a="217715548"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2022 10:11:39 +0800
IronPort-SDR: yNOvUtjJl+7x8BcearrjbQ1X7IHUGfU3VinBb1S3Wt9jQ0/r+wsenTrnZOts+IDPH9yoTOCJvs
 bjW22z+7RLlatGe+xTuYfJuZAVRoEepOqCbCPeoQC88868G+6/d6algUoaymX5siGck9PQIZT7
 fL96Tfz8COFrFaDvtHlbibtFmgFJ+IS+yAfkF3sq8xEz+15sMdee3iRSE3fW7rTTsHRsjcjDDL
 qV90nk9VNAD+U+2KYW5kPo2CfJY3wtLGxIPvCPuwLORmj/Mf+9N+uZfU46HMhOT+74wikjLXLY
 z2qoAYxjvR2mfG2FqRggd/iS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 18:26:02 -0700
IronPort-SDR: PG/Cn51H6zaDEyABqLFzBdI/us3I18yiEoTSHPIb430CQEdcRR7BkoGgGVqA9ustjkNYw+0CF5
 R/W0gcUdTkZ+wenN3KX2v7BSnB38ipJH760EqnFGPKuQ6HHQ5xLqru07nJUfptdgYLVd99P+Ho
 UYbXmLNmjCc9ALYB478RAxEDJC06bPYKOr9k8j3Ql3agHs6GRmpZD2ZDGBJNyrTDKz5OOkrTPH
 1NP65SBaPECIts/EvbnaxxxWrGxp1zgofvvQclUbSvlpWc8MIyvtY3q+zXs0VRwfx+MGqtjB9f
 Cqc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 19:11:39 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MdH0p6gGhz1RwvT
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:11:38 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664417498; x=1667009499; bh=EZZKvbac486IIAN23kbUEoaUH8EfeBcildh
        Xhph5gaw=; b=Y08MyqDnpu03x7czKjvF9Gy76l0kbXLOSN9l/5PXkIy0bRTR+iO
        O6c+2yllrQiWJvU0BqK4wEjW6J96Bmk90u2CRLac3ERFKtlfdj8UcbKeeChmLqWh
        UWV52/zxmOm2MBDQ92JGIwaHiuWmup1R4KTJiSgUQ2DOLd7YpcyASlUbQXnUU3zb
        9fOu2I1f19CqigOgG+u4zTdbhfNwnOkiSpudabxYlvBf1ySqpgPeeLbtbTz2FcgP
        7GADU3ks7KOjiQm3oRQq8KLYPCHx6XSxidcbkpNI0Sci3edVxMRjEVZHjfPGJOab
        hhlRVxg4ZFe+5ui9kDO5tMKsv4+5tSkW5pA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id shLMWdmKvtEi for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 19:11:38 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MdH0l6t3hz1RvLy;
        Wed, 28 Sep 2022 19:11:35 -0700 (PDT)
Message-ID: <4737cbca-6250-00b8-a2be-1d98e2b8d04a@opensource.wdc.com>
Date:   Thu, 29 Sep 2022 11:11:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/6] scsi: hisi_sas: Use sas_task_find_rq()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        damien.lemoal@wdc.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        ipylypiv@google.com, changyuanl@google.com, hch@lst.de
References: <1664368034-114991-1-git-send-email-john.garry@huawei.com>
 <1664368034-114991-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1664368034-114991-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 21:27, John Garry wrote:
> Use sas_task_find_rq() to lookup the request per task for its driver tag.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Looks good, modulo the question below.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 4c37ae9eb6b6..1011dffed51f 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -177,13 +177,13 @@ static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
>  }
>  
>  static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
> -				     struct scsi_cmnd *scsi_cmnd)
> +				     struct request *rq)
>  {
>  	int index;
>  	void *bitmap = hisi_hba->slot_index_tags;
>  
> -	if (scsi_cmnd)
> -		return scsi_cmd_to_rq(scsi_cmnd)->tag;
> +	if (rq)
> +		return rq->tag;
>  
>  	spin_lock(&hisi_hba->lock);
>  	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
> @@ -461,11 +461,11 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  	struct asd_sas_port *sas_port = device->port;
>  	struct hisi_sas_device *sas_dev = device->lldd_dev;
>  	bool internal_abort = sas_is_internal_abort(task);
> -	struct scsi_cmnd *scmd = NULL;
>  	struct hisi_sas_dq *dq = NULL;
>  	struct hisi_sas_port *port;
>  	struct hisi_hba *hisi_hba;
>  	struct hisi_sas_slot *slot;
> +	struct request *rq = NULL;

Do you really need the NULL initialization here ?

>  	struct device *dev;
>  	int rc;
>  
> @@ -520,22 +520,12 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  				return -ECOMM;
>  		}
>  
> -		if (task->uldd_task) {
> -			struct ata_queued_cmd *qc;
> -
> -			if (dev_is_sata(device)) {
> -				qc = task->uldd_task;
> -				scmd = qc->scsicmd;
> -			} else {
> -				scmd = task->uldd_task;
> -			}
> -		}
> -
> -		if (scmd) {
> +		rq = sas_task_find_rq(task);
> +		if (rq) {
>  			unsigned int dq_index;
>  			u32 blk_tag;
>  
> -			blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
> +			blk_tag = blk_mq_unique_tag(rq);
>  			dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
>  			dq = &hisi_hba->dq[dq_index];
>  		} else {
> @@ -580,7 +570,7 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  	if (!internal_abort && hisi_hba->hw->slot_index_alloc)
>  		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
>  	else
> -		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
> +		rc = hisi_sas_slot_index_alloc(hisi_hba, rq);
>  
>  	if (rc < 0)
>  		goto err_out_dif_dma_unmap;

-- 
Damien Le Moal
Western Digital Research

