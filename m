Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FC1C49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 16:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06682186A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 16:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="oayiqqSv";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="F+B2fCaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbfIPQTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:19:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7084 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbfIPQTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Sep 2019 12:19:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8GGF8aB025719;
        Mon, 16 Sep 2019 09:19:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=JXW9tQgK0u/t8JXA/0q6gjPZDprw7qlE/kIW2nWaBCA=;
 b=oayiqqSvvmFkr101ZKAqgWvFBwzBIadnwPuOMP8vIAFdgRNuv6oynQhGJtItZizCDa/8
 nZ6P/UjjiPJ2pIR9YgLVRcdjhpbNbpeq5RCNvBWTkboE9tMqXVIGNiUuC1tK0/5EYBvL
 Eli5H14Z0vHKlKON6NOgr5bnHkDMxFNdGvNueaL7reZEr6qvY9aVfmyouojeiuXEt69N
 lXF7S5+AYZjBeoUvucAeg9UVtieieISZld46yL94y0DuS0kZ/U/1LyaRFZwJSYl+A2RP
 DZ2zJ069j5jp2SkhK6qpBuzXqhQq+Dh33fVDgzBWT0jRxOysjuA0pBWNWSupjAOuAyMG Bw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2v0wjpfubn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 09:19:16 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 16 Sep
 2019 09:19:14 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 09:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9mQTh8lEZn4mR0rzLLdzhGyGhegZ7y504TA7RHUXJUPQu8+cTwLG0OEKK7AGcXnOylDMFK6Yq5mg8HgGk4HBLODVli6en6RfFVL+lvtlXvS6UQhTkmj7SOtiJG3+S6PRe3acZ16LQPl9XJl48sLq08sztecc6YgeDYGNgDNBmH72DnR+Xx6cspHPxwE7+VX5tLjzHJOjvkxAwdx+PW3k/jIct/EKCULez6eS/cLwaAfwIICEA6dHQS4DAGdfsZC30UpIDlo0MMAij7bszvXfCZosQX4GIajjQEGSTRptITI2ZBjdDpDIvjStiHMjoKdtqutSABpHZL/aXionzi03g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXW9tQgK0u/t8JXA/0q6gjPZDprw7qlE/kIW2nWaBCA=;
 b=K9BhbLpFTP0y9dx9UkdDhcjpA7ofz5t+DUNzzqSU4tDmN/WL4R187m+0IKEy4PZEpnRp9IBHaMzPVz1v0Q9HokPQmuicwDlEV96MPv/H7Slppv7Sq+SVgb8Y7jtizZQ0//iE12lif3X5uLNf2v56+EhIyApcvFqlo68QG5XhZxWG43Uip3FE5I6dk8s1jEaqX3nxGNnN8Ebs2I7SJzd83eGWd9xLSxwQx4R3brpQM9o4zYIPooA2VrLD2YGmiRTmENt3c0x42pKhPJsLKTGXdl7xwhYWhcipnWEe0LJdDEJgEg/TiwDrsxKK/8+xZCeqCUutDpB+CowqEIH/ZSh17Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXW9tQgK0u/t8JXA/0q6gjPZDprw7qlE/kIW2nWaBCA=;
 b=F+B2fCaCELGYkib29g9+Aq8eOGJ3/K65KQdMkSDxawiqU9u75Gv/2i/Ev4GTmX5nDTA4vnR/PxOWWm5Y3bjUizOFoq6FXe8RMycu6LZHe8Bmy0jO56ATdjn4ccVgqqACjuTk83k7bItVqRvXIKLP49Xr4WlRSYsckhZqlc4J8bE=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2621.namprd18.prod.outlook.com (20.179.84.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Mon, 16 Sep 2019 16:19:13 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933%7]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 16:19:13 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.de>
CC:     "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
Thread-Topic: [EXT] Re: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
Thread-Index: AQHVX4GnQnGRQbPLAE26WD+wLnlRJqcqJuSAgAAhsvKAA/mGAA==
Date:   Mon, 16 Sep 2019 16:19:13 +0000
Message-ID: <E47BD0EB-38C5-4248-BE6E-540209A2DF37@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
 <20190830222402.23688-3-hmadhani@marvell.com>
 <bcab32ef2d17d7d14c3a5d41ee711e21ab749ab3.camel@suse.de>
 <yq14l1fddrh.fsf@oracle.com>
In-Reply-To: <yq14l1fddrh.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [2600:1700:211:eb30:3975:5be5:7776:fd50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45346b0a-d0f1-448c-9a16-08d73ac19cff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2621;
x-ms-traffictypediagnostic: MN2PR18MB2621:
x-microsoft-antispam-prvs: <MN2PR18MB26215CEAF9C6B7E85423CB0CD68C0@MN2PR18MB2621.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(189003)(199004)(305945005)(478600001)(7736002)(6116002)(14444005)(6246003)(256004)(486006)(54906003)(25786009)(33656002)(2906002)(58126008)(316002)(476003)(4326008)(186003)(14454004)(4744005)(76176011)(2616005)(76116006)(446003)(36756003)(11346002)(229853002)(6506007)(102836004)(110136005)(86362001)(66946007)(8936002)(8676002)(81156014)(81166006)(46003)(6436002)(6512007)(91956017)(66446008)(71190400001)(71200400001)(66476007)(66556008)(99286004)(64756008)(5660300002)(53936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2621;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pd1pCXhoQALcXnCJVnTujQD8b8hRzMytwTW0UNa7k3E/zfHJ3taoZGobzjEC7MKis2wZbg8/RKYKW4ei9hXGsnisOd5OZprAG9cwfGQtEROkrKGxQ4ReL17pqLqD987/5sGCh8ZUw8HT6tuUABaLeQfemQ/0OPfQ3plGdsud19swxdR8fecOvujntrWPekLai4YPcNIGytD8CS7q7YrIKxy4X9TdjLewrvN2j0trfZRt2kkoY4xhf95M2BXW7riHrz/bws89usn5sea01ElAukb81WnUYvJpdhAUSMV/XXj+/4q0T/Lb16r6wGCZEV8kh55wxdDon3+CYLrdX8WULB8kh/K/+fAjwaxqz7VvPflnDgcbA07IrMC2J0ThEZyxm8uIU6J9y0MFcJfyr3n58/AL8fSrlcWx33Wse/ZYm4Q=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA2B96B6E6653445B617BA7E642ABDDA@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45346b0a-d0f1-448c-9a16-08d73ac19cff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 16:19:13.1191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pz8IQZgrKkP0octPrReTsUX+I8aiYXsgGTOhYKn5xTww0hOt1cNG6p8AOF22NOUqXiiTqWBNcVTaMff+lUkf7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2621
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_07:2019-09-11,2019-09-16 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCAgDQoNCu+7v09uIDkvMTMvMTksIDU6MzcgUE0sICJNYXJ0aW4gSy4gUGV0ZXJz
ZW4iIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4gd3JvdGU6DQoNCiAgICBFeHRlcm5hbCBF
bWFpbA0KICAgIA0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAgICANCiAgICBIaSBNYXJ0aW4sDQogICAg
DQogICAgPiBJIGJlbGlldmUgdGhpcyBwYXRjaCBzaG91bGQgYmUgdGFnZ2VkIHdpdGgNCiAgICA+
DQogICAgPiBGaXhlczogNWZhODc3NGM3ZjM4IChzY3NpOiBxbGEyeHh4OiBBZGQgMjh4eCBmbGFz
aCBwcmltYXJ5L3NlY29uZGFyeSBzdGF0dXMvaW1hZ2UgbWVjaGFuaXNtKQ0KICAgID4NCiAgICA+
IEkganVzdCBiaXNlY3RlZCB0aGUgRlcgaW5pdGlhbGl6YXRpb24gcHJvYmxlbXMgb24gbXkgODIw
MCBzZXJpZXMgQ05BDQogICAgPiB0byB0aGF0IGNvbW1pdCwgYW5kIEkgY2FuIGNvbmZpcm0gdGhh
dCB0aGlzIHBhdGNoIGZpeGVzIGl0Lg0KICAgIA0KICAgIEkgYW0gbm90IGdvaW5nIHRvIHJlYmFz
ZSB0aGlzIGxhdGUgaW4gdGhlIGN5Y2xlLiBIaW1hbnNodSBvciBRdWlubiB3aWxsDQogICAgbmVl
ZCB0byBzZW5kIGEgcmVxdWVzdCB0byBzdGFibGVAIGFmdGVyIExpbnVzIHB1bGxzIDUuNC9zY3Np
LXF1ZXVlLg0KICAgIA0KU3VyZS4gV2lsbCBkby4gIA0KDQpUaGFua3MgTWFydGluIFcgZm9yIHBv
aW50aW5nIG91dCBtaXNzaW5nIHRhZy4NCg0KLS0gSGltYW5zaHUNCiAgICAtLSANCiAgICBNYXJ0
aW4gSy4gUGV0ZXJzZW4JT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQogICAgDQoNCg==
