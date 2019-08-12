Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD97EC31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74B3920665
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dt87chjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfHLOba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:31:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHLOb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SmeI836gs+r9TqaOIp+SuoHB1RLK2L5u07BK1n0O9IM=; b=dt87chjsIWFhhTEhYDEzLZj7O
        1MsV6BMJlphjUQfv/DHn2cWOFqtDzpyMECrCOjz8euiznG901MomdynT28C3vgnqAUXRBR7aM+N3z
        Vt9Iu+D2u3ALW6iqoMmJIfH0GaH3RZRn0aD1ATNk0uhwh7bMI5yE5TszotnDfVJHNM2sk39GEVvbk
        ngGVX/43ZVJ5PQ/T/MidyPaLes6hYtW+Eijtq6qbg6XjW3VGC0/1lu4DM+7WOynI+l0dEsYaC9LFR
        RWNHLTquPAcYoVpiAr/nYE87/y08zApAXyo6c6CWG25UqRGukTyvaYhOzTIneC8jO8kUhqIfn1OAX
        C3PrRsvsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBM9-0002BN-Kq; Mon, 12 Aug 2019 14:31:29 +0000
Date:   Mon, 12 Aug 2019 07:31:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 09/20] sg: sg_allow_if_err_recovery and renames
Message-ID: <20190812143129.GB16127@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-10-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-10-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:41PM +0200, Douglas Gilbert wrote:
> Add sg_allow_if_err_recover() to do checks common to several entry
> points. Replace retval with either res or ret. Rename
> sg_finish_rem_req() to sg_finish_scsi_blk_rq(). Rename
> sg_new_write() to sg_submit(). Other cleanups triggered by
> checkpatch.pl .

I think you want to split adding a new helper from random renames.
