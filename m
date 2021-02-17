Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7180C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 14:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA3564E4D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 14:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhBQONq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 09:13:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56000 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhBQONp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 09:13:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HE4tZj005139;
        Wed, 17 Feb 2021 14:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WWJX+JKl58A9M2zjuoeXzTblfNJvZTwPbuyFSdHt6dc=;
 b=hDFeCqfNpQCF0YiaGbwsCNflWMqsp9CpY1BP6hPJdjnrIJ5GFnX2FH2m1au5Pr3/iJ21
 QuRNKuVvkfdepNVVj1XQL2V9YeaVtc0OkX5fIG7w0KulZv8+TvKbBsB9AZ/ysClFBJzv
 /bIMD7197sUGaTHxVbCfbud/VPB0d4bmjw/ih/WQI4f4OplhlGSYk9aHZ4P8gKlz7seB
 7As0WGKXil3YPsU0jzwLBhHf2dRmfSg3gcjj6TIdFjlpYhhoevvwt6ipEIm41sWvdfbe
 CyGwYjk+HINT31xk2Zr2E42ykF2wCd1iWb5Oxus/Y92OjhV1wezUAHI6KMWPYT4D7TT+ dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36p49bange-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:12:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HEA50V102324;
        Wed, 17 Feb 2021 14:12:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 36prpy6btm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5JLUdO4GoxJtJmc1vDdeU0A8cLW2224iQ5zrgpTZoCNt/yZEWHYS7d6zxjQcDLnzrd9f1SgOYjvZOz7imdttzuSwHpsBamWaJVCxQ3UiaU9TnPAedPkyEztySv1HFBmSOPppe5+odMvknOwZqpWfYS4O4p5pV5y/sGmK2iic2V2diHfkTvnidflppB0XJUrmVPBqJKTxa1FJXnnQDyjxhRfsgasqYRrCZRimcGGk7gBd3NgHFsULyM0oDlGEKSjp2HpkHZV1QlttbxurPjGfp/rJk6AAeAjDskWJ7aoJKVlFluajum2S2VokT6z6uSnR8b6kYoFdBlEugZZ7cXteQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWJX+JKl58A9M2zjuoeXzTblfNJvZTwPbuyFSdHt6dc=;
 b=N37rx/1smRoGuKLutZ8odTttgUJYGhRhQ1d69soQnG8nHRRND5ZPBGbzQGe96bcDbNMBpu0s4GKd6rm22zzLliFoC/RPAcCU/3IG37pxzh5trytz+EPttLr4XlDAmbUhlDICIuCYE5HV8hHZRdrCnMPJvAS02vZgmtSuhZfvMyomxnX/BeCbPO+esd8hFNwIkdRkts9aMUpQq2ZR/1PzaHxz6bI5r37y0Xfsj/wqq1j5xAdDI8E5meYMF1sCRZfF6gn83SsRgOSmSCgC6PgyAajYFVWb6R2x/8XmM+CTscZ3Mq2Y5v8FxnD5FYfrb4GOpCBu4m8x4qfSBd12yFMcUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWJX+JKl58A9M2zjuoeXzTblfNJvZTwPbuyFSdHt6dc=;
 b=E7hEaVn2FcKuRHVzFC6FABTvWaNdUoqZ2TTRr0H9lcJiVLlzeuLTQPT2NmYNpW5vgkVyLnXfL8E4L4SL8q4F1pGXgTsKYEv3CJBLAqLXbUyHi0A54U84uSsiUkzfd/5+5sO1dIlXIwYn9MELDqR14P0eUxZCPDE/jZy+SWUbpWg=
Received: from CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6)
 by CO1PR10MB4467.namprd10.prod.outlook.com (2603:10b6:303:90::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Wed, 17 Feb
 2021 14:12:56 +0000
Received: from CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::7c7d:14eb:922c:dadc]) by CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::7c7d:14eb:922c:dadc%5]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 14:12:56 +0000
From:   Gulam Mohamed <gulam.mohamed@oracle.com>
To:     Michael Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3] iscsi: Do Not set param when sock is NULL
Thread-Topic: [PATCH V3] iscsi: Do Not set param when sock is NULL
Thread-Index: AQHW+dKhY8GURPdgkkeBEYA+FYrZzapceXQQ
Date:   Wed, 17 Feb 2021 14:12:56 +0000
Message-ID: <CO1PR10MB45639C515F423B5829CD666798869@CO1PR10MB4563.namprd10.prod.outlook.com>
References: <20210128061753.1206620-1-gulam.mohamed@oracle.com>
 <f8141353-7792-59d7-1f36-f338bb25cf7e@oracle.com>
In-Reply-To: <f8141353-7792-59d7-1f36-f338bb25cf7e@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [49.204.180.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48476f54-e39e-4faa-1d5c-08d8d34e1f85
x-ms-traffictypediagnostic: CO1PR10MB4467:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR10MB44671BDFF3BE1CEAA057589298869@CO1PR10MB4467.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UvHIlrR0CLCJLUG0gIBuC5amx348gPhw2LiPQcI3lRSc1qu3OqMHR1jBCPcWWNJMApqpmJCOgPvxIeZW3CjVgHw4ti9kCPCvaXRhOI7GsvmPhgiTv2Wc1xVIgOyO8Pfvrbb4FETgsSNJoNDWEnTNmBcasjBDpXugowcrdQVAQ2O3PBiWrXuDSoVkGJnyh3rwJL6CT6RY//gm0u/Q8bMC0294+NudtsIBeDvdsWtXUOHFqOqcR8pBynyDzEvZ2U4dN5SJJvChZeS6iK0c0Z7pEn8tpqK7ONN2Mzg0B8+0yQd4gVRV+AJhVgO89httgdp5en5ecb55HVufyZ2ZuqPORBTeXg6LhhJf6RISvTVt6LRgHOsclygDFaYQfPyc1ELNDNaqd/m2pXLp+PMAxqElArRmQt0vnWHXj5Za6IZ2WEUczGqOpn4MiADde2p5sKnGTxfpnNp+FidQNXpaXq63lm2aPqxYUPal8Es4MAM8OpBOh6T0Lyoo0NRpMoDO7O0RSWN7OaqasVUzMdU3jxT7ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4563.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(9686003)(71200400001)(55016002)(33656002)(478600001)(316002)(26005)(76116006)(7696005)(44832011)(110136005)(8936002)(186003)(53546011)(2906002)(83380400001)(6506007)(52536014)(86362001)(5660300002)(64756008)(66476007)(66946007)(66556008)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S1Q1b0w1SWVYU2lJT3ZkNnlFQkNmcDFjOFUyZEZCbXdCMVdReXEzTUQ0RlJX?=
 =?utf-8?B?a3VDbWRsSEdmdGJGVVo4Nk85OUJqUHkrRWNZUHh2MW01andvbVhGeWdTNnBa?=
 =?utf-8?B?TmgzWGFET2NtZERKOXFTTWtVSkRzL25RVXBZaHZpRElobVBPV0lTZERKQjFy?=
 =?utf-8?B?QjVkWi91cTJCSGhsVktzU2RhaG1QQ01ubW5VSVdwSDkraENrRVQ2Ty91aUdY?=
 =?utf-8?B?Q3RFbUhuQkFIZ2pCNEpwUXpxaDM3ODJSMkNDcU1LS3FLN3pOdDBSV2R2OFl6?=
 =?utf-8?B?WTJaOGNuS2k5U0ZscStha2NUWndVR2NuOWpHTXNjbVVzZU9tRUUzN3Uwam1P?=
 =?utf-8?B?bjhseW8vcVoxd0lXZmVQMS9YOVZ0THFlMEcyalp0aCsyWW1rbjB5eENzK1p3?=
 =?utf-8?B?S3FBcGR2ZzFXQ2JsQ0wreVpNTC9wMDNRN2dqaUY4RzBZSnZjazV5S3NkRmc0?=
 =?utf-8?B?UHU2U3RObFB2QUFyMmQrdk1nNDgrWWk3d0llWDh0TVdkQzlldVpHVEFJNWMw?=
 =?utf-8?B?Mm02aEtRWUxycDVGdHUvQ2RHSVd6aVQ5N3Vyd3IwMmsrQURrNGZYTTFSSmhx?=
 =?utf-8?B?S1M0aEg0ZUg3RXhlVlV5czFoa3dWWTVBODR4S1FiK09qNmtDVXlrWUZxZXVR?=
 =?utf-8?B?NUV3UzhwQ2NGSU9hYjJudEFDTUp1TURlaWdLUmkzTHlVTXg0NzNvTzdtN0l5?=
 =?utf-8?B?aUgxQzVKeGJhcjRkbUFaNnVhUjR0Q1lNUFFMOGQvOWhrYkFWY0pRWXlndWJL?=
 =?utf-8?B?WW84VEs0cDNFK2dnUW9FQlhvcDl6RFpJOTZSTXoxZWd6dEtmVk9NQzR0SWxp?=
 =?utf-8?B?RlBIbkhSSGZMd0U3Vy9zelVEZXArUUdaZDdIUlBNMnQwbjhMdHJ0cmp6a2NV?=
 =?utf-8?B?Zkl1SFcvOFNKaHErVGZxbnUrMzEvWDFhNUcrVGNTS2RKaW9HaVR1c2Jkd0dD?=
 =?utf-8?B?anIwNTd5TUdjYisrMmRwNlBBQXNSRVQ5U3RmNlZzbGlzd3pQTHMwbXYzcTBs?=
 =?utf-8?B?YnRtTnNuTjFYYUxGTUx2WnM0R1psUHpPU0kxK2xjWEZxRTZsY002YXJxbDUr?=
 =?utf-8?B?NVF1dXBKWmJNUDZ6UnJZd2t0b1N4TjR1c21IMHlNZmRRYmp1V0RhODI0a2JF?=
 =?utf-8?B?bWplR2xOZzZ1KzErYUVFNEdhTnNKWG1YdzVJNmlYejcwdTVydEUvSEIvNEh6?=
 =?utf-8?B?eExjRkR4Mm9kenF1ekhRY3NhQW1wbUI0M3RhV2pFOUsrMldkL05zTmYyNHpl?=
 =?utf-8?B?dmIyWjg5Y01yTkJla2UrRURwRmsxdTRoLzloOWRIZHhPb1krMitUQUNlRzBP?=
 =?utf-8?B?T050REVhN29hWHpHamhjamdvZDJhQ2FsclBCM0dzVlVuQkZCbHVLbnVkZDIv?=
 =?utf-8?B?OGVmZmE1NlRZbG92a0lrMUlEekpjZ3hXNzVqMFRmMnBERnlmMVlac2JHdzlZ?=
 =?utf-8?B?NGtHVWIxK281MWEwQnhrNU1IMXRqcEZPZnlTL0k5TGlDS2Z1MC9Dcm1FaS9T?=
 =?utf-8?B?NUNNVlQ5RE5mYjRZVDVVM0hiMlZ6a282YlpYOW5USTlranNjTWJQL25qdEpF?=
 =?utf-8?B?aUF6ejBnRHJ1eVozVU1LSmhmbyt4c3hIcXRxdFA2TEJLUk5HcWhGYUtyVTRZ?=
 =?utf-8?B?OWYyMW1lWGROaFRzN3pweWc0bTdPWTZCMXVsaXJOS2ErNWcrQjA3bVAyUzdp?=
 =?utf-8?B?R2JGU0ZmOVdJcEYwazBFL2VZbWxxMEZZcDI4aCtubEZuRTFrMHJKSXNOR1lo?=
 =?utf-8?Q?y+jfp2sqfZ3lkarhJmooeomlOh3QicPQ9phgAlp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4563.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48476f54-e39e-4faa-1d5c-08d8d34e1f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 14:12:56.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zNOsC8yklVgyp1goaAqfTDDoq4mI34cu0vsFUxMNB2XohT8xsdzJRZumJVnrthDUZ2k+KIU31GldnfBEcwjTT6OCs/5DTMWsyHeDWhph17s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4467
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170110
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWljaGFlbCwNCg0KICAgICAgICBSZWdhcmRpbmcgIiBBbHNvIHRoZXJlIG1pZ2h0IGJlIHRo
ZSBjYXNlIHdoZXJlIGEgdG9vbCBzZXRzIGEgdmFsdWUgdGhlbiBmb3JjZXMgYSByZWxvZ2luIGFu
ZCB0aGUgbmV3IHZhbHVlIHdvdWxkIGdldCB1c2VkIGZvciBzb21lIGRyaXZlcnMuIiBpbiB5b3Vy
IGJlbG93IG1haWwsIEkgd2FzIHRyeWluZyB0byB1bmRlcnN0YW5kIHRoaXMuIENhbiB5b3UgcGxl
YXNlIGdpdmUgbWUgYW4gZXhhbXBsZT8gSXQgd2lsbCBoZWxwIG1lIHRvIHVuZGVyc3RhbmQgY2xl
YXJseS4NCg0KUmVnYXJkcywNCkd1bGFtIE1vaGFtZWQuDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBNaWNoYWVsIENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5j
b20+IA0KU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAzLCAyMDIxIDc6NDcgQU0NClRvOiBHdWxh
bSBNb2hhbWVkIDxndWxhbS5tb2hhbWVkQG9yYWNsZS5jb20+OyBsZHVuY2FuQHN1c2UuY29tOyBj
bGVlY2hAcmVkaGF0LmNvbTsgTWFydGluIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xl
LmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIFYz
XSBpc2NzaTogRG8gTm90IHNldCBwYXJhbSB3aGVuIHNvY2sgaXMgTlVMTA0KDQpPbiAxLzI4LzIx
IDEyOjE3IEFNLCBHdWxhbSBNb2hhbWVkIHdyb3RlOg0KPiBEZXNjcmlwdGlvbg0KPiA9PT09PT09
PT09PQ0KPiAxLiBUaGlzIEtlcm5lbCBwYW5pYyBjb3VsZCBiZSBkdWUgdG8gYSB0aW1pbmcgaXNz
dWUgd2hlbiB0aGVyZSBpcyBhIHJhY2UNCj4gICAgYmV0d2VlbiB0aGUgc3luYyB0aHJlYWQgYW5k
IHRoZSBpbml0aWF0b3Igd2FzIHByb2Nlc3Npbmcgb2YgYSBsb2dpbiANCj4gcg0KDQpIZXksDQoN
ClNvcnJ5LiBXaGVuIEkgaGFkIHNhaWQgdGhhdCB3ZSB3YW50IHRvIGxpbWl0IHRoZSB3aWR0aCwg
SSBkaWRuJ3QgbWVhbiB0aGF0IGl0IHNob3VsZCBzcGxpdCB3b3JkcyBsaWtlIGFib3ZlLg0KDQo+
ICAJZGVmYXVsdDoNCj4gKwkJaWYgKGNvbm4tPnN0YXRlICE9IElTQ1NJX0NPTk5fQk9VTkQpDQo+
ICsJCQlyZXR1cm4gLUVOT1RDT05OOw0KDQpIb3cgYWJvdXQgbWFraW5nIHRoaXMgYSBjaGVjayBm
b3IgQk9VTkQgb3IgVVA/IFNvbWUgb2YgdGhlIHNldHRpbmdzLCBsaWtlIHRoZSBUTUYgcmVsYXRl
ZCBvbmVzLCBjYW4gYmUgc2V0IGFmdGVyIHRoZSBjb25uIGlzIGNvbm5lY3RlZC4gb3Blbi1pc2Nz
aSBkb2Vzbid0IHN1cHBvcnQgaXQsIGJ1dCBtYXliZSBvdGhlciB0b29scyBkby4gQWxzbyB0aGVy
ZSBtaWdodCBiZSB0aGUgY2FzZSB3aGVyZSBhIHRvb2wgc2V0cyBhIHZhbHVlIHRoZW4gZm9yY2Vz
IGEgcmVsb2dpbiBhbmQgdGhlIG5ldyB2YWx1ZSB3b3VsZCBnZXQgdXNlZCBmb3Igc29tZSBkcml2
ZXJzLg0K
