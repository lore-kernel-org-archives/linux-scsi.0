Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9710FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 14:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DEC564E38
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 14:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCROfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 10:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhCROfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 10:35:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA81C06174A;
        Thu, 18 Mar 2021 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M+rroC7fofMZQqGE6piCG/Z3nyte9xXQxvsh9iKBr9g=; b=BBbjpTBmobqllIPf8W/hoWqgOO
        3tE/ubLAp9tB5aQgDH5HkHQjQNmIScOIyfhqr6cXPwj73nau2jdnm9ZQbkBxk9MPdHbtwZ+PRHaiz
        CSXtsfZiu6T328d0OU1A/yVfvHooUG2LX2gIkV1efbhQwPfNOqFlyMk0ySferOoOTBB8YTMFmhWuG
        ljgu2fi8IxmSdV98sYYqXpF12K1EHa56/WOfZMwdNdibK19J0NVcx9CfVUkT8tz1/MfN+6XoU6+ef
        IqfmE+Y2DDdGP8m8Id9PXRMk3aKIvM/2gV96cLTyNAx17vgMibr4zmr4lkc+YT9GBdolJba9FtpVa
        4SguiRxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMtiz-0034n3-82; Thu, 18 Mar 2021 14:34:14 +0000
Date:   Thu, 18 Mar 2021 14:34:09 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] advansys: remove ISA support
Message-ID: <20210318143409.GN3420@casper.infradead.org>
References: <20210318063923.302738-1-hch@lst.de>
 <20210318063923.302738-5-hch@lst.de>
 <20210318112025.GK3420@casper.infradead.org>
 <20210318125453.GB21262@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318125453.GB21262@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2021 at 01:54:53PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 11:20:25AM +0000, Matthew Wilcox wrote:
> > On Thu, Mar 18, 2021 at 07:39:19AM +0100, Christoph Hellwig wrote:
> > > @@ -2875,7 +2859,6 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
> > >  	uchar serialstr[13];
> > >  #ifdef CONFIG_ISA
> > >  	ASC_DVC_VAR *asc_dvc_varp;
> > > -	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
> > >  
> > >  	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
> > >  #endif /* CONFIG_ISA */
> > 
> > I think you can remove the conditional definition & assignment of
> > asc_dvc_varp here.
> 
> The way I read the driver CONFIG_ISA also covers Vesa Local Bus
> support, which is not removed by this patch.  Corret me if I'm wrong.

I agree that VLB is also enabled by CONFIG_ISA in this driver,
but in this specific function, I think you removed the only use
of asc_dvc_varp.
