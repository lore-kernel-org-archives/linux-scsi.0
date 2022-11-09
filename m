Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58659C43219
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 12:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiKIMfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 07:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKIMfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 07:35:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE914175BA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 04:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=btVed7kFbEych2ZX4eeTjPrBEcS0t4WUaf7Rl9XRxdg=; b=w9UHQjJE5RrcoZDI3iXjVj3ZW3
        p1lmKULVZjGJcJwoBBUVw9GCVLv0WwUZe2wPs4QNHJ+frs1kzpAWNefCqIKFYzoH9bEoU+uUP5jhb
        0lbANYtVtCz/V7YvfMICvUkN7f2vpniOj8aDjbKF3sP2WsM9N/eLfyBl98CE/euhh0TIO4Bjqfohl
        QEPiOkXTnCp5I3vYUZkV/qulkMHI9iMDJKmhT4aO4aLxxdcfAgNlYxenf3ST7sXOifrM9M4Sqy9sg
        ipiJ30bGK4V2FwhrdJsiTEJF7BGe24sEUP557afHPfONPhFCaMuVakyuaeVhpOgFz/NDsKImVDQV7
        oNn40viw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oskIE-00DPvl-BF; Wed, 09 Nov 2022 12:34:58 +0000
Date:   Wed, 9 Nov 2022 04:34:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Message-ID: <Y2uechJH/4GFDs8h@infradead.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108233339.412808-6-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2022 at 03:33:39PM -0800, Bart Van Assche wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Modify the UFSHCD core to allow 'struct ufshcd_sg_entry' to be
> variable-length. The default is the standard length, but variants can
> override ufs_hba::sg_entry_size with a larger value if there are
> vendor-specific fields following the standard ones.

There is absolutely nothing 'vendor' in here, it is all implementation
specifc.  I have no idea why no touching ufs can grasp this.
