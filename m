Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A951C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5C1619CC
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhCWVVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 17:21:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:47756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233506AbhCWVU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 17:20:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616534455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rh7UiV11siYZzroNsXRIUQBsl9EwjWLE0W39QrqhoN4=;
        b=jG7i4x9XyqPygIbFC2ZOyLHZ/MfG0RuRrg22IPbXl4hLgYRvJ6x2vYMMUOmi1QOkM82HgL
        sbWdmNQSIHlWluf19S5IfriegoVuNGpWpUS3yv1Huq2SWZELeJTRXESVas0FiNCtQ2vvh6
        Br9eVwA3vvL2Bioz2Y8gupj58oIGKPE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 090D2ADFC;
        Tue, 23 Mar 2021 21:20:55 +0000 (UTC)
Message-ID: <225fe1d4a8d579308583fdad4f23221596355931.camel@suse.com>
Subject: Re: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
From:   Martin Wilck <mwilck@suse.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        David Disseldorp <ddiss@suse.com>,
        =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Date:   Tue, 23 Mar 2021 22:20:54 +0100
In-Reply-To: <BYAPR04MB4965DC898570F11C1B4CF06D86649@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210323162203.30942-1-mwilck@suse.com>
         <BYAPR04MB4965DC898570F11C1B4CF06D86649@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-23 at 18:07 +0000, Chaitanya Kulkarni wrote:
> Martin,
> 
> On 3/23/21 09:23, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > pscsi_map_sg() uses the variable nr_pages as a hint for
> > bio_kmalloc()
> > how many vector elements to allocate. If nr_pages is <
> > BIO_MAX_PAGES,
> > it will be reset to 0 after successful allocation of the bio.
> 
> I think BIO_MAX_PAGES is replaced by BIO_MAX_VECS with
> commit a8affc03a9b3 ("block: rename BIO_MAX_PAGES to BIO_MAX_VECS").

Right. I made my patch against mkp/queue, which doesn't include this
commit yet. As this is just in the description, I don't think it
matters much, does it?

Martin


