Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795F9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 02:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiGLC5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 22:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiGLC5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 22:57:14 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916D12AE25;
        Mon, 11 Jul 2022 19:57:13 -0700 (PDT)
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A630BC1A48;
        Tue, 12 Jul 2022 02:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657594633; bh=kUdhYwodrxyjyBrpL09ljBa8FTGJMCCIlbuVXEHYQes=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Cgf3+Zxp69UxllhwYFLa8mFm16Lo7IoiZwkIVwKIYjZ2KZAxcpNC0+T/Cqs8/NNcr
         q78YEuHrfvqh8xg3c7sbrq8PQirhgLeh3TZnRQxHwxeg29WXdhZ8gpWrx2IvUjgYEZ
         uKm9+IuPdtmn5f9uHwNi9m70ryeWHXiCAC9MAVL7ZU28QeqzUPkI+xNrR0QBsm3z9u
         d7kypMYIwGQIPZxVNsRUSXDsvqcycyXXX1EACAFBzmU1esvnRkyoG2H4npjw5jVdgN
         hBiQjsMTp6FOET2x4xXx3iwMpck9NWj6eLKq1pCg7Ky64oHc+kEQ60rmOjCSGxnwJd
         DhQ2H7v4oCe+g==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 896F8A008F;
        Tue, 12 Jul 2022 02:57:11 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 171D5400CB;
        Tue, 12 Jul 2022 02:57:10 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="cRMi9FMN";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPSvFHqLbzDXv2mz2aBLDjwlEctjQS+j8AKKVwPENVQvy0pHASxMo6mYJhysZ8tyJXwGzFocnIlDef2/ZQZTf3LZDm8XMGeYihY8nm0GzCmes+d09BIiNT/4Njg9KL0qqw67alZtlkHKB/O8Rnb8iu+XhSXYcZMG+H2627wsFk6DEESwTPhv/ngqMATJ6I0aTr6o6M9EMFzqMdbxmw0mlKekPn0BCXkiSkC8s9Eo/o5xniscSWH8oPkdwvSQtF2cVUMhymQ69ipktJwgFf+q/nECU2HV3XZ2NFxO01f90X32NL7y2uFy2kq+oDCt+L6YryCo4EzCTaH82gOc142Uig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUdhYwodrxyjyBrpL09ljBa8FTGJMCCIlbuVXEHYQes=;
 b=R8BsJ6vHrPtp2usJcK7Ig/3zbd9Cs+CiTKKgbMba3HehVU3wW7VRQjTLKqTbpaoY+uNY5io22RzDXETdqmmPex59cSdshwtdNEAog4Orgou1qmubP1O2fsPBNMKIXuVu+naZsVvoznvqtfLE6sitL1bGKJI3lLTVGEe6kvKEfnjpIBCod1UucbDAqEpDn79cD+GcUM8D6vR0Apb2rDBkOzzGXFq+1r39fSXxLGbj4YlL7sUzQQagR7bNDcRHz1APoa22pyCRfdYjv8aYTFCgG74aWBAm5T8OFdOaIWJbUq7/nYPyKESL1YJ+PtUpjfBKHbWKwE+8rAA+nEXSAkYiJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUdhYwodrxyjyBrpL09ljBa8FTGJMCCIlbuVXEHYQes=;
 b=cRMi9FMNqWMRAI9UaT+2P+ArQgklSkRZa0Nzh5Fpfla27swTzx74qhXXkMogF3M+Ch8gTCcxf0LK2+DA2Py+ruQwXqGXiegF5uq3kRSxBeShjr3BGSIUce6rzdmqdwDKi1GJ+ngW6SZ3z9Sbf5DPz+jQnB7CiN+gojvKrq1a78k=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SJ0PR12MB6904.namprd12.prod.outlook.com (2603:10b6:a03:483::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Tue, 12 Jul
 2022 02:57:07 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 02:57:07 +0000
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
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Topic: [PATCH 04/36] target: Does tmr notify on aborted command
Thread-Index: AQHYkZD+KpUxHtfPikWfNnfwlTmL+K1y3vKAgAI+EYCAA9WdgIABIGKA
Date:   Tue, 12 Jul 2022 02:57:07 +0000
Message-ID: <a40817dc-f966-37ad-8b45-680db7c948ce@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707125657.GB23838@yadro.com>
 <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
 <20220711094457.GA32568@yadro.com>
In-Reply-To: <20220711094457.GA32568@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7c47d04-b57d-4c18-096e-08da63b23520
x-ms-traffictypediagnostic: SJ0PR12MB6904:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NwzcKe4apsSVuf4cGy/FXsf7O01YwlJoi2KwSAXQ71MUHLgJH7RO1f5j7Qz8mwCVqy7/UIsUA5gmOwAZTIfBAGBbdneGjnL+la0uRtItasVq5uxp+0jXA7JpbsmC6l9X5rM4cPvq9v50d14AStPDJ/eM3e3c9jOWp8Sy6dXmpce8F4FZIjlCQ7345xDbKZs/lCioXzXb9mKeIWRE4/MxP8g6cj7hb+yZKWwF01bY4OmUYD28e8tTMf1/ImzuTiPMePK7w0zJx8XQIIgr68aqI51H48WHsKOIyb+HQ2xcA7piK6fpWDakANb6ltbJ4gHOoo/cqx/ilPHa2ESN4PnBZbedQXMwdgw5WmVAZqQuT/qKI57Hg3NEAgmirHca81TGLdJsAF/4eH2F0/Ca9n9S1pWNKEBgK/t3bQUZbmOkp80nKBZYJ16Y5DCT+1let8c26rNhvgpzRn0P/7Bc04IrycSnmjn2F1k/rPI+JFumVvCyEz99mSUxiWlY+Y9FW9/fQ8jhO1Iwsx+b4ciWxsvt8AsqxONJzM/NWjD5qcDWNg0FMf/nmSoK1BH8TesSdlBHEaPYd6AcldPprumNvZHB7VKy1FQOPi7aYaJ3Dxzp17pTH89bHRWrf6fcSsH3YBjIOixyyY0MCH3Qz6vnoNynvaYjITV1KdbC+njrTf4fFvpv/208tKGPwNmHxfPOfS9WtdKIwrujuG9HHGFaCW3d4FifXz6lsK7953emz1pzVbRuaF80G3iI6kzFlZ8TVFqN/mco9b31+uyMDzOQWM9Hwo4OTeGCOJsfUwajud4+5H4MTCRKZv6s+IEFEpma888OiAwg17YQfl+9HmNtSm1YNT2W/qzOeqn/SGHXuKSRetyxayNwiHzygQIDyx3jgbuy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(39860400002)(376002)(136003)(5660300002)(316002)(26005)(86362001)(6512007)(36756003)(76116006)(2906002)(66556008)(66476007)(66946007)(64756008)(66446008)(8676002)(4326008)(2616005)(71200400001)(478600001)(186003)(122000001)(38070700005)(83380400001)(41300700001)(38100700002)(110136005)(8936002)(31686004)(6506007)(6486002)(54906003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0IvSitlMmQzN05wU0R4N1RuSWNNR1JOVE96OThZUTlyeGk4MnFxbHhOWVl6?=
 =?utf-8?B?cm9FWnh0eWcyK0hmMTNTVkxiN3F3NTFDMUdwZ3pRb3ZvcDEyN1lqUkh6aWlw?=
 =?utf-8?B?eXVyczVYSTlNY2R0QU9HaHFCTUh6cm9zM0xiR0pGQW5BaEdiNithZHlIdkdD?=
 =?utf-8?B?K1BPQXprSG1FL2VhM0RDUGd1dnlDeGw5eUZ5aGdmS054SWtveHl5QVMyTnN3?=
 =?utf-8?B?d2RONVhTQU5Zb1pwTC8wOGZDYWRNRHgzMzFhbVdTV1MwMEwwZXJQWmJFYllZ?=
 =?utf-8?B?NGlSc2RyL2xqL3pIdG81V2Zzb2tNMGFpVjNtSDVaQWJrdCtySHFrMnZPeE5G?=
 =?utf-8?B?U1BBSXEydDhjUUpEQ0V3c1IvNVpydHpWL3EwVHNieUVscTdobkxSRmZVN25M?=
 =?utf-8?B?bjUvMmdYOCs4czRKZEZyb3Vycmk0S2U1bWJyTDI0cHZtY1p3RlNVOGp6MCtJ?=
 =?utf-8?B?bjVYMEkvOUh5VWU4ZHFkMnlLbGxGeitjN1VLeThKUm5Ybzl2Y24rQ1pqeWRq?=
 =?utf-8?B?MDVJOU1vWHNidDRhb1p4cGhMQmpEY2dlWEpkZnJGZFdyeWREMWcwM1J4T0th?=
 =?utf-8?B?R2ZnZC8zaVJGdHc4NnJDTnZZOHY5b2JSa0E2TW12WGdIbkR1cVdnQXZJbUVP?=
 =?utf-8?B?VFFWcC9IMnUwVWVEbDdRR2FzUUxuamtrWTlzckEyNmJRcHR5cyt2TGdWMXMy?=
 =?utf-8?B?emNMVk82dUNkbjQ5S0tTZmloWnkvQnVXcVVzeC9YSzhXLzkxa3UzMXMyc3NB?=
 =?utf-8?B?UlRXeUZtbS9jYVZLRk45Z3BVbi9qNzViN0JVenRvQzRtOFVNZHFaaWRSTVJF?=
 =?utf-8?B?aUZDc3FRanp0TFZiRlpvKy9TTkxucjRwUkYyc0o2QjhwSmgrUnZpTTJKSnFu?=
 =?utf-8?B?NzE4Sy9rcklFb3BMYXg2TjVoVXhxSHUyN3BGYW9uTXBnMUpjS29RM0xlUUxw?=
 =?utf-8?B?UHdmYWJsSDN0cEErQkNQQmI0WHYrSGFPaEw5aTYyRklZblYvSTJ0T0RMa1ht?=
 =?utf-8?B?aldscElZSytpSTFOSjlpa3hEWlV0cUpiT3hOOU9lY1lObjA2dEorN2xlQVh1?=
 =?utf-8?B?cmRUM3o1NU9TYmhYalFaQzlmZFRHSURBYU5aYTlOWjIyaWV0emdMZEI3bjVE?=
 =?utf-8?B?Z0JyR1ZLSm5rVS9adnA4T1hiTFNuUjdmbGVTcHljQVc3RjhOcEYzcTdpbHRu?=
 =?utf-8?B?VG9yOUdpQkozd2N1M2VUSUNJbG5ZUmtFWGhRUWdrMmFPZkFsNExRakt5V3cr?=
 =?utf-8?B?aWpGV0ZEUHVoQ0p3LzJDMURCaC9NU04vdU1RaHhzUkMwbTZJdmxROUcxR1BC?=
 =?utf-8?B?R1pHTitBV3NGYmtqbEpzck5EZlprMTh4ZGV4d1UrV1Q3SjlvcGxMN3Z3V1Vi?=
 =?utf-8?B?Z3dZYWFCSjNQZWNyaDBoOXRCVjBzTWtrVnYyQjkxOG9hRUV5QTlXeTI2OEhv?=
 =?utf-8?B?L0RLaEVnM0t2eGxXdkpqb3NDYTJXUGdoa1NoSHRlS2ZSRzdrSmZuUktiRjJE?=
 =?utf-8?B?RzlURVA2QnRlOExDUDR2dHVYYXRVdHVUbGdCa3dudmdzVkNHRnBTM2R2RjE5?=
 =?utf-8?B?TlhvaktheVhDanJoK3FXSk5Hc1VIQ2VyZCsxdkgxdGNzS3FZUjl2UitZdEV6?=
 =?utf-8?B?cGt5c0puUlNDZnVJdUxpc1BLN1c0QVdkOW9PMEpycjRGQ0JCRU5STjZ3WnUz?=
 =?utf-8?B?YlMwYmF1eGVqd1ducm5RMlJzbWYrR3lQOVVxTjkva1BkRVNvOG1FSGxlREVV?=
 =?utf-8?B?dEVDbkZhUnpyanpXQ3FKMGVuUC85Ykk2RXp5Y2dUdmdaaTZyckE5S1NsYzRL?=
 =?utf-8?B?SlpqVmYyeGpuOFRCQ3ZuM0NuVzBIdm9oTFhKWWJyelRvSmozbG1WOWlVWlMw?=
 =?utf-8?B?Wm9YZUlHOUtxbk8xWm5xVzNPS1U1ZkxKKzFNNUxTZkxyS1V0cHN6TlV2L1dS?=
 =?utf-8?B?b1QzOVhwMmZrQ1FnZnVFMEpVYTJzMHhwNmhMWGlHNmIyc3UvUHNHY0drV0tN?=
 =?utf-8?B?aDRQVFViNklLaUlRcHV2MDluYUs3L09vdXMrM3hyTzZ1N202YVc1YnkzRjBP?=
 =?utf-8?B?ajJKdUtJYkhXakNyNHNZVnlsUVp1SG9RemFmWUx6YW9EYjhHRFhQVUkxSDB4?=
 =?utf-8?Q?QgAmSrEvDHX49bSiwQ1WLXN0U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26334B3AA6CFBB49B2BF69D78A8384BD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c47d04-b57d-4c18-096e-08da63b23520
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 02:57:07.2810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sx5ec0ck6hGGErTgEPSqU3z1fBZYsdJSWA86SWcBc4lKOXqWlHT3NUKKiEgP7vhVlaJG1hxrhKWBKqFGGCOCZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6904
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy8xMS8yMDIyLCBEbWl0cnkgQm9nZGFub3Ygd3JvdGU6DQo+IE9uIEZyaSwgSnVsIDA4LCAy
MDIyIGF0IDExOjExOjM3UE0gKzAwMDAsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4+IMKr0JLQvdC4
0LzQsNC90LjQtSEg0JTQsNC90L3QvtC1INC/0LjRgdGM0LzQviDQvtGCINCy0L3QtdGI0L3QtdCz
0L4g0LDQtNGA0LXRgdCw0YLQsCHCuw0KPj4NCj4+IE9uIDcvNy8yMDIyLCBEbWl0cnkgQm9nZGFu
b3Ygd3JvdGU6DQo+Pj4gSGkgVGhpbmgsDQo+Pj4NCj4+PiBPbiBXZWQsIEp1bCAwNiwgMjAyMiBh
dCAwNDozNDo0OVBNIC0wNzAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+Pj4+IElmIHRoZSB0bXJf
bm90aWZ5IGlzIG5vdCBpbXBsZW1lbnRlZCwgc2ltcGx5IGV4ZWN1dGUgYSBnZW5lcmljIGNvbW1h
bmQNCj4+Pj4gY29tcGxldGlvbiB0byBub3RpZnkgdGhlIGNvbW1hbmQgYWJvcnQuDQo+Pj4gV2h5
PyBXaGF0IGFyZSB5b3UgdHJ5aW5nIHRvIGZpeD8NCj4+IElmIHRtcl9ub3RpZnkoKSBpcyBub3Qg
aW1wbGVtZW50ZWQgKHdoaWNoIG1vc3QgZG9uJ3QpLCB0aGVuIHRoZSB1c2VyDQo+PiB3b24ndCBn
ZXQgbm90aWZpZWQgb2YgdGhlIGNvbW1hbmQgY29tcGxldGlvbi4NCj4gdG1yX25vdGlmeSBpcyBm
b3IgdHJhbnNwb3J0IGRyaXZlcnMgKGlibG9jay9wc2NzaS91c2VyKSAtIHRyYW5zcG9ydCBvZg0K
PiBJT3MgdG8gdGhlIHJlYWwgc3RvcmFnZSBkZXZpY2UuIE5vdCBmb3IgdHJhc3BvcnQgb2YgaW5j
b21pbmcgU0NTSQ0KPiBtZXNzYWdlcyAtIHRoYXQgaXMgYSBmcm9udGVuZCBkcml2ZXIgaW4gVENN
IHRlcm1zLg0KPiBTbywgVVNCIGZyb250ZW5kIGRyaXZlciBoYXMgbm90aGluZyB0byBkbyB3aXRo
IHRyYW5zcG9ydC0+dG1yX25vdGlmeSgpLg0KDQpJIHNlZS4gVGhhbmtzIGNsYXJpZnlpbmcgdGhl
IHRlcm1pbm9sb2d5IGhlcmUuDQoNCj4+IEkgd2FzIHRyeWluZyB0byBkaXJlY3RseSBub3RpZnkg
dGhlIHVzZXIgdmlhIHRhcmdldF9jb21wbGV0ZV9jbWQoKS4gSXQNCj4+IG1heSBub3QgYmUgdGhl
IHJpZ2h0IHdheSB0byBoYW5kbGUgdGhpcywgYW55IGFkdmlzZT8NCj4gRnJvbnRlbmQgZHJpdmVy
cyBhcmUgbm90aWZpZWQgb2YgdGhlIGFib3J0ZWQgdGFzayB0d2ljZToNCj4gMS4gVGhlIGluY29t
aW5nIFRNRiBpbiBmcm9udGVuZCBkcml2ZXI7IHVzdWFsbHkgYSBmcm9udGVuZCBkcml2ZXIgZG8g
bm90DQo+ICAgZG8gYW55dGhpbmcgaGVyZSwganVzdCBwYXNzIFRNRiB0byBUQ00gQ29yZS4NCj4g
Mi4gVENNIENvcmUgbWFrcnMgdGhlIGNvbW1hbmQgYXMgInRvIGJlIGFib3J0ZWQiLg0KPiAgICBj
bWQtPnRyYW5zcG9ydF9zdGF0ZSB8PSBDTURfVF9BQk9SVEVEOw0KPiAyLiBUQ00gQ29yZSBjaGVj
a3MgdGhhdCBjb21tYW5kIGlzIHRvIGJlIGFib3J0ZWQgd2hlbiBJTyBpcyBub3Qgc3RhcnRlZA0K
PiB5ZXQgb3IgSU8gaXMgY29tcGxldGVkOg0KPiAgICogdGFyZ2V0X2V4ZWN1dGVfY21kKHN0YXJ0
IG9mIGhhbmRsaW5nIFNDU0kgY21kKSwNCj4gICAqIHRhcmdldF9jb21wZXRlX2NtZCAoYmFja2Vu
ZCBkZXZpY2UgY29tcGxldGVzIElPKSwNCj4gICAqIHRyYW5zcG9ydF9nZW5lcmljX3JlcXVlc3Rf
ZmFpbHVyZSAgKHNvbWUgZ2VuZXJpYyByZXF1ZXN0IHRvIHNlbmQgYQ0KPiAgICAgZmFpbHVyZSBy
ZXNwb25zZSkNCj4gICAgQW5kIGNhbGxzIHRhcmdldF9oYW5kbGVfYWJvcnQoKSB3aGljaCBjYWxs
cw0KPiBjbWQtPnNlX3Rmby0+YWJvcnRlZF90YXNrKGNtZCkgdG8gbm90aWZ5IGZyb250ZW5kIGRy
aXZlciB0aGF0IGl0IHdpbGwNCj4gbm90IGJlIGFza2VkIHRvIHNlbmQgcmVzcG9uc2UgdG8gdGhl
IGNvbW1hbmQgYW5kIGl0IG1heSBkbyBzb21lIGNsZWFudXANCj4gaWYgbmVlZGVkLg0KPg0KPiBU
aGVyZSBhcmUgdHdvIHBvc3NpYmxlIGNvbnRpbnVvdXMgcHJvY2Vzc2VzIGluIGEgY21kIGxpZmVj
eWNsZToNCj4gMS4gRGF0YSBJTiAoc2V2ZXJhbCByZXNwb25zZXMgdG8gaW5pdGlhdG9yKQ0KPiAg
IFRDTSBDb3JlIHJlY2VpdmVzIGEgZGF0YSBmcm9tIHRyYW5zcG9ydCAoYmFja3N0b3JlIGRldmlj
ZSkgYW5kIHBhc3Nlcw0KPiBpdCB0byBmcm9udGVuZCBkcml2ZXIuIEZyb250ZW5kIGRyaXZlciBp
cyByZXNwb25zaWJsZSB0byBzZW5kIGl0IHRvIHRoZQ0KPiBpbml0aWF0b3IuIFByb2JhYmx5LCBp
dCBtYXkgY2hlY2sgdGhhdCBjbWQgaXMgYWJvcnRlZCB0byBicmVhayBzZW5kaW5nLA0KPiBidXQg
bm9ib2R5IGRvIHRoYXQuDQo+IDIuIERhdGEgT1VUIChzZXZlcmFsIHJlcXVlc3RzIGZyb20gaW5p
dGlhdG9ycykNCj4gICBEYXRhIGZyb20gRGF0YU9VVCBpcyBjb2xsZWN0ZWQgYnkgZnJvbnRlbmQg
ZHJpdmVyIHRvIHBhc3MgaXQgdG8gVENNDQo+IENvcmUgaW4gdGFyZ2V0X3N1Ym1pdF9jbWQuIFRD
TSBDb3JlIHdpbGwgYWJvcnQgdGhlIGNtZCBhdCB0aGF0IG1vbWVudC4NCj4NCj4gVGhlcmUgaXMg
bm8gaW50ZXJmYWNlIGluIFRDTSBDb3JlIHRvIG5vdGlmeSBGcm9udGVuZCBkcml2ZXIgdG8gc3Rv
cA0KPiB0aG9zZSBjb250aW51b3VzIHByb2Nlc3Nlcy4gUHJvYmFibHksIGJlY2F1c2Ugb2YgZGlm
ZmVyZW5jZXMgaW4gZnJvbnRlZA0KPiBwcm90b2NvbCBzdGFuZGFyZHMuDQo+IEZvciBleGFtcGxl
LCBpU0NTSSB0dW5lcyB0aGF0IGJlaGF2aW91ciBieSBzb21lIG5lZ290aWF0YWJsZSBzZXNzaW9u
DQo+IHBhcmFtZXRlci4gQ3VycmVudCBrZXJuZWwgaVNDU0kgZHJpdmVyIGRvZXMgbm90IHN1cHBv
cnQgdGhhdCBwYXJhbWV0ZXIuDQoNClRoYW5rIHlvdSBmb3IgdGhlIGRldGFpbCBleHBsYW5hdGlv
bi4gUmVhbGx5IGFwcHJlY2lhdGUgaXQuDQoNCkJSLA0KVGhpbmgNCg0KPj4+PiBTaWduZWQtb2Zm
LWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+Pj4+IC0tLQ0K
Pj4+PiAgICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyB8IDQgKysrKw0KPj4+PiAg
ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyBiL2RyaXZlcnMvdGFyZ2V0L3Rhcmdl
dF9jb3JlX3Rtci5jDQo+Pj4+IGluZGV4IDdhN2UyNDA2OWJhNy4uMmFmODBkMDk5OGJmIDEwMDY0
NA0KPj4+PiAtLS0gYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYw0KPj4+PiArKysg
Yi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYw0KPj4+PiBAQCAtMTQsNiArMTQsNyBA
QA0KPj4+PiAgICAjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4NCj4+Pj4gICAgI2luY2x1ZGUg
PGxpbnV4L2xpc3QuaD4NCj4+Pj4gICAgI2luY2x1ZGUgPGxpbnV4L2V4cG9ydC5oPg0KPj4+PiAr
I2luY2x1ZGUgPHNjc2kvc2NzaV9wcm90by5oPg0KPj4+Pg0KPj4+PiAgICAjaW5jbHVkZSA8dGFy
Z2V0L3RhcmdldF9jb3JlX2Jhc2UuaD4NCj4+Pj4gICAgI2luY2x1ZGUgPHRhcmdldC90YXJnZXRf
Y29yZV9iYWNrZW5kLmg+DQo+Pj4+IEBAIC0xNTAsNiArMTUxLDkgQEAgdm9pZCBjb3JlX3Rtcl9h
Ym9ydF90YXNrKA0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRldi0+dHJhbnNwb3J0
LT50bXJfbm90aWZ5KQ0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXYtPnRy
YW5zcG9ydC0+dG1yX25vdGlmeShkZXYsIFRNUl9BQk9SVF9UQVNLLA0KPj4+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmYWJvcnRlZF9s
aXN0KTsNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgZWxzZQ0KPj4+PiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHRhcmdldF9jb21wbGV0ZV9jbWQoc2VfY21kLA0KPj4+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU0FNX1NUQVRfVEFTS19B
Qk9SVEVEKTsNCj4+PiBUaGF0IGlzIHdyb25nIGFuZCBicmVha3MgYSBjb21tYW5kIGxpZmVjeWNs
ZSBhbmQgY29tbWFuZCBrcmVmIGNvdW50aW5nLg0KPj4+IHRhcmdldF9jb21wbGV0ZV9jbWQgaXMg
dXNlZCB0byBiZSBjYWxsZWQgYnkgYSBiYWNrZW5kIGRyaXZlci4NCj4+Pj4gICAgICAgICAgICAg
ICAgICAgICAgIGxpc3RfZGVsX2luaXQoJnNlX2NtZC0+c3RhdGVfbGlzdCk7DQo+Pj4+ICAgICAg
ICAgICAgICAgICAgICAgICB0YXJnZXRfcHV0X2NtZF9hbmRfd2FpdChzZV9jbWQpOw0KDQo=
