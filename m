Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D513C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiGECkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiGECkw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:40:52 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9156A11153
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656988851; x=1688524851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=989zBONpd6lbkl0CE+LWDcNz1wqrb3C//HCnh1qmPLg=;
  b=ao+mW5UrVEzT+lUc3repfPng0FnYQGVONajrm0zx5+TcV7o6BL3LMvDn
   mC0lyhsuOIkT/lxukx3sMgxtUw3uVUJp+3hgLhHlGGw3VnmCjXGNfMtEe
   Z6+cVPx4/HolOkxRD/X6bBqCLngYF0OnDUh4IGRDOyj7spNl5sUjfjOCD
   oKJ1W7RCNq2FKGdYnx/HLOrtFYP19I/eMugQDAZ9yShIzMq6KE5vUs2/T
   xhbnyT9RycY68fe7SLnNM0OcwL9si2VhKHtQ1N8AU1cIp3IkqoHyYOSDb
   PIdKUA4V8SxNg2MGA4fvMuhaSTart4wL2BIpdraJJekAKWNi2Ed7VpNda
   g==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="205520082"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:40:51 +0800
IronPort-SDR: byNs9vAMNnkDNvrqdZS+8fntGVylxhbCtVd27ebsQFyItUm5ZEa4A4nFxodJwVqYwFRvY9FKvP
 jq28mHSIFtqdKYWnRCkMIYlivkIFhpGssY0+WllUtPcpj/3uibs6AfMGpPcQ8ObverlAWihls+
 ltOraBjaouC8RuyQqNME54lDnVUEcuVZ6rC6UhAn8yEMI/clWC15/t6g0yWtswCh/Jmwf0i/oz
 8IUDo8SnD+5Y7XVbACxUBao9XYG1co1biTYHYd/i86N+b4iedXIYuytRxwCWQuNQTFonl8oy4S
 tniPmhC1hPopSfDrBlqJUOQX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:02:42 -0700
IronPort-SDR: 8wjPhvJ/tWr30Wv9KUQ5oKSNrjAsmqBbEOVPDW2zVs3dfuatYI6Lw4s4bDxDjo6rgmBLeY4XYi
 5ZJtW+iQugy9hUqUVmTe+Z80dSuhazhrPgJX1lkfnNllHvWZWd9PVAKR7x/1w2nf+haM1v9RXF
 5yfXyWHtfYThek5p9D5PcjIcZqk9zrAvIbCHsPgX27GT+yQ+FA2bF2IXrEsk3ALpvab0ZxMetZ
 u3BGGmAj7pM1a3E+xoGAiRsObL2IJzFa72JW1qgvqU3jmnH5ihxIzCACvjNWfoIAnuYe6rMU/I
 dx8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:40:51 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRkB5zj0z1Rwnl
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:40:50 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656988850; x=1659580851; bh=989zBONpd6lbkl0CE+LWDcNz1wqrb3C//HC
        nh1qmPLg=; b=paDgPg9oId8zVLLFZw9dR66ws9BeKUZ+7UHToefYzTKjMIF7Ui4
        Lr/tTWbctO5OilyRIKvuWp7hI54vi3WU6ehYAN1LxXeA9ntNAXdKDO82iA5o6LZG
        Zb7CKRrEg9wkmTILvTofbfA1G6PLlM/McBq2bRXbi8t3AJYOKF4Cz5niaBCU5Dtp
        slxC6s3it7Q/gMaqrl9xfwOfOqU1UkSySw4Gt+9ZjkBKS7I5hf7+TWMekA0D5mfY
        7fHk4C43m65CxxTCiZ4TEPZ8B7ap1/PS7AP3pDcFf5o/dk3+TNve3NzJ6gS02Hrj
        YesqinqMPs76FpY8C0a65eEL25AxXOUI4mA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7Ogm7S3EOTik for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:40:50 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRk93N6wz1RtVk;
        Mon,  4 Jul 2022 19:40:49 -0700 (PDT)
Message-ID: <71dae34b-b5fb-e3d2-941a-0dd0836e542d@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:40:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 07/17] block: simplify blk_check_zone_append
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use the bdev based helpers instead of open coding them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index bc16e9bae2dc4..b530ce7b370c4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -565,7 +565,6 @@ static int blk_partition_remap(struct bio *bio)
>  static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  						 struct bio *bio)
>  {
> -	sector_t pos = bio->bi_iter.bi_sector;
>  	int nr_sectors = bio_sectors(bio);
>  
>  	/* Only applicable to zoned block devices */
> @@ -573,8 +572,8 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (pos & (blk_queue_zone_sectors(q) - 1) ||
> -	    !blk_queue_zone_is_seq(q, pos))
> +	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	    !bio_zone_is_seq(bio))
>  		return BLK_STS_IOERR;
>  
>  	/*

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
