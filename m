Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61241C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiDATtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiDATtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 15:49:17 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C8B1D2059
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 12:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648842446; x=1680378446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YHRoRSoGei/2Oda+BSlU4VFl8Dbw6eYBqdfrb0xO6qI=;
  b=TBRvvBpFcMaes2DOK0t3hL4DO4up2205Ya2SkQWe25ia03yucN4LtYjf
   7YMkyjc5OWZKOjcBAGkB7yMiL2knKIRP3BaChHRI6jiqq+pJixc5fi7FD
   6rwh8YP2CkuOQqzJAem4SACUGFf2LvkUlSKk6X0kmZ4Mock2SR9vHy/3/
   Aa2WjCDPlZcrEuA9vy3KWqT1K1Luiam+peGVr2KMAfXQxL/mPSN9pqlyH
   MR8GdTzIsnTBI+D+Shoa+mBisQ0OZjEUaJQUjIj4Lwh8qptPvATPW3+TV
   4NdJ3eT30an/8rXaArefC5iyv05dNeWVfuCRhttfnh0FCnCVAX9O397jw
   w==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="196872570"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 03:47:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixlvKNFwaX93ul1oaNDQEQiMo/y2XXehQe3SgksGbIFUOFVMBTszfZZTWUwdsENVGbwRtUcq60O0uMfMNRm79pbdU8MdMwhIMQ9hqPmptr9ZR4GSnup6YhZ3A7kwJvk28+mlu1K48PJUEkRlGtltCPJ66f2XgaYNUHxjFcOOJStgzWWmjM0vGAKl3u6H7Z++tWC9lzSVPL4Gt1N7OK9ydbp9TfzZGmjpCd6iHhTxc0MJwKgdJx2Log+Dtw/EmHlAt9pQNZOz9I1NfTGjOCSLZLpZluqTOvmxRZlG0I3wqwfPa/4AoNlD6c6+IkAnkL34E2i8jj54cM2hBjAbDwwaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHRoRSoGei/2Oda+BSlU4VFl8Dbw6eYBqdfrb0xO6qI=;
 b=WyR7szGv4mgioaNDTw6UbsgHaN8tWMAM1wL+jHPDAzmPC+gpTvD3ItMDiYDQu17LyPNm7Oovmx/EVVYoi7x9YM22qclhFnKJRFlRi5Yadv8KZDglSQz6xFxO2dd+fxdM6hBk+KTnmsJybmmco7sx2qEMYTt2+yDEZ2iOCE6ubxnNrhcBDCnom2QFfqq4nR5qyCHaCgFxTMPAcspAGaAH7RvJUzuMX9liGIb6UPUWDwGXQVQZ6z6IKCLBix3TDTlfCsfkETeIvtn95BE1XegCVgh2sceqeGAztmtNntrAE3qqnJDRy+shtdVZApm4A4mgDv6LhVyJSzKaAB6vQnscgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHRoRSoGei/2Oda+BSlU4VFl8Dbw6eYBqdfrb0xO6qI=;
 b=RZa4UhqqD56PjXY8T0S9ze83IT9vOWqJqi4MK2ty2RGHSXhCAKY6BaLwdwt9KafM1wNkXCIiL455rbmxuEFRIa7dgkIOLQcrVWEuuRBYpWEtDvZY2CyF1GiNEYVZtcB8heXjaEg7gmOeNnmyYciJJzg97c5eVxJLTKTBj5YUeHc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MWHPR04MB0414.namprd04.prod.outlook.com (2603:10b6:300:72::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.20; Fri, 1 Apr 2022 19:47:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 19:47:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 08/29] scsi: ufs: Rename struct ufs_dev_fix into
 ufs_dev_quirk
Thread-Topic: [PATCH 08/29] scsi: ufs: Rename struct ufs_dev_fix into
 ufs_dev_quirk
Thread-Index: AQHYRU+0lqr5rm15A0C0vCBj4+K86qzbdwHg
Date:   Fri, 1 Apr 2022 19:47:23 +0000
Message-ID: <DM6PR04MB65754BB97F7C77FA41EEC8A8FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-9-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88109385-8a0e-4389-e459-08da14187130
x-ms-traffictypediagnostic: MWHPR04MB0414:EE_
x-microsoft-antispam-prvs: <MWHPR04MB0414AB952CD65A1653C95596FCE09@MWHPR04MB0414.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GeMc2Tocfsnrf1AE2NnmKhqa66/FBdQ5bI+PU5DVYmZJNvgmwRkZOOmnn9zeb4mAGj7b+sVdIXZtvMixH33CgNPln+r1pmclj5Bzj8s5koGchB1QzGgdgj2QGzvHgJTLrCpBCC0gKrHIUqodSTCI2i9mgl67n04r13ODY6zCH4IdwqIdkfLpwHqfAzBwnSeGgiyaGJG+mEq0paxCj6qEIwCZxvmsiUedTDPe18hRva6syWC6CZYS4QxX+s4+NuwBc+wYMdclf7hJGaGymjZ2+rJjuXRmO6zNVyTqxp8weJAG7/4cd8uGEgYtzmbM1NJ6+eU6tgwxkZngXGXfEQ+Yew8YBBtk7iO2NDta4aMy0eMtmUTd7nUtSqsv/Ks0JGIZ/+QaPVMAnaKppZp/ay2XZlacNhdyaq5H0A2DHTA7h0/qxRaNIvRePQCcBtRB5/+u0QC5VheiRuwgQM5HHugAqYXpM79RDVurDpTsRGy89Fwx9azi2G1DH3A4CBwTr99vgdTkGaViIgVcurQFMhgB7OblXfm/joksBrZR+BJsLGjC9MCWIMQMS9BIJH05NCAzBLHL+WQeeMKvEfNkZTu2aoHe7Pp+KCXvkAjeuxaF7gIkEmrobBbpUx7t4JHcyTrNKGDal0XF9bwAOIrtRyetttXePWOp1ahrs0zjV/s5Jqh8cnQZVMMaQBpc6HXfymGTC9UdwEqxwBquTrkMvja5WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(26005)(71200400001)(2906002)(186003)(7696005)(508600001)(33656002)(558084003)(9686003)(6506007)(66946007)(76116006)(38070700005)(66476007)(66556008)(64756008)(66446008)(38100700002)(8936002)(8676002)(122000001)(7416002)(5660300002)(110136005)(52536014)(54906003)(4326008)(55016003)(82960400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HImCqqksLoP0RHA7eujngz3f0GYgG1jU86p6R5B8F+7PrbdqglxJiVMW/gG4?=
 =?us-ascii?Q?Lg3A2lay8mmvZqU67JK4lHxIfk+hUfS7niOkDvDsgnZUOkz4Ha0cJp85oB/b?=
 =?us-ascii?Q?qgyZs0gIeLJ5yQ9LSJhNMa2cOV9ScXOnXAN9CXR0t8YFaMPdVVh8yTzDI/rE?=
 =?us-ascii?Q?YlnAk5c3a8RPEhPxPz1CQPdBsAhCSg2j+NHCUnntEQZi9oUB3AfVtOgM6Hef?=
 =?us-ascii?Q?HTx63QFxNrJtQKYq18ZHpdXmQR3gTTAWr6HZfbblMirL7TA8DkkqB9BY8dHD?=
 =?us-ascii?Q?e53yaC8OWDEA8Zk+EqQlclff7ai05copshgRap/fvHfPqDc5R5SVymeQDkX+?=
 =?us-ascii?Q?DEJvmdLDacFco3G7o2zO25ryvBoLQNxyL+1+p22rs/tgC+68q/XsV+i0xiYp?=
 =?us-ascii?Q?s+nUDhl/Jt2ptjumbk3nMWB79Wr/1TpYPPUene6WwyS7M/uIiAeJCJz6FKcd?=
 =?us-ascii?Q?E4UjQ674ys/d8tDQ0lSyRuVkuFBI7+IBa3ME2q2zgpgHDNjgRxCy2aLRrSMx?=
 =?us-ascii?Q?050eUe/oAl6DQLWx4pZlROqFrCjJFBB3slNM7b6mcyN7JGbPnweOqjrfT043?=
 =?us-ascii?Q?tbUjjm9qWhlQ9N37/Ir3jnSvqs1AXCUv4Lwc3+WEYKvrpp6tY9gPcw3RDtkc?=
 =?us-ascii?Q?AU19Z7ppQffpuSpjj4/Njmqknh8hBCujnXT7+WRYib2cHPyN7YM+YySqn4hB?=
 =?us-ascii?Q?CUV2VnQpYThBW16tDsOrd/kTTULEfS4KAFJKxoz+9+xfpns18ltEZjEnT5Lf?=
 =?us-ascii?Q?CbscczHvNwieS5WNOVotLEgJQTVbienx97EJ+iINbgyLcMwRsTq+njQ7ik0c?=
 =?us-ascii?Q?LaqwRkgqRe2DnXI4Dgbnzr8C1a4hJEy21eBDX6N60kQsqesfM6zldP6lW9cW?=
 =?us-ascii?Q?JOBts6Gvq/DNEeubpBNhoOiw2ImuYznAfGZQZcBVgXzlPNFfUFkr87F+IFHh?=
 =?us-ascii?Q?xUSWAUqqf8a6bFEnpIV8ZnIJVuiKgXdB7GN+xA8zhyPqTFxRhA2/Xoexq4xy?=
 =?us-ascii?Q?ynCCVjqDUJDfGvkF6GUabk2PCjTyxu66tB5PFLNWEb6dm/zB6frTaBqCq1up?=
 =?us-ascii?Q?FkZeHmIKinDxzhtR74p2Lhc42zJTGPndzSqUXJWwsHbiA2HOySBJo4ibJdBI?=
 =?us-ascii?Q?31aeftrF8i8dwqumscKBiVkYl8Y/qlHMojn8duallsZjIEzjmZbuWBuITmvY?=
 =?us-ascii?Q?YtW2r9duQj2cGLISB3hVzxvMzJEbvYcE2SAE3AAXXHMJAvfpMLp9QeKw4OE2?=
 =?us-ascii?Q?MrKW+fmRgbj56Hh263hVmO4ub8J7ZG3yxq5KJ+aSH4xDWk8uXdU7uF9/BmM8?=
 =?us-ascii?Q?1J5VyH1W14rwtu8fj0AIYERUTapopCCYa65UUv+42QG3u5DpLo9QlGN3iTW+?=
 =?us-ascii?Q?CGxBmk84O/xQXvPMBIPKbRMgBuVlXbEJ4xjzhn9aJpkDiybL1OQrpU/FJKTn?=
 =?us-ascii?Q?9NKOKDJIz1w/4PajXQWMLLSn4z8jl0pk6xLaaNME2LO4jPSnZ5RJ/MS6BpO0?=
 =?us-ascii?Q?/4vqeCV/PTKS2g/a7rrYn8bKvn5kItaIjCZB/7+Lc4RuKwPhf2LajYXj+dFd?=
 =?us-ascii?Q?NjKnUdvxeSeDN55w7BryJgwx9SaJLG9tkEVhGv5aYWyWiHouSwn1QyuEiCT0?=
 =?us-ascii?Q?k372yCzJ08SEcWkjJHTspb/py4vosyM32/I0QcjxrXdhtzoCmATTD/D+Pcf8?=
 =?us-ascii?Q?wTnpl3fyvulcyQd3ezWrJKWtss3q27DVo+9BmAa4b9vmbGLSHtSRwLPAlJHc?=
 =?us-ascii?Q?Pb8HaXivDA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88109385-8a0e-4389-e459-08da14187130
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 19:47:23.6365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MkA5yd5UwlIIsC2+EFcKmscaeMbBtXxjpEN+w5rX9U9iZDwQS+plSNcJsOELYN1Eg3xUYSvPdKCutvbwgyTh4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0414
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Since struct ufs_dev_fix contains quirk information, rename it into struc=
t
> ufs_dev_quirk.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Maybe squashed this one to 07/29?

Reviewed-by: Avri Altman <avri.altman@wdc.com>
