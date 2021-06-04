Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B6BC4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E4761421
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFDSmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 14:42:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58884 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhFDSmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 14:42:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 154Ie0ad006984;
        Fri, 4 Jun 2021 11:40:53 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 38yges9xnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 11:40:53 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 154IephB007862;
        Fri, 4 Jun 2021 11:40:51 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0b-0016f401.pphosted.com with ESMTP id 38yges9xn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Jun 2021 11:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgFbYMVwwnl9Zr6o9nWMn+kj4/mSmaMsJkHwCkd3TvmMEpXJClQeLS7UrbgfWuGhSUi6hkqi8dJAJU5fb81WXaoW5o98FDapT8HNANmJj3VA30VxSSdXABk8nvv9/0+x2y4CrI0PqaXp3kx7iO2BIP3P6/YATIUIWuomNTtRQnXrMUl5+a7R/NhImXpIUmDx7TKpiBlQkKGKcfWPCOCpBCiTR/Qaw5ZK8HOnUkXukwKnO2ZszBRENCFeHgXWkr0EFLuV6YJh5MqrDWhp/rZfkKWSsEAkAhCQf+1KfmBycY4mOeH3m++UEScRGvublSdaRiwJKec0DGhE+5XpJTjkgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcHe6QoFDHJDNeufgRV1JuWY59VJmR2EWSssR4ZQP6I=;
 b=me4hIfBxbeFFko+25D0h1apME7PH6MeBMDsQN8QU9WmMHvM0kq0+K3dPmFFXbvWDYSt7AqiTxmn/ULsxQlN/myLw9xSoXfWOFMseQmT04K92ZZpCr0OVcY/O6exTPDjqONjxYIhqQmfBE/RQ+W+EEUkfdPYy/p7+FjeOMN4UaGElHNAGfRz5NPZGFgXv03NjykrohVY8BydqFSG5KDLERcvFKf7aSD8t0fn1KX440MxpoNq0uZdhYBOA7gs61+vdmhmptedxGigPcjeKRXTO95OdnD9oG9JxLZcLZ5bH6gZUAhnBIwSUl1lYroqht3RXXo9o5HxLLXqOWh4lrOHd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcHe6QoFDHJDNeufgRV1JuWY59VJmR2EWSssR4ZQP6I=;
 b=hds7RZXjxoij+ZfVRU0e9c2EONBQUeREybT81VQg7aBmAM/jsa4sVEFrYftwfH+PYrXH5J5/CiErtaf7GhAsJeFE5Yvt7SIHDlSsZYRwPZCWIKX1uPsLgs8Xsg/b9CWAl0rur/ivEsCHghVOVqCtgs04GDqxHF8gBxJ57wCOvXY=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by BYAPR18MB2742.namprd18.prod.outlook.com (2603:10b6:a03:10d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 18:40:47 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a543:d35e:d4a3:579e%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 18:40:47 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
Thread-Topic: [PATCH v2 01/10] qla2xxx: Add start + stop bsg's
Thread-Index: AQHXVeuDrPCVzeUItkSrjU+IUrMt0Kr/GOeAgAUZVdA=
Date:   Fri, 4 Jun 2021 18:40:47 +0000
Message-ID: <BY5PR18MB334573C8F38423370C0BC756D53B9@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-2-njavali@marvell.com>
 <035e4f12-bf2b-99fa-a4e8-4d8b981056ca@suse.de>
In-Reply-To: <035e4f12-bf2b-99fa-a4e8-4d8b981056ca@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33868601-3f96-4278-6637-08d92788451e
x-ms-traffictypediagnostic: BYAPR18MB2742:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2742A118DCEAD7DE3A8D0A3ED53B9@BYAPR18MB2742.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s6cz5nQmLdpoaaZc8ZGhvBDV08jXP/Y4u/ZOnBJuzKPbKrj3HZfn9pCnVZS2HW1LfDzqQq+TEIf13iZqocl7Jp0nm8hB3tK75kEesrU4m7MQCwQzFTv1XSFQWdvDt4xzcA7vseYD4S/NRHKxWSEbvquYRMWmO5WlDwStgAp8t1agZJm6+5y2jcXN6krwsA8qM4tenw4ifliFu1a4i2UwmUJjhm8JAL6Td0WTj++a9fBsRjFtvom4S0C+rKlrt61IFnLBt5yHuFwnySEFut7eJdJ4WHqI529/PPY++192hAWK5vICsO2aVxewfq+ZfYYr5SYyrkwePWosOlP/VNRHqoOBaeOb1KqzDNRkSsKThXI236wCXTkDXOC51eSM495TEzz+j5e7EEO1yaetMt1JtOXGUYG53Lk84uGQcFflRDkKqdyUwjpPZUV7QlCNrDmVOigUS8zdJHEJtvBxYE+Nssp8ztuA7gAi5qH/7/VunhUps+3l9Bdtncs+Hxm4bpKvznRbRXRZJi/QxHGw1Lj0qUnFjsUbqTNcaV/pQc/5FehwP9jnbSqeXAUlYS/nEVyTKUwVFTMtvGw9EQAgUYkPOoXCUxMGXhy3siJVReSl1FU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(122000001)(7696005)(26005)(6506007)(83380400001)(8676002)(9686003)(38100700002)(66946007)(66556008)(4326008)(55016002)(64756008)(66476007)(76116006)(186003)(5660300002)(52536014)(66446008)(478600001)(33656002)(110136005)(54906003)(71200400001)(86362001)(8936002)(316002)(107886003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N3BmL0JDQmZtdkpkNW01QmR1OFJJUXhSN0Zjbm44ZmJscFVJTnJ6ekZYZjg3?=
 =?utf-8?B?RVpwV2NaWTY0aE9vUWxqRUc1SFlaZDA5dUQ4cHRmKzIrc1pHdmpTWGdneUta?=
 =?utf-8?B?Z1RBRDgvcEhMYkdvMXpERlVsQXdUS3lMSklYNVJwZlhHL1d1VkdISThXUG1j?=
 =?utf-8?B?Ujg1Y1M4ZjkyT1R4Z2xvbUZjWlNNODNhVlFpMUszb2ZPdHFmQmF0WFJHbFRa?=
 =?utf-8?B?cnlDSTFkUjJHZnhmajEzTk5SSm9aaThEcDV2M0hKKzlka1QvQ0FQQW1LK09D?=
 =?utf-8?B?aEViNXIwRXFWM2VqL1VUaysyY3ZaOXFrY2VlTHBpRUkyTTBUV1Q1SktEdDFQ?=
 =?utf-8?B?bmdicUlNNlNiamJOWmtTVGx2UUlMMU1VbTJKd2taVzdQUWNjak80UEhrSmRl?=
 =?utf-8?B?MmtxbmVRK3ZCM1RJTjRySjJwOGJvbmlOUlRmdEdaWHZIQW8yeXVSZThTY0ky?=
 =?utf-8?B?MDJub0tkeWJlK0x3WU1mdFEzQnpteG5ocTFFTWs0ZlVnUHhrTFZSaDlqNFdU?=
 =?utf-8?B?eHozdDd5aHIvYWZwMjF0dUpxR3A3WkxxeWtObTRpVC9ReHdBSC9CcTZOSm9Y?=
 =?utf-8?B?UlRDS0c1dk13WHpuQnc0dWdIOFdLZzdHY3FRSFVEU0k2b0haeDB4d2JWNFA1?=
 =?utf-8?B?dlFEZDhOVklobFdJWlQyektYbGF4K2RWS3UxN0VkblRBWHRmajlHOHNmMUhG?=
 =?utf-8?B?RUszdTBqSWg4MU8wUVU1QTV1K0JPODdtY1M2K0tYc3NoN3ljeC9FQlNNdVNZ?=
 =?utf-8?B?eXZFZmpLbXFXb3FtNTUzUXp6Uy9QbkZSclc3VkdTK29WaDBENUkzTGNlYnJk?=
 =?utf-8?B?c0R5VGpDWVBHekhWelN0LzNIR1JnK0VZU0xDL2xxajk5VnZhL1RtNXJ2eWhv?=
 =?utf-8?B?MFZSZ0JxRUw2dXBRNTlTaDB5MUdaR0hld1lYM2V1WHVyeDRuWTdqbWJRM2xH?=
 =?utf-8?B?ZTJqaWhZVWNMRy9LNVo1R3BkZnF1Ui9DanBuSWN2OHdKUjlDWjJLanlpcnk4?=
 =?utf-8?B?Q0JQSk55bXQ4L0ZJRmE2eWZaMVJQVkRLZXlVYUZhWTFySGlYT1hyT3FSWVlp?=
 =?utf-8?B?NUEyY1hQRnNtWC9sbWdlS1RFNU5nSi9sYTlWOWpibFdVd2s1UTRLYWQvMXM5?=
 =?utf-8?B?S2Z5bjluZDdEQWJhUDRtVFJ6enZDQ2dRdzhxeTJPNFdaTmxoeDVTM0Z5ckR1?=
 =?utf-8?B?OWtVaDRZYngxWXRqTHM5OGxyMDJSTW8rbjJnbWdUa3huR2o0NkNwV3Y0Mm5T?=
 =?utf-8?B?NlBFNzVkV1pFdzR6NWtUN01XWWNYMDBvYWRBc3pBNE1DZ1AwYm8rNHFTZjlB?=
 =?utf-8?B?VjQrWVZDVTlvb3dyb0pNUmJpSnRIeHdWRnNFNUMwQkcrTjBwMzY1aEZTRXRI?=
 =?utf-8?B?YXdoL1FJVzB1bEVDc2ZQSUxxZHc5c3BUb1dYaGZwNE1CTmp2c3BUMGNVZFlW?=
 =?utf-8?B?WDk4aXdVOE40blJJdHBub3VCY1VrMkFUR25USTdNVzlDYUtMZkFlZkJwVjhW?=
 =?utf-8?B?aE1lSllTSXpBMXJQWklOb1BtdFN2bmQvUG5FMmFRLzNOOEhIaXJzZ0J6aG9V?=
 =?utf-8?B?YkovcklIR0V6dFg0RHNsTVRwTFA0S1czT2RvRHNxVGtQWTYvVjBhc2VoUzE5?=
 =?utf-8?B?MnVKUk95Vis3cVFGRFNYbEdUU1lxMXdabGpIVm03R2oxUU5OeDcvY25QRjB1?=
 =?utf-8?B?SjdHU3plSVpVdUlHRndKbnRCN05xanVhay8xdElXU01pVFVJanVzVjNLMmlT?=
 =?utf-8?Q?MKx9cHYfdccvg3HNI4SsMeF1HQdZk9nUeiOLlNs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33868601-3f96-4278-6637-08d92788451e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 18:40:47.6552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XcRf3cNME/r3UzOPrphJfrIi/+BhrU5uv8/069o2FWZKrJcZ+UfLch2nM2eAylxxzwHvnXSH0kHjn2I1WmEz1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2742
X-Proofpoint-GUID: 0FKMGBz0hroVphtYVRBEArvQzJcyBeYy
X-Proofpoint-ORIG-GUID: 59HVH8k5kbBqts1r8Fq2e6RGbrMdAm4h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-04_12:2021-06-04,2021-06-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGFubmVzLA0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQo+ICsJCXVpbnQxNl90CXNlY3VyZWRf
bG9naW46MTsNCj4gKwkJdWludDE2X3QJYXBwX3Nlc3Nfb25saW5lOjE7DQoNCkhvdyB2ZXJ5IHVu
Y29tbW9uOyBkZWZpbmluZyBhIHVpbnQxNl90IGJpdGZpZWxkLg0KV2h5IG5vdCBtYWtlIGl0IHVp
bnQzMl90Pw0KQnV0IGFkZGluZyBpdCB0byB0aGUgc3RhcnQgb2YgdGhlIHN0cnVjdHVyZSB5b3Ug
YWxzbyBpbmR1Y2VkIGEgcG9zc2libGUgcGFkZGluZyBoZXJlOyB0aGUgY29tcGlsZXIgd2lsbCBt
b3N0IGxpa2VseSBwYWQgaXQgdG8gNjQgYml0IGhlcmUuDQoNClFUOiBhY2suICBXaWxsIG1ha2Ug
aXQgdW5pZm9ybSB3aXRoIHYzLg0KDQo+ICsjaW5jbHVkZSAicWxhX2RlZi5oIg0KPiArLy8jaW5j
bHVkZSAicWxhX2VkaWYuaCINCj4gKw0KDQpBZGQgYSBjb21tZW50ZWQgb3V0IGhlYWRlciBpbiBh
IG5ldyBmaWxlPw0KV2h5Pw0KDQpRVDogICBzaG9ydCBpbmRpY2lzaW9uIHdoaWxlIHNwbGl0dGlu
ZyB0aGUgcGF0Y2guICBXaWxsIGZpeCBpbiBuZXh0IHZlcnNpb24uDQoNCj4gKwlpZiAoYXBwaWQu
YXBwX3ZpZCA9PSAweDczNzMwMDAxKSB7DQoNCkh1aD8gQSBoYXJkLWNvZGVkIHZhbHVlPw0KUGxl
YXNlIGRvbid0LiBVc2UgYSAjZGVmaW5lIGhlcmUgdG8gbWFrZSBpdCBjbGVhciB3aGF0IHRoaXMg
dmFsdWUgaXMgc3VwcG9zZWQgdG8gbWVhbi4NCg0KUVQ6ICBhY2suIFdpbGwgZml4IGluIHYzLg0K
DQo+ICsNCj4gKwlyZXR1cm4gcnZhbDsNCj4gK30NCg0KQW5kIHlvdSBjYW4ga2lsbCAncnZhbCcg
YnkganVzdCBjYWxsICdyZXR1cm4nIGluIHRoZSBpZiBicmFuY2hlcy4NClBsdXMgdGhpcyBmdW5j
dGlvbiBzaG91bGQgcHJvYmFibHkgYmUgYSAnYm9vbCcgZnVuY3Rpb24gLi4uDQoNClFUOiBhY2su
IFdpbGwgZml4IGluIHYzLg0KDQo+ICsJCXFsX2RiZyhxbF9kYmdfZWRpZiwgZmNwb3J0LT52aGEs
IDB4ZjA4NiwNCj4gKwkiJXM6IHdhaXRlZCBPTkxZIGZvciBzZXNzaW9uIC0gJThwaEMsIGxvb3Bp
ZD0leCBwb3J0aWQ9JTA2eCBmY3BvcnQ9JXAgc3RhdGU9JXUsIGNudD0ldVxuIiwNCj4gKwkJICAg
IF9fZnVuY19fLCBmY3BvcnQtPnBvcnRfbmFtZSwgZmNwb3J0LT5sb29wX2lkLA0KPiArCQkgICAg
ZmNwb3J0LT5kX2lkLmIyNCwgZmNwb3J0LCBmY3BvcnQtPmRpc2Nfc3RhdGUsIGNudCk7DQoNCklu
ZGVudGF0aW9uLg0KUVQ6ICBhY2suIHdpbGwgbWFrZSBtc2cgc2hvcnRlciBmb3IgdmFyaW91cyBp
bmRlbnRhdGlvbi4NCg0KLS0tLQ0KPiANCklzbid0IHRoaXMgYW4gb3B0aW9uYWwgZmVhdHVyZT8N
Ck1heWJlIG1ha2UgaXQgYSBjb21waWxlLXRpbWUgb3B0aW9uIHRvIGVuYWJsZSBFRElGPw0KDQpR
VDogIEl0IGlzLiAgVGhlcmUgaXMgYSBkcml2ZXIga25vYiB0aGF0IGNvbnRyb2wgdGhlIGZlYXR1
cmUgY29tZXMgaW4gcGF0Y2ggOSBvZiB0aGlzIHNlcmllcy4NCg0KDQpSZWdhcmRzLA0KUXVpbm4g
VHJhbg0KDQo=
