Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29C2C54FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 13:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815822077D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 13:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RMBMapqX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JfykQ5tV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgCYNLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:11:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36885 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgCYNLt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 09:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585141909; x=1616677909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KJAiYWpmlT8eU2NQuB/U4g8nTQMBB+9MKdNbgIMOz0=;
  b=RMBMapqX/jsgyKmUpMvCHE/y9nMcg12EIzKvGLmFX0C+VTsvpjoWCieV
   kpfse3uvxKJB/ih/1J7dCSZpZ2fpket+kTcTEUuyflsg7mKiS90uXgpAf
   vylmnmZkZAbWzl+eBytrwxNKG+Va3ZO05s7Xk1wpimujic0yrqw9xd46m
   N+nHcvHhOAHAuXSQg7MJiNeoiL8pQRqtK78pabZ3Hkt9TbNldSRt0gw68
   8PzLiLLhmpV0gzUJN2Bpbnj0o/e9YWPjDVgrvhfsmEp4psJoYN5Ga1ue0
   ciag8Jq0w1cIAJlRY62GdNg6oDBfZzoxoa+CdLtpcLm415hzCPZcXzQRx
   Q==;
IronPort-SDR: r8dXcqxlGkP/Su7KK6SAAVTktmfQdJYpmj4Q2z0dNLAETqIZsFosqpFycq6Adrm7VfmgkYANlG
 gY6EaohMMXjz+DlbQug3JtuklUMdTsvuduo94+ctIkFKMSZcRH2yFyRYFJ8uY6k7xEJwSs9242
 HeWVkIahKV9GwlzS1NfvUvpjgnuOVIrBoXrQ1VQQ2s5qPRoHW1gSkBUIVy5liTyWvlyVY/p5kM
 2mtfHwFCuVNOgbFiY0NS3wWv0FvMqZzN4Y0NNbN/SLYvxOfOVu1SlcOv39mr4769Qc4C6SSqOF
 M7g=
X-IronPort-AV: E=Sophos;i="5.72,304,1580745600"; 
   d="scan'208";a="241957522"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2020 21:11:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5nKGhtn8cCDsG5+FNiBqlQmmbnYFjManrR/erm0paCsYukKvmudUuid0QUBaxk0UPxOyap10r6smIMfw1cRB/q2z1Nrt4+YQ6M5BQthPxPuWgFdykwqKPxAHxDbVKDuptqTMhX96U6jEnziV8AJimy6yR2kF0XKBXIJOeX/0E16p0qQ4tLVz/OziGTZ+m4k/sH9gXyy8frUv+UF75RqxuTbKDQDWY35oRQMWeycs69gqItrDQfsBeGZrI6huQHyI5hrrqO1EVyLZorJ70c/BEUsKF4GRxlY2a8EnfCAYvGcgTD3atVp/7mX8vNGDkJsGh1LATgR1YSJCHg925JB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KJAiYWpmlT8eU2NQuB/U4g8nTQMBB+9MKdNbgIMOz0=;
 b=Z/I+uW6aR0h2v+fy7F4+3vYDEHT61xAU3PMMRB8EB5pPFYqURt4wxl4CamgGdA1woWgoEET+jrIgmQxgbfq++YngrGquYdig+d+dNKyIcgcl26HVkEB6tZO+fxpAFUScluw5aUxiKdNCt3PRnTG+UoHj40G2oX75NiROv5XWW91ydjjGyBnIDoYomVUQ0Tmfu3ojg9TvVv+rMVnK46aw7C8pNLDkExRqAxkBEIMxfcLNpa9VyPj3OfMIm5osYiws8X/nFSKC4VESnUj0dTSBdFOChsQzTN4RyQg6Q7DcAwxKX2uFJPY+yxP7xBroIAyI4AMTOpOioYtJCDgGqQRzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KJAiYWpmlT8eU2NQuB/U4g8nTQMBB+9MKdNbgIMOz0=;
 b=JfykQ5tV91pW9jSAgU16bmVcHbFn1RiqIPAdotZcsaJVqowRLwBQHZhPHsowCWoXXL6CtVm9ifqJt6OZE8wuhoUDYFeg+jNhcU3XfoRV7IuWn/nEQHtkQdOZKS+K+Eaqc8s5C1TWzmEQvX9I6Pk77pO7/sr9xrkbwuyMh3Wmy8M=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4256.namprd04.prod.outlook.com (2603:10b6:805:31::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18; Wed, 25 Mar
 2020 13:11:46 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 13:11:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] scsi: ufs: Enable block layer runtime PM for
 well-known logical units
Thread-Topic: [PATCH v2 1/1] scsi: ufs: Enable block layer runtime PM for
 well-known logical units
Thread-Index: AQHWAlBr6MxaJV41pE6Y/SVj7ognQqhZL8+Q
Date:   Wed, 25 Mar 2020 13:11:46 +0000
Message-ID: <SN6PR04MB464074937DF99880D9EF7709FCCE0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1585104739-18593-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1585104739-18593-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77b43b54-25b8-400e-2d66-08d7d0be1258
x-ms-traffictypediagnostic: SN6PR04MB4256:
x-microsoft-antispam-prvs: <SN6PR04MB4256F016EA1A3810FFD2D1CFFCCE0@SN6PR04MB4256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(316002)(54906003)(110136005)(9686003)(7416002)(55016002)(26005)(186003)(2906002)(33656002)(8936002)(71200400001)(86362001)(66446008)(5660300002)(66946007)(66476007)(4744005)(7696005)(478600001)(66556008)(64756008)(6506007)(4326008)(52536014)(76116006)(8676002)(81156014)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4256;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bpEwH9WYnTAJZ/F9dhub6xJzXnFnwU0CjyCemfuVx6Du6T1AQdrgXdoURZQv/c0eUTP0E3Zgfu5Cq1E7PCDnSaBIZOj/1UqS3otIfbTUAfwwDPM3Ku10JFWAgXFp1mi+D+4Q8umX0zUPkWXbiqhm/uHKipzLQkeja9XQqSC4yZchBJuSFWQoOihrEuZY43Kajs3qrwzfa0T7ctLn4figazzAfw3gwT+7NuLTWrfd3CubimRC7vTml1yfTb1gZC7GDpLMA/IuE1Oa4RUVuz91XGngq7pkyb57varh2gXbg0nLDL2lVkj99QN3hiyqLwyMefBW2/c7VZ6Xw0EqwB4Wu93ZjIB9zVzQCzx1uufN7NAyeyfWUTESO9TcKJ5RQVVUH9WbIu/tiGIc6hWgJluyh2LCO3AhJtE3dIwor2qSGO1J/ae0OCNh+lLCDIEvWdE6
x-ms-exchange-antispam-messagedata: /U0N3NGd/RH/2gduDsaHE2B/CP7kasrUuGvT0YeMKohAJBg6pfXl1atzqBqotTDJlMcAag3vrwInD/28BienL23jOkNxdKL2lhz5+gNa0MRqcT4PU+DLKZR764Pw0Oatx20HdJfjMqVgncBAZBR6tw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b43b54-25b8-400e-2d66-08d7d0be1258
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 13:11:46.5448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ulkwRDHAORa7jEsX69rZSoyrw+sSh6nUe/yCFIH/oAmMsfB9Whs3DuIwNSqnN3oKAjnUHQ55CjrAGJAGrPiYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4256
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> For the genernal UFS SCSI devices, block layer RPM is enabled for them
> when they are probed by their driver. However block layer RPM is not
> enabled for UFS well-known SCSI devices.
>=20
> As UFS SCSI devices have their corresponding BSG char devices, accessing
> these BSG char devices may result in sending requests to the SCSI devices
> through their request queues. If BSG IOCTL sends a request to a well-know=
n
> SCSI device when hba is not runtime active, as block layer RPM is not
> eanbled for the well-known SCSI device, hba, which is at the top of its
> parent chain, shall not be resumed, then unexpected error would happen.
While at it, can you fix the ufs-bsg as well?
Add this call to ufs_bsg_probe() and revert commit 74e5e468b664
(scsi: ufs-bsg: Wake the device before sending raw upiu commands) ?

Thanks,
Avri

