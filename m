Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7AEC61DA4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 06:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjBCGa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBCGa2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 01:30:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDB023319
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 22:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B3ouCU203mTGL39hTIB2dmqc19np6Wgvfugc2U6IcQA=; b=3SgU7lNvi/z/FuDWeGlLGoAenj
        LoHN0bplniecIfckhOSg+EMTmiP6/Y8UYKmlnpc/vwyYO1Ch1S+oIlGGNZ6Q0ymil4wRYiIkHH7Kq
        Sqm14Z2jTkohIt0j8RCZdniDi9rOk3AXPcyoTZoSroJ0xBCXJmj9luQNvHLUoqOrLP09j3JulD8Fg
        nV7l0nwKuF6mhILzbOAPyJUiWeY9Lh/8YhPl+eDyoYx7YKRhCD1wgawOhD4dnZMkOICLREuBtKGO/
        BMG97pKKs4iRBUWPHgXkP3Zh/I73dd2d1BhCsv59lMWdorVKR9fY8xYOL2S8FIJdyQgrKvrq4biaw
        kDGRrtTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNpaS-000Zi1-L5; Fri, 03 Feb 2023 06:30:16 +0000
Date:   Thu, 2 Feb 2023 22:30:16 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS
 devices
Message-ID: <Y9yp+H1qkuAxrB8j@infradead.org>
References: <20230202220041.560919-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202220041.560919-1-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2023 at 02:00:39PM -0800, Bart Van Assche wrote:
> Hi Martin,
> 
> Measurements have shown that UFS devices perform better when using SYNCHRONIZE
> CACHE instead of FUA. Hence this patch series that makes the SCSI core submit
> a SYNCHRONIZE CACHE command instead of setting the FUA bit for UFS
> devices. Please consider this patch series for the next merge window.

NAK.  This is a policy decision that might make sense for current UFS
devices.  If you want to do it use the sysfs files from udev to quirk
it up for them.  But there is nothing inherent in the UFS transport
that speaks against using FUA.

And please lobby your suppliers to either don't claim FUA support or
implement it in a useful way in the future.  Unlikely most of us you
and your employer actually have that power in the market.
