Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E84C636CC
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 16:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjBPQvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 11:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBPQvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 11:51:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2812E0C6;
        Thu, 16 Feb 2023 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z9L7OCl80jb/hsDN+Rhd6bi9ZPLuBsktXXs5P51q8gc=; b=Abvdt4oGV67A4jZOHInLWy0FHB
        +lVGU1eSMWLSsPafncfnzdZtCy7zn/NSyC8+XnXPmu3RWEeftbAZF0W9A81tUPT8trBF2YkNa2pPW
        hfA9w9PjdGhMNtbE6RmHrT0WXhXMlOoBqSF6ZzIK17dNTkF5iU+WRud5nb4PBOnzPgphu23PFU/Y1
        jmFzNyhgRe5nHsdSnh22iZTuNNAdfqJrsLyknTRAtITVV2zfvADUoJqjQs+G7TvUOmHHm0U1LMyaF
        UcyEfZKIzeyM3f7PZGuMn19GR89QpVpVpFFDD+PeZYi6IrYAfN5/Y7ntAkZtDpGrbeANM8xZc9mto
        h448PoFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pShTw-00BGP8-5V; Thu, 16 Feb 2023 16:51:40 +0000
Date:   Thu, 16 Feb 2023 08:51:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Li zeming <zeming@nfschina.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: Modify the kmalloc allocation flag
Message-ID: <Y+5fHPW/OXhfOqjv@infradead.org>
References: <20230218005356.3932-1-zeming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218005356.3932-1-zeming@nfschina.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Feb 18, 2023 at 08:53:56AM +0800, Li zeming wrote:
> The inq_result pointer must be allocated successfully; otherwise,
> subsequent function execution may crash.

The error needs to be handled.  Or in fact this LLDD needs to stop
breaking layering and issuing it's own INQUIRY commands.
