Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005ADC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 00:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiKPA7W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiKPA7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 19:59:19 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4692315D;
        Tue, 15 Nov 2022 16:59:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My3Wg3VHJP03iDwDVDPFQB6CF6LLPWSWeE16SGQnOjmhOCSZWUgKdG7iFxGEdp+sJj8FrITrSO/AsPBoQ9FT3gxqvr02ZW53LwuvkHdWhbg/C4+/gkAemncnoRyhlkh6pyKuoXT6bZsaSbdfjYZxvuzXkvkm6at73JEhdNm+iGKNKwxGvg7/CaHaiwnkA/Wpog4IaW6px/Q8TDX7IO8xBtiz8X5jYAZirNEvVFrrdUjIEUbO6xbsjBOIR0I62eO3MAce7zsn/GOzniZPrUpLi2lGnE/QyYE/IJy838PQLz5rZQk6oI05soI6ttzt2ttW/TP25imccLLrueE0Qaxmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzefyH/qhE0ZKztUwgLF+CpclfLbZyulcvVjBQ4cskM=;
 b=QmKysddMg3iN5qfv8qgmGdx3mh0yCaUUzLDU4XRHNjvYK4VgxUIS4FvBi2OD8vxHb/z0pC40fMeqRwoalaGxBvZGa1/xDV1XPsW5zn0UF56CjGA0VMTIckNWInnzpXQ59NCL9FfIrE3VCkkxLPICOj0tqjnDZ4ku82uj81vhFandDDxpU+JZvhBT2EBQZ9hswBxnK13Zh+GVQE3Y1EtLmAL8xaNfHHQAZpyd6ithP9Rh+W911PM6yDPXDQ5s+ocqX7VQGISGL8LgIeuKzXoMJgf18WAUgZHdGPi3WcVRE/Q9vecNQWW0rYRfM4HujssXbeWNuy4/Fn12pNy5siEwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzefyH/qhE0ZKztUwgLF+CpclfLbZyulcvVjBQ4cskM=;
 b=Z5wEbAxx9XvugYtxyb0xRYoj32azh1aAitOiNSuutpg2Ozc8exZVxSu/E+aYpyAPH4ONhfT9zhGCO3puSkoTUDRkrDngllH21QliFqbwtORZE9UxEErbkfvHWYWvw2tFq7DPXam5lc/8hLvOAV9ne5gE/h/V/4iKcRJWTSAtQK2RGeMYQni4GWlZ8M1Quan0uj/eMx3ex9wXmrpuOT73oXv8a9zXEfYVM/I4mtUL0A5+fmeUj1mm8b09Mjo9UsHdTCbOhrmQN8CdwvfGX6wN/fghToHLlZ3Zg8GJ+gPRTLNsPwsb61v1yv3zc+kUVkTQmU073LErtsrdoqHqKXjnWw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 00:59:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 00:59:15 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] block: Add error codes for common PR failures
Thread-Topic: [PATCH v2 1/4] block: Add error codes for common PR failures
Thread-Index: AQHY+TlC6Rb5BGXa1EevVJGmrD1iDa5AutcA
Date:   Wed, 16 Nov 2022 00:59:14 +0000
Message-ID: <b1735792-5626-3ea3-c347-5893d31e8a4b@nvidia.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
 <20221115212825.7945-2-michael.christie@oracle.com>
In-Reply-To: <20221115212825.7945-2-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB8131:EE_
x-ms-office365-filtering-correlation-id: 968d1863-bdbc-4094-2608-08dac76dc833
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6LYTQEE93rJbzSgCTNRt0Su0u+VlPh+3YhFsVsRPDBBNw2JWYFeKYObGZ1RY0JCXtjzGERXQ488QSMsJVosMbPlJ+q0ers6fXlhz+dxtOrNLSMUZxDDeR7iYc1cRivSg/3p/vqfqfDL9mqy2GhZmq4RJn3gU8KY+BkYi2yPz38Z6iHKofOolUTtRIneh09a9hUBWi7yQ9ew0qa3V+ioKKLzCf8m60ECj1jTd3kIzJ4OMdwqK2/TSP5jI4bjjtqR5u7M1LVhnHK5QOf3P7MS570YvQ0lLWie+ax1/9t7ojSAp0L/3SD7qpKjjEUQucSDpktEtorKT+mcME0xZIL1sK+ju0WEAaR+LbIgL5+Uhf4aCEGTMLAEz5IXLqaQJIGElPK7HEvzrcRfLmCHHyhXxVCILrb0jO6ew2uWHBgIFvQk/jaLC1IvqsQ604XDHVkpPg959rujLklTyjXxDRTHwhGO2sEzRCticZ8UwFW4rn1qEUrPeBaTDr+icYPs3a5U5B/jHvX5EIY8KBGptBf1HeNiyhkHMNi5nPFx//GCgmM5xnR8/rdRXpvT8DlqnDYnbIXlFF5ybSYvyz3sJx9hZu4POsYHPdCOiEosS8pKj5WyIYa0M/u1uvsIFFNo6KrmZM0VmTnbqLscdJqmgRtsnVaNvdklb8EAzbOwdq7yoHKcZMRg3cMC1e28f4Cp3fQb6mhbYaZfH4/aqFWRrqHsArasAOIjce5HB0OH2PIsX3PYYqj/A5VEgM25XYXILS9//Y7tRTFxhWSaeha8R/6I0JsHuZZB8Oz2I/nOi4lRq+MkMhe4aLh/D4HcpOA2SWo6gHfsOXfNvMKilNLTW/y9Z2tql5llxUETiKQy7X+1IB3o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(31696002)(6512007)(6506007)(53546011)(38070700005)(71200400001)(2906002)(122000001)(86362001)(91956017)(5660300002)(41300700001)(38100700002)(6486002)(76116006)(478600001)(8676002)(186003)(110136005)(66476007)(921005)(64756008)(66946007)(4744005)(66446008)(66556008)(2616005)(8936002)(83380400001)(7416002)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a050eDRxNklCc091MDZKK1U4MFZrdm1leWx6dkZPVUtVdjNORUxqL2lnQ3Vs?=
 =?utf-8?B?WC9yYUx4L1dLdzZacEF6YlBQQWxJNDQ1QVVsTWhJUVN1eUV4OVNtL1NVckJS?=
 =?utf-8?B?UlgvS3kvRElTby9vMEllV3pwaGk0dFc1TVRoMTB2ZlJMdU9Dd2NCM0xrcmZK?=
 =?utf-8?B?RTJiY2FDY3FGMjNYQ0tucmNWblhsTUFncDY0MmVBSTFscEhocW9mVXhrQlNQ?=
 =?utf-8?B?R0JDcHdLK0NwOTBSVy8wdGt4SjhOczJMYUQ3d0ZCS0ZWMlNiMEJvcmNSWnpL?=
 =?utf-8?B?TlVxMVY5R3JDY1ZuNmR3MUx1cjdXTGhkS3ZhbllNQUUyU1hTTWdYMHFBLzRz?=
 =?utf-8?B?N3Y4NkFwTEw2bmZxM0VVL2tTNmhhb2M3WlJTRnJjbDVHMzhwb3p5QmtEMUlm?=
 =?utf-8?B?b3gvOGpXZW9kN1JxTFVkN2tTR0FaVExZVXdHOTFySVcyQUlDR1RWdmFrV2lo?=
 =?utf-8?B?R00zRmpOWVFBSEo2dzl5Zm5ZM0FsbzhDRFh5YkF4Wm5HMjE4TXNKVjBWSjli?=
 =?utf-8?B?eVoydTlWcldBdHZDTCtxcHdXMTR2VTFGcTRjUHd3ZThOL1JIU0tmLzJnNUsw?=
 =?utf-8?B?QnBVNE1tRXZmL1dtQTc4NVYzTTluL2FiQUJxUGVOS1Y0RnlwbllUNzFZQ0Er?=
 =?utf-8?B?V1VWUHQ3TUJZOUFVK0ZYR29nbDR6L3FLNnFDTHQvOG9xeWFUaGp5MDFQQnN2?=
 =?utf-8?B?Wit2cC9NYlV5OFB6TE5HaXNaMm52Tit4NWZRa0xLdzZnR0pkR1A3VlZQck5S?=
 =?utf-8?B?QkllT3RxcVhkbm11VU1jMXI2Mlh3dEZFcmxXOVBoQWFOd1AxQXYrejBXOTdF?=
 =?utf-8?B?Qm9ROUdBK3ZkOVhrRjdlNXFtTU8rb3NhaHJRTGRiY1RJc2V5R0crU1NIZERu?=
 =?utf-8?B?aVJtVTZ4MzR4MVR5K3dWaGZNMnA5cTlqc01oMzBOYmNRTmNzeDJiVFVvZVVJ?=
 =?utf-8?B?cnpCSlJNTWpVWjBkQTlyZk1yOEg3MUtzT3U1YTNJMnRXNWlPQWJQdVZyWnRX?=
 =?utf-8?B?ZHVVR21uWEhKN29sQ05ZVllkeU0vcGdERUVPdTlDQnVjdUdTM08vdWdhMnEw?=
 =?utf-8?B?K3JNT2pJQW5hd2VzWkNxNmVva1labzl3eFkwZmdJT3daOTl0N1Q2TjNRMGR4?=
 =?utf-8?B?UTBPeVZrVmp5Ti8yclRRQWVWbkNSOXkwRnBBMkovTEtaSTlvZnRRc2dtY2hi?=
 =?utf-8?B?OE45YThRN3JudExzbUFpTTVGREt4NDFudTFiTUszaWVCWUwydTdyaERVK1hT?=
 =?utf-8?B?UjNEb0VkMUJDN0hLTDF2cjBLQVZGblJZQjRBcGdqaEh4N2J4SWJtL0hEbjlT?=
 =?utf-8?B?TExGd1d4ZDNzQTd2RVhGekpGRVVKbE1HNUg0QzNMTEdaTDR1WjJVV3RsSHJv?=
 =?utf-8?B?Nlo5WExUdzBIaFdqakcvb0U4UFJJSW9JWGpVMExvSEp1N0hzTWZCaXpPMUh6?=
 =?utf-8?B?bm9iMlltSU94QnM1V3piYzI2Yi8wdjFEKzVlN2RucjAzWmV4TElQbllxczgy?=
 =?utf-8?B?d1h4bmp5M1pnemFpa0FIUGIvamlMYVZPYWo2U0xteHN6WVV6T01OSnQ3eE9h?=
 =?utf-8?B?VTRMMUV6TUQ0d3FwOE9LalRyN2tLNVExSWZCM0FNMWo1NnpaNFp3YUhMU291?=
 =?utf-8?B?bFFibEdtdFcwRTNrOHhGWWJUaFRVNy94RGZncVVITTJIbXc2NUc5MW9OTzJk?=
 =?utf-8?B?bjRMWjMwNlBtUUhDbUlHU2t1aVJ2ems3VCtndW82V2Q2YXMvU0REMVZ6Y2hh?=
 =?utf-8?B?bDVORHBqZ0RzQXV5a3RKaWt4c204b2g4VVgvN1Y1L1ZvUGtlTGFCK3pxVHdL?=
 =?utf-8?B?ZThpb2E5M2dMdDU3MXYybTBUZEUvY0R5VGY3UWh5N1QySloxU2hxeGdzQ2lk?=
 =?utf-8?B?U1dmV0JOSE90Y0ltY1pDSFkvNWZxb1d3T2p5MXRrQnh0OC8zQVRLUVI4Umdr?=
 =?utf-8?B?OTVkNWY5WFNlWG05Zll6Qkh4WUluaUZpY2xQSldUOTFNWmRlVTkzSlcwdVdk?=
 =?utf-8?B?R2p2VGJkbEV0anZBQUQ4aXdZQnVzSmtseFBUNUNsbFY1L2h1QXFBZ1BMeit0?=
 =?utf-8?B?Ulc1bWVUcFJvK0JDSDlpOHA1M0tHR0RBTGo4MHRuUlA4VlR2a2NrWXg2OVFl?=
 =?utf-8?B?OWxiYTNUN1d1OFN3WmkvS21JWkRDMTQ0b0dTcytpSHdSaHRTUU1sVjVINnRV?=
 =?utf-8?Q?pDE1+dpRbSS3LUXsGehSLTSUQ+uz437TwjMpaMWpDb3q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE5E0CC72C128849ABAE781DE68E7526@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968d1863-bdbc-4094-2608-08dac76dc833
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 00:59:15.0035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENGBKX/yNkqqtolApGbrb9397cYQVdNTY43SOmbZmhWJKXAtHXl1gWtkpMDEkygWpU7dXJ7wLLBpLQy6b63m5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTUvMjIgMTM6MjgsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IElmIGEgUFIgb3BlcmF0
aW9uIGZhaWxzIHdlIGNhbiByZXR1cm4gYSBkZXZpY2Ugc3BlY2lmaWMgZXJyb3Igd2hpY2ggaXMN
Cj4gaW1wb3NzaWJsZSB0byBoYW5kbGUgaW4gc29tZSBjYXNlcyBiZWNhdXNlIHdlIGNvdWxkIGhh
dmUgYSBtaXggb2YgZGV2aWNlcw0KPiB3aGVuIERNIGlzIHVzZWQsIG9yIGZ1dHVyZSB1c2VycyBs
aWtlIGxpbyBvbmx5IGtub3cgaXQncyBpbnRlcmFjdGluZyB3aXRoDQoNCmxvbmcgbGluZXMgYWJv
dmUgPyBqdXN0IGNoZWNrDQoNCj4gYSBibG9jayBkZXZpY2Ugc28gaXQgZG9lc24ndCBrbm93IHRo
ZSB0eXBlLg0KPiANCj4gVGhpcyBwYXRjaCBhZGRzIGEgbmV3IHByX3N0YXR1cyBlbnVtIHNvIGRy
aXZlcnMgY2FuIGNvbnZlcnQgZXJyb3JzIHRvIGENCj4gY29tbW9uIHR5cGUgd2hpY2ggY2FuIGJl
IGhhbmRsZWQgYnkgdGhlIGNhbGxlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0
aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=
