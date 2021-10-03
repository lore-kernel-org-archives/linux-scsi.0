Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C96AC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 06:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D466F61A78
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 06:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhJCGtr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 02:49:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55468 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhJCGtr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 02:49:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633243680; x=1664779680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FcK1gBMK3TkP4rOBWjj09pPDW3lPJxAsTlmsexpUl2I=;
  b=ZV48qvV5+ky2vMJ0ELtLh1nLHxYWug9X9gndbBt1RdrLJX+94g+6PPzY
   QxtS+UmcJfgD52Dbm7+vxFKiSpRYOvJV4pDLCbAYYIZLt27GrqoVlwHRa
   GzVhzOeLMboHIWUjbmoa/KRbmslT17SkqJ5DpGpXn3sZYPGjO9rAaWHLi
   Nf7vRBbSXz7/4HU8ADGKrfPysZW+rf9yJBfBKLVNQ860V6kEufsiAvp2p
   tcTzf6QOT6IPhBO5B8D9V55Qrreu/EZdNfqOL7dIlf1vTG7n6WoLnGvzz
   3ItsugcbOjU/x5hpSSY8Nihj6kv2MPngN+SNBJJInrF6Z4SVN1JuSgh5Y
   g==;
X-IronPort-AV: E=Sophos;i="5.85,343,1624291200"; 
   d="scan'208";a="293364449"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2021 14:47:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1ji0pBtdiI65kMc5hQZF2Q18BPeUsp1qpp1z09nggDsa//YD+VXTbCszVde1XnAQoZy4x5hbMCWD14s9Lq9q5uWvsDX/pkRTT8ICY6VVzILj/HNr44Rj16uljUsmD+lQbshFGB0sBrcn1L6XW7UfTfL0d/NV3rU/F3V34NBSIRq0aOtl00jruqm5NG5UgO3EOJzADu8z3Ibyr48ZaXKFcyhJ1SEDCbo39jV+jdOvsT2SbRoMnLMXzaGdFqX0NcJJ3v+OHhu50GmthXiKVRduZU7+5UTzRCezAKWGSXRb62hqT5GA3lkIv3p2hyBk/JSg+Xt1eaqBfXHq5VJv1dkbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toOWYRBRep+fylBkvqPxQxZkLyYB8AvPMKmwy4f5z1I=;
 b=oYuZ0E2iqqrh/G9qY/+GMGaa1B7lFiPmZsO0kUXK7mAr20ZmH6SFs35GJsfqqlMSA6F1jy4jwkc5QN6mrCNHVKtU/Qfnvc17OKoDt1SxsWn3TwhQ4ildlqo7CLX9Ud/O6LGFDlkYCxwpCWnfJz2QxNW3l+ii5LbTdJmb7J4/EZPhnLpnqGICg9b5tVLoB5NQ8RyY6tlP9sd9OSTIxarZ9Wtgxk3GUO8nZVJW40PGBkeqRjUCbTgxxZ6CnR5PmqbA3HuN2J2AKxEHtTlJkAXTdsa5nPzJIC6FAdez9+PDfM0i3d0q4VYWYt+XwOZ/0b4yRjFoDrQQqTsv+JccteAMsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toOWYRBRep+fylBkvqPxQxZkLyYB8AvPMKmwy4f5z1I=;
 b=t0tF6fRCvBrQwFmuTzfNcxAEVtFzUVjjWzUJ1xXjlaa7IsENl+7EFJ40BcxO2YAYSXi1uzsx5kPBgOHCUWUKR90Uzd4xlDpCtsm+y8fsmIv8gx4PjJUOKcG75sB4JXhuryJ3VVOB18j3vN9rI9UjKSIkfGVh8a0cy7Qy4tTW+5U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4556.namprd04.prod.outlook.com (2603:10b6:5:26::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.21; Sun, 3 Oct 2021 06:47:58 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 06:47:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Topic: [PATCH 2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless
 operational or dead
Thread-Index: AQHXt6SizcPX5XU+gUCAYqEZHVd+nKvA1OIA
Date:   Sun, 3 Oct 2021 06:47:57 +0000
Message-ID: <DM6PR04MB6575003C0D1D2A31878B952CFCAD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
 <20211002154550.128511-3-adrian.hunter@intel.com>
In-Reply-To: <20211002154550.128511-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e99060b-d5ab-47da-da93-08d98639bc35
x-ms-traffictypediagnostic: DM6PR04MB4556:
x-microsoft-antispam-prvs: <DM6PR04MB4556C5F0C6B66D1B82E7A875FCAD9@DM6PR04MB4556.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWOXMwqDr23zlAiNxHwcH1rZCdFP4MyyDSwZo0KPGoMryxTUI4fieCiIHgCLOMI7gAZDnn6uLHw7bz994ByjYxbH+EBUuTx1usAfNx/huPf6iPGV20uESv3EWltfHJqDLHRVBFMbwyD/9jhkoNlNk8vc/o+ukfZfQ+ZKDXAv5fkp12gVG6vXkqFem1w2vIsW0l+bYjgWphiBAwDSRN2gkwTIiPZJDAOoomUugMzzNoHMKis2dmohYAxZvRuhoH4iOHwl0f+Ss1pBC/EEF8WRPat4HyCkM9cTRiOUB7YBd3bLCcuGCon8O6AyDHYL1NvStRXirCWTERPT8Ad4IYDHkKbgrtAsY4o/ZYY1iFgdUdCHjCFSmTiPwlxy8k8L/MlyEWRuV3Dik1pZ9Xj4vjvWH2aNWKqXlmBre0C8+KdNcW0pn61T7aYN/2NZEKVY4VaZsBiLqRmYiPSaP6o1H6EJyMdcS9ho2Yqqr1gbVYuTZu4AGh+TIPiEI2Mefsm0RUSQIf3CPrj3rjiP5SJstGEyXiswSAq+R+KI+y7D3ZF4/y4nIXbDgdw+Gf38iEuxReWZv2MxaWTGAGxJ6IY4Do1r+o7fHHUORKLg3LVoSAlMI12qU79lacjm1FriId4Drwq/3iqdAM8Ik7RhDOY4lsfAYYOlIIzjjXE7xSQejjHt27CElYkni9nQ4WL6R5RuHQ3PJgJQnsQe7VeEjzThRmA6Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(316002)(86362001)(4326008)(38100700002)(508600001)(38070700005)(26005)(8676002)(122000001)(54906003)(186003)(110136005)(66556008)(9686003)(64756008)(6506007)(83380400001)(33656002)(52536014)(71200400001)(76116006)(55016002)(5660300002)(66946007)(66476007)(66446008)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OsuzA44e2v99fapWbH1FGSf9tztajDZsDx/LNYfYL743fnrNsrvJRFFxykqJ?=
 =?us-ascii?Q?csMf24A6Q48fi+Xy2Gvy6qP/3zIJJRGwhsGfv+fo19aY5bk9rbYBMcCF35RZ?=
 =?us-ascii?Q?6PDzEquFufVAhZNqO6dsdr1SIhCW07rolCcTMvCUfratOFD36EESo1pVFpcu?=
 =?us-ascii?Q?vwyeU1FkzPLLqmmUkOq9DCq+Ll2P8ok53cXLK4kk2UAoGrEAsitR6xH0kDBO?=
 =?us-ascii?Q?APHNVMZPQetTfGEintK8cUGr4vwMh8RJFruttdmDD6oWvsB3sCwbTNfjq8sB?=
 =?us-ascii?Q?7blPZX1vz7w/y5a6z77svQANJBGqfb6dQrylvbIew2b9l5eKoubx24MNRcx7?=
 =?us-ascii?Q?khVFW+PbA1rGsj/xCOnf+L0zvovoD4xs4xg5h+YtCXgkK06/6oY8jNtUAx8H?=
 =?us-ascii?Q?pIG0BCocipwMWixn6jnaRdVnDRWX+8La4S4htMSj2bTUPRTxzbUh0KmqZkSH?=
 =?us-ascii?Q?GQJI4VG/psK7Y3ARm9csJbqR7S3qje85KSbAf/sa0wbmDFouf0jC9cWX9ME4?=
 =?us-ascii?Q?2LtUUZkXh+1PsS06vdMQLGMv/4sHRXL6v+q+zMgTutbgzf9TspoeCJlH2eD4?=
 =?us-ascii?Q?Wf7oJhLrqlM7IBnGfhzGR0GJk7nAUhuTm9P0UZm855Kfzf9yjd/NcaplbKMu?=
 =?us-ascii?Q?LJj0O3EfLm/QG8/DBsO4dVBDzGoQtCh5d9RIGYqolOLb91J3EGfDgDennYBT?=
 =?us-ascii?Q?rCKQpJ5C4hsod2zNgFfaAntNXdqF+e+/CkTA1WjayUQjQICOSuVZYHhL+2M3?=
 =?us-ascii?Q?ploQB8M/oMH3Hlq7hY4WJFtC9oOuoCviszn2u4WJaf6Ux+RMscByg/qMb1mp?=
 =?us-ascii?Q?tpdiJX4d5N+7KyLzSBPKZZO6BT6cKN0vAmz3tiIVFA9NpNkwxTQgGtiXlFQv?=
 =?us-ascii?Q?I6smfoH0lECU0vOVhBzfR9e3DZU+M+79I4m4MQnPeKt/hnIt1Sp3CUUQJvJX?=
 =?us-ascii?Q?ESm28zi6I5nJNSK6h6sPXhSotpzX3d+Fk3UbADPGr+pXJcI+E7nPM6G9m5Un?=
 =?us-ascii?Q?cTDJ9Iew7QHu078Nqr5OKsGtz/VZKqRfgT4Qb5SeEoYbs6hhrNGAYc8RzpGN?=
 =?us-ascii?Q?zj1eC39m7KQaHTG1g64mQfnw2KkAycRuyG78vMzk7t/5NhLBGjU9KJHJIiCs?=
 =?us-ascii?Q?GMpiiuMs4WUr9lxTenWw5eIK8CGODFJBrxwZVz2Z3Ll48rtR+UzNuGQMBbQ5?=
 =?us-ascii?Q?Q7xPuegTJOom43nHG3A/K6dmQZKL5RLwJHfmu34TlVSJPVPHx4I5LKRJd+CM?=
 =?us-ascii?Q?KBHyYCzR7i1Fcfiq8+2SSxzWtOLONsaC4qfAsGpiT0S01vATv4jz9vwgffL7?=
 =?us-ascii?Q?gC7eKaTUTuEE8tdnFJHdmSjY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e99060b-d5ab-47da-da93-08d98639bc35
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 06:47:57.6797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HxsfMHYOCBV3k7lFLY52VQOsr3MzirP4Nmq9v9iHzLq9SdlNXyxRfCs0r8AWuACpBK2LXgHJfwwYyEm1bB1EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4556
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Callers of ufshcd_err_handler() expect it to return in an operational
> state. However, the code does not check the state before exiting.
>=20
> Add a check for the state and perform retries until either success or the
> maximum number of retries is reached.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 16492779d3a6..33f55ecf43de 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -64,6 +64,9 @@
>  /* maximum number of reset retries before giving up */
>  #define MAX_HOST_RESET_RETRIES 5
>=20
> +/* Maximum number of error handler retries before giving up */
> +#define MAX_ERR_HANDLER_RETRIES 5
> +
>  /* Expose the flag value from utp_upiu_query.value */
>  #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
>=20
> @@ -6070,12 +6073,14 @@ static bool
> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>  static void ufshcd_err_handler(struct Scsi_Host *host)
>  {
>         struct ufs_hba *hba =3D shost_priv(host);
> +       int retries =3D MAX_ERR_HANDLER_RETRIES;
>         unsigned long flags;
> -       bool err_xfer =3D false;
> -       bool err_tm =3D false;
> -       int err =3D 0, pmc_err;
> -       int tag;
> -       bool needs_reset =3D false, needs_restore =3D false;
> +       bool needs_restore;
> +       bool needs_reset;
> +       bool err_xfer;
> +       bool err_tm;
> +       int pmc_err;
> +       int tag;
>=20
>         down(&hba->host_sem);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -6093,6 +6098,12 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>         /* Complete requests that have door-bell cleared by h/w */
>         ufshcd_complete_requests(hba);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> +again:
> +       needs_restore =3D false;
> +       needs_reset =3D false;
> +       err_xfer =3D false;
> +       err_tm =3D false;
> +
>         if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
>                 hba->ufshcd_state =3D UFSHCD_STATE_RESET;
>         /*
> @@ -6213,6 +6224,8 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>  do_reset:
>         /* Fatal errors need reset */
>         if (needs_reset) {
> +               int err;
> +
>                 hba->force_reset =3D false;
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>                 err =3D ufshcd_reset_and_restore(hba);
> @@ -6232,6 +6245,13 @@ static void ufshcd_err_handler(struct Scsi_Host
> *host)
>                         dev_err_ratelimited(hba->dev, "%s: exit: saved_er=
r 0x%x
> saved_uic_err 0x%x",
>                             __func__, hba->saved_err, hba->saved_uic_err)=
;
>         }
> +       /* Exit in an operational state or dead */
> +       if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL &&
> +           hba->ufshcd_state !=3D UFSHCD_STATE_ERROR) {
> +               if (--retries)
> +                       goto again;
Why do you need to retry here as well?
ufshcd_reset_and_restore() already exists only if operational or dead?

Thanks,
Avri

> +               hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> +       }
>         ufshcd_clear_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         ufshcd_err_handling_unprepare(hba);
> --
> 2.25.1

