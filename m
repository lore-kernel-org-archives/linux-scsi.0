Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3D3C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB64622D01
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 01:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLUBpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 20:45:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39262 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgLUBpv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 20:45:51 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201221014507epoutp04535e17db32ec11a69393192d13e9b922~Sl-fgCIZJ2875828758epoutp04I
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 01:45:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201221014507epoutp04535e17db32ec11a69393192d13e9b922~Sl-fgCIZJ2875828758epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608515107;
        bh=wW9eOGVnw0tX2IV78vXavuXpNxOc0KjQOWnEIasj0Z8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=X9T8tuF8+wI/vMu7mkIX7z+DdoXVVkhc56/x9Am4Z5GBQV/nELoHa7ggjZjVrKyGF
         z6cQMDzcdGQFJsNV44vGq/GZZyaoDHDFRl5DQ3vH0gYPm9GvqHc341w6ndQB8QUu45
         DL7aZun6ipexOGih7ebpZQHRUQFkTZnJ/VLBqtEE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201221014506epcas2p29f52acdb997c4ae5f492110530edb3cd~Sl-enBl_Q3106431064epcas2p2M;
        Mon, 21 Dec 2020 01:45:06 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Czj2l6gZLzMqYkw; Mon, 21 Dec
        2020 01:45:03 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.88.56312.C1EFFDF5; Mon, 21 Dec 2020 10:45:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201221014459epcas2p2f3607efcfa7cb4cffdc11044e2f8aa85~Sl-XwJEF33160831608epcas2p2Y;
        Mon, 21 Dec 2020 01:44:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201221014459epsmtrp125f22ce699e7f4f337888f4836f25ca5~Sl-XvGp4i1038410384epsmtrp1E;
        Mon, 21 Dec 2020 01:44:59 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-28-5fdffe1cd229
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.FD.13470.B1EFFDF5; Mon, 21 Dec 2020 10:44:59 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201221014459epsmtip210ee3f7043925bec3580bd49ad046555~Sl-XXqTIc3032330323epsmtip2P;
        Mon, 21 Dec 2020 01:44:59 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <3d662ee3155a56108da13e3cf12f17dc@codeaurora.org>
Subject: RE: [RFC PATCH v1] ufs: relocate turning off device power sources
Date:   Mon, 21 Dec 2020 10:44:58 +0900
Message-ID: <000001d6d73a$e44dd770$ace98650$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJLfxHPx6Q41o+I4PzRMFqDoBiEHwG+6GE2AhZXzmuo+Mws0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmqa7Mv/vxBn8Xclk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjI+3F3EWDBTuKJzwn6mBsZW/i5GTg4JAROJHb+msHcxcnEICexglNix6wEbhPOJUeJ563Nm
        COcbo8SNrYeAMhxgLXN3+UDE9zJKbHy6BKr9BaNE56YmZpC5bALaEtMe7mYFsUUEVCXetZ4H
        G8sscJFJ4lJDLztIglPATuLV5h6wBmEBL4nGDbvANrAANcw9GQli8gpYSnxYaAtSwSsgKHFy
        5hMWEJtZwEDi/bn5zBC2vMT2t3OYId5RkPj5dBnUWieJO9Mns0LUiEjM7mwDe0ZC4AGHxNG3
        J9ggGlwkVm6dwQphC0u8Or6FHcKWknjZ3wZl10vsm9rACtHcwyjxdN8/RoiEscSsZ+2MkFBR
        ljhyC+o4PomOw3/ZIcK8Eh1tQhDVyhK/Jk2G6pSUmHnzDvsERqVZSF6bheS1WUhem4XkhQWM
        LKsYxVILinPTU4uNCoyQY3sTIzhRa7ntYJzy9oPeIUYmDsZDjBIczEoivGZS9+OFeFMSK6tS
        i/Lji0pzUosPMZoCw3ois5Rocj4wV+SVxBuaGpmZGViaWpiaGVkoifOGruyLFxJITyxJzU5N
        LUgtgulj4uCUamDqL5hfIhkkOL04YUKCJX9c5Z2N91xEOCevbag/MV3jq0zfN+Vdc4LONlzv
        /G+qtKTwXLzb7ysKk9+uftVvcy/P6vvvz9u/eoZGLEteFnPsWYdjeP6hec5WR8LTN4Qobjk6
        e3fY9r8JQp/aePodP7/Uvt3145MRk+lV7vkr+pbI/QtO1m32d8kSqFgqstE0oihmNuMuh/hv
        gSIaUR8fLCh7zbFpaSxT+jLNQxvuTpN/YHEtQFvp6qdr6vYmQYv/LnPlCXjF95pLYLmRgkH1
        nqR5NR1hPMy6kze3L2T626f7ye5EiPWzik3fzz15NsnbI6WX8XQdH1PaiaDDYRky52o+5SX4
        fDumG6f7v0koLlmJpTgj0VCLuag4EQDP4ayoXQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSvK70v/vxBpPeilg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZH+4uYiyYKVzROWE/UwNjK38XIweHhICJxNxdPl2MXBxCArsZJba3
        L2TsYuQEiktKnNj5HMoWlrjfcoQVougZUNH7o6wgCTYBbYlpD3eD2SICqhLvWs+zgRQxCzxk
        klg4+QYbRMdJRoktL/qZQKo4BewkXm3uYQaxhQW8JBo37GIDOYMFqHvuyUgQk1fAUuLDQluQ
        Cl4BQYmTM5+wgNjMAkYS5w7tZ4Ow5SW2v53DDHGcgsTPp8ugbnCSuDN9MitEjYjE7M425gmM
        wrOQjJqFZNQsJKNmIWlZwMiyilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOF61NHcw
        bl/1Qe8QIxMH4yFGCQ5mJRFeM6n78UK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8s
        Sc1OTS1ILYLJMnFwSjUw5Z4MzVw3q/enjilrlOu1ZTKpDS8itkxK3LZhk6Rpna3Rvo5Nv65P
        1u8uKj0id8H5JfuNE6FmP6dK/KhlOh0v3PYmzr5FTu3DV/EnMzcKafjMSWebcerhbWtrq3l+
        atqzT50vNzm7Rlbl9x5fvYwZrLcv+nOUNR6et+floWlrt8ssaKpjX9WoxbxEcUJ9U9gj9TnT
        rVSN9Upy/b/smLBh61dBabbUhRYcagXFhzaEhicJPeG1+Pacod/sEIe1Rd2qM7sFBZO9W5mX
        zDSo/Ja1VK/o3MnKbT7aW8I5Ezf+VPiu92mn2+PFHZaWkzW35c3JXmwy4dAtLyNO28N6/MF1
        nWnn/jNuCp6lI79Pcf4kJZbijERDLeai4kQA8iBehUYDAAA=
X-CMS-MailID: 20201221014459epcas2p2f3607efcfa7cb4cffdc11044e2f8aa85
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599
References: <CGME20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599@epcas2p1.samsung.com>
        <1608359248-16079-1-git-send-email-kwmad.kim@samsung.com>
        <3d662ee3155a56108da13e3cf12f17dc@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-12-19 14:27, Kiwoong Kim wrote:
> > UFS specification says that while powering off the device, RST_n
> > signal and REF_CLK signal should be between VSS and VCCQ.
> > One of ways to make it is to drive both RST_n and REF_CLK to low.
> >
> > However, the current location of turning off them doesn't guarantee
> > that. ufshcd_link_state_transition make enter hibern8 but it's not
> > supposed to adjust the level of REF_CLK. Adding
> > ufshcd_vops_device_reset isn't proper because it just drives the level
> > of RST_n to low and then to high, not keep low.
> > In this situation, it could make those levels be diverged from those
> > proper ranges with actual hardware situations, especially right when
> > the driver turns off power.
> >
> > The easist way to make it is just to move the location of turning off
> > because lowering the levels can be enabled through the callbacks named
> > suspend and setup_clocks.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 92d433d..dab9840 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -8633,8 +8633,6 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  	if (ret)
> >  		goto set_dev_active;
> >
> > -	ufshcd_vreg_set_lpm(hba);
> > -
> >  disable_clks:
> >  	/*
> >  	 * Call vendor specific suspend callback. As these callbacks may
> > access @@ -8662,6 +8660,13 @@ static int ufshcd_suspend(struct ufs_hba
> > *hba, enum ufs_pm_op pm_op)
> >  					hba->clk_gating.state);
> >  	}
> >
> > +	/*
> > +	 * It should follows driving RST_n and REF_CLK
> > +	 * in the range specified in UFS specification
> > +	 */
> > +	if (!ufshcd_is_ufs_dev_active(hba))
> > +		ufshcd_vreg_set_lpm(hba);
> > +
> >  	/* Put the host controller in low power mode if possible */
> >  	ufshcd_hba_vreg_set_lpm(hba);
> >  	goto out;
> 
> Ziqi Chen has a change to totally fix the UFS power-on/off spec violation,
> see https://lore.kernel.org/patchwork/patch/1351118/ and he is working on
> V2, can we wait for his change? 

Two questions.
1. If his patch covers what I said, it's okay.
2. What does he plan to post?
What do you think?

Thanks.
Kiwoong Kim
> 
> Thanks,
> 
> Can Guo.

