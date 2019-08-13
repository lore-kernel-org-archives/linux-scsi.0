Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USB_DRIVES autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2978EC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E36E520673
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 10:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k4ODSlkn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JAiaYXuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfHMKsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:48:45 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:62468 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfHMKsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 06:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565693325; x=1597229325;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=tFcrDIfCnl/LRHUQGHVYS0HSJ0mIT3UIg4cj200OLCA=;
  b=k4ODSlknPQzoVRid9wI2FMsV6EggOygDI3FUc4Dga+GyMrnW/yGSACSh
   YcM3fyJdqpVlKgz89iXy9HPpUaOXVhnwf5o/MYG29UcgLM4Ku36ywcy0I
   qm+W6CacdRt1v/6Gjjw0pTpCg4u3bbiUCTIYyMEA0lUHSofMBAufIi1oD
   3fpqHDgho5bI+c/ZTfyoq9VhpAMlGGhlYreHsPXbovQo2cR82ggs+tdG0
   lVWOz8NWFKt0R1ot55E5EtLM/k9JXxRMcgiIQlqVHxKVjuFQD6tYhazvy
   TlgHau10AfuTCkKTUt8B3pfMxGoSbgBhBw6RZudYkBUkoOTBQW7JUjzv2
   A==;
IronPort-SDR: gfzHqU+uNocj1Gs1ih1vnphaLRRlOCOmd6t7J7ROIwBdXTNdfFZZfUjMJrvGkKWJCpGiDLPeyr
 Zrf4lZDSxpNxc6RT7WtsunufDr1DeCJ1DCzwAn/iEblNn92ezywTMn6ExA4SdfGEffYnYwEtC+
 hCpLWTmjLobB1T/uohxkHxXs3knclKTJbjqUIRcJbm5qqPvDwmqNGq1iyhSggfZwjxbKDlTUKI
 4nor/OUJ/f/Zf8ZTw8AkUr4RzBl6Dz4XQSjcLdCcB0w4hwh4XLndhpdg1ZAkUBOcuWAtIewO0r
 aEk=
X-IronPort-AV: E=Sophos;i="5.64,381,1559491200"; 
   d="scan'208";a="116668737"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2019 18:48:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdiNK4hjHnD2QurqPaPiJO8nwxFjGYErdZAdsy+VIe3PtvXPnZ9PS45QKroiCga8/H8BGSr8TQyIVT17F/uZWCAkJEoOU4o15+LxRYtjhTubIxg8bjabDAKEMd6cyr6Q3fDMecwA9lhEgYOhfvR/rV9Zy0RCehABCbAIN6oqRsQq06XsuF2StGHNUkxlJqg9py5qrvcXFIRd947b/FYctr/C97TA9agXyhRJsXcQldpbhEtx0GxSLM4gikIgAeWhsyAWmWZUa589RKCLf0J3l6lhAphRZZddL7j7P/8atZ4G3i22rGLTQ9F7oaJzZU1emV3v8LrVInXS1LJ22Y9O2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIssqGaJpLkzxwxjuHDkdFP0WtsmkC6Soq7bQ1FxEnA=;
 b=G/Pfbs28zNOkEKGVmNLiLjAtLcJi+v0JzHk01JwPiB1nXCHNiCSUbcBdON/KbVNbpskP+5+mIla4gmfC0TX9aavnRM4NPhfBI9r+vBCKabdKs4M8QeNMs4e/q0KEXI+kdWcK6gbOrVV8F5DgM1GmbmGESeNQ2F37sA03iqLm1dawuMiLXQIawg+jjGdxm3PeMvoAc4nb0lKNup+JQNYluRS4kpaljwuLTuUCZgwEig6ZRI/Q+0K2x9ju2T5eJvInodPaS+pgG9hTL2LnggIA+DTtBGgeU9kwJPLiYHcPYTNf/WRjWfpUaPwHTph+gSEXXw4NPvcY4bflj4SCtjEuWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIssqGaJpLkzxwxjuHDkdFP0WtsmkC6Soq7bQ1FxEnA=;
 b=JAiaYXuqJXS4C4mXLsV4/yvaElMZUPsqg8mLrWuFizybYkF/HAtLIYbOLoJecE2LUuTzMHSNtzqYMmnKLUsqb6YTuPipyqq9dFr860tt/Et5Ku5ErTwmqXK454yT/l7DqwKqWJWi00Oa/4Ux1zxCLZn5xS6b3pSKQ1GgWxemq3U=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5733.namprd04.prod.outlook.com (20.179.57.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 10:48:43 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc%7]) with mapi id 15.20.2157.020; Tue, 13 Aug 2019
 10:48:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>
CC:     'LKML' <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Thread-Topic: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Thread-Index: AdVJ2z/+9mq0jIkOQpG4zabX2Rwi3A==
Date:   Tue, 13 Aug 2019 10:48:43 +0000
Message-ID: <BYAPR04MB58166DE7AFE1081CEDF674BDE7D20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
 <yq1ftmcct1j.fsf@oracle.com>
 <002d01d54dc3$17c278c0$47476a40$@lucidpixels.com>
 <yq1r25p7qzp.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [12.169.102.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d12531a-df83-4c98-a30b-08d71fdbcf3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5733;
x-ms-traffictypediagnostic: BYAPR04MB5733:
x-microsoft-antispam-prvs: <BYAPR04MB5733934E533798BF8EB82428E7D20@BYAPR04MB5733.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(256004)(478600001)(2906002)(8936002)(305945005)(3846002)(54906003)(446003)(74316002)(86362001)(110136005)(99286004)(486006)(476003)(33656002)(6116002)(316002)(66066001)(66476007)(66946007)(102836004)(7696005)(7736002)(64756008)(76116006)(66556008)(8676002)(81156014)(66446008)(55016002)(81166006)(71190400001)(6436002)(6506007)(53546011)(229853002)(76176011)(25786009)(71200400001)(5024004)(6246003)(5660300002)(9686003)(4326008)(186003)(52536014)(14454004)(53936002)(14444005)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5733;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r0kmdnmkMsRLgezggxVtrvGq5j7w9A1WrzM5uvW24zU9eAsNJ8g0+2Bgm8g6n6hPuEZ8WxFaIIZbMkwl9UXjTrR4SlmZM9r5kasz7fgQTBlKNTbcu8NTjSRg1TaOKMx+KjF3BL1ZhPprUIxlMGlCqVxJPKdNll03HmNKLuEMxf4KpQFMnhH/7yURTz2rIUgrsOQ1J43v4uedlAzDv2dNsWfSS12OSyFEBmdeS5UeYgA/EqDbnK/QnuirWFEa4pW0NBrCq9ZVaOo30SFgafK/oCGVeEl7To9Zuk8IOeA/IeWBZaGjhOwXcRpHlG0MaPvbl9nSvUfajiv8P4cFW/wy0N66Ml9+Xe1AaCxxn8Qm4TtU7sMCq4vZezVvkkKEYOjI/act6Y6WXRybSkPmvQ8zd/JUN0kl/eEy+sVM98N71J4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d12531a-df83-4c98-a30b-08d71fdbcf3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 10:48:43.0441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rV6eXT98U26DT1zyxWrzYqbb4gY8pP8YAKNN9caYDy8tpKhuwruqQ6nhDpfMmcMFc8pz7gxbNP1h1jAwbwbVMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5733
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/08/12 19:12, Martin K. Petersen wrote:=0A=
> =0A=
> Justin,=0A=
> =0A=
>>> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back=
=0A=
>>> and ran some file copy tests and was getting these warnings-- is=0A=
>>> there any way to avoid these warnings?  I did confirm with parted=0A=
>>> that the partition was aligned but this appears to be something=0A=
>>> related to the firmware on the device according to [1] and [2]?=0A=
> =0A=
>> sg_vpd_bdc.txt=0A=
>> Block device characteristics VPD page (SBC):=0A=
>>   Nominal rotation rate: 5400 rpm=0A=
>>   Product type: Not specified=0A=
>>   WABEREQ=3D0=0A=
>>   WACEREQ=3D0=0A=
>>   Nominal form factor: 3.5 inch=0A=
>>   ZONED=3D0=0A=
> =0A=
> Damien: What can we do to limit the messages in cases like this? Would=0A=
> it make sense to make the residual warning conditional on sd_is_zoned()?=
=0A=
> =0A=
=0A=
Justin,=0A=
=0A=
Can you send the output of "lsscsi" for these drives ? I need the exact dis=
k=0A=
model ref name and FW version to see if there is an update for this problem=
, if=0A=
it is a known one. If it is not, I will signal it and get a fix started.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
