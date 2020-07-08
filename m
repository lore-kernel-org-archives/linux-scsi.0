Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1DDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 16:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E65020786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594224009;
	bh=kVOz619XpAOAaq1ZydKyZybzq2MGNZNOOlmqrHYv9tU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Uk4eODh0IbgDAzzntsMq+e1NeBfb7WgbBtLL/qo8R0sxVQXP1mVFStLUTOPIHNDlD
	 MbmZigI1zJgZM3U3DLiGjZLQxPb/JcghCWO2WRTQJVuRaDJKfebCsOKggx5pFAzF4M
	 9kzptTYbNOzOZUGj1LijHGxYHzd+PGzbJePbTXUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgGHQAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730179AbgGHQAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jul 2020 12:00:08 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24493206F6;
        Wed,  8 Jul 2020 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594224008;
        bh=kVOz619XpAOAaq1ZydKyZybzq2MGNZNOOlmqrHYv9tU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1EyWRBb1rem2gIXMPRoLE8Ac8qbyBYsuy7pEDD5IPMRu3A3Mnsmci6l0wpwPOeT2M
         FGZiZkT9h1CyKvxuKbLr7YxV5KEA0a1600GdLk5F+IIAX3wBIY1dxguZh98QtFfO8v
         oQ76xlm4vtGkvD0ct4zDPeN6p2xrk2qNfyRkq17I=
Date:   Wed, 8 Jul 2020 09:00:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Satya Tangirala <satyat@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v4 2/3] scsi: ufs: UFS crypto API
Message-ID: <20200708160006.GB915@sol.localdomain>
References: <20200706200414.2027450-1-satyat@google.com>
 <20200706200414.2027450-3-satyat@google.com>
 <SN6PR04MB4640E8B9BB10FD5A5C2740D1FC670@SN6PR04MB4640.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR04MB4640E8B9BB10FD5A5C2740D1FC670@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 08, 2020 at 07:44:28AM +0000, Avri Altman wrote:
> > +
> > +static enum blk_crypto_mode_num
> > +ufshcd_find_blk_crypto_mode(union ufs_crypto_cap_entry cap)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(ufs_crypto_algs); i++) {
> > +               BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
> > +               if (ufs_crypto_algs[i].ufs_alg == cap.algorithm_id &&
> > +                   ufs_crypto_algs[i].ufs_key_size == cap.key_size) {
> > +                       return i;
> > +               }
> > +       }
> > +       return BLK_ENCRYPTION_MODE_INVALID;
> BLK_ENCRYPTION_MODE_INVALID is 0, but 0 is a valid mode num?

ufs_crypto_algs[] does have to contain an entry for BLK_ENCRYPTION_MODE_INVALID,
but it's an empty entry with ufs_key_size == UFS_CRYPTO_KEY_SIZE_INVALID (0).
So it will never be selected and the code is correct.

We should probably start iterating at 1 to make this clearer, though note that
the code still needs to handle empty entries anyway in case any gaps are ever
introduced into the BLK_ENCRYPTION_MODE_* values.

- Eric
