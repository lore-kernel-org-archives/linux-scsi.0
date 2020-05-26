Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6220C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 14:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B8ED2084C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 14:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E9YEjJ7V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgEZO1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 10:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgEZO1e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 10:27:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE3DC03E96D
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2020 07:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GE0umvOzgoZwhApJfHGEsYR0IHWktqrDSswvSxFCv08=; b=E9YEjJ7V/FbdXFVoF2Lai381T0
        IS0QI9lCSSCCEnagKjaDatePcuN3EPtiXws+eZLUuoWmuEJBKLqopT6qqSwSj0DozO1LBl508ldd+
        ZXZ5xW7cQ2A2A9coKHlW0Eczbtt3WGBsvXlV7bt6ztiyRX5VDjaSkTHPKxpZZSFQE2w2Vq7ut7Rqp
        bDadi9aiXlbWRVntsGq+jvQ7FEMszMfRjQk+z5r1tLdWD8+LwB+KMur660wsU6gWv+5vFX+oLG9mp
        Zt4TAy7Wj17kdw4Oyw/DMcFF7kF6n+9JN9ttb2M9g0r13Rmxw3IQj8QUvWI9fNiaVAR9PDvRvoJTV
        ZJkKTc7Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdaYB-00015W-Va; Tue, 26 May 2020 14:27:27 +0000
Date:   Tue, 26 May 2020 07:27:27 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
Message-ID: <20200526142727.GH17206@bombadil.infradead.org>
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <825bece5-e209-a4da-ddb1-809c48e4e9b3@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 26, 2020 at 08:21:26AM +0200, Hannes Reinecke wrote:
> On 5/25/20 7:40 PM, Matthew Wilcox wrote:
> > You aren't the first person to ask about having a 64-bit lookup on
> > 32-bit machines.  Indeed, I remember Hannes asking for a 256 bit lookup
> > at LinuxCon in Prague.  I have always been reluctant to add such a thing
> > because the XArray uses quite a naive data type underneath.  It works well with
> > dense arrays but becomes very wasteful of memory for sparse arrays.
> > 
> > My understanding of SCSI-world is that most devices have a single
> > LUN 0.  Most devices that have multiple LUNs number them sequentially.
> > Some devices have either an internal structure or essentially pick random
> > LUNs for the devices they expose.
> 
> Not quite. You are correct that most devices have a single LUN 0
> (think of libata :-), but those with several LUNs typically
> enumerate them. In most cases the enumeration starts at 0 (or 1,
> if LUN 0 is used for a management LUN), and reaches up to 256.
> Some arrays use a different LUN layout, which means that the top
> two bit of the LUN number are set, and possibly some intermediate
> numbers, too. But the LUNs themselves are numbered consecutively, too;
> it's just at a certain offset.
> I've never seen anyone picking LUN numbers at random.

Ah, OK.  I think for these arrays you'd be better off accepting the cost
of an extra 4 bytes in the struct scsi_device rather than the cost of
storing the scsi_device at the LUN.

Let's just work an example where you have a 64-bit LUN with 4 ranges,
each of 64 entries (this is almost a best-case scenario for the XArray).
[0,63], 2^62+[0,63], 2^63+[0,63], 2^63+2^62+[0,63].

If we store them sequentially in an allocating XArray, we take up 256 *
4 bytes = 1kB extra space in the scsi_device.  The XArray will allocate
four nodes plus one node to hold the four nodes, which is 5 * 576 bytes
(2780 bytes) for a total of 3804 bytes.

Storing them in at their LUN will allocate a top level node which covers
bits 60-66, then four nodes, each covering bits of 54-59, another four
nodes covering bits 48-53, four nodes for 42-47, ...  I make it 41 nodes,
coming to 23616 bytes.  And the pointer chase to get to each LUN is
ten deep.  It'll mostly be cached, but still ...

> But still, the original question still stands: what would be the most
> efficient way using xarrays here?
> We have a four-level hierarchy Host:Channel:Target:LUN
> and we need to lookup devices (and, occasinally, targets) per host.
> At this time, 'channel' and 'target' are unsigned integer, and
> LUNs are 64 bit.

It certainly seems sensible to me to have a per-host allocating XArray
to store the targets that belong to that host.  I imagine you also want
a per-target XArray for the LUNs that belong to that target.  Do you
also want a per-host XArray to store the LUNs so you can iterate all
LUNs per host as a single lookup rather than indirecting through the
target Xarray?  That's a design decision for you to make.

