Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDB5C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiI2CJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiI2CJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:09:44 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219B12D24
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664417382; x=1695953382;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UePg92TmQirppI3fLER8oTy0F5vGd/zU7VLVsuGJ+60=;
  b=IymH++R+oeZV8Uo4J8ueJIwsKFBH9DYWg817T3UtEdxRQRGGVjnE+Mnc
   vhjz9bXj22chrP0zuqjufTP/Mo+WKvgDHIluOsOIMoup3l1cYfrBMypQk
   NekpIVkfOQTxpmdQwA0aljJpfppSOv7WRmk6L+tgpcKsDQd9oRHdmbI3g
   1mnVF0cK3+16bji7q7t65fAIR96AYs+ZeTfYDZ1qmpv+5Yx11ShhhdFRV
   ktUCuwH/f2T3VPWseMUoi75qovyw8Sg9ub5sRwsuo64a6l7tfqlfuZKR/
   8Oq+r/BANSZTBWQkFxQotpaM8+Yj9n4aTiwnhtRROCt5C6j/lwJYXgakD
   A==;
X-IronPort-AV: E=Sophos;i="5.93,353,1654531200"; 
   d="scan'208";a="212540170"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2022 10:09:39 +0800
IronPort-SDR: NZcFsj45MD0529/YWG14QytI2pWPhbaM8t88PG7YG9oMGL2zCdj4ZyUzSl93eBq6p1ExpM5nBi
 iRzneJehv+dNyQDhdOvdF32asOi4nT0qeZ6C8KkYanRMCT606QnYhGAwfJoIbsQPI/pW4O9mnH
 YM2xdHINJYysHqlXJnFRIjIoWW2KERIgIrODtl8NByGb8+fPCD2nshdY8jWJcHtI2p+bAf2zyq
 8mMMfmpsjYTVK605DLW41aCPheXWk97e6DaHiLhzdJuba9kU93coFboIrX0OZsuBcRkS9hijE/
 zd74tnfKFT4IHA0k2DXA9EWl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 18:29:35 -0700
IronPort-SDR: mOkwFRgqe7K4ydZaSyrETxKiO2JgH6B31SXhE18Vgj8fTS05h95Q7y0Q6R7p/FlgIY4j0RSE93
 xflFYrliRzKHmwjnwC6+LBJtifoX1+V2tkjeGm3UQvkSqtM71mjYHsLJNYAJAi932AHz0I2Q24
 2BJvzV/q6FCCDBE919d7IeGCfeqTdrQhY0fWB1vH3HPHsZzeQUwDnZTgqWgxhb0AHrsbf6Dmrr
 qonEbXDD4S/IXGGR5InbzrK0TU9Dz4fp6YrkU1WbGPryhWvvJ+igIC+JrGYjZA8aL8E8kyvRxx
 KR8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 19:09:39 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MdGyW12tLz1RwvT
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:09:39 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664417378; x=1667009379; bh=UePg92TmQirppI3fLER8oTy0F5vGd/zU7VL
        VsuGJ+60=; b=oTuOwkz/6D3sY84sla1wrNVLi37KJq23/Gf9FMfUcXNN1qNSoN9
        eE5wEtPuHlfnMsPKjLrp3okD7CzojRh83fYwuoEFQyF9F9SzGDZioFpG6IRSD/gF
        PWhBzDQgIfvGWK52/xHC2QPdUjrx1Sees2LDMAfRcIi5nsn+Gnnwsrt+C2heQDEr
        KKJowu5huCFN5fZkJ+O+cVKfI2zk0OiIO96m2D/mXa7tE8AbhL7d1KdZrzcwDRqF
        fzyKaPsHmeeU0cGvn60sZQhCSAYe/CWALn7ulXG3Lc7OBjZG5K+4TrXDH6CR40IJ
        SYFPVai/8ODd1FhhZfPtSPaxUEzC+qDOl5Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3O83OcgfezTQ for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 19:09:38 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MdGyS20pzz1RvLy;
        Wed, 28 Sep 2022 19:09:36 -0700 (PDT)
Message-ID: <0c0306d7-2645-874a-9745-8aa5dcfeede1@opensource.wdc.com>
Date:   Thu, 29 Sep 2022 11:09:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 1/6] scsi: libsas: Add sas_task_find_rq()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        damien.lemoal@wdc.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        ipylypiv@google.com, changyuanl@google.com, hch@lst.de
References: <1664368034-114991-1-git-send-email-john.garry@huawei.com>
 <1664368034-114991-2-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1664368034-114991-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 21:27, John Garry wrote:
> blk-mq already provides a unique tag per request. Some libsas LLDDs - like
> hisi_sas - already use this tag as the unique per-IO HW tag.
> 
> Add a common function to provide the request associated with a sas_task
> for all libsas LLDDs.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  include/scsi/libsas.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index f86b56bf7833..bc51756a3317 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -644,6 +644,28 @@ static inline bool sas_is_internal_abort(struct sas_task *task)
>  	return task->task_proto == SAS_PROTOCOL_INTERNAL_ABORT;
>  }
>  
> +static inline struct request *sas_task_find_rq(struct sas_task *task)
> +{
> +	struct scsi_cmnd *scmd;
> +
> +	if (!task || !task->uldd_task)
> +		return NULL;
> +
> +	if (task->task_proto & SAS_PROTOCOL_STP_ALL) {
> +		struct ata_queued_cmd *qc;
> +
> +		qc = task->uldd_task;

I would change these 2 lines into a single line:

		struct ata_queued_cmd *qc = task->uldd_task;

And no cast as suggested.

> +		scmd = qc->scsicmd;
> +	} else {
> +		scmd = task->uldd_task;
> +	}
> +
> +	if (!scmd)
> +		return NULL;
> +
> +	return scsi_cmd_to_rq(scmd);
> +}
> +
>  struct sas_domain_function_template {
>  	/* The class calls these to notify the LLDD of an event. */
>  	void (*lldd_port_formed)(struct asd_sas_phy *);

-- 
Damien Le Moal
Western Digital Research

