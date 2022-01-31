Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D698C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiAaKlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:41:32 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:16779 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbiAaKlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:41:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625691; x=1675161691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=gx0ILjYqH17GLKgplZXMhm0A4Un1+FPw5uhHZ5fG3Ltjv8bZtU/WZMOv
   zyEipmcmi0dVyHZf/BlpnhdvrMEqNKt1uD9RW983eZM0N9UFTrMIbysts
   r7FM+pKs+OX7/lJ6kHTOKgJ4zbfmqjn5WbSMtlrST+wufYkdORnrtSPqp
   Iubk2xzjm9F8MyWsc8r8zj4ETl7XCTl3/7EQnkwZpe5BHslEp6IYbHgcb
   CuPCFESvHyVJvjh4jEvwzNFzsQxj1acAxadKAuu/VYoGGo0AfCNDeSd92
   LQ85X6zBl/aBl77u6pija59Gb4cKirRf2DkZCQf6xJhbcidxt6qL9n2gb
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303679774"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:41:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHM4Q03sW97lvr8jsCB0EzsmJGH6lnlBsTht9+eIzWpFSDipt4vVpOTxUEu2Y+5oITZ1zIh5qYJhCGEtS0e2igPCqu0hdshCOvRphikHn/1QJO6+Q+DyLffwCDfQCg2t8JqS92o/hpsUtpJsVOpo4byNCq+ahowsT44+1w4nkH92klfhUC3SWQWouhbbKVMOUKt88w8Erzm6iCwls/Q6nJkr3H094ngTZqoHTLbeUkOCZooDSopLtu6xcUPl4xCkajydesdx2MM5jKBwl5mrJmtnvLVxlK/+1720BO+g3lWhnTtybRzxEwwJW1FwadDWaNA1NY/hjmnL4MXiUVmySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=YVwLtaT+kZveD7HOQc7Mhd1ToFCY1j/wvFHElg34MxEEVl1J6v651wAPGxuAXx6fS6FovVn8E08orukc/100dGiH+Y2yCD+i7/Ljt9un1IfL2P9oTywxYdn7sok2Q9d5fteA+CLPChaMThghcEKbK/sSvm98RLVc1zAzEnpROWTycOJsqusQWYRQLkQ9rPleH1TXwW3gA8hdO6Jyw6JR/N+zliO6GbmkHwxzZxVJqZcU5JOOy4bEdG+qNUbzUfpaT3W8/45IJw8suzqPsSIe/V3X4QfDhsGyJx/ZP9xB8MRzXe39K4sSaOZqa2DJc5tXzXdxuOjHkT1FX3ALFUExcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=d6rybJhpFIwQulEuliZumiJQ4m+ahQCKnXI+N/6f9m//2diNF2MBMqzPDJaAWHdDeZNuL/beMzDvLd9BelJTEoxVHbMwTe6tiZ21jM9s0dBPOdjT5FjKSg2OXEmVerbJO3tm5ekHxL5Sv3jb1tSbuWgOM1N+qtzM3Eo7snXLpgA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MW4PR04MB7265.namprd04.prod.outlook.com (2603:10b6:303:7c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:41:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:41:27 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jiapeng.chong@linux.alibaba.com" <jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH 14/44] csio: Stop using the SCSI pointer
Thread-Topic: [PATCH 14/44] csio: Stop using the SCSI pointer
Thread-Index: AQHYFJVf7X2Hjpj/YkOTNQOkVVnvLax89QYA
Date:   Mon, 31 Jan 2022 10:41:27 +0000
Message-ID: <f9f200e3d90adc41b65e6121392d545d95d60779.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-15-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-15-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 824a37ae-4bf9-42b0-36d5-08d9e4a63c33
x-ms-traffictypediagnostic: MW4PR04MB7265:EE_
x-microsoft-antispam-prvs: <MW4PR04MB7265722A334409864F5EDF539B259@MW4PR04MB7265.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lArQFVa6NIlAUXJPFXz5e3VY6xmS0jpFXhFG5zz673Tj+GRUnYSTKONr6jfSsUYD1nrOyKdR79u0s11yOZRaGHzmFUdcV21U/g5Dt0bYoRz3NaMQADNdoM6VuxnIJFiYBIRJLz2JQdm+i0frF85mr1Z9sgyI71hE/SZTNIsvwfYLanru0gI7Ropszd2yZLIljzOZKmAeWPWfyTHpqWQ3ak3GfK9VbkjxSSQCtyiaS0sF5JXuMTQdXtgdl4mdg6G9FpDO3iR8lgIdE6FkzgTm+gLHX2DtLVk/NkJU079O4AhgrICfYpGDzlyXRE80GIx+vInoYKpLYnfQRbz+nCQi5WSt0KGALpWmY2kdbsjJB2DQ6OAZdByYAVc7fjQTMuxWVtojtRF86UGycQbADAB2o/nNk3/CptnkSebPaNcJ8o5gWms9CWYi7Ccq048jsX8ZiWFTLBuKuwGWuTmfbNgmqRu4jvN7FjgvvZKbSbpr+pz3iuwcwFlUdle+htRvbvu4TkCU040ewy1X714JA0gsnnrAWr+lk3k6SURgbj9pDH7MEo2RCg+pU8HfZp6t8ZcM4qFNkldGZafsASIf1GW4ZkcbIeeAiCXFK5wzjfniqMOuDJ9tS5Q2/9ai4OzJaNlQbZkLMLw3jhRKis6X1q4SScqEUCIeCStAUomPamBa6u52yOWXSATGriJBDLTwGwyl3VXyxQ4Y7CogJB4v5R6vhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(19618925003)(82960400001)(38070700005)(2906002)(38100700002)(122000001)(6506007)(6512007)(316002)(71200400001)(6486002)(54906003)(508600001)(8676002)(110136005)(26005)(4326008)(8936002)(64756008)(4270600006)(2616005)(186003)(66946007)(76116006)(66556008)(66446008)(66476007)(91956017)(86362001)(36756003)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODVIRlNjc2dCNVROb3UzK1pqcGZrcWtqRm5nK0FMTTVCcVlmUmhqVG4wR0Vi?=
 =?utf-8?B?RDZ2eXlRZGUwaXhJeDZjQWtXb0VIdmJZOFhTcFo1T0xCL2t4VWI0WnBFTkVW?=
 =?utf-8?B?cWxtTXVmZ0NPU29aVTRoZkgzYzFZdUo4M2NsNHA0dFpsUVJYV1A4UU1MUSti?=
 =?utf-8?B?SXNSVUkvb3U3TXNMckhnb2Y1aHJSRm85OHRXeG16WHRGemlxSDBVOUFSYlcv?=
 =?utf-8?B?TjVsYUlZQ05pTVR6MlkwOHJqMjFjK1o2NTdkanB6VkkvWTF6WnNsdS9rQXF1?=
 =?utf-8?B?SnJHanAxK0YwUHZkTjRIdXVMNHFJRVNYdHhScHVKMGlyRHJMcU1jQ2tFNnVX?=
 =?utf-8?B?RUlhZ1NpUzZWVUVvcnJuOFVaYysvSlBuVjlPY3VGNHVsQjNENDhtUmxMdDcw?=
 =?utf-8?B?c0VpaFI2d0xvVUlkYlFJR3BTZWxLMjJ2ODQ3OFhFNHRkOElFZWFhQ1Y4SHlp?=
 =?utf-8?B?Wm13K2RKdUlhUmpiSTNVWTJmREplaTJQZWRCUUY0VnRjcHBpUUV0SUxuZlg1?=
 =?utf-8?B?OWE3c2REeEYycFArcDVMLzV2b3BtZGp6OEZTWGJ4YnB1K2UzZU5YKytWb2pr?=
 =?utf-8?B?ZmJ0b2Q5VEI1ZE5nT2Eydlg3M1B4UDNpaENpVHg1OXM2dVlrMHpZYUpLZjFN?=
 =?utf-8?B?cEFOQnkzbXVaa2Z2V2N4S1hDNFV1cGZYblIvVWh6K0VZNlRFdkJ4N0xIY2Fh?=
 =?utf-8?B?YWVDdFdZUGxaYjZoY2JNUzlGeUI2ODYrVmRTQyswd29TZ05sb044RTRjcnkr?=
 =?utf-8?B?ZmxuR3dxQmY1bU5VMVlEQWU0djBSK3RhSG1jc3lrakpHRC9VdDFtdUxhL2Ri?=
 =?utf-8?B?QzRrM2M1eUFDb080YkhmbmlLWXBIaFRJV1lRNHZXbTdTNUJaR3ZwU2l0SUM4?=
 =?utf-8?B?NGxUSEhHTkNOWFVFT09sNG5CYlM1YUZNZ2dGajN0K1RVK1c5RXBDNi9UVld3?=
 =?utf-8?B?eG1CUXY1Y3VBcW1XeW10aHJZNFF3MVdZak9rbzNvQTYxRmZUUkZET2lFN0dl?=
 =?utf-8?B?cjlvWW9HZ0FBK3RtOVgzRkdjRkdxcG4xVElSTzFiUXlpWXFVRSthcUdRMGsx?=
 =?utf-8?B?ZEo4bC9OWS8vOEorWFhKOUpKZlFSRXhDVWVYcTN6RjRocERoSTZWb1hvUjdv?=
 =?utf-8?B?dDZVakVOWlFWdzA0SUs5aHc3WGlwUEI3cmt6Z1RwSC9Pbmx2OGxqOUJLRWgy?=
 =?utf-8?B?Q3o1alVHKzJYQXZiTldRbWFhYmZYNHNyL0tOVDdhd2E0YzRRR3I5RHVjNUdl?=
 =?utf-8?B?dFp5M1ovdXFGaGhqMWxoQ2w1dUNMZjdNRFZmdWZlckpZOFNvSmlHbDQxZnVw?=
 =?utf-8?B?NVhJTSs1bEI3SWlsdkFYeER5dS9HcXgydEZsRldOK3BvQ3lyN3dIdlBQcTJh?=
 =?utf-8?B?ZUU2T0RFdjZ2TW00aEZvTWtMUENkS2tHMGZDUk1nUjgrVi9FNTI5WjhoLzNU?=
 =?utf-8?B?WHVjaGoyQk9vZFFSdVJ1OW1sVjRkMXNDZU5zeEllVTdDcmVQWUxKaG5PdVVs?=
 =?utf-8?B?K0FOanhBUk5lM3N1N0xySUNXa1N6bzB5Nk10MHM0NXRwRXRmYWZCU0FscUEr?=
 =?utf-8?B?MWYrbEkwU3RURGdoWWplRGZUQmhieVpuV3ZwN2hPNmVCYUgvZ1F2Y3RaclhG?=
 =?utf-8?B?UEtrQk4rUjVHSTJITGszTEg4cmw1K2dtK3REaDR4ejBENWxLZXNIdU4rR0dh?=
 =?utf-8?B?bWJuZjlndlV3ajQ3MEpIL0sxVjhRR08rU1BBUUN6ZjhjQUtlcU8zOXkyZmgv?=
 =?utf-8?B?SWw5dTl5YXdHNUI1RUFnRVlhcUkyR2oySk5Sb0ZsWXFkcTJXQnN6ZGxXc0li?=
 =?utf-8?B?NU0rcHpSb2FSQ1RMZHRCK2dCL1I0THUyU3ZwRHBOR0E3N1IySG03NnQzeWxQ?=
 =?utf-8?B?Z1ZmZ2lQMHd0eG9BbTVKK0hrM1R3bThHdEtBWC9wM3piTXN0SFhKMnNNeEZ1?=
 =?utf-8?B?NmxDZHVPUlJVeXllNFVPOXp2Y2dGVnhCRG5SS2RkOUJqK2ZNZ1BteWRsZEc3?=
 =?utf-8?B?akZOVzFYVWppN0hNelZNV2w3ZVUrTXQ0SUJhVXQwUVBCcW41NTBRREU5V01h?=
 =?utf-8?B?ZU0zaEYyK0dCYWJtNTE3MzZ2TTRFYjErUldmck9NbHBJWis1YTFrbnFEN3Fz?=
 =?utf-8?B?TWRaSU9xcWduNWFYa1FZcC9FTTduQ2x2R3RONzZ6ODV4ME5Ja0xMMk5ENzl0?=
 =?utf-8?B?UDQ2V3NMNmJEWk8xUkREN3NZS203MlZTVTlIdDlTamhpYnQyNzYveHNYQ1Bt?=
 =?utf-8?Q?toH1MYKGz+Lj9QsDASFkKdlHWKJRNcA1LPBajH8hiU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35D35BD5B6B2DB44B946A38CFE3924A6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 824a37ae-4bf9-42b0-36d5-08d9e4a63c33
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:41:27.4079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mnx76MRAYM392PToA/qrBqelD4DShkaU8ENS4+mHwx+mVfVmN6IxBTmTnmhXws8d2MKiU5c8dH9fGj5u6HvKeyjJ+q2YaXxKK88fsMqnAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7265
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
