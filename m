Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903EEC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 18:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1BD25230
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592765355;
	bh=CgDkoFeH/dfgT+MnlSX5z47YEH6DHW4iEWxldmfyS9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BHE/CM1Ce2uns3Ln8L1PFbYTZcLZ2dbBXy0LrQhb7bVma+7rnAgQEjiXNBCSVZThX
	 9mUIYp7Vv61O6EzwOUD6Yj8b6wdT1a++XrL5n1/GxQ6LTANqlYxEKDTG5mmqIQgkXo
	 n24E70BqRyTmj7j6V+bsAht8qnyZUt9UjVT6N5sU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgFUStP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 14:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgFUStO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Jun 2020 14:49:14 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7EE225227;
        Sun, 21 Jun 2020 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592765354;
        bh=CgDkoFeH/dfgT+MnlSX5z47YEH6DHW4iEWxldmfyS9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ho8+kOa4AhMHnOp4OEIew/UyxuziLQGdb5LHezDLV60Rr3Cgx8nJSshl+d7rMSJ6B
         8NniZuWHSRk0kIXBzB37Rm8u9yQZVq/gS/032UpH4bmFQUMQPJlKjB/4HYmcHy0EKL
         DITXiaFa7yTEohLNPAzKf7TOE2LopKLWXqRbuz2Q=
Date:   Sun, 21 Jun 2020 11:49:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v2 0/3] Inline Encryption support for UFS
Message-ID: <20200621184912.GB1140@sol.localdomain>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
 <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
 <20200621182436.GB1518@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621182436.GB1518@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 21, 2020 at 06:24:36PM +0000, Satya Tangirala wrote:
> 
> > Today, chipset vendors are using a different scheme for their IE.
> > Need their ack before reviewing your patches.
> > 
> Sure :). The Inline Encryption patches (the block layer, fscrypt, f2fs,
> ext4 and these UFS patches) have been part of the Android common kernel
> https://android.googlesource.com/kernel/common/
> for quite a while now, and chipset vendors have been working with us
> on ensuring that their UFS cards are supported by these patches (by adding
> code similar to Eric's RFC: Inline crypto support on DragonBoard 845c at
> https://www.spinics.net/lists/linux-scsi/msg141472.html
> or Mediatek's "scsi: ufs-mediatek: add inline encryption support" at
> https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/
> for their individual chipsets).

Just as a practical matter, I don't think this patchset should be blocked
waiting for a formal Acked-by from every vendor, as some of them don't to be
participating in LKML at all despite being Cc'ed on these patches for a year and
working with us outside LKML to support their hardware using the new framework.
So I think a formal Acked-by on LKML is not always guaranteed.  (It would
certainly be preferable if everyone would participate though!)

- Eric
