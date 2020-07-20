Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417BCC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B07F22BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CBZB6VfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgGTKuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:50:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32368 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbgGTKuu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:50:50 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200720105046epoutp023a2d1172e8b955300c5975c13d7f7316~jcF71k_3v2737627376epoutp02M
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 10:50:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200720105046epoutp023a2d1172e8b955300c5975c13d7f7316~jcF71k_3v2737627376epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595242246;
        bh=V9QQXFFxaQy/XENxFu5XF6eS4Q+dHBYurNCvnWs/bc0=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=CBZB6VfQpJIXzThbTI601WvI7wS25EolGmSWz4XsIimKqm8BVrPhR+Lpv2OnoNzdh
         /gCDe+UBe7xJDWNp2FoLkfZtI4juVm1y4Ao+UiiE6O/Z0bbkAtA38r3x3h83qJwog9
         xXSASGmisd++TIdsnPhfEE+QWT763TiQEJo1Ton0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200720105045epcas2p2699c4d8ebfd21f852a3d4fe4d5f4f56a~jcF7bTkZ90405804058epcas2p29;
        Mon, 20 Jul 2020 10:50:45 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B9JRR4zqhzMqYkk; Mon, 20 Jul
        2020 10:50:43 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.96.19322.307751F5; Mon, 20 Jul 2020 19:50:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200720105043epcas2p261bd8a3d6f946319c05e160e03ec994b~jcF4_OoFF0405804058epcas2p25;
        Mon, 20 Jul 2020 10:50:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200720105043epsmtrp2cde51e81711ceba71f3dcb361b58431e~jcF49iWoz2691326913epsmtrp2r;
        Mon, 20 Jul 2020 10:50:43 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-63-5f1577039a39
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.06.08382.207751F5; Mon, 20 Jul 2020 19:50:42 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200720105042epsmtip25417c52def6b25048e5b8cfb399cf118~jcF4vaB351442114421epsmtip2V;
        Mon, 20 Jul 2020 10:50:42 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB4640C3D4BEB8307112C5F42EFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] scsi: ufs: modify write booster
Date:   Mon, 20 Jul 2020 19:50:42 +0900
Message-ID: <017901d65e83$9d7007e0$d85017a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHGq+tJDkRqPXH45Xvt+KClJxZLLQBbHP0WAXQrvgSpITNYwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmuS5zuWi8wfsLKhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQkzH7wh3WgmP2Ff/WnmVuYDyh08XI
        ySEhYCLxdf8W9i5GLg4hgR2MEs0bl0M5nxglTj5dxgLhfGOUWHH3KFsXIwdYy/RbXhDxvYwS
        e1sfMEI4Lxkllv8/xAQyl03AVKJv2wpWkISIwDQmid2/FoElOAViJfYe+cAGYgsLWEucuN8F
        FmcRUJXYvmsXC4jNK2ApcexwJyOELShxcuYTsDizgLbEsoWvmSEOV5DYcfY1WI2IgJNE57Uv
        bBA1IhKzO9uYQRZLCGzhkLjUe5oRosFFovfSdXYIW1ji1fEtULaUxOd3e9kg7HqJKfdWsUA0
        9zBK7FlxggkiYSwx61k7I8j/zAKaEut36UOCQlniyC2o2/gkOg7/ZYcI80p0tAlBNCpJnJl7
        GyosIXFwdg5E2ENi0+HHbBMYFWcheXIWkidnIXlmFsLaBYwsqxjFUguKc9NTi40KDJEjexMj
        OP1que5gnPz2g94hRiYOxkOMEhzMSiK8E3mE44V4UxIrq1KL8uOLSnNSiw8xmgKDfSKzlGhy
        PjAD5JXEG5oamZkZWJpamJoZWSiJ8+YqXogTEkhPLEnNTk0tSC2C6WPi4JRqYGp85/vJ+Pj9
        XJ6WZUdeFZwMV72kecHMsTC3rOPwb+3StBdM1kqblCbmaeSWdnGJdDdtO1fS98Bp1u9VZU/z
        e3/+OrH26qXb5pFy022OT3wrU8ZQE3qo1tTotn5ooaKdQBr/Oo9DrkWbp2urTLx8qW3avJlb
        qvn3BkoWMnf0XHcxCNnwcc6U4wxRyXYrlbRLzq85pbSu/3PaFOmz82s5TsQv2cUmKyckErZd
        /JwJ09XPTBv1/Dzlp/H5Ozz2D12f9yncY23rl8DySZ2bErgenNGVXV28UsOlOOZyyDcb1123
        qv6sdD+3jmvrRMZklukyPrMX/06OYpxY+eClwmq5x8I7S24enb+kYuF8Y/+XK5RYijMSDbWY
        i4oTARQtV8tIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvC5TuWi8wbrLVhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCI4rJJSc3JLEst0rdL4Mp4/k+joNGu
        omdON2sDY6N2FyMHh4SAicT0W15djFwcQgK7GSXedN9n6mLkBIpLSPxf3ARlC0vcbznCClH0
        nFFi+/tONpAEm4CpRN+2FWAJEYEFTBKPVu9ngqi6yyhx6+MSFpAqToFYib1HPoB1CAtYS5y4
        3wU2lkVAVWL7rl1gNbwClhLHDncyQtiCEidnPgGLMwtoS/Q+bGWEsZctfM0McZKCxI6zr8Hi
        IgJOEp3XvrBB1IhIzO5sY57AKDQLyahZSEbNQjJqFpKWBYwsqxglUwuKc9Nziw0LDPNSy/WK
        E3OLS/PS9ZLzczcxgiNOS3MH4/ZVH/QOMTJxMB5ilOBgVhLhncgjHC/Em5JYWZValB9fVJqT
        WnyIUZqDRUmc90bhwjghgfTEktTs1NSC1CKYLBMHp1QDE1sDv1pNrLdAYZbUv66VGxfLXhLm
        mnYxxydRh3fjiut3by8Uu/7wz6uexPXbtr1fd21aaueKteJLgg7JznRk3ubVu6mC9frxWzba
        wbeTYktPNiZUKLTVPt21X6qA4YRoXdeslUqPEktsfnlc/nyoNmfjye/rb62Urdv1XUH7ZKSU
        m07RIf0IR/6db8RyP6jtehpvq+Ym9FCjJ9Rn778lJZXrvLfyZj5YN8X05srSukV/ElLYzjvy
        zmVUvDfr6vy7fb9fxLIt9O50rbr9bvYuga88xx0uH1tTcqVr7otb63n7fz5veHKwWuSh7LeM
        l+KXTpdkzWzZFZPFF5Egy5X70/OAasDnum9STzN+/V/OPkmJpTgj0VCLuag4EQAWWamdJwMA
        AA==
X-CMS-MailID: 20200720105043epcas2p261bd8a3d6f946319c05e160e03ec994b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200713111949epcas2p47da38b91548e7a13123380b9a7093642
References: <CGME20200713111949epcas2p47da38b91548e7a13123380b9a7093642@epcas2p4.samsung.com>
        <20200713112022.169887-1-hy50.seo@samsung.com>
        <SN6PR04MB4640C3D4BEB8307112C5F42EFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi,
>=20
> >
> > Add vendor specific functions for WB
> > Use callback additional setting when use write booster.
> >
> > Signed-off-by: SEO HOYOUNG <hy50.seo=40samsung.com>
> If you are introducing a new vops - your series should include your
> implementation, Otherwise why introduce a vop that nobody uses?
Ok, I already upload with vops functions

>=20
>=20
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 23 ++++++++++++++++-----
> > drivers/scsi/ufs/ufshcd.h =7C 43 ++++++++++++++++++++++++++++++++++++++=
+
> >  2 files changed, 61 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index efc0a6cbfe22..efa16bf4fd76 100644
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
> Are you exporting this because you need ufsfeatures to use it?
> If so, you need to wait until it is merged, if not, add an explanation in
> your commit log.
Yes, I need ufsfeatures for use.
What patch will merged? Is there patch to export ufsfeatures?
>=20
> >
> >  static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)  =7B =
=40=40
> > -5257,6 +5258,10 =40=40 static int ufshcd_wb_ctrl(struct ufs_hba *hba,
> > bool
> > enable)
> >
> >         if (=21(enable =5E hba->wb_enabled))
> >                 return 0;
> > +
> > +       if (=21ufshcd_wb_ctrl_vendor(hba, enable))
> > +               return 0;
> If the vop fail just keep going with the standard implementation?
>=20
> > +
> >         if (enable)
> >                 opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> >         else
> > =40=40 -6610,6 +6615,8 =40=40 static int ufshcd_reset_and_restore(struc=
t
> > ufs_hba
> > *hba)
> >         int err =3D 0;
> >         int retries =3D MAX_HOST_RESET_RETRIES;
> >
> > +       ufshcd_reset_vendor(hba);
> What reset has to do with WB?
> If you are changing the flow, need to do that in a different patch, with =
a
> proper commit log.
For disable WB feature.

>=20
> > +
> >         do =7B
> >                 /* Reset the attached device */
> >                 ufshcd_vops_device_reset(hba); =40=40 -6903,6 +6910,9 =
=40=40
> > static void ufshcd_wb_probe(struct ufs_hba *hba,
> > u8 *desc_buf)
> >         if (=21(dev_info->d_ext_ufs_feature_sup &
> > UFS_DEV_WRITE_BOOSTER_SUP))
> >                 goto wb_disabled;
> >
> > +       if (=21ufshcd_wb_alloc_units_vendor(hba))
> > +               return;
> > +
> >         /*
> >          * WB may be supported but not configured while provisioning.
> >          * The spec says, in dedicated wb buffer mode, =40=40 -8260,6
> > +8270,7 =40=40 static int ufshcd_suspend(struct ufs_hba *hba, enum
> > ufs_pm_op pm_op)
> >                         /* make sure that auto bkops is disabled */
> >                         ufshcd_disable_auto_bkops(hba);
> >                 =7D
> > +
> >                 /*
> >                  * If device needs to do BKOP or WB buffer flush during
> >                  * Hibern8, keep device power mode as =22active power m=
ode=22
> > =40=40 -8273,6 +8284,8 =40=40 static int ufshcd_suspend(struct ufs_hba =
*hba,
> > enum ufs_pm_op pm_op)
> >                         ufshcd_wb_need_flush(hba));
> >         =7D
> >
> > +       ufshcd_wb_toggle_flush_vendor(hba, pm_op);
> > +
> >         if (req_dev_pwr_mode =21=3D hba->curr_dev_pwr_mode) =7B
> >                 if ((ufshcd_is_runtime_pm(pm_op) &&
> > =21hba->auto_bkops_enabled)
> > =7C=7C
> >                     =21ufshcd_is_runtime_pm(pm_op)) =7B diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > 656c0691c858..deb9577e0eaa 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > =40=40 -254,6 +254,13 =40=40 struct ufs_pwr_mode_info =7B
> >         struct ufs_pa_layer_attr info;  =7D;
> >
> > +struct ufs_wb_ops =7B
> > +       int (*wb_toggle_flush_vendor)(struct ufs_hba *hba, enum
> > +ufs_pm_op
> > pm_op);
> > +       int (*wb_alloc_units_vendor)(struct ufs_hba *hba);
> > +       int (*wb_ctrl_vendor)(struct ufs_hba *hba, bool enable);
> > +       int (*wb_reset_vendor)(struct ufs_hba *hba, bool force); =7D;
> > +
> >  /**
> >   * struct ufs_hba_variant_ops - variant specific callbacks
> >   * =40name: variant name
> > =40=40 -752,6 +759,7 =40=40 struct ufs_hba =7B
> >         struct request_queue    *bsg_queue;
> >         bool wb_buf_flush_enabled;
> >         bool wb_enabled;
> > +       struct ufs_wb_ops *wb_ops;
> This actually should not be directly under ufs_hba, but a member of hba-
> >vops, and also please follow the vop naming convention, e.g.
> ufshcd_vops_wd_xxx
It is a variable with a different valid.
So I define in hba structure.

>=20
>=20
> >         struct delayed_work rpm_dev_flush_recheck_work;
> >
> >  =23ifdef CONFIG_SCSI_UFS_CRYPTO
> > =40=40 -1004,6 +1012,10 =40=40 int ufshcd_exec_raw_upiu_cmd(struct ufs_=
hba
> > *hba,
> >                              u8 *desc_buff, int *buff_len,
> >                              enum query_opcode desc_op);
> >
> > +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > +                               int lun, enum unit_desc_param param_off=
set,
> > +                               u8 *param_read_buf, u32 param_size);
> > +
> >  /* Wrapper functions for safely calling variant operations */  static
> > inline const char *ufshcd_get_var_name(struct ufs_hba *hba)  =7B =40=40
> > -1181,4 +1193,35 =40=40 static inline u8 ufshcd_scsi_to_upiu_lun(unsign=
ed
> > int scsi_lun)  int ufshcd_dump_regs(struct ufs_hba *hba, size_t
> > offset, size_t len,
> >                      const char *prefix);
> >
> > +static inline int ufshcd_wb_toggle_flush_vendor(struct ufs_hba *hba,
> > +enum
> > ufs_pm_op pm_op)
> > +=7B
> > +       if (=21hba->wb_ops =7C=7C =21hba->wb_ops->wb_toggle_flush_vendo=
r)
> > +               return -1;
> > +
> > +       return hba->wb_ops->wb_toggle_flush_vendor(hba, pm_op); =7D
> > +
> > +static int ufshcd_wb_alloc_units_vendor(struct ufs_hba *hba) =7B
> > +       if (=21hba->wb_ops =7C=7C =21hba->wb_ops->wb_alloc_units_vendor=
)
> > +               return -1;
> > +
> > +       return hba->wb_ops->wb_alloc_units_vendor(hba);
> > +=7D
> > +
> > +static int ufshcd_wb_ctrl_vendor(struct ufs_hba *hba, bool enable) =7B
> > +       if (=21hba->wb_ops =7C=7C =21hba->wb_ops->wb_ctrl_vendor)
> > +               return -1;
> > +
> > +       return hba->wb_ops->wb_ctrl_vendor(hba, enable); =7D
> > +
> > +static int ufshcd_reset_vendor(struct ufs_hba *hba) =7B
> > +       if (=21hba->wb_ops =7C=7C =21hba->wb_ops->wb_reset_vendor)
> > +               return -1;
> > +
> > +       return hba->wb_ops->wb_reset_vendor(hba, false); =7D
> >  =23endif /* End of Header */
> > --
> > 2.26.0


