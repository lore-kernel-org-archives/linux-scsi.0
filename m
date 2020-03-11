Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEEEC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13844222D9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JcjKDSPR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="a6pftpig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgCKGk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:40:26 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29153 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 02:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583908825; x=1615444825;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=U6eaKNk1AL5KKRiIpPxdAHVk/JfpXwNBslhXx3l3E2I=;
  b=JcjKDSPRpLSF6sYdqAEu5XXl5fxdouzYbV96IC2IOATht19MzQyDe/2K
   BZgDTM8Cy+MoJFexzyv2rjJVuqmNQyJh29+3sDGHEy0a/f9o8I2E6Zp1G
   0Fpln7YvkzN0nsCtw6CQgYa/AsdigAxaYEkJqVOGnOE1Bvm/tGUTGeEKu
   UfbLxPLNk0dvm4EUfcQeJP+3xjtTRdtrZuKN95cPB9AQ+I/lAzwtiflMn
   5DAhlPSKq8BQRgNPCBJEKYv3podaBfFagwJqAzpMp/BkNF+N4I/QCNywq
   vzE4+dOJ39DMeMydfkfJQo+N42siHUXLyNqHCbvui/u6lH3THWtcx8P1c
   A==;
IronPort-SDR: FRMughFgWhucMbAMVoJGNN8opZNoprmytH92/0zKyx89JOuSplV6IBC/fhiBEm+rDO+6fRVqtE
 Ksy58m96tDI8dUkessV/E2s4x6EWKSYYcTYMIfK/ENVUzuzHN74RLhutirVb9WCs07wiO2qpBU
 1FOGpQ29yMt0xy6urWRI7aptNBiajc3WJRZwy+t1GqWrJhp3NcdpG7oVLB8sOVRr7nkdULam2C
 YPy3mCWOU+uHACzjw5hc2fhHwrlZ+jOrye5on3P6t4A7hflBWngjwIMSv/5g7SDdjdub3Fu1Zd
 bt4=
X-IronPort-AV: E=Sophos;i="5.70,539,1574092800"; 
   d="scan'208";a="133594630"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 14:40:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8C+Dx4579MVk08DXgXVwHhY/6YSX3+h7WszPUrct+hyU2Tngne+6RR4xz1zVi0tBa8FZP7PWKNjfdLeVBmrC0eur0miC5JEYW/xTjo8/+tmrxT4C8Pp4ba5AVD+vboxkjPJj4qrNstgnug2ip7LH6U+vDFud8McvyGBjozgAmuQ5IZulMsl9vUMjG0uvAlFW56UTM3B0rwwwU6XfGM/NGfoXrdnY8IJe8+p5W5o6FACfK/deeDy2HVHQcLL+LngFnYXlLG/Zr2BN0pzS1yoF64/dL7G4cB6yPlfwWf1t2vOi3gXVzQY2ZUMJKAY8ezO0+yuvMYPVeDRjFJijUDihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEjw4Z3SJryvMqoFI4D8WYCfm6vDQjO10RgnK9J6iCg=;
 b=hqH6Uoi40ALvW85whyuLV3rehbnNZJcLTgaqUDz3I1MUfgRhTQLxKgFfKUUf/O+VbEYXJfrS8EMc7WMxXYtpZFzk+ByclZQJgILSA1t5ww/+YyAx0XbEbactrIUNPpNjDl06UXjeH15IHfb37mvdpou2sJq0Hur+27dGLegjIcHWqBeJRWk3J5DIxShXVcWB/tBGrGfJ2iaRJsCE0nZf/b5PPShmwsY1HxtDToxWeUyvziIPUj+L54beO4rFNtJzMQ8zF0L8TVKCSM4oMm4LcwIj2qU08zMl7bZ36mwLP1rj0eYui34StWovvFhYWaJHU17ALBunDjmCv1Nww6HYOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEjw4Z3SJryvMqoFI4D8WYCfm6vDQjO10RgnK9J6iCg=;
 b=a6pftpig2UxMjMUDH4upa49Amk9IDj486/0aRr+y9mZfRSGqYY6nbAgvaMnLb1u2GSALoRb39BLAbeFATEYdy27j29owXweX6G51AaMVurySx8PaGztkAR3ftsZ5VMuMGnW25cXT8eAwsNbclAt1MS/bG0TLBQhvXBmABropejY=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (2603:10b6:a03:10e::16)
 by BYAPR04MB5477.namprd04.prod.outlook.com (2603:10b6:a03:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 06:40:20 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:40:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Topic: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Index: AQHV9sDiSduaJQxZBEy62Q8TA85MvQ==
Date:   Wed, 11 Mar 2020 06:40:20 +0000
Message-ID: <BYAPR04MB58168DB7CB0E62C329412E3CE7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310164229.GA15878@infradead.org>
 <BYAPR04MB5816A4B727B954E1C409E451E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200311062454.GB5729@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fb72a76-8895-42d0-77e0-08d7c587118b
x-ms-traffictypediagnostic: BYAPR04MB5477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5477F81D9BCBECA906C103C2E7FC0@BYAPR04MB5477.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(316002)(8936002)(54906003)(5660300002)(66556008)(64756008)(66476007)(66446008)(53546011)(76116006)(66946007)(9686003)(55016002)(6506007)(33656002)(91956017)(71200400001)(7696005)(478600001)(52536014)(8676002)(86362001)(26005)(186003)(6916009)(81166006)(81156014)(2906002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5477;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XEzBrBfgi7dPAeu0lreyOKN9doTMdQR8FB6ScWTLt5m64oPZB+JCDaq/ICVxiPpOPmSuTGOliKbujvj14Khqj3sFvSeVU3+tOk2uJHQVhgX+sheJz3K/XNsyBT+Et6Ia5NHLBBt3zZF7nqWi1Prvnh1tyIFY8zgkBAIGFQv8f/3eU+fRtpx3uyAYE+EoQbaRTFrKgVioxALGy2OTkIjRbzrCxp9UiM1ltePXV7ZvaHCYpE7RDF5cP9XHXe57A+yird2HFk85Ib3Nl5BLjf08YO1lKG8Jk/fae5ixz3Y98HYMQpP3sM8pFLWm9mndqcNgBNTBesNH4D93Vn0nDvgjmNdfi0wDohyyctQ5+BwasnBHnrIAOjkzHEdeT3ujLFA6sKFyrfUka89Rb27Vt+z8RVTnCVtFwlcCIwhEFQxZGR2N8doM3Bkzts8i+RvPGxxd
x-ms-exchange-antispam-messagedata: ZxDnCXKORI7dgf79n5L/Sv9WsrPGWlKZH51u2OBcNCiP8QJdlv/d87XTSGDCnQuJmP9U1lPCtI+1/Xu/JZ65dLL8YJCmQEfCzppbMxPszfHNIe/qN2nOrIIs/tjycBOTkIYJLjZPTRd8WuX8omhyvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb72a76-8895-42d0-77e0-08d7c587118b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 06:40:20.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3LdCASgbEM4gQagJ303C2YG9u6TdGgPoJqzJDYbFVnaluKLZxH5IJ8eAHcY/ZgDxdDW2zugSHoKH4XKn/MMdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5477
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/11 15:25, Christoph Hellwig wrote:=0A=
> On Wed, Mar 11, 2020 at 12:37:33AM +0000, Damien Le Moal wrote:=0A=
>> I do not think we can get rid of it entirely as it is needed for applica=
tions=0A=
>> using regular writes on raw zoned block devices. But the zone write lock=
ing will=0A=
>> be completely bypassed for zone append writes issued by file systems.=0A=
> =0A=
> But applications that are aware of zones should not be sending multiple=
=0A=
> write commands to a zone anyway.  We certainly can't use zone write=0A=
> locking for nvme if we want to be able to use multiple queues.=0A=
> =0A=
=0A=
True, and that is the main use case I am seeing in the field.=0A=
=0A=
However, even for this to work properly, we will also need to have a specia=
l=0A=
bio_add_page() function for regular writes to zones, similarly to zone appe=
nd,=0A=
to ensure that a large BIO does not become multiple requests, won't we ?=0A=
Otherwise, a write bio submit will generate multiple requests that may get=
=0A=
reordered on dispatch and on requeue (on SAS or on SATA).=0A=
=0A=
Furthermore, we already have aio supported. Customers in the field use that=
 with=0A=
fio libaio engine to test drives and for applications development. So I am=
=0A=
afraid that removing the zone write locking now would break user space, no =
?=0A=
=0A=
For nvme, we want to allow the "none" elevator as the default rather than=
=0A=
mq-deadline which is now the default for all zoned block devices. This is a=
 very=0A=
simple change to the default elevator selection we can add based on the non=
rot=0A=
queue flag.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
