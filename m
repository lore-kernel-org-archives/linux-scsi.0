Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB86EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 17:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiBIRuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 12:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiBIRun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 12:50:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726EDC0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 09:50:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HIpbi017445;
        Wed, 9 Feb 2022 17:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9PfU/HO3pQ7n3eSlDDA4/U58Rid7WjuFWjQ5rgAk3x4=;
 b=HFgljwDzVHKdZqXt4RNRIPGyAsyejpxQNa0vnijxpbKKERbtLXjKXI8pook1jUGCMosQ
 2ZEv8y0gDBwozeYrZ+mhs4CbB4eHWq68o8hAfKut1tCpLTht73g5GXSjW8ZvkN3dq5Xq
 GYyQdwNruQq4LevgpYihbaeKnD6tQVEPnud6O3NfhX69REyQ2uaR2MFrYJfcRZocnScU
 Ee1NjYkysjtN5uuThW71XyZ1qiKZzU0uEsrngpSGBZHmBTT4RhSuDzW1i6uFbSVuN38c
 o46aW3WcS+ixXJc6qlgYcD8e5OgX/NG0iaYlKRsw+rNP8HSAo3xBaI3lHSwcpgfrk3oK mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28n9gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:50:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219HaRTt167488;
        Wed, 9 Feb 2022 17:50:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3e1f9hrkpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:50:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eevi/XH0LXk8isGvD8Mqsk5IL0vANOePWjWjZoyDEVz30NTg/D9I7vVeEIx3jHfMAB5PzaZ6ObIQ1MsG+9RRjZWdhE3rhReTi5FcvlaX43tK7YwSNtk56FANZUWqZuFBEjJLo5Ixh8yEPjX4EbFruIdVBWcnJ4EXUmDScZsTlnrOW0xCfpDzzCCVw8UCvzXwgJFXiNbioi44XcWyYG+R4CaB7OhhFDcatFMFXLToYqDd0OAXUptq+pzu+PmF7EbrIJurrpepdSiMwD8Gne8ZwtXsIXgpVIj/soHas6zCPbYRF7yna7fzyxRQV7a1eiylnMxBQ9MQjbc9985hQY3UkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PfU/HO3pQ7n3eSlDDA4/U58Rid7WjuFWjQ5rgAk3x4=;
 b=R7phWgqMvMZJ0fzmvtAJstR+gImhgmikP1LcWQVjEGp2+4KF9O1Dsyv0EymdnA3b6SkCuMoe/BhEl6RJuI7SOhA3pzAz/gr7MOl03ZsmP4vnZGvFnMHckxj7mZlin1y2P5z89WcQ1n3I+YYKBZ5/D05PB4442qi5rQhc+Ya4C6YWVH7bqevO2rULwLwJpXZ3cv9/WsIbqbfEIVl3LqL/rSWdvVgmsVfnXiAC4v69IsgMuABpM7Z8/JIyp5jGm5vNJRNXWOyUkaNAaYP/4P85ZERdfFUmW0M7XrHDRSRb0ZhK7yqfkaHh5OsA3JG7+YCuw+TGv9MNcW6BC41OXD6Tzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PfU/HO3pQ7n3eSlDDA4/U58Rid7WjuFWjQ5rgAk3x4=;
 b=e8dwJS/X4N4m8DJu1375XVaFt10duLXgiQPQ+tq5fyNEssjrioXoYlj+w9bSNpr+utK+2ixCCoVMIogPtNO5eDLCmMi5G1FqYdY0/+I+FXew/LU0obXEYBcc6dhL/Txg88aLyyqP2l0aCr+utD1x+GA33X3T5rpRU8qL5tCJjKA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4019.namprd10.prod.outlook.com (2603:10b6:a03:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 17:50:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 17:50:39 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 11/44] aha1542: Remove a set-but-not-used array
Thread-Topic: [PATCH v2 11/44] aha1542: Remove a set-but-not-used array
Thread-Index: AQHYHRFAaQJipip5+kWqrzuXQLj1WqyLgPSA
Date:   Wed, 9 Feb 2022 17:50:39 +0000
Message-ID: <350347E9-F190-4A05-8BE7-0483170886ED@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-12-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e01a3397-55e1-46a9-2f27-08d9ebf4af2d
x-ms-traffictypediagnostic: BY5PR10MB4019:EE_
x-microsoft-antispam-prvs: <BY5PR10MB4019DEEDB19A65580F8ACD88E62E9@BY5PR10MB4019.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ql3/ynCYwX8CeuarUDIdcj8Tkop3sa6q9c9D0261yZNuCwY0MXCzwkGP8ISvZRWdH6NtsipY088c2RQ4sc7KoDpk1yX3y+XsbWE5/u10fwS2yY5ZbNx/zEmEU/zDJqik5Mlz2o/0xLVCqQDTZrPje1W3CqlalfB8R+uFUr3FGD9Pmc3pPGop6G3R5tOAGfOgafF0GratH3krAktY2tu6GOES+xsOhg1ALQLoOzvFFQ3Z1jALNt589LfYS8mQMyF0wVTjJYYl3pkIi3dC2/gvEWTrX8NwHwouMFjOljb0ZRga7KIRpFkFqQylL0dHcle0zqOkDR/ISxGdGy08QJje90GLJQ8iKAK1B9mD0HZ/4Ir4ii8+JuwYHo2LJoYZhaNT2ZrBM8jj8G9aSmlTrPZqs3JsB4p6V364ZgKqQoCAaIeTiLu+eHwsDwbzYCVVrCJGidyEgTY/wAD+4rIanzLXK9lhd3cB4A0VSA0Y5cfc6KcJ0sA7+Cg88EXJjs4ima1M9uXn+iiMo1k6sSO391yGX7svKMHCzn+nRsR6gE8R30gDYN5ASQx9hy7vBpFtUzDF9bWELmpOj5WZsUQf+lppBZPqi9+eMc7aushpGLwKB5cOyo9TcN3gdOhejvlUVnSbSWB/O8LUubVlJJ4f0Z68jaeNnl7u1383WMao07te3pjblh+4Mii6ABm++iBPj6CKcX9Axsp8OgVj7mLCZJjpWXPu1v0nMCHexqxN/I+uyiOfBI2DX+H9KFEObcbjVtSw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(83380400001)(38100700002)(122000001)(66446008)(66476007)(44832011)(5660300002)(64756008)(36756003)(2906002)(186003)(2616005)(6506007)(6512007)(54906003)(71200400001)(6916009)(508600001)(8676002)(8936002)(86362001)(316002)(76116006)(6486002)(4326008)(91956017)(33656002)(53546011)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SE10YzRZblJuVXNpZ3ZVQW5VSzVBUithVE9vaEI0cWlWNThkZlo4aWF0V0Q1?=
 =?utf-8?B?eEFidXNETkJZdFNTckZBUjQ2M3dYQy9MY0E3YSs5d3pwVzdKbS9xcW9SSk9N?=
 =?utf-8?B?cXpKTHp3dVpxOTRleDVLVzJwSnJ3WXNqeEQ1VmtGaFJkYkdtWEIzOEtZL0hy?=
 =?utf-8?B?bzBJSEp3Q2p4eHU1SmNVNDloNWRwVkZoeFFjU2xsaytXZEcyUXpucm1obkMv?=
 =?utf-8?B?WTNlQzJaK01QOVhzWVY4akNmaXRnRGdzV1MrUWxwRW11UkozQ3lNNHltM1VN?=
 =?utf-8?B?c2NVSGRVR0lwUDlZZVF2YVllM0JQK2xwNk54TGxROEhKV1J4YUR6U0tPa1FW?=
 =?utf-8?B?Rk1zcndwaldNQXlQOGI2aFFjcm50SURueEFqRnBsNVJhYklHVDQ2UjQ4eWVZ?=
 =?utf-8?B?UUZyeFVWZDl2Vyttc1MvTTEvWEJBTXZNeDVZT0FGTFdVOUs2RGtORVNaQk9T?=
 =?utf-8?B?WENFeko3b0NOcEhxUFVxNWt2Tjc0V20wLzBoVGFzMjlhWk94b1VSWWR3VGVo?=
 =?utf-8?B?enY3VGNEalV6WnlyK2k2dFdReWRZc1ZjUWUvbmtVVkJ3QWlNWkJ3NHluNnA5?=
 =?utf-8?B?NWN3dWZQWGR3Qkhrck9PVVBjeGgxZXpRRDV0bWUrQXgwYWEwdGRUR3BpSjNI?=
 =?utf-8?B?N25QalB3QUVoZTJWa1lOeXgzMUs3UE5oSytMQklHUlczaUh5c05IWmhGQjZD?=
 =?utf-8?B?eFIvdy9wcjRvSG5TQnVteWtlaEs0bFhlWmlmT1RreHNTUmlGOFMxY0cyQmtG?=
 =?utf-8?B?ekt3enJYR3FPdm9hVFVuaFVORGlVeC8wOXE2cloycEd6aUVvQkhkaXZSOHN2?=
 =?utf-8?B?T3IwUzZmeEZENlNZSllmVkFnbVBZaXcxYk94QzU3MW1ua0d6dUdRUXpBVGJ0?=
 =?utf-8?B?YXJKdU5HcHFQRXlQQnozYXh5RUdyTEttdE9PUjZQNWxOZCs0a050Y0dOdG5z?=
 =?utf-8?B?N1Y0UmYxNmdqUUk4VS9KWHc0c3MrNTE4TkRreXZRNjYveHk3dkwyQ2EzcTlu?=
 =?utf-8?B?WHBVMkxMTnc3bjJEMUt2Z3JvMFhmUUFWVmFZV20veTRuTitJckhld0JVa2dH?=
 =?utf-8?B?Q3QvL2ErSnhVR3pZNEJ0QmVmUEFnblh3SHR6a1UxT20vSWNRVTdOUDVHN1Z4?=
 =?utf-8?B?TnFwMm9hNjRYQVZzZlNpUDdNV1ZXTHUrdEFxeGg5RzJFeVhpbmg5WVpvYVFj?=
 =?utf-8?B?bGRHQTdxbCtJMDVQMWNQakQ2Vks2UUlHbzdmVTNFQ2tWQk1QS0NZRnIvdWdW?=
 =?utf-8?B?RzRoTmc4cW9PZms2OWxwUk5VcXBFNE05bHlkL0VVei9qdjczZy9KNVpWU0kz?=
 =?utf-8?B?dTFMMEprOHpyMXk3bkhxTFA5ZnVzWjNWdVZSekVvSmZsQnEzLzFGZ3RwZHZJ?=
 =?utf-8?B?Y2pKSHQrenMyNkpxSVQxdTJ5MzRzUkpYUkdFQ09Bc3B5S3NBTVQ4T2Z2Mzlp?=
 =?utf-8?B?MGxNeVlLWHZaMFNRS0xKckl5aWNLZDBUTUJYaXJ2MlU0ZHQ0SEVFNy9uYlJp?=
 =?utf-8?B?d2wxdWJ0Ry95aHpxWEhDZWZWNjhsTkFUVzhSRVZFUWZEa3lyNk0xd05keWU5?=
 =?utf-8?B?bGkzMHBJYWNqTWMwQm9KQzF4eW9DTllGdEVXWUtZd1M1Wk5zYUlKN2NoWlBY?=
 =?utf-8?B?KzZicHpQMjBNZThONEtmYlRaQnZZMlVaMW9OZ01ydDNKVkZnZVdKcERWNDJ0?=
 =?utf-8?B?Q0hFYWMveXdGb2tEa1FYTW45dGJ6Lys0dVNYbWNwZDJxMVJkaGtLSlZPaG5H?=
 =?utf-8?B?YTZGTmtOV1NvTU9zQXdsd1VRSGIva3BZRWxQZ2RYY0lTTGQ5NStyREJvaG1m?=
 =?utf-8?B?dE9Od3hPcFNtWHMvNWVOMUFlWWRhbmFDUW9RQ2JnaGdQbGt0ZU93dXB5QXJH?=
 =?utf-8?B?aCt3UkxmMzkxRmJWOXZ5WmZ2R0Uyb2xiSTJPeGlpV2tpNVMvMmhPcmwvUkFh?=
 =?utf-8?B?dThXMVJ0OWRQU0RNWU9uck1TbHB5ajExQnBMWFF0YmNnNUJvSzV2VTBKZ2x6?=
 =?utf-8?B?ZzN3d2E5WUw4UTdqR0xBZWxFcGhya0NHbVNGdDNXdWdpS3hNbUhIUUNEY0NG?=
 =?utf-8?B?elVxUEMzay9HbHFPbTIwNDJKaXNLenlZOGxsaUEyYjNCb3doMVoxZmRUUWta?=
 =?utf-8?B?UmZyK0xNa1hQdDlUcGl2aUM4OVBqekFlZnM4ZE1WRjZQVnZqM2lJdm00VE5J?=
 =?utf-8?B?cEFlWW9VaEVqdUdNNEgxbHVDYkwxTHNTSkRvN081SkR0OWhGTGl1SDllRVIz?=
 =?utf-8?B?VjRCcDFTT2RaZ3BsTGEyRzc2aWdBRkZiQ3M4WmNXWGwvUzdsVGQ5dU51RTBh?=
 =?utf-8?Q?FVoIe8XkAMtxSLWSUb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6276B8C9D893DF4D95FA0F4D0EC9FCCC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01a3397-55e1-46a9-2f27-08d9ebf4af2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 17:50:39.2376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PgUl3VeiBLmmaWLtqzpixJYcGaLO2zxk/YMlf7zKKLOqJYtwfe9Zo3bQD0RSUHlJoBf81h4mnL7KgZMd/IFJa24r7+AdrRJP0TpkluAhVfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4019
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090096
X-Proofpoint-ORIG-GUID: spBoHFMmM-nH2MrGuvq3u6qfBK6Ya2cy
X-Proofpoint-GUID: spBoHFMmM-nH2MrGuvq3u6qfBK6Ya2cy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gRmViIDgsIDIwMjIsIGF0IDk6MjQgQU0sIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFz
c2NoZUBhY20ub3JnPiB3cm90ZToNCj4gDQo+IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGZvbGxvd2lu
ZyBXPTEgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvc2NzaS9haGExNTQyLmM6MjA5OjEyOiB3YXJu
aW5nOiB2YXJpYWJsZSDigJhpbnF1aXJ5X3Jlc3VsdOKAmSBzZXQgYnV0IG5vdCB1c2VkIFstV3Vu
dXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiAgMjA5IHwgICAgICAgICB1OCBpbnF1aXJ5X3Jlc3Vs
dFs0XTsNCj4gDQo+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5h
c3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+IGRyaXZlcnMvc2NzaS9haGExNTQyLmMgfCAzICstLQ0K
PiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2FoYTE1NDIuYyBiL2RyaXZlcnMvc2NzaS9haGExNTQy
LmMNCj4gaW5kZXggZjBlOGFlOWY1ZTQwLi5jZjdiYmEyY2E2OGQgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS9haGExNTQyLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL2FoYTE1NDIuYw0KPiBA
QCAtMjA2LDcgKzIwNiw2IEBAIHN0YXRpYyBpbnQgbWFrZWNvZGUodW5zaWduZWQgaG9zdGVyciwg
dW5zaWduZWQgc2NzaWVycikNCj4gDQo+IHN0YXRpYyBpbnQgYWhhMTU0Ml90ZXN0X3BvcnQoc3Ry
dWN0IFNjc2lfSG9zdCAqc2gpDQo+IHsNCj4gLQl1OCBpbnF1aXJ5X3Jlc3VsdFs0XTsNCj4gCWlu
dCBpOw0KPiANCj4gCS8qIFF1aWNrIGFuZCBkaXJ0eSB0ZXN0IGZvciBwcmVzZW5jZSBvZiB0aGUg
Y2FyZC4gKi8NCj4gQEAgLTI0MCw3ICsyMzksNyBAQCBzdGF0aWMgaW50IGFoYTE1NDJfdGVzdF9w
b3J0KHN0cnVjdCBTY3NpX0hvc3QgKnNoKQ0KPiAJZm9yIChpID0gMDsgaSA8IDQ7IGkrKykgew0K
PiAJCWlmICghd2FpdF9tYXNrKFNUQVRVUyhzaC0+aW9fcG9ydCksIERGLCBERiwgMCwgMCkpDQo+
IAkJCXJldHVybiAwOw0KPiAtCQlpbnF1aXJ5X3Jlc3VsdFtpXSA9IGluYihEQVRBKHNoLT5pb19w
b3J0KSk7DQo+ICsJCSh2b2lkKWluYihEQVRBKHNoLT5pb19wb3J0KSk7DQo+IAl9DQo+IA0KPiAJ
LyogUmVhZGluZyBwb3J0IHNob3VsZCByZXNldCBERiAqLw0KDQpSZXZpZXdlZC1ieTogSGltYW5z
aHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUg
TWFkaGFuaQkgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
