Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5A6CA9ED3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A39FA21D71
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TQiegYR7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="C6d3LECI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDOeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 09:34:31 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57448 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfKDOeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 09:34:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572878111; x=1604414111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ir2C3elMmglDHXIIPjwIqFNJCYU6GgqFVY8yAAQrn5A=;
  b=TQiegYR7XRJ2cI8wsKGNT1hHIgscWeywb0jeaZFEbzxXxMYYiqX745N9
   Hwf3dN0y7bpep3of9ApmwrcEWFsUckMw08b2Npo6ikvfeQC35JAuHvM97
   NaC1cgJ06p4KR/Gr72kobNun0EL4vceJRLeEHpq9ZIoliK25L0VojFZyR
   CHkAt6b46Q8FK09t9GVVzfWlgXX5kZq6mdV5JF+rnraJfNj+yWtDH9Qp+
   3ODXZpbRqMFPA6Dn0dSng/PvORSOorCqnkZ/ljQGlhYsRsrgDolM4/YMr
   kZixlTvDDf/G6hV4krRS1IFNryB/0PjS9EInro2F9XIR6GmxBhcGdhzWB
   A==;
IronPort-SDR: v9IFD42+Im1bcdnyRPyNgk0d4dOnVFYPY8rT258o+5dBLSRQJJh2O/e3aggoSYb0kxqXGGTCzb
 /WT+NT1/xrWFjPuNXkIbPn0FxPP+u2F9D7g3+EHdeiXcq4LUW7I+Am/D0IbYEMSz/iWmy7Y4W6
 ijOrKrEr1VT+wxusnzEuzHZVrAcVi4wCNOXBCXSR4ck8kVSJ4bFjW9gmjQnNcI9S9qU7JMG8VQ
 7DmkEI49zSbX3clkLMfRIMXzb27SNYXxhoXslq4Tv10dTfMESdMFNk8QnI4UT1JfDBLQDktnrs
 bOw=
X-IronPort-AV: E=Sophos;i="5.68,267,1569254400"; 
   d="scan'208";a="223255737"
Received: from mail-dm3nam05lp2055.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.55])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2019 22:35:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzTwzc7wIE8pfY45uzoauBwDZkmfFdEs84QbfJyPN76mn3WYB/VVcaCOBmU418GbLk1z63Lz7pzuDEwrJok8CSoYY5Qg/5KIit2XJZWqCX6uvXKLY/yNhaf1jNkrcMzzF2ztBbq4+qvHFGbHeKffq+WnnnQcrYy1kw2du7bqWJqASiJrnIEqDZeILmNyaS1jzbDcioaM9nKFKaQfzUcGRHU2VvUEuq9yiZOgmYqRG8aJXBsYCIQFtuzFqWA9o7gXyxdHYe6MZR47lRR3fvEocYGJ3mvwRWUIGAsnIsGLAMJB6l5g5+i3cuQdly3si6I+LImh3m+q3pmCm5ztMX0jgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8c89MYMkaZoDNEn8kP0bqSxFDUC7tPuIZSktNubZv8=;
 b=bmfo8yOKxRpFqco/aDJn4w+yuhoiNnXn8szoAZSwNonESN4rncayku1TnL9gJbK0ahpSpVf2QBYu+8BDg1CK+F33eP0XIJvbMRPkOrxrt1qoTwH1AAERs8sczlrwn2M4r5VwdJJbpyYO6xcRoI7VD/wvr1ZjuaoExQ0HSKXO2vRCSkOSOrbXyrirmBU9Ic589qriV2ZrOzMkcS//LIahZOtsY6rwhfLrDLPZDJ9JlGTLCCuwbFCGrDrlD9gQzONTlf4kG6KL+uO+XUnymUU5BizT9YWqpnvyvns03GoWSYlla2Z5lOlaMQN/CqrI4PyBJY1+7a93tpWik7+kp+Ujxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8c89MYMkaZoDNEn8kP0bqSxFDUC7tPuIZSktNubZv8=;
 b=C6d3LECIns1NAKvZv7yy5evfiaEFTERQFOeBG7yNj8vKjoJoLqazXGIro6qDLwLxYxAfhRWk9owdE03CIrfzgQL1uRYxfHQl4hViochcjXs8RmbCaz//gc7b/Vg1qqseB40bboiwd9h7++DpdEBOf8r6ZjVPZUxfoCfAqLC7muA=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6912.namprd04.prod.outlook.com (10.186.144.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 14:34:28 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 14:34:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 0/4] Simplify and optimize the UFS driver
Thread-Topic: [PATCH 0/4] Simplify and optimize the UFS driver
Thread-Index: AQHVkD5RyQfc3hdHFUaYYYhThHTdT6d7GQ1A
Date:   Mon, 4 Nov 2019 14:34:28 +0000
Message-ID: <MN2PR04MB69910A6F1B859497BCF0A74EFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191031225528.233895-1-bvanassche@acm.org>
In-Reply-To: <20191031225528.233895-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd9d0ebd-062a-4b52-e7b5-08d76134192e
x-ms-traffictypediagnostic: MN2PR04MB6912:
x-microsoft-antispam-prvs: <MN2PR04MB69120AF58BD6F7A571CD7B6AFC7F0@MN2PR04MB6912.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(189003)(199004)(446003)(11346002)(5660300002)(229853002)(26005)(7696005)(102836004)(7736002)(478600001)(8676002)(81156014)(33656002)(81166006)(4744005)(2906002)(186003)(76176011)(74316002)(6506007)(14454004)(8936002)(476003)(486006)(316002)(110136005)(3846002)(6116002)(71190400001)(25786009)(305945005)(9686003)(6436002)(86362001)(54906003)(66066001)(6246003)(4326008)(55016002)(256004)(99286004)(71200400001)(66556008)(66476007)(66446008)(66946007)(64756008)(76116006)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6912;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g7Mt0r1cZ2H6b6PX7VPK/OQQ930pv2hLLciranQj2LP8mF4KPOKTmT8/yIsTmrs76K06xER+B6m0KYVTtGCs0XFZ1z6ah1+IP9kaVTLy/OnmlSNJq+hBDyEZrcCIFXLFWpZ//+Iy8Pkq5zfCWzfyWzrc/QvYFRWh8dZBTSF9Ht56VeedNP+ghF/W16PQoYDTUrMH3PEtWYJt3JjNGPkSto/JDuPK4YPY6/GPvFI/GjSoHxsjkIIA9qJ+1R7wdBpY32wqiaNN8anL2ZaJaa5RXahvW4KWB68P+LWijJTYbxdfSQ6YpK3mOGH79kFtE/dEfODGfMEerjt8RJmLPL54C7X1rdwZQ0VP7i+Egyg6bv2Wjt9glVbX/JYYGYWK1LIRsdBMqo7y5iFuyTBc3hML8fXsnpMNcou9qowPl8tnABIDBaP+cB+LywssJM/GFclE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9d0ebd-062a-4b52-e7b5-08d76134192e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 14:34:28.2911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1D+eZjeMD0lq5yCQ3jodcEKk9UhcCb+7Qxnqcbu3aNLt3Ou8BTMT/0Wzz5rAJUepA4rA9dDA+cS+Pucy9537Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6912
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Hi Martin,
>=20
> While reading the UFS source code I noticed that some existing mechanisms=
 are
> duplicated in this driver. These patches simplify and optimize the UFS dr=
iver.
> These patches are entirely untested.
Please allow few more days to test it.

Thanks,
Avri

>=20
> Bart.
>=20
> Bart Van Assche (4):
>   ufs: Avoid busy-waiting by eliminating tag conflicts
>   ufs: Simplify the clock scaling mechanism implementation
>   ufs: Remove the SCSI timeout handler
>   ufs: Remove superfluous memory barriers
>=20
>  drivers/scsi/ufs/ufshcd.c | 288 +++++++++++---------------------------
>  drivers/scsi/ufs/ufshcd.h |  12 +-
>  2 files changed, 90 insertions(+), 210 deletions(-)
