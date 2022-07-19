Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCA2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 11:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiGSLPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 07:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbiGSLPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 07:15:18 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E266445
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 04:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658229316; x=1689765316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wqsj5tvBL4RGKaGJeUNMSlWqzRewP+IsJoFuaZAgFLE=;
  b=ptmWR324n0dgzZ8YlAjrcHa3ik18GViuRyHpCYvi3Gj+5Dqc5WIzzZsY
   Wg/5Vp4W6DjggeIzkLiRXCCgY+opflfKbmVdksPOb2IFKLsjgUO7L8GRn
   sMLnoPYql1YjrSKTRNcCc6rOxJHDJEz36HVzng5aJqXR57TQZYSd8wWbg
   6c1PCmif3K7B7iadNs+X1Lr1WmZPtj+T8wm1y6k/jWRWhp5t2Kd2uQE04
   BwPEYH8K2Cga8pwLThyZdoQJ/ujLVHGT7qbse3fTuEK/Hgez5etiCCcjV
   UyN8br1MSmEwGm9cNj1GKx3WNwqqPrCcwGZQOS/rd7Fv4ZWIN6V1KJzjL
   A==;
X-IronPort-AV: E=Sophos;i="5.92,283,1650902400"; 
   d="scan'208";a="206977442"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2022 19:15:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdxwHirrRZlCcC4oAFpqQTMeMC6Mh5VwcNDN/5bAWMS3GATcsyxxgV3BUiiOh8VyVUFGq+xVWQR4kp2FPk26G0CZmPLY7A8cvxrVW5ILSFWaB50m3ddx/u0WDOt+W0ndxJlir3P31dSPaXdLhHtlIKiA4PUQeHpQPrYenQsDeMEhrYzpQsjSJbvbP2dojwhV7to12fYxG9fogWRLrCeFyXE5LIX4q1ekUEvNPdJqb/jpLwL0dWLcC3GHmKxOkbaih23P0cbTK88AgshBz1YOrhnGR0XAl1Pqj9qj3uTa8u2XMHmNyhrKn1b8O5YnOOYMknXo3du+O/XSqbzkxjwJEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqWyj9kbB/IY6khdByrX/ODOsanVSKZZsPO840cVIvQ=;
 b=bqm3gV03HvVqqDSwHOblirs/VodrnmHnHg5O+2oSagcInM8mup8scgnCbsNMvb/HJMXoTW2C0SotGaAQq+4mM4RYdI+/R/0IhY/u2SbaFYetCy3VpTr3F14/OCsAZ+rR4p9+P2LhIYFzyIsatYaeHhf1ERGeJl3UztFmj86JWXpIr8E4YdPnnsQ0DAgROrc2X2ENWca5CYJNy35TemeqwX9mFPFYZdWtjL17nlyzqgbS1dHDApAYLtxeETMavyKUobE1yDh6Fk4/pYHE/PqJlJL4l8b+Wysc9rhhBWStbg3E5/ni13tmCSRtNpnbk5quSZgoX080KE7nNlt1UhhT9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqWyj9kbB/IY6khdByrX/ODOsanVSKZZsPO840cVIvQ=;
 b=KOdFTIAC0OXoq/m25sZTTYBflUZRuFyhUw0eVhlTY2hCXhcGjnNOMTE8wEBZ917fed6iIGb2/Y+cEk1pe8J91dNhIBFjkLL2Tjw5IEHS7HOHXe/JO32xCakgOVDCDLLTRxFethsPDxnXNWXJj/Y886YoSSUKAqRpa35KLbBwwFQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5686.namprd04.prod.outlook.com (2603:10b6:a03:103::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Tue, 19 Jul
 2022 11:15:12 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 11:15:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v2 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Topic: [PATCH v2 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Thread-Index: AQHYmJGXBdLTHJBKMkmM0zNPfFrcDq2FgnVQ
Date:   Tue, 19 Jul 2022 11:15:12 +0000
Message-ID: <DM6PR04MB6575E66298A6E29011FD9958FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220715212515.347664-1-bvanassche@acm.org>
 <20220715212515.347664-6-bvanassche@acm.org>
In-Reply-To: <20220715212515.347664-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7041d357-6506-4800-71ff-08da6977f31b
x-ms-traffictypediagnostic: BYAPR04MB5686:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4aVhG35ilV77uVVqOS4ZAbgVDNBKRAorfb4Td4/RVyWkuDK++MHuZ7xY6SQaaeK8N9NuMHSx7UROHU+DwdnWIRz2AbRGmqp/XrboIl+W6HX6Yw8eDkOgzHtsWGC9dIo4TiqExKtydlSc4GQPbppGuLschU59h4KMhRM1cz58yU2LzYV9uLGqtmJ3zeG071dwd891W1bT36F1x9B511UNLrW5FMxM/cqHK7q0s3NO/VBQQSUkoVkxqdSZkRpwyGyBJOjQDLuICIVjOvmqbuEI8A3fQi9uxY6n8HSdzcEn7m3BzvEzo2G/bgKfu3vjZXJ9SZdVLDY92pjbXYOUeyiZ7K0jeS3E9MunFxMa1HgFSbOEcovFItFG5lkgQyosJTYX10UYA8C/7E/2OtsZGeLEjy3Z6ZVplE5fH2yjs1b1KyrGZ8V4umKRTweDih7E3ka8/Vy9KIem2djQq/vP5o4piLarEr5wopc/vX5dGZaLPsXVDgqTuebupj7hjX1klMYR7wu/ROjP8bLvIIDMiuOY4FK1Kq7Y2kiH49NiFNLapNnbndXfpfzmF6TpIS3Dpo288bqvhCnJT2Qn9UnogVkb7k/M8rQTKfDEXDxU7aONQRItNRXUiUWZvo8ts1kf68QmLZWKkM2ruVKkGDcf2Yc37awfwENs72Hv6orctiB1649le7qRx8Rg7ljlAfKtmVVttG6wzGZU/1OtQrjtGyfItiMzSI60mUOOhUzgoN53lQZj4xaV5o0UA2TatcniDco1zYPWhu3pFznDSV73GN1SqbZklaXcymDYklsEQADT7OQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(8936002)(33656002)(52536014)(86362001)(66476007)(76116006)(66446008)(4326008)(66946007)(8676002)(66556008)(64756008)(6506007)(38100700002)(110136005)(38070700005)(54906003)(55016003)(316002)(82960400001)(7696005)(122000001)(9686003)(26005)(41300700001)(186003)(83380400001)(30864003)(71200400001)(478600001)(5660300002)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hugY5gEoyjXGKfd9wLecbAcMoAopAgfHRrjzbx9ZT7+Qw01KWcRsUtVgI0rh?=
 =?us-ascii?Q?3GIFRI5RdzEL02Hy7q3SBQ/BcuZ/49zcOUARqn1RW1fpksDivLQ15u/91RY9?=
 =?us-ascii?Q?ymRybdcDF3Os7ZDEer37aIJrKiZvoCRR42FcYZctq6yuuX8Fy6dz0Muyii4O?=
 =?us-ascii?Q?JEwhiRb3j6KWMnvscvXvUDGQ3y0tfOzY6wqKXCNGLTlq2wcoPmDn7MQ/gyo9?=
 =?us-ascii?Q?eRmUcTntXuuANS+8l7aur2TQWPz5aYkY+mgDxXeuyvYv03R76NSJk4kiPI/C?=
 =?us-ascii?Q?ylAnCDhZNJWu9koSi6jX+JKyyfbD08q4ehA2AEwlBXV14A336VWH354iC07J?=
 =?us-ascii?Q?b9NeI/b1i6Yo4CTHlddEB2FOjVNuGoge0TVZSGyhCzeJeCBtclLwyudWOLM3?=
 =?us-ascii?Q?C7j9zNP56dzQzL/FG8tQ1tvhIrzvq5ncQXwPgkrnQM65k2VAtHGVIRGgsYbw?=
 =?us-ascii?Q?yIHACWS8KaXHFzxhJMVFvUCOfWfy9o4V25q1cOph3izd2lLwb07/yV4K27i5?=
 =?us-ascii?Q?DxzKMs8KqtX4+95Z4hADWmG7kBxcYRaQdG7UmylI5Q+0NfRewY8Q5/FOK6Mg?=
 =?us-ascii?Q?kC2RU0Q8NxqPMQeeAmXehwyutzpmR/B4rBWX95thwogkxe2ZHySa9JWcCT/s?=
 =?us-ascii?Q?RT8Gd7r76Vw+eEHn/zGtNRg16jQN7VVbx3HwJtwpbRaiWxmvXdr+6JVw4X1k?=
 =?us-ascii?Q?2eX+D08BxCgF2IYUFmBMDG3cdzg7zLmnJ5kmMiP8EcRzdpYTznfCo33MZtUl?=
 =?us-ascii?Q?X5UrqSuYJs5S2DPcP0G31uZjrqY0oyUdQOMzACwXd02oyc1WSUSXstOUDzkg?=
 =?us-ascii?Q?htvjxWz0zGWvl2gOE4WbV/MJ9eOgbR9eD8soThNBddm6PhhdnaUW98yIdRty?=
 =?us-ascii?Q?Qu+pG5y+/lZc9q0buwK34D9SRRHTkwE767wYdNsEv4hq73C/2VunTNVVe0zJ?=
 =?us-ascii?Q?gOlOR8hG+HK7fxwWNEDpaDZRsYMq2jht6ThrPXS879AeYxNp3pKhp8zjIqU7?=
 =?us-ascii?Q?CONJgBk8fSEu5tJqvC8EUL8Gb5GcMb2Ufgflv02YULGzB2ga+JYntH3P9cAC?=
 =?us-ascii?Q?H1fUbEevcmZ9hMImqJ7c9JXtsZxr65X+BjdlPJnuG9iFp9ceEQME77yZeHSw?=
 =?us-ascii?Q?QF+MdPWfPLoHXTfI3MTpznnvd29eRWXgFLahrj/xvZ758s44TgeSSJEvd1+R?=
 =?us-ascii?Q?4FAdZM5YyN7mhU0N4rMAXqp1sH7LJ0SUL0MdOWtOKbcrxcUSrQl4f0UMKsxS?=
 =?us-ascii?Q?vksRhUAJcvTm8eXmUfRoG/xTwLpUl/RjvJVDcdVz2pdYEILvjnFdMaPCiPBF?=
 =?us-ascii?Q?bV3/4pL74IfXQTgm60NvCw9JH7hkI5RCdzAaIckQWmf4Z//iL9UQVgf+98Xh?=
 =?us-ascii?Q?M1vuDOTNOIKps2g4avXmK/UXEQo0p+c8sdSXdOBHeAiMZNmHIKr1ugCseJKq?=
 =?us-ascii?Q?754c+FRCHrjZ3osTP0JbF8+f1/qHdwx31qCvsQX8cCG+0wrJavXheGgxKtWG?=
 =?us-ascii?Q?3sUAQY11pMyo7d6sFVzZGg586HjOFJ10mrrteKcWDDaGv0hMhKu7OhZhQT2N?=
 =?us-ascii?Q?vXIk2BxCYP2rGyWj9fKZIKrLYQ0iAgnJJFGYdeAZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7041d357-6506-4800-71ff-08da6977f31b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 11:15:12.6564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k91oFUWVNB+Jq2ELUeVOlDT1+mdI+K/fxEM6Svp3oK2TzBKISubL2WBJq+t7KUSb4yle7nITyiGlCspfu28hYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5686
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Eric Biggers <ebiggers@google.com>
>=20
> Modify the UFSHCD core to allow 'struct ufshcd_sg_entry' to be
> variable-length. The default is the standard length, but variants can
> override ufs_hba::sg_entry_size with a larger value if there are
> vendor-specific fields following the standard ones.
>=20
> This is needed to support inline encryption with ufs-exynos (FMP).
>=20
> Cc: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> [ bvanassche: edited commit message and introduced
> CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++---------------------
>  drivers/ufs/host/Kconfig  | 10 ++++++++++
>  include/ufs/ufshcd.h      | 32 ++++++++++++++++++++++++++++++++
>  include/ufs/ufshci.h      |  9 +++++++--
>  4 files changed, 67 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8363d2ff622c..8894d66413e1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -523,7 +523,7 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned
> long bitmap, bool pr_prdt)
>                 prdt_length =3D le16_to_cpu(
>                         lrbp->utr_descriptor_ptr->prd_table_length);
>                 if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> -                       prdt_length /=3D sizeof(struct ufshcd_sg_entry);
> +                       prdt_length /=3D ufshcd_sg_entry_size(hba);
>=20
>                 dev_err(hba->dev,
>                         "UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
> @@ -532,7 +532,7 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned
> long bitmap, bool pr_prdt)
>=20
>                 if (pr_prdt)
>                         ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr=
,
> -                               sizeof(struct ufshcd_sg_entry) * prdt_len=
gth);
> +                               ufshcd_sg_entry_size(hba) * prdt_length);
>         }
>  }
>=20
> @@ -2437,7 +2437,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba,
> struct uic_command *uic_cmd)
>   */
>  static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  {
> -       struct ufshcd_sg_entry *prd_table;
> +       struct ufshcd_sg_entry *prd;
>         struct scatterlist *sg;
>         struct scsi_cmnd *cmd;
>         int sg_segments;
> @@ -2452,13 +2452,12 @@ static int ufshcd_map_sg(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>=20
>                 if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
>                         lrbp->utr_descriptor_ptr->prd_table_length =3D
> -                               cpu_to_le16((sg_segments *
> -                                       sizeof(struct ufshcd_sg_entry)));
> +                               cpu_to_le16(sg_segments * ufshcd_sg_entry=
_size(hba));
>                 else
>                         lrbp->utr_descriptor_ptr->prd_table_length =3D
>                                 cpu_to_le16(sg_segments);
>=20
> -               prd_table =3D lrbp->ucd_prdt_ptr;
> +               prd =3D lrbp->ucd_prdt_ptr;
>=20
>                 scsi_for_each_sg(cmd, sg, sg_segments, i) {
>                         const unsigned int len =3D sg_dma_len(sg);
> @@ -2472,9 +2471,10 @@ static int ufshcd_map_sg(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>                          * indicates 4 bytes, '7' indicates 8 bytes, etc.=
"
>                          */
>                         WARN_ONCE(len > 256 * 1024, "len =3D %#x\n", len)=
;
> -                       prd_table[i].size =3D cpu_to_le32(len - 1);
> -                       prd_table[i].addr =3D cpu_to_le64(sg->dma_address=
);
> -                       prd_table[i].reserved =3D 0;
> +                       prd->size =3D cpu_to_le32(len - 1);
> +                       prd->addr =3D cpu_to_le64(sg->dma_address);
> +                       prd->reserved =3D 0;
> +                       prd =3D (void *)prd + ufshcd_sg_entry_size(hba);
>                 }
>         } else {
>                 lrbp->utr_descriptor_ptr->prd_table_length =3D 0;
> @@ -2767,10 +2767,11 @@ static int ufshcd_map_queues(struct Scsi_Host
> *shost)
>=20
>  static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb,=
 int i)
>  {
> -       struct utp_transfer_cmd_desc *cmd_descp =3D hba->ucdl_base_addr;
> +       struct utp_transfer_cmd_desc *cmd_descp =3D (void *)hba-
> >ucdl_base_addr +
> +               i * sizeof_utp_transfer_cmd_desc(hba);
>         struct utp_transfer_req_desc *utrdlp =3D hba->utrdl_base_addr;
>         dma_addr_t cmd_desc_element_addr =3D hba->ucdl_dma_addr +
> -               i * sizeof(struct utp_transfer_cmd_desc);
> +               i * sizeof_utp_transfer_cmd_desc(hba);
>         u16 response_offset =3D offsetof(struct utp_transfer_cmd_desc,
>                                        response_upiu);
>         u16 prdt_offset =3D offsetof(struct utp_transfer_cmd_desc, prd_ta=
ble);
> @@ -2778,11 +2779,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
> struct ufshcd_lrb *lrb, int i)
>         lrb->utr_descriptor_ptr =3D utrdlp + i;
>         lrb->utrd_dma_addr =3D hba->utrdl_dma_addr +
>                 i * sizeof(struct utp_transfer_req_desc);
> -       lrb->ucd_req_ptr =3D (struct utp_upiu_req *)(cmd_descp + i);
> +       lrb->ucd_req_ptr =3D (struct utp_upiu_req *)cmd_descp;
Maybe here cmd_descp->command_upiu ?

>         lrb->ucd_req_dma_addr =3D cmd_desc_element_addr;
> -       lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp[i].response=
_upiu;
> +       lrb->ucd_rsp_ptr =3D (struct utp_upiu_rsp *)cmd_descp->response_u=
piu;
>         lrb->ucd_rsp_dma_addr =3D cmd_desc_element_addr + response_offset=
;
> -       lrb->ucd_prdt_ptr =3D cmd_descp[i].prd_table;
> +       lrb->ucd_prdt_ptr =3D (struct ufshcd_sg_entry *)cmd_descp->prd_ta=
ble;
>         lrb->ucd_prdt_dma_addr =3D cmd_desc_element_addr + prdt_offset;
>  }
>=20
> @@ -3669,7 +3670,7 @@ static int ufshcd_memory_alloc(struct ufs_hba
> *hba)
>         size_t utmrdl_size, utrdl_size, ucdl_size;
>=20
>         /* Allocate memory for UTP command descriptors */
> -       ucdl_size =3D (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs)=
;
> +       ucdl_size =3D sizeof_utp_transfer_cmd_desc(hba) * hba->nutrs;
>         hba->ucdl_base_addr =3D dmam_alloc_coherent(hba->dev,
>                                                   ucdl_size,
>                                                   &hba->ucdl_dma_addr,
> @@ -3763,7 +3764,7 @@ static void ufshcd_host_memory_configure(struct
> ufs_hba *hba)
>         prdt_offset =3D
>                 offsetof(struct utp_transfer_cmd_desc, prd_table);
>=20
> -       cmd_desc_size =3D sizeof(struct utp_transfer_cmd_desc);
> +       cmd_desc_size =3D sizeof_utp_transfer_cmd_desc(hba);
>         cmd_desc_dma_addr =3D hba->ucdl_dma_addr;
>=20
>         for (i =3D 0; i < hba->nutrs; i++) {
> @@ -9601,6 +9602,7 @@ int ufshcd_alloc_host(struct device *dev, struct
> ufs_hba **hba_handle)
>         hba->dev =3D dev;
>         hba->dev_ref_clk_freq =3D REF_CLK_FREQ_INVAL;
>         hba->nop_out_timeout =3D NOP_OUT_TIMEOUT;
> +       ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
Where are you setting this variant for ufs-exynos?
I would expect here a set_sg_entry_size vop.


>         INIT_LIST_HEAD(&hba->clk_list_head);
>         spin_lock_init(&hba->outstanding_lock);
>=20
> @@ -9979,11 +9981,6 @@ static int __init ufshcd_core_init(void)
>  {
>         int ret;
>=20
> -       /* Verify that there are no gaps in struct utp_transfer_cmd_desc.=
 */
> -       static_assert(sizeof(struct utp_transfer_cmd_desc) =3D=3D
> -                     2 * ALIGNED_UPIU_SIZE +
> -                             SG_ALL * sizeof(struct ufshcd_sg_entry));
> -
>         ufs_debugfs_init();
>=20
>         ret =3D scsi_register_driver(&ufs_dev_wlun_template.gendrv);
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index 4cc2dbd79ed0..49017abdac92 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -124,3 +124,13 @@ config SCSI_UFS_EXYNOS
>=20
>           Select this if you have UFS host controller on Samsung Exynos S=
oC.
>           If unsure, say N.
> +
> +config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> +       bool "Variable size UTP physical region descriptor"
> +       help
> +         In the UFSHCI 3.0 standard the Physical Region Descriptor (PRD)=
 is a
> +         data structure used for transferring data between host and UFS
> +         device. This data structure describes a single region in physic=
al
> +         memory. Although the standard requires that this data structure=
 has a
> +         size of 16 bytes, for some controllers this data structure has =
a
> +         different size. Enable this option for UFS controllers that nee=
d it.
Then this change should take the form of a quirk, AKA "opts" in exynos_ufs_=
drv_data.


> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 6d78bcbedb9e..a1d0dab9a01e 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -744,6 +744,9 @@ struct ufs_hba_monitor {
>   * @vops: pointer to variant specific operations
>   * @vps: pointer to variant specific parameters
>   * @priv: pointer to variant specific private data
> +#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> + * @sg_entry_size: size of struct ufshcd_sg_entry (may include variant
> fields)
> +#endif
>   * @irq: Irq number of the controller
>   * @is_irq_enabled: whether or not the UFS controller interrupt is enabl=
ed.
>   * @dev_ref_clk_freq: reference clock frequency
> @@ -865,6 +868,9 @@ struct ufs_hba {
>         const struct ufs_hba_variant_ops *vops;
>         struct ufs_hba_variant_params *vps;
>         void *priv;
> +#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> +       size_t sg_entry_size;
> +#endif
>         unsigned int irq;
>         bool is_irq_enabled;
>         enum ufs_ref_clk_freq dev_ref_clk_freq;
> @@ -967,6 +973,32 @@ struct ufs_hba {
>         bool complete_put;
>  };
>=20
> +#ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
> +static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
> +{
> +       return hba->sg_entry_size;
> +}
> +
> +static inline void ufshcd_set_sg_entry_size(struct ufs_hba *hba, size_t
> sg_entry_size)
> +{
> +       WARN_ON_ONCE(sg_entry_size < sizeof(struct ufshcd_sg_entry));
> +       hba->sg_entry_size =3D sg_entry_size;
> +}
> +#else
> +static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
> +{
> +       return sizeof(struct ufshcd_sg_entry);
> +}
> +
> +#define ufshcd_set_sg_entry_size(hba, sg_entry_size)                   \
> +       ({ (void)(hba); BUILD_BUG_ON(sg_entry_size !=3D sizeof(struct
> ufshcd_sg_entry)); })
Why not static inline void?

> +#endif
> +
> +static inline size_t sizeof_utp_transfer_cmd_desc(const struct ufs_hba
> *hba)
> +{
> +       return sizeof(struct utp_transfer_cmd_desc) + SG_ALL *
> ufshcd_sg_entry_size(hba);
> +}
> +
>  /* Returns true if clocks can be gated. Otherwise false */
>  static inline bool ufshcd_is_clkgating_allowed(struct ufs_hba *hba)
>  {
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index f81aa95ffbc4..4e764016895d 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -426,18 +426,23 @@ struct ufshcd_sg_entry {
>         __le64    addr;
>         __le32    reserved;
>         __le32    size;
> +       /*
> +        * followed by variant-specific fields if
> +        * CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE has been defined.
> +        */
>  };
>=20
>  /**
>   * struct utp_transfer_cmd_desc - UTP Command Descriptor (UCD)
>   * @command_upiu: Command UPIU Frame address
>   * @response_upiu: Response UPIU Frame address
> - * @prd_table: Physical Region Descriptor
> + * @prd_table: Physical Region Descriptor: an array of SG_ALL struct
> + *     ufshcd_sg_entry's.  Variant-specific fields may be present after =
each.
>   */
>  struct utp_transfer_cmd_desc {
>         u8 command_upiu[ALIGNED_UPIU_SIZE];
>         u8 response_upiu[ALIGNED_UPIU_SIZE];
> -       struct ufshcd_sg_entry    prd_table[SG_ALL];
> +       u8 prd_table[];
>  };

Thanks,
Avri

>=20
>  /**
