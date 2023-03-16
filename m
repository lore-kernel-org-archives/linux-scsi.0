Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EECFC6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 06:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCPGPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 02:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCPGPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 02:15:03 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE65914995
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 23:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678947301; x=1710483301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fYFMyghPIXbqhTVMg2VRiA8J10dspPafqF9S24zgQlU=;
  b=CTurkbkbY4bk7d6zdoN84l2wdPRRnzY9iG11MTfxpUG6b5qZp0JOiXqe
   H9+YE/rdO2ID7K3GcZh4tEA8jpEx0QFzAMpkfT82bvvwqUGotkdDmmnu7
   RopwV9Ttuu4yWyREyJXkntlN0M71iDbJihn2JHOSklptqnv0SfzPx5hjC
   0NIquvlaZE1lAV56s8XbODkGrEwvmGLDyB3/R83G9gcXpifqnyS0ldILY
   QttXia16AosLCGipBtFkvUGqARDLhRzXxldnytt3HU2bu69kWVA2f9/1f
   eiJQlAaBkj34MmflHvCTvuGrptFegayUG+gq/LBIvdZWIZ6UcgBzHBPHG
   A==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673884800"; 
   d="scan'208";a="224037174"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2023 14:14:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdPL4GH/mnLPAmfg+AKUKwKbrVEJLKzuUQA+x1dZJSRq5lmw0aPdr3RUCkhevoDQ9k+cfdW/DIpPssY/Ql4B2J7oHsEMG84M4IXTqfJYipbmx3jCYjRoBuhtBZPAOBvwZkPLZSQK3h4iAMyOEMRQ9oCeyh4X6nvjKiXm7Kyp88PzCzExqLIPiHpoB4/NdOytLcxXn/Nfh1Y01GoBXjQL/n0mlzM1LAkFMcMtLfkjV0s2dJ80Lj3AfsAmlg1FvtZyjfU8BusLhoNJBNp+tvpvGEFfVL/RSJ8hYFCN5U28B/8Ck6sE+dEe8kzZfVGwPlyKnVkzdOGWWoE6b9dyUTA6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYFMyghPIXbqhTVMg2VRiA8J10dspPafqF9S24zgQlU=;
 b=Y+d7wWflMIfSma+OsVFYOvZR4hfiJ8w6eCnK/OVd/UsT64iaZPcnUQMdejySclQyRaArLCRUTlVomufJn/iw183Vk1X9QG0sDcqoh+HFQH+bfCjkY8nFkrkStKlZ0nPhrzyN4ac68Ct0P1SbpVkbr7dB6z6IexbxnZ/zTHlN2JiNPjpsXt7e/VCCICQaXTHYUjEAdWrsLK28ZTYk0JS42QVndksL2z5M+1lIbEh4Hl08ES5MkPLFkMd3sdKBUAzMSra44QK5dWReqFW/OqQyTU5rT30VV/O8QKZA8Wc5UNptlGxTYSabMVDjpk5lLnth6JYa+swUpZ5TDCfyHBD4oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYFMyghPIXbqhTVMg2VRiA8J10dspPafqF9S24zgQlU=;
 b=pzgfkj+c2P95WmpZKtXqdHTLeKkx6ZJuvufsB4nIZXLpVMPqrPE4CLKoG7GKPkt6LpbxgBa6tv3xg72IDD+jpa5PjpKU2Msd/ER8SgCzFXZbZ402tCNopVUBhvJOLeSsXyG4kG5ig+YLVnkLQ1hCyk3O7wckbAHMF9AB/uPAbNA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5944.namprd04.prod.outlook.com (2603:10b6:a03:104::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 06:14:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 06:14:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Index: AQHZVrfDqXFgb4oCmUShIwppDXdKFa772ngQgAAku4CAAGjwcIAAH3uAgABoGUA=
Date:   Thu, 16 Mar 2023 06:14:57 +0000
Message-ID: <DM6PR04MB65751656D963D86AEDD4FCE5FCBC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
 <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <09ed808a-b697-37fc-8bec-c4da6be1382c@acm.org>
 <DM6PR04MB6575D6BA280BA7B4396D39F7FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <993866eb-fead-5c97-1194-0b29ba43c597@acm.org>
In-Reply-To: <993866eb-fead-5c97-1194-0b29ba43c597@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BYAPR04MB5944:EE_
x-ms-office365-filtering-correlation-id: 2ac9fb8d-4655-4630-a53d-08db25e5c427
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJa++n4ScH9gbJobrUGUMdtOchfo2DnLm41hcPWOjWVv8lj0IL2Ki6YJtUW9Zs5vftpe/RIeNBXpDtPlXPZaZC8c8LE5twxD+4gsN/SBLdmLpqFcMhhiSrbEMtC/ddEiQbqLeYQsQWXtSI1UJXhRX9ZiCnl5Sm3RJ6Uqjhnl43pFzAZqLi9dWL/ddYMbYsjLrBqNxLTZ11I9WpLyvb5ABqV9oT6iMPVVt3B8HhAVPmSN4QjhZ6fqQEAPSPLLOkgK007i5RdB5HHfpdl3aWS9fkG+RzwQqZd8fzNpZsESKaQvHwfEfpK1qAI+anVorVxu1cOaNi+xKXPG0DwITJe/UAcjLp9wkU+pCQ+K4uKXwr1wSILeirKSqAOCFPqpxLgVyWA7pFj31zkoDEHTUAJpQW+xrGb0OqKl80xpV+oNsunMKpaRNZ8fwkCrvidiyiRafuVODl9Y1l58AAG6H8XP/MNuryfLPWJTV/2XEZwzr9YoaLaCCFHj+A20jb+BxmBi5h6wnYb0Xe5jKyaV5ouUbrlvSHj+6O+AfpccO/iM5mwzXjbZiTNWyAHQaIkTn6hEggI6xBBj8NE6cPMJqaC3HwSNDL9PR34mLvHOR+MlOYSclqRlsqOsVMsBarhpYo4XETSoacXQc3CYwX/29ht3/TvkSJ/MjwVl4XgfX4nLulYpsALxtwqPUN7Y5Lbpm4s4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199018)(41300700001)(38100700002)(8676002)(4326008)(66946007)(64756008)(76116006)(66476007)(66556008)(66446008)(4744005)(2906002)(82960400001)(8936002)(52536014)(122000001)(5660300002)(316002)(9686003)(33656002)(53546011)(86362001)(6506007)(26005)(186003)(110136005)(54906003)(55016003)(38070700005)(7696005)(83380400001)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uzk0Z2hFY2x0eEVDSUJGQnh4R3VwRXdvNHpZelhhM1loWjZIb2FlWUJ2ZHho?=
 =?utf-8?B?aFdYZElrQ2VNSGFCWHNuM3N0a1VoUE1hUng2Q2M4Q3BoaUFCOVVPdzl0UjZQ?=
 =?utf-8?B?a2NNSURjMmYxSzlVYU9oejRMQTBETnhtL3BjVDhSaCtBTVpmQ0dZMGJ5UmM0?=
 =?utf-8?B?RDNjYVJTY3JwNTYzZzZZSVQyUVkyRjNlcVQ3MGVHaVY4MElQd3d4KyszSjhF?=
 =?utf-8?B?RkpUQXAxTWM5UHZOWC9OV0NVMEtVZ1U5VVdUZUJvbUtYVTEyYnNsV256eS9N?=
 =?utf-8?B?UmlNLzRXSnc1d3BhUkpaU2NrdDVsWng2QUtKSktMMGVZdjdCTlovK28zVHFV?=
 =?utf-8?B?TW42eHJRMEtWdWVYbk1uQTdxY1gwZVRCZDhuYlJzZEpLb09OTUoyd1N3Q0RH?=
 =?utf-8?B?eHBKZ1FLTHE3dmlLZlNPMktGbFRVL3d4U0xVTDFyLzVhSlJRK0puem9ERmVq?=
 =?utf-8?B?TUgwR1FXTStheVRiMEpuVFF5cDRyZ2NFVXdpdzM3OUgvSFlJMnp4ejhjczBp?=
 =?utf-8?B?aUxnZ0JYTE1VUkNlRjMwQmRDSE9TTS9TcU9rNmtPZnpEZTlYaDZ0L0ZHQVRL?=
 =?utf-8?B?Q0trRm5qZHR0ZFhyT25jdUFOa2kzVytHRSsvU3N4Tlk1b0ZjUlBCWDJBQWFy?=
 =?utf-8?B?bDNJdVJXOE1scjY0bWJ6cTBqNERWVkhMQko0ZjUvVzVFOWxINy8xdnFueUpw?=
 =?utf-8?B?STFqZzI3YUh1UURiNStvblY1d09sbUdxcDFYTzlkRTBuZmw0RXpINWIxUGo4?=
 =?utf-8?B?Z1hPM3NYejNJZXpBNzQ5V29leWtGRFRQU0dJNXN0ZlBvNkZaNU5URnQrT2dB?=
 =?utf-8?B?enNQdTdMV3F0WU9DWHRxc2lWUDVEc2YrSnhXb2JWWEs1WGdGTHpjVGVYcGJL?=
 =?utf-8?B?SURpdDk0azBKNFRnWXU2cWRFOHU3VDkycUhRSzY1cDVLSWU1Um9MZmF1d2ZJ?=
 =?utf-8?B?S1ZyU2M5M3VKMi9pdGxrT3o5U25GVmZwa1dtbnZJajFXN2JpTGZRWjV2Y1da?=
 =?utf-8?B?MXR1UUtWRWg3YUxSTFZiblFKd2xpV0tEbGNNMmZvaTQra3FjbEM3V3h5RFU0?=
 =?utf-8?B?QU5RQ2RkcERqekxFOUdsTmp5T1VlYlU3UTI2ZTk1eFlFZjU0WkJLa0hRaVI1?=
 =?utf-8?B?QVdsOXQ3Um1BamlKL3dPU0labGU1Zm12UGcyOWlURnFiZEozamNTL0YrM0Fw?=
 =?utf-8?B?Q2ZqNlR5eTFyUkx6dEFLRTA5U0lwdEJka1BBY2NRVGQzUk5DV2xFU3I0WDRq?=
 =?utf-8?B?cUJPZWNlY3ZheTFLUWMyYVlwMEJHZXE5TXNiUFZma2kxNHZkTHdMWnd3Lys5?=
 =?utf-8?B?aWhLVEhaZml1TnpyTVVoc2FwenE0OEF3VzM4Z09iQnMrVlhTRjR6N2JEeCt0?=
 =?utf-8?B?M2VBa1gxcVYzRTNhcy9HYzhxaHBRU0N4V1MwSll2TkJwSXVEODBvQzk5L2dt?=
 =?utf-8?B?MlhsT0diRUQzNFRBRnFwOXhGc1FJOTBUQ2FDN2lrdWNEalNqVWlLaGh5MFZ5?=
 =?utf-8?B?ZXJSVHU2VkhLbU0yck5jTmpyYlloVXpFa0NvbWRGUWdMRnk1NjE3ZjVKYjFL?=
 =?utf-8?B?cVV5OEozeTNpT1ZiU0VlaXNaN1pzY0M2SDJWaTVPYjh4MXM2NmxhZXFkSjZk?=
 =?utf-8?B?YU9WL1l1Uzg2L2ljRldoMEZLemF1TmdaZy81UThBU091V2NXM0NWRjlZcitK?=
 =?utf-8?B?dHZNaHBXRng0OUxrZTZLQWpYZGhDSkxscWdCemNkVnhkR3NIbVlkbEZyTHRz?=
 =?utf-8?B?bVZtbDl6VFAwWjRweTZoNVByODNya3NqeW9EbHMzc2NUZVVUZVVIdGFLR0cw?=
 =?utf-8?B?bFIwcjY3c0FQazVqcWFFRFVtM1luWk5ScGhFYmtIMERkK2lSbEQxU2dMaTFD?=
 =?utf-8?B?MjhnR2NZWWhhOGJ5dDI1aWQ1bkdyMVhFdWxXTGtvNXB2NFJnYzhlYkk2SjI4?=
 =?utf-8?B?cFV2SGVUSlJ5QUlVNTM5ZFhUNkpTUzJUSWVycnU5NUNWM2ZvbXBtTVZjbGxX?=
 =?utf-8?B?Y2JNOEZ1Y1NGRERSeG1YQWZEQlJmd1pTNEljU0N0K2VvOFpyb3pHbXYvbml5?=
 =?utf-8?B?OUx6MFQ0dTZOK1ZhVGRKbEhxZEMyWUgyc3hVYVhqRWtueDErWmd3ZkNjQ0ZF?=
 =?utf-8?Q?alMYLSm0f8nPUJpxkt4E4117B?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cXZYd1dmV0QydW9NUVlFMzJ6aGEyZXVCOEZ5WWU4bmVuVWJIMXlaYU1QeUtv?=
 =?utf-8?B?empzQjMraWpJb2c3RElBRUdUZzRkRnhNU29YUFIxSnRaRjdMTVdMM0Rrc2pj?=
 =?utf-8?B?MExrY2xKcEUrOGlOemEyNWFTcVVTUEZCZlJvbFV5TUdnSGttMnhqVkphNW40?=
 =?utf-8?B?RmZMRi9GREhYZjBTV3pqWmZRUlVySTZQc1NiT1FHRm1iVkxteG83dTY4UFJN?=
 =?utf-8?B?QXVGd1FwMFpqTEJiUklxL3VxdWZ4QTNnT25tbnFLYkdTVzI2Y1ZsVXgzZDVO?=
 =?utf-8?B?aUxuY2VTQllVeUlPNGxab01xekhFSmZyVzNHaXl6d1VMMSs1ampFMFROMGM0?=
 =?utf-8?B?WkhKQWxWL3Z1OTBTcXNOdnpZVEVVdGhJQzFMMFBnaWxhV1FyZFdsOEh4UnRG?=
 =?utf-8?B?c0tvRyt1Tkd5emJ4OFBDcmFSaHNzUDZLdDZQMVA2WkZ5QUdLK3N0eVgrdFJ3?=
 =?utf-8?B?bXliTXplUitWbFlJamVrVjNsV1pmRVI4dTlqQkFwYk5DYkdqRjdHREdwMS9I?=
 =?utf-8?B?MnJHREgyTEh2NnVGSEJiYjRJZXdxSS9oMHJyVm1HcjV3OWExL3ZzVzlTQnZl?=
 =?utf-8?B?MXlpSnFpUEk3VU5KTU1nQTY4ZTV3eUxvZEpkVm9HdTcwYXBuQTZDYWx3SXpF?=
 =?utf-8?B?bHRrNHJJT0M3cy9nQ3RhcjF3enRUYi9hakRuMWZqSlhrRjNSZ3BHNkwyWDIr?=
 =?utf-8?B?WTgyc1p2YWtnUWFVeWFuQlJmT1Y3eFJnclEyWWpoZUZlNFJUV3dhQ3hzQldk?=
 =?utf-8?B?WGkxOFBwaTRkakhjeER0VEtYYmNiVS9PY2xYNlcvRG5UaFM2cVBCcE95cWla?=
 =?utf-8?B?L01qRXhBUmJHV0FBbE5qRW9NVStINVlpQXV0cWduTHJoTlBReExLSmJRUXVi?=
 =?utf-8?B?WFE1Y1Z5MGp1cDBzSEwrNzlEZXRtVXhuR0VlZFZ6a0JYVnhzUkJLWEJEVTcy?=
 =?utf-8?B?SmtxU0JlSnduVTVNSkhzV0UxOHFXUVdSbWVUYmgyNDg5V2ZHK0NVcE9YZHdU?=
 =?utf-8?B?WEs2VmRBcUVDaFBDbmd2K1N3N0R5WVZMTWsvVVQveVlSWkFwaWdId2dkREJ2?=
 =?utf-8?B?UEUxak9oVHRBelZydURYdE50bDRvemt0Rm5wQkU4REcrVTU2YXhINkhURkVO?=
 =?utf-8?B?R0JLQ0lqSVdBZit1NWI1SzE1NWwwd0hHMS9zaitzRkRySTVuK2YyLzVyN2FW?=
 =?utf-8?B?aEJqM2ZvK3I2STljTnhxRHRaY2U1bmp1YjhISGV0YnoyanRMSnRiMnd6N0Ry?=
 =?utf-8?B?TzZ5dDlzVWJoYzZ3SnpLS2cwV2NuQkE5b1g3c3ZiSEswSmEyaWR5Mm13RGkx?=
 =?utf-8?B?S083ZFF2SFA3Yi9XUjlSd1hmNXdNT2dCYzZyZlhvalV0Z2Z5N2NTaXlSU0l5?=
 =?utf-8?B?dm5Td05ZT25IOGc9PQ==?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac9fb8d-4655-4630-a53d-08db25e5c427
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 06:14:57.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7WCqPK+fr/I+kZUV0xf3YTtWZ7sKEtlpM6iCDLUESsAWSRXMqlDk3ZEm+1Z9XyRKi/Ir1ITUFU4Q5SSJhLD4Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5944
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAzLzE1LzIzIDE1OjEzLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBCdXQgYXJlbuKAmXQg
d2UgY2FsbGluZyBub3cgc2NzaV9yZXBvcnRfYnVzX3Jlc2V0IHRvbyBzb29uPw0KPiANCj4gSGkg
QXZyaSwNCj4gDQo+IEkgdGhpbmsgdGhhdCBjYWxsaW5nIHNjc2lfcmVwb3J0X2J1c19yZXNldCgp
IGltbWVkaWF0ZWx5IGFmdGVyIGEgaG9zdCByZXNldCBoYXMNCj4gZmluaXNoZWQgaXMgZmluZS4g
TXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBwdXJwb3NlIG9mIHRoZSByZXNldCBzZXR0bGUg
ZGVsYXkNCj4gaXMgdG8gcHJldmVudCB0aGF0IGNvbW1hbmRzIGdldCBzdWJtaXR0ZWQgdG8gYSBT
Q1NJIGRldmljZSB3aGlsZSBpdCBpcyBub3QNCj4gcmVzcG9uc2l2ZS4gSSdtIG5vdCBhd2FyZSBv
ZiBhIG5lZWQgdG8gd2FpdCBhZnRlciBhIGhvc3QgcmVzZXQgaGFzIGJlZW4NCj4gc3VibWl0dGVk
IHRvIGEgVUZTIGRldmljZT8NCk9LLiBUaGFua3MuDQoNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0K
PiANCj4gQmFydC4NCg0K
