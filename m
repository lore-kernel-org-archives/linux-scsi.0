Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A353DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 07:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbiD1HT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiD1HTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 03:19:25 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA299972E2
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 00:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651130170; x=1682666170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PPNkVNxY7NO4X5jKPeE3sMIhIwSBd+SYC86bAWByBmI=;
  b=AdObR22vLR/jzGGqxZlorI/D/pQFaTVCcIafHQ+dcQIpIghF3f2sBqId
   PIWbJ0vWx8nxXZYWNqV6dUGGaW6rTxiiwXdfzhUGTYJ1AUJ5vTz4Y++ok
   6kO0LhdWnthvd7qGPeCCV4itXYW3csSVxSQxqWEbHMQyGr2zQfUpiLqWN
   vVYY5vzfYyQH0VZiER/baxy+7pldwhlIVuUWgsKdthoxYZQ+QXS+Ob+Ls
   xvEhKzY6UNAWfi1CFKAyqVaYGuWCX8KhjaBODprk3zJER4dnMog70VV4a
   MT6N+3H2A4kCVihJSMFkY+iGaof3XvMNFW51SRDOiJzf/qfVI20BjxG/7
   g==;
X-IronPort-AV: E=Sophos;i="5.90,295,1643644800"; 
   d="scan'208";a="197875642"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 15:16:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcOw3G/HVOjzDoBDqxQeZigmBqJffdU8p/sABq91Jcqp4/kkUlGMxMIFwN32aMh4/xuP9oSyatXWsNWt2NPFlf/omuJlp1l+efHplItD2hRGd9flfvfrPa4SApbP5g8eHKDdnPzBBTHLRQsQ7u3feUI9xzM/+JLO5v/7J0CpAUszUrvPD2dJle/usr51VClCxIGrOibWoQkFYjM9LRwit1aL8wbVtbI8Ahvac7Gbc9wnIIq+BT6csS270hItA4ca6B0NAcMmgino88r19H2BmuWOZWCiPfYmCRWT1d7lfdzBOj3uQoAZWSX1podfHoeksUrXm+WoR9+BXwGPmAS2xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdZQw/6RrECM7phS0FzQDzl35yl1oPUVO/DUptqDSow=;
 b=F1Ecg9iuP90QBmTZtt9bvldepx0+9yfRRx+BNz3VGfIiYB/0Lmp0hfWDUf0K/ExTVmp1P9ya3KweOo3KDm10ICzg/L0AG/2HNgfpUUl9kjZIJKsBzS/nMTOJkpE8y5TETa6Knl5KG0Z1IjhWZjqUYUJ024BpMpCriQ+UaX9Rc3Tlp9lnz4CDtVv8u7eDguAxOAYVyZpDZ4hjthVdu7aI7PVKHB6EXoDZkE7/ry3BTe/t50GJeP6tuWCj/LqpfJDbCJQvpXUMQcry9jtbpoo5IC8uqTRxLaFHeAPPsCqKRfU+yrsqUS2K15z21Kyjs6PrP/ukc8YchhKEUmFzXteUlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdZQw/6RrECM7phS0FzQDzl35yl1oPUVO/DUptqDSow=;
 b=qzsxctKLaO0TBJnNBAPEez2cfvTW6wOD5xblM35/6PP0sayzIkFpGTJWAMqcn9V6cA3aPxZBE9UcSs6EMvwP8HRgAb0eju0v/L5lhi89gVw79rEQ/IV8hYmwACb5ZyLR3CV22nxNUI5M0/unHZzah5lDI1V/HzxmGeaHWHPvh+A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN6PR04MB1139.namprd04.prod.outlook.com (2603:10b6:404:9b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 28 Apr 2022 07:16:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 07:16:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3/4] scsi: ufs: Pass the clock scaling timeout as an
 argument
Thread-Topic: [PATCH 3/4] scsi: ufs: Pass the clock scaling timeout as an
 argument
Thread-Index: AQHYWpAONTz5VttOVE6LQ2eRDj8SBa0E6lJw
Date:   Thu, 28 Apr 2022 07:16:07 +0000
Message-ID: <DM6PR04MB65759DF908871E546AA78E28FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-4-bvanassche@acm.org>
In-Reply-To: <20220427233855.2685505-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b554348-7d67-4f3b-c7aa-08da28e6f6d4
x-ms-traffictypediagnostic: BN6PR04MB1139:EE_
x-microsoft-antispam-prvs: <BN6PR04MB1139CF0E59EB22B0024CEED5FCFD9@BN6PR04MB1139.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m7AkO7kfIdvTMCmHGkEPm+jxeviLSvQUNAywqCCzNUrvcFlhZItU8cBphF8r7dOxyejabcxCp1zyYb4J1AeVna5WHIcBVZplYRTcisnNzTqzZ3aDkcjpbmlvboAR64cotZP3EIGbSOOwAr9E2mmS/BvBOmSWxOK6biXXLp5pAPKpgxjMb6+zfg1Q8mayYeZO79gQilFclJ9F2IDlc/GxMluQg+GXCzTqjxIaDK3ZkmePPZGs7gNiGulzcXz1Ln3HQ58ZLak/Dv3Z8eM6djY9ynp7ixNtCmNnrssumcxFBbR4+QjXpFKQMhkgYB8Uhzih4SZaVDpeDnf+4NEUQrkOfA2vgawO1/iZ1wkM3H1LyD2F/VVlRbW5jerVW6E30OVbS/UMv+xt9u5MH8IGQiFDRJG/2gukCXrVQpnTfgVmHwGNRZbLZO1G3LAWKG5f4HHiFpTVFavWMFje6n9JonA9asFyNOThRFWwtJWf4yAT67xiDSfIqkcMreXQP26yR2KwMfWsPubaOF6AF/72D7O3ruHJYZ3Fk2LnLd/z87dwjEBIyv3pv4+STw1HvxlX/9Eg1q1aRAfY79YVPNzYV7CCdueJT6Ctm/k1yD1DWcoIB8l4/zfOJpBzFFwIa3eBBD7ccNlhekHPKMvA/ckJowiM7aAemfLZUXqIAYAF8xLRmhaBd1dVtOAmfmfPQgNbWT6qsxTmUTUTFXGyT/KMkkrBIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(7696005)(508600001)(71200400001)(86362001)(2906002)(82960400001)(38070700005)(38100700002)(122000001)(186003)(83380400001)(110136005)(9686003)(54906003)(316002)(26005)(8676002)(4326008)(6506007)(76116006)(66946007)(33656002)(66556008)(66476007)(66446008)(64756008)(55016003)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q0LiXD3c9akJ8iEjY2OQ3ozgrPve7j/AgH1MpQDFTaso/dpJEtlHNxyM7iEZ?=
 =?us-ascii?Q?w7mSRSVpQPGXaXEinVoZC3ZVk75otzrdgjEa3d0TtoBcO+/4qI1dkZw043S5?=
 =?us-ascii?Q?jKhuh3p7Gg7FebtbuLRyLnn2jtUxkaDORKGvfamAgeUQEmqSJqdUM+A+dlNv?=
 =?us-ascii?Q?RMwrfq/GwGcDdyu2biLbDRWNFGX2WHYWBEVDk20U0EAvQiv2TZFKnN+Lhg/r?=
 =?us-ascii?Q?bAyRGJDNCYv0cvgffu1MKXHfAwjbO6UAzU/zK6C1/aNP8GXn5A4hz9cEHdpu?=
 =?us-ascii?Q?UCLWhNv/lA02jElhovLi8pjE5DVKyGWfd5EGBvld1agTVt3Z7ti2oHBisexd?=
 =?us-ascii?Q?BaMxosZQDtEBTq+g+sVo48Xro2k9wVj3VhiV35ye4DNQwtILHNQRj4qqmVsX?=
 =?us-ascii?Q?b01ia0YVBWVxHPMCE9KO3KTfkFPCw3PnHQxNADwycSFB/Tgq/3ehHdY9TxyX?=
 =?us-ascii?Q?oErwMJ2vk41DMMKbX1V1T6wtKD+kiPLswC6WmmSL1Cqi9wkWPj/RZX9EJtSM?=
 =?us-ascii?Q?mNulPDo8MBDIlV5rQW6qUzfiQSJJnDVhTme+omYdUB0To9KTB97PI63xs+R3?=
 =?us-ascii?Q?Z2w+7IobRkjCjoHLIFJhuau0u/tvdy9FzrCN5iya4yK/JHHKsWMB6JwxicIt?=
 =?us-ascii?Q?KlTWq/CGOhi1MaIpHRFyJl4jmvHS85QuLLyjIOl6EeaEQlI1L6vL/Me7RsnC?=
 =?us-ascii?Q?N9jK8+l7JFWqIT1Nly8giM06A5Hs7jGFrhedekOsqdQnekeJkQO0CzP/+/vk?=
 =?us-ascii?Q?EbMdeP5/XMl7PoG7+W2b5+gD42b/KD057Hgndcp62ZSw48OfNYxP/0Xdau2m?=
 =?us-ascii?Q?tHaxGSc0wgIwbYFACNUeuLJHYv7PyGCPD+6bjpCwCZhwf/6kLyMAEskVao7R?=
 =?us-ascii?Q?7Uh2f9UJhex5F7XzojRnuRNggqZ/4NAK58YcEA7QnCWkyTQpJzCNJnSVIwkP?=
 =?us-ascii?Q?W5o5IgF0+AhuIKWfpC8+allhiGtziS6kF65x/faz5DFMuOs2n5lxbyH4d4wW?=
 =?us-ascii?Q?H39QSOYs0Ho2zoOjA+pVJhx0yubmnBtrq5jv98wiq1ahWQ8q5WrXcInxHKOF?=
 =?us-ascii?Q?fr7B0rzvVuSEsxghwAdOd2dgAgqzzuBotAQaSUfKskt8jDx54CNWjEsSNBLD?=
 =?us-ascii?Q?CxoOgivqL/txPMgGNHIxgSm6NjRDkGuXWQ7Q8XqhL1eEAgfIW9pon2Lm1JV+?=
 =?us-ascii?Q?T4zhvLJhTxce9hlMhTi/g9VhUMaFhoS9Wa7SAhOwkqr/D4MT6HCbRSvFvUod?=
 =?us-ascii?Q?tzfzxLKKA9l5Jt8vSAKmfXfIHI39nbt6ijKaVwiuQyKLteJ+NTZc4RnD6PnF?=
 =?us-ascii?Q?nGL766jkPLF2o2ao8Q3/q6tbvl3nzFo8iOMiW0CF07IWJoe9gCADO9Fd+2GK?=
 =?us-ascii?Q?7zfI4bW8vsnAAybIsqOYojjoSbkc/ykBhHTv9g89Qg7dSG5OeSMtAREOTVcf?=
 =?us-ascii?Q?LXIXA4UqtS+vbBK+sifLYcONf3XM1+wkTbQTEwnNSGOcw738k8XRjpduisV7?=
 =?us-ascii?Q?u1oBErdjaFAeToSj9RAb5rIoK1cu7+Va5G0n9rkd3VzIzMAYk2/WJZppNA6a?=
 =?us-ascii?Q?gCWLhyLYfWjJWxtzaoXgjIlzyHxjzC8UdCJxPG6kVG7pIxuddOo/h+n7KW+E?=
 =?us-ascii?Q?g3FLcDDuq2txQhU/LgnQnH0suwZZH+S0vP/1NW75Ni4GKW5sfaci10A098za?=
 =?us-ascii?Q?sIMszDFNBO09QUw0K99t0VTbdXL3lDME9TB5Htjb0Ar0tihPKKShKtrhfrRd?=
 =?us-ascii?Q?Yd9pVSJQ7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b554348-7d67-4f3b-c7aa-08da28e6f6d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 07:16:07.4606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFkHusAkwQIW/Dvqf7aTABxoWYfdK08l3sFC4AAVU4fufojRUpisWJKsJf+7ka3d17jkb3tRp5TEYmdszlPoRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB1139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Prepare for adding an additional ufshcd_clock_scaling_prepare() call
> with a different timeout.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3c83f4049031..60ba11b68735 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1108,6 +1108,12 @@ static u32 ufshcd_pending_cmds(struct ufs_hba
> *hba)
>         return pending;
>  }
>=20
> +/*
> + * Wait until all pending SCSI commands and TMFs have finished or the
> timeout
> + * has expired.
> + *
> + * Return: 0 upon success; -EBUSY upon timeout.
> + */
>  static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>                                         u64 wait_timeout_us)
>  {
> @@ -1212,9 +1218,14 @@ static int ufshcd_scale_gear(struct ufs_hba *hba,
> bool scale_up)
>         return ret;
>  }
>=20
> -static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
> +/*
> + * Wait until all pending SCSI commands and TMFs have finished or the
> timeout
> + * has expired.
> + *
> + * Return: 0 upon success; -EBUSY upon timeout.
> + */
> +static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64
> timeout_us)
>  {
> -       #define DOORBELL_CLR_TOUT_US            (1000 * 1000) /* 1 sec */
>         int ret =3D 0;
>         /*
>          * make sure that there are no outstanding requests when
> @@ -1223,7 +1234,7 @@ static int ufshcd_clock_scaling_prepare(struct
> ufs_hba *hba)
>         ufshcd_scsi_block_requests(hba);
>         down_write(&hba->clk_scaling_lock);
>=20
> -       if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> +       if (ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
>                 ret =3D -EBUSY;
>                 up_write(&hba->clk_scaling_lock);
>                 ufshcd_scsi_unblock_requests(hba);
> @@ -1264,7 +1275,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba=
,
> bool scale_up)
>         if (!hba->clk_scaling.is_allowed)
>                 return -EBUSY;
>=20
> -       ret =3D ufshcd_clock_scaling_prepare(hba);
> +       ret =3D ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
>         if (ret)
>                 return ret;

