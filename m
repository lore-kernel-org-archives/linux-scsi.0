Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B406C4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 23:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE3F60EE8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 23:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhHCXfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 19:35:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33098 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbhHCXfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 19:35:37 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210803233524epoutp032735205163501f8160ffabda19490cec~X8AvvEXZd3058830588epoutp03W
        for <linux-scsi@vger.kernel.org>; Tue,  3 Aug 2021 23:35:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210803233524epoutp032735205163501f8160ffabda19490cec~X8AvvEXZd3058830588epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628033724;
        bh=QHkAlDyGSuVzU5TssxLvoaQvhRh5Joz67L+1dX4LHOY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=F17tfjmb36QMNBnmU0rNtCKsfDQkl9l/sJYeZ9+PLhwDt3c/ODYMND50q6Z+3cPxf
         LVcByG0aNCOUk2Yv7mFjyNWJRdEj1800zebE4lFU7wMMFkaR+v2DoUd+1efedFac/O
         vgmgUZhHlvwvghBFd7xUxCzt27XynR1X/O9ZTmYU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210803233523epcas2p4e219074c4b16cee48ab5ec4660376447~X8Au7XGvl0890708907epcas2p4I;
        Tue,  3 Aug 2021 23:35:23 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GfWSn0DQYz4x9Ps; Tue,  3 Aug
        2021 23:35:21 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.B7.09921.8B2D9016; Wed,  4 Aug 2021 08:35:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210803233520epcas2p4c4005ef331ac281020bc76a502de1fe4~X8ArrLR3h0892908929epcas2p41;
        Tue,  3 Aug 2021 23:35:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210803233519epsmtrp25606bfd3eb8337751e772e22e37f7b5f~X8Arp_0NX2516625166epsmtrp2Z;
        Tue,  3 Aug 2021 23:35:19 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-dc-6109d2b80d5e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.81.08394.7B2D9016; Wed,  4 Aug 2021 08:35:19 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210803233519epsmtip2e498a22bb8e0a277e02e331b67389444~X8ArXzg6I0166901669epsmtip2Z;
        Tue,  3 Aug 2021 23:35:19 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <73a79fbbec661cd898feda9064a10c6c182d7fad.camel@gmail.com>
Subject: RE: [PATCH 14/15] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Date:   Wed, 4 Aug 2021 08:35:19 +0900
Message-ID: <000001d788c0$38ba49b0$aa2edd10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQJl2E6sAko8FTQBPPGrXqyhAjbQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJsWRmVeSWpSXmKPExsWy7bCmme6OS5yJBosOaVmcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC16djpbnJ6wiMliztkGJosn62cxWyy6sY3JYuU1C4ubW46yWMw4
        v4/Jovv6DjaL5cf/MTnwe1y+4u1xua+XyWPnrLvsHptXaHks3vOSyWPTqk42jwmLDjB6fHx6
        i8Wjb8sqRo/Pm+Q82g90MwVwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
        5CXmptoqufgE6Lpl5gA9oqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtO
        zC0uzUvXS87PtTI0MDAyBapMyMk41LCKqeA7f8WZ09vZGxgf8XQxcnJICJhIfGw5ytzFyMUh
        JLCDUeLV2R42COcTo8Sc47uYIJxvjBLP7x9kh2lZ/+MOVGIvo8Tht3fYQBJCAi8YJZ7cEASx
        2QT0JV52bGMFKRIR2M0o0X3iByNIglngBLPE5FPMIDangLtE64ZvTCC2sEC0xPwXP1lAbBYB
        FYm5J1rBbF4BS4nFJzaxQdiCEidnPmGBmKMtsWzha2aIixQkfj5dxgpiiwi4Sfx4fpsJokZE
        YnZnG1TNBw6JRw8MIGwXiekHO6DiwhKvjm+B+kxK4vO7vWD/Swh0M0q0PvoPlVjNKNHZ6ANh
        20v8mr4FaBkH0AJNifW79EFMCQFliSO3oE7jk+g4/JcdIswr0dEmBNGoLnFg+3QWCFtWonvO
        Z9YJjEqzkDw2C8ljs5A8MAth1wJGllWMYqkFxbnpqcVGBYbIkb2JEZzItVx3ME5++0HvECMT
        B+MhRgkOZiUR3tAbHIlCvCmJlVWpRfnxRaU5qcWHGE2BQT2RWUo0OR+YS/JK4g1NjczMDCxN
        LUzNjCyUxHk14r4mCAmkJ5akZqemFqQWwfQxcXBKNTAlfImfbalUHKAXai2b078puXcbTwV7
        34dvTf+6Fj/cziJzfup3r3NLoi64CU5yO/yd83K1+/7O6OdLU0sf57jlb+xfOlvuRXcxZ3Xn
        chmzgmCxxjLv27dePHR69qs9nMn5c5+38rldy5/N5cmc+0+vZtumvucPk7emTMg+ePS+1Ix7
        lsoimytmlLs2TLxkwnj7WnRIncxE3Tmadr7Ga+pYzN9Xux/TaWK+M+3sVrPbh+dGXWwMFdSa
        dii9nL/KbNtKOaYjZjvevpn9nT+k11ou8WovQ6U/x0umOUuZBaxWnFmbPCWgb8Ly4kMM3z52
        p5z5t3bVOt4zbBkezCI3r6XIeJm82/bwdf/+wLorN62UWIozEg21mIuKEwGtgdpJbQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWy7bCSvO72S5yJBjf2GVmcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC16djpbnJ6wiMliztkGJosn62cxWyy6sY3JYuU1C4ubW46yWMw4
        v4/Jovv6DjaL5cf/MTnwe1y+4u1xua+XyWPnrLvsHptXaHks3vOSyWPTqk42jwmLDjB6fHx6
        i8Wjb8sqRo/Pm+Q82g90MwVwR3HZpKTmZJalFunbJXBlLPi1gq3gNX/F7NlWDYzneLoYOTkk
        BEwk1v+4w9TFyMUhJLCbUWLG0luMEAlZiWfvdrBD2MIS91uOsEIUPWOUWLf4PhNIgk1AX+Jl
        xzZWEFtEYC+jxPueEpAiZoELzBIXdj9hg+j4zyhx899ZsCpOAXeJ1g3fwLqFBSIltq5ZAraC
        RUBFYu6JVhYQm1fAUmLxiU1sELagxMmZT8DizALaEk9vPoWzly18zQxxnoLEz6fLoK5wk/jx
        /DYTRI2IxOzONuYJjMKzkIyahWTULCSjZiFpWcDIsopRMrWgODc9t9iwwDAvtVyvODG3uDQv
        XS85P3cTIziqtTR3MG5f9UHvECMTB+MhRgkOZiUR3tAbHIlCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MCkXpd64fnSJRMC76Sxb1D0t1uZE6wdk9t/6
        zf7Iw/6rteD6LUlxdqJ8U28pTbzCaHWyRpO5faaxvqiMVHd4t9y2+BV9VncZLE3cpunGvfmW
        vzlxVYjYJVvVYiHun0yT399vzOk1vnC3qNNhpXXGPc4tdk8mrOV9bRctfupQcb5HTs1pAe66
        9QVnpr/hjn43XdOvSvObIa+AV86jIvu6ei+Hiy7GDwQZuL3mGj6J1ayYYMi2Y3LoaY/v8aXe
        e9ljnPo51s7rT7kc4vp5VXPgHtst96b82aTf9GZ/o8hapmgbrokvmY94CxxQ6doi3vX0zq4Q
        nuLXxi9d3x9qjTU51nFE63ucsvLlxItqXAxKLMUZiYZazEXFiQA8R3PRWQMAAA==
X-CMS-MailID: 20210803233520epcas2p4c4005ef331ac281020bc76a502de1fe4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p10c59e097d9770fc02134cb0545c9de4f@epcas2p1.samsung.com>
        <20210709065711.25195-15-chanho61.park@samsung.com>
        <73a79fbbec661cd898feda9064a10c6c182d7fad.camel@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > We divide this M-HCI as PH(Physical Host) and VHs(Virtual Host). The
> > PH
> >
> > supports all UFSHCI functions(all SAPs) same as conventional UFSHCI
> > but
> >
> > the VH only supports data transfer function. Thus, except UTP_CMD_SAP
> > and
> >
> > UTP_TMPSAP, the PH should handle all the physical features.
>=20
> Hi Chanho park,
>=20
> You mentioned this in your coverletter:
>=20
> =22There are two types of host controllers on the UFS host controller tha=
t
> we designed. The UFS device has a Function Arbitor that arranges commands
> of each host. When each host transmits a command to the Arbitor, the
> Arbitor transmits it to the UTP layer=22.
>=20
> where does this =22Function Arbitor=22 exit? From your comments, seems it
> exists on the UFS device side? right? If this is true, where is related
> code in your patch??

The =22Function Arbiter=22 is in our ufs controller as H/W and it is respon=
sible to arrange UTP_CMD/UTP_TM among PH and VHs. When we set MHCTL registe=
r, the controller will enable the multi-host capability and the arbiter wil=
l be automatically enabled as well.

+static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
+=7B
+	struct ufs_hba *hba =3D ufs->hba;
+
+	/* Enable Virtual Host =231 */
+	ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
+	/* Default VH Transfer permissions */
+	hci_writel(ufs, 0x03FFE1FE, HCI_MH_ALLOWABLE_TRAN_OF_VH);
+	/* IID information is replaced in TASKTAG=5B7:5=5D instead of IID in UCD =
*/
+	hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
+
+	return 0;
+=7D

> Maybe you only submited partial of your real driver
> parch for this controller??

Yes. The series is the initial version but it contains most of multi-host c=
apabilities. Most of things can be handled by our UFS controller so we can =
make driver code simpler as much as possible. Only =231 VH can be supported=
 in this patch at the moment but I have a plan to support more VHs later.

Best Regards,
Chanho Park

