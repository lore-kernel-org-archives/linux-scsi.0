Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E03C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C7F613B0
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhGEGfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 02:35:53 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:63686 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhGEGfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 02:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625466795; x=1657002795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VAuAjjz8SrakHc10vLHMYsnIGAZss9xVBo03KZ305rc=;
  b=fU5GCLHObhXWq2C9L1lTr1NWN9CAHswFSw9lsJQ0ddK8MANYnJowqGfL
   n5BiwHUMP+adRrbcr7GS/xsKRn124vLgf/GCb197t6Y9gkBoDVsLirjA5
   rvmj+mHtKDiFL/42Ob8LINnfwQQ8kpEpNQDsB5ALRgVF510cxkhnXFhA6
   uBxpo4vTQmGughsNCYSs5iq+4siFWgWm4nuJ0+nrXY7EHRdRmvkZK/xkO
   rHMbkiwHMPTqIDrQ+QKdNP4VFNtEgyl6kEb4q51mOBtYsN3Qvmw5qeuTT
   3WDUQfxD0+IBIubyKeG8IWDa6KvLFMKcMHtLllKOuZl9AKQ9fjl2o7JTP
   w==;
IronPort-SDR: SXQovlTFFl792uift427NVhmA1oD8LOmO7yo2e8VwPjVgjuJa0nLaCdN8N9IvGNqjBjmNyJj7n
 TAruDbv/fzyZjpd+cRHk81Fj18S2s31gn+nK2C8yLg4+QPssOnLUiHnB0Bg7O91ws3SlROoP9T
 b9eK7NOIkr+WIahQQfg0pYhQ5wetOAeseXQH0bKtocPL+UwZKevhAzG8oqwCjtZNvLLwWsKUbr
 QpM+rU6Ku+fYQA9G2s4mN20T7Slw1qsAm0klHk41vf6uwWncSsVdSi6lZd7joPf1elbeTSy0+9
 fmg=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="178504701"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 14:33:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isTdRn5JyhAx2h0pIK7lMSr9a4JTbcRluaRP+xnq1Rqox67D9s7vClffi700CZ7d56loxdawjW+j2U19+nE8XIJwyXFJoABe9N/6RBQdnKax6cC2/lz88BOY3iUCp8jx5GYg3LJsoXrcUFQw0cIAigTVKayWAmN7krI9bH5s6O4C45l4IO3SJx+ip+0M93Xm75LVCAPsRiIPr0mfKsfMYdJGEiBsfvoRWqUQRPsy6IJegqbEJtGR2HGsARCV+bYXT1EBiSmBiWe1a8B/3P7m3Dx6IUAz5TebJvlQpWhDTgRRPmdBi/tPCifKeH+l2qM4hHs+0K80JRcJkUP9c6eUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paEKLzmesvRi0B9LfNu5QqpjAW68her/rQGnDyYZLxg=;
 b=lthbWm14Cep0tlXlmzMHp85RVdVY+9rsd6Tc5xv9Z4gL8Se9k++OK9FcwcaGeJYNRjdwUmZbOunjUXmsMN+y7m6aKJ+yvWdWUef51OZBPxaj5hazG9/wE/euqoSR3goRQHi7XeMCrtSzKszsAlrHvendqOc7F9vLMPqMvODXTsvQdKy1Bw4zZ/df10Hs3fO1Qh0dh/GN6Ea4fxnNX3xbdo4Yc8YrOVXzOd9aC4bnLwjIdsJHSWMD0hhCR3TV0I93uZOVlMMMJhvK6IOh3mk5AoxKbghAumY9T91Aw1W1yrdW6dgoGsJV4i6rNfDcAvr8/dh5+zIY2CW8cO3F3vekAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paEKLzmesvRi0B9LfNu5QqpjAW68her/rQGnDyYZLxg=;
 b=rOVvoNERQRumt+AJozkIO+Qxrf4LJ2rSbQbyLOn8SDlmgHdaPkF5L70GA1mN9Ai3gUnB5cJcSw+8QMgo5UL3JoSIjqT1kE9M6dWRBHphilqYR+WmqOuNmH2gDENBEutbLBNK6+miui4Txwsnl0bibCrkeYsiZ5smpbXcmAN3UKM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4426.namprd04.prod.outlook.com (2603:10b6:5:a2::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.24; Mon, 5 Jul 2021 06:33:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 06:33:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 07/21] ufs: Only include power management code if
 necessary
Thread-Topic: [PATCH 07/21] ufs: Only include power management code if
 necessary
Thread-Index: AQHXbr3jMnxoa96Wj0aJd27JZ3PPTKsz8LYQ
Date:   Mon, 5 Jul 2021 06:33:14 +0000
Message-ID: <DM6PR04MB657574076FC4E3FDAF5914C6FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-8-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d10aa1c-3f36-489e-baff-08d93f7ec4a2
x-ms-traffictypediagnostic: DM6PR04MB4426:
x-microsoft-antispam-prvs: <DM6PR04MB442666925E483631A893D885FC1C9@DM6PR04MB4426.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWeTqRho/L19EIQqJXR0hJFgi/ZkPj3Au5mo9R3calMftw/6CwHpYDTEcDwDEL3AmE3OQKOtmpK5ciFvOR85xDUJJQeqWy2sGcMCdsbjUOZ5N/BdmbAcJp2WTKurcBwqzSvN9OK+ZCLhGBE4D/INU8JIzW/crzQgdCWbU4O+lYdOMLCYXBdAQ3jFShPF0Zgey+EOP0rzkV2tF/w4YEQvmYultniS6zMpc70a06uVg11K4Ip0woNVXAId0qE17osEamZ7bS1pZ8XXUWb5EH/SAIahmvOduYEZlxytELMh9FQsUbBhnmtJ3NFvfp9Sv5eGRXs+Ax1tFSbVUclIkc4ssz4w57J06vDli7X1ge+/oOYKnYypCC1zEU65qBNsPddz3T+cDWAt8hXrGlr7yNqa071TjjFG+MVtJq5GUJSElfMe2VohcmST3N/jJugXl47psg3XxWkih0ZGCPX5UGrzX+s750WC5AkYAD5uB0lAQiMVSaS+JEaLdGxLUBapb7j5SoqLAX7Fixz0ou7Z2UubPnMBQuOm4FWYLA1M6Zu2aLnTtLsv5bGKq7V9GUhpnLu6WqHMS/6DWTMuQYbfEHEc5ahhoaQrDTchlq0hOSwdrUSErdh4M2Nlm8tIvP9WRwZFzJJUgBQToZeI5LdmdK3tuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(33656002)(316002)(86362001)(66446008)(478600001)(9686003)(66476007)(4326008)(64756008)(26005)(83380400001)(7696005)(52536014)(110136005)(6506007)(54906003)(5660300002)(186003)(38100700002)(122000001)(7416002)(66556008)(71200400001)(8936002)(2906002)(76116006)(55016002)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zIqurLWiLyuw8ISsCW0tg0b9NVgsagtPcI3uisZ/aMgCur6rcZDzr8rDSwFf?=
 =?us-ascii?Q?GUlJ817ZRibsCCC+/K8FugNnt4FVwffQMNfnZZ9FzTnKhMLd+YB5fkpp/AIq?=
 =?us-ascii?Q?1yowgxrQAy+ngye1LK6gjjjrFZvyB1furOkvGEZ3dYHqoI9NAOVFzPuegOJU?=
 =?us-ascii?Q?H7fMGmygYPXBzf2qnA2EAR996Q2qA3tGz+38bnzMtPInjxICTmuE+DOXOAyr?=
 =?us-ascii?Q?o09Sp+50uAF8ynGhLw/0X8aN69K/aaYJ7Ew366d0r3gqWsc+NlGUkwbb9+wp?=
 =?us-ascii?Q?LpcB4uY2yUBqmK5Z4l9u60Zo22/cvqXZQU4mdTKcvHmCX8sws5JGE8U3a7z+?=
 =?us-ascii?Q?wIgYwnKGvuN16nn6k9EPIpSmH3lkVzm6pMDYAjSNlS1hhRzq20K6MrdVllLe?=
 =?us-ascii?Q?iA5PzcJSqGKkgVgkZLzZGJ2e/9aqVIylDJNApPk2h8VeLAf1gfiYisI4FmPT?=
 =?us-ascii?Q?SJEN86flDjNoxhBXnFA6ce2R9mIu3ZftxlQxHigH9XzI5TCwvpriW83+MMN3?=
 =?us-ascii?Q?EKVs8tsIZ+gFYFF7HthFepmJsgS78T40/8hSTJbBQPSWWOn24+ZyFWqT364q?=
 =?us-ascii?Q?E7MRtFtPXJ/KAwNnDQpupKA87E4paTzslj9izaSQIuXe2ynVmKToAEYFa6Sp?=
 =?us-ascii?Q?MQFRog+FFaycswRmishBsSAYH2vF7dUsFQG4+YSX4D5Fn7a+JAIzh/yVOLdu?=
 =?us-ascii?Q?nTXefmQCmi+ySEu5IMb7gxJz6H2cNi/6i57/9oLFjtQFit+1AL1qbiz0q0ta?=
 =?us-ascii?Q?nCVfDW8Y/GPbZ8nk7HAO0VhgaDIk1GnpKjx9hjnfXIuVevvZP8HfT4uufaSb?=
 =?us-ascii?Q?UNVk7saChETpccNgZDxK1F63P/U8D7RuH2VVDxMhwp9FUFYucxs7V6JAhzhR?=
 =?us-ascii?Q?tVBOwsiDYUXbEdAFjApnGzXVV71ooV4MKhu2bCtMLrQj8UagF0Nh8dc2QGvO?=
 =?us-ascii?Q?4udoBtL5kWBT8tXQVvAWtqY04gZkL7GbzNNQERYxXn4envnts8i6A5+7OuLf?=
 =?us-ascii?Q?AHLeKuQCKQkPR59vNZfh8/LQE4m5sBbJ+CbQ5W6X/pA4L+SkmYzJrvmjQ8n1?=
 =?us-ascii?Q?JA+HkrPqSA9re8VqsT67+4+L8PI/CRRb9iuhdmQnW2u9QN6rJrSznnJOeELg?=
 =?us-ascii?Q?JIVKvcK/9Vh2yeq2BOxD3LBofnbEhOGqJLI+/8JHYc8u/tDR4zrOUBvXPwS2?=
 =?us-ascii?Q?ZwYtQoifRVj/+078BBjYFtmMYk3KQMbXSm1lGUUYqmzS/5Ktk3aRbNrQQukQ?=
 =?us-ascii?Q?FVxxGxtlGfgtcFWmNMS8Jvzyg14Op9STWbGAnCItBOX2VXSpwfKsDXuj04Xh?=
 =?us-ascii?Q?QzLI9hAHpctDlG4sgKIAXXCO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d10aa1c-3f36-489e-baff-08d93f7ec4a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 06:33:14.5391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6XKw6008CkP+pdsPfsVXfBsaBh4xCH3z2POVslLWuCaWofCGLgTwAdpBMJkgzWDAqB/1mVYnj1jRQ0qkZcMo7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4426
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> This patch slightly reduces the UFS driver size if built with power
> management support disabled.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
>  drivers/scsi/ufs/ufshcd.h | 4 ++++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a34aa6d486c7..37302a8b3937 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8736,6 +8736,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba
> *hba)
>                 usleep_range(5000, 5100);
>  }
>=20
> +#ifdef CONFIG_PM
Maybe move this few lines up to include ufshcd_vreg_set_lpm as well?

Are there any ufs platforms that doesn't use pm management?
Automotive platforms maybe?

Thanks,
Avri

>  static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
>  {
>         int ret =3D 0;
> @@ -8763,6 +8764,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba
> *hba)
>  out:
>         return ret;
>  }
> +#endif /* CONFIG_PM */
>=20
>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
>  {
> @@ -9165,6 +9167,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>         return ret;
>  }
>=20
> +#ifdef CONFIG_PM
>  /**
>   * ufshcd_resume - helper function for resume operations
>   * @hba: per adapter instance
> @@ -9202,7 +9205,9 @@ static int ufshcd_resume(struct ufs_hba *hba)
>                 ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret)=
;
>         return ret;
>  }
> +#endif /* CONFIG_PM */
>=20
> +#ifdef CONFIG_PM_SLEEP
>  /**
>   * ufshcd_system_suspend - system suspend callback
>   * @dev: Device associated with the UFS controller.
> @@ -9258,7 +9263,9 @@ int ufshcd_system_resume(struct device *dev)
>         return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_resume);
> +#endif /* CONFIG_PM_SLEEP */
>=20
> +#ifdef CONFIG_PM
>  /**
>   * ufshcd_runtime_suspend - runtime suspend callback
>   * @dev: Device associated with the UFS controller.
> @@ -9306,6 +9313,7 @@ int ufshcd_runtime_resume(struct device *dev)
>         return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_runtime_resume);
> +#endif /* CONFIG_PM */
>=20
>  /**
>   * ufshcd_shutdown - shutdown routine
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index dc75426c609f..79f6c261dfff 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1009,10 +1009,14 @@ static inline u8
> ufshcd_wb_get_query_index(struct ufs_hba *hba)
>         return 0;
>  }
>=20
> +#ifdef CONFIG_PM
>  extern int ufshcd_runtime_suspend(struct device *dev);
>  extern int ufshcd_runtime_resume(struct device *dev);
> +#endif
> +#ifdef CONFIG_PM_SLEEP
>  extern int ufshcd_system_suspend(struct device *dev);
>  extern int ufshcd_system_resume(struct device *dev);
> +#endif
>  extern int ufshcd_shutdown(struct ufs_hba *hba);
>  extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
>                                       int agreed_gear,
