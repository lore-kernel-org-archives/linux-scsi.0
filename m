Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA58C07E96
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E43611B0
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jul 2021 08:32:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:30120 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKMcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jul 2021 08:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626006554; x=1657542554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cPnLmvTr0nZggEtBOp9Ea8wrlm4WWnATggwv7UaKjyk=;
  b=GrHEkO097/zT7hxhuSXL7MZ4hhqjg4YXjWJohMLkcmxoq+mf8IQCJ1kj
   GpucnH4Cu4S5B7YWwVGjIpskQ0AKe8dv4ACegQ4JxVsmYJ60PsGxkCJQZ
   zFdnTr2JAo5Sr2G/vhHt6MmmU3dpeNldWj7YPw9tcYQlsJa0ePGrNcIeQ
   nvrKGI369SByffBbPvW7kdBYSa/CjCSY9R1q317YE40N6HpcstSV8b7UU
   vPRusyY58QAm+QhZ1+ecJ7IzlX2C127nGY9ydigbyr4CSDX58ymYp/EJV
   MOAMUUHm/LzOpy+sBvRx2y+QQpu/9cNz0hwr24l6uQbIFKT3vGKXLdXAW
   A==;
IronPort-SDR: r890p5h8bw0rAkUgLgxrqJe9t2Jfks0zJpFxuCq8ChvAyqMUiTmH9sZbSBVx6CyiDi/5D5AoMo
 EfA0BFf+MrgtbosDxvWmjdRoRKUgbIlXSHsY2EXlXM/DiTA4wdO+jMkQTUzAtWszTMLkwCn9pH
 3LgMJWgZyBmmCnh6b72lDP5g5RGJC+YCj9Ec9+9KDVEFQo3AC3mfsEstYpVSyqQpUQv8I0uj1q
 MKd5Srm5qJNsFrrgq09UC7oep3mucIEjCUXP/3y2rRv2vqSPZ75tUlRHBHTEfeISweYNBaY9Nm
 wfo=
X-IronPort-AV: E=Sophos;i="5.84,231,1620662400"; 
   d="scan'208";a="179094344"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jul 2021 20:29:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpnWuRZD9vAOQFjeEJjfJGUBgrUF0iLn3nitPECiZytxRWEe4XWGzXL4q59ugBFeoLtYh8AZuLVvRCA4edPnONZ7LTdNSVSyjFBQ4r0BZGv7MP5YqnCLdJXKZ+6zoh+u5ToDWrocssfNmqCRHoS6Wz5CmRXhAuKTNv5EjIAgX6HNOA54riPqd9ZYqnvfgdcX09AgVouqbB+0jJrFUNS4KY1a9s9+fTldThos8jvzZ4iU6B79UzrCdPe+bcodl3A1FVpBl0LFSmFdw2mwUz5NrCNLTQgJTLvbz8bz0sB4CnKPnAyeOcH8jnQcAENfptREoklTV/V99l4VISZpNZEbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQdZ1RLvxvqsir7UJxjWC0vtRqEN5NU8KPoyh3/pudc=;
 b=X3RhitS541YMDFFejlYM5lPx3zQK5Ley1mVTpbPEGYwNt4hTf3dEYU+lonhSSb09Gl1XpFAenSHDpuriF40ZrNbhVxy9fL2m91vGegovfxmdsfzq8cS56CAqGDrYR0k8NkNu2q7g5f3VF6ShSEC7ALPvLmQfOWro67Z8h7ukQuOF0n/OhlXTeN1bUa0A1XFqSkF425uN7AUiPtbIeMyY+0KpQvxKLkOMwr+d+QSb1Jkk0WNq+HE7KRsf3GW3DssRQ6TWwkUUCEcz3Zl+brbaoY3fbPSpaLheIlA7g5Ixtx/meuz36R783vUic17wnORd9wPppBKlykOa3U7Dk6dx0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQdZ1RLvxvqsir7UJxjWC0vtRqEN5NU8KPoyh3/pudc=;
 b=ivor3ZFQMaytmcFtqZc7LltXEgifWzh23jX4Wlv/rVB5xlq+qN2zvDSdphOg2VBqinM47azTVXCHwmC6fUFkAXKPt5CvTOHCYrie7n+xvquvBImIrs9+WpHUdWRGC4fIHSSvFO+QLURLrv4McmOCRuVdRIx+LTmwwjMzWfnpeiQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4427.namprd04.prod.outlook.com (2603:10b6:5:a5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.26; Sun, 11 Jul 2021 12:29:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 12:29:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Topic: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Index: AQHXdQDgAGtkX44t6kOse8My4O1WHqs9tRkw
Date:   Sun, 11 Jul 2021 12:29:11 +0000
Message-ID: <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
In-Reply-To: <20210709202638.9480-15-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0c16097-a3b6-4b93-4dca-08d944677ca8
x-ms-traffictypediagnostic: DM6PR04MB4427:
x-microsoft-antispam-prvs: <DM6PR04MB442712864F150090E8090B69FC169@DM6PR04MB4427.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mT/dDiXU6GVCMjSUaJe8uZgk1bvtGAkCb9p0Vff/vRKzbe8wTPoF6XJcqO+yCzCPH9UVkcPDcs0XEUDO373hZ6B2tuMC7O93CvOkoJmW+CNMgAXTJn6h5p29JQp5mmNo4JTE1CoppG1cR+6RWI5Ff/AYAT7VEZLOPmZOSD/VD7nMLmaSsYNlNHlzXRCF4ciHK3l08jbOv8xpCs8bYRbLZ4kYZG2mqvEcFWPyn7yptOmYv2dCXXYqxwvupmEizz2QX0S9y9P/WT5jYUgCSbFYEUfjFSehLZ8/zXtle5MR1sZuc2kJb+29pHljlyzSwVbhOgupUuJADL0xOqocVT0udUYOcOYXON1VMrggU00WTiueAMKEJOJrfH6rOfIm2LVu5aHQxBx4CVgEWylomPHZetiDbm4dXPW25RR7UKY2JKScnivnQjpwCSCBz2ZyWx3157ib3XXHU3XlG8NOjo0PyrAeW0hnGr0L6U72lvXlahtYZWnyuUPXZz+AqSla28YPLhWD1eN9l4XnNYoDZ2u4nypfB5zdViOtnqpUaRGhKnin70Miq2KAFuodPPVc+UX1HruhfeXt0faJ8DtArumDhZLZRoDAXRkO6fPG0HEjeBD3tbIbsZ6dRcXNfdyjJYcVJikZlfaKqiZtVl0wzloCgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(64756008)(76116006)(66446008)(66556008)(66476007)(66946007)(316002)(86362001)(54906003)(110136005)(38100700002)(4326008)(52536014)(33656002)(122000001)(8676002)(6506007)(26005)(7696005)(5660300002)(186003)(83380400001)(9686003)(55016002)(8936002)(478600001)(71200400001)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qtb47DafvAHqitGUD3e2W/F1BGfZeQh+eYsT8Q6n8+UUEC16RSYZPD0p8aPu?=
 =?us-ascii?Q?JgA2dh4nqlKfPLzYqjuTJ87XGWhu/ylQZpTBzUSeIgZR0Tr/IWmj26V4ESnL?=
 =?us-ascii?Q?bZwmYDXFSBOAUdJWe2qM3OMag0WSXjH0AY90YIqJIrAD4+kjZ+D2sOg2saRK?=
 =?us-ascii?Q?xm1jPiA7oC5XxrbGZSyfEqKIzGc0LTv5Hig0WHWorfOv7x1MJ8GfHgu3XMVr?=
 =?us-ascii?Q?CCYd8reqZgwrCnpZjd6sJ8U82uW3lsWCXvKDleEkOchtRvcpof4THEA/JhV+?=
 =?us-ascii?Q?jFBK6khqZGrlEcfFmmXVgFdDGbok4vNOvtd0v6CoMPljDpgCX0K1CdVFnC+3?=
 =?us-ascii?Q?1Q0WoTaJkm6E04NdOwBhMUimHUDFDYRAMPp9M7XXi0JP/NbquFFuwt8wa6An?=
 =?us-ascii?Q?jzU3VGKTbR4zo1xlBcMqJn+oJmit+APCMgKHsoRvC+uflKyY7wNT77DPDCUv?=
 =?us-ascii?Q?4N5oV3X2V0n5umyxnSMSuDn2NuVF4vfhEqpmCTvfG6t5asTGNZOUp//rrgVO?=
 =?us-ascii?Q?tQJk4AoNY2J3Dc0p18Lz3lgHmRc3uqadvRliD0uQvnl9oTJZr1S+l3DmVwfK?=
 =?us-ascii?Q?aVXl8Z6Fo+zLeUa0IMFBsJuBY+BIARpMG5ISadBQFwNoue07t09hc7IKR/8Y?=
 =?us-ascii?Q?LtnaTm9KUzKERDX6Ir626LwxYgx3z5hjOMkil/KK9N3/81ljDck72NCQvI/3?=
 =?us-ascii?Q?kQzK0DeBq6C+PSXEH8df5D1t1rlEdjpv82mhJK5Rmo1SW27G/TuxCAXvWkt6?=
 =?us-ascii?Q?4haYRLIM8Jr7fe/AM9NX8+gCqaXU5thxuruc0MRjPawSx4Z/eguMjZTqHyQv?=
 =?us-ascii?Q?ZSK2+wWZSDzF6NCx/Wew3L574gCsTFsJoOtaB0GnaKyIhdKSIVcvX9cXFpV2?=
 =?us-ascii?Q?e1rrxiLe2w8J1/gW2QQKHMOKQayn2xRqw7smcRcU7KunxjcnqYo4Pbi5sxw5?=
 =?us-ascii?Q?LXU3MO5AddoV91954K1N7zQPVqKWeRmFVaUFblnNCtd6j2uStickKc1+OcAg?=
 =?us-ascii?Q?RwD8P8Eua0lxEcnjopNMmteefFB/5bzaChN56GX1TFPQLefBi5RYE7hKtpZ+?=
 =?us-ascii?Q?OwGbm7pJmfQx6OTUmjK4XaYS3o6gLZJJ62oGWffOdoK7iI/Ey4n9ILchCHre?=
 =?us-ascii?Q?u45AqXTROFNt38ZdCSYwu+GqkRJWKcSo2Ok/P6BzCSQvBOr/diXjRFxWtaRr?=
 =?us-ascii?Q?e0Necjmdqj7s9zr4Qeu0ANEU0wVsr2KttisNFbFqIbLn6czeRRWkU3w9Rity?=
 =?us-ascii?Q?UhLGNAxsLg50YYBJlzBC6NqkdSMLkaPA9kncf+R/utlHADcJeF4yLrWqEEcJ?=
 =?us-ascii?Q?ndOcSX3wfcceDzEyZrzhXhUr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c16097-a3b6-4b93-4dca-08d944677ca8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2021 12:29:11.2186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RImhM+FZAhukv6SZlTP6wLQ1mvY2XSMEdF23nqYKO0LRhxYHNoZdxxSQcVEuGceDu47XaFiE3iWRZnga0s/PDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4427
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> The following unlikely races can be triggered by the completion path
> (ufshcd_trc_handler()):
> - After the UTRLCNR register has been read from interrupt context and
>   before it is cleared, the UFS error handler reads the UTRLCNR register.
>   Hold the SCSI host lock until the UTRLCNR register has been cleared to
>   prevent that this register is accessed from another CPU before it has
>   been cleared.
> - After the doorbell register has been read and before outstanding_reqs
>   is cleared, the error handler reads the doorbell register. This can als=
o
>   result in double completions. Fix this by clearing outstanding_reqs
>   before calling ufshcd_transfer_req_compl().
>=20
> Due to this change ufshcd_trc_handler() no longer updates
> outstanding_reqs
> atomically. Hence protect all other outstanding_reqs changes with the SCS=
I
> host lock.
But isn't the whole point of REG_UTP_TRANSFER_REQ_LIST_COMPL is to eliminat=
e the host lock
As a source of contention?

>=20
> This patch is a performance improvement because it reduces the number of
> atomic operations in the hot path (test_and_clear_bit()).
Both Can & Stanley reported a performance improvement of RR with "Optimize =
host lock..".
Can those short numerical studies can be repeated with this patch?

Thanks,
Avri

>=20
> See also commit a45f937110fa ("scsi: ufs: Optimize host lock on transfer
> requests send/compl paths").
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 83a32b71240e..996b95ab74aa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2088,6 +2088,7 @@ static inline
>  void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>  {
>         struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
> +       unsigned long flags;
>=20
>         lrbp->issue_time_stamp =3D ktime_get();
>         lrbp->compl_time_stamp =3D ktime_set(0, 0);
> @@ -2096,19 +2097,12 @@ void ufshcd_send_command(struct ufs_hba
> *hba, unsigned int task_tag)
>         ufshcd_clk_scaling_start_busy(hba);
>         if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>                 ufshcd_start_monitor(hba, lrbp);
> -       if (ufshcd_has_utrlcnr(hba)) {
> -               set_bit(task_tag, &hba->outstanding_reqs);
> -               ufshcd_writel(hba, 1 << task_tag,
> -                             REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -       } else {
> -               unsigned long flags;
>=20
> -               spin_lock_irqsave(hba->host->host_lock, flags);
> -               set_bit(task_tag, &hba->outstanding_reqs);
> -               ufshcd_writel(hba, 1 << task_tag,
> -                             REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       }
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       __set_bit(task_tag, &hba->outstanding_reqs);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       ufshcd_writel(hba, 1 << task_tag,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>         /* Make sure that doorbell is committed immediately */
>         wmb();
>  }
> @@ -2890,7 +2884,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba
> *hba,
>                  * we also need to clear the outstanding_request
>                  * field in hba
>                  */
> -               clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
> +               spin_lock_irqsave(hba->host->host_lock, flags);
> +               __clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>         }
>=20
>         return err;
> @@ -5197,8 +5193,6 @@ static void ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>         bool update_scaling =3D false;
>=20
>         for_each_set_bit(index, &completed_reqs, hba->nutrs) {
> -               if (!test_and_clear_bit(index, &hba->outstanding_reqs))
> -                       continue;
>                 lrbp =3D &hba->lrb[index];
>                 lrbp->compl_time_stamp =3D ktime_get();
>                 cmd =3D lrbp->cmd;
> @@ -5241,6 +5235,7 @@ static void ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrl=
cnr)
>  {
>         unsigned long completed_reqs;
> +       unsigned long flags;
>=20
>         /* Resetting interrupt aggregation counters first and reading the
>          * DOOR_BELL afterward allows us to handle all the completed requ=
ests.
> @@ -5253,6 +5248,7 @@ static irqreturn_t ufshcd_trc_handler(struct
> ufs_hba *hba, bool use_utrlcnr)
>             !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
>                 ufshcd_reset_intr_aggr(hba);
>=20
> +       spin_lock_irqsave(hba->host->host_lock, flags);
>         if (use_utrlcnr) {
>                 completed_reqs =3D ufshcd_readl(hba,
>                                               REG_UTP_TRANSFER_REQ_LIST_C=
OMPL);
> @@ -5260,14 +5256,16 @@ static irqreturn_t ufshcd_trc_handler(struct
> ufs_hba *hba, bool use_utrlcnr)
>                         ufshcd_writel(hba, completed_reqs,
>                                       REG_UTP_TRANSFER_REQ_LIST_COMPL);
>         } else {
> -               unsigned long flags;
>                 u32 tr_doorbell;
>=20
> -               spin_lock_irqsave(hba->host->host_lock, flags);
>                 tr_doorbell =3D ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -               completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> +               completed_reqs =3D ~tr_doorbell & hba->outstanding_reqs;
>         }
> +       WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> +                 "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> +                 hba->outstanding_reqs);
> +       hba->outstanding_reqs &=3D ~completed_reqs;
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         if (completed_reqs) {
>                 ufshcd_transfer_req_compl(hba, completed_reqs);
