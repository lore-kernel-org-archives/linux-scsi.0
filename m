Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04732C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D377F611B0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFUIYS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:24:18 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23002 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUIYR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 04:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624263742; x=1655799742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GdK1kHAkX4BmT2Kg96iPlaMHRUJL+z/EyrTcDt5OhyY=;
  b=q0zYp+XZZMxEwDdLHtHCdFKDRi2WxmWLAir1TwqpGMd8cTqtfyGnvP/2
   dla7WrUFGhb8H1rdiTxAFNJcLqeXz26I2QqcsqH9xgWtmLhEEUHfEIu5F
   M9xh3UpVRgFNDVAZ8XcEbtYD6y4JwdtN94ByMFLxRT18nB1JKZgZmVXID
   4mvvD8Nk2HXSpj6KLi73qWnMsQfYcFolazc8MueeqJxQKCWzhFjvDSONU
   Hvzk7pcdf6vzWhYrx6PY9mPMJlJtZ2ZKZOO1vDbyUGp7TmHsE7ghlO09A
   mFwraf9CIfanzy7iVXwhMRNdePqaDYPRm73F6S0coSVgUK/e8DEeZGgwM
   Q==;
IronPort-SDR: Qa6FDX3MqwJdcDxV6MTQnRaD9+B/CWc2jt8F0Wj1USDS9SyusKWOjaXsb+ay5IJ5DicAxFFqfm
 1MjPq2hf4eSth6i2i3tSW4nfB5aayEXr/9eWwWXZxK5dOG8fFGkjPHQAUnIKZSIWsaIuYH+Aae
 Km6GbyfJ22j+gLYIc1wxXmrAU9QvdyM0gKtC/DsJPk2iLPjAKoKEa0IBOZureI9xuACM0R24GQ
 2UNMBc2E34UAo4c0UfdsMSf9S2AgXv16Eo8ipjwCAwP1ORNZ1EeCOVgCdD367cRWxhcK6CFTQQ
 WuM=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="276252262"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 16:22:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIkh8Xy7F+SFWA+bOk6T/78DmQXXIX3SGYV2Kqt2Fe9HQ37OuT2Erx7mjsJEi6feyf8PmTcmJLSOm9+h14ebWIz6pw6c4PIQJ52A7V4FLzMmbB0y4B9c3B0UuQ+SRG3TbCs1jUtFENrnc8Lo2aoSqxqhaFLEoAAZtTYPTj64yC8Uq4om3YOYVz7f6LcrkrNm5caPtgbM5TxRLHoOiIOeCHox24WVvAGypGTBus1KxdODVGFnadkLBlR7BcGbJD0axjRvw5FEwdmYRWM8Nd9dmGeGMB2eGKn8UL5K3G5aSru5NYaw6/QM42M8iEzPi3eEIORuzYwFPXB4U4x8CgzH5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfPgTMRQ5mbb4u9nOk3JxBzzLNNk+vbcYuImK3iImCM=;
 b=mr513l/3/ccsx/NAdQJXbhHiipDKneOOl5TxbVpnM3y4usc2RqcIcE4Gqv7zhLE79w5MDgerf5O33r8Toeb0Hr1B5yiAKKhykfdVn4PIOYP/hMT1RvTO2u2EKODVE34GXYXRn16cNOsPYxB4KFfBaTK83trMPxYiIhPx6ZjiOxbeGGhPKMGLAennFlZTV65eQZnPpsgzN5km6oziqiLm0/e1LNzwKuBOaufLYIc9kkYmzBeERG2d44klcziSrsYcnUErn2AFvK+GwuRgKRwsrUCf2VJ5SN2z2OqQCccza3UZhjbueW1nwq/rTtJHTGjosoBPHoAHoaC98LDWGHG/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfPgTMRQ5mbb4u9nOk3JxBzzLNNk+vbcYuImK3iImCM=;
 b=olAWIUFhmxSOWDsj/5RH8HfMX4+T4zOuKPJivmitBK+23wK12wYRkAvbszVU1XbP/vveifLRpP6QK9ybCkcFsbjXLAb99DADO4gIFyagjcoH9mpk4iYgu/oKkKG+CoROlZhALQhtC6KMuYPBhdjBEYKqPJzUIfZxRQb2jgNPBJE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1116.namprd04.prod.outlook.com (2603:10b6:3:a6::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.23; Mon, 21 Jun 2021 08:22:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 08:22:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Gilad Broner <gbroner@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH RFC 2/4] ufs: Remove a check from ufshcd_queuecommand()
Thread-Topic: [PATCH RFC 2/4] ufs: Remove a check from ufshcd_queuecommand()
Thread-Index: AQHXZKVtU5ZBoOSLFE6bmt9glyfW1aseIzxA
Date:   Mon, 21 Jun 2021 08:22:00 +0000
Message-ID: <DM6PR04MB6575D553EA3E6938FEAC0F9DFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-3-bvanassche@acm.org>
In-Reply-To: <20210619005228.28569-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e698cabc-440e-4f0a-9701-08d9348da4b7
x-ms-traffictypediagnostic: DM5PR04MB1116:
x-microsoft-antispam-prvs: <DM5PR04MB11167E6BE8F643DF9C692F5BFC0A9@DM5PR04MB1116.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bgj48UBxoaeTHPnBKpjYdbm3KPoZ10UK8A3G8574btwHTIySD+uqcJGj2Q4GqehCx8ZjGobMERvBS5cCI43/XAapxEGWYr8X9DCnzbnMoorG1gGfeHT2wrBPtjplutxy1QRUu3fjMup9biyfQ0op983TTOQxNwM2fUR8/dqH9TbR3XQxSPqMP2Lsrg8fEMxnaPLz+Ly1F5GeEIoSs+UFVrnFmtJbvdyf2IUJqKmIN7wBBUMQD1bpu0F/sLq7ZBt+yQZ8AzxQqAMsyalhIHQiG5BBticUJG4NuVf5DZdU9rqjwX1ESFLI2xFStvQMphVK9+wlSwQCEmfdbr02oeqTXKI2Tp/5McSaktQ0kEYiht9HxLMKIg8aWkQqUYp7SwpBmTybPS/F+2nzZeDfnH99n7CayKdm4xqil7OZDekZqyjMMew+hy6VQ0q28i7MjbTd7RakYjglstu6r7BNz9eeD6iIyFNg0/S7STG/ecnISCWaudc9zWcJZ9IffwzT/W/zwgSG/JCFR/9M/gajXumP46H8E22UkbgdFEUvx8PVOI+MkrGvTA6s1VJN2ZWzLXrPXPkIHxQYsGgf1tb2/lkzkFtI4y5rZBSLukam8/NnWic=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(26005)(316002)(186003)(54906003)(110136005)(86362001)(478600001)(7696005)(5660300002)(33656002)(8676002)(8936002)(7416002)(2906002)(52536014)(71200400001)(6506007)(122000001)(66476007)(4326008)(55016002)(9686003)(66446008)(38100700002)(64756008)(66556008)(66946007)(76116006)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5y85bEsN00oqfiaiEnX0iCS0UHab71nGKh2cFj6mXogG6lgFFSrAEF/RtVE5?=
 =?us-ascii?Q?BeyiyzNQZYMgKvYuMIX4a7/fcoLq6dNPxeZ5N0WM9STgXX+r3SOX64czgkVi?=
 =?us-ascii?Q?wjJCT/YNph9sHbyEznuI3OBEjELeZPJ4K2X4BqGNMykvnpuOLee6GDtyiIWt?=
 =?us-ascii?Q?y3tRKohhY1RFDrkxm1e8KgM/Lp8Vyw5GfK0mKdAGynUB+M6x+CKm4R8RTxAK?=
 =?us-ascii?Q?dC6Y5dzHcqSl6eZQ5ZNF2ieafpDEmx5AES/7xFIWnWcyStsrG1RMgCZQnTsI?=
 =?us-ascii?Q?3EIu0THQ7OcqG4h6twuI5ABSEAyvgLTA30EnH16HYlmb4L4dL9iE958wcynF?=
 =?us-ascii?Q?lEVqGXFZMEgGIBc0Z3tO6TYEym23snBb7dBCV9HsWKGCL4W8aZcuxgNtVP0V?=
 =?us-ascii?Q?DbY4usmiiSHIK7/obyGK4tc2W8/AIcL0dliPE7dyBsNeFUEyUdQyJwguhcUn?=
 =?us-ascii?Q?8pRBtZDn9RCrLKZ6yE0hv9A9SI0JzRLjN+w1m9BvbbvtD3FGXxxNWE+vPm2I?=
 =?us-ascii?Q?AmeV0nfqc/gxq0wZUYCHB2dKAxLqMrbcb9k1NW8beINqjaSykZROignJuguD?=
 =?us-ascii?Q?P6pk6Sf/cUco0psVnCo6VrNSCix2gPDpzQWcXF9CxRs2yzn0iiGZg0gu40Nh?=
 =?us-ascii?Q?3Jkzblp6fPE44++eSUZiq5HdJUPYpt2PbUHuaz7peo7VMBcoLnyGxLzm9BkJ?=
 =?us-ascii?Q?hKByiq+RpXlE/NNH5EEI3h0e1zlAMS/mGzJqoSPTY1GWsvvW8aLD0GCoSZn6?=
 =?us-ascii?Q?E07mb1u0PTO8IQ4eK+HS0tn03mEacVdIfWSzM6UVkP0dD+bDOCKXp3W7zUmh?=
 =?us-ascii?Q?p8lz2CdDs+NfjMXMUXZ9CPjenFzGpfs3kn4uvqVCi3rDjHh/UnL3yPgVi18i?=
 =?us-ascii?Q?VxN5KDcVHE1wiF/PBEXWhEWPGVbtusKwzEm7y69+LWKw74KM1/hmzeha1d6x?=
 =?us-ascii?Q?8SKQhJkawEExg9gFRlXfQ9V1rirthjd76R8Rx2lXdU3qM0SkqWRzitxSTFF4?=
 =?us-ascii?Q?2BMDROqnV/BAK2Qy7GjDecJdjeHC5g2swRFqkby7FKZyovIx/vy4NacxmvjP?=
 =?us-ascii?Q?5gxFLdCU9YbvVcs1jhRKNs5x1pX5CGzj/QnJaIFppJdYQJusIszGEKsBtRvU?=
 =?us-ascii?Q?kWPA2bD38u5WsQF9Re2x35d2/n9XttULemhuak0Mn9/xn5YH/Bw3nFD2VpCO?=
 =?us-ascii?Q?mU/XWaVB4dn2m18SojzhKtCSYnAcRsmj+KTAR4gfKmgdOv5ou/96mvjDaFE9?=
 =?us-ascii?Q?emLG185P5l4tR4jhSmZY9lxENec1JblGerdYaS0c9vTT5FcD1bco33XexMuo?=
 =?us-ascii?Q?upw8QNHLXj6jDUfmE1inVUCE?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e698cabc-440e-4f0a-9701-08d9348da4b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 08:22:00.7158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FwfjGlt4h2cp7mlUOvmSphuPEXVTALbngCHWgmczW36VlLY6l6W0+1gN+Ym/4qqWjIN+cTVQyJbMrhY0/My38g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
> shost->can_queue to hba->nutrs. In other words, we know that tag values
> will be in the range [0, hba->nutrs). Remove a check that verifies what
> we already know. This check was introduced by commit 14497328b6a6
> ("scsi:
> ufs: verify command tag validity").
>=20
> Cc: Gilad Broner <gbroner@codeaurora.org>
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c230d2a6a55c..71c720d940a3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2701,21 +2701,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
> struct ufshcd_lrb *lrb, int i)
>   */
>  static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd
> *cmd)
>  {
> +       struct ufs_hba *hba =3D shost_priv(host);
> +       int tag =3D cmd->request->tag;
>         struct ufshcd_lrb *lrbp;
> -       struct ufs_hba *hba;
> -       int tag;
>         int err =3D 0;
>=20
> -       hba =3D shost_priv(host);
> -
> -       tag =3D cmd->request->tag;
> -       if (!ufshcd_valid_tag(hba, tag)) {
> -               dev_err(hba->dev,
> -                       "%s: invalid command tag %d: cmd=3D0x%p, cmd-
> >request=3D0x%p",
> -                       __func__, tag, cmd, cmd->request);
> -               BUG();
> -       }
While at it, maybe remove ufshcd_valid_tag altogether?

Thanks,
Avri
> -
>         if (!down_read_trylock(&hba->clk_scaling_lock))
>                 return SCSI_MLQUEUE_HOST_BUSY;

