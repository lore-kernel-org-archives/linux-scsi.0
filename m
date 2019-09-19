Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6069C4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6472196F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ACW8s/Em";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Mdad7dUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389467AbfISMol (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 08:44:41 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:54748 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfISMol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 08:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568897081; x=1600433081;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Z21KyimuM5OK4QFm7v1RYgDhW6FxRwRQkbAFkFrYK20=;
  b=ACW8s/EmU1yVEid2ANSzHQDDA0nBwwi48iHogPDx21iXfdSVY+OcDCed
   C06wHo6AKzZYfJCbcprwKCNexmOwgRSd5k32WEdxf3t67hmUPMDk0I5lI
   SOqyGuAE6psgAuSV3cmoVzbgxSd/m1PagR95e8mqdd2NT2lmO7mL2dwVX
   0B9rAF4lJoN0XVEdaxOHm8CZdHn4iOVZaXp7waaGUfgnvbNUOYWPRGU1A
   IsJ8mSLq26wq2pM0y5TBy4fBQFeSP0D0Zzr7/8+yk00NXcwyhcFFEpHl2
   WZ2l5anjC167d2KLqGx171m7+QSUDvJzDd3XOJO6ZsfgCFiV38MEGL7f5
   Q==;
IronPort-SDR: uPf9VGLZHXo5xHnmwSQr4pYZJEmlHXjIEa7Iw+gvEr9q/MSISubuCkXo/rvjGGCNbwKB+xwQiK
 PjJ+W9lG3FJRvHWiR8xaRKFi7ZDzUdA2dCyA2uifWSATooaF0kbpK1Vhhk2tSG3r6agnCIdWKl
 9kFNzZdaMTd7/A2rS6xai7ZkmK5pfeHTwRCzAk3geRN1936KMiNwS7BMpL7zdtRthUbRs+1oOZ
 BGVBMK9A+ADjZWqWDjHdKBerRKWzy3G/9NfqwUZuG6am+v0lE73CMPycn/7L1sm3Z7BQfiTMds
 MqY=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="123105756"
Received: from mail-co1nam03lp2053.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.53])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 20:44:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDamdiSIYmbd1hbIX8ZRwSYIpCVRcbLYyB6ecDjp5pcNu0pcd86EIGWfRJ2UCER4kAOHokQuPc9DUNcEk5dCYt8RCSftDbmyFOeV2zggVFAH5QD7+IqcDbug4BWK3fKXY3FlCoxpjJqLeE58w9mdDOOm8wFNXZOhtkrucgJWRSC9MyBIJRCVQt8gC5Uf0pL78Brvbj7C5K2G33BAEAJJrUVYYsedtMnq1wrsNqNjIAKDKbVsBFxMmlPVtYxirtMKkTqndYnNHpQdhwy09cqEeL7bIi824Rv87zqF/2lC1w+703Wf5vuXUvX0wA+RMeygpvZ/H7gCpa0lwXiflT/gDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z21KyimuM5OK4QFm7v1RYgDhW6FxRwRQkbAFkFrYK20=;
 b=NQ4qT+DSliF87aVrSpvJ/ukGrFgPvl76AgsEw1bS77/ogIqfhqyne4XsIMIRa46jgzRFp0VppeEZB0tgXYtnl7lFJZSK49ePk1dqmiMMNFji28W54KCSCkIeIBs8AJx8d8nYMLQJopBZQo2eQ19ODisnBn2G2rRULFg6iBVOIv2aeFNZF7CAg8ENTL4kwNkg9hd/BTra1y1za/GlOeI+l/o/G5D7/DNyGz/VUGeftCYv1QjhODJ5OwCtGdGrC0h8T34Y5kuQuns0wD9T59ItDzLZktVJyPnfhhiAURmEyCN5O1bgVOZZ/ST+cLH50VNOJHRgZLjNXK3j0ChfiSZqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z21KyimuM5OK4QFm7v1RYgDhW6FxRwRQkbAFkFrYK20=;
 b=Mdad7dUtGZB5J3k9l3pHb0tfOI83ZR1GLaXWjTkiXFmlE5AufixdpweqGMWYWBfJRu7VzpY7d++wtUEbFMdGJVdq2JYOjw9zjz+rLX6moOkhJ6NZ3XGYjhzV1796+4FIyZtEWzaNa0PAWKJxKOGEkq5hDplWn3ctmCUmiJUNHw8=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5013.namprd04.prod.outlook.com (52.135.233.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Thu, 19 Sep 2019 12:44:38 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 12:44:38 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Liu, Sunny" <ping.liu@lenovonetapp.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Index: AQHVbtGArbQxrIRB/UOO5+Jp36iGNw==
Date:   Thu, 19 Sep 2019 12:44:38 +0000
Message-ID: <BYAPR04MB5816266B5EEBA1E800E73116E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
 <BJXPR01MB02964BA1F5E67B7B6CB39EE7F4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
 <BYAPR04MB581634BD1F85CA9768AC780FE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <BJXPR01MB0296594F3E478B5BFD4DA2ABF4890@BJXPR01MB0296.CHNPR01.prod.partner.outlook.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44290bf1-25d5-4cab-5200-08d73cff2282
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR04MB5013;
x-ms-traffictypediagnostic: BYAPR04MB5013:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5013C898125EB5DF9AAD39CAE7890@BYAPR04MB5013.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(66066001)(229853002)(5660300002)(6436002)(9686003)(55016002)(52536014)(8936002)(14454004)(3846002)(6116002)(6246003)(7736002)(26005)(25786009)(478600001)(71190400001)(86362001)(71200400001)(2906002)(305945005)(256004)(476003)(486006)(54906003)(74316002)(66556008)(102836004)(186003)(76176011)(53546011)(76116006)(6506007)(55236004)(446003)(7696005)(99286004)(81166006)(81156014)(66946007)(91956017)(66446008)(316002)(64756008)(66476007)(4326008)(110136005)(33656002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5013;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xAbcr1TKWgBLXcKilC2JFwrF/8UM51OnLKrSMgX3lWfBfyKsddfOqofE1KWtNCYDMNJi0tNak2uzaV3fOdoxfTwAE0wcg7MrvxR22vNtRLU6guoj26MMRu3TJ0AYbTJLrml5Y5CQ3W2EyXo1xEk+A2AeS88P/wTm8z+j0tBBIorc1zV2Nmi8Cot5E8Ig9KLLvlvUz7DYDLr/cHBQGKk3fEp5gALEirT/JO5leQXyiPHlGush4FkwRFqZSHBS3kchhgngsOLbL4IGhxNZlCpBfE8JHzBfaKdkIplcFG587eAMuCmSijzxSfXGW40BozXTPLAf2X2SrHTBsS6ZDhC6Nr3QmftZG+epA+aVCiG5q+JMyFTrmkMrB1nlDxCQyjuE78tYZ4P1mOnR0SFQz/OXfFI61T3Q2V26JPCZmdihDHE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44290bf1-25d5-4cab-5200-08d73cff2282
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 12:44:38.7458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 921pD5fifUcMJ5r2EHF5owVtMqxs765KS6UOg1hsn7PgSDo+jTLk1BYKAfq71Y6BNNUR4rXz+/BxwFdt86OSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 12:59, Liu, Sunny wrote:=0A=
> Thank very much for your quickly advice.=0A=
> =0A=
> The problem drive is sata HDD 7200rpm in raid 5.=0A=
=0A=
Sorry, I read "SDD" where you had written "HDD" :)=0A=
Is this a hardware RAID ? Or is this using dm/md raid ?=0A=
=0A=
> If using Fio libaio iodepth=3D128 numjob=3D2, the bad performance will be=
 as below=0A=
> in red. But there is no problem with numjob=3D1. In our solution, *multip=
le=0A=
> threads* should be used.=0A=
=0A=
Your data does not have the numjobs=3D1 case for kernel 5.2.9. You should r=
un that=0A=
for comparison with the numjobs=3D2 case on the same kernel.=0A=
=0A=
> From the testing result, BFQ low-latency had good performance, but it sti=
ll has=0A=
> problem in 1m seq write.=0A=
> =0A=
> The data is come from centos 7.6 (kernel 3.10.0-975) and kernel 5.2.9 wit=
h BFQ=0A=
> and bcache enabled. No bcache configure.=0A=
> =0A=
> Is there any parameter can solve the 1m and upper seq write problem with=
=0A=
> multiple threads?=0A=
=0A=
Not sure what the problem is here. You could look at a blktrace of each cas=
e to=0A=
see if there is any major difference in the command patterns sent to the di=
sks=0A=
of your array, in particular command size.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
