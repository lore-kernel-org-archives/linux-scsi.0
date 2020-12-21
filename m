Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46CCC43381
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 18:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7522322D49
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 18:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgLUSG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:06:26 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:7049 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLUSGZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 13:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608573984; x=1640109984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=amZvUOWFS7IiUWuBRcLWif8pzVfGOJWWQH/Pq3DZHjs=;
  b=JkaZDGNkaGmppIXk9QQtV3HKjkL/X+06FBfw8ZDhCW/Rk/T//8PvWpwZ
   kUW2RAWjiZDZ/20m0YncVTOWT1PMO1esk+do8jHQoU5T+ZzOJ6RCta0z4
   y9vCeZfzKsHY6BNRnzT89gDdWVaH75624MtK3F/OYJHFYJQNde8WFxd0s
   xfCipVugSGzoUkzyRwHcoL9DnPGo0qlmTfRiPsqvG2FrzC/BYBZo94hrl
   UZPs+W/4fdPK9CpY6g1EhPc5HudZDOIEuACy7wiSLyY61aqkpt85p5IBx
   xGWONf2vl/nrUYzdyjsx5u55sC2/+1Tanrt/GRligLHPHvFfK7yTF28kM
   g==;
IronPort-SDR: FC3PEtQhWkYzFjB9I8HuxR/PWdHHhtfeTkc+0k8/j+vU+Ly+PTHM22O3SsGelhSVA7FSxSNMPs
 GAe9qyvSAKpSlqS3c9w72ZyJ7r8I0lsw4OJZY0QBGR8tSTtsGB3CmRmC3qPhtXoBlsUKumBLFE
 ZQLlr8muvByZu/hjdsD6Yv2rE39AK3narV4LMC52bOt5YZJz4qAwyD3ebryItE3z+TJap9F6Tn
 +LdNP0zPZnpfPbNQ9R8b9F0zM9+F/T4REoSpmaTAvIrASK9FPxptYsfzmxEenFQoC8hBtR67iT
 ZM8=
X-IronPort-AV: E=Sophos;i="5.78,436,1599494400"; 
   d="scan'208";a="160153291"
Received: from mail-bl2nam02lp2058.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.58])
  by ob1.hgst.iphmx.com with ESMTP; 22 Dec 2020 02:05:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tza749vIEookiULJygiQIlaJKdiCWOcQ3gidzCby9isrPG83ZNpwXgXVvS6OVfSldJlS6ktoGJc8mf4TrO+QaCD2RaypC5CU1VFFwQduXyEqE5b4ioNO+FD/pwD4rmMuU6Rutr1E0TiVdKVgdpYcrtX4Lcn4OXSfxIiPSQMh/myib7PivFkl5hkVe7Di4Vfqihq3ymAcJNbYkHwNHrSZzZ2Km6f6bCIAYdaxhSRRWD7xtm/9hDieQNmPb9XUa7SvQOoWlMPvwVABoGqo9ZOMN6npinIAC77jG4dqogHuiXZaS77gyuMrlpWdonxYbjx0wFwYGG/7MsWyGIKECARhiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdLrnFCV308jA34zsSY2qWNxJnj/SFLYF8fpUQpLihY=;
 b=VcQkGGcr89YZwiSJOQjbGLF60p4qmaiQ1s6NBZ5DzPvSKgtGcF795Czo2MM2/cTFsWA3/0XY6cZaSammuUribp3aC0fcdcTw9a0FQpOX1Vkwo5snjghaHRL2koHn2bH/HsMJ6OYn8Fg0PMDcVxOR3x0oNz98DPTw3a/1WU7htnK368Fr7Pm+nq4sxLMyzj5pDWw/pxpM+sYHI4cGaSIPTY0uZIuYYjT2oDrTPKNZh0vrPdFd5V7pLoPZ22cvsqzrQhke22/uyK7nSsbI5ZeHx3EzfJG1rM5rwW+7rj0TE9+MPNdsM57JWUH3dZY2gi1+3RXht3M14nhEzH+IYyqSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdLrnFCV308jA34zsSY2qWNxJnj/SFLYF8fpUQpLihY=;
 b=q6wrWN90Cpc6d1q5AgJGZBQ77d033ngJ5C7S2l8Qu0AG4tDhZHfKFxbbbGegpPm7AadVY/tMQ4yacy3uIpOjoVPxtOiRxCGJtnXKfJ8Hc0vXwhrsgZTU4ffs9urvWfPjNxnvnKKF2QbOlqYtqyF8suKBYI4/g8DUYAGhSgXcwFg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5082.namprd04.prod.outlook.com (2603:10b6:5:1a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.25; Mon, 21 Dec 2020 18:05:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 18:05:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Topic: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Index: AQHW1O5Lq9Xt0bukCk2VnSNzzSWPAqoAjHbQgAEkMYCAABqVAIAABd2AgAAK2YA=
Date:   Mon, 21 Dec 2020 18:05:15 +0000
Message-ID: <DM6PR04MB657558D8353199D53586F654FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+C9+1p1CbssKRdO@google.com>
 <DM6PR04MB65753B9D31B3643C757E4E23FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+DZMwSHsskcEgZE@google.com>
In-Reply-To: <X+DZMwSHsskcEgZE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e4901311-49a1-4646-4abc-08d8a5daf7df
x-ms-traffictypediagnostic: DM6PR04MB5082:
x-microsoft-antispam-prvs: <DM6PR04MB5082056671CEFEFEDE35D9D2FCC00@DM6PR04MB5082.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2i8hP1j1P7A9n5lWdtaQXdylYogxbMIgYlNls2u6KH9BszymdsGEJITlos6N7XRV1OdZPVKRT0xxDndhIlcfzWYw80/1FgmXByNz7zRRsoLufjPocFxJDxO6utGI2w0dP0MJge3w5o6MlYSaI+q0Ya5rnEVVyri8jk95yBl8G03Y1IU2XUQ/FnVqQB1ndpfpzfpBoVFllBqiroXYfpnZWYRk47udSZ7HSzZG3t7GOLw0HbXrKD2U3NG1nmIzpSevDNSehhyL0muVyVVbr+d7yTi+5qKwmtfYDMdkpVsumxFtt1i7AEkyqbHbtbRFS/Yb9sPh1Se74T27KNC6jVZtV7hQsbRvm2CoRbRGdTo0CiDXZoWMtrxSljR5I1TcDYB0uB7Ynukmy+TS4UGBpsukg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(4744005)(2906002)(55016002)(5660300002)(8676002)(86362001)(186003)(4326008)(26005)(52536014)(66446008)(6916009)(64756008)(6506007)(8936002)(7696005)(33656002)(71200400001)(66476007)(316002)(66946007)(76116006)(83380400001)(9686003)(478600001)(54906003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NlZAnDZrBbZpa1JFDV1KGtPGgapX/YmseJWCiWSFzOZyduavwi9kaKCfv+0P?=
 =?us-ascii?Q?cilQ032cvq0aiISNYBP0cxAfavgTB+FQLvhS0TxThcl7Gk7WzT28yHaPD3WY?=
 =?us-ascii?Q?H5582Z1U4nrxvF4UWn1kZKIdyApyyNgVIunVRd7NsvIkTH8q8OI5ID1jBMmv?=
 =?us-ascii?Q?PYe0xXomjkQpOi/P8Rtr7YFv2w2gPa69hqK+bH8ftfVwVAFW1WHag86OBJmo?=
 =?us-ascii?Q?j7vKk15vM0elH/7S7rNRngm1px/jCh4cCJ9kupaO4A0gdAytSVKXv6aoQUqJ?=
 =?us-ascii?Q?PI2s9F6rp1XxGbdFR6BvsVdUI6+fzbb1GYe0Zu/YCs/uIkKdFqlYpUH0v8DQ?=
 =?us-ascii?Q?GNBicym2XiMMzr2fxlrdZTNYcrtz4rQ2gHs3wg7MhlZ+8fb9usYS4nee5Mq8?=
 =?us-ascii?Q?Sn1lQQoH56yBvdsmx4f7Z6ehfDMzqVs7D/EeN9nB0RaSMAAzXU8jir34GpXC?=
 =?us-ascii?Q?LnDtUGlWoeYQhOUZYeH4Ik3KTCSTM7LMOQzS1saJe9t64mqD1/FjM8l2cU5D?=
 =?us-ascii?Q?bKmcEtuLvL2gjydty0I4vVtfl0wcd3ELRgqK5eE+e6cVXdVVVX2FLURRtIf0?=
 =?us-ascii?Q?+qkTbcjtp4L3lLPzQSN0OwsS9zUztJkJXkIGwQdi6Tr4RkE/RCB7ArS1s2ac?=
 =?us-ascii?Q?9nVgMYL/awWhCSrFmzufOLlpQky1i5rDXsWIW9TBF3m7HjDUNvdKCfZSaZIN?=
 =?us-ascii?Q?rkkBKPhRw2OzBl+YdeEXEksqeagWMY6tUXshvjwgTF3cYqlvKP1jho99hu+m?=
 =?us-ascii?Q?UWtYt9DXTvAPrHnTiN9IJcTPOfOVx3ssPV3QWCrhdq5BV25rp4hQ9EDPKkZv?=
 =?us-ascii?Q?I4J2nIpDTR2A2TT4L8lumrm0nDJdX70Ok2TzmaXaWRJeqYJIkgWUKKrk7DrI?=
 =?us-ascii?Q?Dr2JOIuvcLH9C0u3R1Ss1svsbjgFZanf+bvYv7dgLukFTygQSEwS13YgXQzF?=
 =?us-ascii?Q?REj4v7VfenDqLUTXmwi8Wynw3vi+rmceF1IupGSd82c=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4901311-49a1-4646-4abc-08d8a5daf7df
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 18:05:15.2367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jTicC7i2MmbYYD0OAcrMe/Dl1qt5fnHvDpBXUvatalBZBeYyUG5TkCF9EjJY0RfjY6oG7aBySdkWe5fNqaGcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On 12/21, Avri Altman wrote:
> > > > > When gate_work/ungate_work gets an error during hibern8_enter or
> > > exit,
> > > > >  ufshcd_err_handler()
> > > > >    ufshcd_scsi_block_requests()
> > > > >    ufshcd_reset_and_restore()
> > > > >      ufshcd_clear_ua_wluns() -> stuck
> > > > >    ufshcd_scsi_unblock_requests()
> > > > >
> > > > > In order to avoid it, ufshcd_clear_ua_wluns() can be called per
> recovery
> > > > > flows
> > > > > such as suspend/resume, link_recovery, and error_handler.
> > > > Not sure that suspend/resume are UAC events?
> > >
> > > Could you elaborate a bit? The goal is to clear UAC after UFS reset
> happens.
> > So why calling it on every suspend and resume?
>=20
> 1. If UAC was cleared, there's no impact.
But the command is still sent.

> 2. ufshcd_link_recovery() can reset UFS directly by ufs_mtk_resume().
> 3. ufshcd_suspend can call ufshcd_host_reset_and_restore() as well.
Seems excessive IMO.
Why not selectively send when indeed required, e.g. on reset?
