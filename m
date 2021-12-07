Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2A6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 00:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378896AbhLGA6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:58:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9487 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378869AbhLGA54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 19:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638838468; x=1670374468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GV3U6vnmhIGGgr4XnQVidOHNVIzezFSVHhNukGrY24U=;
  b=DXkxkVUlPLVMpKo+TYkuZDGvLMiz8gHHxrmIISa21BX7Z11RNFgUhOz4
   0NfI/dzVeqyngRN8gtGYeEs4ttyqw7MvTa5nOqgCPyMX5Kwqhq4lsLJGw
   oUGiRY6VmZBkUn03KJHCwSGKFFqH7tpVhlAgryODfndWv/+X/vIgUpkRD
   W87L1Z6pdVllWUIHsrn0IhV+olM0VtCgP6BheKGWUuNe7QiBGOLp52fWk
   Gx4n8J2Djws1bhoGKPqUF9muS+jU1uKmvIa++nVjpRVZG1iv/zrGCAbNW
   lGRN3pFR3kQnl43sycDe51E9fQ+kICP0ftL422dIn81DE3TSNpD2SefBr
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,292,1631548800"; 
   d="scan'208";a="188614420"
Received: from mail-sn1anam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2021 08:54:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdYJISCz8AgR8h5ouKRBJokdEHoyUVhWhv20fGYs7ar7o6a+KLCF+CLC1AG2WE5IAqz8zfOkZRBBh/IJK3SGbsN8XDifc11KP/Er919UsmvRZLT/LLpzlhXmDl1fG99QodF7xGRrA95CmlWANlEi/ouJnE7ZveNIQzdw8aE6pRHbreQniZNTq7JPfwx5aNoitkzBfQ/d8OgQ5Z0sbmubauxggHCS6kt3kt/EAyv3UcNscaFoHKtkFI8oNVALGlIzDXu/a+SnOUbr3Im/TyxOGHnAWNAC5eb/WNDsvXchS6Nhe+qxear5Qxr280prVIhD8YN4JEL/9S+dhQBaIwy3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hBrUt9sljWZ5Rpimv6dhGNFqYquVuRvOjFA3+1mvvE=;
 b=X5WS+WZS/Fwr5vGRvu5h5Dw0uuftjUXuhobWdNyl/gjeC2YC7enB3AvIdqro8ca4YT0mJgCrMcEDl+VEIvO1bX52si08jsEeeY1q6fhtW2GGGnf1tlZdmI5fhS1av71IVhdL9fOWZp9dVs3Jv0pYy55LcxFxiPatOda3zfJH//rd3M5RqZ6zQS1C8Rf82adfgWuiNBXhZNG83mfIhhpbs6sJzQI/PnYGab1xQYFy4BUxtx6Sg39MRW3HdS2RD4z0i8vwTRyJk0edRvy1sVlB9jzFyS7rdDQauUNQ2pBqRwdOQo5FanGDczH/P8xZIYIoSOCeQVhydlJelhzOsPox2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hBrUt9sljWZ5Rpimv6dhGNFqYquVuRvOjFA3+1mvvE=;
 b=GKP0unloypm3hGH9dHZGgmmArmDXv5NPzWVR/V5R6rACUsIz5jnmhdXzk8CGu0gqc7h9qlkprRWNQEI6EVzYn0rs/LKuazfS391/P8ji99Xt6bvu4VRmdfkMZGd6fdd0DCdUwU+x929rBazzgmaQDnTpKEQI5nE8sj7/LggCE+s=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB7990.namprd04.prod.outlook.com (2603:10b6:8:9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 00:54:25 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::28ae:301e:551e:a62e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::28ae:301e:551e:a62e%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 00:54:25 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Thread-Topic: [PATCH] scsi: scsi_debug: Fix buffer size of REPORT ZONES
 command
Thread-Index: AQHX6pzzSZ3OwluJ7kKBOQoGllzIcawldxwAgAC9ngA=
Date:   Tue, 7 Dec 2021 00:54:25 +0000
Message-ID: <20211207005424.pqnzp7qnkasfljs5@shindev>
References: <20211206122939.105942-1-shinichiro.kawasaki@wdc.com>
 <bba4768e-b96d-1f04-5de8-b87264342fdc@opensource.wdc.com>
In-Reply-To: <bba4768e-b96d-1f04-5de8-b87264342fdc@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91bb8f96-7f72-45eb-039e-08d9b91c1da0
x-ms-traffictypediagnostic: DM8PR04MB7990:EE_
x-microsoft-antispam-prvs: <DM8PR04MB79907CC6754710626FAFDC80ED6E9@DM8PR04MB7990.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OKzjLvEYgug1T67JH67hctJ+2+4JXwwRcevWfd8tZa1kTOCXlI9b1sDn5OPlYGOum5SF4tMc0d9QTPIWfD2c+YBYWcV298eGi+eWI96RLatdfcBCo6Lzq50/0NXpJBTe/CplFQcQkZYKNw5WNKGaPrRI4WJbZwxn2HFb4WAoZvh/RgoijTZ4ahthkvVKXLo9j2CT0pYS0gkKA2R0PGFaTjaay11XhC2INj6RZgcdjbT4CK5I6UN6P4ZwcowLhGEYrPLrcgWom7P+VgAkvgwAgDiPuUGeUIg4YhPmRbSQZMpKu91kkIk07br3mG2pwk6p+AV/7xaaKAWI7zDBNW3cHs5ZYpjM0TnxG6ntADkcsr5MP2xl4YUuEva47g5NaXXz6M4cFNmlqPZII92wafy+AW1YGj2mHK+GgVgb/Y605s1UckHB4JCFuzKhOLlZpsiatCJP3joqbJm7NwDGhm9hE9RqkLgDWSflDfbmEZXLQGI3qofoMl3ofQI/3G1UdIDJ7BEeQDDIqyr43ABc4jaLW/kHkvjkM9ssu6MGeVHNDlqcoxuTVxAgee0O/I8IpaWTrARPdL1toJoTy5yLaHh2s0af03sRLFsJYehYCMQUQhM3poscbp7imkSqDCgwyh0NXuDx3Y1TA4xxqBqk2jQ4ierH+YuUK4a/dtXQvUJ+UgBQIw1WEvyG165JrqKaCvMbBrtb1rSSWhXvq5zfNaJ67Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(71200400001)(8936002)(4326008)(316002)(6506007)(66946007)(76116006)(91956017)(53546011)(33716001)(9686003)(54906003)(6512007)(6862004)(26005)(66556008)(5660300002)(66476007)(64756008)(66446008)(8676002)(6486002)(82960400001)(83380400001)(38100700002)(122000001)(86362001)(44832011)(38070700005)(508600001)(1076003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/Chr1w9rQVJO+7ofzmIB291ZsLN0RPzVcv3kt//t6eFAWXaMzsVHLLuwWh7a?=
 =?us-ascii?Q?odCM8rtn1SYtfsBwUbLuYTgcyL0K/V8VSTnkAbbjidqEUHqXYT/O7+LGcUzO?=
 =?us-ascii?Q?mbwmsLXKXF6GnaEYU9kQSEcjJs8gMH1/wK3Jbzrk7Kc+XCX2pjfLl7UI3YXv?=
 =?us-ascii?Q?Y14Y1B+9v/7/GIp9GVI5rJ3enRAOP3sN17BUEXph7YIJX030YP6NNUk/MoID?=
 =?us-ascii?Q?hUz7KJqQxoOk8ssqYheElTB3ypFNr5NAr01H81FAZqp7TyF4rptHYLwfsKah?=
 =?us-ascii?Q?iQ9tQpzgyxjC8vLB4tsjY430IQiCNs14FGlI7mPNeMPiK7xj/xS88dIozD1l?=
 =?us-ascii?Q?f7MJwz5D7BIB0T4f/Ue2JBm5s2jPZmMWU7sAw5XHzEZ65+y3aqarz/jdrtVE?=
 =?us-ascii?Q?ISu/ZsAPddpV5zDyWSBfZgxPrR323ro4AtY/Mlewz1U1ScmnzPAnrI/bNJqS?=
 =?us-ascii?Q?HixHvlvT6uzumUF3Z/q5ogaS2IfPU4Uwcll4cEhbwVEegKPt18HLPZbcisIK?=
 =?us-ascii?Q?LGEc/ATe1h3wSIcJSV17IJNu6lCWR5W47V7McPhL7Lk131Qj035qc2bgR5SL?=
 =?us-ascii?Q?ARzC81Kh8ZFQ7nx1TS7odn9t4v8zPm7d07CEd6WeM3VXTaVx/ZNaWRZ1nXSy?=
 =?us-ascii?Q?Jm8/Gmh/1qI7bk61zCWlgivsiaFpn7vqCthDWDwzL8zHy2u6k4ZMIq2Ztr+5?=
 =?us-ascii?Q?5BVCkP6XqBl9vMV7CK1BI3C2Fwi4MAsI3vSJiWMfAv1c5oRHhq/YBufTWPac?=
 =?us-ascii?Q?o16vPkB+IDPP8ZQm6VBuOfpNWOWnESHL1chCaeLCLDq1V9KJ3MewTaUWMwBr?=
 =?us-ascii?Q?c+wejRQo6lnzZMPo7Zx5bGJ8cp51WFEREFiHzdsPS4KFUlStQDeTMWWJ6mA6?=
 =?us-ascii?Q?VfFvTIzE3AhcC6RoAVCH53aLciDhsEckKXzXvvILOIVYxL4gDQ7Keg9wIqa+?=
 =?us-ascii?Q?A9ZPFcXFpDQvyweju9SSAJ9G4xe2coAxYv7nMBhmFeiA2/uc/2coJeocUaLp?=
 =?us-ascii?Q?v9shgMMpbAO+boXuVLI6xjE4DnVbr0RF0v4eWlDc5u+1rajkm0N0blFYHnh2?=
 =?us-ascii?Q?9DSXwWVVoFJFFjqubRDolm8zMI2x16wFFoBNLst7Pw/R6AgGaD5X/YbAMTzf?=
 =?us-ascii?Q?WKcVoKZR1zUyiZfDx7+Ow3RvVvgTBGfgT/dvJ9VrHQhCvpgShUe/rdQkDKHK?=
 =?us-ascii?Q?NljFN4ucc2io442HeNL5fo7KamkW8OJr5wQAtdv+t3xWzGLX4Qia2jXBcTiw?=
 =?us-ascii?Q?gfurWGwLi9LUPAsDcpbMPNSbtb/a4OJQGnW2TCBXf/VEZvWHZBXTjWwIki7Y?=
 =?us-ascii?Q?FUcO37brtrlUIAau8ggul317y4qXn2+M8b9y4uCeUQVC35qOFaixn+qz8GBK?=
 =?us-ascii?Q?KY7TTzAwMQCIOUmq8gA+Wqx9SVChF5J0Du/8iubJvVBY9x+ipIMMedCdcYPA?=
 =?us-ascii?Q?/e58I72bvN5W1tU6WRc9UXX8qOA6uWmd14SejYp0jLO8y2Wa4KVCdxttu9uA?=
 =?us-ascii?Q?oBajF63VT5tC/7xe1E7c+QHW9ggE17ZAdo/E+P4o7ZsKWeHhYxW+/M6Ir614?=
 =?us-ascii?Q?CfocudKj8aHallmKqOztCucGzAaKvhFCC9SQi4BkMjWR/SKRk84qh4U3qTXQ?=
 =?us-ascii?Q?SdHCHkFcAsL2gF4HtHpra9miONkLCMNpJ2Lb3jECp7gL2XTEAjRvLbQZgoz4?=
 =?us-ascii?Q?1yaIjTaZrj+OSLje1PCLso9Qulk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B44FBAA821AE4B498233700B50858BCC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91bb8f96-7f72-45eb-039e-08d9b91c1da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 00:54:25.5739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DfI+4jiaUu/aLdMoVrBkDDukMKXEoVx+wp+eXhWtgoOzmlIofKvxd25FC1yiYCikeiGlJCW8b+8uyRu1gNaN2K+Zc7POMnFd7ms0A0EyA9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7990
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Dec 06, 2021 / 22:35, Damien Le Moal wrote:
> On 2021/12/06 21:29, Shin'ichiro Kawasaki wrote:
> > According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
> > field of REPORT ZONES command is byte. However, current scsi_debug
> > implementation handles it as number of zones to calculate buffer size t=
o
> > report zones. When the ALLOCATION LENGTH has a large number, this
> > results in too large buffer size and causes memory allocation failure.
> > Fix the failure by handling ALLOCATION LENGTH as byte unit.
> >=20
> > Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/scsi/scsi_debug.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 3c0da3770edf..74513129b36d 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -4342,7 +4342,7 @@ static int resp_report_zones(struct scsi_cmnd *sc=
p,
> >  	rep_max_zones =3D min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
> >  			    max_zones);
> > =20
> > -	arr =3D kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
> > +	arr =3D kcalloc(1, alloc_len, GFP_ATOMIC);
>=20
> Then maybe use kzalloc here ? No need for kcalloc...

Indeed. Will post v2.

--=20
Best Regards,
Shin'ichiro Kawasaki=
