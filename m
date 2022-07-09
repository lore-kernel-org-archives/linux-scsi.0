Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A532BCCA47B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiGIAOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiGIAOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:14:02 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2B24E639;
        Fri,  8 Jul 2022 17:14:01 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E0BB9C0D67;
        Sat,  9 Jul 2022 00:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657325641; bh=SQ5xNJUXeYN2akTrXNTaCP7PqUuIhKhuykJ8ZMBc9q4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=QO79a8ClaaJo3LuDLqwlrGaOxqGYTSNxLQSxjGkbURBwyHENgbbZ6FNs0KlFK+iSW
         45DPnd+lHazP+qKmdPqM694VAn1qQJAQ2Yn33/L2SalX41AibCq5lvo6KytlSkAukY
         U7YN0/Gc2mlHXYqce6v4QfafHMbEmwnOhOnp1jqzmVTyu9/mbHgkhJUStjFQQcPsQ/
         hCj2J5Kk/u05d9SAXkmHziEAonn1AqSuyje0Uy/5PIJdOJwTYc2vQQwuXelcuyZrdx
         CUsJnTstdBhhGxmDsGV2KFxtDjudZgcr2aEMUUPXIammoCnauQq1fku98zHlCkb05T
         Lqxb9k8bR82RQ==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id A9612A006F;
        Sat,  9 Jul 2022 00:14:00 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 59EAC80078;
        Sat,  9 Jul 2022 00:14:00 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="JGdQBrXx";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evLCM7a05F7GthS8Zi3zlM6nFQG3OHJgWt5Mdt1i0CYv2UUpATIe7UsMRAjvA6+xfPUaDgVutsL5YiN6hSFkzBxdwFqDtYXmqjxO7/tmoX8RFm7/6Ak+BGX6nBBE7icSyjF/fmVBTjSL31KOZZiSdPxF1ZXrt9wfrlmukWRilQjS70dko/o4Td51Dp+YW0qJW2TZ1uPvkCMyvOi+QqFoYFUxcF+CClCHRQH1wEVIIRdP8TVWaXG8bzt3nd69tOtNxN6RsQ1ujI4lXKCxRbVBZKfDWTus+rNDB9JK2ijUlRU5rgv1qArlZNr+gO3+kTtezVLTZQuVWypfgoYBueEhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQ5xNJUXeYN2akTrXNTaCP7PqUuIhKhuykJ8ZMBc9q4=;
 b=itzfogERQZFTmfIbti7K7i//tyUOvpgfeEOfEd0dFAQVW3Egdt8c163vrgBU9/kbhBnv9nMnjQvxTZPCbnlmB4r2/xGyhVEkpb+XXG3eU4sc1gj2Jw8ub6EaWcEZ22qr2oa8HS0wJku7mwD3ZMeOdVbRI40sCJvuXQWRBZxkwqcOqjgchr50HHfYN84Bgo+nfZmJ7t/OCsfRJiXaOQtW2VhnE0hvEDNJpydjv7fQDJVg4KW7ScfcrGHtyWAeCxn/iVxTSu988Iegi75ugLewFCyzSWTe3LdEykFM6OPaQ2f3elxR56usILe+pEWJFy7Y6lKz0a+7vREKKRu+ULfMVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQ5xNJUXeYN2akTrXNTaCP7PqUuIhKhuykJ8ZMBc9q4=;
 b=JGdQBrXxGPAr58xDvFBkksNdGRAsOLVHRJZny5glHVrwoz6/L+MfTv6+Sn7wfqiyu4sWDRtRKrllnpnOhYy1WNM+CORXWZWOrvzAaWSPNX3H1HSp24KRWNbqUuo+liuJ2GJfV7ojXxmHThWuh42BKTnqD2OsOrSx8ID31Lz5lXs=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB3728.namprd12.prod.outlook.com (2603:10b6:208:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 9 Jul
 2022 00:13:57 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:13:57 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 32/36] usb: gadget: f_tcm: Send sense reason
Thread-Topic: [PATCH 32/36] usb: gadget: f_tcm: Send sense reason
Thread-Index: AQHYkZFmqGG9U8fufkyCWPlh4RdMh610F4kAgAEW5IA=
Date:   Sat, 9 Jul 2022 00:13:57 +0000
Message-ID: <c8c15cc1-24f1-30b4-4fdc-b7f9b99d0e76@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <ce84775a1364314625f366d1bf5f71befb1ca335.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220708073546.GL23838@yadro.com>
In-Reply-To: <20220708073546.GL23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ea1f575-5964-4e65-fcc5-08da613fead8
x-ms-traffictypediagnostic: MN2PR12MB3728:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yx7iWoAe4xtIYmCrq2sZzS8clgGeIq6yjowRUo/NWehaj3DQZe1kf938t0Ksq6kh2PSlAnp+uZ4yuYtNMfZ4ga04fu4WqLlrZFgQjRDZOg/ai+wZdlDd456rCwAJYWxG2J/iO1s84E7/agbAYRRNiO2sFKxZldideKBGyeNM5oRhcxG5LIuYYBtg8hCXucMY4RJAGXD22AHyrBaloWI+f3x8M2IsSKSkLGCFQJ4Hyb8pFTYMCiVvUO9LkmMTt4QUIFfqEk8D+Bbx4uffoef5U/D2il8KauG1F3aVg2Ta9q+l5+mILE6fGvmeRpQ3ufz0ASnSuvPNajN3ZBP3PDHcerI79efFXLu0bQWyHtMjc8KmwhBxzEUZ1gXgCKwhlJVALnhDFy7vWKIkkbuHuVAO3TLM3WvkvFtiOJ4/ZgFBklBGbUhnzijp9eV6qNf0TdKTzztOHKoAHxYOyl2Q9pKHNjop0FThuomf+DMRftewRVOAYmD+Cy2s9SCd8gZRCkDT7TT2H+UNv+kJdlh+fZuvbtqC0YS9PDE4a2hRvHcJ+x8l2M/4gSzXUHcckih9pW2cvxIMcvLDisURonBIyqDjrj6po8o1kuway9blqRjpwIaUw4RfKPe0+/T9dpNjErxwZ9ESYSmMHCwlinLt1Focqks89f57bP19nFhv+qZ99ddkXOynOABtWsqsEWOaySSVzGeLabSi/Pd3xH0M6if+GueJ4qqreotuJiyFKx4pJfXyKaQYyaAh8xrdnqbDpFeyskO5Qrta0kRXmPh/LQwVdD79nQtlggIcg/6PskSQEoUkLIBBdOGkp/b0CAXHSn2xyEzN/lLzkXRlZvG0dQGYD1f9OVrHuP0n1IKoGyMesBWraPlrMo5WRXBn2uSegjPL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(136003)(346002)(376002)(66556008)(54906003)(2616005)(83380400001)(316002)(64756008)(122000001)(38070700005)(186003)(31686004)(110136005)(71200400001)(8676002)(66446008)(66476007)(76116006)(38100700002)(66946007)(4326008)(36756003)(86362001)(31696002)(6506007)(478600001)(6486002)(5660300002)(8936002)(2906002)(41300700001)(6512007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1IvRk0xWlhVS0YvQ1dyM093QXVVZUIzcVNlRnRIbVUwRWprTTF2MThBZlli?=
 =?utf-8?B?cnN3OTZIdHhDSTNlUnF5TERkSGxJUkhPTjllUzNETTRKYkNhZ05pS3ZCNmZn?=
 =?utf-8?B?YXp5MzBRL0VLMzVpY3hzL0FER21VTkNLMGdSQk9pTGx5OThrb0lsTW9NUUU1?=
 =?utf-8?B?QUV2dEcwYW40UDI0VjZ1elYrcGNOZENNNWNydHAvVVB3ZTNWc2h5WUlTRlBV?=
 =?utf-8?B?Nys0Wm9peHFmMWxtNHJjSUovbEpOanR1WWVjRkJQYWJWQUR3QXdCVHFFRkk1?=
 =?utf-8?B?TjZKMHVocHZETWNiakJqTTZyV2c4MDhaTEdSK1FjejV1WXRiZnovczNOTDR2?=
 =?utf-8?B?QSt2ZE1jcVIzL091TnhtYTNyWFRRT2xFLy9qU0dxVU4vSFJIdkdkM0dRdmtz?=
 =?utf-8?B?aGVHY3loMm1ndUZIOWZFd2M1Qjh5a2ppYnhOVTNKUFozRjJOT3JmU2pMSGVT?=
 =?utf-8?B?bzhTMUFvSDZDUkt2UDFreGZCdVgxcURUMVJpSFZTY1dCbGp4aUE2TVdJRldM?=
 =?utf-8?B?OWFMZ1I3SVk0eVIvZWdkcmJ0WDB3V1J3M0lEMzFnNjFUaDROSXFrbFN4dEZH?=
 =?utf-8?B?amR2cUc0TXBObFFCQmw3VmQ3NHhKUU9GMnJvaDQ5SGdWbWR6a3Uva0Jkd2VT?=
 =?utf-8?B?TmtudlorRzVJNW1lbU5qemZDNmVSMGdZZVdkbloyTE9hYTR5QzJ2V2NjbWpZ?=
 =?utf-8?B?eGp4OWQrVENYc2VXMEdLS2FjSFRVUE1IYmRQMGw2ME9wYkNKUkw0NVp6UStK?=
 =?utf-8?B?dERpbUhhWnFaaCt4VjJ2RVlJM1o5SHZQcWlUQ1c1ZVRUQmxRS2JaYmxxeVBW?=
 =?utf-8?B?emhTRllBWU0zUDZUdWxIc25PZTA4SlV1dG5SVk1iMXhIYzUrYjIrUEVESGhO?=
 =?utf-8?B?YmF0N0MvaTllSXpQcnR4MFZMMWVMU2QraWZnT1NpSCt5Y2N2c1NWVUdUQnBG?=
 =?utf-8?B?ZE9EN3ZZbDNWT0h3Mjk1QUk3MThYMkZWdkdXWkExVm9iZVFDeis0bTNXdTNs?=
 =?utf-8?B?eW1SV1I3VFJMYjNYMHE5S0VNdjJQeGczUjY5dldiK2tQQTQ0ZkQ0cUJqVU5m?=
 =?utf-8?B?WGszR0IwbFByS3dyU3BxRHUvWEJBRTdJQUR4aUI4K0lpc1RMTHFlbGlDcXlO?=
 =?utf-8?B?QVFNS1hKZ1JHVVZCVmRKR0VuWHM2VVZldjRqVHJIR1dXYlNpMzRJOURuMnBI?=
 =?utf-8?B?VXVJWTQ5Q0J2QkFxRlhvWXpKWk5MRE5nUlJzK0o3SlpDZTVMbEJhbnhYcnF6?=
 =?utf-8?B?YUcrZTlVb0VENkd6VDk4a2xpUGdkclg4SWhxQ1ozS2FESU9ROGs0UjVVUTd1?=
 =?utf-8?B?RExkVzgwL0dYcHFuei9qQ0d4ME9MOFdJU1VLejErYXEyTFVOTnZQVk5aeTFK?=
 =?utf-8?B?b1BpZU9rWnkwM2xCaUovNmNyNDVsSnhXbmJWalRrdGlSeXdYUW9KR3FIYlpr?=
 =?utf-8?B?alBubWtuM3pUQXV0NFM1dEMrYnJsZEZQWitSdWlYamtyUHNhT2MzcmQvNDc5?=
 =?utf-8?B?aGt3dDIzYVN4YVBXZi9QWTZWZ1p3RUFGcTBpUjZqNVEzVjBVV2Q5MTlURkFE?=
 =?utf-8?B?VmhCZHI1SUtxU3FIUmVndk5TMFFDT1FmTUdhMkZBRFR1V2dxM3hmQ241UXNQ?=
 =?utf-8?B?b3JMK2l0UUZrSFYrTVpZWmhldGt4SlFRWTVOc21YQTZwaFN3SzRCaWRXMDRz?=
 =?utf-8?B?RDByVFVYbnZabG00Q3I3b3RLeEd3bDdScU05TlFSVDlsWGtwTjhjdFl2MUVE?=
 =?utf-8?B?Q1o2bUd4eWFEY0RTVVB4WFhOZlM0NG1IaEM5cEVlYTBlQnR3dnNXanh5Q1NV?=
 =?utf-8?B?K3hwaGthazNMNGdTYzhZVEx0anV6c2g0b0lOK1ZxMlNIWGNlVW9yb0pOVTdo?=
 =?utf-8?B?dXVjOFg2VjZGaVluY3ZaRE8yeStuQWNuc21rT0pqTjJlbk9OczdQWndFaDJC?=
 =?utf-8?B?RGlCcW1FVHBPUnJheHIrQUV2WmNaTnQ2aDdVRllLRHRwZE0vRlQ1WHRUSE4z?=
 =?utf-8?B?TFRRNW12OUxYc0x2eGo3M1U0N3krdVhDMFNEQzA2eXE5RHR3dmJKS2Nac1Fa?=
 =?utf-8?B?Q2dZTHZXTVZLWENoeHJqUzJjR0thUHF4bHU5ZjBWdjhhYnNzR1FUclZEbDB3?=
 =?utf-8?Q?8SVw4i8R40Ih3kd60wgmTir6s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49152AFB37ED4A45BF0835D14E12CB3A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea1f575-5964-4e65-fcc5-08da613fead8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:13:57.6800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FDT3A/6f8Laf7t44pxGLthaqmBuRBDz3hCXyIk0L2bpei7lBjuncZcaGA2pO05h8Sh3cgqOGT2TWvIfd4fHyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3728
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy84LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gT24gV2VkLCBKdWwgMDYsIDIw
MjIgYXQgMDQ6Mzc6NDNQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gSWYgdGhlcmUn
cyBhIGZhaWx1cmUsIHJlcG9ydCBpdCBiYWNrIHRvIHRoZSBob3N0IHdpdGggYSBzZW5zZSByZWFz
b24uDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lu
b3BzeXMuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3Rj
bS5jIHwgMTYgKysrKysrKysrKysrKysrLQ0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9n
YWRnZXQvZnVuY3Rpb24vZl90Y20uYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3Rj
bS5jDQo+PiBpbmRleCA3MTYyYmU1ZmRmMmYuLmZiOWI3MTE1OGM0YiAxMDA2NDQNCj4+IC0tLSBh
L2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3RjbS5jDQo+PiArKysgYi9kcml2ZXJzL3Vz
Yi9nYWRnZXQvZnVuY3Rpb24vZl90Y20uYw0KPj4gQEAgLTY2OSw2ICs2NjksOSBAQCBzdGF0aWMg
aW50IHVhc3Bfc2VuZF9yZWFkX3Jlc3BvbnNlKHN0cnVjdCB1c2JnX2NtZCAqY21kKQ0KPj4gICAJ
CQlwcl9lcnIoIiVzKCVkKSA9PiAlZFxuIiwgX19mdW5jX18sIF9fTElORV9fLCByZXQpOw0KPj4g
ICAJfQ0KPj4gICBvdXQ6DQo+PiArCWlmIChyZXQpDQo+PiArCQl0cmFuc3BvcnRfc2VuZF9jaGVj
a19jb25kaXRpb25fYW5kX3NlbnNlKCZjbWQtPnNlX2NtZCwNCj4+ICsJCQkJVENNX0NIRUNLX0NP
TkRJVElPTl9VTklUX0FUVEVOVElPTiwgMCk7DQo+PiAgIAlyZXR1cm4gcmV0Ow0KPj4gICB9DQo+
PiAgIA0KPj4gQEAgLTcxMSw2ICs3MTQsOSBAQCBzdGF0aWMgaW50IHVhc3Bfc2VuZF93cml0ZV9y
ZXF1ZXN0KHN0cnVjdCB1c2JnX2NtZCAqY21kKQ0KPj4gICAJfQ0KPj4gICANCj4+ICAgY2xlYW51
cDoNCj4+ICsJaWYgKHJldCkNCj4+ICsJCXRyYW5zcG9ydF9zZW5kX2NoZWNrX2NvbmRpdGlvbl9h
bmRfc2Vuc2UoJmNtZC0+c2VfY21kLA0KPj4gKwkJCQlUQ01fQ0hFQ0tfQ09ORElUSU9OX1VOSVRf
QVRURU5USU9OLCAwKTsNCj4gMS4gVENNX0NIRUNLX0NPTkRJVElPTl9VTklUX0FUVEVOVElPTiBp
cyB1c2VkIGlmIHNvbWUgVUEgaXMgYWxsb2NhdGVkLg0KPiBZb3UgZG8gbm90IGhhdmUgVUEgYWxs
b2NhdGVkIGhlcmUsIHNvIHRoYXQgcmVhc29uIGlzIG5vdCBhcHJvcHJpYXRlLg0KDQpJIHNlZS4N
Cg0KPiAyLiBJIGFtIG5vdCBzdXJlIHRoYXQgaXQncyBvayB0byBpbml0aWF0ZSBzZW5kaW5nIGZh
aWx1cmUgcmVzcG9uc2UgaWYNCj4geW91IGNhbm5vdCBzZW5kIGEgcmVzcG9uc2UgcmlnaHQgbm93
Lg0KPiBPdGhlciBmYWJyaWMgZHJpdmVycyBqdXN0IHJldHVybnMgLUVBR0FJTiBpbiBjYXNlIG9m
IHNvbWUgbGFjayBvZg0KPiByZXNvdXJjZXMgdG8gc2VuZCBhIHJlc3BvbnNlLiBUaGVuIFRDTSBD
b3JlIHdpbGwgcmV0cnkgdG8gc2VudCB0aGF0DQo+IHJlc3BvbnNlIGFnYWluLg0KDQpJJ2xsIGZv
bGxvdyB3aXRoIHRoZSBzYW1lIHJlc3BvbnNlIHRoZW4uDQoNClRoYW5rcywNClRoaW5oDQoNCj4+
ICAgCXJldHVybiByZXQ7DQo+PiAgIH0NCj4+ICAgDQo+PiBAQCAtOTU1LDcgKzk2MSwxNSBAQCBz
dGF0aWMgdm9pZCB1c2JnX2RhdGFfd3JpdGVfY21wbChzdHJ1Y3QgdXNiX2VwICplcCwgc3RydWN0
IHVzYl9yZXF1ZXN0ICpyZXEpDQo+PiAgIAlyZXR1cm47DQo+PiAgIA0KPj4gICBjbGVhbnVwOg0K
Pj4gLQl0cmFuc3BvcnRfZ2VuZXJpY19mcmVlX2NtZCgmY21kLT5zZV9jbWQsIDApOw0KPj4gKwkv
KiBDb21tYW5kIHdhcyBhYm9ydGVkICovDQo+PiArCWlmIChjbWQtPnN0YXRlID09IFVBU1BfUVVF
VUVfQ09NTUFORCkgew0KPj4gKwkJdHJhbnNwb3J0X2dlbmVyaWNfZnJlZV9jbWQoc2VfY21kLCAw
KTsNCj4+ICsJCXJldHVybjsNCj4+ICsJfQ0KPj4gKw0KPj4gKwljbWQtPnN0YXRlID0gVUFTUF9R
VUVVRV9DT01NQU5EOw0KPj4gKwl0cmFuc3BvcnRfc2VuZF9jaGVja19jb25kaXRpb25fYW5kX3Nl
bnNlKHNlX2NtZCwNCj4+ICsJCQlUQ01fQ0hFQ0tfQ09ORElUSU9OX1VOSVRfQVRURU5USU9OLCAw
KTsNCj4+ICAgfQ0KPj4gICANCj4+ICAgc3RhdGljIGludCB1c2JnX3ByZXBhcmVfd19yZXF1ZXN0
KHN0cnVjdCB1c2JnX2NtZCAqY21kLCBzdHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkNCg0K
