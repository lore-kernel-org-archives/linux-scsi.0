Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A11C678D4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbjAQHXv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjAQHXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:23:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C0C22DC1;
        Mon, 16 Jan 2023 23:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mP0AUaBG3JoYrfmpU3YWzGPO9M8Q4EVpcAHPp2EHRVo=; b=YNnuHMgDgH+L/XTPaqqM9Z4Cmq
        HfysCqnoI+wqaO/z1CPZtULdpbCh6YWCOYOBuV5Q5KCPb097vKst4wmE5IkgqF/0GWeSEFAHGok/1
        U5PWREYahrRdKbEZTZxTX1G/rytpZurQjYDrGbsxcu+ZPfO5G4w7T63Av/MRyuYqhg2cK9CYp+ho/
        mC4O0Xu49m1tAE2a6DZU9mnwqDo7F2IP1MR6QgV2Wi6LblMtIHTgYLeB1N6f2hXvhm/3Xoxoxc7WF
        x6y7thyMPI4GliQLnwF+3wLT3EvNG0cdiNrtcOpHk2xp3mfifH+TPAaNeZ2kR7sCxpTjmvq3eeIOF
        pl2ZJl7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHgJu-00D9Xl-IC; Tue, 17 Jan 2023 07:23:46 +0000
Date:   Mon, 16 Jan 2023 23:23:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not
 set CHECK_CONDITION
Message-ID: <Y8ZNApPCqcueEd5U@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-2-niklas.cassel@wdc.com>
 <Y8Y6/xa3thf4/UNy@infradead.org>
 <04ab7f5a-9ba2-09f3-7aff-61cde2696d25@opensource.wdc.com>
 <Y8ZKUnVtxlpOzXKR@infradead.org>
 <b1c381c4-5bb5-f697-ef35-686edb1404dd@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1c381c4-5bb5-f697-ef35-686edb1404dd@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2023 at 04:15:01PM +0900, Damien Le Moal wrote:
> Trying to get to a pretty solution keeping a single line for setting sense
> + status. But sure, splitting out the status setting works too.

I suggested just adding a wrapper above.  And while I tried to white
board code it here in the mail I think we can do even better than
that, and just drop this change and just open code the call to
scsi_build_sense_buffer for the CDL use case.

While we're at it:  That !cmd check in ata_scsi_set_sense looks
really odd, can someone clean that up and just remove the calls
where there is no command?
