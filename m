Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF4FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8EA60F58
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhJ2T2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:28:33 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22304 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhJ2T2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635535563; x=1667071563;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uGHBpPFpA4qUYUoXG0HiEyOTZWgjNKZOPCVYkcfWzrE=;
  b=m8cjQJLsK3s7PliHmpwvXeaUkEFzII0nUM2KEfGOptjfM9/yx4mX9ZKf
   7AfvdoGBWco7VR848HyQejUo9vUyu2BiAPMILbXY3iel9Ej0Wh2v16uJJ
   qCZvYpyfE2EEqzjEL7v13iA0+uXXl4nWucX00aEq0fX4JC3WG3wMLUbX4
   L06hyZyudg+6R4VC9kvWDm2jnytMtl/0Ld388Wpvc9/LnHWCOnrwIsPdy
   abkyUV3sENZcoscF7wd3Ir4ggnGhXhTVTVr9lMKP3fpuVWZiW668iFeU5
   Hha+GWlCn2QngDsv4kFm70WwgAAXptb/s0/cRsx0bOUrSy/eW5s6cgD7V
   g==;
X-IronPort-AV: E=Sophos;i="5.87,193,1631548800"; 
   d="scan'208";a="295945844"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 03:26:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHEVdNgU5bCmYVhZkHYSmZ3bAP32wOaZv2PgZzdwShbojjmhHFYIV1jKxRjSgr1Gntqo726S4780BQm2mQZ+l2N1KY9F6ChZniyRkSodG0ztTlMtQLggqYPErA1lASoIgf3pQuCCta/hI9u4T/MWbLdG5T5qQVgRKqvnKi/kp3J57dMN6Oby+yPSlEZAXU1VCJBWI2rOWjfEkboEJwPQU8ciaLUJeTADFqG/mmN/FeH/tt8RSPrDKewtssJWDja2pOYmLa1qILzCU/KrgGs7deqSg8BesD5YzGdBLoHmDBDSX8fptiw0lFyfJN+qLwSWeQRkyD6Omt/HCtP4clk41g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fa1X4xfft+mV+zlly6JBRG3bMFakUu0YYRGKALiJM9k=;
 b=cxS/4SUf6Qmj6mkpT+eh6TJYUzhRgw2SfuAH4StiEq9qvXEJ79bdaVuoptyo7P5HKNsCGclC03EgEWsiI2W810JlCo3xzIL81yULKEGVowWr0XBCaY/awzMoMLw21cdgOLvSANYKNthiwL55gAlQy7gEAouIAWK4WsMNBd+cIMYKkHzhikKojqPjYvPAEDhZzm5YougwpLB7cxSl+0uXHFMu/w711I0LVSjA0O+i/V00FlcAemhiSMay8BIs6omAtX4RiGNpOaAFwMLFhsqIcLLd7mJ31O7yd6C3ESRbDKQrZqKnBLFFHm/3HzJBYKGWxWhYFRcD4zbXPrxMiaA7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa1X4xfft+mV+zlly6JBRG3bMFakUu0YYRGKALiJM9k=;
 b=pg1x38084VM2Hy0tJUcxrQuICONwcrjQOQmtQrwFmKGNyWa1NNTG8tIzOFywpsdcxjymfqKRcefxqUzeFG6I/ivjQi3I6ERcUV/7roIU2tEwbqErVp+nNBQ0LrVToLndx4y/rn/ayL0GMvvOkNMu+JqB5LPd13pPCVraK/43SGM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4554.namprd04.prod.outlook.com (2603:10b6:5:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.20; Fri, 29 Oct 2021 19:26:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 19:26:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Topic: [PATCH] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Index: AQHXzN3L0YKwjUrP8EeCo9/uqY5qHqvqTU/pgAAOYsA=
Date:   Fri, 29 Oct 2021 19:26:00 +0000
Message-ID: <DM6PR04MB6575A932FF6AE962DEBBFE7AFC879@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211029155754.3287-1-avri.altman@wdc.com>
 <yq1tugzu1ev.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tugzu1ev.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d8d55ff-ecb1-4bb5-b46e-08d99b11f09b
x-ms-traffictypediagnostic: DM6PR04MB4554:
x-microsoft-antispam-prvs: <DM6PR04MB4554707F25F4D1836F3D2A5AFC879@DM6PR04MB4554.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I8I6JiJJUhf0Tb8qGB4fg3oaMFmF9QebQWobFlG5uVn5/uHwwW34Yik3IZkK0JwcyUx2KaPkkmc6a6+7VHckB3vK8GZ4w4b7ZdD/T+p+xoSRePvF7IlbMVRVw34uBK9lkpK0RWr8d9XZpu/czoHbp9ihO/HD6lXUwfNa8Y1QUZci0AbG2ST8xGt6JXL8rjQ2sK/PxDxudWiCPTpt2ctpPnr7QO5tf4fO7z2oZNaygQ+vGE7NFVPNWTjFfWOZNyA3gc6qPnRE3VahOD9FFyaMETHSjkH8WsH5Eh2NEJfRWTsU6MSF+CV0uaU2Rq0CGOiSTCG/AmescgawMSccvrEsMhPpa5mc6lX1b9Gs63t9if6pWWSMHX35vr2GvOLMeTrU/9g9+po+bnzrlLt7/EYZf88qHdJZUbsiAWM2btNd7LcTdtnYmU1+9KBHSVywYyHsCsXFVgRQrYFXbLXE4Fj6RPz4lB18JIBXcAE1rPPRegoTNPMIH+jSxPQyB5/tzKPy0KCuWxym3eepzLZs5Us3/PSbssMVuMI5Rme6jdrSEMOjJGcQqg8gs9DjwDeq71kKu2sW7whBuMIFjrijhYmqLToJxttX1Hd+DqZIY3sGP7uVYE/fO2lxMfKl58ns7WMHOb7NnmnSIiLKmFueJXq4qA/hX42vlMevUe6NpOud5tTnZLPK47MZ9FIW65xIhnHIcNcb3nDmEb5E8Q1uxNuvbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(8936002)(82960400001)(66556008)(4744005)(5660300002)(76116006)(55016002)(7696005)(64756008)(38070700005)(2906002)(66476007)(9686003)(66446008)(54906003)(66946007)(316002)(86362001)(8676002)(83380400001)(52536014)(33656002)(38100700002)(186003)(71200400001)(6506007)(6916009)(122000001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KXstO9oH5Qj/SCjMAEuS8rJk8zrmmwjfvnyoSr9UNqcqrxjZI8zLF7jkoG4K?=
 =?us-ascii?Q?lM2+/+FLLtS9VCncipQaBJIgnuXyMjCSYuWgWIAiDNx6QE1n7/4Jy2biShEG?=
 =?us-ascii?Q?CuaZRYEoVlSWpmL3sQ5S+W4Ui0be3sMcGpoRK4TDgyL13w3Sm/Z3dhJ6ayJD?=
 =?us-ascii?Q?7uRj0uAIYeiXdFCbhu+JpqFIppbB22hchCALhaHqnVfuZsRF4AsTTG8tQ/W8?=
 =?us-ascii?Q?Cx25NIt30Cjl14pPb8G5z7jWh9ObLmAc6743uA94u78ZUuP4PWDA0XEe5NCo?=
 =?us-ascii?Q?yV0lt5a8Udx+7Saw/iZX7SYRRJ55L+SHz+v/D0ga+fLymj2CTw3YBJqBGrDi?=
 =?us-ascii?Q?FrkiYDE1mqyULuflv8XJHhnDFvh4prIz6JNzmFJxyiw97/rd6YoD5KjfP3r9?=
 =?us-ascii?Q?rDK9hxE1UL46ZFPg+zsqwPLA/xZN7zEiqU1gpbfdzTJIxkvRTfuPm1tnaWqy?=
 =?us-ascii?Q?dbF6pKgaQlkfkhZdISx7rjw+kHnfplk10pDKHzes/ZoAb5iM0az0WPq+ic+S?=
 =?us-ascii?Q?fb2ZtSQGL5BGk7sgn2gOlOQVY1ij954+vnOrfDsK7IbSeMggitJ9au7rCQn8?=
 =?us-ascii?Q?WYMEdoEiSW2Qo19AdwDSYNwK2qLQhRugF6QDLO+k/o0Li6Hf2OPz1xQ/ovvI?=
 =?us-ascii?Q?lG2xYpFn/klOu4DnHZi6WMEJoCZ/e4I5oO5VWVY0MH0fQL/tFCl7j2oxblby?=
 =?us-ascii?Q?dY+U5FM5VXx2M1MfHNZ3lKzqO5udc8YUWIsXtzp/LBLaQWaRSxRZV4Nz5Qd5?=
 =?us-ascii?Q?mEjL47YHLU5n/ykP+wp/gcpj20AS6uz2GeEeBnaqlD2w8tywUKYM+E2iONKI?=
 =?us-ascii?Q?9Qo94UjodwfBkGYgj33GncSFI8yRqEKHcTL6B2N5i3LqV7mnvArrZZhW8d6Q?=
 =?us-ascii?Q?hamaw/PTPliMpmcWRDlBHxv/xje9sAIts1l2maoNie7Yg5nRJm0X7p6xS1Qk?=
 =?us-ascii?Q?G07nLHGcBOfjhqEDCanq4TMbFzpXI82Om6doF61Xra5p8qf7BoizQypSstkH?=
 =?us-ascii?Q?EiV58bwLRc87JgLOj8ehfQ2vc2UMUyzHcwDmMQ6IKRIlcnCji+kGrtqTZQph?=
 =?us-ascii?Q?Wrx89+uq+Kl/8jqV+Qypj9SLlMU329kHDap4wKuvUgAaAlCYYOMweMY0HNxL?=
 =?us-ascii?Q?EmAVb4WJk2ts7ei1KviVDWzcJAWmLEm8+l5Zeo8G2r9VodDmzEmxfH9RStpp?=
 =?us-ascii?Q?6M/PSOXawEHlLEE7h2hAntW23Rl/t6dxW1+Abq67ZVda8R3fTDXZwMVP1uKr?=
 =?us-ascii?Q?0mdPV+iGTg3by2Ey1r9gLlTNDYbLjPByfJOUAywV+b8Kn/XTi04++XUMTw/E?=
 =?us-ascii?Q?h+AzJnKHCR/+MsfkGlx6oUWVsUZNzLrJYy22rZmLUYaF9Hxk06I29fl8ebMr?=
 =?us-ascii?Q?OJYXu6Lm6S5+ijEZDPuC9qTLwhkSx4+3qaA2oS9lGBOinSdktql14gtiXvOq?=
 =?us-ascii?Q?yQarIZvZmO+dJOHgq8myrLDua1ZvnVPZCVzlGDpzpWBM59qdTURixz/7DO9h?=
 =?us-ascii?Q?bx+Y1EuAJP5e9VTvSfvIKunTohnqSGPu5ui3hv9OhZkBs41EEiM/6m5/VUzV?=
 =?us-ascii?Q?jCjKy8Gpnrklvcu0B9Xvs9jFJWh1OgEZc1IBDYvmXZGE29qvUqXT3h19Thgr?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8d55ff-ecb1-4bb5-b46e-08d99b11f09b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 19:26:00.1488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FwanqvPIk+jO+dV+2/iY1U8mirk03eY6sh0LlkFyRNDKEFklEtWFlnvQbPYgjZuyQbQ5+izonsy10UhlXe5uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4554
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Avri,
>=20
> > HPB allows its read commands to carry the physical addresses along
> > with the LBAs, thus allowing less internal L2P-table switches in the
> > device.  HPB1.0 allowed a single LBA, while HPB2.0 increases this
> > capacity up to 255 blocks.
>=20
> Applied to 5.15/scsi-fixes, thanks!
Forgot a nit - sending a v2.
Sorry about that.

Thanks,
Avri

>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
