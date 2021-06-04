Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8D6C4743C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251326140C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 19:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhFDTGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:06:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60496 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhFDTGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 15:06:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 154Itwhp005822
        for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2021 12:04:53 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 38ygesa123-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2021 12:04:53 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 154IxQtp011855
        for <linux-scsi@vger.kernel.org>; Fri, 4 Jun 2021 12:04:52 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-0016f401.pphosted.com with ESMTP id 38ygesa120-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 12:04:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+MTyp4PNAx9b2U9z0zEmsSqvEZLvis6o5Ij9tm12VRytZH9G97GSfhfcU49IcIxO8FLEkilrEv1so1wJWm3fL6K+UHr7wx0eUduiN2BY/otoosbol5h9R2NrZgGItqHWA9VEzDmSmOBSjD4dn2i9rp7oxgA+s6PhDmsNQOp0BCJ7jtYOnwhCL0s/Fn/0bZSzrust5ubctPG8yQYVQCLQhEzEnhJAGoLqt76EoR4BAQADO22NQUqR0wpqmQNEQuXDLhmv2vZcnN2uPpKcRFWTqxp4rnKRQzpjt9aPJNRCMqR4ilKvwsdhWPdDZHHUudGeFjrW4oaJODbflAb6gp3/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyKjz+HpGsFM/jEc8q2Mkgz/vInVd/IiRGBgE+NUMzs=;
 b=aToXV2jFkVZFHL5IuzZFvTLkTaS2gHc3M9omHMwd5v+nWVQV5F0F24KjmRNNBD1ssevaXDfKAeerMDZ2gxM08haghdg21cQXyXNeEdiSQMA69cCBsNCZBTrlJDLhbL3rjMpG3ndP6XRvhhKnB8PAfIwWnaW/62nDOBsvXwZWW1js1PASK6CIbz6p49xu6m85CMc6VnbBPDk+QhpVAjVvcoMTJ44qkh+aFYX11mReIQvsmMrlzKZ/rv0SU5xVjr5aCPx8+a6N6TNaiRJS6eszOBeenYzgnGaanOPs3LukWBaRb4/T+103CCa4R1p0LTSs+eE71+66nFMb8Rn3VFGAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyKjz+HpGsFM/jEc8q2Mkgz/vInVd/IiRGBgE+NUMzs=;
 b=sX3P7mapWszb0oRVLdDzrz0V0Mh9iy2RDQhR3cxgh4Cye2r7ydoiFQkzx5nb0Ihu72F/2KKdoXb9zwsA37qNInUvTNihM1YGOi9EwngQ0DrF67Bp+XmCRAyJkOwe2uk8FwwTCn1s3BolIfkS0zGXW+HnWMVWEUxGx0l53WHiMjM=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by BYAPR18MB2470.namprd18.prod.outlook.com (2603:10b6:a03:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 19:04:50 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 19:04:50 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
Thread-Topic: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
Thread-Index: AQHXVeuDrPCVzeUItkSrjU+IUrMt0KsCm2IAgAGbaVA=
Date:   Fri, 4 Jun 2021 19:04:50 +0000
Message-ID: <BY5PR18MB3345810B7574467B25037240D53B9@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-2-njavali@marvell.com>
 <62032fee-e643-9421-1cd2-95a342e2666b@oracle.com>
In-Reply-To: <62032fee-e643-9421-1cd2-95a342e2666b@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9f72818-5ff9-4d2d-bba3-08d9278ba0f2
x-ms-traffictypediagnostic: BYAPR18MB2470:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB247068DE3918F6D457AD9396D53B9@BYAPR18MB2470.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y+/EOv3mXORAOF01P7QOZQ86BfxP89GqLYzq9Gx8PHFcWc42ri1YOia2SFGDtFj5mSBiu/cRh7iSNHX01kbhhKG2JV5yKvqqlMgPVXe4TOTC9YSRyB6sW0lXUqNrAHaFs42KQQ4132lYdU3fS2ArVh9u0csA9+WD13Pq27JprfDvEbtrEmbXHO4Shj1aNJ4SSrdc7b4SkX+Ere3OkljdWtpVGYqt3a5B3VzIlIVSrmC0cmQD/1W38XZSAsiUqybl86VbCHRekuqZnRwMvOVng+qkaBjRtHc9NONrGt2cnP5h8OiWGv9gkNE+lB40QQElRQQ1QmCCUjVjdCXnmYS/DS4kNEE91s0ckhtjx8+5DGDW5E92lPgxIfzAOLVO+i9rPBydpzaoC9Qm2ahifWS72+8Zgy63nFm0Un76acNlhkZvnKxEJ/VNCsdC46NYJc9z7a3tfy1l/HV/HKVLvVi2/s8lTAz349mDZXnjVJ2X+Sgw7VGJUxkcvVjet8JkyghqpuvYnucKIx2MoHel8pynaimXADnmcGoyIZkVijBvgSig9HpQ9fwp63ePp/MW2aPnem5K6EdkQuCMXehK9E+tRIQapOtL/XIpeAMqElA3Ta0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(136003)(376002)(346002)(478600001)(38100700002)(8936002)(8676002)(122000001)(5660300002)(76116006)(55016002)(66476007)(66556008)(64756008)(66446008)(9686003)(66946007)(4326008)(107886003)(2906002)(83380400001)(7696005)(26005)(316002)(54906003)(110136005)(186003)(33656002)(71200400001)(52536014)(6506007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TVlZR05LbUlZTm1acXAzK21OdS9FTkJVdlVGcWZHZUFTY2FIVFpYcmE4WUtL?=
 =?utf-8?B?Y1ZGaW12VUJJQU9LRlBad3E3QmRpK2o2NHNnWkZqZUVGbXpqeWdqUlVOTmtl?=
 =?utf-8?B?cTBEV3RlZ3RDQUdNbWUvYnluMnFiZ2VXaThhbW9ONWFJbXdiNElYSXdkaWpJ?=
 =?utf-8?B?djEyVS84QlpvRGxLNHliRjU0YkEwdkxWQXE5ejJzTW9ycnRBY2NMOHVJYmtL?=
 =?utf-8?B?VVhTMlp1di9vNGRweEs1eExHdjczazNoUGtKcEdYTklwU0tuYXZIRUk2OUlC?=
 =?utf-8?B?YzRHN2Z5UTdNbDhFVWhOcGhCSzYvbkU0V1BkZkIzSjZSZzZBNGd6VFZoVmw2?=
 =?utf-8?B?K0N2Zmx6UU1XME5lZmdHWi9VaTVlNDVyMzhxcW80Z0kydWVmSXBGd05ENzdL?=
 =?utf-8?B?aFZQZWdoUFBmUjRFbDZUc2tFYWZ0VkNGeGozNmMwT3c4cWR3a05oVUd2U0Nq?=
 =?utf-8?B?bjdrUndaWHBKR1FzU2d1SEZpYzd3WHFtN0ozSTY1b1drV0tkZFBjWG5JOFAx?=
 =?utf-8?B?RVFROG1zNzVOYVE0cXkyWm5USUU3OW9sMFBjd0J2OFJBVGNlRkZLUTVmc1JR?=
 =?utf-8?B?eXVEK0VMeDFpdkExb3ZObFhXemRrZnRFUlVDZzBRTnYvVVlRRU9yakpzTnJ1?=
 =?utf-8?B?Y0owQUEwcnoxbXFJR2M4WkNTb0psdFVVMkhtWkdRN1U2ZFNCMXpVY2NPTWpj?=
 =?utf-8?B?alZkVFd5SDVsSVlETHU5ZERyU0hIK0MzTFQwTU1STnhqdG5oVk1CbUVQWFN5?=
 =?utf-8?B?QjYzenhWQTBXaHZwTWZuUjBjOU9MRmduZktrbWNPK0V3bGpHVVRQLys4Wm5N?=
 =?utf-8?B?YVpKNXVUUnlHSlVsQ1cxdm0zTzNtWjhjYTZSbTFtekF0YTZHN0h2dThaSnhw?=
 =?utf-8?B?Nng2TkFUNkFOaVNkNTU5b2hHaFpyU1ZVK2xHOGVlNU5yK3hBUmgxZzBLUzFw?=
 =?utf-8?B?aTU3ZEV2TnFSSlhTSmUweVlHOEgzS0V3YTMrZzBMdGxra1pPeDZIRXJHWVkx?=
 =?utf-8?B?ZUZZMDlQbnIyRGcyREdYMEFSOEdnK0xuKzFUZ1ExN2txZHBMMXYxaDRDL2g0?=
 =?utf-8?B?TTZGaVFtRU9rdFBBR3hzbkVCSkJheWxBZnJKaE9palRlWnNwNUdNNjRWUXRX?=
 =?utf-8?B?d3BVODNxQUY4VldvTHdlVTB3OXdQa2pNc2M0TmhuNTVZMkVtb1dJdzFaR056?=
 =?utf-8?B?TmlDK2laTEY3c2tZY3RLWXA1WFVEeHZzMWRIb1RqZ1JOQUtCZWgxRWtiTDdS?=
 =?utf-8?B?RFRGeDJueDNSZmx1Nkt5dFZ0UDg2U3ptUVovdWhreUJsQytkNk9CNWxIdity?=
 =?utf-8?B?bUV3eC90KzlLZnUxV0JXZEZYU1hsRjNYbUJtbVBTNWxrSDJnUTI5NWkvZ0RL?=
 =?utf-8?B?RkY3L3IyRVpMZjR0RnV0cHZSblVHWkJxcDltQTdENXZxd1lHVDRxK0tZUnJp?=
 =?utf-8?B?M0FwSFNNampzb3lXd3dnOWZ0S0RRWjF5Yjl2MENxY1NhUlFBeXVXMmQvU2Y1?=
 =?utf-8?B?bTdjdjJYTkFtbW9BZVpnS2ZvV1pXVy9LNmlseTJNTTBNL2ZjK2RiU0t4dmVC?=
 =?utf-8?B?NHFCZ0c1VWQwV0NKSGdHbkJ6WWFTK0h4ZkEzdUpydnJtU0FiSkh3bEYyRktp?=
 =?utf-8?B?YWRxeWI5TlZRUHRSYUsyWDZlRXFxUFFxTWpmNFBVTzk2UWZOT1dYUThiWFdV?=
 =?utf-8?B?dmRkTlFWSmkydWtqQzVqUVZXV1VmN2NiUzJkNHZhbmJCeTkvMVQ2Z3ZJd25V?=
 =?utf-8?Q?RsgytJZPPgReVyGejLr/dky27OSxAOeaoyWDGiE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f72818-5ff9-4d2d-bba3-08d9278ba0f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 19:04:50.1936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qNRq22caxyOGbK3gNqCJ/3DJOkNCjvxlz18bHee+PMQ4hU2MWNl9cy/QFKxo0bC6QygH1JTAd2SzmKY/lmX4zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2470
X-Proofpoint-GUID: HLMoy6MQbcPfEkz19hspjj6SrOWu5h0N
X-Proofpoint-ORIG-GUID: VYvdWkF0F21IVNOqCkz6SojfBCouKVcZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-04_12:2021-06-04,2021-06-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGltYW5zaHUsDQoNClRoYW5rcyBmb3IgcmV2aWV3aW5nLg0KDQo+ICsJfSBlZGlmOw0KPiAgIH0g
ZmNfcG9ydF90Ow0KPiAgIA0KDQpTYW1lIG5pdCBhcyBIYW5uZXMgYWJvdXQgdXNpbmcgdWludDE2
X3QsIHdoaWxlIGNvcnJlY3RpbmcgdGhhdCBwbGVhc2UgdXNlIExpbnV4IHN0eWxlcyBmb3IgY29t
bWVudCB0aHJvdW91dCB0aGlzIHBhdGNoLiBJIHdvdWxkIHN1Z2dlc3Qgc2NhbiB0aHJvdWdoIGFs
bCBwYXRjaGVzIGFuZCBmaXggaXQgaW4gdjIuDQoNClFUOiBhY2suIFdpbGwgZG8gZm9yIG5leHQg
cmUtc3VibWlzc2lvbi4NCg0KDQo+ICsjaW5jbHVkZSAicWxhX2RlZi5oIg0KPiArLy8jaW5jbHVk
ZSAicWxhX2VkaWYuaCINCj4gKw0KDQp3aHkgY29tbWVudCBvdXQ/ICBpZiBub3QgbmVlZGVkIHJl
bW92ZSByYXRoZXIgdGhhbiBjb21tZW50IGl0IG91dC4NCg0KUVQ6ICBzaG9ydCBpbmRpY2lzaW9u
IGluIHRoZSBwYXRjaCBzcGxpdHRpbmcuIFdpbGwgZml4IGluIHYzDQoNCj4gK3N0YXRpYyBpbnQN
Cj4gK3FsYV9lZGlmX2FwcF9jaGVjayhzY3NpX3FsYV9ob3N0X3QgKnZoYSwgc3RydWN0IGFwcF9p
ZCBhcHBpZCkgew0KPiArCWludCBydmFsID0gMDsJLyogYXNzdW1lIGZhaWx1cmUgKi8NCg0KQ29t
bWVudCBhYm92ZSBkb2VzIG5vdCBtYWtlIHNlbnNlIGlmIHlvdSBhcmUgYXNzaWdpbmcgcnZhbCA9
IDAuDQoNClFUOiB3aWxsIHJldmlzZSBpbiB2My4NCg0KLS0tLQ0KcGxlYXNlIHVzZSBrZXJuZWwt
ZG9jIGZvcm1hdCBmb3IgdGhlIGZ1bnRpb24gZGVzY3JpcHRpb24NCg0KPiArLyoNCj4gKyAqIHJl
c2V0IHRoZSBzZXNzaW9uIHRvIGF1dGggd2FpdC4NCj4gKyAqLw0KDQpRVDogd2lsbCBoYXZlIHRv
IGNpcmNsZSBiYWNrIHRvIHRoaXMgaW4gdGhlIGZ1dHVyZSBwaGFzZSBhcyBwYXJ0IG9mIG92ZXJh
bGwgcHJldHRpbmVzcy4NCg0KPiArCQkJX19mdW5jX18pOw0KDQpmaXggaW5kZW50YXRpb24gZm9y
IHRoZSBwcmludCBzdGF0ZW1lbnQgYW5kIG5vIG5lZWQgZm9yIG11bHRpcGxlIGxpbmVzIGZvciB0
aGUgcGFyYW1ldGVycy4NCg0KUVQ6IGFjay4gT24gYWxsIGluZGVudGF0aW9uIGNvbW1lbnQuICBJ
IHdhcyBmb2xsb3dpbmcgY2hlY2twYXRjaCByZWNvbW1lbmRhdGlvbi4NCg0KLS0tLQ0KDQo+ICsJ
LyogaWYgd2UgbGVhdmUgdGhpcyBydW5uaW5nIHNob3J0IHdhaXRzIGFyZSBvcGVyYXRpb25hbCA8
IDE2IHNlY3MgKi8NCj4gKwlxbGFfZW5vZGVfc3RvcCh2aGEpOyAgICAgICAgLyogc3RvcCBlbm9k
ZSAqLw0KDQoNCkkgZG9uJ3QgcmVhbGx5IHVuZGVyc3RhbmQgdXNlYWdlIG9mIHRoZSBhYm92ZSBz
dG9wIGZ1Y250aW9uLCBpdCBwcmludHMgbWVzc2FnZSBhbmQgcmV0dXJucyBiYWNrIGFmdGVyIGNo
ZWNraW5nIHZoYS0+cHVyX2NpbmZvLmVub2RlX2ZsYWdzLCBidXQgZG9lcyBub3QgdGFrZSBhbnkg
YWN0aW9uICppZiogdGhlIGVub2RlICppcyogYWN0aXZlPw0KDQpRVDogd2lsbCByZW1vdmUgbm9u
ZGVzY3JpcHQgY29tbWVudC4gICBUaG9zZSB3ZXJlIHBhc3QgY29tbWVudCBsZWZ0IGJlaGluZCwg
d2hpbGUgdGhlIGNvZGUgaW50ZW50aW9uIGhhcyBjaGFuZ2VkIG92ZXIgdGltZS4gIFRoZSBpbnRl
bnQgaGVyZSBpcyB0byBkbyBjbGVhbnVwIGlmIHVzZXIgc2h1dGRvd24gKGV4OiBpcHNlYyBzdG9w
KS4NCg0KLS0tLS0NCj4gKwlxbGFfZWRiX3N0b3AodmhhKTsgICAgICAgICAgLyogc3RvcCBkYiAq
Lw0KPiArDQoNClNhbWUgaGVyZSBmb3IgdGhpcyBmdW5jdGlvbiwgaXQganVzdCBwcmludHMgbWVz
c2FnZSB0aGF0IGRvb3JiZWxsIGlzIG5vdCBlbmFibGVkLCBidXQgZG9lcyBub3QgdGFrZSBhbnkg
YWN0aW9uIGlmIGl0ICppcyogZW5hYmxlZC4NCg0KQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0K
UVQ6ICBEdWUgdG8gdGhlIHBhdGNoIHNwbGl0dGluZywgdGhpcyBjYWxsIGlzIG1vcmUgb2YgYSBz
a2VsZXRvbiBoZXJlLiAgIEZyb20gdGhlIHN1bSBvZiBhbGwgdGhlIHBhdGNoZXMsIGl0IHBlcmZv
cm0gdmFyaW91cyBjbGVhbnVwIGFzIHBhcnQgb2YgdXNlciBzaHV0ZG93bi4NCg0KLS0tLS0tDQo+
ICsjZGVmaW5lIFJYX0RFTEFZX0RFTEVURV9USU1FT1VUIDIwCQkJLy8gMzAgc2Vjb25kIHRpbWVv
dXQNCg0KZml4IGNvbW1lbnQNCg0KUVQ6ICBBY2suICBXaWxsIGZpeCBpbiB2Mw0KDQoNClJlZ2Fy
ZHMsDQpRdWlubiBUcmFuDQoNCg==
