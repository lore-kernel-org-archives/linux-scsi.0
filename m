Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5007C43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiGDNRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiGDNRM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:17:12 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D82B48D;
        Mon,  4 Jul 2022 06:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940631; x=1688476631;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=PX+L/TmfoQCK3CiLHSxt2gfSkuUgC9EQYY/4RptbIl79BCZn3rU6OTkj
   9s4jHx3FLvf8EJM22ctmH8HKRlClGjjH9oMrZs3ghv/3H+yoB2z2zLK8U
   DoLx4cyDQcz+6qQBNgLpFPSLaHxCgk5xSt1JVQYwuHdQ6mb3V2UD0DzUI
   x3+WhSjueyZ0r1wcC8ihI4of2+SjGtkexK6lNTNb2wgcED47wUln/k/Hv
   16y5hgc6NxWLAjehe93902JEZgRVeLRb9B85zyb20hsUntrjVBA3sE7JJ
   5dvAoohkSoACNT1jsDjjqSmI1CQnpNBApmEYfUztPWOLxpX0V4XF7ydpl
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="205481516"
Received: from mail-bn8nam04lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:17:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqFeM7QccwKkkQ8ldGMQa2EWwF1TBUKVGY3faW3rluLYfw9AWoEeUVFAbWjAca09EBO+a7qYDKz6gb3m4bQOvle1js4c/Yi16wVDQ/UE5xFJWNaZGWsBrFQsOSug0TI+u3SYshMdFSz4pl4H7qDbrqJv8cWDwUUKg87s7zjgRpQ3zqV8ogkjiQTd/oSMDhVq+4wnpJhamSGr7A3ptSfl1iCBHGUv5RwqzyFh8CTJHCOymM2ZaMW7rHBN4hJkaXdH4YYwiptRUx3cVTx+cU/EBP6cefCeXcKx2Q84rnpTBaA5WXQYXB4Tkfkp7lSw8fmAP0/rnDCcKwPokomPAFBzBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=gzdxD2h/x5Oj4CWfEg5BUAK2IQY6LF42UR3ioy5A8vYeD5L/dC9SGJIBxj6479+Ia+eY6CmNQO3EYjGmVka622RM9df/7bPztZl1ld04Bsxs+e2MX7DEWVmIyOJl5h8GEX/yHV37X6k2D0CMLF6ROpVa1LnVxJHA+3xUf8wogIKqR9ro9f9jw/50Mf68YX4xdcCij2zCyXiFoYnOfrLwciU74vOgw+hu6unznmrJFMDkVB/I2KhZ2ux6gbOGOEJ37tBMxissDAAcYWiRdnKAkBK9pWLzpiCgPEiUfekuSkp8fDh+r8C0Dd2Hr3vyj6qsSn+B1nCUJa7GajicBd69EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=gzLmk81GHQV7X2tb6vBjESCsJnjzOMskKUO8+gtFe5J6o2E3eKb4Vv/mXUYF71xk346eTZegArS1C3FBsrGPpDP113soYUyslUcfnRKTVIQ1G9zrA+6kXGSBOJHqNAGDbT9SO4/FovKBVRNSWIOsE3R5CoD6Zb5zDE0/LOyLRSs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:17:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:17:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Thread-Topic: [PATCH 05/17] block: export blkdev_zone_mgmt_all
Thread-Index: AQHYj6P1rQgmgQLRK0yBIpbU1T8JTw==
Date:   Mon, 4 Jul 2022 13:17:09 +0000
Message-ID: <PH0PR04MB7416ABBFC6E55FF41B2AF8F99BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73c5c2f0-9548-4d38-4440-08da5dbf7fec
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8xZ/ckm0bKpes0ZfCYy6AJS4ayKJ+FvYQ7jIjWpxTeC6rCGQL3JcIiDD9ycOQHv+ZA+A8xjosvHALWo4Urpn5pEAQGegUZe19cNPVY8d7gswNveRlQtXA400OaqYHlKzQS6Vuh3DqigltaFEzrSpZ41SQipDkbQfX7HMT+rpwzSk8olmqGa/PAdgPJBoaEwnfQXBoku33grzLImn2gRUg6/J4pV2HxqgSaaibbbhWOowDAY4DcDxCYSxtktwaVrbELwaVIp1jkzZSdRKW/w2dwG6fLBInThXRJzxCFQx0LUzHdbdZgQYp/5f5+Z5S0qadRQm3FOjQfZcvFuBC77dfeXdAvCsieF/QZGMkgTc7iypf38J4XeHa3CIZOTlg00M1q1u9YYOUtPq7mHXcV6W2dnkJeCJY0cjIje7MxzWmMHKTYXJAQpyYcvLBAXICmpAPfwgsj4gPMzhA0rVxZz+pK4wPGPt/QeR9ymIBepDeTZHTflLkTT4JXD51OnWzjN7KlX3aa3FOxQVVY2AGrRR0tRthaRCxy/6mstwf2zD4VpwlNpEK4pCl95v7jpq5aTH+PuEeRi2RA3aMS70vlgvlLCf+B+0TOz/GWSLQ+iazJKr3sJfDCSgeViUr9PCTtEmfeiBel41NorhzZtO2ShR314aPeIJO4Qsm+UKPWlym1UJeh4oDQD6rj/hmYq8bGxns8BVEdxp4f4HsZudt/uk+5ykMFYsgg1dXu7ySUyJIhf7qFqXVK3PPEVyqI0P1WIUxbSLNz3bwdlYt7LQO65RqFDSyR3hM/WKlpYtrllFmbQrznYdCE9bx0L2Bdyqb6AU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(71200400001)(478600001)(91956017)(86362001)(76116006)(558084003)(186003)(33656002)(4270600006)(4326008)(110136005)(38100700002)(7696005)(38070700005)(66946007)(9686003)(41300700001)(316002)(54906003)(66556008)(8676002)(66476007)(64756008)(66446008)(6506007)(52536014)(82960400001)(55016003)(19618925003)(2906002)(8936002)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PRkf3MOM+RdH4rGUQ+W+TnQmbWp44ZeuyrmVaBFZjMxd+dkVSVILIOuHV9Qc?=
 =?us-ascii?Q?sTbL1gvemGC0McABTZNdvIbd5+Z1qcBsPXB0ySQf+wqy/AH1S+yo6WQF2ews?=
 =?us-ascii?Q?3B5T2q2sEmbgk9KibpOYXC8fNKbh5irjUJPzL1Td46fdM5U367xvnACdNaw5?=
 =?us-ascii?Q?OvtEIjeMpxcLxhBjB/c1U5OJQ+wPvISmnEuf5tP0ha+csIeBiK8cSCSOIVw+?=
 =?us-ascii?Q?LlN0LcHIoqS2vNbzM3IBbW25DFUSzxBEhgUypfGNwEt+6+7/iJF428rI3LQ7?=
 =?us-ascii?Q?zPOfLLIAPKcSb40VH5+9eZwKOYi96IzvrOugbjvPaZMVZZW+vIjT/w7A7W1G?=
 =?us-ascii?Q?/zMtCDc1qzdmy7NT8DdLWxE18xT6cG2HpT8LqAGnQWsRNifYIGCriuCl2tgz?=
 =?us-ascii?Q?uEN/Mjz/epjgmYEDK8jJsLC+k+G1XuskBqoHTSOFfOTkEADsBjC5xN/OrR1w?=
 =?us-ascii?Q?P9PqOMEmVB4EIP/81Vsk/W7Bc1BAHLAaabIKwxPkljZO9kAEwYpxkZ+ZBMPK?=
 =?us-ascii?Q?DkdH2thC9An2sb17STjs+VEp64WuBf4Re5n8Orjp3BOdEFwW2A3y7vg6XreN?=
 =?us-ascii?Q?ADcuFoRXeV+R9nZTotsOMjmUAH7Q2pLBkLlGM6Mc147L+miWv1Ze7PYjcnt2?=
 =?us-ascii?Q?GBOCGxy3pkK7HUHH3yd3oC0hM9sD5zNxWo+pL9IlDVb3JhxhngjK6QwtMqwH?=
 =?us-ascii?Q?KkIJEEc3jNllOz809iZVZhBXy8VrLyWk8+tGIbkD2FqEdHszFKU4g+FRK8PO?=
 =?us-ascii?Q?Wdbp1pKVBunctkBMUax1zyWUoXnGTqR8IiY6T7xgCgBypAx1X0KIma6eKuY0?=
 =?us-ascii?Q?uddmDU8pBOKWmH53IaqxyXTHXgmLUJdf0Zhb3TCRVdXd1Us2D0VkniodyEH+?=
 =?us-ascii?Q?gIu2U08iGAw56OXJg+lu6wuNK3cRjG8a3ggNiR9decVWvl0ELcx7gZZUzCaE?=
 =?us-ascii?Q?sbNOLkucV/JepwgCZq+8K7/LI8FWnKe611ErNGYyNd6jeEKBF0IQfcqHVT0a?=
 =?us-ascii?Q?ArgNkXPadWPpXOhtiLdO6d73K3zLIZDZglalAFE8ps4S7KZy+a3CKRp5X+VH?=
 =?us-ascii?Q?z6vUUcCjjIp5Fu5KnFBd8ShvXYD1q32487s5gb8HlJAITE3q8JGfjlGESUkH?=
 =?us-ascii?Q?rmK1bwroVAQnL1bPy91KdplegBsco7wzBsWPgtz3ZeKKmzU6XQo+mf4wAyMO?=
 =?us-ascii?Q?4qimCqo5yChNZXvpzr+3EYtGCXw5aO+5DPU8hbFx5tGYcBOtqZC1Kg7FUnDA?=
 =?us-ascii?Q?7sOU6JnK0ELOL8VVMSjHmgMw8yXgbKIC3+G7s3rXzKsG01KOKALa+amCRBMD?=
 =?us-ascii?Q?lPPF0F2dgQfkgCo5nQC8XPViveEG8/bSzaXOwYNUL72RX6QQSZ9AsGerMPaj?=
 =?us-ascii?Q?xsnL9+B1ua30fY860uVOpfeTLS4hOjrv0ogchHg5EY6FHSa7aBC4wrPFXWAp?=
 =?us-ascii?Q?mTqVTI5w6rDngfBtQinI9Ygrk/z+dhI7sEx+fv9OUn/FbiCBvU69hOBekyf3?=
 =?us-ascii?Q?6UK0iF+aOGpAu7oLYf9vX0gziDRLEnGsHTmoQybxIQR+ACcu46u0hYmK7hkF?=
 =?us-ascii?Q?mf5Fj61cawHap4kmA8eo7PvCj+3/EL63QQKmU/2fjaQi9GHjOXhth5SSPbv5?=
 =?us-ascii?Q?c/YZBZ3VpiVi2RE7oK/vjs4NWPYSF36DbeRVF0M87n/jf44VD2KdbA4kznSm?=
 =?us-ascii?Q?MSnAGtTcJ+emsv1xnr5C3OQc2eM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c5c2f0-9548-4d38-4440-08da5dbf7fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:17:09.2361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ithajeacdzdJNp/J+bqv85d+VSjLxj19uzS1Vw+QhUjBMiYXIfFtFOOl36SHCSGoMsu48eKYAmnakmTPfTEjaLeqESHPW97BnftVAtOIKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
