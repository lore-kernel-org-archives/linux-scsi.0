Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C390C432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE5420748
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gvajz0xy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dVKXx4xd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLBHe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:34:57 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:32133 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfLBHe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:34:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575272178; x=1606808178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tE3/rwWQFOIr43dD+xWQR6fZ59oWhwBkC6Asc+f0eXE=;
  b=Gvajz0xywQgspgWNrH+TXwZ1632gzrHW++Myowq6vG9ifHhAbuQhVm3Y
   d32MOMVeGiT/AgdYxV1CGGGDiMnDFgTWbvECwkjj1xZSN1RcF0JC2Qn1U
   kWY8ghsg9x+slw7HYqgepJnjFvccpQ7XGZRCvF73R45JUaKzdBbW+f5hx
   4NZfW2UO95/om0VMaAxBZ68L9DrzeWG4kDfMAUeHPB4aslsoam8hMRezB
   acyl7//jx7o+yysQeFHuySocHlRyGI6OpkYpFsJJXZ8lHyvygrNu9Dpkp
   H3ZGPsnzZRWn963JeA7PISGo66SFHOmxeIsnx+lI7UV/zziDH3zJc1wH7
   Q==;
IronPort-SDR: rPDCH6DTwYW/+YZa1eMXblIvP4t2tRBziw0jLdqSXQvY5LerfM0glpWFrsBfZCIQWSeKHYOQLX
 tjXIfcC6mkKW/P/bWYDW0j5g/0T0fiyPf2kOQGjPpwNxTee6Z/fW0dZO3op7GxxWT7qPQ00RaU
 coMlvwlADq1VzoSzdx6WHO9DNm0S3dOXDsVMJ2cxWA/nB+YRm7RVWfDfEtJfBYl5PEt5qKVilx
 xY6veLcqq4mFn8YwkqGwx0z+RWAvd7MiEegoFDiiVQm7zAFzMdPJ7urewDb2d0CAn/MuxPNvn3
 SBg=
X-IronPort-AV: E=Sophos;i="5.69,268,1571673600"; 
   d="scan'208";a="225826782"
Received: from mail-dm3nam05lp2056.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.56])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2019 15:36:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTBqA2OLTQSMhNWGdkDessRgPSIsMsnZY7cFPWtHpUoT6RsHI+REjl5zgO7Wnt1nSrs4UWelQx0SwXvde0gLeK+IH8mMT3CvXqxv/d0S6AfBJP4qam+7y2UGRz+Fnrby3bt5nvz1ZBaeeI2CotzEbHXbv41xQNvt9/Qb+BcjhhgjwbVcj+PhVvPNU81oPhGDeI4kiWcPymgY0FKEhx+FVJhmINSadD54Eqkp8PK6oraxIKaHaEdz42D/l3WfqhXbYC3ZYJdfBmQ4CMeafdt3VAUsJHKw7a0pGZk6iK2brjLNCfak4VzltbJMpstoQhCdmeRKayhVHnJSTP83BOChsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tE3/rwWQFOIr43dD+xWQR6fZ59oWhwBkC6Asc+f0eXE=;
 b=RBpfD2wV8K8TV9UdJGvvXd/gWLK8upY21WoqXZcj/iJO2B5eTxD7JoR2lC6RT0nnF5XFRVILKnntoxnORVMH+ZBlNtjzlHWIsdNxS6h+2iUVf7XKsD5oTw4WRDAJkIga1cJWBLrZaAbk1QJTpxz5lAnTgVVS0N/LsYXbEPy0IboI1wV6ZLTWp6Ze++kFIApRTpLwYW4pfr2LXPQU/qS7cpUuepKKH/OQ1lELI4yppgtaI7ah1+ITM/psCUY+XMFXZmdYZUfBUrD/DSZyfEtgkV1roB++FjZm1nBv1JHCF55h0/aBIYA0DqEEcRo71REDEruxGVJy1NrsK/sXfnhfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tE3/rwWQFOIr43dD+xWQR6fZ59oWhwBkC6Asc+f0eXE=;
 b=dVKXx4xdByUEN+tlMtA21cjSQfJxngSfUqQ/9NYqOikqliSHlcwh9tGapmG93pSdW0RrlzCkJm/gpDFyoA9nJfF69xiirYP4sypecn8zwDBg/agtiqAEvz2Lx0qLhLt+rUp8CWq7Q4+aXNjzwIDVpWJHPr68+RNhOsynNWN2ck4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5744.namprd04.prod.outlook.com (20.179.20.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Mon, 2 Dec 2019 07:34:54 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 07:34:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Evan Green <evgreen@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
Thread-Topic: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
Thread-Index: AQHVqL/hFybx9sJSP0mlYCF52U9X+qemdEQQ
Date:   Mon, 2 Dec 2019 07:34:54 +0000
Message-ID: <MN2PR04MB6991BF133DDADD31B4FB6C95FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ec4a25faa-77e03f78-006b-4b7c-bf8a-d56378f4b1be-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ec4a25faa-77e03f78-006b-4b7c-bf8a-d56378f4b1be-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ed4b3f45-983d-44b0-6ee9-08d776fa1fd5
x-ms-traffictypediagnostic: MN2PR04MB5744:
x-microsoft-antispam-prvs: <MN2PR04MB5744ED5DDF0819EB66B49FAAFC430@MN2PR04MB5744.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(199004)(189003)(81166006)(316002)(305945005)(81156014)(74316002)(7736002)(25786009)(110136005)(54906003)(2906002)(8936002)(3846002)(26005)(99286004)(8676002)(6116002)(66066001)(2501003)(256004)(11346002)(446003)(4326008)(14454004)(71200400001)(71190400001)(33656002)(6436002)(6246003)(186003)(478600001)(229853002)(86362001)(558084003)(66446008)(66556008)(66476007)(66946007)(7696005)(76176011)(76116006)(6506007)(64756008)(102836004)(2201001)(5660300002)(55016002)(52536014)(7416002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5744;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IlU0pMZ6CqQVDE0AUpiMXsd0oGe5iGwWis1KtJpDa5hCdkn/sDfmVmzBXOH5gQyHNIF8goeMd5PDm9TJgR1A+aXdh1L/LnORlDY/23nghJJfwzNPq8WE8bnD4VfFzaJ7k/BE/C3tEAqor4paKhDbaXYe+mrCcJz+hqIEQfHbEm9wJ56im9C57kjwnJMapCxWG4y32Wu/CtkfIFTOoH3985acu58L8K+okZXmwHcyIkfnnRO8mtusZfoJK8+sKlPRrCeGI/KP6EKNNF3xsx73GKNU5/efW5eH7HbIYUsmCbgLYAveHmmMoOH8vDS2K8ddwJFWvoYKJbEB8fHce7z98fEJ+mhpqj10BU87Xy5iS9gtDkH6Qfq9u/bfEgFl6ntObROQdiLR9I9DXXKuGnlR/RIF6A6cAC0PevE19Kq6WFYlj2FfDJaOrYdkKJ8mW3it
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4b3f45-983d-44b0-6ee9-08d776fa1fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 07:34:54.3082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eUMLIqRh7a+aXK29EKgk1Qlv+jV7/s/AZ2bK0tPc0C3DGv6e5dFDeRb9YRrCQqPMHWcKZZDFlPtDFzsjnsalLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5744
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an =
unique
> ID by appending the scsi host number to its device name.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

