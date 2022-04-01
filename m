Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AA6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345313AbiDATXq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiDATXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 15:23:44 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1018B11DD1E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 12:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648840913; x=1680376913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=13hEWLCCGvW0saSltp3TITsGyP+Y2sEiXBJkaiAWslY=;
  b=lKMle8T4bevv9Oha9tFTfisxP7KeGjaYkNyJ/cXyyG+QQetwf8C/avlz
   8Ey9jIlBYm5xkLg/kFeOCU6mqZ1Jr581cyARErjTPkjaRap+vnxUAU6ZY
   cHToZUXAcH0F5M6QmjO8AXcPImH168QO/J/t1ys6Gytq3X8djU4pIVFyV
   UY2EirMsMb2ee1jVTiC7qhUP8cbk8j492d4Swbav5fQq2DZU6M6OBicYM
   S1sBHuJErRopkgXWhEbcVSC2c93fnszjIVIz259z2cQwSpt0HR0b58JgO
   WnBj+/h7R3hgQ5xjdodT11pgKqAHhBNeGJTACCIlyTPIjxfd67KGYcFdW
   A==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="301032481"
Received: from mail-mw2nam08lp2175.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.175])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 03:21:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MizpQwZ8CFX5AOuUQIFU1uOTgOS1Y5kuUNP0mUGjjUFIFf81V92FzTmnEcHPTMDeB6BwV1BocjcSwN7xRSusU9gyAFcUoaEkPi+p0f2cN4XXZ0Y5ciHy1oXDVv2yJsRilAg+4TTtSClTkPIWfvi4tiGhjGDSUCYmqWaYMAgN5HrjSQYnEBN8LFFbwi/HxxMVpliY9Y/jug+xONpig/RctuYgRZ84smSvYE/NvISCXfSABt1Gr+NE1yJ62xI5gaylP9/vqcIMMFq6dYdHHaDQUjG0r6DQa8CwwnakOTsxKv8mUaro/4leqO0GO2hNIH68fvo81kuSkfe+uxxXr+aQYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cj5Df7o4G+BxmBa4EgfnxszJTidR7XUXyz+FAONIdvU=;
 b=m+A5JX64KoFtZrIpaFt3a6fyHVNN6H2Zif0mtXrsczWXzLlDfg9Ekq5apX8OyBIGT5zktMWwKrjXVnp0r0bSHEO5CHGlPT3AGPYNPTe8FfI2CdzHxiDFWWifMKBEztoIxG0L7RWSY7B78fwrVIH7Ci0YTiCEFFM4YAiVRtDfnQ4sfxteXaq/YVSjbe9wlqyBHYGYdrvZ2S8lCtIHZKPJudZ2tK8+1ywKyPCPmDe+PkrUTiCkV8Mxmb4COLwshXhOhVPEy0sRBkUmJyLtlum/0zxJg+s3seWKR33XFd2TcOTr/0aJDCxZjAC7no5ee7laAABGfZrjRLBHaXgG/g2vjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj5Df7o4G+BxmBa4EgfnxszJTidR7XUXyz+FAONIdvU=;
 b=KDoo81vz7bse66WQKxwZQqVdKrJnJeFjM2NgSR1WOFBjjRfHR9nzAHiFEiPnLL9VTNkk4bw7DXrptXXXHq/qg409LnsoOUbETRlKr5VeXZGbN/6ANXK8CF4orVLmJI584nZp++xirmGHE4R6GA/qMBpEPlr0luBxKYXWtoRbY54=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN6PR04MB0949.namprd04.prod.outlook.com (2603:10b6:405:3f::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.26; Fri, 1 Apr 2022 19:21:48 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 19:21:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 05/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Thread-Topic: [PATCH 05/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Thread-Index: AQHYRU+fyPcbX/Ktwk6M0T4JCejR96zbbHjw
Date:   Fri, 1 Apr 2022 19:21:47 +0000
Message-ID: <DM6PR04MB6575C21425DA784513E160C7FCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-6-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 147f7a34-7f6e-4ac4-a69c-08da1414ddc0
x-ms-traffictypediagnostic: BN6PR04MB0949:EE_
x-microsoft-antispam-prvs: <BN6PR04MB0949EBBDD15C7B07952E0356FCE09@BN6PR04MB0949.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RczP+T+73MR1zrrrhKWmGl9l54gOcp85hIm0T43dxNnjpYzRbLDXdknumYAssY4wG4v2DtlNflUPBIaYF/TipWGNgKQhGn1S0s7iENwl9IU8ZlkVgGA/XozCXNBO8fjSTVNUj+iAVxpKsZSe/8TzmroafA7OOagZoBCVBtNmRw+tny8iZl7UXMP9T5fnJC8Z1kW+yzECkGwWDOxfZPKTpjERcTjOlS9pXSZ2NESxQ6YB2CIcG84od3vyaIIZIWTNOdcUy9DbVq1WgmNo575hKA2y18mH7sNeTjSApWDRdnXwiEpY5wfjhwTirpec4izg14RN0wr4QMMJ4IarEfte+7GTS0exMoeKhecoO/fIM1WpLD2v+ygsQRzXyUA+bZKgm9/NdHDUJyIcPtHD91wN6qccJAz955xE2N5W3CTfsmFjLrbkXvKg/twvG10bkFXoD3HMsXvVLN8fNT/Hffpo95WpfebeMr34Ohc1fwkonBew1SQIct2PsBa1Pi36aRsea1EvaWU7IoeWOfPdGhCwfgkSsrtyKK4c5nlfBMTj5f+lIoyU7kC0goxgbheipHOEOA0sgk/iAOAq3GWCMG5m+fB/dBMcnwYe+eeoZa9UBes04faLRN18PWKzNAdiLnkNnOq5Ah6HfGtanlX8aFWfaEGNl8ta9mEedpe85nnIc46nHYx9qvtVln3WQJdTKTJxr3DKduTVgKoOIpQSc9S0Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(2906002)(55016003)(86362001)(8936002)(508600001)(316002)(7696005)(6506007)(52536014)(33656002)(82960400001)(9686003)(76116006)(110136005)(54906003)(66946007)(122000001)(4326008)(38070700005)(66556008)(66446008)(8676002)(64756008)(66476007)(38100700002)(7416002)(5660300002)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b6W+gd2bD6R1FJqjGPcXiHhLs4pyKPFC9a1y/cgygUI+Tzv7PK+Whyw7afcv?=
 =?us-ascii?Q?PWLeMkvYsETJPfekg1X1bjo+PfyQeSxF7CJ5l/lKSsAvFbqlC1P6zQS3xlPL?=
 =?us-ascii?Q?bXCuj/5artRuDwueC0Gg4ZuKrAlP63sEQ5EaF2jV7Z4sbiwYi/SO0KG2dXNM?=
 =?us-ascii?Q?Pq+CSnBExi61Y0QblkmsMf682IlP06TpBN59BGAx4KRjCiuaU2eOgFWYfdPV?=
 =?us-ascii?Q?Hy8YPHRmjW8TuPsLwbVdAomXSnB5qD1mbUadlw65+up9/RDpxsC9etSwLEso?=
 =?us-ascii?Q?srWDhrdjETpo7P3iF/rfIMZm+O6FMlF8WRBagT8mIwyTEQpsXpsa2+gOWPqD?=
 =?us-ascii?Q?gibik2jgWDyryrKjUo4NcN04EFVuMcSvQfQYFOn6hPGA7tRDO5EmjWbeeAGb?=
 =?us-ascii?Q?RRkP87c/qbAGB2SNbfvHJr5nsIdptH10AYUJLKC1slpNR1wp8g/Y1xjYgeY2?=
 =?us-ascii?Q?f4f3qzeYS24nkuiOsfBOj2BRl3G4PF8+ifKzts1oKJapXOhn4mDoB4YBWcSv?=
 =?us-ascii?Q?UwwKRBBEk8zmZMAPNdGY5qy/cmod1Jf+Pzx3ZNLI90J7YM4fxxtbd0fGIrCY?=
 =?us-ascii?Q?4dAl65d7slebgVA1bN6sVLTYFvVCJ7TYn7EscJm83t+6S+crchsgqp9VWF7o?=
 =?us-ascii?Q?oj8tvk7vmCaqeZ51FHziYZs3YwLFQK81n2seGSBDbHgud7Qwn8e+3Zy9QwLd?=
 =?us-ascii?Q?wLxi25++AW7BGsd9jNzSvCoITsAZy5iTJDz5NHh+B1W4lvpCDS8B5mIqJp5Y?=
 =?us-ascii?Q?GpBw8w2Odf464iALCj6HErmjxVGSnOi9DLAuifNC98KcChhe0SYrjKM4t9B9?=
 =?us-ascii?Q?lf7sG10HEjW3rLCrD9qLKZMjJQ21c4gWEI+9y6pHVtSWWd7ewkxruE34UB/5?=
 =?us-ascii?Q?/xMzUAmk38U82dVl0HwrgkMrVpGbGF3zZu0Gu3B9sS7SKfLfyjERfK2E3S4F?=
 =?us-ascii?Q?eTUAMVL2CP6TeER9qxVrKocgobj8Kv2VA0TalwJBO3I1vGl3xvam9xuHwjkq?=
 =?us-ascii?Q?wuYvjnBSzpK54yQVqigtgXvvm1ACzal2rlJpkWQzT/HM2rB4aTeUvKdaLeVx?=
 =?us-ascii?Q?X7xDdUQxolz4xdYdr5rXTF10SrWIWQRKvparcuDmlNRcNBaJcydjU+6IYNZS?=
 =?us-ascii?Q?pxbg9CnpTaKp72V1jM0u3h9rKjoFK1OTMeTowr153Va9UrQEOJzu/4UYJQmo?=
 =?us-ascii?Q?qW/xPpaIWBqyTByqBqQeWKRIFxdKppK2kpzB4XtgVe6Encqhpi+d4aCu+PgH?=
 =?us-ascii?Q?EipKAIyTt6+WgGoHJYSBJ46eOUCiBFFoq+dbRil+gFPxIg7S2G7QfXFQzQdi?=
 =?us-ascii?Q?4waNblr50NH/11Lmhy1wxAL6EKNJFmjbJ9Ak7aHX8qSr8P3bCRNWHLbJ8lwI?=
 =?us-ascii?Q?p+cgcV48B80ftlsFBSWOm7KeR2iG7MGS6957NM4YzD8c+Wgw6wXzdeflurQZ?=
 =?us-ascii?Q?hEYH2j6HR6dXl/hVzt3AhFavBr1NaJlrzKJh6R7zryjUQMs+IlXF8sXhBPLq?=
 =?us-ascii?Q?sRVPJ6CFtx0gXN0P8wY5CKmVFVn6E9Ep6h7bJPogECf7rksMuL/U1s+0keTL?=
 =?us-ascii?Q?Vp4QWmmfbiWKBSuS3FYOAUg+gxGK+2fNQV/yVHlY2dpRIDBDxqHk7Z1wQpqq?=
 =?us-ascii?Q?dzgOICOIUuEmR6O/zArIjOcgZEN+3306CGz6bM/ulVA7erHfW0iGuk0BktZc?=
 =?us-ascii?Q?itHpAAOwQXTfXUnPrBOD9ZJNoOPX12M6iqWfkjjT/s29+kcjjaHOCSxOLw+5?=
 =?us-ascii?Q?dU+LhwfJfA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147f7a34-7f6e-4ac4-a69c-08da1414ddc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 19:21:47.7544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Auu7hh3HEwiUIspVVlkWzyTPCXJpH1BxKYes/h7wKYJZpbvcBCpDjmZpSRbJ9EFlX/Pt+Ffz9P43DFWct9CkKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0949
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> ufshcd_lrb.sense_buffer is NULL if ufshcd_lrb.cmd is NULL and
> ufshcd_lrb.sense_buffer points at cmd->sense_buffer if ufshcd_lrb.cmd
> is set. In other words, the ufshcd_lrb.sense_buffer member is identical
> to cmd->sense_buffer. Hence this patch that removes the
> ufshcd_lrb.sense_buffer structure member.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 ++++-----
>  drivers/scsi/ufs/ufshcd.h | 2 --
>  2 files changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e52e86b0b7a3..eddaa57b6aad 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2127,15 +2127,17 @@ void ufshcd_send_command(struct ufs_hba *hba,
> unsigned int task_tag)
>   */
>  static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
>  {
> +       u8 *sense_buffer =3D lrbp->cmd ? lrbp->cmd->sense_buffer : NULL;
lrbp->cmd  is tested in __ufshcd_transfer_req_compl(),
which is the only caller of ufshcd_transfer_rsp_status(),
which is the only caller of ufshcd_scsi_cmd_status(),
which is the only caller of ufshcd_copy_sense_data().
=20
Thanks,
Avri

>         int len;
> -       if (lrbp->sense_buffer &&
> +
> +       if (sense_buffer &&
>             ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
>                 int len_to_copy;
>=20
>                 len =3D be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len)=
;
>                 len_to_copy =3D min_t(int, UFS_SENSE_SIZE, len);
>=20
> -               memcpy(lrbp->sense_buffer, lrbp->ucd_rsp_ptr->sr.sense_da=
ta,
> +               memcpy(sense_buffer, lrbp->ucd_rsp_ptr->sr.sense_data,
>                        len_to_copy);
>         }
>  }
> @@ -2789,7 +2791,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>         lrbp =3D &hba->lrb[tag];
>         WARN_ON(lrbp->cmd);
>         lrbp->cmd =3D cmd;
> -       lrbp->sense_buffer =3D cmd->sense_buffer;
>         lrbp->task_tag =3D tag;
>         lrbp->lun =3D ufshcd_scsi_to_upiu_lun(cmd->device->lun);
>         lrbp->intr_cmd =3D !ufshcd_is_intr_aggr_allowed(hba);
> @@ -2829,7 +2830,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba
> *hba,
>                 struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int =
tag)
>  {
>         lrbp->cmd =3D NULL;
> -       lrbp->sense_buffer =3D NULL;
>         lrbp->task_tag =3D tag;
>         lrbp->lun =3D 0; /* device management cmd is not specific to any =
LUN */
>         lrbp->intr_cmd =3D true; /* No interrupt aggregation */
> @@ -6800,7 +6800,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         lrbp =3D &hba->lrb[tag];
>         WARN_ON(lrbp->cmd);
>         lrbp->cmd =3D NULL;
> -       lrbp->sense_buffer =3D NULL;
>         lrbp->task_tag =3D tag;
>         lrbp->lun =3D 0;
>         lrbp->intr_cmd =3D true;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b6162b208d99..b9f17219ca18 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -181,7 +181,6 @@ struct ufs_pm_lvl_states {
>   * @ucd_rsp_dma_addr: UPIU response dma address for debug
>   * @ucd_req_dma_addr: UPIU request dma address for debug
>   * @cmd: pointer to SCSI command
> - * @sense_buffer: pointer to sense buffer address of the SCSI command
>   * @scsi_status: SCSI status of the command
>   * @command_type: SCSI, UFS, Query.
>   * @task_tag: Task tag of the command
> @@ -205,7 +204,6 @@ struct ufshcd_lrb {
>         dma_addr_t ucd_prdt_dma_addr;
>=20
>         struct scsi_cmnd *cmd;
> -       u8 *sense_buffer;
>         int scsi_status;
>=20
>         int command_type;
