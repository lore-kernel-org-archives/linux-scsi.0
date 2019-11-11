Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2A9C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7970206A3
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BRbydXi8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iEONDnpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKKNq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 08:46:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12713 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKKNq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 08:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573479989; x=1605015989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QaZ5VQiAFrk5nFhWDAYAkTNB/vPMho4UDjHfANcZrhQ=;
  b=BRbydXi81McPk/IZkadZcvjIzBH4IZKMo3DOnQUzXSaZbRqrUDlAQabr
   sMKwG594NvoRhLu29Sx3V54BnjxGL0/CAOjw/swQ6fZLEYSIz8lR3kfMc
   YtAXrY4czXIiftiJtsvnhahff1u/5qV34Fx7BbYy6JrqnMOuo6hUzxDsb
   0xekBLjZ6RtAvHW05ZQmMkExaglEZ90EtsMVt76hcTmchJLUBJxJS8D69
   iiz4RwzO4EB7d7JjOcdMMvPZRNp/2O19j+gbh3XJwKTmVt4BbEx9K4oQt
   lpspzo84B3HE7gJHQ3OaQxAh05Aqh6bl8bgAv18cR6vWovZS/Zz6oLF8X
   Q==;
IronPort-SDR: ktk4EengiyKSD7pce/o9jdhek5K4zpJ/mjpDUpCtffyuVybTE2ZRyNX2fv+yNjLHeZu/oVGOfJ
 BHezlbLPQOp9LW/Y4LCvdLZiuECFqLLifKKB0vP2IPPUHHToG2wEisYS7EMXrtew6PPuf2s615
 lISBytfMU0D/29YyKvc3/eRGi28KNz7XvHLPf6QW/kqxg59tSHj7EhgxYTLYb5ai0r1Tr+OKFj
 tr/ikVZIwLEcwvwEP0rhxtm4hJAPQfNJpizQDQmJErXTBaWNNm5kqiM0ri65G5ON9Hm1DiAG5c
 I+M=
X-IronPort-AV: E=Sophos;i="5.68,293,1569254400"; 
   d="scan'208";a="229958449"
Received: from mail-dm3nam05lp2055.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.55])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 21:46:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyDwc08EXscEe9C4stLZduH8KYdLWXeDwfHfARgtiNq/S94ybuAU3oEXKg32iFOLauYTLU3DMI1TQqB3/5nbVe0TdoOPTcgtpNvf7AEvamQh8GeqYNlMfsvgycDgyrGTOis8rv/Duu+P9u2IUv9fnvKQzZB0oZCcIAFiLsWvI0jlRhTROovetpNe8DVP0f1NbcBZQ1akNrVq/kLmRsM1tIXAcWEthcS6QKup9+9P43XmKaE1j8ZY5IdR7aeAqYOKj6+yRK6PJzVXup7u6m0xCCgkwuKUGqU7iWqAvyKd7JJ94Wpp1sc66fLqv3xmILEX344PgzEHqA8aO9yCA+/6qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXtWBTqy/8A9+ifJBUddo+cIE7TwzaSdQger5fpmevM=;
 b=mVkzfeBcmi1xbdVQW5JCokMNDbbmVmUao2rQ7qw8RRQiZwistQgiPYQr9oaGgHruzKkf0f8SCHKxjD4VAZ0O80Xj3WGi+uyBoLE5uWo6LOrtLQ+T/K4DMXeIwEVmvFOOtnz6crePWyJXkNl+QcaFkasStXhdfP6do9ZpYmwEItu5/Pi7NESrxaTW0yFGzCIC/3M4zxHuVjvVT4ho3x+Xeh//iw3e28IDv/W2YQ3EGpFkm5IuEqCzDHQaoUhdkbz+rvHEvyb8g+K1eP5ozujM0L62Z1FW7pVGXWB5lVU7EuVaTRhJ4lgQ7DKWmm3t9oAHZ9D6PkLa1SYVr3OO5GE78w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXtWBTqy/8A9+ifJBUddo+cIE7TwzaSdQger5fpmevM=;
 b=iEONDnpEnpeJqj8Q5LYAbmgcXbCn0BO4UqRjymzcXXi0+TOw/yoyMPS2P8+FmeicoJXWOaT95IXGWM0BS+H2D/0R1Eh+be330q8o113Dmv8NEro/g7JWwMwRtYTs8ZdPxbvx3JOjwSTE8jENF4M1y2SdhNxGCbM+N3ahIcUNQGM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6717.namprd04.prod.outlook.com (10.141.117.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Mon, 11 Nov 2019 13:46:27 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 13:46:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH RFC v3 0/3] Simplify and optimize the UFS driver
Thread-Topic: [PATCH RFC v3 0/3] Simplify and optimize the UFS driver
Thread-Index: AQHVlD5yh7myPMGjAUSju3FT8ETD8qeGA+Eg
Date:   Mon, 11 Nov 2019 13:46:27 +0000
Message-ID: <MN2PR04MB6991B29502CACFDC1FE23462FC740@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191106010628.98180-1-bvanassche@acm.org>
In-Reply-To: <20191106010628.98180-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47dfab77-b883-4551-e0e2-08d766ad8cbd
x-ms-traffictypediagnostic: MN2PR04MB6717:
x-microsoft-antispam-prvs: <MN2PR04MB6717B264406C81219963DB6CFC740@MN2PR04MB6717.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(53754006)(71200400001)(6506007)(76176011)(110136005)(7696005)(102836004)(99286004)(2906002)(486006)(9686003)(229853002)(81166006)(81156014)(54906003)(8676002)(11346002)(71190400001)(476003)(8936002)(446003)(33656002)(6436002)(14454004)(186003)(26005)(256004)(14444005)(5660300002)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(55016002)(478600001)(6246003)(6116002)(4326008)(86362001)(3846002)(66066001)(52536014)(305945005)(25786009)(7736002)(74316002)(4744005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6717;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jRoV/WE01F7sG91oYYoYINYCemW21TjsqC41IfIjCGV3/cOdOo2h48vwB5jHy6f5oSog7XuYkpRrj8fh5/ujEN8bRFoPFUsljSAUBe1smCdLnx5yU8kSA0q1i8v5HbRrB+ozKvkixAIItUPn9ShdSU/R6CcOrBgj6KbOFXXhfIohFCWql1Iva9GpT+nYh0lWM69mj0CLvFk1y0ceBBg0Wc7RKvk3iygzuA1sKdoCfDLhOhuJs/UN3D3igeBVcmKzBno3nXtx2PqlHWlaZM7VcUKlVibTdOHRagyr9qSFRVv3S73TIFUPmEinJwXS50R1unQGB6iD+ZMXL3DsGGIaFh2NvS7sqFiraHMEUdB6/rVtSmGjnrc7gg8PUCJ+aWFuRj3jfNm54yn/K5kGd5M8Rt8haz+LvpbMxjZC+oaNWsqKp8d7vdcOfvxs9DmwPU7d
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47dfab77-b883-4551-e0e2-08d766ad8cbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 13:46:27.1280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ppYCUbWdQ0WVqeHlRCap5D47ROOHEfSL5AHJeT59NcLf2tt6y1RviH6eS9f9Tr1MdRSSSItk7fTdV9dfU5e6QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6717
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Brilliant.
Except for one small nit in the 3rd patch (which you don't really need to a=
ttend),
Reviewed-by: Avri Altman <avri.altman@wdc.com>

>=20
>=20
> Hello everyone,
>=20
> This is version three of the patch series that simplifies and optimizes t=
he UFS
> driver. These patches are entirely untested. Any feedback is welcome.
>=20
> Thanks,
>=20
> Bart.
>=20
> Changes compared to v2:
> - Use a separate tag set for TMF tags.
>=20
> Changes compared to v1:
> - Use the block layer tag infrastructure for managing TMF tags.
>=20
> Bart Van Assche (3):
>   ufs: Avoid busy-waiting by eliminating tag conflicts
>   ufs: Use blk_{get,put}_request() to allocate and free TMFs
>   ufs: Simplify the clock scaling mechanism implementation
>=20
>  drivers/scsi/ufs/ufshcd.c | 375 +++++++++++++++++---------------------
>  drivers/scsi/ufs/ufshcd.h |  21 +--
>  2 files changed, 169 insertions(+), 227 deletions(-)
