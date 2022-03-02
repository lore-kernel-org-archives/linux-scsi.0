Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D205FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 14:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbiCBOZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiCBOZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 09:25:55 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EE1C5DB9
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 06:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646231112; x=1677767112;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rlqDNY8Qa9SW/S4mmlJgP1LXTWVJr9PyqtsIr5gEnjA=;
  b=WlITTrqudTDIDN4ZAtOpxV2qBJy6U+2mevTXTAMGBrFGTJ6yX/qgFBtf
   r4AehD9kR2DA5recDSeF9EihG1/XuPKIPfa5D9e7ZzhW9NFfL/88dz8+1
   gncmtwrnXUho+MSFEauXnipwHkiEtcdE3YwHK4jYsDU7Rp1PIixT+r+Me
   WVepPDhbGG+EgOxNwoti21hRg7xLyWQUaroFCE9i6BBZuwhMkH1eYacda
   Tm/S1MUU0OQkrud3mRjjWn0bwEiHB/17Lzfj7QXvJd3cstyUhAwjNOWtN
   JnVRyix2PsOpk8m+riLunKCWuz8lwo+w+pwvFllK7p4YD2YCyKbPZAN5I
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643644800"; 
   d="scan'208";a="194296088"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 22:25:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePfSO4NbNMvCVIETomB5q5L/nSsuWExSwkcCgaeJCs/wzYuDHW3PSJ4CnqyRNrZbN0NNpM9NHF+V1TbYaoY6u/ckaV3Qjgg1+8TbueGTFLNsi65BmzW8DvXbrcN3WTn6wKJ+XpJfRIHT2yzT6KSd7P/PVY0TvNKwy4x5QSws0XOTxqiOnJgblvSIi9Q6Mjc/oJJ5oCKfWagUkcOGhHYX2vSGkNw1j09CWYVItXEDn9r9wJmKpt72nlNw1JWuKzduYlticHNFi/9/3yDrRL7OBBnUv6Jh1xW8vkkofuSdWF1nqyfzrkBJ0vG3bpW5/J91qJuP8hEOv+rno71P0dZqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgbQKpOPLaL/tCiB60mimnZjaKm/bH8py+ter76j/rA=;
 b=I/XFvfWZ3OZxsXhOQukKq4ckKQaNN4IbK7Lp+1A8lWEG8+FAV0ny5UtMDBTZ1HRpefgyve4nTxQwo2lg7X9VAQE8TNyHbTP4aTFjJKZkc4tXF2s2bSX+hYQN2tXDisj/nF5gDJ0ArqJ2bAxbrR8QDOcmIaNvTC2g+/BACWgJwYUnByR7rI08lOOPhz9ajmR261kTc3nEx5wuYAvylxK8m713NnI3r4Pu7dHTR2JJgF1Ste/KnHFgQYBMHx4DULj1sCETf0nF7yz4a7pjwfg2cvfr1j4wOeJbz5QfkzpVubQ5H/pOiZVrTai8Di+akb0SIhaY/+tZZK5x18p55rwCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgbQKpOPLaL/tCiB60mimnZjaKm/bH8py+ter76j/rA=;
 b=VbF+NzfQkDfazs/PIDHK0ylHPZ7amoIY/rf40TqPP7ZMIib+djSupg+LDHy1tlfvDuWYLiiaFp6v/6xmu7ROwDMWJH6r5MCRueOKFycVUR9xHFHqH9r5Ad5PdJHF8SXoHTIVzTvpqIwpFi6T/kF7h5zseRFnAEcxR8knyYvJMTU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB4438.namprd04.prod.outlook.com (2603:10b6:a02:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Wed, 2 Mar
 2022 14:25:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 14:25:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Thread-Topic: [PATCH 02/14] scsi: core: Query VPD size before getting full
 page
Thread-Index: AQHYLfeDHZBxLJziUUiMx8hje7uwUA==
Date:   Wed, 2 Mar 2022 14:25:08 +0000
Message-ID: <PH0PR04MB7416D285ADC638FB1A704C239B039@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-3-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e482b6-eb4c-4adf-16af-08d9fc587408
x-ms-traffictypediagnostic: BYAPR04MB4438:EE_
x-microsoft-antispam-prvs: <BYAPR04MB443830840676C1CD633CA8A19B039@BYAPR04MB4438.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YsEfF/AX7LI8KuG2MLfSIs5kVSyEA7uHu1P/DlJeM0PqZ/ILHN6E1uf20Uk2krDTl631dQuYdJgTKQdNydsIUle49deUtUR5CxLayZ6MaL5ks+wHFJur1Cg2nxBkW16QSqfgpuX84Ytxqg7zMvYFSEi/M9JMmPpyCEtiDMnkswTsRN0UEbmjJbSp3vZ/qBGhl+7dvzasyjqPiV2azfj7aPS0aasPskQ9abD/ZoGZKCb5n0pSKsng0pwZ2lvG2Cb10xtBNOUPCFocM2f5oT+2T2MS8LARrxSW7riBq90hsZzIb/V2S8hkkLQfcvQLeV1FzOwbMlDkGrHmZtz+hbHxIgM2fyWhJBiaYJoXiC2Zms1cwuuu3oyQM02k41q7S1G9GAw7DYGoeVEw1DMWoahHyoAoIH9HTpO86QkdfsjFUWFPPxIEOZU5lAudLJPeWnZWDSZaknNF3R4ltSQvTEQ8cvN8tw0NgiJoQOtWB38dguMlDBNCgjOp63CzKtchbOEHfRe21cIMnmd0TglN1ADy356mgpB5iBSzYqIN5LUiGqcQXpLcVEwlE86C2Fqk6llnHB5FYpYCbJJZzb3OQA6WbeKGMHudFNMcgTxgJekKVn6t9KWSwKS/oBFssgZeBf0XP0m/m7GkH/AFVWV1HVAsEvH2NZ1vPpETfa8eqGSUOzllSWyxFp49M4IPOgxr4mLK1PJoUl4nEUzgeEQsQi99eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(83380400001)(7696005)(6506007)(508600001)(66556008)(66946007)(82960400001)(76116006)(91956017)(64756008)(38100700002)(4326008)(66476007)(316002)(122000001)(110136005)(66446008)(8676002)(5660300002)(86362001)(8936002)(4744005)(52536014)(38070700005)(55016003)(71200400001)(33656002)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O6iyuAXu9WqtLVXBGmmHgFE+pNZzEE5dG/SuTSTQ6tf2aAlQjYs6IM2UZd6h?=
 =?us-ascii?Q?YEOHRfbxpd8jdhOmMOSxzLJe15DxtCgnVWfWrKlb928+LbaQxqNkZoCjFMfN?=
 =?us-ascii?Q?yF1Jv4n4ICGAdJkbFQzfpX/UdBLASYLYweiYoSRvcPi2XUzSmAQjBtE4ap8j?=
 =?us-ascii?Q?qb2+PkRu0+MViMhxeV5UM3eSWo9V/v1SINcZAUTrmXz5GGpImaN2764aopoT?=
 =?us-ascii?Q?NPalNr3S59Gpl7gX2vwX2eTSiKW/5DuWjbKElinhAwKy9aWcZcD3w2Z3SVs2?=
 =?us-ascii?Q?k7fJhHjkdz3At0Wup74C8QeA0Cy/RupYKuVz795qMNOkvwMr/1cYV+s+Gv+D?=
 =?us-ascii?Q?3c3sM8bl+0vOBhz0mIQcfAgixRpheneqwhgPuzrFJDTL9S7VjS5yvZgz4YgU?=
 =?us-ascii?Q?aOUec9G6Dzd23vCJatjKlJdcTeWfNw/EHJLAur9FHu833LrUdQLwHus/3KF3?=
 =?us-ascii?Q?scBAq/OHuJkyuOfXVGgIBWqPVFHxFEynHqF2JIWhEHBXDjkvR5wLCSLsbFqG?=
 =?us-ascii?Q?8ZlOHo4fSgLb+GxOnfK0wxXwXO6JfPblFJ2srV0TZJ0L/IK6ArJaYQETVp8s?=
 =?us-ascii?Q?Twdjk4paJ+rKze3fvRNdBl3C3sqssTy0h0k1TCo9W3J1cyv6pHKM8ytZHjGq?=
 =?us-ascii?Q?PWJPDcXNh7Ic982qzOW/FglgAeKbNQp/KFz3bsxJbfmqhp4CT9MzJ3nIKLGn?=
 =?us-ascii?Q?+gqdIbp6p10cLsDBrcUPthmiIe3p5nFksu2ngFXsmROAn7GeiBTG5AJvxUDx?=
 =?us-ascii?Q?h6KrX7dBI674AwYYGJbNB/6k8z5E7ihUQw268nvDYBnbQzkPs40/KLg97d6a?=
 =?us-ascii?Q?kRiJhViRa2khv8WfqCMDdAtRNhl0bq2Wpi7vM7PtcLPiH4l78Yg45W2HAL1Y?=
 =?us-ascii?Q?4o11iZD8vCoN+B9/aZW/2Q/+vXR9lx2HapMPLY5wi72fFaiWfEwNQnFwuZic?=
 =?us-ascii?Q?3KUD+JHW/xAY/rWYD7pkEqMH3jxEyTJEMATJj/oT+wC/NWlA5f85fVpFytD+?=
 =?us-ascii?Q?PuYOJRuKdYSmD3tkUbtx1BMdBFAMBZKQqkpCwTsS9HqDHJAHFMgnx0VUwaKE?=
 =?us-ascii?Q?VwkVEGB7Phse2GSIrQ+Ojg8ZsP8Vm+A62Sgkp04yxxzW94FVF+EsCDJYheV0?=
 =?us-ascii?Q?7k9FaWJ9fJn5xIwMp3YhK34SoT+gaJKlW9HYW8wt/Hb6EZO59qCP0jI/WJiF?=
 =?us-ascii?Q?5/Vpi5YP0qoAZO3s65xEsj4RiQsqXixGk+MKECxThCU68FKR5fkWwr40Ggp4?=
 =?us-ascii?Q?wlYksdqHTjv7PbTDiHOJTfqS5jdpFU5pq1DsyfK1g/GlGAZB0geqiShJxLVi?=
 =?us-ascii?Q?gkiU636kHl8AJ5ZXSHY9yPpz0OPw08Cf9c1H5qKpBa7JTX7vo52HifrXxzzY?=
 =?us-ascii?Q?l6vh/Ynmhj/kXSzTI6jIHi2y71E+rHvMAvch+w8toFZ98SJ3Yh23L/NNNy7/?=
 =?us-ascii?Q?fRlPoqTiEjmuddk1tgNPmm1yLXKAOgMx7BSjiCIn3WEhElSV/8tSLxfbVhJs?=
 =?us-ascii?Q?u8VoFcpKvJdB5TyFXPnk5wZfAVJN01Oha+mpW3kztePnfQDmwTsKHT+nGyAi?=
 =?us-ascii?Q?U6m/VWVj+GXh1+D1YEdwyxK+hWaKFKU7XT2yeS52f9HGpYUyPpKa6lCsS9sk?=
 =?us-ascii?Q?YQzo/jBjzL3N8+TAjGG4gI5D1tOVcFp0T0PYu+vaIQIpDYw6c2p8BPBTs3Bi?=
 =?us-ascii?Q?60/sBWzhz/j0KGuPUfhPruXwkrO69R40Ay9Mssq2hs+HJuRbqPflKsg9BzwB?=
 =?us-ascii?Q?RL2nW7MGxYAx158MTdVp/ZQbfoVJWCc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e482b6-eb4c-4adf-16af-08d9fc587408
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 14:25:08.2082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7vpIBFvjQepPzY473lDogVCCAySC5kE3o62xtzvi4zJdZvk5Yaahsef70s4Kftp7kSllvRY7eAMhfGhUw9nKNHiIgYsbVt5l5DGqQJmt9M8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4438
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
=0A=
Two minior nits below:=0A=
=0A=
> +	result =3D scsi_vpd_inquiry(sdev, vpd_header, page, sizeof(vpd_header))=
;=0A=
> +=0A=
> +	if (result < 0)=0A=
> +		return 0;=0A=
=0A=
can we remove the empty line?=0A=
=0A=
> +	memset(buf, 0, buf_len);=0A=
> +	result =3D scsi_vpd_inquiry(sdev, buf, page, vpd_len);=0A=
>  	if (result < 0)=0A=
> -		goto fail;=0A=
> +		return -EINVAL;=0A=
> +	else if (result > vpd_len) {=0A=
> +		dev_warn_once(&sdev->sdev_gendev,=0A=
> +			      "%s: VPD page 0x%02x result %d > %d bytes\n",=0A=
> +			      __func__, page, result, vpd_len);=0A=
> +		vpd_len =3D min(result, buf_len);=0A=
> +		goto retry_pg;=0A=
> +	}=0A=
>  =0A=
=0A=
Adding {} to the if block as well makes it look nicer IMHO=0A=
