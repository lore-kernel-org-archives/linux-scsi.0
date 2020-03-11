Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B80DC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 12:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC4D20873
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 12:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TEeD4wXJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Rv0bUXOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgCKMZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 08:25:54 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9798 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgCKMZy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 08:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583929554; x=1615465554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PvOAgDQP1g+0tdCJL6kYe7SKTG2U7Cb2XyyTRJ69UHM=;
  b=TEeD4wXJmpY/wOKUrPbHoRlXra0Rc1FvQIHQIfuA87+L2XycAQbUEQOh
   GggHiZWEEqLbTE0s+5bIDUDJgBAsxqmqKzM8DsXo7Gnx9Ywl7SWvimTvF
   Helkuq8p9ykF1bheJGyGjO2WYd3M31OCI8MZJAqFMPGtg/CmqwUM+O2d/
   aI0mZZIj4Z/CwpWrjrikmKYCUBDl64vn5BeOUB7sfcq+AUS5WPd8vbMzx
   vx9t5zmdemEjNKvSKJkWYF6Z35PKkDTeEsYD1Jcm+chy0KGyHZpdAR5LG
   KOxSLNJlo4RLv4NcEPnTckFXf6L0RBNww3WqErY2b5uK0mI1xBqcNVqJ5
   A==;
IronPort-SDR: cwwUMRCac8dtf6fuC3cm0v3Lryj1/jwn6QLqGc9nC9/PJheKJRvAEYpZMWzRKzTIyk0b2BAjGs
 YPkozWq8U+GkxLjlLyeurYL+UFr9fDd6umXgBMKMl65oTXfmBwyn6/gwlOwU4TV5qYPJkx5ZpK
 OU6sTx/+js5yPqPGJMnmFUDeTJydJGjkNTIVM5vAYVeSzV0b0tXRZRRJobiHxMoY8hvNxyXjgf
 flUma56jDfbVD8aTseMGSL4iubuJHNwvJaU/lqKt6irBkwIa3iOMvhOHqHsNjwLlCh3TZ2i4AL
 2H4=
X-IronPort-AV: E=Sophos;i="5.70,540,1574092800"; 
   d="scan'208";a="133621357"
Received: from mail-bl2nam02lp2057.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.57])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 20:25:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnBPIQ8ybLOZlndB0Ppb5iGbmzoXmvYj4Xgwk/oGfcRVzT3s/HO6Gq+ehPu9X/7AtS6hgtK9L2mpvaheOhuvewaOdvHcAVUEKtX7c7M4SYszCCMBNZGzIv7Nk8lbKd38eLZYjJL335EKOtLR1ekYFyUuY+fZYOQzuKV14rMEKrhNIu5guDX6XCc4L0ZNX+z3hRN0kJpQmwVQWZmQO7CB+82bYGnTBYbooyLXb5olUYtKHZckP4fHS6wO641lSg/kBXOafkM7tulkSN6UPlOK/IoLI0eOWvJRodUCZMrytDWp5LTjV7Cy+lW6w+nv1e6/5Ve8QpIrnnE740pQGJL6PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSuLQrWsX6YUUyg/xm4ZVKI1Mln0NcTV65NLNCcRU2Q=;
 b=LX3971t911dk13MSQR4vPXCng2dpdubFp6eXlXCE83LK1Bri4KhvdMeqWpaVj+/0SqOJRmWyzMBoWILoKtgXF6QM5Fok6SFXl2bfA2KW98y68HZ/q+3axthlum/hKyJK2nFNp7mwvsofdosAi/6MLRIfGuoGiSzMPoIodY5PKW2NLa62ubMvTECXC1uKE+6dGy87nRpeLcjC7lX1fVRsmurti7vRPbKdk8QuuOLio8aI27n1XUroVQ77zQOawwU3eg2NzkybdWqMs5zFpBDvvsRVm2RTuAGfIMjxLzIfcJ08PQ4E7UX+HdslAAcy06mTGFL6so0CnSWcbnz5nJlDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSuLQrWsX6YUUyg/xm4ZVKI1Mln0NcTV65NLNCcRU2Q=;
 b=Rv0bUXOWOHcnlr1+9PL6UWsXAh2UB9kw+OQCi19V9SbBIzqBDt/9INjV7v+PdPS5RBabwJwsIXAtAO6qYcGUUkRPvNKCgpkKnToChXI6fdPx6WIQU/5X6xVF5gV6KKg4va9wmuXDVNtwOaKMvZUCCCerQtNsm5LkjLx9wxziwIs=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4272.namprd04.prod.outlook.com (2603:10b6:805:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 11 Mar
 2020 12:25:40 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 12:25:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core allocate
 per-command UFS data"
Thread-Topic: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core allocate
 per-command UFS data"
Thread-Index: AQHV95hc6FW9YIowBEi+wfL8gXkfUahDQwpA
Date:   Wed, 11 Mar 2020 12:25:40 +0000
Message-ID: <SN6PR04MB46404175998962B4FA575824FCFC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200311112921.29031-1-beanhuo@micron.com>
In-Reply-To: <20200311112921.29031-1-beanhuo@micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d69b908-0b9e-44e7-dfe2-08d7c5b74fac
x-ms-traffictypediagnostic: SN6PR04MB4272:
x-microsoft-antispam-prvs: <SN6PR04MB4272FC0A19FABB08CFF2104FFCFC0@SN6PR04MB4272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(199004)(66556008)(2906002)(4326008)(86362001)(64756008)(8676002)(66946007)(66476007)(478600001)(7696005)(66446008)(9686003)(6506007)(71200400001)(110136005)(55016002)(4744005)(186003)(76116006)(33656002)(8936002)(81156014)(81166006)(7416002)(316002)(54906003)(26005)(52536014)(5660300002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4272;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: evzRYWsIkA5fmHvUuKN5AOY86sj/2UnG3Zf/YMr9AqveuwxVPf+OfcoeQLn0dQTVjzdOlN93KYmNqMI2/IiK7+VxuM7wEIJE6uX59FnoZrB3WA5HhooY9Yo1kWt8zP6RJBT2MK8uxD+YcGrykVzE5YfrpPlbNAUiD1pX8E+w+k+F2pExgUck17718Pbf6NPxj9XEMrk7npB60urrv7VWXj4Zoen2HenbmfTnZBp4gwTb252HgRXrVm6G5Y2lT9gGrXF78VceoCcs+uy6ThTeYq7+9wHGx9bRc6KvGjdGUnP2Bdi0WdSV7cEuGuY+nZDBj/q9NQuyvdkAq2gvksfhN61hDaz6Rh5LW8jWoIC1TcjCIxk6KmH3/JHv2rr5BKD616+2F+NBg+P5qOCw68+VBA6fMXX9dOktLH3khTXTGhynbnRDPnVIlj2QdAeIklUC5M5wm8HfUnkOqUOfKiQ3HoIS/M+c0k0zAG+u0gADt3N/s72o25j9fZb7x+8gBllA
x-ms-exchange-antispam-messagedata: r+lmiGz0OuzHiwvjPG9VKCK0aZ/qLrjcjOvNZilq6ufEHX/EaAOEUdmXa2ZA1cnCzEOWztne0JgrvZQsKPDKUTCCD/ep4nXiN7jg3o6VJtQPwBjrKP8XtjwUG5wOBTWxEyXharQG0oVMo3L7gn7Unw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d69b908-0b9e-44e7-dfe2-08d7c5b74fac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 12:25:40.1501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptWdCAcWBNcRdv5jJUPTluQrm2L1dOkM3YBsUwAIY7X37I775PF4dxL5/QJxHY1F6X8xEvlvhJpY4Fs05iefsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4272
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Hi, Martin
>=20
> Based on Bart's feedack, the less risky way is to revert commit:
>=20
> 34656dda81ac "scsi: ufs: Let the SCSI core allocate per-command UFS data"
>=20
> Bean Huo (1):
>   Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"
Maybe it's safer to revert the entire series?

Thanks,
Avri


>=20
>  drivers/scsi/ufs/ufshcd.c | 198 ++++++++++++++------------------------
>  drivers/scsi/ufs/ufshcd.h |   5 +
>  2 files changed, 75 insertions(+), 128 deletions(-)
>=20
> --
> 2.17.1

