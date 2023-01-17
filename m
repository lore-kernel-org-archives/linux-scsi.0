Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE4DC63797
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjAQHMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbjAQHMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:12:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D45323308;
        Mon, 16 Jan 2023 23:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Oe62VrihQAGSUQ6IyJqXdQKjdGmWxWkhJYEXnz4TpbY=; b=o8DlPgf/QU5ANtIqihgtOA9JQQ
        nIKCno4mUiypVhgr2ihX2m1Ant5DQEoe5H/usvZrKBrkSu3Fxxzh7XZdwnNEfysrh/PtlQcoUQd1N
        fGTZrNhn6wxlGwVGUnLIB0AVVBYQctOeKv8sMBo7qrd6LSn2Ay9PYbmeF4fdLLqRPm7VgM8uK8me5
        EX/sYU9xyS9PA7ivr/JXRdtULxVAQIihqD0TwZ0XN1U+zrwzZRdQLJbURyedtZSz9tLJ/oYFNqoLG
        0fxHpeEqbrwumaMG7EGYBLUapZ/zZh0jo98q/6yo5tTMMFpPtNQvO1Xee97nd1pOXHMLFM2eJ4onq
        c2kIyIDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHg8o-00D8nW-E0; Tue, 17 Jan 2023 07:12:18 +0000
Date:   Mon, 16 Jan 2023 23:12:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not
 set CHECK_CONDITION
Message-ID: <Y8ZKUnVtxlpOzXKR@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-2-niklas.cassel@wdc.com>
 <Y8Y6/xa3thf4/UNy@infradead.org>
 <04ab7f5a-9ba2-09f3-7aff-61cde2696d25@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ab7f5a-9ba2-09f3-7aff-61cde2696d25@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2023 at 04:10:15PM +0900, Damien Le Moal wrote:
> >> +			bool check_condition, u8 sk, u8 asc, u8 ascq)
> >>  {
> >>  	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
> >>  
> >>  	if (!cmd)
> >>  		return;
> >>  
> >> -	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
> >> +	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
> >> +	if (check_condition)
> >> +		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
> >>  }
> > 
> > Adding a bool parameter do do something conditional at the end
> > of a function is always a bad idea.  Just split out a
> > __ata_scsi_set_sense helper that doesn't set the flag.
> 
> What about passing the SAM_STAT_XXX status to set as an argument ?
> Most current call site will be modified to pass SAM_STAT_CHECK_CONDITION,
> and we could add a wrapper ata_scsi_set_check_condition_sense() to
> simplify this most common case.

What's the point of that?
