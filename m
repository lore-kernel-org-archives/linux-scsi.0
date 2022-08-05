Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166F3C25B06
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Aug 2022 10:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiHEKJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Aug 2022 06:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237638AbiHEKJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2022 06:09:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BF96A4B3
        for <linux-scsi@vger.kernel.org>; Fri,  5 Aug 2022 03:09:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2755AZX1028532;
        Fri, 5 Aug 2022 03:09:21 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hrvtwrsh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 03:09:21 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2759hLUk006664;
        Fri, 5 Aug 2022 03:09:21 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hrvtwrsh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 03:09:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggdFvZVMANalSYF5s4wfC227O5Rkhi9DTfbDHRINoaH5vQPokmkLkdH40Glyz9Js6gKwhd5ACiwFLAqSNsc8IaRwGce1fkHRM4Fmg9Gz1+1yhFhik4MltSNf+h4njzvu6/nM0A7OjlQHeL8AExpgxpSs6Yof2cMYwEX43RMA3KRhDbPfEVuO/86zZIrLfM7qFTAjwlRxKDnZPD3wLvya9t5m6Cq4IIcZPBTwJDAbZGidMKUQo6BjYORT1ixwgHrEe+Rjywm8cYaUv7Gu5t4QBEosRbjCMeATZzRCzvnyJISNRJD0K/MS59/8424Nt3XxHgzfL3oMSl7huPmYKWYa4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyNA00l5n6/LXVeN778o3VxBxvHn19B5R8q6Qz+W+2o=;
 b=VFdK7jlcKzn2RaOSqvumbtjaRpAwexp4URz/26S8ravtEUhNTTjIAMRwTgrZM/8U49+M+tF0JLhCi+tu38d0PNAapE8LpzTBVVAUS7yMOgEZaAByc5G2CtFsoIKdNlvadbkXI3n4JDAeMwLBjKfsrGRy24JABit+BTR3/0Oaxvs6QBbg9mY9+GiuY5MKubeAztPUO2dXLCN23rrrFWAK3GM6z95EG1IBZj7GDLjITKh6QNhY7+vdT0db2/NQxxMywB0brdqYuMZeVoMwP6Z/i3Ix2qVuR/0/t+2w+3w7+xmY2HMU2g3WczTMRjGrspuy4avSSmsyF6jl+f6hb7tVPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyNA00l5n6/LXVeN778o3VxBxvHn19B5R8q6Qz+W+2o=;
 b=ieTKTmvyjQzFbo/9DzAfHISt4skyhLkm95Gk9VrDyruceuXUtO2Voan0lWKqQrpbiWBDfliiovk6fQ1gVS1xwLUjL6Fa4+Cx+/oIiK8bWzbTdXQCqub7HRBEuevmr/8sd6o+h3rYFXI1MWSAZkDq/2x8PuQhCWRGXBlL5H/w+xg=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by PH0PR18MB4670.namprd18.prod.outlook.com (2603:10b6:510:c7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 10:09:18 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::fcb1:ce3b:73e0:544c]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::fcb1:ce3b:73e0:544c%5]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 10:09:17 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Tony Battersby <tonyb@cybernetics.com>,
        Quinn Tran <qutran@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for
 quad port ISP27XX
Thread-Topic: [EXT] [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for
 quad port ISP27XX
Thread-Index: AQHYnD7EyXXoc0KD20+TqvUk10HVHq2gLaAA
Date:   Fri, 5 Aug 2022 10:09:17 +0000
Message-ID: <CO6PR18MB4500846F71746CC776958A72AF9E9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
In-Reply-To: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c9cdde1-3f2e-45eb-b0bd-08da76ca8eda
x-ms-traffictypediagnostic: PH0PR18MB4670:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aAwFVwENMydtKueJPxLWZ/FUFWpHDOf4TIcMaXBZ8SO4G8GZlUdVF5NYZOKnqcUCBSdCV4/hyf6fXoiAMCfEV951+9D/QPosLHpE1BH4gu2/r+WkfYSGQIkC8z8GgOfTVHktUNjueA9lGX8JiwKPPMDW2MHaKicdJLu06TH83svwxpLnUxlAxvLnMF+YpaylLw65hOBKXEYoD1xLJorRRTer/absKAomlICkhS0jqMiC49yVoulQdwX448js/0PvUKevz36gxzEjOuAXAV2UB7E3ekFKFKNcbcM0n1f+7xIdbbsbutGPx9kx8rDrWW8CtiyQMLRxN/jBmtIJ+/mAaqAhEHyxKQftcAmoLWAWaQKlqeep7Bcaz0D+FIysblVdJe2x8w8quobkl3tIenvoM1u/OQ97tAU1wmES4up15+jAQoJZ6TAd6HLcOz0O11sjHu7d30H7EmtsbXOjBNg4ZAqzCF09DrzUjvkEl4fMiqeEkmzQcPknXrTKxWGfmwQToKOWKNTlDkOYktLwb6DtlAwCalqzTJCuI3L93Zl8edb/tBEeHI/0FW8NyaNpZ6MDMMBKUVVxov17ZFXxh2uY5nWbNE3OUvAi40QXUEDafO2VcY03fwkvJAW6r83VQrT+nQkboSPZnXJLoz8rDsBqmwSuEGwRNB/VcHFwrQzoLVhISzShavNNc2GvPrgJpvGOnJ+KzqimITJSEDJmIN21WTghaviUOTfSszExIU8U8EXbG1QkW9VQXk0TeGxhoN1udzsEvlRefkywQAchhuiI6QB6onb4gHmQ6jdA4rB5ZeXITDuv8cqvOynkuIEBfChFyDFbVVL+IXlNXCfHzLqKWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(38070700005)(122000001)(38100700002)(83380400001)(26005)(186003)(86362001)(53546011)(6506007)(33656002)(9686003)(7696005)(110136005)(966005)(41300700001)(316002)(71200400001)(478600001)(19627235002)(64756008)(8676002)(66946007)(4326008)(66446008)(8936002)(76116006)(66556008)(5660300002)(52536014)(2906002)(66476007)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGp4ek9MZEFnNFpFeStsL0pvbk9NdEJsSGVUKzUyRjhDcDNHNW96WjZwdEpR?=
 =?utf-8?B?WWpnS21xUHVlU0NRbVlBMC9DYWJPd2NzUVRyc1kzV1F3bE9Gak5yMi9GR000?=
 =?utf-8?B?NlJJZlpxUlRzVit4UXpReHBhL1M5VWpaL1lVOUk0c0J3YjlRRng4ZUtWaE1r?=
 =?utf-8?B?Nzg4dnRuMG9mS1FEaUNPMVZlUStNR0hRUFNGUGppanNKOTVxSXJlS0NVdmhi?=
 =?utf-8?B?R0NnWXVxWmhNM1VDdm5LaUpsWnltcDZqVGk4dWFNeFBJeDdHRWUyZmlZd2k5?=
 =?utf-8?B?bm14SDVHbXJHOFgySE5rNTdMNWtTT0JjaEFUQk04SzR3WWxVZFljelJBRDVt?=
 =?utf-8?B?NEpwWTdjSjdkc2xERDNoYmNhZkdOeWNhNWFRenJzcnhFUloyS1RhQjY0SDhr?=
 =?utf-8?B?dWkrVytLeVRScHMxY3liSjJIQ0QvdWxhNVNpNVhDNk9CZVpmMG9OVlBYMGsz?=
 =?utf-8?B?anYwRlhuYzA0OVlPZSsrNER3NUJ6dkZlejRlUjBncVEyMjhmWkxESURvMC9w?=
 =?utf-8?B?OHVIMjdWemR4UG1lTWRUbVFlLzBjOEl1S1M0d0l3U3ZZUy83akFMQkxJMStw?=
 =?utf-8?B?eXJsNStYQkRiOU9pc2RCeGNyUFhvUTJpRXJYcWphcW1EelUxd3pkYUtkREIy?=
 =?utf-8?B?Z3h1Z1ZmdlMweXlKcEUzMmMrRWxweG9yY0YzbEd0VTNvYU5KMEFZcnRIOFY1?=
 =?utf-8?B?RDdOSExoMFp1SVdQL1I4KzBKeTQxN3BhN29kZlJDeDVCY21NQmErbDAyVk82?=
 =?utf-8?B?aHVQVVRwcWJmWVJqRXBOQU9OaXRZV2pqWDZvL3VUZGJhRFBrcWpyYkNoQkRh?=
 =?utf-8?B?ek9JTm13czAwbEVuVzFwaVlsZUJZQlAxbWpmUGpjMVBIb0V2bnd4MlFaZFV3?=
 =?utf-8?B?L3pFTDV3TEl1M21STmZSYmhaR3l6bVZJL1NCRHdWU1E5Z1NudVFZVVBOTlNo?=
 =?utf-8?B?WUhEM21pNGkyNTdKcHNobG1zUW9laWIrd2dBSDUveENUY0NtVUVtNldna281?=
 =?utf-8?B?bTE1amE5b0xpU3k0RkRLR1o4Z0UwcE1Cdk5NUmc1dWpNNUFjM3hPNTRkWVFO?=
 =?utf-8?B?L0JMVWhSeEd5TXpwWVhLTHpPbGsyNG45TGxvd21KRW1zcStEU0lzQjhTdDhU?=
 =?utf-8?B?MDZ0a0JBV2svL2p2YkFnR1lzSWRGYWwxK0N3ckUzbStvWW11V2NGVE1jTC9S?=
 =?utf-8?B?cEpRdmVJZTUyS05Jb2Jja1kyN2xRaUNzVFppNWx0cEc1VmViZ1ppZTB6ZHdq?=
 =?utf-8?B?YVJlNC9GTXFlSkhxRW9ZSDMra2FaQVMza1ZnT0RNZkZhck1JVmU4TXRjaXUw?=
 =?utf-8?B?eEtmSlo2OVlrOE85blUvZG40a1lnOGdsM0VJREVUeGtvRDZ0UTk1SS9YRnBR?=
 =?utf-8?B?RTFiZTUyY0pYeks3QlA4TzVsbVhFUnJwTFhhQVFwK3Fob0pBRHBFNzM0U1dy?=
 =?utf-8?B?eFhNUnNqUXZJLzZPSmZOMFpPSGxlL2V1eTZBR1JLSHhYMElDSS94NVF3aWk4?=
 =?utf-8?B?UVNVQmtxMFdBRlAzSDFVOW5tSU0xNVp3dmY1cGd4K3h3YW9SYThxRFI0elNa?=
 =?utf-8?B?a3lVbTZSOTQwZk5DTWlpaTJWRlo2Sm1uclVvbzN5a1h6S3ZFYTd4UGJJZG9M?=
 =?utf-8?B?TXozNG10WUU3ektIZ005Y0gzWGJIUlZMOWVEb2ZzeWx4aHBvWnlYbjY5RnRs?=
 =?utf-8?B?VGo2ZU9vSW90Y0xZRkJyY0FadmgrY0N5RHcxMlpVSm1NYVNxbHdwRXF0OU9i?=
 =?utf-8?B?Z1RWNVVTSEQzVS9wbU5neUVFMmlkZFBGekh0ZGY4SEg0RFlRRC9vTjZvbXBi?=
 =?utf-8?B?VWhKQ0dhMVEvM1R1R3lNNVhDckNOTVJwYmRwaHVOc09lblI5RkNVYnBEZVM2?=
 =?utf-8?B?WDhJTjMySEJWQXF1YnBpYUQ5UG5ybkN2WmZab3RubUpPOHpUQ3dyelJvTkds?=
 =?utf-8?B?MTZ3SUE2WUE3eERjNWRISWg4eGFqK3hHejl1V1gveHFyQ2JIV3JPaTYyS2ky?=
 =?utf-8?B?UHFpd01UcU1tMzUrQmVNZXNhOGdVckJpNGdDdmdMQ3VNd21lZ3h0L2RxS1pk?=
 =?utf-8?B?WFR1cFRYTkQrZ2tNRElJby93S1ExRGhkc1JKZzdrditpSzZlK2Vwd1lBY3Zs?=
 =?utf-8?Q?LnKF4YOJK2zLH/k5m/ZTyixHZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9cdde1-3f2e-45eb-b0bd-08da76ca8eda
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 10:09:17.8202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yiqfrINsg91AJbprv1jQmLhMm9/vOB2yZLlgtMLsGcLbg8EuU523igT7BcFVrvXR+dispCkB1HwOwc1NiNcjMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4670
X-Proofpoint-ORIG-GUID: xF6V3KO-9KSscjAw1KEIrJzsN4rTy8I7
X-Proofpoint-GUID: 1ox5R0YBrijvFQPzurvHtIhV6nGbqvVz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_03,2022-08-04_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9ueSBCYXR0ZXJzYnkg
PHRvbnliQGN5YmVybmV0aWNzLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKdWx5IDIwLCAyMDIy
IDc6MTQgUE0NCj4gVG86IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2ZWxsLmNvbT47IE5pbGVzaCBK
YXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+Ow0KPiBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVh
bSA8R1ItUUxvZ2ljLVN0b3JhZ2UtDQo+IFVwc3RyZWFtQG1hcnZlbGwuY29tPjsgSmFtZXMgRS5K
LiBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT47DQo+IE1hcnRpbiBLLiBQZXRlcnNlbiA8
bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBbUEFUQ0hdIHNjc2k6IHFsYTJ4eHg6IERpc2FibGUgQVRJ
TyBpbnRlcnJ1cHQgY29hbGVzY2UgZm9yIHF1YWQNCj4gcG9ydCBJU1AyN1hYDQo+IA0KPiBFeHRl
cm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBUaGlzIG1lc3NhZ2Ugd2FzIHByZXZp
b3VzbHkgc2VudCB0byBzY3N0LWRldmVsOg0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2lu
dC5jb20vdjIvdXJsP3U9aHR0cHMtDQo+IDNBX19zb3VyY2Vmb3JnZS5uZXRfcF9zY3N0X21haWxt
YW5fc2NzdC0yRGRldmVsX3RocmVhZF9kMzgxZWI4Ni0NCj4gMkRkNDQ2LTJENGY5ZS0yRDAzYzMt
MkRhYTkzZDkzZGQwNzQtMjU0MGN5YmVybmV0aWNzLmNvbV8tDQo+IDIzbXNnMzc2ODI5MTkmZD1E
d0lDYVEmYz1uS2pXZWMyYjZSMG1PeVBhejd4dGZRJnI9RkFXOXd1emJ0SA0KPiBJWkw3U1Y2M3Ny
OHJHNTlIY3R1LWVHdTBHOXB4d09YZ1EmbT01R1NTX1BuT2stazZhLQ0KPiBNUnVZTzBXaVVqNUFZ
eGd6Nng1Mzc3dWROaURNb3BKYTRwZlp1QUdkdzlENl83aEdtMCZzPVpyLQ0KPiA2NVRYcDJWLXpK
R3A3eGYzdVBBX25KSURRZGVUZUoxMVZwWXNpQktjJmU9DQo+IA0KPiBJIGFtIHVzaW5nIGEgcXVh
ZC1wb3J0IDE2IEdicHMgUUxFMjY5NEwgKElTUDIwNzEpIHdpdGggU0NTVCAzLjYgKw0KPiBxbGEy
eDAwdC0zMmdiaXQgYW5kIGtlcm5lbCA1LjE1LiAgVGhlIGZvbGxvd2luZyBvbGQgY29tbWl0IHRo
YXQgd2VudA0KPiBpbnRvIHVwc3RyZWFtIGtlcm5lbCB2NC4xNiBpcyBjYXVzaW5nIGEgcHJvYmxl
bSBmb3IgbWU6DQo+IA0KPiBjb21taXQgZDJiMjkyYzNmNmZkZWY1ODE5YTI3NmFjZDY0OTE1YmFl
NjM4NGE3Zg0KPiBBdXRob3I6IFF1aW5uIFRyYW4gPHF1aW5uLnRyYW5AY2F2aXVtLmNvbT4NCj4g
RGF0ZTogICBUaHUgRGVjIDI4IDEyOjMzOjE3IDIwMTcgLTA4MDANCj4gDQo+ICAgICBzY3NpOiBx
bGEyeHh4OiBFbmFibGUgQVRJTyBpbnRlcnJ1cHQgaGFuZHNoYWtlIGZvciBJU1AyN1hYDQo+IA0K
PiAgICAgRW5hYmxlIEFUSU8gUSBpbnRlcnJ1cHQgaGFuZHNoYWtlIGZvciBJU1AyN1hYLiBUaGlz
IHBhdGNoDQo+ICAgICBjb2FsZXNjZSBBVElPJ3MgaW50ZXJydXB0cyBmb3IgUXVhZCBwb3J0IElT
UDI3WFggYWRhcHRlci4NCj4gICAgIEludGVycnVwdCBjb2FsZXNjZSBhbGxvd3MgcGVyZm9ybWFu
Y2UgdG8gc2NhbGUgZm9yIHRoaXMNCj4gICAgIHNwZWNpZmljIGNhc2UuDQo+IA0KPiBUaGlzIGNv
bW1pdCB3YXMgcHJlc2VudCBpbiBxbGEyeHh4IHdoZW4gcWxhMngwMHQtMzJnYml0IHdhcyBmaXJz
dA0KPiBpbXBvcnRlZCBpbnRvIFNDU1QuDQo+IA0KPiBXaXRoIHRoZSAiQVRJTyBpbnRlcnJ1cHQg
Y29hbGVzY2UiIGVuYWJsZWQgYnkgdGhlIGFib3ZlIHBhdGNoLCBBVElPDQo+IGludGVycnVwdHMg
YXJlIGhhbmRsZWQgYnkgcWxhMjR4eF9tc2l4X2RlZmF1bHQoKSByYXRoZXIgdGhhbiBieQ0KPiBx
bGE4M3h4X21zaXhfYXRpb19xKCkgZm9yIHRoZSBJU1AyMDcxLiAgSSBndWVzcyB0aGlzIGlzIHN1
cHBvc2VkIHRvDQo+IGdlbmVyYXRlIGZld2VyIGludGVycnVwdHMgc28gdGhhdCBBVElPIGVudHJp
ZXMgY2FuIGJlIGhhbmRsZWQgaW4gbGFyZ2VyDQo+IGJhdGNoZXMuICBCdXQgdGhpcyBjYXVzZXMg
YSBwcm9ibGVtIHdoZXJlIHNvbWV0aW1lcw0KPiBxbHRfMjR4eF9wcm9jZXNzX2F0aW9fcXVldWUo
KSByZXR1cm5zIHdoaWxlIHRoZSBoYXJkd2FyZSBpcyBzdGlsbCBhZGRpbmcNCj4gQVRJTyBlbnRy
aWVzIHRvIHRoZSBxdWV1ZSwgYnV0IHRoZW4gdGhlIGhhcmR3YXJlIGRvZXNuJ3QgZ2VuZXJhdGUN
Cj4gYW5vdGhlciBpbnRlcnJ1cHQgdW50aWwgYSBzZXBhcmF0ZSBldmVudCBzb21ldGltZXMgbWlu
dXRlcyBsYXRlci4gIFRoaXMNCj4gbGVhdmVzIGluY29taW5nIEFUSU8gZW50cmllcyAoaS5lLiBp
bmNvbWluZyB0YXJnZXQtbW9kZSBTQ1NJIGNvbW1hbmRzKQ0KPiBpZ25vcmVkIGluIHRoZSBhZGFw
dGVyJ3MgaGFyZHdhcmUgcXVldWUgZm9yIGEgbG9uZyB0aW1lIHVudGlsIHRoZSBob3N0DQo+IHNl
bmRzIGFub3RoZXIgY29tbWFuZCBhdCBhIGRpZmZlcmVudCB0aW1lIHRvIGdlbmVyYXRlIGFuIGlu
dGVycnVwdC4NCj4gVGhlcmUgZG9lcyBub3Qgc2VlbSB0byBiZSBhbnkgdGltZW91dCBmdW5jdGlv
biB0aGF0IGdlbmVyYXRlcyBhbg0KPiBpbnRlcnJ1cHQgYWZ0ZXIgYSBzaG9ydCBwZXJpb2Qgb2Yg
aW5hY3Rpdml0eSB0byBwcm9jZXNzIHRoZSByZW1haW5kZXIgb2YNCj4gdGhlIEFUSU8gcXVldWUs
IHdoaWNoIGlzIHdoYXQgd291bGQgYmUgbmVjZXNzYXJ5IGZvciBpbnRlcnJ1cHQgY29hbGVzY2UN
Cj4gdG8gZnVuY3Rpb24gcHJvcGVybHkuDQo+IA0KPiBJbiBteSBjYXNlIEkgYW0gdXNpbmcgdmly
dHVhbCB0YXBlIGRyaXZlcywgd2hpY2ggZ2VuZXJhbGx5IHByb2Nlc3Mgb25seQ0KPiBvbmUgY29t
bWFuZCBhdCBhIHRpbWUsIHNvIHRoZXJlIHdpbGwgb2Z0ZW4gbmV2ZXIgYmUgYSAibmV4dCIgY29t
bWFuZCB0bw0KPiBnZW5lcmF0ZSBhbiBpbnRlcnJ1cHQgdW50aWwgdGhlIHByZXZpb3VzIGNvbW1h
bmQgY29tcGxldGVzLiAgSWYgdGhlDQo+IHByZXZpb3VzIGNvbW1hbmQgaXMgc3R1Y2sgaW4gdGhl
IGFkYXB0ZXIncyBBVElPIHF1ZXVlLCB0aGVuIHRoZSBob3N0DQo+IHdpbGwgdGltZW91dCBhbmQg
YWJvcnQgdGhlIGNvbW1hbmQsIGFuZCB0aGUgdGFzayBtYW5hZ2VtZW50IGZ1bmN0aW9uIHRvDQo+
IGFib3J0IHRoZSBjb21tYW5kIGdlbmVyYXRlcyB0aGUgaW50ZXJydXB0IHRoYXQgY2F1c2VzIHRo
ZSBjb21tYW5kIHRvDQo+IGZpbmFsbHkgYmUgcmVjZWl2ZWQgYnkgU0NTVCwgc28gdGhlIGNvbW1h
bmQgYXBwZWFycyB0byBoYXZlIGJlZW4gYWJvcnRlZA0KPiBpbW1lZGlhdGVseS4gIFdpdGggZGlz
ayBkcml2ZXMgdGhlIHNpdHVhdGlvbiBtaWdodCBiZSBhIGJpdCBkaWZmZXJlbnQNCj4gc2luY2Ug
YSBidXN5IGRpc2sgbWlnaHQgZ2V0IGEgc3RlYWR5IHN0cmVhbSBvZiBjb21tYW5kcyB0byBnZW5l
cmF0ZQ0KPiBhZGRpdGlvbmFsIGludGVycnVwdHMgdG8gcHJvY2VzcyB0aGUgQVRJTyBxdWV1ZSwg
YnV0IGV2ZW4gdGhhdCBpcyBub3QNCj4gZ3VhcmFudGVlZCwgc28gdGhlcmUgbWlnaHQgc3RpbGwg
YmUgcHJvYmxlbXMuDQo+IA0KPiBJIHRyaWVkIHRvIGZpeCB0aGUgcHJvYmxlbSBieSBtb2RpZnlp
bmcgcWxhMjR4eF9tc2l4X2RlZmF1bHQoKSB0byBjYWxsDQo+IHFsdF8yNHh4X3Byb2Nlc3NfYXRp
b19xdWV1ZSgpIGJlZm9yZSB3cnRfcmVnX2R3b3JkKCZyZWctPmhjY3IsDQo+IEhDQ1JYX0NMUl9S
SVNDX0lOVCkgaW5zdGVhZCBvZiBhZnRlciwgYnV0IHRoYXQgZGlkbid0IGhlbHAuICBUaGUgcHJv
YmxlbQ0KPiB3YXMgc29sdmVkIGJ5IGRpc2FibGluZyB0aGUgQVRJTyBpbnRlcnJ1cHQgY29hbGVz
Y2UgZmVhdHVyZSBhbmQNCj4gcmUtZW5hYmxpbmcgdGhlIGRlZGljYXRlZCBBVElPIE1TSS1YIGlu
dGVycnVwdCAocWxhODN4eF9tc2l4X2F0aW9fcSgpKQ0KPiBmb3IgY2FsbGluZyBxbHRfMjR4eF9w
cm9jZXNzX2F0aW9fcXVldWUoKS4gIEFub3RoZXIgd29ya2Fyb3VuZCBpcyB0byB1c2UNCj4gcWwy
eGVuYWJsZW1zaXg9MCwgYnV0IG9mIGNvdXJzZSBrZWVwaW5nIE1TSS1YIGVuYWJsZWQgaXMgYmV0
dGVyLg0KPiANCj4gVGhlIHBhdGNoIGJlbG93IGlzIGFnYWluc3QgdGhlIHVwc3RyZWFtIExpbnV4
IGtlcm5lbC4gIEl0IGNhbiBiZSBhcHBsaWVkDQo+IHRvIFNDU1Qgd2l0aCAicGF0Y2ggLXA0IiBm
cm9tIHRoZSBxbGEyeDAwdC0zMmdiaXQgZGlyZWN0b3J5Lg0KPiANCj4gSWYgc29tZW9uZSByZWFs
bHkgd2FudHMgdG8ga2VlcCB0aGUgaW50ZXJydXB0IGNvYWxlc2NlIGZlYXR1cmUsIGl0IGNvdWxk
DQo+IGJlIHR1cm5lZCBpbnRvIGEgbW9kdWxlIHBhcmFtZXRlciBpbnN0ZWFkLg0KPiANCj4gRnJv
bSBlNTg4OGNlNWRiZmZmZjJkMzhkOWRhZmQ0ODQxZDZkM2JjZGE0MzY1IE1vbiBTZXAgMTcgMDA6
MDA6MDANCj4gMjAwMQ0KPiBGcm9tOiBUb255IEJhdHRlcnNieSA8dG9ueWJAY3liZXJuZXRpY3Mu
Y29tPg0KPiBEYXRlOiBUaHUsIDcgSnVsIDIwMjIgMTU6MDg6MDEgLTA0MDANCj4gU3ViamVjdDog
W1BBVENIXSBzY3NpOiBxbGEyeHh4OiBEaXNhYmxlIEFUSU8gaW50ZXJydXB0IGNvYWxlc2NlIGZv
ciBxdWFkIHBvcnQNCj4gSVNQMjdYWA0KPiANCj4gVGhpcyBwYXJ0aWFsbHkgcmV2ZXJ0cyBjb21t
aXQgZDJiMjkyYzNmNmZkZWY1ODE5YTI3NmFjZDY0OTE1YmFlNjM4NGE3Zi4NCj4gDQo+IEZvciBz
b21lIHdvcmtsb2FkcyB3aGVyZSB0aGUgaG9zdCBzZW5kcyBhIGJhdGNoIG9mIGNvbW1hbmRzIGFu
ZCB0aGVuDQo+IHBhdXNlcywgQVRJTyBpbnRlcnJ1cHQgY29hbGVzY2UgY2FuIGNhdXNlIHNvbWUg
aW5jb21pbmcgQVRJTyBlbnRyaWVzIHRvDQo+IGJlIGlnbm9yZWQgZm9yIGV4dGVuZGVkIHBlcmlv
ZHMgb2YgdGltZSwgcmVzdWx0aW5nIGluIHNsb3cgcGVyZm9ybWFuY2UsDQo+IHRpbWVvdXRzLCBh
bmQgYWJvcnRlZCBjb21tYW5kcy4gIFNvIGRpc2FibGUgaW50ZXJydXB0IGNvYWxlc2NlIGFuZA0K
PiByZS1lbmFibGUgdGhlIGRlZGljYXRlZCBBVElPIE1TSS1YIGludGVycnVwdC4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFRvbnkgQmF0dGVyc2J5IDx0b255YkBjeWJlcm5ldGljcy5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jIHwgMTAgKystLS0tLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCj4gYi9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCj4gaW5kZXggY2I5N2Y2MjU5NzBkLi44MGZk
OTk4MGRmYzkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQu
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCj4gQEAgLTY5MzIs
MTQgKzY5MzIsOCBAQCBxbHRfMjR4eF9jb25maWdfcmluZ3Moc3RydWN0IHNjc2lfcWxhX2hvc3Qg
KnZoYSkNCj4gDQo+ICAJaWYgKGhhLT5mbGFncy5tc2l4X2VuYWJsZWQpIHsNCj4gIAkJaWYgKElT
X1FMQTgzWFgoaGEpIHx8IElTX1FMQTI3WFgoaGEpIHx8IElTX1FMQTI4WFgoaGEpKSB7DQo+IC0J
CQlpZiAoSVNfUUxBMjA3MShoYSkpIHsNCj4gLQkJCQkvKiA0IHBvcnRzIEJha2VyOiBFbmFibGUg
SW50ZXJydXB0IEhhbmRzaGFrZQ0KPiAqLw0KPiAtCQkJCWljYi0+bXNpeF9hdGlvID0gMDsNCj4g
LQkJCQlpY2ItPmZpcm13YXJlX29wdGlvbnNfMiB8PQ0KPiBjcHVfdG9fbGUzMihCSVRfMjYpOw0K
PiAtCQkJfSBlbHNlIHsNCj4gLQkJCQlpY2ItPm1zaXhfYXRpbyA9IGNwdV90b19sZTE2KG1zaXgt
PmVudHJ5KTsNCj4gLQkJCQlpY2ItPmZpcm13YXJlX29wdGlvbnNfMiAmPQ0KPiBjcHVfdG9fbGUz
Mih+QklUXzI2KTsNCj4gLQkJCX0NCj4gKwkJCWljYi0+bXNpeF9hdGlvID0gY3B1X3RvX2xlMTYo
bXNpeC0+ZW50cnkpOw0KPiArCQkJaWNiLT5maXJtd2FyZV9vcHRpb25zXzIgJj0gY3B1X3RvX2xl
MzIofkJJVF8yNik7DQo+ICAJCQlxbF9kYmcocWxfZGJnX2luaXQsIHZoYSwgMHhmMDcyLA0KPiAg
CQkJICAgICJSZWdpc3RlcmluZyBJQ0IgdmVjdG9yIDB4JXggZm9yIGF0aW8gcXVlLlxuIiwNCj4g
IAkJCSAgICBtc2l4LT5lbnRyeSk7DQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoLg0KUmV2aWV3ZWQt
Ynk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo=
