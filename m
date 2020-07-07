Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941E1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75C1A20708
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594144755;
	bh=G4gbjeCawk42jom0IDqx7cs+gNSByJwNSXM44xofNEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=D3eGS0v7L0U7H+K3pRS+MB7agJjCiYoZ7mQ9g1OiYUCbTu4AROSSXYI3TIbLqzHun
	 LGe5GKbQy/iTUxHEcf/PCOwgeD986aBgPSO+elV6K2wETqYVTWbMz2Z6+kgLXL9kjD
	 lmn6Rsx445SNfoNQSUCLEDa2uEDm/pWSdu/cFP78=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGGR7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 13:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGR7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 13:59:15 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B693E206E2;
        Tue,  7 Jul 2020 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594144753;
        bh=G4gbjeCawk42jom0IDqx7cs+gNSByJwNSXM44xofNEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkQ8Dw7B/PGpugkaFUPLmCtRhNH8gEUZbMIyj3KIXGMJ+W2kUFMJ2n5FJ+XEarVBD
         QHSf6ggMTrTBN1KrL01+cGys39wHiIHrAcAcjGMFWpXGbQJ5YOWPgOUMNwApf18/fI
         8Ayw33vByKvJcldiJpETjJhwfNH4JqNE0Ls4/x/A=
Date:   Tue, 7 Jul 2020 10:59:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     'Satya Tangirala' <satyat@google.com>, linux-scsi@vger.kernel.org,
        'Avri Altman' <avri.altman@wdc.com>,
        'Barani Muthukumaran' <bmuthuku@qti.qualcomm.com>,
        'Kuohong Wang' <kuohong.wang@mediatek.com>,
        'Kim Boojin' <boojin.kim@samsung.com>
Subject: Re: [PATCH v4 0/3] Inline Encryption Support for UFS
Message-ID: <20200707175912.GA839@sol.localdomain>
References: <CGME20200706200432epcas5p1d276cdebadfecc3984de37a80c4b19f2@epcas5p1.samsung.com>
 <20200706200414.2027450-1-satyat@google.com>
 <000001d65485$1e819280$5b84b780$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001d65485$1e819280$5b84b780$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 07, 2020 at 11:06:14PM +0530, Alim Akhtar wrote:
> Hi Satya,
> 
> > -----Original Message-----
> > From: Satya Tangirala <satyat@google.com>
> > Sent: 07 July 2020 01:34
> > To: linux-scsi@vger.kernel.org; Avri Altman <avri.altman@wdc.com>; Alim
> > Akhtar <alim.akhtar@samsung.com>
> > Cc: Barani Muthukumaran <bmuthuku@qti.qualcomm.com>; Kuohong Wang
> > <kuohong.wang@mediatek.com>; Kim Boojin <boojin.kim@samsung.com>;
> > Satya Tangirala <satyat@google.com>
> > Subject: [PATCH v4 0/3] Inline Encryption Support for UFS
> > 
> > This patch series adds support for inline encryption to UFS using the inline
> > encryption support in the block layer. It follows the JEDEC UFSHCI v2.1
> > specification, which defines inline encryption for UFS.
> > 
> > This patch series previously went through a number of iterations as part of the
> > "Inline Encryption Support" patchset (last version was v13:
> > https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
> > This patch series is rebased on v5.8-rc4.
> > 
> > Patch 1 introduces the crypto registers and struct definitions defined in the
> > UFSHCI v2.1 spec.
> > 
> > Patch 2 introduces functions to manipulate the UFS inline encryption hardware
> > (again in line with the UFSHCI v2.1 spec) via the block layer keyslot manager.
> > Device specific drivers must set the UFSHCD_CAP_CRYPTO in hba->caps before
> > ufshcd_hba_init_crypto is called to opt-in to inline encryption support.
> > 
> > Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.
> > 
> > This patch series has been tested on some Qualcomm chipsets (on the db845c,
> > sm8150-mtp and sm8250-mtp) using some additional patches at
> > https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-
> > ebiggers@kernel.org/
> > and on some Mediatek chipsets using the additional patch in
> > https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-
> > stanley.chu@mediatek.com/.
> > These additional patches are required because these chipsets need certain
> > additional behaviour not specified within the UFSHCI v2.1 spec.
> > 
> > Thanks a lot to all the folks who tested this out!
> > 
> > Changes v3 => v4:
> >  - fix incorrect patch folding
> >  - some cleanups from Eric
> > 
> > Changes v2 => v3:
> >  - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slightly
> >  - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabilities
> >    and ufshcd_init_crypto. The first function is called from
> >    ufshcd_hba_capabilities, and only reads crypto capabilities from device
> >    registers and sets up appropriate crypto structures. The second function
> >    is called from ufshcd_init, and actually initializes the inline crypto
> >    hardware.
> > 
> > Changes v1 => v2
> >  - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status
> > 
> > Satya Tangirala (3):
> >   scsi: ufs: UFS driver v2.1 spec crypto additions
> >   scsi: ufs: UFS crypto API
> >   scsi: ufs: Add inline encryption support to UFS
> > 
> >  drivers/scsi/ufs/Kconfig         |   9 ++
> >  drivers/scsi/ufs/Makefile        |   1 +
> >  drivers/scsi/ufs/ufshcd-crypto.c | 238 +++++++++++++++++++++++++++++++
> > drivers/scsi/ufs/ufshcd-crypto.h |  77 ++++++++++
> >  drivers/scsi/ufs/ufshcd.c        |  49 ++++++-
> >  drivers/scsi/ufs/ufshcd.h        |  24 ++++
> >  drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
> >  7 files changed, 456 insertions(+), 9 deletions(-)  create mode 100644
> > drivers/scsi/ufs/ufshcd-crypto.c  create mode 100644 drivers/scsi/ufs/ufshcd-
> > crypto.h
> > 
> Looks Good to me.
> I don’t have a platform to test this series though.
> It will be good to get a Tested-by tags for this series.
> 
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> 

There's information about testing in the cover letter and commit messages
already.  But feel free to also add my Tested-by to all three patches:

Tested-by: Eric Biggers <ebiggers@google.com> # db845c

- Eric
