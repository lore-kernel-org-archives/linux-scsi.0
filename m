Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36252C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376347AbiAaLqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:46:23 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56206 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378798AbiAaLnL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629392; x=1675165392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Ma/6VA7Gxb1h5gv45bqHLmNRDvNqQqQ75dWIJItfaZjovzSAcUcSH8uU
   n364w1f5QHHggwYZ021vdJ+fdAAMZvHfBDb+BKpjFYvhTowiiaWhrL129
   ofgnroePIzN9iEK2hQ4CFIlhfzvcm2f/EEovdNV8eiRz08ARh80EQErGl
   R/g4yJ8M1E+RwSa+mlfRmsEhnQIiu21t5sgSZk8SiwkoYfe/9cKpXsOwN
   Q/UPYy/hFr8L5wSmh0a+57UDtfHvcwWPTNb6t28mcyHZEdlQl+k1hB1ql
   pWKZwTjXTI9O8xt6+34v5q0UNlhjooqXXZAwi1LoDeJr72KNm2ve6LjHH
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192790161"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:42:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkOiXkxuf3dz464H4PelRf4QEBj1Jh59RDYpL7tE8QLBO06GsmIkqHepYjUEgpOXeYtsyGJOZ9hpTcYeCiWILpoEmiNZb3lxmAbz55IXeBPA+vIdIuEn21KspSQqHF7JWwqN8BFzlrfj/ZZmOYPZI8VZ7oObHYh6wwToETBkh6pRq4x0oxiJQNHe9GUVNecDYQuJNDwpaW0Z2U1dDz2AvCJYDaQfEgMFDjMsh/LMTJmCsYHPgPMn4MPa+wf2dTsFQaYeLICSKcL7cKLxgJ46YuRn+H1jYXk3kXNZPbZFwFetEn3VLGVcoz4xU5XQlBa01svm/+372rWVOpQxX29ycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=IuaYiPC196l7qh6sjiWkHFYDZRGMHw2T0NkQv4hzBcTbk7NtJ6TSEQHJNYzbLm0KY+n8etPhXtF66ydF+sk9fVT0EAIf24yR0bBBD5HIl06htsSAkeewcj7oXfJvSxmvA/wC2Gp1HKDNDllhvWOT42rLTl/zWCIo5UohLmGZ1sDI/QRWJVRMkIGI2Ypi0Dy6BXV93Hgm3/pkrB8R2889L+4lQjv3C622vfrHiMqtoQUQTgEVDHDgu+Or1BqjAzJx86VBh15kKTv+ed5idxlEIdbLm/MRqC0+dLFsrBmmIQoSQVLcjgk5ZdbuwqZDlBW+yjKTKnxVnpk9SXFPutD0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=VjByTfHRQx6h6rBdfSIov3z2xbTVzyMvvEpK8WlTv+WqxH+4wV/wpzFR2+nKUYhHLhXLppxZoTUBJrszioOWalZHo5CvL1YDJ5rlFb4BySSPm6adyy9lYp85FTNWVe/yfZLXfbVPgnm2hqzM9l4xkiWc5cTJyCcDT0rpupYuTdE=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN4PR0401MB3629.namprd04.prod.outlook.com (2603:10b6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:42:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:42:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH 39/44] sym53c8xx_2: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH 39/44] sym53c8xx_2: Move the SCSI pointer to private
 command data
Thread-Index: AQHYFJWDQu5BwkfHvUeeQhY9KRrKQax9BfkA
Date:   Mon, 31 Jan 2022 11:42:07 +0000
Message-ID: <2953edc39f8f23e7636b71fc43405ed09cbef8dc.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-40-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-40-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5318f94a-6d04-4a9b-cd5d-08d9e4aeb5f1
x-ms-traffictypediagnostic: SN4PR0401MB3629:EE_
x-microsoft-antispam-prvs: <SN4PR0401MB3629404703D06A05EF80F2929B259@SN4PR0401MB3629.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dx8z3WVbHOM2osnVrLA3Tob81q+y90cBN1lDfGEzuD5tw7xnxtq66sKUY+aMBblXtgCCJRxFwTdni3nVVhM1W0RZ/a3VdOHmIYIvmh+hZV75gXWEZutwJX7SoCFFBwQXpQKo+2C9mlJlXROGCpduaBE9lBTaGYKouqlD8ybfiIm1AWRjZgQj7Py3i4X3udxtDD3c7b/O7qPV1ejrdYLuZ7H0tMgCRRenKDAWI/mGk2ebafoTSfHjrUs2SfISlf239AZbQ/mS4iCs+hKEHhqRKUIf3oZdN98vllh2KxOEt+mwwO1LrGHVUIV9mwRvnY0PdzkL+1w+eVjDOH6UYSn+kU3BVGT7UlXhvxgDiyfPVFSYzZ/GaTaR2KnfbtG3EybC3BsXClva1UOEKioYMvXmc2MJwSd8LAPW73mnviL/tWY1rU7BXSHL0tz8h7zXVDgDldnPGaSTVWpXWxolzygqx6+e2jiw45igDCZjovOQJk3QcT2EjnyL6URqrDuihz+TK04/h543d3pfeW5RWPJbwHq6O6pWbCDLwRfTGubeatQ1PbFKNMgvs+nmtMOxbbCXUplN/xOHPVcC4C/hMnzAxJSxvFe4I7XSp9d1m3tTyt5j5ANPdwXzm73D7YStMAgqsZJf5WF80oa+LP5tFTCNngglWJNF7zx0B5ZffsUVM6nA6IHAD1Pl2Ythk11ELDSf3zf7IbOrdzoN26lVtmg2aA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4270600006)(6512007)(5660300002)(6506007)(2616005)(71200400001)(2906002)(26005)(186003)(19618925003)(86362001)(64756008)(66946007)(66556008)(66476007)(122000001)(66446008)(8936002)(8676002)(6486002)(4326008)(38070700005)(508600001)(54906003)(110136005)(82960400001)(316002)(38100700002)(76116006)(91956017)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVFFQ3NQbnJzMVlLd3VHUERFbXNlem9KTXgvS1hNYi9VZXg5UFVpTWFGZWMz?=
 =?utf-8?B?cFVuVHB6ODFOanByMHl6RXU1djlad2hvTHIvVGUvTkhVazlhcC9Rd2J3Um92?=
 =?utf-8?B?KytOelNjRUdyT24vSncxYnB5TDVhR1pEaU1WcE5qRWRoaU5wS2o4MGdXbWR6?=
 =?utf-8?B?L0NXU0ZLQzYySHJTVnAvUmxsOFVJMG9MTnlNZlFYZ2pzMWlPeVN6ZWZNaUVB?=
 =?utf-8?B?R1FmV1dNSW9NdGppNXVkaEkxQ1Y5Vi9jRWZmaGdoaVJqdktCNHpGTy9lOHJG?=
 =?utf-8?B?WUV3SkROQWZGWnZCaVdLQmFZdjVSUnFNVC85djQ1YWxmNFFTRjVrTmtQdkJU?=
 =?utf-8?B?UW1JT1hqdkk3V016SHJLMlNuZ0NnK1Vsdnp1QTk1Rlo2dS9DcnpVT0lWWkxr?=
 =?utf-8?B?eG91UDZlT0NRZmd2L3VGa0NYb1VWSGN0NDN6SEthdTlkOFVPcnl6d29mV0dh?=
 =?utf-8?B?ckNSS3R3dkpFSWZXelcyVEFianRkR0FxaVYveG0vZ1h5L0J0MEp5bzRucjE0?=
 =?utf-8?B?Sm5lTTMya0RuZmFqWDFKcmtiaHB0VGxzNjgvZGRaTTkzdTZibWtVa2pkSXM4?=
 =?utf-8?B?SnFXayt6WEJzV21SWlBDeU1SVXIrMk5vQ0dyZCt1RVRXZW9QWXoxVjFMYS8y?=
 =?utf-8?B?bFJrWTBNV3Qza0ZHWXJFM3Jsekw3QUFIdWQ4WnVFOEJQUGRoZmJoWTFwTlZO?=
 =?utf-8?B?cGpHOWc1bDdGTjR6Z3c0d2Fxdk9PRklySlJzTzNhdVFDMEpSUEdaTGNVcExI?=
 =?utf-8?B?SHU5MzlUNTVwamhGdUFRNU1QaVZnd0xJUnJOaG82YVArQXc2TW9PNUM4a3lp?=
 =?utf-8?B?VTdIMVhLNVEvRk9YWERlN0tMMjJRS0YxM0ZUdHN6Z2FmdDBja3hzYzU1Z1JY?=
 =?utf-8?B?QU5ZSEJURlNyMDgyZnJUd2pnZHhCamFwOTdyRTdyb3NOM01zdVg5eDJyV0FQ?=
 =?utf-8?B?ZjBQVklVeFJpLzZJMStXTnJTVzFVeXp4NWRMSm4rUHVSME1PVWY2VTIrTE5W?=
 =?utf-8?B?Y2pEZFpZTzFjaW9XRVljWXJTcVQ2ZTFOWFhVU3cyNElmaWtsVWQxRnpFYXJj?=
 =?utf-8?B?V3h1TFB0OUlpaHBQR0dVdlpnbUxIdHZLcnRKMFhFbk5VZWtNNXd4SEpsUWNi?=
 =?utf-8?B?T1dkNzVEUjZNOVBQRU5QUEZpM0EzNmNjYVQ5blh3NnFIN0xQK3Zhb2F4K2E0?=
 =?utf-8?B?bDdNSTRGa0tDWFlPekpWNEFmTXMxcXVFTHdZeUNDeXV2SzN5RFMwbW53cm92?=
 =?utf-8?B?ejRJZVdDdVRGdkFHQld0UzFjdVUwTmg3UmhPTEhQK3lhdGV2Q2w2SU5sWGlP?=
 =?utf-8?B?STRiT1dpc05RaEFFQjQxYVpGSk9HZFBlK1ZjaDBtb1d6S3M4bm9nbVBFSXdS?=
 =?utf-8?B?NFRXMnpITTBVVzBMZERRNTJYSnNHQ1ZxVVBRNGtEMk81VTQ3c3JBcWFXcFly?=
 =?utf-8?B?bWcxcmFaaXVNVithcWZKdWtkWEpXbE43Y3VSbU4zMldUNDNObjlwQnp4TkxG?=
 =?utf-8?B?NEF6dVVCNTZSOTNOUXlGRGtOK3VKMWsxcDlhNmd3NndxcU05UUxHd1l0bnpY?=
 =?utf-8?B?R25OMDcxTVBWQmxITHVWRTRoTUlMZEtNMFp0MFVIUmY0V2pGbHdtbTBHZ2ha?=
 =?utf-8?B?TklOVUZya1pYYmFWTTYvZ0EzMzNtSjRONkJhWjRQZXowZGtMU2pBTy91N1ZR?=
 =?utf-8?B?cGhML0NIb09JL1lteXFMTkpHZzE0ajZremV2cU5zdldiL0NmYVZCUi9IRjBm?=
 =?utf-8?B?aVF6VENtSXFhbFYwWGNzSnB3eGFZMXAxZFFLMDNremxqcXhXZ2hlSWc5YWNB?=
 =?utf-8?B?RUo1bmsyNnE4ZUFlOXB4QWNKeCtSLzNHMXo4Uk1nV2kyVEFyOTZuRGp1TTZw?=
 =?utf-8?B?Q2V5QW8xcFoyMTk0c1BYMGlRendmTnpqOWdtMnZ3Ty92ZERGK1Npc2RhVFVZ?=
 =?utf-8?B?Z3pKUTc3a1lnQlp1eUNlUEN3eHlaKzdNNGQ1M3ZlMnFUdTNHaU1IdWRQMUNC?=
 =?utf-8?B?TmlhS3kyVjY5b3pjcFhyc2l4STVPMy91eWJyVHVMR3dQK3grSGV2R1FLS01z?=
 =?utf-8?B?RGlpT3ViRXVhWUdTRjA5NHVUTGp4bVArM1JiMUZwNEhPVFpaQzFQOWNYQmhY?=
 =?utf-8?B?R0w4OFpaNUFyQUhFb052RVk0OTBKWVNsNFZ2clY5b3VIelo1YVZOWDZVT0Jt?=
 =?utf-8?B?SGhsdE4rM3VBTDR5YjNoZW9ISndKalUza3lpa2F0NE1Lb1BOZ3o4K2Q5QUti?=
 =?utf-8?Q?g+8g/FVBRWN9QAIjCmdMo2TJzdD5x4o98tDHLCu9OI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53828606ED29E144A21DB505AC545D91@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5318f94a-6d04-4a9b-cd5d-08d9e4aeb5f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:42:07.6195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F94In9Q7gJlJp5Bu8nZUkvybOfNErYesuhvuMCH+2S9V2n4YaYwloPZNBVV5U32bNVCTLTtALBEpQs1/OuN1vlC1+fIWVDbQQpk4cdVTIqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3629
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
