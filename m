Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C70C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiK3KBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiK3KBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:01:20 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7724E2B185
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669802479; x=1701338479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pTb20iFl+iTEFaCwU56irACi6k1OuIWE+RfXBMgolIM=;
  b=bpzR8eyRfXTF5iPaBr6VQ/VAakwo6zH0HTXSMdsBfpPQhsZjhLdDGDBq
   aBjmIb2FApWr4iL7HsjmRo2jIfdQm1TJZ56ZAqp/bIvJAwP8KkrfFWSFU
   3d2LlbS8ClmxJVD3K+fi3t4SJA8lb6nB2mngc8XcWawOYHsnkZdCWu+oG
   ypbYPK62Laxat+j+VR6cDdsJj8UyU3CpvpULoOhzuoUqTPC6Z68tP+6Qg
   uHuo1mPvt40s7ALlBZ1G8fDp5WWTtRL31yGuSSrfqwk2tG4oa06FH0WPB
   WO+/Duwcu6JCD+SEG6p0J+6d6c5PGoiq1LZRE/L0qDPj/evzWXxkBW9QD
   w==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="329641273"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 18:01:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgxBkCpKHV6uOzJqg/efiAeyimTadQm+V8OTOODVU2RTQczBpij4Jpu1LJ8dzebO1U8/u/AaLATJrUx045w7I1BwfJgEtIq9ZGSSSaazVIxYnjTVxJODh2sSdjjOCnosaX0ztdvuwzLa+Ffio/wkBqxRUhsJVtM3i7KfZ5R7lqeZmevlRSPiG/cw30I0SdhXYNHHskDOihr3E5dZ+rz3KLN417NcOiRp/aStXasIzjrRomTp0ilFKG7EqZbh5yV7FggobtQoM2GXrGDP9MDKWA9X04UR6weu+jbsMmbabiIbpvAxzWU1DR+/KeDJ0+iHaRHn0LVVoYd3iiynnDU7Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTb20iFl+iTEFaCwU56irACi6k1OuIWE+RfXBMgolIM=;
 b=ii/vqwWA1Gnr052jSYQuiQHrXvcpsNHxmMAf6KwML1qeYZEivYPL6sY+YCc6o9gesspG9NNJ5+TEPIa2pH3bizrqmlxYrHRVMc+RFAZWGF7jf8Ue9CepyYj3eWxHbF5l3e9XEv6IXxg3XyU2tGpVu/pAZVvxAoK7OYnaRKytU2onBZl2Ik4v2EpZTztUVEzzPwKmHKAAr+raJdrZc8pvY4oebxa9ZNKkBfM6fruGKNvvxpX8dI7ho5zy+PFoF1Xc8qNmEh6pcjDt5ZcD1653GWO5QtLtuovLIDI3f3uFCRua6R6X1ieYw887hQNN9JZNsquWC/b596twak8a3rvXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTb20iFl+iTEFaCwU56irACi6k1OuIWE+RfXBMgolIM=;
 b=fmC09hUSbnPfm8B1nTWBi369/Pr+4V0pUAcEwnsw5sRZDyWAGqfeIB648W342ujJLXMbiknfu0lVPO0Xne3XPAnTvhnPp7PJLP5+a1KyGwrdFy7sIZYD05ZWbLSveppbZ0v4jAL8hvtVSWioA6xAEmwp+/Hd6UvyGnSqhIVGkBY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6883.namprd04.prod.outlook.com (2603:10b6:a03:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 10:01:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 10:01:16 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHZBJdIwi0ipPRZEki0DoidGKrtk65XO8GAgAAAboA=
Date:   Wed, 30 Nov 2022 10:01:16 +0000
Message-ID: <568ebb04-c0a2-4f49-3b92-3c929b1791de@wdc.com>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
In-Reply-To: <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6883:EE_
x-ms-office365-filtering-correlation-id: a0aa6a19-1baa-4508-adea-08dad2b9d237
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zg6Ai73RgJ9uAsAg7JqJQOiYaGjqlxykNKOFNDWmAS295nR+/rvD8WQ9Atec86qFoAKXYr8rRmyszqVRdDeO0sck1p00J2z9NWRCGSGbrDdu5zbZiVW6siIJLlUvCTat0Km3kPz2NKSrjfDIZUbbzCS9Q0OvcIWmN1CKDdIkYL4u3rvbuXYMZ+E7gZtL+2rmTxlb6Mdxm0FId4eE78EbeP4pDNxDibbmYmb5Qo5urIAyYOpxtuKHNKOp83VfAR8ZCTogS13vB0IIQUXEAMy869+TNz3PtaaxekYYNjdqGkfa6bQEiY0VNr0NqADLRjRqp1MW9w7RAJYT9m0DjtNHDlI+wPB2ED2AhnHYWBw0C/A8rQ8bEm/TNpdp2wg9GmxmHSx0yESAkQE1zkhoHHBn3OV2cYLM5uAkwpLLWDRRBMBXESHxusyPRuiPKBmiqkvfxdEzPQcHWtjkbUiZm/DZJW/dsKuksi0aTBLKbse7O/l72M5j0pylV8c5RATeKLYyxIzKXDrC0wOTokH0rNbZd/PVWLw39R5rGXEDE17IL9NlC45Vl5a9YOzio3XjGNfRYKuFowuF8JssrdKpty2Iu1BugCUIjkSHCMfAtJq2QdYpp/fvUI/l36/SOYoj5X3Rs2U/PXh63PrUQp306F6b55somFwBUgu+oUOPpShfXw64bPD2rbiEL7j7SVrCPdhQefULHEu8TYH/a3Xvu6v47hZQRkqW1ezuNKb8LK7nmeHAIlRJidrRNUxDJWztT+qlzyRBjlwSj9hKYCTaDUVUlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199015)(4326008)(2906002)(4744005)(91956017)(8936002)(41300700001)(5660300002)(76116006)(66946007)(66446008)(66476007)(8676002)(64756008)(66556008)(316002)(31686004)(36756003)(110136005)(71200400001)(54906003)(82960400001)(86362001)(38100700002)(478600001)(31696002)(186003)(53546011)(26005)(6512007)(2616005)(6506007)(6486002)(38070700005)(122000001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVcvNlB1MTdONzhyejRJUUtBM21xZEc5Y1JjRXYrdytnZi9tTVNibGlYUVYy?=
 =?utf-8?B?N3hDOGx6dTIvTnloN1BReVlQVXNqODhHVUZKL3VqRU9KNE1ENDFiQmZtV3Jv?=
 =?utf-8?B?TFJFRHlBNmcxY2lwNjdpeEpNRlQ0dzNIVEgyL1VDbWlZMFpYODNSWUVEbi9n?=
 =?utf-8?B?YmxuNFI3V0J0NHplc0dCZXNKdFhCWk1wTmErWUtQR0VneWtOYm5PdmFGK3FP?=
 =?utf-8?B?L0pra05TMGNjM1lWb1lnWWUwR0x3M1UvSDMxM0xJTEc1eHYzc2g0T2JRbDZx?=
 =?utf-8?B?aUtBTk5EZGlUNmdUYVF6QlFvWGF4TE8wYTlNc1ExRTBma0JJbnY0UThvWm1L?=
 =?utf-8?B?cEpzWE1IVDhkQUxJRi82YlU3OTdZNFFTWUhNRjFJNWlGZWlpK3RqaERHZWlQ?=
 =?utf-8?B?eFdUUis0eTJ5SlRMaGRNRWV4OGp2c0dRbmJISTRVaE1tOHlGWjA0d1NrcDhG?=
 =?utf-8?B?R3JlK0FkUC9lNzc4b1RtY1JxODAvOHN5SEJXOThYZGZhTi9SakcvbHJMajdE?=
 =?utf-8?B?emFQSjdPRFJkeHVoaXd2ZTB3MWdrU1pGYTZCQlErVUUxbTBtTCsycW5OM0Fn?=
 =?utf-8?B?VmdsWG44K2tSQXUvM1ZwWkt2ZmtQaFk2S3R6c3hBeGZVVFNaMGNXcDJMSmlO?=
 =?utf-8?B?QXBZT25hVmdEbHBFRVVtT0JObXd2cGtwbDZZbmZ5U0g3YUtkVmducEh4YXRy?=
 =?utf-8?B?bHRBTVZqMkpWWnUwY1l4WVIzWXNUSDF4b2pZMFNSRTRZMVJLbHJ5WXZ1OElN?=
 =?utf-8?B?VjR1QkI0TTV0WFVqUXJLWU5lSG0wbVFxOGRyZXlnSG1KaXF0Vmo0OEVpTnpT?=
 =?utf-8?B?cDFYTmNSWEt1MVpWS3p5emdUU2VyWHNDZVphdFVkd1QwY0pNbjFISXRJMHBU?=
 =?utf-8?B?cUVoKy95cSswY0F3WVI1S0QxUjIvL3BSelBESU4vRVE2aldnTkRnNUtqOGNT?=
 =?utf-8?B?K21QMHpQcE5nWkVZRGU0ZVZCWnAzSGZtTnd3WXo0NHRlMWF5VVVZa3VKTVFm?=
 =?utf-8?B?eHppNE1NS0hEZmVTamFaK3JoR095WnVFR0VkY1RUN3AwWk96dTBmNHluZVJn?=
 =?utf-8?B?TVQwdCtGVWtGUElUc0ZhbEFwRWx2RVJkTEE4bE9NT1htcHNqelhVenh1M2p1?=
 =?utf-8?B?ZmRhcTdEYnVhdUYxMXJ2WlRsVVhhOE5xMkFUbmErdFdDbmFJVjJtTTZjdkcr?=
 =?utf-8?B?OFY5eUwwNW02WFdQMWtNdTBGWHduTXcxcHFaSlBBMVQzNzc3NXVjRThta0x2?=
 =?utf-8?B?YWdYSFJMZHNLTzZySHQ5M3hnY0UveUlLRTFCTDkvWDFTV0NQZVMzcmxDNzFx?=
 =?utf-8?B?Tnk4a0ZZeGw4SkEwVFdCTno0bDdLVmRySThlVVpmdk1lWXpUSWdZRmdtSFU5?=
 =?utf-8?B?K08rT3Q1ZmVGM2dCdU56WEs5SGY0YlYzMVVVOFJGU2hmSFFZMW1YR284R0l0?=
 =?utf-8?B?VHRJTm1nUS9scnRiTzlzUHlJYlJXNU00NzdsdTZXcCtjTnVHSW5BcjBrMWxQ?=
 =?utf-8?B?L1ROOXdRRDNoTWJnc3RRZDlnSFNDMGZTTTFqTnRSdFBRV3NrMjB0RThxUmZa?=
 =?utf-8?B?L0FiYVk3N0ZZWm1hUVdoSitUaTBhR2p4NzR5RHFjajNKOXY0YUwwd3NCeEl3?=
 =?utf-8?B?M25yY3ZFZnA2bnFTZ1doMGorc2xhQTlWaU1LSm9LckJkdGFoTWprVElyaFBt?=
 =?utf-8?B?SmRWVkpWVExEQzlEaVZEZ0RqUHVvbUFhZlF0bWRoK3R1NVZYeEY1Yy8yMHd2?=
 =?utf-8?B?ckRRVmtJMHNmQTNGWVh0bjRocDlCRzNwL3Qybk04UDFVU09PWVdMQmhIYVIx?=
 =?utf-8?B?NWNlSjJ3M3BrZHM1MEp5NTNraUI1RHU4RGJwa1VhQUR0ejEwbGtjckFEOWFP?=
 =?utf-8?B?ZUgwaFhZVVExZUc1YTJzcFRrWUkzTzE2bFdCVFhlN1E3ejlyRktiZlppc0Zh?=
 =?utf-8?B?SVhnelN0Nm9GK3F2STdaV1hlVDArbTVGZHVhajhNVGdFU2QxVzlVTGs3UjQz?=
 =?utf-8?B?ZWgyczNUSGlpQjgwUTlSdldEOXRsK09rd0lvT2E2M2czTzFETFRhRENGVkJt?=
 =?utf-8?B?cGY3TWZTb1J2RXh4amJGQkV6Y3RkRzlscUlZTHRPM29xdHZ2NVlKWEhPZXVp?=
 =?utf-8?B?d21MdWczdVFIVVRScUwvbmJlUUVPSG9IS1pqNUNnZHpnQVEwejN2d3pYeEtK?=
 =?utf-8?Q?3NOsP2GhMKhe0Ou8hFfYRXY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E92F04C4D8A374AA7FE24E3698C1B28@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: exHtZciH10MXoFtlkAiD+eryREOl1eDTLCTkG0Ss+egJzhtR5y/09Lm5LG2r5/DTjCyR/hu3UlbAGhivGDD7zZ9Mjtuzr7MR0joVANtGZc2/LsqpNqwmQegpi6LFkFe+hD2vgYgxcfT15/z3avUwWHzgSxV5C9BqfAE1FICHaGsgwYYf5rrEEJPlj5U6QnV71i8lkXOOVkre6uQHZQkiq1Vl3NKrKMU19X5VsJQLrgtm1063+7idEifCivRL8m4PuN4wUclwXqjCUiV2bw5Ol9dQIo9eETfb+uh1WaRBQdvv+tTRcCszxAvUv0wdh9qLYeNFxJLykAEVMQBRS3gb2fXQ8AH2SQ8XqQYbRdND4BvjrOq5gIAZMu6rsR/oIv2d/2QkS/lZnxpwDoShLck276k95EpRiWG12EwuqcP/fwS4+D1uQGe0t3fbrfgdO9BWQZPgXpXscPxqK750VuhCPf2P9jCRGDt7UHsd7Wx/MTiKlwRGo6HlGT8u6ak6Sh5ZFWFf3UYr6Kxe03Wi79RhIfj0bWf69gOTrCFUUZXH6FGXEZ+TCV10Ahvu8AnqDqsMg1VxCthnIJ5HQsZ2NFMgmYpvia9OTtk1Q6X2a4DPo0CwxgtE2RU49Bjn4o/Z9S7tdP0nCSzkN1rt9H7YNo9LVaxMlmHS5+QY+0QdeyzjZEiiVGL6Khg0g6F3IJu8rKVt8mQ2wBA+A5hZpA8SJ0oZcEbPptNFyxaW7fcepQJevab/1sF+d3tyIwSQ5yBQ/GQyuav5rblzgAdKOoxybVUpv73XtKn51uNzcHN/d/kqKlOKheOFxI02BgBTbvrfS73bJFezGn2e0VNOXpsIvD4b0Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0aa6a19-1baa-4508-adea-08dad2b9d237
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 10:01:16.3837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UpiNGKdKrKcxzjCr36OTA305pstDnkD7z5Bf78ke8MiJPmEbhRdcpE8WpO5liMtK/DvNCwLDkJOk9RVTwFeOg2lY1P5lpwGVj1XdNVBpfG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6883
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMzAuMTEuMjIgMTA6NTksIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBPbiAxMS8zMC8yMiAx
NzozOSwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPj4gQWRkIHRyYWNlcG9pbnRzIHRvIHRo
ZSBTQ1NJIHpvbmUgYXBwZW5kIGVtdWxhdGlvbiwgaW4gb3JkZXIgdG8gdHJhY2UgdGhlDQo+PiB6
b25lIHN0YXJ0IHRvIHdyaXRlLXBvaW50ZXIgYWxpZ25lZCBMQkEgdHJhbnNsYXRpb24gYW5kIHRo
ZSBjb3JyZXNwb25kaW5nDQo+PiBjb21wbGV0aW9uLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEpv
aGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo+IA0KPiBbLi4u
XQ0KPiANCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy9zZC5oIGIvaW5jbHVk
ZS90cmFjZS9ldmVudHMvc2QuaA0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAw
MDAwMDAwMDAwMC4uMGIxMWZlZDgzMjdiDQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi9pbmNs
dWRlL3RyYWNlL2V2ZW50cy9zZC5oDQo+IA0KPiBXaHkgbm90IGRyaXZlcnMvc2NzaS9zZF90cmFj
ZS5oID8gVGhhdCB3b3VsZCB3b3JrIHRvbywgbm8gPyBEbyB3ZSBuZWVkDQo+IHRoYXQgaGVhZGVy
IGFzIGEgY29tbW9uIHRoaW5nIHVuZGVyIGluY2x1ZGUvdHJhY2UvZXZlbnRzLyA/DQoNCldlbGwg
aXQncyB0aGUgY29tbW9uIHBsYWNlIGZvciB0cmFjZXBvaW50IGhlYWRlcnMuDQo=
