Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1C3C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A9220738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=netapp.onmicrosoft.com header.i=@netapp.onmicrosoft.com header.b="B9tSpLT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGGRH0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 13:07:26 -0400
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:48097
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727791AbgGGRHZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 13:07:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYp0W/pysddM3ycwy4RQ1s1AtJJT1VZJX7S+qgzpYlSYjPvdoYJL/h7HsLohh0t5hl8tSYbDzU7BaCTSnsb9GOtueDIygScW7QweF019lQuu0oO2cNBfSH8DY+Spi4lpH2UDV3SjcY0M1frt5R0THEla9KQkcPJ9fURe40Pm1O6kJCdYqA+vrk0IKIQB5F6qnWz6TrlpSTbLHF0YzPz8i2eJT/UNCTLuVL4JGVpDzG4f6cQzWinYExsEANmctTmSbZVLJXWUC6ezyXaBwF+rbxEd/OwTxADIC8kMp2EXYlaVFuf7tf2Cu/IXXgPdhNdyv9Iad26XxOibtWr3AHNHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8JAaE0N007DJ9a/A6LQbGmMkpSqu1r2wyyNZQBUEHE=;
 b=gG5IpBIabXV0TM0pJnBPsn1YhcD1b0LdLczlQJbg3xjg1JUgvFWK4Ya29XeRuFaIxDWOyGrx72F79A7RYL3jMHf59eIHI8cERagctX76686MrUHJ1M6/d8j4DVCtAgrU3OGa3rOagLwSQxOR9GJqzZ5fO2EiVwmqtLnoWNvb5RC207w4gakc+23spVUrfJdZAYXJnyuO38096j4DVojiuz4hDrwK5VHe6nGVSARKLHn2ZX2PazbQJ1w4yK0YEb3q/0UnmUBxfQddI6o2PTPz3+UwpI4sYtpcF6RJGC/kTJyK47CAqdo7WrImyrAeArZycNrqVhIh2UTr7o3lI/iYeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=netapp.com; dmarc=pass action=none header.from=netapp.com;
 dkim=pass header.d=netapp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=netapp.onmicrosoft.com; s=selector1-netapp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8JAaE0N007DJ9a/A6LQbGmMkpSqu1r2wyyNZQBUEHE=;
 b=B9tSpLT6OFmfwUJaY3hVy5l010+fIqCbKIbHbDudRP+IVz8x03Ff7zRPx8VFdpBquMFu3T5fEUyWDYtImsiG0kv3jhmIW8E6guO50J+mJPrZhbbuhglGvo4SgmCyxRU+woXezXroS5KpyUyp6YjMCP9CVe/TLN5OaUkz3lwfy3g=
Received: from DM6PR06MB5276.namprd06.prod.outlook.com (2603:10b6:5:10e::20)
 by DM6PR06MB5420.namprd06.prod.outlook.com (2603:10b6:5:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Tue, 7 Jul
 2020 17:07:22 +0000
Received: from DM6PR06MB5276.namprd06.prod.outlook.com
 ([fe80::a431:1852:72a1:1a1a]) by DM6PR06MB5276.namprd06.prod.outlook.com
 ([fe80::a431:1852:72a1:1a1a%5]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 17:07:22 +0000
From:   "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: [PATCH] scsi: add new device to devinfo and dh lists
Thread-Topic: [PATCH] scsi: add new device to devinfo and dh lists
Thread-Index: AdZUfo/PQcrFxwhwSEGnQO8FqJt5bg==
Date:   Tue, 7 Jul 2020 17:07:22 +0000
Message-ID: <DM6PR06MB5276CCA765336BD312C4282E8C660@DM6PR06MB5276.namprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc3NjaHJlbW1c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy01MGUzZGE2ZS1jMDc0LTExZWEtYTk4Yi0xMDRh?=
 =?us-ascii?Q?N2RiMTY2Y2RcYW1lLXRlc3RcNTBlM2RhNmYtYzA3NC0xMWVhLWE5OGItMTA0?=
 =?us-ascii?Q?YTdkYjE2NmNkYm9keS50eHQiIHN6PSIxMzk1IiB0PSIxMzIzODYxNTI0MDcz?=
 =?us-ascii?Q?ODI3OTkiIGg9IlpHNnZBd2U4WkdtK0NYcGQ5YlQycVY0SHUxYz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUNRRUFB?=
 =?us-ascii?Q?QVBPMndUZ1ZUV0FiY2lhbVVVR28xanR5SnFaUlFhaldNR0FBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUMwQXdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBZU1mc2lBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BWXdCZkFHTUFkUUJ6QUhRQWJ3?=
 =?us-ascii?Q?QnRBRjhBWVFCdUFIa0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdVQWNnQnpBRzhBYmdB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFIQUFhQUJ2QUc0QVpRQnVBSFVBYlFCaUFHVUFjZ0FB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhB?=
 =?us-ascii?Q?Y3dCekFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBWlFCdEFHRUFhUUJzQUY4QVlRQmtBR1FBY2dCbEFITUFj?=
 =?us-ascii?Q?d0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwv?=
 =?us-ascii?Q?bWV0YT4=3D?=
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=netapp.com;
x-originating-ip: [98.187.40.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7de4d2f1-9d32-4536-b4e4-08d822983712
x-ms-traffictypediagnostic: DM6PR06MB5420:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR06MB54202B08468D789AFFFAABC38C660@DM6PR06MB5420.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jaO+vhBhGn22sBIftduQjSEvQYbIBjWZANrewbs7DlhT4lRzkqhFEkGbV/u7WKqUUdTWJ/ZReAsXos61ko2g19aIdj4lUyn8TuW+JHXd9J/tnKxrZm8cKbtfaglcDUubc8Ev1kaGK04DKRr6Ta76FouwQ8gwF6vEE1ACFOqfapi1ymY30UjuFVjqERqSkzGkxihvaqP805xvsUANeFFhmSwX5+coh5bWCRHiFUB1qRwynlqCwXiy3xh1WsXM/65rhHKeul4bIymDaqRdCzxCtcia5dBCdEX0VQvXcB7bfFSEKKTXWi2YZ/lE5BFSMk7D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR06MB5276.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(8936002)(7696005)(478600001)(186003)(107886003)(26005)(71200400001)(55016002)(9686003)(86362001)(6506007)(2906002)(5660300002)(8676002)(316002)(52536014)(110136005)(66446008)(4326008)(66476007)(66946007)(66556008)(64756008)(76116006)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4vk3hX9yVK2/NWMh1aTFAI50qyoV+TW2mGfdsFd9TwXVzWAMCqdmzkx912lo13J9sOm/EygoCmGySij/QE5tvvqSrpD1yIzPaOw4R6PpdskG5GMfaqQzjTS6Dbd/9f3BybeIo7Ixm8pqWy7cFlvfMVB6soQJND8EiTt2e6HMfHGnjQ8cvaImKYebjPwLKqUtoQsvbFpveo+j6lfN/AjuMaxr7wj63KNC3l6MBlwghG7OzuiSW+VVKH29/w4TycgsY9XugsKaN1zWGnXxrXdWmMrZUabvItt+w7SJnJos/nH4pk5fUV3Pph7JA+A6g+apUCCoKvG9Etx3JPkKUNcmvuTxF0nqq/HPA+8vMIOv5jw3JTQJeqRM9zHJck6gbnvFBqD7snTiorztOMGYTVMpdqegRMh5djNyewYxD2Mf4mOb28orvJxHeFWLFVa9SMG1YCGKtUDAlAQFDnbXd2LEBEATMxVgAVFd3dYkYiUt3LQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR06MB5276.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de4d2f1-9d32-4536-b4e4-08d822983712
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 17:07:22.5692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ej7ovidTlx/V9jInU/TvlJ+TuGrTpeO5ZWHrH2RoA0i6qsyWXHirtX3h56WF3k3PnZ7wI+xd/Yx4BzIEvTth6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5420
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Steve Schremmer <steve.schremmer@netapp.com>

Add FUJITSU ETERNUS_AHB

Signed-off-by: Steve Schremmer <steve.schremmer@netapp.com>

---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_dh.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index eed31021e788..ba84244c1b4f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -239,6 +239,7 @@ static struct {
 	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"FUJITSU", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SanDisk", "Cruzer Blade", NULL, BLIST_TRY_VPD_PAGES |
 		BLIST_INQUIRY_36},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 42f0550d6b11..6f41e4b5a2b8 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -63,6 +63,7 @@ static const struct scsi_dh_blist scsi_dh_blist[] =3D {
 	{"LSI", "INF-01-00",		"rdac", },
 	{"ENGENIO", "INF-01-00",	"rdac", },
 	{"LENOVO", "DE_Series",		"rdac", },
+	{"FUJITSU", "ETERNUS_AHB",	"rdac", },
 	{NULL, NULL,			NULL },
 };
=20
--=20
2.18.0



