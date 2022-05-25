Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5BDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 15:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245271AbiEYPmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245261AbiEYPmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 11:42:06 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9782BB1E
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 08:41:54 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 25 May
 2022 18:41:53 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Wed, 25 May 2022 18:41:52 +0300
Received: from smtp.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Wed, 25 May 2022 18:41:52 +0300
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (104.47.18.105)
 by relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 25 May 2022 18:41:52 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S38CAC2UKMDJms6Q3xlO3SkXg9091ZpQLZEWxF8v9SMXg16CNVtq6vOjjWRb89SGTe47dN/TpdGQTT0797+debty4JaMkrwyHHtEF+dl//buRVypq+e9rTdEF9ywKj1h3lob5Pl8LsDl+eQG/+F45FvBiUilWrLLZrikniwVlJIeojJZJLmxEo/855ykItaJ+4OXq4gYkD0vDSN7FSmpi9T+KE4ii+NQeY16TchtqJCEAEhZPArBrUgcnmF0mjCJ/L+Jt15xDGT1bg20u9Syxo9eeBuJjruXGKUfzQv9Bw9jCe13Z7WznRFk1WTGARGS9YC07RUIh3XKuoYR+xQ0EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoduzJ2sSzQMvxUycux/Ru1WwHl9ghO6Oo46EjQS6PE=;
 b=bYvHQ/tqA5iv8kbeUlDqQnXeKABnBviH3i+Oiki9C8qCkeQF+SZC/coQSu2miCJFabUmDSUDqlGShgLiJsVVBS7q75qiGJAPFlAfqLsL9sEvSroIyAzVNX3lDnYiAgMLH29YfKCMiEN2wzdV94kqOZCal0swgReyRvJxtXdhLLcow+UVYje1HjsM0DxzfBTCkODAUOmLgzv+MRii3jKM4Dvo6VQqPOW43XfobJtJuwYQhbwOlCFaS5a8hoBJkmxyElpJZOZl91RLifs3ogOZNGDNeLpqOsG+F4ORa0zKkCTcHlxfEJ93T2qZq8HVoouCuVtgvEAxlVDfWdTSHRVRbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoduzJ2sSzQMvxUycux/Ru1WwHl9ghO6Oo46EjQS6PE=;
 b=RceYV6RphYbMVmriPPTmld9uVcXeHOCht2ZcVOjp9LZfAmmTCPLBXzuRRELBc1ICHIjLm/15Cidl7NtQmLeRMZrfwA1Ni43c9V6n3+/YQI+N+PG2jGhOe7rnP4twbIgft0cfF+O6sgxIPlwIKoB0HFlH3v8BD/wNebA4ofBLSz8=
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::5)
 by AS8PR10MB4808.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:333::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 25 May
 2022 15:41:51 +0000
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29]) by AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29%8]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 15:41:51 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5x60uVaWAgAFZBkKAAAkogIAABpRU
Date:   Wed, 25 May 2022 15:41:51 +0000
Message-ID: <AM9PR10MB41181FDAF10299549765FB1C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
 <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
 <AM9PR10MB411874ABB2FF82B263EDD89C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
 <06B14F66-F736-4A12-9D47-6AA4A8920DDA@oracle.com>
In-Reply-To: <06B14F66-F736-4A12-9D47-6AA4A8920DDA@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: df7a7c03-9ea4-e512-c61f-6e60ef6181aa
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5181561-8dee-4ad0-9239-08da3e65162d
x-ms-traffictypediagnostic: AS8PR10MB4808:EE_
x-microsoft-antispam-prvs: <AS8PR10MB48080AD8314D092C53E49F069DD69@AS8PR10MB4808.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yKaUfHyr/G8OxwuW8WTZWfw7P3ZvCh5O/Mae3VlB6rBOestVRze6WtXWl+Qth9iHEeqa/hKiYw8po3F/alOqfIk1eAaW15xSMV8GSdh/W5Cm90WVSgF/8KnU+Vxi+wK1wigLGyFdlVNZyDNab6QA8Zgr2zzDjINBo+a1eOvjoZvV1VvC5PhprBAM0mEQBa1m7wOXB4fgoJvj+P44OgjNgrEdiaQ6RQl4TskQRfdM4mxEB/RL6hVwjdN5fBPe4YREY5borTDbdFhetds+A44jOY7KFCGOwV168vSLW0iWmaSa/K0W4koqRfBuQ8iIIFQD8LrR60bKChmvQL7KdWpJoa24kRQq3ui5oqX/2sALlMutaqY5QMIltfa0brfQv2ULTP223jTpgzq5uFtir1prUsafKzuLcK0wdMDIXaFRzUjhAmIFmlvEgUljMzExF1O2hbuzZqyinUHFHbkdYVN/SYJFOQ5FVuulI2TtGZjhK+8KKJX7IUb/DaZFRPDHeW+6CsZcgLUBPu6rEAUM70BDe2sCL+TAKm1kordd/6ykLfcOihJqyZKQDH7z8njSb7GLYixHBPTtkRth4JmKCrG8j+gJeNUikVeMsszRyx+TuG28k1smgmPpZS12xFseV1oBD2DRvOEJfZ7VcoI6tWpNw7kQrmdajYTncCe4ruZR1ti7b3A7xiIY089I9CGCkglGybblSve5KKLl5KEWm2m27A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(64756008)(66446008)(6506007)(55016003)(66946007)(26005)(9686003)(52536014)(186003)(83380400001)(7696005)(5660300002)(8936002)(508600001)(38100700002)(71200400001)(38070700005)(2906002)(122000001)(4326008)(6916009)(76116006)(316002)(8676002)(91956017)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?d2ehmxoLkBYXywOZ3diaH7yogDY4dtCGSFG8BitAX6WsCG9noLS8aq1PcK?=
 =?iso-8859-1?Q?k3knbn77MakSROnevAXbjXhjjpthhqAqQ9wxKR0ibcPmCyVmqmqlBvWK3a?=
 =?iso-8859-1?Q?h8jGGn/YmifgM+n7ivONrU9bMJ553+gLdk0Hx9aJmoK/1LuzS5rCAlB9is?=
 =?iso-8859-1?Q?gesE44YihATfHeLu9gEtMm93/cTJ9LJNLK8RD87+nK0ix+0pBOgD7OPOBN?=
 =?iso-8859-1?Q?vgcy0Auv7Jc/wQDtTfo4PHsqJEUpZs/MrxaPH2GEggbhK0nEUEGIz+37yX?=
 =?iso-8859-1?Q?pii8XmWHtWrhZygb+fkS1WN6ZXPrHFX12m1Jzn55ZkzWCtRLyohjI4Ms/Q?=
 =?iso-8859-1?Q?36pmI5a7lAzbJHa8XsIFIq8snk9p4TYo+sB3YAIO51rcUlTznDIZDqpCx8?=
 =?iso-8859-1?Q?lc8EIPLkYagTw59pf0P12f65ZLKSn4ADdhgrnuH2cisWBrjis8icYucjaG?=
 =?iso-8859-1?Q?mgq6ZyPCqLaQR04V+LeuKNPuUe5uAQjvEj6kpQwn2Td6NmkcBEA1pVVkCx?=
 =?iso-8859-1?Q?ZzW6BdqrOHQzzau2fBjzgcuU5MZTlL8xshwtNBT01Y8pzE1MuZ4czYd4X7?=
 =?iso-8859-1?Q?APf+y68jigvjBuEap7R+2hOLnDFmRXLs/R0BJ7xOw44G/GFt8AzDrg8MgX?=
 =?iso-8859-1?Q?zH5h6EOPqfxEepJpMoaccLmNISuL1HSOb7lnnBtm6iC/Elr7KQbCKAt4fb?=
 =?iso-8859-1?Q?3/l0GPs+1njlAbYYAQvIsjtOClaRuh1VPkaAMOBGKbCa89XRKN+skpGlry?=
 =?iso-8859-1?Q?xh+h6NuCIvPj98PHugGu24hBK/hTSE9QTFDIdKk/hYoAP7JEa/7uBQIGuz?=
 =?iso-8859-1?Q?u3c90fIwEkk2RvX3+eJ6OJQ6mvHEy7X0oHWqikRnLk5C0Vs6DY+Q3qKVCz?=
 =?iso-8859-1?Q?pkcS5edMJF4OIXtpQKgyT2uRAyF1rdMCYA4WIpQeKyVVJgRTzcFmCo5U96?=
 =?iso-8859-1?Q?1lwm2/LOK0HojtIvAv8Rtcr+WJcDp92w6wPAFaBEljVyC8leOvcPoZ1LVK?=
 =?iso-8859-1?Q?Co+ytePQeawGm/ccEzntXjfE/vF1Ko+sMagv4LYL0sZr1G/a8v72Nn2WZX?=
 =?iso-8859-1?Q?wL2n8FphOTYl+vJ1IESWmyFIrMiXiQK0vjyCLXj5X9hMgPXHG7TUahimq2?=
 =?iso-8859-1?Q?hZlbF6vKoJ7tnOt9+97viTMcu4eB4Ydyyi7BzqEMnPXmjL2YZR9gyZgdYM?=
 =?iso-8859-1?Q?S9OtKCygF1tNaejANlcvdjG1WJvWKbQdP+H2HiboQoGMHy7Bn9ObGLZ7Jk?=
 =?iso-8859-1?Q?AYFKuoibrv2EA6zZ+2pFjly0Pr02/g78gxhnD0MgVnCkzLeng0ocwpY/xI?=
 =?iso-8859-1?Q?zpDUC6apTXPu8MpkAz+WKNnCKD/gmLBCtEXNJzEhRwaDGYMLnLC3cNnCrf?=
 =?iso-8859-1?Q?wQvYygPelpsl3wk2GAxk53yyFrzCiPPlz5dvfvs6bLyAdf9cPwGBzziz0T?=
 =?iso-8859-1?Q?TCMrOn2E42hfjCQ1M/y+jGRQ/+IWoUUlMW9//I1NYz57fjRaufxUFUP3vY?=
 =?iso-8859-1?Q?0MQxDMIHEnNdC5hk4trmhX+O5ohEqnnP3PpREv9IFY7DXK9gJNYIRpxFoL?=
 =?iso-8859-1?Q?9Jh6AFXQlzbknMb0w5TgG5ZlncznhYyLQ6K5+giYqf7z6zgzLV0SO3R+3Y?=
 =?iso-8859-1?Q?vaCMPgMLofXJADxDu0IrecquzKeS/M9IIFbb43VnCTE8u+vcmK926fTDsl?=
 =?iso-8859-1?Q?svgT1ypuLrup9iO140lGAzgO28rf3heYZYJDmab2cJ34r27yQ6vBaUKPmL?=
 =?iso-8859-1?Q?Nz1EtJaE+3Ju8w+bA7rAdjEMUPu56drFCVTLhY7nQSDfGNfaCcmlMPi5dt?=
 =?iso-8859-1?Q?1ZZ7E5Uesg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d5181561-8dee-4ad0-9239-08da3e65162d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 15:41:51.0738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hCQouE8g3j9boONCZy0Gqw7ncGXzr5d+kjy1nDjKmfqkyyLYvRwKQlSQX6+iG81nuEvu4/J8wnyLXVudOsPfPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB4808
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ql_dm_tgt_ex_pct parameter was introduced in commit ead038556f64=0A=
("qla2xxx: Add Dual mode support in the driver"). Then the use of this para=
meter=0A=
was dropped in commit 99e1b683c4be ("scsi: qla2xxx: Add ql2xiniexchg parame=
ter").=0A=
=0A=
Thus, remove ql_dm_tgt_ex_pct since it is no longer used.=0A=
=0A=
Signed-off-by: Gleb Chesnokov <Chesnokov.G@raidix.com>=0A=
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>=0A=
---=0A=
 drivers/scsi/qla2xxx/qla_target.c | 7 -------=0A=
 1 file changed, 7 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_t=
arget.c=0A=
index 6dfcfd8e7337..d03b9223b75e 100644=0A=
--- a/drivers/scsi/qla2xxx/qla_target.c=0A=
+++ b/drivers/scsi/qla2xxx/qla_target.c=0A=
@@ -48,13 +48,6 @@ MODULE_PARM_DESC(qlini_mode,=0A=
 	"when ready "=0A=
 	"\"enabled\" (default) - initiator mode will always stay enabled.");=0A=
 =0A=
-static int ql_dm_tgt_ex_pct =3D 0;=0A=
-module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);=0A=
-MODULE_PARM_DESC(ql_dm_tgt_ex_pct,=0A=
-	"For Dual Mode (qlini_mode=3Ddual), this parameter determines "=0A=
-	"the percentage of exchanges/cmds FW will allocate resources "=0A=
-	"for Target mode.");=0A=
-=0A=
 int ql2xuctrlirq =3D 1;=0A=
 module_param(ql2xuctrlirq, int, 0644);=0A=
 MODULE_PARM_DESC(ql2xuctrlirq,=0A=
-- =0A=
2.36.1=
