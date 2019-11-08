Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F122FC6195
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7740E2084D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 18:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aVFm+Dmr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XS1qXdqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKHSrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 13:47:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23396 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfKHSrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 13:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573238832; x=1604774832;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RwP0sMYQIQM81rIW6yRpa/tfUpkaKBTx87CRme6zbQI=;
  b=aVFm+DmrggaAj0iw651vck872wLy8Zwcv3NSlPToV1+Zye/omqa0Oz32
   hLPD7gesv7K+IETzZOln8bhbokskj+ipHklxAmKrB85sGE9EHhdgDFktC
   3yDHK1AHzjkS7rNGI//Q34LyNR2R1pqmRehoTq5/KC7rF8TH+cjWZ0MpS
   OB6AvsxJ8SEHtk5lTvdLY8czGkEMQnRTfkgsjXzk4J8BgJq3F9UWShGjj
   M/qiIf9uKx266KlInPmNcnsz/q8kLleD+BYGP8VDUXmctbVTZShNajb+5
   MYzEgzkDpAbhbwl10xoNxozMLqd8BN7fHK99kq/sk0ZxqP1/33HBSJ4vV
   w==;
IronPort-SDR: 86Xgug5q6WhBZF2AfFv5QkxQaOY2UFgehk7xGLHHm5aKnSmJZjMzsJAR/vBcK2suGVP183p40q
 lwlkomhBT8uV6+o3H2GSBbJuvHba1jEtY/4OIg3KdMUstCxg2Xmwg7v+sX7y1phixbghbrpc6J
 oSyPPJr/OF6TxnozDpH9AvFt28lzILQ21DtaVxwZogl5bkQ8VYQgDlhhG10PDfsgFQRJS0ojZS
 f17cpJXFDugpfl+kEmN6ayReSzBZP3uXTIAplIHOGiTx3WZFtSmrtqRNnT95FGvLoKlPoa8aWJ
 UO8=
X-IronPort-AV: E=Sophos;i="5.68,282,1569254400"; 
   d="scan'208";a="122523772"
Received: from mail-sn1nam01lp2056.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.56])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2019 02:47:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZfTT7JhhMXLwi6Uke5GA2NIfd7WvBqgjr861aJNo1du9qc6FF8gxXIuWMGzRK5CgBAbupaHKcEZjK2XrZPsWO1BtvAficNd1iKwwniAMjy6q8GyAB0Nu3OvJWU0PY2HKwQLKG6svwy1I1khxGcWFDz22pJ1gAHeXwX64BK3Z8EJWaddM/dNBMhz7VyzILC/ohZVR5/j2wIbN3UCalIeVzg9q8euubTZa0x0Wu9OFwd/325cVhrOuXrQalh5BVCb861+AGJ+upg7POjBJT2DJU2+I3UQn4Oz1ybix2LMgDTq95N1mHTVYWGM91R3J1re7fSgFYjoBJxq0mKGYO3LNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwP0sMYQIQM81rIW6yRpa/tfUpkaKBTx87CRme6zbQI=;
 b=cVJOastIGWwVaS2yMBURvY0IVd0KEx6cM04AwHFvNt/Fv9ZAuycT5Dv4YgXxE2QdP+uwImKFG85W3uJlW9NoEfI9Kzx9Hz/7dwXHaHFuEW1mctUv4JlLCPcEKcJ7hvq3iZc/hKfDpcXDrXXqMIU7750VzoBA9Dj8O8BmJi9jw9S0AaVN8+SgxibThFJwLNkmIj+0rp7Na1SzhqeV+SIxHYFA9DSSuJ650TYNaG9ko38n92abOSSPLHzCXP2AEGbZOkQv4yzMktygp/tftpwpVat0BWiy7OgSkbXe91gzYn3Kigv9dSnk+wBVtrf15PxDAsOONfaXExacLhtLvabozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwP0sMYQIQM81rIW6yRpa/tfUpkaKBTx87CRme6zbQI=;
 b=XS1qXdqWUjf1Z+BSbE0jemiJYN1q67C3LXyqAZDYf1pHjwKn3OOhb+rxh+TysNxKPEOE0g6lYFsA7SEzYx1r4GreLr/viD/YegQB4TSKzW9JYx6FW/b05tHbZ0k/F5Q+2FTF3GcSHwYvgjSMErrO7dmO2003fLIt9X0BsCHDjQw=
Received: from DM6PR04MB5754.namprd04.prod.outlook.com (20.179.52.22) by
 DM6PR04MB3993.namprd04.prod.outlook.com (20.176.87.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 18:47:11 +0000
Received: from DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04]) by DM6PR04MB5754.namprd04.prod.outlook.com
 ([fe80::65c4:52fd:1454:4b04%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:47:11 +0000
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
Subject: Re: [PATCH 5/9] null_blk: clean up the block device operations
Thread-Topic: [PATCH 5/9] null_blk: clean up the block device operations
Thread-Index: AQHVldfcI4rsOvEhuUe6UgaOW5UvvA==
Date:   Fri, 8 Nov 2019 18:47:11 +0000
Message-ID: <DM6PR04MB57549851153D90314D5C36C2867B0@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-6-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7de547b0-f13f-45ab-ac0b-08d7647c107e
x-ms-traffictypediagnostic: DM6PR04MB3993:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB3993905385A545FEE6181A65867B0@DM6PR04MB3993.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(71200400001)(55016002)(26005)(446003)(9686003)(102836004)(86362001)(53546011)(2906002)(3846002)(52536014)(66476007)(256004)(76116006)(5660300002)(64756008)(305945005)(91956017)(76176011)(6246003)(7736002)(99286004)(6506007)(6436002)(4744005)(2501003)(7696005)(6116002)(186003)(14454004)(110136005)(74316002)(478600001)(8936002)(66066001)(33656002)(66556008)(66946007)(66446008)(81156014)(486006)(8676002)(476003)(229853002)(316002)(81166006)(71190400001)(25786009)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB3993;H:DM6PR04MB5754.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxuK6StXfXwohuD++/710laaB337KuMBssYn2N4gFPhWrsyq0HKGxmKBfY3ciIpmXZrZXmmMjeaYgjGkhnV9tVZpZ7wAec36ZBU196vKOUCuPeqJw2I4koDvphm3NJM0GRyEm8sVjcXICFI3MVPOsuqSBvhDefBhF0G72syfh3pwtwhXh2DAGlUPIxExhlwY70ypBBUjJHlbB62Ay5Yw5V/1x7HBl0QOoHB/GxWumwPGegxu99yb+doMSsb8Lbd3/nwaZ5Lmc4pducMcvmBG3dY67ygJ/qDFKp+eoQPC0mR/7NRftmUd69UpW7+FimFBEYgj/0byOxWPPE75IGgiHy0PEJlNgKhOvBRfiyRwxsGDOQg1wvtT7wBUAQrhKFpXap6v8tHseFdzRhBp+HoFugYk5h+bO8x7/k84A+6BZ8hi15RvE+3PRm2cC1TZEpvF
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de547b0-f13f-45ab-ac0b-08d7647c107e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:47:11.0494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6d1PxzOIRnANSz6qs8V4Qlpj1pTIoKxYJ9WFu1VhhvIj4PKgQy3AGGv6NLJfi45TowCcFyDi524+7zwUL937boPVKQiEN8hC+urVG0x5tyc=
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
> Remove the pointless stub open and release methods, give the operations=
=0A=
> vector a slightly less confusing name, and use normal alignment for the=
=0A=
> assignment operators.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig<hch@lst.de>=0A=
> Signed-off-by: Damien Le Moal<damien.lemoal@wdc.com>=0A=
> ---=0A=
=0A=
