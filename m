Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D29C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641256128E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhKKHg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:36:28 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49027 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhKKHg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636616018; x=1668152018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wjIqseAHygm28R5k+QDSDhN2Y6jTEjL7yvkwPmq21Fc=;
  b=BNrI4blTUiEil9iz8eF44XDn/YKY+g4/V+yvg5i88ZVhzlReZ846CVGB
   wLO0cBndEBCAOEiJ/WJzK1VO+Cka4Hajpn6YrnUsxWkrZr/wJWW91T/zo
   qDLR75IATeg/BzAMX3y7KxXQep1OkVwIbeHIZ9lq9q2C+ag1rTyoYdbRc
   q3TGOdLyeNQ3jVDvLr2T/7K14gikdKiGofw7gsBhqYofGHl1ZUmAZhETY
   BtLA2nQ7bjzC91Mv2eMIVD01oVIeta9D9vZydvqQQE5derT5RzB7JyYQM
   ber2b50Aco7vPJArWK56PV8rd4q4HMTdIXHaNvfPXu4cCVX7xsAaf7zKZ
   w==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="184329645"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 15:33:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iepzjWv5o+hCYPZ62+/aAVKEqZMU2qQsD4WnKTZL/U3VPtkc15e55TabBKNWE97oOZ4CMUKZn4xcq+s3fDbz6yak1aFKzYlJlMSqyfxDkv22h3YNI9mcMOoHoi34zc+Q/zRsLtaIgtwDwcvc1nNZtEgzuHNoT9NQnexV4oLw/Gu3UStXd1eCJntpAqlTOoXB28vMed8RbvTyL5AkFu6EqBtgTor+BCyvRlxlZiNjA6H0mG2mYaIJpQUPn5wpkBQPcRtjbeuYEzVcRlqp48LbxUHx3G55hnWVTTk01+MbLv5dD2KwDpdZlU8ZCdGFa8dd0IQV6X3Y6JEKUJ8RcR3glQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUtwsO4ViZ2iHs6OeG0nwhAUWbhH3ePZ6Cls17H1O24=;
 b=fIKT8dW9BmZ+YWYywJe8jRgwUkuDah3D0s3kJpqugGxpqzTby1QZPeraN1qGC0G6qP6SRn8h+zQ5RBORNOmVa+RIGwDEMpG7NWA7+67jMm98nsL2pJAFWOaBovZZUdedh2WMuh8gbPV2925c+Fa196OUaYlvFgm8VqKijR/xF+/FROrgPU1RXVI9vKV+a9VZHyrlXRiRFlZIDjnp4hA+2+FnDdICFAtfxZk1/pUiMSAiMDt7CtELo44TJI9/uHR3AAZEebqff0sDqkcm/AGLygFk+nqd9pUsd1guQjhMZMYXlymCj2I2o7iHAOu4Kss/Kpu6nM2JDzdq6eKYHULY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUtwsO4ViZ2iHs6OeG0nwhAUWbhH3ePZ6Cls17H1O24=;
 b=E/kIkFa+QWErd0YeIfL4Fnruy8fu1Qz1itn9aiyguzEhiUgnHxjYE+/vAt1olOf3thvww5asgLk8pefhH7/CNS94RpXVQs6+H0FekfMSH2R1qRUKmC2QZOYFXmvCmhWd2mq1fUd6JfYhoQHOro6RiEecUUCHqAlZefQhARlTGkg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5354.namprd04.prod.outlook.com (2603:10b6:5:10b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.16; Thu, 11 Nov 2021 07:33:36 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 07:33:35 +0000
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
Subject: RE: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
Thread-Topic: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
Thread-Index: AQHX1cxWhEOUIGHLakuqZTnS5cGv5Kv97zNA
Date:   Thu, 11 Nov 2021 07:33:35 +0000
Message-ID: <DM6PR04MB6575281355B3E4F18204131DFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-8-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6a80502-c863-4901-670f-08d9a4e59261
x-ms-traffictypediagnostic: DM6PR04MB5354:
x-microsoft-antispam-prvs: <DM6PR04MB5354F51CBA648C692D015C31FC949@DM6PR04MB5354.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPNxK0K0uvHVq1Gej18j+AsRSPkUgDg8RiEUJmzIIIRY2q4/n+qdBdtAk+SWhcQok8NxdkeWGSTRgqWW5NK/1ocVf58WxKVXT/VsIFQKo6R+NSjIANDouzsrV4Zka82cgq1hX7f9w+V+7tI1cbCNHxmX3WRhbFe2MDAMTGzdH0VrzwyD05+5GMeQVTz6/kUZK+9JUklOtXQY/jZBQU2gAM39ZALD3W2M7VmGs7tKKMzekMy3EZcp3k4oY08pYRlHPaHmwTcvRXiBRcIF4AlwtQ10B1v6rYS7w3NzFM8SQWmKLiqVLg/L8e75LomwMgiF8rHGHZyXwHKyUPi38Yv7gDYsG4kc1N1ZHMS1Js8/xRX/G7tiQoycF3+HRnrlhDb0y3UNbF3gYTk4ehHrjG7vpSwp6kp5Uy5hkGjT7IaQqe0Weng5PuYKug6bahYTZYrJNwekJkP00rvVxG8HvQy2aH0aBcZb7FxPhv3xMfq05ulxOk5ibRsNf3ikJve4Jk3Igi0wwYG8MhbCq5IcW7sMCxRaxgw2Jqu9DZCGEMlJytHwt4wAJMFaAoI/pNOeGcn19OBFhDlRT74X63jtlxMkU9uA0mYz648MaGW8C90UnqBJGkOy+IPb9fv9Tp+xnWKXss20Kn9jJvKbDTy6cmBiF4ObvkGLLDPuzhu2/uMBoKGqPQlF5ISAmrLFgmzwNVTW2UKXzyJzZPTjLxfTWezZsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(52536014)(71200400001)(316002)(54906003)(66476007)(6506007)(82960400001)(8676002)(122000001)(86362001)(4326008)(38070700005)(5660300002)(7696005)(83380400001)(110136005)(38100700002)(2906002)(186003)(76116006)(8936002)(9686003)(64756008)(55016002)(66446008)(26005)(7416002)(66946007)(508600001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FSqSvnF/m6TtWnFY/995yAf631+yAvqWYEkiu0JBhxtmr8zFKAiiI0QOXDo+?=
 =?us-ascii?Q?3itaYM1j0tQnha77B4rvfA1kS+t8Uyf2mz308RQv4ErHMMKWQ6hMKXyOt73r?=
 =?us-ascii?Q?m7cxCiaFpL4kqIV+9wAUBFNHsAdiumWOzSPBTNi+ys5QoV1PFDWa/jsaex2E?=
 =?us-ascii?Q?8GfgXNrEOIWeeZVAIk+daXzS5KyRLFTGXsFGO8TSHglcr0cG0+dUAID5+w2x?=
 =?us-ascii?Q?ZTpS7SepniZVruyrBwKhOJ9kyDoKV9+wmxYdavv77cXfMmLGcN2n948FJgfw?=
 =?us-ascii?Q?joYrnePiWdcMtZrlV7VrzwMSE2w/gjODPwx2q7ZzTZu0Aecz8MAjU9Ic07nA?=
 =?us-ascii?Q?DR5nuMo3dBNfEMfBP0C2RITDF7oUEIYxUCO6sErMkoXTQzaB7aN8gJR3XK8q?=
 =?us-ascii?Q?gey1O91Ni0fNpCOhy3gVW8efM2plVTPUzgSBckJQuVHOTuHdjFpVGUw7kpSP?=
 =?us-ascii?Q?f+4+04daMXJMpZ/2POs8TJM+UUAlsSN4PlMJ1EoHtWFjTAfOe9W/hI5NDaqd?=
 =?us-ascii?Q?9PChlG+OEeLfNnwEQ4/Rz1LMJ81qtJlTujpCU8+4tT1a0iWrW3ixu8xPjP5i?=
 =?us-ascii?Q?6GLIy6aCWbyD/zkYt0uCmjAZd9UM3wM+g70EHNK0BM1o7UI0oZdWsni2Lmlj?=
 =?us-ascii?Q?J1H7dLDb3Lkae4CEzqBKlN5dtj2Zc+4zbtGT2Fl3eG0lpXNkuH+yVfKeFact?=
 =?us-ascii?Q?Jz55bc82qBDrnc/GwsL7UGPuuOf4pjQ0ABIhCJvqNfh37ToSosHTV7LVM42G?=
 =?us-ascii?Q?/W50M0sZBs6mGqu/1NLiyBK4sBAeDp+iochtBbCrseJtwaj0/I/1TP9Dn7ad?=
 =?us-ascii?Q?nhX57e7/vNChxSbgeV8zaf6gEraphRdTJxSI8QW7+d0DYZr2jqACn9FywFAD?=
 =?us-ascii?Q?eGruUMwpixwHwNcgw/T0jYMgzHgBXpj003oL6knUNUd8cCjDf9vnEMPNCAyL?=
 =?us-ascii?Q?s2vZEb0Su0Nrh80v4kIMAvVG1gQ1eEjYXorsyaZgUr/hD/Shn7CVYFhGDuAm?=
 =?us-ascii?Q?cBkKov6pfvIjSMd7BSS21q1F+k0mlDbWD5QB+IY2hyG3MSXAEoeGCxRWgk4O?=
 =?us-ascii?Q?I1igOpUiYZmk1ilw2CIqTcnjWMbhfSxyvtk1jrCYcfZS+vX4/psa7UdRKI9G?=
 =?us-ascii?Q?u2CWQuKYt7Xf+KFuqsPcRKvBjU5rjUG4v8Hc8lrf3DCE19e12rExBvtB35iD?=
 =?us-ascii?Q?DUmhsAwzU19nnDBOU/sAZw83GSUse+/PpZX6YW02uJdERV3ERrTnVicqU9ES?=
 =?us-ascii?Q?dJ5sZCt8HBnJls0YmbjfKyIRRjeIXk/SbZAsG1uoHJlVkOxV5x8JUhcLV9Us?=
 =?us-ascii?Q?xIuAZzVaUVA7UT9NPTQ0/difZHm9WlIux3MrdTIf94/kypd8iXiyecinOAsY?=
 =?us-ascii?Q?ifPj3QoYPJtHQtq2mRhonASQyjZU21r62v0BrGaSNyM2omJqdwMPXwmCbvov?=
 =?us-ascii?Q?myZ6rjgQx8GC0Bb31e6pDL4PTF9QXH7IBRiTVLBQ9xQ2jCdMrjEy+UvuGXus?=
 =?us-ascii?Q?0TvLdmchaFS+ng2anXV+5ZfdPfAAUwZuvTRNjb46whCYhKNSJiAiuHH+ORdh?=
 =?us-ascii?Q?VtW4+eC7s27LsVcT+ihIWWmxegFLU8pSDkQO+v5E+NhR7d3SuTK928PM/jdY?=
 =?us-ascii?Q?jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a80502-c863-4901-670f-08d9a4e59261
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 07:33:35.8087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xov4VKboaRA/ZP43DpZJtMv8CReB3kuLFMgUiEaLJ50E3VJQuBINrr7ukojVxQOSTZZFLIUV9oEHpxBmp6lDfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5354
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The following deadlock has been observed on a test setup:
> * All tags allocated.
> * The SCSI error handler calls ufshcd_eh_host_reset_handler()
> * ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handle=
r()
> * ufshcd_err_handler() locks up as follows:
>=20
> Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt Call trace:
>  __switch_to+0x298/0x5d8
>  __schedule+0x6cc/0xa94
>  schedule+0x12c/0x298
>  blk_mq_get_tag+0x210/0x480
>  __blk_mq_alloc_request+0x1c8/0x284
>  blk_get_request+0x74/0x134
>  ufshcd_exec_dev_cmd+0x68/0x640
>  ufshcd_verify_dev_init+0x68/0x35c
>  ufshcd_probe_hba+0x12c/0x1cb8
>  ufshcd_host_reset_and_restore+0x88/0x254
>  ufshcd_reset_and_restore+0xd0/0x354
>  ufshcd_err_handler+0x408/0xc58
>  process_one_work+0x24c/0x66c
>  worker_thread+0x3e8/0xa4c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
>=20
> Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved reque=
st.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 8400d8e9a6f7..8f5640647054 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2940,12 +2940,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>=20
>         down_read(&hba->clk_scaling_lock);
>=20
> -       /*
> -        * Get free slot, sleep if slots are unavailable.
> -        * Even though we use wait_event() which sleeps indefinitely,
> -        * the maximum wait time is bounded by SCSI request timeout.
> -        */
> -       req =3D blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +       req =3D blk_mq_alloc_request(q, REQ_OP_DRV_OUT,
> + BLK_MQ_REQ_RESERVED);
>         if (IS_ERR(req)) {
>                 err =3D PTR_ERR(req);
>                 goto out_unlock;
> @@ -8152,7 +8147,8 @@ static struct scsi_host_template
> ufshcd_driver_template =3D {
>         .this_id                =3D -1,
>         .sg_tablesize           =3D SG_ALL,
>         .cmd_per_lun            =3D UFSHCD_CMD_PER_LUN,
UFSHCD_CMD_PER_LUN needs to be < 32 as well?

Thanks,
Avri
> -       .can_queue              =3D UFSHCD_CAN_QUEUE,
> +       .can_queue              =3D UFSHCD_CAN_QUEUE - 1,
> +       .reserved_tags          =3D 1,
>         .max_segment_size       =3D PRDT_DATA_BYTE_COUNT_MAX,
>         .max_host_blocked       =3D 1,
>         .track_queue_depth      =3D 1,
> @@ -9513,8 +9509,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>         /* Configure LRB */
>         ufshcd_host_memory_configure(hba);
>=20
> -       host->can_queue =3D hba->nutrs;
> -       host->cmd_per_lun =3D hba->nutrs;
> +       host->can_queue =3D hba->nutrs - 1;
> +       host->cmd_per_lun =3D hba->nutrs - 1;
>         host->max_id =3D UFSHCD_MAX_ID;
>         host->max_lun =3D UFS_MAX_LUNS;
>         host->max_channel =3D UFSHCD_MAX_CHANNEL;
