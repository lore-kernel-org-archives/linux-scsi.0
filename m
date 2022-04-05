Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806C0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiDEGlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiDEGlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:41:17 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B9935AA7
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649140759; x=1680676759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+oWiPEhakX+SJ923rPHMmvQtSNrV/lhljXEODOv3Gc=;
  b=Coacvy1NnCf0GoXVyJ93mMU/ybOEx7IoftrhwozQeLMJeaXTysnIILg6
   +muBjzh82W2MYkl1SEOT3QzHrLcupqJ29OzpDwJ3tttWIq5+hL90+fpCU
   RlI7gUfuRb8SQuy90WNn8ruKob8xI1Zhp6agQ4slytVsxCwwZC//yq8cI
   28v0L8igX/Tezc1QadKyVQP7z7JRdEd1TSG92ta6JwDgXm9X9q+oy5Sll
   /S+uhfVNi3SDhMlxdqR+iWTtQd3LNkLu5bO1G5dGPT9QeTKh+3WmU20XC
   WtD6LBTh9Iujtki1RFpKMD+4LUlXyoSxvWx0m6rMCMY0SGUgKhBPfBZT1
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643644800"; 
   d="scan'208";a="195982894"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:39:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OECHGaP5JiWXhOa6cOS9boXl1BVVmpkkthYOcKuXKTqph7qUcXfqoKxlRVCRHgAFTPXO5iZM8oWGYtwXx2ANCDK0TMvJnwNhdsjSCSGN44Usxm+lzLHxZVFRh8fa1kDX+IFt0QzaTxbGuKfVzZdl2N2b6kwYCK1tasKcQJlHeAinoUFAxFiBqFODgtWCTkGYm/mjmY7wQLYHQiSod/RD1iDynipcVTjuWY9VF6chCwvukcT+CGExjLTrJCwo8Ki0kjZgnzZqBSn//d9rgWtFJgR8+4xnY5MZuBKNRid3vUwUGl09dz8n7nrKGqDJZRaiSQAMCLtiICYYDVupLRGEdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+oWiPEhakX+SJ923rPHMmvQtSNrV/lhljXEODOv3Gc=;
 b=eV9m0BnxZHGBUzlCqCVQN+zfnIKrtBAVtXhAbFLWfF0ZPQevb4AbXYEKkPdZRM8GM5DgPDz6ANKadAjx4z8/5OKVyVp75jJ+AbyHTM2caYIzBGi4oso579/+w37ykh8kAaRA1O+WmCOGCw5sIIlN5WdWalhm73Cp/OBEdTGfrnpqkV5kLQdQdasNPF7uKwkqFkTDs8RHn9tHAswXI9rmHa/0FGlKghx2JaDmJzTEqw3UdBRfHLRcp8+GkmTnIgTRsztED5qANLOPIdE8T4mduzBjMLhuP+Fx5OHz1ftymCjaWfDsDCRLe5kDKH8n3GQNtQ5Kc9AkvSsaDTrnZB/KVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+oWiPEhakX+SJ923rPHMmvQtSNrV/lhljXEODOv3Gc=;
 b=O7Bs4i66a7Wy2KhjBBQ1ZQtT4tPpaP85HRhIS0yEauPikloh8E9par76FzlN93AxobfnNlj+USizCS8JT02PyQncpaZLq5ZCrBfRcmNoRypRLSc9lhvJ1cVAgfMWAjFQApo0pUWF6gqFf7mFcAr9rDf30n3hwJiBQv5DoEX0fX4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN6PR04MB4989.namprd04.prod.outlook.com (2603:10b6:805:93::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:39:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:39:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Thread-Topic: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Thread-Index: AQHYRVBHlWJd+EDs6EKRm91tnhEtPazg5EdA
Date:   Tue, 5 Apr 2022 06:39:15 +0000
Message-ID: <DM6PR04MB6575D4708E72D3E1BA4FDA1AFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-27-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-27-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 070a2e23-866d-44b1-ec58-08da16cf00d6
x-ms-traffictypediagnostic: SN6PR04MB4989:EE_
x-microsoft-antispam-prvs: <SN6PR04MB498910F9A4807B94B0033541FCE49@SN6PR04MB4989.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wI9yiRMvb3g/aM+r9V13DtX/snNc+sybIr0yMKrUwgyey6EYuSdj31vooJeOHC3drxsod6LcIgXIZw8th9/ygcAhcJxVeY3WpHOjAL4OMmZldWG/NPaxBng3CnSuNOkSbCnli04WQhJJiR6rUn0cXmQvJlSzQfsrQGPkF5+1I4OWY+HHEH2UZGFWOV256QsoqqJ6oltK9ACwoVPITProa/HSM4vzWiAdj0S5MnZeAnFKicBopTBD8gLNfVtqrrBTJokCcl6LtCd0Q7fOBSzlNB/+m4sHsK5w+8bvmC83vD/vzB7THf6KTqBpU7SqBq42lbn1iTutNJW23CuSZEQWJTehi3o3iDa9GidH3gZHYeT+wcYQLOkDFdxKNUeSG8hB+Dpdlc9Cjm+WlJQTjqCP9Ml/IHIwvImG/qdP2Byb5i3TJWVB++7Dn9YYDG7PPbQ9zAYZFnjxF1FakaeXMqtjleFkH8HiPPUs948Doai5OvVis21yPqQhBZbmPiqH1pWCol+S2R5qV+yJMUKqNC4R+sqy2fobd9UpXXaLSaAGTh6gHbfO0a6jyvgwB0wZSEzWw65jdHaIwP7OeKnwDm4PCUKo2FubKPBtEEjBQYWp8cJJwPVQFxKuhlUlzYfIu6Q1FzKEHH9luEfSj4m7QHDm3sjxJZo5ZKXyAqNkDHdjn2mMwYTZ+ycyOlx7zmXftkJNFlRBLJBuc/P2x6BxS0ALzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(86362001)(2906002)(110136005)(52536014)(6506007)(66556008)(316002)(186003)(66476007)(66446008)(66946007)(5660300002)(64756008)(7696005)(8676002)(82960400001)(508600001)(4326008)(9686003)(76116006)(54906003)(7416002)(38100700002)(8936002)(33656002)(38070700005)(71200400001)(55016003)(558084003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ezK4mrzVzl/GdOcSHmgnlhPkGxOGfJJ9sLRSU47Wly148qdCUNq6SHJZN4K1?=
 =?us-ascii?Q?9ENNhJ+zFx+GGPAAe2j449okG/HNI7wiPP8JT6egTyGj9N6dBZsCWoFGsuFx?=
 =?us-ascii?Q?Fo05QmBSPgG6KBSLx/UNs9Dzc7Cr/tSkQmSXwUw3Bec4XyOjoySPyQTQryqe?=
 =?us-ascii?Q?3CKgJq1mNDaL5VDv0f0FZq2/B4/T3wPRFFRzUM7pVEi/hVNKlBKWpMd01rqb?=
 =?us-ascii?Q?J11pm9/BXSome1bGh0n7PDOWayrB5zzmoyfMS5ZJ/kCPeycUODnBeNADTmzi?=
 =?us-ascii?Q?yyXdCxpVq+Trd/AsV+UahT0U6iSrsxrtprUwipkLc2Elt80Vd0s4Tl/DC50/?=
 =?us-ascii?Q?yqNZfUy28tXZEtgkA/17ajBxsRitPOqaMpuU+fkmEQmYkTV9piT3CzoZbGqF?=
 =?us-ascii?Q?m9ZH3VUptJTWtdBB4aScL21njmDbS0hMBczTOmyuATien6lNfd6usWYlFVZw?=
 =?us-ascii?Q?lfpIJaEzyqtNOqWrvOiD9Q9tgYhNum0pHH0x9/hC+HtgrVgl+g1Bd5mulpkg?=
 =?us-ascii?Q?sY9ZbJ37cCNxwJn4GTJA+IVM47VrF6jFpjhsPQMmGbPWhnxMvOjy/Ihn3hvz?=
 =?us-ascii?Q?SJlAMAJf3TzZWm9dTGhw4+vR5kZ6y0VZH/Hn5ag1U+nZQCoDImND4Rj2e+hz?=
 =?us-ascii?Q?dyBbOKY6IlvSHEDt5DfRfAnBTk5K0zfs8NUO/T+Rjrs6re76wCv6LeG+8dfw?=
 =?us-ascii?Q?o4xPpPlaIOTvd4V0GM+tKLu2zIF3dZnp+0yGLDMA0u2lmu/5VXzZvkJ0V0P7?=
 =?us-ascii?Q?s7hubE4R4U5oFrCIa9EG8FdcRAtOPULrXf03XJhumRiJhqgmQ9jiIp3rVfRe?=
 =?us-ascii?Q?NQAEUeBYUramdATY98a9M4CL3FflMHzMC2u1WYpde8zrETPD58yEqRgDPhe3?=
 =?us-ascii?Q?JLScvy3a2gp9hwULrprXsVnarQRHHYrxuNvJIee2wpWae+/G5WIqVNQ4IEuq?=
 =?us-ascii?Q?rN4LID16NocUO+KudV4hBrYvj0J1hqAPE7pynVCdzfW/sMPAytLY8MoEhgVW?=
 =?us-ascii?Q?c6Ry+KcMT01opYBDwPaCPRLaXoDNCfTvtGcRHZHeLI+ePMyxgMdvZ70vIYKs?=
 =?us-ascii?Q?c/PStYqOO6PSFPqJWEXpp7afL3ZdUSbGomVzQBDXUkAg2o9scpj8mdSy0hQ5?=
 =?us-ascii?Q?F6QbO+Dm7pWP306/hEaFtB6cDBpFKB/XTNgOIC76nw9HsU5ppQr8M5jhQ54F?=
 =?us-ascii?Q?SZNQ52AdJutgcUf6r1dXrmW2k0U/Ii9HmgOwXS5+L/TUsCaQHlEQ1etm2TWc?=
 =?us-ascii?Q?JcGW3qCqosNezFntCD9thiORKeJrQ2+/1Z2NcsEjc6YLPj19lFU4Gbwd3Thc?=
 =?us-ascii?Q?a/F6NjEOf8GwcYiEoexEZmiz1L1PHGvzUj+gCLX9jgjZq6mr3WHpRYrzSCdc?=
 =?us-ascii?Q?UpReUVOzAgsLS/ok9vDrUDyeuAumWMgXwRrY48iJeUR/sz2C/N3AxFnuPcqK?=
 =?us-ascii?Q?ItcPpRHNePUAmp0BkDkTx2Vqu+KF8JWAZ4Hqw4NCxnmB1RsOjf1ax0if9TVB?=
 =?us-ascii?Q?QWugCZNtkrgfVZ0W7mnlJpvbpD1Udg05LDU7jEnY6QQZ2dq7B7YUfefX0xQy?=
 =?us-ascii?Q?dr1lNlC7HLB0a+e+Y0vxQjT4LfiR+0O339VW2pdoC9XQelwtKHYGwyTsqYLQ?=
 =?us-ascii?Q?FcmkECVPdtafaTWMkO9UO2To1+OXk5N2R1R/IdT//qcu4fgtiDpw4GvkPstb?=
 =?us-ascii?Q?XGe2IV7X+v3v4m+kbhS5q03KaIRyD2YYyzEyHDDThI+xRPPElnl12WEVZ21z?=
 =?us-ascii?Q?KZh6c1aeaA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070a2e23-866d-44b1-ec58-08da16cf00d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:39:15.3691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xP3s3UsvS9dtrBpctbZXYUwy96EIIlFBmCkv+LP3pElwxPjXqnTsmgS60a1b99FvYdW3hLnI1UxBKYiQ0HyiXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4989
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-pri=
v.h
> new file mode 100644 index 000000000000..4ceb0c63aa15
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshcd-priv.h
> @@ -0,0 +1,277 @@
License identifier & copyright?

