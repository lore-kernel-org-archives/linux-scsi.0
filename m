Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424CCC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24791610E9
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbhIQVdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:33:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23417 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhIQVdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 17:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631914302; x=1663450302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yqqg0/b4aVBCzu5FlDnNjP67f/eh2WFiUzWCH2N8AeA=;
  b=a/yPQoZvYjRzJ28d+/SYlUEEcVUvNtdXw8eozooHqO/h3JQys8Q12yxl
   dSWy86jOd0tXeD8/+L/oHhcpI0+aXOL7SsuV88sZzrcyXQpsY8MEUrWsm
   41IoUjeulm4pFf8PxkiicymanC//5+NnEy9iDYwWn2T3bcQPry+ia02sF
   slRDaucuQT9tvfRtfz8PxXvDR70vguPonU+S5qshMvw/FDAbgs4/mdLhz
   /9m1uSpSfFfIv0l6CE16alFqXRe7qGgAH8DOIPG8Whrc1GVOakJEFGciv
   mR26Sv2fPa2AkEmJEpTQbIvybiuyVwue95NL71W38NW5ir/eAsjj8sakt
   w==;
X-IronPort-AV: E=Sophos;i="5.85,302,1624291200"; 
   d="scan'208";a="180307432"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2021 05:31:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIujTLPy/z0PbzEKB0PnZQLhvR2/YqXVca44qpH/YjwUD3Na6ul1gnU+P+yv1dSTXfR/vfpvpECTxi/KsHLQORKTuUyEHCeXiWuX/EtTSfK4ko/QYx5t9jumpdmw5b21Fhu7fIAcmfzZ+f3FbsHpuAXdQQY8F5kgO2MdpAsFqd/ztUD7x9e2aSCV9ZoS/va9vuATzP+SsVzhrCjlkXr3YCKGift0bj/NMMY+UevxttN3bgqt6pjXM3TyjhIge4cQujMmcDpZMvaA1VHhmQJNABnbmnO7+8loRl9E4BzOguwelnsnHbXjG8fj65oAYT0o6jzBYk4eBgw6dfcPKCpf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WH7ngHo10DKL8F4cDGvL1u15EwkJ4PBPfn1ubraUCQg=;
 b=JE4U5/hZxtvTq2klO0S1puzmzv2SrspzDN2wLQaf6jfLES2N+qdbc89iXYeH/+d+iUAc8nGMMYWqq5K+3f3uSaBJSIEWJi+Jsq6dZuuwVSLo7u8WTcQ9SaUmAe40zNJXM8BBXA1WbYaqKtc7bl2PWg747g+IsWQEYdDFB814b7iG4og5eJqca5YgGF0Uv9Q7AAC6CTj7Kl+3TC+X/qE8Sod5EA6t0PlR6yEBvzP/t5b/QhKBWtGBOs5MwlevNJd/x1yEfArhZaHmgkTddBL8ieUSflrsLykk1i7QwbVTt3ZDdxss6vkTG262KWV3oJVQKAS+m5BQWRM0NqaWnlUZDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WH7ngHo10DKL8F4cDGvL1u15EwkJ4PBPfn1ubraUCQg=;
 b=PawY9bijABjbYPwaJCRUqGfac8hMK3Os7CbYAh2hCxZjqClaC7mC4XwHMNCy0yJNXSedf/j6Q/CMSDCEloQytYJ2XGBuY7ObEMcY9ouED+2Vad0vEOo8QZbBDPpdja2qE5K835UuXzhxGCsNoA+SImhGqwFQyKqcu0MD/NbAcYc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Fri, 17 Sep 2021 21:31:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 21:31:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: RE: [PATCH v2] scsi: ufs: Unbreak the reset handler
Thread-Topic: [PATCH v2] scsi: ufs: Unbreak the reset handler
Thread-Index: AQHXqyQyF9fK+OGJ6kSjEiY7uZWPSauovSvA
Date:   Fri, 17 Sep 2021 21:31:41 +0000
Message-ID: <DM6PR04MB6575C763ED538A0B2761A7D1FCDD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210916175408.2260084-1-bvanassche@acm.org>
In-Reply-To: <20210916175408.2260084-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc7b3e6a-7da7-48d2-70c8-08d97a228a14
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-microsoft-antispam-prvs: <DM5PR04MB0266EA2C4F613E7CAC1A3D34FCDD9@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bzRge4254asjjwbZ4KM8Itv86ZMUUv1GBYUEKk/PPU6axLSDQ3SriDDmx9E2x5SbE5Cna1KrQkgYAA0jiLD0yJjnSnZfW/r4eeJbpz7QLDSUFniZfWC/6azh4dcZt50z1Ng5Ay3DgeFraHu6zsRhM5gw9squDmExf0Zg+eFMteeftv80BgjwPob4ZjkRtNWFmHsTfygulccei++1aNiA5R6/Zj6sQwODDA5ZEATfR9b8GraL3GEe3319jXwi+MGw+gclT+2xeAhcCqd5278ZWYO9GW67xPh7fGtUn5vVAGgFV3J4FD07HGlLALL4ICftXK0TSrlegmh2+/lybs4GtDS8eY3oVjqyT22Th3vwMUBLlVh48wkcaI4ND1UbJzAYNKxZfngUGE/4eKKVbFnsFZ4uxFNp8lHC3ZltsPdZ1VOZmBXCebhIDmyEc22HN4gsTkP7DRvTq/Hz/oGib44KnXljgRARTrdlfLc8OOzHXWSezt5vX3zhB9zaCg9Ep5MSOd3XYOyF25PufZP9yzSMbX9gVTV1SQfPtFd8K1HY/pGhVG3iIST1Oe0SCCjUkaME7zf5Bk2u2Mb5hC7kbwq2MkiZWHnP2lbdG5i6IHLE/YGbU92ob6+Av0VA7oxuiqyTZu7pGq/8LtEDIQNS0E/Kj/hP0+c0MLF12HZow5NT/jiV2Hg54G8rZgODBEodKhzIsizXHJIbhVWHEhHPFZ3N3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(5660300002)(83380400001)(7416002)(186003)(6506007)(26005)(86362001)(478600001)(4326008)(52536014)(64756008)(66476007)(8936002)(7696005)(38070700005)(66946007)(316002)(55016002)(9686003)(66556008)(71200400001)(2906002)(8676002)(54906003)(33656002)(76116006)(66446008)(38100700002)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rG0gws0K/y/GmDSWa18JHVYJOsw3F0RFP4p3dGpTmw/djUHPb7O+xLYB59bC?=
 =?us-ascii?Q?eln1VKtQNCmjAlJ48T7sapi5/aWOiwSROqyLRhMypdmIqk0xFlGYt6hg2ib9?=
 =?us-ascii?Q?Z6cw37nn11FwwwpgynfT/nt4NjQ08k1mK0Bnasyavi/iF740zElpilaYIv8r?=
 =?us-ascii?Q?89HMSZv+r81i+DVDEqWP5pzID3bp5pFuMk9QCTr12m4WTFRviYghMKiGXk0E?=
 =?us-ascii?Q?aoJlWxilHI5boXTSMWukM8CO6PDkr0wNvYesciW7cbyjw7kkrRiTkAarPwYN?=
 =?us-ascii?Q?H9xhUq/0vdeuM/A+hHFVtN5GsYe1D4O4OaeZ4AJ/b6OQWxd6Q9rFKRfeFC1S?=
 =?us-ascii?Q?2simaiDj5cTyETJTumG0+qNE5NCJFIowlM8ywnvNcg/gUm2mi/bhEws48yYc?=
 =?us-ascii?Q?R5EbVa705pKSMao3nwYkrhNFGUrDL9LbrGYDg5dnEqvBw6Ae5aPkh4S8EzEN?=
 =?us-ascii?Q?wiLB2gwn0g+cUa8IoA3gBhkYwPcZrCGdp8AA1UmhJAEwRWYIBa+6/39js82n?=
 =?us-ascii?Q?7ArbJINxMnXmFko9+eZEHJdFnzrGenOne663gOxSBUvEdZKdcGENYURe0KO0?=
 =?us-ascii?Q?JeOtWpqaSGlQ8SRHf0pjsiNYY1nkhD0SCo04w4jAXfS9oLQWVNLKCsoIz4Ii?=
 =?us-ascii?Q?gZnIiEJRpc41cQCRt3BYsiw8myGxlQCoWbkD6t5bEvbg0iyNHmIOtFiLMeNv?=
 =?us-ascii?Q?3hPXqqzje4ha0j+GHnH5qD8YSRb5TSCB7nlqacRmRUWkNYzAIxcB3h625ttC?=
 =?us-ascii?Q?0hPjTnkhHBSSSPhAw8MN1Y/4ynUzP/SAScGSvBoIjQdSan+3urQiKUEq6Lh9?=
 =?us-ascii?Q?kTZsG9+DyX32HGJHNCcoMZTDjj51nWlZMDkzkf3LWkkHq/U/4uDATlBwYKac?=
 =?us-ascii?Q?TyaMxLj4grKRrnYQD4PF7/hxGPOlnsyVCedfvBiIUs1OGrwM6flL9bQIna2k?=
 =?us-ascii?Q?8mniVvKgxzfSpSROnzKTPENwHQ5QVz/7c9ArKIaQ1+J/xf/QXoeaLuqfuavT?=
 =?us-ascii?Q?Ko1lWd0anCvyk10sdrBspp0DvvJfoSfb/QM7TqCoVFO2FSgNnrouibu+4Kup?=
 =?us-ascii?Q?gP2WWrmxdvwjaMC1/XNHuNhEIV2OhqNJ+iSnxSugPlPbdp4iYvSuOLrI4dCX?=
 =?us-ascii?Q?9wB5mcKKq5V2G50j4KXWxBmHDkRBa5g1apUX7yvA/G4VFqRMgE6X+rKF+mjI?=
 =?us-ascii?Q?/LRxa6Yrhl4N9WrpiS7zu3dWenmabj3xHoIW8cmBS9TZmTQKW+enNeOWzY07?=
 =?us-ascii?Q?EBIGxvcjKgb67yQuSEZs1/oDCti19wy+Io7XFnR4UkcZnxkJ8h+d3GrKoiLk?=
 =?us-ascii?Q?72On4WMs9KATEHmy3iKu7Yc9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7b3e6a-7da7-48d2-70c8-08d97a228a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 21:31:41.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6IimuBAcD0Lie2RjTGvzN51Ek8qKoT0hHXZFPjaACbBnJYRjMXJGBpOLrBLS4G5iqd9NMmkew8yo5FQOsaBnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> A command tag is passed as the second argument of the
> __ufshcd_transfer_req_compl() call in ufshcd_eh_device_reset_handler()
> instead of a bitmask. Fix this by passing a bitmask as argument instead o=
f a
> command tag.
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests
> send/compl paths")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Few nits below.
Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Changes compared to v1: fixed patch description.
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 3841ab49f556..d1dc52c76847 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6876,7 +6876,7 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>                         err =3D ufshcd_clear_cmd(hba, pos);
>                         if (err)
>                                 break;
> -                       __ufshcd_transfer_req_compl(hba, pos,
> /*retry_requests=3D*/true);
> +                       __ufshcd_transfer_req_compl(hba, 1U << pos,
> + false);
1) Maybe a word in the commit log about changing retry_requests from true t=
o false.
2) Also while at it, maybe change u32 pos to u8 tag?
3) Add an unsigned long pending_reqs, add the tag inside the loop,
 And call __ufshcd_transfer_req_compl(hba, pending_reqs, false) one time ou=
tside the loop.

Thanks,
Avri

>                 }
>         }

