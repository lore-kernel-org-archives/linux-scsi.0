Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EE0C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 18:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFC42133F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 18:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="u+SjDDAN";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="urzKHNPM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfHNSdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 14:33:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1310 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfHNSdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 14:33:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EIURbw005285;
        Wed, 14 Aug 2019 11:33:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Syy+6+YE7QmzQrVGFcZ/X+sbJwuofSDGjEh7kcgTRnw=;
 b=u+SjDDAN/QXK62GHNaev3TSouhM/YOh9u+s77boGY/kG2y5/81jqJyix/lqeGskGEZEb
 EDTGiygESmMxFsbkX+HLTZEXHxYI9NXLjJnF9H0V4biKVNKvPLj+uTOxVCedChPi43eJ
 7cfk8wPNF27KBULc3j34LxSrfUBcppeA+ld5DBT7SunLP63Oh4A4GtcJ2kGHJYWIowqb
 0MzbT8VOyXMtdjoCFlOUnCq4qkArqU6knKNsIFCiL/QzD+3Pdv1uB+ren35AaSOdfT2j
 hngPYCfgGN/xhzn32lELFUOf5DVZwmyorASZM+lueQEZOzGPtDl5cuvdY7+iH3OXVf9+ kA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ubfabg8bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 11:33:22 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 11:33:20 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 11:33:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8mf39oKQeAEA++DQkFiaPCU37+7TYrcUf+PpIduEh06Rcc0GWsg3qHcCc4eMa3J3DDyJCcBUTd1iSXOKIhdG3+6kHK7cAJl2Kz0neGhowAlXbvue58t09uufm8gidNQhUfMLlnpvB0GmO0lGzlWVOX5LY20677CMsm5Npj+lvuM1/HyzLCuD+KXm9CUGHztNnnAvDmB3nbbUFL7jVLviRIW3+Q4MvcClC66mEFm6UKsnqX5Tnjba6l7P5e6chzU8fZvq91IdwQBb1Cma8ab88Wo4SIQJ7rFZdo9L1or/tbdQ3qn4LpTcOZcxG8NVXfwX8pmpCwU9JDHKZ56Q5APOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syy+6+YE7QmzQrVGFcZ/X+sbJwuofSDGjEh7kcgTRnw=;
 b=VsZqd4i2maDBgKLn1vOgngOJNOIBqQGLoBNAeThpyPFyiFYh3gR/JeryiozKa/a4nSXwxpJ37QsMQu3Z0yCUOP0VMdcDKQTfEe8EJjM30eqUChHSjHSUX0zGcxchec6TzQeHIVYaH3QHlBC6ne/hF8fd3rI9979CA4ksUp7AWKGinyAA7NYk+9jILBMdVgUxyjPfk8yk5WyxO5s/vc/UWgH+qv0ubdNDtHdtswixfa8uILdAPWeZFsKYb+Pl2eIynZ6jE9OUTqYqwaWI7LxXpTriLDPZEIezLS5M3MrjynBjgYNMbLEYSf5vaWW+S9gBxOfRRLFpBZtP7ZAT3n9Wcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syy+6+YE7QmzQrVGFcZ/X+sbJwuofSDGjEh7kcgTRnw=;
 b=urzKHNPMPLfYmXkiF3uW/aWnEZL0EhRS8cTkyiokQcHUaLoy6lSsMXMGEtPTfpZu97TBr9woHbbO6bQBPKyyjIKQtY4A0/5InWTQBzMnZ7eT7iQ58qOL80+Mt6KN9LeHjWJIhZjv4nw/857DNjSmN1IE/nUJsIKPAFKEwLieWgY=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2784.namprd18.prod.outlook.com (20.179.23.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 18:33:19 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 18:33:19 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: replace snprintf with strscpy
Thread-Topic: [PATCH] scsi: qla2xxx: replace snprintf with strscpy
Thread-Index: AQHVQq1r2m4vuuNEjU6H5Hb3H+MN0qb647WA///gmgA=
Date:   Wed, 14 Aug 2019 18:33:19 +0000
Message-ID: <01880B0D-B241-4D1A-AFA0-CD57C09A4E4E@marvell.com>
References: <20190725054653.30729-1-xywang.sjtu@sjtu.edu.cn>
 <80cad672-d727-8e96-4e2c-ffc33ca6ff55@acm.org>
In-Reply-To: <80cad672-d727-8e96-4e2c-ffc33ca6ff55@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:5871:9d72:f424:86ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d471613b-eae6-45f7-b532-08d720e5e109
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2784;
x-ms-traffictypediagnostic: MN2PR18MB2784:
x-microsoft-antispam-prvs: <MN2PR18MB27843B583790AE2E384D3B65D6AD0@MN2PR18MB2784.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:119;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(396003)(346002)(136003)(376002)(51444003)(189003)(199004)(86362001)(5660300002)(478600001)(36756003)(2171002)(6246003)(8936002)(186003)(71200400001)(71190400001)(91956017)(66946007)(76116006)(14454004)(305945005)(6116002)(102836004)(46003)(76176011)(8676002)(66556008)(6506007)(66476007)(7736002)(99286004)(66446008)(64756008)(53546011)(25786009)(53936002)(256004)(4326008)(486006)(6436002)(14444005)(110136005)(58126008)(2906002)(316002)(33656002)(81156014)(446003)(476003)(2616005)(81166006)(11346002)(229853002)(6512007)(6486002)(156123004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2784;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BV+5XobvgCV90Q4Ieuu5KQCl8gwcuh4Kzs1vm/Lunct3CAdTAl+5rG8YQPrguO2ux0eXC67SmbCMWpyxfIIL+S12LHY1+ko/kO7y9YkW5ycknYZr5VnGhoAXdAOvUviaqLi1mNnmZll7XiQUpI60gd0r+Ud4/A1hqqVFY7iuQLzHjBLr4MPXvPuiUztz3/7Tsd2KJdXM+U0R1K3R1bNVmb+rtpUcX6lNRZNdFWgR2U3whapD9eJMaDr1E6yFuJedZ3Ov3iL67UFhFfoUcSudZ96rc+RbTTRbtb7C4TQyhoJhRI8DIRqcUDwQEmwqzkCetJwMU8nTNGGMckhKeZ0oKW0qDB72q1W76R4GsZv9ajGx4YLM9/H5MW7J7Y+GNT+f7Tamc0Blt90nQ7W1yWC+8MZYkLT8Mlzi0nMCXJuOXLc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FDC8FBD598A4747A189343C8198A82A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d471613b-eae6-45f7-b532-08d720e5e109
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 18:33:19.0124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VcQcQjUn61iFnwu8UcJR0bL9JtFaVMKoSVEeF7dzzSgrM2dKwJfiaG4af67+TQC5SRXc34/pYmrovCnXTlbCbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2784
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_06:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDgvMTQvMTksIDEwOjI1IEFNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIEJhcnQgVmFuIEFzc2NoZSIgPGxpbnV4LXNjc2ktb3duZXJAdmdl
ci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBidmFuYXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KDQog
ICAgT24gNy8yNC8xOSAxMDo0NiBQTSwgV2FuZyBYaWF5YW5nIHdyb3RlOg0KICAgID4gQXMgY29t
bWl0IGE4NjAyOGY4ZTNlZSAoInN0YWdpbmc6IG1vc3Q6IHNvdW5kOiByZXBsYWNlIHNucHJpbnRm
DQogICAgPiB3aXRoIHN0cnNjcHkiKSBzdWdnZXN0ZWQsIHVzaW5nIHNucHJpbnRmIHdpdGhvdXQg
YSBmb3JtYXQgc3BlY2lmaWVyDQogICAgPiBpcyBwb3RlbnRpYWxseSByaXNreSBpZiBhMC0+dmVu
ZG9yX25hbWUgb3IgYTAtPnZlbmRvcl9wbiBtaXN0YWtlbmx5DQogICAgPiBjb250YWluIGZvcm1h
dCBzcGVjaWZpZXJzLiBJbiBhZGRpdGlvbiwgYXMgY29tcGFyZWQgaW4gdGhlDQogICAgPiBpbXBs
ZW1lbnRhdGlvbiwgc3Ryc2NweSBsb29rcyBtb3JlIGxpZ2h0LXdlaWdodCB0aGFuIHNucHJpbnRm
Lg0KICAgID4gDQogICAgPiBUaGlzIHBhdGNoIGRvZXMgbm90IGluY3VyIGFueSBmdW5jdGlvbmFs
IGNoYW5nZS4NCiAgICA+IA0KICAgID4gU2lnbmVkLW9mZi1ieTogV2FuZyBYaWF5YW5nIDx4eXdh
bmcuc2p0dUBzanR1LmVkdS5jbj4NCiAgICA+IC0tLQ0KICAgID4gICBkcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfaW5pdC5jIHwgNCArKy0tDQogICAgPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQogICAgPiANCiAgICA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lu
aXQuYw0KICAgID4gaW5kZXggNDA1OTY1NTYzOWQ5Li4wNjhiNTQyMThmZjQgMTAwNjQ0DQogICAg
PiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQogICAgPiArKysgYi9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQogICAgPiBAQCAtMzQ2MSwxMiArMzQ2MSwxMiBA
QCBzdGF0aWMgdm9pZCBxbGEyeHh4X3ByaW50X3NmcF9pbmZvKHN0cnVjdCBzY3NpX3FsYV9ob3N0
ICp2aGEpDQogICAgPiAgIAlpbnQgbGVmdG92ZXIsIGxlbjsNCiAgICA+ICAgDQogICAgPiAgIAlt
ZW1zZXQoc3RyLCAwLCBTVFJfTEVOKTsNCiAgICA+IC0Jc25wcmludGYoc3RyLCBTRkZfVkVOX05B
TUVfTEVOKzEsIGEwLT52ZW5kb3JfbmFtZSk7DQogICAgPiArCXN0cnNjcHkoc3RyLCBhMC0+dmVu
ZG9yX25hbWUsIFNGRl9WRU5fTkFNRV9MRU4rMSk7DQogICAgPiAgIAlxbF9kYmcocWxfZGJnX2lu
aXQsIHZoYSwgMHgwMTVhLA0KICAgID4gICAJICAgICJTRlAgTUZHIE5hbWU6ICVzXG4iLCBzdHIp
Ow0KICAgID4gICANCiAgICA+ICAgCW1lbXNldChzdHIsIDAsIFNUUl9MRU4pOw0KICAgID4gLQlz
bnByaW50ZihzdHIsIFNGRl9QQVJUX05BTUVfTEVOKzEsIGEwLT52ZW5kb3JfcG4pOw0KICAgID4g
KwlzdHJzY3B5KHN0ciwgYTAtPnZlbmRvcl9wbiwgU0ZGX1BBUlRfTkFNRV9MRU4rMSk7DQogICAg
PiAgIAlxbF9kYmcocWxfZGJnX2luaXQsIHZoYSwgMHgwMTVjLA0KICAgID4gICAJICAgICJTRlAg
UGFydCBOYW1lOiAlc1xuIiwgc3RyKTsNCiAgICANCiAgICAgRnJvbSBxbGFfZGVmLmg6DQogICAg
DQogICAgLyogUmVmZXIgdG8gU05JQSBTRkYgODI0NyAqLw0KICAgIHN0cnVjdCBzZmZfODI0N19h
MCB7DQogICAgICAgICAgICAgWyAuLi4gXQ0KICAgIAl1OCB2ZW5kb3JfbmFtZVtTRkZfVkVOX05B
TUVfTEVOXTsJLyogb2Zmc2V0IDIwLzE0aCAqLw0KICAgIAl1OCB2ZW5kb3JfcG5bU0ZGX1BBUlRf
TkFNRV9MRU5dOwkvKiBwYXJ0IG51bWJlciAqLw0KICAgIA0KICAgIFNvIEkgdGhpbmsgdGhhdCB1
c2luZyBTRkZfUEFSVF9OQU1FX0xFTisxIGFzIGxlbmd0aCBsaW1pdCBpcyB3cm9uZy4NCiAgICAN
CiAgICBIaW1hbnNodSwgZG8geW91IHBlcmhhcHMga25vdyB3aGV0aGVyIG9yIG5vdCB0aGUgdmVu
ZG9yX25hbWUgYW5kIA0KICAgIHZlbmRvcl9wbiBhcnJheXMgc2hvdWxkIGJlICdcMCctdGVybWlu
YXRlZCBpbiBzdHJ1Y3Qgc2ZmXzgyNDdfYTA/DQoNCkhpIEJhcnQsIA0KDQpTaW5jZSB0aGUgZGF0
YSBpcyBjb21pbmcgZnJvbSBmaXJtd2FyZSBpdHNlbGYgc28gaXQncyBub3QgXDAgdGVybWluYXRl
ZC4gU28geWVzIHRoZSBhcnJheSBzaG91bGQgYmUgdGVybWluYXRlZCB3aXRoIFwwLiANCg0KVGhh
bmtzLA0KSGltYW5zaHUNCiAgICANCiAgICBUaGFua3MsDQogICAgDQogICAgQmFydC4NCiAgICAN
Cg0K
