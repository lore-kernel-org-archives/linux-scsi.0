Return-Path: <SRS0=7D1W=W3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC01C3A5A6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 15:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0369C21874
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Aug 2019 15:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfHaP6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Aug 2019 11:58:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39996 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfHaP6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2019 11:58:23 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.1 #3 (Red Hat Linux))
        id 1i45lb-0005xE-Vu; Sat, 31 Aug 2019 15:58:20 +0000
Date:   Sat, 31 Aug 2019 16:58:19 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] Re: broken userland ABI in configfs binary attributes
Message-ID: <20190831155819.GZ1131@ZenIV.linux.org.uk>
References: <20190826024838.GN1131@ZenIV.linux.org.uk>
 <20190826162949.GA9980@ZenIV.linux.org.uk>
 <20190826182017.GE15933@bombadil.infradead.org>
 <20190826192819.GO1131@ZenIV.linux.org.uk>
 <20190831083241.GC28527@lst.de>
 <20190831133537.GX1131@ZenIV.linux.org.uk>
 <20190831144447.GA600@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831144447.GA600@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 31, 2019 at 04:44:48PM +0200, Christoph Hellwig wrote:
> On Sat, Aug 31, 2019 at 02:35:37PM +0100, Al Viro wrote:
> > > So for the one real life example of the configfs attribute life
> > > actually is simpler.  acpi_table_aml_write verifies early on that
> > > the size matches what it expects.  So if we document that any future
> > > instance needs to be able to do that as well we should be able to
> > > get away with just writing it from ->flush.
> > 
> > I'm not sure I understand what you mean...  Do you want them to recognize
> > incomplete data and quietly bugger off when called on too early ->flush()?
> 
> That is what the only user does anyway, take a look at
> acpi_table_aml_write.  So yes, change the documentation to say it
> gets written on every close, and the implementation has to deal with
> incomplete data by either returning an error or ignoring it.

That, or we could just let it have the sucker called on each write().
As in "for such files writes are accumulated in a buffer, until the
method finally decides it has enough to process"...

In that case method should return something recognizable for "need more
input", as opposed to "stop, it's already an unacceptable garbage".
