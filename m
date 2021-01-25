Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6B5C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EEFB22B3B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbhAZF22 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:28:28 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13759 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbhAYMZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 07:25:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611577529; x=1643113529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jjWIHLT5lbq78MQ1fyUel9TUvNItCas7vtDdFfeiFFM=;
  b=p+WOb9zC52fmQ932Xk/J4iaoA7KKkk3mVuDcab06BkkgJdh+SQ7mcEjC
   OoPNgRZOoCeWD/okbhWEHuz9IyRaE08bXhfgyHQ9ito3QpbAYeocE9KEA
   pTvRuesfeYkF2Q3sGPSs0/kJxeCGfZkZIQrrgFgfQKJTI7s8GkOiF4Yhk
   BWRQWMbWch4z4WCacDQwMmvcP4ymnrv9+iaYzduV2B5SZT1nTFkCUn1av
   DcrhkKsVAkqoRK8UCjbwQQw0SAyhZBR++NARfogU2SonSgXok4y4lm8WR
   zoG8/0E+NbR3+PGmshuViT5PgmWXSJZZcEtG6TJ6uIS3B30FlbY6fAKCt
   w==;
IronPort-SDR: Fdxe5QS7l6XNZUSQXLMMhvN5eEW2G+mSWcoPJxf45SQXueMlhB3hWhMkOxN9E9g63limpRd9bb
 EdB1gqgiAEw4XKRMacRYDiyy7siHvqirwfkjeVvMkfM1HUo1HG4/4ZnVLau/l3jDY98DQe9Am9
 O1BvBS0Qq1yGU0umktoXtj0DviZ+zIbVN1UQDBvoasKTzqUx55y2GxckWAAyFz4jRYF56UArAi
 ExofGPWy8BkNH9EZCGG7rE5y5HM223avLMt1jsn6UY2+Y+C5Qx0eWYyG8UN8BuUDarLRXw0Vvw
 KYY=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; 
   d="scan'208";a="162692015"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 19:36:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdbg+935we+EDxkTIbdkZmp4x6gfx8/Dbf6fgf9R+KD9ncGoBh80Fefvu6I1Y+CsRfQcZkTxFEbF086HyguG88ooYr7fYwh+w0pB8gp4WqCnOX8AhV1FxjWWPgQHXr2C+pVECLT87RPF+fC0eWMG6vICsSxb98QLoTr288xmgUfPTqmVw3cKTtOveKUYHJXg1qXTfx67mgkKEJlf+DA43O0Tg/otZUjFdsLY3SgOZmvchwTJhAvOWUvSFPMb5uLru5njq/SxLEOh0KT9MhDgBcGHvvVd3YZ/0TE7+g0tWRTs+gRCeEX0YZyFc1mGM9ZtFLhliZ6Gw55nPSb9zS0FTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2l4U0y9fVUpDKRbL2gcFk0lq7R9MkoC4iq8WfEIeM4=;
 b=UpHRMuW9VA+OMgaCLP0YvBQKb5XyB8bf5oeC+6W5qu4CRhjAHdwDrrOW/mIDy8dXvs8rWoBYJPvgkFWLrfGwLG+8xcDq3fgTcvinu6Z3lqsozOEDymarvtZJTzjxQJD7PUUgkSdiZelGyPE7VDFq0APBUPjvRnntxpBB7MhMO1dlAUrz9uPi2qkL1GXISMZOBxGxJrQgAs7hpdQCPqsMXVx9iqrPOqM5XLMdx4fM0Sea4XMBdHgwvXsh2huZxCmpkc/rq9+VxCkETyLpLs8Okpmt33x38bhOSmCbZ4BkYsdBBLpN3d/bFIs/0QJTR6ONOPicuPTI6mgUfWXFS4ngjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2l4U0y9fVUpDKRbL2gcFk0lq7R9MkoC4iq8WfEIeM4=;
 b=vPRwO9lC6XMVqLCbh/lqG2JnNI+DMAuKxxICiuU76l4MiczfbEnKdpVkwZftWW3aod8ImFmKw/moxC/Mronu3kRnMkj5mezh8/b/2Bvwi1HBQ6wQNS40F4O49po+tu2PuThzunI7d0UujAC8ThriPOapkUAJsoc1uqxGyC30S9k=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4844.namprd04.prod.outlook.com (2603:10b6:5:1f::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.17; Mon, 25 Jan 2021 11:36:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 11:36:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Fix some problems in task management
 request implementation
Thread-Topic: [PATCH v2] scsi: ufs: Fix some problems in task management
 request implementation
Thread-Index: AQHW76TBHapLUhkMNUSBLd+xVXHyt6o4OnQQ
Date:   Mon, 25 Jan 2021 11:36:01 +0000
Message-ID: <DM6PR04MB65754B0CF70B9A3EB036D157FCBD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04c56bc7-28c8-435b-bfd7-08d8c12564c0
x-ms-traffictypediagnostic: DM6PR04MB4844:
x-microsoft-antispam-prvs: <DM6PR04MB484403F63789AFD21617088BFCBD9@DM6PR04MB4844.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9GS3Bq8YYO1pvgKvSTq3wTVzjNTuzNLPQjomWxZBDXClhQvQFTniudAiFPHz5s+l7//S2Msf34X+XipVYV0wBXMOIpVLDQFyHq9n0Cq/ANCXTNrUKbaVmgPe/y5HVHFvw7DszCyrKv1c4/JtlwxHv59xOnrX20y89af0m7dxpZOIkqWBRCILB/DAooeXTSpux+TvXBkD29jeWzwVkdfO0gYCxi15qU4+2cni7V7qbYARIeRmRfrarEocNV6Vv9x3U6f4N1lyMEjU5Sm3HVWIEBjHXLVmaC0P1IDoFjK+b2AYP5KNMYSy64clIF2mcFNNt9LV0C9Wd23csbRCjZ9XUOzd9F7wC3F+0zIatl5v0RYEFWNR4P2lOlS7WANi0/odqbtOMPNaijH4X6ynNGN5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(86362001)(83380400001)(316002)(110136005)(54906003)(64756008)(66946007)(76116006)(66476007)(66446008)(8676002)(7416002)(2906002)(66556008)(478600001)(52536014)(186003)(26005)(7696005)(71200400001)(4326008)(5660300002)(9686003)(8936002)(6506007)(55016002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RodNVflO7g2ROIlkRu6yRqrnMo9nFHhS0qlGGVTsEWDSRxb2D6Gga8RLyMPh?=
 =?us-ascii?Q?In3zMCeBSPOqRdJqJOIOM14HXGWhEsY9hmVwY/yZ6MybSKCqayRI/jXDc1pO?=
 =?us-ascii?Q?8btyUXAEME89XhfChFFIZWX1npqX9Fvm3vZm1Y34ZVIGNf6sBRlfIwKerL3D?=
 =?us-ascii?Q?XGHjb0yPr8xlMJ2x+zii/NZXexgfyNpEDU0HopGAOCmDLmDHKsxwsBUN9jFW?=
 =?us-ascii?Q?OszEc9X2yigbSTUEbUhiLRnsIYSQ8LqbxQpCDXxybhGIQDEToJC3dOc9jk4C?=
 =?us-ascii?Q?aUPW02aveqJeaSgEvWy5929s7vSp1xO5rKDOTfRKQ7viwaOClaQg8CQGRytI?=
 =?us-ascii?Q?KfaGapMIJQP1LpWzWkE+W8IuzOKdZX4EHBl5azu3sOtLRpAfJE1Oa9WNZTYg?=
 =?us-ascii?Q?tpbWxj+5vdBQqUKj5G0AeXvDtHtgJxvH93/qaRbrN9Zo+VuKWr8T3k/5ppfg?=
 =?us-ascii?Q?vOi+DKU3Rbzt3c1qEqF9i+bx2ZEzIF/sFAm6aQ3sUb+VseDtGWcMjR4wOy4K?=
 =?us-ascii?Q?SUKoZDv0X/BkA/LSw5MLcjMfOQsAINQDf8D7CSJ3vfHNWpCX8O2AMCMgk2il?=
 =?us-ascii?Q?mugoj0UplaFkfj61b1QMz1YoYRUXS02mJi/I+dVZxsDkWHfzAXXGQ9sHjXw2?=
 =?us-ascii?Q?F6qWU/UJB/KX10gmDoGKP9w4laDy8ovDyklp9TJwV9iljl/Nc2MQes2ZbcIe?=
 =?us-ascii?Q?xA0vt4UoHgcIhlSRWeeE0Xc0L+MLHG8bYlKPkXKqLFRwYZjFq/HQFRGVszWp?=
 =?us-ascii?Q?hlnlGS9MLrdxRw9HLnHbpXF+Fv59o7PwvrtejzzakDcLS2QZtjz2BYQSrZss?=
 =?us-ascii?Q?i5MjYZN/IRN0xvvkX2PSrhtj67bDB3wnC8ocyVv5nMh9Gcq+kjFrTYBQChkt?=
 =?us-ascii?Q?3O2kcKqfRKSbvXSnvlLsR1LTgdnoj8Ehnr6oC5TNe21gogrankEOOi5StVKT?=
 =?us-ascii?Q?byeiHmP3oWo2BX2YxovddhzmFcO8geu01swQf3K1fyA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c56bc7-28c8-435b-bfd7-08d8c12564c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 11:36:01.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2YKEi7hYtYXIG9i2w5TZ0TkUkG7NNhCzyYuutWPS4ZBuEB63O8K4WAYewMhvywtowXEXQBsF64IMsarQXGdDVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4844
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Current task management request send/compl implementation is broken, the
> problems and fixes are listed as below:
>=20
> Problem: TMR completion timeout. ufshcd_tmc_handler() calls
>          blk_mq_tagset_busy_iter(fn =3D=3D ufshcd_compl_tm()), but since
>          blk_mq_tagset_busy_iter() only iterates over all reserved tags a=
nd
>          started requests, so ufshcd_compl_tm() never gets a chance to ru=
n.
> Fix:     Call blk_mq_start_request() in __ufshcd_issue_tm_cmd().
>=20
> Problem: Race condition in send/compl paths. ufshcd_compl_tm() looks for
>          all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL and call complete()
>          for each req who has the req->end_io_data set. There can be a ra=
ce
>          condition btw tmc send/compl, because req->end_io_data is set, i=
n
>          __ufshcd_issue_tm_cmd(), without host lock protection, so it is
>          possible that when ufshcd_compl_tm() checks the req->end_io_data=
,
>          req->end_io_data is set but the corresponding tag has not been s=
et
>          in the REG_UTP_TASK_REQ_DOOR_BELL. Thus, ufshcd_tmc_handler()
> may
>          wrongly complete TMRs which have not been sent.
> Fix:     Protect req->end_io_data with host lock. And let ufshcd_compl_tm=
()
>          only handle those tm cmds which have been completed instead of
>          looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.
>=20
> Problem: In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs +
>          req->tag as the Task Tag in one TMR UPIU.
> Fix:     Directly use req->tag as Task Tag.
>=20
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Since you are practically reverting Bart's change (69a6c269c097), maybe cc =
him as well,
And add a fixes tag?

Also, even though all those fixes are around the same place, but fixing dif=
ferent issues,
You might want to consider to separate those.  Whatever you think.

Thanks,
Avri
