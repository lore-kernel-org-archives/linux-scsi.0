Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7D2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8358365101
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhCPQ0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:26:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbhCPQZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:25:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGJobt134108;
        Tue, 16 Mar 2021 16:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=w3HF5M52j7/B8AymMlRL8aXIgO77XNglJZ73MrgeGzw=;
 b=DkDnyzjzktZHowFE4ENygxugUrCQ32h33hDcSmIuEKf4DS49541/n6PFC0DXVPM2Gj70
 xApLBPvUaWkykkKN/2Y0EtZjiyhRxBJI7rPWqQJ5D6DYRRU7HStYw+jWfgsYRuXGdT/S
 uAL1hcr82t7qNBdg+OpOFv+sgr1okXxLOxo6EYn46nseHglpuihieOdZk1q/B1yipAhs
 k0xWwIFcb6BkGGCmiLte83e2knG0cCcbfZ5g7iGjrw0bRLd9/lWTXYFFJvRcFnOLPgIg
 m5lFc/1oZq76zko3n1kKGafEbhH6/khKO3PLKnvyXbTw9KlDZMcrU4HBy9nvzEoRGHYN 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1nruje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:25:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGM1sl178734;
        Tue, 16 Mar 2021 16:25:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3797a1dt5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdfbTEJbKNGGd2wRBR7o6bJ1uO7f/O//7zSfWfaJtXU8KpwNuphZ9EBXopBD9Rn/xy7uVBAU1HmCXBZtnltJKc6vrIzFMQTM4xQXhvnfvNoAOLZJ06hyS+nuHGdd3+xc9N2QSi33MH3VmH4h2qdZCd++mhBNPXNJn0Pan157H5YefiNdYIkvPHX9oH7e+hjTqKaRGQas0PxaChm9wge4xOscoGExMST5zLELNHAS+8TmkvW0KcsJSaAykHLNg4jEnxDbffdbZQoOE+4SDLLtVVRh5bj8s7LWv/njOj8Lzt56MZJjZCfP8vnAMrOZXsOf+xNP4qN/mEIANOvjts7v2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3HF5M52j7/B8AymMlRL8aXIgO77XNglJZ73MrgeGzw=;
 b=CxjkYqX5bi+k4I3Q0Go1aDNEyxBRsZVUySfIBibAhCwn9Rf1aF08HhpHb5HE0ZNth1AAqtqxylRrngrtmlm1R/Veyf7ldhyIK1gmftQ2ft0YIZsHxWRET5LuUtTY3ctbuiDvv1UIIC3vWdP8dxmaUxifnH9gQaR3EXbCdRtKMJUE76+iVrpiYAuWT4KGlkKYAyCOgnTD735erV6IH8UoqReq/oCVIzeFe3/I17z4CD89cglJ/1Um1sVZmNaoniiJhZ9O/sNaFUN1jRdqdkh6UK4Qcpy27ax4wRVxMyRpl8mk6eC5fH9T7PPjDXnePPU6Y37m1hMHESKI3balMLEz4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3HF5M52j7/B8AymMlRL8aXIgO77XNglJZ73MrgeGzw=;
 b=Xb0azunxPvK4UvpFS+p5EPx8u4iPZ0/xtUFscDtLqh3gjA7Tkj56UPiH05K20N7pPC8ztmhUuMHzwQbUb39l8B3WU6wPEp1XV5TUSL69VxwoZk0A5+D/uQJYSjghrcAIZcAeOMDdpJxod+19L+HvcsqWZqXMJxqM4tlb5OUzKWA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 16 Mar
 2021 16:25:46 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:25:46 +0000
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
Thread-Index: AQHXGhhv+4Y3gXBOHUGR8Dvotigd1KqGzdeA
Date:   Tue, 16 Mar 2021 16:25:45 +0000
Message-ID: <8EE7F726-C6BA-417B-BD68-5B2FDE5F74FC@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77a99925-724d-481c-a714-08d8e8982707
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB473237096D4ADDF70394B000E66B9@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcUu56MEOhCEDcnqNynyEj2uiw8QdxOFp8erNYAKjzGdsL8NZtaBIhRkWXFXGbJGosrhjb1z0wyWEA9fki+luIXk2Tw2hEXFDaSSNNLttqilrxpkxrOGyhyHPkuMaQh5bwPHHx8rDntCvT/TLc7wSGDz6tQ9jyh6TCQbEK8dOC1MCTPisqsbpnAiF28tStSraSRCqDL5swD1i7wXlSACG6ybVsbnp5byCCRg7gnQrFdr5sGMe/no8G2p0wpKbJdGrGNDQhGtQ5lpGnnGoTD+54PrSk3bFx61Cu5fiQbx7VNNpU90ctc/APkAo0J2A6YkthJ3gY4fOEmhC0NTQNcN+uTqboEtGrHAKDvwE3vHD87wiXE+cgjq0gy2Ejc3GfXywLT+Ds33YO5AS17hqbf3/MHVW5Y5ajnh41DPRI6GACTL/WT8HVWtU/UQn0O9gTtYfSPgnCZVnTn6CzH+dNcrFUJH/CPg2yG4cpqGF3pKHi+0pNxMx9+OYBkADufun+TOwC+oWDXrXZcfyRTKMtYHVT9U8Cm/1snSvdg23/RaEmJPDS6enHpqOE1V6DX/hSjWHyvFs89I9iuUeWMlwrz+p3thJibUk1m36Ciq/O0lYoiQgHOkBp5Prsdl7yVsoWNf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(39860400002)(376002)(366004)(6512007)(83380400001)(71200400001)(5660300002)(8936002)(316002)(8676002)(54906003)(6506007)(6916009)(6486002)(478600001)(2906002)(4326008)(66556008)(66446008)(44832011)(76116006)(66946007)(66476007)(64756008)(2616005)(86362001)(36756003)(33656002)(186003)(26005)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R3lmcDlDeWxwVWJaQ0pzL2FnQnFUcTFMR01ldHFYZ01ST0RXVEQ3bFd2MWlz?=
 =?utf-8?B?SG03WVVtZ0FyUHhsSzZjNnF6RzJCQUswYlZvWWp6ZnVCaVRkZGhTVHM5Um13?=
 =?utf-8?B?cVY0amNYcFdCbGtBb1M2WG1XaVZ5TStUeTgvNnBGc3p0am9QYTg5eWE1UWlH?=
 =?utf-8?B?NGVlWUxlTFBmRm0rc2RSd0JlVVljMElmdmZ5NWhMUVU3TGlSZ2JiV1k2ZWtR?=
 =?utf-8?B?QjBwOEo0VDBWbjZEVHpPblpYVEoxaE8wUloyUHlWdEJmb2xqOUwzZkhrTmRD?=
 =?utf-8?B?Wkl3U29pRVdQVjNSM3JKaGl4UXdpZVZSMG40R1Z3UjFWK2dValVRMWlzOUVn?=
 =?utf-8?B?Sy9oV1JxMDNudmhQSTFEYUloYTRGalQzZEFqd2d2Zmg1UWw3WlEzT3REeHZS?=
 =?utf-8?B?MFpneG1iNE5CTXZ2SFlSMS9UVHBRQTk2Nnd0eitmcTNYMU4vTUN0SHF4Unp4?=
 =?utf-8?B?ZEVQdzM2NlZLTUlLZFJWSFFROU54eGFacG5YSk1BQTU1Q2NlV0RrZDFocGRN?=
 =?utf-8?B?VG5LQ2pxUm42dVh1blE0QzJXbDFPanN6Qlo1M3hUdzllR2VQclZpSi9LR1FF?=
 =?utf-8?B?bDlXSVZCbjF2dU9XM1ZiQW96V21YRk9jSmd5TEc4Z2lFOWpDMzZnd2JkYkVr?=
 =?utf-8?B?QkFtRlRhYkZoWDQydS95WGNCcmFMcjlVdW1YWndSTEc0VjBmRFhBSWxKRm9Q?=
 =?utf-8?B?UXJBRUozR3lFU0pNYjZwUlZITkdId3pzSnRSMWhPUmZZbHlMa2VCa3dVa0Zm?=
 =?utf-8?B?YUx2Z05yNFpBbUtBbGVRTGU1OUNTOVdIOUE5QUsvY0ZjanJIOHlXT3RZY1c3?=
 =?utf-8?B?ci9hU3NPNHBCdlM4bWlmT1lvWEV6ZVdCd09ta3FMbzY2QkM1RHIzR1I3YmlW?=
 =?utf-8?B?S2Fmd20ydzJXMTNJUXFqOGc2MDBFTERremxRLzlPL0Y5V1hZMVhlRkJwNU05?=
 =?utf-8?B?dytxTlpHMGFqbENCSG03RkNNamZRQ01lMjRCdjdlZlpxZEFCT2JJZm5hc0hG?=
 =?utf-8?B?NHluV0k5UHBEOHBWaldIMUdZcmxTTVR1aUdTZ2hKZ2lLNTQyTDRSZ2cvQ2Ix?=
 =?utf-8?B?UG5ydUdxR0ZPUngwcmFQRVRtaEJyVEtzYTBya0p5NVVjb2VhWWk4YVoxU0pI?=
 =?utf-8?B?Z0lSbWdMNThGS0NXdEZCOUxyUXFDY2lUblZReFJmaVlvdE9RNm5pbS8rNncv?=
 =?utf-8?B?RXNsVnNUMkYrVDJZSzhvekkzdCsxMzN3NUxJTnpBREw5K1BoN2tUMVRHWFNs?=
 =?utf-8?B?dy96YytYUVVrRFR5ZlZ1RWNJWVdRVk5nbmtEMllOU25TMTUzUzhJTDZSQ0FH?=
 =?utf-8?B?MEhVcTFtU3dYbDkvSThMb0Z3ZS9SMHo3dy84WWpJYkVrVWs0dGU1QmtVRjVN?=
 =?utf-8?B?MnB6TXhqSmlJc25teXdCK1FyU3Zqc2pJei95ckFqeHdVYVhlaS90N09oTHo1?=
 =?utf-8?B?YitQVDBBZzBNVXhhTVM1cnpvRU1VZEtHWXZQRlAyZ3ljRjIrMC9MbTZsSWRX?=
 =?utf-8?B?eE9jS1RRZ2picUNmR1M1WGxSRHRhcmU0VWQyc2VXMWJiZXdxeWE4MElHdGd3?=
 =?utf-8?B?OEZBaU95STlRbEtPNjFvcU1SOWc4MSs2U215Sk03YzhXbzE4R2xlUGFHZE1q?=
 =?utf-8?B?K2JGbmcwNURjci83ZVltSkpTOW1GcERlZ3pNekRLQ1gvdHdoM3lsOU9UeUta?=
 =?utf-8?B?LzZRNGd1RTNwa2xIZExIVG9Qazl1b1BoREJRU1lBem9LNkpaRFQwZVd1Tk1j?=
 =?utf-8?B?V2VtNXg2ckd2ZzQ0blRvVmg3ZWdJZVhsMCtOU1dra2wxSVI2S1ZqSFI5Rld3?=
 =?utf-8?B?UXZvUGZ1NVhCb0FSZHpnQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <182128653A2F5D46A53D9C3CADF7555C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a99925-724d-481c-a714-08d8e8982707
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:25:45.9741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mcCkx7dc9MYTYLJgeiSMEyw1UxoGRcBMwHF6dSgX51oLf8bf+/nNIfOJpVXa7HiuIeEftZCno2Rr80ZD+wLR/s0MXx3X7SIJz66Kl+aD15A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gTWFyIDE1LCAyMDIxLCBhdCAxMDo1NiBQTSwgQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KPiANCj4gQ2FsbGluZyB2aGEtPmh3LT50Z3QudGd0X29w
cy0+ZnJlZV9jbWQoKSBmcm9tIHFsdF94bWl0X3Jlc3BvbnNlKCkgaXMgd3JvbmcNCj4gc2luY2Ug
dGhlIGNvbW1hbmQgZm9yIHdoaWNoIGEgcmVzcG9uc2UgaXMgc2VudCBtdXN0IHJlbWFpbiB2YWxp
ZCB1bnRpbCB0aGUNCj4gU0NTSSB0YXJnZXQgY29yZSBjYWxscyAucmVsZWFzZV9jbWQoKS4NCj4g
DQo+IEZpeGVzOiAwZGNlYzQxYWNiODUgKCJzY3NpOiBxbGEyeHh4OiBNYWtlIHN1cmUgdGhhdCBh
Ym9ydGVkIGNvbW1hbmRzIGFyZSBmcmVlZCIpDQo+IENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFy
dmVsbC5jb20+DQo+IENjOiBNaWtlIENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5j
b20+DQo+IENjOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+
DQo+IENjOiBEYW5pZWwgV2FnbmVyIDxkd2FnbmVyQHN1c2UuZGU+DQo+IFNpZ25lZC1vZmYtYnk6
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jICB8IDEzICsrKysrLS0tLS0tLS0NCj4gZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvdGNtX3FsYTJ4eHguYyB8ICA0IC0tLS0NCj4gMiBmaWxlcyBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90
YXJnZXQuYw0KPiBpbmRleCBkNjM2NmE0NjI4M2UuLjVlOGIyNjUzZTEzNCAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jDQo+ICsrKyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV90YXJnZXQuYw0KPiBAQCAtMzIyMiw4ICszMjIyLDcgQEAgaW50IHFsdF94
bWl0X3Jlc3BvbnNlKHN0cnVjdCBxbGFfdGd0X2NtZCAqY21kLCBpbnQgeG1pdF90eXBlLA0KPiAJ
aWYgKCFxcGFpci0+Zndfc3RhcnRlZCB8fCAoY21kLT5yZXNldF9jb3VudCAhPSBxcGFpci0+Y2hp
cF9yZXNldCkgfHwNCj4gCSAgICAoY21kLT5zZXNzICYmIGNtZC0+c2Vzcy0+ZGVsZXRlZCkpIHsN
Cj4gCQljbWQtPnN0YXRlID0gUUxBX1RHVF9TVEFURV9QUk9DRVNTRUQ7DQo+IC0JCXJlcyA9IDA7
DQo+IC0JCWdvdG8gZnJlZTsNCj4gKwkJcmV0dXJuIDA7DQo+IAl9DQo+IA0KPiAJcWxfZGJnX3Fw
KHFsX2RiZ190Z3QsIHFwYWlyLCAweGUwMTgsDQo+IEBAIC0zMjM0LDggKzMyMzMsOSBAQCBpbnQg
cWx0X3htaXRfcmVzcG9uc2Uoc3RydWN0IHFsYV90Z3RfY21kICpjbWQsIGludCB4bWl0X3R5cGUs
DQo+IA0KPiAJcmVzID0gcWx0X3ByZV94bWl0X3Jlc3BvbnNlKGNtZCwgJnBybSwgeG1pdF90eXBl
LCBzY3NpX3N0YXR1cywNCj4gCSAgICAmZnVsbF9yZXFfY250KTsNCj4gLQlpZiAodW5saWtlbHko
cmVzICE9IDApKQ0KPiAtCQlnb3RvIGZyZWU7DQo+ICsJaWYgKHVubGlrZWx5KHJlcyAhPSAwKSkg
ew0KPiArCQlyZXR1cm4gcmVzOw0KPiArCX0NCj4gDQo+IAlzcGluX2xvY2tfaXJxc2F2ZShxcGFp
ci0+cXBfbG9ja19wdHIsIGZsYWdzKTsNCj4gDQo+IEBAIC0zMjU1LDggKzMyNTUsNyBAQCBpbnQg
cWx0X3htaXRfcmVzcG9uc2Uoc3RydWN0IHFsYV90Z3RfY21kICpjbWQsIGludCB4bWl0X3R5cGUs
DQo+IAkJCXZoYS0+ZmxhZ3Mub25saW5lLCBxbGEyeDAwX3Jlc2V0X2FjdGl2ZSh2aGEpLA0KPiAJ
CQljbWQtPnJlc2V0X2NvdW50LCBxcGFpci0+Y2hpcF9yZXNldCk7DQo+IAkJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZShxcGFpci0+cXBfbG9ja19wdHIsIGZsYWdzKTsNCj4gLQkJcmVzID0gMDsNCj4g
LQkJZ290byBmcmVlOw0KPiArCQlyZXR1cm4gMDsNCj4gCX0NCj4gDQo+IAkvKiBEb2VzIEYvVyBo
YXZlIGFuIElPQ0JzIGZvciB0aGlzIHJlcXVlc3QgKi8NCj4gQEAgLTMzNTksOCArMzM1OCw2IEBA
IGludCBxbHRfeG1pdF9yZXNwb25zZShzdHJ1Y3QgcWxhX3RndF9jbWQgKmNtZCwgaW50IHhtaXRf
dHlwZSwNCj4gCXFsdF91bm1hcF9zZyh2aGEsIGNtZCk7DQo+IAlzcGluX3VubG9ja19pcnFyZXN0
b3JlKHFwYWlyLT5xcF9sb2NrX3B0ciwgZmxhZ3MpOw0KPiANCj4gLWZyZWU6DQo+IC0JdmhhLT5o
dy0+dGd0LnRndF9vcHMtPmZyZWVfY21kKGNtZCk7DQo+IAlyZXR1cm4gcmVzOw0KPiB9DQo+IEVY
UE9SVF9TWU1CT0wocWx0X3htaXRfcmVzcG9uc2UpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvdGNtX3FsYTJ4eHguYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3RjbV9xbGEy
eHh4LmMNCj4gaW5kZXggMzA5NTlmOGRhMDY1Li4xNTY1MGEwYmRlMDkgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3RjbV9xbGEyeHh4LmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvdGNtX3FsYTJ4eHguYw0KPiBAQCAtNjUzLDcgKzY1Myw2IEBAIHN0YXRpYyBpbnQg
dGNtX3FsYTJ4eHhfcXVldWVfZGF0YV9pbihzdHJ1Y3Qgc2VfY21kICpzZV9jbWQpDQo+IHsNCj4g
CXN0cnVjdCBxbGFfdGd0X2NtZCAqY21kID0gY29udGFpbmVyX29mKHNlX2NtZCwNCj4gCQkJCXN0
cnVjdCBxbGFfdGd0X2NtZCwgc2VfY21kKTsNCj4gLQlzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhh
ID0gY21kLT52aGE7DQo+IA0KPiAJaWYgKGNtZC0+YWJvcnRlZCkgew0KPiAJCS8qIENtZCBjYW4g
bG9vcCBkdXJpbmcgUS1mdWxsLiAgdGNtX3FsYTJ4eHhfYWJvcnRlZF90YXNrDQo+IEBAIC02NjYs
NyArNjY1LDYgQEAgc3RhdGljIGludCB0Y21fcWxhMnh4eF9xdWV1ZV9kYXRhX2luKHN0cnVjdCBz
ZV9jbWQgKnNlX2NtZCkNCj4gCQkJY21kLT5zZV9jbWQudHJhbnNwb3J0X3N0YXRlLA0KPiAJCQlj
bWQtPnNlX2NtZC50X3N0YXRlLA0KPiAJCQljbWQtPnNlX2NtZC5zZV9jbWRfZmxhZ3MpOw0KPiAt
CQl2aGEtPmh3LT50Z3QudGd0X29wcy0+ZnJlZV9jbWQoY21kKTsNCj4gCQlyZXR1cm4gMDsNCj4g
CX0NCj4gDQo+IEBAIC02OTQsNyArNjkyLDYgQEAgc3RhdGljIGludCB0Y21fcWxhMnh4eF9xdWV1
ZV9zdGF0dXMoc3RydWN0IHNlX2NtZCAqc2VfY21kKQ0KPiB7DQo+IAlzdHJ1Y3QgcWxhX3RndF9j
bWQgKmNtZCA9IGNvbnRhaW5lcl9vZihzZV9jbWQsDQo+IAkJCQlzdHJ1Y3QgcWxhX3RndF9jbWQs
IHNlX2NtZCk7DQo+IC0Jc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSA9IGNtZC0+dmhhOw0KPiAJ
aW50IHhtaXRfdHlwZSA9IFFMQV9UR1RfWE1JVF9TVEFUVVM7DQo+IA0KPiAJaWYgKGNtZC0+YWJv
cnRlZCkgew0KPiBAQCAtNzA4LDcgKzcwNSw2IEBAIHN0YXRpYyBpbnQgdGNtX3FsYTJ4eHhfcXVl
dWVfc3RhdHVzKHN0cnVjdCBzZV9jbWQgKnNlX2NtZCkNCj4gCQkgICAgY21kLCBrcmVmX3JlYWQo
JmNtZC0+c2VfY21kLmNtZF9rcmVmKSwNCj4gCQkgICAgY21kLT5zZV9jbWQudHJhbnNwb3J0X3N0
YXRlLCBjbWQtPnNlX2NtZC50X3N0YXRlLA0KPiAJCSAgICBjbWQtPnNlX2NtZC5zZV9jbWRfZmxh
Z3MpOw0KPiAtCQl2aGEtPmh3LT50Z3QudGd0X29wcy0+ZnJlZV9jbWQoY21kKTsNCj4gCQlyZXR1
cm4gMDsNCj4gCX0NCj4gCWNtZC0+YnVmZmxlbiA9IHNlX2NtZC0+ZGF0YV9sZW5ndGg7DQoNCkN1
cmlvdXMg4oCmLiBXaGF0IHRyaWdnZXJlZCB0aGlzIHJldmVydD8gQ2FuIHlvdSBzaGFyZSB5b3Vy
IG1vdGl2YXRpb24gZm9yIHRoaXMgcmV2ZXJ0Lg0KDQotLQ0KSGltYW5zaHUgTWFkaGFuaQkgT3Jh
Y2xlIExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
