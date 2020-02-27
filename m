Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C649CC35DF9
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 18:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99091246BE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 18:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582827254;
	bh=DfvmaQgMZxcqfEpHuvrrlNTCaevj5uxdnW4bw4l/cwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mWNYnRGAdNlxLvzboEQpm60u3bgR6E08FpMIvmv1zR/hgxaPEfYv1QJBzFCLaDL/f
	 KVoolxB08ZMT1oNgzb2KfFjhwn9ef2L9ONrtyp/IufwzHEe7ss2L7d3i4wQrNmD2iG
	 sXG5cLzoV/LmEtkaIrUvxpZVm0vzj8LMoUxzmlsk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgB0SOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 13:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgB0SOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 13:14:14 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F29246B0;
        Thu, 27 Feb 2020 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582827253;
        bh=DfvmaQgMZxcqfEpHuvrrlNTCaevj5uxdnW4bw4l/cwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sT4dmVR9UsPbGMcknWI3bgOsjSvrPsgtUAmdt1lWngGDPvi6tYTXfp8zAlivAVVGE
         Nodjsd6dayZE3c3DVdI5DxqXH1cs4fq2TQNuuy1ir3hHqyCE3C9nGSpbDbR7iyczgy
         thWQWFpyhElDDeVDwp9+De4JDQO1/TZDUfWsjIts=
Date:   Thu, 27 Feb 2020 10:14:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Satya Tangirala <satyat@google.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v7 1/9] block: Keyslot Manager for Inline Encryption
Message-ID: <20200227181411.GB877@sol.localdomain>
References: <20200221115050.238976-1-satyat@google.com>
 <20200221115050.238976-2-satyat@google.com>
 <20200221170434.GA438@infradead.org>
 <20200221173118.GA30670@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221173118.GA30670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2020 at 09:31:18AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 21, 2020 at 09:04:34AM -0800, Christoph Hellwig wrote:
> > Given that blk_ksm_get_slot_for_key returns a signed keyslot that
> > can return errors, and the only callers stores it in a signed variable
> > I think this function should take a signed slot as well, and the check
> > for a non-negative slot should be moved here from the only caller.
> 
> Actually looking over the code again I think it might be better to
> return only the error code (and that might actually be a blk_status_t),
> and then use an argument to return a pointer to the actual struct
> keyslot.  That gives us much easier to understand code and better
> type safety.

That doesn't make sense because the caller only cares about the keyslot number,
not the 'struct keyslot'.  The 'struct keyslot' is internal to
keyslot-manager.c, as it only contains keyslot management information.

Your earlier suggestion of making blk_ksm_put_slot() be a no-op on a negative
keyslot number sounds fine though.

- Eric
