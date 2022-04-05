Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE89EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiDEGzy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiDEGzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:55:46 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBDB2C7
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649141611; x=1680677611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LvXs8EuCvrvt139QK+TaiFBjVeLKvbPnrkVMqzMweMU=;
  b=AAmjyY4jLBiQcU/+lnSFYANV0gfYMdyyVmrV18KayR4APd/V5eJhdiT1
   Na20kRA25gJPLjmA1oDjLbxW1wFGD588w7PjEmLHIGTYfRTxXIej0Jfwx
   FpcSv708fpL9Dkl83QnDdbZp66rCOjOU/i6UW9Ek/mBNv4GtYf97hKPFY
   EsXhG+J8lasOwVq7nutx4hQRJL7L5Ys4rDpJFYio/UgM2eOj6hC7HYmYP
   xPfClzW0fP+w7LuGPOEeTqswiAyTUHva9rFei36UV4E00t4foJn6lWJ1k
   23mG8D1HoJ5RSYu35NiNDi3Vi2abnrG4ClfG1Fv2dywUlyl4kdKyrychX
   g==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643644800"; 
   d="scan'208";a="197112467"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:53:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6fvjiuW5cn1vpjNTCz+3Pxi7iXbI1OxBy1uxjpm4B3C4QDXwDbH8hwnqxquC+dzs0934bu5lSlP7kug/12B3cEtCHUor941SbcN3LNbapzUxpKuNk92VSMLOTodmua8Va0TZ3ZSd2fub+1AqqLhXmqQ3FaEAZW1oPD8b7RJYl7fzdH4U/rfxxUhV35sV1nxTZKMa1nT9tb1DxuTwQ4nL6/h+PUu6jGS8t2eSYIWZNLm+fkf0fY5opr955M/HNnrHW2XWxVzPDDtkoy0Z2U1YRwTdmh5iSYxJihsf5WHj24hGf4gQGMoB4IEEAVfi4qCNCMYDk5sMYvIJupGP+TEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeLcJdRBujClQ+Cdv8BHV9R0TOD8wU3xHpdB5cixWyY=;
 b=IZgSzNAYcDPcm+KXIRLjxenJJKX3wCLIjOsetzRhMUYjno/Bpy2QlAmRGJzbQ9fIx6dDiLvY6jrUGZTDfUbC2HiImo3v0kmZNcbk13x1glondTqSYA8EzyyOpZPGtmJXbW5VhmQ/1U8Uw2B30DB918xtN2QHyVJ5ujwV2Cla5JCspqMrQo6QbzxOdDbbu7pSfZeFnc1GhDJb2zm8Aw7CJbGX7aJXKive7SKaF7HP/lvPnXBW4Xcfytnc3M6rrgrnGM0jHEIYqLk9AEUYSZ/8BJ5mzpTle45SY+HK9eChHEMNP2gfDpbeUdOkeyybja55vdOwA2eoB4x9fHQTOLK2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeLcJdRBujClQ+Cdv8BHV9R0TOD8wU3xHpdB5cixWyY=;
 b=s135Wti7tq75JnlaIw/iam40+aYnDMkEh6FTNGngR3sgZ0oR8k+wuRGShHA7CypY2EtKBLGE4JXIdCbKxuoOIjbXD3Mhc8m2Me+5NSwLoZaVA71WeyOarYx0Umjhw8u9kweDa+Ek9jfymwIzOY3rqnvBfraKOScMaXpdX7SuO7w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN8PR04MB6161.namprd04.prod.outlook.com (2603:10b6:408:50::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:53:29 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:53:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: RE: [PATCH 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun()
 definition
Thread-Topic: [PATCH 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun()
 definition
Thread-Index: AQHYRVBS+gHDB1yQBEKgwudWmsWqdKzg6NUw
Date:   Tue, 5 Apr 2022 06:53:29 +0000
Message-ID: <DM6PR04MB6575F48E7D66AB4644CBD87EFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-29-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-29-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61287096-82a9-4e1b-da69-08da16d0fdf4
x-ms-traffictypediagnostic: BN8PR04MB6161:EE_
x-microsoft-antispam-prvs: <BN8PR04MB6161040AD34C1397A1E835BFFCE49@BN8PR04MB6161.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPvLCDYU49SzK1smkbmoL3NYHrJiVIWbfj1zEACNYTKRCm+D9FZKP9v6+l/4FvtnO+NRuLruKxRlzMi/cBluaaWmzJuOMFgPPmc7l3EqXwn2kdx6dHM7lXkQ+2oionLaMB9wMSjwXgYFFkDFVHgl/lnCb3Z1peO1s9i2BVOR3G6ovIv6k8hgdrVhhEB50i4hCUkPSucaWWyplqy5PJgo5pbTTeMLJ4H//Mpyx5oQSsjw/k8r94pdijBhi4wZZfBQRgU6bflp7U79BUyxoTSTU/MOvDO6qPApeVbDNehWYV82Zrf7RII8ALN3EZNH6LcpBUE3pk49jmqEnePxnINLKDtNyQ5oyfmjiOHJcybDZbdFQ8k0ME8UFerwJHJ+hm37OgINxXvK9yEMb+3ib1IH3UrBOyTuBtjjVHxtd36+2lq+8MxKW/H/dWWuqQjFmFKyx6+Ig60tB6frXDFr/n7EmccB9AAR3MOmCZ1mjfUM+xn5b+Nxg++HKTEfqc+gv8rUjgxtYDxh0MQrnok7no7xeasigvnaGuWeZj3Izi2LoXH77rmYLlUi14Zav8y8poUmV7oqNgAyNxroHesuvL/u8rI+y1IGwixLyPIbHqzxAgQJxnqdCDrM1SW/GEOFCOx/VNu8mRmzbcvTjT/C67v0zfR+1HaWqIsTlI6nCQDDL1HjzVxnYezWCPzY1aU+HGeo4QYKkjLieP9MqIL7yA2tOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(64756008)(82960400001)(66446008)(66556008)(66476007)(38100700002)(8936002)(66946007)(83380400001)(5660300002)(122000001)(76116006)(52536014)(86362001)(316002)(6506007)(33656002)(4326008)(186003)(7696005)(71200400001)(26005)(110136005)(9686003)(54906003)(55016003)(2906002)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5yhWJmuW+9BL6SynIBvsHwxej7mlr1vc/ADw0rloT0htE1rWU/0H/RamxG+M?=
 =?us-ascii?Q?Ze3e5PoYAmlM+q3ZxN8gg/ABPT+spD+oKHVI1e3Pf+y1Kn0m/aCXFQCVp2rJ?=
 =?us-ascii?Q?WKj7PXbNk3v5CqJpgKd9Y3m6hq2gCMk9ayeXTbJkt1061v6ZQNGYqi5/z/ki?=
 =?us-ascii?Q?AXTw8NKmZEi7D9JeDG/ipUqydFvUtOoOdOE9ckVvv0EAUent2tanSpstRolg?=
 =?us-ascii?Q?jTxQpkBcbVj/UPvQRcweC1DkP5cCZ/4FyjDIXDlU5N8ywh97+JmfC8Um6W7T?=
 =?us-ascii?Q?u7aRUi4dxsaqwfPaLU54IaNqedeuonWizUivxF6rI8nU18ptVIPPVzzkeJTw?=
 =?us-ascii?Q?Zju3pd3bQ4ZqURPipvrxpD1HGxnumo7uDqQpWQTyywf70q8FQrUt3DMiwANK?=
 =?us-ascii?Q?W7Kouyt4OwS3UpEbpSaTjU4jKazQaKDb3wkkJ0EkpeYXEeQJJcROdVEf+G+I?=
 =?us-ascii?Q?57M5KoJR2H0zeMZ8UoCEDYKLHTXwaTKKx6Gt3FAo4YDFIPm2qZw2osuzPDTX?=
 =?us-ascii?Q?bFlIU0tttQQBsz4tWI7xindzlO0P9Lh7El55WAOJWBkliYhOVm4tQtMLgAxy?=
 =?us-ascii?Q?RQ63UKA4prqGHaTi6B3c7WBZnyZHFb5wSYkswI2lGOfKDviVOhJEn9MMV3aO?=
 =?us-ascii?Q?gCGEeGmZ0dWGsWjfpThGHRfFdAPL9WDprvrlKebvz3HWuexYdzIAphloDwgX?=
 =?us-ascii?Q?AIGEFui3Ix4gDjqS7CkkdBjGsTW1ujSu8qRDcW42l//rj2qX26q3OaqFUOhc?=
 =?us-ascii?Q?lI6PeToaYJNKDTlUBN7C26Kr3L7+uUSCvobHUWopmzRedi+qfqnwjlH7mTak?=
 =?us-ascii?Q?IoZVlIFPSRSGse8aABFLK1ALhUGM0zwu9QIb+bsLYDkvLpOcgMO/NfS1+Rq9?=
 =?us-ascii?Q?bGGyjhBJcRjWmLLYtHq8nXlF3JCA1yljAvNnQAQDzMw8mQ2Pj3bodEqyUWIf?=
 =?us-ascii?Q?LqE8bytYFLKaUR255k0tnVSXx1Y6iG0UF/ZHe/SJmphNqT8inNnwYUwFNt5Y?=
 =?us-ascii?Q?JY3U2oeIFPaGQwQrfC7bj9NyraB0cxI882QgQC3RN9yoKvzkcIZ50prDGfTr?=
 =?us-ascii?Q?pJW7FDQblf96C3HIfOF0sdBazHYjqWCxQGCp5Xn4+ry9COCOC/cXDrOOnYiw?=
 =?us-ascii?Q?L2EIJ7ZMbFvxIdp1K4hAB90oSaJCk+/+JhfUfsLuQR2di9OKnKt27PL2qmCf?=
 =?us-ascii?Q?tBf+L5nW6nv06IOk63LZWrvlMsxUNXJlGsrR3wOD88IyquQzW2RkHPKiSNd9?=
 =?us-ascii?Q?Wt0eYi2gQMdomU2CaftTrjloirRops2ZEsqRDBXEbcgNHO76HMUoCJA9SZX4?=
 =?us-ascii?Q?H8Lb/+hkFDof4aZ+5PyyMOA0Zs4qmmG1cyww/EvVER2dPceR0IU1PPlkj7pN?=
 =?us-ascii?Q?7yYTRVeojuS9QEWC7GSTalrWYNLSlqRJ/0i9v7Kg/h5vuBeAcQbKDAXtFafF?=
 =?us-ascii?Q?2UnCQZUCyW2vVQ6E4wo2/JRwGER+RRk7TdBydszyyIzGrA+DKmFLf9/P/GhJ?=
 =?us-ascii?Q?diuYBGiyII/TEN0Su9digseAMGXljqDc3EPWl7lkTgVvE/pi6udeCa6DAipN?=
 =?us-ascii?Q?1O0wHP5dRSCi1NHa6nqSn5fLhAVi89nMk5FWiKKwP9pMd8R0qC9TN+vOGgcX?=
 =?us-ascii?Q?PrVfQGOYTYG1gq64QliSaZSnfqtPa+g+hLe5/4hLpeeZxi0uHUuLhRoGAkeZ?=
 =?us-ascii?Q?LPyOR5RGmwosFrvjSkqy59nSc04MCjbJiUiXc/w5aqNXX4LEvLrbuDGU6rSX?=
 =?us-ascii?Q?5B+UqivxnA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61287096-82a9-4e1b-da69-08da16d0fdf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:53:29.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Ghd38tGxZlZ3fuvGhHm0v7VfuyB9TU/mCBwcEag8pGKXlbotN4dbXgrYKJ/b3vR2zikWvROrGuEsoFMDK5t4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Move the definition of this function from a public into a private header =
file
> since it is only used inside the UFS core.
Should be in patch 26/29?=20

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs.h         | 19 -------------------
>  drivers/scsi/ufs/ufshcd-priv.h | 19 +++++++++++++++++++
>  2 files changed, 19 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> f52173b8ad96..1bba3fead2ce 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -620,23 +620,4 @@ enum ufs_trace_tsf_t {
>         UFS_TSF_CDB, UFS_TSF_OSF, UFS_TSF_TM_INPUT,
> UFS_TSF_TM_OUTPUT  };
>=20
> -/**
> - * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descr=
iptor
> - * @dev_info: pointer of instance of struct ufs_dev_info
> - * @lun: LU number to check
> - * @return: true if the lun has a matching unit descriptor, false otherw=
ise
> - */
> -static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_i=
nfo,
> -               u8 lun, u8 param_offset)
> -{
> -       if (!dev_info || !dev_info->max_lu_supported) {
> -               pr_err("Max General LU supported by UFS isn't initialized=
\n");
> -               return false;
> -       }
> -       /* WB is available only for the logical unit from 0 to 7 */
> -       if (param_offset =3D=3D UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
> -               return lun < UFS_UPIU_MAX_WB_LUN_ID;
> -       return lun =3D=3D UFS_UPIU_RPMB_WLUN || (lun < dev_info-
> >max_lu_supported);
> -}
> -
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs/ufshcd-pri=
v.h
> index 4ceb0c63aa15..de699b969aa6 100644
> --- a/drivers/scsi/ufs/ufshcd-priv.h
> +++ b/drivers/scsi/ufs/ufshcd-priv.h
> @@ -274,4 +274,23 @@ static inline int ufshcd_rpm_put(struct ufs_hba
> *hba)
>         return pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
>  }
>=20
> +/**
> + * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit
> +descriptor
> + * @dev_info: pointer of instance of struct ufs_dev_info
> + * @lun: LU number to check
> + * @return: true if the lun has a matching unit descriptor, false
> +otherwise  */ static inline bool ufs_is_valid_unit_desc_lun(struct
> +ufs_dev_info *dev_info,
> +               u8 lun, u8 param_offset) {
> +       if (!dev_info || !dev_info->max_lu_supported) {
> +               pr_err("Max General LU supported by UFS isn't initialized=
\n");
> +               return false;
> +       }
> +       /* WB is available only for the logical unit from 0 to 7 */
> +       if (param_offset =3D=3D UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
> +               return lun < UFS_UPIU_MAX_WB_LUN_ID;
> +       return lun =3D=3D UFS_UPIU_RPMB_WLUN || (lun <
> +dev_info->max_lu_supported); }
> +
>  #endif /* _UFSHCD_PRIV_H_ */
