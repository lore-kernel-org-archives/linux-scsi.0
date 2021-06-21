Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD63C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E94561151
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFUI3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:29:05 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43253 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUI3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 04:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624264008; x=1655800008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UFR7jrOgWs+KHcjNZXRVitWn6YF0HeWPqYKJvtQSOsY=;
  b=bxWifbeq8kTg8UHs9q6QhbSh4s1dNA58c9M7jILgx3s5Zv6Hcun6iXaN
   8k5lnjrX6GQ+DUHbEq/YlrSWAsVyX4BVkw57ebpNHwJGvwddwG2QvWZtm
   fySG36YOBWyKAr4WWzgKNqIWrEG69HDhR3aHmHh7KuMC090svmWrzvtl4
   rsyQS1PGCK3u/sV9gVRf3SaMPlEi1bDuGxN5NAADiPHbKyMxIdqDa0TR8
   h8wZvhfsJEzmaZmU9J6c0GpXe/B2+YokS3qPNcZu1RNjSFo2tOtJiCUx7
   sfaRc31H8Rp911wIdXzG9hONO9by06DQiSpWQMH+9XLu1kv+bbAe6I/uz
   A==;
IronPort-SDR: s9VsaAUW1cR0luXlReMO6BZWfU70bak5VMXimjHJTfOr2NXC7XpgeIkN/QgKEOy3+BmXfsl1qg
 1xuTLlKnjjE+QA+J2mg6YgdS7RlCxsLLABjtmhHnshjcSCUQ12TaopbetiXXHl7CZ/FuE9fnY4
 uXN++jfY3q0Wmfpk7nWyBBZ90hnysesn95DnthnQ8dwupLVL1pNl4vwZjLpB/jhZ0g6k5FlTfb
 MKLiqa4F1Tk9qn+8KjeMgurBOZ6dkiuvunhIiVK1f0f71TvU6a9pINdwcLPU6ScdLu82FuylBA
 OCs=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="172467813"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 16:26:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk5oOYmZBuxo77bsp0K++EQHUd/iMOgRkzcmxS/d6kwul4pLgZbrJsUIdtrRmH6Pn+wXG5oSBIPPXLWR3hRebN5jVG9XRlBMAWkmS+p0pUn7vchW0G0aynXIlpV9NQvkWbhVnlDseBXiYl2CEPBAjbWi6SWmKjUd5wNAmwc2gzSLzUcmeJwK/7zTgc5r+HaP+D7XZGQ/gcJ/SHfPz9x5GEzhX6RMJzAWO01H/7nmFXX6zvd230AEcSXEBIP/PtmIEFPIXEX4sUfMUeIyskSh5ha5RccnK0kMnO03gRKXB9wNqHnlV4HpX/oJNzNRL9QdzAstmFeVOzNnWhwe/oYfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYqqcPLk/IdZtAn8lvC+QFYTvtFgeUYDcqm42pzyCYQ=;
 b=UWOYaiieIjFpSxjlRgfvSjvojPBt2f3u21upHB3njGsyt95Ulj8AKKybDpFQsauFTCZRc/9DklcceLP0h23DCJWqWjFCSohoBKVZ930E2EH16Kuzu+h6k4gXrF5jW+XvVd4q7eJgbls5uesatCz+ewMAFxolVFyezV1j8QReKm92621DaEBYtZkitdfhuokxaumqIKt4WKTq+r7D57MvXjIofJKudr/vOB9lD0qZ9dx0QAnzVvtbGTY2Wmzwsfwwb95GPo3IvAV9V5WZ3Y9x4+74kak+COkL3hJj7cXGcIHT30TpCpXaV2nyYDWpqSQh9OgIkbjLcVjxvVhHf8zC7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYqqcPLk/IdZtAn8lvC+QFYTvtFgeUYDcqm42pzyCYQ=;
 b=sA2FX6SqrlkCG4WuFhrCbRCR4pV/vYDaUh43UjXRNUfUAZSjYsrLTYwooMQ0JK23ZIlLNQE5S8Py8WoRC6w+vCIPceuRDojJprp9VakaDJWa26shBNf/HtYhWIkHnlhH4xO7hpDPOnLzkQRrtW7jUm8qGiu6SWWkURQkKG5UjHA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4026.namprd04.prod.outlook.com (2603:10b6:5:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Mon, 21 Jun 2021 08:26:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 08:26:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH RFC 3/4] ufs: Improve static type checking for the host
 controller state
Thread-Topic: [PATCH RFC 3/4] ufs: Improve static type checking for the host
 controller state
Thread-Index: AQHXZKVxiUHyTkIZPEyuDF1qQ/r1SaseJM8g
Date:   Mon, 21 Jun 2021 08:26:47 +0000
Message-ID: <DM6PR04MB65756B7AF5F60811F2791C4AFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-4-bvanassche@acm.org>
In-Reply-To: <20210619005228.28569-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8755e180-7f1f-48f1-ca47-08d9348e4f78
x-ms-traffictypediagnostic: DM6PR04MB4026:
x-microsoft-antispam-prvs: <DM6PR04MB4026F362702F99919BF9332BFC0A9@DM6PR04MB4026.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PuTK8qkPjcvhvjk5T2jNMgcThZB8fNEKA6EdDW61CAWoyihcfJNFlwPCNBjYoLocADMjIia3aOVdIDyydYA1TJaxGymSnGndz94mke21iSkOJRZCaQVP3D3uElyk8Vm9sRai3JoJP2LLmPzBe3hMxXA6oAPzfTlrqWje6qMZVhNoXUN+OJHmNDEyA7dXdqbl9fpk8N6cmVu87GHmRtkyAAroEObO0Hj5GzZjdYRQW6Tk3Iu4xehMsErvi9cAqSwfoE1MwTuRfoeVMn88zoDKrIyh9E3wr0TZnWvYN0ZFzSyf4E+LMCejQO1m148VOrrhc3fC4waXjVavE7vCmMGhcw3qiBxeT9RIvidjY9s4npQ8hA+WrscvkDULwReKNGbzJLYTrau4soBObROT3BmcEsJwp3ukHE/ZKGT5t3ewx2KqOU8TuIXJjbNrwFud8m2tLQjw1qZ8DdJYVIeMb4SGkAwqYjblO2xc+HLIu2Qu9kfX5fuEYB2QW7qPlOXcdtDBN5145+SJgz1tUTxNa8smhODqnvt+qTqMmYoZk0vGAGb7ZChYcKhtAYk/gtwTYmep/HDlmxxhS3V0n3RC/WEMUsUiizK5YulkTQ2fEv9Y+M8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(26005)(4326008)(33656002)(8676002)(316002)(7696005)(76116006)(122000001)(38100700002)(9686003)(6506007)(83380400001)(478600001)(186003)(66556008)(66476007)(71200400001)(66946007)(64756008)(66446008)(5660300002)(52536014)(2906002)(55016002)(7416002)(86362001)(8936002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WlDEuRBElu1yFTgv1ZXc9+yp8mqgztxnMeQRMmLJq6MbRcZasQ1Yv8s6/iVO?=
 =?us-ascii?Q?w+7W9KudxEOIoFGJ50aXlQjcymVFFqCKHVED4oX2SK9uVYuuU4KznrXTCcKI?=
 =?us-ascii?Q?qQJFX9p16goaRwFaoqymh0kxM09VRH9u/x/8BCrj1RXThnZb6DbKfOWdRmRO?=
 =?us-ascii?Q?A9tJ7P2CaG+HLNLkavNGnd5BBc+btycp/oQya3TztaKc93XCfC6N9Tprf/wM?=
 =?us-ascii?Q?DJ7L4wov6a1zOVcdIx0mLrU4jUNk+AJmuk+XOtvDxtCOdWoAJ7c0b6ut2Tjt?=
 =?us-ascii?Q?p1RSWIDPoQzKooEPxrdnG7CyfJrbsoqINdTvpEU/+narUQ4AbdlHW5t9zQDU?=
 =?us-ascii?Q?Z4LuY1cI7/xh2ELVx95TcZ79OsMZDnpqGJfXCaQfVy2E0oewHMCbFJ5lBJkG?=
 =?us-ascii?Q?zsJwen7pF5lvyjHfYDOVDX0nfFTf6RZJdronu0URh5XG59zN3YEdxJa/DtpR?=
 =?us-ascii?Q?spDS83nWxGYjUuRXkxwQgvCs04mUQTfebubuYGumEKTCeHMyeQhFYVEkzrPw?=
 =?us-ascii?Q?c1VCgrQ2w8q3ECCvkpDHcE4Hccpe08lwiyqs7jgccyV489F+0UtpdzHbksq1?=
 =?us-ascii?Q?/MC3aDSkAMDcR8nUQ0PN5IMKC4ily7/wU6UhmFgmPz+aQYShX19ILjJBDATi?=
 =?us-ascii?Q?eQFos2T6vky04VJnFxe1IkSioWDTuUTGjVAfcjRb3S7yk+VKSmJkZKZpD5Dd?=
 =?us-ascii?Q?gda+JBlSHNpcQrGGP/raPYX6wiScBl+TmqFF7Qeoj2sen0wNQbSqygbOKzha?=
 =?us-ascii?Q?jLiFrIUU+Z8iUAWMsU+4TKermIqzRfqSHHhSSjEFYY58UZTzKxfiPCvG6+t4?=
 =?us-ascii?Q?fS2xjAz+UZhnrOWRtwgICHKchbXsmSd2IAQ0sNuUvHPxnGIbPaDHgq32ZHpi?=
 =?us-ascii?Q?j/pMvrh47a10L76Cy5anZ/pKtjaaeRjBgvLoXN4Ol3C7Lj8lNpEW3vUvcDQt?=
 =?us-ascii?Q?NIwVG3y75TKCWqJOJmSLxN7UmJYJTaLQpOH+p/G48uefZv3ZcKw3u2N/P4sv?=
 =?us-ascii?Q?k2Seu5rqvbaHeyZn9Qd3sBysSiM1olOj7ig63/DCyhk3CfSjbwv2VLnUXqB7?=
 =?us-ascii?Q?4bax4wfpPHyUR55Y9lUYi2w60cyA5znOASagO9+GEGYEvzAEsF8d7JSun264?=
 =?us-ascii?Q?9CnyjDvA2/VR4R0F1bSWwxHzadOvtpe47px/m+xSq/aBaP9ympoTEQkhgnep?=
 =?us-ascii?Q?T+k02emH39QbPKsWQWm6itVrXg7IxqLPzWk2+RS4Q222JAZKZJX/fyk2mqQ3?=
 =?us-ascii?Q?mqhrfAfUkQ6K1FvHncf7kT8jxpoFdUsTHmKr1Gc8EDP2iWyDGBWVsOkjIXRM?=
 =?us-ascii?Q?t3BTI6qOLdaZ+tvHFiTUA+Ii?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8755e180-7f1f-48f1-ca47-08d9348e4f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 08:26:47.2195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZrv6PdeduUYp8oY/bEOT84rnxmvpe3u2eZDOzs145kN/nQDmx929GR/AYkpi6XPHieP5mL8yY0s5FAUu5Za4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Assign a name to the enumeration type for UFS host controller states and
> remove the default clause from switch statements on this enumeration type
> to make the compiler warn about unhandled enumeration labels.
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 15 ---------------
>  drivers/scsi/ufs/ufshcd.h | 25 +++++++++++++++++++++++--
>  2 files changed, 23 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 71c720d940a3..c213daec20f7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -128,15 +128,6 @@ enum {
>         UFSHCD_CAN_QUEUE        =3D 32,
>  };
>=20
> -/* UFSHCD states */
> -enum {
> -       UFSHCD_STATE_RESET,
> -       UFSHCD_STATE_ERROR,
> -       UFSHCD_STATE_OPERATIONAL,
> -       UFSHCD_STATE_EH_SCHEDULED_FATAL,
> -       UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
> -};
> -
>  /* UFSHCD error handling flags */
>  enum {
>         UFSHCD_EH_IN_PROGRESS =3D (1 << 0),
> @@ -2738,12 +2729,6 @@ static int ufshcd_queuecommand(struct
> Scsi_Host *host, struct scsi_cmnd *cmd)
>                 set_host_byte(cmd, DID_ERROR);
>                 cmd->scsi_done(cmd);
>                 goto out;
> -       default:
> -               dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
> -                               __func__, hba->ufshcd_state);
> -               set_host_byte(cmd, DID_BAD_TARGET);
> -               cmd->scsi_done(cmd);
> -               goto out;
>         }
>=20
>         hba->req_abort_count =3D 0;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..f2796ea25598 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -476,6 +476,27 @@ struct ufs_stats {
>         struct ufs_event_hist event[UFS_EVT_CNT];
>  };
>=20
> +/**
> + * enum ufshcd_state - UFS host controller state
> + * @UFSHCD_STATE_RESET: Link is not operational. Postpone SCSI
> command
> + *     processing.
> + * @UFSHCD_STATE_OPERATIONAL: The host controller is operational and
> can process
> + *     SCSI commands.
> + * @UFSHCD_STATE_EH_SCHEDULED_NON_FATAL: The error handler has
> been scheduled.
> + *     SCSI commands may be submitted to the controller.
> + * @UFSHCD_STATE_EH_SCHEDULED_FATAL: The error handler has been
> scheduled. Fail
> + *     newly submitted SCSI commands with error code DID_BAD_TARGET.
> + * @UFSHCD_STATE_ERROR: An unrecoverable error occurred, e.g. link
> recovery
> + *     failed. Fail all SCSI commands with error code DID_ERROR.
> + */
> +enum ufshcd_state {
> +       UFSHCD_STATE_RESET,
> +       UFSHCD_STATE_OPERATIONAL,
> +       UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
> +       UFSHCD_STATE_EH_SCHEDULED_FATAL,
> +       UFSHCD_STATE_ERROR,
> +};
> +
>  enum ufshcd_quirks {
>         /* Interrupt aggregation support is broken */
>         UFSHCD_QUIRK_BROKEN_INTR_AGGR                   =3D 1 << 0,
> @@ -687,7 +708,7 @@ struct ufs_hba_monitor {
>   * @tmf_tag_set: TMF tag set.
>   * @tmf_queue: Used to allocate TMF tags.
>   * @pwr_done: completion for power mode change
> - * @ufshcd_state: UFSHCD states
> + * @ufshcd_state: UFSHCD state
>   * @eh_flags: Error handling flags
>   * @intr_mask: Interrupt Mask Bits
>   * @ee_ctrl_mask: Exception event control mask
> @@ -785,7 +806,7 @@ struct ufs_hba {
>         struct mutex uic_cmd_mutex;
>         struct completion *uic_async_done;
>=20
> -       u32 ufshcd_state;
> +       enum ufshcd_state ufshcd_state;
>         u32 eh_flags;
>         u32 intr_mask;
>         u16 ee_ctrl_mask; /* Exception event mask */
