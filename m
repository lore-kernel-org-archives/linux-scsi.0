Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09AFC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E03F20665
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mt3TJsTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHLOfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:35:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45704 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfHLOfR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rxj0ehnB3Vqo57RxeDekMqbg2gFg6t1VrSJjHcLlnl0=; b=Mt3TJsTH2vQGi/rBEUPtunoAQ
        gKeZtIkvbiksYN6DVR/yFuVnvElRJSfsxxIWP4Pf5lpyAfWFuNHhPCaxv39HbsrPUoqVXaAV3lObm
        ZmKAhlQV9kNzHxQnTY2dPFP2qf/genCXF0zbLdQAHPn1pRRaZfPrrWHzP9YzZFTBIMLb4ftfRcldq
        kY2LLRMyWhs9mc2pAD3FN1B8hxT0fPioTCRTeDygscnEn4gQfZfSCceHRe5M5WRBp4/nsMQXah5zD
        d3PMONmaAuGcuQZ1OW/gXcfXVux/soNA3lXddM1ql5fg6zjKfTyqhHHBiOL6Gsohu43FX93toBOe6
        ChoQIIzBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBPo-0003ec-SI; Mon, 12 Aug 2019 14:35:16 +0000
Date:   Mon, 12 Aug 2019 07:35:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 11/20] sg: replace rq array with lists
Message-ID: <20190812143516.GD16127@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-12-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-12-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:43PM +0200, Douglas Gilbert wrote:
> Remove the fixed size array of 16 request elements per file
> descriptor and replace with two linked lists per file descriptor.
> One list is for active commands, the other list is a free list.
> sg_request objects are now kept, available for re-use, until
> their owning file descriptor is closed. The sg_request deletions
> are now in sg_remove_sfp_usercontext(). Each active sg_request
> has associated block request and scsi_request objects which are
> released much earlier; their lifetime is the same as it was in
> the v3 sg driver. The lifetime of the bio is also the same (but
> is stretched in a later patch).

Willy would probably want you to use an xarray.

> Add an enum for request state (sg_rq_state) and collect
> various flags into bit maps: one for requests (SG_FRQ_*) and
> the other for file descriptors (SG_FFD_*). They join a
> per sg_device bit map (SG_FDEV_*) added in an earlier
> patch.
> 
> Prior to a new sg_request object being (re-)built, information
> that will be placed in it uses a new struct sg_comm_wr_t
> object.
> 
> Since the above changes touch almost every function and low
> level structures, this patch is big. With so many changes, the
> diff utility that generates the patch sometimes loses track.

There seem to be a lot of rather unrelated changes here.  Also
please don't use __put_user/__get_user for that same reason that
drivers should not use __copy_to_user/__copy_from_user.
