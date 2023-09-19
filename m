Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4148CD5BC4
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 14:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjISOAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjISOAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 10:00:06 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD7F1;
        Tue, 19 Sep 2023 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695132000; x=1726668000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AvRjeACmJvNnaXVC9gggLxBQHOwmQOayRBUEXxfjjOM=;
  b=kklTmyGaZBHy9T4GZE7OvyR+XGvcHtcko+6wrtGArZIo69Dnysvzwu8Y
   TGmcaYzqKOugD6/p47ODV8IGxT+EhXEL5NaeYHKCUAwMLnh8Xgq3ohdYz
   d6lLaVUYXLZtcDeWUFK9Fj/wiIfwYIMJn5j2S71ut/OMqCncYvGyRbKYp
   DX+vFEnAF9NJiKApPiMyjsnYCAB/6/E7kbxL+ZdrdBqZOCIktmLqNNlZb
   WJICrnm9iBWbz98gQtJNVMFn1O96LhUhgHBEYxrEw7mAqWvp9Fhq2PhVa
   dZSntvy6f4vPH5KoiUgEG/+eGXPLB8sHbIm8kW66qxec/R/Ak5eYEndN8
   g==;
X-CSE-ConnectionGUID: bQ8jYWy2TTuxHRxK7Kiicw==
X-CSE-MsgGUID: eiIbuUhPS9GooIl3hikZdQ==
X-IronPort-AV: E=Sophos;i="6.02,159,1688400000"; 
   d="scan'208";a="244659657"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 21:59:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L71uDU7+l1kQm9scl8yLpFIz+w9TlNG1bMgi0wH33n9yv7xZKPsOrVKlqo1uh0XoZZfWSPi0UO6g36pafm0Tnm7fdYpIjYA260Kf1VPrdf1EHrBE+1EeHd+cN5NHq4JlbgWPhcoBQJ/3XB+TanbmQeBe2DL1VB0OFkuNtAVRlIB/cefRulIIG2TZ9cCf2vvO2vNrcHFLkw3hVfW3i/jLM5ui3gp1ayMqYuNFs9Aje/17dwbiWBUr4GL4VQE54B9WZbNqKI9etJKrHJlvqCQIOKO89xfcbieffhD44ugh7c68YXBMLH6phY5WxOYF8urETWtkIJ2fnh3cg6Q9nrfg3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1NhnUdXFlaDVCTIIXSWi42IE9EGHGWJH06EJajxqPA=;
 b=cPKVrqEg1QzqB8tmAwVF4nV2YX5h0WX+LbI9xzTrgBfZIC1nHAES8yMLbjyuFPYn3DrWt4om6aWy9Jz/EBef+jhOcSVB4fpuhrwcW0YSwJDLXwabicSDHA7iJ8jW9+fjBA3dwukBdVyeDWYk/K+mETUSquGUvVcLYMlfRRHWgkwhN8Rg1Bu/0kmuZ4ev17gZFQ+lb+Ge+LRIPg4A2s3J4rJEL8iM6dpUeIyd5XY0/vrvLdyo1Qm+l0E6sCCBMwntpJwZybrdSuQHxhX00U1yxwWqHdPyUDxb0Okf71OfEvPtfaDuR0R5hKLYzGvXJRtveoOJ/xuWORXVJM8TeSrbdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1NhnUdXFlaDVCTIIXSWi42IE9EGHGWJH06EJajxqPA=;
 b=Ai1nWqjt0aAgGcE2yxDil+cLbFevCCHPXTsduBDqdE5VC45BLfx/XBssZGF5Xn1EnXBrw2sl2Yjobu23KEny65agF3Lk9RO0zRiiZFd16Fvah6l35QNi9KJpgrfuY6NBJKa8vsIpwG5HVFjDNV6yaswhwHY7AEONE2fYmVj1afY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH0PR04MB8051.namprd04.prod.outlook.com (2603:10b6:610:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Tue, 19 Sep
 2023 13:59:57 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Tue, 19 Sep 2023
 13:59:57 +0000
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
Subject: Re: [PATCH v3 06/23] scsi: Do not attempt to rescan suspended devices
Thread-Topic: [PATCH v3 06/23] scsi: Do not attempt to rescan suspended
 devices
Thread-Index: AQHZ6wGSHxmVtdsFfEmysLMQ55xiSg==
Date:   Tue, 19 Sep 2023 13:59:57 +0000
Message-ID: <ZQmpWC/i9kgBxnaJ@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-7-dlemoal@kernel.org>
In-Reply-To: <20230915081507.761711-7-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH0PR04MB8051:EE_
x-ms-office365-filtering-correlation-id: 0ce39641-8353-4688-49fc-08dbb918b53f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: poYhNq2EcI/bfgLLXcXtn8a3KBycC5bJbP8dT4d0UElnfVRaD/0yAcF1KVinUqukL1UP+xN0HMfEDLMKJrYyryP0qZ4SwmlAB0EwiIXau9sb4SGjAMtKwH1bw4zkoatjSxl8r+tvI7ptT+idJOM32wHW76Tq92eo1fwGC2zWoU7zKv/zNk5iko8CJ5T/5uQzWwhj/nRs1hjlhOHArRYLW7VCVNbFHlnCsrLxfts67pyGaEV4KHCwN3fTVwWkz+pHY2qhVDo+8/K/9uM2SZqXVufWxy4nSP/OWOuFwu9tVEz8os1gwg+jdtQclVyTxEOZP6nrBXd+tMfVW1YbbYmWkypyZl76S/f55UUORhrbyaffHc5SwR5pWPHdCDATIIU/F0J9CE6RN7eHX8ob1X6V5vU9HRaRpmoN5G4BgnffgUj8UCMMv4OP2kU29+z+LU2MJY4zHek4JfW350jree8q1D1Qf0u1YPwacW6/aFJMccEbETDGbMC1CmdY9WjxV7M2jAXxvWpBt+mk/qi6aaeMv182Y86XxJE9OS0LrQhCKkv79u+jWOgvRWLKWDFWQ+3zfnt4IZf5iOygZXOyiCwPsua92ZCnvtgHaRlO7fXZLxGewSsQLcPYg9NbQDQcu8jR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199024)(1800799009)(186009)(122000001)(82960400001)(38100700002)(38070700005)(33716001)(86362001)(6506007)(6486002)(478600001)(2906002)(5660300002)(66556008)(66476007)(64756008)(54906003)(66446008)(76116006)(66946007)(71200400001)(8936002)(8676002)(4326008)(6512007)(9686003)(26005)(83380400001)(41300700001)(91956017)(15650500001)(316002)(6916009)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sVVFb1FrizWrKOajLCol/5c/OWYs+n/adPWE/bstbO7cVmkRRbQyJPL80V90?=
 =?us-ascii?Q?vTg1gOcNIVPIYUmCYHSRle3EuwD8Jwp5jJGVwTXdXLrbnnHksqZtDwjWy6bM?=
 =?us-ascii?Q?2M4FPWj7o07GWTiPZ26PhtAhMBBY0bGpYbaBEOawVvF6LJ2AIGXRXfh6mDxv?=
 =?us-ascii?Q?nuUUFp+GMiwIEMvLJSj46VB9wIheokBnUrCSelr54RczdfCPcljhaG4Z81Tn?=
 =?us-ascii?Q?Ycmu1Zke95pJ/cQKrI7px1hTCiCJWe4zrayeZtTTpps54HQ/t1rHEAPYi4aX?=
 =?us-ascii?Q?HWSSYiWXJOIChLn8Qtdd33NXvvpQqHd/PjBtlywVT99bRIevq8vWgnAdsNKI?=
 =?us-ascii?Q?5duZSjJEAnHQ5jJBi7uyfl3B/j6rgR3Bkzj/uIrkBq5nmcpLiOdwTwsWuTYl?=
 =?us-ascii?Q?a9pBzOtmDSeNaTWoEwGVC7EfjMyTxD9jvjT/MeGgSywZ7SmdLJmftkA2sDqe?=
 =?us-ascii?Q?mADiQwFRlG7wvkYTE6me3loTL9yvuaTLzOQUhj8hqAKwprKqEyYCKVaPxsSI?=
 =?us-ascii?Q?4btxaww2/XbWoZw+XhIwkcpkvhhgEmp/ZE4EDEKygbWtTwXAQvh0Ks1LFk7x?=
 =?us-ascii?Q?qAPFifCO+DNPkVdIfeZmLoskB11Yk32tdJbvN1/xrl+CrQCTreBfcntOXPpV?=
 =?us-ascii?Q?BPpOZs2YEvoL6Al/szwQ1nsoPfHkC/98Mzv57ICDX5/KQ/sOKuv6GQl+7t4O?=
 =?us-ascii?Q?p07nXn1Y3qM2PiHin4m2ESKewkJeOsHpfR9BcjV1CrlNeDCMzJZxAPd8f0UM?=
 =?us-ascii?Q?2P9uT/TuD+TXheRatgKywRlrFjIb+HEZJO6PsaNhmp52EyJDW3GRZE4ZgoZP?=
 =?us-ascii?Q?nUDlIs3JWzhwlMR64XEy6zcyP41V4C4XLR+g/RAFTQw8ZnAjPqxj1FlTd0nh?=
 =?us-ascii?Q?MhXKCOy0X4TdPlRpBVZ9ANIe0f2v+4jBL8Jg3aSvBa5LNiZBIZ/F107jQbC5?=
 =?us-ascii?Q?24rSqpjsaC9iggaIFbtEh2330Zog6H8iNm8Eg7fVrOgTTc5qAbIZFiPKJbIp?=
 =?us-ascii?Q?Cz3tuVTIgp4SKX+Lm3dg8lG7dub5Q7LXGcftcmfcmde0kusq2kE3r/rl+iK/?=
 =?us-ascii?Q?UUiZQ7zCqxZ7hbZgXD0BNTt4A3Tt3i0k/EcnZPUzPBDMTJxcPHAPSyFxfGNv?=
 =?us-ascii?Q?1vgYOIWDwIvw6YgBCfaiJfYE2Mx9VUfjYYBYcDKtg7siKcBownTLg+PVDyY0?=
 =?us-ascii?Q?yIWVVVH7Nz8vfmMFS6d5ulHz1q9sCHlY7cBpaV1NGqw+oCCc4jWjI0P/j2DE?=
 =?us-ascii?Q?K2DfNCK6fByp1HjOkCyBxsmSVe5KY7p3OqNANV/W/xGC7vZPv2sXGqUBWgZD?=
 =?us-ascii?Q?sxd6h7Gd6rHjZf1E49fPlWR7xNz+PkO2xFEJSPF8aUiBtR/j4v0p3T6SMvD2?=
 =?us-ascii?Q?KMEa3vgFoNoWOWK5UeUpav4OJPHwcJOeYNTq/0sNVG80XY7YD1QTaIGdCpho?=
 =?us-ascii?Q?19kvS3Wobm5X+CHrJWGbh3N/8KwhxHotsCg2CqVzK0VTo7g4M2jIAWpzTf9P?=
 =?us-ascii?Q?YbPneYbn3NS5m/VDw7HlZMe6BphYRMKI3qavpEtdMzriUdeb/SHHXOzja/Hd?=
 =?us-ascii?Q?y8HGFrbEC9Ak6j5wVDBvhfiRHTPMWhzCLwpAM1EYGaNCLdWOaZTD6mFtQVAx?=
 =?us-ascii?Q?0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0BED97F5BE6460408F9104A8FF407C3E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Boz9UYP712i7rJvSudwF0Cf3JsJpB86quHF1w1H+FmPtbHGzFdNEHBzVx4H2?=
 =?us-ascii?Q?yG0z0fbsld8kYKbLrXKlWEGLNgmwoYrQ4AwZdFkVlRKQGzB2aeThXArvcgdp?=
 =?us-ascii?Q?OYNhdpa/aA5UiMn2zCeqHtbuUsLQ9vexTlEnzM+CTOgAiPH0wmwH1KDXYH+H?=
 =?us-ascii?Q?H+gU2YluZcH9N6oY5REh9y5SLSf7q6VcjwFRBeowoD1NZ+Czm93+VoB8Xzjh?=
 =?us-ascii?Q?pIoAbHuBKGtenMFvEgyZEZsjSrIllr5Cfpu2ZwiCnt9RP/unmThW61nanaPc?=
 =?us-ascii?Q?/kmTOQ/KzQN0us9bBwD+dSimmri40EzgZgo3DsA+dDmF37wvz//95hRVwSoM?=
 =?us-ascii?Q?WHPqIG4ohqpuw37uGi5bboPlwsheuRr/YOgBNBS+O+JJBLlydvkjLQEovl+8?=
 =?us-ascii?Q?88qc1zvdXsHt+B+06LVxrSVo4fVpYJAPoyspRdrhi9zGZzZSwaX/zm/huS9K?=
 =?us-ascii?Q?rzol+l6vv1HPwN3+HPJpGBhaUZ+d2eKoKxhSqoruzJ0AtV9/bx76J8/OD4ZG?=
 =?us-ascii?Q?SswjmWc1R3ftMKVcLPYBVoL300siR4+4agSCECtKt7f/F5wMUHUgDYlYU3tq?=
 =?us-ascii?Q?sCHN9TwByymvpRT1JtWsbwxZ3dl4kvuw7obCoGsFWSpJFgMg5rI5C/xS14aH?=
 =?us-ascii?Q?iBWYqrZlp1jrR8j3d7Xl+If2w8cd/J2DJEdbFhCGyaQoYnqBEIWRSwCWsvpN?=
 =?us-ascii?Q?xoYfbkTMGtTisKI+310tTaiA+ATODDcErGRlU4/mciAbuX3HEn0K73aa8wkT?=
 =?us-ascii?Q?BGca4V7To9S2czH0Z/2158qEqRDOe8nV5Il839BtZCBxgQaSYsMbopNS4Jny?=
 =?us-ascii?Q?+eG0JcEHR3X0jBEzVULkJZvR9863XnxzNo9fciNVHI3G3tsfDsHrSfQFQgjk?=
 =?us-ascii?Q?+EOG3zhiWLURsrmebdoQdXm26JQDCXUZHhAUDRXOW3W1BvaXx1jGn7ROXi0L?=
 =?us-ascii?Q?LinmaCswNezWAOqY8kw/gaK9ce4sHrf6mI5Rco9ASBR7yi5UBieq6echAprY?=
 =?us-ascii?Q?L95V?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce39641-8353-4688-49fc-08dbb918b53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 13:59:57.4151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f7xrOPMVropV2p+dJ5cOLEYh7eBWml/itsItTLrjXU4BR7856nvvKf07xoar+wm7YLFwoUmzu9X4LIWovFkQbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 05:14:50PM +0900, Damien Le Moal wrote:
> scsi_rescan_device() takes a scsi device lock before executing a device
> handler and device driver rescan methods. Waiting for the completion of
> any command issued to the device by these methods will thus be done with
> the device lock held. As a result, there is a risk of deadlocking within
> the power management code if scsi_rescan_device() is called to handle a
> device resume with the associated scsi device not yet resumed.
>=20
> Avoid such situation by checking that the target scsi device is in the
> running state, that is, fully capable of executing commands, before
> proceeding with the rescan and bailout returning -EWOULDBLOCK otherwise.
> With this error return, the caller can retry rescaning the device after
> a delay.
>=20
> The state check is done with the device lock held and is thus safe
> against incoming suspend power management operations.
>=20
> Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after de=
vice resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/scsi/scsi_scan.c | 18 +++++++++++++++++-
>  include/scsi/scsi_host.h |  2 +-
>  2 files changed, 18 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 52014b2d39e1..3db4d31a03a1 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1619,12 +1619,24 @@ int scsi_add_device(struct Scsi_Host *host, uint =
channel,
>  }
>  EXPORT_SYMBOL(scsi_add_device);
> =20
> -void scsi_rescan_device(struct scsi_device *sdev)
> +int scsi_rescan_device(struct scsi_device *sdev)
>  {
>  	struct device *dev =3D &sdev->sdev_gendev;
> +	int ret =3D 0;
> =20
>  	device_lock(dev);
> =20
> +	/*
> +	 * Bail out if the device is not running. Otherwise, the rescan may
> +	 * block waiting for commands to be executed, with us holding the
> +	 * device lock. This can result in a potential deadlock in the power
> +	 * management core code when system resume is on-going.
> +	 */
> +	if (sdev->sdev_state !=3D SDEV_RUNNING) {
> +		ret =3D -EWOULDBLOCK;
> +		goto unlock;
> +	}
> +
>  	scsi_attach_vpd(sdev);
>  	scsi_cdl_check(sdev);
> =20
> @@ -1638,7 +1650,11 @@ void scsi_rescan_device(struct scsi_device *sdev)
>  			drv->rescan(dev);
>  		module_put(dev->driver->owner);
>  	}
> +
> +unlock:
>  	device_unlock(dev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(scsi_rescan_device);
> =20
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 49f768d0ff37..4c2dc8150c6d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -764,7 +764,7 @@ scsi_template_proc_dir(const struct scsi_host_templat=
e *sht);
>  #define scsi_template_proc_dir(sht) NULL
>  #endif
>  extern void scsi_scan_host(struct Scsi_Host *);
> -extern void scsi_rescan_device(struct scsi_device *);
> +extern int scsi_rescan_device(struct scsi_device *sdev);
>  extern void scsi_remove_host(struct Scsi_Host *);
>  extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
>  extern int scsi_host_busy(struct Scsi_Host *shost);
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
