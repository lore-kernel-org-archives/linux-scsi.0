Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B1DC31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438C8206A2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PMyGrvtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfHLOiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:38:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52592 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfHLOiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QgVM0Nc4JKFwdyMPbzHcurXExj3SOYhChc53F/6E75Y=; b=PMyGrvtm2XSt3HfqEiElV8ziE
        Zsc1EQ0lsE9dS1ISJthy+7QYrtTzJLlqn9Cld5lrXIqDyTyBdXpVnMltvSL0+aVRsolNKrZOFy/NF
        FS9B2iDdqox0Ox76A6adVW99za3xNDvgYAeu7rYVGnnYA0O8+Z0iXdvceOZhYUNNJoXIsNCtSRbEw
        xd8XGKLGjdyE4DSO8MACOhtnfiheybzAeHe3DwN4czSN3gd03HY4Tz6ScORQ3uQ0pY+t3xL625++L
        4OWJl+BZQYluO8kJwIpGeuG8X5NNn4tLe30VF7u9ZGX5GSfTpa8hk9RNhgU9VADyrMvNSkVK6iHv+
        5mrUViFcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBSS-0004xH-15; Mon, 12 Aug 2019 14:38:00 +0000
Date:   Mon, 12 Aug 2019 07:37:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 12/20] sg: sense buffer rework
Message-ID: <20190812143759.GE16127@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-13-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-13-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:44PM +0200, Douglas Gilbert wrote:
> The biggest single item in the sg_request object is the sense
> buffer array which is SCSI_SENSE_BUFFERSIZE bytes long. That
> constant started out at 18 bytes 20 years ago and is 96 bytes
> now and might grow in the future. On the other hand the sense
> buffer is only used by a small number of SCSI commands: those
> that fail and those that want to return more information
> other than a SCSI status of GOOD.
> 
> Set up a small mempool called "sg_sense" that is only used as
> required and released back to the mempool as soon as practical.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> -
> 
> The scsi_lib.c file in the scsi mid-level maintains two sense
> buffer caches but declares them and their access functions
> static so they can't use by the sg driver. Perhaps the fastest
> option would be to transfer ownership of a (non-empty) sense
> buffer from the scsi_lib.c file to the sg driver. This technique
> may be useful to ther ULDs.

Why do you need your own storage for the sense buffer?  As soon
as you have allocate the request/scsi_request you can use its
sense buffer.  There shouldn't really be a need to keep a copy
around.

