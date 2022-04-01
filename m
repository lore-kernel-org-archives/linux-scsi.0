Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DBAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 18:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349918AbiDASio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiDASin (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 14:38:43 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A341E31AD
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648838214; x=1680374214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UNbSOSR8LsgZnCvL3qYan/v1Lph6vMCRvV74/8raoU0=;
  b=Dk9yBxLO9z5ATAG6+haD7odhFhGimX2ZDxe/TAajX4/fXcSxTZEOpv29
   Ni2l7q62jLXjrTjyK8Il/TP/5bRLdsOyUrota6adw8czwQ/X8qpSTpgWH
   U562CVvTTpyLXaE6tnNX5lt9Idst0QjJDcxEjzZ99OIh5yfFqmqFmGnty
   8WqX6fHApiECLnwxRTknZ9r5+tjZF7ekBTz0vCC8vkHR3pbjJXzk9ifCX
   Uh6FO7uugUa9T7haMz/n0trxY1o8qCuQ+VWVMTZHfpqHIikTE3ruK1vON
   Q7Ec2+FIb516Pyn7AjhMRV/5Bz5DtxQdSpGYsgoeJohEELRb0P7BCvPJd
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="301029407"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 02:33:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS00Uz8uPZYU14xLYRkmOzImcE8hgO5Mbct9Vb/gAkg8yXxmh/dtPBuPj1Kz2e8l8HtHCyQOZhGo+/yfgcJ818QU8Tmfak8eF3rz9AkZg+/k3MGEjA4B5IE6MlpNlf61weOvWQhGOCGPrU6mCHxuWiBs/kIZ1wC8VBMyk/Vj58gcgcCOswi+m+zgGzweyKOswqu4QBF/UfUDwObYmm8e+420mnbEEw5vdt0phHmHgit+Y2SitxGY5TWugLGyDE3E1KHk/AT/Qu7SqAh56CCWYwYKYIXuVQjHThR70iU/YiSWniyr4igcO3bSmrttrGlEV/WPwZ7JEPGeRoGVdHJ0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNbSOSR8LsgZnCvL3qYan/v1Lph6vMCRvV74/8raoU0=;
 b=AGT135M+drbo3ozvmSCaSHBNlwycTlIx/O18WEFyF09QdkYftDfWAyStohE2Kleb8x8yxT+FnOtVnytwtukOInuVjx3DfJXCtidso9DgH2gqL1zTobhp3ZlgEeU7R9s4XA6Nv8E9fUYTUHhZ4PQLBSKn3brH5MbFof5kXMIAu6woRz1D8P9wLhD+d1iGvhsZa04mGRjIdM9Xms8f1ngG7419S0oQ90qbZCtewYJwp/idl3Fs+T4i4STxM/W8ktPjoYRizMznNpdp4cDF9q2TYoVRFFaETDglxI+VXQvwWnvhyB6U8viZFaHhFX7IxwgJz/xq92FUpUdKK6mY9qU/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNbSOSR8LsgZnCvL3qYan/v1Lph6vMCRvV74/8raoU0=;
 b=lekwoSN7gxQ68ifUqispTciCARRzEHR04bQUQCTVHE/fbjm6/3XJV1quIgoB71Es/W1KTYwB3MmIuPBOYByXPuzfE+gHTHNNMvz7pYz9rKBfWBScGnAY9br/XO6HTxPrpXLCHGIyIES4TwTO1vGQlLV1euk32J64Z4uGM4ycPKo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5191.namprd04.prod.outlook.com (2603:10b6:a03:c2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Fri, 1 Apr 2022 18:33:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 18:33:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 01/29] scsi: ufs: Declare ufshcd_wait_for_register()
 static
Thread-Topic: [PATCH 01/29] scsi: ufs: Declare ufshcd_wait_for_register()
 static
Thread-Index: AQHYRU+MadySc4ntXE6wK54K+npbF6zbYxQw
Date:   Fri, 1 Apr 2022 18:33:13 +0000
Message-ID: <DM6PR04MB65750B3D2BCEBC2673C8C8ECFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-2-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6768b5be-e8aa-4060-e54f-08da140e14cb
x-ms-traffictypediagnostic: BYAPR04MB5191:EE_
x-microsoft-antispam-prvs: <BYAPR04MB519179C273153FD75EFBBE4AFCE09@BYAPR04MB5191.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HWALU1o8OMTci9RKKbMNs131DEbLqjexH999a16sYf6XnqaINGW8FE7Cg7GEuZ6VFXsHb08AsThrbwJxKqqPLJtBrO+8ekFJQgPq5rhzUrr9+S7RskGRJGwwtfT5QZkU5GR38ESgTcSbo3p7U+ST2c0EuJjdfmYkWopOgOXCBvHLxz1Vgu2B6yQX0rQ1RWJQ/SL+mKm+Beuff2eKXzRgzNLGktDemZXCHXl/+13rrSoPoVlXB29hooBCGpDKsImd+KVOEl1bI5fffZV1sdXcM2Gp6lqIZTURg5xiBZoDyhVzlCWjRvi/Mz1J0W7ZXlCUT0mCKPP/X7JyN7b4bMtbs+YsrN0IRhli10pQjC8w4+8TG36jrCvBk5umoIxbrWooAAD/RSZUWCUGo8Cw4FU+vk+S+H1upfBb7v/gC41SKiDOIBlOL6onq25gO4arKVpleQX/tVK2AL14DeotO9TcIDV7YD3PRWhX4rCSVLt3pNtyYHosoTpRaKOfFWKsNyHctOgKO00V903G15l3z7oAS4juswXPrJdpql4ndJ9ZJawP8NyVWuJozQN7SDT7mejlpdvJ+2MO8he0m9dD2zsOfVJxr9S8vim/TOJRS0N34LdEgGzdhISzDjLYEcom2mGAv5rjUgTr+SRDI1HktTZPy1WTEgTpLbVgSqddzIxjk16JPGoSsMBdgQXB9zU78o9yahCiEkj4TgJgZXWBx9ZQ3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(38100700002)(52536014)(82960400001)(122000001)(2906002)(8936002)(38070700005)(71200400001)(33656002)(6506007)(66556008)(86362001)(7696005)(8676002)(64756008)(4326008)(26005)(76116006)(110136005)(186003)(54906003)(66946007)(66446008)(66476007)(9686003)(508600001)(316002)(558084003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?51cH2Ndrx/RstQmm+scBBbGHm1oHAT8yQrrhyzyd2bUNTnIHrh6r1nSmzVut?=
 =?us-ascii?Q?g4VJn4wTvjtCtHnSTeMYmBFobdx6IzA+Bej7u8llbTCImk8OBiFELNLWxput?=
 =?us-ascii?Q?0By3m1FD8YiEPo9OZZg5z77i8CuFZhEIAyh4do4mD87L9yBn7IJPBjPKInZI?=
 =?us-ascii?Q?fLTCxYTCD38tQNX9LYW8QAywLXIGZptUo693hsOczMoQ7x/a6t6fAPchDy1o?=
 =?us-ascii?Q?2O/OHBH/vX5qqI7W//427gP0Y34RuvY5A1vF/WVTxocmrBIEgeQtvErx1EhM?=
 =?us-ascii?Q?B4hjgN2dKciXzQ7iKYQHCepQu2bnn4LlQBQALot3Q8r8vH5Y9Bi5TjU6/3+O?=
 =?us-ascii?Q?EwqcrPkdDa0BGk9hFHwQKqdUy+hqsV0R3i9zB0IeSTohc/2X+aUeHndaSju4?=
 =?us-ascii?Q?BH7vXfYvWVE4HOKNtiyo1TNa98WDNLj+Cpaf5cTTgG7nrm0KVdU7usgdnfrA?=
 =?us-ascii?Q?ZcshLHDJIHhXo4xQILoHfFgWt6pVS3cPOejjxRX6TGM3cunTpG23LXGV65Vk?=
 =?us-ascii?Q?WV8I9gSIa1Z4DJd1esWbFtegDdONBMi5N/P+PVoKWmEFoUkrTv7QqpEVubv9?=
 =?us-ascii?Q?5nLL3aLhguJJKdD9sqjLRdHSAe7/flGqvxPN+TcQGMBC8DqL3fjZ2voB0N1f?=
 =?us-ascii?Q?nwt89jdB0ZYDsEtSJPbUdyg6dEE59LUiGwiY5aS2lrXt1mj2QnJ4tWOV1MQp?=
 =?us-ascii?Q?mvnR8LX9ErisJjfXNHsMA07di593lu41tLn3DeM59oJ/qCIkmI0KSFzlugi3?=
 =?us-ascii?Q?JzkDwgScjfoD2XikIPb+VzrXZDd207WXS1/Ss8xrxBMwoFTwHH3ptM4Hzmic?=
 =?us-ascii?Q?tZsPhsoJKV3dKWAis6oZfafdo8SltbxUcsOZQLZnQ+bcGdzlrg2PDY/4q5x1?=
 =?us-ascii?Q?PKH9xobRNyE/6Au+ksfjMt3ypZ1A6+Yuj7WpfBtzR8h+cdSexGD5K5/kh3FC?=
 =?us-ascii?Q?sxLOTwezw48nwGTm7x56atZYRLVKR+zymhw3c1nY/srnp7xmLVM50axxIE8Y?=
 =?us-ascii?Q?6kyIQDQs3rNkM8sScSG4XdhTssCdO3Jfk8RGBp1I/GRqMfzZgQ2T3mo8jx2E?=
 =?us-ascii?Q?1DhexJs7nxUCI6MptSlTUDYvQUgT5FORAEl/PnbqsEc4K/TG8IRK8fQbdQW/?=
 =?us-ascii?Q?S3x/DmNQiEo/dWQ+2EX11Bje33E7rCPkb+7P0i4VDYznVHcElrrmDJ1zOhSu?=
 =?us-ascii?Q?sifmevNbC0wPCaU3vQ140bjfZ7Gi7yMBS4kZgRsmD3JGs+AfapadjAHAnqXj?=
 =?us-ascii?Q?91b09t1GrpEyBsc65uhx9CLJmCxzVsnC0fFGoJoAIyYXfiep1+ILr3A3Lva+?=
 =?us-ascii?Q?pSVQB4kowqXXlnmp0iwENz8j4z9NBLwW5eO7pEm1mVlrkaNpnBV/J2PBx3o5?=
 =?us-ascii?Q?wMkipv7dnos9U4FufHqNPbrLJyhdl/gh2+OdpUjZ2RqmrybFv5TGz5+8hMm2?=
 =?us-ascii?Q?meSD4Dy4mNv/zytX21YXhEFc5qcDR8k5gXrt4LLUU4Dhf5lpuB7vFATR7X64?=
 =?us-ascii?Q?8b3G2gxZ3V5bNPec5eoZocpW58F9ubccR+ehwneTVSbb88ofur+JzTzJLzOB?=
 =?us-ascii?Q?zSf0R33RUlz/xFIS9meaR1cD1p8ZGIf9LoebDFU9jLZNNh+pErEZFbYFPjvH?=
 =?us-ascii?Q?1Bd3OwSUnLj+gUodSz+3kpFcmjzk1vVLFCZiy1vzQnFh5n/F/QTR1Gh8D+0g?=
 =?us-ascii?Q?ukN4JRu/QCpOfZ3UGOKSQRRIuIT2htkkixMY5I1aHhOVywgCKmhNXy00Bd+I?=
 =?us-ascii?Q?1qA7r8uM5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6768b5be-e8aa-4060-e54f-08da140e14cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 18:33:13.5788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mHQ5KaG7DT8WU2wXejoNQSFGArZ9DtBoQnr2ZWjO599ZReWVSIrv/PDdatAd8OIgkavzsckgpfxb2aMUMJaI1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Declare this function static since it is only used inside the ufshcd.c so=
urce file.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
