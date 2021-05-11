Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13708C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 14:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D950A61155
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 14:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhEKOQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 10:16:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhEKOQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 10:16:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BEEbAX120846;
        Tue, 11 May 2021 14:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PUNG2PfERuZig3G1f6JM5w961M8KjHsNvPkwM4BgBaI=;
 b=LAz/ckeDXtR1xVFssXCH89YvAQMXw0KadSkU/h3o1OA2cz5EmVRyxCtonx93z5bDnglw
 sWB2FHbYgq4ork6+/oRzbgFHkKuLJgxjUfNoIhJhcBcdzfrlDjL+5IFf1CMzIG6i0xpt
 KuE0nEd+hWiIFVkGF8gM/j/QjIA9a3+4LChZYro4lNyBjE/CubzjHPo4rNFTwbZtiHG3
 KOz6pEzn+uOewBrrOOY2N42gMi6nEIDvBWN1UJkMSmgQY4L4tE0qteuUB6jjhrwpCzM1
 E0SOHeVnsT0fZ6ImiTSmwgrgaWQYXJp/Nze1eliONjrrxD6mXd9NcWoIhQSHv0ssE2TG 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38djkmev8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 14:15:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BEFAiu003742;
        Tue, 11 May 2021 14:15:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 38djf9bv77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 14:15:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+4iFA0H5X2j+6RX1PIgqmBefiUZ1O31dgMrnepLKegH/8YHmRDsS+R+oHYIY/TqjSxg7bqGoX0k5ICARvrBFGCSoxU9oVj5YWZobFgoy0reCW2rAB7H8vn/SKNxkUYkvNk//sC/V6wGIVGlvCu7/8qhKk+3YVBOkW0RXqM0c+CwFxOjlv55TNQCc+UgGwokNlU2X4+Xs8gsHCCiv7spD6jJvlXQqaby1VexH3Oz5ZiY1aknZu1Iv+wIU+2xPow8iwYsVeIVLBzaMMVjqA+MXBGhlsXNiHDB748P7ACd/WD3SSWkBHgdC9t0In0kRDzhbdqLfr36UgitlGWUftpU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUNG2PfERuZig3G1f6JM5w961M8KjHsNvPkwM4BgBaI=;
 b=H3ZMqjtUMGuzlCmQ9P0HO8123gXv/RVKEZ0LXNxzWCGgwGWZtctHBjBRNkh4wmnHLkj4c85EVPuIMFzH9EJ0+MpJLkDCvBLJzpFYu8zbdKMJgS+lbbMcYR7SEhfCghEsyIHEZCsuUhE/Yru0zaGvRTURLvljNBVNEYIDbrd4nkkHtvdS5oqpPlf8xdjUuJguMHwnwjog1wE70zfkEr7KN75YX8Y/irgAQzu0vRy8SAyThDVa6wHX3oNo+UOUH+xl6jzkrTe6sAsytLMAkIzq5SkMjmdope5wrIs2NR8T86bQ6JvK6ZV/dg0aMcCNZCRD1d8+AxxY7OMHbFBR2U10Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUNG2PfERuZig3G1f6JM5w961M8KjHsNvPkwM4BgBaI=;
 b=Qfg6fDPwTHILZNXZU+TArI27Rn7UZwfpxY0bru2XK4tKIqOlj+pDElgABjffcJTstDHVWA/vw0ccmSTakLFQzp0n3zHSawOlH54MxgXLHK2MQfxXLR/Z8vSpNzf6lfGyolhrozFxus3hfT3/4RbIn5uGNYDIJbSajfTkWJffx4U=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4651.namprd10.prod.outlook.com (2603:10b6:806:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 11 May
 2021 14:15:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 14:15:29 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 1/1] qla2xxx: Add EDIF support
Thread-Topic: [PATCH 1/1] qla2xxx: Add EDIF support
Thread-Index: AQHXQ0R6tHUHZbRESkqRLTYlJXu//6reWaYA
Date:   Tue, 11 May 2021 14:15:29 +0000
Message-ID: <1C94A3FE-3373-49AA-9E7F-1E5BCAB00FC2@oracle.com>
References: <20210507132505.14100-1-njavali@marvell.com>
In-Reply-To: <20210507132505.14100-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.6)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01d6c594-142c-4d2d-8c37-08d914873b09
x-ms-traffictypediagnostic: SA2PR10MB4651:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4651A8270C23577E82236C1BE6539@SA2PR10MB4651.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rvzN3Rf70kFupzMh43kPGMtbfVudse5aqnuTolATh1C5w/dNlJmo29j0lmT21yTDkKM1q8fjdkgyjRfeXKDl+iGUQLuvyWq7Ydm4+LCZBho5yucNkHAPZb6SSoGvAPPk0VmfWwthzCaAdgLgjqLoKmRzK48jQiThVUSkGAmfOTsiv513q5azzB2Y5ykojfpkIJD25ccfatgAtSnkHS/dIiDQJA9H6Z6oKgb9lwjGW7O4C/Ydjeq5pwPs1L1sLvD3RnXB1b9W3899Tax+PJLzVIAOH/1iQDO+D/jvAxBZNuMQF4TNAF2nQ6RdznHAWL0SxwvCZacOxS/YjKLU84oXUyyXTFsDREkpRGcCUGsyZ39HvgmISMcCDDsXq7Vfd1otDLTpVfd8C9HzhmL+fpefbXW1zxNuHX4Ha78+UyHKwMAccIZGYIjKiEQ77V3XECwL2+AQIzoIyRXEAGAimgEJrfCPla0SEo+9NFWiPVFTE8WhXeTUqxt/CjG6i7KWTZnzx78DRaHpIa3Xawiz3tlRdC/TNeNJUqAI3URTD8t0nBuOQhVpN8iYqGkQY6iZ1F52LOE8BlV8FiXMBYg9svzhmTc5QDnNWE6/jFC6fx3QuJQQYzL4lg8mT1zF7cXTYi18hMBNRbn05hxVOxDfY7wanw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(33656002)(53546011)(6506007)(2906002)(26005)(66476007)(38100700002)(66556008)(64756008)(76116006)(66946007)(71200400001)(8676002)(66446008)(86362001)(4326008)(36756003)(5660300002)(6916009)(2616005)(4744005)(44832011)(6486002)(83380400001)(8936002)(498600001)(186003)(54906003)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y05hYnlod0NRSDN0bTRmMzdKY2lPUGF0MUx5SUMxVGRKZG9VRHp3SVU2cExl?=
 =?utf-8?B?dmFhMnIwaHU2ZGYwdCtidndJbWp2ZVZPUnlrYWNQMzJBYlJadVZqSTZxbEh6?=
 =?utf-8?B?VDhOTEh5dW9XcWpVb0lOUGYvZjMzQXZab1hlYzFUUXhxZWtIZEZMQk9TRnJC?=
 =?utf-8?B?ODdRYUpoSUo1OTRxSmtJY1BMN0ZkdG9tbU5hWk9sQTBFZGtMMVhnL0lpZHBR?=
 =?utf-8?B?d1AyWGdwQmRwTlJBV3M5MWhSdjFUbnpLUU5meHhFeElxTDMxeElzSG5NK0kz?=
 =?utf-8?B?cGNIVWRkNkFwVWdCQmdqUWRaNXlRYVN2WHJaNlZOZ0RzcjRXZkNNc2ZaWWww?=
 =?utf-8?B?NVdPbVd2NHczQUN5ZWo1UUgremJOMjJWOGc0QW56UDczMVRqeFhRK28zaThF?=
 =?utf-8?B?Qzd1ODNQNXNBNkQvdTQyeTdZeEdzeVVlK0wrWW1LLzlLUklDc0dmYytlTW0x?=
 =?utf-8?B?dTJrcWNLZkxEUUE3aXk2QzlJT2JMaFMrcStaQ3Qxc0VjWmx3TUZQc2lWeERr?=
 =?utf-8?B?ZEJXcndPTm9QM0VaUm9mSGpNdGRuTE9EVVNVam1wMTRvQXltQXNJalBkQzFV?=
 =?utf-8?B?a3NEaDlYOE1tK2JKMWZtSU4vUEFMV1p5VmVhTVpJZE0rR01OaWc1NzljazVG?=
 =?utf-8?B?MnUveUFUWEZ2QTc0UGtoY3p3Q1VnMjY5Y0xSd25kMXBvOWhVZVJqKzkyalFE?=
 =?utf-8?B?bmJ6OHRXNVFmZElVVXNuWXErYzB3QitSK0swWTMrNmZ5SUU0WWwyRU52V3I2?=
 =?utf-8?B?bk96dGVia1AxTjVrdGxFSDFjTXZQdDI3NlltS3ZJSjdVb0JwTHRMZXA2TUpk?=
 =?utf-8?B?NTFFa2dhL2hzSlkxQ2xvNTlTRlRlRTR5cFk4ZVMzYm9paDI0cWNWMGJVajdV?=
 =?utf-8?B?VTNPVFBGYVBTcGpxRDBjMkw5d2ZiMVJDZG9lNCtPUHRRbzNyVzBDcTNoU0U1?=
 =?utf-8?B?dWdvS29pQytsNDZHTXRNME5UMzVpWHlrelp5cUd2SjVMY1o1T1I0UEtRM3BN?=
 =?utf-8?B?K2hhZHFTT0NxdTdBOTRoM3o4S0tEV2MwZFZwU1U0L0ZrN3VjeXp4blJZeEFF?=
 =?utf-8?B?UTJwdXdISDRidHdzMkNxb3Z1RTRscjNhc0ROSEVZamYzS0x0bCttRGJ5Umlk?=
 =?utf-8?B?TGRNWG1vVVJoMDhFN3F4ZmtXWkIzQ3Mra2ZLeXl2Ukh4emVuMkp5ZTVPYWhs?=
 =?utf-8?B?T1I2aDVsb0RRd0VRNDFDb1grVzlaMFVwVTRuMXc4ZmM2N3ZHNk9XVEhmTDYv?=
 =?utf-8?B?UnZ1dE1XOGw4TndrdE5qVGFkTVp5dVdXQlNKMitranU5MW5USUJybVdHYXBm?=
 =?utf-8?B?c252SktmRFpRQmV5b3U5Ung4STkxdWkxZTkzbUlWN3FYWVZabHFiLzQ4NVRl?=
 =?utf-8?B?ZkFMa1NCMmxwb093YXlzeTZGS0hqN1dFVGJVamNINEN1RkNmY3FiZjJOWmx5?=
 =?utf-8?B?anNJWHkzSVpHRUlNYjlTMjBLRXJBdkNKbEpjVWo5VkpDdVFHdlBWdDEvYklE?=
 =?utf-8?B?cXFLUVBkNXJ4d244ZnZ5V3BRQnJwZnhkU3NmMXpTMzNiV1B5eFhVVExVaHFq?=
 =?utf-8?B?a1VtVytkWG1EZTlaazZ6TmQ0OUZUc055d3A5bExpR29WWTk5TmJhRkFiaHVQ?=
 =?utf-8?B?aFJ0anFxK293S2Z2dlRMdVc4dm5zOWdlVFFwckZoRTdTZktiNytHaEtyMFNM?=
 =?utf-8?B?TVFCU1djRmRyRm9ZV0RQR0QxMzNLNzVDTjYrOFhzRlZVRWExdWZ6OTNDeEc0?=
 =?utf-8?Q?9mxW0pTnLr8Fhsyimtr+P7D7B1zs4rSViC6diP6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D58D0C0148990E41B4ADB413C3629820@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d6c594-142c-4d2d-8c37-08d914873b09
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 14:15:29.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXDj9VdeKuJlNjmk+bgt70xb/3gdemWPwYg03h/fqZ1aowR2sGqOuXSuvbIBen2ObNqbtMrU+HGF6iSPgbe87Kg6LTi2ON418w6Tsk31NNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4651
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110109
X-Proofpoint-GUID: QZ6rD26iwV9RH8OtmD_CtNlzcQTsQRuG
X-Proofpoint-ORIG-GUID: QZ6rD26iwV9RH8OtmD_CtNlzcQTsQRuG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTmlsZXNoLCANCg0KPiBPbiBNYXkgNywgMjAyMSwgYXQgODoyNSBBTSwgTmlsZXNoIEphdmFs
aSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gQWRkIEVuY3J5cHRpb24g
Zm9yIERhdGEgSW4gRmxpZ2h0IChFRElGKSBzdXBwb3J0LiBUaGlzIGZlYXR1cmUgYWxsb3dzDQo+
IGRhdGEgb2YgMiBlbmQgcG9pbnRzIHRvIGJlIGVuY3J5cHRlZC4gQSB1c2VyIGFwcGxpY2F0aW9u
IGlzIHJlcXVpcmVkDQo+IHRvIHBsYXkgdGhlIHJvbGUgb2YgYXV0aGVudGljYXRpb24gZm9yIGJv
dGggc2lkZXMuIE9uIGNvbXBsZXRpb24gb2YNCj4gYXV0aGVudGljYXRpb24sIHVzZXIgYXBwIHNo
YWxsIHByb3ZpZGUgYSBzZXQgb2YgVHgvUngga2V5cyBhbmQgc3BpJ3MNCj4gZm9yIEhXIHRvIHBy
b2dyYW0gaW50byB0aGUgc2Vzc2lvbi4NCj4gDQo+IG1vZHByb2JlIHFsYTJ4eHggcWwyeHNlY2Vu
YWJsZT0xDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMYXJyeSBXaXNuZXNraSA8TGFycnkuV2lzbmVz
a2lAbWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IER1YW5lIEdyaWdzYnkgPGR1YW5lLmdy
aWdzYnlAbWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJpY2sgSGlja3N0ZWQgSnIgPHJo
aWNrc3RlZEBtYXJ2ZWxsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFu
QG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1h
cnZlbGwuY29tPg0KDQpXaGlsZSB5b3UgYXJlIGZpeGluZyBrZXJuZWwgdGVzdCByb2JvdCB3YXJu
aW5ncywgSeKAmWxsIGxpa2UgdG8gc2VlIHRoaXMgcGF0Y2ggDQpzcGxpdCBpbnRvIGxvZ2ljYWwg
Y2hhbmdlcy4gSXTigJlzIHZlcnkgaGFyZCB0byByZXZpZXcgNUsgbGluZXMgb2YgY2hhbmdlcyBp
bnRvDQpzaW5nbGUgcGF0Y2guIEFsc28gd2hpbGUgeW91IGFyZSBhdCBpdCwgUGxlYXNlIHByb3Zp
ZGUgZGV0YWlsIGRlc2NyaXB0aW9uIG9mDQp0aGUgZmVhdHVyZSBhbmQgaG93IHVzZXIgd2lsbCB1
c2UgdGhpcyBmZWF0dXJlLiANCg0KLS0NCkhpbWFuc2h1IE1hZGhhbmkJIE9yYWNsZSBMaW51eCBF
bmdpbmVlcmluZw0KDQo=
