Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCF2C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CC620678
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fsclXNFa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hEp8qzQB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgAIJtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 04:49:03 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:49785 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbgAIJtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 04:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578563343; x=1610099343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XPMnZG1DSpvTn6Oh1CeT2j23yOF1idPP1nMPIF7ZlO4=;
  b=fsclXNFaF4lBA9fYWtJvL0H1+dwEaJFnbWoTWxrufqQqV5fx4Upg7U3h
   QbwJA8OFOEMfaS6YZ6J5l3ZBpTbvtwBgy038ZVrybTr3g1iTcejTKbKcO
   JOzVAmj33gNThZJxwmHhxY2nytmcjlWv2eMjyOL9ztPrhMEZjy6Y0vxld
   awqgDshOJBMqslIKe40ewttId/R9RFv7Nlc+1HaPvNaK0rA5oxN3W23JI
   jK1KO23ImkJUt4H/bZPBhvf+y9aa5akBR3vBLB7i/17a0Am4uw7vCXv8Q
   cK+ADzIAozZiG9LSi7LnB2ySXN1UUYOyEQrWAqzOkeDzGHoW5YFypkhEZ
   Q==;
IronPort-SDR: kD4fFEHjwUYkSEivvS13LvMK35NTFgcfJPM2N6XusZCVHRLC2TREEKek4jl0CSWVbQZa2rCbST
 7zs9zoKToB9xDIfI1SgV3bkmcS5gZ3i7JD13L0eStfPm/1N0Obu14Ogf2/gHIae5ZyODY0JAx/
 jBbSt57e9ZTPR0jtzEFpbGUhZI11/gb5APrXjzSd5su7/7b9ftGZrBhVDstVF3by4oNRIbffD+
 8XQ78txceuVDq0W2aOd1/eG4K5JVmvFY2g1hCvei28zOmhbAn++Mm8n2+8OeRcGj43LlDtsYef
 ZXE=
X-IronPort-AV: E=Sophos;i="5.69,413,1571673600"; 
   d="scan'208";a="127765665"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2020 17:48:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqAebkAJ7rnTZRNrHBm3VgLE4oTPpA5v1pr5J9QeWEqUQvVWSCDv9hu4RXaXR5ydWXPb8KzQTeoHMUaelPK1j46pym45HNnmAzMCjKwUN6saS28vwrxmKE8Jk5GrkWafnW53IIgOoj27Z1B7Dn9cg3JATgHXn8CRtJ2c/5jyq6uSzuzmM5IaeXC1PlCpaZ9g7AWecPjI+q3/JFiU6MVBlTWPCsrP+NInxY7yPLutPxYGB2i12kPqOUiBTe5bP4sr/Fa1cTaY5ah73iVXMI/8uzdcUoGij5nfm/ENEDxMxBCIX4vQKbuosx4uAiycOQaG1gNa2J991A/iC28v3kjG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRlGFEZS69ojKBfhjgwoB+hZJHbIVC8+K3mpp0SBk1g=;
 b=Q6e5m+otUzKutJC9sofzIXp/CBHKkqKDDNMS0OjV3I650l5FowscL+hbUh5pfO2vwKiUVeNlRdXieO48vMv6+YwW4tBNvahHwxl3IfWCoXh1gHAsK0LYnRSUiiT0lyfe63vTVt+r+21tO7ka1I1HWDkWyNm/Aw5uxE0mZ34rpGvZ2sOIhZ/hklRLin5JdziEJzCfVb6axwkvvsS3ESsc3RzFnA2jKNKrdaKiNn1B5zIzWA3fF1bua9EEbPG8nH0/s5fwFOE72B3+hmUWJETg439RbXLCX1xAiNZ00S4PwsYpJag5rDi9uh5HSb5sqrim7FCrgfq3tuUeCiJ4cNq1Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRlGFEZS69ojKBfhjgwoB+hZJHbIVC8+K3mpp0SBk1g=;
 b=hEp8qzQBfd4gvMrY9PfJbGn/7MLVLRn9bR6++oPW53qbSLipPJiomdKgXxQ1dyS+eAhEQIEV/vkuKrXQpzXv1qrLRjeWZT3MEVQnRd+v8UFzR+fVAfbcB5jPSgi+noJL896h5FDD2+gV5j1vYmX68haZWfVdFpd13GmQ3JDl1n8=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6896.namprd04.prod.outlook.com (10.186.146.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 09:48:56 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2623.010; Thu, 9 Jan 2020
 09:48:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Can Guo <cang@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Topic: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Index: AQHVxZBMBjHYQAMMRUSGfCYvryuWmqfiFWXg
Date:   Thu, 9 Jan 2020 09:48:56 +0000
Message-ID: <MN2PR04MB69913704982A01708C36374FFC390@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-5-bvanassche@acm.org>
In-Reply-To: <20200107192531.73802-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 024b82a0-c238-46b6-4ecc-08d794e924d9
x-ms-traffictypediagnostic: MN2PR04MB6896:
x-microsoft-antispam-prvs: <MN2PR04MB6896AA1BAD2EADC811EB1401FC390@MN2PR04MB6896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(189003)(199004)(51234002)(64756008)(66446008)(186003)(66476007)(33656002)(76116006)(26005)(8676002)(66946007)(478600001)(55016002)(2906002)(9686003)(86362001)(5660300002)(66556008)(6506007)(4326008)(316002)(30864003)(81156014)(8936002)(81166006)(7696005)(71200400001)(54906003)(110136005)(7416002)(52536014)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6896;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7jK8Cym1cXu3ESmPT8yh3KRm6ls3go1D6Jp1GWuvvcig6p5AIKYWfsOVRKBHWHu42E/cgbHbodQ6Q2eeKpl8gUze+H1aBXD7T91m0d6R7IDfC0DDu+Q7vzRh2ivzjtyy7bgHnAnLcr6iA9XKwOIYJ+sC/foWtyHjcS8xTj2H2IT9ANEDCuJxc5oR7jr1JBzm62lBg93L7r6mqY5n1xpbdDXWd4jdRf0yCG5fn5XIGDPghi8oNC6po4ptMVOHZGSyGjI6D5G8jK/HvYIa1SFv09gFsTRkWQCgp/f2h6OSINa49uCT6w7Ot4dPc6pAoHyQ93YT4F5vuztCqCBAdgicwn1N1JcXkrc++TeOEDqRzF/n3y2LE+pHHBLA1Ozj3kTor+igKd3PwL3lugXqSkBIcQZCtG0B9tGGSi7QdQaAPXwVHK2IX0a1ZRUX/Foh5hQb3KfjnXQy2IZCy9cuSZeBwbQIBF26DqhmNrLKb0MjNNC/kOh8UXCeByoO/Q2rYgV7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024b82a0-c238-46b6-4ecc-08d794e924d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 09:48:56.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4oduJFPXPa7CmsHIcFrn0uiUIP1SI5kx7PRBoXcz58ushB+ZCmd6WJVphJ2rXadA20uIUf/KL6o11uf0oNS3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6896
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,
>=20
>=20
> Set .cmd_size in the SCSI host template such that the SCSI core allocates=
 space at
> the end of each SCSI command for the UFS data. Set the .init_cmd_priv fun=
ction
> pointer in the SCSI host template such that the UFS data is only initiali=
zed once.
>=20
> Remove the struct members that are no longer necessary due to these chang=
es,
> namely ufshcd_lrb.cmd and ufs_hba.lrb.
>=20
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 207 ++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |   5 -
>  2 files changed, 134 insertions(+), 78 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 15e65248597d..e4b6408e55c4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -294,19 +294,60 @@ static void ufshcd_scsi_block_requests(struct
> ufs_hba *hba)
>                 scsi_block_requests(hba->host);  }
>=20
> +/*
> + * Convert a SCSI or device management command tag into a request
> +pointer. Use
> + * scsi_cmd_priv() instead of this function if a SCSI command pointer
> +is
> + * available. The caller must ensure that the request state won't
> +change as
> + * long as the returned pointer is in use.
> + */
> +static struct request *ufshcd_tag_to_req(struct ufs_hba *hba, unsigned
> +int tag) {
> +       return blk_mq_tag_to_rq(hba->cmd_queue->tag_set->tags[0], tag);
> +}
> +
> +/* Convert a SCSI or device management request pointer into an LRB
> +pointer. */ static struct ufshcd_lrb *ufshcd_req_to_lrb(struct request
> +*req) {
> +       struct scsi_cmnd *cmd =3D container_of(scsi_req(req),
> +typeof(*cmd), req);
> +
> +       return scsi_cmd_priv(cmd);
> +}
> +
> +/*
> + * Convert a SCSI or device management command tag into a UFS data
> +pointer. Use
> + * scsi_cmd_priv() instead of this function if a SCSI command pointer
> +is
> + * available. The caller must ensure that the SCSI command state won't
> +change
> + * as long as the returned pointer is in use.
> + */
> +static struct ufshcd_lrb *ufshcd_tag_to_lrb(struct ufs_hba *hba,
> +                                           unsigned int tag) {
> +       struct request *req =3D ufshcd_tag_to_req(hba, tag);
> +
> +       return req ? ufshcd_req_to_lrb(req) : NULL; }
> +
>  static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
>                 const char *str)
>  {
> -       struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +       struct ufshcd_lrb *lrb =3D ufshcd_tag_to_lrb(hba, tag);
> +       struct utp_upiu_req *rq;
>=20
> +       if (WARN_ON_ONCE(!lrb))
> +               return;
> +       rq =3D lrb->ucd_req_ptr;
>         trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.c=
db);
> }
>=20
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned in=
t
> tag,
>                 const char *str)
>  {
> -       struct utp_upiu_req *rq =3D hba->lrb[tag].ucd_req_ptr;
> +       struct ufshcd_lrb *lrb =3D ufshcd_tag_to_lrb(hba, tag);
> +       struct utp_upiu_req *rq;
>=20
> +       if (WARN_ON_ONCE(!lrb))
> +               return;
> +       rq =3D lrb->ucd_req_ptr;
>         trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);=
  }
>=20
> @@ -320,16 +361,35 @@ static void ufshcd_add_tm_upiu_trace(struct
> ufs_hba *hba, unsigned int tag,
>                         &descp->input_param1);  }
>=20
> -static void ufshcd_add_command_trace(struct ufs_hba *hba,
> -               unsigned int tag, const char *str)
> +/*
> + * Whether or not @req represents a SCSI command. Device management
> +commands
> + * and TMF commands have the operation type set to REQ_OP_DRV_OUT.
> + */
> +static bool ufshcd_is_scsi(struct request *req) {
> +       switch (req_op(req)) {
> +       case REQ_OP_DRV_IN:
> +       case REQ_OP_DRV_OUT:
> +               return false;
> +       }
> +       return true;
> +}
> +
> +/* Trace a SCSI or device management command. */ static void
> +ufshcd_add_command_trace(struct ufs_hba *hba, struct request *req,
> +                                    const char *str)
>  {
>         sector_t lba =3D -1;
>         u8 opcode =3D 0;
>         u32 intr, doorbell;
> -       struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
> -       struct scsi_cmnd *cmd =3D lrbp->cmd;
> +       struct ufshcd_lrb *lrbp =3D ufshcd_req_to_lrb(req);
> +       struct scsi_cmnd *cmd =3D NULL;
> +       unsigned int tag =3D req->tag;
>         int transfer_len =3D -1;
>=20
> +       if (ufshcd_is_scsi(req))
> +               cmd =3D blk_mq_rq_to_pdu(req);
> +
>         if (!trace_ufshcd_command_enabled()) {
>                 /* trace UPIU W/O tracing command */
>                 if (cmd)
> @@ -439,7 +499,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned
> long bitmap, bool pr_prdt)
>         int tag;
>=20
>         for_each_set_bit(tag, &bitmap, hba->nutrs) {
> -               lrbp =3D &hba->lrb[tag];
> +               lrbp =3D ufshcd_tag_to_lrb(hba, tag);
> +               if (!lrbp)
> +                       continue;
>=20
>                 dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
>                                 tag, ktime_to_us(lrbp->issue_time_stamp))=
;
> @@ -1853,14 +1915,17 @@ static void
> ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
>  /**
>   * ufshcd_send_command - Send SCSI or device management commands
>   * @hba: per adapter instance
> - * @task_tag: Task tag of the command
> + * @req: SCSI or device management command pointer
>   */
>  static inline
> -void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> +void ufshcd_send_command(struct ufs_hba *hba, struct request *req)
>  {
> -       hba->lrb[task_tag].issue_time_stamp =3D ktime_get();
> -       hba->lrb[task_tag].compl_time_stamp =3D ktime_set(0, 0);
> -       ufshcd_add_command_trace(hba, task_tag, "send");
> +       struct ufshcd_lrb *lrbp =3D ufshcd_req_to_lrb(req);
> +       unsigned int task_tag =3D req->tag;
> +
> +       lrbp->issue_time_stamp =3D ktime_get();
> +       lrbp->compl_time_stamp =3D ktime_set(0, 0);
> +       ufshcd_add_command_trace(hba, req, "send");
>         ufshcd_clk_scaling_start_busy(hba);
>         __set_bit(task_tag, &hba->outstanding_reqs);
>         ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL)=
;
> @@ -2076,19 +2141,18 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd)
>  /**
>   * ufshcd_map_sg - Map scatter-gather list to prdt
>   * @hba: per adapter instance
> - * @lrbp: pointer to local reference block
> + * @cmd: SCSI command to map
>   *
>   * Returns 0 in case of success, non-zero value in case of failure
>   */
> -static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +static int ufshcd_map_sg(struct ufs_hba *hba, struct scsi_cmnd *cmd)
>  {
> +       struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
>         struct ufshcd_sg_entry *prd_table;
>         struct scatterlist *sg;
> -       struct scsi_cmnd *cmd;
>         int sg_segments;
>         int i;
>=20
> -       cmd =3D lrbp->cmd;
>         sg_segments =3D scsi_dma_map(cmd);
>         if (sg_segments < 0)
>                 return sg_segments;
> @@ -2212,13 +2276,13 @@ static void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp,
>  /**
>   * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
>   * for scsi commands
> - * @lrbp: local reference block pointer
> + * @cmd: SCSI command to prepare
>   * @upiu_flags: flags
>   */
>  static
> -void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32
> upiu_flags)
> +void ufshcd_prepare_utp_scsi_cmd_upiu(struct scsi_cmnd *cmd, u32
> +upiu_flags)
>  {
> -       struct scsi_cmnd *cmd =3D lrbp->cmd;
> +       struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
>         struct utp_upiu_req *ucd_req_ptr =3D lrbp->ucd_req_ptr;
>         unsigned short cdb_len;
>=20
> @@ -2329,10 +2393,12 @@ static int ufshcd_comp_devman_upiu(struct
> ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   * ufshcd_comp_scsi_upiu - UFS Protocol Information Unit(UPIU)
>   *                        for SCSI Purposes
>   * @hba: per adapter instance
> - * @lrbp: pointer to local reference block
> + * @cmd: command to prepare.
>   */
> -static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb =
*lrbp)
> +static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd
> +*cmd)
>  {
> +       struct request *req =3D cmd->request;
> +       struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
>         u32 upiu_flags;
>         int ret =3D 0;
>=20
> @@ -2342,10 +2408,10 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba
> *hba, struct ufshcd_lrb *lrbp)
>         else
>                 lrbp->command_type =3D UTP_CMD_TYPE_UFS_STORAGE;
>=20
> -       if (likely(lrbp->cmd)) {
> +       if (likely(ufshcd_is_scsi(req))) {
>                 ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
> -                                               lrbp->cmd->sc_data_direct=
ion);
> -               ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> +                                               cmd->sc_data_direction);
> +               ufshcd_prepare_utp_scsi_cmd_upiu(cmd, upiu_flags);
>         } else {
>                 ret =3D -EINVAL;
>         }
> @@ -2394,7 +2460,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
> struct ufshcd_lrb *lrb, int i)
>   */
>  static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd
> *cmd)  {
> -       struct ufshcd_lrb *lrbp;
> +       struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
>         struct ufs_hba *hba;
>         unsigned long flags;
>         int tag;
> @@ -2410,6 +2476,13 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>                 BUG();
>         }
>=20
> +       /* See also ufshcd_is_scsi() */
> +       switch (req_op(cmd->request)) {
> +       case REQ_OP_DRV_IN:
> +       case REQ_OP_DRV_OUT:
> +               WARN_ON_ONCE(true);
Maybe just WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request))

> +       }
> +
>         if (!down_read_trylock(&hba->clk_scaling_lock))
>                 return SCSI_MLQUEUE_HOST_BUSY;
>=20
> @@ -2450,10 +2523,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>         }
>         WARN_ON(hba->clk_gating.state !=3D CLKS_ON);
>=20
> -       lrbp =3D &hba->lrb[tag];
> -
> -       WARN_ON(lrbp->cmd);
> -       lrbp->cmd =3D cmd;
>         lrbp->sense_bufflen =3D UFS_SENSE_SIZE;
>         lrbp->sense_buffer =3D cmd->sense_buffer;
>         lrbp->task_tag =3D tag;
> @@ -2461,21 +2530,18 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>         lrbp->intr_cmd =3D !ufshcd_is_intr_aggr_allowed(hba) ? true : fal=
se;
>         lrbp->req_abort_skip =3D false;
>=20
> -       ufshcd_comp_scsi_upiu(hba, lrbp);
> +       ufshcd_comp_scsi_upiu(hba, cmd);
>=20
> -       err =3D ufshcd_map_sg(hba, lrbp);
> -       if (err) {
> -               lrbp->cmd =3D NULL;
> -               ufshcd_release(hba);
> +       err =3D ufshcd_map_sg(hba, cmd);
> +       if (err)
>                 goto out;
> -       }
>         /* Make sure descriptors are ready before ringing the doorbell */
>         wmb();
>=20
>         /* issue command to the controller */
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_vops_setup_xfer_req(hba, tag, true);
> -       ufshcd_send_command(hba, tag);
> +       ufshcd_send_command(hba, cmd->request);
>  out_unlock:
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
> @@ -2486,7 +2552,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)  static int ufshcd_compose_dev_cmd(struct
> ufs_hba *hba,
>                 struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int =
tag)  {
> -       lrbp->cmd =3D NULL;
>         lrbp->sense_bufflen =3D 0;
>         lrbp->sense_buffer =3D NULL;
>         lrbp->task_tag =3D tag;
> @@ -2649,8 +2714,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>         WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>=20
>         init_completion(&wait);
> -       lrbp =3D &hba->lrb[tag];
> -       WARN_ON(lrbp->cmd);
> +       lrbp =3D ufshcd_req_to_lrb(req);
>         err =3D ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>         if (unlikely(err))
>                 goto out_put_tag;
> @@ -2662,7 +2726,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>         wmb();
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_vops_setup_xfer_req(hba, tag, false);
> -       ufshcd_send_command(hba, tag);
> +       ufshcd_send_command(hba, req);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout); @@ -3378,14
> +3442,6 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>                 goto out;
>         }
>=20
> -       /* Allocate memory for local reference block */
> -       hba->lrb =3D devm_kcalloc(hba->dev,
> -                               hba->nutrs, sizeof(struct ufshcd_lrb),
> -                               GFP_KERNEL);
> -       if (!hba->lrb) {
> -               dev_err(hba->dev, "LRB Memory allocation failed\n");
> -               goto out;
> -       }
>         return 0;
>  out:
>         return -ENOMEM;
> @@ -3449,11 +3505,17 @@ static void
> ufshcd_host_memory_configure(struct ufs_hba *hba)
>                         utrdlp[i].response_upiu_length =3D
>                                 cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>                 }
> -
> -               ufshcd_init_lrb(hba, &hba->lrb[i], i);
>         }
>  }
>=20
> +static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct
> +scsi_cmnd *cmd) {
> +       struct ufs_hba *hba =3D shost_priv(shost);
> +
> +       ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
So ufshcd_init_lrb() is called now for every new request?
=20

> +       return 0;
> +}
> +
>  /**
>   * ufshcd_dme_link_startup - Notify Unipro to perform link startup
>   * @hba: per adapter instance
> @@ -4826,19 +4888,21 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,  {
>         struct ufshcd_lrb *lrbp;
>         struct scsi_cmnd *cmd;
> +       struct request *req;
>         int result;
>         int index;
>=20
>         for_each_set_bit(index, &completed_reqs, hba->nutrs) {
> -               lrbp =3D &hba->lrb[index];
> -               cmd =3D lrbp->cmd;
> -               if (cmd) {
> -                       ufshcd_add_command_trace(hba, index, "complete");
> +               req =3D ufshcd_tag_to_req(hba, index);
> +               if (!req)
> +                       continue;
> +               cmd =3D blk_mq_rq_to_pdu(req);
> +               lrbp =3D scsi_cmd_priv(cmd);
> +               if (ufshcd_is_scsi(req)) {
> +                       ufshcd_add_command_trace(hba, req, "complete");
>                         result =3D ufshcd_transfer_rsp_status(hba, lrbp);
>                         scsi_dma_unmap(cmd);
>                         cmd->result =3D result;
> -                       /* Mark completed command as NULL in LRB */
> -                       lrbp->cmd =3D NULL;
>                         lrbp->compl_time_stamp =3D ktime_get();
>                         /* Do not touch lrbp after scsi done */
>                         cmd->scsi_done(cmd); @@ -4847,7 +4911,7 @@ static=
 void
> __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>                         lrbp->command_type =3D=3D UTP_CMD_TYPE_UFS_STORAG=
E) {
>                         lrbp->compl_time_stamp =3D ktime_get();
>                         if (hba->dev_cmd.complete) {
> -                               ufshcd_add_command_trace(hba, index,
> +                               ufshcd_add_command_trace(hba, req,
>                                                 "dev_complete");
>                                 complete(hba->dev_cmd.complete);
>                         }
> @@ -5892,10 +5956,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>=20
>         init_completion(&wait);
> -       lrbp =3D &hba->lrb[tag];
> -       WARN_ON(lrbp->cmd);
> -
> -       lrbp->cmd =3D NULL;
> +       lrbp =3D ufshcd_req_to_lrb(req);
>         lrbp->sense_bufflen =3D 0;
>         lrbp->sense_buffer =3D NULL;
>         lrbp->task_tag =3D tag;
> @@ -5936,7 +5997,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         /* Make sure descriptors are ready before ringing the doorbell */
>         wmb();
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_send_command(hba, tag);
> +       ufshcd_send_command(hba, req);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         /*
> @@ -6053,18 +6114,15 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)  {
>         struct Scsi_Host *host;
>         struct ufs_hba *hba;
> -       unsigned int tag;
>         u32 pos;
>         int err;
>         u8 resp =3D 0xF;
> -       struct ufshcd_lrb *lrbp;
> +       struct ufshcd_lrb *lrbp, *lrbp2;
>         unsigned long flags;
>=20
>         host =3D cmd->device->host;
>         hba =3D shost_priv(host);
> -       tag =3D cmd->request->tag;
> -
> -       lrbp =3D &hba->lrb[tag];
> +       lrbp =3D scsi_cmd_priv(cmd);
>         err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET,
> &resp);
>         if (err || resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
>                 if (!err)
> @@ -6074,7 +6132,8 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>=20
>         /* clear the commands that were pending for corresponding LUN */
>         for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
> -               if (hba->lrb[pos].lun =3D=3D lrbp->lun) {
> +               lrbp2 =3D ufshcd_tag_to_lrb(hba, pos);
Can lrpb2 be null here?

> +               if (lrbp2->lun =3D=3D lrbp->lun) {
>                         err =3D ufshcd_clear_cmd(hba, pos);
>                         if (err)
>                                 break;
> @@ -6102,8 +6161,9 @@ static void ufshcd_set_req_abort_skip(struct
> ufs_hba *hba, unsigned long bitmap)
>         int tag;
>=20
>         for_each_set_bit(tag, &bitmap, hba->nutrs) {
> -               lrbp =3D &hba->lrb[tag];
> -               lrbp->req_abort_skip =3D true;
> +               lrbp =3D ufshcd_tag_to_lrb(hba, tag);
> +               if (lrbp)
> +                       lrbp->req_abort_skip =3D true;
>         }
>  }
>=20
> @@ -6134,7 +6194,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>         host =3D cmd->device->host;
>         hba =3D shost_priv(host);
>         tag =3D cmd->request->tag;
> -       lrbp =3D &hba->lrb[tag];
> +       lrbp =3D scsi_cmd_priv(cmd);
>         if (!ufshcd_valid_tag(hba, tag)) {
>                 dev_err(hba->dev,
>                         "%s: invalid command tag %d: cmd=3D0x%p, cmd->req=
uest=3D0x%p",
> @@ -6178,7 +6238,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>          * to reduce repeated printouts. For other aborted requests only =
print
>          * basic details.
>          */
> -       scsi_print_command(hba->lrb[tag].cmd);
> +       scsi_print_command(cmd);
>         if (!hba->req_abort_count) {
>                 ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
>                 ufshcd_print_host_regs(hba); @@ -6258,7 +6318,6 @@ static=
 int
> ufshcd_abort(struct scsi_cmnd *cmd)
>=20
>         spin_lock_irqsave(host->host_lock, flags);
>         ufshcd_outstanding_req_clear(hba, tag);
> -       hba->lrb[tag].cmd =3D NULL;
>         spin_unlock_irqrestore(host->host_lock, flags);
>=20
>  out:
> @@ -7102,6 +7161,7 @@ static struct scsi_host_template
> ufshcd_driver_template =3D {
>         .module                 =3D THIS_MODULE,
>         .name                   =3D UFSHCD,
>         .proc_name              =3D UFSHCD,
> +       .init_cmd_priv          =3D ufshcd_init_cmd_priv,
>         .queuecommand           =3D ufshcd_queuecommand,
>         .slave_alloc            =3D ufshcd_slave_alloc,
>         .slave_configure        =3D ufshcd_slave_configure,
> @@ -7113,6 +7173,7 @@ static struct scsi_host_template
> ufshcd_driver_template =3D {
>         .this_id                =3D -1,
>         .sg_tablesize           =3D SG_ALL,
>         .cmd_per_lun            =3D UFSHCD_CMD_PER_LUN,
> +       .cmd_size               =3D sizeof(struct ufshcd_lrb),
>         .can_queue              =3D UFSHCD_CAN_QUEUE,
>         .max_segment_size       =3D PRDT_DATA_BYTE_COUNT_MAX,
>         .max_host_blocked       =3D 1,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> e05cafddc87b..231a948151ca 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -157,7 +157,6 @@ struct ufs_pm_lvl_states {
>   * @ucd_prdt_dma_addr: PRDT dma address for debug
>   * @ucd_rsp_dma_addr: UPIU response dma address for debug
>   * @ucd_req_dma_addr: UPIU request dma address for debug
> - * @cmd: pointer to SCSI command
>   * @sense_buffer: pointer to sense buffer address of the SCSI command
>   * @sense_bufflen: Length of the sense buffer
>   * @scsi_status: SCSI status of the command @@ -180,7 +179,6 @@ struct
> ufshcd_lrb {
>         dma_addr_t ucd_rsp_dma_addr;
>         dma_addr_t ucd_prdt_dma_addr;
>=20
> -       struct scsi_cmnd *cmd;
>         u8 *sense_buffer;
>         unsigned int sense_bufflen;
>         int scsi_status;
> @@ -480,7 +478,6 @@ struct ufs_stats {
>   * @utmrdl_dma_addr: UTMRDL DMA address
>   * @host: Scsi_Host instance of the driver
>   * @dev: device handle
> - * @lrb: local reference block
>   * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
>   * @outstanding_tasks: Bits representing outstanding task requests
>   * @outstanding_reqs: Bits representing outstanding transfer requests @@=
 -
> 558,8 +555,6 @@ struct ufs_hba {
>         /* Auto-Hibernate Idle Timer register value */
>         u32 ahit;
>=20
> -       struct ufshcd_lrb *lrb;
> -
>         unsigned long outstanding_tasks;
>         unsigned long outstanding_reqs;

