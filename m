Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2263DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 18:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiJFSNg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 14:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiJFSNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 14:13:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D6DFF23A;
        Thu,  6 Oct 2022 11:13:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWuzjuxq5BHHvKz89zaR0yhlyPYnp5P0iI0oe0+G0zTnJ49EzkFGZ3tKd9SFKrQlZPeUj8h2295Kschi84ytb0Yq8Lkr8Ke6EM4iwFIW8CozscMO/QbmMRXsSnYaJUgR0Q/9in1mBNGUmybwZxjSeXG9/9wwhfVP3kiF5NtEeuTqNfMeYhUTM+ifNCtk6YOLEvb1/nYu3SokuPez8nBPaV9MsxaCRdi4Q5f2spQbNb/8KAKdSOwCkDg47Y4sm0mNYrOmvB1XxshdTsCUmRLEXM4l4wfpXVn7Vp4CvTgd/Mk9WAt9i8PKpc5YYm9AznA1qp3VaO50OoCvt1r1l6By3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLpnZmiCyPqqwUJlBDmYk+i6ryltJAXnfuuRMKbYRzo=;
 b=gIFADvXiENbGMPhzHSHrjlQdTjvHcCupT281/ssfSnV7ueXDGxweHhY/7HQU1UeZ28oyqXEZj06STdRRddPNFKpxGnOEz50EYEErIIF6eexHvSNsfV3ZprI3mDP52Ed9+k3OfSq4LhQknEUQ58AndKwp2Uspcq91D379yius0w0ILFi5jL5DO3e6aDduF7Iv4Ic0rPaSsar0U0dvSNdHHN35iKfEV6JhHau5DAja8QYr1kv682DVNZ67iP1QUqLofr/j63xKlGA0UReR7MxC0fEvPQShTWc0Q4gl0bmpHbYKzyTMnRFP8t6KZcXk5FJuTkDS8LIdkqkXLYMcXxWX6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLpnZmiCyPqqwUJlBDmYk+i6ryltJAXnfuuRMKbYRzo=;
 b=YlCw0LON7eXkBG6RzvYrB6KIA6i3aFKFQwtB4Hc6inR7rIS7EIC6EFjnH0TiufiGeBoBHMy4udm8xr81f1Q4XbVNaEL4mubcQ9I4rwSp0NcFPl5wgPpMtr/RRZKdeHgxk/58jV9kq6YFdCZcK2z7yEzeNYYpa7BoHBdw3002fIuqKQfnYC0Kaian4Bl0F+nnI+04PMaDua0rFuFyk41CqhZ4EGAWz7PagxvHjSTIYYxV+jwPPIg7tocygy/KjbFX9KD45S4kTdQ0DldCv9HJogsKVPNcgwnnxvX1Ye8xMwVy5ih+1/DVg6Aign1gbp0gtwb8h+AqPYlq3bnjKp2YPg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 18:13:30 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 18:13:29 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 01/21] block: add and use init tagset helper
Thread-Topic: [RFC PATCH 01/21] block: add and use init tagset helper
Thread-Index: AQHY2GnUla2DUnT45EePa3oKE5VM3K3/QPCAgABNOQCAAHcygIAACAYAgAGgd4A=
Date:   Thu, 6 Oct 2022 18:13:29 +0000
Message-ID: <7e9ce6b2-70c8-cf85-95ab-de09090db64d@nvidia.com>
References: <20221005032257.80681-1-kch@nvidia.com>
 <20221005032257.80681-2-kch@nvidia.com>
 <6fee2d7a-7fd1-73ee-2911-87a4ed3e8769@opensource.wdc.com>
 <CAPDyKFpBpiydQn+=24CqtaH_qa3tQfN2gQSiUrHCjnLSuy4=Kg@mail.gmail.com>
 <e0ea0b0a-5077-de37-046f-62902aca93b6@acm.org>
 <a7e4fe12-64f2-3164-d675-26310ac07c9e@nvidia.com>
In-Reply-To: <a7e4fe12-64f2-3164-d675-26310ac07c9e@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DM4PR12MB5248:EE_
x-ms-office365-filtering-correlation-id: ea1d743b-b351-493b-1fd0-08daa7c678cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +G/NJMKQkIg9jgSm9072JK9ZsK/GilxBFRwNqJIGQPG10Jo5F43Qktq2QuPciqtzXC0nmNQbEHPBYkg/lpha4hVu/MhncGHbf+rIRMBla3x8pA9gQdTcJLf52b6xvWOJ7SZwz5SZ6FZkgm60vszUcJhXjQAUzQlTY+C+Hb5VbfQO0uVBAe1IAk4iw6HYKFJFkvXFsROnkF864m4UdaQFD0LD2M+R/f7AsSRbVZbS4jzyObxm/0A0AtyVBAZgK1GL2tdg8M7oB+Es80jsHKJ2TCHOKpICjnRhTFYHdmnEOAE2IUn7EEsw2ONC7RcvoBaUS8omA9wodXs2+BKChFVCCqSXlBYS3xIT4GEtgnGhGgnHkICRkRPAczo8h7VUaDISk7Ysb0jZIgiDrNNrTggbn9qwTY+v/SUv45wyqsWLELAYdHyIeXiQZOQKOxqcOYup2175p7CZY0RBYdFbDJ1actaxYurSxuovBwpG8IXi8PX01o5vIrFzo57Jh8rmZjGnLJvpn1HojPj3TugFE9RomlwvTtRuKAgNSLdgAFRi2/78mkGTZpdV+lfjPna0ulUdiGjDNLrPOFi8/BNLwoekepNhZAkloBk6iAPnDfbF+zcPHUXjy/PLx1Up7GRQBCu1E7X8wui0qb5evQGi+00ulHU/FBzBLskva6ww7/H5HaMw7fszEMH6Fdah4aStu/6aGg6ekBsGM7tMvYaF0XYLxDNeFVh2o4Y+e7Q+TEj0RHsGBOsXDTwiAFtRoYFAPBfEEsWQjEdE2OArtY+rrj8P790P5BixzbgESam0kx/7Dt7+aNiX9Uz95KI2YPZ0SWdIB7FtGTmWJ+xD8CjCplbFZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(5660300002)(38100700002)(186003)(64756008)(36756003)(66556008)(38070700005)(66946007)(6506007)(66446008)(41300700001)(53546011)(122000001)(31696002)(4326008)(8936002)(66476007)(86362001)(76116006)(110136005)(8676002)(71200400001)(6512007)(316002)(6486002)(91956017)(478600001)(54906003)(2616005)(31686004)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTdIUm5TK3lhTnM2U1VIcmhPK1dPYnFMck10N0MwNC8zZGkzanJqRzQyaSts?=
 =?utf-8?B?eXhyQnRaZnR4a25SemEyZWY5ck4wMFh5cDluQkppczkycnE1MDRlRTQ0dVZM?=
 =?utf-8?B?UWt0czJNNUNKakJ1N1BCMnhpSXA3eW1EeCt1RGd6SmVocnM1Nk1YQ1IyM3Zj?=
 =?utf-8?B?WWJxT291TzBOcVFrL0pPcHR6SHcyOEI4S0F5Z3BWN1pRMDVkNlBNbVVueUhj?=
 =?utf-8?B?emtVcTFnc2JVT0EyZzQvWFcvYzIvT2wrOTJ1YnhzOXNrNzNKR3BydU0razE4?=
 =?utf-8?B?bDR3cHlYbURRYXo4ZnNUYXBrTFpXbGpBTFNua29kYTc5NEE2ZVhReExCWmR0?=
 =?utf-8?B?YmUvZGhFMDJDV21UdVV2cFlSaWdid3VYZGNVdUZiME1nc0xOOFhDZndwczMx?=
 =?utf-8?B?U3FIeVBsRktjbGZuc0FJd1BTYXFqcDBrTEpCQ242MmJ3VlRNQzJvTFJ3RHpm?=
 =?utf-8?B?M2ZzSjFEa0dPeVd4Q0N2dWN5QWxTQWlINis2MzdNbU4xWERxeGxKbjJFRDUz?=
 =?utf-8?B?SzJSY2lJK0RkWVB4OXVpRHNMZzAwRkFPa3haN2d3dXZyMlYrbGxlOWhTajg2?=
 =?utf-8?B?ZWdXKzRqQ2hPUmRhbnZGQW1wLzd5OTdyZ1NPaFJ4NzBPRG5GMDRnMGNocHRG?=
 =?utf-8?B?bGN3RUhaNmo1KzcxQW5pOVFyM21FQlg2U1JFZWMzUFlpcWYycm1SNWFQSVJX?=
 =?utf-8?B?YnFtTVhEd2JCNXFnNUM5RVNvYVViVzh4di9QaTRxdjEwZDJNQzRlcXQrN1BH?=
 =?utf-8?B?Q3o5UFZoNnlVVExWcG11S3FrK3dZc1pOMGJ0VXREZzk5VkE1c0dROHhwZXhi?=
 =?utf-8?B?Z1NLRm8zdENodFk5VEx6Y1NFN3dIcHkxUzE4bFV0akFScEFuaVFZRTVVNlVG?=
 =?utf-8?B?UVd1TWdPUkxRYjArUUhEdThFbm5aZlFIMlQ2bXQ5YzIyV2ZuWENsQXE1OVFZ?=
 =?utf-8?B?cHJWL3k2RTVPancvU0c4V2JNT1NORnl3M3JpdG45N1hTMnNZOG1oOHByWEV3?=
 =?utf-8?B?QnFGMjBUeFczN1NtbklHdmlYbVp1eS90eDlCSFdiZ3MvQjJZR2Rrb1J2U3FB?=
 =?utf-8?B?aWFyNVVBWDRiSDZuUWloWXB3WG1NODZpVFRxZjFCdnVreStFVFBYZktlR3RF?=
 =?utf-8?B?WlZ0UmFUTmhjdWQzZmtobmwzZm5zOG9yS29TZnlzSng1R3hBT0oxbzhrNUoy?=
 =?utf-8?B?UWdLdzNOTFYzNTFsUnI4bnJmMFRXQVdMTUh6OVRpSmJHWkwvNGluR2JRdUtC?=
 =?utf-8?B?VHhsQmErVHk4MExYMGNlSExQQVhmVXUvWnZYUTJvcVpYZzhKVkVDSjZNaWZq?=
 =?utf-8?B?ekc0aHU4TFJ6VFM5NlJYaTF4ZFZtVjNSTVVLWXRBaFA0WnBrdHR2R1RSVllT?=
 =?utf-8?B?TExabXhScEhqS0drYTllMC9iVHV6a1YwNnA2VTE2ZjVTV3dKSENKcEN6cEpM?=
 =?utf-8?B?YVlSakFpQmdWdlloLzI3S2p3SitiREk2T2lwdGR0bG5mRXUyd1VSU1NYRi8v?=
 =?utf-8?B?Q0RXanloYU1KVVoxWVFjNkVHK0xMcWpldWEzcTFKQTd3Ri81MUw1OVRaZGp3?=
 =?utf-8?B?SmczRk4vQS9UMlM4L1gzcHJmVlNKNStFZk5ydGJhL1IvelpNNFZ1OXBtcFdr?=
 =?utf-8?B?WFBySk1DWnV6ZWp5ZVRGQ1k3eHRlczcvRjBmTUNxa3ZTdTNCMndoUURxbXVQ?=
 =?utf-8?B?bGxXVitsK2tGeFh2clJLMGNyRnI0QjMwYXFBZEJvNVhIdjNCcmVLSG1DdTB5?=
 =?utf-8?B?N3lOQXRieGV4UWxyVmJqTUErL253RGQrTXUrVmNLcUg4NmNseG9OLytHSEhQ?=
 =?utf-8?B?aldHcC9IbHVDZXN5Y1ZkcXU4QTF2WFlicUZGdlR2bGdacUdDYmJlTnJnSDBE?=
 =?utf-8?B?Z2pGeGJ0cnZMaWQ0Wmd6MlpkY2dtOVU2VUNnMzhyOWFnMXlYVnA3cFU0c0N2?=
 =?utf-8?B?dlJKdFNsSklhcW5lMjJvOWVkZjRKS1FyN2xrRlZkTTcwc2d0clBXUkdyZXZN?=
 =?utf-8?B?c0FiclVjcjFmcWdPMkhWWXNKeTE2Z2Z1cEloMnltWjk2MWdFMDY5cDBPZy90?=
 =?utf-8?B?SlFxM1o1dFBLWSswYXZJaUJZTkJvYnZSN3BMem1XeDZNeDNNSXo0L3o5M3A5?=
 =?utf-8?B?U2ZJMWpWRnJLbVFrM0dLeTRqQ211WUFSd3htTG8vQWhyNDdlZFlGN1krWkVX?=
 =?utf-8?Q?/d2uqG14Kg6jO5pendPG6PU+VtBkw7gWi/CYcSix/Rbg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3287FBDA08B58E47A74D29E2F67EED51@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1d743b-b351-493b-1fd0-08daa7c678cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 18:13:29.7793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkQt/vB8T9LO2hHExSocUhGYlMDNH7NRh27MYul/sPIiM5kP66kWNL4OKty6eH5uTcv1I+lizU2EI2GjCiH++g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvNS8yMiAxMDoyMiwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPiBPbiAxMC81LzIy
IDA5OjU0LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+PiBPbiAxMC81LzIyIDAyOjQ3LCBVbGYg
SGFuc3NvbiB3cm90ZToNCj4+PiBPbiBXZWQsIDUgT2N0IDIwMjIgYXQgMDc6MTEsIERhbWllbiBM
ZSBNb2FsDQo+Pj4gPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPiB3cm90ZToNCj4+
Pj4gT24gMTAvNS8yMiAxMjoyMiwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPj4+Pj4gK3Zv
aWQgYmxrX21xX2luaXRfdGFnX3NldChzdHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnNldCwNCj4+Pj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IGJsa19tcV9vcHMgKm9wcywg
dW5zaWduZWQgaW50IG5yX2h3X3F1ZXVlcywNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgdW5zaWduZWQgaW50IHF1ZXVlX2RlcHRoLCB1bnNpZ25lZCBpbnQgY21kX3NpemUsIGludA0K
Pj4+Pj4gbnVtYV9ub2RlLA0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25l
ZCBpbnQgdGltZW91dCwgdW5zaWduZWQgaW50IGZsYWdzLCB2b2lkDQo+Pj4+PiAqZHJpdmVyX2Rh
dGEpDQo+Pj4+DQo+Pj4+IFRoYXQgaXMgYW4gYXdmdWwgbG90IG9mIGFyZ3VtZW50cy4uLiBJIHdv
dWxkIGJlIHRlbXB0ZWQgdG8gc2F5IHBhY2sgYWxsDQo+Pj4+IHRoZXNlIGludG8gYSBzdHJ1Y3Qg
YnV0IHRoZW4gdGhhdCB3b3VsZCBraW5kIG9mIG5lZ2F0ZSB0aGlzIHBhdGNoc2V0DQo+Pj4+IGdv
YWwuDQo+Pj4+IFVzaW5nIGEgZnVuY3Rpb24gd2l0aCB0aGF0IG1hbnkgYXJndW1lbnRzIHdpbGwg
YmUgZXJyb3IgcHJvbmUsIGFuZA0KPj4+PiBoYXJkIHRvDQo+Pj4+IHJldmlldy4uLiBOb3QgYSBm
YW4uDQo+Pj4NCj4+PiBJIGNvbXBsZXRlbHkgYWdyZWUuDQo+Pj4NCj4+PiBCdXQgdGhlcmUgaXMg
YWxzbyBhbm90aGVyIHByb2JsZW0gZ29pbmcgZG93biB0aGlzIHJvdXRlLiBJZi93aGVuIHdlDQo+
Pj4gcmVhbGl6ZSB0aGF0IHRoZXJlIGlzIGFub3RoZXIgcGFyYW1ldGVyIG5lZWRlZCBpbiB0aGUg
YmxrX21xX3RhZ19zZXQuDQo+Pj4gVG9kYXkgdGhhdCdzIHF1aXRlIGVhc3kgdG8gYWRkIChhc3N1
bWluZyB0aGUgcGFyYW1ldGVyIGNhbiBiZQ0KPj4+IG9wdGlvbmFsKSwgd2l0aG91dCBjaGFuZ2lu
ZyB0aGUgYmxrX21xX2luaXRfdGFnX3NldCgpIGludGVyZmFjZS4NCj4+DQo+PiBIaSBDaGFpdGFu
eWEsDQo+Pg0KPj4gUGxlYXNlIGNvbnNpZGVyIHRvIGRyb3AgdGhlIGVudGlyZSBwYXRjaCBzZXJp
ZXMuIEluIGFkZGl0aW9uIHRvIHRoZQ0KPj4gZGlzYWR2YW50YWdlcyBtZW50aW9uZWQgYWJvdmUg
SSdkIGxpa2UgdG8gbWVudGlvbiB0aGUgZm9sbG93aW5nDQo+PiBkaXNhZHZhbnRhZ2VzOg0KPj4g
KiBSZXBsYWNpbmcgbmFtZWQgbWVtYmVyIGFzc2lnbm1lbnRzIHdpdGggcG9zaXRpb25hbCBhcmd1
bWVudHMgaW4gYQ0KPj4gICDCoCBmdW5jdGlvbiBjYWxsIG1ha2VzIGNvZGUgaGFyZGVyIHRvIHJl
YWQgYW5kIGhhcmRlciB0byB2ZXJpZnkuDQo+PiAqIFRoaXMgcGF0Y2ggc2VyaWVzIG1ha2VzIHRy
ZWUtd2lkZSBjaGFuZ2VzIHdpdGhvdXQgaW1wcm92aW5nIHRoZSBjb2RlDQo+PiAgIMKgIGluIGEg
c3Vic3RhbnRpYWwgd2F5Lg0KPj4NCj4+IFRoYW5rcywNCj4+DQo+PiBCYXJ0Lg0KPj4NCj4gDQo+
IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLCB3aWxsIGRyb3AgaXQuDQo+IA0KPiAtY2sNCj4gDQoN
CkFjdHVhbGx5IEkgdGFrZSB0aGF0IGJhY2suDQoNClRoZSBwcm9ibGVtcyBsaXN0ZWQgaGVyZSBh
cmU6LQ0KKiBMb25nIGFyZ3VtZW50IGxpc3QsIGhhcmQgdG8gdmVyaWZ5IChEYW1pZW4sQmFydCk6
LQ0KICAgc29sdXRpb24gaXMgdG8gbWFrZSBzbWFsbGVyIGxpa2Ugb3RoZXIgZnVuY3Rpb24gYmlv
X2FsbG9jX2Jpb3NldCgpDQogICBibGtfbmV4dF9iaW8oKSBwcmVzZW50IGluIHRoZSB0cmVlLg0K
DQoqIE5vdCBmdXR1cmUgcHJvb2YgaWYgdGFnX3NldCBnZXRzIG5ldyBtZW1iZXIgdGhhdCBuZWVk
cyB0byBiZQ0KICAgaW5pdGlhbGl6ZWQgaW5jcmVhc2luZyB0aGUgYXJndW1lbnQgbGlzdCBvZiB0
aGUgbmV3IEFQSS4gKFVsZik6LQ0KICAgc29sdXRpb24gaXMgdG8gb25seSB1c2UgY29tbW9uIGFu
ZCBtYW5kYXRvcnkgbWVtYmVycyB3aGljaCBhcmUNCiAgIG5lY2Vzc2FyeSBhcyBuZXcgQVBJIGFy
Z3MsIHNvIGlmIG5ldyBtZW1iZXJzIGdldHMgYWRkZWQgaXQgd2lsbCBub3QNCiAgIGFmZmVjdCB0
aGUgQVBJLCB0aGF0IGFsc28gdHJpbXMgZG93biB0aGUgYXJndW1lbnQgbGlzdC4NCg0KSSB3aWxs
IHRyaW0gZG93biB0aGUgYXJndW1lbnQgbGlzdCB3aXRoIHRoZSBtb3N0IGNvbW1vbiBhcmd1bWVu
dHMNCmFuZCBrZWVwIGl0IHRvIG1heCA0LTUgbWFuZGF0b3J5IGFyZ3VtZW50cyBpZGVudGljYWwg
dG8gd2hhdCB3ZQ0KaGF2ZSBkb25lIHRoaXMgZm9yIGJsa19uZXh0X2JpbygpIGFuZCBiaW9fYWxs
b2NfYmlvc2V0KCkgWzFdDQp3aGVyZSBtYW5kYXRvcnkgYXJndW1lbnRzIGFyZSBwYXJ0IG9mIHRo
ZSBpbml0aWFsaXphdGlvbiBBUEkNCnRoYW4gcmVwZWF0aW5nIHRoZSBjb2RlIGFsbCB0aGUgaW4g
dGhlIHRyZWUsIHRoYXQgY3JlYXRlcw0KbWFpbnRlbmFuY2Ugd29yayBvZiB0cmVld2lkZSBwYXRj
aGVzLg0KDQpBbHNvLCBpbnN0ZWFkIG9mIGRvaW5nIHRyZWUgd2lkZSBjaGFuZ2UgaW4gc2VyaWVz
IEknbGwgc3RhcnQgc21hbGwNCmFuZCBncmFkdWFsbHkgYWRkIG1vcmUgcGF0Y2hlcyBvdmVyIHRp
bWUuDQoNClRoaXMgZGVmaW5pdGVseSBhZGRzIGEgbW9yZSB2YWx1ZSB0byB0aGUgY29kZSB3aGVy
ZSBjb2RlIGlzIG5vdA0KcmVwZWF0ZWQgZm9yIG1hbmRhdG9yeSBhcmd1bWVudHMsIHdoaWNoIGFy
ZSB3YXkgbGVzcyB0aGFuIDkuDQoNCi1jaw0KDQpbMV0NCg0KOGMxNjU2N2Q4NjdlZCBiaW9fYWxs
b2NfYmlvc2V0KCkgNSBhcmd1bWVudHMuDQowYTMxNDBlYTBmYWUzIGJsa19uZXh0X2JpbygpIDUg
YXJndW1lbnRzLg0KDQo=
