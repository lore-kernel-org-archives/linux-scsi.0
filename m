Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991A3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596FC23A51
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgLHHxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:53:48 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59389 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbgLHHxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 02:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607414505; x=1638950505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4nqyj8tGWTbf7ifyxa+FW7ZpqsDz3017PKN/42WR2ZI=;
  b=r1V5IwD0dfFDvPzFKzu7ZAtzm4mIR+4Lgk/AaQ82rA9XJ6y4jXq3NQbr
   iNinVKJuuNf4ep9L1rOUOqPYjg1TINCCnwCrIKnvZtPw5RncCGwn2oqQt
   HpmsGPlg/2ocoxGjSH9zIb7ISJqmOJfIz7Ks4hDazOT0LI2/pOZVmsGxu
   IZZ1VolSZeZKsj2YoVK8G7HgdPca0ke/fNkJv6kY0CphiewG+ckzb/Gbv
   YvCDmWOd3oyKzUDt4SFNSsIJQN+pxoQJS9n5mOcD5ZkrX1WdOqKU/1vwn
   nuFtvEQgqXs+tbylgbWDpPC2Yk5yfycjf/lHmgZ47h22KBK6GEUi9PQRY
   g==;
IronPort-SDR: DkuAboP16URxUeFtIQaBdhXFPVIUUlIbG7J/pNBQ7Y7Cn5gAlzluMwir1vdZF8CliT4ptXfVoL
 8b1y/xxc+FFCh9Bg9b4o6bEGcOH3LsRavGmh1o3JxrdpHpIhA9dHXk5GqnP7R0PGFpL+KLSJng
 Rg/b+0qAsQ4e2YCwUN+F9qokLsI9trlntKxNWHZDsMd2o0rey2qyWmgg33Vp1m98FLQA5vC7s/
 Gl2IOwKylYfUIG6k2UDMRzT9Gqge4n+2hguEVKnL4JLslwwH3N+RGR/yp+3LDXGLmMFXeCKDMq
 FJE=
X-IronPort-AV: E=Sophos;i="5.78,401,1599494400"; 
   d="scan'208";a="258383170"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 16:00:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duvRkb/R7csLCsnSuoYXUiphojI1Ulm/8DHX9/jrZqyoLBHOx8W6ukX4+0mv4IEcTNAU37GtTub3rrCcARp2eC5CJ8QCsybUYCrY2GKvgjAqyXEmtqj9elCAMpG+eK1DbTPEorPzaSikTWyRDRJK5sLFUy4MY4fA/ip7UHEL2lx3vH6OU057Oi9dGdywfY1au2rkxlpgXd/o9zMzD3jRysc8I9vHzQGNAWlbz4ETaazvAuxKXDj1VRBgbTqG4WXSVQccBbhkMt5aNBjtv/AdwcCXeS+083B7MqvDeO0DR9E1keJop6nk3auMBwhBu+y+vus/KxMCPmDOqCZRM9nqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nqyj8tGWTbf7ifyxa+FW7ZpqsDz3017PKN/42WR2ZI=;
 b=d0WJ9wHc39OouD2sZ0XvwvhQNy244aT7NfIkJ6p41beKgBxY4gzWU8J3jAWSnlGNlkUvzzChtWlAPF7SWC+hXRMqc28EHCMsUz2ZD2HwldEQ+ffVH1ojo1R8AlxQ/EhSFTsgtadlsp4jMHajeTEu2i13ATlUh5EypANBDRXC9ZqRZw4Y/QiUWXGCv4V5UcT0TqrqKsEuPWwKd+zgKYRX+/4ulfC1B44H/4Wz42t8VYT628Kkvbek5TnogL+6fHeXSq3QDCJJ3H6wWhEM68UWO4/y6mDKzdT74H/iFeP7KFA4v03acFyWqWzbnHffjcAJsduJeUHLiNPfHLfd7ARiGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nqyj8tGWTbf7ifyxa+FW7ZpqsDz3017PKN/42WR2ZI=;
 b=lX3oWaGcnPkUe1XzD++BXBMVu/6j4OTwvam5D7kd59rUigJufRoTv3dx4iev/dn/SR0AhVUQA460TcgaIdpjCBmtrTr/JI3CmJB7mRRH/azoSOzV516fEUpQfygTCiyR0Y6qxXUXka7CShI+O9Y/NNWax87ejAsXPbkFDVxl5Q4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0538.namprd04.prod.outlook.com (2603:10b6:3:9f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.21; Tue, 8 Dec 2020 07:52:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 07:52:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Remove an unused macro definition
 POWER_DESC_MAX_SIZE
Thread-Topic: [PATCH 1/2] scsi: ufs: Remove an unused macro definition
 POWER_DESC_MAX_SIZE
Thread-Index: AQHWzMtvlox3Lplt30qX9QueDvz3rKns1GtA
Date:   Tue, 8 Dec 2020 07:52:39 +0000
Message-ID: <DM6PR04MB65750CE7A3DB7962C41795F2FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201207190137.6858-1-huobean@gmail.com>
 <20201207190137.6858-2-huobean@gmail.com>
In-Reply-To: <20201207190137.6858-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 490541ab-94d1-401b-a40b-08d89b4e3c81
x-ms-traffictypediagnostic: DM5PR04MB0538:
x-microsoft-antispam-prvs: <DM5PR04MB0538C3AA059530906D2EB191FCCD0@DM5PR04MB0538.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SfOri1ee6XBf21fCzPYeSr+dRpJqIqUn89zdk4fhVxL8vq3OMYUptnSNRy9S5yAbqZIAgSfajzfsACqFfx5ps3snxq935M6sfB97f4GhMxYbbblqYre08bQvDjMGnhD5I2If+m6JLH6R4BsokBqufiwAS2pBKrznhBR/rIidwxPUTcZT4xEl9A1f16qjnSCeb/8M1iH0/ID0+q9hQ/3k3xV1s51F6ywfIaRErWlBX5wJKf9U3MRvD3+mo6QsCqh9rbu364Yzfl+5pa59ETzNLY5qZ8efU8YAN3ik0CfaolJ0iycxHDfb7wm9H/G+2x2+a1PEDWVaQh3ClUVmiZdLbx3vv7Zu3y44RSeQfh2WbYxYnlncT2su5ivIuT2pkqJZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(9686003)(86362001)(71200400001)(55016002)(54906003)(33656002)(921005)(2906002)(66946007)(76116006)(66446008)(478600001)(5660300002)(316002)(110136005)(558084003)(26005)(4326008)(8676002)(66556008)(6506007)(52536014)(7416002)(8936002)(64756008)(66476007)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uHOC0AQ+U9oZZOLKrb3sP8eOYfSJr/gq+n5vgjL7e9OWDxkK+/FGPo4tJUew?=
 =?us-ascii?Q?yAAf6ziJkwTGXKM80GIPByK8vEZiBNbOhBXgzP4ZUhl0SuVl1T1ivq7ppuHQ?=
 =?us-ascii?Q?0zSM/Y1zRjG4QM6GeL6rR5BgmMPbtNKoAcytg8rQlF6KkFhkM4Ctf3s9iagS?=
 =?us-ascii?Q?20OsoQMb1UHkWjVjEl8/XwSAwgAIxW0MJAIcfSFVymBq44PptfUc+NvDVuMJ?=
 =?us-ascii?Q?GfYt9GUBwzN3/5zPFqHmwyGqtwJpPduYvP8YcXaidrWkMYpuelQlMkACYb7F?=
 =?us-ascii?Q?eBvXQEz15WO8O5RLoh92lWSZH2SQcT/1mqvSRuRFIdUciZy1GbOaWDeeMjeN?=
 =?us-ascii?Q?Dw1JWWH1t6lZ+FOTO8uKCIWk9SJmXyBM2xumUgv/bLRUif43LUy8ej0exFuZ?=
 =?us-ascii?Q?SaCYTTRPUWpav3YAeSP4mSGgy+lG6oPt7/ZWFXW8Ycs1vS0fouYdGCzOEM0c?=
 =?us-ascii?Q?nnsha2ZfmNnTq2UbaNMxgSn5edv4gRTXPNo6+H7ICYQ0Dj918nv93hmwFArB?=
 =?us-ascii?Q?UoVp98hDk3YKlH9wlmqW/VOB1B9vf8rcW1ekISHUYWNRRHUTbGnR+CktuQGO?=
 =?us-ascii?Q?p98biqBUqh1TT0xV0x3Imcl9ZXdMmw029hIUfQoBE+pxtlKC+E7XVBXfenmg?=
 =?us-ascii?Q?TvK5bZucc5q95ks+u4DcKE+tXztKv+AToXPHuUX8cBRi0icgbcRl7RRGUYdX?=
 =?us-ascii?Q?T4rOLXvLB1NiNkdyNXYj+tMR5KWzMV6uLr+l64f3aGKJOoHE9IzO2owW9fh8?=
 =?us-ascii?Q?2naDR6nDUsU4co8uIuWqIKclRi/lJlQ561gSR2g0f8rvwXxf62r8IXGqyjcq?=
 =?us-ascii?Q?R/ORiUrGROIIejWXUg8b81qcNZYOExDM1mLvWAcOjSGmvmdhMZlM9GWopApW?=
 =?us-ascii?Q?jG4FqiDZyf6jQ0pLfIPoWlkofIfxtwYjw+H69vCZ8MiefGcQWQTZ/S4yQ/eR?=
 =?us-ascii?Q?4vcBViUHGEjTnyRPaxVVTtGUWJoHpLAfcU3ee710vaM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490541ab-94d1-401b-a40b-08d89b4e3c81
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 07:52:39.6355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTg/E+FIVf76Radbp2wUesTM2eUxTvemwGm7Z5dH59PsI9SCjPasD51Ad3VgjkKO3JLPejs+atjFWwNAN4e6Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0538
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> No user uses POWER_DESC_MAX_SIZE, remove it.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
