Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B671DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4A461177
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhKKHJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:09:14 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62525 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhKKHJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:09:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636614384; x=1668150384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HIp8iB0oDjSQtRt/2swn3kmBot/2pFmqLKhALvKogfI=;
  b=JktkO9V8ozgaobQYMBpBxcA8mD5OWWeyfAhFE+l9xujFyq+FW0IyQ2Jn
   3bGKfuHDr2hMdoz3VN9clGvGqrNo9fPV2jgldlUnB2DbVtd5VaU1VNc2O
   07ezI/I9+j6hm4LzFl8FtheHHzatwVfXZdkFzKaMBDfnyOmGdPA3CpVwy
   On41rLvwFqvmIkI2isioIhIbRTypegLWdDDxSmQWK0mb6gOZYwvy6J1lN
   Nlk1lQG52jYnMXyFxagQf/JRrst8I14jBE9tHFaXUp4mbUhiryCMGuM0s
   NGnL3ZnIRc6888O5cBzS6jJpljvs3QqRKoXBKr95ecd7q6qx3g+wwL1Mv
   w==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="190126219"
Received: from mail-dm3nam07lp2049.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.49])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 15:06:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhlS5TdjZwWK62DwLiXl6rg7GdaQu4yJsCqPjcm4usa8Sd9zDIYMHSqonfSy7ECbgH4xDtIU0xSy0dVadaC5bMNZ9cryp9aDNOZFgeY5W6DSFvNnfeRW1Jft6RQ7EIUrH2ovtQCr7VV2uPJjh9NQsocA2DECbNWtCoNZ/S1oiEDOc/PRsGA6J/irRg0R6SwMng02nn0evCEidFl5nMPLtIcrzx0rKgDy25d5bqKCAQZEXVyw3loUFNjhVdZrt0nFKGU75qmvHuzo6cAB8GU0VWqqZwYsX++z5zAgjsW7/LflMQxTu2ZLP1UZg2WOJqlEErhFj3qheBguBp/OGPVbEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIp8iB0oDjSQtRt/2swn3kmBot/2pFmqLKhALvKogfI=;
 b=Sp74/4+RPnxN77YPEiu4Da98SEcYDQoxiFGPE/+bPgBFlRObeGvJNUI0OmrAB5+AmPKSUapc4lByOGDhIKzepKIqBfnvacWQvrtMhaOdA2NStMX/YizsFSOx2Dp3GVLoPomFmrF3/AEJrNbq93tdiH4/Fv82XjTQoeWdkt61sYnmOItn9bj4+kIlA13ynJw+HdlHNm9TS1ctmw0gdWbva+r4reZfFRsYw7pQe+EwE/engZV18ax4KifZ/laVcNkFHhvGN+Dc1muRGI+YbiSyqUnq5S6owg38K362m6eih/RPWWsFfChBHzUX9OWHLO+uZHV9TXRDPm4tXLAHyN9Wdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIp8iB0oDjSQtRt/2swn3kmBot/2pFmqLKhALvKogfI=;
 b=LZhIjKRuR0j3J7KXqgS1HgNcw242jNTSG9rslMNSNUTgQTy3YuqP5TBhJJhb7PCXSYGiK//RXFHSs4EYyn2VY+VrY/fvju58Nagd9OfaXrb/rdKCFK2dwCKcOz9JKbtYDJ6mxrsU/GeOO/HHZ56ODlm/mxzt0F4V2DnpXUAN4ZM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB3899.namprd04.prod.outlook.com (2603:10b6:5:b9::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Thu, 11 Nov 2021 07:06:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 07:06:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 04/11] scsi: ufs: Remove dead code
Thread-Topic: [PATCH 04/11] scsi: ufs: Remove dead code
Thread-Index: AQHX1cxDprw0sZXni0uOmZK51iYl2av96Vww
Date:   Thu, 11 Nov 2021 07:06:22 +0000
Message-ID: <DM6PR04MB65759FFB0A785C9C6C98B716FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-5-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d11f8e55-7aba-42aa-86dd-08d9a4e1c4a0
x-ms-traffictypediagnostic: DM6PR04MB3899:
x-microsoft-antispam-prvs: <DM6PR04MB3899EE0B911908BC92AC52E9FC949@DM6PR04MB3899.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: um4obMeVXvWVC4pvGRMWKtZhqVJ1My3mfpwQ6i5Odpym75ieNtQhSw4mAYsAVcqWvl0yeO2VRGMHojyAsi/dnxwxo4OqUdnKYoSOmLvTr95SCsZBD0p9thQRC+GYdKdxtjvM+CUeF130QDUigS2n9BnIIiHtUSUX3iconzPhj8atUUP7UVdZ/+G/Jw7a1j0oSb6omtMWV1T44NBcU0zFTxQECNfkRn5j4orwMKlh1z0OI3+/pfMEGqD+1vFVIvTaBzzJUQXcJA1U7Sp1vphyg07MhXdkjIAz0/zbvKgqwBMcSDR+O5G2OvkRx8MQhpuZ8+xw5yycWIF1PwUL+xLyWD+fcchGLIEJyUR2tpkKtBNAUi0WBUCHjqgL0JEtWDkuPVAk/8jQ3Qgty1cCbq4Tae+JqdzEBesPn5q/Coz5ztPhWsqtQ6GrhCs405RMBPSan3IdtpEfPasXPLk3LtAdJzvwp52meFUC/W9u42MpeTFABVrqno9dMCkIAKW9P/quapBGENBfvC/Pkd1c6I5q0gh8UQxC5sb8q91utf4GMxZSw5txezmM/aYSzjQ9twr7BHFKPbdhruuquAbAyAlGTd75EjNakMiGstYarUqEatwmF4VpH2OIl3sdLZCduu/U2IHMp4MNAe+nnz9VwrmpKKFFaMwOFxJydfyBl2C6r8BS7bUdvUtXhFfF78ySc2p5cJ8QXTsf2GlybIgqqh8bSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66476007)(66556008)(64756008)(66446008)(71200400001)(26005)(66946007)(186003)(8676002)(122000001)(6506007)(54906003)(9686003)(38100700002)(8936002)(316002)(55016002)(86362001)(4326008)(33656002)(508600001)(2906002)(558084003)(38070700005)(82960400001)(110136005)(7696005)(52536014)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ST0XvZXW/eHGKVYgnoo8zXpr7zUmcDwYKKHqqpmfbWawHuK4738Ljh6DgEWx?=
 =?us-ascii?Q?5Lky+G/rMyBPKbA7g1QUd/eGf4AUajLPOM9A8XVKrYGrl3lE6px/A3uZ3Kcy?=
 =?us-ascii?Q?mEdcTCXN50FAAysCECW3/LSBficpN96WjJdt5aWRR5nSTjMM8o+3/TRqkqZJ?=
 =?us-ascii?Q?z98gk/t+pfAoSogduBvK1AiHX3JFRJWIdkxTXMdA9v7h+7e6p+4QRZbbSm6x?=
 =?us-ascii?Q?j1XZB7vB75wUnKTSpGZP5GobyZMp26/XlsX8f06jAZ5GMBxzoFDPUT/n/JrD?=
 =?us-ascii?Q?u3I+IzcFXrsZVt3IIkqNJy/6Sz9ZRWB3Rc9LOossbTqBBSjOOH57Krhmdc2A?=
 =?us-ascii?Q?fe1cikOJrrUH0jG8/sptk4odW7CMZDRWQFN34TxXbh5k88a//kAFfiIELggZ?=
 =?us-ascii?Q?S/6iaLENDMAZ/7pz7VbZs/hU4NWcE0bpIl3E8qHv3gIdr+ZhCDEWA0lDRa2s?=
 =?us-ascii?Q?+HePoMNFM8FP4OFuXG6YtXQnpxLzX+YDJ66hKZP8fZ/76lyxQ7ziU6mBaJw7?=
 =?us-ascii?Q?mkzChUclsRCxKm13/vX5M8Zk8pw//tK6cO3YlkELNWEED28AeQM9K0Qurn2k?=
 =?us-ascii?Q?wBOHqe/6auYsdtxvL+uFWQxeBGxWG7xVRkM8v4ndiJKZfBgbdRWN34zAGfgY?=
 =?us-ascii?Q?wpW11QaBpdsnYDQUUeQZBmJmlJ3rG0zZ2G5JcryOxUtgSzS7wZdd/xI3LvTm?=
 =?us-ascii?Q?htjzU9jjfAk+u2YEMRonb2z6Nf3+YTKIRIlbSat/exnHNbn3nJImfmHZ8l2H?=
 =?us-ascii?Q?+uSa5qYmSkKjZwvrVzA2mTFPJzlNfSdISe3qN7DIjiXudvVyIfRGM9CSUiU8?=
 =?us-ascii?Q?ktL1+izo+SdOIXQ6kq6WnS2O6NG7LMzzT/Fi6n8LTrHEpBUVpfNwnJFGkSPS?=
 =?us-ascii?Q?hJzOuuYvk2IkFaYvEhZHgjza1zUXKYqFVPW8kuOtgsNuxSP10j6H/DZWzE9L?=
 =?us-ascii?Q?lGIZIVdqNaKM5VA+P7fmwaTaetk/DdQy2ah/Bh4izQI2eI3+W6C3SZMp+/nZ?=
 =?us-ascii?Q?uszbGH57sNDQo9m7j8fVAg7oe+5IjlUnuIhvA2E+tbkAaAu4M0Gtx1D4d11r?=
 =?us-ascii?Q?YTEd0E25fcZGt6UPqtnIZUio1hdnje3LkSc07zAxn4mXpo01A/jNZ6liP826?=
 =?us-ascii?Q?oIGb9enO1VvVIVtl/RH40wRV42NPKr3w8Or12Ix0q5vR2Bayw2WFdYFFAh+u?=
 =?us-ascii?Q?D7nV6S4QbflnMStuBZDujbZLF4hjjzh86cUrXfP0aKjv5zLZex/P/xzh6mPF?=
 =?us-ascii?Q?8r2xKO8lx0co7Y9w/UsCJ4YKUups7Lji6KeD6xkAxssLSf6ij3DjxxgRV9ZC?=
 =?us-ascii?Q?YDcO8Jx1WNgHNTYkDrQqwc4EU5MyqTQ9nf7NpuXLeWiMNjM6ajg0y+uvsCkd?=
 =?us-ascii?Q?0slGno7bCd0WkM4B+hc3EJB0SRn33Y8/D5+wen2ubyFsWd7j1hjlFtgQ9k93?=
 =?us-ascii?Q?qUJSGnWHZi/7U+SyLmcJq7tBCrdDBucxE7L9IceXq0beEhQd/9Ay8DD13sty?=
 =?us-ascii?Q?fwxGLSlrGbKVvk+n9I2bnvtLehlpsXzU78dtpkmh8/60WQIFniEKHLqJTjIj?=
 =?us-ascii?Q?0ZebRuvEa/qjGcw34NKwbCkaGiwt7/ORD7DmiqZhTuiiY8FUsN61KRQPeTve?=
 =?us-ascii?Q?SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11f8e55-7aba-42aa-86dd-08d9a4e1c4a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 07:06:22.1872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssBh5p1to/yUEbrfjBrmotUoZtNs6npY/v5f6BqfgEbK0uuIXEMcxysPN+oTp6WelbE/kTpvI9WcyqXXl4Nfew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3899
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
> conflicts") guarantees that 'tag' is not in use by any SCSI command.
> Remove the check that returns early if a conflict occurs.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
