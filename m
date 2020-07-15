Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7D2C43446
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC1F206F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mc+boQkg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgGOIfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:35:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46766 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730199AbgGOIfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 04:35:20 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200715083515epoutp02f43afa447c653823575d8e38474a0a66~h4BL9TbdE0838908389epoutp02N
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 08:35:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200715083515epoutp02f43afa447c653823575d8e38474a0a66~h4BL9TbdE0838908389epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594802115;
        bh=9lFI7VGYR7Ejqu8MSPZbVA78HowkJB2DLWHW06Qk2Po=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=mc+boQkgJqIEA4yJvV7LtmuQixeqPCXv7yprdfXvyrClw6e93aJUKRJO9qz8q2ouB
         njnABLcAWNZitIz/ZiTirzQ4Hy5+nKqijB1bZRVvjmA7Eez5a40HCnRuyl/sIp3xnU
         wrZ1tPeUYbYaCtjYq/3fLXdJ3dQISuE+S0/MQjT0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200715083514epcas2p270864fb69b7978744cc6aa446ba56eb1~h4BLVyZqc0602706027epcas2p2l;
        Wed, 15 Jul 2020 08:35:14 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B69gN0FwzzMqYkf; Wed, 15 Jul
        2020 08:35:12 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.81.18874.EBFBE0F5; Wed, 15 Jul 2020 17:35:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200715083509epcas2p4b41545ff0dbb744a15601512552cb9bd~h4BG6hL3V2095820958epcas2p4m;
        Wed, 15 Jul 2020 08:35:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200715083509epsmtrp2a001af461fddf8a56100d56ea1fb109a~h4BG5shKR2373323733epsmtrp2D;
        Wed, 15 Jul 2020 08:35:09 +0000 (GMT)
X-AuditID: b6c32a46-a92a8a80000049ba-f6-5f0ebfbeef4b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.DC.08303.DBFBE0F5; Wed, 15 Jul 2020 17:35:09 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200715083509epsmtip112b2f079ad8f913d66bcd07a6a71af20~h4BGozVlI1656116561epsmtip1J;
        Wed, 15 Jul 2020 08:35:09 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB4640958B96D370146EA86334FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] ufs: introduce async ufs interface
 initialization
Date:   Wed, 15 Jul 2020 17:35:09 +0900
Message-ID: <000001d65a82$d98c7ec0$8ca57c40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJf3Lb61o2624A7HIYY502pzJR6wwGotN4cAhHmw+Kn13WSUA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmqe6+/XzxBkcf81k8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAIyrHJiM1
        MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
        QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G7b5r
        bAWLXSs+3brC2MC4Qr+LkZNDQsBEYsvPg6xdjFwcQgI7GCWWbZvGBOF8YpRY+OURO0iVkMBn
        Rokrq6xhOvZ8vAVVtItRYtWSDlaIoheMEl8mpIDYbALaEtMe7gYbKyJwn0niyM4HLCAJToFY
        ia0HuphAbGEBf4lPc5eCxVkEVCV+btrOBmLzClhKrNk0lRHCFpQ4OfMJWA0z0NBlC18zQ1yh
        IPHz6TKgBRxAC5wkZmzNgSgRkZjd2cYMsldC4ASHxNmFD6HqXST2bYeYLyEgLPHq+BZ2CFtK
        4vO7vVDxeol9UxtYIZp7GCWe7vvHCJEwlpj1rJ0RZBmzgKbE+l36IKaEgLLEkVtQp/FJdBz+
        yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfWQWH/zM9sERsVZSJ6cheTJWUi+mYWwdwEjyypG
        sdSC4tz01GKjAiPkuN7ECE7NWm47GKe8/aB3iJGJg/EQowQHs5IILw8Xb7wQb0piZVVqUX58
        UWlOavEhRlNgsE9klhJNzgdmh7ySeENTIzMzA0tTC1MzIwslcd56xQtxQgLpiSWp2ampBalF
        MH1MHJxSDUwLUuQdbZnifbanP9y4zENDLlqgOzNo89rAsIPWD5sYBDatlg2xMvMMc9lnftxk
        g5dUXsJ85oLDt7f2mL1T7Fyw7b5qVA/v8Vs+BTKVIYwG3yTfpvd8+zf3qqre9N5+x1esvFem
        2Fc5fb1iWnNOwaeei9ctUfKb/Ky/7DutXl1XTHmV6n744/aeJ0FLSh9cni6Q91o2ccuveX8K
        EtzkA44s47+wrbI2R7G2+diOXSUBalWtZ96tka63rTqQelKVW1j+woM1u54bN9iuqteexG4g
        cDFnw+7KxybbXOJVZmqXpgbNWZe+RM/p2I+zvsqnTpTvMGF33l1gnrHn7D7J+UmXrt7LiUlK
        VO1YKqLnpcRSnJFoqMVcVJwIAA93pShWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnO7e/XzxBpOmaFk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY9vSzewF510q3k67z9TAuEevi5GTQ0LARGLPx1tMXYxcHEICOxglDqw+yAyR
        kJQ4sfM5I4QtLHG/5QgrRNEzRomPO3vBitgEtCWmPdwNlhAReMskcef2ZahRLxkllrZuYQWp
        4hSIldh6oAsowcEhLOAr8eivBkiYRUBV4uem7WwgNq+ApcSaTVMZIWxBiZMzn7CA2MxAC57e
        fApnL1v4Guo6BYmfT5exgowUEXCSmLE1B6JERGJ2ZxvzBEahWUgmzUIyaRaSSbOQtCxgZFnF
        KJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcj1paOxj3rPqgd4iRiYPxEKMEB7OSCC8P
        F2+8EG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5akZqemFqQWwWSZODilGphMRBkP
        /f0y4bYNx+/6Pyay7rf0Tk4SbQ3UmeyjKPKLZ8GlH88i286EPtPZtfqrc9HxTy8crfgM9jdo
        iHOc/pLP+6m5cYr2u6A1vKffPL1gvSpvn9hdy3usntLzRHxnttkFTldds6PibIPY9Np3W/uW
        +z4Vs9i8V2jpgnvNdtMCT76+nSmcEx/JHq7N8eHwmteV0ju3aRXx3GCVNF/9KeZfYYVR2WET
        xYPOuaXLJi8QcGM/wyM02fqe9SuRlxKrZ2kwRl7a+35psd5b06LC6c4lRQ9OL+59vfyk6r4D
        jx/43olZIXw5s7vXdwlDfckuk+tTDwvM3HJm/+PLOfllN0xPV3Q4TfoXmPzM6cT0c5uZlFiK
        MxINtZiLihMBAi8ntjYDAAA=
X-CMS-MailID: 20200715083509epcas2p4b41545ff0dbb744a15601512552cb9bd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8
References: <CGME20200702082826epcas2p2face6d1689c2f5efc1dcdb53c19804b8@epcas2p2.samsung.com>
        <1593678039-139543-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB4640958B96D370146EA86334FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi,
>=20
> >
> > When you set uic_link_state during sleep statae to UIC_LINK_OFF_STATE,
> > UFS driver does interface initialization that is a series of some
> > steps including fDeviceInit and thus, You might feel that its latency
> > is a little bit longer.
> >
> > This patch is run it asynchronously to reduce system wake-up time.
> Can you share your initial testing findings?
> How much time does it save?
For this, you can refer to the Grant's comment and
As you might know, the time reduction relies on devices,
situations - after spo or not or whatever.
The thing is that system wake-up time is very important for product makers
and the period that I'm seeing on this is not an amount that you can ignore=
.

>=20
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> > ---
> >  drivers/scsi/ufs/Kconfig  =7C  10 ++++
> >  drivers/scsi/ufs/ufshcd.c =7C 120
> > ++++++++++++++++++++++++++++++++++---------
> > ---
> >  2 files changed, 100 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
> > 8cd9026..723e7cb 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > =40=40 -172,3 +172,13 =40=40 config SCSI_UFS_EXYNOS
> >
> >           Select this if you have UFS host controller on EXYNOS chipset=
.
> >           If unsure, say N.
> > +
> > +config SCSI_UFSHCD_ASYNC_INIT
> > +       bool =22Asynchronous UFS interface initialization support=22
> > +       depends on SCSI_UFSHCD
> > +       default n
> > +       ---help---
> > +       This selects the support of doing UFS interface initialization
> > +       asynchronously when you set link state to link off,
> > +       i.e. UIC_LINK_OFF_STATE, to reduce system wake-up time.
> > +       Select this if you have UFS Host Controller.
> Maybe replace this config switch with platform capability?
> So each platform vendor can choose if he is using a sync vs async init?
Got it.

>=20
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 52abe82..b65d38c 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -8319,6 +8319,80 =40=40 static int ufshcd_suspend(struct ufs_hba=
 *hba,
> > enum ufs_pm_op pm_op)
> >         return ret;
> >  =7D
> >
> > +static int ufshcd_post_resume(struct ufs_hba *hba)
> Why do you need to move this code around?
> If its async - then there is no shared code - you go through the full ini=
t
> flow, and just goto out?
With SCSI_UFSHCD_ASYNC_INIT, ufshcd_reset_and_restore would be run by
worker asynchronously and in this case, some stuffs that are supposed to ru=
n
after completion of ufshcd_reset_and_restore without SCSI_UFSHCD_ASYNC_INIT=
.
So the stuffs should be run somewhere in kworker context.
That's why I teared it.

>=20
> > +=7B
> > +       int ret;
> > +
> > +       if (=21ufshcd_is_ufs_dev_active(hba)) =7B
> > +               ret =3D ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MOD=
E);
> > +               if (ret)
> > +                       goto out;
> > +       =7D
> > +
> > +       if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
> > +               ufshcd_enable_auto_bkops(hba);
> > +       else
> > +               /*
> > +                * If BKOPs operations are urgently needed at this mome=
nt
> then
> > +                * keep auto-bkops enabled or else disable it.
> > +                */
> > +               ufshcd_urgent_bkops(hba);
> > +
> > +       hba->clk_gating.is_suspended =3D false;
> > +
> > +       if (hba->clk_scaling.is_allowed)
> > +               ufshcd_resume_clkscaling(hba);
> > +
> > +       /* Enable Auto-Hibernate if configured */
> > +       ufshcd_auto_hibern8_enable(hba);
> > +
> > +       if (hba->dev_info.b_rpm_dev_flush_capable) =7B
> > +               hba->dev_info.b_rpm_dev_flush_capable =3D false;
> > +               cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> > +       =7D
> > +
> > +       /* Schedule clock gating in case of no access to UFS device yet
> */
> > +       ufshcd_release(hba);
> > +out:
> > +       return ret;
> > +=7D
> > +
> > +=23if defined(SCSI_UFSHCD_ASYNC_INIT)
> > +static void ufshcd_async_resume(void *data, async_cookie_t cookie) =7B
> > +       struct ufs_hba *hba =3D (struct ufs_hba *)data;
> > +       unsigned long flags;
> > +       int ret =3D 0;
> > +       int retries =3D 2;
> > +
> > +       /* transition to block requests */
> > +       spin_lock_irqsave(hba->host->host_lock, flags);
> > +       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> > +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +       /* initialize, instead of set_old_link_state ?? */
> > +       do =7B
> > +               ret =3D ufshcd_reset_and_restore(hba);
> > +               if (ret) =7B
> > +                       dev_err(hba->dev, =22%s: reset and restore fail=
ed=5Cn=22,
> > +                                       __func__);
> > +                       spin_lock_irqsave(hba->host->host_lock, flags);
> > +                       hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> > +                       hba->pm_op_in_progress =3D 0;
> > +                       spin_unlock_irqrestore(hba->host->host_lock, fl=
ags);
> > +                       return;
> > +               =7D
> > +               ret =3D ufshcd_post_resume(hba);
> > +       =7D while (ret && --retries);
> > +       if (ret)
> > +               goto reset;
> > +
> > +       hba->pm_op_in_progress =3D 0;
> > +       if (ret)
> > +               ufshcd_update_reg_hist(&hba->ufs_stats.resume_err,
> > +(u32)ret); =7D =23endif
> > +
> >  /**
> >   * ufshcd_resume - helper function for resume operations
> >   * =40hba: per adapter instance
> > =40=40 -8370,6 +8444,14 =40=40 static int ufshcd_resume(struct ufs_hba =
*hba,
> > enum ufs_pm_op pm_op)
> >                  * A full initialization of the host and the device is
> >                  * required since the link was put to off during suspen=
d.
> >                  */
> > +=23if defined(SCSI_UFSHCD_ASYNC_INIT)
> > +               /*
> > +                * Assuems error free since ufshcd_probe_hba failure is
> > +                * uncorrectable.
> > +                */
> > +               ufshcd_async_schedule(ufshcd_async_resume, hba);
> > +               goto out_new;
> > +=23else
> >                 ret =3D ufshcd_reset_and_restore(hba);
> >                 /*
> >                  * ufshcd_reset_and_restore() should have already =40=
=40
> > -8377,38 +8459,12 =40=40 static int ufshcd_resume(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >                  */
> >                 if (ret =7C=7C =21ufshcd_is_link_active(hba))
> >                         goto vendor_suspend;
> > +=23endif
> >         =7D
> >
> > -       if (=21ufshcd_is_ufs_dev_active(hba)) =7B
> > -               ret =3D ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MOD=
E);
> > -               if (ret)
> > -                       goto set_old_link_state;
> > -       =7D
> > -
> > -       if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
> > -               ufshcd_enable_auto_bkops(hba);
> > -       else
> > -               /*
> > -                * If BKOPs operations are urgently needed at this mome=
nt
> then
> > -                * keep auto-bkops enabled or else disable it.
> > -                */
> > -               ufshcd_urgent_bkops(hba);
> > -
> > -       hba->clk_gating.is_suspended =3D false;
> > -
> > -       if (hba->clk_scaling.is_allowed)
> > -               ufshcd_resume_clkscaling(hba);
> > -
> > -       /* Enable Auto-Hibernate if configured */
> > -       ufshcd_auto_hibern8_enable(hba);
> > -
> > -       if (hba->dev_info.b_rpm_dev_flush_capable) =7B
> > -               hba->dev_info.b_rpm_dev_flush_capable =3D false;
> > -               cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> > -       =7D
> > -
> > -       /* Schedule clock gating in case of no access to UFS device yet
> */
> > -       ufshcd_release(hba);
> > +       ret =3D ufshcd_post_resume(hba);
> > +       if (ret)
> > +               goto set_old_link_state;
> >
> >         goto out;
> >
> > =40=40 -8427,6 +8483,10 =40=40 static int ufshcd_resume(struct ufs_hba =
*hba,
> > enum ufs_pm_op pm_op)
> >         hba->pm_op_in_progress =3D 0;
> >         if (ret)
> >                 ufshcd_update_reg_hist(&hba->ufs_stats.resume_err,
> > (u32)ret);
> > +       /* For async init, pm_op_in_progress still needs to be one */
> > +=23if defined(SCSI_UFSHCD_ASYNC_INIT)
> > +out_new:
> > +=23endif
> >         return ret;
> >  =7D
>=20
> Thanks,
> Avri
>=20
> >
> > --
> > 2.7.4



Thanks.
Kiwoong Kim

