Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B420BC31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 625D920665
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aHjGludd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfHLObC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:31:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfHLObB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kUpv3CTSi1aISa0ci4QjYLzV5Ud/d8D9hiWC/QLXzjw=; b=aHjGluddlZ4dI27N8szHvDwMx
        IsM8+LMmFFAz7jp8kW2CZWJeAXeF/9nXJD2J41sw5YDdpNmKTJ3DLvSF/vFHx5I034iyixrfLrgir
        /GZ4wZ0nCOWhVLNlq4edTGTpSNm+ZBmhZfWCfxa04hKW54hz54SH6EUDAzZLTu3wqS2iz0zlNMeQq
        9A+Ujm67tqDprJx/Sm/4XEFru0YJ1BxNMWQdrv1aD+VjJxD8HQs+LeWjkquBoLDk254FWa8UcEosM
        Pjfpa0BesVMrJy7Dtu5dHi+j5EhDC2amISeNr0uReFUIquZ5NzpLM5+ZJa5uIpsW6d4VcXpIe51T0
        Gt606UdcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBLh-0001x4-Ik; Mon, 12 Aug 2019 14:31:01 +0000
Date:   Mon, 12 Aug 2019 07:31:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 08/20] sg: speed sg_poll and sg_get_num_waiting
Message-ID: <20190812143101.GA16127@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-9-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-9-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:40PM +0200, Douglas Gilbert wrote:
> Track the number of submitted and waiting (for read/receive)
> requests on each file descriptor with two atomic integers.
> This speeds sg_poll() and ioctl(SG_GET_NUM_WAITING) which
> are oft used with the asynchronous (non-blocking) interfaces.

The idea of just tracking a count here seems sensible.

Tiny nitpick below:

> +	else if (likely(sfp->cmd_q))
> +		p_res |= EPOLLOUT | EPOLLWRNORM;
> +	else if (atomic_read(&sfp->submitted) == 0)
>  		p_res |= EPOLLOUT | EPOLLWRNORM;

Why not simply:

	 else if (sfp->cmd_q || atomic_read(&sfp->submitted)
 		p_res |= EPOLLOUT | EPOLLWRNORM;
