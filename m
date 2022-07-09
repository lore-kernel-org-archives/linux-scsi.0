Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C8CC43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiGIALY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiGIALV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:11:21 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0422868A0;
        Fri,  8 Jul 2022 17:11:18 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5FEF3C0D69;
        Sat,  9 Jul 2022 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657325478; bh=Xzf+YnRxSvHvuw9cn/9QD12tPau84Zo7ko7Jioe+jMk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=G7zToxZFjukfqeNQk9PBZt32RfxHoC/2bPFaVRS9RQ8oey7rNuQFUNE6V5a+lxMCg
         j7QsyMpamP1Puf8sU1LGkraP8R3ORy/drd9qP644No0I++Ab88xZNJgDHaNgi55e6t
         VWVamRojZ/EkPCHLPif/Dh8Ia37rM+zS5g2Ok29HQFj2BsQOAcde4JpePCSoIphXd+
         qId4AFZtrORMDnt/8lz1NgiZQVao5HUDYEVzLvPdZYF2frf23tqkDUIVRfrwpDg49A
         evZdE0Oz1KOAmpx1Ilyg/Twm0LR4NiOzCUTpZ0wtGOcpYRwRlqttUJz4D7smFmHSoZ
         +vX0NUGnY/GCA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 94A4AA0085;
        Sat,  9 Jul 2022 00:11:17 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 0B71440053;
        Sat,  9 Jul 2022 00:11:17 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="wIPhv1Ji";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUgrnZTjSQ9xlCvQ4xwdMPZxyKtGwGlrs9D7ttyNUqARghgxSyWI3WjS4WDoxcKH484UNh5vtBeRvrjD56ouGmWn3+nlyTV6STrd6CQX1Nl6p1F2RvFlgikoDz6fXbg7+x1k60Fdlq5MUJ9+Xj/IymZJNzzUisEwDyfO+bxyldc9sSLuTO44she5j1c1986KiJs3u5aY4yJIYq5RF0fvi4C0L/tQhCiu2wLwT++sr7K+8WDLiSc/XeaaQrKAjF+arN/s8m2SZT+LvPf+2seG2uCllsokWHp1wmqhOe1nDGCCE0LiyrszWy5G1oMg8oH1S5Fjc5lGTC5QEGHXgHdZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xzf+YnRxSvHvuw9cn/9QD12tPau84Zo7ko7Jioe+jMk=;
 b=TdhAOnFx5oIP1dYYRqJUJyQ2XJTD4qZlJhdNHtvhMLEiQ7lBvISuZMYhg3qJjlF5syyLpzWiWoD5ggnLdXGAE8sJxud/LPZDBDb7TRVDWYR+QGEnP1y16SZqlPrrXkU0W+WAVe0ecNmuWM4/gnG9Nr17Zc1S4yDm2o5lAaNYmLJoMwccKDgDLZCH0BThQFfZPHnQi9mtimoQ/8hbne3+o5mnQXhOgs+ZxKaOOpbHlL7dHQGL6zdDgy7y2qDDBoJXpelfRtQf/6viAzCPxYfmht5BCX2yVyNKHcXy7c7vS8DbwlbJXQNoc8zRPXXBafOigyMT1OIqaoNAKPvL4OA5eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xzf+YnRxSvHvuw9cn/9QD12tPau84Zo7ko7Jioe+jMk=;
 b=wIPhv1JiZqxT7BrtJRPIzSlKKPca5C8LYjDgiuTv4Hia6s7KDnbaHxvl9XCT17LSiqjk6w8jwI9UHxwM0156yaMOCU96QYnWuysb6mXzZVIECvFvRb88X1s+ICWdY6ptk6xEuRNzt2dFtjyuR+WpB8sPfxwo8GAkWKQS/gnmUGw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by DM5PR12MB2584.namprd12.prod.outlook.com (2603:10b6:4:b0::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 00:11:12 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:11:12 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Thread-Topic: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Thread-Index: AQHYkZEXJlo9bSR5U0ecwiNAJamf+K1zXN6AgAHQywA=
Date:   Sat, 9 Jul 2022 00:11:12 +0000
Message-ID: <5ef5d719-0e3c-ff09-16da-6790ada2a118@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707202739.GI23838@yadro.com>
In-Reply-To: <20220707202739.GI23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1ee2c8b-13bc-4526-58d3-08da613f8873
x-ms-traffictypediagnostic: DM5PR12MB2584:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XvaszPrGRyHdJCiyPRZevczJxKb/Sbhl0cXDyTt2P+on4Vns9Gm0ckhpwvtAGuF26ZdXuPQhyEniTv6RtNPCYzf+71FcWFt8ye69WhPmz7U5x4gZ0eIZpgmRGIIZM836+s4Qj71aOzz2M3LKB0v79p6CNJPHcjltpapX5gibUmNR+YOIz9JOxxv/GKKvx1x+viXv7k/CVtradjXlidu6ra8hV0k9pS0xCxkZTGhoe7YyRWyWrHm4xn4Ij76xqUPaF9dX+2iLyygh2xdKlBo1/fPo9OLGjQsik4WeKXZR4cItVM7qBfm5t/JRe0M64Usk+fh1U84knSqI/V8fHiGqF0vYjLoQjRqmmTqayXJZBF5Wa0BCi8uwfMddxkGp8nF4BXWoDGOQ77JcVouvBaz3ui2pPaUj14eE0gYM8DM15ZAEJo5I8RjUom1hTK8fVQr4gHkhYs45/dJMicErgJtNdP5WbQiYaKuqagheGMa/JvLS8i3mCtQuoMJQam0HIJEDf4+ucFK+Y+1k6Gcnvh6cqYymR10eTJz7j8zXEsYrv7eX1TAq1alLl0quybAahiO3j3Q1pHQkt7tLq7QukZY4ubUvKlGaXs3tPseMNXVB3cNwSdB19O+U/Ze0gKRrBkpO7ya4vVbao/znJ7g/JoRi+ji1eC4NChFdHZ4n/LpbLshrzpuGjk7wcrK58NSOPi4LFH3ZH5xe/834YOo9OCNsKmJflRHr3tLNyvKgzmKSbxmfL+qNtpivwdJduTSKWB1JpChXGTAxJYCGytzEUjUNUjdBMfDCIJYFT1awA//DLZQNBjcPSEm3YNalyuBEFfeKKbsIWKVSjZwgLmfQ/qVj8QwsDFBxfq0CTR7SVF4eVgngW2rESTGgJZfDZBjGtgMb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39860400002)(366004)(396003)(122000001)(64756008)(76116006)(8936002)(71200400001)(6486002)(83380400001)(66446008)(66946007)(66556008)(4326008)(8676002)(86362001)(66476007)(36756003)(38070700005)(478600001)(41300700001)(110136005)(54906003)(2906002)(6506007)(31696002)(316002)(26005)(6512007)(2616005)(5660300002)(31686004)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnR6SnFQTm1xWTBhWDl2bVhOTHZOeGJWS3EyTVRIMkg2OFVSVVF2bWdkWXVD?=
 =?utf-8?B?azFDeVJQcHdCV0lwVGxKZHNvbVhsUi9kVDQ3czBhLzJPWm9uWDltWjZFc2hI?=
 =?utf-8?B?MmREOXBzMUZUdDhPYU1ObDlIeEFySTNwTFQzbWI0L1N2cEdBMEh5ZmZialFL?=
 =?utf-8?B?TUNoUmtBQ2I5aUJsNXRNN2U3dDBnSm9TcVJxdE8rdTk1Z25HdDZ6SC9wbHVQ?=
 =?utf-8?B?bUEya0gvN0JJdllQSTU5d2FZRnowYU9KVEkzeUFlZCswR1hIbGFDLzNoNDYx?=
 =?utf-8?B?MUFrOUNiYUFBL2pGdGptcWQrc2ptbk5RYWlOWlF0dDJHTG10MUxJZnc0VEYr?=
 =?utf-8?B?Ui9DY0tpb1IxWDBzMG50VXBoUDN3OWZNb2tRUVNtRGJqa2ZOQjViZW42U2NE?=
 =?utf-8?B?MzhtQmNzK2cxcWdoLzYybXNwcGRMOXZBQWNCVmZMS280dWlodS9DUkZmb0lG?=
 =?utf-8?B?dW1WYWRxM282NkYxSVFLdytKSUZQZjB6dm5lSVd0ZTNLTFd2cjV0aDgwOTdZ?=
 =?utf-8?B?V01FQzA0K1k4UnpBdHl3L2tMTFVQUGIreUsvWGlGNGpHL1E2aFJiN1lYTE1o?=
 =?utf-8?B?ai8xZ2tKTk1SMkg2Wloxa3psTGhieURvS3RQRWV3S0pQa29ZSzVUZnRsQzlG?=
 =?utf-8?B?V1AwZUxCN0pjUm94S0krRks3akl1b0k2UmJCY25qYzdoWU5mTDkvZmlLaU9K?=
 =?utf-8?B?Y0pwTHExZ3FLUm1TM1FUVkxNaG9ZVUtQMlFYb3o2YW1hc2c4OVlYUTEzRE1m?=
 =?utf-8?B?ei9PNXVtR05WeUlBWGhDcUN5K0pId0VOeUdPeDlLcnNJZm8rVW1iR0tvQ2pW?=
 =?utf-8?B?YWYyM1NDU0wzWVZuMkozbkFkeGU4Zkx1VnJoeWhNQTljcTlQdzlRY0pYMWV3?=
 =?utf-8?B?VkhSSFA4NUdzQmZmQVNtbEdIM1RQVms2UTA5K05ldDRSSzBwU2hqbHdRcmcr?=
 =?utf-8?B?Ni9nczNEUkpqKzdXRzJrS3JZalBZcVljTjZyYzMxUmFIVDZCOHJjOVRmdVRn?=
 =?utf-8?B?UWt1WGxHS0hpSllxTmRWM0p5aUxLR0xKOEFUVzh6Z01EUFJvVHd5Tk1PZWcr?=
 =?utf-8?B?YjdsZytiQkJrcVdiUEcxYmg4cWtsMWJVUUp0b0VRQkU1NmQxaFRtTnZnMG5X?=
 =?utf-8?B?d3UxLzYrUG0ySGhZai8xSURNN1VPNm9WUllwdnNjZDNWcEIrdVJXNVhKeHk1?=
 =?utf-8?B?b1JZSDVWZXU5a091bGRQUjBVWElZV2dvVnFnVGNXUGRGU2tOTWI4QkVyOXRH?=
 =?utf-8?B?SVF5M0tLcFcwQ3l2Uk1nUWhoREE0V1h1OFpZMjJ2MzU5Z2ppck9yMW4zT1JX?=
 =?utf-8?B?YTFTMUFhdkU3SXpBYS8rck8vSVFPUTN0WEw0SDZjUmxHeHdqb0k3TVBHOHJL?=
 =?utf-8?B?MG83T0dEaThqcDd0bFk4T2p3a01MMGRxVmJ1OEtVL0J2ZmtTTTdWMWR2OUVP?=
 =?utf-8?B?akVoTUgwQitNc0h4TENHZGx5YjkwMHRPcWZMZHlDblkrbGh6aXNEWU9qM0pK?=
 =?utf-8?B?UkIranBYLzV6MlQybVloeXU5d1llK2NHaXFGanlDdEFpbnJaNFN0bHVzTGx2?=
 =?utf-8?B?dlZWbWZqTFhQY1IyVWlEeVF6T3I3alpWdWQvNVc1aVYyRDFYeE1vMVNOWVVy?=
 =?utf-8?B?UlNXdDZvSThPZ1BsSzM4T0RzaWN1QlBoQUpPc2RiMzc2bnRiS29WTXdjMUxE?=
 =?utf-8?B?cVcza1p4RE11ZkExV0U2SEQwS1VYdm5LMmpuTzZPa0xpSEpwcE1mbzFuYjdm?=
 =?utf-8?B?cDd5bkFNbDVvNVdITEdteGVuZVo3cmJFQnRGNGVTZGVTRUZ3L1pNdjM2VHgx?=
 =?utf-8?B?eTlCNUwxaGZub3duK1FBYjNrK01EMzZwd3Z0b2d5amp4K3hFdmxuTzlFZ0d2?=
 =?utf-8?B?dnR4S2FlZ29RL3NHRG5RVEFhUHRaMDhSa3ZtTFFpNjl6RjJOYlNLMGJDTmpC?=
 =?utf-8?B?UnFLOVVGdHlueHFKbk5oeVJMVHlST3lhdVZhQ1I4S2JKMWt2eTBqUnRVZ3lG?=
 =?utf-8?B?UHhQWG9rc0o0WHVwcjEzVEFvaEF2WDlFc2VtNnZoeWU4OE9WSzYvckxEMWRR?=
 =?utf-8?B?UW4wQU5qeHFDcGxEMkltbjJiSU9INWl6RVRKMTFaU3MvSUdVeUVEQnpsNUt1?=
 =?utf-8?Q?+kxph685WrLNAh/Ucu31joaU8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CA09D9006EC224AAFE762DE8985B2EF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ee2c8b-13bc-4526-58d3-08da613f8873
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:11:12.5972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LZ+4CdpXnMEDrbOknRozM3Cbou5lQdc9RLqQeydkFkLoP119aya6DKcKAVU1pRQG4MHdFZ7PpuhGEmamSDnsSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2584
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM1OjMyUE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IENIRUNLIENPTkRJVElPTiByZXR1cm5zIHNlbnNlIGRhdGEsIGFuZCBzZW5zZSBkYXRh
IGlzIG1pbmltdW0gOCBieXRlcw0KPj4gbG9uZyBwbHVzIGFkZGl0aW9uYWwgc2Vuc2UgZGF0YSBs
ZW5ndGggaW4gdGhlIGRhdGEgYnVmZmVyLiBEb24ndCBqdXN0DQo+PiBzZXQgdGhlIGFsbG9jYXRl
ZCBidWZmZXIgbGVuZ3RoIHRvIHRoZSBjbWQtPnNjc2lfc2Vuc2VfbGVuZ3RoIGFuZCBjaGVjaw0K
Pj4gdGhlIHNlbnNlIGRhdGEgZm9yIHRoYXQuDQo+Pg0KPj4gU2VlIFNQQzQtcjM3IHNlY3Rpb24g
NC41LjIuMS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXll
bkBzeW5vcHN5cy5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVf
dHJhbnNwb3J0LmMgfCAxMCArKysrKysrKystDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90YXJn
ZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90
cmFuc3BvcnQuYw0KPj4gaW5kZXggYmMxZTRhN2M0NTM4Li45NzM0OTUyYTYyMjggMTAwNjQ0DQo+
PiAtLS0gYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90cmFuc3BvcnQuYw0KPj4gKysrIGIv
ZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+IEBAIC0zNDU5LDEyICsz
NDU5LDIwIEBAIHN0YXRpYyB2b2lkIHRyYW5zbGF0ZV9zZW5zZV9yZWFzb24oc3RydWN0IHNlX2Nt
ZCAqY21kLCBzZW5zZV9yZWFzb25fdCByZWFzb24pDQo+PiAgIA0KPj4gICAJY21kLT5zZV9jbWRf
ZmxhZ3MgfD0gU0NGX0VNVUxBVEVEX1RBU0tfU0VOU0U7DQo+PiAgIAljbWQtPnNjc2lfc3RhdHVz
ID0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OOw0KPj4gLQljbWQtPnNjc2lfc2Vuc2VfbGVuZ3Ro
ICA9IFRSQU5TUE9SVF9TRU5TRV9CVUZGRVI7DQo+PiArDQo+PiArCS8qDQo+PiArCSAqIENIRUNL
IENPTkRJVElPTiByZXR1cm5zIHNlbnNlIGRhdGEsIGFuZCBzZW5zZSBkYXRhIGlzIG1pbmltdW0g
OA0KPj4gKwkgKiBieXRlcyBsb25nLiBTZWUgU1BDNC1yMzcgc2VjdGlvbiA0LjUuMi4xLg0KPj4g
KwkgKi8NCj4+ICsJY21kLT5zY3NpX3NlbnNlX2xlbmd0aCA9IDg7DQo+PiArDQo+PiAgIAlzY3Np
X2J1aWxkX3NlbnNlX2J1ZmZlcihkZXNjX2Zvcm1hdCwgYnVmZmVyLCBrZXksIGFzYywgYXNjcSk7
DQo+PiAgIAlpZiAoc2QtPmFkZF9zZW5zZV9pbmZvKQ0KPj4gICAJCVdBUk5fT05fT05DRShzY3Np
X3NldF9zZW5zZV9pbmZvcm1hdGlvbihidWZmZXIsDQo+PiAgIAkJCQkJCQljbWQtPnNjc2lfc2Vu
c2VfbGVuZ3RoLA0KPiBzY3NpX3NldF9zZW5zZV9pbmZvcm1hdGlvbigpJ3Mgc2Vjb25kIGFyZ3Vt
ZW50IGlzIGJ1ZmZlciBsZW5ndGg7IHNlbmQNCj4gdGhlcmUgVFJBTlNQT1JUX1NFTlNFX0JVRkZF
UiBhbmQgdGhlIHBhdGNoIHdpbGwgYmUgY29ycmVjdC4NCg0KU3VyZSwgSSdsbCBkbyB0aGF0Lg0K
DQpUaGFua3MsDQpUaGluaA0KDQo+PiAgIAkJCQkJCQljbWQtPnNlbnNlX2luZm8pIDwgMCk7DQo+
PiArCS8qIEFkZGl0aW9uYWwgc2Vuc2UgZGF0YSBsZW5ndGggKi8NCj4+ICsJY21kLT5zY3NpX3Nl
bnNlX2xlbmd0aCArPSBidWZmZXJbN107DQo+PiAgIH0NCj4+ICAgDQo+PiAgIGludA0KDQo=
