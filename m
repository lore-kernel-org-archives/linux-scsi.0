Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57F1C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88D7720866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="T9Z2puh3";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="OZbjqFcr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfHNXys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:54:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726119AbfHNXyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 19:54:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7ENo17e003378;
        Wed, 14 Aug 2019 16:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rGgmNfu/M0BXg7gxseq7VnOLl4i1aL2r3v6OWMUlsNs=;
 b=T9Z2puh3JvTHfO4asIBz0VqUtoO/wll8wxtfW1YQdOPDLa1Eq/zKfjLhOjvba1xKuAGx
 T1xTvR0SeHCD+4C8gDZTJA4dJeBit5jA3Zl7RXKfeWMd3S6hiP+vHuhcAU0JIM3zP/Ew
 l3bhO4vR0B6yX60ABqIk+XdPLOEn+Muu7dISSdTcj3kLvVWiAdd7WJd2zl938MlpveUG
 4vbj6OQXICxiMVcU5YDmRMCHFxiiqJSbwaebxn5BH/tVYg7FUnh5+kyGwQk/k8OCwYTm
 Wbz949MnMlYTuZeA/VfXcoEK7wP2vaEarxx4NO5fMHScQKKEkBfZShhe4pH3HQvYx08D +g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ubfad26pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 16:54:41 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 16:54:40 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.54) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 16:54:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In387cyDxhsU3zuEwVamp6flwaFSGZ12G9TsZ1n2jlCE3qbvVo1UNP4vWd75zLSB5mG+SA859EoZIedyAYT9Alt6lFx/lztLPj5T5MW0xsRZxw43DkaEtRa21aDhUVgztY8UlasrFEiqwU1GN7RXZXztPWQDAxxyR/7fq1pS5RK2RxeDz2qQ0v3lWMj1Y95catSj7YmQ9LBLGkBJ9szXIUdA+99KrzjlEBtOPAhjWYYH6zE+HAWi8hSI9RNf2bfptXhND1Cf9cB8Ciq+ArIu3D0d9emvHascOO1rL585QQDrGwZTkme5zprKotmhdo8C5ecG9/1thGY5tsAn7xHtXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGgmNfu/M0BXg7gxseq7VnOLl4i1aL2r3v6OWMUlsNs=;
 b=SnzFttgOKih91rmHJK4y+KbbUv8KLSmeptlCrl0teD71NqV9jFvF7b2tDfUhFg2fmIFcSPlGB0sZk/866U5tp4yl0b3i9dL0551QWIXnkB4XkX9pd06G/LoLMiYsv15EDH9XMtySZH0g+ux2j4QM1rEdWKqAtFmMUY+299JDs0yktru5H4+7RR02WWkUFmrmFceR7dK6PI6oWum43Axi0F0X0Z9N0ORSrmTyJ/4uIzIpTgFfBH2R3kBy2uBEqIkO9t+tQl00xvEbms/xwCQuPHmbvAWILiIsoThs4VKXBYrRqXeoTdY2yqoBXM6TLkBDXnkzV8hvn/eMARpmKnNclg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGgmNfu/M0BXg7gxseq7VnOLl4i1aL2r3v6OWMUlsNs=;
 b=OZbjqFcrjKoipz/mKGjERDpby/y702nLfU1U7dXjBBnzuZhU3LsBM0/lZjlv399qpWdxig86EYDhddfrcCSf+BOTCZEegwpb53yDRyYN+bpGPRijo1eYoydHzVRNSqv7gUhqzs4oK0L2/0q2ETWj7Svy1BnNJLa1/Wn8OQzVguo=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3293.namprd18.prod.outlook.com (10.255.237.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 23:54:35 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 23:54:35 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] [PATCH v2 0/2] scsi: qla2xxx: fixes for FW trace/dump
 buffers
Thread-Topic: [EXT] [PATCH v2 0/2] scsi: qla2xxx: fixes for FW trace/dump
 buffers
Thread-Index: AQHVUvugx9Hs3Uxb40OY2yXH88WrwQ==
Date:   Wed, 14 Aug 2019 23:54:35 +0000
Message-ID: <032DE22C-618E-4888-877B-1603C96D641F@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [107.77.218.51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd9ad6fc-a509-42da-9e83-08d72112c2ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3293;
x-ms-traffictypediagnostic: MN2PR18MB3293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3293E808179F6E6712F4CCAFD6AD0@MN2PR18MB3293.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39850400004)(51914003)(189003)(199004)(8936002)(6512007)(6246003)(2906002)(81156014)(316002)(33656002)(66066001)(5660300002)(6486002)(110136005)(58126008)(54906003)(81166006)(6436002)(36756003)(478600001)(53936002)(71200400001)(71190400001)(4326008)(229853002)(14454004)(99286004)(2616005)(476003)(7736002)(6116002)(102836004)(6506007)(305945005)(86362001)(3846002)(486006)(256004)(8676002)(64756008)(66476007)(66946007)(66446008)(186003)(25786009)(76116006)(91956017)(26005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3293;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6IBbV5ohpslIgOCRwps0W3u/OsFl9cCJyohhD/WeGWGTHathfK34ELCDb+hhkZh7/y0EqvxPVXEkMzvKai+8XoSP84IXZy9QEESKD/P1vxiwYsgZOVOVAEbt+thwSYI9oacf8T2jznvc1dMMIdLCNAKbo2sk1UaHB55e8nhtFTjUrp4NaRa8I0g/Vvro+AKHprSf5sOuxFpIuns2O5zF9QAencZBKOqeNny7S4H2V5VBMGqKAPAUiShJ/F5qX9gxgcXjbCyIswKxC5JmWlfyWP2HgSoeKj1fPyOSM0f/PIXzaZ0XBopT3cjhWIh/RUToLJz8a0DcZSr3c5qRGY/Y0b/xc7Quh8ZytJ0sBqufQN7IfW3mJY2pa8ob6R+1NiGah7v7hj0NIE5r3CWLqlh7/gsdm5W6XaiDFnRjXKnXMyM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6865CD7B6C49A745AA29EA46615EDB99@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9ad6fc-a509-42da-9e83-08d72112c2ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 23:54:35.4396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zkK+98iKe4enEF8eYS6oHR4Ld9B2uFAMt5p19Ef/TEVsdKibiTSMLgmKROTVubyADyUQvAAT2Xr/Bgl58FzyOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3293
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_08:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluIFcsIA0KDQrvu79PbiA4LzE0LzE5LCA4OjUyIEFNLCAiTWFydGluIFdpbGNrIiA8
TWFydGluLldpbGNrQHN1c2UuY29tPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAg
DQogICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KICAgIEZyb206IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2Uu
Y29tPg0KICAgIA0KICAgIEhpIEhpbWFuc2h1LCBoaSBNYXJ0aW4sDQogICAgDQogICAgUGxlYXNl
IGNvbnNpZGVyIHRoaXMgc2VyaWVzIGZvciBtZXJnaW5nLiANCiAgICANCiAgICBUaGUgZmlyc3Qg
cGF0Y2ggb2YgdGhlIHNlcmllcyBpcyBhIGZpeCBmb3IgYSBtZW1vcnkgY29ycnVwdGlvbiB3ZQ0K
ICAgIHNhdyBpbiBhIHRlc3Qgd2hlcmUgcWxhMnh4eCB3YXMgbG9hZGVkL3VubG9hZGVkIHJlcGVh
dGVkbHkgdW5kZXINCiAgICBtZW1vcnkgcHJlc3N1cmUuIFRoZSBzZWNvbmQgb25lIGlzIGEgY2xl
YW51cC9jb25zaXN0ZW5jeSBmaXguDQogICAgDQogICAgUmVnYXJkcywNCiAgICBNYXJ0aW4NCiAg
ICANCiAgICBDaGFuZ2VzIGluIHYyOiByYXRoZXIgdGhlbiBrZWVwaW5nIHRoZSBwYXRjaGVzIHNt
YWxsLCBjbGVhbnVwIHRoZQ0KICAgIGJ1ZmZlciBhbGxvY2F0aW9uIGNvZGUgcHJvcGVybHksIGZv
bGxvd2luZyAoYW5kIGdvaW5nIGJleW9uZCkgSGFubmVzJw0KICAgIHJldmlldyBzdWdnZXN0aW9u
cyBmb3IgdGhlIHYxIHNldC4NCiAgICANCiAgICBNYXJ0aW4gV2lsY2sgKDIpOg0KICAgICAgc2Nz
aTogcWxhMnh4eDogcWxhMngwMF9hbGxvY19md19kdW1wOiBzZXQgaGEtPmVmdA0KICAgICAgc2Nz
aTogcWxhMnh4eDogY2xlYW51cCB0cmFjZSBidWZmZXIgaW5pdGlhbGl6YXRpb24NCiAgICANCiAg
ICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyB8IDIxOCArKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYyAgIHwg
ICAxICsNCiAgICAgMiBmaWxlcyBjaGFuZ2VkLCAxMDIgaW5zZXJ0aW9ucygrKSwgMTE3IGRlbGV0
aW9ucygtKQ0KICAgIA0KICAgIC0tIA0KICAgIDIuMjIuMA0KICAgIA0KICAgIA0KVGhhbmtzIGZv
ciB0aGUgc2VyaWVzLiBXZSByZWNlbnRseSBhbHNvIG9ic2VydmVkIHNpbWlsYXIgaXNzdWUgb24g
dXBzdHJlYW0ga2VybmVsIHdpdGggbG9hZC91bmxvYWQgc2NyaXB0IGFuZCBJIHRlc3RlZCB5b3Vy
IHNlcmllcyBhbmQgZGlkIG5vdCBzZWUgdGhpcyBpc3N1ZS4gDQoNClRlc3RlZC1ieTogSGltYW5z
aHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQpSZXZpZXdlZC1ieTogSGltYW5zaHUg
TWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNClRoYW5rcywNCkhpbWFuc2h1DQoNCg0K
DQo=
