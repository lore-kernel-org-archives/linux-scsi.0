Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045B1C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96524221E3
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cZSRtcFx";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="FzbFOfNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIQRVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:21:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbgIQRVD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 13:21:03 -0400
X-Greylist: delayed 1643 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:21:02 EDT
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HGpbF0003313;
        Thu, 17 Sep 2020 09:53:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=be1zsipaPUEkaxtCeUqW9OoGjK1N+Ibgy/B0beXzwRg=;
 b=cZSRtcFxfVw6KfE0vi/nX7Xz1dSMvkWA0e/bAYGKCjjbTcACEfeLE63qbQDbAKeFk1Bd
 0DlUQhdP81EJnqxQA/eejpz4NpELetyqJrC7XG6oKrD0LLgnPb+9lC/PcRJ340LV8mnX
 DKZx+ruibyWl1dxQCnuSBuYaM0RJIpgBPDaZL16Yt1BrzJNrsOYasSDt2wmYQsIlOPqQ
 KDIngLrHjgHiwlQLDUtkKyrW9gZe5LArWoBN3x/2fA749pr6x1EClpTi/Ijzc0C5d5fd
 Z7jN5aJQHtIXa//OTl1rrnBsMbZMqMEpUTeyPBWX5crNTniIz3RlLdlCIPGJMfw3rluh 3A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33m73p113a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 09:53:33 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 09:53:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Sep 2020 09:53:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRhkglwNcWvcI4MlKExyGqGXnoUWKcvQ7Jx0lJsUobkNRfvvrWZVjMiWLj63ki9fUO2jYWajSYSM1NlnVyPsBn/JMJ7q26QkTWVIVkMJkUdQRGnfOrcptJvaQPLMHLGKVtHfXRXBy/PjhOnRth/+FwjYbl/xpeEeFjZIgZ7iqqJbV090KhOJxFlC+JCOAsv3L4NkhHrHYCyxqS0pOf5SUhnXsijnMeys1pG+xysm/rFGqL5O596hDZ4DaE/8jNt1eM1yR0A6/nBlTKK0Bmc215El/F0Z5UsciQex36ry05bG/hBq8oR/fqt350mJHD8kOQta/VtlXpL5CfJL6XAImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be1zsipaPUEkaxtCeUqW9OoGjK1N+Ibgy/B0beXzwRg=;
 b=YUpF3gkUmCcTeEm8NnHURB/KbxEVEWLrMobHz0ILFKwsu5/BYyn56UkkXnkMYKEoR9qTIIChf73SaF91kKYd5SzlI20lMhoEHrCQljXXwO4fh8fBvR+nvu4FTxfkdjKfqfVsWWD2JrxShlkY5CQt4C8V4tRytqjZxDgt4TFimQirzWNi3hl2hvI64ObnAoXDNdOTQvXZ+mCy26OqOHEW1g4TZJOqvi/dit++YrO62Ylic8FBSEi+OOLOQLUUNPx03lhJGWO4O5cige270T4p1XPjRaCJ3QK0/UDgwrwh9E5mG7kzkPm8sP4raS2RunpybU671vn1sc9FrgG2gBHKDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be1zsipaPUEkaxtCeUqW9OoGjK1N+Ibgy/B0beXzwRg=;
 b=FzbFOfNddkU/4HI0q5nwEbfkOJI2V/WwHgk1A4NxY2vqqEPFx0w1awwsgmZysES6fZOntHBMTEoR39r2/uzNQtT1kFCOu8lVI0sKKM51VFZQaMX+h9fn8cUgYbyrAxEOotMyIdadgPt22anOCJzfkSltNu3ACJ/v/CZJ5wsN4ig=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB1658.namprd18.prod.outlook.com (2603:10b6:3:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Thu, 17 Sep
 2020 16:53:31 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::905a:ebb4:369c:ae1b%7]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 16:53:31 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 0/2] SAN Congestion Management (SCM) statistics
Thread-Topic: [EXT] Re: [PATCH 0/2] SAN Congestion Management (SCM) statistics
Thread-Index: AQHWZjhMrgcFZD1E10agzucUNAA04KldOfTggAKjcR2ACkyeQA==
Date:   Thu, 17 Sep 2020 16:53:30 +0000
Message-ID: <DM6PR18MB3052AD22FD8D495CEF4948B7AF3E0@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200730061116.20111-1-njavali@marvell.com>
        <DM6PR18MB3052C2991B834B3A93D96E69AF280@DM6PR18MB3052.namprd18.prod.outlook.com>
 <yq1imcn4q6y.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1imcn4q6y.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.37.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97e206fb-ebec-406e-597a-08d85b2a351a
x-ms-traffictypediagnostic: DM5PR18MB1658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB165893484B6DD5563661A98FAF3E0@DM5PR18MB1658.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e2Ufj/tFipOizkiCdKfrBoWP3wwyuME7nIcg6tlN4fTEpPtq+pzgExV20kqjH7CMLY30OXYPc3MGJThprcYCmogagoBL1oW4x5nnWKP5y/aZDWKO8gqfDKwwbt9wfN3fP/jMThUYHRN1FgHfurTHotEFAQJNY4Ove+DhU3UkkBEjZCs6vMLyvLtDqulGZthFvku0jt95vZJmnhQLU3tTs0IEr1099B0isUHzvESrjkZMClIzv0wAclxDOj3fLX2BAf7xZVmLMK9BHXaXGwpRl0uB0dAlnaCoFccAQtaGAgelAWVebJ+PhEz2nTD4v5WoLqXUnyqfwI3mdbwPd5EUWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(64756008)(110136005)(66556008)(66476007)(186003)(66446008)(76116006)(316002)(8936002)(66946007)(54906003)(26005)(83380400001)(4744005)(107886003)(4326008)(478600001)(53546011)(52536014)(6506007)(86362001)(71200400001)(2906002)(8676002)(7696005)(55016002)(5660300002)(33656002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hlBYQt9517H3KQF1Rqr+swmbmYiyzCziGtbWh2lZHlgSRa7CkDofS51YVAEKSFaGt+sn9ELWEYKZULpytmCdjyNomUkp6ZFQ+gXqVQ4VUGGE1lZDr9iEQbNFLabdyGCakWirlBcQnGdOpFpqra6NG6L/5ZHOsTTeUHcheBUjKu3Pk3YSE4CUSTvPpmlVbExhYt+44QhMj2PTFrHBf6E8KDUZnSx6McpngF7XmU5MLRcteR5eJvNVAnjuW+BVAZ2GwW1bbaUh707OE11gduVGXh1qPNuAYJ0ZF1JcA5u/Mn5b+3RbZZMloptIfprj/N70bLjHJc74gMECa5JtWwi4fb3IFcvYxpa0mRqxm8hTu+3PQuHVD0A+yV7OHgah1PB7KOQqc0Gd9WJcOZy6agEWuhBYIhKLEtrwWGHXumJRJq+0w6n68D1/8jjZPYp+fkWcRCV85T9MB4+B9Tn5DtMVPxC+2Z2lWXzmyAl7qmwMtAR/rj7V4iLIgkV3nG84L+yItNW2IIpUkuH2M1miv5FClukO6+fQqDkishekjP9JjeW0hSZbUvrKWv2RakjZhWxCqjJyyWCLW1sW0zdY7n5FCcxL8iZFuWKaYLS7aMdZTjEyyr0ok9PUzjk6wL+xcTvtA2NSJ6O7kwJT4H5bq/8qng==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e206fb-ebec-406e-597a-08d85b2a351a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 16:53:30.9249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 75RfQVRzFM7ZeWyYC4gvfZgM0YCsb4OWGEhQjqCiiWx8PDSut/g5cI6tUdS/zTAgZiLcuh6FI1e0ciTbBWswAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1658
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_12:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James,

A gentle reminder to review the SCM statistics changes.

Thanks,
Nilesh

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, September 9, 2020 8:27 AM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>; James
> Smart <james.smart@broadcom.com>
> Subject: [EXT] Re: [PATCH 0/2] SAN Congestion Management (SCM) statistics
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
> Nilesh,
>=20
> > A gentle reminder to review this patch set.
> >
> >> Shyam Sundar (2):
> >>   scsi: fc: Update statistics for host and rport on FPIN reception.
> >>   scsi: fc: Update documentation of sysfs nodes for FPIN stats
>=20
> I'm waiting for James to review these changes.
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
