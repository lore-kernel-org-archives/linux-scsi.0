Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0F7C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E3620872
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 09:10:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="d1wrD9QW";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="and1zsNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504105AbfIXJKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 05:10:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5856 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729889AbfIXJKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 05:10:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8O95E25016174;
        Tue, 24 Sep 2019 02:10:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=U6kyGhw4kq0OhVlpSF+1Ah9m5NBNlnSpz/p0OYiu4xU=;
 b=d1wrD9QWhNTo05tk/rxjCAhl41m0c2sOooQeKpOa4QIr2inTrbQTE1+67z13skOv0mK2
 rOxPLCgx3qRqvMl3hGmI4f8fLftG1X3QtC6yrNAJ5bAPm1eiJ1/KYxjrqt4/94kkEZRZ
 488LJGOa/jAQiHvw1aqvshur4q0Dg7xW1WfNqgOwlDbM0x9YJFE2XVz/TrxbXuFoaXBC
 CJpsKX1cbh9OQg/rpjhkXf8elnNO+hD5J9GyodfUn6vKMmy/KT4h0V4+hkz6NnTxCnxY
 RTy1ESmnrHlTATux1G2szRmGUWub++pO8mBes/ZpoyF+J40vNC2+Lkbvt12EzwCM4qVZ Uw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2v5h7qj15a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Sep 2019 02:10:25 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 24 Sep
 2019 02:10:25 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 24 Sep 2019 02:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSf4cavh1Nj/TyMA3DgCWdWURhf354gWI+mD3JITnFB/M3+U/PeDcCVwXxNA4PFrQ1aObG4EL3QGK8SzHJg8IvQ4woYx0xZeuEtdnsRUQ4apDfu1X9dG+oRbKOOgZpioZTUwtBZumxguHVXYuPJGEsKXLbQqarRckl2dLB8fS6WgIr/QmgkY0sSTPWDIakTdU1jBxQATcT4+0FX9bZZUDGBRPDXvd8t1rH/x1TyEDQsgAKD/PJK8+79xObVgR0M0sc9+y9jNkF9x0Vfh9/yb3oMrIrlqabPv9VlMI/t40/UcXjoRyJBLpSUlujVSH6CskUQNe40DYdJ4vbIC7j12xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6kyGhw4kq0OhVlpSF+1Ah9m5NBNlnSpz/p0OYiu4xU=;
 b=e2W+PVHF3BF4fJPgUKPJF/uuS54w4Hc+gn/8gMloBrDN+dM+I5pA2Zh1LY+LqcdMfEmCBBWcx7INvKd/p1s5CEyBU9GcmxeU8MvQ3X2TCszixdDT15pwqGsYm1hMgHPeS6NXxXHh5qZ0ncFIEYe/plxQYoe1WE5/DmZDWv/Q5hgO0oaYicogdk0u5YWu2nHoAYG9Uuk3IhOOM3rCHxvqm8E/g9o5yDOupQVTXA3+iEhMcZO11Ds6RqdV7lmUFXNRv733yd5npvreAX0sdk9A7qFvOgDHHqxVPFAnM0+7HU2HOwVWRS6x4vbj48yLNrCyWGN7Vk3OeJxktTCGZJepqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6kyGhw4kq0OhVlpSF+1Ah9m5NBNlnSpz/p0OYiu4xU=;
 b=and1zsNt007kmkBXA2K6z78gsel5boa1/oamI+150PDPzOKUhOjz3fi/W7hlUYmg6FhanC7Xw1bQbFDWE7rLy8PKks1G5L65qSDyF/1RPRzQdVm/2+EkOTsXbsjEa7GO26jQrr6xEfWdfryVuveCN7k27P0OxkeWy6mHVXcAwlM=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB3183.namprd18.prod.outlook.com (10.255.236.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Tue, 24 Sep 2019 09:10:24 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789%7]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:10:23 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] scsi: qedf: Add port_id getter
Thread-Topic: [EXT] Re: [PATCH] scsi: qedf: Add port_id getter
Thread-Index: AQHVcfrzLGK4JScA4kqhj7Bwh5oaVac6WHaAgAASMQCAAANZgIAAHYaQ
Date:   Tue, 24 Sep 2019 09:10:23 +0000
Message-ID: <MN2PR18MB2527C8FC1902CA98123E2231D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20190923103738.67749-1-dwagner@suse.de>
 <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
 <20190924071138.pifkyd75xhrminnt@beryllium.lan>
 <20190924072337.rfmgmyw2pjoi2lgx@beryllium.lan>
In-Reply-To: <20190924072337.rfmgmyw2pjoi2lgx@beryllium.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d40ac632-9d15-49d1-054e-08d740cf086c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB3183;
x-ms-traffictypediagnostic: MN2PR18MB3183:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR18MB3183A221222A5E80EB8FF5BED2840@MN2PR18MB3183.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(189003)(199004)(13464003)(52314003)(6506007)(26005)(6436002)(966005)(71190400001)(66446008)(316002)(76116006)(53546011)(102836004)(8936002)(11346002)(76176011)(52536014)(486006)(64756008)(66556008)(66476007)(86362001)(2906002)(446003)(33656002)(478600001)(71200400001)(4326008)(5660300002)(99286004)(229853002)(305945005)(81156014)(7736002)(66946007)(74316002)(25786009)(81166006)(14444005)(6116002)(3846002)(14454004)(9686003)(54906003)(186003)(55016002)(7696005)(6306002)(476003)(6246003)(8676002)(66066001)(256004)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3183;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tavfDpps4hAO2t/N/c8x6OWqSEOn1wocvjxwuNlcxol95VpfhEIGuLHSTqyr7bhvvorOToriCFgyW2Cx2b2Ph1WlZXdUboa9PHR9p4MPf3bCQsUm+4GdEYoyIRGH7xkU4+lISySbQC4HSqCOSTw5aeq/FX10bKXm4RUS9k95UHVVeKL3E2YcxSFvR6F4++WNFFD6NVW0hV9hMY8iy3RaMhjEFUeDcRm0pOsC6DVMje2vXamibWphQMcB9JQtWTQZ+6lLfEURqymg8uZp/28hrTAkKRzXoFnhbiiEkXEu9tzYjuzlzwlLXFucH+YACgsbATqFbEkH5Y8z+wu5iH74knOLztaV/MGXTLIGU9SODZarWGKiMpvdqmSJAYykPHJo5KYPbNfWK+kqI/XN5e1Uf6IID3pKjLd0y9rjha8ZGvEvCIhVE+Lrp+P0K7JrPHWRoj9w5+e5uXde1z5d+c16bA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d40ac632-9d15-49d1-054e-08d740cf086c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:10:23.8790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8DpaEqSd4GzawYb0AJYKZdhJJ0bHH+ibgpzSC3Oc0bnaN/rEtuFODgjMzdF5HqVs2Dzj5Mtx886dUVAUJ1ju6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3183
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-24_04:2019-09-23,2019-09-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

> -----Original Message-----
> From: Daniel Wagner <dwagner@suse.de>
> Sent: Tuesday, September 24, 2019 12:54 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: QLogic-Storage-Upstream@cavium.com; linux-scsi@vger.kernel.org; linux=
-
> kernel@vger.kernel.org
> Subject: [EXT] Re: [PATCH] scsi: qedf: Add port_id getter
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi Saurav,
>=20
> On Tue, Sep 24, 2019 at 09:11:38AM +0200, Daniel Wagner wrote:
> > On Tue, Sep 24, 2019 at 06:08:09AM +0000, Saurav Kashyap wrote:
> > > > +static void qedf_get_host_port_id(struct Scsi_Host *shost) {
> > > > +	struct fc_lport *lport =3D shost_priv(shost);
> > > > +
> > > > +	fc_host_port_id(shost) =3D lport->port_id; }
> > >
> > > Minor stuff, the closing brace should be in next line. Please submit =
v2.
> >
> > Oops, sorry about that.
>=20
> The patch I sent out had the closing brace on a new
> line:
>=20
> https://lore.kernel.org/linux-scsi/20190923103738.67749-1-dwagner@suse.de=
/
>=20
> Now I am a bit confused how I screwed it up. Anyway, I'll send it out
> again after with hexdump there is not a special ASCII character
> hidden :)

Sorry about that, I changed my email client and it remove the extra lines.

Thanks,
~Saurav
>=20
> Thanks,
> Daniel
