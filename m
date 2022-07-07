Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EF3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 10:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiGGKL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 06:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiGGKL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 06:11:58 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8BC4F665;
        Thu,  7 Jul 2022 03:11:55 -0700 (PDT)
Received: from mailhost.synopsys.com (us03-mailhost1.synopsys.com [10.4.17.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 21BD040CF3;
        Thu,  7 Jul 2022 10:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657188715; bh=xClpG9K6v7G8gbmcM1yXVpfLfsyBQ4OwxLv4UCCFoqs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cC3w2nIuMZDgtvVO5Ytf6606zYfruW//GLORhfXdLBNhfvMXdwJR+ULGcwlGBGSe3
         TNPj+/0n94M7oefXI5kTlTFRwwmrVu6P+JcmFvkzAbHqyDNOLjvK+/r/OmSCoOKBTe
         W2Z7kU3oVaXPIyfpxcfxSSvzZ1f9fsDE8OIHPzh+qfqdrvdvY7yxGD3kF1kwbczv5G
         5vmj2bRW92wCjXeMzC6tu9wsdGsnf9Iw2VnR05VLV0gJmQaKQ2+xAzU1uE6Fq6rZ+k
         JN++JFkyrddn3LiJNs6wT5vd7xRwu+MHHcGTva/hWuDSdkk9QUTnGksdt1lEf9HoaU
         M1QVLdHkEwnxQ==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 19EA4A0080;
        Thu,  7 Jul 2022 10:11:53 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 648CC800C0;
        Thu,  7 Jul 2022 10:11:52 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="PRmV6sGr";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDySUL3h238qL/JPceDgkilJcQ1m+/3uvHnxKYjOkm62Qmah6H12UKc63N9ULDXtV2p6jW/h9iwCqaK7/k4/wsT3BOJoYi3kER76NNR0p4zXXeIXEbGrU1a79jwSCP1WWuzesw0AJjwZI1pVEBDJm51mzy4JpFrOUIS5CmKkMIEq86IfHQAnOlYWSLmn+V3YHtxOMfyjxZZqs3pLl+h2w6jEJtdqImPtt9LThKD+pvePruPzC++p3ZfZZlAsc58AohX2d+IUfTsReLZztKHkg6IrfVApjChepHRCW7uFyWAu3/OkHVUcBF/dF9jhYER2zPKgnhhIHi2GkfUxNY02Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xClpG9K6v7G8gbmcM1yXVpfLfsyBQ4OwxLv4UCCFoqs=;
 b=DUp3qOV/VW0sIGQ5U3OZCUC85YODmIK1d05k85zxBTqG8iJM/IQNt3/bU7Z0fwTqyI0IFwvhIuhGPpmxc3yZJGzADP2KWzGtIat2vafBYbeY/i1AYuOUlfR151fQgHuTZRm/oinNH2r13qy+gxF/StprdxAFSqD/fcoHj2fIw/G3jJVcwckhRGU6SBgWrG1wiqmzVVOFdVkTS5A/A+qfCIKrd9R+jw0pjC0kKl7l5kjYSBhYeWKmXFSbh11Y9Y/c77pAA5KitNqGVobWrkla5unhg7H5QHoOPNvF8pz3pggrxvt5UKlKa9nzAw+uGKL9XW4qToHgszAAO2jHcm6SGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xClpG9K6v7G8gbmcM1yXVpfLfsyBQ4OwxLv4UCCFoqs=;
 b=PRmV6sGr43oWHFRIYuOGZeXclB2TkEnaQ7M/QjNyAbHT+f4t5hrgDAhm+QsNrvN9HJk0esi+fzg+i7wSkF0x+U6jLMn3jZubgBJryBMmEIzmRgEj/iTXW+Tm5y2v618YEEKgZkHK6MH1zq4McZrddcR+HlHzOSA3wqNmeMH7MDg=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB3416.namprd12.prod.outlook.com (2603:10b6:a03:ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 10:11:49 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 10:11:49 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
Thread-Topic: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
Thread-Index: AQHYkZFu3ckWi0bZUUyNRghRX+szfK1yoN8AgAAP74A=
Date:   Thu, 7 Jul 2022 10:11:49 +0000
Message-ID: <e9e153a4-66c4-ca08-98b6-3849646b9bdb@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <6a5487365f0804447d4cbb8911d0719d8b21b601.1657149962.git.Thinh.Nguyen@synopsys.com>
 <17d93b498de04ee5b550ff0fe8b91847@yadro.com>
In-Reply-To: <17d93b498de04ee5b550ff0fe8b91847@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b122206-bf80-42c4-e5dc-08da60011b61
x-ms-traffictypediagnostic: BYAPR12MB3416:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRfcxCMjg2nfOKi1l96nwX3MdJIYTA3dX+SIsWnkvgjfmHSMlIcfqoLEN9XD/nDnD/EwFcFQWVJd3hZx/RmkogPegOfmdL7VDt1SJ1biTVswjTNo+4xzjQFqCRYfcZUvSjxm52J6jJBTd3OYkkAMR4Z7grj7MZXNdTJpU+MnWWvG/1pWHjus6TmyrNwI/375u0/EsR3fSp/woLposj7D3MESOB0Cay8m5Ph55VvDKhrJ3TZGMvER+o+T57eCnSyNKJWT3WKX6elFtCqPvD1kEhi85eXQXT54nA5JY8WjjBmFeszndxP8THcrjQYNOk4oyaGdvENpc0S/BrOqw3jw6FxWj3kNWkoWUH5u3wTSGO/GbdIuqIcARQqbVx1upIYDQIDs+xLji0AL8/ds4bSxk0B+qzLXlHj4CXa2AZCRjyqaAeGpa3viIg+A7BfFqxrEP/musbzE0f5btXR9e2sOiJN2czuLmd5YTIIrtU3OhMvXi8cIjqA2QqejPvNP7UdDjUE8Zp7KdB0JSVv+TGMm4oZat5OEwKlPtjlVikTfEOWevk8dPAAUjIHN0hydfBx4+j0LyCeUcvuhs4jKygilcoCWDTFQE+Dx9G8HrqhcAIJmjWvM5V9SeAJ0RLUqVhoDU+Fz88F8cuQzk7aS3nsT2yZjtMqEC6lVpcledzjtVqm/2SLtTUwee5+8OPn+eaI9XMwj07O880rYjGpnmp6rxZaJdp4lBzSKmWcDGxtEfoYn0XLqHcgCvTZhz85G8pALdMC9Q9k4X0+Ko9ntXY3BEnu+1WsuUWaPGHlVJrod362tGm1si/zPir+LN1+a57gJdDU2OXeZRwyBaYGIkHpP3gns1rF446IHuYfVLr/DiXChdWXUVJ+doTSdAiYy9xno
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(346002)(366004)(136003)(54906003)(110136005)(66946007)(71200400001)(6486002)(76116006)(36756003)(86362001)(478600001)(31696002)(122000001)(6512007)(6506007)(31686004)(41300700001)(26005)(38100700002)(66476007)(4326008)(8676002)(316002)(66446008)(64756008)(66556008)(186003)(2616005)(2906002)(5660300002)(8936002)(38070700005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3h1UThVd2p6eGlvdmVBcmpTS1hpQ1JuWHFNZk1xSG1oVkxmUG5WZHRDOXZS?=
 =?utf-8?B?NkdHd1ZRQlA4T3lEdzJISlZUZHJldGx3NzRQRisxZWh4K3hEY21ZaVVkVERZ?=
 =?utf-8?B?QURnaDVSQzREcHFjWmFnRHhhNFAyNFhVeStnWjlRY0ZZZ014OTVoZG5MSVRo?=
 =?utf-8?B?UVlWYzRTVGI4U1BmYnJsUlBOc01rK0VnSjV3VFlTV2xxV0xnMHlrNTFLUzdl?=
 =?utf-8?B?dDBBR2ZWUHczTHhwMkVKMEhqbTd2REh2eDNwWElJbElhOFB4d3U1T2RBVWlT?=
 =?utf-8?B?K0oyVy9uSkV3T3FMa0hrK2pWVzhRNG9PQzJWTFdRalBmckd6RHMxZkpXbWU3?=
 =?utf-8?B?UHpCU25pWkMxblcxcTJRRkhjeFp5L2tCQys4c3JQd0xZc2VRUkFmdFBHOTYy?=
 =?utf-8?B?WjBLbzVZazJydkxsWVg2SGMyRmFoZ3k0SlRwTElLS2VFR0NlT2JOYlhXZGlI?=
 =?utf-8?B?dmZ4UFVNbkwyZHZ4enluSzVMSW9qSXFLUEJEeXVLWU0xdjJ5TGJ1ZHozbEIz?=
 =?utf-8?B?cEZ3aW9RLy9GaHRCdnR2dEEvRUU1K1ZiY0tTOUNwQ1FTejVhNFFnN1IzVHJ5?=
 =?utf-8?B?WmxjWWMveElySDUzdytYNU41OVUrZlAwMEVaSkVsa09lV0taaG9kdHJ3Nmd6?=
 =?utf-8?B?amRpSFlKS0UwVGxsRzZnbUhzdmVXUzZIc2VSK014eFlySTNNMjRKNThhR04x?=
 =?utf-8?B?UWQyb3hLN2NsUVJNcmxTeHVWWlNZMU00SUltbGVtV3B4Q1ozcDZKWjBmdExV?=
 =?utf-8?B?YWxvVXJuMGxYOVJhR1ZWNUZ1U1Y4bzZlbVBRbmR6NnRwcUN3U0RYWm1zZXdt?=
 =?utf-8?B?STRFbEtWTmJ3QWlXMUxIeVhNZFJNaVhFMWxhQmowZlROVVR5VlBRVWJyT1E0?=
 =?utf-8?B?M0JJU09BWHpIelNOeFJUSkdtUjU1QUFxTGh5SFRNV1ovRWdKQnVFckI2Y3lU?=
 =?utf-8?B?cUNHSnI2RUZTd3hpczRDT0JCZnNWTFcvWlc2NEZCUEQxRHQ3NGtlSzY2VXQ0?=
 =?utf-8?B?cXBidGZ1OHVZNnIzYmo2bFNEQU9HUEQ1eFIxaFUzUGVabHkyazlCbTVwYzZL?=
 =?utf-8?B?QVZTcGdvN0htWnVXeVVpanUxem9OcDh4SW9BaDV0TEpPeGhIeHNnOVhVVGFx?=
 =?utf-8?B?dk5sakZNWE5FWk1HbnZRVDVjUXJTelFBQlU1VjZWRkdvKy9Mb1VKSTE3K05B?=
 =?utf-8?B?OFhvNThOOEtiZmtqR1hhTVQ1TFY2d09BRzJWUEJycTRnL2RXU0dNbmlscnlJ?=
 =?utf-8?B?UDMzc2twSW9QNWZVekNodmcxWXZ4a3VDdEQrUUZoMnc1ZTFwTDF6YmRvYVJS?=
 =?utf-8?B?T0J3OU1rQ2oyS2pKanllR2RMdmgvclJrdUljeVRxcU9qV3FsZmtZazA4VDZw?=
 =?utf-8?B?ZUVrQzV4cFFNZ21SbmdLMTI3KzB1dEFDZlVpZkpWcmdrbGpqdTNHQnBpcURS?=
 =?utf-8?B?VXV4eDZteWtNZ1JwOXNBUkRjOHVzTG81WkIveXFjVmlMbFl4eFQzaUpuVXIw?=
 =?utf-8?B?RmpjdjRlK2xRckRGZCtBbjRsN0hBL3lHUVc0MTA1TURvc2gvWEY2UjVhMDdn?=
 =?utf-8?B?cU9vUFNIditiazF3bjk1Tm9wMEYvaFljNGdWbzFub2hTaVBQS3VISGpvaEd3?=
 =?utf-8?B?L3A3NUdzTlQ1RHl1WFYyZ1VsSGZWaURTSmV6bVR4TUlzbGFXTU92NkFjMHR2?=
 =?utf-8?B?R1QwMXgyTjl1V05OaWxzMEJhdmJRWTJNenp6d3MyaGhiUW9mTVp5TXJQYjI1?=
 =?utf-8?B?ZDJ1V0l0NWNIeEVReGxRdUg1Q0tGV3V2K2g4dmhjOHJsaTloWTJLd250QlZ5?=
 =?utf-8?B?UkRNNkk3c0hjVkdoSmJVVVhhKzIrVzNTdzVPejlMbEo4Z3NOWUhDOHptZ2VH?=
 =?utf-8?B?VEpINGFVaVpjRGVqelhPODJ2aW14SVBKeHJzWWNBb2VKMWsvN3BwL3o2K3Br?=
 =?utf-8?B?TkY5NGptRFE3azh3Q1ZZa2VmcXV1dnJIdnJnaGlta3RqRW9SaFpVNmtYaWxr?=
 =?utf-8?B?eGs2QWNaQ2pnTlhKRTE2YWZ6cDB2RjJDTVU0amJmZHN2NUE3eXdldzI0YWpD?=
 =?utf-8?B?QkFYTm1RajhUdmx6OFQ1UjFVQ0FERkJxNWpsQVdHQjJ1ZmQzZkRPWWRKOWR1?=
 =?utf-8?Q?PQyHAcy9GrP90OVn3XZcpqyWc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FBE50E322791B4194E22726E3D9D234@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b122206-bf80-42c4-e5dc-08da60011b61
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 10:11:49.6512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6bM/6NXxjfbDHpZk2ZAZvftRX5mxq1yoly0Xi7TyJRGSVhLJrjXY5RaDrbK5RRJ5c3eIuIE7ayypWBUUoJtrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3416
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyaXkgQm9nZGFub3Ygd3JvdGU6DQo+IEhpIFRoaW5oLA0KPg0KPj4g
RnJlZSB1cCBzYml0bWFwIGluZGV4IGltbWVkaWF0ZWx5IG9uY2UgdGhlIGNvbW1hbmQgaXMgY29t
cGxldGVkIHJhdGhlcg0KPj4gdGhhbiB3YWl0aW5nIGZvciBrcmVmIHRvIGNhbGwgZnJlZWluZyB0
YWcuIFRoaXMga2VlcHMgdGhlIHNiaXRtYXAgcXVldWUNCj4+IGZyZWUgcXVpY2tlci4NCj4+DQo+
IFRoYXQgaXMgY29tcGxldGVseSB3cm9uZy4gU2JpdG1hcCBpbmRleCBpcyBhIHBsYWNlIG9mIHVz
YmdfY21kKiBpbg0KPiBhIHByZS1hbGxvY2F0ZWQgbWVtb3J5IHBvb2wuIEl0IG11c3Qgbm90IGJl
IGZyZWVkIHVudGlsIHVzYmdfY21kKg0KPiBpcyBub3QgdXNlZC4NCg0KQXMgbm90ZWQgaW4gdGhl
IGNvbW1pdCBtZXNzYWdlIGFuZCBhcyB5b3UgY2FuIHNlZSBpbiB0aGUgY29kZSBjaGFuZ2UsIEkg
DQpvbmx5IGZyZWUgaXQgd2hlbiB0aGUgY29tbWFuZCBpcyBjb21wbGV0ZWQgb3Igbm8gbG9uZ2Vy
IGluIHVzZWQuDQoNCkJSLA0KVGhpbmgNCg0KPiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4g
PFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvdXNiL2dhZGdl
dC9mdW5jdGlvbi9mX3RjbS5jIHwgNiArKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24v
Zl90Y20uYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mdW5jdGlvbi9mX3RjbS5jDQo+IGluZGV4IGMx
M2FhNjFkODJhYS4uZmEwOTk5OWFkZGE3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9nYWRn
ZXQvZnVuY3Rpb24vZl90Y20uYw0KPiArKysgYi9kcml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24v
Zl90Y20uYw0KPiBAQCAtNTcwLDYgKzU3MCw3IEBAIHN0YXRpYyB2b2lkIHVhc3Bfc3RhdHVzX2Rh
dGFfY21wbChzdHJ1Y3QgdXNiX2VwICplcCwgc3RydWN0IHVzYl9yZXF1ZXN0ICpyZXEpDQo+ICAg
ICAgICAgIHN0cnVjdCB1c2JnX2NtZCAqY21kID0gcmVxLT5jb250ZXh0Ow0KPiAgICAgICAgICBz
dHJ1Y3QgdWFzX3N0cmVhbSAqc3RyZWFtID0gY21kLT5zdHJlYW07DQo+ICAgICAgICAgIHN0cnVj
dCBmX3VhcyAqZnUgPSBjbWQtPmZ1Ow0KPiArICAgICAgIHN0cnVjdCBzZV9zZXNzaW9uICpzZV9z
ZXNzID0gY21kLT5zZV9jbWQuc2Vfc2VzczsNCj4gICAgICAgICAgaW50IHJldDsNCj4NCj4gICAg
ICAgICAgaWYgKHJlcS0+c3RhdHVzID09IC1FU0hVVERPV04pDQo+IEBAIC02MDMsNiArNjA0LDgg
QEAgc3RhdGljIHZvaWQgdWFzcF9zdGF0dXNfZGF0YV9jbXBsKHN0cnVjdCB1c2JfZXAgKmVwLCBz
dHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkNCj4gICAgICAgICAgICAgICAgICBicmVhazsNCj4NCj4g
ICAgICAgICAgY2FzZSBVQVNQX1FVRVVFX0NPTU1BTkQ6DQo+ICsNCj4gKyAgICAgICAgICAgICAg
IHRhcmdldF9mcmVlX3RhZyhzZV9zZXNzLCAmY21kLT5zZV9jbWQpOw0KPiAgICAgICAgICAgICAg
ICAgIHRyYW5zcG9ydF9nZW5lcmljX2ZyZWVfY21kKCZjbWQtPnNlX2NtZCwgMCk7DQo+ICAgICAg
ICAgICAgICAgICAgdXNiX2VwX3F1ZXVlKGZ1LT5lcF9jbWQsIGNtZC0+cmVxLCBHRlBfQVRPTUlD
KTsNCj4NCj4gQEAgLTYxNCw2ICs2MTcsNyBAQCBzdGF0aWMgdm9pZCB1YXNwX3N0YXR1c19kYXRh
X2NtcGwoc3RydWN0IHVzYl9lcCAqZXAsIHN0cnVjdCB1c2JfcmVxdWVzdCAqcmVxKQ0KPiAgICAg
ICAgICByZXR1cm47DQo+DQo+ICAgY2xlYW51cDoNCj4gKyAgICAgICB0YXJnZXRfZnJlZV90YWco
c2Vfc2VzcywgJmNtZC0+c2VfY21kKTsNCj4gICAgICAgICAgdHJhbnNwb3J0X2dlbmVyaWNfZnJl
ZV9jbWQoJmNtZC0+c2VfY21kLCAwKTsNCj4gICB9DQo+DQo+IEBAIC05NDEsNiArOTQ1LDcgQEAg
c3RhdGljIHZvaWQgdXNiZ19kYXRhX3dyaXRlX2NtcGwoc3RydWN0IHVzYl9lcCAqZXAsIHN0cnVj
dCB1c2JfcmVxdWVzdCAqcmVxKQ0KPiAgICAgICAgICBzdHJ1Y3Qgc2VfY21kICpzZV9jbWQgPSAm
Y21kLT5zZV9jbWQ7DQo+DQo+ICAgICAgICAgIGlmIChyZXEtPnN0YXR1cyA9PSAtRVNIVVRET1dO
KSB7DQo+ICsgICAgICAgICAgICAgICB0YXJnZXRfZnJlZV90YWcoc2VfY21kLT5zZV9zZXNzLCBz
ZV9jbWQpOw0KPiAgICAgICAgICAgICAgICAgIHRyYW5zcG9ydF9nZW5lcmljX2ZyZWVfY21kKCZj
bWQtPnNlX2NtZCwgMCk7DQo+ICAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiAgICAgICAgICB9
DQo+IEBAIC05NjMsNiArOTY4LDcgQEAgc3RhdGljIHZvaWQgdXNiZ19kYXRhX3dyaXRlX2NtcGwo
c3RydWN0IHVzYl9lcCAqZXAsIHN0cnVjdCB1c2JfcmVxdWVzdCAqcmVxKQ0KPiAgIGNsZWFudXA6
DQo+ICAgICAgICAgIC8qIENvbW1hbmQgd2FzIGFib3J0ZWQgKi8NCj4gICAgICAgICAgaWYgKGNt
ZC0+c3RhdGUgPT0gVUFTUF9RVUVVRV9DT01NQU5EKSB7DQo+ICsgICAgICAgICAgICAgICB0YXJn
ZXRfZnJlZV90YWcoc2VfY21kLT5zZV9zZXNzLCBzZV9jbWQpOw0KPiAgICAgICAgICAgICAgICAg
IHRyYW5zcG9ydF9nZW5lcmljX2ZyZWVfY21kKHNlX2NtZCwgMCk7DQo+ICAgICAgICAgICAgICAg
ICAgcmV0dXJuOw0KPiAgICAgICAgICB9DQoNCg==
