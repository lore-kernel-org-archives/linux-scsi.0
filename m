Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F0BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946D364E86
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 17:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhCQRhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:37:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49386 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhCQRhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 13:37:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HHY1it053902;
        Wed, 17 Mar 2021 17:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Vmg5FpLAu6FLTwREBBOFUSFdYYzMyRQqaMwaK5o6uz4=;
 b=SO+gXe+kKX+lAEnm/rP5uFBA/1VreNjnq7Y3oJ+/ECJj6KN7xQb+v0exV08uqBMcdsC1
 Dd76weNgkyTGonXNSDWCy+1vCWd7DZMN8nMTLlRSN50CphFpk/ea/gKG9C362iPCw82k
 g8zG1LZtgcznmNTlOlQxvOwL/RRv6pMn1k8sPC0lRSP/GqEHGrr54ElAVpEcwlqGxmk2
 xes7lvoOuWV5QbbjGwhES77rdHM6ghu+n5VIiFLAMAlc2DEQyrFZe0mKArwbylJHv7Tb
 5/ul7m6kGTdixczxVVcK5DreuPn9A5qKS+XPo1VdEeVTGgS35/WXOjtIL+01OBm0ZjgF BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 378jwbn16g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 17:37:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HHYj4S100295;
        Wed, 17 Mar 2021 17:37:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3796yv4kvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 17:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI8PbkwBMOmQ1XMkgYQS3eIspuy3qH88EuD6qcWbK59w6NRdCKLqXnK0uyWYTskdjqOcLCWUXNpxZaB4tfzymj0/k65MMzOqQsffw0ZMJEoQ40GogW55mGVKWAiy6rajDzJagLFeg1x4WyIUwfW1SLEO7CnEQ3mWFjDAeKWfZjwjDnBi679wxu9X16VxFsOmIpTE+Yf2NizcUCrWdqZbu3CTP+iCeiuN6vjbEEt7bW8uVdaaFML1opy1HnLn1R2Qqio0oYgJBXUUHKKHXw3Qc9Ihk5T2FyV2Yo/dqWllehtXNVCktn9O5m6p5Z6o/o/moJ5T4RWhv9FsGygcJlHBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmg5FpLAu6FLTwREBBOFUSFdYYzMyRQqaMwaK5o6uz4=;
 b=iCQ6JBLT9IsTcLbW2pyn/MlSlPFVOqSAvp1qXDR5jWDmGt+/X8pAuGxRL3OVJ5KiItniKjn6QM+BBo+8YMD0zWTgfH/CG/l2OtCaHgHqe02ZD3I1HbGN47CMu0cUIP0UDhUH1LS9PwzDAmEZD6FPun5dxr3DNkOBU/cvvwTQDWRt2paa8JmOoL3U6Tled5h5dkMyze4pcKIubUV2U2wN0Xg52KJTTd29f2VuFXK8qbGE5t8UEuwy+UMaMeB/3uYOso+tdkhUdh8akVKoQLlYLVQCorOX16LFOgWTyia9w5RHjlktZhKuywe0jkEmrpbUCQFvmCwo5tnFMgqhxARRoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vmg5FpLAu6FLTwREBBOFUSFdYYzMyRQqaMwaK5o6uz4=;
 b=zbPUhXqPfJc+OeECoOkT7ldThA4RKngoBxUQgKFjGJe4KapgjUJiUPaoLU7ONYNfsQuGpDyyMbeTd0bH5UW/htbbMVGJg5tBQVZi5viH6Vk53uVM+yboPls9FI8utjj7uDvlMJSne+clHwYEVTV+CfuMsbRyMWBklRGR65GEd1g=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 17:37:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:37:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
Thread-Topic: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
Thread-Index: AQHXGhhv+4Y3gXBOHUGR8Dvotigd1KqGzdeAgABD4oCAAWKEgA==
Date:   Wed, 17 Mar 2021 17:37:36 +0000
Message-ID: <A3AAE51E-4152-456E-9EE4-A457B7A1CD9C@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
 <8EE7F726-C6BA-417B-BD68-5B2FDE5F74FC@oracle.com>
 <b39b0088-6cc6-36b3-8ca7-b4d49209ffbb@acm.org>
In-Reply-To: <b39b0088-6cc6-36b3-8ca7-b4d49209ffbb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d025352-1364-4cb7-a885-08d8e96b5a76
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4732F602656DEBFEF0CB07A5E66A9@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ohDA+jI9KMHmDxBTxB2U8xOivm3jOiooZ6KdqO1EtPSBp9k63XOD3ZmD58cO1jqP1ugQAR71dkUJ+Fcd5VdjS2aO3KV1AxXa2xcnhzdXi1TtJ2NzD2ycQiakiA/o1j0ZxHRMnlaq7VLR2mVLVAYgAXcRIiea9IMFuYFkCWAhXk3zabe75FUE1Z4k9ZcELkXka0DO/fvRyd/eV4Z4+6ehoi2PDTP2rBqXyIlwMRA52G7NA2xAE06ZojupN2gupV30sqEtd88/a7iGRUN8/IDjBparDsUljMv8et+3PLCA1HbkaWFuu3sBMc76cj4qjK+TlDS0wVNlKY2P6kVWJQJwntw+1dE1Hh4XtAwXgcv5vtZDp7hB8x8Qllciz0SnUPIwgPpjSJcFnK59k+/n0bPpQUrZdLk8ADxASnWDel/m9M5FjO++cPibOelp22ULKeRv7sVuDgnxLuqldAig3bDBDKD0BL807QFhGZQqyYydBatcenjMdWRuCiwlFV913tE1F0cQ9mXiQy/4eFS17FhrbpUh+6KIWz1OkdKAV1P3wDSVOyQFhKaT7jn4gP5GhsmI6ait9rqwTtAScmH9TaCWPfwVD2pK3YbO4e8c8lgnuNULTNbJaB5+/WcugjT12l05
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(5660300002)(4744005)(53546011)(2906002)(8936002)(6512007)(6506007)(4326008)(71200400001)(76116006)(91956017)(33656002)(36756003)(66476007)(6916009)(8676002)(66446008)(64756008)(316002)(66946007)(66556008)(26005)(6486002)(54906003)(186003)(86362001)(44832011)(2616005)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z1RWS3dLZFpaV0ltWGszSWIvdHlJY3Y2MGR5R2I3UU9tU2hmazZBdFJabVdt?=
 =?utf-8?B?cGs1OG5DSEQwZ2FBTERuWGFMZ1hVbUVXaEpFbXg4RW90QVpJUzFMZmxua3Fs?=
 =?utf-8?B?aUw1TmVRRE83RWxkRmlBSFZaTkp5dk1FSGRySytKSFQzbmM2YTNSaytBUStJ?=
 =?utf-8?B?NUJIZ1FKdjBuZ3R3Yk1QOThTbUpaRDBxTkp0QlVzVWZ6YmVHbTVWNGJUVkds?=
 =?utf-8?B?MVZsU2lycHZyeU44STA0cGx4NDlpK0ZMRnFDMW1KNGliRC8yUzBvUnRJalIx?=
 =?utf-8?B?OERqWWsyd0pNMUgwUjlVdTJ5UXByTTFpVE9zVDJiclBYcTdZYzdiYmhZQnQx?=
 =?utf-8?B?Ymt1VmxlSTU3cmlnOHNEVmR0YkFxRCt1TmJWWEVnbjlPbDBlRGdVc2V3Ky9m?=
 =?utf-8?B?S1l3elRDczJUQ2dtUkRseFBXbG9wZE92WDMySEdQTTZHYStwYWV4NjJVdm1k?=
 =?utf-8?B?WWV2RGZta2loaGlLanN3L2RLUy92UGVmVHJrK25FaEFqUWVXOGpzbzJDVkN5?=
 =?utf-8?B?d2h2ZUlSRlRNQ2RRYVlaL1pld0VUODVEUytUb1Z3Wk1xZGQ0Y002VWs1UnVa?=
 =?utf-8?B?bkhxQ2thcUZkZlFwM0FhZ3pENFFLZXkzYitCL2kyS0RncThkbm1xMlVLejMr?=
 =?utf-8?B?Umt6Ulk1TU5vdEh0YzRCaXJibnRaS0dkNDJiSDNlL2ZzaWxhTFRxbXFJUFF1?=
 =?utf-8?B?OWRTQ3ZYdlI5YU9lVmZISmpBbDNUeG1wanFhSk4vbUNyQURKMnFiMHYycEVr?=
 =?utf-8?B?NzlzdVB3ZHlGdlZMVERlNnR4VnBWT2xQcDlRK2h2VDRGQ2dIeWFEWFRHVHZG?=
 =?utf-8?B?M3ovWDhqajZpeUI5Q29uZ3VhZ0IxeVRQRGNKamJwKzR1eTlybzJkTDdXaEo4?=
 =?utf-8?B?bnhxNHErUDl5WWk4RXBSOW8rVXJIS2trOFBSVXYvUnkvaDJzRFlLR3VOZ0JF?=
 =?utf-8?B?aS9CcXkxdmpFaWNWdE9DTHZZcGhneU4vK3A0UnNPNDZIaTJuS0FtZ1V3WHBk?=
 =?utf-8?B?TEtycExXcG83MjVjZVVHVkYrYUtOWG5YTGhqWE1RVGFjdDIwellMbVZvb0pz?=
 =?utf-8?B?WTg1bzJsejB3VmxEU0tCMDFBdkNueFkvcEpnRjhxOFJ0WDI5Ujl6Umkwd0hs?=
 =?utf-8?B?TUVYZU5xS3g5a00xSGR3b3lqeURISTIyemdzS1ZOODlXRnFFTUdydGNROFRV?=
 =?utf-8?B?bmdtaGV4aDlBdkpPcThwOTl6Y0VOSnRxd3lpK3k1K0VQVUVpZUNIZ3l5Y2Zx?=
 =?utf-8?B?RGdveDgvK0xoUVFPVFkzUzA3NmRUd3RXSUNISzZBejllL3NWZlJmcjlBOE9o?=
 =?utf-8?B?ak5nc1RSTmxtNnJla2hUUllaYWN4SlY3RkVoVWVCbWlHRVFJUmtqeW55dE8x?=
 =?utf-8?B?M3FFaU1NK1ltQVpoc2xCNi9MNnEwd1JabEI0U2p1bEczRHVpdjRrbSswdTZ4?=
 =?utf-8?B?aW44MXRIaGZVWVk4dXVlTnpkdk1YYURaazNtWDZYR3BiVGorKzRlb0d1Z3pV?=
 =?utf-8?B?ajZyc1F1VHp5bU5DWTViajZmZDdZL1J5RVFOK2QwTGFSM0Q0NzlqYk9NeHFI?=
 =?utf-8?B?NWpVVU45T0J5TGJZT3hVcm1Pc0dyMlJneENZT21YaU9Wc1NsbWNiYTRTSEJW?=
 =?utf-8?B?eUlQOWNHWUlwa3kzNUwxR3V3MFQzTGFhOVYra1BWME4xdk41RzJoR3M5WmtZ?=
 =?utf-8?B?VmRuUVBKNkZQQ2IyMjRBRm41UjZjeGo5bTNGRzZYZnplRUFSUTJ1eVJVckRp?=
 =?utf-8?B?TjdMbWJTKzlTK2xUcnVNS3h6ZjJLa2VRc0xHS0JYcUczZkJOOExJVks1Z21t?=
 =?utf-8?B?b2tzdnNnT1B2UFc4ekw5Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5C16B18A5FDC44A9D4601302DF63E8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d025352-1364-4cb7-a885-08d8e96b5a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 17:37:36.0963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdCagULcA+HDssrq+D9LKuC1oXWs6S+8T/Lbkn2wdOKmqNH1J9A+Ajk5m+hsvSkPrCcj9BegrZTW1ZuDC5c9qDE9IXO3RflcgP3VCX8DBRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170120
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gTWFyIDE2LCAyMDIxLCBhdCAzOjI4IFBNLCBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiAzLzE2LzIxIDk6MjUgQU0sIEhpbWFuc2h1
IE1hZGhhbmkgd3JvdGU6DQo+PiBDdXJpb3VzIOKApi4gV2hhdCB0cmlnZ2VyZWQgdGhpcyByZXZl
cnQ/IENhbiB5b3Ugc2hhcmUgeW91ciBtb3RpdmF0aW9uIGZvciB0aGlzIHJldmVydC4NCj4gDQo+
IEhpIEhpbWFuc2h1LA0KPiANCj4gSXQgaGFzIGJlZW4gb2JzZXJ2ZWQgdGhhdCB0aGUgZm9sbG93
aW5nIHNjZW5hcmlvIHRyaWdnZXJzIGEga2VybmVsIGNyYXNoOg0KPiAtIHFsdF94bWl0X3Jlc3Bv
bnNlKCkgY2FsbHMgcWx0X2NoZWNrX3Jlc2VydmVfZnJlZV9yZXEoKS4NCj4gLSBxbHRfY2hlY2tf
cmVzZXJ2ZV9mcmVlX3JlcSgpIHJldHVybnMgLUVBR0FJTi4NCj4gLSBxbHRfeG1pdF9yZXNwb25z
ZSgpIGNhbGxzIHZoYS0+aHctPnRndC50Z3Rfb3BzLT5mcmVlX2NtZChjbWQpLg0KPiAtIHRyYW5z
cG9ydF9oYW5kbGVfcXVldWVfZnVsbCgpIHRyaWVzIHRvIHJldHJhbnNtaXQgdGhlIHJlc3BvbnNl
Lg0KPiANCj4gSSB3aWxsIGFkZCB0aGlzIGluZm9ybWF0aW9uIHRvIHRoZSBwYXRjaCBkZXNjcmlw
dGlvbi4NCj4gDQo+IEJhcnQuDQoNClRoYW5rcywgb25jZSB5b3UgYWRkIG1vcmUgaW5mb3JtYXRp
b24gdG8gdGhlIHBhdGNoLCB5b3UgY2FuIGFkZCBteSBSLUINCg0K4oCUDQpIaW1hbnNodSBNYWRo
YW5pCSBPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCg0K
