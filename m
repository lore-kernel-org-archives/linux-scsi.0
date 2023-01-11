Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69748C46467
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 17:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239756AbjAKR26 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbjAKR17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 12:27:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EB44261B;
        Wed, 11 Jan 2023 09:23:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE0661D7C;
        Wed, 11 Jan 2023 17:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E63C433D2;
        Wed, 11 Jan 2023 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673457814;
        bh=YPJTvmpqOFvLLGZvozg87GvEW6KjgkohEJNtTFjH/P0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=daF9vOjcpZfTuMGOIKa4HtJyQWFJXwqkfJBZN/PuKVo7POx0S+Z65P9uF1EQH18hB
         /OO+X28twF3xtY8iyjYJXnH6yn0OtSCYwIzufTsH3Li6ODWDcDBMMRzshjiP1pgdlG
         yhDCnxHI240dYmmPJ8Dz3buhu2UTXemooBYdO09avw2LfMqHlT/OjcktU+wWyJTYfo
         2S6MZNxkwUrJTKj+NArVkmAV9R6YWyajtsmtEQOE/wgpMfqbWyh58agR9NNkdIlnxN
         NBppQMpj8Ar0ualacwQLmB2HMr895iVBSvGl0K7MDXKiEYxHTWg+J4AhiPpe31jdoA
         pvkTKvjBzRNIw==
Date:   Wed, 11 Jan 2023 10:23:31 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: SG_IO ioctl regression
Message-ID: <Y77wk6vQKsf6zC3b@kbusch-mbp.dhcp.thefacebook.com>
References: <20230105190741.2405013-6-kbuschmeta!com>
 <Y77J/w0gf2nIDMd/@x1-carbon>
 <Y77Vcz3dpll2WoV/@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y77Vcz3dpll2WoV/@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2023 at 08:27:47AM -0700, Keith Busch wrote:
> On Wed, Jan 11, 2023 at 02:38:56PM +0000, Niklas Cassel wrote:
> > It appears that this commit breaks SG_IO ioctl.
> 
> Thanks for the catch. I'll send either a fix or revert today.

The below will fix it. The code was corrupting the ubuf by assuming
iovec type when copying the original iov_iter.

---
diff --git a/block/blk-map.c b/block/blk-map.c
index 4cf83eae9f2e8..f2135e6ee8f62 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -31,7 +31,8 @@ static struct bio_map_data *bio_alloc_map_data(struct iov_iter *data,
 		return NULL;
 	memcpy(bmd->iov, data->iov, sizeof(struct iovec) * data->nr_segs);
 	bmd->iter = *data;
-	bmd->iter.iov = bmd->iov;
+	if (iter_is_iovec(data))
+		bmd->iter.iov = bmd->iov;
 	return bmd;
 }
 
--
