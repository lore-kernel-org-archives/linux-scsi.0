Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56926C04FE4
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 18:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjITSzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjITSzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 14:55:51 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B85CA;
        Wed, 20 Sep 2023 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695236145; x=1726772145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lAXO17UHMJCDcDtNSrai5gn50etsXgXZbgJPXyEli7M=;
  b=UzhYBoRV+qZ5d1yc4nqAdgefMR4PhWMsVNwyq5qrTY5ykBBbjWBvoG1U
   hrLaNbnqdM1YlXZzsQ3hC4R9yVjp6O1YTHtGkSbVGoz75rcd/G3+LSgox
   hhx/bfAc8P2B9kvO8/kZ7cQHaMWJXF18FHk/xMYqJ70kSfpwUbPOe5fbF
   bSnQjEkbqS3kaB8F4uztRo81fcdIRZ2+mkGqF0VUdS1zEyDn7HLJzaGrU
   rMWTWFQCWOminwPTG1exZVshGO3VJPTsobP1zk3fYennlLr335mBJXY7N
   oqt7FKe+nrM1l9GTPFBJqFrpHasPQ85ahC5f79RflsFi9IJBwoVgPK0gk
   w==;
X-CSE-ConnectionGUID: 7PTdlakZR/eD8O4vQAoXyw==
X-CSE-MsgGUID: QBW4A84oShKmfzJUncwnyA==
X-IronPort-AV: E=Sophos;i="6.03,162,1694707200"; 
   d="scan'208";a="349769854"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2023 02:55:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIdG1tikPn4pJ0R/kvEye4EmTw7FudBHB3vwqUA+yn3Bs5lvByk29MeTHAepIHgDM8REG9GVTvmXJkSQQQ4CX/t48GieCEWoDujidFr8IfJRtZsssEy8mzdGGdZNLK9Gx99TdwDR2LSsQihpBz56a9FuzAP6aSOauzzjz/CJTaprZcIt+eeEM3o0I6Bl6/oxspHazORGCMqMlSCxqdBeIuYLIRB009sKLH2wHGfWZlYt7ODiK5mDmKd2Z6dcmWS3sJxPLXVc9+NlNIO4lHWTLKPVNvFLQE/fDHXwe0+g9y19hJu2/Fp6J9NZCsSOgEaLTY0lXwccRmdZBC06ERm97A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ltdBeNeO2fmIoDQK0dPi8yOiGLBUmKzVOMcDdjZ4Ow=;
 b=hE9K6Dz3KJzPFBlAVEmDKpa74Nyy1hG7bpLKZGCacNbCui0sHfkh06fQXJ9sk8Xql2Wp1cGc67sEE/sY/kg4xgeb1wwFkTxMZ8Z1PRnAyYVF2kUvqrIM4b+aJ3yfRgg7vU00pZFU79SRa1Z5UkJIVl8EYOqCTLjfglbVLwxSF1REvv1Mc1uYPmMmJ4kmtSnthptDUQSqG3JaRVD44SSfCVGi5V1pB8Ax5IDj9LosVKefh1HKNsDvyjtQzvC/KbCLRCAJ9fkN3USmZevfnbTC6K/jwGJVXBIg18UdgdsUhbZEHXDPjDL4S7e9WPrl4yWF5eF0G/ftRPx1YqK3jdFNIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ltdBeNeO2fmIoDQK0dPi8yOiGLBUmKzVOMcDdjZ4Ow=;
 b=y+qQ0AeO8b+WqZBafDs8nm6asmtxJvswNeuey99tSlYo2TJ1Jc6Y4CtYY17vL3+repBOQar/3CwZkmLaMMdvMucyFgJCSkQFLfmemEVHCGxooTVaVuut2sWVKyuMKIrMpe6nkUtcl16T1vi8cmwL91aSKFaGNKnTMYpOmW4aPNo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8456.namprd04.prod.outlook.com (2603:10b6:510:2b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.17; Wed, 20 Sep
 2023 18:55:36 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Wed, 20 Sep 2023
 18:55:35 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v4 03/23] ata: libata-scsi: link ata port and scsi device
Thread-Topic: [PATCH v4 03/23] ata: libata-scsi: link ata port and scsi device
Thread-Index: AQHZ6/QJGeDaSVDszEyjaNeX6WKCsw==
Date:   Wed, 20 Sep 2023 18:55:35 +0000
Message-ID: <ZQtAIaGG/mtMSMtr@x1-carbon>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-4-dlemoal@kernel.org>
In-Reply-To: <20230920135439.929695-4-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8456:EE_
x-ms-office365-filtering-correlation-id: d0afd75e-8cf9-409c-05f6-08dbba0b2c4a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhK+eEpfPigjSrVIK1VyrqBsuryfQc3xXYVn1BfvYqBd+FrIX2KJJpjVAosqsj9O9s+We8bbMsYDThuumaOYhDVnpwOVd6hRNrWZKXZCkw2wEIc12rBc38QQxLX75QLf3Ny2Ich6hPXOAEDbgWvPCzo9SfPzaVlRLF4okFIQXxaOmCT9OX97INi+kmm6kEvSAxUf6Is0btKy3GxL1SL0quwm1AlQ7YzRNLLh92nalfrt/eKXsA2ezCBhJzK6eFvC2j6T/l4nOeKjQPkBoCKbm+cMIwBdd2cHUgtmoaQ1hp9vZguqHGD51/XgRYIR+W0748g1PW1iULwsHC/iuPOdUJl/0Hinu6m+Jju+XIVd59EnU702/g5TWBGpZeAXqV0QqoHCOTGNmNi+v2IWRP6cnZ1jQkBb7j3xNK3d66Ci7zZyjuJ+UCPdExKCJ4rJ1Qqo0LWpuxwOVq5aRDFBSMIPMddz8gZ9A5TJUFje9ZCrLi/9JuH7bOVtaHQUaZHRiFMW4Toz3z5B3rc2oNnt2dsm6k/eQxGACW8F4051lCq4znLEGMvg6VCLax5YDgB8wqK3QApCtf4RTw0aRNPTQTzlED7VFq2psgjoflbcW9kchN+uGlTuC0dxbwO+mWfuvNsy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(136003)(366004)(396003)(39860400002)(376002)(186009)(1800799009)(451199024)(6506007)(6486002)(9686003)(71200400001)(6512007)(83380400001)(8676002)(26005)(2906002)(33716001)(54906003)(7416002)(316002)(76116006)(64756008)(66476007)(6916009)(66946007)(66446008)(5660300002)(4326008)(91956017)(8936002)(41300700001)(66556008)(86362001)(82960400001)(38100700002)(38070700005)(122000001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wlYpkPdonZb7xSZwZ5ulOLGg5xQw2Pgz9Nxq82UEn6XEQIe+4jsdnRpHU3yf?=
 =?us-ascii?Q?UhJ/hkJogou0xMfUAo8pRnCtqP8nnJAt1u4LLKaROciyEXyOiVRlIToogKl4?=
 =?us-ascii?Q?yP8P5QHSdE1sihymzpKSpnLpCSl5IPb7eiustjmJMrXoJQ+TTIVozhMfoGpB?=
 =?us-ascii?Q?fBbLAYNE4BEJS8PnfCnjCyOe1E6lZ/QEAayBZ7eu76JlRMUUsy23RK2v7x37?=
 =?us-ascii?Q?iLzeEW9wj1yClK/eII0nW93j0lu+QU2Yzwn2Da/L4kdMprZrEo+EbD7bpu2f?=
 =?us-ascii?Q?uk++ja5/VTK/Ti/IQmDADwmYrmSatbNK4FGY78FvrPMzdwsfxiWPnhlRW2vC?=
 =?us-ascii?Q?8c/zYnrNonxAKINBbBI+Z054IcrBRoXErlVB0ROIQIWT7t1MFvMKK6FFUVxZ?=
 =?us-ascii?Q?uR21M4i5xoNoCUaECK+UjIHL7uhC4Ci5Fj4UQ5ZgyokFvjsRO6RNwbD1ANJV?=
 =?us-ascii?Q?MQKIy0FPZUKDYtMJAY3b0XVaFoeAaoAryFH9HykZCfFul0iYL8Y71iB8Iow3?=
 =?us-ascii?Q?ZE5HOD3zr0aOcNmh20OAWyjl+rmToNDSuUlC1ohcB6G0t80zF0uDJlYI6PPZ?=
 =?us-ascii?Q?eoibfRGf6mQU37R7xw3ay+kARPWAX9fo9LBfqk13SrUEtpaJ8YnmKl5rwbEc?=
 =?us-ascii?Q?G4rW101/Lh+KLqLV5RVkmEQXF3kttsyrsmT8Gf5HlepudPBHTAEuyh/tVbIU?=
 =?us-ascii?Q?qmdREtQ59ZpiAphMo/AxLLJG70oGlUgYMnxv8j1ePgKgcJcrDyR7Wa9u0lWC?=
 =?us-ascii?Q?eiM++1/XSYVutjNQORUNeE9Hs07weAOVZ3THfPXtNrqjTxWhFIQvbBwdZdm9?=
 =?us-ascii?Q?/Z9G+OTGfpAQSgDDITEh9AnFXaFhZleVU6t9MqHFYiqE8tDLEkboEqL9wOaP?=
 =?us-ascii?Q?W6kZK2UnZKFVoPz/8BI3mhNjE+FXKNy26mR3TEyhMriRQ4Z7DdR/8dsVPJco?=
 =?us-ascii?Q?FRBbh3DNRxYzqT9oB+5Opd42JZUjJ7+D+eRC1zP+U8IQsQGukW4yiIcahBKl?=
 =?us-ascii?Q?i8Ibe+h+kzxV2wR4KzgmTp5jwV2r/doX9PU+GDe1cCQOMi2ObnLjwlzLi7pl?=
 =?us-ascii?Q?ZMw0unhbBsYzwhdfVVGzuW4OhgYYIUEbOiyQbgFiI8pjg5FxliJBrSGzt2mF?=
 =?us-ascii?Q?9+tEccE4Q8ziRicY99OOp8OsRCVOqchR8UDnRGRcNb/kAFAyB2/szNFsmmpf?=
 =?us-ascii?Q?fql3pI66m8XFlLrU6bcH6520glWoLBW9vL+wnDs6VTilFr/acgFYJHRfvSQQ?=
 =?us-ascii?Q?GQedjzgy9hi5WMbEzaxDpHagmvfF2GFq6OjISB65r5i9QHE4psALVLnUZhZz?=
 =?us-ascii?Q?8QOaqhykuIA17oGG7ia+qDeLWsXORdMREjVWJmfBi9nuMudOLNGi5oJApSF0?=
 =?us-ascii?Q?lDiS1ZwGrMEb9nqZjKQPD91wcYOaqozJn27gqljhwu8IetgoUSIMBl0qy3xe?=
 =?us-ascii?Q?t1PyiyhIFD9soDCvj0groP8q9U7ZQ7tlHEpdpeq1tymoEmnzjVMFTI+Kk46w?=
 =?us-ascii?Q?ibtaclS2oQIzRcyV3OpoZXqGCsRlDCxYaMW2p2jyNkC1IBdSTtGt8WEV06+K?=
 =?us-ascii?Q?tely+8eHMQ3ZqGAhFoDNBdf1fXDzLqKy8I7eRwl4/fOdvx6Plx4LsY3eL0B2?=
 =?us-ascii?Q?Cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1ACEF41EBE409E4D9C2D8DE86E8597BA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?kfelL+tv/VxqX87SnJ0NDl4zr3rNHEaJrQkQAxwROyFq4XgGAikoOKmqcYzZ?=
 =?us-ascii?Q?L2pLS3ZZQ3aMXIxsford+ZRrysf5B5Y2HKaQ0DduhJqmxeznl18mEhxdtcQB?=
 =?us-ascii?Q?66Bri77A0eds5sdaaI6kMiZWI40EpOrtXByW71B8ABZ6HcLnoqVRV3yKpHK9?=
 =?us-ascii?Q?qQm57PDH+WwvyIwP9bcxnPGFV8biESxvSaX2sI423X7HXkbQ4cOkFKeg2806?=
 =?us-ascii?Q?tZqkNck/yrKTOaeV0lehPzTWuJeCIdKRB9XGznovuj6IhfHEvumUatMmrcRz?=
 =?us-ascii?Q?oJJcvSOK3vIq2RDNgObYGPZZQJslz4aBxvElcN9uZ3tGzMSyQsINq5NBqvPa?=
 =?us-ascii?Q?Jl3TWppfnn4GEk8eNtnbN92gERbtq6bv5DONBW89nZTVfbxlvJptYo+cMCCU?=
 =?us-ascii?Q?vD5W8oV/uLEdiBiXeXlASt9XSJZhAI3Ycd2m/1Cv9OIFW8gw57KuA5OaOtLg?=
 =?us-ascii?Q?mAw7GbRU+rNYt6vRNHIbQTepJvlf85dsVnaw1wq1STPTzBT8zMMfU5ODZwkr?=
 =?us-ascii?Q?+UWmo0XBziaXOHIZORfA6X3oYyQVuKnP31iqf4TM7TdjFXXAEbVC/T4nyI8V?=
 =?us-ascii?Q?W1A6VyvtTwR7+n0RuDuVR45jssWvnKXiphFCKjm5R2Mqjlp9jpFVKvNXKx/b?=
 =?us-ascii?Q?QzYTIEOyvYkrzAbYy/eTHqbKeki1S8OmJxyAIBZyW0YbZ8UonsTXgWWMEM09?=
 =?us-ascii?Q?76uZlw1Lt2Vo6m3T6y8we7XS3RDr5RSrmFfAnc40nGmRMkDNve4ukTHO2Uoo?=
 =?us-ascii?Q?4/6v/XB5Gk06lHdUEnqvTOhNmyALm8hj4r7oI9pb7CG7Ck+vKG4kTgUFyUoP?=
 =?us-ascii?Q?LH+EChnBgQGGruAix/d5kZcGPKI6fz1SoZp+BAjT+HKFD8mi7TOHt/0nGL88?=
 =?us-ascii?Q?smHTm2CdfFlpCo9uFpP3XGTcCY8+JbcRdIF8hD/m8lb5pIg/nPSQAKzXxNj8?=
 =?us-ascii?Q?Cik2RjQI4t7io4KzIMQTk5c5MbFw4z4LCC6CMZyEsltJnpZCwDlTtYGSl1bK?=
 =?us-ascii?Q?NVNp?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0afd75e-8cf9-409c-05f6-08dbba0b2c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 18:55:35.3369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aATfxpCV6jc5mKjAg7Odr0GC0LxQrqFY0ALbeTUg+Cpcl5KHX7AVQrMCPkbBAwDYBwqV+w87fVvPFRoxh4xktg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8456
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 20, 2023 at 10:54:19PM +0900, Damien Le Moal wrote:
> There is no direct device ancestry defined between an ata_device and
> its scsi device which prevents the power management code from correctly
> ordering suspend and resume operations. Create such ancestry with the
> ata device as the parent to ensure that the scsi device (child) is
> suspended before the ata device and that resume handles the ata device
> before the scsi device.
>=20
> The parent-child (supplier-consumer) relationship is established between
> the ata_port (parent) and the scsi device (child) with the function
> device_add_link(). The parent used is not the ata_device as the PM
> operations are defined per port and the status of all devices connected
> through that port is controlled from the port operations.
>=20
> The device link is established with the new function
> ata_scsi_dev_alloc(). This function is used to define the ->slave_alloc
> callback of the scsi host template of most drivers.
>=20
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for =
async power management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c | 49 +++++++++++++++++++++++++++++++++++----
>  drivers/ata/libata.h      |  1 +
>  include/linux/libata.h    |  2 ++
>  3 files changed, 47 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index fb73c145b49a..f420b65d3331 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1089,6 +1089,46 @@ int ata_scsi_dev_config(struct scsi_device *sdev, =
struct ata_device *dev)
>  	return 0;
>  }
> =20
> +int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap)
> +{
> +	struct device_link *link;
> +
> +	ata_scsi_sdev_config(sdev);
> +
> +	/*
> +	 * Create a link from the ata_port device to the scsi device to ensure
> +	 * that PM does suspend/resume in the correct order: the scsi device is
> +	 * consumer (child) and the ata port the supplier (parent).
> +	 */
> +	link =3D device_link_add(&sdev->sdev_gendev, &ap->tdev,
> +			       DL_FLAG_STATELESS |
> +			       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
> +	if (!link) {
> +		ata_port_err(ap, "Failed to create link to scsi device %s\n",
> +			     dev_name(&sdev->sdev_gendev));
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + *	ata_scsi_slave_alloc - Early setup of SCSI device
> + *	@sdev: SCSI device to examine
> + *
> + *	This is called from scsi_alloc_sdev() when the scsi device
> + *	associated with an ATA device is scanned on a port.
> + *
> + *	LOCKING:
> + *	Defined by SCSI layer.  We don't really care.
> + */
> +
> +int ata_scsi_slave_alloc(struct scsi_device *sdev)
> +{
> +	return ata_scsi_dev_alloc(sdev, ata_shost_to_port(sdev->host));
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
> +
>  /**
>   *	ata_scsi_slave_config - Set SCSI device attributes
>   *	@sdev: SCSI device to examine
> @@ -1105,14 +1145,11 @@ int ata_scsi_slave_config(struct scsi_device *sde=
v)
>  {
>  	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
>  	struct ata_device *dev =3D __ata_scsi_find_dev(ap, sdev);
> -	int rc =3D 0;
> -
> -	ata_scsi_sdev_config(sdev);
> =20
>  	if (dev)
> -		rc =3D ata_scsi_dev_config(sdev, dev);
> +		return ata_scsi_dev_config(sdev, dev);
> =20
> -	return rc;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
> =20
> @@ -1136,6 +1173,8 @@ void ata_scsi_slave_destroy(struct scsi_device *sde=
v)
>  	unsigned long flags;
>  	struct ata_device *dev;
> =20
> +	device_link_remove(&sdev->sdev_gendev, &ap->tdev);
> +
>  	spin_lock_irqsave(ap->lock, flags);
>  	dev =3D __ata_scsi_find_dev(ap, sdev);
>  	if (dev && dev->sdev) {
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 6e7d352803bd..079981e7156a 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -111,6 +111,7 @@ extern struct ata_device *ata_scsi_find_dev(struct at=
a_port *ap,
>  extern int ata_scsi_add_hosts(struct ata_host *host,
>  			      const struct scsi_host_template *sht);
>  extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
> +extern int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port =
*ap);
>  extern int ata_scsi_offline_dev(struct ata_device *dev);
>  extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
>  extern void ata_scsi_set_sense(struct ata_device *dev,
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index bf4913f4d7ac..4ece1b7a2a5b 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1148,6 +1148,7 @@ extern int ata_std_bios_param(struct scsi_device *s=
dev,
>  			      struct block_device *bdev,
>  			      sector_t capacity, int geom[]);
>  extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
> +extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
>  extern int ata_scsi_slave_config(struct scsi_device *sdev);
>  extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>  extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
> @@ -1396,6 +1397,7 @@ extern const struct attribute_group *ata_common_sde=
v_groups[];
>  	.this_id		=3D ATA_SHT_THIS_ID,		\
>  	.emulated		=3D ATA_SHT_EMULATED,		\
>  	.proc_name		=3D drv_name,			\
> +	.slave_alloc		=3D ata_scsi_slave_alloc,		\
>  	.slave_destroy		=3D ata_scsi_slave_destroy,	\
>  	.bios_param		=3D ata_std_bios_param,		\
>  	.unlock_native_capacity	=3D ata_scsi_unlock_native_capacity,\
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
