Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A27C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 07:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B644C60EBB
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 07:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJXHwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 03:52:04 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60898 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJXHwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 03:52:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635061782; x=1666597782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f/siv+A1w3J6MM2iAyJL0lZmjqSVPJqu+Kq/laNfKSY=;
  b=d7YNhk74Oe+4M3x9y4fLmMvS60D/eukWDcaeaMRLd8ZPZBHDbdzrTY0W
   /TChgKDcbhOceVN1fghDJB+ktrx8qyEOdkmlvf+Rd51YvmHBDa6wRx9X4
   AErmnVuXjNwDF/1dD8v8wwHKpzNOO3gLiIjCBH7FtAfgrJjSWsbmP26h/
   vEqlNZNEaBbiPAg6NMuGMBu39ZMsjkuogwrBbDzNl4aM6GavnYv24ofbv
   UwfRfR9ZQkho/DS2Oj5sDgmlrJdw67cld3JnigDHX9uYn8E/Tyyq1q0nn
   ebnGz3URCH3eWCWFKa8rrFvpFI9Gcc0QTxgkrjR/A1aV+hxednVq/BDet
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,177,1631548800"; 
   d="scan'208";a="183698536"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2021 15:49:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWiZaNw/9gVhXE2qfoPG3H3Syq/toIoyl7AxVIVjX4FkPxXVPLaFv9DNcwJWm0rKbRNnigeXf1C5LAUYNpBNw74rO0eNiDRjZES6JzrY7b9DOS7Z+GThizSpFAXP4+DxXT4cAiq+T8A7F6yMe7cYajOYV8omP0wQeixM+cZz1mDZqS5XY5rJ27UgvUT0jiUXUkZXvKesXV84wBhPPWVV2g/OLtgtZJd4CZX5jqsWePNXCExBMWRvq/7JDYQ4Pyqbfq9BIa+1QuHJxcGvGWTEh52owT3PmbcYWhlzVAH2MJzTfxww1qf+Zp6Y1uxrfqSROsPC9X3GuGcDA2ERZYK4KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KQwnNAGJQQ2loAqqP6EgHQdep7FL28pLZVWh81k0vQ=;
 b=U/DhqsmndEyWWxTK5Gmfx/Ul0IefNM8JP1MtcF/B3gg/sAt+6cnpNuOnOcWdRJS9qkA22AlpB5pIIYCJOXC7C00DaS1o0Ke7X/qo03KBurPD2EWZAgZBxAj5qRmtymbg+53E78diC7WB0S60I/oGhQc6tVXIqITtnHeM8tD/prs3KvuBwkvu9TWvZvk7EfO2WyL+FJ4PLXhErc+KEswN/o7u1n/W+Hjw6RX+MNPRXi/5HvfKGtyGyE75Yhp27Y8dXbfJgk2BvAm16d5N9xZBlM+b5YsbEVwDOT+jeNU6rbuLXKfVWK9k18BqjVD9+NftD6vcwd8MnPGmHsEqLI1bqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KQwnNAGJQQ2loAqqP6EgHQdep7FL28pLZVWh81k0vQ=;
 b=sleW+eZoQseh+kLHjwEZ4TcBL3hkCgRf+yAj4zs8ISGuGMCX6g0m+tjzOaf+lUMKaKz0Uu6dc2U52q/tb8AZoa2vHGof256qGrGofuoKJXitmlo0Ob6C9Oap8HuIyBJRGD//WjRThNxZaIlaNk/B7sO6wlViGW/GcKv9bHuPhKY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4153.namprd04.prod.outlook.com (2603:10b6:5:a0::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.20; Sun, 24 Oct 2021 07:49:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 07:49:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: RE: [PATCH v2 00/10] UFS patches for kernel v5.16
Thread-Topic: [PATCH v2 00/10] UFS patches for kernel v5.16
Thread-Index: AQHXxfsgh00fBV5p4U2gh19sO3R4VKvhyZaQ
Date:   Sun, 24 Oct 2021 07:49:41 +0000
Message-ID: <DM6PR04MB6575DB7493729B101E013C19FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211020214024.2007615-1-bvanassche@acm.org>
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c2a863d-90f7-43af-e47d-08d996c2d6a8
x-ms-traffictypediagnostic: DM6PR04MB4153:
x-microsoft-antispam-prvs: <DM6PR04MB4153D1B72750BBCD0C1F916AFC829@DM6PR04MB4153.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PjNF8SQsHmPXtotfH9+B+Ar8KS7Z+veBb56k7p0VXb7dtHOSQC3zYRNQZqezS5gqUc9vXiFOxh7IZG7ayWMunzvW0N4EUjG9cewRxhTL7gZAJ8dcFc17/KxcUYYeO1M7j6rPIqX9BYxn89Cpnq7jF+xpkxZmYPqNQltOk2leZrB75QHtbyGyoY1lFboXtnmDcBbBWZFZDt+BkH7om2KXEnw7PCbY9LbPPeGMa83dOmIfJq7uFMlFjOScW6zDpukHR2VCYX3OK3zdmbP0AZLttS6dBuhHmbDyCEROMzcO2XIkDn4Ws4ntJwtF5WJCVKbGcEfh1I19U3Jij+jsIhfomLGEM1G1g7AsixicU5nHgImsvaC7jxMEWlCG4Q9xPw3l/TeYQhvb0qj7XNZKv1ege8s/PRAh+dOaKpAZdiqzOsozt4a0dR0b3IQ4Zhxyux7TONQ+eL2BydkyhuobKXbqm21SJHzTNEewyZyPRK1hX2binHy3P8oXIAXJVCsGItKqV6/LuQMZ1ol+Iatp7BARgP3Zs4sS0YRHQyK/8G97FF/EbQbm6MmZ0AXG4JrWq3+ycT/v7S2Abet1eT3Jt30ry4PPZV+1yeFL0qcWRZe0k8HnYlAQRzcmCkfWVTBKrIZTjaokVhwSt/RStD9IitCLWO9ysTh+TWI1QBndeJL6qqVBkxmxYNdYeDbE6luA0RnCQK+VQGJ0qYqM+2EFdFB9xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(82960400001)(6506007)(316002)(508600001)(83380400001)(7696005)(86362001)(5660300002)(66446008)(54906003)(66946007)(66556008)(66476007)(8936002)(76116006)(186003)(110136005)(64756008)(55016002)(71200400001)(8676002)(38070700005)(4326008)(2906002)(9686003)(26005)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qCBvYS0NqoBMQvNRFPxvRz9z3SuBv2eKQTgVUaAU3UAULYaUQn3Z2e+1wTF4?=
 =?us-ascii?Q?84na3csSIadJQqRSZLXCU4AB5yDt1LNy5UoftH9AJCpZ7wTc9uRwCtdoVurY?=
 =?us-ascii?Q?gxVn9s/kYo2i2uylDA6QD5q3Rnrq4/n4AMFif+pIrWxHAztPvHmU/8VC/kXJ?=
 =?us-ascii?Q?DHJn1E1doNrwnIlj4dBmLUqZqzJYlFPa/OUI+ew/QhXgB8/w+iA7agecCq3N?=
 =?us-ascii?Q?snBk3XTkfHstOfMXo64Rk/6bWOUiyipw2EN49Nbxhy0f0ESdr3fQ5MKuq2Td?=
 =?us-ascii?Q?VZD59BqYqcd6pby2PxhUTggIcmgDmRYHUvTfAcd4yAmzoc1eVcSEERA118UJ?=
 =?us-ascii?Q?PWraFxBUu/uopvqHfjbIZdYTdtYAzcKrB//oIUOozXM5ezAol5Fq20W0dsiZ?=
 =?us-ascii?Q?1T/pLGdIHiLzI5Kzg9RWn9MVB+GLeqpNcjBviiWYdZnWGceFfMu6wnLD43xN?=
 =?us-ascii?Q?3uF0hbXSzKyAQGcSJVExi3X4hzkwq4FQmgUiC2xIRWZvsgrzMBX5lwesr0WJ?=
 =?us-ascii?Q?UF6EwQaX/ge+8smOg2eia+5e+PvHdclyOIQE9/BAoTfWHi0yTZY8mqs9+sAv?=
 =?us-ascii?Q?SN52rHSFYJ3Y/tT2pRK/blHma9+xMuBXQOz2A/nEzeR4KiuP4k8VktxRzyb2?=
 =?us-ascii?Q?6HnI6ArZYdqSJdNBK1oDrqhCT8d2K+rSYC5pvQWJ2hu2JBczqOJ1qT12/FZO?=
 =?us-ascii?Q?kKlt7gvMKDnWFdklPnB66cH3faSW+XcCRevUslqspf1Wok3mu8vzzXoKMpUz?=
 =?us-ascii?Q?Os9F2OgnS3OnKv01MHoLDQ0oogiftTck4mEtuo9XKLTi00PBu9DrwgFYdP0h?=
 =?us-ascii?Q?2AGJ7KKBCOkgyOgvePeOOLBjYNf8JKYbZXmEVCf/uuT0QEF6Sue5egyVL5Jd?=
 =?us-ascii?Q?B40qS6tgF/66wBdDCFcK2DN6a13fZSnZW+hDLOKX3AwRd81ettpPP0SxSbym?=
 =?us-ascii?Q?lWSD8L2pgR99pN3sKA/nfl5feUmdlm1K9TpdSN3tf6Hz1ZMnbG1ymR3h5VY+?=
 =?us-ascii?Q?cdmcOOktZOmuh08SsArerijdzgkthYsL5dQ/reBU/cDk715e99GTO4rBqOeP?=
 =?us-ascii?Q?RpIMPM+Jhvkf/pruDyEatQjoSsjCafIY21moQMJbeFt4HuO1DtUweSRswm6g?=
 =?us-ascii?Q?xzatAt7LpYjTST9n/M4CJmDYJ+E86U6Z5iTabSjD7xCBa0k3JIzMpqgTRlMB?=
 =?us-ascii?Q?+yD6YEr135dmqt+WAdpIYV+n9dXIC2G7hrjUCrLVQU2EboJ2Q9wYsn3drBSf?=
 =?us-ascii?Q?8HSRQVAR889bMs3GyGRXu05jqOXwi96S08cPCBc80EUeNwI4wrskM3J91rjj?=
 =?us-ascii?Q?H6d7fIocfbHaTnjo1TpRe5rg0fgo0Df+xXGC3PKUHbraqoCJPSbwgmfij07q?=
 =?us-ascii?Q?u0easgkbyqL4mx+8S77dOi0Aay4q6K7b0Klc0xiiF5KZFvXidEuLLw1dMJda?=
 =?us-ascii?Q?mAbNF8beMqhRSTXi4C7WIiQRvlPPsil7UR4SzvS9QZXd3ME7g5eoGDuFHl1i?=
 =?us-ascii?Q?J1IrJwUO0NW38OCWaCHu1GJK2r9dhASD5ykFIUYYkwM3d9kzBXtxlmKIrFsx?=
 =?us-ascii?Q?GzykD/JqgPEctoun+Q9/53WNOI72X4qgbYfc4bBCzmfiJ9RPyy0uQYPwxwzN?=
 =?us-ascii?Q?Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2a863d-90f7-43af-e47d-08d996c2d6a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2021 07:49:41.7127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VgLo0lvm79AefVGqIJ5HI0c1pkhYQVlcTk8lCUjSydUvpMvwgaD0nqoeBhhNNylxG3OITMabUqThFsDtLN2RYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Looks good to me.

Thanks,
Avri

> Hi Martin,
>=20
> This patch series includes the UFS driver kernel patches I would like to =
see
> included kernel v5.16. Please consider these patches for kernel v5.16.
>=20
> Thank you,
>=20
> Bart.
>=20
> Changes compared to v1:
> - Converted the sysfs attribute for triggering the error handler into two
>   debugfs attributes.
> - Use ufshcd_schedule_eh_work(hba) instead of scsi_schedule_eh(hba->host)
> to
>   trigger the error handler.
> - Added three patches that implement a small performance optimization.
>=20
> Bart Van Assche (10):
>   scsi: ufs: Revert "Retry aborted SCSI commands instead of completing
>     these successfully"
>   scsi: ufs: Improve source code comments
>   scsi: ufs: Improve static type checking
>   scsi: ufs: Log error handler activity
>   scsi: ufs: Export ufshcd_schedule_eh_work()
>   scsi: ufs: Make it easier to add new debugfs attributes
>   scsi: ufs: Add debugfs attributes for triggering the UFS EH
>   scsi: ufs: Remove three superfluous casts
>   scsi: ufs: Add a compile-time structure size check
>   scsi: ufs: Micro-optimize ufshcd_map_sg()
>=20
>  drivers/scsi/ufs/ufs-debugfs.c |  98 ++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshcd.c      | 102 +++++++++++++++++++++------------
>  drivers/scsi/ufs/ufshcd.h      |   1 +
>  drivers/scsi/ufs/ufshci.h      |  15 ++---
>  4 files changed, 168 insertions(+), 48 deletions(-)

