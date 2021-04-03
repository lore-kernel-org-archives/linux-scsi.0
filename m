Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18871C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 19:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB3C6121E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 19:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhDCTpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 15:45:25 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37194 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhDCTpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 15:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617479122; x=1649015122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Zyv1uIa09TT6ueClmPMKYhuefYUiz/jGWjlop/owdw=;
  b=Fys8hQtQfS7R0gZYt1xxSmgK3oXRJTzDCZLkAjjpti0+Y0KtNHeTkxC+
   D5DHTDew1VzMiQ6cuO3G/+hXIxuhMtgX4yLZiiq1uYktMr7/NXQABwrOh
   7M0xl4UK4Y5xmb/e3A5x8K/ISwK9qjzVVWFgw7aZxpfrPzdpA3FaTh8g7
   gBAtlr/ZtNKLdkJf+p4Nf+0G5sXoA7EW5qOwORKWwVdTCcIwQTWcVnJdM
   g+erd9qOJA4LZdXOaQJ0eGXK97ZEmIbCYhq4r14MILZLRhnmfM7+LZc+W
   4kkpDCYQb6atMNxGKXbSxuAaWk55vUHjzaoxAtIbBSGBZM46/woDgFmjO
   A==;
IronPort-SDR: yZpZUtLl4uacUWbagOLW3V8OW1lefRKqeZhPjl36Zz9LCrW8f5Aosa0Kxq38Xo290hJWCYRMRj
 gdQRIhuD5ARxPROTqpDHbMNjbMRnccyo8D4NH81pwrfUU93zC8lxwcKjEMdAdKND91dOTrLNk+
 /SrbrfGJr+Ho5WnFA20KCEE67N21YyikjTKwzYpFYeYPHacqRhMtlrdDF9V5/vWWuch9RfULL5
 KdS0aRln8Ffx+OZiHuTpVSBbvGTlJuEEbwEDAhsmTbOHQJIQfoSwgpF0CUk+q8U8/BXZEByVp1
 y3U=
X-IronPort-AV: E=Sophos;i="5.81,302,1610380800"; 
   d="scan'208";a="163583612"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 04 Apr 2021 03:44:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H12AYC/a0a/F25JtAhUBbnjZjeJGotfyk3+KQoiuVAH7D4Zx7qw5ZWeo9koYuqslBI1YFlqOUuDeBcpKj+Igtn/9943XrTouSFf2EG5af3cKFVHXR+UDnKMleBV/ZFNuhk436Zoj4Vy8wFnAjMBFifYIujIFWscII/rdrlDEAfEQte/Y1zvuOc4FTI5oW25xs34pkaFwIfrxQRGHT2GBPvhCjtJWaNDrXJKtbmTwsbvcsUajS8TZdrkbe8sQ9AM2RFSye8g0In8YxNvkk2oD05nUe1aSb9D32YJ2NwEQPuMYdRSs/y5zHhjC9IYa+EQVsioKWT4riWpP6w45v5r/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgnS/KLbS3h8jE+JXZKpX462AW2yStDyRTE2EpD1/Cg=;
 b=RjH3tOjHXHQmSpYbfULPKxTkmlZz1BfPkLMNX1jhzrjuLfs/YnrYEBnEntFygXCbA6sl5DxRmNmx2NDcStatz8ObzEu2lbm6qWOIO/WAymC+VP+N0ocddrptNSTeNbpe3TII7b1mem+mYWOCpyE4k7Rj6jrfOxt66PLNSX4yEa5deIAtrLDYRS1RFSYCZxGL3xiATm72EwUF+M2adzxZ709X2thMc21vSdBcgDZ9U7Qo1Ed8NA9AYwytEWcb6wbJAyPIv+dALMoaVj4fTOBwrd4HXRQDjeNjkvCBTWSVFF0MXe+jMcrgFAImRIh9d+w/xZQ1/rkHclqlE0/BKCYicw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgnS/KLbS3h8jE+JXZKpX462AW2yStDyRTE2EpD1/Cg=;
 b=YqWv5549o17QbzLVnPojL0AVhO96AVS3vYnNxC6LJNrRaiIyVUxVrgT1chND7kVDXb7eFUxxo+ItV8p4LmJjXXC3x3CO2ql00uN+KmISz4EVAxq+cEMjMT63wT6l1tTF8HUizK5Z6fNsQEXSyOLZ5ezjC7BSpUBJxK/gFjFvf1U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5626.namprd04.prod.outlook.com (2603:10b6:5:167::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.29; Sat, 3 Apr 2021 19:44:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 19:44:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH][next] scsi: ufs: Fix out-of-bounds warnings in
 ufshcd_exec_raw_upiu_cmd
Thread-Topic: [PATCH][next] scsi: ufs: Fix out-of-bounds warnings in
 ufshcd_exec_raw_upiu_cmd
Thread-Index: AQHXJoeuCthvokHAnk+y1L1bOvWX4aqjNDKA
Date:   Sat, 3 Apr 2021 19:44:32 +0000
Message-ID: <DM6PR04MB65751397A9CCA9B677875B3EFC799@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331224338.GA347171@embeddedor>
In-Reply-To: <20210331224338.GA347171@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0b17007-8080-4cf9-25fe-08d8f6d8e737
x-ms-traffictypediagnostic: DM6PR04MB5626:
x-microsoft-antispam-prvs: <DM6PR04MB5626DDA89C6E990A3A5F8437FC799@DM6PR04MB5626.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:156;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gexBf83c5Vr3owLmIMH1hnIrtSK+59BfiPd/JLSYfs/scRh/9XfjSNXNluC3sq9qyLXtLcRHGFaqD4pv3IdUqmhzuWEVHGmpq3Jw5kJevsO+s9BeKk4fFjSDWn5WA3f33ErBIQrYOrRsiAIyYE7lrkpFAFxEARnHLJpmxHKoLbFEBD51f/weyAN4al9C9AtG06Y7isqqvy3im/AGJhWBecjs9avV+WvuhGkOcmcB9YDz1lm6DXHysrIgP5V1ibCW3Qmiz+DvfEbzSFIJaI1eA3zs3HkidwZQ6IRRbv3+X0tNPryt/xnBcSL51FH0lEvx1cDzODahcuemrE2E4Vf69TWwpM5HCI18iEYR/MHymaYFYaxHfZkr50bLcoukmet/zmPjtKf40JYDEQ0LCEYIwaEJ7RXN75Lr5nd1d3r9sHkMincDy5ObMGlCGdJrLVhpZRdvyyjbDmn7zJL+fniImg04fm8usP7jPFlgatVfupWLgd/RIoygYPg2vALlY+AJDmpfM8/PpVu5FTE0K6uweg7koXu7Naa5BcD3QAwcA6cyGF0LBRYcAnbErW0DvTlAPbXXvJTu+OwRtEu3Irk0mwj4xOljgm5GzzM0WbhMr6fQurCOpxhcC3AT9Z9svqVHZFGZHnRWtLuuPIXlLPEpNls3vVX8hAvbXlk3aM0HC/l5pYEqYJG2zqCFjqgCGnKYSFdUY7K9B1aKXGjmt77Xcz4VZYFvBFOe3hbhY30lL7Az27NX6DvF3tJp1//vULz1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(66446008)(2906002)(66476007)(55016002)(64756008)(66556008)(26005)(86362001)(8676002)(33656002)(5660300002)(4326008)(966005)(54906003)(478600001)(8936002)(110136005)(6506007)(316002)(38100700001)(71200400001)(76116006)(66946007)(7696005)(186003)(83380400001)(52536014)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5aVTRWrzi1elKe3vuDQ8fkSS8fTfHvUPs3vPk6X7gLE3FSqHugiBA6jRibym?=
 =?us-ascii?Q?WoFflzfA0qG72MsubvtFUxzUKk7FvSK5cWVbOmOBtwvHNUlMn7CgMge5QT/e?=
 =?us-ascii?Q?LTYK+LYl0oVqcxAYIthmtrb8wPohHh0te3ZvnZRERy8wYrV836H1qCIXjSLT?=
 =?us-ascii?Q?Q9VTnv4OKBP4UbXQiKnMEqkvADxMO0QLLkzR6FRZD92dbT85NB6kpD4TIRQv?=
 =?us-ascii?Q?d0D2PHgr0p708c35XH/zhXwTYIbQshbG/uxVHJLHjYCl9e9p92Yll65bU1Ul?=
 =?us-ascii?Q?UDuyhQ0NFKrUK7Wc5FUHZHsNB+U+rogXEAyEN9ZOO0N9SYjTSn/WbgICK79M?=
 =?us-ascii?Q?7dWLZ8IglxYlY6TOM0tTawXUSp4vLCEkAQezcVw3aCxzTZNF2taYWb3aNEeO?=
 =?us-ascii?Q?gcc043v5bhO7HA5BmTddXUPohAkj2oVls7nMk34iPJWKzNbsYmVC1jc+ngho?=
 =?us-ascii?Q?ANHOeJ2redU1T1wJbw07RGESWKh4TtJHWVGF/NQwzWmkGySLVelRneatslF/?=
 =?us-ascii?Q?PJwXpiBJe8G1WicbGHiCbapQRGf5D3IXu+1jpSvJmfOxiXycGTCR5Q1KkPP/?=
 =?us-ascii?Q?uiWE7AFvI7DqcONwmR/BbGK9X6gPft/MRnrvRamD9esBSZghn4bcedFnUbD1?=
 =?us-ascii?Q?DWrUMjQhcuHx9LzUwzV5d0qnvMKALaoBQYhq9E0O8WhEwkd5USZtBsyfZZR9?=
 =?us-ascii?Q?0+c+ATOvcKCgSWuNqd8MJLHufy8j2eCnmyWtvS3w90a4IehWfvs89urrqq+O?=
 =?us-ascii?Q?mr1s17bNkgApYxkCgbTKWO7QG27fY6nWKnZMfK/1E5lrJLL+New2rnEBYF+Q?=
 =?us-ascii?Q?Lq5w7BaJgAZyJ0gslxIXMRRaZiY+dmrDU0gJgRqB0pwmp5gMDrwT7bwn+3hS?=
 =?us-ascii?Q?Xdxr8Wkrl5gNlezOvNLHELopiLppmgKBrAyoY1wWanevFRAEVn7R0OjACYr8?=
 =?us-ascii?Q?DUD1jXsJ3vGUT5QdQ/9tzSwbS5RYbBZDj5hk4LxMh9cK3P4TIydeTYpEzMIy?=
 =?us-ascii?Q?nPmBTwE2zvn6Rj6muvC/4pbj0eEqcbf1JMfCbkk5/y9z4NernVMsBqswlyM8?=
 =?us-ascii?Q?oExK3TESLWdhbLG3ltwXOe3AE/e9hQhDd5JkNt0Tf6zc5GUIxSD5Th0rt3Ic?=
 =?us-ascii?Q?dfbbiCJD/AiPUiVfwBx9+TGajWh5yWJ6jafPH+p3S3wN2e0+Ac/3PHr/z8sU?=
 =?us-ascii?Q?Qzq8SH1epuZbQ+wIIvd8r4X57lp4XPiW5YbU9cn6E+kjQaZxuUTztS2oSUD1?=
 =?us-ascii?Q?kRqDUtXvMHgXJ7q5KaoT5wuwh2R54Vxez31GMYS0I0/9lOGVc9XHVn/SJLMg?=
 =?us-ascii?Q?R9I=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b17007-8080-4cf9-25fe-08d8f6d8e737
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2021 19:44:32.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HCyN7bqNz0uRItPH02mtM3GIllNgxo142237/27ypHomrpLg2LqDkqfZUMS4i8neq8voBNlpb1qjgMoLp68Uag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5626
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Fix the following out-of-bounds warnings by enclosing
> some structure members into new structure objects upiu_req
> and upiu_rsp:
>=20
> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset =
[29,
> 48] from the object at 'treq' is out of the bounds of referenced subobjec=
t
> 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bou=
nds]
> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset =
[61,
> 80] from the object at 'treq' is out of the bounds of referenced subobjec=
t
> 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bou=
nds]
> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset
> [29, 48] from the object at 'treq' is out of the bounds of referenced sub=
object
> 'req_header' with type 'struct utp_upiu_header' at offset 16 [-Warray-bou=
nds]
> arch/m68k/include/asm/string.h:72:25: warning: '__builtin_memcpy' offset
> [61, 80] from the object at 'treq' is out of the bounds of referenced sub=
object
> 'rsp_header' with type 'struct utp_upiu_header' at offset 48 [-Warray-bou=
nds]
>=20
> Refactor the code by making it more structured.
>=20
> The problem is that the original code is trying to copy data into a
> bunch of struct members adjacent to each other in a single call to
> memcpy(). Now that a new struct _upiu_req_ enclosing all those adjacent
> members is introduced, memcpy() doesn't overrun the length of
> &treq.req_header, because the address of the new struct object
> _upiu_req_ is used as the destination, instead. The same problem
> is present when memcpy() overruns the length of the source
> &treq.rsp_header; in this case the address of the new struct
> object _upiu_rsp_ is used, instead.
>=20
> Also, this helps with the ongoing efforts to enable -Warray-bounds
> and avoid confusing the compiler.
>=20
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Build-tested-by: kernel test robot <lkp@intel.com>
> Link:
> https://lore.kernel.org/lkml/60640558.lsAxiK6otPwTo9rv%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++------------
>  drivers/scsi/ufs/ufshci.h | 22 +++++++++++++---------
>  2 files changed, 29 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7539a4ee9494..324eb641e66f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -336,11 +336,15 @@ static void ufshcd_add_tm_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>                 return;
>=20
>         if (str_t =3D=3D UFS_TM_SEND)
> -               trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_=
header,
> -                                 &descp->input_param1, UFS_TSF_TM_INPUT)=
;
> +               trace_ufshcd_upiu(dev_name(hba->dev), str_t,
> +                                 &descp->upiu_req.req_header,
> +                                 &descp->upiu_req.input_param1,
> +                                 UFS_TSF_TM_INPUT);
>         else
> -               trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_=
header,
> -                                 &descp->output_param1, UFS_TSF_TM_OUTPU=
T);
> +               trace_ufshcd_upiu(dev_name(hba->dev), str_t,
> +                                 &descp->upiu_rsp.rsp_header,
> +                                 &descp->upiu_rsp.output_param1,
> +                                 UFS_TSF_TM_OUTPUT);
>  }
>=20
>  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> @@ -6420,7 +6424,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> *hba,
>         spin_lock_irqsave(host->host_lock, flags);
>         task_tag =3D hba->nutrs + free_slot;
>=20
> -       treq->req_header.dword_0 |=3D cpu_to_be32(task_tag);
> +       treq->upiu_req.req_header.dword_0 |=3D cpu_to_be32(task_tag);
>=20
>         memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
>         ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
> @@ -6493,16 +6497,16 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba
> *hba, int lun_id, int task_id,
>         treq.header.dword_2 =3D cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
>=20
>         /* Configure task request UPIU */
> -       treq.req_header.dword_0 =3D cpu_to_be32(lun_id << 8) |
> +       treq.upiu_req.req_header.dword_0 =3D cpu_to_be32(lun_id << 8) |
>                                   cpu_to_be32(UPIU_TRANSACTION_TASK_REQ <=
< 24);
> -       treq.req_header.dword_1 =3D cpu_to_be32(tm_function << 16);
> +       treq.upiu_req.req_header.dword_1 =3D cpu_to_be32(tm_function << 1=
6);
>=20
>         /*
>          * The host shall provide the same value for LUN field in the bas=
ic
>          * header and for Input Parameter.
>          */
> -       treq.input_param1 =3D cpu_to_be32(lun_id);
> -       treq.input_param2 =3D cpu_to_be32(task_id);
> +       treq.upiu_req.input_param1 =3D cpu_to_be32(lun_id);
> +       treq.upiu_req.input_param2 =3D cpu_to_be32(task_id);
>=20
>         err =3D __ufshcd_issue_tm_cmd(hba, &treq, tm_function);
>         if (err =3D=3D -ETIMEDOUT)
> @@ -6513,7 +6517,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> int lun_id, int task_id,
>                 dev_err(hba->dev, "%s: failed, ocs =3D 0x%x\n",
>                                 __func__, ocs_value);
>         else if (tm_response)
> -               *tm_response =3D be32_to_cpu(treq.output_param1) &
> +               *tm_response =3D be32_to_cpu(treq.upiu_rsp.output_param1)=
 &
>                                 MASK_TM_SERVICE_RESP;
>         return err;
>  }
> @@ -6693,7 +6697,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> *hba,
>                 treq.header.dword_0 =3D cpu_to_le32(UTP_REQ_DESC_INT_CMD)=
;
>                 treq.header.dword_2 =3D
> cpu_to_le32(OCS_INVALID_COMMAND_STATUS);
>=20
> -               memcpy(&treq.req_header, req_upiu, sizeof(*req_upiu));
> +               memcpy(&treq.upiu_req, req_upiu, sizeof(*req_upiu));
>=20
>                 err =3D __ufshcd_issue_tm_cmd(hba, &treq, tm_f);
>                 if (err =3D=3D -ETIMEDOUT)
> @@ -6706,7 +6710,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> *hba,
>                         break;
>                 }
>=20
> -               memcpy(rsp_upiu, &treq.rsp_header, sizeof(*rsp_upiu));
> +               memcpy(rsp_upiu, &treq.upiu_rsp, sizeof(*rsp_upiu));
>=20
>                 break;
>         default:
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 6795e1f0e8f8..235236859285 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -482,17 +482,21 @@ struct utp_task_req_desc {
>         struct request_desc_header header;
>=20
>         /* DW 4-11 - Task request UPIU structure */
> -       struct utp_upiu_header  req_header;
> -       __be32                  input_param1;
> -       __be32                  input_param2;
> -       __be32                  input_param3;
> -       __be32                  __reserved1[2];
> +       struct {
> +               struct utp_upiu_header  req_header;
> +               __be32                  input_param1;
> +               __be32                  input_param2;
> +               __be32                  input_param3;
> +               __be32                  __reserved1[2];
> +       } upiu_req;
>=20
>         /* DW 12-19 - Task Management Response UPIU structure */
> -       struct utp_upiu_header  rsp_header;
> -       __be32                  output_param1;
> -       __be32                  output_param2;
> -       __be32                  __reserved2[3];
> +       struct {
> +               struct utp_upiu_header  rsp_header;
> +               __be32                  output_param1;
> +               __be32                  output_param2;
> +               __be32                  __reserved2[3];
> +       } upiu_rsp;
>  };
>=20
>  #endif /* End of Header */
> --
> 2.27.0

