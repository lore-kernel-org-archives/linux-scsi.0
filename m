Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C35C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710FD60E97
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhHIHdd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:33:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58555 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhHIHda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 03:33:30 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210809073308epoutp01d66ce4bffcd73fe43af7d785d303c60a~ZkwS0JylP2964129641epoutp01g
        for <linux-scsi@vger.kernel.org>; Mon,  9 Aug 2021 07:33:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210809073308epoutp01d66ce4bffcd73fe43af7d785d303c60a~ZkwS0JylP2964129641epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628494388;
        bh=BarSdkHshT/gTYvSx0tpdUc5GNfRUbjeEuC83HMkYOs=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=trGBpE4HZ19pGjjueVOC/VbIUh3RS+F3DCZPiIS6VsEJ0oMHjAOibsOa4qcPj3Pw2
         II7K9CkLI43uNL19T37tpw3mPyPjVsmmn9zm+fxiqcpp5RuwHh3uGvmCA20oVq3Rwu
         JmeKqVJlaN8n6pKStUemDuaDox/vZQP93gpo335k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210809073308epcas2p2af97bbb6adcec236e519806da98a0881~ZkwSUhisg2196921969epcas2p2A;
        Mon,  9 Aug 2021 07:33:08 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Gjnqj0Qt4z4x9QT; Mon,  9 Aug
        2021 07:33:05 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.7D.09921.03AD0116; Mon,  9 Aug 2021 16:33:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210809073304epcas2p4d9784b7bef6558d8e31bc09466efa0e3~ZkwO96QKH1938819388epcas2p4d;
        Mon,  9 Aug 2021 07:33:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210809073304epsmtrp16b286a923107b42a73dcd2c165b3fc4f~ZkwO8rNHt3132131321epsmtrp1W;
        Mon,  9 Aug 2021 07:33:04 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-a6-6110da3012bd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EF.B0.08394.03AD0116; Mon,  9 Aug 2021 16:33:04 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210809073304epsmtip111568ad4b7d147724de1e470462a8a00~ZkwOsAp8l2353823538epsmtip1R;
        Mon,  9 Aug 2021 07:33:04 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <9ed9f56c-d7a4-8e68-0968-da0eccb0b38d@acm.org>
Subject: RE: [RFC PATCH v1 1/2] scsi: ufs: introduce vendor isr
Date:   Mon, 9 Aug 2021 16:33:04 +0900
Message-ID: <000501d78cf0$ca3157b0$5e940710$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK++sB58EgqqX1myvhKfEGyIJx4UQKuf+SdAls7Bv0CEI0oaqljGZjw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbVRzOuff2th2Cl6fHumB32RRWgbZSvOB4ZM7lbpDIlJiMqN0NvQJZ
        X+ulxscMxCBPVxhzuHYPJmOVh5GHgAwoss6FVB0LUrJJIIADNuZQVmQTJyjl1sh/3+/3fd/5
        Pc45IjToOi4R5enzWZOe0ZL4FqzrSpQqWj5GMPK2eYpyzXyJU1PnunBqfmUUpy5Pl2HU8sU5
        AVWzuIJSnha7gGq+MIVRdTe7EGqk5wxOVdzoxqkvBtcQqnziJqAuri1gqQH0iDuNHrEcQ+gL
        ffMIXVU3AOiHLaU4fX92DKMtHU2AXmoPp0sGKpAMcZZ2Vy7LaFiTlNVnGzR5+pwkMu019Utq
        VbxcEa1IoF4gpXpGxyaRe9IzovfmadebJ6XvMFrzeiqD4TgyNnmXyWDOZ6W5Bi4/iWSNGq1R
        oTDGcIyOM+tzYrINukSFXK5UrSsPaXOHKm5jxtqwd4cf1QsLwVpgORCJIBEH71/Xl4MtoiCi
        G8Cp6vMIH3gArO6dxvngAYADY01oORBvOGo8rUKecADY3L3gU90BsKphUehV4YQM1kz3CrxE
        CFGEQrfDg3gJMfEitI46MC8OJlJg649zuBdjxHbo6FjayPsTCfA312nA40Doss5s5FHiafjN
        whlfG1K4MmsXeHEIsRfOu79CeE0IPF1WjHoLQ2JcBO/aXDhv2AOLTjZjPA6Gdwc7hDyWwPnK
        Yh8ugP0nCwW8+RMAZ/vXAE88D21zJcC7MpSIgi09sfz2IuB3Y77eAmDplVUhn/aHpcVBvDEC
        /lV9wnfIk9D687ivEg2X5iqFVWCbbdOUtk1T2jZNY/u/7nmANYEw1sjpclhOaVRsvu12sPGy
        d77cDU4sLMY4ASICTgBFKBni33IqgAny1zDvvc+aDGqTWctyTqBa3/txVBKabVj/Gvp8tUKl
        jI+XJ6goVbySIp/wj3xr+VAQkcPks4dZ1sia/vMhIrGkEFE2D507+mtkeuK2liMyTdvrkaH2
        wILtKdo2CgUOZPjD0M6HPyCjz+zYmlL2U+zyDecdnfxeuNq+W/a557ljPZd3HDjavBWLOFjy
        mCzz76t+tcmDbx+v+qixviHdaFWnZg0/8pOudGmWhfUTq1/XOgV9Fd1iR4F2v8xjOXiv/1b1
        qt3ssnxPh8fdQpaqZhvK2sxo/++feiZn8FdqwlrDgg8HyFNBhKzTEtWYW/J4+599Dz7u3OfO
        OnLps2+5N/WNf1yTPIUOJlY2uuP8Bpg6LKXXPnVgcnxCdko6mXnJ+mpqQ5vkavJZPA3Fi8qe
        7Zz45wPLvrklw5D1diJ5rf2XzDfEUSTG5TKKnaiJY/4FA7USsmIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSnK7BLYFEg8vvxSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mo41/2cpWC+WMXF30vYGxj/CXYxcnJICJhITPu0gb2LkYtD
        SGA3o0TTv6MsEAlJiRM7nzNC2MIS91uOsILYQgLPGCVanpiB2GwC2hLTHu5mBWkWEZjCLHHn
        2lE2iEmdTBKNXa+YQao4BawlZl7dCzZVWMBeYsOZZ2wgNouAisTeLZ/B4rwClhLvTs5mhLAF
        JU7OfAIWZwba8PTmUyhbXmL72znMEBcpSPx8ugzsIhEBN4mXV9YxQdSISMzubGOewCg0C8mo
        WUhGzUIyahaSlgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYKjVEtzB+P2VR/0
        DjEycTAeYpTgYFYS4V0/gy9RiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2amp
        BalFMFkmDk6pBiaZPsaIw4US17WbtSr7/xzv3vg1uuHD7pfJ5w993rysf2sfq0v0wX/rzMW0
        8i0KG4N/ugabrqzPz9BltH59RonXc6Hv5yJPV6O8M4vWq/yfeGnirNeHuJsqTMVsc1N/azR5
        d4vtr33a9cRpt8NJIykmkc07/12+Nb9Gk9+C2e3Zglpn/jsc7w6W3j02Y5ZeyqWWOaKrjCue
        lkvm3qjLnTTZhvH6vOXbjypskXPY+JVN8JfbnPsOOw5NDNq+x81X17yfyVPd7MWW6RO7a24d
        jI/We6Oh/V41cpe7WoLK1iXv4r+9Kz9+sccvmXNShJxO3EWHBy0Bk5+GPHgo5fC25nvJq12s
        pxnYBVLU7pyur1FiKc5INNRiLipOBABzhMOIQQMAAA==
X-CMS-MailID: 20210809073304epcas2p4d9784b7bef6558d8e31bc09466efa0e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537
References: <cover.1628231581.git.kwmad.kim@samsung.com>
        <CGME20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537@epcas2p4.samsung.com>
        <0f6f2337e98f8a8a7dfae816bc001af28fa3a7be.1628231581.git.kwmad.kim@samsung.com>
        <9ed9f56c-d7a4-8e68-0968-da0eccb0b38d@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 8/5/21 11:34 PM, Kiwoong Kim wrote:
> > This patch is to activate some interrupt sources that aren't defined
> > in UFSHCI specifications. Those purpose could be error handling,
> > workaround or whatever.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufshcd.c | 10 ++++++++++
> >   drivers/scsi/ufs/ufshcd.h |  8 ++++++++
> >   2 files changed, 18 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 05495c34a2b7..f85a9b335e0b 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6428,6 +6428,16 @@ static irqreturn_t ufshcd_tmc_handler(struct
> ufs_hba *hba)
> >   static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
> >   {
> >   	irqreturn_t retval = IRQ_NONE;
> > +	int res = 0;
> > +	unsigned long flags;
> > +
> > +	retval = ufshcd_vops_intr(hba, &res);
> > +	if (res) {
> > +		spin_lock_irqsave(hba->host->host_lock, flags);
> > +		hba->force_reset = true;
> > +		ufshcd_schedule_eh_work(hba);
> > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +	}
> 
> How can a non-standard extension have error handling code in common code?
> Please move the code under if (res) into the vendor code.
Got it.

> 
> >   	if (intr_status & UFSHCD_UIC_MASK)
> >   		retval |= ufshcd_uic_cmd_compl(hba, intr_status); diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > 971cfabc4a1e..1ed0a911f864 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
> >   			       const union ufs_crypto_cfg_entry *cfg, int slot);
> >   	void	(*event_notify)(struct ufs_hba *hba,
> >   				enum ufs_event_type evt, void *data);
> > +	irqreturn_t	(*intr)(struct ufs_hba *hba, int *res);
> >   };
> >
> >   /* clock gating state  */
> > @@ -1296,6 +1297,13 @@ static inline void
> ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
> >   		hba->vops->config_scaling_param(hba, profile, data);
> >   }
> >
> > +static inline irqreturn_t ufshcd_vops_intr(struct ufs_hba *hba, int
> > +*res) {
> > +	if (hba->vops && hba->vops->intr)
> > +		return hba->vops->intr(hba, res);
> > +	return IRQ_NONE;
> > +}
> > +
> >   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
> 
> So this code adds an indirect function call in the interrupt handler?
> This will have a negative impact on performance, especially on a kernel
> with security mitigations enabled. See also
> https://protect2.fireeye.com/v1/url?k=fe14d1e9-a18fe89c-fe155aa6-
> 0cc47a31ce4e-8200591154f8c42c&q=1&e=7cf22799-390c-4209-8a19-
> 6ad1fa5fa811&u=https%3A%2F%2Flwn.net%2FArticles%2F774743%2F.
Interesting. I'll refer to this. Thanks.

> 
> Thanks,
> 
> Bart.

