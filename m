Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C3AC2D0D1
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE2924685
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576813961;
	bh=+1rZOJ+7YGgXyzuEyadBtswufhH8eKBcvvIK/5ZNDfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=g683ezKW0lzCov6cs4InuNFXXegn5nG6sSjjoRwOd89mMJcuRUspHPBaLcKuxf4di
	 oB5oxnrlkoCKmhLhGxO/Cs8fnwWfJtobGva6sh6r0uf3z8EYl0OVEKmyAXMeaY0xYQ
	 peNstdFULySLM158zy0eI9nVqiaw+qWdezwn5N7U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfLTDwk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfLTDwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 22:52:40 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D677A24676;
        Fri, 20 Dec 2019 03:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576813959;
        bh=+1rZOJ+7YGgXyzuEyadBtswufhH8eKBcvvIK/5ZNDfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNXd7r0dbNYQXrn4m6q2F7iH6ZyG9RfuebAAQBSWQBSZkNOwCcuv1lOFyrSDHGAdD
         OLk1O9Ps/vEl1vGN0C0iEpW0X0bTi69Y57BOa2dWkpFgnufQ6YTgDxV2oS0vyoc5Me
         g7p/eFJ5xJXx0MDG5zhAjZxC4vSSD6zVVSiSbuCI=
Date:   Thu, 19 Dec 2019 19:52:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 2/9] block: Add encryption context to struct bio
Message-ID: <20191220035237.GB718@sol.localdomain>
References: <20191218145136.172774-1-satyat@google.com>
 <20191218145136.172774-3-satyat@google.com>
 <20191218212116.GA7476@magnolia>
 <yq1y2v9e37b.fsf@oracle.com>
 <20191218222726.GC47399@gmail.com>
 <yq1fthhdttv.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1fthhdttv.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 07:47:56PM -0500, Martin K. Petersen wrote:
> 
> Eric,
> 
> > There's not really any such thing as "use the bio integrity plumbing".
> > blk-integrity just does blk-integrity; it's not a plumbing layer that
> > allows other features to be supported.  Well, in theory we could
> > refactor and rename all the hooks to "blk-extra" and make them
> > delegate to either blk-integrity or blk-crypto, but I think that would
> > be overkill.
> 
> I certainly don't expect your crypto stuff to plug in without any
> modification to what we currently have. I'm just observing that the
> existing plumbing is designed to have pluggable functions that let
> filesystems attach additional information to bios on writes and process
> additional attached information on reads. And the block layer already
> handles slicing and dicing these attachments as the I/O traverses the
> stack.
> 
> There's also other stuff that probably won't be directly applicable or
> interesting for your use case. It just seems like identifying actual
> commonalities and differences would be worthwhile.
> 
> Note that substantial changes to the integrity code would inevitably
> lead to a lot of pain and suffering for me. So from that perspective I
> am very happy if you leave it alone. From an architectural viewpoint,
> however, it seems that there are more similarities than differences
> between crypto and integrity. And we should avoid duplication where
> possible. That's all.

There are some similarities, like both being optional features that need extra
per-bio information and hooks for bio merging, freeing, cloning, and advancing.

However, the nature of the per-bio information is very different.  Most of the
complexity in blk-integrity is around managing of a separate integrity
scatterlist for each bio, alongside the regular data scatterlist.

That's not something we need or want for inline encryption.  For each bio we
just need a key, algorithm, data unit number, and data unit size.  Since the
data unit number (IV) is automatically incremented for each sector and the
encryption is length-preserving, there's no per-sector data.

(Granted, from a crypto perspective ideally one would use authenticated
encryption, which does require per-sector data.  However, no one seems
interested in building hardware that supports it.  So for the forseeable future,
only length-preserving encryption is in scope for this.)

Also, blk-crypto actually transforms the data whereas blk-integrity does not.

> > What we could do, though, is say that at most one of blk-crypto and
> > blk-integrity can be used at once on a given bio, and put the
> > bi_integrity and bi_crypt_context pointers in union.  (That would
> > require allocating a REQ_INLINECRYPT bit so that we can tell what the
> > pointer points to.)
> 
> Absolutely. That's why it's a union. Putting your stuff there is a
> prerequisite as far as I'm concerned. No need to grow the bio when the
> two features are unlikely to coexist. We can revisit that later should
> the need arise.

There are some ways the two features could be supported simultaneously without
using more space, like making the pointer point to a linked list of tagged
structs, or making the struct contain both a bio_crypt_ctx and
bio_integrity_payload (or whichever combination is enabled in kconfig).

But it would be painful and I don't think people need this for now.  So if
people really aren't willing to accept the extra 8 bytes per bio even behind a
kconfig option, my vote is we that we put bi_crypt_context in the union with
bi_integrity, and add a flag REQ_INLINECRYPT (like REQ_INTEGRITY) that indicates
that the bi_crypt_context member of the union is valid.

We'd also need some error-handling to prevent the two features from actually
being used together.  It looks like there are several cases to consider.  One of
them is what happens if bio_crypt_set_ctx() is called when blk-integrity
verification or generation is enabled for the disk.  I suppose it could either
return an error, or we could make blk-crypto use the crypto API fallback
provided that it was modified to make the decryption stop relying on
->bi_crypt_context, which could be done by cloning the bio and using
->bi_private instead.

- Eric
