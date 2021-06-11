Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FA5C48BE0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2BB613C6
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKUzc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 16:55:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48330 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230233AbhFKUzc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Jun 2021 16:55:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BKo6gB002388;
        Fri, 11 Jun 2021 13:53:31 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 39417nb7xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 13:53:31 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BKo5Y1002379;
        Fri, 11 Jun 2021 13:53:31 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-0016f401.pphosted.com with ESMTP id 39417nb7xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 13:53:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsjKNjYjGKKUoa54IsG2no6Surc+5You5oes356YyddWriE5LWy0yqAiNa18xS4aVBLqYWJz6BPaDxL0unS8IJ35jgv+zyVgKvpLKjbPda/SimVjd2zMnUisxnKKqt7ev6N6rmheUXA/n09b76AeYLo6Hi3xAHQDivD+kU2NHWuRzNaHINl719z79YW23PgOLiU4rvVLsudqXO2gHNROqrL2+INeslc3Y4I9MSMoR8BCUge61eFQX4QQiEQX5xEON6I6UshxB+itDe5XyFlxQrBkPE2LrPFz5ZhSnM8mm0HLIlpvR2n/oPFzLDmc0VCMnQNY9U+F7df0zSBJZ3WczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJLd5yr7NGXsTjPaKDD+tFmfWXPrf9KadcJVZA9hv1w=;
 b=i5f2bVuf8FORydl2SYvRhMrdxSis4jM5H7mMU4w4T4TJmOVZuCJ3rBEeu/vbsosDK6PFW3TwOLUnQJhULktuMHvXYoTpT3Dd2V4+Hlk9Xc2xLADBVkqmXMNOz2+n6ehFxJOo6MnikohevKMzNSLZ6yve7vykLbK+VvT73zZU4uBbuVnK0UGgXVEoQ0EmiuYPW/Jvf31Hr1JIhQiJTNBvg8iczyM1ux5VmcAoMcSrjWz42L+AlHc7T22gomN5wbtg/9ybKRCOWSxRGejJVf+D+AwQeh2n+xbl8ypRWk/zsPVG850AUVT7/x0vw/0IXy3qE0PwlMg97MDtjKJ8G17C4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJLd5yr7NGXsTjPaKDD+tFmfWXPrf9KadcJVZA9hv1w=;
 b=hOlyedMsl6v6ua9YsCP7mpIbqXnDPhD8Fm1gSOqyjrjMMSzZ25F7r/MHDHT0LOB/Nk+adxf57za59hEJpUqkxHvMgqBJMVsxl4TCzyNRKnsS6i9cTVBHj8C7CEBQ+hQWI7GYVw/c67E6MMIKniHgQNj/NZ0S5h7dONc1RZzUeoQ=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by BYAPR18MB2629.namprd18.prod.outlook.com (2603:10b6:a03:136::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Fri, 11 Jun
 2021 20:53:27 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a5e6:1262:9d8a:11b8]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a5e6:1262:9d8a:11b8%3]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 20:53:27 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 08/10] qla2xxx: Add doorbell notification for app
Thread-Topic: [PATCH v2 08/10] qla2xxx: Add doorbell notification for app
Thread-Index: AQHXVevkc0C/U4BZdEOI8EXhbojRAar/I1YAgBA0dPA=
Date:   Fri, 11 Jun 2021 20:53:27 +0000
Message-ID: <BY5PR18MB334535FD96A1F917244A1233D5349@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-9-njavali@marvell.com>
 <1a5b3c38-51c7-3141-3019-6460a5d6f300@suse.de>
In-Reply-To: <1a5b3c38-51c7-3141-3019-6460a5d6f300@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [68.5.10.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81b3ff92-377f-4b3a-e2e5-08d92d1af669
x-ms-traffictypediagnostic: BYAPR18MB2629:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2629313ABFEDE19BEBC37212D5349@BYAPR18MB2629.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: giheBohbhSlcUtvhZlGzmZ4GOvVLc3+iBpESwjQD5hQzrRnaZE/Mu1atpi5BcmC5A4G8TLaPjQWJOIst7oGu7xkQYwq6yLJWyyO3FukG7nm5Eaq9R/spl08E27rQByVVs6FvqIf5KSdydZ5UZnLGoOVhuPnz/yKUbFXxu9tNGZyKADTWavG7t3m+nph49VgLwxi7JLrB7Uy/iUc1bqu/j/NHAjOJVTZERHSuWw/sW9d+2a4u9ENApkCQ61KRcntKiPdKCvQJS64z9JzCpwCSwPjzm/6drk6MdjWp9994N01H8HHCk1obHHmo3t2zkZ0bn+8x23g2ngIRIy8YSb76SU5ZyKLduRF/Dg6aLaQB1w5wwVVUXnw4oKORyxcuP09MJd9y5yRrkXBN3yn3/k2E7yfbe86cvchfmUWu7Ghn3B5Unkv96xv0KhN6yLrUgz/QWzcpcUr4C8C6UdN5YS7IOnt/abV1OWJGMskJtPjnq8HsuC9iTx6WTveObzFC+Xw0CnXpYBTa5eFx8rcrz/YmEOA6ugVWl/JnBSZjD+ZgxheEESw1gk6JuWIkxDu/nR53H3mX+NvpkcVfAVD16vZR2ZnFFLeCF5v6w979eywt26E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(396003)(376002)(346002)(136003)(366004)(107886003)(110136005)(186003)(55016002)(9686003)(54906003)(316002)(4744005)(4326008)(66946007)(66446008)(52536014)(64756008)(66556008)(76116006)(71200400001)(66476007)(86362001)(6506007)(122000001)(8676002)(8936002)(7696005)(478600001)(5660300002)(26005)(83380400001)(33656002)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG9tNjJyVHlTYXNHS3piak1oem0vT2lSaUI4MGM3RGw2YkxnbkZabnFDQzk4?=
 =?utf-8?B?eFNOMjI2bEMydGxJSjhqUFRJSklDakV5TkQzNGVDQmVzU0lQMG5QUXFSVElS?=
 =?utf-8?B?dDRhSVUyU0VmMkxwSW53b2phbTc2UFVzaVdwVTNOQ0dMa2k0VW14aGd6a2dH?=
 =?utf-8?B?ZGxNWktObTJOZUM5eE5oN2pUcDB2TEdoWjM3bWlzZU5yZ3ZiVythRHZLaDZH?=
 =?utf-8?B?UWViMEV2TWppNWkwU0VBaW5GWFpFN3huNWZKck0yaDBtYS9OdlhzRmxLYkpC?=
 =?utf-8?B?eHNSQ1B2WGJQdFlvdERaVEFpSWVkZUFEUVEwdTVmQ0t3SmdiM283Q2lBOHZs?=
 =?utf-8?B?S0liV0tLREZLTk1XbE5CM203SmcyOXdtMlpJWkdZUUJWTldGY3dOT0xBRTQ5?=
 =?utf-8?B?Y25Qdm0vcERURWtacEo4RHZZWklVR0ZZaFQ0ZjJyUFRwYmhNSFBzbWUzaE8y?=
 =?utf-8?B?K29HK0E5UXRKcFM4blBkdDhoZEQzamFBTEgveHNDM2Y5ejNMdWp3Y2t6bFRl?=
 =?utf-8?B?UkpUNFRCM1RINTl5WFpIU1JUV3NabnN5dkw5dzlWZE95WmdVU2pLVGlOLzdI?=
 =?utf-8?B?ZVAzNndVaEd4WFRxVDg2N3BkRzFNY1BoY3RRTmV3c29GZ2VwbGFRVFlydEl6?=
 =?utf-8?B?T292VHlBUWxBeXZpTXlxVis5Z2F2QnEvbThvWEdYN3NpdW8wYWFJN2kzSHEr?=
 =?utf-8?B?Q2VBUDJ3MHNoa1ZGRHJSOEhrU0ZLTy96K21wMjJONkpleHhSdFVEMDM2OXAx?=
 =?utf-8?B?eFA1YXNLUnJpRGx5cDlVeDNhVHVsY0JPM0Z3KzkvR0pNcXB5SGxYNDhiVERi?=
 =?utf-8?B?cFhDRUUyWllPbGJHM3hVeW1PWk93YlhySjE0a25qZXlOL1NBTkJZc0ZWajRX?=
 =?utf-8?B?SW94d0hWOFNpQjcvSXJMazhnVWFYQ0RrTXRuQ3hROHFCZy9SY0h4NUF4MXFD?=
 =?utf-8?B?WkdyMkFTZURPeDJpaHkrZWorVVN4STQ5bmEwV3BkbXpCZ2FPMFZyRjM2blZ5?=
 =?utf-8?B?MitSREJadjFFWjJ3WUs1UTBkL1FHeHBBZmxFZHIvalZMdUFFS1UwNnJ1UTUw?=
 =?utf-8?B?TW1OUHJwcmdtVlZlcFBpRjBITGV3dDNWTFVHK2syVnFqQ0JuREZCajVPYlJa?=
 =?utf-8?B?cFpQMjFWeWdIVmM3NEZySVlJOG5nQTRaWC83OGF1SGZYV1M3TC9Fdm94M0J0?=
 =?utf-8?B?a1pzajFYN3VCczlXOUUyYmtGdFBVRkJ0b1N3N3lmSm43UVo1NXFMWmIxSGc5?=
 =?utf-8?B?R0xaTXB5WVYvZ2lVUFUraVFXMkMrNFpMdlpYcWxoZy8vT29HTUJwd3RBWmll?=
 =?utf-8?B?b0xSMEh6SnhLS1dOV3p6RmFaL2k3UFFZTE9wMnE3YzUzNld4aVBLZC9EdEh1?=
 =?utf-8?B?N1o0TFEzZFFxT04xWEpsSWJZYURINmZLbi90V0p2L1U5VDF0ZlJydHFEcnJJ?=
 =?utf-8?B?ZDNyVFZMcC9jYmpSVk8zV0hFYnFMZXIrUFZ6N3ZGbHI5amh3TDY5ejB1bWFq?=
 =?utf-8?B?UTlTSkZObE9yUVBBSHFsK2xDZXg3VEFXVjFNcm5LRGdzeXRVMGV4ejBCMmJR?=
 =?utf-8?B?WGFRYk9zUmM3V29MdVF3UXljNVQ5V0JuSGZLNHVyWjVPZGsrQzlCZDdLN3RG?=
 =?utf-8?B?by9rZktTRC9IUDUyQkhlanowdktHd012Y1U1Rnh0SWlyL21zRzM2S2xpWXN1?=
 =?utf-8?B?dG1nc0RzY2JTOHpqRzhiWkpYRDZpMEhyc0ViNmlkTG9oNU9MRlorWk9LN25T?=
 =?utf-8?Q?U//w8FPsK76bpJtlrs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b3ff92-377f-4b3a-e2e5-08d92d1af669
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 20:53:27.5430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LOyX9T+FjA2SgJZ9k/b59I/3flIyLezNhyV+aMycJqlKrKeWGJ9twbHwzJvgLeM2+YlLJ4Aney3rt8bSyqo/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2629
X-Proofpoint-GUID: kha00V1NT4K8QjPuclLsoq8mg4UDFq_Y
X-Proofpoint-ORIG-GUID: uifEF7BOxrfPBjLRXjKkhrq4mTTRHX3m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_06:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZ2aGEtPmVfZGJlbGwuZGJfbG9jaywgZmxhZ3Mp
Ow0KPiArCQlrZnJlZShub2RlKTsNCj4gKwkJc3Bpbl9sb2NrX2lycXNhdmUoJnZoYS0+ZV9kYmVs
bC5kYl9sb2NrLCBmbGFncyk7DQoNClVubG9jayBiZWZvcmUga2ZyZWU/DQpXaHk/DQoNClFUOiBJ
IHRob3VnaHQgZnJlZSBiZWhpbmQgaW50ZXJydXB0IGRpc2FibGUgY291bGQgdHJpZ2dlciB3YXJu
aW5nLiAgSWYgdGhlcmUgaXMgbm8gcnVsZSBhZ2FpbnN0IHRoYXQgdGhlbiB3ZSB3aWxsIHJlbW92
ZSB0aGUgdW5sb2NrL2xvY2sgYXJvdW5kIGl0Lg0KDQo+ICsNCj4gKwlzeiA9IDI1NjsgLyogYXBw
IGN1cnJlbnRseSBoYXJkY29kZSB0byAyNTYuICovDQoNClNob3VsZG4ndCB0aGF0IGJlICdzaXpl
b2Yoc3RydWN0IGVkaWZfYXBwX2RiZWxsKSc/DQpBbmQgc2hvdWxkbid0IHRoYXQgcmF0aGVyIGJl
IGEgY29tcGlsZS10aW1lIHdhcm5pbmcsIHRoZW4/DQoNClFUOiAgQXQgdGhpcyB0aW1lIHdlIHdp
bGwgbGVhdmUgdGhlIGNvZGUgYXMgaXMuICBUaGlzIGlzIHBhcnQgb2YgYSB0b2RvIGNsZWFuIHVw
IGZvciB0aGUgbmV4dCBzdWJtaXNzaW9uIHBoYXNlLiAgV2Ugc2hhbGwgdHJhbnNpdGlvbiB0byBh
IGJzZyBjYWxsIHdoZXJlIGFwcCBwcm92aWRlcyBhIGJ1ZmZlciArIHNpemUgc28gZHJpdmVyIHdv
dWxkIGtub3cgaG93IG1hbnkgZG9vcmJlbGwgZXZlbnRzIHRvIGZpbGwgdXAgaW5zdGVhZCBvZiBo
YXJkY29kZS4NCg0KDQoNClJlZ2FyZHMsDQpRdWlubiBUcmFuDQoNCg==
