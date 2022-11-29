Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499E9C46467
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 04:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiK2ESb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 23:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiK2ESX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 23:18:23 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB7363CC;
        Mon, 28 Nov 2022 20:18:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bndlEY7FPPRMOr0fhHA7mXPk6HhGIb1vnHAM9aaJVwcuh5lSqLBxvra3uhQlio23lQQh4ZJ77MIfC8RITHYbM6fVKzLwnIJ4vCSmoo/AfoIpTl+rJ7ZRE8k9GxbALxo+SO1WcUkaf+hWu3ccuRr/Fat4ihUso/IxU4JRwLMSxdEC1WurJRrtHoa3nZcvFhvh6H9Wukd36AVUvFIWZWv0NvGlUz9GjO9HGefF+knICN9uVbNCvvQAftnuitMz8QuHbCB6jXJWkoHXTDcz4BrPFsf0F5qqNzba6b3AbGn9k+2ooLIU+sn75tmOPljWXrCUseFIzEVEipC7OGRapAQjqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lOudla6gXrH35v4Dl+8wmXrzToiindJ06Dy0qkI5+k=;
 b=Q2GaDOviuIeUCFMdzCCdQGhHU/AEdYCjSU5p1pS5w6tBGi8FQD6+mS8aqbj8QxAJjyZ2yvG3NmbMtqthMyEhvGKetODdR31+Ywu75fgVqi+UFl1P8G/Et7uPzbSq+k9ZZmwqfj11G8fCQ1yzNuYD1xe1rTxMgvpii2qwxs56sOrDmZs5HTVZRMZACW1cBN8leDpVb+XebCIIJ0YRFiBrdfBlbw3fJz+50AXbJnETEb/EeLGK2UC6xJAo5GD/oMXPNX3eSgdcWcaTt6e9ULx+IwqFqAv527L8V7BeJ5SruT8isH08VbtZ2K0KVsEFRro758/U9FQBEnsiDxjvdXgGVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lOudla6gXrH35v4Dl+8wmXrzToiindJ06Dy0qkI5+k=;
 b=M3Eii2QUZo0b5gMwBcc3gaCtXd9aTQ0Qh/bmg0pBm5umRHe8lQ7+mH+L5LUZPBtDRFOp9v05A4BHiLwoq76bUzA0w6vKGL3+Kxwovfo8S0AxXpie/x4APHmD4rHsszOvieI3mxu6f08/4BmobqroJAq5r6h7GbNY1HKPHCu5QYV4Yce+ApAe1mMZHt7zqGFMbODb7vk7kRM3OaZZrwAUG8GI/RuU++dFmwIQiXokOptrp2YQZXEWK/jG+oOF0DUvNZmea1snyYznJ6HWIcE17ZjGNKxgidyuXYHoMgb70EfjrY8stbWS6I86gAdiiHqYAZ4gT2lIvt3TO/IAOH7szA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7507.namprd12.prod.outlook.com (2603:10b6:208:441::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 04:18:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::f02:bf13:2f64:43bc%7]) with mapi id 15.20.5834.015; Tue, 29 Nov 2022
 04:18:19 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
CC:     "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
Thread-Topic: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
Thread-Index: AQHY/iI45uMf4CpwKkWVe5zMcNCh3q5QhxUDgATP34A=
Date:   Tue, 29 Nov 2022 04:18:19 +0000
Message-ID: <538bcade-c453-e6f8-4530-808a9bf2140a@nvidia.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
 <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7507:EE_
x-ms-office365-filtering-correlation-id: 8cb5f918-bbaa-49a9-d58d-08dad1c0bf3a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KS+9vHba/NDdRaj8qJIkTBBRXADlQVN46g263PIq97oDlNDbUIFaNLXQ6XczYZDHRUdx2WC13fb/rlCxIAbfcnk832vfhqmgZ08ac2PuH1hcmGes7vLwg9pETeCfB/KZT9oPmOzCmTKCkMsikn1NHpje35BIRSQVay9XwPAOfQsmqBYlj37iZ4HPHuLlrpG61rVY8gOdOcVl08lITRuYpYGRXomUbbdq7e55dr3l6/rsZ71WSTXKyfMc49PyGHkPTSpWxJR3+VqJZKcvzqjEm619QObx3e1brz8xauBVTxVXHqRm56lgfA3laqTDZy7rU9Wsar6sf23RGSnM+BVhEjUIfSEW60q/fnHC49mF1JjfDQnnuDPcTYe1R7RrJoYoCLF8AKNQijIrlB+EGm9he8bh1zGBhH/lKjNo6WQPt2ykB/vl9T5w0SFThdtUQDI8W2Ddkne4SHwIwo41hErhEbMSDwSKH5OuWS2eu8T5kUPq9Xh/BZl+BJk2gaxeoTwo7pAFgCaE+7xI3HhRPdLkDsh4007jfdZCqIvfOFFhiHtP+DAxDo6wr5PJLqUPB2c3lq/jHpFLa2KXNsXY8cvL2mqbGfQtgHH+D7PvKo0LIn2OgRrN83tfbYjjlV+FFzFtt9EfZU/5EY87NLE9/JnV0xsRI4urWOk7jRnHaBtDWeh24W+UtywpUcXVXoJfuSenMZeLJF9bCeGnSn8cvXui5oVA6X6XWPThDK/efsG0PJXRd5tsCuMJklbTOzxAvCe4BBX69ooPylBcIjYILBHvmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(31686004)(86362001)(31696002)(478600001)(6486002)(71200400001)(7416002)(38070700005)(2906002)(36756003)(122000001)(186003)(6512007)(83380400001)(38100700002)(2616005)(66946007)(66446008)(91956017)(6506007)(53546011)(41300700001)(316002)(76116006)(4744005)(66556008)(64756008)(110136005)(4326008)(8676002)(8936002)(54906003)(5660300002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SktkOEJ0by9kbE1iSlk4MkRjeXpZUExBaDFzQ3J5MnpDaTlralZxYVJ0dkZS?=
 =?utf-8?B?ZXlxVVZjV3h5N3I1emRQOXptSXpJWEQ2dElSZFVHNFRHVWdESDA3V1ZVb2Ir?=
 =?utf-8?B?L1ZCWHNOVEFDMnA5cjhnOExMSm96YXY2ekEwYzdZMVV1TlQwekwwQ21rRmtC?=
 =?utf-8?B?TkxjZk1mcGhFeDg1UmY0OTA4Zk00V3d1Tkt0Q0pvZkZxeGhnOGFVS2U2TDhm?=
 =?utf-8?B?OGcwcys5Q1V4VEhnZ0dSZnNUV2NYR2dhajJaWCtrcFArbkU4eFdnZVk1OHow?=
 =?utf-8?B?c245TEJ6V2JVZjNtalRyMlBBN2VmNHoxcTJ3QnZqTVJNTFU2L0JzLzl0ZElE?=
 =?utf-8?B?TjlBa0haUXM0SnhSUmgvSDUrWFlnM2NBNmMzMHgxQW9EQzRxbXh0UE9YTkw4?=
 =?utf-8?B?akl4cU5DY0NCNFZJM241Y3NrSmtJdFBjUXNEM1YyUWRGb3FUZlVNd0E2WDZY?=
 =?utf-8?B?bm5uTkxlQncxaHNHWHd0dVFhWnZlTENRSnYyQ1cvQm5HMDRRQzVPU3kwQk1L?=
 =?utf-8?B?cFNaS0hLTTY2REl6YlJmaS9wZG9tTTJqUVBMeUxLSVZlc2diZTVJNG5obnlX?=
 =?utf-8?B?cnBIUkZDYlpsMUQvRVJwMXp6Q3NVZVlCa0Z6NmgyQlJwdHVVUmFPY0o1R2hn?=
 =?utf-8?B?c1RzTVNRRGN2andLRGdQT202S3JkK1BYeUFMakk2MVdIRnZnZTZNK3ZGeWk2?=
 =?utf-8?B?b2RuY0tUNzJZQ0lIVFJqbmtoekg4NlUrY0pXczZzOGlCdWlIaHB3ZDNZRXhT?=
 =?utf-8?B?VjRZcGgrdWVqN04wbWUxZE5jLzhzbFpodU5VVkR4N3ExUEd0NVZuQkJEM0dT?=
 =?utf-8?B?NkF2M3pyWUpiek1UVUNqS2NFb2w3bkI2aUI1aDZvbjVvVWNhcTZQMWN5dFV4?=
 =?utf-8?B?bGN4YkVmakpqb2xRejM4Q0dvb3psa1JSVFlxcnVVclcveER0czROYys0ZjV5?=
 =?utf-8?B?YmlFOWxHOXVKUVFVVTJPdU8wNmhpLytZQVQram50QlJjYXZGSjYxeFlWYzlz?=
 =?utf-8?B?dUhtUFd4ckI3ci9LUmF3alMwMmdHZHUvWGVjYUhRZ0lMeDVORGx0b1JpSVY3?=
 =?utf-8?B?b25mVzMraXZIN3YvN3JSaXVOWEZOM0lhMVJ6SGVTNHR3WmxTYnZ2QkZBSTVv?=
 =?utf-8?B?dFhrMGVRa1ZvbGdTUmgrZmZDOVl2eWpRLytnWFRHVHlnMmIwOW9tYmJZZU5P?=
 =?utf-8?B?WTdBbHRwdzFCRUdVQkFRMkVKaHZmQ3RQMUMvM0cxSHRjSGlkY0FlcWYzbmcr?=
 =?utf-8?B?b2pmVjU5U0lLRGpvNU5waUJ2UHd5TXB0ckxadENZS0xRaklnUTZON0kxcGlW?=
 =?utf-8?B?YjB3Z1VzendlZWVHaW1pS08ybnFkcEZYeVV3Z0U1K2llMU4xZEhZUTJEVDZP?=
 =?utf-8?B?WDRCaGlhaHBTeHRmQ2FtUWNJcGlheEVFczlvdVZJTWRJR2s5bnhsa0lwbHJM?=
 =?utf-8?B?cUNUMGIya3V3NmQvakdreXBoNWtoZ3pyY3BHNEFSWkFKeHZqdUZuRUNWek9s?=
 =?utf-8?B?dnljNS9hSmIzaHpmUXY5U0wzZUo0WlBtL2NidFd0dmdGYVVKczMreHk0Sjl4?=
 =?utf-8?B?U05OTlN2K1lnZTluMmNpR0RteEZJbks4MjU1anVRUGZWRElnQmRJSU4vMU9G?=
 =?utf-8?B?WE4rTlNrUGJzQzZpYmVSRUZWcGtKd1Rma1FyekNORFROdy9vR3Zaci9ETTZN?=
 =?utf-8?B?b01ycE9KMGhIdlZzN2U4SWc4M0JwUzNVTjRFZmMwL0FPWmRBVFhCK2c4ck9u?=
 =?utf-8?B?eWZFU1ZCNFNsVGFEN0lNS3BlRUVwbmw0YU5oNFBBOUVpV3RrNHVETXpXRXdV?=
 =?utf-8?B?OFVtaDlJV3J6cFhkRDBGRWJnT0pSYXRZdmIzaDhuc0NQZ2dSeXN3aDNVYnZK?=
 =?utf-8?B?UUpyelkvOUFJT3JNeERNSjVHZU9YWmhZQ0RZS0ZnYnh6dm5TZjNQTEJvWXpq?=
 =?utf-8?B?VHg1Q3R2Nm5jL0FlaGgxd1NKVWc0Y3BHNHI0eFVBTTRQc2FuMGVDYVluai9Q?=
 =?utf-8?B?Vy80VE9Qa2g3OTRMSnhBeVNmdnlOZzFnTEtxVkVhSEp0eW5SZHpWZUJqdEVD?=
 =?utf-8?B?UGJxMGdCbTc4a2xrdmNEaTJLTFo4QnBRb3pkQ212UXFIMUFIV29YaDZvSnBB?=
 =?utf-8?B?S0c1TTVGYi9VMStpT1ZtV1pZL2hNQ1BaZGFvR3U4eUZzNSs5QXUyL0RqTk55?=
 =?utf-8?Q?0+oOJUhzT6gvhXeg0GXKxxXLrSkkW3Nt3gHeJws88UJY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A355E868140B44D9B2EFBA533EA2803@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb5f918-bbaa-49a9-d58d-08dad1c0bf3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 04:18:19.8107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qP6OOmcqciTPYrDsBDBy+e8lFmpfT9fLUXBkvKtQKu/KU4EKIYks2JJIen2Tk4ZWM7ghfPMQoSSYR/R4U4cF4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7507
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMjUvMjIgMTg6NDgsIE1hcnRpbiBLLiBQZXRlcnNlbiB3cm90ZToNCj4gDQo+IE1pa2Us
DQo+IA0KPj4gVGhlIGZvbGxvd2luZyBwYXRjaGVzIHdlcmUgbWFkZSBvdmVyIExpbnVzJ3MgdHJl
ZSBhbmQgYWxsb3cgdGhlDQo+PiBQUi9wcl9vcHMgdXNlcnMgdG8gaGFuZGxlIGVycm9ycyB3aXRo
b3V0IGhhdmluZyB0byBrbm93IHRoZSBkZXZpY2UNCj4+IHR5cGUgYW5kIGFsc28gZm9yIFNDU0kg
aGFuZGxlIGRldmljZXMgdGhhdCByZXF1aXJlIHRoZSBzZW5zZQ0KPj4gY29kZS4gQ3VycmVudGx5
LCB3ZSByZXR1cm4gYSAtRXh5eiB0eXBlIG9mIGVycm9yIGNvZGUgaWYgdGhlIFBSIGNhbGwNCj4+
IGZhaWxzIGJlZm9yZSB0aGUgZHJpdmVycyBjYW4gc2VuZCB0aGUgY29tbWFuZCBhbmQgYSBkZXZp
Y2Ugc3BlY2lmaWMNCj4+IGVycm9yIGNvZGUgaWYgaXQncyBxdWV1ZWQuIFRoZSBwcm9ibGVtIGlz
IHRoYXQgdGhlIGNhbGxlcnMgZG9uJ3QNCj4+IGFsd2F5cyBrbm93IHRoZSBkZXZpY2UgdHlwZSBz
byB0aGV5IGNhbid0IGNoZWNrIGZvciBzcGVjaWZpYyBlcnJvcnMNCj4+IGxpa2UgcmVzZXJ2YXRp
b24gY29uZmxpY3RzLCBvciB0cmFuc3BvcnQgZXJyb3JzIG9yIGludmFsaWQgb3BlcmF0aW9ucy4N
Cj4+DQo+PiBUaGVzZSBwYXRjaGVzIGFkZCBjb21tb24gZXJyb3IgY29kZXMgd2hpY2ggY2FsbGVy
cyBjYW4gY2hlY2sgZm9yLg0KPiANCj4gVGhpcyBsb29rcyBPSyB0byBtZS4gTm90IHN1cmUgd2hp
Y2ggdHJlZSBtYWtlcyB0aGUgbW9zdCBzZW5zZSB0byBmdW5uZWwNCj4gdGhpcyB0aHJvdWdoPw0K
PiANCj4gQWNrZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNs
ZS5jb20+DQo+IA0KDQpwZXJoYXBzIGEgYmxvY2sgdHJlZSBzaW5jZSBpdCBoYXMgYmxvY2svc2Nz
aS9udm1lID8NCg0KLWNrDQoNCg==
