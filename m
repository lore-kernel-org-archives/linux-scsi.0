Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E29C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD872070B
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="wIGOVCQm";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="C/eEGiQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJJz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 05:55:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgHJJz0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 05:55:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07A9lPsJ031391;
        Mon, 10 Aug 2020 02:55:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=A7TPy17cS1+TGlx//lvRQY1gJifWzurJp2C5eNJrBNc=;
 b=wIGOVCQmCEp2D0B0qgWOIlI+yiqqJTrsu8D+Ou00ccD9jqI9AxPYJY1kgQc0lJ7yf5M1
 Ci6GvtA5Kpk7VsldaF+MtSXj8TbOCiuTTed41qAbzgvbg0SQxZITiMQdCPZRtzkMSopM
 TRBIsEDDO8lZ+vRwpwTMIhfSBBuRK81b8BHqEIe++MH8xQAXiz/XRNn7NEIsMksZ74Sj
 awAeBBPdonbCoXp7aNuzuMH2FJ3M62JDI4ush2tB54ZeEIlc9yU0gOuR6gq1sy3QKwcb
 x/YVVbVUJ1/WrVnsarhAenpIg88RKXgIXh7rX9CQLX3EGVUOeZFqLZzu32bi223RFqPk rA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32tgpkjq0c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 10 Aug 2020 02:55:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 Aug
 2020 02:55:11 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 10 Aug
 2020 02:55:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 02:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gr8yOwVli0wl0uTjoXbRUNPxAkBzrPROR+MnzbODzLRTnrfBvLnnQ8h6JmwgbmUjyIpAwX5d0HwMWbgIc8GKtvK31NWmjSBb4C78m64iogq2O9DzSbtMEx5gG7GOcAQLvnACt2GU0j880O1iskZHPrz/LEs/2VQoGMwfbkwMH0jeV/yTSiVCsiLaYOZS+ardB8AoPdhFeC0Q+dsMsKfYraehqObvEuBMfNj3rdhSpRKcIXFntQ67IgyKpjvsqVEq2VMzxGeG+OKqVod7roq94Vmz9vYhqt6r4I6m0RR2+cs/QHYOtcnvHZNiZaZZj4JSZarYpDJALvG+iSodN4N+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7TPy17cS1+TGlx//lvRQY1gJifWzurJp2C5eNJrBNc=;
 b=XFw/9dODUGL5J9jSrdgFfddeMRGbipRbFW6Kj+8iW/InNCewQ0Xeh9Qsf0Zm4D/ZkBvtYOiNyTJYveewBcFzvbO172dbWROREV3m9VFcvUNu49R0qDqKPWy4eLr5bH0/8d6DQJsxfSxRg+4htc5UamePZfrczeJIHq+puIFD/TqcQpFRfjib1DYkNePWooaP5H95rPimCJlVPlIE92v2a8Rs0SL3Z0qutPR7LvKIjmUYMzBp8x/pQT7QIocYrtodfoiSy8UR9ukCFbA7cmOaLnvEbxxPHyDIGZW/ojX9O8VW+5UFUjBmjJ3zDmOu1svU3X2vRCh88BdEU5T9q3BhtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7TPy17cS1+TGlx//lvRQY1gJifWzurJp2C5eNJrBNc=;
 b=C/eEGiQWHKoG2MF6McIAwk42Zbl5FMNOgZIzmxttuFIhCAZmjmGMB3yBuEZYbnbpm4qIHxMHHCXsqvA0X5akrcQ8awsnFPH7Q30gkh7IU7dJz59mS2vrh92sI5lBzDu0TNtCuBeKSSC0oQXaWVL58Ex1AOlJs7lhcrGgIXMKbvE=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2409.namprd18.prod.outlook.com (2603:10b6:5:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Mon, 10 Aug
 2020 09:55:09 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd%3]) with mapi id 15.20.3261.023; Mon, 10 Aug 2020
 09:55:09 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
Thread-Topic: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
Thread-Index: AQHWbI/+O96ANa5b4ESWnC8uuaWMj6kxHdYg
Date:   Mon, 10 Aug 2020 09:55:09 +0000
Message-ID: <DM6PR18MB303407CDC145F69390C28F5AD2440@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-11-njavali@marvell.com>
 <20200807075428.bzrhqwllvt5ajfhl@beryllium.lan>
In-Reply-To: <20200807075428.bzrhqwllvt5ajfhl@beryllium.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.226.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08f9eaf4-dbfb-4487-5dbc-08d83d13779e
x-ms-traffictypediagnostic: DM6PR18MB2409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB24090D93E2E2988D86A42245D2440@DM6PR18MB2409.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mp/DMeLllwJFW5u1DokeN+ZuvmRDyWuISgwTI+dwAlg/YCHGz99YqlFM0HCbP0lX7k7pyHbFQCKi1iKrcFyFDTKNu168jdUolguiaAErb8A3RBvBS+DZ7Rsbmkuvh7wIXSgHd/Irj1ZdmaU81b7AUkfzbd0kE8gHVyHG7v9Qr9U5TcCRNlStcRfsKAlZPrys5o+pWs0eVmxO4tEaQ232AKlWgnAwjinKHJLTe3GzmORYWUpA8UD4FWfg6FjbB9S86QAETBc5PaaRvHOgYtmyeWq+WJNvK2iXfGFnmJlFBPva8brPruVX0INjVipcbKbV+X6GQicQEbLEfyyveQ5CyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(39850400004)(376002)(366004)(55016002)(107886003)(186003)(8936002)(4326008)(110136005)(478600001)(9686003)(54906003)(55236004)(64756008)(66446008)(66556008)(53546011)(76116006)(6506007)(33656002)(66946007)(26005)(66476007)(8676002)(7696005)(2906002)(52536014)(5660300002)(6636002)(316002)(83380400001)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: piFlnamUFMfJcwyc/KHnxc3PHFztCSkzyfjh/KbJIEw63TB7/7/aBI0TwL4y0B6xK7TXBnlpwYlPbhyN03CGiS/3o54gEAwEHdkH+MmcGyXDMOb80g0ioeojH9VCdGWawbf8EB9J/VSx0UrJ8U/srI/kgcsKJY3MzNFrs8UNTfUFxbd5KWHcv22lU4h/4sSlGMzOdr8FmqUZPICYGKrh5BMUw3gijm+idg7QkJX5s9ptg6NxVDkfSiaylwShWzz7aDjxUYNi+U/vv5FVxX346Y4/ITr/wi7Phgbj/B6rYg9WeAZjSIiTa8jehXiYUi15Chf+lTqHlxbSNpdIHQzcRjOeTK3M246sPTmG+dQGXUPSrB48XOeFP7Xqyhr3XoqzQb7k6OVCHtUeMFwVLTqADVRXJmrC5gxITqepAw94X9ABEvAWfIzFagttSOUiY/TMTaQcrUz1YF1egZ83djiDY+fGXBTlXnqWXkrLD67fc7xjScp8CYqZBZR04jJSPyLni+ZG/3Ah5u6KFD+UtUOSOCt8XP5jLlEDjZS9UhmmAkV2upAcnbKxLOIMhoZ+gz9AiKuQx68KLVnuPsZTnnRraNrtURF7rgzPfTRrkQ9qW7VPoc8mnRG3bUcZCIPZ7Jyz3XVsDn3DGbc0cuQcNb+HGQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f9eaf4-dbfb-4487-5dbc-08d83d13779e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 09:55:09.2216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ic/IgLCKACVbU8E6VtbJpOtdyv40TYRfbqSjYW2+sYWd74u1Zb652tHDI+4ugF/rBDtciyKJcIl3LxkuuzszKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2409
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_03:2020-08-06,2020-08-10 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Daniel Wagner
> Sent: Friday, August 7, 2020 1:24 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
> Subject: Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
> qla2x00_mailbox_command"
>=20
> On Thu, Aug 06, 2020 at 04:10:13AM -0700, Nilesh Javali wrote:
> > FCoE adapter initialization failed for ISP8021.
> >
> > This reverts commit 3cb182b3fa8b7a61f05c671525494697cba39c6a.
>=20
> But wouldn't this revert not also bring back the crash from 3cb182b3fa8b
> ("scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"):

This patch was never there in OOT driver, and we never hit an original prob=
lem. I have tested this patch myself
and this have gone through test cycles as well. If an original issue is hit=
 again, we will do an analysis and provide
the fix. This revert fixes a load issues with ISP82XX.

Thanks,
~Saurav
>=20
>     This patch fixes a crash on qla2x00_mailbox_command caused when the
> driver
>     is on UNLOADING state and tries to call qla2x00_poll, which triggers =
a
>     NULL pointer dereference.

