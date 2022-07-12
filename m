Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD2C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 03:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiGLDJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 23:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGLDJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 23:09:47 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FED2B619;
        Mon, 11 Jul 2022 20:09:46 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F1BB0C1A48;
        Tue, 12 Jul 2022 03:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657595386; bh=HilNEJFQ+l8SIwWSoy6Amaag5rL3g1okIo6MQTAngBw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cYfxvDHcu88l4jF8l1H95+nU34gusZFttcb1BfUhgmPPoVEF46wNNaGVHi19f8W56
         /z9snmuFQtDM04hHMCXlH45OojP4rwWgEYEpZYm+Dp+J17AVz0SbCz8V2njL1TNMTR
         h2kpvJkaysVewdHEygLsJM67czj0eR0nqme6B9Gar3B7M65x1fvwbkHdcCi4dOhPXD
         wpW/uqBtpMd3bmMUWOa0ia4VJJ32dwT//ZaCHSEOIFR5h4y7yLlFyjmQZYXvQr2e9h
         MJbrhY/5AEnDEJjpAJT/ZOtFPJFu1zfT8RyF+sm93GHe95J1rwsEQwAnPppLD5lZFv
         pKwQ7p74K0q3A==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id DF5DFA007A;
        Tue, 12 Jul 2022 03:09:44 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id A5F95800C0;
        Tue, 12 Jul 2022 03:09:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ngoPuqHP";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akG6snTvVNw0Uxax6w/PVLYPx/Wnh0w9z5dempwn9/cbcpj1B0QOq68JESiTGlgVEYKVB3L7yzmq0TijjAM9+fJLHRFSEyN9dDYrVp65ieoYezO74qNhCgsyRP0FwTI1ymFGtG+isg/u2EphXKAvDfWjjiM2acbYUQaKPJmZfNdXQFdfZ4C7QtywgV9xwEdLLkPcHm7r6B8p603qt+/Ab+9eo1jVbcTTRBS4eIgHBZP5HZYMpsrjsfmvSDRh5FDxVUv5ArAg/9dX0qvBrUOovcAt2KP/o/py+pc9foiCagyvLp5y8FCjieGD4VoAmv9k3Vfze7CsnIFaJuprTFe5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HilNEJFQ+l8SIwWSoy6Amaag5rL3g1okIo6MQTAngBw=;
 b=RNz/lOROBDqfgubxYI6SR5RsR+7IoOEJbAQlpNbXFvkXExDnYkIQdNkNJk5xB4UX0XpRsUaJpd01ui39dVS4LIevcU+GLejtmUo5kO4zVnzh306GaS8pn9uiYTk5AbyrDm1e+wIvl3G4D1GKrU68SvW/8FRahKihzRuwXB6Bv/om1YhLVzCQyxnhLhg+IbAvkXNZeA3aLfQU3dBtxu2WN1tyYnT9J/olysPTbjT55lRjGcVG8u3EOvWOC5sh2Lwb0cNi7G4nHlROUTxUgzF3wcCaWPB6COve9ii9JiLQ9Lgsd5SBiW1j4tm0mSGpv+QhG520Rq2hMVOZu090aNb7ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HilNEJFQ+l8SIwWSoy6Amaag5rL3g1okIo6MQTAngBw=;
 b=ngoPuqHP6gq8BRbDjUrOB4z3krs2Bb9jXzyR4OiqrDihMe2ooMIHAMOFF5ESC36y49ISLCxK81sSw71BkEEk74BRTUrf5/cmHByG3aLRN9kSARECBJEO3Y7DOpbiYr8HpqDvPr/qlKwjV6bTlimvTxK/NWXUxbbKLjZqEk7qsdQ=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Tue, 12 Jul
 2022 03:09:41 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 03:09:41 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Topic: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Index: AQHYkZD+KpUxHtfPikWfNnfwlTmL+K1y3vKAgAI+EYCAA+LBgIABFsGA
Date:   Tue, 12 Jul 2022 03:09:41 +0000
Message-ID: <629f8171-abbd-c4ea-c22f-afd9815cd969@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707125657.GB23838@yadro.com>
 <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
 <205876d4-5455-4f31-4c9b-34df736f68fc@gmail.com>
In-Reply-To: <205876d4-5455-4f31-4c9b-34df736f68fc@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e5072b3-df91-477d-94ce-08da63b3f69b
x-ms-traffictypediagnostic: DM8PR12MB5461:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aLl9aaDWAFVGGL97QLKa8JKEtvxq1bSnT4bbJRWuo9a7q+4T2yGH9/88g91vrmmDAdAGJXIbjY0/F3QRNjX21K6eRI0KydV/qdVQKi1mu0YaRiZ8X0nHEFyL/Vt4dVT+1keLRlvDoKqrIcZ5n+P9svoLTdL9N0AbX2Jr36HGTBNqKoQEYkuK5Sam62KcInOzIXk8Jku/MA62eCJe4M+0I4+h7W/QG7bHwx699tz2wFxcUW0IbdQmGeOCNyvbzgl46yLTMx0r9J/cLjR2SZX9rcUf75p+xO2646Gse/LvS7pHIoUnlV9OGa4VwrxLnGg402sg+b7rxPWdjISrXsTvFaHVh5QU9bf/vCUVN6ByMQv5QPfqfulyGnUgv7qvhAsWtw8ZQ+6yddlZJit4Kx8QIgMiT4kr+R6yWpWmv2RJWTjFyTu5oY7BqJQCllgr9iapDSbPy0V0CI9gzPTV8tpr+xjtDB9QiTqXQjH06uaSetG02lyPbIt9lVmw5O7BvCsjOGghxXwPT8rv0bcrAerEScVS/raadVRVVQSfdgv/C0iovqUOOww4tD7dvbhZqYPKr9C5BdYoiK/TzJci0ZUmjL3mxFfq2utkcb8p5aK3NqEc+SWluTtSuN33GA7ROjUCBCrIOIxgPQM3HI7RZlksK4zjv74ugixgNROJrTxPmuzo0bpH0jI4crGWrrP4GqltibVNSbnsvTBt5hw3q4jfj+nnHn2YqFekE+7xKX+dpR9b6huwUj4TL/XazwmaWl06kP8+wbInZJDwjxeddM58f05YQzpkY0ej/NQvKgdoePYjYVI3NYDriUumJDzfcfNwm2bmoxW9WestDM6R5CeLMpwRjHTuYvJwGA6ff8yvU7L9WDlQ75fUm9Mf+0q8Ol1d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(136003)(366004)(376002)(71200400001)(8936002)(478600001)(186003)(8676002)(26005)(122000001)(5660300002)(2616005)(53546011)(6486002)(38070700005)(83380400001)(31696002)(6506007)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(76116006)(66446008)(316002)(31686004)(6512007)(36756003)(4326008)(54906003)(64756008)(110136005)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjBwZjA1SmJ6WjJiZVVzR2JCTHVHVUlaMHBrMkVxNGdLUmRoMG1sdHRjQzIy?=
 =?utf-8?B?VnIwcXY4SXNRK3N0TkN6ZWhUZHNaUlQ2ZVZINjlscWJ0cjROUGRUam9ZaDdB?=
 =?utf-8?B?eHVzc2NzaEZ2MHZtS2lmN1ZmUUlFZjlEVGI5NVVPeU1CL2pGajdyTVZwVWhr?=
 =?utf-8?B?VXVWUEdMRG5oSjBsWmFWN1pDS3p5QTJIM0x0Z1hVMEllNTl3YzUzazFzb254?=
 =?utf-8?B?ODlxTGduN3U0bW5ZckY0RmZXUjZGbGd3WlUrUzBjOE5GMTNWVmtYb3NVOGk3?=
 =?utf-8?B?cFJ4dU5ubDRzS1hJSFkwUVBYaXZ6QlcvbGs0RVd6OG8vZSs0QjlrdEhVMStt?=
 =?utf-8?B?a1dLZ2ptcFAvVWlBYkVLYzhWeE1ZVDVOSDliUXFiZXNVZHJRMC9XU0d5T0Vn?=
 =?utf-8?B?emFnRG9wdCtsdXo5U1JXSytaN1QrbUZFVDl4OHlhL2ZZWXJvaWNzRHA4Ykg1?=
 =?utf-8?B?azRzckkrdkJ2VGZvb2RmWEttektXaGlmY0FLcE0wNDgwY2hlaEtqcWVBZ2N2?=
 =?utf-8?B?TFRGSUQySVFIUnA4TnV5UG9WMGJNTHZ1bkp4dHY4VS8vK2k2UC9lS2lNSXVZ?=
 =?utf-8?B?S0FJVDYvZ0dsTFc1bCtaaUZSU3phOTA2bmh6bFZLQjFvVnk1VW4rWHltTjNP?=
 =?utf-8?B?ZUtJUndicTdUN2RPOUt3N0F1ajRyWmVCdmc0WmZGeUo0ZWNXa2pXRFY0YWo4?=
 =?utf-8?B?YllGR2NJRGp0SURRc1hTVDZaVWJmOXFpM2dNZ0tTVkJDa1ZQNlhjK0ltRWNx?=
 =?utf-8?B?ejF4VVhwSmpDWjA1Mng1RTJJMmhiczdPdWdueFJFNXI2S0UwaEJlTHRocFdH?=
 =?utf-8?B?Wm5weTk2eVN2aEtLS0pOaU5GTW4rTitCM3lmNmZrWS9ZRHAyOE5WWHY2K3hw?=
 =?utf-8?B?Y3diSW5HQytNM3dNd0VSbmQxNWJmMkZWZDB2OTkxdExidmtLRDE2RGx2UE5N?=
 =?utf-8?B?WWpiMkYxS1ROZFhjcmNMQkgvZDJDL05RUkxINGpaTmR1Y3hVcVRZaDZlaUNS?=
 =?utf-8?B?QTE1VUpDQXdCTGJRZmMwYVZWNk8wVk9CRS9UZWxFV2lOelhtNHNha1dmK1Ra?=
 =?utf-8?B?Z1FYVzlDUEhnV0lqSUJGOUFTQzR5cy9Dc3RFanNidXpuYWtCSmY5dGJNemV4?=
 =?utf-8?B?bmRQYkVuamlCdjd5VHZHbFdSdlpmM3RhV2RVbTVwYnlab01qbFlOd3VOTndS?=
 =?utf-8?B?VE1weElPRk42K3hXM1FTbHJpampyZFBkbUlKQTlWUmlFelViR2hwT3JvQnAw?=
 =?utf-8?B?a2JVUnZSdmN2ckdtTDE0M0hjaENDY2Z4YUNvbXJqNy9tSFdkN3lxVDNTV0tM?=
 =?utf-8?B?dXBWSTRpeTlCUXdaZkFqRmZXRmtqNUFoTnhVN3lvaFNFbHoyS29KMXRWNGh2?=
 =?utf-8?B?UlFRb1dVeWwvclZWN2JlWHVpaHlzR2loV21FSE5RWEdqQXNab0xJTmFnZHph?=
 =?utf-8?B?WStVdTNjdXE1bGtEd2EybERBT2hZR3RCOEZoK1BQbFFiemdxSDhodmNjWW9n?=
 =?utf-8?B?SEtaN2dXNXRIRFJjQlhnSkRLeXVOcXAxY1lBSHRHaFB6TjJDZnl6M3hpTVdX?=
 =?utf-8?B?ZWlVdnJxM3dLMlZ5VVZ5ZHRaK2V2SFNOd2R1RExBVkpTb0hka2J0a0ZHWmVp?=
 =?utf-8?B?d1l4QzRGeU5mS3N5dDdxQnBYeFdBOWpIUVMzUzRaRDVMTXYrSHFCQ3FNL2Zo?=
 =?utf-8?B?M01JMFJVZk81MjF5WFJIWDNXNWtDdU9rVkVVSGNOQlgwRElFV3lWNEJ5dFNW?=
 =?utf-8?B?R3F2UVY2UTdZR3U2eHprbVhreUtsR3Q1TjZKakJEbit5TmFYWEIxUzdtc2tC?=
 =?utf-8?B?ZHZWbkNTdEs3dTNuaXhiR3ZqYnBGTldnRjFldkJOS2FtaTIwOFp6VU9HU01I?=
 =?utf-8?B?MXA4TDgrdFBnY1djS3JJcXBLNnkzYlU3RURZZHFFMWt3dEhSeVBNNFAvcnhD?=
 =?utf-8?B?YUVXZWE0YVA0anhhSmVSdmpFeWNMcVhXSTBZNVVVa21VY3FBdzl1c243UUNq?=
 =?utf-8?B?SndRMktEb25wVkorSWdpZWRTREFCbWwvclVERllGaUFpSGZxV3ppS3I0WUVm?=
 =?utf-8?B?RGlINUkzSmQ2MkVVdnI4WENvOWxNa2dMWThXVDNudVRFclRRdlFrWlBhUWp3?=
 =?utf-8?Q?MClgVfq4oS46gNpXPqLXP42bT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAC406ACA3B4104AA8F1065E9988D4B9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5072b3-df91-477d-94ce-08da63b3f69b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 03:09:41.3564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7amiBVkp8O2avrnhcL5XhW0xfNm8PfxmjaMBEP3CSmuw+IlIMLFqeksRgv7jI4Ds41Y8LR4M8BXtO9X/mOuM2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy8xMS8yMDIyLCBCb2RvIFN0cm9lc3NlciB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IDA5LjA3LjIyIDAxOjExLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiBPbiA3LzcvMjAyMiwgRG1p
dHJ5IEJvZ2Rhbm92IHdyb3RlOg0KPj4+IEhpIFRoaW5oLA0KPj4+DQo+Pj4gT24gV2VkLCBKdWwg
MDYsIDIwMjIgYXQgMDQ6MzQ6NDlQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4+PiBJ
ZiB0aGUgdG1yX25vdGlmeSBpcyBub3QgaW1wbGVtZW50ZWQsIHNpbXBseSBleGVjdXRlIGEgZ2Vu
ZXJpYyBjb21tYW5kDQo+Pj4+IGNvbXBsZXRpb24gdG8gbm90aWZ5IHRoZSBjb21tYW5kIGFib3J0
Lg0KPj4+IFdoeT8gV2hhdCBhcmUgeW91IHRyeWluZyB0byBmaXg/DQo+Pg0KPj4gSWYgdG1yX25v
dGlmeSgpIGlzIG5vdCBpbXBsZW1lbnRlZCAod2hpY2ggbW9zdCBkb24ndCksIHRoZW4gdGhlIHVz
ZXINCj4+IHdvbid0IGdldCBub3RpZmllZCBvZiB0aGUgY29tbWFuZCBjb21wbGV0aW9uLg0KPg0K
PiBXaGVuIHlvdSB0YWxrIGFib3V0ICd1c2VyJyB5b3UgaW5kZWVkIG1lYW4gdGhlIGluaXRpYXRv
ciwgcmlnaHQ/DQo+DQoNCnllcy4NCg0KPiBUaGUgaW5pdGlhdG9yIF9pc18gbm90aWZpZWQgb2Yg
Y29tbWFuZCBjb21wbGV0aW9uLCBiZWNhdXNlIFRNUg0KPiBjb21wbGV0aW9uIGlzIGRlZmVycmVk
IHVudGlsIGFsbCBhYm9ydGVkIGNtZHMgYXJlIGNvbXBsZXRlZCENCg0KVGhpcyBpcyB3aGVyZSBJ
IG1pc3VuZGVyc3Rvb2QuDQoNCj4NCj4+DQo+PiBJIHdhcyB0cnlpbmcgdG8gZGlyZWN0bHkgbm90
aWZ5IHRoZSB1c2VyIHZpYSB0YXJnZXRfY29tcGxldGVfY21kKCkuIEl0DQo+PiBtYXkgbm90IGJl
IHRoZSByaWdodCB3YXkgdG8gaGFuZGxlIHRoaXMsIGFueSBhZHZpc2U/DQo+DQo+IFRhcmdldCBj
b3JlIG11c3QgZGVmZXIgVE1SIGNvbXBsZXRpb24gdW50aWwgYmFja2VuZCBoYXMgY29tcGxldGVk
IGFsbA0KPiBhYm9ydGVkIGNtZHMsIGJlY2F1c2UgY29tcGxldGlvbiBvZiBUTVIgdGVsbHMgaW5p
dGlhdG9yLCB0aGF0IHByb2Nlc3NpbmcNCj4gb2YgYWJvcnRlZCBjbWRzIGhhcyBlbmRlZCBhbmQg
aXQgbm93IGNhbiBzdGFydCBuZXcgY21kcy4NCg0KT2suDQoNCj4NCj4gSSBpbXBsZW1lbnRlZCB0
aGUgdG1yX25vdGlmeSBjYWxsYmFjayBmb3IgdHdvIHJlYXNvbnM6DQo+DQo+IDEpIEl0IGFsbG93
cyBlLmcuIHVzZXJzcGFjZSBiYWNrZW5kIG9uIHRjbXUgdG8gY3JlYXRlIGEgY29uc2lzdGVudA0K
PiBsb2dnaW5nIG5vdCBvbmx5IHNob3dpbmcgc2NzaSBjbWRzLCBidXQgdGhlIFRNUnMgYWxzby4N
Cj4gT25seSBjbWRzIHRoYXQgYXJlIGFib3J0ZWQgYmVmb3JlIHRoZXkgcmVhY2ggYmFja2VuZCBw
cm9jZXNzaW5nIChmb3INCj4gdGNtdSB0aGF0IG1lYW5zOiBiZWZvcmUgdGhleSByZWFjaCB0Y211
J3MgY21kIHJpbmcpIGFyZSBub3QgdmlzaWJsZQ0KPiBmb3IgdGhlIGJhY2tlbmQuDQo+IEFkZGl0
aW9uYWxseSwgc29tZSB1c2Vyc3BhY2UgZGFlbW9ucyBuZWVkIHRvIGtub3cgYWJvdXQgaW5jb21p
bmcgVE1Scw0KPiB0byBhbGxvdyBoYW5kbGluZyBvZiBzcGVjaWFsIHNpdHVhdGlvbnMuDQoNCkkg
c2VlLg0KDQo+DQo+IDIpIGl0IGFsbG93cyB0byBzcGVlZCB1cCBUTVIgcHJvY2Vzc2luZywgaWYg
YmFja2VuZCB1c2VzIGl0IHRvIGZpbmlzaCAvDQo+IGFib3J0IHByb2Nlc3Npbmcgb2YgYWJvcnRl
ZCBjbWRzIGFzIGVhcmx5IGFzIHBvc3NpYmxlLiBJbiB0Y211IGZvciBhbGwNCj4gY21kcyBpbiB0
aGUgY21kIHJpbmcgdGhpcyBpcyB1cCB0byB1c2Vyc3BhY2UuDQo+DQo+IElmIHlvdSB3YW50IHRv
IHNwZWVkIHVwIFRNUiBwcm9jZXNzaW5nIGZvciBvdGhlciBiYWNrZW5kcywgeW91IGNvdWxkIGRv
DQo+IHRoYXQgYnkgaW1wbGVtZW50aW5nIHRtcl9ub3RpZnkoKSBpbiB0aG9zZSBiYWNrZW5kcy4g
Q2hhbmdpbmcgdGhlIGNvcmUNCj4gSU1ITyBpcyB0aGUgd3Jvbmcgd2F5Lg0KPg0KPg0KDQpUaGFu
a3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9ucyENClRoaW5oDQoNCg0KPg0KPg0KPj4NCj4+IFRoYW5r
cywNCj4+IFRoaW5oDQo+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5o
Lk5ndXllbkBzeW5vcHN5cy5jb20+DQo+Pj4+IC0tLQ0KPj4+PiDCoMKgIGRyaXZlcnMvdGFyZ2V0
L3RhcmdldF9jb3JlX3Rtci5jIHwgNCArKysrDQo+Pj4+IMKgwqAgMSBmaWxlIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90YXJnZXQvdGFy
Z2V0X2NvcmVfdG1yLmMgDQo+Pj4+IGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdG1yLmMN
Cj4+Pj4gaW5kZXggN2E3ZTI0MDY5YmE3Li4yYWY4MGQwOTk4YmYgMTAwNjQ0DQo+Pj4+IC0tLSBh
L2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMvdGFy
Z2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+Pj4+IEBAIC0xNCw2ICsxNCw3IEBADQo+Pj4+IMKgwqAg
I2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+DQo+Pj4+IMKgwqAgI2luY2x1ZGUgPGxpbnV4L2xp
c3QuaD4NCj4+Pj4gwqDCoCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+DQo+Pj4+ICsjaW5jbHVk
ZSA8c2NzaS9zY3NpX3Byb3RvLmg+DQo+Pj4+IMKgwqAgwqDCoCAjaW5jbHVkZSA8dGFyZ2V0L3Rh
cmdldF9jb3JlX2Jhc2UuaD4NCj4+Pj4gwqDCoCAjaW5jbHVkZSA8dGFyZ2V0L3RhcmdldF9jb3Jl
X2JhY2tlbmQuaD4NCj4+Pj4gQEAgLTE1MCw2ICsxNTEsOSBAQCB2b2lkIGNvcmVfdG1yX2Fib3J0
X3Rhc2soDQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGRldi0+dHJhbnNw
b3J0LT50bXJfbm90aWZ5KQ0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgZGV2LT50cmFuc3BvcnQtPnRtcl9ub3RpZnkoZGV2LCBUTVJfQUJPUlRfVEFTSywNCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICZhYm9ydGVkX2xpc3QpOw0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBl
bHNlDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGFyZ2V0X2NvbXBsZXRl
X2NtZChzZV9jbWQsDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgU0FNX1NUQVRfVEFTS19BQk9SVEVEKTsNCj4+PiBUaGF0IGlzIHdy
b25nIGFuZCBicmVha3MgYSBjb21tYW5kIGxpZmVjeWNsZSBhbmQgY29tbWFuZCBrcmVmIGNvdW50
aW5nLg0KPj4+IHRhcmdldF9jb21wbGV0ZV9jbWQgaXMgdXNlZCB0byBiZSBjYWxsZWQgYnkgYSBi
YWNrZW5kIGRyaXZlci4NCj4+Pj4gbGlzdF9kZWxfaW5pdCgmc2VfY21kLT5zdGF0ZV9saXN0KTsN
Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0YXJnZXRfcHV0X2NtZF9hbmRfd2Fp
dChzZV9jbWQpOw0KPj4NCg0K
