Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1937DCCA479
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 10:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiGGKVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 06:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiGGKVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 06:21:51 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F85A9FE2;
        Thu,  7 Jul 2022 03:21:50 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9CC9DC0762;
        Thu,  7 Jul 2022 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657189310; bh=TvS8C7wh5KAHvFmGw1o9kxLdKkHZqKECgOHIyralx+w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TPevt7mfGJP9f/z0ft5g6xDpyj7v4b7A/YTJauhw84Wb8EDVtlF4hjV1ePdw3mTe5
         SelEZaIs216eLnd6yS5RAzS+7BzsM8H9zKdk5obDn8pA8QmGJkCISzj0aaKVnEMP4p
         PWHtsnBMLgyiGi10Ae03Ta59m5XYVhdgjnRgZVn42jvULuLZzSMsjK74173Te+X33C
         LMsGI3N3CdsE/iYJI+FglOSsKaKlCxrUGF6XTrTMlfEyxseRxm6GMobcaLtv6miyX2
         QinWYlKWXSTMM62eS5JNcVq7MSFw5htncq6oD8eFU0i4AaMyWS0gHDBjWVpyIRwTRy
         wu0vmHHaCr+TQ==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id C01B4A006F;
        Thu,  7 Jul 2022 10:21:48 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 66240800B4;
        Thu,  7 Jul 2022 10:21:47 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Q6SDqh5S";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIWI1J8wPWqbAgHY5zmdgddxBrxSTDLSPfnmKjdmh/wLRKz/eKXVdvHm09i3p8wp0UU9wxeufZ53Q68IK2lcKj6RL+fZXxL55JqH1lypdLVKEfZDDTm4ToMqcAaQXof51bJ1/rjMrUDwFkD6Tv+Iwilvte8/ldn6Ce2E4MkPZ7fHxHjsV0jyj+A98owkd6pIZpewu10v722i6k2x4t49+iepryaY7Y256/CYan/Ac41JqRP5n/ruuZPUFRFvcta7HcJHX6PsVoe1RzV0A+rKF/OcSn366QA1NETWbl8C2ziw2nQ0vYr7SELkED4VRHHgs51Hz0ErZ47jKr4+zQoFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvS8C7wh5KAHvFmGw1o9kxLdKkHZqKECgOHIyralx+w=;
 b=fmYwbp5VbYD3qL6lPYK+e3wCFFvcSmKmMnGdV9B3zgBnBGjQbbgzacjQJLMfkm7/nYILLUnPaZklbC10KQ+GiR+LWSH4yfJJB0O6h4Axf7alBCgOZhFVsEoPkeeF88LdPQqG0CQWFKEBby0x3A6OfQoI2ev7qeEOqKIJuZDL8lkbKDxx6dreHfJbIaRSQoVHfb33BL1uPIWJuc9aq+FvP11odcGqp5o/HSGmmh3a0KWQDivcxQjSAbkttE7HGoPdodwdnIj1thpNuGiMpsF5P8KOCGyFXm0yIjVPIFhlFXFRmdfvgJXBOA8TZTTFo1So6TQoefY9DVx02weaCkfJEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvS8C7wh5KAHvFmGw1o9kxLdKkHZqKECgOHIyralx+w=;
 b=Q6SDqh5SlW9HaR+Ikz3CoS4EBGjI+sDMiDAb8rQDX/o2JQT2p9jVEhVyl5PKLIyLK2ZfRq/EwMtA1FWYlK5QRPjbqu+D8v1DmEEWBDHxWY7Vl+jd+1iHDQpomLwz62UCrTkjlMbfI+O7ivTblAOPoHhWOr55ElDAOWGt+sYzpQc=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CH0PR12MB5043.namprd12.prod.outlook.com (2603:10b6:610:e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 10:21:45 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 10:21:44 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Thread-Topic: [PATCH 11/36] target: Properly set Sense Data Length of CHECK
 CONDITION
Thread-Index: AQHYkZEXJlo9bSR5U0ecwiNAJamf+K1ykuSAgAAgsAA=
Date:   Thu, 7 Jul 2022 10:21:44 +0000
Message-ID: <e83acf85-95c3-8dd0-7290-c1900697e779@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <61593a434f543184f41df91a4ba858e1158fd33c.1657149962.git.Thinh.Nguyen@synopsys.com>
 <c0506189-e36d-f7e3-8a5d-71adb2d6dc2a@suse.com>
In-Reply-To: <c0506189-e36d-f7e3-8a5d-71adb2d6dc2a@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab4941c4-47cf-45d4-1262-08da60027e08
x-ms-traffictypediagnostic: CH0PR12MB5043:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26AvmyjYp8Zg+vLcxS1tGQO9FGcOevGCFgHEFr+yfpOOXpOo6g1GoPBIUpjcUIwdfn7jYXnZSKg/dDzMIhWIHCyrJCzwL0ZRwrQ8marvqcJr/9QLVPQY78lmyxoGFH1LthHvVOgxD7OyF0S8e8C+ZfA8y5kPi2Ga7XClmgNF2u7ezD+SzbEzR/iub+j+6gFkcw3Ozu7gU/SCE+Ul9rGekD4TclIuFTbGxR7dKG1jX2XDvCybULQVZlW3MbiSxbqBS6rZFNm+hZX7KL2GqSZsS6eavD6sQZkqYsvSykU4sXIWCCOIkhUyRUKkwzjQjrQcaVJLI/8eAfH44reuuPK5ydDNGwtIOjHVLJuTs3iB4fDbgMUlgJMiMF0ePmXV8Awn7nlRBDK5swbvUdXBPtWc2wog57YwGtoXs7DQ+Mpzcvn5kIX1kHU2iVXb4UsvXSjBeu0pMzQ4jh3KzKoKkUYJaU9bKmuAKYe/wsUwd68WfnEr0y3GJCSIarS/JmNWX8fCb6ZuGnlBqLJUBwPDUxILC6lZqh27KKORi0QnoDHDyV/oc1WYmcWlGu1cR2f5hemMc9kqNny4XZQgJSD2hEL5DQnxyQWeZjFmP0LPS8AEB7tiWcSDO9qnDCJxHWX75s2ispY/s9gAEAB6XZDQueZohJvq2Tcs5Zqny/cZu+4zTlumea1uz85xSEIf488H3oBmDdFTCQQGCtcto57t6jJpztXIKNtiMwbg/8MVHaeQ0O3opBvzCOKa4V5w/YxMhj5gzVxZVrChIBGe+tbYYxjT8wa/n6tFkXeRaGHxtNML39jiYP7YUh0XOCvnQ2yE+JM23hKb8bPo6BmuQyVPWQMYCYAdWRfpP+Lbyq/jumbc4CmGC17PIBao54QlTFYfAKKd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(136003)(346002)(366004)(36756003)(8676002)(64756008)(4326008)(66556008)(31696002)(122000001)(66946007)(71200400001)(66446008)(76116006)(66476007)(6486002)(86362001)(478600001)(8936002)(316002)(5660300002)(83380400001)(31686004)(38100700002)(41300700001)(186003)(2906002)(38070700005)(2616005)(53546011)(6512007)(6506007)(26005)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REJKK21VV0lPZU9FbWJHb2tOa29NM0hEMEhjblZ1aWNOZTh4ajZ2akhxK2RV?=
 =?utf-8?B?MWdWWURxS0dsN3g2UVlGakRzei81OE92dCs3bm1SbTVYZkRkaWhrSUkvczlQ?=
 =?utf-8?B?MkdPc0JZeWJ0UW5PQ3FVMlREZGdJSmFYQWMxMFFEOUlJcFk2VW9mVmVQdXp3?=
 =?utf-8?B?a2pLcmduVjdTQnNWc2VJMmMzSENQbWRtYW0vUXo3bXhWckU2TGlCN2x2ZFd1?=
 =?utf-8?B?aEt5QzM2MUdaZzJVQnFwb0tLMFdPK29VZmNkaHJTTFhxcndhVzI1NTFHNXZB?=
 =?utf-8?B?Ym10cUIwa2h2bXozV1ZPQmNJTWM4V2pHM0hkK0V5eWNIOWlIZTVyYXFBNEl2?=
 =?utf-8?B?U2h1WkZGa21nNkVQQVNQbWZmZEZoMlFha3BGKzFtRjZtMUVmMlRSSHVUZUIw?=
 =?utf-8?B?Ykk0Qm9icEtMVEVoa0lEY3MwZUtLZkZIaUxRekVqN0tIZ0NqbE5mVzJ4QnVt?=
 =?utf-8?B?RXBYL3gwU1VlVHVpY0ptblVsTWtqMXJFWlRJRnp2TnZIcDdwbzVxbDJ6ZFNJ?=
 =?utf-8?B?Z21wZVRYZm5kV1JEdUdVd1I2R3ZLL3gyU2NOWENjemdkMUZkZXpOSTI3cWJp?=
 =?utf-8?B?MjU2cE13eXU4WkcwT01wd0c4UmY0RFg3aEdXMGJsRCswdVhHUXZBNU44WXRr?=
 =?utf-8?B?Y2hzQUFqYnJnSGFtMUo3RHRLUEZqM1FJWnROS3VsYlVZK1RhWXpjd01TMXJ5?=
 =?utf-8?B?YXRoa0s0S0tSZVplM1Y1c2Q5eDVNNjkzdnBMZnMxNnJ5R1VoTkMyaEUyS0lt?=
 =?utf-8?B?RVhhV0J3akM4ak1GR3BJUkZ5SGVFYVowT1k2TTkxclRFVk5aOGtqNXJvQTc1?=
 =?utf-8?B?dEFPN2drUHBJdldqZDJYL1RSeVFkTHh6aDRuR1E3aWkxVGFVRGdxQ1AwZkNN?=
 =?utf-8?B?UzdQd0pOTjZyNlZjQzdmb3NCTUJTMHZhSXY5bUJOUHBpN0xQWVBEeHlUNWJ2?=
 =?utf-8?B?WjdZY2Nhb1diOS9iTEVUS1pUb3NxOGtsTlMzcHNLcjZSRE9xOFBZKy80Y3ZM?=
 =?utf-8?B?UUkxSUlBNWpjL24rcXFhYjdDbzQ2cENFQ2N0S2dnREQ1WUV1MFhBMGpHQzhr?=
 =?utf-8?B?QTZEZ1E2Uk1OZWdaUEM1TVNDd1R4bTllTjExZ24vcGdaYWRaUUhQK3AzSDk3?=
 =?utf-8?B?TlYvZVFKVENxZHhyaDlkdjV4UHRqZmRleW5pdkhmenZCV0Z1OEpJL3U3VTkr?=
 =?utf-8?B?QUVyeURPelpkNHZ1S2JGbmlxSVhHNndsTHh0a1J2S0lsRk1Wc1JyM0lOQTVD?=
 =?utf-8?B?a28ybW41cTRNbmIwSnU3d001RnRUWG5lTHpRYWJYeGdjamxXQmx2eHlxZmx1?=
 =?utf-8?B?OFR0MGJhd1g5aWxiNEtlbjd6dENLcUdxQ1B4MTVoL3c3NmlYTTJiQk00TzA0?=
 =?utf-8?B?MTFRd2psRThmSlBBNnk2MU51Y0dCV1hEUFhCODluYUdrUUU3UkhudHJuUWlj?=
 =?utf-8?B?eEFXRnByV0daWDhPWDN3aHllVVBqTWYxS1k2QU94bjRyeGhldzlZQ0k4ZkJO?=
 =?utf-8?B?SXgyM005aWh2REc2VTZibVhXMlNFQ25GT2d4Uy9DOS8zRHZjRER6ckhPVCtY?=
 =?utf-8?B?VGpPeHZKM0d0WWxydVlnODR1dEYyMm9MRDZtNjIrbzF2VDNpWFpGSHVLdzRP?=
 =?utf-8?B?V2pjQzdkOUxUYVFWazVnZTRidFo2Q0N2V2IrKzR6K2l4Y3VFcjVIa3Njb2NQ?=
 =?utf-8?B?MWR6SWF5N0FRYUMrNnZra2ZLWjlhUmY2T2FwaUdQZi83N0o0Y0RsbzlvaW1j?=
 =?utf-8?B?U0M3dUhNUTFtWWtIOUJmY0VWRXVLWXRncUkxOU1tQ3A0bGFvOVJ1bnJrWDE1?=
 =?utf-8?B?eTNOZG00dS90NEVBOXorU2R4eXkzQkVEVEhWTjBPaEpta0xtNzErd3BQNzJB?=
 =?utf-8?B?cUdLcDk5RkswZXpHczZZc1Y0OXFrZEs0YlhuZ05NTy81UEZxNUhIRGRURXNI?=
 =?utf-8?B?SlBMUjdoMFYwYWJMTEZXdUFLeXl6cXVNV3g4eExYMWNMTnJpOHNZRm9xOGwy?=
 =?utf-8?B?WTh1MzhvbUlhc1hlaU84a2VmUHhvaVVlZTZ6dy8zU1ZlRGxQZXZzNi9nTFdX?=
 =?utf-8?B?OVZBYWVJejJ2RDZ4djlXa2hTVUdxeldIRzFYcUNORnZIL0xzNnRuSVlDT2RM?=
 =?utf-8?Q?vwtNpZX0CE3HV/cLUaE2on6qk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C62E0EAF3FA30B4C9F492421A79F9F78@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4941c4-47cf-45d4-1262-08da60027e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 10:21:44.6693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xEsFUf8xuln3v0VvSmih0t7RiiVTkTnpnyVNr/ZKI2AtHCaN8Dv94hwjfiGrSXZ/6udZsdmIUdGhWTB1JbFg3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5043
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIE9saXZlciBOZXVrdW0gd3JvdGU6DQo+DQo+IE9uIDA3LjA3LjIyIDAxOjM1
LCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiBDSEVDSyBDT05ESVRJT04gcmV0dXJucyBzZW5zZSBk
YXRhLCBhbmQgc2Vuc2UgZGF0YSBpcyBtaW5pbXVtIDggYnl0ZXMNCj4+IGxvbmcgcGx1cyBhZGRp
dGlvbmFsIHNlbnNlIGRhdGEgbGVuZ3RoIGluIHRoZSBkYXRhIGJ1ZmZlci4gRG9uJ3QganVzdA0K
Pj4gc2V0IHRoZSBhbGxvY2F0ZWQgYnVmZmVyIGxlbmd0aCB0byB0aGUgY21kLT5zY3NpX3NlbnNl
X2xlbmd0aCBhbmQgY2hlY2sNCj4+IHRoZSBzZW5zZSBkYXRhIGZvciB0aGF0Lg0KPj4NCj4+IFNl
ZSBTUEM0LXIzNyBzZWN0aW9uIDQuNS4yLjEuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmgg
Tmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMv
dGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIHwgMTAgKysrKysrKysrLQ0KPj4gICAxIGZp
bGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIGIvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+IGluZGV4IGJjMWU0YTdjNDUzOC4uOTcz
NDk1MmE2MjI4IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJh
bnNwb3J0LmMNCj4+ICsrKyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5j
DQo+PiBAQCAtMzQ1OSwxMiArMzQ1OSwyMCBAQCBzdGF0aWMgdm9pZCB0cmFuc2xhdGVfc2Vuc2Vf
cmVhc29uKHN0cnVjdCBzZV9jbWQgKmNtZCwgc2Vuc2VfcmVhc29uX3QgcmVhc29uKQ0KPj4gICAN
Cj4+ICAgCWNtZC0+c2VfY21kX2ZsYWdzIHw9IFNDRl9FTVVMQVRFRF9UQVNLX1NFTlNFOw0KPj4g
ICAJY21kLT5zY3NpX3N0YXR1cyA9IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTjsNCj4+IC0JY21k
LT5zY3NpX3NlbnNlX2xlbmd0aCAgPSBUUkFOU1BPUlRfU0VOU0VfQlVGRkVSOw0KPj4gKw0KPj4g
KwkvKg0KPj4gKwkgKiBDSEVDSyBDT05ESVRJT04gcmV0dXJucyBzZW5zZSBkYXRhLCBhbmQgc2Vu
c2UgZGF0YSBpcyBtaW5pbXVtIDgNCj4+ICsJICogYnl0ZXMgbG9uZy4gU2VlIFNQQzQtcjM3IHNl
Y3Rpb24gNC41LjIuMS4NCj4+ICsJICovDQo+PiArCWNtZC0+c2NzaV9zZW5zZV9sZW5ndGggPSA4
Ow0KPj4gKw0KPj4gICAJc2NzaV9idWlsZF9zZW5zZV9idWZmZXIoZGVzY19mb3JtYXQsIGJ1ZmZl
ciwga2V5LCBhc2MsIGFzY3EpOw0KPj4gICAJaWYgKHNkLT5hZGRfc2Vuc2VfaW5mbykNCj4+ICAg
CQlXQVJOX09OX09OQ0Uoc2NzaV9zZXRfc2Vuc2VfaW5mb3JtYXRpb24oYnVmZmVyLA0KPj4gICAJ
CQkJCQkJY21kLT5zY3NpX3NlbnNlX2xlbmd0aCwNCj4+ICAgCQkJCQkJCWNtZC0+c2Vuc2VfaW5m
bykgPCAwKTsNCj4+ICsJLyogQWRkaXRpb25hbCBzZW5zZSBkYXRhIGxlbmd0aCAqLw0KPj4gKwlj
bWQtPnNjc2lfc2Vuc2VfbGVuZ3RoICs9IGJ1ZmZlcls3XTsNCj4gRG9lc24ndCB0aGlzIG5lZWQg
dG8gY2hlY2sgZm9yIG92ZXJmbG93cz8NCg0KSSBtaXNzZWQgdGhhdC4gV2lsbCBmaXguDQoNClRo
YW5rcywNClRoaW5oDQo=
