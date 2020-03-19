Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680CCC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FA920B1F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 15:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fhq94E+q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbgCSPIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 11:08:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24357 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgCSPIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 11:08:19 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200319150817epoutp0204468051d22d7bc78845d0820576af6b~9vQqlpHbk2087320873epoutp02E
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 15:08:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200319150817epoutp0204468051d22d7bc78845d0820576af6b~9vQqlpHbk2087320873epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584630497;
        bh=YSu631xNjSaldYtkUAPYXwEIP9wwS2l1NIeJ7so281I=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=fhq94E+qwe80s4mU+NsqyYt+VouJmay0yZb54lwIH+NPQSKU3UQf4qPWcZbmUGpSa
         m/khDOcX/gxdj6/DwwMDVKwhwGqN26zPBO1aM7hEe5moIY3DrhQ6n9SmJLbwbyXgAU
         3J10aIPswzftYdU/82aMtqe4ayMkpKSVEAw51oGE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200319150816epcas5p23ac527cf61f392d3f1cb9fa01f7425df~9vQqP2k4m1427414274epcas5p2j;
        Thu, 19 Mar 2020 15:08:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.39.04736.0EA837E5; Fri, 20 Mar 2020 00:08:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150815epcas5p2a38c516887869b9fac421e31893e190e~9vQpJsKds0318203182epcas5p2r;
        Thu, 19 Mar 2020 15:08:15 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200319150815epsmtrp253e4e10c920d9a2dbc27b949b5000f98~9vQpJB9Q01615016150epsmtrp2C;
        Thu, 19 Mar 2020 15:08:15 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-b5-5e738ae08200
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.C7.04158.FDA837E5; Fri, 20 Mar 2020 00:08:15 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200319150814epsmtip2cb3da31c4551ffe856cf0bfb93e33ab4~9vQoOQpvh0558705587epsmtip2v;
        Thu, 19 Mar 2020 15:08:14 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Julia Lawall'" <julia.lawall@inria.fr>
Cc:     <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.2003191028360.3010@hadrien>
Subject: RE: [PATCH v2 4/5] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Thu, 19 Mar 2020 20:38:13 +0530
Message-ID: <000001d5fe00$3713fe90$a53bfbb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMOJRnv04d+r13ahNm/yTnqp3OKywI8yl0Zpc3PrsA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdlhTQ/dBV3Gcwe3H5hbzj5xjtWha1c9s
        0X19B5tF694j7A4sHpNeHGLx2LSqk83j8ya5AOYoLpuU1JzMstQifbsErowTkzazFpywrNhw
        7zNLA+NV/S5GTg4JAROJHwfaWbsYuTiEBHYzSvy5+4UJwvnEKPF39gyozDdGiaf7FgE5HGAt
        d6/ZQ8T3Mkrc+r2ZESQuJPCKUaJXF2Qqm4CuxI7FbWwgYREBHYlLT/lAwswCYRIdNx8xg9ic
        ApYSN469ZQexhQVCJP6/+gRmswioSiy/eJoJxOYFqlm/ZxI7hC0ocXLmExaIOfIS29/OYYZ4
        QEHi59NlrCC2iICVxKPVT1khasQljv7sYQY5U0LgBJvEitW72SEaXCRWX5oKZQtLvDq+BcqW
        kvj8bi8bxIvZEj27jCHCNRJL5x1jgbDtJQ5cmcMCUsIsoCmxfpc+xCo+id7fT5ggOnklOtqE
        IKpVJZrfXYXqlJaY2N3NCmF7SHR3TmWfwKg4C8ljs5A8NgvJA7MQli1gZFnFKJlaUJybnlps
        WmCcl1quV5yYW1yal66XnJ+7iRGcTLS8dzBuOudziFGAg1GJh3dGW3GcEGtiWXFl7iFGCQ5m
        JRFe3XSgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5JrFdjhATSE0tSs1NTC1KLYLJMHJxSDYy9
        dlPYl9QJOD9/MZuhYar4xq1h+pN7L1lnvNusZOgyZ9nhcqOANsG1R8RbdIzOzov707as7+vu
        2Z4MJr5fTzBZ2cxkP7BSRiMoOIurZNcEK/WOnQvm6ztsC5/wfL2FRJlHyepsCV9dm0uG/jUd
        r50FJnre3nLO48Uy7e9p7xb+3PHt7+a5Bp1KLMUZiYZazEXFiQCRsk8xIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWy7bCSvO79ruI4g50tWhbzj5xjtWha1c9s
        0X19B5tF694j7A4sHpNeHGLx2LSqk83j8ya5AOYoLpuU1JzMstQifbsErowTkzazFpywrNhw
        7zNLA+NV/S5GDg4JAROJu9fsuxi5OIQEdjNKnLo3k6WLkRMoLi1xfeMEdghbWGLlv+dgtpDA
        C0aJqf3yIDabgK7EjsVtbCBzRAR0JC495QMJMwtESMx4+IENYmYXo8TEv62MIAlOAUuJG8fe
        gs0RFgiSmLPnPiuIzSKgKrH84mkmEJsXqGb9nknsELagxMmZT1hA5jML6Em0bWSEmC8vsf3t
        HGaI0xQkfj5dBjZGRMBK4tHqp6wQNeISR3/2ME9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi
        3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4KjQ0trBeOJE/CFGAQ5GJR5eh5biOCHWxLLiytxD
        jBIczEoivLrpQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK88vnHIoUE0hNLUrNTUwtSi2CyTByc
        Ug2ME58vtJAvObFlLddBFw6XBQFzjFMv35oaZZSxf2Pp8+tJrsueRh3/I/WmWjuw89ismcFN
        xt9XrUg307i+SdViSV/enZbL054Lyr94riF7V0R6ofKeC1Wviy4WvZtn397Ql/ejy4HTZ9KU
        t99v7hdk0NDd++jB7cW7eR+GKMfscu1457Kuf/KUJ0osxRmJhlrMRcWJAJLHZI2GAgAA
X-CMS-MailID: 20200319150815epcas5p2a38c516887869b9fac421e31893e190e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319092934epcas5p2442a8a995c1028ad7beb76bbe137aed9
References: <CGME20200319092934epcas5p2442a8a995c1028ad7beb76bbe137aed9@epcas5p2.samsung.com>
        <alpine.DEB.2.21.2003191028360.3010@hadrien>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Julia

> -----Original Message-----
> From: Julia Lawall <julia.lawall@inria.fr>
> Sent: 19 March 2020 14:59
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh+dt@kernel.org; devicetree@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 4/5] scsi: ufs-exynos: add UFS host support for
Exynos
> SoCs
> 
> Perhaps this is intentional, but please check lines 931-935.
> 
> julia
> 
> ---------- Forwarded message ----------
> Date: Thu, 19 Mar 2020 09:31:14 +0800
> From: kbuild test robot <lkp@intel.com>
> To: kbuild@lists.01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [PATCH v2 4/5] scsi: ufs-exynos: add UFS host support for
Exynos
>     SoCs
> 
> CC: kbuild-all@lists.01.org
> In-Reply-To: <20200318111144.39525-5-alim.akhtar@samsung.com>
> References: <20200318111144.39525-5-alim.akhtar@samsung.com>
> TO: Alim Akhtar <alim.akhtar@samsung.com>
> CC: robh+dt@kernel.org, devicetree@vger.kernel.org, linux-
> scsi@vger.kernel.org
> 
> Hi Alim,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on phy/next]
> [also build test WARNING on scsi/for-next robh/for-next mkp-scsi/for-next
v5.6-
> rc6 next-20200318] [if your patch is applied to the wrong git tree, please
drop us
> a note to help improve the system. BTW, we also suggest to use '--base'
option
> to specify the base tree in git format-patch, please see
> https://stackoverflow.com/a/37406982]
> 
> url:    https://protect2.fireeye.com/url?k=03b4933f-5e785abb-03b51870-
> 0cc47aa8f5ba-1d3ee5e67b031afb&u=https://github.com/0day-
> ci/linux/commits/Alim-Akhtar/exynos-ufs-Add-support-for-UFS-HCI/20200319-
> 022156
> base:
https://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next
> :::::: branch date: 7 hours ago
> :::::: commit date: 7 hours ago
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> 
Thanks for review, I have just fixed this and posted V3, PTAL

> >> drivers/scsi/ufs/ufs-exynos.c:931:8-10: WARNING: possible condition
> >> with no effect (if == else)
> 
> # https://protect2.fireeye.com/url?k=8ebed792-d3721e16-8ebf5cdd-
> 0cc47aa8f5ba-3629a5edceef073b&u=https://github.com/0day-
> ci/linux/commit/a0a2731081dba4edfad146c501203adb97d5947b
> git remote add linux-review https://protect2.fireeye.com/url?k=c8ef01ac-
> 9523c828-c8ee8ae3-0cc47aa8f5ba-
> 8639b30cb2586a0f&u=https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout a0a2731081dba4edfad146c501203adb97d5947b
> vim +931 drivers/scsi/ufs/ufs-exynos.c
> 
> a0a2731081dba4 Alim Akhtar 2020-03-18  898
> a0a2731081dba4 Alim Akhtar 2020-03-18  899  static void
> exynos_ufs_specify_pwr_mode(struct device_node *np,
> a0a2731081dba4 Alim Akhtar 2020-03-18  900
struct
> exynos_ufs *ufs)
> a0a2731081dba4 Alim Akhtar 2020-03-18  901  {
> a0a2731081dba4 Alim Akhtar 2020-03-18  902  	struct uic_pwr_mode *pwr =
> &ufs->pwr_req;
> a0a2731081dba4 Alim Akhtar 2020-03-18  903  	const char *str = NULL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  904
> a0a2731081dba4 Alim Akhtar 2020-03-18  905  	if
> (!of_property_read_string(np, "ufs,pwr-attr-mode", &str)) {
> a0a2731081dba4 Alim Akhtar 2020-03-18  906  		if (!strncmp(str,
> "FAST", sizeof("FAST")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  907  			pwr->mode =
> FAST_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  908  		else if
(!strncmp(str,
> "SLOW", sizeof("SLOW")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  909  			pwr->mode =
> SLOW_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  910  		else if
(!strncmp(str,
> "FAST_auto", sizeof("FAST_auto")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  911  			pwr->mode =
> FASTAUTO_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  912  		else if
(!strncmp(str,
> "SLOW_auto", sizeof("SLOW_auto")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  913  			pwr->mode =
> SLOWAUTO_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  914  		else
> a0a2731081dba4 Alim Akhtar 2020-03-18  915  			pwr->mode =
> FAST_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  916  	} else {
> a0a2731081dba4 Alim Akhtar 2020-03-18  917  		pwr->mode =
> FAST_MODE;
> a0a2731081dba4 Alim Akhtar 2020-03-18  918  	}
> a0a2731081dba4 Alim Akhtar 2020-03-18  919
> a0a2731081dba4 Alim Akhtar 2020-03-18  920  	if (of_property_read_u32(np,
> "ufs,pwr-attr-lane", &pwr->lane))
> a0a2731081dba4 Alim Akhtar 2020-03-18  921  		pwr->lane = 1;
> a0a2731081dba4 Alim Akhtar 2020-03-18  922
> a0a2731081dba4 Alim Akhtar 2020-03-18  923  	if (of_property_read_u32(np,
> "ufs,pwr-attr-gear", &pwr->gear))
> a0a2731081dba4 Alim Akhtar 2020-03-18  924  		pwr->gear = 1;
> a0a2731081dba4 Alim Akhtar 2020-03-18  925
> a0a2731081dba4 Alim Akhtar 2020-03-18  926  	if
> (IS_UFS_PWR_MODE_HS(pwr->mode)) {
> a0a2731081dba4 Alim Akhtar 2020-03-18  927  		if
> (!of_property_read_string(np,
> a0a2731081dba4 Alim Akhtar 2020-03-18  928
> 	"ufs,pwr-attr-hs-series", &str)) {
> a0a2731081dba4 Alim Akhtar 2020-03-18  929  			if
> (!strncmp(str, "HS_rate_b", sizeof("HS_rate_b")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  930  				pwr-
> >hs_series = PA_HS_MODE_B;
> a0a2731081dba4 Alim Akhtar 2020-03-18 @931  			else if
> (!strncmp(str, "HS_rate_a",
> a0a2731081dba4 Alim Akhtar 2020-03-18  932
> 	sizeof("HS_rate_a")))
> a0a2731081dba4 Alim Akhtar 2020-03-18  933  				pwr-
> >hs_series = PA_HS_MODE_A;
> a0a2731081dba4 Alim Akhtar 2020-03-18  934  			else
> a0a2731081dba4 Alim Akhtar 2020-03-18  935  				pwr-
> >hs_series = PA_HS_MODE_A;
> a0a2731081dba4 Alim Akhtar 2020-03-18  936  		} else {
> a0a2731081dba4 Alim Akhtar 2020-03-18  937  			pwr-
> >hs_series = PA_HS_MODE_A;
> a0a2731081dba4 Alim Akhtar 2020-03-18  938  		}
> a0a2731081dba4 Alim Akhtar 2020-03-18  939  	}
> a0a2731081dba4 Alim Akhtar 2020-03-18  940
> a0a2731081dba4 Alim Akhtar 2020-03-18  941  	if
> (of_property_read_u32_array(
> a0a2731081dba4 Alim Akhtar 2020-03-18  942  		np,
"ufs,pwr-local-l2-
> timer", pwr->l_l2_timer, 3)) {
> a0a2731081dba4 Alim Akhtar 2020-03-18  943  		pwr->l_l2_timer[0] =
> FC0PROTTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  944  		pwr->l_l2_timer[1] =
> TC0REPLAYTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  945  		pwr->l_l2_timer[2] =
> AFC0REQTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  946  	}
> a0a2731081dba4 Alim Akhtar 2020-03-18  947
> a0a2731081dba4 Alim Akhtar 2020-03-18  948  	if
> (of_property_read_u32_array(
> a0a2731081dba4 Alim Akhtar 2020-03-18  949  		np, "ufs,pwr-remote-
> l2-timer", pwr->r_l2_timer, 3)) {
> a0a2731081dba4 Alim Akhtar 2020-03-18  950  		pwr->r_l2_timer[0] =
> FC0PROTTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  951  		pwr->r_l2_timer[1] =
> TC0REPLAYTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  952  		pwr->r_l2_timer[2] =
> AFC0REQTIMEOUTVAL;
> a0a2731081dba4 Alim Akhtar 2020-03-18  953  	}
> a0a2731081dba4 Alim Akhtar 2020-03-18  954  }
> a0a2731081dba4 Alim Akhtar 2020-03-18  955
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://protect2.fireeye.com/url?k=c28ebd30-9f4274b4-c28f367f-
>
0cc47aa8f5ba-85fd58e3389c5682&u=https://lists.01.org/hyperkitty/list/kbuild-
> all@lists.01.org

