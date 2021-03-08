Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CE7C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 08:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2102D6513A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 08:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhCHIAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 03:00:25 -0500
Received: from verein.lst.de ([213.95.11.211]:54550 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhCHIAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Mar 2021 03:00:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CC3F68B05; Mon,  8 Mar 2021 09:00:15 +0100 (CET)
Date:   Mon, 8 Mar 2021 09:00:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        ejb@linux.ibm.com, stanley.chu@mediatek.com, cang@codeaurora.org,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] scsi: ufshcd: switch to a version macro
Message-ID: <20210308080013.GE983@lst.de>
References: <20210308005739.1998483-1-caleb@connolly.tech> <20210308005739.1998483-2-caleb@connolly.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308005739.1998483-2-caleb@connolly.tech>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This looks like a really nice improvement!

A bunch of comments below:

> @@ -696,10 +685,21 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
>   */
>  static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
>  {
> +	u32 ufshci_ver;

missing eempty line after the declaration.

>  	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION)
> +		ufshci_ver = ufshcd_vops_get_ufs_hci_version(hba);
> +	else
> +		ufshci_ver = ufshcd_readl(hba, REG_UFS_VERSION);
>  
> +	/*
> +	 * UFSHCI v1.x uses a different version scheme, in order
> +	 * to allow the use of comparisons with the UFSHCI_VER
> +	 * macro, we convert it to the same scheme as ufs 2.0+.
> +	 */
> +	if (ufshci_ver & 0x00010000)
> +		ufshci_ver = UFSHCI_VER(1, ufshci_ver & 0x00000100);
> +
> +	return ufshci_ver;

I'd use early returns here to clean this up a bit:

 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION)
		ufshci_ver = ufshcd_vops_get_ufs_hci_version(hba);

	...
	ufshci_ver = ufshcd_readl(hba, REG_UFS_VERSION);
	if (ufshci_ver & 0x00010000)
		return UFSHCI_VER(1, ufshci_ver & 0x00000100);
	return ufshci_ver;

> +#define UFSHCI_VER(major, minor) \
> +	((major << 8) + (minor << 4))

This needs braces around major and minor.  Or better just convert it
to an inline function (and use a lower case name).
