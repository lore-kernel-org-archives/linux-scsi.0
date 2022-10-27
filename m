Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895EAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 01:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiJ0BVs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 21:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiJ0BVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 21:21:47 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604C77E810
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666833706; x=1698369706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zlWp80+yvrKZBis+PLBfQmb9XO7Jhgd5T5V32e2tV2g=;
  b=r8AG0YFB9EICxrNnop1BG3MN7f39CQxzZvywne2V/QxUZ/BN1YjQOLSb
   0OmGYWNFhfb3xHh+RhLp8s7rXiPqZZI8Ja0EGzjWqY07eILZDZu+ovBDJ
   HeteJaG6swddmGQuqJpWvys1M/HfASAtYMP53HBvCupZzMCLpRpibKBkV
   /GzDC7Tav3J+s8JUOE0H0g5ZiQZ7HVun4RuK7gxglla6fCiLQx8+eCZOe
   BrfJZCF4wiGHMdVbMcO1RwoWqL4buHtnBLd4LYT3KDXFSCjzNVgAouhHt
   e/Ytsp/xRpa3dDN4GnVie+wNWtYEg7oygoYdujf00YoY2ICJUL8WQqhT+
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="214828443"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 09:21:45 +0800
IronPort-SDR: djcwDp7VjTxYD401/dfOYc4H8Z7T8cN9EdTYUZQlCd9/Vp3EEwyIIqdd2aqM+ee9uYd5cJ/ME7
 h1KWX0KocXVq+9+Gk/FqEetQ1yMyRgFe9xNlbYC87nhQHRG24Ozq109rjyyaFjQ5WzDGoApShH
 TawPLM+J++8LmJrrPMS4ZJXhii2lEwVbYyFgu6kO06O423BNxHZStyqrFCL0ecwF8E3Rw6mv5X
 xkuvbkx40sB4sSpRDAdTIuPSaohhgQv8zURm3bV/lvYd0oiArT9ERClKDK39e+ZM8RZFuwQ9fQ
 01z/4gFCoEB+CwIBebYicN9M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 17:41:06 -0700
IronPort-SDR: adhWxQSq05lPcrX9KlbmeXUgZmVOgT655Yz8kAQIrsYaqgtqaGztoTWGVhIyLRIl+Nm+XFwsro
 tgEMPW3FKx6Bgwn2mtR61Y7bWqTQSsjcgkVuirNBM+5M6dz6F/EfdACch4sYDMQYXz6UWvFhFZ
 uncBL2rZQ03fbNChHowXkjJjuXVJqiqCl/NlfmFlmO7EpuC6txxwcRbEPG67LVCFA1MYsyZ4xa
 SEVK0g4zs7sY10EQ4VOG0eeOie9FLH65U6pdxKOipz3aA0PQ3KgBJDsm95f5r5kpoHET0YcpV1
 FX8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 18:21:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MySZJ42Vcz1RwvL
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 18:21:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666833703; x=1669425704; bh=zlWp80+yvrKZBis+PLBfQmb9XO7Jhgd5T5V
        32e2tV2g=; b=qhjj5TKTJPjLQtNPy47LI6UCMauJm0ANFwKY9hqY9x04hBD1VmB
        1rjjBr/gaf3vDPfXO1wKZyjYP8vhLrLFYxzZh0aprP3IAj/PL4cF2foT/2xxfsqZ
        SXIf42BRIS/p70vF6NzwavgeUPbl58N/HMvwcCjJg5fik1K1CRXQM4YfYhl2oumD
        CqYParN25SnEI6xYzLeMumCP5gQt85iLs7EDGQQxC6lZJstNgJZaG+6fDVMJhAHL
        FU0rHyPnIOLcF3p/G2YZCWLcTMsysXbOqb0teSeht1qkRYHrIWz6CA4qL3LXGueV
        f4sLhwOrTheHaPqgvUsGsnOK72ZbBl7FxNg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lVLx0JDEEi9I for <linux-scsi@vger.kernel.org>;
        Wed, 26 Oct 2022 18:21:43 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MySZF1xJDz1RvLy;
        Wed, 26 Oct 2022 18:21:41 -0700 (PDT)
Message-ID: <c30e421e-9652-ebb8-9733-b286cb0f9f19@opensource.wdc.com>
Date:   Thu, 27 Oct 2022 10:21:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH RFC v3 04/22] scsi: core: Add support to send reserved
 commands
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@cloud.ionos.com, hare@suse.de, bvanassche@acm.org,
        hch@lst.de, ming.lei@redhat.com, niklas.cassel@wdc.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
 <1666693096-180008-5-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1666693096-180008-5-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/22 19:17, John Garry wrote:
> Add a method to queue reserved commands.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hosts.c     |  6 ++++++
>  drivers/scsi/scsi_lib.c  | 25 +++++++++++++++++++++++++
>  include/scsi/scsi_host.h |  1 +
>  3 files changed, 32 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index db89afc37bc9..78968553089f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -230,6 +230,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  		goto fail;
>  	}
>  
> +	if (shost->nr_reserved_cmds && !sht->reserved_queuecommand) {
> +		shost_printk(KERN_ERR, shost,
> +			"nr_reserved_cmds set but no method to queue\n");
> +		goto fail;
> +	}
> +
>  	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>  	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>  				   shost->can_queue);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a8c4e7c037ae..08015c42c326 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1428,6 +1428,16 @@ static void scsi_complete(struct request *rq)
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>  	enum scsi_disposition disposition;
>  
> +	if (blk_mq_is_reserved_rq(rq)) {
> +		struct scsi_device *sdev = cmd->device;

This variable is not really needed. You can call:
		
		scsi_device_unbusy(cmd->device, cmd);

No ?

> +
> +		scsi_mq_uninit_cmd(cmd);
> +		scsi_device_unbusy(sdev, cmd);
> +		__blk_mq_end_request(rq, 0);
> +
> +		return;
> +	}
> +
>  	INIT_LIST_HEAD(&cmd->eh_entry);
>  
>  	atomic_inc(&cmd->device->iodone_cnt);
> @@ -1718,6 +1728,21 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	blk_status_t ret;
>  	int reason;
>  
> +	if (blk_mq_is_reserved_rq(req)) {
> +		if (!(req->rq_flags & RQF_DONTPREP)) {
> +			ret = scsi_prepare_cmd(req);
> +			if (ret != BLK_STS_OK)
> +				goto out_dec_host_busy;
> +
> +			req->rq_flags |= RQF_DONTPREP;
> +		} else {
> +			clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		}
> +		blk_mq_start_request(req);
> +
> +		return shost->hostt->reserved_queuecommand(shost, cmd);
> +	}
> +
>  	WARN_ON_ONCE(cmd->budget_token < 0);
>  
>  	/*
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 91678c77398e..a39f36aa0b0d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -73,6 +73,7 @@ struct scsi_host_template {
>  	 * STATUS: REQUIRED
>  	 */
>  	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
> +	int (*reserved_queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);

Nit: This op name sound like something returning a bool... May be a
straight "queue_reserved_command" name would be clearer ?

>  
>  	/*
>  	 * The commit_rqs function is used to trigger a hardware

-- 
Damien Le Moal
Western Digital Research

