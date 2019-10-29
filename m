Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C5DCA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E30208E3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 12:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="t7JjoPEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfJ2MNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:13:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44861 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfJ2MNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 08:13:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so13343438wro.11
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 05:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=XYis85XXQhcd2SkQXzhhTcjdkLmbB4AJeu/17MYU70E=;
        b=t7JjoPEwPSSydswS392SYh13NcpoFMCqxk453K0LxF2N+BbcpCwncngTLztjwptqnN
         DcdVEGmykDPCydMbW2YwSvf5RlGoEPPKtYiPCbAgNULnfEYodbvxYq2Pi5k/Cunw5Jmr
         eW6nFyQBoHoUSeErDkefQf39fCX0/34vFmRueybkqpdIw+qdVm3Jysta6U0S15jXl7yy
         plustJSkpG3dGL0X/JtD3CggTDq6s4AMMY25L8xtWSj25ni4M7wZ1xVUwv/MQIOXMxeb
         QbHWCxrn4iatTv1tVFVFpY0tZU8DVD8bLN6TkuWEPKxUxTSVIyALF+y5LXI/d7Z+ogzb
         rIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=XYis85XXQhcd2SkQXzhhTcjdkLmbB4AJeu/17MYU70E=;
        b=Pcmqcb0VflH1HcaL9XgIJwWUjt7uLs8k+sIGeodyisuk2WQJ+bQ89FIOsInOuH566r
         XcJED3VcpN1rC4EWp5un8aTT1tUabXDSroJ6LzHqc2bFVn7hM83bTLlH18do18nTYLCX
         11c7vq9R8cx7RJG5kPSbTRasHGGrmedEzlGojSDFpkErCfADMcAUrHejl5xCQCWHUE/d
         /H9Hv/UEQl9Z8dVIfKswnDYI8W9bjEzIrA/wN8p/RPhcCNVuWdsRJPqoNsyKIgdmc+OB
         xoyOFyrZdLWDTbdHfGIfJm02+zpgJ1z3zWtjh7aJIPNaJMoh6dT8nwd3J65a8krd5Ry5
         t6SA==
X-Gm-Message-State: APjAAAX0sRN8KoVuf2VHGOj+ev8DeSKkHO3ARScPqeQhdx8vlxpFcn7K
        Y4DoA6D1UibwCFSrhaLu+9hOlA==
X-Google-Smtp-Source: APXvYqxYNZl6KADg03qJIEP+vtpqMpRTmeTJBC0MGbnAV8ZdmD8Gf4I3Y1BqR0OGyyksPz3If0R3Cg==
X-Received: by 2002:a5d:6203:: with SMTP id y3mr19765135wru.142.1572351198151;
        Tue, 29 Oct 2019 05:13:18 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id p1sm2533019wmg.11.2019.10.29.05.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 05:13:17 -0700 (PDT)
Date:   Tue, 29 Oct 2019 13:13:16 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Message-ID: <20191029121316.o7o7cjurn6qp2gse@MacBook-Pro.gnusmas>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191027140549.26272-2-damien.lemoal@wdc.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27.10.2019 23:05, Damien Le Moal wrote:
>REQ_OP_ZONE_RESET operations cannot be merged as these bios and requests
>do not have a size and are never sequential due to the zone start sector
>position required for their execution. As a result, there is no point in
>using a plug around blkdev_reset_zones() bio issuing loop. This patch
>removes this unnecessary plugging.
>
>Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>---
> block/blk-zoned.c | 4 ----
> 1 file changed, 4 deletions(-)
>
>diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>index 4bc5f260248a..7fe376eede86 100644
>--- a/block/blk-zoned.c
>+++ b/block/blk-zoned.c
>@@ -258,7 +258,6 @@ int blkdev_reset_zones(struct block_device *bdev,
> 	sector_t zone_sectors;
> 	sector_t end_sector = sector + nr_sectors;
> 	struct bio *bio = NULL;
>-	struct blk_plug plug;
> 	int ret;
>
> 	if (!blk_queue_is_zoned(q))
>@@ -283,7 +282,6 @@ int blkdev_reset_zones(struct block_device *bdev,
> 	    end_sector != bdev->bd_part->nr_sects)
> 		return -EINVAL;
>
>-	blk_start_plug(&plug);
> 	while (sector < end_sector) {
>
> 		bio = blk_next_bio(bio, 0, gfp_mask);
>@@ -301,8 +299,6 @@ int blkdev_reset_zones(struct block_device *bdev,
> 	ret = submit_bio_wait(bio);
> 	bio_put(bio);
>
>-	blk_finish_plug(&plug);
>-
> 	return ret;
> }
> EXPORT_SYMBOL_GPL(blkdev_reset_zones);
>-- 
>2.21.0
>

Looks good to me.

Reviewed-by: Javier González <javier@javigon.com>
