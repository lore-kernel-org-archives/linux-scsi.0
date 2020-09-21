Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2E7C43464
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 07:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81285207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 07:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CONbHAK1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rkBol7je"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUHBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:01:21 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2020 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUHBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 03:01:21 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 03:01:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600671681; x=1632207681;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=nOMd+ztI4K1qDPLorhcR3vFpGvb9LB+wNpFkoQu56Xg=;
  b=CONbHAK1mmvAoN/AkfcAwjOUd5XRic290SVRKhkhqIpJ7TjbW6ctAvEu
   EawChkbG+E6G0DMC9I5fZqMIy+Ff6Gw1XMjEjsvzdVqfZ6JWTcK0enACS
   Ap5aoZoVhXaWmTTghmQ1gpxAgrwTl/lRXw/wATW/oE2F2UwFt801jzxET
   Mn9AWOGSQ2IAeOjxFP5dKEC8AeSysEnVYptalw0jm4XvJC44QCa5mJvvd
   DBL2h/zSGDUKqFJtSHHWBsD+fhwvrbs/mc8zVUnob8ZnwPP5Rf/gvo3R8
   MArODq4P4CvuA+RlLTQbnvdTIFPvG9GfvHdJcyLsFv7BL7Ayn8GQjEoZ8
   g==;
IronPort-SDR: CbOvkl6/rugzMDdqIA9irzDJVUlX7uWn21sGQgm4hQnyzXtA9QtWJVRi+J70imHVlVTkksr2mq
 BoSdO1DMinGImVVbAiNjQK3+ktG2iLHDKuWkXZxHgbJpXGE64+gWYxvnOutDkMgOXc7wiieshB
 ihDhwHviyZj/PsxsTT0tkSAg0Zek0hmcHBeGINiTQ6/mJlfh63TmbekT7lAS4XTOYXQl4tbMXO
 9LD2b5iczo+1O75EaxLFyGhKwizQcjZWvzx2CaSoPPN3qWxnx6x9261IXwmEZJgEk5vTAY7/H2
 qXQ=
X-IronPort-AV: E=Sophos;i="5.77,285,1596470400"; 
   d="scan'208";a="152238755"
Received: from mail-bn3nam04lp2055.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.55])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2020 14:54:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2XBdgZSRmtb4SZW2h/EGo7k5ZZXEmvjqHoD4Gjb1MphLR2vOqkTEQcrPWUG/slHSe2ffRc4VZ2baPvhn92CYxp5q/0F9mUkHfWZA5YiwFU7ivWx5UIVvwEJO0SBtD/7i08gfXYznhs6QzHaIDCVKT3D35nyG4v065APzajQB5cnNa9Cj/gXtBvc6x+Ly5HNVyIQXN9uQogzGuETy/Jbl45iOCe9AGH+y8SLoen5GArzRpB1FvsTQCWy4YTTw0v/TbmhB2P28fWjaejdgRoSF+KBx6W9WpbUyt+qSMYmORCI8gD2Z1/3Iey7FwONNwVS8B0Cq6+Uaetbs93sfep4TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOxCLo5RS2zj9cIUNbzMB+diNBbBPqEDWnRt8hL72sE=;
 b=TueE/PaNFlTfqq8WuFqcau+ULaWxxTyELwekXl5CkmsxWslAMw4byJcO/U8XqSW46j/OZI7LtAdiakXYJOzVCAPzJl+zplUrWdUTejxNtar/JAisG2reeP/cHtsjObBF7VmGTCARpkiRYT1BZzhcz1yOwla+Uhgy5Sw82gHRp1uu73qvuR/jgnjEgBnoMsP0xcfYTHJABirevkne9AeJbMhOtS2SciAK5RB/Ffx177AhQyTxR7+v1tfcXAfcGBktCKciamARsqO3pocQFSCeP4AyhSNyH7FzDEz5EvwdHEoksMZ1C/ez/g4Q08BTawznkUxXzyZwCefaiO5vlZ7AWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOxCLo5RS2zj9cIUNbzMB+diNBbBPqEDWnRt8hL72sE=;
 b=rkBol7jedfibrgLsP3m1n5lo7Drg+m/yZupzSgVYofocL124bLxQthJKezT4UjT8V7pobo/Kn3XYHHZ1YkvjHHJPHBfxesgbXSmFiTRtvKkZO4f2HZ94zbCxZyEWMXp3gtCToxLJgSNRZ6tTc7huPtgi5bLrakzABsCasqhUJhc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4864.namprd04.prod.outlook.com
 (2603:10b6:805:9b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.17; Mon, 21 Sep
 2020 06:54:10 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.019; Mon, 21 Sep 2020
 06:54:10 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv3 1/4] block: add zone specific block statuses
Thread-Topic: [PATCHv3 1/4] block: add zone specific block statuses
Thread-Index: AQHWjUjpcQ/OOMMUgU+KxaV/geAZWA==
Date:   Mon, 21 Sep 2020 06:54:10 +0000
Message-ID: <SN4PR0401MB35987C8C8D294A37CD12A36E9B3A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
 <20200917231841.4029747-2-kbusch@kernel.org>
 <SN4PR0401MB35983DBC8B0B97A4083CDF8B9B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200918194056.GB4030837@dhcp-10-100-145-180.wdl.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [62.216.205.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 038f6fa4-bd82-4d24-4fe1-08d85dfb24b2
x-ms-traffictypediagnostic: SN6PR04MB4864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4864729917E0BD6A532B9E259B3A0@SN6PR04MB4864.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dhNSfypXmMAcM37ncazeexUjEpK6rpimegHVTTEGbMsrnmaeXb9pW4l7WQl6iuHrwz6rXUhv1AtwucqS5mWUf+4ArFO+le2f7id52hwuq2AvdvxHFEvJs4ZC03reU0eu2kaLDSJugHVsciFublsd7guOe5dgAWJiGo3kLze2zdk4mrwe59HW7TSyiAcBUOaCRkWDXm5B7clU9kqoILRwTR0QhBmEflUNfJ6kg0v+rOt2FjrVEeOeNqvE2A+KISmWTKRMgpJbEtGAYEqTbD/nKoEgbEKvfiAnvIhsutBGBYkNaduQH7aeVE1AyA93jVvIi7jxZTW1v09Ib/JJVPdmEt0lbNwDLh1yeO3uZqZRrcB21ieS7MoLSEAmST8w28Vkd3xBMwpGBEGr1Li5UnlBng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(966005)(4326008)(4744005)(478600001)(6916009)(2906002)(54906003)(55016002)(9686003)(52536014)(7696005)(26005)(5660300002)(316002)(86362001)(83380400001)(8676002)(53546011)(6506007)(33656002)(8936002)(66446008)(76116006)(71200400001)(66946007)(66556008)(64756008)(66476007)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1KnM2Zu7fE43V283BaSecBLO7vPclMIiSOaYYQjm3B+IS54c6KmzjTMI83PtLKOZbRTFIeuio7miNK3PteH7kfnTcgHwAi5iJ2IMwJ8w+5UGeuHQrEgS7zMNDcYF8YzMd9EV0lqMlaPNWH+qhygCPYkEE4eyUx8PCZLrJJXmWW8ZAIGOYCoNFTWxz74pHjAXHipOzzTJsAlyChwbDGwNq4hHenumdHX3lfc+2qu5apYhRpHJj6TpH6xapj50mOTMt5f8VtllnOVyQ+oQg4l3nhyQHTbtpvGjZTvY3JRODemMXOGKz8MkEGKuSWlG0vJcXqxIKkHsfAbfZcyA5S7Uy9ZOd18XE3xXKiuyyTrWZ6YUIdWQyDxeGwrncm/qeCD1n95KvBd2BDobRin6sTNcspTmSX8w6I2f48Q9KBvizgyl4+vKEgw+209gMi6Rk4Lu04nxk5T7h8oZpr4V6CU6Cjo0Amon9EdiVDTYRzl/IEeaaHYEmUNAvsTf916/hUYNTS/hWqEHD4cUalovsB+NorYb3C64AI6fAhk9m4NCL0mbB7aqA3bTJ+lB6nITRKpMSopr93iGXC5k1CLLusZ7AC9cd2/iTAw7v1OFH0g0nRnTY5Jalv8NqBQLlNam8Km1pMQHnZ8YsKCrd/sQdApEIA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038f6fa4-bd82-4d24-4fe1-08d85dfb24b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 06:54:10.5266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKEO0lz8j9FXKrfbAlS/DGWOEh5dnJQZeP4mXVMe3tiL8xBE2feHMmS1/hvfT87TmkmM+boOCauSwPVnmSAjZr7Pu8NvRW2nXchTnbcwxuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/09/2020 21:41, Keith Busch wrote:=0A=
[...]=0A=
> =0A=
> Yes, good point. Those updates need to come from this repo=0A=
> =0A=
>   https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git=0A=
> =0A=
> right? If so, I can send updates there once it looks like this is the=0A=
> form that will be committed.=0A=
> =0A=
=0A=
I think so yes. Should we also Cc linux-api on this matter?=0A=
