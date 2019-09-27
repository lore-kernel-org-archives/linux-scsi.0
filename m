Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F90C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 19:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31BA721850
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 19:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UiCLVt0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfI0TUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 15:20:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfI0TUp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 15:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s8ypukgQOLXAIyF2hdNYPqQSa7FeAbisPLKET7G1YAU=; b=UiCLVt0PK0hWmrqLBhFF6NijU
        BfYXdhYDKvn0Kx1wf5Y/zgLCVxuj5f9oLQxKQiexlP+uwSEM5h7DAkBboeU9NsIfBdioHce3xOnh1
        0gbIJrKE3hhGlw9R22guCK5CDXKnnP/aCa3o7hpz4Hb7VDSfUFmXFjtLVo9Y7fRf3rc+7Z/MTMgBn
        8lv+tkNuRi0l+GZCfZ7fiVd3HmuLFMfuAscGUC0nvm2mvE6uXHtrXxenOuqL8FaLNT5MN0CJYCgTj
        o1LcNQ14BoM2PI9fQts5OX4rb2ESIg+MUDvICsXLGgTqQ++q2e8jHhbOQnKxyMcXJ4HX/n8YvB0PD
        hibK3fpWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDvnI-0007lx-Fz; Fri, 27 Sep 2019 19:20:44 +0000
Date:   Fri, 27 Sep 2019 12:20:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH 1/2] scsi: save/restore command resid for error handling
Message-ID: <20190927192044.GA24037@infradead.org>
References: <20190926220844.26631-1-damien.lemoal@wdc.com>
 <20190926220844.26631-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926220844.26631-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 27, 2019 at 07:08:43AM +0900, Damien Le Moal wrote:
> When a command is terminated with CHECK CONDITION and request sense
> executed by hijacking the command descriptor, the original command resid
> is lost and replaced with the resid from the execution of request sense.
> If based on the obtained sense data the command is aborted and not
> retried, the resid that will be seen by drivers such as sd will be the
> resid of the request sense execution and not the value from the original
> command failure. Make sure this does not happen by adding resid as part
> of the command information saved using struct scsi_eh_save.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/scsi_error.c | 2 ++
>  include/scsi/scsi_eh.h    | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1c470e31ae81..d4ac13979189 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  	ses->data_direction = scmd->sc_data_direction;
>  	ses->sdb = scmd->sdb;
>  	ses->result = scmd->result;
> +	ses->resid = scsi_get_resid(scmd);

Don't we also need to reset the resid to 0 here as we do in the
queuecommand path?  That would take care of what you are trying to do
for usb-storage in the next patch in generic code.
