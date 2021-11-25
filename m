Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC38C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 05:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbhKYFje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 00:39:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18692 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232169AbhKYFhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Nov 2021 00:37:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AP4nUN1003320;
        Wed, 24 Nov 2021 21:34:18 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tt6f9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 21:34:17 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1AP5LdQY031244;
        Wed, 24 Nov 2021 21:34:17 -0800
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tt6f9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Nov 2021 21:34:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ/uNAnpiXyB2VyCLHM9a/+31ZI7WInw1sbq4wTm6xjUg2gIV1SnOwpI+EdYEylyuydwlN2ORwVVTFxyOjv21XTT4FD9V1iejY6bVHFDBPDHNaa4A52SMWZcRDuhY2StMDZUD8NRj9CLzWF4K7nnW/6mxKwIA0R4/sJk9gVhMBmSQM3nP6SywP2qnHO4UBRwJyItHSUNXKANXLTvNumbq3UVTpphCWxQ6mRAg5lZN8jF/guQKCan5+6+rLE34VHIhxclCzVu/pizltHEHe6Jqd6qlA/06we437mzRF0WyynFKyzaHooR4ZTw69JQS2NH1WAgVFDz6fEWkRhB8rWbEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+b5kpj75u/EHZXXgsE2rFStnHKiWHXz9qLd0zmDDiP8=;
 b=eCVPXGc7b3jzcoteByHsOZghG2PVVIhvcW7dWpS7z2gm3aeP1VFaxW9PIDaGAP19Gsl3LkSjtDtm/Igqoe9E4qFKyQ8+AggLcv2Y9UHj2tl6DDXqN9VCiWac+xn6b96mLYvGoYbJ5f+OG2l4JS+PHo1b6DFl+f4o73lP/dKdOoAaPFp2HZOfT3EDWz1j+KK2ylGpkdn8krUs0SmgWseymiSMYIEWoK5nKPXmed7JGrhEQvLXMfrd+CLZb2BTDmXuYpBD1qcTm90QOwrWf2j2FYuyHhAR6nzCVSok/AHkD8iy0D5zeWGF9PiYYJpptDC7L4Phrl8at5dVpT0prBi6Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b5kpj75u/EHZXXgsE2rFStnHKiWHXz9qLd0zmDDiP8=;
 b=XQE+CMm4TMYbC3+R1tSiol0icTbikRXGXFJsba4HN9ugvZcHgGCxA3VY8QHnsPHKaX3mIQDyGCrpOEji8Mko0WlFzWfpE4GDRxpauAlvW6aHWbTU69FoIUGH+HuL6niS8Nl4Vt+7Nb4ZglPPVQCwWTuLlFbIYHCSoBFQlbJ6ijA=
Received: from PH0PR18MB4425.namprd18.prod.outlook.com (2603:10b6:510:ef::13)
 by PH0PR18MB4544.namprd18.prod.outlook.com (2603:10b6:510:af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 05:34:14 +0000
Received: from PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8]) by PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8%9]) with mapi id 15.20.4713.026; Thu, 25 Nov 2021
 05:34:14 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Thread-Topic: [EXT] Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Thread-Index: AQHX4GS1GaPhotEvvk2Hz/zH/Da7RqwRnfgAgACQJTCAAMYDAIAAxuxg
Date:   Thu, 25 Nov 2021 05:34:14 +0000
Message-ID: <PH0PR18MB44253266C65D2297BCD7CF34D8629@PH0PR18MB4425.namprd18.prod.outlook.com>
References: <20211123122115.8599-1-mrangankar@marvell.com>
 <9c21c019-d6ff-a908-80e5-51b9c765d118@oracle.com>
 <PH0PR18MB4425F4F08057B89453C2222ED8619@PH0PR18MB4425.namprd18.prod.outlook.com>
 <3edefd05-333f-7879-7ce7-ecb758fa0ec9@oracle.com>
In-Reply-To: <3edefd05-333f-7879-7ce7-ecb758fa0ec9@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 240f0a03-637b-4040-006b-08d9afd537c6
x-ms-traffictypediagnostic: PH0PR18MB4544:
x-microsoft-antispam-prvs: <PH0PR18MB454475E0470B5901C70B4DB8D8629@PH0PR18MB4544.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+HLfsrHsQy/4p529nTgrDBIPUTm+jo99Q2QQ1SFrw4nFwJqEzTTiKZzJoAvNLtt/7eGL/0KfOLbpfv6KhHgkBuKC4CVtdPDeEwmSdfA6LpBmXEBntCPViV3s69eHv+LgPGH7At5h5Yg5th9p+eYmvh0qn+rNqReD7R+M+dG8Vks6Dkcmgxpdl3gykp4yJtlg+BY0dwF+4CxVB+iR7iApYYkRN+CdPlNuz74/vlhNKnoStQF7UBrQ6636yd4lVlggWbnkOkAN5fez0fvIQS0P+qcAukWISU0ZDS79FmJCgFY7y24+iDTVHLU1VExn+GR/JYaBfUujQ3Qoj/VddELdm7R1W/aesv9paKCFw6b9A0MDProPnKMQ0EVW+WShxxEcD3u/v2a/16RQm3dqbErO5K9PB7KjlW53oMDhlWq6KG6+8Su3TnABMkHgdpuGQqLnTrqE2yvc2UmY/HFhswoFz1N+JRIBm3U0T0/ZZCUk++sEZHOI6v/dSZOBJtaFd15LTEIhtPvYm5S1t9No+Elhp719i6MYPhJpE246L5/jmBuEBviUZsCXojaLRc5iO+Mp8euQPE8XukkEhNPSYFmdSfrsmW375x9+MLL0HuthEeHKyo+aPxQNZAzSjkRmLKtwdt0Ub2fYhFxMqd0l7Yq+us41bPAinJa+MHxY9Enj+qi1dizvCgfRcpP92gjiX//lpq5CeBjaI6w/KMhj2A95w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4425.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(86362001)(26005)(4744005)(2906002)(76116006)(66476007)(71200400001)(66946007)(316002)(8676002)(107886003)(38100700002)(55016003)(186003)(122000001)(66446008)(66556008)(6506007)(64756008)(110136005)(55236004)(83380400001)(33656002)(54906003)(9686003)(508600001)(8936002)(38070700005)(5660300002)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHFQaStNT3FLbU5ZQkhoVVpyT3d6eUZ5YXhLbTJDN0tkUjNuU1piWExabVF6?=
 =?utf-8?B?eXdaS1VaMU5qdWpSdVNjUFlONnk1VldLMXprSEp4bEtDOGpjSk9aTmNmYmtv?=
 =?utf-8?B?bzY3S0FEOVYwYmEvdzF5RG9DbDhYSlQ3R3NEcXV3WEdPcE9uaUJBeTErNlEy?=
 =?utf-8?B?QUxUZXBuR3pHZFFBN2FwN1dKaDFLYzF2RzB0VlVsWTE4QmhDZWN5R1AwSmVN?=
 =?utf-8?B?ZWNYQ1p4MloycGFpMVdYVXJzdWlDVVFsb01lS2ZHYkY2Ujd3cFJacTg5WGht?=
 =?utf-8?B?WU9mQ2wxZUYrdVhIR2tVaHk1UmFRdEZBbitEcjd0c1RCdjEwQ2hNdkw3eXVQ?=
 =?utf-8?B?cXpzUmxsUWVuN2xiQlFQdzluZHRvQm5YbGJ4cGhtajZWNEQ1TnRTNUlRdWR5?=
 =?utf-8?B?UEVoenJwTVJTNExwWlhZMUJQamRSVVhFRzUrdkZ1VlVMeFVtZWN1WUNuQ3dZ?=
 =?utf-8?B?ZEg5czR3YUhTaGp0MG5LNnV6Zm9QT3ZKRlkvNUUvaFdEWDM1TVJoY2dQWGRN?=
 =?utf-8?B?UitxRDRvYTJaM0F0VFIvYlR1amd2VGRKWGVxRGxKaGFObjFETXpOaFd0Nlk3?=
 =?utf-8?B?SEdackhIUytVUllpT3FzTGlmWW10RmM4YnYzcVBpR3dYTnRINTRuVUdJNVJi?=
 =?utf-8?B?NjNFQ0FCQklldnlxcHlRSUZzNXZ5bmVUcE9VcVhZNUVnTHczZUZJUldEYXlj?=
 =?utf-8?B?Vk1vVGdlcEpsa0FhWVU0Z1ErbisxSUtZdTBMT3VDbHB1SlY4WUNQVml2ekJ5?=
 =?utf-8?B?cVNMdGExSHVVUEhvajVxbjZRUm0rcVh5ZUY2ZDFDN0dwdWlrYmlDNnlUZ3JL?=
 =?utf-8?B?RlJtb3Jrd1ZheVhMS3RHWlZCTGNKWlZnbURNbFNyZzNOVUpHMGwzejJDNnVQ?=
 =?utf-8?B?L0FJYm9BcXo2OVN0cU9GSS90Z1E4M2QzVG9TclBJcFNQdEMrTThHdi93Vlda?=
 =?utf-8?B?V1lqYURlK095YTlXZTFHY0FqZUNZV1hnTVpnamRWNGJFODlZMS8rTjcvaGRL?=
 =?utf-8?B?NUxKTVZ4UTBqVzdZYi80SXhUc3Y4ck1UVVEvVEtmRlIzYkdpVW1ROVN5UURw?=
 =?utf-8?B?R25sSmJtUmNhREl1ZDRtOW9uMFBTTHZ1Wk55cm9zdHNkL0ZLRlZpbm9ac1NJ?=
 =?utf-8?B?QTI2TS80aVdadjNkUGF1VlFZRFl4Lzl6bEppVUlOSnl6c1pIaDBKSDByYlVI?=
 =?utf-8?B?ZmQ1eEJxN1A5UG9QNWtRRGFjYkdyU2VFVGU0dTNiRDVXOUdjbFppKzdOeTRH?=
 =?utf-8?B?WnFGZmJjdXdaQTMxbFNVSGFWZWNxMFZpMXZjWXA2eXlXck9yeHJyeDFITFp1?=
 =?utf-8?B?MlpXS1V5aWxyWEppK2N6QTh4YWxWZS84MWE3YWZPdktRMWdjUlk3UXZhejla?=
 =?utf-8?B?R3Y0aC9yTVZiU3pyQ2U0TG5WdmhsOUx1WDZGRVZUTzMzYTdSWk8xcjlMN2M1?=
 =?utf-8?B?dEtmTlBlVVljNUg5RWYxTFN0a2w5QmRVRnNOSGRVMkU2UnBhdEhMN1NpVk9E?=
 =?utf-8?B?KzkwNXVvV3V2Vk5EcjlFQ05jT0o1TjIxMjNUazNXQ1NLc3orWS9UYXMrKzlu?=
 =?utf-8?B?RmhZTER2RmM0TVBLZHp2YllFMzJoWGpLUGMzSGFZbkxLSVFrNm1IcWRKTFJF?=
 =?utf-8?B?YkFFNFdLV041Rnh3QlhiYTdIR0tCSjdycWFlM2xNb2lRSjZqTHhDTWdXOGVm?=
 =?utf-8?B?RkJndDBITURlVXZJNUZUcmFSdlNlOTdLU0p4UkwrenZ6Q29xbjNWODZFcnpF?=
 =?utf-8?B?cGlKanIrYkFmeGR4b2srbVFlVW9hMjRmVTZpZEVYb2VDTHZTNTlZNjI4RW82?=
 =?utf-8?B?TGRLS3hhWDZVZFBOdi8wc1pJRHZVWVVQQ1R5S2JmM2tIT3kxbHcrVWtUeFBV?=
 =?utf-8?B?T1ROeCtpamhHVUx1UFRvQUczTktLbGtSOWVyTEFNTnhDcVZ5Sm9DcktrQStn?=
 =?utf-8?B?MkJQZGt0dWN2ZFZscm9KOS9tMlBxS3Yvd0FodGJPcnZhT2JrMVQxaEhqY0hP?=
 =?utf-8?B?elZrSk1raTVLRVZSMENYY0N5Q1ZRWTA1UFBZQVVIRC8wY0ZyanROaWNzdTZu?=
 =?utf-8?B?WEk1MEgxR2tLN1VFUC9aS1dCM1J0T3FQblZJZlRvSU9Ob3V1RW4zOFFCUGFU?=
 =?utf-8?B?Z3RvV1hXdXlUYUV4L1ZXSnBIRG5PSFBER1lLMXJKMUFYOVV1TjhOQWFGS3Fy?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4425.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240f0a03-637b-4040-006b-08d9afd537c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 05:34:14.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eC2RfA29sYx38au4XAu6kDvW+qhEwId+uMQRCtVV8W3Ks4NNTdkpMMwcJsiiRS5tAJLAyaWntjd5mP9zXipwcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4544
X-Proofpoint-ORIG-GUID: oOnZHqBGHuMXdP_vDRKeAhFLtcZJ9CkH
X-Proofpoint-GUID: FJi7cvHYFPbdYEogAPkDQyCN8IozQpbo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_03,2021-11-24_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gTm93IHRoYXQgSSBhbSBleHBsYWluaW5nIGl0LCBpdCBmZWx0IGluc3RlYWQgb2Yg
cHJlLWluY3JlbWVudGluZw0KPiA+IGNtZF9jbGVhbnVwX2NtcGwsIGl0IHNob3VsZCBiZSBhdG9t
aWMgdmFyaWFibGUuIERvIHNlZSBhbnkgaXNzdWUgPw0KPiA+DQo+IA0KPiBZZWFoLCBhdG9taWMu
DQo+IA0KPiBBbmQgdGhlbiBJIGd1ZXNzIGZvciB0aGlzOg0KPiANCj4gICAgICAgICBpZiAocWVk
aV9jb25uLT5jbWRfY2xlYW51cF9yZXEgPiAwKSB7DQo+ICAgICAgICAgICAgICAgICBRRURJX0lO
Rk8oJnFlZGktPmRiZ19jdHgsIFFFRElfTE9HX1RJRCwNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAiRnJlZWluZyB0aWQ9MHgleCBmb3IgY2lkPTB4JXhcbiIsDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY3FlLT5pdGlkLCBxZWRpX2Nvbm4tPmlzY3NpX2Nvbm5faWQpOw0KPiAgICAg
ICAgICAgICAgICAgcWVkaV9jb25uLT5jbWRfY2xlYW51cF9jbXBsKys7DQo+ICAgICAgICAgICAg
ICAgICB3YWtlX3VwKCZxZWRpX2Nvbm4tPndhaXRfcXVldWUpOw0KPiANCj4gDQo+IHdlIG1pZ2h0
IG9ubHkgd2FudCB0byBkbyB0aGUgd2FrZV91cCBvbmNlOg0KPiANCj4gaWYgKGF0b21pY19pbmNf
cmV0dXJuKCZxZWRpX2Nvbm4tPmNtZF9jbGVhbnVwX2NtcGwpID09DQo+ICAgICBxZWRpX2Nvbm4t
PmNtZF9jbGVhbnVwX3JlcSkgew0KPiANCj4gPw0KDQpBZ3JlZSwgSSB3aWxsIHNoYXJlIHRoZSB1
cGRhdGVkIHBhdGNoLg0K
