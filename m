Return-Path: <SRS0=7D1W=W3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CC7C3A59F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 08:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966D0215EA
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 08:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfHaIcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Aug 2019 04:32:46 -0400
Received: from verein.lst.de ([213.95.11.211]:33982 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfHaIcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Aug 2019 04:32:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 194F268AFE; Sat, 31 Aug 2019 10:32:42 +0200 (CEST)
Date:   Sat, 31 Aug 2019 10:32:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] Re: broken userland ABI in configfs binary attributes
Message-ID: <20190831083241.GC28527@lst.de>
References: <20190826024838.GN1131@ZenIV.linux.org.uk> <20190826162949.GA9980@ZenIV.linux.org.uk> <20190826182017.GE15933@bombadil.infradead.org> <20190826192819.GO1131@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826192819.GO1131@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 26, 2019 at 08:28:19PM +0100, Al Viro wrote:
> For configfs bin_attr it won't work, simply because it wants the entire
> thing to be present - callback parses the data.  For SCSI tape...  Maybe,
> but you'll need to take care of the overlaps with ->write().  Right now
> it can't happen (the last reference, about to be dropped right after
> st_flush() returns); if we do that on each ->flush(), we will have to
> cope with that fun and we'll need to keep an error (if any) for the
> next call of st_flush() to pick and return.  I'm not saying it can't
> be done, but that's really a question for SCSI folks.

So for the one real life example of the configfs attribute life
actually is simpler.  acpi_table_aml_write verifies early on that
the size matches what it expects.  So if we document that any future
instance needs to be able to do that as well we should be able to
get away with just writing it from ->flush.
