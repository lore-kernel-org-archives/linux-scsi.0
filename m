Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1121FC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E7B21D7F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JxQubE9y";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="J7XAz3YW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfKHSrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 13:47:32 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23432 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfKHSrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 13:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573238851; x=1604774851;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=1ReDcCz3c2YGvr6A5NNr6MwLnjLmHXbmnIWRtk0Ey8c=;
  b=JxQubE9yPZ8pYTtBZAaHISpNgHdHqLAGiWl6lXWCNJC7wzbmgbdes23N
   GcVdso7fJvklsxUnxf95H+o0C9ad8LI+91M+MTUISpKdd+0guI3codAya
   B0/ElYfkTL8DbsKonpGaVE4N5YLAvAywjku8WxAtsEeLFL67Cp2LbDD2q
   DbKwQmpRuHt5EqzzeopU/3yHwtQwfeX2sa2Sdj9ceGhfu+JubbMef9TUT
   cQCE78ILd3VcUMI04uc4xVUmQqk7AY04dBK4fspuhyeyT+AzucmeH161Q
   SRpK4dHE+5x5H8grPXD2jutl2WtZw9dqnaA9odYGneKH0TIpW5HrEFMpO
   A==;
IronPort-SDR: disVkONpimVkV+5nONEZ9mGi6c5MwklkDmknR1enp39E7OUqsW5qAwFf49N5CjQRrAMaWgvy7P
 mZnGbpfL6LGq06q3yPZruU0PeKhP1KU5eqtWckeiMjpQdr0DcFPXXiPbwHNJIkeF86QtJ7FPnW
 cd9/4Ol6aZjWg+aNmC6+Bc81M/8gCwpd1k4HDQO2VrUe07cv71e0NFrif7e2pNgN0D0JJ2KXXt
 KO5fOJw3dQaMZt9xgLWFLnchFe5wRRryHxlAeh6O/WHL97o7/5vyTYP8kQTsMIwnZyEuEmp9qT
 4y0=
X-IronPort-AV: E=Sophos;i="5.68,282,1569254400"; 
   d="scan'208";a="122523783"
Received: from mail-sn1nam01lp2058.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2019 02:47:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvGP1+kK3dQAhYbaYITlJRa0dJeeaUvdfCMe/f6JMchOy8hAzozfcXdHxoUKxUAywxXKJD4tFHOz87/I+1isxh1b7382lb0gU+ImdmY+YAjLTKdoKhX2fQbQuoxxDJpIBCtPuUSf5nEagFEeHAQCog6KolvGVxEYMwSbf4bkmfEn7H1tRr/FWurKoQJLiEOH2Epxe0q4Cgitvr3SwgvYrStGPCPARe+IVnGLkzF8u0ZzX3BqUfyfII0fknpeNobpRyjDBYdanHmeH8w/P+X4T6r+QRNHtNM0TAyipOvTtHPzNoh4Jysdjl1xjY00cWcYpt3Iz/auybyAD98uIO+X+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ReDcCz3c2YGvr6A5NNr6MwLnjLmHXbmnIWRtk0Ey8c=;
 b=j3bWzY2e0V5JpJmdGYqUv9Fpg7s+Czg96WTUpQtSC20dZVaqL+roIUeo/vARtG1XkJuUCivx8L94+v+VFzaNSl5OpSf6aFSeJdLPUaCuQ/jPP2iOUjOCpxgNbGx6D6fxDsTZ8LussaEtq4oNTDXqiO9XFgAFd8ZZb8n/DjBLLFWWL+HKLmf+GdR5Uw9NBnBFiN6kzsWEWm3MQroGuOI9upn5xM7jELKnYgkMfGomBA9zmXr2wEWvbkackOY5v+XnIo3PJiBHV/Q2BREuQR1lXGa56tp6mQ8UJpLMbdJ/OPqwHMOcFt9qEGqo2ViSeLP2tVyK3xnrpB2+jD6qyrJHYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ReDcCz3c2YGvr6A5NNr6MwLnjLmHXbmnIWRtk0Ey8c=;
 b=J7XAz3YWTelbONBA/0LCu/I1oKswqUgHCrVamfMJHTHv0jFrdnMDk1EBA1F1J8BRI69lXqi704Rxiox2qV91Tia+OdboxUtekxsYG0q7QUnZ1TdLEfXOm+juYxVeyR8WUjHWAnpqlYUmAp3F0QKUARIXc5WFAzNjA0HNzlXEGa4=
Received: from DM6PR04MB5754.namprd04.prod.outlook.com (20.179.52.22) by
 DM6PR04MB3993.namprd04.prod.outlook.com (20.176.87.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 18:47:30 +0000
Received: from DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04]) by DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:47:30 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 6/9] null_blk: clean up report zones
Thread-Topic: [PATCH 6/9] null_blk: clean up report zones
Thread-Index: AQHVldfde8HAJMYLm0eJIjLXj3HMAw==
Date:   Fri, 8 Nov 2019 18:47:30 +0000
Message-ID: <DM6PR04MB5754D9A214040C012CF475E3867B0@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-7-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 886f1a27-a8b5-4e62-ec1e-08d7647c1bdd
x-ms-traffictypediagnostic: DM6PR04MB3993:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB39932F80520D57A09F1F0D07867B0@DM6PR04MB3993.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(71200400001)(55016002)(26005)(446003)(9686003)(102836004)(86362001)(53546011)(2906002)(3846002)(52536014)(66476007)(256004)(76116006)(5660300002)(64756008)(305945005)(91956017)(76176011)(6246003)(7736002)(99286004)(6506007)(6436002)(4744005)(2501003)(7696005)(6116002)(186003)(14454004)(110136005)(74316002)(478600001)(8936002)(66066001)(33656002)(66556008)(66946007)(66446008)(81156014)(486006)(8676002)(476003)(229853002)(316002)(81166006)(71190400001)(25786009)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB3993;H:DM6PR04MB5754.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hhMlDObvQsTnMApHfvrnflInXhg2RBqj35e5KCmV2MQfavQOcVJSprNcH+Q/ivZpc30S0HiLKpveqLwZDwWn8G7/qT5z8kjbrSAQz/ubMCF8NU4Fe6PHPmsur4+RiY9OLwsBxuwb1kLHatk3vmXFFiMAzftGpSsbWdCkZiJnRlIDiO7xO+Ex6k+pHpUtJHnQkX3NpCLNAOrmGmgnNBXXDpRNXVMxM4QyDq+Tfu1e0Ir6gT+rqyuUuC4UUR2MWcSRRU5YP2i61O45xI+k5yVa974OnbjbJm6RYcFLZTegkdsd7AdbfcOi7Ugg0zw3BGpTfXazGG6BlvCEVp0CdIU1KhajH0RNoDeoJzeCB/3uTgMnyFzPyviZUShIXM07xRb8GVY6ezf5y7GGXizsJ9nWfYv00lUxOTk5u97IKwWZITpT3QBOUME13WTgdV7M+ifO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886f1a27-a8b5-4e62-ec1e-08d7647c1bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:47:30.1336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zR07IsicZaVwQGBgTwEg8+jr7oSUgMJ/++3rzMDgs6tH7RVP4OXuo5cxrTaIneWP/U4uAfHHAqsY7xMgRM8q8I2zAXCneAVsiPTxWZjd9/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3993
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good to me.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
On 11/07/2019 05:57 PM, Damien Le Moal wrote:=0A=
> From: Christoph Hellwig<hch@lst.de>=0A=
>=0A=
> Make the instance name match the method name and define the name to NULL=
=0A=
> instead of providing an inline stub, which is rather pointless for a=0A=
> method call.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig<hch@lst.de>=0A=
> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>=0A=
=0A=
