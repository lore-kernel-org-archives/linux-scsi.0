Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A9AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE61611C0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhKKIn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:43:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39031 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbhKKInZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 03:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636620036; x=1668156036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L+YDVTakTARpg7lnvp7CtMNE8X53a4h9yaZRgdudWsY=;
  b=TOQxTiG5MepR75EASkoUvtQUiC0H+zGQ+C54+pWmN3uoj4Z36vz7lpo2
   hhIqDT1EQdg31Nd4YRLWEs4Xn1O3u5mVAUd9DMzS6gJNSkCK1factrq1c
   z/mf9hv7bmpEynN6+GpK+xckycrkGA++lww73kO2ZiUKCxaKQ2dBogFdF
   ke5sIV5cTWO5cg8bG5Gr86HNgwTWRdLuffDT+9uPkjEHD1soSGhCNzwB7
   SFShPwrVE6f2wD8mT0y7/9VhcI40IdWWUWMiTjLI5KvvZ3PL0iITa5QZW
   74QfJM9sgHfcfZW9RJIYzvvQE3nfpTZ20ZjXA9tJjzKX5ZMWGti6/kPxr
   g==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="297136995"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 16:40:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6mvW5v8WgLucOey9uqPPYpOtovx0rcOdos73jqlhZGlsdLFsm5bUvIEpwwYtdQXMeHrH6B9duOMJ041CnYkWInRC7Q3tbeDnHo7LANi3R3rSu/qkZUnnvapqFNZMD/DPDjEts6Gj7ijjNNskM28bKOwSTZuRXtxC1R+ZuYysV9LgteioJqki6p/odejOpxDpUJjo3/C7ZAR6HKq4W/RTAro+WZk6kahu6vMiz3/EVErZRhsvWHU5pK/5XxBn1y9aas9N+Nso5qMnO3l4OyGaE6JKNHT6UU3Wl4f4bUlqMENxv3ggHYt4avJ8p1splbpo4tRF10yPT2I6zs7wLJo3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H56VYsgvs1J7CPdE0zZbxaVE68vrM0itTaVvkT6FXvg=;
 b=afVtSdFIjF/0zM3gTAVW1WtqcnAjvGibgmy63Lq9maLX9Y5yCnKHCV7GJStg1uSJDjDpS5EncLgJ7YonQFAGCifkTzQemZK3NK4qYdt8YMlG8hEN7I+1MqFjp0M9idXt9NiD0/xie67tpt3lSwuQ8htgaLPJX3ylZ4Br4FucabHik2E/OxG84gTSiLS/fwEu4VGicmHvyMqbONJeDer4NUZJ5WLVKAmfYf0jOM8eep08/xQq9JkCUs+93t1l7vKVI1mUlb6WtkEtwCzdjJXxA5PnzTtFnUWL3FE/pJMY7Y4X3Z8Dy5dl56IeKqW9KjwKmsb7LO/cl1ErRo6diMRZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H56VYsgvs1J7CPdE0zZbxaVE68vrM0itTaVvkT6FXvg=;
 b=wTdAMwlOnvJYxUKMpZj0+kytYU6CnCW/c2Ta9Cz92JlES0XbEMwK234Cx9eL9g3WaSi7QtJ8K2v6ypaCmotZOZhLkQ3d3VBAZsPXYv5I1IUfoWbewroLzdl0apllQfn+1GshawnHA9SIGnL1UXipStwhwrjnhL+2K9fS0iZairA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0732.namprd04.prod.outlook.com (2603:10b6:3:100::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 11 Nov 2021 08:40:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 08:40:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Fengnan Chang <changfengnan@vivo.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        tanghuan <tanghuan@vivo.com>
Subject: RE: [PATCH] scsi:ufs:add quirk to keep write booster on
Thread-Topic: [PATCH] scsi:ufs:add quirk to keep write booster on
Thread-Index: AQHX1rB4o050P1bkG0eqPjX3Z+JJ2av+AP4w
Date:   Thu, 11 Nov 2021 08:40:33 +0000
Message-ID: <DM6PR04MB6575E40B2196F37E66C4E522FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211111035844.395208-1-changfengnan@vivo.com>
In-Reply-To: <20211111035844.395208-1-changfengnan@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a094d89e-aab1-4e25-7189-08d9a4eeed49
x-ms-traffictypediagnostic: DM5PR04MB0732:
x-microsoft-antispam-prvs: <DM5PR04MB0732BD0A56BA7A510C2959BBFC949@DM5PR04MB0732.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7KM9jK0yhojbyaKxaG+xpFJk0RFS3LtU/ZdlMnFVGEuh8QpQkvY8TKUejzLeGOE+/KRIt+ufNF5qpzZLJes+tlnrORMu1JIZbmfciuiUqcOf6UlegcsFSEQd3vtPD6JljrJZUNP+pYghmCuzZKUixGzS9iFc72aSsyeXLsHCz/BQKV7YWL0iU+MaLIpIi4Mio/ZuUQOzfKEa91WxYCWVBZMxbVhll8tM9yZ9bdl8tPbR3DuOsMhmtLM5l+l2H2cZ1iYPLTkaOmayuwC03Z/imHXaRw2+Xh0huPBsl6y+PVhTgrdyV7bGhNm+bZaTdU7BaPGTmLexZdGyBDWzmUEzHl26ft9HrLiq98sSKtOcxG+tl/ugIUjOMam5qsRfippJEwWjVM6q59RaFv95d1T9nijVACHSld8WWadjssLCLE/psN4NCCFqgBsUcbsMaxGEZBHSHQERCi56zOhXtfIsim+SX5o3uToBWVyuCKEw0IpbQhJDpFHTrWyf9T550SXwlWelo4SE8IJHHe9zgUMuhqfRB8P6cgEvSJQGdqCHBfB5RpoTMu8WMkkz2pWYdwQ3AijIKzyXUNKd5K5BOU5/4kkg4pF8/wuoNAQhuLDRgHiqHndebSgCqOhzsi2Ed3tK5jbh3sccOXI0vOjbY6JYWnFTpS3p9anj5geiRS/3afwChz48XuFjLpD/zOwlI4MRTt4Zdl0drTucuEMUbX5y2iF3D28SRtJjZ6PAIh1pL80=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(508600001)(8936002)(66476007)(66556008)(8676002)(921005)(55016002)(76116006)(5660300002)(9686003)(54906003)(33656002)(66946007)(2906002)(7696005)(66446008)(122000001)(64756008)(38070700005)(186003)(7416002)(82960400001)(38100700002)(83380400001)(86362001)(26005)(6506007)(110136005)(316002)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J7SrR04qoGTmCweVVLko+8+in/43IEEA2pY4SNyHwQVYXCXpEM4Uor4Bgf6/?=
 =?us-ascii?Q?BiLv/hBBpbUg5Gnz9DnTpkxJ3Nhuk/UO7E7gfwaJTWmcQ3mmDX/efPzjFUpR?=
 =?us-ascii?Q?KUfWP4grfiyo1bdt48FT64TkMC9J7X+ClCbYTDHzux6Wwv6UfLWmSED5LSnV?=
 =?us-ascii?Q?I4yI8F42q3xHc1IxwadALbhj79ndN1uyMNMB8OUldNuTZE02UMIk5pIgxXFj?=
 =?us-ascii?Q?lHc2ZnSdE386/U9Va3LTx2XiLih8rgMJFV4CmMGyLM+9FhMb3AvMJsV6GbUN?=
 =?us-ascii?Q?p2HebMUJBxglwB1wTxGEw4sgzg3J28+SgjCInVMNZwHS1c1Y0i13Fy8Re+Ck?=
 =?us-ascii?Q?A03OGe0hAhBw6JPxePTdRWRdAOVzEoKreYyW3rsDchMQLRuaeuT6KR8r8c1y?=
 =?us-ascii?Q?XUsec6Oell2rE5oUZBUJWf+dmaU7crwyAbbCzihXqvfqQG3xJUr2Gmni9Mhr?=
 =?us-ascii?Q?oGz5fO9hWX5zZFqIVuljWLIu5YC2mMJYn2H7eQDqElacCpeqG2/VU6bZeL7a?=
 =?us-ascii?Q?ECWh4B+DjislcDCwJFpbpAzAWkOzQUtCkso/PVBEPDgLJxU+dDJqb6SDsxvu?=
 =?us-ascii?Q?oCXS0/mvfyxxYvf05Hb88sRv/YZcgSi4lAlvqz+7vpFrSvy/Q9O3FAuzjgLa?=
 =?us-ascii?Q?rtm0on/tmKsnB+FAg6Nt8cx24coQMCD4RpnR+unndU+2W6ihq9Q5yFlnVZgd?=
 =?us-ascii?Q?ZlhieLe8dSp60LL9XHuOLuoUabLUMFSzbUSNhC/NgwLMKyHubmUr28Op51lp?=
 =?us-ascii?Q?8vqjzGTPdkE5w66Z4B17I5aovx/Xgcl6dfvub0dhD2o+0H5E2hH0C01gkohy?=
 =?us-ascii?Q?3d5E6T/9/PjTIR1nxxMhwxjKmrMdvND83L0ydIeyXHFe76hV333Dfb2F+j4z?=
 =?us-ascii?Q?EkVJ2WrfZXUmpxsItjorDaeA+vC+6CAfq4ALG6t0KI59RBL3Pkxkb1IKS2tv?=
 =?us-ascii?Q?ZAK0dTUIrVr6YBSlUGwEP8qE44vcw+qlktq7ja5Y3TuuIWvBTTiRGopCqTyv?=
 =?us-ascii?Q?K8CrC383HSuYXNXAE662d6+s0SPz791LA3GrehgAvSyPqILjZSEv2IVuUXra?=
 =?us-ascii?Q?oo2dWE/h5w7xWfD4H284IOyVoUadiuWPNsN3JKu5xctdBtNlD5s+wWn2F1qI?=
 =?us-ascii?Q?TakhcLEmynuM4v49UaqKqxKAahzqBh/vyj2emumRR1S2FVIsuyJrxJsuEf6t?=
 =?us-ascii?Q?2Z033y1RMyeNCzwN448ifhNJKeZpCixWCFNRnu4QC0gLSsw+R+HbkWzE9HYV?=
 =?us-ascii?Q?ifS6QJF0sfbIfPcl5cX3gEBJqo0QxXnij5p6dwdgmOXo6rd++DKG74arc55F?=
 =?us-ascii?Q?VJx8V0ujADtIX3Kh2oC34xr5dPUlpIPct/mQ6cWlrEqmU6tAMeN1/3yL/OpM?=
 =?us-ascii?Q?MBinDkfqfloInwS9RLgX6qJJQi/gFiw1urEgVHEzCjLkWmRk2pz1Wr4D+tFv?=
 =?us-ascii?Q?73xh/o4jX505zECb1boh0uYqGwH7il6oBebq4EWLcCHxoew/HqNW+nfsEmAs?=
 =?us-ascii?Q?mNEBqAXltrq7hNC49e4qbX0IVLM0T80GUkbMunNhGvuuMbd5hBCj7jUJnukH?=
 =?us-ascii?Q?v3oKHVkUdvSrsZNAhbQbfE7oUYRM1BT0VyXyDZRGwLT2wQ3pvpM5CpTTI0rC?=
 =?us-ascii?Q?zA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a094d89e-aab1-4e25-7189-08d9a4eeed49
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:40:33.9203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V2gLctgDo6u29AdFe6jVuwY+xKo4hOrnY1S4wIsJnlFhSTOoIbBNnOoHLjCLqHSBHs3nw3w1OBFPLOAoYeefow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0732
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: tanghuan <tanghuan@vivo.com>
>=20
> Some samsung devices have performance issue when the
> remaining space is low, and the write booster needs
> to be always on.
>=20
> Therefore, add quirk option UFS_DEVICE_QUIRK_KEEP_ON_WB
>=20
> Signed-off-by: tanghuan <tanghuan@vivo.com>
a) Someone needs to use this quirk, e.g. you need to set the quirk in ufs-e=
xynos
b) I think that Samsung does not use clock-scaling
c) So maybe for Samsung, you need to use the quirk in ufshcd_wb_config(), p=
revent ufshcd_wb_toggle()

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
>  drivers/scsi/ufs/ufshcd.c     | 13 +++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.=
h
> index 35ec9ea79869..532719eb4f50 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -122,4 +122,10 @@ struct ufs_dev_fix {
>   */
>  #define UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ (1 << 12)
>=20
> +/*
> + * Some SAMSUNG UFS devices require keep on Write Booster for prevent
> + * performance drop. Enable this quirk to keep on Write Booster
> + */
> +#define UFS_DEVICE_QUIRK_KEEP_ON_WB        (1 << 13)
> +
>  #endif /* UFS_QUIRKS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dac8fbf221f7..acca346b43c4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1250,10 +1250,15 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, bool scale_up)
>                 }
>         }
>=20
> -       /* Enable Write Booster if we have scaled up else disable it */
> -       downgrade_write(&hba->clk_scaling_lock);
> -       is_writelock =3D false;
> -       ufshcd_wb_toggle(hba, scale_up);
> +       /*
> +        * if no need UFS_DEVICE_QUIRK_KEEP_ON_WB, Enable Write
> +        * Booster if we have scaled up else disable it
> +        */
> +       if (!(hba->dev_quirks & UFS_DEVICE_QUIRK_KEEP_ON_WB)) {
> +               downgrade_write(&hba->clk_scaling_lock);
> +               is_writelock =3D false;
> +               ufshcd_wb_ctrl(hba, scale_up);
> +       }
>=20
>  out_unprepare:
>         ufshcd_clock_scaling_unprepare(hba, is_writelock);
> --
> 2.32.0

