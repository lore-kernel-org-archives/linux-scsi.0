Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4781C33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEEFB24670
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579036617;
	bh=PzGGbPQJnnJrvhracuO2jY95bGpEghQuRwTZb0zELqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nRruZyqh7tggIyZs4jUMJIoZwJJJxNRU7RGWcsnwYcV+luLIxUJoWOBCqWdVA7CTB
	 SsTvtfqv6h62k0Dc688MAH10ns0GP+6Wm4xqE3afjncVSsLv1ohYhOT6tH5XVWFlmG
	 YBCnZaZIYialqdUDXD9tCtrpf/GS43qVaz4L9Aak=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANVQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgANVQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 16:16:56 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8862124658;
        Tue, 14 Jan 2020 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579036615;
        bh=PzGGbPQJnnJrvhracuO2jY95bGpEghQuRwTZb0zELqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TvYuEITubu7X9Iyh7rL1YDF9fFJ6DmKcYzaM8JPSbuuQnYaWIeNMfyoIrp7LTNzzk
         AFLcvj+PHjjtph7ptkJjJNJBLMX0wQLtE9FAUBkmym2qR4do8F9NVjFgXKsK4L7j/p
         duZAnSEudfJrWbWpuKsOM+wEVqoY0d5Pnz5UL82k=
Date:   Tue, 14 Jan 2020 13:16:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 5/9] scsi: ufs: UFS crypto API
Message-ID: <20200114211653.GD41220@gmail.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20191218145136.172774-6-satyat@google.com>
 <20191220044838.GD718@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220044838.GD718@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 19, 2019 at 08:48:38PM -0800, Eric Biggers wrote:
> On Wed, Dec 18, 2019 at 06:51:32AM -0800, Satya Tangirala wrote:
> > +/**
> > + * ufshcd_hba_init_crypto - Read crypto capabilities, init crypto fields in hba
> > + * @hba: Per adapter instance
> > + *
> > + * Return: 0 if crypto was initialized or is not supported, else a -errno value.
> > + */
> > +int ufshcd_hba_init_crypto(struct ufs_hba *hba)
> > +{
> > +	int cap_idx = 0;
> > +	int err = 0;
> > +	unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_MAX];
> > +	enum blk_crypto_mode_num blk_mode_num;
> > +
> > +	/* Default to disabling crypto */
> > +	hba->caps &= ~UFSHCD_CAP_CRYPTO;
> > +
> > +	/* Return 0 if crypto support isn't present */
> > +	if (!(hba->capabilities & MASK_CRYPTO_SUPPORT))
> > +		goto out;
> > +
> 
> Note that unfortunately, this patch doesn't work yet on some UFS host
> controllers that claim to support the UFS standard crypto, due to issues like
> deviations from the UFS standard and missing device tree changes -- and this can
> even cause boot-time crashes.
> 
> So if we can't fix everything right away (which can be really hard without help
> from the relevant vendor) I think we have to define a bit
> UFSHCD_QUIRK_BROKEN_CRYPTO in ufs_hba::quirks which can be set on host
> controllers where the proper tricks to get the crypto working correctly haven't
> been figured out yet.  The crypto support would be ignored if that bit is set.

I included a patch defining UFSHCD_QUIRK_BROKEN_CRYPTO in my RFC patchset that
wires up inline crypto support on Dragonboard 845c:
https://lkml.kernel.org/linux-scsi/20200110061634.46742-4-ebiggers@kernel.org/

Satya, feel free to include that patch in v7 of your patchset.

- Eric
