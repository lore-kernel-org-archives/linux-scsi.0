Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D47CC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 04:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC53220732
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 04:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IRqW3Vzt";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="uCGDYd9t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgC3EDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 00:03:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27224 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgC3EDQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 00:03:16 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U3xwQg028837
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2020 21:03:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KNGOpQZRH64fAV6YiWOTGSgF3v63ClpakzB7R5ALrag=;
 b=IRqW3VztSZjGvxJxCyN1fIf8Ncf85VSNW1K6GqSjoSk8acIc3NT+9stRndrrieGCdo8Q
 kiX61KDubl4D8mxPGlF+yCBRdjNWgOW6/095FdZnKvN5EJavL809ztBmbBTuzrHhQeCW
 Q94FanExqvV17jTjVnICnSLMtygUZqkTiy36qrphlPujAtktt5BCxS9ORKnr27q7VHAd
 sOmMcFp0bDiwP5QDEzCEpNVI8JD4M6AnvCUKz1ZiV9JGQEpuUYwrXFZ1HTAVToBd7ywe
 euyLqDl6hz+XBBO30sYWtOyHJ0RyoytJCBbwdx2OuedFmFYn4FGeot392LRGOdBTzuB5 mg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30263kcp78-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2020 21:03:14 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 21:03:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 29 Mar 2020 21:03:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeY41TOogiFe0I5BeRnjDKZjj7EebxgxfHw4iIX4oWNFaeivneMVrSpnkqYotyvm3xdP4YDuRl+po3xw1XCJATh1S01wts/TR1qENLgFO6ZKOUXCE9NxTlhmCj7t5AojClQlCFUtKvuLypcHVkZO2ja+HeP8EEuWzc0USYv+43FdSrmMHGrzL0B2WvvEgvHJodxCHAoXL7pn1EgFt4zvAS08RgmP+3UoRFvRCo8cnqJKfR0fZmlJrsiq7VNgs5xb25hQi6WLUgPOMyvVbiGGTgR3MQBaJyI7VG8BgZu6p9HhkPxeHcj2OTkkhCFRaMWuxcpg8O0rDyKv4Gdgn6y5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNGOpQZRH64fAV6YiWOTGSgF3v63ClpakzB7R5ALrag=;
 b=gxMt16fTy5M2I6dRPKt3Y5MuzGIzxfZhd2eGpC3A1v7RqLL1/hFplG5hbTSg3G7eK1u6ADSvs7I9ylGNJuUu1tNaZeO+FUMMmkHypaz2AdO1uttCTNtCYDFAi06ifrugLLF6GtZFVvc7huxN/rQleSa7Dn2X9kDxi+8THobGvp4EFPbK90xxZtarhArYMIgKIQH0DzZP3T5UaxMmSa6CC7UECSD24ZWkHSFqJgRHnlD1vN+Uzkfi69ot7iQMHhU5vRdZMLP4UtmuxJNHspF2rL+7kWQ8VEopk/in56QKmU/hKnmGD2gc6N/36wiGDqfZVGHHITYS9vUcV4Hhhryi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNGOpQZRH64fAV6YiWOTGSgF3v63ClpakzB7R5ALrag=;
 b=uCGDYd9tpZjnO1RuX/s74/fhIVKHNBJ+8rVRLZtXqcU4FEfuUUvHrqWJB8zgNSGBR36dd7+DhSUirGtqwIUAXQH3995prd0JjfR26eNPap7e5lpRyrVQv4HZ6k/fGpmnz4pTIJwri0vxZ9vL3P+jMpeaW7AfTX1brsv9cHBxWBc=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB3591.namprd18.prod.outlook.com (2603:10b6:208:264::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Mon, 30 Mar
 2020 04:03:09 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 04:03:09 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 0/3] bnx2fc: General updates.
Thread-Topic: [EXT] Re: [PATCH 0/3] bnx2fc: General updates.
Thread-Index: AQHWA/tlErF1rPgPuUel5xoM2YFPqahcwN7VgAPHOiA=
Date:   Mon, 30 Mar 2020 04:03:09 +0000
Message-ID: <MN2PR18MB2527CB8AE9366EC4C3A6C187D2CB0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200327054849.15947-1-skashyap@marvell.com>
 <yq1wo75acge.fsf@oracle.com>
In-Reply-To: <yq1wo75acge.fsf@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [45.127.44.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50570210-2dab-4711-2123-08d7d45f423d
x-ms-traffictypediagnostic: MN2PR18MB3591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB35918EA225FF8CC9C15D8F34D2CB0@MN2PR18MB3591.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2527.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(39850400004)(376002)(366004)(15650500001)(478600001)(316002)(52536014)(7696005)(86362001)(6916009)(5660300002)(54906003)(4744005)(186003)(53546011)(6506007)(26005)(8936002)(9686003)(8676002)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(71200400001)(81156014)(81166006)(55016002)(4326008)(2906002)(33656002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Akhv2PhVAXSlf6K9ygCiQ3dmDlFxxKxq+uDc8d3PaglbitArZt6p0zKp9LSQRlvS30mci2P2hESbRRaLA+4YfExcvXKGp87cdVDDoRX2fwsoBK/ket5zZOJlidZ3nsVIuUH8xJstHjnX8tnlHd2w8BBsEJ5+Dzwc3xEeU3h2Ydv586h32DjfMXnbywPL5gLqgnxt2gHq97gG1U93yk4SRVZRB8heqFF/zcjTewGvh7/m6iJABg/21r20hN8gmcw6CPWnUUoWBXlKc+9LwsDI+b+v/+1OxOZX/MIV9Shqws7ybNEyhjMef1JL6Sz4kcMj5TweeRyqFVhzzmQfWCdzEG7rxlykSISdgd54rbltrKR8lKcDu6tJAckqvdJhpCAv20OglcsfsMu9ggA0j0Pkzn+ruY4L4Pnqs/zsnNild4rOEfR3PkVF+BCnjAlN5yQ/
x-ms-exchange-antispam-messagedata: y/nAUumDpbw0QQbMKp5DTQ3eMVw47xYiWb41UnkXyuOEA9vXGqjcHGftbue981qyWB6VHXte4gtQKg4qTBq6sE/Hpfes033cQ9k5q13SK+9MjpZDb9JISUvnbSuopHNVWp0HBKvojGpgVQukGRGmYQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50570210-2dab-4711-2123-08d7d45f423d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 04:03:09.1580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PxYlt55o03t6VPhc87mU5XMs3VK45cf5eJ05jKShY7onPpGnAnNnviuhdNQvpkUT3b7G95ocBXv0JVRiex7/Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3591
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks a lot, will take care from next time.

Thanks,
~Saurav

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Friday, March 27, 2020 11:48 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org
> Subject: [EXT] Re: [PATCH 0/3] bnx2fc: General updates.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Saurav,
>=20
> > Kindly apply this series to scsi tree at your earliest convenience.
>=20
> Applied to 5.7/scsi-queue, thanks.
>=20
> Patch #1 had several indentation issues which I fixed up.
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
