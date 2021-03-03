Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1884C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7628A64EDB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447091AbhCCMrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:39 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:14226 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbhCCLqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 06:46:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614772087; x=1646308087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lr5Ig5uYNa8ZQsywnU8fc+8RlgUSssheYvJJkYLPYjo=;
  b=EvRnCJtQbzMrGvhDLq81liRjSkmmRGVA2FoX7UN9XbsYKtwoya1/iNpX
   SPfpE4N66WfICZvqOrBqeqB/niiH5j8yryxqwqFvL7crKW1q3YsHwD6EN
   Vbzf9z5uoGUoDtRM48lNqUcRO2CMO6FjcH1oFurMBH0n6ANkUYhfbewxw
   18HITUPIY1eEVmQKReM9ceL3p+Fug9H1p1hf6sp78CUfmB/vcpyHNLkjv
   IHco3ckKbfV7hUrAOnug/2eXzwWxEVNbnq7H/a4/CeM6QNn01xA8KT75t
   Dd53Ug8nEGysQBTqPA/qpQR5tvS+/aceqXMEiRNdJB20uVFalW13wjpiu
   Q==;
IronPort-SDR: 27TxiZQR7kFQFTeS+e8TKimp/yXvd3cL8KFDN39Y5WCDLfTnp58X3zBzLgQb4zldF09OFLQPKW
 OxAzdBXHKm4+QVErzm+nkKHTgDMwlMNDnrRrRnB9HgYuZcqwOAyYzoek9vyifEOcHyVewpERLq
 uwkBiqCmNsqISJo0g+ZujppPSXI5RR/8q5tvmAWs1j1H6g618N1D/6iTyT/2oZdWw8+lAegxVD
 jzD7hypJaRS5IgIKzkn1JypeKYmGhQDyJ4xSyD4CSKTdLPHrsCqNWxW7yiaCmuT9ckFxRNJ+Ss
 bwE=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="265543320"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 19:44:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+/IWmad98Rss3yVb+FPkVo8K9QywAQwFrQ2jiGalAUOyzMCNfo6EGvqVUo09aVa7J3W8wDIZBL3Mj0Moo4SM64cLhpqo0jffB2bD/34SxGf6I8tQOZDGrKZeeFZNSVtdWUomvIrwOmKMmo6mNI9H1SwDosTgeJz5SKS8WeJmAXbo0+N9Nook5diOfX3TJUO0KIEpTaCy9k5fYTikR3BJnwtq/BHo/GKo1wj4+DBcf5ouqTE+dYKCZlRZUUw57J4WxbtbBnxFd/8ny+rhUwA3S+jcRcZmDoyn5Ng4xqH+JZcrQgQrUFYHWHItwxP6YWn1qcQo+nxi667zvMuMa4d7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwHQnIqUvw5uye542MJW4jfW5WvShQp+/IPY/uD0P+w=;
 b=F+a1WsRMyvEQLL+1upTvS0VYKmkiJk1qdi27CZHUje+SC6h6Hnlepp8+pc8IH8kKdnkgSxKNfI12Ldq7xHzl6z8/00Wgq5eoIWAcrUtQDmorHtf5fl7U8+5N71gM6qkZge2N0LmnpDgmg61rWlg4nHvyDrXVTxCN3C+nAW7jvM1fDmW6TnIOliIfWEFse6iP7Albjq6eBP5ChvDxImKoqNYToVjIaJZiqGzBBMcvWwoUd9z/RsG2/UrrCLnqwKIYZeGhUKnAX/879VYm/CFu0PaCdvdkdT92nyJMPWblqgg6c3oz4bzqslf+dZ6LH1Czpi8Vz6X7SxbnQORVYv9A8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwHQnIqUvw5uye542MJW4jfW5WvShQp+/IPY/uD0P+w=;
 b=FH4KvEOlslVoBnK3yiD6mpl9lTaUv5MNuygCQQ+dKUsB2Cu8QjMe72CFCTArUEQ1Z0u1OyZdbTKkBSamlfmMgToX+5g/1funfQ93NuTWz+HAyz4PlIP+kJ8VRmHyDLSTh/m13K1CeQ9KpEjrfqxxZ0c1B+Bzb63MLAyG4WyznBo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4428.namprd04.prod.outlook.com (2603:10b6:5:9b::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Wed, 3 Mar 2021 11:43:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 11:43:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
Thread-Index: AQHXCm8VGyJQOUJ72k+Gqmf0n4Zi1KpyL8Yw
Date:   Wed, 3 Mar 2021 11:43:19 +0000
Message-ID: <DM6PR04MB6575A96167ACB04BDB8ABBE2FC989@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
 <1614145010-36079-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1614145010-36079-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96e84d15-50a9-4a79-c50d-08d8de398b05
x-ms-traffictypediagnostic: DM6PR04MB4428:
x-microsoft-antispam-prvs: <DM6PR04MB442873C9F8DD68BBDF3ECB77FC989@DM6PR04MB4428.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W0+pNdJ7O0GrGbf2zE1Fw8bItTl9TOtETtAGDnBkAlF3cC6aNpK7LM5WPP1LiNmCFIF6thRF7gWTf3IPcQmZN71tasi0h3IQ6Qp9536fNjC0OpAw8qNYFgIb3qQ1uoXiBUtcOANxoI3xdPpkdcp9wSnKFgZcXZ3Gh3Mx0+eH76PnbPDfUIY8lpJkhajLnWNJsgo7O55IGhkJkSFYER9PyAiKLzvHYQqgGswXpT1VSv/lBJoRsOJhAU3KjKGPUqiZKgTCx8UEeVODn1y5Ua7h3+owOxOu8lQ43EEjemd5h+1lG4RMvgtsUi0+6oXIu1uv+kOsC63GC3O9oRbNOxCJNcYIfFWPsPZKOK7WFJpRIH31J3a/+wcC3DNufWscNrpPL15JfNCqyxuxvtWGJmdbWRI2rujOm6yE6D6mg2galYb+Xbr53sgo9tjDEel58YYvAyJ9pRb99QhvYlkpkaFbwpf9gfSlsGhBbxA07IJ0B+wo0NdqjoV/J4QqJ5uDA+/dFWujlaL3HTSqffdeuSZ3sA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(26005)(83380400001)(5660300002)(55016002)(64756008)(6506007)(478600001)(66476007)(76116006)(66446008)(8936002)(66946007)(186003)(52536014)(110136005)(86362001)(316002)(2906002)(71200400001)(9686003)(66556008)(4326008)(7416002)(54906003)(8676002)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ABDQnoK5oJlveNKoTANo5PXcfWwBw4zDiFIGH2XpjhteKIIifbXw3lJuRFxK?=
 =?us-ascii?Q?vmcZ263npabLpmfym17c3AmRz2wirMsh71H2sBgvFyGvJofTUtgwO99/CFD2?=
 =?us-ascii?Q?RcYXtpJ8mcGSLWlJYc/wwOukr/eH2SjdnnOlZjdSuuHjTy7VS3Lwawo2Z0s6?=
 =?us-ascii?Q?J99k6ixoU0Tmz/GKuRbA4Wm/woM1jRN7fMpoiMfitOrWKSDRIQ7yYPqLIIZS?=
 =?us-ascii?Q?Xri4nkiPzuFpUn71/9HZO55HvyF8YWNaWyz9ZpVoBEpsfickbHfZ6kWgYbsU?=
 =?us-ascii?Q?3valk4k8/xCyVgxut0kCEBhBp8gu7ZnhIBbVs2lllwKtNmDB/oPJGfTL0p5U?=
 =?us-ascii?Q?aqMcoW7Lw7YHkU4QMewlHFGvZdrACczUSPdv2RPPuMqfxOrmRKaFCGpQIczN?=
 =?us-ascii?Q?QdBu4tg+Lj/F7M3oKn9RzKpjboHzDoLpTBH1+7lm0d0BPbAv5j6sFH8z5cCa?=
 =?us-ascii?Q?UMZ4NoxgWygCipHS5hjL8U+HnXJCmMIIQ01pJSzRnhK8iMOPM42moi8YwcO8?=
 =?us-ascii?Q?8UIvjouQYRoVi+qemZx7AccEQGQlBxGbHJYgzECWJfvBXpd2LGajQxfGrHkk?=
 =?us-ascii?Q?WZIKVvlM9G1E13erfO5/lqFB0XPqaq/hOIK9oLjCz01J40VnUK0j7XVkbROx?=
 =?us-ascii?Q?CZfyOwasQJY+KSJT7VsllUhWXjOo0gcVck4K+1Ol8Q4HhI5xX93C8lqTX97G?=
 =?us-ascii?Q?GIMxc43Fq0hZHK14Haq1t253UMue022F4mq1v6UbG7b3N1JB31fkRs7xiALD?=
 =?us-ascii?Q?+2NDJJRxvL5XdcWiuE9FiLbJquulDbjn7m8R7RVIofIrZC96Bz6ScPPCD1lt?=
 =?us-ascii?Q?EnUUL5hLikjV5sG7WoAfx5dcHaHZCKEN52vniBGGLLAuy3Af60T74XJIAVOW?=
 =?us-ascii?Q?+ZndZikCDONa70lgVS/Qh0r5mOeFqo8LagpGuWNGnpENd6n8UVnqcYBUCqhX?=
 =?us-ascii?Q?vE1RCdOmPFkCSD0ShHohR9V2hPy5FHSFeuDGsmNWqU/1z5+bgY2/EgyjgYi5?=
 =?us-ascii?Q?FBB62dnYJq2EyDUjscOBjwDw8cfTWuJ91JohQFaUec4HxW5YSkctBEbXocdT?=
 =?us-ascii?Q?UnplN/iFopxBUCYtkHKsJ0iroRnc049cBeHhNdzrGQhs3BV5pcRg8nwm+3C6?=
 =?us-ascii?Q?SQFnssfq3Bc5M5hE/MR9a91MjhkkPa2zzQfL4Qq8u9cwk2lISIKtoOFtpMFS?=
 =?us-ascii?Q?0sz41WAaGuhN8sSaCOkJwhe0wHevg4yGs2DdJIKrsbkRcekS9w0mq/9JRNup?=
 =?us-ascii?Q?vy9vibA8kvM74Ac1mvLZvCI5NiniRFpXPjK26pWUb/P03e00P5ZvA6EMP6JY?=
 =?us-ascii?Q?yNf74GxLgLrxpFfAE96HIgUS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e84d15-50a9-4a79-c50d-08d8de398b05
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 11:43:19.7747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFJmuIlH6rnsaEu308NpAZ5pLccW+0E8i/mKp4QftlqJRhiJRMLB/nI6LQXRZe1G4pO/+HRi5UaSK74sqnRwHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4428
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> In error handling prepare stage, after SCSI requests are blocked, do a
> down/up_write(clk_scaling_lock) to clean up the queuecommand() path.
> Meanwhile, stop eeh_work in case it disturbs error recovery. Moreover,
> reset ufshcd_state at the entrance of ufshcd_probe_hba(), since it may be
> called multiple times during error recovery.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 80620c8..013eb73 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4987,6 +4987,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>                          * UFS device needs urgent BKOPs.
>                          */
>                         if (!hba->pm_op_in_progress &&
> +                           !ufshcd_eh_in_progress(hba) &&
>                             ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) =
&&
>                             schedule_work(&hba->eeh_work)) {
>                                 /*
> @@ -5784,13 +5785,20 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>                         ufshcd_suspend_clkscaling(hba);
>                 ufshcd_clk_scaling_allow(hba, false);
>         }
> +       ufshcd_scsi_block_requests(hba);
> +       /* Drain ufshcd_queuecommand() */
> +       down_write(&hba->clk_scaling_lock);
> +       up_write(&hba->clk_scaling_lock);
> +       cancel_work_sync(&hba->eeh_work);
>  }
>=20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
> +       ufshcd_scsi_unblock_requests(hba);
>         ufshcd_release(hba);
>         if (ufshcd_is_clkscaling_supported(hba))
>                 ufshcd_clk_scaling_suspend(hba, false);
> +       ufshcd_clear_ua_wluns(hba);
>         pm_runtime_put(hba->dev);
>  }
>=20
> @@ -5882,8 +5890,8 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         ufshcd_err_handling_prepare(hba);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_scsi_block_requests(hba);
> -       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +       if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
> +               hba->ufshcd_state =3D UFSHCD_STATE_RESET;
>=20
>         /* Complete requests that have door-bell cleared by h/w */
>         ufshcd_complete_requests(hba);
> @@ -6042,12 +6050,8 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         }
>         ufshcd_clear_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       ufshcd_scsi_unblock_requests(hba);
>         ufshcd_err_handling_unprepare(hba);
>         up(&hba->host_sem);
> -
> -       if (!err && needs_reset)
> -               ufshcd_clear_ua_wluns(hba);
>  }
>=20
>  /**
> @@ -7858,6 +7862,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool async)
>         unsigned long flags;
>         ktime_t start =3D ktime_get();
>=20
> +       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +
>         ret =3D ufshcd_link_startup(hba);
>         if (ret)
>                 goto out;
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.

