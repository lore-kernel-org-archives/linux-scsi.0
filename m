Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E04C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 08:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCIIaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 03:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjCIIaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 03:30:02 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F92DE48
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 00:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678350489; x=1709886489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i1tSf29agAKGN9PDEbaIKXEY7UiP9h8FYm3J8o/JIRE=;
  b=DCVQ5fb+ySzFYKEXDHG03tI3vt2vPcCQGJJ2M/wdJB3fLuwS+epP2icx
   RdQNjKCqgqJ4SHlXF/hDgIzHlSM628LVXVTCqop7DgKlZYGdPoerxm+p9
   5SJeI1iY5yX3qPL9bzbDfLvNybQi2ws1KTEQSHnbOUw8PgLybWDSTE4g3
   1yQlLO/gLYmRVnGbe7Qr4V3Hx2tEUeoFwz91HVmPxKFoVKgcUp4Emz4jm
   kqrjQ9cUhgtn8V3swv4uFScm+qU/oeii9rnHIX6SZSkPSpgODCGeqUxtr
   l+EyyXX4BN2glnuibRUt6jWUYL3EZOO0wLLGV01PHLcoAObR2PZpeiYCs
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,245,1673884800"; 
   d="scan'208";a="224984030"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 09 Mar 2023 16:27:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyLZUcDEsoXj4LqIWtQ5Vo+SctCnLRQkTydldNP6E5DoU0sy8TxCfcmCvtBFJusO/5eYNleXJzuVWK0em66KXs9DXiXJhY6DKXo7upCCbIgAYdX/Imls3zyK725PQt0p+thZEwTPPm013uBPbxDJvp+dcMzB/k6hM/HBMavWcGJS+JkJxVe1H96vndIUcaF58/91L3FQnQzaipkedqF7o+G5IlQp2N5vaGkHb6NgZv43fKt3C9ZVIAm3bvwO985J5nNgTlA+Spe6zws7Q5GTxXnG5t0je6b1OOvUT0QbuQL1ZEMa9AR9NMnnTorBc9sZRlOm94HiV8bB6mVImZCsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1tSf29agAKGN9PDEbaIKXEY7UiP9h8FYm3J8o/JIRE=;
 b=mi3VxaQmIehQsiWIbmHCjQtdpmWuofEUrEtzYHj3u9at2mdBIh0HXk0Y9apOu4ozkoLV3NnjdVoAWoyO2hfGf0vI5TsUqlg34qMb2pOd8w1zdPDu3WSymal6SPcQhYFJe4NZaFXbQVuO9Mr4Xrzlq7rVPg1Ii/AMN96ZwJpJQmLj2XQEq8f1wvzYtQPvJjOrODwrGzxAOHhpCfrkxW6y6QZHeIh1ZPs6LUdhv5HkAWbsUHq46l3nnGzAt1i9fRpSPQLZf3aPppoCS8iQ702GfiwTUp4MsrkybxOls/DmZSj7Z0UD7IZRyxo+wx3uvt6udsFKy5JiDao4eYFXiG6Wcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1tSf29agAKGN9PDEbaIKXEY7UiP9h8FYm3J8o/JIRE=;
 b=XLWK3TF4QqQUm1LznqlH/zY3xGLR908mY54K8Uv+O4yCvG2RJe5w3Bts2SIfiXkLD5vrBrS2FZ/Ut/VWYXbs2skB+i95FHnkJGjsml2+6Q3G2u2BnzaaiKtOBy0ZglBixdStNpbSKyyzDirQhFDuZL2U44pA3jvElNslBwDhyiU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN7PR04MB5427.namprd04.prod.outlook.com (2603:10b6:408:d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.18; Thu, 9 Mar 2023 08:27:44 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::1b90:14dd:1cae:8529]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::1b90:14dd:1cae:8529%9]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 08:27:44 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        "syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com" 
        <syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Fix a procfs host directory removal
 regression
Thread-Topic: [PATCH] scsi: core: Fix a procfs host directory removal
 regression
Thread-Index: AQHZUmEFjWIlUI7Ur0Kxou67LsPI8Q==
Date:   Thu, 9 Mar 2023 08:27:44 +0000
Message-ID: <20230309082743.sb45rbgje6uuhrrv@shindev>
References: <20230307214428.3703498-1-bvanassche@acm.org>
In-Reply-To: <20230307214428.3703498-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN7PR04MB5427:EE_
x-ms-office365-filtering-correlation-id: 7d32ba2b-36f4-4c72-354c-08db20782840
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RUIaq2JgtEtSm0OiFn2vPXNsUXKsgBzY8AoCoAU2gTVJjqeGfCLQuRFQhipNzeOTaPbONK20easJZnUzmmZS7chIm+XRa47Su4MoLiZFzOF1yhkPcpvxU1CvcsOvl8wIKduKguBk/q5RwoHUDtQZSZ3AJwhNKVfdddaZGst3vEMsNQrU+y0hdXWIRgcPmpP1ToTNNrGfIdehAXmKEKvh0VUACWHS+eQJxin9XKE0DGuCwZFfqovfLXJknRKpo0hOYqcz3RDjmCBBSimk43nDsoxHoBcyuPpaJQxDFn82kFgf3Shkutp0/6ECIW3KXxOntybkXLX9blaMk2/kklI9nGPNM+rBlftTw3GFfwqO9RDS7rLw8HULxd/eJ6B6gsX5sBFBEggUzsZAOTPX3TexRV2dP1+rwKgeqYmSdRhcpHUSkgCP/Vo0V/pOECAa3x62SdxSQYry5Aa3ecQjc8fAQSP5pjkpWW0Bor+nFphMsWPdvUWVuYUNeBYwmZlOsvfASZQFwpWGc0roZNk+/rKG7nEI4ic+4zwyhMRwKzJ/GAGVuUmbUAEMc/YGB79rEvl6qsEO399yGwAS+QZxLEgCD4aO6QFB94lRDav0j7WnhHx1aMztMJjM12OcFUF0JEh+HIXeaK1bcJMErRrRpeXOzNvQv8wkPvzM3/pquGpOk1GEdtC6SlgrURiT5wR0uRTZzbxfc4SLiX8WRHFaTP0rAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199018)(86362001)(54906003)(186003)(478600001)(6486002)(316002)(5660300002)(64756008)(66476007)(44832011)(76116006)(4744005)(66556008)(2906002)(66946007)(91956017)(66446008)(8676002)(4326008)(8936002)(6916009)(41300700001)(6512007)(9686003)(122000001)(82960400001)(26005)(38070700005)(38100700002)(71200400001)(33716001)(6506007)(1076003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tMwYkLNiu+BSLawINF4XtvJFc1dYl0XLSgv1UdGinIhZ4C84oUp3AiXK8YYN?=
 =?us-ascii?Q?Hka1OzG/aAVt0g564NEhNSdGLA4MusffvYahkIJfxtOppbCZyqb/wtVMm2ar?=
 =?us-ascii?Q?+TDEQSets614usCl+g3HWeVXHPUyMSdGcXl0jIEc24kSrNr5U68cLTU/AbQs?=
 =?us-ascii?Q?34x2SQIcmgjx5fiHE4x0/c3YRmS7as03sNjjGJ4o3SWA3kd+osBok9NtgR3V?=
 =?us-ascii?Q?eqkY8eJOMYtQRS9qh6qtFOrjugE60Au+Q5mkfQGNFulnt5bs46/cehSoP6I+?=
 =?us-ascii?Q?ZbX12zos5feqs4swxNEEsAMDS4QSavt06tvmFrRgbP56q7EdNFbqubG5e+KA?=
 =?us-ascii?Q?i1gS/kDofFCODfWNRmnD4q6yEshSq6HI8B7I7ocFYMcx/Bgs2/mcd2UmSCiy?=
 =?us-ascii?Q?0jt2i5aKuou9FnfFylciCyje19Jrhat0s7Jrnm8etNR4FU70vxPrX1sMexjq?=
 =?us-ascii?Q?g2LD3ris0DXkm6YsqvxoWF6ueep7lexbFzY/6M7Hfy4WZ+L4MBp3E0nNRF1z?=
 =?us-ascii?Q?ipRjeVo1OUobgwQ11lD5scR7l9i/Tkvhe9XJGpy/jNDVaSjoeftFmzBKdQYc?=
 =?us-ascii?Q?C6sLX/OMpBgmbjYrP+MmGr6wo3zmbr99YYJ3LC9tKkv2TZhXg11ZxMro7cyV?=
 =?us-ascii?Q?CR3yrb39E3vA6y2oGxAonE/gnLl7outFL36cvtH9BYyMI/icrab2Viy96Pdi?=
 =?us-ascii?Q?F+QhRUIT3Ipef37FcZJVuN2Cni96Cxy2mlFA6grx+YxVqNaVSdm19lrZTG+0?=
 =?us-ascii?Q?rp+Be6SpWjm7i73XVKNAUo/jNBNfLuwqs+8GAB/w1+8WZJBmd6D3ZzLP7Kpn?=
 =?us-ascii?Q?s5C6q5q8ERj1OmiXfKZoWC1aIkhWH/cXsr1fh9HZVtO27EE5HA0eWH1aFjX/?=
 =?us-ascii?Q?55vjYI69kTdmPsWbcW1VsgPLeI5xLROFw02piGSOsl9/hjociLYCIMbkhGlH?=
 =?us-ascii?Q?skMOEqqrYcy49G6ME2md8CZV+bl86jGv2eOvqUOaPNKh4VxH7Czfy9rH5MD9?=
 =?us-ascii?Q?BXrgEtPHyJInB+YSpAaMFtQ3LM2D6znP8UvUTxbhyNqtChTVYQHmoW5B3z/9?=
 =?us-ascii?Q?1lld4EiB7AA6MEkJAW3H47VcB+ythZF0E0EsnUZlE2Ika39b9CZz2o1SxdNo?=
 =?us-ascii?Q?gT8fUdCZOBQc5QftgmG3P8tD1XgH+kEmS91XyXXfmGowGrGnB4pwFHGBClXZ?=
 =?us-ascii?Q?hQu0uDvC215Rh9+RL+/Hcr2hBg/eM73IRTkeIbnC7NHi9XXqpu5CvioRd9V6?=
 =?us-ascii?Q?kwvyaBtXNzKDHMuDw+Orc9LyiuWM9KQNNg+ov8fFhx1axvvHv1SeqUQJG9rP?=
 =?us-ascii?Q?XhXMNSlGkYqmNv9cjCwksCi6Uyb4bzO1OY/XjXuyHe/agTDioB5zwgfny39j?=
 =?us-ascii?Q?tp1EoK753tOdvm+Npsh2P9UEuGN8cvRoXJC7dNxPQSaSDpYy5GITX00V/pXf?=
 =?us-ascii?Q?CYpUlQQUIzg9/tSgKbmnZhlJNhjKyVoyX0IlgcbK56BB8+cBtqxFgH1NwSC1?=
 =?us-ascii?Q?kVT1oO4KytF8OF4OVh0uamo4feNLXT69cvtkCtRDpYS4TGiouas2OEijgu3t?=
 =?us-ascii?Q?J1b1rmIZIkusK4DpfKr0kGAebFnIj8X/SWmw27608JxcGicaipZzVwQCsD9t?=
 =?us-ascii?Q?Xa9xS42dLo8Q9LwcQVo4vT8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <950AC0DF37589B49B7CC75B0CFD858D8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Q6Kn2uW3VKnaWsGu3FQDjMAgaKPh3F6AKaFAluIZS0wXZ7ZgHCps8utCKP3p?=
 =?us-ascii?Q?get+6On2aq3iqDLLZFhsxaLEmeRVsQ/+/xhfv6+XH+PB9+1NGmUrUGk7kjfz?=
 =?us-ascii?Q?gMzOckXr3MZt8l4mbQrBY6K+hu8Tw8ZwEU3PKuXS99CNoZGmhJ+lMBXElXOx?=
 =?us-ascii?Q?Ui1qn+mb+61x5oMELcSLquIJF0a9cT3j4mTbZc/ZVnGTfT7a4dyTor67n6kK?=
 =?us-ascii?Q?PBR4jqZ1oLSIDM2rRhLnOMMzTnO3rWAEnSgCO2mcp7eDtBVlWB2SEoGk/yyo?=
 =?us-ascii?Q?fjvM70JeIf7G2X3bNExHoVUuBoTtC/C4ll1Xw5laBD7ydQ41CeIHxqRHUuey?=
 =?us-ascii?Q?lgXi2SPbCYDS3BICdI83FAhR7kP9gvLLCrIoZKXX++TsC33qQ5ZGfe/NfmWJ?=
 =?us-ascii?Q?piFG8ERRsSmi0LpMiS1Yim9KLbODE/zjYpAIDS9MN+P4HhgmRIJSGnFq/yhF?=
 =?us-ascii?Q?9AozC9jrbbjNYb4bNFwDJ8vnIsy0xnA7n3pHKAnhBQcUXW5HiF9FB0TjUG6l?=
 =?us-ascii?Q?dZa2nQBVzt96SmXiGa57altGcEygfNNvf8VN2wPD5pkyfi/jVGIibG+ZTMZD?=
 =?us-ascii?Q?LxdDTVAkw7CFHcXS/N2v/cAkdHzdWFAPs+PJJ4BRkpjG1gyRsd7c52fimZwY?=
 =?us-ascii?Q?6+AYYuf/uAxqJcZelXm3YFN+K1ExafeizwGNwWdilbZ8EJhvAG9Cmxc14gzU?=
 =?us-ascii?Q?1FVevfHF10Qwf122MTgLbEHX/QJN/CSLdWoxaWKUurYF+pl8kI1syxy+zSaJ?=
 =?us-ascii?Q?UHAo9+DRA1sgmpUx3evvJW4X39Y3O8LeDCiTQ4xCdlA/eeNwjNOzJqHxxXJY?=
 =?us-ascii?Q?Jrd5knIGjAI78fNA8w7dltM6kQ2dfX3t+ByeX3fpgbi3a0GRp/ndHCA+Nvvy?=
 =?us-ascii?Q?EGXqruZKoE++l/roknw89p8D/xMyBGGLS6xpxI79DKcM35/4bLG67tvyJgci?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d32ba2b-36f4-4c72-354c-08db20782840
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 08:27:44.6049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaZMx37wMTHS3H13dhRS3CM19l+fSdl/Xhqo15hQxxwiRnVwBps5bZvRuGfgi1J4+SYAIC+f/7aXclc9lpC+F5RI+5KwNRZreVXEIp26oRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5427
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 07, 2023 / 13:44, Bart Van Assche wrote:
> scsi_proc_hostdir_rm() decreases a reference counter and hence must
> only be called once per host that is removed. This change does not
> require a scsi_add_host_with_dma() change since scsi_add_host_with_dma()
> will return 0 (success) if scsi_proc_host_add() is called.
>=20
> Cc: John Garry <john.g.garry@oracle.com>
> Reported-by: John Garry <john.g.garry@oracle.com>
> Reported-by: syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com
> Fixes: fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} dire=
ctory earlier")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

When I ran blktests test case block/001 on the linux kernel v6.3-rc1, I obs=
erved
WARNs in remove_proc_entry(). I found this patch avoids the WARNs. Thanks.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Shin'ichiro Kawasaki=
