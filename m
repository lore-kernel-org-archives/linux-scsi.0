Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E997CC4332B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A091D64E13
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhCAKlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:41:47 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9092 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbhCAKlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 05:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614595284; x=1646131284;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=CVg8zp/nP7RUXBdUgkN0Es+ZeeqxSYwnPprXw2/6U6K+fbqlbWV5+Mvs
   biEtyWbo/iYdY53qxAQ25KK8JEiuLZU4vDfsPD3NPr7Rfwd93wI65Xfo2
   fI3ZX4YoDWAHrJm0SAketmpi3JNQtWORxPL60eJUIsubZgPIVGe8AqZTH
   nT7Hr7GbS6IIEcY/p2gLbMTcyDkcVa+eaSxhYXpApzeTuXCkpFIpbP/Jd
   WTeqLsaLbFowk95qmanwGinDUDpNU2Pkp1xcXKJl1W1ycZF/aaxmiq2EH
   CZFSmW8qvhxMw4Xcv4s2bBVDeyyPgi0grFwH8/u5riZNWSyPg2jnyoUPH
   A==;
IronPort-SDR: UCHNVjVmgfGJLa68RwvduRHGpXp4vyohSEZImUNZEwT3U7XqogG9xHfJHEW9RKFkO60nDj8ivP
 g/7+qvIpGQwrZjnH6rhaY2am8eqpvCd9WHjhMXcM1hikkvRTeAHM30Z90kIHaWDoKYNSo7aUT/
 N+jSm0ivdBrYeFqpYQUqOw5lvRtxJOng6RE/y5jLJfokcDs7UH2njDxypWOwjRwuCk63WQZusc
 XWrEBHkxMuEVm7Swt9i55+jTenHn9D45ppVZWHHUVX1OCSdimOAmERVHGbalE98XWR8tRra2WO
 39I=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="165537621"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 18:40:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9cCsjI+tkshcgX8bbn71M0SI8dIrje/afQQxHntWK4cYWgtZFvFS776+xZQG/mlO5IIXpXwKtgNZxWKTuwxH5RRElfswn5CjxC0qZeAknIely6j5N4xWRiq+jaCf3hAo205HVwHOPU2NQhWFO5xxB7nsC3jZM/rLFMO7IMhU1IhvD/0NS0duEa+EP2XjPXv/k9t42MCvBLa6UT85C7oUW723HCCeKOZGFkO1OVyj7n8ht2pS6LqanPPhaUkx4fZdz1TnazzUcrZ5ZRpqUgUtIpMe/iLo9Xatq1VOwwVJGqeo99KEvLaS/xL6yMLoNpKH8JQmqnh0kNx5wbwlgzKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Nxa8qdnyJycCzyIwsKLMf07eWI319ZON54SHpUbQrs+6jCMr/5ebBS1zX6Mi0vdMxDtGH4lQeoDXrTwdYASawUT4uXk7SJtZFWuWYCv6k9YHbjYm3ocftMHYaWbxNWDqNoe+M5NDSQmXIbgKciLxIsDruzwD/m4vzgFrz5prg//Vw0URfOeffJ6tTkA2qMTogaa9qQfDVF0yO/YyIf+4DMEG2BZlG0/yHfMENQY4eODNiSyerAhxs4FD4QeHQBuVj1AOWUVatW+rWDJZn9z+gs691Im70twVDaVwnfE516f6T9r7FKffuJjGvXlv/BoE2dzGOIb/KTC14oZUhobZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=wIiug6geswG1GFR38WwLVaIbq7uB60QEt3CJ+oHtvaFHOZcP7I98m/8/HvBv37e19TXBPwzPmWLwuiA6o+X5oKJy3pZCnr4+ERaDWiNAmETOloFvFVU1gGjBVNB/7etfdb0wKR5BstBa68rP4oeVGnEGnPWSwTv0WDPVMqlV/64=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7270.namprd04.prod.outlook.com (2603:10b6:510:19::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 10:40:16 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:40:16 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 01/23] target/iblock: remove an extra argument
Thread-Topic: [PATCH 01/23] target/iblock: remove an extra argument
Thread-Index: AQHXDZcFlxIsRufiJ0ifpaaAMj6aOQ==
Date:   Mon, 1 Mar 2021 10:40:16 +0000
Message-ID: <PH0PR04MB74163F7EB8F606107DD2A2FA9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-2-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2ba48a7c-7830-4b22-8f23-08d8dc9e670c
x-ms-traffictypediagnostic: PH0PR04MB7270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB72709A9AAFA4919CC291F0919B9A9@PH0PR04MB7270.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 74JrNp87sgVbCr7zlWpr2K75mXeHOwhxgV1+PTcIF7xmMdBGWuQTz6emXuczIPlWM9roaIiMSyt5ttOH2Jf/nPq4kFQufCAz6wWLxugDEomo/Qp7Z3rNxwW+xwQeziBP4h8WeePJQmpvuqUMuHGry3GPG1Vkok1HKVCVc3DwSCBHbwiPRVexng4sfU7+P/04uWoJa2ayn8jNiDl1OC1Tr8wm66goAbDNs9km642LiCV5lp/QM9xugCZJJUqoHiITNNUdQRtCmUMK9U7gjvqDXenxkF1CVX72NQP3+LdQlmnSqjP36zaF/QVpKK/RwXMDPD6oVwU1EqI3iP7I4uNV4EqZU8rKdbV8qvXECttij+2lV7DTthAfy4jmhxdFY/gCCq4QSJTBj3PPBjKHImKnvgUGaZUbIsvLgFy2ei5o8ySVwhyApy5OTLiEDvMwf5wtoyAX6hthoTvLTGt3Sj4LcRupaRFriTNYyMejwwU2uB5csPj17SDFfu+uSc6xWiNMLccdRvP4H5lueH2b6qyIFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(86362001)(91956017)(52536014)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(19618925003)(5660300002)(9686003)(8936002)(26005)(33656002)(186003)(4270600006)(4326008)(558084003)(8676002)(54906003)(110136005)(478600001)(6506007)(71200400001)(55016002)(2906002)(316002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cIXT5bvJ42AhW5e3ynBAZY+JOXGfwTj9PtM2ly8HFKHPtKOrvMQia5EBpBEG?=
 =?us-ascii?Q?TqI2v3eXg4yxk4BOO+LrlUuSSEtk356tgwgU9GmLy5NMn1IpXPmjhdGGSldo?=
 =?us-ascii?Q?9Wu0jLbqcmJKLqK0R+w2KXld4GSIyx8BMA2dJjaJ0OIJv5Y8k0lhGd/2jcIK?=
 =?us-ascii?Q?6nbMiL6wcJ+FGXRV68bWa0WyHz2liC3nknb9oNd2JvITM4UZ3D27xgjeqiAl?=
 =?us-ascii?Q?gvaQ4TiybSFDD52Nt7XKvnamkU761M93pOvjHNjZGHl7oae0JpfJKp/hS5Hx?=
 =?us-ascii?Q?L62OdJn21TlWWEKe/dCyw1Bf2RocjQeUwSRQJ0PycEosXg9v2Lv61qYxmon+?=
 =?us-ascii?Q?A2pzVPK4qsA9Tq95BwTRUENrhjsoVEMk0/RvESqoLrPbpweEg/foSiTiysb9?=
 =?us-ascii?Q?BCMEIZqsorTrQI79YXVFC8fxRC3G6kYp7l5oYtW9bRXCPLIrmEMJNUWQGqNq?=
 =?us-ascii?Q?FZBelVMlhAl2t1yLpZSLhjqHO4pKsK7MLCIs5QZDcO7do3z96dvQ+GGcKUsm?=
 =?us-ascii?Q?1jp1krXEsdQ8j0TYbdyCatkMM9xIQ4/R6zMVIpx1qI0gq0hXhc1eTmnzO9fL?=
 =?us-ascii?Q?HbMvZZTKSNmx/BdRV8KqZ4VSQhK29TuYL6QcHOfXUAulvpBBiJH5zCHZ19Fv?=
 =?us-ascii?Q?6yeMY/M3RJg2hoU6QHyso1QWAlzZwukfywACPt1pjjY0oJc4XY5QAyv4K7R8?=
 =?us-ascii?Q?wHo1pkWdZb5lZpVNrlV1UqSVwp8zPLDyd4RpctbXi4vWXTJzFemyOHhlFajz?=
 =?us-ascii?Q?cJRWSXjP4PSOoIAVeKbI3r34MA8gR3yEv50DvVrcTZlADPtT/RHJ37D74ZuX?=
 =?us-ascii?Q?HNglx+HsmsrCT1d3LwRx3ey7cT4VMLfd0v+iNdqfO6B9mfz7axJypPxo0sk5?=
 =?us-ascii?Q?g0b2j76PeOXhaKMUR/e3Sxy5+DzwyHEzp3xVe8xf2GBh2hufTzYijEPqx9UD?=
 =?us-ascii?Q?xmqAxCdMlK5OSMAV9UEnyJCi9qX2ZqdOSL9CZq0Ue77JgFF00uThpw2qgxT6?=
 =?us-ascii?Q?vzNPkxanzmO73Fmmrf85ObSjodr8TOqSHahyFTRnvgqAri/70XlQpwHMLf6h?=
 =?us-ascii?Q?qpIlG0SuKyUXNdzEuft0nVUmvROSrUnrljC6M5vHN2OOKSCTIWDuAMalEsUd?=
 =?us-ascii?Q?ibF0bJ7d467RZNQduBVwQvVWkdgfvV8gZSaQehCtOKcrMGWkfePNIxslWqsD?=
 =?us-ascii?Q?+e9NYVje8E0k5K7mTlBapF+fTmiH+9DGiB7D93IwU74/DNgIcshGa40Vn7WY?=
 =?us-ascii?Q?X1zDEy9FDdcdporoo0ycbD+3FuhFpXQLWW6nalEnQDAaKFOeV3W4Ppn0DAEo?=
 =?us-ascii?Q?X4uWzqIaWuXQapHpOeaez0zfAxdhK0j7hXsD3zdPzaGOAw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba48a7c-7830-4b22-8f23-08d8dc9e670c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 10:40:16.3351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nevsg3+0joVTAiUMClRKfgqCiHVPdRk7Es19qI1FaA1lg7WxV71247Yijja1fscaS3felRry1IIXwM3NsqgyrSWYXJNYdCjyDzwuftDttpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7270
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
