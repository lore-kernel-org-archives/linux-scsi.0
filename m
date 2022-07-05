Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2880C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiGECbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbiGECbA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:31:00 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1660024E
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988259; x=1688524259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2hn761/VM2mO0Ez6uD50tfK9rtJFq6flc+B4e+Bf4h0=;
  b=rt0Jo4Y1O4c/EfTi+du4wHYo56DFzQ+pNjgYfwMzmqrZ2UaEXBv8WQ2R
   5ArK7LEr5U6/xrLfVJO1/9P9G2EyeD8qUqSDOSnjPlAkUfJLUZmsqWOt+
   t7JgDbhFPaj9gtZZKVPTygjGBKnUarMszoeDinx5F7h3ggrQJf6AynuXa
   IZjJnaFfhfgFkU950O3pVKrftZoSdY6Mfal0Mloo0ORHpBF33EjGfP8zo
   bw/x//h5uvvGypL63MUP3fai+lo6ry4T1A5q4tllQISqTzkNl4ggm2FcZ
   jgaPT149sbokbXcXJiARKdXPh49EVo3oks63Kj9Ygc2Vb4+rzPUubEsEG
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="204806443"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:30:58 +0800
IronPort-SDR: s9XN/jYihkl/kGklj+k5mBB/hncK3q1IF8LKpPEaKzmcrdZzxMj3Lw8miimPfgVLR/xV0gZVfN
 YIdpo3or7bQZTx2L9bFXv4oeg6ebWcDsKVUWBUnChrtF9zEr8SPyhv3aqbyHex4oP2BELTo3m9
 tvhgzDw1VfVAcMiyWRkl3OxuXRV4cq7re7whEVaDNfdPZ5AAPzmFwM0u7KnfKadinVb0dkTrBc
 S6htTkzeEE8SD4QpwItnLeYfZ92Asv/t4zG5KiD8L3yCPIW1vaaOhUSzde8HD2r+CfE8Y0Owhd
 x/JSNTtHDmr4aIgRsXgGQFlW
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 18:52:50 -0700
IronPort-SDR: 2i+8ZYe3OvYBYq05qQTYH6Zm7F9uHyM+9rSiDnjGjb5mydLJRt3oCBzcpKEOBsB5cQ2NfU/+m/
 t/a1MpwPPU1WTrvHxB7L0lsdCVNIBlUuP67l1OOLcjaBhZt6IqyKfybEpDxT37mM2/fFXlviCr
 ZkCa2gVlTnRLCLvpi7ojA0WIVc2SHWSgTETdPRfxf/8hPRHLMRXm+/xOwm/pyRluvR9VsKJ/e+
 qCIwVl47UUjVFDiHM4D4PNduHI9IyMTSo3IFdleh2PxK8hONI3KJPIXfjNRIMaoyWJatLHBjIN
 hbE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:30:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRVp3Lktz1Rwqy
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:30:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988257; x=1659580258; bh=2hn761/VM2mO0Ez6uD50tfK9rtJFq6flc+B
        4e+Bf4h0=; b=S0P2HSjhX66Iv5uNELmmr0DsQ6e1N2N94PZusn9ZwOQ4Qo6tvfL
        9t2FVsVm24Jckjfdx7LvTALN//OdAOTEQIYI2p1s5ue78H7sb7iT+hUYOj2VB7wv
        TNgiDEY353oh60p/qO5YdGFrjDTT8NAIUFkynXsjDcR5Bm1OPuD0yk7uct5yOX7y
        F8jZv5x3gbj70SMbM9jbev8vMyIUcw1qx9WeuUFJvumPbi0nHBC4L/C49VB0j6qI
        E+zaNIyJ8zJiHO+Zg6M7OyUXWjZDEN63n0fnJDW5MMC2XUye8vGnIsoFKSxHKqkM
        iFiIKQ19zWhlP7JkL5kDinaJiGymE6zzZkQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f3lWai9T6YD3 for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:30:57 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRVm5SzGz1RtVk;
        Mon,  4 Jul 2022 19:30:56 -0700 (PDT)
Message-ID: <36284d54-bb3d-d77b-cc30-1759e897478b@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:30:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/17] block: simplify blk_mq_plug
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-5-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Drop the unused q argument, and invert the check to move the exception
> into a branch and the regular path as the normal return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c  |  2 +-
>  block/blk-merge.c |  2 +-
>  block/blk-mq.c    |  2 +-
>  block/blk-mq.h    | 18 ++++++++----------
>  4 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6bcca0b686de4..bc16e9bae2dc4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -719,7 +719,7 @@ void submit_bio_noacct(struct bio *bio)
>  
>  	might_sleep();
>  
> -	plug = blk_mq_plug(q, bio);
> +	plug = blk_mq_plug(bio);
>  	if (plug && plug->nowait)
>  		bio->bi_opf |= REQ_NOWAIT;
>  
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 0f5f42ebd0bb0..5abf5aa5a5f0e 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -1051,7 +1051,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
>  	struct blk_plug *plug;
>  	struct request *rq;
>  
> -	plug = blk_mq_plug(q, bio);
> +	plug = blk_mq_plug(bio);
>  	if (!plug || rq_list_empty(plug->mq_list))
>  		return false;
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 15c7c5c4ad222..dc714dff73001 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2804,7 +2804,7 @@ static void bio_set_ioprio(struct bio *bio)
>  void blk_mq_submit_bio(struct bio *bio)
>  {
>  	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> -	struct blk_plug *plug = blk_mq_plug(q, bio);
> +	struct blk_plug *plug = blk_mq_plug(bio);
>  	const int is_sync = op_is_sync(bio->bi_opf);
>  	struct request *rq;
>  	unsigned int nr_segs = 1;
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 31d75a83a562d..1cc0b17d69229 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -294,7 +294,6 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
>  
>  /*
>   * blk_mq_plug() - Get caller context plug
> - * @q: request queue
>   * @bio : the bio being submitted by the caller context
>   *
>   * Plugging, by design, may delay the insertion of BIOs into the elevator in
> @@ -305,23 +304,22 @@ static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
>   * order. While this is not a problem with regular block devices, this ordering
>   * change can cause write BIO failures with zoned block devices as these
>   * require sequential write patterns to zones. Prevent this from happening by
> - * ignoring the plug state of a BIO issuing context if the target request queue
> - * is for a zoned block device and the BIO to plug is a write operation.
> + * ignoring the plug state of a BIO issuing context if is for a zoned block

s/if is/if it is/

> + 8 device and the BIO to plug is a write operation.

s/8/*

>   *
>   * Return current->plug if the bio can be plugged and NULL otherwise
>   */
> -static inline struct blk_plug *blk_mq_plug(struct request_queue *q,
> -					   struct bio *bio)
> +static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>  {
> +	/* Zoned block device write operation case: do not plug the BIO */
> +	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
> +		return NULL;
> +
>  	/*
>  	 * For regular block devices or read operations, use the context plug
>  	 * which may be NULL if blk_start_plug() was not executed.
>  	 */
> -	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(bio_op(bio)))
> -		return current->plug;
> -
> -	/* Zoned block device write operation case: do not plug the BIO */
> -	return NULL;
> +	return current->plug;
>  }
>  
>  /* Free all requests on the list */

With the typos fixed, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
