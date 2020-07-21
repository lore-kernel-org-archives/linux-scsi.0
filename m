Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D126C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41B6206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:10:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="quO20pYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgGUMKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:10:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36599 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGUMK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 08:10:29 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200721121027epoutp0188de75894bd67b65ec041f0740627f35~jw0zPZJyl0156701567epoutp01d
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 12:10:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200721121027epoutp0188de75894bd67b65ec041f0740627f35~jw0zPZJyl0156701567epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595333427;
        bh=r+4UzazZvU1CucWahZJ0K/2ZwBCyHIICfkvfgujEkTQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=quO20pYtXaGYIvfltsHHzjbdihVwbKwe3tUTNdRIvXkJ4IrHVj5wUnWhUpctlilee
         GzQ3CEWaWBBwDfEThkZBNuIjN6b7iS8pTfKAglS0kc7wU51zTvV3VCUNapcBRWmsgl
         d3PXu5bSjxZEC2zWR5+AEIwD6X8iFfbjnQJz5h4s=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200721121026epcas2p275282192c2c54156607122353af0c391~jw0yb1WsQ3268732687epcas2p2K;
        Tue, 21 Jul 2020 12:10:26 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B9y8x4YhXzMqYkV; Tue, 21 Jul
        2020 12:10:25 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.77.19322.13BD61F5; Tue, 21 Jul 2020 21:10:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200721121025epcas2p29ded4d83ead3d646068487bc2a34b54c~jw0w0SuB43268732687epcas2p2J;
        Tue, 21 Jul 2020 12:10:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721121025epsmtrp2904ad5eacbac04dec59c336473f582fb~jw0wziN2W3006030060epsmtrp2g;
        Tue, 21 Jul 2020 12:10:25 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-b4-5f16db31e6f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.C4.08303.03BD61F5; Tue, 21 Jul 2020 21:10:24 +0900 (KST)
Received: from KORDO038411 (unknown [12.36.185.191]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200721121024epsmtip2afc3ca3553b76af22f40902d5db56c16~jw0wlG2Tj3247832478epsmtip25;
        Tue, 21 Jul 2020 12:10:24 +0000 (GMT)
From:   "???" <sh425.lee@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <kwmad.kim@samsung.com>
In-Reply-To: <fe7ffa6778360cafeabbd238db85ae13@codeaurora.org>
Subject: RE: [RFC PATCH v2] scsi: ufs: set STATE_ERROR when
 ufshcd_probe_hba() failed
Date:   Tue, 21 Jul 2020 21:10:24 +0900
Message-ID: <091201d65f57$ea1f4680$be5dd380$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKKvZHaeoM4RCZL91F8gHuez7JtegGab+VIAloN9r6niY7foA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmha7hbbF4g98bFSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wejA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISdjzeOP
        bAWT+CtuLm9lbWCcwdPFyMkhIWAicenEFrYuRi4OIYEdjBLt16azQDifGCW6e/+wQjifGSUm
        rf3JAtOye/UFqJZdjBL7zs5lhnBeMkp8OfqGFaSKTUBZomHHLUYQW0RAVeJd63mwDmaBbUwS
        W9bPYgNJcArYSSx/vxTMFhYIl1jW8QOsgQWooe3ZKbA4r4ClxMQHh9ghbEGJkzOfgJ3BLGAg
        8f7cfGYIW15i+9s5zBDnKUjsOPsaaA4H0GIniUU/5SFKRCRmd7aBHSohcIND4u2R9+wQ9S4S
        l5//grKFJV4d3wJlS0l8freXDcIul9jdd5UNormFUeL92k1Qy4wlZj1rB1smAfTxkVtQt/FJ
        dBz+yw4R5pXoaBOCqFaWOPNuLdR4SYmHrZuYJjAqzULy2Swkn81C8tksJC8sYGRZxSiWWlCc
        m55abFRgiBzfmxjBKVrLdQfj5Lcf9A4xMnEwHmKU4GBWEuGdyCMcL8SbklhZlVqUH19UmpNa
        fIjRFBjYE5mlRJPzgVkiryTe0NTIzMzA0tTC1MzIQkmcN1fxQpyQQHpiSWp2ampBahFMHxMH
        p1QDE4uNBDt/1hGlT08DLcXe8ghGl3je+WL+jtOpwYtP80bY0gkXLlxhkrFRusN3WOmhwe3N
        p2yD1+p9ffPwne32JUsbg7ouVXsfjNrVbbL5v4AO48t1K4unFPwr4JFhlV9YG3tka8jh2seT
        XDvK9Gv4GO3TWQvPnF7Y/u1E3KbgpAnvu3d+T/u3hOOW4Jp/UafbsrZPY/l89fP1kxO5j60x
        /CqzRXiXydYzHIeufOmeHnvMw9/E+W2OlkFDt4/pgVyvN+zcE/g8eqKbf6vNSsyR1Lsk//52
        /A1WPUGVRf4X7C482XFs8Y5bKao6fTpmSWwv997eUxsXrJO2VPyge+jmg+GHRb54yi1Q51y7
        Ji2YTYmlOCPRUIu5qDgRABlhbIpaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWy7bCSvK7BbbF4g9e/LS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wejA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CVsebxR7aCSfwVN5e3sjYwzuDpYuTkkBAwkdi9+gJbFyMXh5DADkaJ39M6GCES
        khITLzVB2cIS91uOsILYQgLPGSUm9cmB2GwCyhINO26B1YgIqEq8az0PNohZ4AiTxKa391gh
        pp5klHh4qosZpIpTwE5i+fulbCC2sECoxKKep2BxFqDutmenwOK8ApYSEx8cYoewBSVOznzC
        AmIzCxhJnDu0nw3ClpfY/nYOM8R1ChI7zr4GuoID6AoniUU/5SFKRCRmd7YxT2AUnoVk0iwk
        k2YhmTQLScsCRpZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBcaqltYNxz6oPeocY
        mTgYDzFKcDArifBO5BGOF+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB9MSS1OzU1ILU
        IpgsEwenVANTdd7CC4ZXPn/UervaLE2lJabfR3PyTZMityl6bY96L/eeyZ0jetE2SkyOz1Rm
        4bm5HWqXv0qtyrb90+DaoPH8ln4C+zYl40kRHL86ZBuU96YqKcf2PjI+pjFHR+Jj4/eTp8Rf
        rpM/vfNv/UWPlPsmJ1c++e4n8jd1cZ1L8bKIzdffneV+cqgjKbSa566V5sbWjyVf1k5m8N9i
        HtDlxi9u7Saqor76Tec29a02bzka0/Smfn+jO/+65Eb9uxaHu4S5ppiJS2+M/CkT5PPll6sl
        R5vGHpW9vEESb7mUNx1PSV3KmPnbmv3o3ytPpdN37rkc07vSylTkiO21FSd3THmbyXW1+CLL
        p9WeJutd4hyVWIozEg21mIuKEwGAVEqxQgMAAA==
X-CMS-MailID: 20200721121025epcas2p29ded4d83ead3d646068487bc2a34b54c
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c
References: <CGME20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c@epcas2p3.samsung.com>
        <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
        <fe7ffa6778360cafeabbd238db85ae13@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Sang Hyun,
> 
> On 2020-07-17 15:31, Lee Sang Hyun wrote:
> > set STATE_ERR like below to prevent a lockup(IO stuck) when
> > ufshcd_probe_hba() returns error.
> >
> > Change-Id: I6c85ff290503cc9414d7f5fdd934295497b854ff
> > Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index ad4fc82..37e4105 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -7368,6 +7368,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> > bool async)  {
> >  	int ret;
> >  	ktime_t start = ktime_get();
> > +	unsigned long flags;
> >
> >  	ret = ufshcd_link_startup(hba);
> >  	if (ret)
> > @@ -7439,6 +7440,11 @@ static int ufshcd_probe_hba(struct ufs_hba
> > *hba, bool async)
> >  	ufshcd_auto_hibern8_enable(hba);
> >
> >  out:
> > +	if (ret) {
> > +		spin_lock_irqsave(hba->host->host_lock, flags);
> > +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +	}
> >
> >  	trace_ufshcd_init(dev_name(hba->dev), ret,
> >  		ktime_to_us(ktime_sub(ktime_get(), start)),
> 
> This change is included in my change
> "scsi: ufs: Fix up and simplify error recovery mechanism".

"scsi: ufs: Fix up and simplify error recovery mechanism".
I checked the patch, and confirmed that the contents of my patch were also
included.
> 
> Besides, this change seems not complete because
> 
> #1 You are only protecting your changes with spin lock in
> ufshcd_probe_hba, what about the other line "hba->ufshcd_state =
> UFSHCD_STATE_OPERATIONAL;"?
> 
> #2 As you are giving "hba->ufshcd_state = UFSHCD_STATE_ERROR;"
> in ufshcd_probe_hba, why keep the same lines in ufshcd_error_handler and
> ufshcd_eh_host_reset_handler?
> 
> Thanks,
> 
> Can Guo.

