Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16678C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 00:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE43B206DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 00:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594080841;
	bh=Lgs3dRQEv62QGCkW3ZDfW6ksMmoH1NGaaZbwmfhrD78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=foEGMim6ixTG75N+Y7Ne5sOKaxuOrneYXke3RAV1At4mOr5NqyBlcTcUYbA+7k9tw
	 BGtgbbzMMwu10l2Dh9cwxv/ZSHlzocTDlmEECNDyNcHQoA6nwo4lF0YnxFM45FhCq6
	 FkZKm+/23TBAA4uZ5/ttgfWEmuLobkprpuOmGkmU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgGGAOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 20:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgGGAOB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 20:14:01 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A74A2065D;
        Tue,  7 Jul 2020 00:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594080840;
        bh=Lgs3dRQEv62QGCkW3ZDfW6ksMmoH1NGaaZbwmfhrD78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aF0NbMI6dA2q2MHsamDygZYqrg0VADxhh9Phgwq6+y4YFW4Ofr+EYNKz7dgzMxoo6
         vlAWvdkzFb7xtymp8k0bvZHadgntXjA67S/qowp1L4sryzMXB46qky1qhmbr4qAaEg
         KXLZQLlPJ/uYWj90gyKx5JS6k3H4fJFWgPhHqzi4=
Date:   Mon, 6 Jul 2020 17:13:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v4 0/3] Inline Encryption Support for UFS
Message-ID: <20200707001358.GC833@sol.localdomain>
References: <20200706200414.2027450-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706200414.2027450-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 06, 2020 at 08:04:11PM +0000, Satya Tangirala wrote:
> This patch series adds support for inline encryption to UFS using
> the inline encryption support in the block layer. It follows the JEDEC
> UFSHCI v2.1 specification, which defines inline encryption for UFS.
> 
> This patch series previously went through a number of iterations as
> part of the "Inline Encryption Support" patchset (last version was v13:
> https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
> This patch series is rebased on v5.8-rc4.
> 
> Patch 1 introduces the crypto registers and struct definitions defined
> in the UFSHCI v2.1 spec.
> 
> Patch 2 introduces functions to manipulate the UFS inline encryption
> hardware (again in line with the UFSHCI v2.1 spec) via the block
> layer keyslot manager. Device specific drivers must set the
> UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
> to opt-in to inline encryption support.

Note that it's now ufshcd_hba_init_crypto_capabilities(), not
ufshcd_hba_init_crypto().

> 
> Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.
> 
> This patch series has been tested on some Qualcomm chipsets (on the
> db845c, sm8150-mtp and sm8250-mtp) using some additional patches at
> https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
> and on some Mediatek chipsets using the additional patch in
> https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/.
> These additional patches are required because these chipsets need certain
> additional behaviour not specified within the UFSHCI v2.1 spec.
> 
> Thanks a lot to all the folks who tested this out!
> 
> Changes v3 => v4:
>  - fix incorrect patch folding
>  - some cleanups from Eric
> 
> Changes v2 => v3:
>  - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slightly
>  - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabilities
>    and ufshcd_init_crypto. The first function is called from
>    ufshcd_hba_capabilities, and only reads crypto capabilities from device
>    registers and sets up appropriate crypto structures. The second function
>    is called from ufshcd_init, and actually initializes the inline crypto
>    hardware.
> 
> Changes v1 => v2
>  - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status
> 
> Satya Tangirala (3):
>   scsi: ufs: UFS driver v2.1 spec crypto additions
>   scsi: ufs: UFS crypto API
>   scsi: ufs: Add inline encryption support to UFS

These patches look good to me.  Avri and Alim, what do you think?
We'd like these to be applied for 5.9.

- Eric
