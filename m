Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31E7CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E1D20862
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="US99okLT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OcxR+NEP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJ3LU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:20:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:35809 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 07:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572434435; x=1603970435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xv9DMySwZA1MAfJfpfUFobXLtgc0jZwg5aZ0AY/VmNw=;
  b=US99okLTS6POTh0jMzswoUkqh6sUb6noyzehA46zRYXQFzpXYyjZGiwz
   KOsTiHgUrkpGIOCzApP3RcpTTRtojjRSoKN+q2S0kDtLn33+lBSJt8BHm
   msLxgt2Dy1FXFQK0DrTwvxrxvdtVIyq/N9zlcR5B/WF4lesztvDeESZnj
   xo7DRRk2fB06iPYm7MCXgGm0y/T7i6uSu9agXB6tHfIJgngqT2ejl4WhM
   R1KeAdmOEFaFk6MAPaxNRdJebZTqVhsYM/uI9m3oQdNe8Yx8GURyDKlDO
   L06gp5DLPLLH+FJW+vOsk8/2VcKBhfMtu1+YjToMKafeGIu2GknWabeK7
   w==;
IronPort-SDR: p6zh324Y+BtiVQ/Os2Lxrhcojxd7HSZ7AaHOB+YZeOAduI9shD3LoJy7XrRYS+DqED33axLtC+
 Huhy3VpqF4Jk4YiKDJm8YZL7SYWGBHbsQUp45H/n7DQOaF6Ec6eul5TQUTuSEeMOYCYhlXJE00
 eT2eWRpmW7PzUeanUK5vpaghdTjZ4Urqy38VGf0GbnaDYiYPd64d+5A1syTBwJJV9uDrxgDYeZ
 sWxx1TF65oODschlAQg9+JND+RmPcfS/8222esWh/xIfXQajvPCTn6yk97hcPbfWzUzCDTxn/1
 KmM=
X-IronPort-AV: E=Sophos;i="5.68,247,1569254400"; 
   d="scan'208";a="222819153"
Received: from mail-bn3nam04lp2051.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.51])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2019 19:20:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feE7lEoceFlR4g8NupBasn8ogGaJyl/o3xnQP85HHkBDoebvBOiolVOY+1o4NU0RS8EfHbLwTwmRO10Qtd0BQCVIbbAR6QAy9qg01JV65p0br+LbXn9ZuV4UPPTFramriFyQBx7HGtMQ7t8BHkuF2NfYyH/4l6V/ey7yViEElq4Miw7JzjuPFjmyGNqOFgxvzB0c+MNdPdyXrEag/pwC9ise1THPS5uSKcTWUYffbK6JmhQ7JXogSZ4NKlR2W+qk+wG5kfK/P93Iu5xY5MCl5xoRiMkFAdg1FrjvWezVR8SD1vkrBq5Ug5ZzYNj+xBnA3bka3OAPC43TtemmYuX7/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv9DMySwZA1MAfJfpfUFobXLtgc0jZwg5aZ0AY/VmNw=;
 b=Ep7QV/vhDwo3EWrh31AMc5oHcsmpcF6GfaaU8YQqERbJSTqgn1k8erVrVplwTQok2uu/McToVMZ8DysMFEMguBMBoNK6i9AIK/3c0BjhXC6zbl1kT8QptNsR6j7KTN/VOOfEgB9DC0ePFuZyeCAUS8aZEcuLcSVWLjORhDgZ3CqNe/kehNmlJJV5pdRLxSX8obXu6sgqSN9wkFe0GLxqNKZFPqI6K4vY/Ebr/DMPcY8Jlqt66x8pqRjR8kkzyT0aIeFGmghx0LYFNWBORnY95gDz2ao2wpnmwU4R2a2TogZ2vAGoMjVa/+fE9aFJGtgpwydrWpFobaLW2jxFD/GwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv9DMySwZA1MAfJfpfUFobXLtgc0jZwg5aZ0AY/VmNw=;
 b=OcxR+NEPT8UotlDbsFp6qoLuNGboVyHtFoP5bDvaQUoO9F/e2h7HpoFzCNRS8KH2WAwPDHlzGeBG6e+FIPr8SWeKomdgqLtakOOQ+oHOITOMQ6j0XaBi0u4Mp488gcfRD5q1DsqYboVeURQHDwvuahOfnOLTBlB7p0C52/1CPqI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5757.namprd04.prod.outlook.com (20.179.21.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Wed, 30 Oct 2019 11:19:23 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 11:19:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [PATCH 3/3] ufs: Remove .setup_xfer_req()
Thread-Topic: [PATCH 3/3] ufs: Remove .setup_xfer_req()
Thread-Index: AQHVjq2ntzlUV6yyIk+z0Dr18QpBGKdzCcJQ
Date:   Wed, 30 Oct 2019 11:19:22 +0000
Message-ID: <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191029230710.211926-1-bvanassche@acm.org>
 <20191029230710.211926-4-bvanassche@acm.org>
In-Reply-To: <20191029230710.211926-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75a5f9af-04a5-4ff3-74f7-08d75d2b03e4
x-ms-traffictypediagnostic: MN2PR04MB5757:
x-microsoft-antispam-prvs: <MN2PR04MB5757A53B48D9A4B5271C820BFC600@MN2PR04MB5757.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(76116006)(66446008)(256004)(74316002)(7696005)(9686003)(8936002)(76176011)(446003)(110136005)(54906003)(4744005)(7416002)(7736002)(476003)(26005)(64756008)(66946007)(486006)(11346002)(66556008)(66476007)(5660300002)(81166006)(498600001)(81156014)(6246003)(14454004)(102836004)(25786009)(52536014)(99286004)(305945005)(6506007)(86362001)(8676002)(3846002)(6116002)(71200400001)(71190400001)(6436002)(4326008)(33656002)(229853002)(2906002)(66066001)(55016002)(186003)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5757;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C3QhRsHpXMdbJ5uWKu4uPgASWjYzRBE3Kpe5vrQO0eB7N2tLimBSUa+zS/oJyQYlVFmtFqDJVrCjye+P1OLAcJLJMvYX6/fDECGS7YAabMXyiBwin2VCQPX0QFVO5CDFn50FJb5DuVT4JBXMIKz8ICe9s9TwwP/HfICgH3cGewabJzGNnST9dkcWWaOwYqwI737svMecntAYs/w5zuggCIyBuBWvJcihtmwnslDEM5DGoJQzKMCAvLtBsGAxs4J0vMk8iYs61N1XZN2wjKy4eD+kCZTMVqZ4tB7deSJ42hMF/kMJ0Hnvts5OZ+AjPcYWJFAq6fYDn2ddkLsTCfToANHFnhLM941aIrZ5XtZhYT/MJwevEi2BtldCegWrVGATRm/gyqeD1/97d0CQ85oK5YsMjDHEK76JbGHsUL04/me9uPg905j/EgVs8Bu3tIIV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a5f9af-04a5-4ff3-74f7-08d75d2b03e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 11:19:22.6106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yNsOI0c85AF2H4JmJKvyF/daXWeNFN6xNGy/0yyFSM/+neWMydE0jM7h8Wj6VIRKgbU2s8tQ0gbVNZeJBUG2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5757
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Kiwoong Kim

>=20
> Since the function ufshcd_vops_setup_xfer_req() is the only user of the
> setup_xfer_req function pointer and since that function pointer is always=
 zero,
> remove both this function and the function pointer. This patch does not c=
hange
> any functionality.
>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Since this was introduced only a couple of years ago,=20
Maybe better to CC the author Kiwoong Kim <kwmad.kim@samsung.com>
Before removing this altogether.
