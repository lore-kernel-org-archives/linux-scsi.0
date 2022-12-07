Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C9FC4708D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 18:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLGSf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGSfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 13:35:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCDDFC6;
        Wed,  7 Dec 2022 10:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xGrZ2A6LtoANXj82VRH+GvOoFB6HWVWp86DPC/ZopIU=; b=Jsg1Wcy1Od758LNSTrvbbC98z7
        R7S30g9GlhIAaKK9oLh2FTYrAGAcKI+5WO9G41XfmVOrh8KDCJw/JbiBGSRp3W26rsz0Hzenhbd1H
        FE0jsI0OqVJb8QpKtKeT9Pz3+ZIozwBSwQuPZ2sB0IdOov8I9622YWxaEJvsJeMRkPO9owDE00zRP
        PVRvghT4Y562Zul2Mu0M04QUF4c706nQhlFE1qUYU6t27jNjuMzK/IaM92Nl2UWir6XiTi8hqKzH1
        m/GVpYxCfvezNJXi3CR0PH+oKl0VBOJBa6Jd8Cp/AtGk6pgFN7puDw0GuXM7aoPf5tmVRgI30oNmF
        Qd1hv7RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2zGN-008uAH-JM; Wed, 07 Dec 2022 18:35:23 +0000
Date:   Wed, 7 Dec 2022 10:35:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Nikos Tsironis <ntsironis@arrikto.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
Message-ID: <Y5Dc66mOzBfBhUGY@infradead.org>
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 12:29:56PM -0600, Mike Christie wrote:
> I think you need to make this configurable.
> 
> If you use loop with pscsi, then the sgl that loop now gets might be too
> big for the backend device so we now fail in:
> 
> pscsi_map_sg -> blk_rq_append_bio -> ll_back_merge_fn
> 
> So some users might be relying on the smaller limit.

Note that this could happen even now, you just need sufficiently
horrible hardware to pass through for it.  But yes, for pscsi
this needs to look at the underlying device, and increasing the
limit might be a good point to do that.  I'm not sure it's worth
to add user configuration, though.
