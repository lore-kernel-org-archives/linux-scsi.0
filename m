Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F65EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159D864EFD
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbhCDAdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231633AbhCCQQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 11:16:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123FtPh6030991;
        Wed, 3 Mar 2021 08:13:40 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 370p7nseuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:40 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123GDdef028190;
        Wed, 3 Mar 2021 08:13:39 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0b-0016f401.pphosted.com with ESMTP id 370p7nseug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZpJIpFyK8xfug5uCq2w9kkMkfhk7+TuTTRqc3k15OpNvI5nFRujQ1dYKInf9x9ArVXpl2JAQS8g0LSLGuhv88ZLCeeonMIA1tw8VvFWyaFlcAVCnAm1f/p9GMC6xIGtd55Tgh6w3t87KzU2Yh802KsUJAMUu1TadRHlAfc6zMfCGbqjRLBwXk9dqb37r3beI2r398tuyU8gtqpIaHz4c7B7QzpQsKY3OMeYFFzDo2C7/vLw+Pxlv1HaKgS4MjZ/gX6XbVqziliBCtfvgeIbizpsVg9mtmtzvR20AEfNUAynROlIkf1l3IfGa+CWxYzKfZSuK9ExutzfFhg7dwHqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cslD1/hCr9Avkq3jjQF6wC9xouKRjtLMyzO0XkskYLM=;
 b=kVoC4j/o1Oo2L74jrEhX1fxPaOU1wxvSDvPN1ZebhY6KpcCKYlkkIzlcBxGRo6S8dQKKnc2t20GyBp1KOEwHWD9bmDffalCgjhNNMOQia3H18G+IpPpkXAxqiW/8z3PW8ONIgNRMrTZRSR46PrdrpaHX7uDu6H7gHt1eOY+2RCTcSQxowVrlNaN7r8PnR+mjpWqSCupDFWHceHJx5iwdgWpfuJ+1TSxmRiq9LOtw7zhXKIGDtBM9rUQc4w1mDg/8U4DEPlWRijPtqz3CIv2dJUaPFUZS1+p17YjiY5e2JjMwWFz20iV14E1a0igSv5N9UZ5ttBa9aZZdZpwV9wyIAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cslD1/hCr9Avkq3jjQF6wC9xouKRjtLMyzO0XkskYLM=;
 b=QVmSc9moXM2u+F3Lt5fudyd7Km1u4dudzrJoYqZyS8/9a0vKXlhXNAlByz09vAWEQsn2GiHgAUPaejm/lstZaPG+m7uJLQYOlXf2xSp08Qjgw6UviIOsAz6gWYw5Ds47mEf1pAB8b+GbWkVa5/k1i69DufMiR3mfvP4rbibXBvI=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB2986.namprd18.prod.outlook.com (2603:10b6:5:166::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 16:13:22 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:13:22 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 19/30] scsi: qla4xxx: ql4_mbx: Fix kernel-doc
 formatting and misnaming issue
Thread-Topic: [EXT] [PATCH 19/30] scsi: qla4xxx: ql4_mbx: Fix kernel-doc
 formatting and misnaming issue
Thread-Index: AQHXEDwjPpn/+sYU6Uq+c4GpaTJiFqpyb7eg
Date:   Wed, 3 Mar 2021 16:13:22 +0000
Message-ID: <DM6PR18MB305223796B8D81C044623F21AF989@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
 <20210303144631.3175331-20-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-20-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.94.50.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ff3ecfa-7307-403c-998c-08d8de5f44a0
x-ms-traffictypediagnostic: DM6PR18MB2986:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2986125C07DD9216EE0F52D1AF989@DM6PR18MB2986.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2muGtjEzcbl9ttAwqbogcgNrSihD1C1VHF6oOfAtpzBmN5zz5XViyMxFi5NE+oH4omWv4ahmlVn8+aYpJpi2ODN/jfuKfUEJ1ma+iEtl/R8dVa+kwEZa1VSdloZspfBodZ5I51Y5sVa/QRASGrbcrmEFdpeUv9yVwnIHMeN4729aSTrnV5ZSd+qrY2jLgT/YS0XTjhvRYr1elgkw1e3rwGLERGjxn59Fg9cLkPgE3b3FiSmb1JlvkJUgspc0WMoJpK1CP5/kP8NrGCNzbo+tQMQRBVfRw9SP2p+0V9bV+ONg497uQKYte0sZr8ddp7/evFGj4E+5vcWlg2FmLP3a/AuiAGjSDCxCaIccMWCv8aWbqMCOqRG4ntmF4cR8AqNpNgQ4qkMZba5xH0nhg/dT9vlxH7uzmCygwSOHx+StXQVc2tYv8y2q18ry0aqnanKQTucNaktTcQcDNObPYQ8cGRfX/OJ73AvgItqbjUovm01OEWvMohV8diTCvON38voydiByT9lcjQ5O6NaAC514WLew3HSFH5ROIyuRHDR+paCPy95hRD+Nbzy1KkjY9tZG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(6506007)(53546011)(9686003)(52536014)(86362001)(26005)(55016002)(7696005)(2906002)(5660300002)(8936002)(6916009)(8676002)(4326008)(55236004)(316002)(186003)(478600001)(54906003)(66476007)(33656002)(66556008)(66446008)(64756008)(76116006)(71200400001)(66946007)(83380400001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eU1vZDBGUkhVamNuSHFRb1BiQTB1REp6clBEK3VyTE5Vbm52UXF0VlJCMEE1?=
 =?utf-8?B?NCtwRFFRYTlSN3FTbm5PTkRUNmZvT2JaSjd0bEpMUFJlS24zN3pEb0RmS0Y1?=
 =?utf-8?B?bW8vTDU3TkhGdjRDcGdEU1BWYjk1SEZ0TkdJQ0k1RXhBZC9mQnF2SlNua2ov?=
 =?utf-8?B?SDViVWZoOTNpa0E0R2JZM3lES2xTQkR0eVBjSncxUVYvSDFwS09aU25Gdm9m?=
 =?utf-8?B?dUtlaTVpVXc2REdhakJBWGYzdUZFK2hFeGFKeDEvVXVWT0FJYnNPdUYwMWZy?=
 =?utf-8?B?SzczQjJRcjAyT0lYVlM1ZzVxWHBpdittUDAzYy9sNW5ZcXgxTzNCZTRmV21F?=
 =?utf-8?B?aG51OE5XS2RlckpiWmtzNEF3VlB4OWdKSUtWSG9LTTFIVm5reGcweERxSXc3?=
 =?utf-8?B?NFFtYkErbTRBQlpoNWU4L2drejlBejdhKzFnZ2FSOFE3WDZCQktOMTFrbnJx?=
 =?utf-8?B?WlZzNCs0OVJsM0p2S2ppY2dIRzN1WUFRS1hGWWdFWU4vNHd4T3R3Sjh3OXpk?=
 =?utf-8?B?ak1Lc1RaZk1MbVk2M2cxUlowYTRwdm5kQjcvNU5NaEVyVm42TjlxNHdnenNS?=
 =?utf-8?B?aEJiMUhFRzdpNUp2RUtKSnBMRTRRUHg4QWxpTXc0LzBiT0ZZbFMwVGhxVmZ3?=
 =?utf-8?B?aytxRGhFcURPY1pWM1piTlM0OW5sS2dYN3pVcGRTY3dkRkxlbGUvSFNKQUND?=
 =?utf-8?B?TkZhTjhraUszcTlCT2JzOFAzVTdNRkh2U2lVb3VRTUFhYVFJNFpuSG5qRFBV?=
 =?utf-8?B?UURDNmlNOUlVbEVnTXZlQUdScnlTbnpOT2I4Q01kY01aRmZNeFdFa3IxMFJP?=
 =?utf-8?B?QWFYMVNMdHo3ZWlIVmRPZHNHSmE0Z1d5akVtQUFDejBESEtpcnlUazRMczF3?=
 =?utf-8?B?VlNOZzJMa01Nc0dxNnpzNGM3bmR2VVBsYXlnRTBubXZNS0IyRWZ3bTAxWnYr?=
 =?utf-8?B?clZjWEg5N1JpYisvVWZ2bkZ0ZjNWV3d0SUNNSmZRQ0d4NU9XZEFZS1EvczVj?=
 =?utf-8?B?VU9wZE1BcXc4RXgxZzNJalVDalJMVnBzeFpXWnpYQVZDM0EwY0puUFZyYmtu?=
 =?utf-8?B?cWRWQnNjbVJVa1JwSUY5UytBa21SVms4aXZhOUlBYzR2Q0pHYThrWHg4SG5N?=
 =?utf-8?B?WTZOVWtSRC9hQllmcUcwMjBjRHhQTmZ1QWRpRytDUDBJMmJTLzNlbFY2RjYv?=
 =?utf-8?B?TjI0VFZ3RFhweG9zMVdZakZIenF6R3Q0WmNTNDgyV0RDWmt0RjZPN3o0cVJU?=
 =?utf-8?B?VkxhbHlsRmhCbWthc3I4UmwvWU1mTTNocExESGhPYThLZE96Wml1aDdNL1Bp?=
 =?utf-8?B?YmFLU3dtaXA3ZnlZYWViUlRKaUJqZW1BMkhzRDFNWjN3ejB3WlUwVzNEeHkz?=
 =?utf-8?B?ZDJieTlSUXYwME1MWE9OdGE4M0pJVnJ0RXRPUklYZFNtWTY3YlR0dlU4cEYv?=
 =?utf-8?B?SHhRVDlNUFd5RXdQcWw3czMxVW01cUFkSkU4eTNpS0pKdUk0V0MrbVhhNmsy?=
 =?utf-8?B?YUFPQUFhU3NpS0F5SzBhMTQ3WVpMZkNScmpJRndtNXBJSUV3OVExVEV5dHAw?=
 =?utf-8?B?d2JEMDMycFdnUzBYNDU4WHhlanM4ZlphZVMwM3ZXRnlXZE43OG9reWFaYVd1?=
 =?utf-8?B?TU16bUZqeDZ2UFJVa0o3ZWpFUlFnQnQ0NFBiVUlqNzZPa3NOUkZJdjhaUkpu?=
 =?utf-8?B?aUxaM1UyaFcvd1V1SXJyZldUWk4zaTlHM0h2bTdWZ1hLbkhvMUlvR0UyV2U0?=
 =?utf-8?Q?NBX4Y5no5E30+b8UmQbSAlB+ptLvsKeje9qQDAh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff3ecfa-7307-403c-998c-08d8de5f44a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 16:13:22.5981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BQHe/+mnvEiSisRupx26yZyTkjKvjwq0rULwXJb08wC9LAvLyrtb7Q5YoHt0L70mdr83dOBUD73j1HlrxtE/BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2986
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGVlIEpvbmVzIDxsZWUu
am9uZXNAbGluYXJvLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAzLCAyMDIxIDg6MTYg
UE0NCj4gVG86IGxlZS5qb25lc0BsaW5hcm8ub3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPjsNCj4gTWFuaXNo
IFJhbmdhbmthciA8bXJhbmdhbmthckBtYXJ2ZWxsLmNvbT47IEdSLVFMb2dpYy1TdG9yYWdlLQ0K
PiBVcHN0cmVhbSA8R1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20+OyBKYW1l
cyBFLkouDQo+IEJvdHRvbWxleSA8amVqYkBsaW51eC5pYm0uY29tPjsgTWFydGluIEsuIFBldGVy
c2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFtQQVRDSCAxOS8zMF0gc2NzaTogcWxhNHh4eDogcWw0
X21ieDogRml4IGtlcm5lbC1kb2MNCj4gZm9ybWF0dGluZyBhbmQgbWlzbmFtaW5nIGlzc3VlDQo+
IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBGaXhlcyB0aGUgZm9s
bG93aW5nIFc9MSBrZXJuZWwgYnVpbGQgd2FybmluZyhzKToNCj4gDQo+ICBkcml2ZXJzL3Njc2kv
cWxhNHh4eC9xbDRfbWJ4LmM6NDc6IHdhcm5pbmc6IHdyb25nIGtlcm5lbC1kb2MgaWRlbnRpZmll
ciBvbg0KPiBsaW5lOg0KPiAgZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X21ieC5jOjk0Nzogd2Fy
bmluZzogZXhwZWN0aW5nIHByb3RvdHlwZSBmb3INCj4gcWxhNHh4eF9zZXRfZndkZGJfZW50cnko
KS4gUHJvdG90eXBlIHdhcyBmb3IgcWxhNHh4eF9zZXRfZGRiX2VudHJ5KCkNCj4gaW5zdGVhZA0K
PiANCj4gQ2M6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+IENjOiBNYW5p
c2ggUmFuZ2Fua2FyIDxtcmFuZ2Fua2FyQG1hcnZlbGwuY29tPg0KPiBDYzogR1ItUUxvZ2ljLVN0
b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20NCj4gQ2M6ICJKYW1lcyBFLkouIEJvdHRvbWxleSIg
PGplamJAbGludXguaWJtLmNvbT4NCj4gQ2M6ICJNYXJ0aW4gSy4gUGV0ZXJzZW4iIDxtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQo+
IFNpZ25lZC1vZmYtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxpbmFyby5vcmc+DQo+IC0tLQ0K
PiAgZHJpdmVycy9zY3NpL3FsYTR4eHgvcWw0X21ieC5jIHwgNCArKy0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9xbGE0eHh4L3FsNF9tYnguYyBiL2RyaXZlcnMvc2NzaS9xbGE0eHh4L3Fs
NF9tYnguYw0KPiBpbmRleCAxN2I3MTlhOGI2ZmJjLi4xODdkNzhhYTRmNjc1IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3Njc2kvcWxhNHh4eC9xbDRfbWJ4LmMNCj4gKysrIGIvZHJpdmVycy9zY3Np
L3FsYTR4eHgvcWw0X21ieC5jDQo+IEBAIC00NCw3ICs0NCw3IEBAIHZvaWQgcWxhNHh4eF9wcm9j
ZXNzX21ib3hfaW50cihzdHJ1Y3Qgc2NzaV9xbGFfaG9zdA0KPiAqaGEsIGludCBvdXRfY291bnQp
DQo+ICB9DQo+IA0KPiAgLyoqDQo+IC0gKiBxbGE0eHh4X2lzX2ludHJfcG9sbF9tb2RlIOKAkyBB
cmUgd2UgYWxsb3dlZCB0byBwb2xsIGZvciBpbnRlcnJ1cHRzPw0KPiArICogcWxhNHh4eF9pc19p
bnRyX3BvbGxfbW9kZSAtIEFyZSB3ZSBhbGxvd2VkIHRvIHBvbGwgZm9yIGludGVycnVwdHM/DQo+
ICAgKiBAaGE6IFBvaW50ZXIgdG8gaG9zdCBhZGFwdGVyIHN0cnVjdHVyZS4NCj4gICAqIHJldHVy
bnM6IDE9cG9sbGluZyBtb2RlLCAwPW5vbi1wb2xsaW5nIG1vZGUNCj4gICAqKi8NCj4gQEAgLTkz
Myw3ICs5MzMsNyBAQCBpbnQgcWxhNHh4eF9jb25uX29wZW4oc3RydWN0IHNjc2lfcWxhX2hvc3Qg
KmhhLA0KPiB1aW50MTZfdCBmd19kZGJfaW5kZXgpDQo+ICB9DQo+IA0KPiAgLyoqDQo+IC0gKiBx
bGE0eHh4X3NldF9md2RkYl9lbnRyeSAtIHNldHMgYSBkZGIgZW50cnkuDQo+ICsgKiBxbGE0eHh4
X3NldF9kZGJfZW50cnkgLSBzZXRzIGEgZGRiIGVudHJ5Lg0KPiAgICogQGhhOiBQb2ludGVyIHRv
IGhvc3QgYWRhcHRlciBzdHJ1Y3R1cmUuDQo+ICAgKiBAZndfZGRiX2luZGV4OiBGaXJtd2FyZSdz
IGRldmljZSBkYXRhYmFzZSBpbmRleA0KPiAgICogQGZ3X2RkYl9lbnRyeV9kbWE6IGRtYSBhZGRy
ZXNzIG9mIGRkYiBlbnRyeQ0KPiAtLQ0KPiAyLjI3LjANCg0KTGVlLA0KDQpUaGFua3MgZm9yIHRo
ZSBwYXRjaC4NCkFjay1ieTogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4NCg==
