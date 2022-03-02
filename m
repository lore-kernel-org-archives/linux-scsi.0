Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D546BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 14:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242872AbiCBO2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbiCBO2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 09:28:15 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A241935DFE
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 06:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646231250; x=1677767250;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=L28ZkGmApcp9i7ImLXvyO5H3iqmWQ0LpUAvBqrEUMo99LTk70KcLoSH5
   GcSW06iQ+sabLelZ17kLbp8c+MRH8vNc/HQ3+h6PugU+yvbEiPJa//HWn
   PwRch8P8a+FoFfgO09aig/4X/g93VbeEnKTccPdShf2I/zkIK3TNRODoW
   mvGiEsKv4RNvuThGVICRZa0E7UilGza8c0HxzbeomP4ObWwye2OlMeJ7/
   KVswW4C9HsqoH8+obK5fqJ0l598AixkyfIEOZoqSSuAW39zkhtG06DULn
   eyZEcp0NDtT0sIiFuTAz/MlY/O+2m5tRUjOa3ZSzpT8OpEVxyCZkqh3P3
   g==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643644800"; 
   d="scan'208";a="199135514"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 22:27:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hscYhAWA00YGwWEHbHWyFY2bjpxbvyUgo4h91cLy6yeSD1BXdoaxpOOnkAdui4BYTPIb6Zbw+8DL63/+T4aTryJrZVUvOo/UBDtTFz3LeWcPcE2niu7j409XMNJZ4C5jwNVYRAj4yr0yKkuGdhWIKKvVFx3CawLXziTkNXfRxSb5Sejq+vaj3rnYfBvEczIRc5uQFxByu7YO9wQMCpNdGfKjnaJJz+U12ehAHtIKYbOdTufP3jTOm51qXrs5DsRWqeEs0r/LginJAbOhVMUtwAOuAzurphX92GlkcTHU6m8vjKcA/jqWEnuXc/KtTB0vwHNqGFS8oCLMOu9oKAfIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ho5OAjkW7+U7QAl+26nefX15OpIipPQsmWrNTDnJlCDdqi9VVWXGSbUD/y6zfqP5bs60zhM834svYICqlGS6TLbeQ7bjPvyUgD14YnrZ/oD4W/i96giyOOKTh95eYL6jdhVombOnNpnAjuJVq/WUqp9nkP5NEnutlFjydIoOlZiAEWUBS8Oi/iztOrzYOXlE2I3HgToGiShcUhULNnpXioZQOu+awy4tJkF/bSs4ZRDO41itSldnOIUYPs25ebvPXBWMSomVfuB+9PnfCdKecnl0RKzj0Pek8wwgixHlaUuS3qQ60IudhcSDTEe1jV3n6tihzSYJDscMD9hMl/9b0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=u7+HVVaLROafgb/vhRfweWJT/OV4koFs0YAXzb700Qyj29nmqyBQ3jF+RgWEH138KBdzSFzVg2toMkS13itzWtcet92kpXg7ramzCHyr0FC/fwX7N5CAUqiXJKAu3mGwMbsZTy7CTTL7KSaYGWgn6hlk9+IYYH5emulHV3CM2Bo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5653.namprd04.prod.outlook.com (2603:10b6:a03:10e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 14:27:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 14:27:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on modern
 devices
Thread-Topic: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on modern
 devices
Thread-Index: AQHYLfd+orcKsZImG0+ivikqdvkduA==
Date:   Wed, 2 Mar 2022 14:27:29 +0000
Message-ID: <PH0PR04MB74168AEF61259C0D1EAD533B9B039@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-4-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61289eac-a8c6-47bb-a600-08d9fc58c80c
x-ms-traffictypediagnostic: BYAPR04MB5653:EE_
x-microsoft-antispam-prvs: <BYAPR04MB56539866F11613F8EB0238C49B039@BYAPR04MB5653.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EsSWZDj8I6V5/a6nP7Z/C3eFeZonxeL8JxpBXAVZCFJhcDsQM/sEyYYVw9Mm+bLKRQAK7o3e21SqjtB7vLOcdGXOAlWj9UaKXHTgOU4ttbCFg918Peam2Lazg2BLqf1gzlfAGP4toaGKgv3xMmMOYPwtC3vq1Gk/WtvOMjrlRApVicMF5yzAXY8fecbnpmxC0gxKssFsWmDXYa5yGcxTHa42IPQfLJ96SHtQfjLMfTUetwk4k16vK4XIERTxLdGbFSiEjC1cOF2S083izjhD/MGP8I7iLIg+nS0iYwiZChYLs0QTSmAL/JlthBU72uiPXamsisC7AHgwGJv16lbmKLBBChvm/9kQVIn33toiIV3I6hh8dJhdQ59/JbjfM6s9N2ZRfdFDFieErNUejxrOJihm1OkYIzg+OZdl692OsaE1zxTq4gaGgg+h8XPsCRnrw47hYVFM9zPKldazPdFOFlELVKrXQocNzzvTZJnPzgLaYk7mreNnobq2QRVog+De0dDm0pddgnAhES+QDf9hacn/J+z+EtJRbTM9n1GwSb4f6wHUyNd3mLwXi133OodcICxHn5ZtRQCqYPUB1GHqG6kERAZT8NRAHLrJQNUecjgfhne1BdhsGmtvdvG1mf2Mk3YTQ2JTTdng+VhcIEc0Uo6N80r5+nfov/KIKQGPMGoYfuzOWgLH7BlhiQAXFv5UVm9F1wdK5U1RsK8OxrRdDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(82960400001)(5660300002)(110136005)(186003)(52536014)(64756008)(66476007)(66446008)(66556008)(91956017)(76116006)(66946007)(71200400001)(33656002)(558084003)(508600001)(86362001)(6506007)(122000001)(7696005)(38100700002)(38070700005)(55016003)(316002)(8676002)(19618925003)(2906002)(4270600006)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QN+tLal/snIXJ90+UQTpppUIHFx8jGe6KK27NAfCeBzIKLa4LsGc3kqcQ7KO?=
 =?us-ascii?Q?E1hTkEUc10ULd8dfErmgILK1vDpMz2WWly3CRO/MbtgEkNsDVvEPEbAphCjt?=
 =?us-ascii?Q?QW1bs6xKYXiGyLDcqFwPxRdh4gqu/XnjUqja2NtToHdY4CmTGjFv6XK+TMLW?=
 =?us-ascii?Q?iJgdLYEShKffwcFXYOJW37dDEs4tAVlEqdMSiDV8t1zl/Dps7iA2ciqSLZmq?=
 =?us-ascii?Q?lSzXmod6Qnrax1nzfVkNcwNJEjQfheBDtpYWdSaz1lwkSqWFrpDRQ+dEBIdb?=
 =?us-ascii?Q?7IqxDs5IPu5ptURJ1ZEOVVa85+ftTw8SqVAD3otwhkqVNQ9tlcxOyjCwC9iC?=
 =?us-ascii?Q?Td4kszAc83D4PhauYW0qK7b+6S3zQACOp3A0+CGB8a+FLzu3OYz5YMDhv++X?=
 =?us-ascii?Q?CKMQKFivTa5ET09Bdn/GPa/Wd0sk24ed14aokvu4yRMC2lkdRtu7buv0uC2w?=
 =?us-ascii?Q?BoOls4jaU3oNEHtN/8iC3ift22Z88FhLYyWXFc5nY9QZt/4uqOMcmX7t9cV+?=
 =?us-ascii?Q?C819tfl6EHRIdg/KmSMZSFNeldMyjmJO9zxDEwzEoYZPQyVIlhmmi4j43v2m?=
 =?us-ascii?Q?xP8/dXxC/OIxECAHomwdMcb78XexmGoFw1xjn98mLT9+JdOsFBWfAkeBZa3z?=
 =?us-ascii?Q?IRzoTD5IC6UDWuW7QW60UfRku/dZpQrFR9obuq1xbtPYONrSMotxWmD02T5k?=
 =?us-ascii?Q?TdpkBWh+CxNWPL56iTltom/GzDvY8/TiIBrurZtWi99GLXGX8EdxIbaOY7F8?=
 =?us-ascii?Q?WggoeoyMPGkmUnRS6uX5CRR6+HoexAcQjg1tUPKJ5C39itCS1R6Uo66N9ek6?=
 =?us-ascii?Q?8+2Y8bKMtAAauNni9Vd/iq3wWI1KBtb0g/CDwpbE95Bl/HJ66MxdGTmSYM0h?=
 =?us-ascii?Q?llA8L+kPwT27i1q2qg5KHwMdWaIHaxELdchuZgAkotk4RZbTwea6HzdV2DIv?=
 =?us-ascii?Q?k3plT+9QKzw3QXYOGzSvUYkoVh9QAPSvI2Yyv9ZdLK5dmJFiBqpz6uIXHIkz?=
 =?us-ascii?Q?vl1f8ur2PZmLj60avhpPnW0K8Mn6dZfbYPNf0lKrr1ZzsHrwo/2PKgTGKTwH?=
 =?us-ascii?Q?mipH9mvfotq0OpEbN4lOBzmotpVU9ZtscLM9AB718j4HnT5rsK/SUnZPDJJE?=
 =?us-ascii?Q?DZ0uOV/hSI0canNjYc1LJ9OoLJxA1sBVMpecJWAQ+irlIHnkbn527nlA0wi6?=
 =?us-ascii?Q?ov2qhhm7CSurhaPo6hYjJgyweW8w9GTDdxm6QyPKtRLlItDQT8cauqRn8kyt?=
 =?us-ascii?Q?fNFYTCFPO3RmZyxDOnQjNv0DPLopTNpC1Ynsgs/DRWXuDJaCtUJEqcH2JWri?=
 =?us-ascii?Q?ZuZH3kQGCq6vwmN55d8RS+Vlnuk7Siql02jCv0XzZCNs6i07LqhHlT7uptpA?=
 =?us-ascii?Q?eqlc/qkyH2uJSBy7T9h/UcVIGJWObJMZqtDyqnAdMUkzKAN1Tb7JYiED4XLN?=
 =?us-ascii?Q?Dw4KMKIeIEoa4VeO+d8h0ktFxaAInEyLc+Lx85EfeFXCY/Q83KS8hXSbeYj8?=
 =?us-ascii?Q?uPHYR5BS9pph6+ZBTdkb72+SIaZYKcWGooc7SxMYVSQ7ypWHj+gf6FW5OVNN?=
 =?us-ascii?Q?xUiF23jcnQdxlgRFoAxUXusJhKAw0gfJrZSHxfcLB1E6REuilLie5Bk56ET4?=
 =?us-ascii?Q?6VRpo3+THmGl2GYwP0ubDsGm8nji7EvzfofJK20phnHEm6/O7l2Yvyndkxoe?=
 =?us-ascii?Q?zYG04Mri/7OZYQy00YxYUUldQ2hnqzcxzGkAUIiF3/oXtTZz9LnXdw2ZJyE5?=
 =?us-ascii?Q?nyaJg300q0TsLaIm2MJ33EhrXnznLS8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61289eac-a8c6-47bb-a600-08d9fc58c80c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 14:27:29.1667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSNSGUi1JvhOk/2k/0e6hEauK7Tx8e1tKi7P9+ZBewtGqq6TflfrL/kRfzpL39kRJqjom7E127C+KLN6U2akTSkT9Cr+dr7fsvBoSd4Ya08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5653
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
