Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC922CCA481
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiGHXkg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGHXke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:40:34 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B839B7FE60;
        Fri,  8 Jul 2022 16:40:33 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 371EEC0D64;
        Fri,  8 Jul 2022 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657323633; bh=PemiM/PJUTPKLpmHDfB91dotASb2+FjYRAyfL9doqCQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OzJBSioFmDccWObK04ge5Q5PAfTig6iFK7x3ogpulolh6KoLhdu1JspYuHT8QUFA9
         SpEYVBxTVkm+4zSv//ZxOfwDev16LB6tV2kBvDmVDPPLuoDo3+bSR9FbCak6EvyB4N
         otXQ8mFVW85/kcu7dqhAhGE3hMH36qRbnpr+k0zqpjxDorow9hrArr2OVMQnJ8BwqM
         fyHPbN0FXd3cedpPgcuEp3hS1MECeC/tp6TJOeNdauBn84lulbDo8mAe5VI5LYtbRM
         0wWuEvUPuBybuoVELxLj2wLrm/ILS4Zma0DWTO4kn/XRT5BndAtmBnEVaPvi0ssiRT
         Ngll0synphipQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7E33FA006F;
        Fri,  8 Jul 2022 23:40:32 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 2A1CE400DA;
        Fri,  8 Jul 2022 23:40:31 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kTeAPpLZ";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/gZQBC//w5FqsvinL3VTMbZQeKEfVkuLc7e/h6Xr5M4Vhvj/PNmnzhLy0MsZ0EmxW+2fNA7yv6A2iXQUAgs/np9hStSvK0SQcayFurr2/V8VKIKxcHxFlWdbBL2L1WTGR3rTOyoYEszLXv4BA8dQI2NiRLH8iB76/HwGHKF/+7tyzbVo+39+9of6ejcBjjrIGObZya8mlS7GozipzYpApWk+hxLwBInHPuhPUi/Sawg/NCFGftAbc4ud+w8OjJRf8rMfPUBQlc6Zye2/OgOdnzknn+nxnAPjg1//cA/I8oYkb4ELoVN9pv7tQdxYYo8VUjHsFdGqJ2z16go/7su+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PemiM/PJUTPKLpmHDfB91dotASb2+FjYRAyfL9doqCQ=;
 b=Vq2VBDRo1BwMbsR/HWrCzY+63dOKckWNVhR310HcmVHKx+gNmglCj+b3xJLwszsTvHto98H/IV3m2c8DnXel+8bhdDLESOtmFh9ZLADq4Qi8DXiUfSq+InyBNONOAb2dO/tZznTQoX9PAxxVL6At+fFKt5YPvuNyGnl6jgczNrOjVIEWKe0gmJn6d2suPjTogXeOhl3NCMeCgHjHv4rR0kttpPi2sjw7BsEsw3FBiWDxWPhfK93bWDvYJpT8KoTqsSfi2AREe4oX01iC8UgtJyXjSBlZM8qy8z+BQy2LMXw0jYvo/VM98VG4d8CFuxXacY46HiuJtXpS9io+qjWE/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PemiM/PJUTPKLpmHDfB91dotASb2+FjYRAyfL9doqCQ=;
 b=kTeAPpLZp7cplMHBitttQAmnQTP3/85Maa+K16BMII3jhS+v4mM+YajEFbT1cer3M5Px7YgpXqrq7/OrUZoGBRXLlh6K6BjCon2lMMiV5B4BPRwyw7DjXYsWzUAYSlrcbcLTc9Ves6Lz0hI68IjuHg5KoCMESThttL3j2ZYIm8E=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN8PR12MB3092.namprd12.prod.outlook.com (2603:10b6:408:48::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Fri, 8 Jul
 2022 23:40:27 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 23:40:27 +0000
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
Subject: Re: [PATCH 05/36] target: Don't remove command too early
Thread-Topic: [PATCH 05/36] target: Don't remove command too early
Thread-Index: AQHYkZECXLWge6bcSkied/JMxkb4s61y5EiAgAJAyYA=
Date:   Fri, 8 Jul 2022 23:40:27 +0000
Message-ID: <9b6ebcbe-0f15-e1f8-ef8d-56be6e63f95e@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <bb728dcbc73942cda3ae64d0d26195c9a284996d.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707131603.GC23838@yadro.com>
In-Reply-To: <20220707131603.GC23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 741c9b6a-8b83-4323-7f46-08da613b3cd3
x-ms-traffictypediagnostic: BN8PR12MB3092:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x9s9SRUbrPWFOUtLmtUue4u7cU6S4go/pTnpMxI71aHiET/d2L7A7yMp/2M+62pFoZ0fLrDl3czf4sCdG5bm5q1PHCBHlcZ8uuoN9nLUXbugApivAwHUexdyjTNF0n+fZkS4N3lQ7HVdsLzj5cE1qR2PGtfD9o8SoP1wN5BK475GiZooeq3p/5Mz8GoB64sZT9FqfW2xV3KZUUtPlaNCZeCSVGz+IAkmeDB22gsFHARQkWqxgOr1PzCR43OyOqDs5XFyBPU69JpH3xKXAvDVLsvVVItIvjUpWvKu4qGyNW7eWuYg9poeLaHwmxV9/unY810WMHS3se27QX3YMGafkOf8qpqZY5Ka/nSencwtsnXWTSfX9xX95Vpwzr9FgdYazGXprbVmzL+qwICKriQn4JAoI0DF4lOOmlZhuMgpAAdB4ieVXWiQoDbzp4aYGJV/3KauHrua09K0wEJDaj9k1f9ASkyakUL53rf9eO+5igzLyBMO76kUOblf7HJLJ5W2SflfnlRka3Zg8r8PPYOHIKChpHAfKUdHG8dj9K5IMSw/x1fo7+uysdAaGnBv0iMqbhFpcKaYegQSLQuFY61/VVoMjj8usuIdscelBHhc1D8W6i+VNJjKqq+XaidH3k4t8s6k21GVVYmymZDFDzIwkQnTEVTFk58Znma8H4ulM2O/jsrt8mVz9H3nEgLSNvw0qwtIfpzNrOV0mNim0rueoxrRQRf/W7y6sppEOAhIUraST7ZUrO37S9H0vU2213oieLeR8bKRXNUhs9Ae+FdA0azd02A1DuSEW2N9hy3p2HgDEYP376P0K4q+7L0tvhEPA7+Y18pd7CUiw0DDzvPZuJ7srQT/b/d5RDbZmGaXF7IIwJXPaKL5a1aw1MaP2X3Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(136003)(39860400002)(396003)(376002)(5660300002)(8936002)(478600001)(122000001)(41300700001)(38070700005)(54906003)(110136005)(86362001)(316002)(26005)(31696002)(66476007)(71200400001)(4326008)(8676002)(64756008)(66446008)(66946007)(6486002)(76116006)(66556008)(83380400001)(2616005)(186003)(6512007)(38100700002)(6506007)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDIxZkdXSzlCTllJK3I3UVllWjcrc2NmSnU5S1lkbDduZjQ2YkNoUmh5aVp6?=
 =?utf-8?B?bEFyWHpHaHJCbHNETDdzV0lBVHRaWTNxeDByYmNsRjFyTEkrdm53TnAvNG9i?=
 =?utf-8?B?M1JFdDc4N1NGeDJBVU9GVU83RVRndENCSmxrMEdtRmkrUkZyTWp4Sk9XMWRv?=
 =?utf-8?B?S2lSajJwWVJtdVplVlp4TnY0ZlUvUENpNVNOays3RGVlZTlORW5tcGw0VWJp?=
 =?utf-8?B?djFpM3dNaGVlZEFxMjc2cnlaeWVYWHlWaFNTdTRxRHNJenZDV0ZpZWk2VXpY?=
 =?utf-8?B?Yk1sYldTZlVtcVkzYXkrdTBFeDdFQmlWU2djak1ucDEycFJjMU13YzlFMHRi?=
 =?utf-8?B?cTE1NHpKSldJUHVLVmx6VFp2Q0c1Z09KVUtVaHFlWDM3VGJFaHR4QUE5NWJZ?=
 =?utf-8?B?cDZ5Q0k1SWtpUzlDWW15MDJwWDFVRG9yOERjbVBQQk9LdkthYnlVTkFmaStJ?=
 =?utf-8?B?ZDl5cVNwaldyVy9TbUptVlVNdkZLTDB0Zlh5aThmVmhoU1FIeE1qNlBpRDda?=
 =?utf-8?B?SFNCZU5rbkNObERpSnRNdVlQdHNlQjc4ckdNV1QzZlh5M3lSc01UQ2xQL3JZ?=
 =?utf-8?B?dHB6WnZ0MGsrRDV4RGJJZFFEN2pZdTROMldBL2prQ3BNTnpGbktjcndSY1lv?=
 =?utf-8?B?TmFNNy83cE1Hbzl0cHdZY2VGaHYxU3dsS1RGRGxtN1p5dXZoaDVhSUsyMmVK?=
 =?utf-8?B?eldwQjZlN2Q1QU1jaWZ4Ym1xaEdiUVlsUFprdzh3VGZtWGJGa1ExQURERnBV?=
 =?utf-8?B?Qmc0YytPSE1CMzlXaHlteUZMSjF6UGVaNW1PYmNwYml1NElrVFYyckxvblN3?=
 =?utf-8?B?SWtYeU9kUzlvdzdjdmZFRGluampMTkFTaDlrVEhrL0N4ZGNhT0RCY2JESlM3?=
 =?utf-8?B?cStjOGFSeXBUZDIrNGQxam1BQjBvZ3Zpay96aVhXenRRVGxLazVQQjVRb3hw?=
 =?utf-8?B?ZHB0QUEvaVdrZzBybTJLTlFkQzBWN1VITjhpM09aa2VPYWYzVXdBcnYxTGtr?=
 =?utf-8?B?eEp4dGtpVE5wRzlVbTdnamkxdk5TUmo2WExXeUtQVExKTS9pT29IVlhmK21O?=
 =?utf-8?B?UWE1Qlg3ZE5KaHRuMTd0QVE5UTg2Vm9vM1h1dnVmcEV5bVFIN0NIQW5XTGtI?=
 =?utf-8?B?TFFLM2RDWlJjZlp2dHBwL0pINmpseWZXc1BtZlBGZDhJdTMvYXlKcEVSWmt0?=
 =?utf-8?B?ZzR0d2RvM0Jxamt2VEdKRVFVQzZBR05xZHBBalZLeUdneVU3U2t6cEdLUGNG?=
 =?utf-8?B?L3ZCTkpnNy9ndWRhUDA4MS90Z1NtVG53OEducml0eFowOVJqRmZjQlBad3h6?=
 =?utf-8?B?dytnakF3Z1AzdXVHVU1tdmhkejFEMlk1MG5ESjNRTDMyeXFGVlA0OXhsZkp6?=
 =?utf-8?B?RnlqaVlRdGE0WFBxU2MwL0oxL1JwemtDdllhNFNEcDRadkpGV2U5Sk1OK2tU?=
 =?utf-8?B?SDdyNGFodFZ2QlBhVWhCd1l6aGxLb1R6N28yT0tmMGhqN1dFV0wrRW9xNCty?=
 =?utf-8?B?NEE0QlczR0F1b1dySXd0NDRhejBIanQ1bmhIRG1NRkRBVHFXZ0M0MnF6Qml1?=
 =?utf-8?B?YWZiZ09PeldlSnBlOUxKNHprVUY3OWR4ZGdxSmZEV281SW45TzZUZmtKRjhV?=
 =?utf-8?B?ckRPbC9ZZWhDSHVhaVE4ZkNjNUxCeEVReHk1SVpwOW1oa01NTHROM0U4aWZ1?=
 =?utf-8?B?ZjJuWWpjdm1DYTZtTnJYSjBNV1pDL0RuMUNVWHQrdHFqSGU0WWdwNit3V2pt?=
 =?utf-8?B?OVhTR2NDcU1ET0dvYzNWKzVoVENzSU5lZWgrdnloL0IwZCtQMGVjMi9jcnJT?=
 =?utf-8?B?bUFoTlljUXVaMXdiNFdBdysyTWZyN0NQTU1sWUxFTnFZLzdqczd1K213YnZJ?=
 =?utf-8?B?SmlYd09Yenh6WHQxS1NNOTg0cnc2dW9zSC8vYlR5ay9uTUZlYnFGZ29lREpo?=
 =?utf-8?B?amQ0Uml5NDZ5azVncHZnbXlGYlF1RTlEVTdTZElEV2pWZU85RmFwNHhxTzJ2?=
 =?utf-8?B?MTRqK254TUQ5MlI3NDVpVXRJbzR6dVNlQ3B5WW1Lb1pDYll4dlRnRkZHczhm?=
 =?utf-8?B?SFhGUGt0RnRrRnI4ekc5UkZZL3hMNGYrMy94UVVQV01TK29IOVE5dldjUmZx?=
 =?utf-8?Q?LxINhSxC6gB6I09khTA+ZIpr7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F0CEDAE588A16418C585C73FEED2AE8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741c9b6a-8b83-4323-7f46-08da613b3cd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 23:40:27.7648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0hTtqHbdcxykiWqHqvfbWYZroYzETKtNgvMCz4SWbesaiXKACvLW6i4goSpWhpcpgtQBZ4LRpzUYWtn60SjugA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM0OjU1UE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IEEgY29tbWFuZCBjb21wbGV0aW9uIGlzIGFzeW5jaHJvbm91cywgcmVnYXJkbGVzcyBp
ZiBhbiBhYm9ydCBjb21tYW5kIGlzDQo+PiBleGVjdXRlZC4gRG9uJ3QganVzdCBmcmVlIHRoZSBj
b21tYW5kIGJlZm9yZSBpdHMgY29tcGxldGlvbi4gU2ltaWxhcmx5LA0KPj4gYSBUTVIgY29tbWFu
ZCBpcyBub3QgY29tcGxldGVkIHVudGlsIGl0cyByZXNwb25zZSBpcyBjb21wbGV0ZWQuIFRoZQ0K
Pj4gZnJlZWluZyBvZiB0aGUgY29tbWFuZCBjYW4gYmUgZG9uZSBieSB0aGUgdGFyZ2V0IHVzZXIg
dGhyb3VnaA0KPj4gdGFyZ2V0X2dlbmVyaWNfZnJlZV9jbWQoKS4NCj4+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+PiAtLS0NCj4+
ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMgfCA3IC0tLS0tLS0NCj4+
ICAgMSBmaWxlIGNoYW5nZWQsIDcgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIGIvZHJpdmVycy90YXJnZXQvdGFy
Z2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+IGluZGV4IDc4MzhkYzIwZjcxMy4uMTA1ZDNiMGU0NzBm
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMN
Cj4+ICsrKyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jDQo+PiBAQCAt
ODM2LDEwICs4MzYsNiBAQCBzdGF0aWMgdm9pZCB0YXJnZXRfaGFuZGxlX2Fib3J0KHN0cnVjdCBz
ZV9jbWQgKmNtZCkNCj4+ICAgCX0NCj4+ICAgDQo+PiAgIAlXQVJOX09OX09OQ0Uoa3JlZl9yZWFk
KCZjbWQtPmNtZF9rcmVmKSA9PSAwKTsNCj4+IC0NCj4+IC0JdHJhbnNwb3J0X2x1bl9yZW1vdmVf
Y21kKGNtZCk7DQo+PiAtDQo+PiAtCXRyYW5zcG9ydF9jbWRfY2hlY2tfc3RvcF90b19mYWJyaWMo
Y21kKTsNCj4+ICAgfQ0KPj4gICANCj4+ICAgc3RhdGljIHZvaWQgdGFyZ2V0X2Fib3J0X3dvcmso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPj4gQEAgLTM1NTMsOSArMzU0OSw2IEBAIHN0YXRp
YyB2b2lkIHRhcmdldF90bXJfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+PiAgIAkJ
Z290byBhYm9ydGVkOw0KPj4gICANCj4+ICAgCWNtZC0+c2VfdGZvLT5xdWV1ZV90bV9yc3AoY21k
KTsNCj4+IC0NCj4+IC0JdHJhbnNwb3J0X2x1bl9yZW1vdmVfY21kKGNtZCk7DQo+PiAtCXRyYW5z
cG9ydF9jbWRfY2hlY2tfc3RvcF90b19mYWJyaWMoY21kKTsNCj4+ICAgCXJldHVybjsNCj4+ICAg
DQo+PiAgIGFib3J0ZWQ6DQo+IFRob3NlIGZ1bmN0aW9ucyBhcmUgbm90IGFib3V0IHRvIGZyZWUg
dGhlIGNvbW1hbmQuDQo+IHRyYW5zcG9ydF9sdW5fcmVtb3ZlX2NtZCBpcyBmb3IgcmVtb3ZlIGNv
bW1hbmQgZnJvbSB0aGUgc3RhdGUvdG1yIGxpc3QuDQo+IHRyYW5zcG9ydF9jbWRfY2hlY2tfc3Rv
cF90b19mYWJyaWMgaXMgZm9yIG5vdGlmeSBhIGZhYnJpYyBkcml2ZXIgdG8NCj4gZGVjcmVhc2Ug
dGhlIGNvbW1hbmQga3JlZiB0aGF0IGl0IG93bnMuIEFuZCBldmVudHVhbGx5IHRvIHdha2UNCj4g
dGFyZ2V0X3B1dF9jbWRfYW5kX3dhaXQoKSBpbiBjb3JlX3Rtcl9hYm9ydF90YXNrKCkuDQo+DQo+
IFRob3NlIGZ1bmN0aW9ucyBkbyBhbHdheXMgYXJlIGNhbGxlZCBhZnRlciBhIGZpbmFsIHJlc3Bv
bnNlIGhhcyBiZWVuIHNlbnQNCj4gKFNUQVRVUywgQ0hFQ0tfQ09ORElUSU9OLGV0YykuDQo+IFRo
b3NlIGZ1bmN0aW9ucyBkbyBub3QgYnJlYWsgdGhlIGFib3J0IGZ1bmN0aW9uYWxpdHkuIEJ1dCB0
aGlzIHBhdGNoDQo+IGRvZXMuDQo+DQo+DQoNCkxvb2tzIGxpa2UgSSBtaXN1bmRlcnN0b29kIHRo
b3NlIGZ1bmN0aW9ucycgcm9sZS4NCg0KVGhhbmtzLA0KVGhpbmgNCg==
