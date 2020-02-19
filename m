Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF348C34031
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902852173E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 00:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582072259;
	bh=W1a+IDLaN2nytfbvEVTu4WyrSJz2y/Uqxre6CxMrSvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qVGZmkWFIV2jXJEqtcifKWivfjn/pW0OskCug07OA+a0ub96KNpsjZRCOP+1tNyGr
	 exc8Fv/Fg5YqIw+9IcIWaZEhT/R+ig+zbSlhd2Ky7ac0Cc1uNQAAtWgYGgBmqnRsIs
	 xuddR8o/l3hDB+NhBeXDi/iHCXQkiJPMYyO89jDw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgBSAa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 19:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgBSAa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 19:30:59 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F408208E4;
        Wed, 19 Feb 2020 00:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582072258;
        bh=W1a+IDLaN2nytfbvEVTu4WyrSJz2y/Uqxre6CxMrSvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2DaS8hd5nd/2jLp/mbXEq76iOCZiHMUJm9aDW83YLAqB6v1j7Nq8xWEq3K/nw9pbT
         Ylu60sleckEJwfbuB1EdkG0goAe9XbHnGk8mgfxL+wBXNdozMN46S7D579sA4incpy
         W6gcAigOyXPTtFN+Re3egEjQceZA2H6MCzjoWtg0=
Date:   Tue, 18 Feb 2020 16:30:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 1/2] ufshcd: remove unused quirks
Message-ID: <20200219003056.GA213946@gmail.com>
References: <20200218234450.69412-1-hch@lst.de>
 <20200218234450.69412-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218234450.69412-2-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 03:44:49PM -0800, Christoph Hellwig wrote:
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> -		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> -	else
> -		ufshcd_writel(hba, ~(1 << pos),
> -				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +	ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>  }

This part is keeping the quirk version.  It needs to be other way around.

- Eric
