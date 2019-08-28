Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C6DC3A5A6
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 11:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87C7222DA7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 11:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VSPzLLfP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AqW+810T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfH1LIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:08:36 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29921 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfH1LIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 07:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566990589; x=1598526589;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=l+dfK9U4Kr8UyinI5zViw2FBUdjUghyYZNdcEXtl/yw=;
  b=VSPzLLfPl1PPbeJHtKIFjf55AcCRG3gSCue0Lx05ygQz9gkRAC5ZTUB0
   bdCrUjPRwrzYb6r3/rNpV1gyp2DW6eYCTVkiFIegEVh9c3THDMmVTEoxI
   KbtXVCdSO4oho8nwSAH/XkdTpgfe+6x9Z9vU8XjcMMf5GM0psLMQ28eiV
   CwPygjo+i/Da7UDf7VvNrOPdJbSiYTUdIE6H+csD1ehkR8sEi/bvAnTlZ
   Fg8zQA1IWLcsOPFKvdhl+4kxqmnOonMIS/eHWpYUusPKjEg2IXjhHQh1+
   0d18aSA4bdWDgYE7IzoRm8eiZwtUvGe+JZ56PdEmNcrhkohGrAQe9PYAJ
   g==;
IronPort-SDR: pbj2mqWtBTjpiJD4K/4Ts6tL1u8CoXeoqFVzTvGsiKPfofFB+DE7ES968yfMpZHE/0p8+m1+fy
 oI3DJPdYd1vR2dZLAkyBi/wmtUlFc2/cYGi0bZatv4E1paOo7r7mSUmTgPooTHmV9aORVhE5+8
 D75La0KptV1+IMzt6pOOgGzpLsUo9o/6IJaG4cUiUtaA2TLhYpFNZ1y0I1wjo2QoG7q0PbT2GN
 lY9OJO4npeBtSrFBZ8xkF4fh/foQdHwKHipL1Dd+tMVUOiiJB6sxY5u3Q82yk93+tqZQVTTG04
 rv4=
X-IronPort-AV: E=Sophos;i="5.64,440,1559491200"; 
   d="scan'208";a="217361676"
Received: from mail-bn3nam01lp2051.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.51])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 19:09:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiwbvpAzDGVigkYG8DU/96Emvk/X9jxHaAfv4Ic1GJ089EAenRBITMUhpfdXVupblekKbl6rEWcQkkruqNKLlPF7dgz/HsI2KL6lnO9AvFNeUePdf+lfGLVWcXedPZ20iTyr+tLxMTWimu6Bf47HzwkKh8Q4xWXtaIF5cb0UFds0UxusemdT/pMVIfLtd8hp2IrEmb4sqgLcqYI9mGaKv0CCIg42D8hNInU6lOC56L6fQ0fWHpeW3D73L2AWI1CoMNRYrVcNypHY3USsY+ClFAwbjpKsvu0DRreaJ5KYSWgt1QbLa2oZ+i0ksu+8Vm/k4djektm1BteVam+sS/zJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+dfK9U4Kr8UyinI5zViw2FBUdjUghyYZNdcEXtl/yw=;
 b=UvlvC2grvSLo5zrLse4biXbcBt9wEOJiMltVdeEm5zah2IBosmRUkj3PoiI/iGJj/aWr/hCWEC/0bs2tiFSm/EUgL+vzNJFy4XelMFVyi2xgFAUZpejD9WxpXw0hc7VZgtOylg/ZVsO4UNd5Kki/1XLoq/qR54Tqwu8yhD1w1BkEC3pM7Zk1HmQytAX1H1NEQU7v1mqS5anElVyRXnCnRDYA2U8MMe92UcgNInYIYLm5cm+4zmpx7sZycWFGCVZbjupeRQ+X+xDZKEYI3eHdQqhrkldzctRgvn5ghhWWTIeHNyW8f23ICR+ttbGpu6Th35TLTivQHB3x4/g2vD1e6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+dfK9U4Kr8UyinI5zViw2FBUdjUghyYZNdcEXtl/yw=;
 b=AqW+810Ts212RL07EZ6S9SwaK6DxDcpYPzfcpwUwUYqduGM1XVbl69QZN+UstT54/Jlj3I0sb6Bq+xWXDBbNBxXUMbKbCE1ox7j2KHSj8z3EQBI2uonPZAvFg0AFs1kwu+t9txUOqOgh8lK6/e6tQWQwdjidmVMAy85QE1F6opY=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5512.namprd04.prod.outlook.com (20.178.232.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 11:08:33 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc%7]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 11:08:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/7] block: Introduce elevator features
Thread-Topic: [PATCH v2 3/7] block: Introduce elevator features
Thread-Index: AQHVXUh8r/qsW/a/2UuODIWpedLL0Q==
Date:   Wed, 28 Aug 2019 11:08:33 +0000
Message-ID: <BYAPR04MB581631931C13FD237F3F932BE7A30@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-4-damien.lemoal@wdc.com>
 <69e86ed3-348a-ac8c-d3ac-550fa8972246@suse.de>
 <BYAPR04MB5816FDDCF4080943AA408956E7A30@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a0275d93-0454-3cc5-faf4-77210ac03928@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e95e30e5-95ba-41b4-6753-08d72ba81129
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5512;
x-ms-traffictypediagnostic: BYAPR04MB5512:
x-microsoft-antispam-prvs: <BYAPR04MB55122244C7C3858259BE5508E7A30@BYAPR04MB5512.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(476003)(81166006)(81156014)(8676002)(76116006)(7736002)(2501003)(26005)(4744005)(76176011)(256004)(66066001)(99286004)(2906002)(91956017)(229853002)(8936002)(66476007)(66556008)(66446008)(110136005)(186003)(7696005)(64756008)(66946007)(316002)(74316002)(6246003)(86362001)(53936002)(33656002)(71190400001)(25786009)(5660300002)(305945005)(102836004)(6506007)(3846002)(53546011)(6116002)(6436002)(478600001)(55016002)(9686003)(446003)(52536014)(14454004)(71200400001)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5512;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dR67crq45UsKO6GI6UxlIBS48+8CaBvym4+qYz6C5WFLPNOgTdUdoITVGDsv8TjFM55MU+GagPpfLNzGZL2lJOJsaZ/MRh3x0WPtNlYO3L3u+kN3xrmYMwmCEKrry8lQjlkxz5/UDe/rhEbKhQZWptR6byvdxCWG4h9HYpAqCmWhEnP8LvXm+D0Fl+mbwSCFdohafZ3E6B2DGMRsQ0cBufOPVASbTVbAMPpeJBkEKHiLx0RyXRzCa2ks0QQhgvpXp9VIcibCz/YagF3O/zz/eta6m/IOpl43olFYg9VpnW2dm8GauIm60yBbvHDxqv4MmAN2satoTnpB5EcbzTo7HvhyxXYhnCTd6XjpjHWigiC7q776DDkFtF45pK6r9Zv/ztsxrszqjHPvQ1m4hvuVAK3rLFAViXTZPoux5HMrBEE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95e30e5-95ba-41b4-6753-08d72ba81129
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 11:08:33.6741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wp8oPutcabqNi/rOtaIYmbT+bGE2xA/Wx29SoY6IJNEBc2bsiSd0RUVqlphL3vghFN611i/7OuqgYYmlqHSzMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5512
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/08/28 19:43, Johannes Thumshirn wrote:=0A=
> On 28/08/2019 12:41, Damien Le Moal wrote:=0A=
>> On 2019/08/28 17:16, Johannes Thumshirn wrote:=0A=
>>> What happened to my review comment for v1 of this patch?=0A=
>>>=0A=
>>=0A=
>> I merged the renamed ELEVATOR_F_ZBD_SEQ_WRITE feature into this patch in=
stead of=0A=
>> following patch and separated the nullblk and sd_zbc changes into other =
patches.=0A=
>> Well, at least that is what I understood you wanted... Did I misundersta=
nd ?=0A=
>> When tired, my english becomes fuzzy sometimes :)=0A=
>>=0A=
>> Please let me know if that is not what you wanted (it does seem so).=0A=
> =0A=
> I meant to useage of an 'unsigned int' vs. explicit u32/u64 for=0A=
> 'elevator_features'=0A=
> =0A=
=0A=
I changed from unsigned long to unsigned int, which is always 32bits on any=
=0A=
arch, no ? I preferred the use of unsigned int over u32/u64 as these look m=
ore=0A=
like low level driver stuff... Did I miss something ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
