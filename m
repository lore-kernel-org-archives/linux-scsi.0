Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C93C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiBISrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiBISqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:46:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6D2C0F86A8
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:44:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HJqIu013540;
        Wed, 9 Feb 2022 18:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Z1+sN4x8wKzHWVgSG++xDEk96GYBue8hQutl+ySczeY=;
 b=JIiRVK1aCtZJPIZ/V/HDUr1IgjexYw/w/JcmPqcIgJfdcS7bZga5VTnxcdyPC46IxRXM
 0c4HcwKh8bGttkw9Gkocfme36MEY5eKMxxQok3+0/SLV/cpw8/Z4GLi0TilSLAxDXuqG
 01Tv1Np30I3Ja2b/7jMNgEwfV53Wd7Jw6QePXL/bXv23ci397TtCfFYDeJmU+Xr+KF5c
 gFYqUhcbzzi+KVmpCFth4ejBA0Ta61aLhJK4w/I0OrxnGlGXfHENTYHvWxbKmUxlQyaD
 ICv5xwolfSPt9/apcVTFmlCoxxFnrvV1YXMO+55RbErlO+Hcq17vuD3ZxhuaDMjp4mMW WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sqd80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:44:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IQIZW058839;
        Wed, 9 Feb 2022 18:43:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3e1jptjb0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:43:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc0G5d95+47HlW/uGTiBRQrkmudDeGutzzHYM7ZXY+wqIkMv81tj0w0FNe3Um7dHdNzWSqs8tjFGo4MGOxPPs9p89gr4rZvvUfjYYa/+HM17jG0PomUVo+6mr8oZ+FQ6EWPPCDadim5jd+rZIeNJSwDwH8rQbm4fEgUyp9ddAED+92OMPeooqzfCALim3O82iyh1WC1O2HSM67Z7S/NQii/JXAVaEXOQXW9gorZbTDxjk9aKODI4gS40AUgRZ+6IC3cBVm5XFfwRUY8rCsGN+aYEFNV4pRbrfNBGFcwq/FHEc2uVnSQUMUUaTYNyw53dixGKcyiM7wLaDb1QPM+1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1+sN4x8wKzHWVgSG++xDEk96GYBue8hQutl+ySczeY=;
 b=bDTxoKQZLTKrp7EUiIIAlczOyubhHmERjTViz/OqC6fHccB61Up1A2o9/yLhlfjr3NASCmdC/JmCH3F89G4v4eVZQKJSDz4Lz5LRvnEry8s6t+CA9rAQicZiLenl6fLe3FJJYZ2SuRi2QqU4dzW+evb5NyCmiU1RroujpAMY1T9i82HzUGv1F5NErFFsB+aWOtAR7ZTmbLHctIQlDbzdyZ+EWSXwBi0MKB3c9PuoJdYT7zCLUplEz7o5Obra7im4ub3R5NEzoFv/R8rLg1MBQzIPb0m/eqomyxIX3qLw8cKId0rW4m+k64YMtqhaOiYd6zX5IZwPw7bzk5X0HhVGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1+sN4x8wKzHWVgSG++xDEk96GYBue8hQutl+ySczeY=;
 b=ccQIUXVkSsqqxBhHQnZStMFaLPZLhCnKMYjBi3vE8dkexQiivt4uVU8KXmVBkevxDw2WwzcYoJNSEXwQU8vTC9ePlPkrCvdzYOesU9PZfuM97dk9mRp+MfFPEWQGHnsmCvXQw3MswK8tn1hCPotC7nnM+nUwUbmT09YF9Fgk1Gk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5288.namprd10.prod.outlook.com (2603:10b6:408:12c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:43:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:43:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
Thread-Topic: [PATCH v2 30/44] mvsas: Fix a set-but-not-used warning
Thread-Index: AQHYHRE44s89AUAkFEqUv0tEdrt4/KyLj9cA
Date:   Wed, 9 Feb 2022 18:43:55 +0000
Message-ID: <3AC014A8-AC3A-4391-9082-3FFDE1D91838@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-31-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-31-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e01fc40a-84b8-4192-33da-08d9ebfc2007
x-ms-traffictypediagnostic: BN0PR10MB5288:EE_
x-microsoft-antispam-prvs: <BN0PR10MB528809FB6168823876F6D6BFE62E9@BN0PR10MB5288.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0w/kuTIz17yHeCQ9dlww90tkTzv05bK/dUuoKvnBSZgDgCudLoByDi6yMa2BUP6UsGqnlvxywE1NwS62QS3STlX0FMeSMX+76sRKDimBL4dZ8oSD9vz9jC78kHICtDLa4paRoU1FJcmA+iegpKuXtPWess/fD7a+M5TeGcvvK70c9ROYoJ4+oY/nTyZatxUn+oBEmk3tNQvtI/8Dvfgb/VReaLHh9xXVcOq5ZezlL6ajWUbKa4ZDGeWP06XXadaQNt66VicM6uPidSt4ejQoO+evWHTg2WgSKpj7tk/nAimEpYkAtcYXDDEo2mTS/YmcYQL3YRrJAWAs/4UDuHg2jS1RPrRgavTMDF24vldTlRsA+oDTg/xT/GF5dG1Z5Gz2QlPI9PXJclDjQH5dzGeEOe16g/+K/xiXuN2ab+bi6kM5hCzz/M95GAp9/xZ6AhXg+bril9K0qgFu0BkAMrICScFMovuUhsKc3pI9EMKZnpc0uaJm0KEyEKR3zY2pvTGb51/Ndug9mD/17/gdqebe6cq3YJH/G4GOOxqpmqDiLeeMEXlb0QpEZYAYCzbuSWT2YrwtxiSw+4uygdJpunpxr1UlhAHWzzFnpt6O9mxAjFbD7tfytccHGQemAeUlSvWJtY+bXahun9JsYLSki2+At6AoAY+pNdCeGRPWR6XXgqa7talJc2PLlC867tnXopmERzjh1kgR3wCFMERZK9Iu/izOixHZfDaz5Ro1JPt4jGH+8Jkm91imQRzpFgg/FnXt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(38070700005)(6486002)(83380400001)(54906003)(76116006)(6916009)(316002)(122000001)(33656002)(2906002)(186003)(2616005)(44832011)(86362001)(6512007)(66476007)(508600001)(71200400001)(5660300002)(38100700002)(64756008)(36756003)(53546011)(8676002)(8936002)(6506007)(66556008)(66446008)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVJpQjRKTytqSWtwQnhBUlZnMVdWL29neHUyZjZMY1pRd0hoaWx4UVJvSzRB?=
 =?utf-8?B?Vzdsbll3UFJyWVJlek1ObVNzNnMvQmgyR2ptbWJpeFBJSXBIQi8wWUlGZVFE?=
 =?utf-8?B?WmVCdXVXNkhrYzM3eTlIZkcyMjR0aGQvS1FXaG1YK1VVK1RSM2lVRlFDdks4?=
 =?utf-8?B?Z1F3anpzTDRlMVhDWDdGRHpUNzZKakIrRDdWM2FYa0JWVXlYNE4vKzN1NlNl?=
 =?utf-8?B?N0p3MlpVdmJkNGFMaS92M2R1THJwNStiLzllYXdHNU9FdGhKQnJTN1JQbDdQ?=
 =?utf-8?B?TW5WZHBDdU45QzBHeEFpbnBKNC9lNnBDajJ3SnA3bDRNbVNFMDd2YmV0ckdG?=
 =?utf-8?B?K3VFb1NobWsxTUZsQnZPaExqSm5BY2p6aFQ5dFdmbURaM2xPanBpdkZmdXF2?=
 =?utf-8?B?Ly90MTZMdWkyOCt2dW5TZXhMWDN2djBrVE1KaG10Sy9SSnJYbTlKQndMN055?=
 =?utf-8?B?TUNVRnlzb0JNTVFFTkU5eUdDUndPS2taZ3RkM0h3VGhpbUtCRXRWZFlsL0hX?=
 =?utf-8?B?QUFmNHJqZDlybDI4K2ZmdU5HbVUzc2F5Smk2YVdTd1oxb3VMWG1jclZMS3FR?=
 =?utf-8?B?OGQvb0hWc08yOVF1dzJTc3l4MWdpcm92Sk9rTFJMeVc3SEpka0g2ZXN4M1lU?=
 =?utf-8?B?OUZuVnFZTlFab2Z1Zm95MC9RNTJDQnBsVUZwOHRCcWJ3Y2dUdGZ4UkpSZTFM?=
 =?utf-8?B?NWZuZWdNNDgweHhxS3gxNlBRdEFhWkRtb2s2S2E4anVGSTVwRUNCUDRONTBD?=
 =?utf-8?B?OEo1LzhOa0h3R1lvZ0JydGpMT2diUnlPelUxRitnT1R2NlV2ZTNHYys5RTho?=
 =?utf-8?B?RXExRTBXSEtWcTdTaXdvRlo1ZytTRHZ3QlNQWXBlaW5TdXMycmNTYXVMbzkz?=
 =?utf-8?B?cC9Jamx5eG1zU3VuRjV5dEQ1M2pjVGxHbG5DcXNOU3Z3MGNCQWFReHljcUFq?=
 =?utf-8?B?Nm9FemQvR2lub1lsaEJvV1I3WmNaMGJrZGNUL21NdEZkcGpRRkszcjZGMXBZ?=
 =?utf-8?B?ZEc4OGpka1JJOGgvOW9JZVlpVEdJOUtaR2xxMkd0ZXY0SXBQRmtxS2R4ejFU?=
 =?utf-8?B?ajdIUllWUG5vVTUrdyszdHVHMWF1TmRzUEcvRXFYRk5wSjZRRk5ZVUpCajFa?=
 =?utf-8?B?a0hadURFSndxUm9rRE1UWDNtRW44akpMU1haOHdxOUZneDVhUmJLQ21SWUx6?=
 =?utf-8?B?Z3NoditwYmVSS0hFcm9zb2hTU29rczBWaFdUV24vWEtmRXhHTGxsNmVBcnNI?=
 =?utf-8?B?SE5Edjg5VjFkbVlkdTFmMWp3VUVYQ1JnaEtDeVZha0tRM21OM21FSTRMQmUw?=
 =?utf-8?B?dU02V3VQM0xKV1h0bFJLN2hsTkNic25UdHNyQWt5ZjRKSElQUWIxUjRlQWw3?=
 =?utf-8?B?TGcxblJ3eW1nVjVUR3pKdmczTXlvNkJmWEtBa21ldVFOVTZreVFpMFlJeXNx?=
 =?utf-8?B?NEpzZ0NBN1MvZnExY2o0WVpMejdHSHNNL0RPSkxLV3kvZExyeHRZbHU2NVox?=
 =?utf-8?B?T2xZT01NUlpDZmZLYmM0NnhMUUoyamVRU0MxTE9wYTlqRCtrb3dMbG5HaVVK?=
 =?utf-8?B?bCtxVzZMekREZ3cwSHU1ZFFDczlXUXk4TUhBWjRkNTh6U0Zkd1BqcmxyNVhj?=
 =?utf-8?B?c3Z6MlJxdnFmKzNZVzJXYk1mcVJQRUpycEpGTWRqRjBrL3dkMHZBVTg3T0N2?=
 =?utf-8?B?emV0bGNzbDhzbXBhTUhMMjRtRjBGMGFXZUcvOUNuWnpNWVB5NjEwVWlaQ3Fx?=
 =?utf-8?B?a0MxR2NxVy9iUU03S3VsMTF1b296amZMd2o3a2ZPUVB5VmF2T3ZlSVQ2U1o3?=
 =?utf-8?B?ek0xV3Y0ekdxeUZkUHZ3aXMvd3RlbDdYdGovZkVJSVUxUEJmMHRNZkU5TG9K?=
 =?utf-8?B?dGc3b00rMGdHbkR5M1UweFdEQVlVOGZ0QnRsWm5sOHY1ZTIzRXBhOVpMNEhy?=
 =?utf-8?B?b2M0M1lqb3ljV2wyRzd4SmthSEYrUlJNYlZhRmZmZGhHTm4wcGhvQ1QyYU1q?=
 =?utf-8?B?NFZvZzBzY1l5UjYvZEh1SmVXM3Q3NmF0M3N0YnF3emdiMTZUcmhwT041UDhE?=
 =?utf-8?B?eXdqaFVKWmJobGZRSGhCZWNGMURaeWZ1Q3c2cDFxTFR3WDRVWlZDbnVBOGJ5?=
 =?utf-8?B?cVJIbjhIUGJxMEo1RUhJVFpUZmxkUSs2S3NBemVNejZWT0hodDJGb0ZMMUJV?=
 =?utf-8?B?Ukt0K0RGa1J5YnlPeUtPM3MwSzFuQjJ6bUdmTnl1MHkyVk1ZN1orMDdXMDNL?=
 =?utf-8?B?YWppYkJ1cWNGcnhQUVRwTjF5c2tEVTBObkptUVI3ZHpJSUdMMndudUZuU05N?=
 =?utf-8?Q?YsYNOqNaOgC6KBGf8Z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98E15F69B96AC14CAED4131CC19C4E42@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01fc40a-84b8-4192-33da-08d9ebfc2007
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:43:55.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHQ49Vlw4RT/S8q4ANZi2YHij6zTB26LUp4X51kbVuZ8q9yYCAdCBTLdhETCg4QiseNl08zJRrBYgD6XH82amOnTuLgVlUcrw4mmTTkuRzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5288
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: S9EJN4_1eUXtZQXFeYHEDm5ldliClno_
X-Proofpoint-ORIG-GUID: S9EJN4_1eUXtZQXFeYHEDm5ldliClno_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gRmViIDgsIDIwMjIsIGF0IDk6MjUgQU0sIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFz
c2NoZUBhY20ub3JnPiB3cm90ZToNCj4gDQo+IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGZvbGxvd2lu
ZyBjb21waWxlciB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9zY3NpL212c2FzL212X2luaXQuYzog
SW4gZnVuY3Rpb24g4oCYbXZzX3BjaV9pbml04oCZOg0KPiBkcml2ZXJzL3Njc2kvbXZzYXMvbXZf
aW5pdC5jOjQ5NzozMDogd2FybmluZzogdmFyaWFibGUg4oCYbXBp4oCZIHNldCBidXQgbm90IHVz
ZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+ICA0OTcgfCAgICAgICAgIHN0cnVjdCBt
dnNfcHJ2X2luZm8gKm1waTsNCj4gICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+DQo+IA0KPiBSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVt
c2hpcm5Ad2RjLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNz
Y2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvbXZzYXMvbXZfaW5pdC5jIHwgNyAr
KysrKy0tDQo+IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL212c2FzL212X2luaXQuYyBiL2RyaXZl
cnMvc2NzaS9tdnNhcy9tdl9pbml0LmMNCj4gaW5kZXggZGNhZTJkNDQ2NGY5Li5kODJiMzEyOTEx
OWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMNCj4gKysrIGIv
ZHJpdmVycy9zY3NpL212c2FzL212X2luaXQuYw0KPiBAQCAtNDk0LDcgKzQ5NCw2IEBAIHN0YXRp
YyBpbnQgbXZzX3BjaV9pbml0KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNp
X2RldmljZV9pZCAqZW50KQ0KPiB7DQo+IAl1bnNpZ25lZCBpbnQgcmMsIG5ob3N0ID0gMDsNCj4g
CXN0cnVjdCBtdnNfaW5mbyAqbXZpOw0KPiAtCXN0cnVjdCBtdnNfcHJ2X2luZm8gKm1waTsNCj4g
CWlycV9oYW5kbGVyX3QgaXJxX2hhbmRsZXIgPSBtdnNfaW50ZXJydXB0Ow0KPiAJc3RydWN0IFNj
c2lfSG9zdCAqc2hvc3QgPSBOVUxMOw0KPiAJY29uc3Qgc3RydWN0IG12c19jaGlwX2luZm8gKmNo
aXA7DQo+IEBAIC01NTksMTAgKzU1OCwxNCBAQCBzdGF0aWMgaW50IG12c19wY2lfaW5pdChzdHJ1
Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmVudCkNCj4gCQl9
DQo+IAkJbmhvc3QrKzsNCj4gCX0gd2hpbGUgKG5ob3N0IDwgY2hpcC0+bl9ob3N0KTsNCj4gLQlt
cGkgPSAoc3RydWN0IG12c19wcnZfaW5mbyAqKShTSE9TVF9UT19TQVNfSEEoc2hvc3QpLT5sbGRk
X2hhKTsNCj4gI2lmZGVmIENPTkZJR19TQ1NJX01WU0FTX1RBU0tMRVQNCj4gKwl7DQo+ICsJc3Ry
dWN0IG12c19wcnZfaW5mbyAqbXBpOw0KPiArDQo+ICsJbXBpID0gKHN0cnVjdCBtdnNfcHJ2X2lu
Zm8gKikoU0hPU1RfVE9fU0FTX0hBKHNob3N0KS0+bGxkZF9oYSk7DQo+IAl0YXNrbGV0X2luaXQo
JihtcGktPm12X3Rhc2tsZXQpLCBtdnNfdGFza2xldCwNCj4gCQkgICAgICh1bnNpZ25lZCBsb25n
KVNIT1NUX1RPX1NBU19IQShzaG9zdCkpOw0KPiArCX0NCj4gI2VuZGlmDQo+IA0KPiAJbXZzX3Bv
c3Rfc2FzX2hhX2luaXQoc2hvc3QsIGNoaXApOw0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFk
aGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUgTWFkaGFu
aQkgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
