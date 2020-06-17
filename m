Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33405C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B8821532
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592411089;
	bh=ThDDDxOsNbHRCQ/Cmav098DEcp10iSU234rpKdStcY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ra86dDl9ehVV2CwX2yXe0CKDVcQF4gqnl3FwksIL56q4e4mnj71nGSnNB4TXx98+V
	 3aqm/NbIagQ9S+flZVT8V7HfJY8OvYuYZvaynrOxD8RYj6hTYTlHedrIOz4iSgc3Ot
	 9IIRrjKfkF8F74r8sXiGsuRxcelBNlxPEZFJQ3as=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQQYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 12:24:48 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 037EF208D5;
        Wed, 17 Jun 2020 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411088;
        bh=ThDDDxOsNbHRCQ/Cmav098DEcp10iSU234rpKdStcY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rw4s25KzWxPHjimWUdvaSF415S8yHvIVBfoAuKDM8ITRnQ/4wVfaCJpa60m3/33FL
         0+ZVYJcJG4kg9VqwpohJ1+RIImB1YfsNMYcmGEvoVZSWMwqPEyy8GQCXh9HQgd45y0
         Su28ivscl4YmgjKIS/Ig3UsLGHUqzZ83qF+Q7grQ=
Date:   Wed, 17 Jun 2020 09:24:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Inline Encryption Support for UFS
Message-ID: <20200617162446.GA1138@sol.localdomain>
References: <20200617081841.218985-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617081841.218985-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 08:18:38AM +0000, Satya Tangirala wrote:
> This patch series adds support for inline encryption to UFS using
> the inline encryption support in the block layer. It follows the JEDEC
> UFSHCI v2.1 specification, which defines inline encryption for UFS.
> This patch series is based on v5.8-rc1.
> 
> Patch 1 introduces the crypto registers and struct definitions defined
> in the UFSHCI v2.1 spec.
> 
> Patch 2 introduces functions to manipulate the UFS inline encryption
> hardware (again in line with the UFSHCI v2.1 spec) via the block
> layer keyslot manager. Device specific drivers must set the
> UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
> to opt-in to inline encryption support.
> 
> Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.
> 
> Satya Tangirala (3):
>   scsi: ufs: UFS driver v2.1 spec crypto additions
>   scsi: ufs: UFS crypto API
>   scsi: ufs: Add inline encryption support to UFS
> 
>  drivers/scsi/ufs/Kconfig         |   9 ++
>  drivers/scsi/ufs/Makefile        |   1 +
>  drivers/scsi/ufs/ufshcd-crypto.c | 226 +++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-crypto.h |  60 ++++++++
>  drivers/scsi/ufs/ufshcd.c        |  46 ++++++-
>  drivers/scsi/ufs/ufshcd.h        |  24 ++++
>  drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
>  7 files changed, 426 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

Note that these patches previously went through a number of iterations as part
of the "Inline Encryption Support" patchset (last version was v13:
https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).  There are
no significant changes from v13, right?  It would be helpful to mention this in
the cover letter.

It would also be helpful to describe how this was tested at least in the cover
letter, but maybe in one of the commit messages too.  For example I and two
other people have tested the Qualcomm ICE support on top of this with
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/.
(BTW, I'll be rebasing, re-testing, and re-sending those patches soon.)
Mediatek has also tested this with
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/.

- Eric
