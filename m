Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1EAC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 09:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47CC22078A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 09:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="c5q3rU9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgG0J5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 05:57:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18888 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0J5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 05:57:10 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200727095707epoutp04d3d9247ff99d70ca283925536c1371be~lk4Gd5SHs0436204362epoutp04i
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 09:57:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200727095707epoutp04d3d9247ff99d70ca283925536c1371be~lk4Gd5SHs0436204362epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595843827;
        bh=7sE4+qAT0wju+HrAt/pm9T3VFwzX4r3QlODQUveE64Q=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=c5q3rU9a+J/B+qMeQYjZwK6qFrLkQYTjrGlYFAoVl2eMdPhyQr5+7Qe8M5PS270oE
         JjntVXe8YZqBltaWCTtbTQiVjBLIJAgrRW0EEXWsLjSYcm+Oc6wKLbbNaxkIStVSg7
         Tx8QSGXWTa0FwRFohhDYs1CgDlFXrCfYrSwmsERk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200727095707epcas2p4dc172f043ac810edfbcd729e84df1192~lk4Fp1Jst1255012550epcas2p4q;
        Mon, 27 Jul 2020 09:57:07 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BFZwJ35hNzMqYkf; Mon, 27 Jul
        2020 09:57:04 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.5D.27013.0F4AE1F5; Mon, 27 Jul 2020 18:57:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200727095703epcas2p1c96837d07ce0b01794bceef80b535df6~lk4Co9h_g0898208982epcas2p1K;
        Mon, 27 Jul 2020 09:57:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727095703epsmtrp28fc7851d8d9be0c7c99883da25ab51b0~lk4CoKkGG0599405994epsmtrp2G;
        Mon, 27 Jul 2020 09:57:03 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-f7-5f1ea4f04cb7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.6B.08303.FE4AE1F5; Mon, 27 Jul 2020 18:57:03 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200727095703epsmtip126617a0c17a78581ccf1bc6c59d2ed89~lk4CfLm6I0214502145epsmtip16;
        Mon, 27 Jul 2020 09:57:03 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB46406E701D8571E3A1EB5FDFFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 1/3] scsi: ufs: modify write booster
Date:   Mon, 27 Jul 2020 18:57:03 +0900
Message-ID: <071d01d663fc$4782ef40$d688cdc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLP/cB05Q6MF8BaP7+redz0q/FGgJKaxVPAfmAvQEBqiAtX6kCB6ew
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmhe6HJXLxBovf8lg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsbR09tZCqYIVszdfZa9gfEMdxcj
        J4eEgInE2lPzmLoYuTiEBHYwSpxf9oINwvnEKLFy/XtWCOczo8TPF4eYYVrebbjMDJHYxSjR
        0noZquolo8TtNVvZQKrYBEwl+ratAEuICExjktj9axETSIJTIFbix7J3LCC2sIC9xPtl+9hB
        bBYBVYnf/fPAmnkFLCXu3ZzFCmELSpyc+QSsnllAW2LZwtdQZyhI7Dj7mhHEFhFwk3jd+Z0R
        okZEYnZnG9h5EgJbOCS6pvQyQTS4SPx4NYkFwhaWeHV8CzuELSXx+d1eNgi7XmLKvVUsEM09
        jBJ7VpyAajaWmPWsHWgDB9AGTYn1u/RBTAkBZYkjt6Bu45PoOPyXHSLMK9HRJgTRqCRxZu5t
        qLCExMHZORBhD4neQ0vYJzAqzkLy5CwkT85C8swshLULGFlWMYqlFhTnpqcWGxWYIMf2JkZw
        Atby2ME4++0HvUOMTByMhxglOJiVRHi5RWXihXhTEiurUovy44tKc1KLDzGaAoN9IrOUaHI+
        MAfklcQbmhqZmRlYmlqYmhlZKInzvrO6ECckkJ5YkpqdmlqQWgTTx8TBKdXAdOjOm5uCeQzL
        k98pTeYR7vv9M2eBsAmf1A+ZDwsva4gyRU42C086zGYbnMNpkNp/uMjyiILALw6O50GihWES
        fQ8Wmcp73FI8Xpt4OS711gHLKZrCDqtNvzx9Not79+PgqLmfd/aFWizf1CvYdCiw1b46bua1
        yqbwwO/udxcVV1TE77zglcpTptLIX2elKnLg8qptzfcrp26KOpxS90JlbeZLobOlVU/fu760
        2fNacHu2xBpxjWwjhclzzk0WPHObY2pSYHTTyiO1Ex9fLf2p+HO1svHRiEWGUXIG/w2Vq5bc
        ea57wqb0t2/n6XQhicu7RCesbLBstbANmy21u0C/pTr/2tHXDrE8ge6nwn4psRRnJBpqMRcV
        JwIAYfXMUEkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnO77JXLxBr/Oa1s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugSvjwYU1LAU/
        BCpmnZrH1sC4gbuLkZNDQsBE4t2Gy8xdjFwcQgI7GCW2rZnEApGQkPi/uIkJwhaWuN9yhBWi
        6DmjxPI1T8ESbAKmEn3bVoAlRAQWMEk8Wr0fLCEksJJJYnFbCojNKRAr8WPZO7CpwgL2Eu+X
        7WMHsVkEVCV+989jA7F5BSwl7t2cxQphC0qcnPkErJ5ZQFui92ErI4y9bOFrZoiLFCR2nH0N
        FhcRcJN43fkdqkZEYnZnG/MERqFZSEbNQjJqFpJRs5C0LGBkWcUomVpQnJueW2xYYJSXWq5X
        nJhbXJqXrpecn7uJERxzWlo7GPes+qB3iJGJg/EQowQHs5IIL7eoTLwQb0piZVVqUX58UWlO
        avEhRmkOFiVx3q+zFsYJCaQnlqRmp6YWpBbBZJk4OKUamALul5+acJxBvlJMl3332UnV3Zkv
        Kv78efrwuMOpAxqPU1UvBxzuX/Ir9O8zpXj7gHnhi4waHj1ybHjO0fHKobw2r1H+d/j9jlOr
        t65+vOa5RtuCV+u3i5oWbC49xnPj0vzpm/x6BLfkvxXXyS+47j7PRvfR9okWCn+9ZzCWfRfe
        E+e7LST/x765WlrXK8p3Xw+SvKOm6fl2vbSLVuXD0gfdp35+EOtgPz7Bg/f7ZZ1axXVX3Eqc
        Sr482/ZkdZ5C81WTEoaFJ0VuzVhm/ax6Wluy/6TEZwtDWkPDtnRV3L8ZdKjjEiPzLIlLzi1f
        HBaq1jela8TPsPQ7m8t2L+OqXQXbgo/3NxlMetY8M4rtzCYlluKMREMt5qLiRAADyGXnKAMA
        AA==
X-CMS-MailID: 20200727095703epcas2p1c96837d07ce0b01794bceef80b535df6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095648epcas2p18c3d496076ecd1537e47081c19dbb97e@epcas2p1.samsung.com>
        <90ad671ed4a2b4f6035e9858153a13f7c00a1904.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB46406E701D8571E3A1EB5FDFFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Add vendor specific functions for WB
> > Use callback additional setting when use write booster.
> >
> > Signed-off-by: SEO HOYOUNG <hy50.seo=40samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 22 +++++++++++++++-----
> > drivers/scsi/ufs/ufshcd.h =7C 43 ++++++++++++++++++++++++++++++++++++++=
+
> >  2 files changed, 60 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index efc0a6cbfe22..9261519e7e9a 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -3306,11 +3306,11 =40=40 int ufshcd_read_string_desc(struct ufs_=
hba
> > *hba,
> > u8 desc_index,
> >   *
> >   * Return 0 in case of success, non-zero otherwise
> >   */
> > -static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > -                                             int lun,
> > -                                             enum unit_desc_param para=
m_offset,
> > -                                             u8 *param_read_buf,
> > -                                             u32 param_size)
> > +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > +                               int lun,
> > +                               enum unit_desc_param param_offset,
> > +                               u8 *param_read_buf,
> > +                               u32 param_size)
> >  =7B
> >         /*
> >          * Unit descriptors are only available for general purpose LUs
> > (LUN id =40=40 -3322,6 +3322,7 =40=40 static inline int
> > ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> >         return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
> >                                       param_offset, param_read_buf,
> > param_size);  =7D
> > +EXPORT_SYMBOL_GPL(ufshcd_read_unit_desc_param);
> Like I already told you in your v1:
> If you are relaying on ufsfeatures - you need to wait for it to be merged=
.
> Meanwhile, it got nacked (nack=5E2 actually), so you need to take this in=
to
> account.

Sorry, for not catching this.
Then can I know when the code was merged?
I will remove this function.


>=20
> Thanks,
> Avri

