Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C890C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 07:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECC5322BF3
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 07:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KsWLZgGY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QhDqxrBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHEHJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 03:09:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:6252 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgHEHJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 03:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596611346; x=1628147346;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=soN1ZvSeihPa6rOMQWSa9ldUBVaxmQL7DW1+PG4F4ss=;
  b=KsWLZgGY4uzg887SaNRSvrGI6qJKgEDEXq+bh81aHxRNfkgyOcrqnJdz
   Hbmlu7u0cB1uhRd9RCk9gHFkh7X6Ib00U95vNiEq63HitwKr+freuVQGI
   d/QUKcwobREIX7y/VyK75qOZ3MC0wsJPQMCq+IqC2MyN6t5/Nl4Omi06q
   N6HeoGB6yilCDgn3+5Bn5Z8PpWKl4dln2CK7QADyMv2ypsUJe7WQtIJZH
   ZqkhbAEirtvt0EpCREHQCoUvil2LZVxrlBV/+vFF/rdb9eHVSq1lgANdz
   zED/UoYrPZjieFhfd8YCmFrKMuRN/OiHGRlqjGvMx2S+xvhCZJgf4vH4X
   A==;
IronPort-SDR: Z2L2mcANPd54DdFxMP4wIn2rab3l/K7lcOZic8o8Lr8B6nqjtRBvh3aZ1YZTmS+jufrKXcFuVQ
 buRF7/Sh4x0hXPNkG3Y5NIKmRFUfExZGZP1URjBJ68RryaBVPjewnZyoMN18hv8X03YA8258Ha
 XMICgQfPdEgXisaoGLIkkV904Vb2RZTe9p1N8zBUlt/GJ2f/d0SzyUe7UUtOs+QmyKc3+u2njm
 fU17OZXpdBIybSkN0Usjp89DUl5QRY76knxmGZY7bfgYhKZ7UQa/64m/iFFImzAO34PUUOvDeP
 v6Y=
X-IronPort-AV: E=Sophos;i="5.75,436,1589212800"; 
   d="scan'208";a="253533631"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2020 15:09:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8qljQEfEp7E80iR/+zpppVDOeAHK8U8J1JI/TZLsnhgpMEqAQRjD3Zsr6xDPmxvMMlDx3OxHmpIHT0Z1Nxgi08u9G9KBbnqNJBJ6PCAVlDuP42VIzLycIT90lwLwtU28okdM+go5WS4gMVBy8CQwR8Pu3XMM86DnE6ZrwdOwwIYZdKpcB5xygXTRHK0SkVQm03XDkXkiuOffQGVSqYvYMgEVU+GtKswxe3H+APoKoy2GJyCe+zHjXQSYm4P8CoeM0DFosUiPVDwx/1zOQCQLcBQe0Tc5HelNzdTJExCLomm8FcCib1qa6BVtqp9kYSg7JQPKrw3kmQRMaNM+Uculw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soN1ZvSeihPa6rOMQWSa9ldUBVaxmQL7DW1+PG4F4ss=;
 b=gK3PhG6EYLYGNMtqYr1XjUsnZ9z7liB5k5UwWwDRVxQ7C7DbLWOgYLwb5T2TyZRhkUfheiU8a2VKfrN4RQzkxYnnoLUFM6L5IqSSpWMgPXR4YVvIpSSeFZQHRo8eavltlWz+JSmlMGkcdjlvRQGjESfrRIrOcF294X1sNIxWno3dbvA4TWjKhXHu6yu9qO490FaMrJTQqdqZDv4dTB03OBCJGxC3ZbTRwna2MB4Q9Dy8U7bCX+iUT5SBrhs/L4n5qOnUkpEvzflJg7DYlGF9LRvd/Z9PcZbMDo6jLJjUEO4QW3/UYbffhWpBVSZtYNiIp6ydsRD/aAleP6D5Y+cwUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soN1ZvSeihPa6rOMQWSa9ldUBVaxmQL7DW1+PG4F4ss=;
 b=QhDqxrBectsR5KBzWEGBy52vJbd3UUGMtr1LmpDFlZ0Q/sNDwIDPSJIDeSIZg94IkxYwB7+jIEXtL4//EVK9ez6JIn6lubSXS/lcGlud9BjQyZ+hm0lGm13bB/jHdzkY0pmDMI3thZvHYlIXiiq2BuDwbzkhGRTdtUH1G4bZ4G8=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5166.namprd04.prod.outlook.com
 (2603:10b6:805:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 5 Aug
 2020 07:09:04 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 07:09:04 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [RFC PATCH] scsi: sd_zbc: prevent report zones racing rev_wp_ofst
 updates
Thread-Topic: [RFC PATCH] scsi: sd_zbc: prevent report zones racing
 rev_wp_ofst updates
Thread-Index: AQHWamsoltYRlwenV0yPgATAXD6OIw==
Date:   Wed, 5 Aug 2020 07:09:04 +0000
Message-ID: <SN4PR0401MB359881F2548F5F9522E0CFD19B4B0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142541.17126-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751D3876B133B764134DED5E74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 218020c9-1d7d-41ec-9d06-08d8390e6ff4
x-ms-traffictypediagnostic: SN6PR04MB5166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5166EA7B273EDF57151BEBFB9B4B0@SN6PR04MB5166.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 49nYp9wJayxfFHo3/IpVPAV3OZN5jM16QKNnxOPnCj3JsyhQbnK/RpsxzYGXp2G1QorVlntcxRMewu2mnIwRvC07tZ35q+swXPzoX2WWJvlYbp5KE0XUlRKhY7fERSEM1C2zVUC/1rktP4v9v6AM3pkKpCaIo2tBiEINrjlTcj0BFhiUn6sygvijklz2rxB5lDJf1eUqUbIoDIQ0axgmSeLx48vhmHzLfDpwOjArisiXCopUaof1AfpHiRUjEgO+qRmKbmpGTAroNj1u5o65Kgb+RWWgUn5y7h+i2HvGiDwKeOifeng54EAXZATijbIwtpsuBlRMGjrT0DYigfnttw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(4326008)(76116006)(66946007)(91956017)(8676002)(558084003)(110136005)(86362001)(2906002)(52536014)(186003)(5660300002)(71200400001)(54906003)(66556008)(316002)(64756008)(8936002)(66446008)(83380400001)(55016002)(26005)(7696005)(9686003)(478600001)(53546011)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bnbuSb5eOteFu9TBxTMGJYtSkr92+Z+Bm36mrSHcHZJlnBj+b/OaxBrvfBnhtMMFl63BnM8OrtJwqMPiUoySjuKQM+kthRMDQFAfwuKxnzmdr+2pyxEzG7etN61jBtDo1PNc+zxf2L+ggZReXWeMfRRyC3ChOucpx080aXNykw9jF7K0auXHIaGRDuZ9RgEzVH9YKpTdAiSyqoTI8EnufLc3whsb44i0gaKfxlftPAqhuAq8p/AgNV8JWn8dAAkZ/3GzeeMB+wcHHfqtRB2EpLZfMKHzTapcGUyvJWlbRXYHe3d293yVZq+d+Q3FioF9aaN1k6oSpP6EwPNjNXAZ83TALN1JYa4KA2bRBGpRelrQzQY9sNmDETBmFSP468VmsHnhTHOzHdQR7+kIHhIEIgHDM74cRg81MSprZUu1+inZzYiha1a6+50NRCpzUHfH4I5o6UxgjgjFLcvEcFNeBqDd50jMWdaV7QEuzpUBr4AId5aIatwm/S5wSkoTGoIVGr4V/spJhl1GHcAPKlUB9/clOcg9PWwc7qiOVlYw/6jaexjM3rzGaGiaEjuG81bf7XuATctNLazAe/LqLb+ciXoxmwkM5IqkyiLhfNhvRIGcJawNuRquwIP1otl3ldIjuOmu3xdM3nnxZb3yiSwwHA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 218020c9-1d7d-41ec-9d06-08d8390e6ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 07:09:04.2603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBugVXa0Eewsva4fi1nDpaDNFGzlFODYWW1sHLRxHJke7tGVPqllwtfks/e4HkvU8xRgXulGC8JJsEKbWxIpwiZlJ9SGjrVh6eFOAM3Cbtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5166
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/08/2020 03:38, Damien Le Moal wrote:=0A=
> You need to unlock rev_mutex if unlock =3D=3D true before this goto, othe=
rwise zones=0A=
> revalidation will deadlock.=0A=
=0A=
Oops correct, thanks!=0A=
