Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC24C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 371392072E
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rdn+AaLv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgGUJr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:47:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31624 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUJrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:47:55 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200721094750epoutp029b8827b9c3869a4d3c4c423e40c75925~ju4SE8q2N2635726357epoutp02K
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:47:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200721094750epoutp029b8827b9c3869a4d3c4c423e40c75925~ju4SE8q2N2635726357epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595324870;
        bh=e7IiumoLPPREUSG7uzutx19/HNb7AgTU0TGJLB7p9Iw=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=rdn+AaLv/LrXBJ3B8cUOHCGyzS5KOgURs/ZkrGqmgrrXhPOe2X/b1lzV07TmBui++
         nRHR63ddnbWX1Ezo7rNhhlgg3k+HafwqaBD07tAGo3DasFll6uDjl+xm1mxQsOZlfK
         ntywS9+o0hYa1jlb6GHJlJit2zdvkaSdhesGxbiw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200721094750epcas2p4e70062a8d477b7da9412cfffabb8804e~ju4RqRBNB2430224302epcas2p4x;
        Tue, 21 Jul 2020 09:47:50 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B9v0M1T2KzMqYkZ; Tue, 21 Jul
        2020 09:47:47 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.6E.19322.2C9B61F5; Tue, 21 Jul 2020 18:47:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200721094745epcas2p29c55fdfe4d42cb9f79930a95698bb86c~ju4Ne824O1275512755epcas2p2F;
        Tue, 21 Jul 2020 09:47:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721094745epsmtrp270702069305f6edd0012999813be8eab~ju4NeG3KX3015130151epsmtrp2k;
        Tue, 21 Jul 2020 09:47:45 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-9a-5f16b9c2f42c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.69.08303.1C9B61F5; Tue, 21 Jul 2020 18:47:45 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200721094745epsmtip2f9846715cbb1d81c555c4bc9f12b032a~ju4NS9A5d3033030330epsmtip26;
        Tue, 21 Jul 2020 09:47:45 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Asutosh Das \(asd\)'" <asutoshd@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <588c1a29-38b9-8c5f-d9c5-899272b9f3a3@codeaurora.org>
Subject: RE: [RFC PATCH v2 3/3] scsi: ufs: add vendor specific write booster
 To support the fuction of writebooster by vendor. The WB behavior that the
 vendor wants is slightly different. But we have to support it
Date:   Tue, 21 Jul 2020 18:47:45 +0900
Message-ID: <02dd01d65f43$fc837710$f58a6530$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIfIxEdsYJ1mLdzVGY1rs4r3TVr7QGX/GqsAi1+KxwBLEWACKhYQwMQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmue6hnWLxBmsX8Fg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTkbHwt9MBc9yK1ZsnMPWwDgtrIuR
        k0NCwERi45LzzF2MXBxCAjsYJe4v3skI4XxilLj+bTJU5jOjxL+Z89m6GDnAWo7+gSraxSjx
        7e4/qKKXjBKz975mA5nLJmAq0bdtBStIQkRgHpPEhb+vWEESnAJOElferWUDSQgL3GSU6NzV
        AJZgEVCVuLxsEzuIzStgKdH7eAUzhC0ocXLmExYQm1lAXmL72znMEJcrSOw4+5oRxBYRcJOY
        MnEbE0SNiMTszjawkyQE9nBInD3YCtXgInF/93wWCFtY4tXxLewQtpTE53d72SDseokp91ax
        QDT3MErsWXGCCSJhLDHrWTsjKACYBTQl1u/Sh4SFssSRW1C38Ul0HP7LDhHmlehoE4JoVJI4
        M/c2VFhC4uDsHIiwh0THh/uMExgVZyF5chaSJ2cheWYWwtoFjCyrGMVSC4pz01OLjQoMkWN7
        EyM4AWu57mCc/PaD3iFGJg7GQ4wSHMxKIrwTeYTjhXhTEiurUovy44tKc1KLDzGaAoN9IrOU
        aHI+MAfklcQbmhqZmRlYmlqYmhlZKInz5ipeiBMSSE8sSc1OTS1ILYLpY+LglGpgYsjp+s2n
        lm3zuu69f8H1Kbe/8SgI/m5NP/5h6/ek4937k7JiahY6d68Qs/708XvkC9UP2QXqn3VFBTdx
        MJ9yeHjiz4MMyzId771vai+4XzTaaTiLI9pJjvfg9DO8jDevpbNlTykpvWKQGvH3k5gNh/tp
        rskhKaFZgewbv2xWdlz1tugaz+fO2z6ZbsZcbZqcn9zqXtVPu3Uy4/H2gwvvbquMqj6oFSBb
        zuUgsrVKLe6RcopM0MPpbUcCzIP8nmZnZhnOSW8RfF7WeKz6ZsNPYam+K9+W3Jr96cICu7XZ
        8mGV518v45maGrPudarZp7n/n/vcWSG/vfRLf1lyYofS+kM/E9WPcN6ySnzBtv+oEktxRqKh
        FnNRcSIANHveLEkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO7BnWLxBpdvGFs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugSujY+FvpoJn
        uRUrNs5ha2CcFtbFyMEhIWAicfQPYxcjF4eQwA5GiYfrz7N1MXICxSUk/i9uYoKwhSXutxxh
        hSh6zijx4fNCFpAEm4CpRN+2FWAJEYEVTBKr909kg6jqY5J48noBI0gVp4CTxJV3a8ESwgJX
        GSWWf1jCDpJgEVCVuLxsE5jNK2Ap0ft4BTOELShxcuYTsBXMAtoSvQ9bGSFseYntb+cwQ9yk
        ILHj7GuwuIiAm8SUiduYIGpEJGZ3tjFPYBSahWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWG
        BUZ5qeV6xYm5xaV56XrJ+bmbGMFRp6W1g3HPqg96hxiZOBgPMUpwMCuJ8E7kEY4X4k1JrKxK
        LcqPLyrNSS0+xCjNwaIkzvt11sI4IYH0xJLU7NTUgtQimCwTB6dUA1PYjN2MUqbCngZlD7gY
        pro80JMN2fTwxbbH51Ymq1+Je+ynLJnstX3OhtoF6WWiDclvltesVtmrX58twzbl8cqZXqlz
        XzgaOugxxmzhNuyfuuncrp6fmwUmFObK8RzsiZ19+MQd8/33Lzt3X4pY0HVK7/5drksli++E
        3P3jZW/8UHXyx2P9z+9uEpo785Cp8tM7aZtdjXhmskvqMostucyaNHHVy4T9/B2SudzsXCbv
        HjOlF6cF9f2XF3a/8ujE6f+v3v1Nsphtv+j2yllcxu033oQ0Xjr+8Y7BQoXTeW87268y3bFn
        ffb8YKlnneH17eqhr6sZ7k6SCF3TIbf12F77E7M+W0UxfljaFDG18X+GEktxRqKhFnNRcSIA
        rGDxQSkDAAA=
X-CMS-MailID: 20200721094745epcas2p29c55fdfe4d42cb9f79930a95698bb86c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103951epcas2p246072985a70a459f0acb31d339298a47
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103951epcas2p246072985a70a459f0acb31d339298a47@epcas2p2.samsung.com>
        <5be595eb83365ec97a8ee0ddafb748029ee8cdf9.1595240433.git.hy50.seo@samsung.com>
        <588c1a29-38b9-8c5f-d9c5-899272b9f3a3@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: asutoshd=codeaurora.org@mg.codeaurora.org
> [mailto:asutoshd=codeaurora.org@mg.codeaurora.org] On Behalf Of Asutosh
> Das (asd)
> Sent: Tuesday, July 21, 2020 1:55 AM
> To: SEO HOYOUNG; linux-scsi@vger.kernel.org; alim.akhtar@samsung.com;
> avri.altman@wdc.com; jejb@linux.ibm.com; martin.petersen@oracle.com;
> beanhuo@micron.com; cang@codeaurora.org; bvanassche@acm.org;
> grant.jung@samsung.com
> Subject: Re: [RFC PATCH v2 3/3] scsi: ufs: add vendor specific write
> booster To support the fuction of writebooster by vendor. The WB behavior
> that the vendor wants is slightly different. But we have to support it
> 
> On 7/20/2020 3:40 AM, SEO HOYOUNG wrote:
> > Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> > ---
> >   drivers/scsi/ufs/Makefile     |   1 +
> >   drivers/scsi/ufs/ufs-exynos.c |   6 +
> >   drivers/scsi/ufs/ufs_ctmwb.c  | 279 ++++++++++++++++++++++++++++++++++
> >   drivers/scsi/ufs/ufs_ctmwb.h  |  27 ++++
> >   4 files changed, 313 insertions(+)
> >   create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
> >   create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h
> >
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 9810963bc049..b1ba36c7d66f 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > @@ -5,6 +5,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-
> pltfrm.o ufshcd-dwc.o tc-d
> >   obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
> >   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> >   obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
> > +obj-$(CONFIG_SCSI_UFS_VENDOR_WB) += ufs_ctmwb.o
> >   obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
> >   ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> >   ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> > diff --git a/drivers/scsi/ufs/ufs-exynos.c
> > b/drivers/scsi/ufs/ufs-exynos.c index 32b61ba77241..f127f5f2bf36
> > 100644
> > --- a/drivers/scsi/ufs/ufs-exynos.c
> > +++ b/drivers/scsi/ufs/ufs-exynos.c
> > @@ -22,6 +22,9 @@
> >
> 
> To me it looks like, you want to have your own flush policy &
> initializations etc, is that understanding correct?
> I don't understand why though. The current implementation is spec
> compliant. If there're benefits that you see in this implementation,
> please highlight those. It'd be interesting to see that.

Yes. I want to own flush policy, initialization.. 
I already know current implementation is spec compliant.
But some vendor want to change flush policy.
So we modify below code.
Additionally when use below code, we can use WB without UFS 3.1 devices
> 
> 
> >   #include "ufs-exynos.h"
> >
> > +#ifdef CONFIG_SCSI_UFS_VENDOR_WB
> > +#include "ufs_ctmwb.h"
> > +#endif
> >   /*
> >    * Exynos's Vendor specific registers for UFSHCI
> >    */
> > @@ -989,6 +992,9 @@ static int exynos_ufs_init(struct ufs_hba *hba)
> >   		goto phy_off;
> >
> >   	ufs->hba = hba;
> > +#ifdef CONFIG_SCSI_UFS_VENDOR_WB
> > +	ufs->hba->wb_ops = ufshcd_ctmwb_init(); #endif
> >   	ufs->opts = ufs->drv_data->opts;
> >   	ufs->rx_sel_idx = PA_MAXDATALANES;
> >   	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX) diff --git
> > a/drivers/scsi/ufs/ufs_ctmwb.c b/drivers/scsi/ufs/ufs_ctmwb.c new file
> > mode 100644 index 000000000000..ab39f40721ae
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs_ctmwb.c
> > @@ -0,0 +1,279 @@
> > +#include "ufshcd.h"
> > +#include "ufshci.h"
> > +#include "ufs_ctmwb.h"
> > +
> > +static struct ufshba_ctmwb hba_ctmwb;
> > +
> > +/* Query request retries */
> > +#define QUERY_REQ_RETRIES 3
> > +
> > +static int ufshcd_query_attr_retry(struct ufs_hba *hba,
> > +	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
> > +	u32 *attr_val)
> > +{
> > +	int ret = 0;
> > +	u32 retries;
> > +
> > +	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> > +		ret = ufshcd_query_attr(hba, opcode, idn, index,
> > +						selector, attr_val);
> > +		if (ret)
> > +			dev_dbg(hba->dev, "%s: failed with error %d,
> retries %d\n",
> > +				__func__, ret, retries);
> > +		else
> > +			break;
> > +	}
> > +
> > +	if (ret)
> > +		dev_err(hba->dev,
> > +			"%s: query attribute, idn %d, failed with error %d
> after %d retires\n",
> > +			__func__, idn, ret, QUERY_REQ_RETRIES);
> > +	return ret;
> > +}
> > +
> > +static int ufshcd_query_flag_retry(struct ufs_hba *hba,
> > +	enum query_opcode opcode, enum flag_idn idn, bool *flag_res) {
> > +	int ret;
> > +	int retries;
> > +
> > +	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
> > +		ret = ufshcd_query_flag(hba, opcode, idn, flag_res);
> > +		if (ret)
> > +			dev_dbg(hba->dev,
> > +				"%s: failed with error %d, retries %d\n",
> > +				__func__, ret, retries);
> > +		else
> > +			break;
> > +	}
> > +
> > +	if (ret)
> > +		dev_err(hba->dev,
> > +			"%s: query attribute, opcode %d, idn %d, failed with
> error %d after %d retries\n",
> > +			__func__, (int)opcode, (int)idn, ret, retries);
> > +	return ret;
> > +}
> > +
> > +static int ufshcd_reset_ctmwb(struct ufs_hba *hba, bool force) {
> > +	int err = 0;
> > +
> > +	if (!hba_ctmwb.support_ctmwb)
> > +		return 0;
> > +
> > +	if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
> > +		dev_info(hba->dev, "%s: turbo write already disabled.
> ctmwb_state = %d\n",
> > +			__func__, hba_ctmwb.ufs_ctmwb_state);
> > +		return 0;
> > +	}
> > +
> > +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> > +		dev_err(hba->dev, "%s: previous turbo write control was
> failed.\n",
> > +			__func__);
> > +
> > +	if (force)
> > +		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> > +				QUERY_FLAG_IDN_WB_EN, NULL);
> > +
> > +	if (err) {
> > +		ufshcd_set_ctmwb_err(hba_ctmwb);
> > +		dev_err(hba->dev, "%s: disable turbo write failed. err
> = %d\n",
> > +			__func__, err);
> > +	} else {
> > +		ufshcd_set_ctmwb_off(hba_ctmwb);
> > +		dev_info(hba->dev, "%s: ufs turbo write disabled \n",
> __func__);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ufshcd_get_ctmwb_buf_status(struct ufs_hba *hba, u32
> > +*status) {
> > +	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> > +			QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE, 0, 0, status); }
> > +
> > +static int ufshcd_ctmwb_manual_flush_ctrl(struct ufs_hba *hba, int
> > +en) {
> > +	int err = 0;
> > +
> > +	dev_info(hba->dev, "%s: %sable turbo write manual flush\n",
> > +				__func__, en ? "en" : "dis");
> > +	if (en) {
> > +		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_SET_FLAG,
> > +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> > +		if (err)
> > +			dev_err(hba->dev, "%s: enable turbo write failed. err
> = %d\n",
> > +				__func__, err);
> > +	} else {
> > +		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> > +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> > +		if (err)
> > +			dev_err(hba->dev, "%s: disable turbo write failed. err
> = %d\n",
> > +				__func__, err);
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static int ufshcd_ctmwb_flush_ctrl(struct ufs_hba *hba) {
> > +	int err = 0;
> > +	u32 curr_status = 0;
> > +
> > +	err = ufshcd_get_ctmwb_buf_status(hba, &curr_status);
> > +
> > +	if (!err && (curr_status <= UFS_WB_MANUAL_FLUSH_THRESHOLD)) {
> > +		dev_info(hba->dev, "%s: enable ctmwb manual flush, buf
> status : %d\n",
> > +				__func__, curr_status);
> > +		scsi_block_requests(hba->host);
> > +		err = ufshcd_ctmwb_manual_flush_ctrl(hba, 1);
> > +		if (!err) {
> > +			mdelay(100);
> > +			err = ufshcd_ctmwb_manual_flush_ctrl(hba, 0);
> > +			if (err)
> > +				dev_err(hba->dev, "%s: disable ctmwb manual
> flush failed. err = %d\n",
> > +						__func__, err);
> > +		} else
> > +			dev_err(hba->dev, "%s: enable ctmwb manual flush
> failed. err = %d\n",
> > +					__func__, err);
> > +		scsi_unblock_requests(hba->host);
> > +	}
> > +	return err;
> > +}
> > +
> > +static int ufshcd_ctmwb_ctrl(struct ufs_hba *hba, bool enable) {
> > +	int err;
> > +#if 0
> Did you miss removing these #if 0?
I will modify this code.
> 
> > +	if (!hba->support_ctmwb)
> > +		return;
> > +
> > +	if (hba->pm_op_in_progress) {
> > +		dev_err(hba->dev, "%s: ctmwb ctrl during pm operation is not
> allowed.\n",
> > +			__func__);
> > +		return;
> > +	}
> > +
> > +	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> > +		dev_err(hba->dev, "%s: ufs host is not available.\n",
> > +			__func__);
> > +		return;
> > +	}
> > +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> > +		dev_err(hba->dev, "%s: previous turbo write control was
> failed.\n",
> > +			__func__);
> > +#endif
> > +	if (enable) {
> > +		if (ufshcd_is_ctmwb_on(hba_ctmwb)) {
> > +			dev_err(hba->dev, "%s: turbo write already enabled.
> ctmwb_state = %d\n",
> > +				__func__, hba_ctmwb.ufs_ctmwb_state);
> > +			return 0;
> > +		}
> > +		pm_runtime_get_sync(hba->dev);
> > +		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_SET_FLAG,
> > +					QUERY_FLAG_IDN_WB_EN, NULL);
> > +		if (err) {
> > +			ufshcd_set_ctmwb_err(hba_ctmwb);
> > +			dev_err(hba->dev, "%s: enable turbo write failed. err
> = %d\n",
> > +				__func__, err);
> > +		} else {
> > +			ufshcd_set_ctmwb_on(hba_ctmwb);
> > +			dev_info(hba->dev, "%s: ufs turbo write enabled \n",
> __func__);
> > +		}
> > +	} else {
> > +		if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
> > +			dev_err(hba->dev, "%s: turbo write already disabled.
> ctmwb_state = %d\n",
> > +				__func__, hba_ctmwb.ufs_ctmwb_state);
> > +			return 0;
> > +		}
> > +		pm_runtime_get_sync(hba->dev);
> > +		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> > +					QUERY_FLAG_IDN_WB_EN, NULL);
> > +		if (err) {
> > +			ufshcd_set_ctmwb_err(hba_ctmwb);
> > +			dev_err(hba->dev, "%s: disable turbo write failed. err
> = %d\n",
> > +				__func__, err);
> > +		} else {
> > +			ufshcd_set_ctmwb_off(hba_ctmwb);
> > +			dev_info(hba->dev, "%s: ufs turbo write disabled \n",
> __func__);
> What is 'turbo write'?
I wrote it wrong. I will collect it.

> > +		}
> > +	}
> > +
> > +	pm_runtime_put_sync(hba->dev);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ufshcd_get_ctmwbbuf_unit - get ctmwb buffer alloc units
> > + * @sdev: pointer to SCSI device
> > + *
> > + * Read dLUNumTurboWriteBufferAllocUnits in UNIT Descriptor
> > + * to check if LU supports turbo write feature  */ static int
> > +ufshcd_get_ctmwbbuf_unit(struct ufs_hba *hba) {
> > +	struct scsi_device *sdev = hba->sdev_ufs_device;
> > +	struct ufshba_ctmwb *hba_ctmwb = (struct ufshba_ctmwb *)hba->wb_ops;
> > +	int ret = 0;
> > +
> > +	u32 dLUNumTurboWriteBufferAllocUnits = 0;
> > +	u8 desc_buf[4];
> > +
> > +	if (!hba_ctmwb->support_ctmwb)
> > +		return 0;
> > +
> > +	ret = ufshcd_read_unit_desc_param(hba,
> > +			ufshcd_scsi_to_upiu_lun(sdev->lun),
> > +			UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS,
> > +			desc_buf,
> > +			sizeof(dLUNumTurboWriteBufferAllocUnits));
> > +
> > +	/* Some WLUN doesn't support unit descriptor */
> > +	if ((ret == -EOPNOTSUPP) || scsi_is_wlun(sdev->lun)){
> > +		hba_ctmwb->support_ctmwb_lu = false;
> > +		dev_info(hba->dev,"%s: do not support WB\n", __func__);
> > +		return 0;
> > +	}
> > +
> > +	dLUNumTurboWriteBufferAllocUnits = ((desc_buf[0] << 24)|
> > +			(desc_buf[1] << 16) |
> > +			(desc_buf[2] << 8) |
> > +			desc_buf[3]);
> > +
> > +	if (dLUNumTurboWriteBufferAllocUnits) {
> > +		hba_ctmwb->support_ctmwb_lu = true;
> > +		dev_info(hba->dev, "%s: LU %d supports ctmwb, ctmwbbuf unit :
> 0x%x\n",
> > +				__func__, (int)sdev->lun,
> dLUNumTurboWriteBufferAllocUnits);
> > +	} else
> > +		hba_ctmwb->support_ctmwb_lu = false;
> > +
> > +	return 0;
> > +}
> > +
> > +static inline int ufshcd_ctmwb_toggle_flush(struct ufs_hba *hba, enum
> > +ufs_pm_op pm_op) {
> > +	ufshcd_ctmwb_flush_ctrl(hba);
> > +
> > +	if (ufshcd_is_system_pm(pm_op))
> > +		ufshcd_reset_ctmwb(hba, true);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct ufs_wb_ops exynos_ctmwb_ops = {
> > +	.wb_toggle_flush_vendor = ufshcd_ctmwb_toggle_flush,
> > +	.wb_alloc_units_vendor = ufshcd_get_ctmwbbuf_unit,
> > +	.wb_ctrl_vendor = ufshcd_ctmwb_ctrl,
> > +	.wb_reset_vendor = ufshcd_reset_ctmwb, };
> > +
> > +struct ufs_wb_ops *ufshcd_ctmwb_init(void) {
> > +	hba_ctmwb.support_ctmwb = 1;
> > +
> > +	return &exynos_ctmwb_ops;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_ctmwb_init);
> > +
> > diff --git a/drivers/scsi/ufs/ufs_ctmwb.h
> > b/drivers/scsi/ufs/ufs_ctmwb.h new file mode 100644 index
> > 000000000000..073e21a4900b
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs_ctmwb.h
> > @@ -0,0 +1,27 @@
> > +#ifndef _UFS_CTMWB_H_
> > +#define _UFS_CTMWB_H_
> > +
> > +enum ufs_ctmwb_state {
> > +       UFS_WB_OFF_STATE	= 0,    /* turbo write disabled state */
> > +       UFS_WB_ON_STATE	= 1,            /* turbo write enabled state */
> > +       UFS_WB_ERR_STATE	= 2,            /* turbo write error state */
> > +};
> > +
> > +#define ufshcd_is_ctmwb_off(hba) ((hba).ufs_ctmwb_state ==
> > +UFS_WB_OFF_STATE) #define ufshcd_is_ctmwb_on(hba)
> > +((hba).ufs_ctmwb_state == UFS_WB_ON_STATE) #define
> > +ufshcd_is_ctmwb_err(hba) ((hba).ufs_ctmwb_state == UFS_WB_ERR_STATE)
> > +#define ufshcd_set_ctmwb_off(hba) ((hba).ufs_ctmwb_state =
> > +UFS_WB_OFF_STATE) #define ufshcd_set_ctmwb_on(hba)
> > +((hba).ufs_ctmwb_state = UFS_WB_ON_STATE) #define
> > +ufshcd_set_ctmwb_err(hba) ((hba).ufs_ctmwb_state = UFS_WB_ERR_STATE)
> > +
> > +#define UFS_WB_MANUAL_FLUSH_THRESHOLD	5
> > +
> > +struct ufshba_ctmwb {
> > +	enum ufs_ctmwb_state ufs_ctmwb_state;
> > +	bool support_ctmwb;
> > +
> > +	bool support_ctmwb_lu;
> > +};
> > +
> > +struct ufs_wb_ops *ufshcd_ctmwb_init(void); #endif
> >
> 
> -Asutosh
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> Linux Foundation Collaborative Project

