Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24FCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D70613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbhI2Hkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:40:51 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59480 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbhI2Hku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 03:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632901150; x=1664437150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o1DLswf9WUeW8stqGVTWoSxmRNVTiyEbs8vjWMiVocQ=;
  b=i5wZ584zzADMEshr7U6LmhabL8s4vYs38tqrFm4VG89gWmrd999bnuW7
   LfqxZobk/HEOoFb8ZD/w/VChE8UHsJvjIVbgCIv3QIgpJ0CH2lUUrWxvR
   5/8IEhlH4D8TZVxVBN03e9gnJcO6KCPmlTa/z/BXv5hdvIyVF1cH7iX7G
   lg47l8LUUdsiNUzV5HyFS73SIJE1C+NvOlGe9v1aa3JLjV7FC3T/QvkNP
   /oSoCdAUhUVn/6UfuYTby95CJ/wD2mQpSUHdjNijLfP+jM/t1botK6bPl
   VGVKh4WJFqP3xrXFil63s13QKF8Xa0czv9BL7mqrMDptmuStO7xwyLfL7
   A==;
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; 
   d="scan'208";a="180332821"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 15:39:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVG/PboFzHl7hlULAMLW7QDx+R0Dw0cAJvOa2qAdhsPPlFgx+w+/QL+KmiwdPh9Vr1krQA3vdbIaQ9It0f/AJ+FEHYt2meX6xVh79yLb0zh+FMTfMH81BscUs9R+buam+97t+oO4IeWZfQ+1JQrPB+DEPDBt6a2bDyOe1uB4cBGeffxhbu+GXo1b00yGzW9sHbbR6d6ao/3H0gcxe+50sG9tv7LgfbkaXe/jS5uciuByoG3uO+PbRI2Hzz5BCex22eF6XN+hOR2oMHD0oyalEpm/bF3lYl216IQALB6B//G+Pwu572E0x472NmlSIArtdyjJZSrn+DbpuZemIO4u5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L0w96rus/D0XhMs7sw9+gc0+lsi+1GenoMr6rAgSO8M=;
 b=gAEVFdSan71uZ0JZAp7jj/zkozF05EppCR0c+Zrr5Zxr3b+TYTqda/mCOtAWaOa/ZWNvr4/vse81NdVd8uYMlvGQkgW1gr7vF5ZfGhujmrjth3CsL8vdjtwIiMK3T/j2c5u0BvHKXp1yfvBOqF3Zq6of3y4wzf4D0x+cwpK8T1k6MTPxrzWd2x+CTJqAvrae+SsLxlddwJo9X8zvAKi2eRMsDy8mmIrbyw0yMDQkh8P53ze4MEolaMOra1kfIw6xZ8vya6kI/DxQqKmn31hmblrvQyXAEd15hwJ4tqJswlLr/5/lUrWv+p9MT22hwkMQIlq/dt3yDzWoyfmRMUDDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0w96rus/D0XhMs7sw9+gc0+lsi+1GenoMr6rAgSO8M=;
 b=BKPJHuG24IG31KyytAFGDx5x/ryPMwNhWUrMeE+wyGRcyYmuzA7vAZucZk0sLlb/oB3mbdLWehGjCebyWgXIjpA4/SD+y3klGx1fuaPos2mcmTWn4XMOKIYhzaXxz9puMcepHvZ+WQUqHKyzlL+mIaNVqd0tzcBSiAzkmyDfQto=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1133.namprd04.prod.outlook.com (2603:10b6:3:9f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Wed, 29 Sep 2021 07:39:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 07:39:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Po-Wen Kao <powen.kao@mediatek.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>,
        "jonathan.hsu@mediatek.com" <jonathan.hsu@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "wsd_upstream@mediatek.com" <wsd_upstream@mediatek.com>,
        "ed.tsai@mediatek.com" <ed.tsai@mediatek.com>
Subject: RE: [PATCH 0/2] Fix UFS task management command timeout
Thread-Topic: [PATCH 0/2] Fix UFS task management command timeout
Thread-Index: AQHXtP/PlnuRu0pX8E+4qcaocuRmvau6n+Fg
Date:   Wed, 29 Sep 2021 07:39:05 +0000
Message-ID: <DM6PR04MB657502D8172084475F280CF5FCA99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210929070047.4223-1-powen.kao@mediatek.com>
In-Reply-To: <20210929070047.4223-1-powen.kao@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ca94e4e-743b-4fad-9e97-08d9831c3720
x-ms-traffictypediagnostic: DM5PR04MB1133:
x-microsoft-antispam-prvs: <DM5PR04MB1133B510A0D7E1190ACB1C47FCA99@DM5PR04MB1133.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OSbv0oB5eUSoThR1jXmJ6g6JU7rQjPt/XBBS70gQEXuz1bpyBDMxdHbtgDaJvsMSREpO2oXgJhDGdQDXS5A/wrz2b5YLx9i21PMRjYRqnQ0jGocDxPFVjWmkrEmBDZ1Wsk12s+b/RxZYnH5K8xezqyp+r5VEanAffS6id9goWJH8UcJsmAZnoMOXy3Mq/NjB0uHgedWNG7U/N+KUwgtvwXMbP4YaoyE+wWG55e9O9/jmvUUOh5cXsE1PrG1pPHnncyE0eAFeaNHz9O93aVy1YnF2mr/BdxGAwX7X/XQ1xFAWFROr7RdX2s0nmtFeVY1ybeuf6qd0cMGNaAC8lUuzNvsxoABaFER8npmp4rm4OKetD6U0tLwcwQSnMldIeRb3cIdjCPbNptHSo+ydVa9dcy3oxOeRLR3j1tRoT/WK2ZVvtbFNxAOH/Ifs+xrpc6zjTMB59WhA44Wxf2JI+U7GAg6CM4V74vkKCEsmeQZ679afZvQMzHeZ4/0MTGQbePyotTV5/xHR5J385YnAjb0jNecvmS0IFx96LrK5wKXvME9uQ46WS7MMdL8tGAtJFAJ/LejU+WuZ8CzUGqo38AwKo/zpVfPBvoUjK4D2J1rTusGxFn8qN21uBcP6W4bDA1Lej9ta1McH79JtHsjrpQntxqsDhFZvLDnVnCy+EiuJyS+/ompTNwHIQf8d7X33vCeMAy9PdiQmd7WSY+oPsAgGmbzT496T48Vd+4lVK25S50WOwGKj/tY3/SDSlVcDRiEjRAr80AQX9+XrytWFm5hk/udc9Lip7XsmJ6UTGjcJtU8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(508600001)(66946007)(4326008)(316002)(66446008)(64756008)(66556008)(8676002)(76116006)(966005)(38070700005)(86362001)(33656002)(55016002)(66476007)(9686003)(122000001)(38100700002)(2906002)(110136005)(54906003)(5660300002)(7416002)(186003)(26005)(7696005)(52536014)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3X4oG1eGh0XoixJBnOFPN/PgV9es+OCTKNtbguNUttmRr4d1c/gnGinJclRL?=
 =?us-ascii?Q?vFs5eMD7X4nuJPtjJcA2WFuMMbdka17QQtMHgSF9IDoo6vp+tcAtYCdWrO3J?=
 =?us-ascii?Q?1ScD+OhO4mIJwV6b67yCEidiqiYz42au2GzzRqMA0Y+Hdbwq++2AX6YQheY8?=
 =?us-ascii?Q?phJKnVsoAcl1p9o+orPuFlARg1OYuaGXMhswwiuudNp6qd9yCMY1GSOfRqNW?=
 =?us-ascii?Q?aBQ2ffIbJBlmudUK/IHV/12I6FY4TTN5v77iQqh4dH3NLCvnmDczTORtIKwj?=
 =?us-ascii?Q?X6+tY0A5GtIOmf6oz5JnL7QM1lBvlp8sKmnN6tx6KKBu/jxzZk9yC9qec5L9?=
 =?us-ascii?Q?rPpjGVRq470mvr/JeboM9Bq1EYr+A0IXtHxT4mQlMqIzCPIqstsbSvNEBO+P?=
 =?us-ascii?Q?NXt3IW2+z3Ydd9gMmoSn2tPYC4fraFlS1GjRS5EZdgPJwKVM7zdTr9k+MHba?=
 =?us-ascii?Q?1E07H+M+9XMqxqFml2+CaDN/TzC4e22vKILgn4QGHaAkfALGtoziQHXAiaoI?=
 =?us-ascii?Q?4tF3ldk0dtf9XmlErpN+0DHlYeUTyaMPGhN8BrXvPy3wwOvDagZMA78VmNoC?=
 =?us-ascii?Q?oDNoaiq8lALy1WDejcf0ZLY0zdZWlP7IelVUMpz256Ubnfnr/3ouRHXZQnMK?=
 =?us-ascii?Q?doLoW37xAaP6AOiuf3v1xTEfMApu5GCy8GP2NxHHUk7mL5JLLuYyudohcGAp?=
 =?us-ascii?Q?PM1nFr6nkJCIaTno9vY+vq6Ex4c7sCVN6DWhe4OT0sNGSm9iIplX0QiYTJoT?=
 =?us-ascii?Q?UJbG+fpV4wj0dn9l11uo+mptiA+2tb0FuLzBofeG/eehBmmpVEFXSSnH5u0/?=
 =?us-ascii?Q?Fn52DL0xxtsSSHYBrnpYWczMYxZy8XgveUtQjFDbZHuPJZokI1d1Z+0MMjCp?=
 =?us-ascii?Q?UEU9gLLU1r8AbtISEPWDIv590hi+MTHWPU+6BeUJ4lTf5bIOnZUqasdZYwDC?=
 =?us-ascii?Q?Qpbvmusp7CpTkFtk3v8B1qgDBoT3lOQe4cqaUfGyhJzu3Tu7hZ9OtqXUM1tR?=
 =?us-ascii?Q?YuazbFnbeO5s6ZAl71MfalFGtsPCsdCauotRCPxAqvRU0Z+56L0QFJ70kF56?=
 =?us-ascii?Q?MwdT5tBmhxiTb38S9xdYxMwo/H3/O6OjCqPuuLA6yADMvRmwfq69buVFiDK0?=
 =?us-ascii?Q?spl3XMMY/TCvd2ELaIy5KXRn4rs5BzmpbS/qEJ6Scn1McVGzw1wclJyZ3gbw?=
 =?us-ascii?Q?7uodE3IH7mmSuqxoW1g4i4C5miiPQ2U85wyu7/kTOV71la9VV504cWmYdkXU?=
 =?us-ascii?Q?g0zqb4g12sbCxX1YFkYgnBmfgC/nXRLnUSRKBDuvG+8tAxvNfta6TwsdaitN?=
 =?us-ascii?Q?EBYCJi8YcM1AoQoalpbe19B+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca94e4e-743b-4fad-9e97-08d9831c3720
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 07:39:05.5598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJD8d4GnnzdBNwsSgp3HJxOCG7AqzGDfPCoIDKXcLeAC+MElVYpphH2yCVVRy3y2pb76pzGx9KK3vRT2gQ7OQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On UTP_TASK_REQ_COMPL interrupt, ufshcd_tmc_handler() iterates through
> busy requests in tags->rqs and complete request if corresponding
> doorbell flag is reset.
> However, ufshcd_issue_tm_cmd() allocates requests from tags->static_rqs
> and trigger doorbell directly without dispatching request through block
> layer, thus requests can never be found in tags->rqs and completed
> properly. Any TM command issued by ufshcd_issue_tm_cmd() inevitably
> timeout and further leads to recovery flow failure when LU Reset or
> Abort Task is issued.
>=20
> In this patch, blk_mq_tagset_busy_iter() call in ufshcd_tmc_handler()
> is replaced with new interface, blk_mq_drv_tagset_busy_iter(), to
> allow completion of request allocted by driver. The new interface is
> introduced for driver to iterate through requests in static_rqs.
Is this the same issue that was addressed here - https://www.spinics.net/li=
sts/linux-scsi/msg164520.html ?

Thanks,
Avri

>=20
> Po-Wen Kao (2):
>   blk-mq: new busy request iterator for driver
>   scsi: ufs: fix TM request timeout
>=20
>  block/blk-mq-tag.c        | 36 ++++++++++++++++++++++++++++++------
>  drivers/scsi/ufs/ufshcd.c |  2 +-
>  include/linux/blk-mq.h    |  4 ++++
>  3 files changed, 35 insertions(+), 7 deletions(-)
>=20
> --
> 2.18.0

