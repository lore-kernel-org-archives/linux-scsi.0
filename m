Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32E3C10F25
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 07:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967E2208C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 07:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HKyERBCw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="otSZZry3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgCKHWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 03:22:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18355 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCKHWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 03:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583911353; x=1615447353;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UtkxVhCfc/8wqM/sKoS4RPM9QpT7/+mzhZZD66Trbpc=;
  b=HKyERBCwUM62kNOYDhlggrkw4wLvtNFBKsqqD5AMv2dgHoloxsd3VvM1
   UU5BWUQk8bHWNc+MyDA8cUAhkglvmgjtYA7xw75ZVatVekpAUxK2MQ3tj
   v1DQU/7P4T1+lBHuqph9/oGVWB4DJtmzgIuuafp2v9GWgImvJnVaPmh5T
   8L1zYmYgwnha3kgrynzxG5AfbPjBr46ADqJZPHK7LMFk1fTAhFywN7ilE
   gTY16inII9TyL8Nv29plVbhIelMyF1wzTEShstbDM6Otz2EjIdyq/6X+X
   leRzvjd9Tc2lFZ1vVnjd5h+10hGeC1CwncBgWWkpZ+OwgA9p4/fKmhxKm
   g==;
IronPort-SDR: GK1A/j0qrS9RkW+3QtfhkftjdSwV5tpdi8yQVqMLmZEvUaHFqpQ8hhiYf5goS08AN92QFcfaHs
 MsUKa36VbIcvDFk2AHOvk42ui/64P7Za4qvtxYPN4qUv/iDJOpWefNE+Km18S5cYgsf2rWrr90
 P01IL1WRXrygKHTFsj4bJ5BFVDt/VIbcd8k7U45BPB2fkiCaYrmk3OzxzuxiKO1XyEldvOJe1m
 tTfZDVdv8ZT1OOFB5cj9SLgAO+FUsMKZDI+3jI2JL/9ZCx47khxr/7+83MoeAjNCiKhKLOOZhB
 1sQ=
X-IronPort-AV: E=Sophos;i="5.70,540,1574092800"; 
   d="scan'208";a="136503583"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 15:22:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8H+8/OBqbAMAZtqkWixzqQyDBsNy+gJYTw1Bc5O6m3glKDoOgeuxichR6O1Xz2naUPdZan1xRZJYDdBgZQR7jXSPJVP8tdxX3htUuEMJKyojHowaXFrvHOTEeilTG6HqXqKLKQKmhXOf6jB8NU3QcdBubYAL7RbPu/BrzaYgnx7d45+kFdhI3Wm2HvCs9XY0pG36a0rCQurbCnmVP67WdTkjJL+d0QpQ5nq6mQBO55PkzPmqaIslV6gmH2ZVOyOMQgBLU7ik+YgzA2Wfg+uAw3KKCFglfjU3GV25oy0+zw666P09HcIHgkHsOzBFKJfl0eH0tXCJ8ByyyTxDAR8/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b63O+YULaQncpfNYiZpDKxYmAPtbZ9KzQlLuUaifHFA=;
 b=VBKKVJbWOPhX9yr5CKbc9cjqrNWBBjUvCragiEkEwz8AlpuutGm65Texmg4xPrAcuvhSTmi+x8pPmyFsrurUdunai5jc6njAM9dNIHn84dCPA0Bx8caO1Y9NJ9riPnRjFyYKVsg0K5fQLEb8OyL4Fn8aOuKpsRT+CiDLilaF9e/fK1rzGEJCAIFnVbgqGeHLxlCol1Z+ceh7IbhE6ngxKUzZRo5U2y9Mvq/wUXCKVrlZRXgjwrhl/J5qEQ/ViW7ZrzwSrG8f5YYtntWbx9bGTJYpGZSmASt2NU+aJtaEgIDfN5wWcrWdF0pzounjyQy2rxf+lGFCmYNs7DJbMHLH6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b63O+YULaQncpfNYiZpDKxYmAPtbZ9KzQlLuUaifHFA=;
 b=otSZZry3cR86GErlXgjN14u+2yAM3k07PabjoWLGO38n+U6euf9uSbvulRb8Xk8UjW1jedVhEHakF8tfMKJ29NFQzaWG7KpmmdYzcj4+lM54m9HKdOEYoEulvZc3cSpo2l0RnWNxqbtKSjohFYdxZlyjY1hn+Z9q8wismByj5XE=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3678.namprd04.prod.outlook.com
 (2603:10b6:803:47::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 07:22:29 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 07:22:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Topic: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Thread-Index: AQHV9sDistOgNTL6UEaK0ip7BzodDw==
Date:   Wed, 11 Mar 2020 07:22:29 +0000
Message-ID: <SN4PR0401MB3598C34B1DBE28502C66B41C9BFC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310164229.GA15878@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [46.244.217.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7f7a999-4ebe-4cdf-1157-08d7c58cf510
x-ms-traffictypediagnostic: SN4PR0401MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB36780BBBEE0CD73EC6A976DD9BFC0@SN4PR0401MB3678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(81156014)(8676002)(81166006)(26005)(316002)(33656002)(9686003)(71200400001)(478600001)(86362001)(54906003)(55016002)(76116006)(4326008)(52536014)(4744005)(6506007)(53546011)(5660300002)(2906002)(6916009)(91956017)(7696005)(66446008)(8936002)(186003)(66946007)(66476007)(66556008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3678;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k0Du3TqvbgdOmD2GUN/Uj3+Mg4wG+BsNdx1srZ2VyEHUrucfXpPnptMDtMMk2QC8L7DG2Hz1zNW85jtvvgwBsxzZcTdnYylrRMOyEnnsn9Tf2tZpBiF4e8v1PUi7CZvRzVLQP5Dkn2hFrJQ3dCmeS0cCqZ1GdfRIrVysk9K2ckMsvacG7kM0sCPeLBHbVpG5DnRdwcE1hNs7UnVRu1DiiAuNQhdN6WSaJ1OXmcwJhf0/Ar4M7adomsW4FU3mHiYQauq0BK4Fc0jfGZMjgjhUzp2V/QqCxevqPTu1Zr2SKZCE41fXAIKS0VWCYJ7uy/QctzeK1/c7WK3cpbk5rUjgydc9m1j/fPSZFLPKkZ6lgpmT+U+Gadw7GfF2lnOErmEv/GaYLvWDTVWCsesTwKSvo46o0BXyGlInlaMqq2a+oCRUeoiUffUOfL8pny+YKBL0
x-ms-exchange-antispam-messagedata: +b8EG759+w0334ypJwHXsNO2R1C08k3H+exQWVULdMfXERllw1Fmwpuq3b11Wd2b/r6KLO+fstRjJpP38BI6KNfytC1jFo0sLOfrQOFH5foi+Q/u+3yfNtJQvMEJAh8JI6Fx22fV0tsE4FfmzfkVMg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f7a999-4ebe-4cdf-1157-08d7c58cf510
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 07:22:29.2819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssTeBAOasW3wiM5gbKzXzzsrEaV2flfA2qMKm3TsSqEHIcds6ycgIfXyOCbf8+84YE1/ns8hfdz2zb5l+L+lsYpxHa9RejoxO0HVDoMifE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3678
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/03/2020 17:42, Christoph Hellwig wrote:=0A=
[...]=0A=
> We really need a user of this to be useful upstream.  Didn't you plan=0A=
> to look into converting zonefs/iomap to use it?  Without that it is=0A=
> at best a RFC.  Even better would be converting zonefs and the f2fs=0A=
> zoned code so that can get rid of the old per-zone serialization in=0A=
> the I/O scheduler entirely.=0A=
=0A=
Yes I'm right now working on iomap/zonefs support for zone append.=0A=
=0A=
=0A=
