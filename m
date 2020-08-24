Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A2AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 10:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E850D2074D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 10:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DKmtUGwR";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="MZ12EK4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgHXKtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 06:49:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgHXKtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 06:49:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07OAjpIM018407;
        Mon, 24 Aug 2020 03:49:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=AkiuOsNSOKgbHF0f67ZEShOuPEbPekVe/rWz6t2oqYI=;
 b=DKmtUGwRhIb7uN6X9BBQb6Iq50OukybQXQlcR6ehEzC6awIqWVlp/sPTp4gi18AMbPmC
 bSKgSVbPzM4pi8ziB77eC5tzhZ/PQPIhivKcP5P35MmPYlr8d6hc3GFKaA1BrbRYuUyZ
 VLpjPOMCyxvAx0UaXcj/5jEztdOwyDPsb/1uI7OiTpQI0unbSiUOBTshzQ6UGJjQ9Jhm
 MyqVHF8zNwDuB09/PWHumLVmUoUt29N0vslzH/QPlfojL2zIJxjM8eXP/4rPaNZmflKr
 2lPXDgrLugbTQO6YzxLnTzXhpF+cdoQfnzEBF+m9basrGB8Aw25Xrym0NiluPMkvTQPc ew== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmpamu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Aug 2020 03:49:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 03:49:31 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 03:49:30 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 24 Aug 2020 03:49:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF/EA9Qe1AW6ECgODZ5tjnuIgvQtGl4ZAZIOrziYvld+1/UzGFxlVW6QWbk45mBT9k/PzlHKjbVfeKI8WPKwT+gFM0o8ImmgtfpVANN5tFvxg62OaHBN4t5MBvpGHjF5fnC59B4cXPIT8yDUXD3vkYnN4v0rgMAARR+kCWov/1Jv4wAM+YzObgye/wS/EpvnnpW6wHhpA7NHaVwYMHzz6qUs3LYnjqsE640mt0NffDqw0Aa/9tyKl8SCYAYsctyh4yHT7MlDNjMCYmtiWCQ7Jc7E76jfWDqQqiPAdFS4HWjjvhzBnXBk1HQQZo8wqqslsJdp8IUFs76C3VRb3UtLbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkiuOsNSOKgbHF0f67ZEShOuPEbPekVe/rWz6t2oqYI=;
 b=Yu4VHr+3GjBLRHgKajnm2sbejauKm69d0DvwQSWpCIdtcBPLA1m6PlrJ3KIC3uGBy/2fJuWyH9fHc36TV9WqpL9Vm8tpQCoGpRYWvRd23fBwtxm6uzzbM993UzdDQn1FlBkRyBfIGV0/Z7fTEQ4CGwRSWQhaZflXDAQtqw1Au7fXyqKquOenM2js82dlHaltPUqH4Yfrtv1rRzweR26nOp1ESooDy9FKKZ28dBL+S6umfe73M/KnFpCXYXHj1Fk3ooCFFpUSL9S+8dA1FDwiZIcQPw8ghOKWojY27BV3CFKFQUhK0Jyo6ylSKCT8/94Cryts1G6RHqEnsjpPjoV3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkiuOsNSOKgbHF0f67ZEShOuPEbPekVe/rWz6t2oqYI=;
 b=MZ12EK4jdEtA/TSHx/2al/WRhpyc2m5WlUm+/1J3Y8W3qlvqLXpW9tI5h1QSnMEyK752IWCUE8o3QMjfqHhn2LEBlAshjxVQ9mY88SZb7ElHTnxrbGTRlKXtAkzFNf4ydwcjlVurypG4eB/xaGdskB7bCElI2sH5MU8ULuNistc=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR1801MB1980.namprd18.prod.outlook.com (2603:10b6:4:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 10:49:29 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd%3]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 10:49:29 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
Thread-Topic: [EXT] Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
Thread-Index: AQHWbI/+O96ANa5b4ESWnC8uuaWMj6kxHdYggAPHTQCAEhwOgIAALgfw
Date:   Mon, 24 Aug 2020 10:49:29 +0000
Message-ID: <DM6PR18MB3034E17CCD8A2A558E5979F0D2560@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-11-njavali@marvell.com>
 <20200807075428.bzrhqwllvt5ajfhl@beryllium.lan>
 <DM6PR18MB303407CDC145F69390C28F5AD2440@DM6PR18MB3034.namprd18.prod.outlook.com>
 <8A1A2F11-3BC8-485A-9893-F91AE63DD4ED@oracle.com>
 <20200824080415.st3hazliqcfwxa4q@beryllium.lan>
In-Reply-To: <20200824080415.st3hazliqcfwxa4q@beryllium.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.230.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99e72a45-1037-4fbf-838f-08d8481b6082
x-ms-traffictypediagnostic: DM5PR1801MB1980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1801MB198060AF5B6C10854295A42AD2560@DM5PR1801MB1980.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 06jo4FrWg5fppvUpjfTP+ADMmwENTJzDeQELgLJoU+0x9fjpCaI/Hg+qOilTHWIMfwmhnumCiG+OvYdzfmo9Cu/vUBrePn1NvwgoGlUSWThABo0mB9lFs5CzF/F2NYPl6nbTwPsrjRj6/mI/ditCAk/z0KoFfzceb2oEGH/r/byPpquuEGqdBCHD59vjJIaMdhioqzqn6mW/8D/4hNyalcnMU0RqPmngrpKIvttVkrvt4cZphEgyLBI9/XLkcObKKUB0W2B05+QidEZY1avkMPYroDcuSvWD72+/Vs7DF14DX3XtoK4wSlcNlZTDFnZns1kqk3/GDhGbRb/CbPr4+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(366004)(346002)(376002)(9686003)(54906003)(110136005)(2906002)(7696005)(186003)(8936002)(52536014)(55236004)(66946007)(26005)(66446008)(33656002)(6506007)(5660300002)(83380400001)(478600001)(71200400001)(66556008)(53546011)(64756008)(316002)(55016002)(107886003)(4326008)(66476007)(76116006)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: O/ghPRESpR0PINlhzHH/Eag2vvnyhxQKt4pUugKKK9tBagQvngYOneQZD0zK6MqXLkuMu2Iestr8pzlpPktUdl90zcgHEMUUxJYCof8v7StVtt9cod5zHfY+Gmw0SxcEHGVdcO3m8GjPmJb+h/EWAIUhugaOTFm9GRUgdVCWnBQ49WsFd68jEs6/dKLabjfdd3qzB5mCPycDaAIlSATAlwX4ZlmOBd8m0fxauKlqluwxFTsJ3ikCExuHum/jbZ8QdkkZBPDS6kFsWxn47ALV4Bri5QZuqC/dCh41RhOMmjkKMT0Sxg00glZvq12QYdLbFFuDIQUEaqrEy21I0R+RVty66RusACc60Zr7xXRZtComopdVEYCHCard5OxHrvUuYIVEP6Rw+fTo6X1Y45TR8s9KVVRnhZ2GedF2Q7sD5qWdtda7yP/EGPQFlMWgVgDvQhTYUaGiB6K0dBVLuDcQh4fw3z/JbTHPyXLSQrnczBXk5VrmNJsAy7fZnUMk45xCfSbQbmqoaBj8uPJCBUtmoLT3v6nue4ZKs3zgFoaFX2hYTUDWicL/G8XNT60ojV100/BdEUS5MTI1xkW0tP0pRIMV+OOmwYtlXGiXhp/Io2XoT9yeToAd3RKd49Q8dRwkI5e6Wyc408tEjo1K6HdpFA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e72a45-1037-4fbf-838f-08d8481b6082
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 10:49:29.2268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: faFoTD1Y9IQh1VWO8SOaeSNT/DN67vsPJiEUtXn3YAmPKbc3OrR2MdwcwRIGdMeY/bKpUgMuYQaEU/oooAlI/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1980
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_08:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Daniel Wagner <dwagner@suse.de>
> Sent: Monday, August 24, 2020 1:34 PM
> To: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Saurav Kashyap <skashyap@marvell.com>; Nilesh Javali
> <njavali@marvell.com>; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
> qla2x00_mailbox_command"
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi Saurav,
>=20
> Sorry for the late response, was on holiday.
>=20
> > On Aug 10, 2020, at 4:55 AM, Saurav Kashyap <skashyap@marvell.com>
> wrote:
> > This patch was never there in OOT driver, and we never hit an original
> problem. I have tested this patch myself
> > and this have gone through test cycles as well. If an original issue is=
 hit again,
> we will do an analysis and provide
> > the fix. This revert fixes a load issues with ISP82XX.
>=20
> Ok. Maybe this info could be added to the commit message (next time).

Make sense.

Thanks,
~Saurav
>=20
> Thanks,
> Daniel
>=20
>=20

