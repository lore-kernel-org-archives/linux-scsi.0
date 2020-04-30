Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB249C83006
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6C92073E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 08:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="HlBhpZe2";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="t0Xe0xwx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgD3IOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:14:07 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:42452 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgD3IOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 04:14:06 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 248244016E;
        Thu, 30 Apr 2020 08:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1588234446; bh=0eAhNewpAk67J5pLDtu9HgQFuTExL02AftNVEpnnDTc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HlBhpZe2x4XJTr+RQExLlHBq9Zr9plyU3/qjXd0WLlw39mEFalLWIQgFIGtA83STl
         7G87gnyw84jARPDIhCEX8WYEP1q4SRvOPYl6r1P1WVu9MbBWRWiFF/ExHDyAecJDdn
         4VpWYoXJhPnTwdDIHqcZ8TMbisNuivz9frll9BA375aWXyOUJnZzhmrRovpKAqf5Vz
         CSZa5PYf4WSvHydmnS9i1WpSz00417H/IW+nT2X3w9VvAlvmlYhCb7AT+qfcBvO6DS
         qMSj8mfxXemn7IJmrcyJjLtpij8NtuxNCX9ntnv5L8qwz+jbMqDLTlESNYqWR/J7Bc
         7fBKhX5KfoGZw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7372FA006E;
        Thu, 30 Apr 2020 08:14:05 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 30 Apr 2020 01:14:05 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Apr 2020 01:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngSLNRwqn1eoAsYNK+eISvNLP3dznUZxWINfeCG9bof3XYV6zgKZCNgbqDMWn1DcnG38cpd30nX9TjdBX7VjcYWZzdyc+FM1+GjAOXgDnjU5xYERjJX2OvZlWk8l+PzXOQdX8IYrUxNudi3dTdmAIAISHb8Jkbq7yEGIKS9Ic+CLPUZqewGe0Y2UNdSbrEaw+66zWpnoEYhkY4J1vfMzYwpmv805A2X2GFuMWjmGuD4nbrft4CqPCn3BLEstbQOb7W6EzC3MjnvnlAFL0A6NrJCu/m1zS+alM75v2bjeqwhHd719OFnhRFpSezxVoR8jj8BI6ZjIIFCkvZHKxkL91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0sLmNKMmyDah7X49o5tY/iOBdpb+O7+6/+4VCkOeXM=;
 b=itcm8/6mLXkM+wdzsQMbBnXBJZgd6x5l8S4/IrAgxpZM4l9hn+TEOojlU1QKmnm+xJhXlquQWDCBEGGXc8C8/dwQ/GIO1E4OyzxLFUBAWnmKzP1My4OEerSW9TArsCl3r4sMQutrYvnkqisUoepSyDkKHBfUF0KgqtZPyVxEoN/RL0r+N26Wu7I777GtevGse3p/3g0Hnu8ghmCUTUcK/TWjB/P6dNCVC1laCyKtcHSXIhE6lCMZfWN1VJV55G0yKgAJecpTR/aV2PJhBmxaX6hWjH8rsD9MSl/acZoI2HzPfwtasEUZNMiMAJsS21IVQLoDG9a+LGylHjaN8pzsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0sLmNKMmyDah7X49o5tY/iOBdpb+O7+6/+4VCkOeXM=;
 b=t0Xe0xwxcynr+/pz/p3e6O9UwDbxaQ0AZeKTq4Czzq1ffLyLmddZmd0cNIX+VDEIWy7smnWbCEQGsWxsHAjQvrlF+tE2Vd+w/b2ppDOk+/65rRWOSItHu/VXX2SLy1PGn0lQ3yedjEhzgcQotq6SDD5w3dGxqkRZQKIGtkOFAWI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3362.namprd12.prod.outlook.com (2603:10b6:408:44::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 08:14:03 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:14:03 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGj6lcVDTF+IaKE20nlDb1NNdr6iIbYWAgAdCRuCAAGeoAIABQo2w
Date:   Thu, 30 Apr 2020 08:14:03 +0000
Message-ID: <BN8PR12MB32664256580771FA9102EB14D3AA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
 <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
 <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
 <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN7PR08MB56847531D0EC603DD2C7B349DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
In-Reply-To: <BN7PR08MB56847531D0EC603DD2C7B349DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: micron.com; dkim=none (message not signed)
 header.d=none;micron.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2413acd2-b4af-4e14-2c47-08d7ecde71e4
x-ms-traffictypediagnostic: BN8PR12MB3362:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB33621A551210F417269A8236D3AA0@BN8PR12MB3362.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(66556008)(54906003)(110136005)(316002)(478600001)(2906002)(52536014)(4326008)(9686003)(86362001)(55016002)(71200400001)(64756008)(8676002)(66476007)(8936002)(66946007)(76116006)(5660300002)(7696005)(26005)(33656002)(66446008)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: le0ZHXXHteDvbYCJ4gPQrCNfeQq/Mx8vSW3exM4cEpW87CBHnvmpmH8XmUjYT333I4FuFPYTB2Jmd0ipgCVH1pXgzvbnvUCZNb5t9LgV4zlUsInckE4Emwqhkzia05D3QR3lVxEGpYWGnLqOgm73kM7DW1jvZMrxfNlFdfHxWwb2g5q9rI88BJbq1NlhUzCaFqSoCn2bbnwfVCSyriPweFHqoX8Ec100wBiJE+dF5R0bcTpvG1BNxm67til8CpSNipn0jZBkaf2owYE2AsOjzHU44tUxcOixNt7kz/lL5Vgh0glIi0AXvsmgqqhgwSgjJl3qV7eDZq/1CEeOf0a9f56u/0z5mAZ9PgAz0/kPBt04zA2Z+7wbCwJXDfRk8CiBE1bJkd2l6CnvmFCiiH+LebIfMimQJE7m4F8EMSVGRSRmZYeEkdPrn4uhdJpr3Z5u
x-ms-exchange-antispam-messagedata: 7CxPQWnrAyk2xiAmrpFjAc7zb5wrZwCjbJvBqarMdLgskFlw9Q/VjgWGExwJfKytfB6IvYwQRuuU3URDfP0LfpI6RB6nxg05UD0nrt6yJjKRf+5KByKtHSA+2lko4YZSffVE1OqDhZ17/pl5yRpakPmTgHRism9FNWq5U/pBkKzM7UKBAZWkpmQIBVH8Y4fNO10bLoMwBHxqb2i0vnOyfg6v/Fikik4jUd3UbMhjHwEsAg2Ar9Ow5B4R55TmYEtcF50uAoHMFQwRpE/jGKgIxwgPEE2QNSI8Cne5cEEOz6jMIwBhYlMzUJlFPYvAYlvtce8ZVrahPc+Xtf2Lk7ukLp846RwJmH/tuEcpUs+hqIsFG33PU2PVyV53seEl+tOLldU21pIhkKBjSClAOicf4Aq4aPYF/x2MOfMou9AYd0S1QHvGnzWaUrCnIXy7YS4v+eXDBNRCgWi+sA8XtQKQkJ8pPq6ImjihW57pwUhOOj5Wf2dEdclyjs8zHjOZ3uVjFhDIuj12JYGHRRGSBmMEim88FcbESoRW0OerI6uGzhHgH9gX1I9o3QhkvuTzaxbEZsFxLzkTyniA+FEBfn+AYOo6qw2beofj2p3wa60ELbj6r++/aOVkdr2DtkN3inJjOshNH7QLg5ZH1JNqvpeZAJDhO7OzWAeIpsCm6B5uxu1PKbIndUzsyzU9qy1AmK2rsF8ZCxzw5AeA7L/dF/L6Ui05paSj8+dSN/i6bk9xY8BJhABtetnXG6z5Uzzl+Vuq/Je4Qq0pzhFJhF3Sr5SaMjwkaolJcR1Sfj2NkzHbRM0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2413acd2-b4af-4e14-2c47-08d7ecde71e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 08:14:03.1329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwiTkYQMoPB8LFD/4H4SYd20e75kg/5DTZtnE9dBZtQ1IxxCEfGelkxwfcWhKRlXqdfI6irX8ysHj/7rsnaWAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3362
X-OriginatorOrg: synopsys.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo (beanhuo) <beanhuo@micron.com>
Date: Apr/29/2020, 13:59:08 (UTC+00:00)

> > > > @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void
> > > > __iomem *mmio_base, unsigned int irq)
> > > >  	if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
> > > >  	    (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
> > > >  	    (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
> > > > -	    (hba->ufs_version !=3D UFSHCI_VERSION_21))
> > > > +	    (hba->ufs_version !=3D UFSHCI_VERSION_21) &&
> > > > +	    (hba->ufs_version !=3D UFSHCI_VERSION_30))
> > >
> > > I don't think these checkups of UFSHCI version is necessary,  does th=
e UFSHCI
> > have other version number except these?
> > > Is there somebody still v1.0 and v1.1?
> >=20
> > Probably. I think we can leave them or change the dev_err to a dev_warn=
.
> > This way we have logs in case someone is using a non-supported version.
> >=20
> > What do you think ?
> >=20
> Hi, Jose
> Seems after your patch, all of current released UFS control versions will=
 be supported except the
> version suffix is non-zero. Right?

I think we cover all versions with this patch.

---
Thanks,
Jose Miguel Abreu
