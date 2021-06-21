Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67B2C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB87611B0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFUI5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:57:30 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45328 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhFUI51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 04:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624265711; x=1655801711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bg4aXK7xIRgNMSN+GueYLF6Yr2U/MF2HjbC7XHnflE4=;
  b=kDSyw6QcstUJvw1OeNtLHGP+e/StQcCiIGjjOGSvYgh+vIjusNlKIvx7
   AaohwhChbzyAirzIphnjb7r5gJsrZqIlqfzykKrA/mLadVcgOh/hd9YAu
   IfwYU5eZeMDUJiQ+FUimJ2BMnepbkT6WLPm9WnV958E53IwYRc+7noQtn
   kcB5YtelM/sEaeXhP0HXaPqjVOpDSEj48M+7owuw/3wRYvh83vWHSC52w
   MZ+ITCW5fwA1cqWRu+Ia7oLnbf6QTTZoT5LrhTNVeFnYxstIXxQD1jLO0
   SIDWmkkfhkpcdK4NwBCBnOzBO9gvOfSa/t7rVw/MIEubWg9gfzVmhPxrz
   A==;
IronPort-SDR: upZ4WHIU6qFyttK2aXFy9IkRvDsSfmp+v0aheeyXKz23QnOvVHVKFZIPbeCN6+KtOML7ofMHOa
 XcNBqacpQKRf7f0JBBHEEvs0IpUHTMgzL4m5BSXaE/34WcgRZfkn8hRHO6GUW23nyn5+LbfS48
 1CUqXsc5+wdbfAHgd8l8YFwtSGC77alPm+doQF7lI99OesQ9S7F3P+PsuAlbu4SthE0CDjwEDt
 W7j1Df54C7HXa2NCU3ln5G+2h2KYvt/KGY8H1mCzl6w/DyJQ6P6xW0sNmgT2L0wN4DdeOzVEnb
 VDk=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="172469901"
Received: from mail-dm6nam08lp2041.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.41])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 16:55:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktASoyrXZqFnBL3q+tWIz7lqSZ9xmZbZWlW9NRtf1XWhOkKCCl3p80gPZfv2SLkzyhQp782tzqlHh/iwNLU6f/LXmTkqo8iprt05KUp0Uf+PK7xHcqLKKvIuzx9PUF+yMTbucGG74+yaOho2Citn0Q8Ni25cTbXqLQfPfYc0fk0a2GB1khu2X2QhJJXxJWJX2yh1TdbGCLvvtevbRfdjIgORyFhDEJp8pRSicJF6pbGAd2Rc0RLeGjoZ19YKUssHiczM8mdtn7l+oZjWCrPZxQR2Of5CeaEId7bNZpwRsghspgXfy4P6zB4HiOwxuC/yraPsOJyAgvhmcXcEzmfolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDVTJ2FvnXrwsItJ50Od6IoyLTOzJu6kYiqa9pU5EqI=;
 b=BXPTxbAHyUUz/gLAuXYRz98s4YJzDZEGfNIBIfv6zq5CfDzE+LLKx4Cs4DteitB4QszKi2ezJ9dS+hYg9IjyoEany9C0VabZD0YIsquGQkuQ2zBa4oPTD907S3HU/hY3V9TQAMMHxbEVOXzItRUURxfr/yM5KfbPV7+YqsGJ02+4jrLuJvrAtnEnaLvtHQZWvz0zscvveO2Oz+GVRKqLoA3lpBcfudvDFBgs0U42rejxTPyTMNJLmUYjZ2/EyRiYszlnY1IQrnV5Bt0DB8w8U/50qOwD1/Q21wExWJUIHRRDzAGKkAKWBjWzZP0Dpr18YiccMSfzA3BKoyepcPVp5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDVTJ2FvnXrwsItJ50Od6IoyLTOzJu6kYiqa9pU5EqI=;
 b=szuHEV/AejwhX96rrXDoFl1ReJcUpYUj41/Sm7ZpyXIXhufY1rR2L7vabGUEo1LK4Rwa9Ub7/VFYaFTUnNebDpNXIYFDoJbGMwkAC4C4cGVItqcAIlPspSt0KLaak6JZxHV1ZY5HUyzYYx/SiQSE57LdR8VsKwpzvNqQIIBq5Ds=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7116.namprd04.prod.outlook.com (2603:10b6:5:242::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.19; Mon, 21 Jun 2021 08:55:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 08:55:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH RFC 4/4] ufs: Make host controller state change handling
 more systematic
Thread-Topic: [PATCH RFC 4/4] ufs: Make host controller state change handling
 more systematic
Thread-Index: AQHXZKVzHmiYPcNZAkKvX7gl9FfgSKseLMoA
Date:   Mon, 21 Jun 2021 08:55:11 +0000
Message-ID: <DM6PR04MB65756FC4B5BA216BB72FF22BFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-5-bvanassche@acm.org>
In-Reply-To: <20210619005228.28569-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9885d111-0d4d-4a20-96b7-08d93492475f
x-ms-traffictypediagnostic: DM6PR04MB7116:
x-microsoft-antispam-prvs: <DM6PR04MB7116ECC6D5871C0F79004E04FC0A9@DM6PR04MB7116.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VckOjyszoxm+LXhVmj0i+I1MVCEKDcuJKjYSOatbMxn1s1BxxF0HTliPxfxMbuwFiz/QziuaSETkSwFvNTVXDBKCG2a7d6Lku7fwevlAcN6bRO596ssrR4qXUGeszneqyoeV3iA2OKcXlGBhrM9pTfOy1irwQ7hA90FV2C0XU4DGqaIdRsa+HMu4df9UyZdFi/BGJ/JktzBSo/8XoMJlZ77hq5Fd+X5k7v9OxR/+0jJiVZgeuHH3Pgxn//UMFIywfaPZc/peQNbfHcR9kyF48Ex5ef+jm8Mm8LFl65uXSB+K+Cb+OtvfbFFtKk1CfvFeuzKjwj82DuANy4ek8lYi6t/tl5Pr1c96xA4s0UPDf+w9+kguS/E1SfL+sUzXjzNkG0g7su/GOEGwAOtPCxx4URGf+fSsnol+0d5+WaziWf7yRCIaVNSSxzrWMror0EB5pHg9v7kAHhZ59rettATdSvgcNRIL9J6Ya040Qiiac7mnGQVoECkaHp+ZiXEDu3/na21521zOh1jEUTHzxIRqP/iYsW1jX4lom4upJl4VycMPywj3LLUh+lzZhVP8yNYE2mrYudVmnH3piUI7WBn5pZQfFBdSr9UYZKm+ZS/2+0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(2906002)(66446008)(64756008)(6506007)(76116006)(4326008)(66556008)(66476007)(7696005)(71200400001)(66946007)(26005)(38100700002)(5660300002)(478600001)(186003)(122000001)(8936002)(55016002)(316002)(86362001)(33656002)(83380400001)(110136005)(54906003)(9686003)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wbr0+WOOOYWZNlqi0SOa6h1LDX3mI3NBHkeTEkfyPrW3pB7r5wOh2yLXj1e8?=
 =?us-ascii?Q?Jsq5Lnw++7X/ozNHqy4rsZAWryOYivm/osGv4KZ1b2YFgau3RnVHzXSjVjOd?=
 =?us-ascii?Q?OMCu5wTv7q6CXO7d9Kf/prOvYN0rx8eL213Ik/YuyL40a0BtZf8u/01u9KBl?=
 =?us-ascii?Q?ZmOWpMaOoqA3h7UTHWVtYAe9/2gyy/1JtpVosivqpSlqMTBXnkYnkEe/VxQv?=
 =?us-ascii?Q?5spF8WiJubgtqWMIcXt17tgSXOnNEp96yxj/hWDjOPjw1B2TrvZ6VVh8+u0B?=
 =?us-ascii?Q?qS5XT1Fo3EogLpao7UnGq0vBC0xPSnHXHDXiacNwhC8we7Ump9q7HT3GSRlM?=
 =?us-ascii?Q?o7qzdICgjAWP1Tk3d4llr1FM138FoxaDnbTI5lP3yDgeN3tMHB6iE+NmZ2+5?=
 =?us-ascii?Q?k2YQSPlM4J6GANg9r9kGvovDzTf7zsfmBsDrDtEmD+XDTIspeON92yHKknuq?=
 =?us-ascii?Q?Sp+HDdtczjgoi+HAcnTjUdS2WokP2HtOzhxVDntjcwSX8NjCMHRKkIZHcmhv?=
 =?us-ascii?Q?e16Zof1awM4qWEldQdEmduXD9KXxcR9vZ0/eR7P6YEGlavcMUzCjCGj508Z1?=
 =?us-ascii?Q?R3mmucwfu3l5HrU/WdWrLWDW1pqERZQdKSX7KV462IELTjfrYi6nKIgg/0d2?=
 =?us-ascii?Q?xdnEQnEwrfNvOgbqLBz6LHBK0uEbvhTaOulz7Scf64Zp/GIGkaXEbzb4LBZ2?=
 =?us-ascii?Q?89sHZGUVb29+iHCH+Xd4SkrdnDaPGklPuFhaCtTXWA+rBIy6zqRlwz92R5Ig?=
 =?us-ascii?Q?e2JT7/ojNZBGDzxTB89NqdWsfpYW9+2zf8CVN6VJbUOiOUgQCYsKzwnZfqp/?=
 =?us-ascii?Q?S66muKdQWNhAxzU80VxQbCe5GAf8l9niDodocTV6Vk06B5L7Eu7MzjdBcrrT?=
 =?us-ascii?Q?aZo9kq55zqu7K6M4KgVy3DKVjs+yobAslvHGpEKWT7kSbrDM0HO04CKHXxxc?=
 =?us-ascii?Q?Zh3L2H4cT+rwv8eWuRAiZV5P6wi5GC4Bi2RfcdcLuXE38B3wmf/t2lBdaNA6?=
 =?us-ascii?Q?lkO4lwlyR2cZv4daMy3SBUNGyc8uwOq4uWwZlqibMnDX4JhIrKjP0Lp8w8n9?=
 =?us-ascii?Q?FfwaQkO+cj8Pju0XKsuowlBmF+ABC8SazaJH417TTiZlYqsbu+gpNU4qd9d/?=
 =?us-ascii?Q?TNkQipbcbspWOcngMRmLmcLj0JtiC5YdKm3rPqb0WJIzhQV5e1grcxn9rUQf?=
 =?us-ascii?Q?e5a7YVSfpKKymRm4XjTEUL36JnCpJYazPenivWgHVd/VOtDmdtoWZO9L8fjy?=
 =?us-ascii?Q?zqHyMr2eEIkNmyz2gV9XeCpxEDWzLuWu9sXJS3R69SRKK0mrpSpgvfvxyVvh?=
 =?us-ascii?Q?seVBt0QSxCkIy4NlnuYsd7tp?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9885d111-0d4d-4a20-96b7-08d93492475f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 08:55:11.6135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S9xHSJdIUWlhjoJAumledTAXnGZeYAXnqqP/rsOG/EOG4ih0GphoNKfkkDSNctgQamVTZCqfzT2kNeRj2xYA6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Introduce a function that reports whether or not a controller state chang=
e
> is allowed instead of duplicating these checks in every context that
> changes the host controller state. This patch includes a behavior change:
> ufshcd_link_recovery() no longer can change the host controller state fro=
m
> UFSHCD_STATE_ERROR into UFSHCD_STATE_RESET.
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 59 ++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c213daec20f7..a10c8ec28468 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4070,16 +4070,32 @@ static int ufshcd_uic_change_pwr_mode(struct
> ufs_hba *hba, u8 mode)
>         return ret;
>  }
>=20
> +static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state
> new_state)
> +{
> +       lockdep_assert_held(hba->host->host_lock);
> +
> +       if (old_state !=3D UFSHCD_STATE_ERROR || new_state =3D=3D
> UFSHCD_STATE_ERROR)
old_state ?

Thanks,
Avri

> +               hba->ufshcd_state =3D new_state;
> +               return true;
> +       }
> +       return false;
> +}
> +
>  int ufshcd_link_recovery(struct ufs_hba *hba)
>  {
>         int ret;
>         unsigned long flags;
> +       bool proceed;
>=20
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> -       ufshcd_set_eh_in_progress(hba);
> +       proceed =3D ufshcd_set_state(hba, UFSHCD_STATE_RESET);
> +       if (proceed)
> +               ufshcd_set_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> +       if (!proceed)
> +               return -EPERM;
> +
>         /* Reset the attached device */
>         ufshcd_device_reset(hba);
>=20
> @@ -4087,7 +4103,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>=20
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         if (ret)
> -               hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> +               ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
>         ufshcd_clear_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> @@ -5856,15 +5872,17 @@ static inline bool
> ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
>  /* host lock must be held before calling this func */
>  static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
>  {
> -       /* handle fatal errors only when link is not in error state */
> -       if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR) {
> -               if (hba->force_reset || ufshcd_is_link_broken(hba) ||
> -                   ufshcd_is_saved_err_fatal(hba))
> -                       hba->ufshcd_state =3D UFSHCD_STATE_EH_SCHEDULED_F=
ATAL;
> -               else
> -                       hba->ufshcd_state =3D
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
> +       bool proceed;
> +
> +       if (hba->force_reset || ufshcd_is_link_broken(hba) ||
> +           ufshcd_is_saved_err_fatal(hba))
> +               proceed =3D ufshcd_set_state(hba,
> +                                          UFSHCD_STATE_EH_SCHEDULED_FATA=
L);
> +       else
> +               proceed =3D ufshcd_set_state(hba,
> +                                          UFSHCD_STATE_EH_SCHEDULED_NON_=
FATAL);
> +       if (proceed)
>                 queue_work(hba->eh_wq, &hba->eh_work);
> -       }
>  }
>=20
>  static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
> @@ -6017,8 +6035,7 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         down(&hba->host_sem);
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         if (ufshcd_err_handling_should_stop(hba)) {
> -               if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
> -                       hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> +               ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>                 up(&hba->host_sem);
>                 return;
> @@ -6029,8 +6046,7 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         /* Complete requests that have door-bell cleared by h/w */
>         ufshcd_complete_requests(hba);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
> -               hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +       ufshcd_set_state(hba, UFSHCD_STATE_RESET);
>         /*
>          * A full reset and restore might have happened after preparation
>          * is finished, double check whether we should stop.
> @@ -6163,8 +6179,7 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>=20
>  skip_err_handling:
>         if (!needs_reset) {
> -               if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET)
> -                       hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> +               ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
>                 if (hba->saved_err || hba->saved_uic_err)
>                         dev_err_ratelimited(hba->dev, "%s: exit: saved_er=
r 0x%x
> saved_uic_err 0x%x",
>                             __func__, hba->saved_err, hba->saved_uic_err)=
;
> @@ -7135,7 +7150,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba
> *hba)
>          */
>         scsi_report_bus_reset(hba->host, 0);
>         if (err) {
> -               hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> +               ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
>                 hba->saved_err |=3D saved_err;
>                 hba->saved_uic_err |=3D saved_uic_err;
>         }
> @@ -7951,7 +7966,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool init_dev_params)
>         unsigned long flags;
>         ktime_t start =3D ktime_get();
>=20
> -       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +       ufshcd_set_state(hba, UFSHCD_STATE_RESET);
>=20
>         ret =3D ufshcd_link_startup(hba);
>         if (ret)
> @@ -8024,10 +8039,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool init_dev_params)
>=20
>  out:
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       if (ret)
> -               hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> -       else if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET)
> -               hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> +       ufshcd_set_state(hba, ret ? UFSHCD_STATE_ERROR :
> +                        UFSHCD_STATE_OPERATIONAL);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         trace_ufshcd_init(dev_name(hba->dev), ret,
