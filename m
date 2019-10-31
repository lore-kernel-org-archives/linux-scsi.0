Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B77CA9ECF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 20:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FDBD216F4
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 20:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfJaUvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 16:51:23 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36363 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727511AbfJaUvX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 16:51:23 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9VKojQo005383
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Oct 2019 16:50:46 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 11FEB420456; Thu, 31 Oct 2019 16:50:45 -0400 (EDT)
Date:   Thu, 31 Oct 2019 16:50:45 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v5 3/9] block: blk-crypto for Inline Encryption
Message-ID: <20191031205045.GG16197@mit.edu>
References: <20191028072032.6911-1-satyat@google.com>
 <20191028072032.6911-4-satyat@google.com>
 <20191031175713.GA23601@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031175713.GA23601@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 10:57:13AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 28, 2019 at 12:20:26AM -0700, Satya Tangirala wrote:
> > We introduce blk-crypto, which manages programming keyslots for struct
> > bios. With blk-crypto, filesystems only need to call bio_crypt_set_ctx with
> > the encryption key, algorithm and data_unit_num; they don't have to worry
> > about getting a keyslot for each encryption context, as blk-crypto handles
> > that. Blk-crypto also makes it possible for layered devices like device
> > mapper to make use of inline encryption hardware.
> > 
> > Blk-crypto delegates crypto operations to inline encryption hardware when
> > available, and also contains a software fallback to the kernel crypto API.
> > For more details, refer to Documentation/block/inline-encryption.rst.
> 
> Can you explain why we need this software fallback that basically just
> duplicates logic already in fscrypt?  As far as I can tell this fallback
> logic actually is more code than the actual inline encryption, and nasty
> code at that, e.g. the whole crypt_iter thing.

One of the reasons I really want this is so I (as an upstream
maintainer of ext4 and fscrypt) can test the new code paths using
xfstests on GCE, without needing special pre-release hardware that has
the ICE support.

Yeah, I could probably get one of those dev boards internally at
Google, but they're a pain in the tuckus to use, and I'd much rather
be able to have my normal test infrastructure using gce-xfstests and
kvm-xfstests be able to test inline-crypto.  So in terms of CI
testing, having the blk-crypto is really going to be helpful.

						- Ted
