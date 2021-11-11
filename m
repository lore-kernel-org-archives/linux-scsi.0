Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A4DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524C16108B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhKKIOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:14:50 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9673 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKIOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 03:14:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636618319; x=1668154319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i1qiQjSD24Ll5Iv/EFhYxgjDQxdhAOmFgBEy+OK+dkA=;
  b=Y8zf8ajh5kzTq+3OahxKuGlW1ffFTRC7IPj1P0TiVY2FYRArY4ZGLFM6
   GeEuzWvVwLtB4LAPdlJZZask43oPQxKUm3u+AQsdlZo/xHtKLTa1mhvs7
   iY+EWUz2mnzcYVrYrePyXX5uqypqV/3XO5AFG0O6dxEFz10QbM3KZMoey
   bnuZOOmhLcsWJp0337qWiZ+8TDJVdCifLvtkwcZDxs+iCa383wUPQbNWn
   Tbl4g9qXUK6kFGtbp1QigmstS8FBXkpkiYXT42EoO08sLpdSOaMmVs+vU
   8uFbJxTnhSAOmUiQq357IfH3AXAb3pWr3baXWaCqY2xpS+5IM4Wu7NyuS
   w==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="297135149"
Received: from mail-bn1nam07lp2045.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 16:11:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUz8E3FdCHFQXd/g0D08E6+N9myrV/dTApeQ4rw3Z2dBgRTWO5KeSPv+hALVQusuaYN3ux34lQjwGLSwog26Tf8ULQ23M25SGTFoQb+TEy0pz/7aoWyo/hTQsJbzeyimHScByZM8sQGwsPsoIVTF1oqiluUet6pQ1P87d2nM3xKx4LQoa4vUrCG1qhcGRbY+icL6uCb2E1V5dGddytSs2MfifZp/w/FIO8waIgSODZ0g/nZIUsBlk7Bx3+vXzLlELHvhlPKqsh8s9oospAdvBc987sBjyx51HAVv4+824bN971sjc5gqQm98G1pp3Hl3BuSiNQDQOM+S1EZ8tcRdJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moXz0aWayw7Dk0D9j0T/GaikgmaFUA17Y58NoSI0eVY=;
 b=AzyjNMfQvg8e6ZnskjklHUm5EdiM9/Mmj/V6GZ7NCyhWH0YAUFktCYL+1CEX7CxNtQ/bOhqEmyA1+ckkzEIVi+pmz1gVE41UhdTDSMp15tZRT+xsrQKXwSaLWDZBWBDiqS7Nk0zQ3p5YTQk0Uc5pwQ2d9TnKgv5aXnoFpsoU8a1Sh5BwKQfrpGfJVhEqkp/O/8U+kvEynz6LeD3qS8H4UMsNclAzCXdoigK7IzyaPXwy8sAVwZu0itt9r+F99G+ien1y5TWWm75eCMB758O43pN7o6x9CNKBV8G/GubsMg4HAcxnweoNKHM2Du8AQL5YzPgCqMpNbrhhrynqBBMjmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moXz0aWayw7Dk0D9j0T/GaikgmaFUA17Y58NoSI0eVY=;
 b=c6j7arxtwoasYfjcqGye1TZmh/iV90sXCAZ+J1dPUjOmWGQMqzk83RwOsZMrdCLOU7c0Hnefiunj0aZT6TOLCMD1Kox7mxoeZKDtdyz9vRmBpavd/W3SPv1Dz4SpgoJGPHRXtZ2TO3pbcBe8QgMdktZEFox+5F64GBQfoAiWlA0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0268.namprd04.prod.outlook.com (2603:10b6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.16; Thu, 11 Nov 2021 08:11:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 08:11:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 11/11] scsi: ufs: Implement polling support
Thread-Topic: [PATCH 11/11] scsi: ufs: Implement polling support
Thread-Index: AQHX1cxW2dZoIwZ59ECU/P5eSQHEsKv998zQ
Date:   Thu, 11 Nov 2021 08:11:56 +0000
Message-ID: <DM6PR04MB6575F4155E19B2D08A4EFB94FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-12-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 845c537f-3803-475c-0b3c-08d9a4eaedf5
x-ms-traffictypediagnostic: DM5PR04MB0268:
x-microsoft-antispam-prvs: <DM5PR04MB0268A9E6BA470547429C3A5BFC949@DM5PR04MB0268.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMecOc9DyBVSHa48Dl1NaABu8ETPQhHVA2WfyjPuJndhXl/FPI19HIYnHQ+/izjPfQsgTDCAEpPb3+eMBywX9xFMMl2uflsPKD6gYLhBP0SLPmhmDD2BFJ1BbMm3jtuKdVjics1l+N/3ILW4cgBmch9Fa3PIIIWCFSiJTN1rlj8W5Nyav+2z/eotVk7sooA5nScAGQ1i3447apmaTz2C4DoVmeTxcrZRrHGMtK5NYTk8UhKXCCgdkJwDKLVpwor2rqWuG8WHyt+vSnnmrDAzzDYV7q8Opr1B687W+T3SgTbmJN/k4LMBNxcnUQ9klRgYZGTzITyIh7WPdaKN2JMR1bINsw2NIHbUm5WqivRqKGWMOh5fm3JYH6eE8irK9VELheuCKu2A4rjLcHxshydD4WvQSri0BwdrijQMxFvxlLAKY+sd5xeyLcTBujusedttmETGde69OJXi1L28FvVbje6H3WyY8TdnQtxnZgMaJdTAN6cZWdLYIhCaxsERYPKKHvHxXKrSEV99IGiWdfxLgYfGZvSemYuIqUuOPoTiDNF/NnRl5qpONlSRbMhhDUTxjhOXULhjiq755iIXQcRMa6z4YtnfnLtw+kMhJ/OP3YnFSUun3L+VV85Qm4Qu7DO8gbRI+hOHRdJcppPYKefkinQYlkbj1vHtSndVVF+ne0Z80T7Tc+u0OTsfeJ0KiSMtg+efNbAp01w9DQTjU3k+GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(122000001)(26005)(186003)(2906002)(71200400001)(33656002)(86362001)(316002)(38070700005)(5660300002)(7696005)(52536014)(82960400001)(54906003)(66476007)(4326008)(508600001)(83380400001)(7416002)(66556008)(110136005)(64756008)(6506007)(9686003)(66446008)(66946007)(55016002)(8676002)(76116006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G+qp3+fSeIlnJtEivQxe+VT4oEI/HUfl9qe1tWzrZ66GmbbZvrreTQUoEXOG?=
 =?us-ascii?Q?MIPX/da7AevSLPg7KJpIgUFU8trIpR2wMMyflMpAc4asFfSt+V0DpQW0onnK?=
 =?us-ascii?Q?W12pklDts4o4/NVmV+tM8ELrvU6ovJb8WOjcsOgdUpqG07xQ312yQ+T7c19A?=
 =?us-ascii?Q?RNVxMjlVv6Lb2ze16YUJvF5jicIu2O/VedVj4T0thcnOkYcS3zayi9lEhjFn?=
 =?us-ascii?Q?R6sjJ3AmuhRU5qOJ4m+/cRCTBR62Uj3rGUf4ZPXvLAX1Z79KvVhCqVpyoMCZ?=
 =?us-ascii?Q?MGXKbN2piuRIAioTWWqv/z/Dur8oFhYWU1ZgFOepaitKIBVRO2vSdiB7Tw48?=
 =?us-ascii?Q?UxWTDldSmCEzhJ/PvKB4TLmcGcn8M11i/UHlJeF2FkWA9MFMwEqYEgaA4gya?=
 =?us-ascii?Q?xwyGDKKfv3m41FMoz97MTDVTVj4X7gbK4JN7/qwVgm+RCbc+5K1v4pZsWYEC?=
 =?us-ascii?Q?N28F1NDeyC2lYZZ4mHGDj9stbv+6gmpfqxArECalHErrckWxI0sEFfxgHy+S?=
 =?us-ascii?Q?LoE92G0ioVoL6L2FB5JhRGpWLhNEUM+KoLTPiA83YjlJr5yM3/FUk0s9S8mN?=
 =?us-ascii?Q?fiI9RHq6fBRWGRJifmBgCYczdWlRJA71XxOQeyBdwnN/Lf2n3aPOmeSRvIXK?=
 =?us-ascii?Q?J3EcMs9QsDfhID29jVJ8fMlFre/QSStaYggeFI8oJbLGXa5o+r2KcFCrfvWw?=
 =?us-ascii?Q?8q9To+g2jmcaFY0r46AVnNEL7BD80HvydUH78uvEFVFKymEuN6io2Q5nHOBo?=
 =?us-ascii?Q?vTvy1QM7IQpjW4BYpBxerlwzwv0N0vqxEv//RlMBZoi1F44F+Np6NK/0NGao?=
 =?us-ascii?Q?pgCZbNzKpjMB84PRBY82qYtVzgjsJFquDVsdzpVQbwqbJHv0/KNEOg+cvGFY?=
 =?us-ascii?Q?m9t7LqTuYTmLkLNZ1kY4Oc7T5ZPgKWeKxhKgASciWfdEcWHsefmzpamizry1?=
 =?us-ascii?Q?9JW4EQZ2HsW/j4YrBUqmpxt5pKAyLRWjiFgksOKJXZJSOP2niCbKDy8E71YX?=
 =?us-ascii?Q?yAhcuNC1AIYkTZnA06a5lHtC2J+KCxn3SYQTttHmqJ66dfmLggbmIVY/vHMk?=
 =?us-ascii?Q?CTptXZKptjqiPICjOvSCWLcQVm34c6Wl4LLds++ze3xR9eIfzJK0nLN/H4Bg?=
 =?us-ascii?Q?Y/PNioolQln6NY4q5N91ErFKxieNivasoDSIGV27VJU20TdStrifF6/NQfe5?=
 =?us-ascii?Q?/DaYalsFxgjCZLEGfjoSLyMoM5vz3Fg4YYdf9JLxoGZkjK7npkxpXAseDUhe?=
 =?us-ascii?Q?pewIMCIVl51lp1n9I8Q2WC2IJn5KDTh3ZsKoPLGV4zyecjR8ATPYlBbkGtYf?=
 =?us-ascii?Q?zkbDjg1EqcHdRXgFEwCy0LV974/KwDN06asxEP7V8tyzEakZtQ0aZecJDEq3?=
 =?us-ascii?Q?ooetccmrpUix7GjqAQn6wg/1fDGMbF6BUBTrYKbSckkPiOwjtdb/9dXemrDW?=
 =?us-ascii?Q?F/+LMvP1ufzzf9GhfJXya9ulVTspWGHlJAEog1oVrpOSWFObRqqeoCZ8tjy+?=
 =?us-ascii?Q?ksx+PKHN7eAvy9FApIusob7vK06Yc57QTp0B5KjBS/ZB8XS0RGO6Doq7xHLp?=
 =?us-ascii?Q?S2zqu7r9mmJYiGJrh9x47RSpvjnPsLramGHa+YL8aL3aZ/93bS6vGhrsvtfd?=
 =?us-ascii?Q?aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845c537f-3803-475c-0b3c-08d9a4eaedf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 08:11:57.0062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZW5FCFgpaBuarTKZqUVoJBVxKfrkHiNcc3ZEK5QBqlhKOjA7Nt4ATl9fjKShlC08PTYVnqbZgqqeKbzY4F8gyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> The time spent in io_schedule() is significant when submitting direct I/O=
 to a
> UFS device. Hence this patch that implements polling support.
> User space software can enable polling by passing the RWF_HIPRI flag to t=
he
> preadv2() system call or the IORING_SETUP_IOPOLL flag to the io_uring
> interface.
Do you expect that this will fix, or at least to some extent, the queue dra=
inage that is so noticeable in direct benchmarks?
Can you share some early estimations?

Also I think this should be a separate patch as well.

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 45 +++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 36df89e8a575..70f128f12445 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5250,6 +5250,31 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>         }
>  }
>=20
> +/*
> + * Returns > 0 if one or more commands have been completed or 0 if no
> + * requests have been completed.
> + */
> +static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
> +{
> +       struct ufs_hba *hba =3D shost_priv(shost);
> +       unsigned long completed_reqs, flags;
> +       u32 tr_doorbell;
> +
> +       spin_lock_irqsave(&hba->outstanding_lock, flags);
> +       tr_doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL)=
;
> +       completed_reqs =3D ~tr_doorbell & hba->outstanding_reqs;
> +       WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> +                 "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> +                 hba->outstanding_reqs);
> +       hba->outstanding_reqs &=3D ~completed_reqs;
> +       spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +       if (completed_reqs)
> +               __ufshcd_transfer_req_compl(hba, completed_reqs);
> +
> +       return completed_reqs;
> +}
> +
>  /**
>   * ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
> @@ -5260,9 +5285,6 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>   */
>  static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)  {
> -       unsigned long completed_reqs, flags;
> -       u32 tr_doorbell;
> -
>         /* Resetting interrupt aggregation counters first and reading the
>          * DOOR_BELL afterward allows us to handle all the completed requ=
ests.
>          * In order to prevent other interrupts starvation the DB is read=
 once @@ -
> 5277,21 +5299,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct
> ufs_hba *hba)
>         if (ufs_fail_completion())
>                 return IRQ_HANDLED;
>=20
> -       spin_lock_irqsave(&hba->outstanding_lock, flags);
> -       tr_doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL)=
;
> -       completed_reqs =3D ~tr_doorbell & hba->outstanding_reqs;
> -       WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> -                 "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> -                 hba->outstanding_reqs);
> -       hba->outstanding_reqs &=3D ~completed_reqs;
> -       spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> -
> -       if (completed_reqs) {
> -               __ufshcd_transfer_req_compl(hba, completed_reqs);
> -               return IRQ_HANDLED;
> -       } else {
> -               return IRQ_NONE;
> -       }
> +       return ufshcd_poll(hba->host, 0) ? IRQ_HANDLED : IRQ_NONE;
>  }
>=20
>  int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask) @@ =
-
> 8112,6 +8120,7 @@ static struct scsi_host_template ufshcd_driver_template=
 =3D
> {
>         .name                   =3D UFSHCD,
>         .proc_name              =3D UFSHCD,
>         .queuecommand           =3D ufshcd_queuecommand,
> +       .mq_poll                =3D ufshcd_poll,
Did you consider to use some form blk_mq_tagset_busy_iter,
And return nutrs - busy?

Thanks,
Avri

>         .slave_alloc            =3D ufshcd_slave_alloc,
>         .slave_configure        =3D ufshcd_slave_configure,
>         .slave_destroy          =3D ufshcd_slave_destroy,
