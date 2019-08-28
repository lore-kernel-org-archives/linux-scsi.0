Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2EDC3A5A6
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 10:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 560F122DA7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 10:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m0dMBS/N";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uvVLqRdM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1Kld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:41:33 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8396 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1Kld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 06:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566988893; x=1598524893;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=FNlvVja8jb6INyf9hhtRHj0DjFjyaZFsvYtJFhTyrow=;
  b=m0dMBS/NhiQE2ea8d2N81LKMpMJ4tg/ouw6ymtB5gBUhFVaui+HMQk/1
   oFEfaJ7HgHpupGMNH4bvGMMF7xgLJ7DUjDp39EE2crt/P448R+ilAuyjM
   58IRdBvadTUSKxbpoFG21PzS1K4+oIBgPWXQRJFsiwzJ6pG2afUU7eltK
   /xA0ef/dFxrndiKg5i1cxiC1nj0bK0cw2twjpEEyGDX/gA0Dq27ijqFup
   A8xSqbHItLcH8Uk5RSl4pcRDlamt4b373zCCElv22bdPvt0p/XCA2rlTK
   G0/PHNBWc2sa1DArzLpuRrwM8QGMkmjAb0GlBnOyTNJLJqR2G3VqgXUqS
   w==;
IronPort-SDR: MnUPRS67qlZJxfmMALf3fQdwRKxAmAt2KIwIk6vFY7G4TLZYLUCArDfP3bqTBnlN86eh4TYPdz
 abB9choyPiw++Qv5YuvXz4nfqf4ZphiaJawiVKjsQH5RMsgvBgph0M/2rtO3gNC2viM2XPG/Uz
 GjexWea65n/NA2rmJbAmhftrMV1shfpS2qZk+OlTsITPNsOHVa600hG18n/wjcbxfW4cRtZyjA
 oOBLDSRjwsW3p8dfB4EGNWgHGQGkfEfOA+2qzGv3XbL3cGTzdMzw1lamzO7MSWZHKfD9zV8hJO
 rQg=
X-IronPort-AV: E=Sophos;i="5.64,440,1559491200"; 
   d="scan'208";a="117765121"
Received: from mail-dm3nam05lp2051.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.51])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 18:41:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLFanIMWC+8mlSnWNZik08tbJBemAbsbIZZynTQaE31IG9uM/NEpq0+LRXDeMzm29c2ijUh9k6+d3C+oTPpgIpH2b6x38VcyoHXxCQYEQecbhbhLG62e7jEPBI/vHqsHNU5i9f5LuYO5nFziWMjPDplTimZkooyU6LI1P41j0Xu9xVF+uLW2BmaRjwk1NCLzvp+Co3S8h+2GvFh26YslioSZTK4JARoIw99+/DkBzkVEkIGkZQYjVhDz4uO5gEMxmxMRLmmX2uGy2iWLP2h8WcI/VGpf79knn4XSbm9ZgQFhYB8c2f0WPAMIf/8lZHEO63NMmV+LXbMZQgmWELVZIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNlvVja8jb6INyf9hhtRHj0DjFjyaZFsvYtJFhTyrow=;
 b=Pt2iKSVziepAdVNQJ8ENSST1HK60g1ejLdAWiq+wXZDItgAXt+acadm62m3NdL16okbyOzENAG0HlCif0IxlHBW7v/V3yIyUPsBX8eJRuQ8nKzWDPPBIRBIFNHDhfdMXOoyG9n6SgFjt65Yk0rBXiK/gnRsnmBJnBng/EF8VVwkdpR5J4yg9wUWVEESlmy/5u/yzyrOOPDNwvAY08iuNqQazD8+l4GUENqVagRNrdJxAxBWAzetsO/FX0245NN/4KMly76ZQijjMQUsySRKlbpvy1VLDLg40WOR1BXqHcjLV1u67IqhrUtwFXs8Mn5/WOJEp0CPJpJDLgbVPXdRrEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNlvVja8jb6INyf9hhtRHj0DjFjyaZFsvYtJFhTyrow=;
 b=uvVLqRdMnl4L9tTOgS436xugrxKHBhTrx/tcIclZe+GTLgqPzlMvyxcsvWgjcKgBrRyEhlaxaYGTc4vw7y/xnc4OCIWmspcHtj716dfiiBISzxx+cYWI1EVLfOxfs89vRkfXU1q3hug7ih5MODNJVvMejS8lVDNZQ6ZwvmnJrRM=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB3814.namprd04.prod.outlook.com (52.135.214.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Wed, 28 Aug 2019 10:41:30 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::a538:afd0:d62a:55bc%7]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 10:41:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/7] block: Introduce elevator features
Thread-Topic: [PATCH v2 3/7] block: Introduce elevator features
Thread-Index: AQHVXUh8r/qsW/a/2UuODIWpedLL0Q==
Date:   Wed, 28 Aug 2019 10:41:30 +0000
Message-ID: <BYAPR04MB5816FDDCF4080943AA408956E7A30@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-4-damien.lemoal@wdc.com>
 <69e86ed3-348a-ac8c-d3ac-550fa8972246@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a5b331b-1243-4e74-2e76-08d72ba4499e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB3814;
x-ms-traffictypediagnostic: BYAPR04MB3814:
x-microsoft-antispam-prvs: <BYAPR04MB38142CD3E28C60F0FBE5BAC3E7A30@BYAPR04MB3814.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(189003)(199004)(71190400001)(66946007)(66066001)(7736002)(305945005)(74316002)(25786009)(7696005)(86362001)(476003)(66476007)(14454004)(66446008)(64756008)(478600001)(26005)(66556008)(186003)(2906002)(8936002)(71200400001)(33656002)(486006)(76176011)(5660300002)(6246003)(81156014)(8676002)(2501003)(52536014)(110136005)(3846002)(256004)(6116002)(6506007)(55016002)(446003)(9686003)(76116006)(91956017)(99286004)(229853002)(4744005)(316002)(6436002)(81166006)(102836004)(53936002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3814;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PxJnsu0pvyPRiHRorn2lZb5pIP/0KvfaXk3iXFwbrFalmVYrkD8uL1DU9nEGoYkgHi7dESiWgKRElpqoi+nEBHcnLNPoHbI7mFYM3GMLeNxOyX74MALT1C5+cTj6+fYz33x5E+XeGo9BeVvQabHMpHyWtFP1lirNK3QVeLcLVWmloj2D0LrXDtBXDYgA+s58e/qGFM3xxEOjIDW2o6IEEdPtqHtvKzX/MzQSjtUPjLsCeDd5OpOhfAX2OdV+lA+YLIgI9C2RvTHu4IoCK4FZXm09bjKT245MzMW70OqAqNlxYmbTN2FZ7+aV1rd1PBNJnGOrvTbk89RI448cY3JG6tqHuTqZ4fsh2fajlkEEZsldlDrp/21sd6rGJ9/YWDICp/DEwwPUboYZeWM+yGi74CnvXHD2e1fWHJV8Y3tfQMg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5b331b-1243-4e74-2e76-08d72ba4499e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 10:41:30.4549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nk7KjnKHRKL0vm7caoaisZ2aCHpL6tcepD6UUfs7Lk75rEmtnarS3G8vdw7xOVnhYevEFZWFXzLSB0JYk0tYzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3814
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/08/28 17:16, Johannes Thumshirn wrote:=0A=
> What happened to my review comment for v1 of this patch?=0A=
> =0A=
=0A=
I merged the renamed ELEVATOR_F_ZBD_SEQ_WRITE feature into this patch inste=
ad of=0A=
following patch and separated the nullblk and sd_zbc changes into other pat=
ches.=0A=
Well, at least that is what I understood you wanted... Did I misunderstand =
?=0A=
When tired, my english becomes fuzzy sometimes :)=0A=
=0A=
Please let me know if that is not what you wanted (it does seem so).=0A=
=0A=
Cheers.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
