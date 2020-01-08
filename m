Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDCEC282DD
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 13:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8105A205F4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 13:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j1Ys4mSt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NRdll2z7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgAHNOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 08:14:37 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65075 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAHNOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 08:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578489277; x=1610025277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pRkDpXfj9o5SoCddxZMJehuV1/SIB503nZaNGnAk1JA=;
  b=j1Ys4mStbIlBCip9YsRx6GqfX/waZJUCb1qIGRmGTufYHCwcxaCgcQPn
   diD/dZGSlg5Oe+nHpO5weVghfVlynlX8ikqb0b3oeaPYm3xvYmJPOF67A
   Gmv9qicG5udas7SBjRVof33Xna9UeAawUO+KAe5QgH+HU/lRqiG8bSGmb
   uy8uPaSvsg4EcXH9VhH2drSXGd/uyrFYOA3k09e3Uyn/wZt8MVIf5abWB
   zfeXiCcT3er4G04ox7wBZOUiSkbT9SuPN2vJpQfnO+Wtg+acD6EFgLRhS
   5ndXl3MooiJAC60tWVBL1glEVUKO0M34w1PSV3L7RtgPP4i5DmPuFhqd/
   g==;
IronPort-SDR: OL6J+y0Mq2ZJFIYZBkvqqH8/qKxIB5E5pBEihLHiDsBtbaacn/z4otkok4CGmhQK5epTuJZQYT
 JSTr0R1+19Rj0Buf92XoMaqCL+gEraoGxn01kKrg6qOEU8Sp7DEeV89tA/4VP656yTgYU07rUN
 pApFTDiZNW0lcUmObuYQJt83TrGIKsWWLz7/dWXOa0Or5P60IqpbfvIoel5DRBiGDrIkOcrqlq
 BG23ZRzrxsRu+Hj6RLWjgk7u3WiP5oJuwjoKR4+s817IL+eBq7YmwLYa9rzfGDEnHHACr/HVlJ
 Fv4=
X-IronPort-AV: E=Sophos;i="5.69,410,1571673600"; 
   d="scan'208";a="127690637"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jan 2020 21:14:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrTpn+4wSJ4Gnp1orjbH7AIWUAq28lhJ5CJMh3uWY1N4rWGuS0MSbu4IzYgbMtSAoa6x8ePzB7d8V6p/BeUrDwHvfpJ49FldUgi6NUYdnfHnkv7SSMSW2qdMnybE6+/FOTImGHpBwv8prBG5pFilxxcLFdfFe4B7ukN6hM6wL/CMZSKyeHXx6rb4zPzvd9VmSjRfiIqVdMgW2mbcEHeeKycxqvuOPHx/1OVHHlnH6vGt4N4hCQwamzzU3MDerOiKIY8wyELU87QBBgtvedDkhBwxVVuL//j3S5utENUE/Y2xQmwoUB64LKFQzT039vitP44M0JUo4wIFL/RZ0Wnd3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGZGzc7uZ+Rc5+iRLZMDvoyPusO2UPOu9Z6mxhqWLjY=;
 b=GaSSz/svrTLGOadXO4C/0KyxI6PF15k92KB0fuPpXh84wBkdiuBuW3gNnl07Van+20YLUtJV6W9ZLViwWy2aoCZf9ZABj6xqGG++kQPzDOxd6ctXEH4J3HKV0M4zdgzuikR7YRw5XZXgJgi0+5Bi1SpZFl/Xaul/qpxhgXkvZxjmRFzdCXmyN6D9Kf5320xCzRJJI8+WqWRobslkRM7xr2CTDgSz6XhUn06M+wzko8/SjNW1KcnNT5Z5miW/xFkVldszyTfsUnf7EaJo0UzgPOnZGVrNJd4ztl+VF8lhPjKjzyR+3kOEjy/294kNKZLqsSoHekw9cqnIprBzu4nSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGZGzc7uZ+Rc5+iRLZMDvoyPusO2UPOu9Z6mxhqWLjY=;
 b=NRdll2z70QAfLYUxUPQ2k/Vd29hzFcNYFJ2Xz8SbcvHElQ6QqISqnWTlqIKSsg0x+4Nw72iu8qFECMHuh9tNzS+aE4QGU8KLNsNuXbUBcm1DC1Icj5sNpLHBdggMlOB34Cf3mC+QQcCJzOmUj6BCCw3oCjqcvVqeRLvZZ/r+IEI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5568.namprd04.prod.outlook.com (20.178.249.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 13:14:34 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2602.016; Wed, 8 Jan 2020
 13:14:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 0/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Topic: [PATCH 0/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Index: AQHVxZBLg09XUYsj10S/3JBd/ZaHJ6fgvANg
Date:   Wed, 8 Jan 2020 13:14:33 +0000
Message-ID: <MN2PR04MB699136BA44E4A11A606460E4FC3E0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
In-Reply-To: <20200107192531.73802-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d36a722-a8c6-45b8-8c2f-08d7943cb449
x-ms-traffictypediagnostic: MN2PR04MB5568:
x-microsoft-antispam-prvs: <MN2PR04MB5568F18DF79DC96CBE8D28CEFC3E0@MN2PR04MB5568.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(189003)(199004)(110136005)(71200400001)(52536014)(33656002)(316002)(478600001)(186003)(54906003)(2906002)(64756008)(66556008)(81166006)(81156014)(66476007)(9686003)(7696005)(66446008)(6506007)(86362001)(8676002)(8936002)(5660300002)(66946007)(55016002)(26005)(76116006)(4326008)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5568;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c7pFJqale6L/zXC8YYT7BhE0yIT1ilX51UfcsZ+CZcE0e+El9WRp4xoipqPbkou5G5gSgORrpTsmxsJuV7fp7NL8ElmoNH6LbMK+3oUc7g1sUxWIzWzKLbQ6ROsVb4c4NNJcgthDO+DX3ZiUuRVJqZ72mP4nMC2NBMiFP0H0vDta0uiSSV8hdr0D6yXHVni0zi5UCgqI+pioT/J8eHEKEmq+jIb69HHgiX4eVqs4+VEDYmn0FiKSeF6VzcZKaHIBuWA2IFX50Hxcco5gmVvdDC1ljKSS/DwPVr8vnVtv5XGatfbqJGozoa+7JRjJDJTQXdG2V1OrsbeCG2LwiP18FOz8sO2u7T7VbF9NJQfY3VfKWBJ8wwBpP+PX2VyJOU8w4Aqoxec73gQGgYwARJNJJLkmjMIKRtj0YqUWtlk8WBEcqJCkbcs1QlYeNNsGIPZk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d36a722-a8c6-45b8-8c2f-08d7943cb449
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 13:14:33.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KPMyGaA/z+6P/1Yr4mvlLqnli7nlMvWjVCEih3CFGQLlRfNAF4Uyh8cjpp2YYunoUqXuPzxEkJaI+UazkvteA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5568
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart hi,

>=20
>=20
> Hi Martin,
>=20
> This patch series lets the SCSI core allocate per-command UFS data and he=
nce
> simplifies the UFS driver. Please consider this patch series for the v5.6=
 kernel.
Aside of a mere simplification - is this change has other objectives?
I am asking because at the end of the day not sure if using scsi privet dat=
a for the lrb is obtaining that goal.

Thanks,
Avri

>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (4):
>   Introduce {init,exit}_cmd_priv()
>   ufs: Introduce ufshcd_init_lrb()
>   ufs: Simplify two tests
>   ufs: Let the SCSI core allocate per-command UFS data
>=20
>  drivers/scsi/scsi_lib.c   |  29 ++++-
>  drivers/scsi/ufs/ufshcd.c | 247 ++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |   5 -
>  include/scsi/scsi_host.h  |   3 +
>  4 files changed, 183 insertions(+), 101 deletions(-)

