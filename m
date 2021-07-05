Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7138FC07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE7B6162A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhGENvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:51:02 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60320 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhGENut (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 09:50:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 03AC41FE7C;
        Mon,  5 Jul 2021 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625492892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7c4IiH2aa4P20xqWaw5e/T+wJYbnW/4u5C/hJC+kBk=;
        b=EDeU8Zpz/vEp2RScFVaVhyOvVu+BPXm1C6oEBSEPeQCXms8NCEWDYdDw6FrrMEGL5v2sGU
        1GFOp/hNtOloGoYdQGxlOKTEdlFTkr+QOIbnBeH3/54mj2sjaxBPOacW9DBYMi/JnF6on3
        AD/My80J4l6zWVZ9tiyCCnhoZ5jfq1g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 830F313A61;
        Mon,  5 Jul 2021 13:48:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ah7JHZsN42D0AwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 05 Jul 2021 13:48:11 +0000
Message-ID: <a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, emilne@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Alasdair G Kergon <agk@redhat.com>
Date:   Mon, 05 Jul 2021 15:48:10 +0200
In-Reply-To: <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
References: <20210628151558.2289-1-mwilck@suse.com>
         <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
         <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
         <20210701113442.GA10793@lst.de>
         <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
         <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
         <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mo, 2021-07-05 at 15:11 +0200, Hannes Reinecke wrote:
> On 7/5/21 3:02 PM, Paolo Bonzini wrote:
> > On 02/07/21 16:21, Martin Wilck wrote:
> > > > SG_IO gives you raw access to the SCSI logic unit, and you get
> > > > to
> > > > keep the pieces if anything goes wrong.
> > > 
> > > That's a very fragile user space API, on the fringe of being
> > > useless
> > > IMO.
> > 
> > Indeed.  If SG_IO is for raw access to an ITL nexus, it shouldn't
> > be
> > supported at all by mpath devices.  If on the other hand SG_IO is
> > for
> > raw access to a LUN, there is no reason for it to not support
> > failover.
> > 
> Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
> And delegate SG_IO to raw access to an ITL nexus.
> Doesn't help with existing issues, but should get a clean way
> forward.

I still have to understand how this would help with the retrying
semantics. Wouldn't we get the exact same problem if a path error
occurs?

Regards,
Martin


