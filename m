Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDBFC32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845FB2072A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WH9mmkjg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LMQQ6Ws9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgAIK2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 05:28:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12399 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgAIK2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 05:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578565760; x=1610101760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yWC7GxyCUwDWYUJWi0gxUrV26HUFyUOdiguncY/WyvA=;
  b=WH9mmkjgpnzAlrWoMkRPAylidd6nMkJXZV4F2ROdQMxQRmElf2IDUhGU
   l18+Ja+v9+7wFtreDz2xz6qZjCgxR83QQPxLWfDFkHETbFvqd+EI3fEQQ
   T0oQgbhb8g3C1/DzJDo6qAmL1L6FpyASQ3dBvkS8gbcjI4gqsyFy0PHx1
   X2XLf2ERARLoAYRiVFzXsTRncNaeGOtllw0RJEIt/+1rrEvbSMqY1qfbW
   1LQ+fMWSNJ678KLiKpfylVTpwRl1tKINa++iX4fPuFp4jVfypQOCrXoAk
   7f9JQxAM+jtRL5FgKCwgqz/3T69JnaIH4hcsmQD76LZG9Tl3Bns4kxHf0
   w==;
IronPort-SDR: a/7ksm4zy+TPkOL19pVjiwOmHCxYTndRpRBZxaCLRNKaD8auSpM7JncvvB5A8NnIjTjKupiDZG
 36toshukmhPHRdSSgWwx2XcG3h0hDWL8Ox6NJFmXjdGxSvBCP1Ebp2dWBIt3VjZGynuPTN3XFi
 ir6f20nE9VxrSOW/k/NrIDcmVG4Hcn3My1mO79HLF4QObcIAaPGV1KEAGTpOuVR1HLU8ksEy+U
 JMpFSkS7RJsXf+qlqppE3Ba+MmNW8vncHIbMjrt0s72NPGCwsLUiVb/p3AES+REnc7eXRAT9yF
 NQE=
X-IronPort-AV: E=Sophos;i="5.69,413,1571673600"; 
   d="scan'208";a="228742856"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2020 18:29:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyPZ8ffDOOOYgZVqVv+XzxQtBF0Nq/QFlbrqxbqYwlpeX4sZE5JjheuiEkkaVRVt3mzRe/RMgzEd2LHUPLGm2VcyuprR0HLLh4hZJT6NOPJ5M7K8OlN/8LQUA+q2fMEdJLwwQGR88xLIEZM3+Ue502fXRuJQk+AEytiVCrWrIMv3UVEU+ICXpMFKhVr7XG6q7PJA6tg2qdlnd4fMTnBxNPfuRnB93/GbWXE2idvz+Sew1Sr/GUZNz0QwZZv6rnwtc2zcNpbULnj4NsK7mcZizDYHq6CQ08O8m0Nd7CJ5h3Mh8HHIorunLvH2y82x+lndneVQQLNNRZisN2Swx0wBcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWC7GxyCUwDWYUJWi0gxUrV26HUFyUOdiguncY/WyvA=;
 b=e/zj7IbCVDYXvX8TSD88f92BSzb7JEoh3JMYAXEk5Xp4Pu1hHTzhxCvtqtMB0itkEaQ/dB8If/6dWmDC3c0pAnaWnGEEl0fGhiV1OK2q2PadL/63gOoH/tZarYxmvWV+yd2oZLtc2GJvV+E8JQ0g1mNznivlCDsy7ObJ6V1mJTe6vH8LWTEG6LbHHSiLqyIpk6riDf5UVQKKwQarLvMTY1GyMsS2oHET4RQLGiCejvOi4I4TEbVcyqAlHDENxuVD0VXy53nVp0+BeVzeW7dB7OMHfCyz+Ez2nP/h9HYRpNmmOQ6NhmYWuS6ZvAhu2vgx7bGEFHGgydqXaOV6PqKRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWC7GxyCUwDWYUJWi0gxUrV26HUFyUOdiguncY/WyvA=;
 b=LMQQ6Ws9LPl8alQeJREE8DExY9vFUD2lCjEBrCstQwBdj5DyKdV2hIsLOgKI24/GQPOXbp1oWphERnjhfbIuXeGy+18oshqOabIa9STQcMeB7LoUZT1r1mhYvPtqzMfAgbNgJJDFLUE2Jc1Y2Sv2iWoiu4FXYDea3eIew1IQDFM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6190.namprd04.prod.outlook.com (20.178.247.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 9 Jan 2020 10:28:37 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2623.010; Thu, 9 Jan 2020
 10:28:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Can Guo <cang@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 2/4] ufs: Introduce ufshcd_init_lrb()
Thread-Topic: [PATCH 2/4] ufs: Introduce ufshcd_init_lrb()
Thread-Index: AQHVxZBEUEN6n+VHMUeA45iTIBwf0qfiI7xw
Date:   Thu, 9 Jan 2020 10:28:36 +0000
Message-ID: <MN2PR04MB69912858F85E1EE5208DAE2FFC390@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-3-bvanassche@acm.org>
In-Reply-To: <20200107192531.73802-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80c00ba7-8903-4a95-a77b-08d794eeafea
x-ms-traffictypediagnostic: MN2PR04MB6190:
x-microsoft-antispam-prvs: <MN2PR04MB6190D5990BF3D87428B17ADAFC390@MN2PR04MB6190.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(189003)(199004)(7416002)(2906002)(52536014)(64756008)(33656002)(66446008)(66476007)(66556008)(76116006)(66946007)(6506007)(26005)(110136005)(54906003)(186003)(316002)(9686003)(71200400001)(8936002)(478600001)(5660300002)(7696005)(81166006)(8676002)(81156014)(4326008)(55016002)(558084003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6190;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cPWqwH+KopCGOO9We+2NCprq7vIxM8DpOzRMOqK3BtR5Zlvd22UiP/nmvlx+rIGtWbD7WzPlC1alx3OQ+1O9gStU8L86klQVyetl1AygSK+9EKvmg4on6qx1Il2ibr6R8FRVmiSuWe3wtuUarJZNppMqf3FWkvjtfiqTexT1qMqVGTaKLebMxAFS9TpgDFGWnB8yOX4fw5Lvh1bSnplFw+s0v0zlCCPBQ3xI00ipyRHck9CdlN4ZwwBD7ufF35KyWn1qP8qW0trONGC7WzG8aJ2xO4ZGszqsAQZ767vo6PLis094bjBUcUwofkLvryqBBcDtoujNgMS9TJtDDWbEbDZtXuZ9k8VvrPQ0HVLFClqpQJ81ikne7RO9lNol2l5WdhE4kqh+XVU32AFD33usZFygmpJ9MArIytKTwklzJ4+xhMgoAVjtTjYHtXMJd568
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c00ba7-8903-4a95-a77b-08d794eeafea
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 10:28:36.9538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3HuhR290rbBUdAsDzEMScEY9BQyS/brub9TkSch6RKnzk0Tv/TeUE7GCg3mK6WcMnxfBdA3TUJeyX1s8SZhVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6190
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> This patch does not change any functionality but makes the next patch in =
this
> series easier to read.
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
