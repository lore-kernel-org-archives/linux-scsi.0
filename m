Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693D5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 18:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiDASvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbiDASu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 14:50:59 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2074134B94
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648838949; x=1680374949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3SRRPPXaVtvv4NrrnHJpvNw7qP4vozRvir6w6cMzO90=;
  b=ItvIRr+6Ll1zCAqIGjgQFhNI4PFHWriZ8giWYWFy6os+D2AfW4w6hvbf
   /h0vd+244Wc11VEcKcRkxl5Tq9pc19GYznBIckr2wzrbJfRjshghRHxKc
   S8vQsZRg15mJscbKqU4cLSSON1lXxW28VGfqFRjn6/jL01AZHHf0kiVlo
   OFQJAcNslLLk4jbgwFBw0IUi8G79Z5HLG6VCz0bC8AxSfaR0bGaA2Y/PJ
   kY5PmO0OCoCEb/M/vK0Adf5hgApzZ98WxGiesi71unNcBdgO6akFe/rcc
   CwfEAJkk4GC6Ydzqjt8t7NQhreMlSqCcGMGIzJRGyGeUd2gpOUgBUfRV9
   A==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="195743197"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 02:49:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm54DstuIlNXHKWdeLesR4AUcjc/3DFB4l+rFq/s69AvxtMbAwz/oC+0qp+Z1p452EN+t+1YTg3+zdiNSwZI9nthTvH8O4ZrKWT56QLQYCe/fYiAB9isTTrsAPhPjAgZkKc78OcfBdSXY9QQtnF2c9ihiJtq0h7bVW9SlTBoV2s6ikyV3ZUMkS7yZCxjLeynTmebzNP4P/UEP6z0OvYUwj/Ih9Rxz2fE7GA1MXpgjXPa8JokQ69fDH86e/KhL7zqnt/tKWOqcnz6TbnlMWqqUyA67isfK6IXBaJV5k5WyiZx0M5s+DBwB5uMCTskVvt9hX5GlqzsyhsEGeeDIbFz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ox2LO/IIwSTPDG6gF+iY6x3L/+hi2fjVfd8HtA0BSyo=;
 b=PDd7A9oo7JVTjRefH6rLu0PIGy/0amhBh1jEMYhcMQ97j1Ge+CNbXX9suw38WLAIYpmlp3jXrRJBIRLtpu3S/ihdZEAAOhPNtqBgsSlDZCI/bby3zPr+i1dp/i9rh1jTOzG5LqanW2HGj0PxQSGMqdRfHimeqrmSZ/a6iFLzm2ol5ZFTUsEst93ItdSBqpHgEdaKWi+DZKdM9iLGiuUTCJO7fTC4VYZn1aidZ4HkU97hotht0g/qEpe286LacBIIO3AFTuwsQwKKmB/t3uH7ceSzfars/0ma7fPkGmkL4p+sQMo3t4PV73WGRoO3fHxDpHG7LKYQVkWRhQsEKIWJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ox2LO/IIwSTPDG6gF+iY6x3L/+hi2fjVfd8HtA0BSyo=;
 b=fiH92N5SX3BYoGUtke6bS4hHUsFwpf6K6UBeEVatGAbvTZ4jtkoTw71w5Ae3Nw4nZIe3pLXdP3JcqWsy3mO46Ntx7Lbh/UIdEVYbNpV8kyq10cSglAY+A0YdNA2Jx1HSk6RndhwyYzFy3kpx+8YU00Qp/UvhoxqFDDt8mIA66ho=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5351.namprd04.prod.outlook.com (2603:10b6:a03:cc::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.16; Fri, 1 Apr 2022 18:49:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 18:49:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 03/29] scsi: ufs: Simplify statements that return a
 boolean
Thread-Topic: [PATCH 03/29] scsi: ufs: Simplify statements that return a
 boolean
Thread-Index: AQHYRU+VzWLTeT18b02UyaDfmB+m4qzbZiLg
Date:   Fri, 1 Apr 2022 18:49:03 +0000
Message-ID: <DM6PR04MB6575F201FD004FCF0140B87AFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-4-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7825a968-b4d0-46fb-2146-08da14104b18
x-ms-traffictypediagnostic: BYAPR04MB5351:EE_
x-microsoft-antispam-prvs: <BYAPR04MB535189D9C51BF9222F54AD00FCE09@BYAPR04MB5351.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjM+F5UrqB9epBFUfDh0aVp/z9UsL5Lny227Su2E+2KgoWiL7DjvnPqlcHAXpMvzoFVnmcFP11PvrLtCNuhYU8+qyFKBn8QecY+mDRTKUKvfhI5rQ2D08NCPMOZxRUgyvWb2QGQFOQRowUtnii5FugO4pNSAroZY5izrb4eOu5eeXUKW3hBfkau2S4TbOpYF/rV3HMEkgL+8kZRx0QhdfYxUxOxMU+vBGWMZY7KJ4XVbV0DAgjKmB/LWVHVeRag+MZcT4fibF0p4WIfm+xQx7pot0ackD3uKGPgtKaMS5nZ74Fk3SpljIPy2F7Pirv/Mh9QbggoC1+CkOj6GnC4IGpzD2/KaAKd1gdYZIOA7Lqo7j9JtSYOF88U2sdxHAcDQfnjID5hYMJ1KVGB/HDM4kvBYTdNpP266Z27En90SFwtmvyV/hqPQazP4uo48K0crntb+p0aikq/kVN1qbxT5p1+KlDEENIDYuqU1FYXo9UabGPxpcAvDVaQe/gPZJ6guu77pV6+pb4oJR4uMD1csaa9Li4t7E2LnEYmbzyz1DfZUX0UnkuA1AlKGo26hU/Qb8ZGQHiNy5tNU3aS8Gpy+r7WotEff9F4YmXnIhC8DGRZB5OZfIctuZSX0csJgIlrI0pn6NOeynUadkKrGb2tKybC6z3hF78JFBupoKICKa8+Sb6BtfTG30sOAzqDUkqfYQ1lAmYNCrn2c+m+bIWc98w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(71200400001)(110136005)(66556008)(66476007)(82960400001)(122000001)(66446008)(54906003)(4326008)(66946007)(316002)(64756008)(186003)(33656002)(76116006)(8676002)(508600001)(7696005)(9686003)(86362001)(6506007)(2906002)(38100700002)(8936002)(52536014)(83380400001)(5660300002)(7416002)(38070700005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BIol8NZYa6o7G26TN3nCVD2KysJ26n9TesU3Zg4EC+xsze6pCsLtacDttkqc?=
 =?us-ascii?Q?NWbdz+YmbwxSVk+oLTLMmyKXRfnQZ53npVt1P6WCuVMZOfYRFpRA5EKinNQ0?=
 =?us-ascii?Q?TjXVqvaoBXHC7av+s3yajRWpQXFdYF0kwdoUQSQK+arZxcB/OWtUz6yCfL8o?=
 =?us-ascii?Q?sSj359NDRZYkgIJ6dcDMmceBacGvz4a6CY8BSgjA8+RCRTyfyTqTJlGzOAqU?=
 =?us-ascii?Q?zkKMou7FTzT+/ot0PVhRftTO09BlvIviTp99XS5e6kaDQXvwd5VRHdh4MbKh?=
 =?us-ascii?Q?ICoMW7qBCQd7lBMn3r/ZLMCgVRmPTCF84yuMF9RjCL1k4/JtteUmilJ3eMAU?=
 =?us-ascii?Q?4WDH3Xsw/aTqPD/vZJhxodNhCtv9Q6Ffii4wg+CUX29qtUj2O6/ZWYD1zKOF?=
 =?us-ascii?Q?7/wQ3akWbN4UKasFfD4VRbQ6uta2kcgVAcDyM4ER0Rkv6+2/PiSgg2g5ZKH+?=
 =?us-ascii?Q?P4k1SpiLCE7l20QMwml/E5gE5VJvVs9UVF6Mn3cN+cguEQJy9eREBfeuwHcG?=
 =?us-ascii?Q?6EohJaQaJnyqx/TuY4JZhuDjcb5UfIULr7IfvEBJaGGHeIU+1xucPlkxrII+?=
 =?us-ascii?Q?9F9Kf1TwYvcZ/K1SKI7i2F1kPlYLE2YOUW0MNhjN9l1sCOGuywDX82OwxJ3B?=
 =?us-ascii?Q?AMV2SgnwE+rauz3vI/pR6MKPY8dauOOPAmw1aIjA0aooBbIp5LJ2TVbgfONj?=
 =?us-ascii?Q?wbtZfKrdq01CkyOg0eoqkzhQTC9smM82TIy1Hy0sUL2pAMw0xSzCRt0mr1PI?=
 =?us-ascii?Q?kBLo8U5mDDwlmfLHNXSzXg9EohPl6UMF4aZfUdzxntGvJ42K2Tf2xhQjq9ua?=
 =?us-ascii?Q?LiC2xDdP5KL22h9w7CBNv0dkoVn7WdSKlPxL8Y3r7NHoD0NQZQZpaD7tfEOe?=
 =?us-ascii?Q?YtoyRRF2UKo/An0a2Pe1yK4ZlNk6eF04oVHOHQSIfDRXyEnu/DoGFu/4Fgld?=
 =?us-ascii?Q?ucUoMQ1cMHw3F85z6tOpRN24JikCmVs1QzY5h9EEQ4uAKBFmiFQcqI/zyVzY?=
 =?us-ascii?Q?Dvn6kpRRdzR11SCHYKTU0QzM6AeAu1WHC34aC7hhcF0se6cDo7CKTp7DdWOL?=
 =?us-ascii?Q?S4/ia3iYxW54VopwwfGjhdVLI5uVZyVlhaaDy/uEG51cjBsS1QvRxorOJbI1?=
 =?us-ascii?Q?uI1X+qSk9x6rMhj2JlW508/hTaCAkGC2jBcagjJA0XfcXdQt8ljuIUpMWdf9?=
 =?us-ascii?Q?x1vMeTCK4GHCEeWEDO1/SFbv1LfrKz7j9tIbgQW46tRpjUiFMhKEmg5eU670?=
 =?us-ascii?Q?JRIXMCsNN0hv6TjLZIemNJcm5OSOGviZSyde+ukuTk7NEh/Q3vZrccWoKqcG?=
 =?us-ascii?Q?YKrFIuU83S4FuiKApwLLZdt5CkdzhumQ9PqfV6Tv5KuM3tRKAClAQRAZvjH9?=
 =?us-ascii?Q?VSfdm+VNSwz93OnCNK8qcGsuyeGDYtfVlh8Tjcek4JATr6+nTeScxd1rdAFt?=
 =?us-ascii?Q?3RvyTTxeBiIkw4+4sULeCtliaZdOjiG/VynJ6N1+YhfPuXq/gRhDViB3wlDK?=
 =?us-ascii?Q?l9W5DKApTYK9T7WwJ0tW1VLXedxahv8omiKWC2GFy8en/1rogARYwas071Gf?=
 =?us-ascii?Q?CgmmR5IhOaYcJaZ8XmbNTzhEfcL5etDBvsSkPRU7P3nbJlW/8l4j9DfefapL?=
 =?us-ascii?Q?hnVq+9kseDbju3uRrtFP6WWLyaNK5J+c2h+yD9TIqdNfb+UGwr65nnWe5+0H?=
 =?us-ascii?Q?EZgyb7xKPrSNr0m1BJVaHhQNPGP+w/IwN7RvWtZQxkgiG4PGNJ0pSqE3PT+3?=
 =?us-ascii?Q?TEk3OMpfCA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7825a968-b4d0-46fb-2146-08da14104b18
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 18:49:03.6845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YEKevh7tXnWO1nZwXcmdDeVoiD9XZKR5o9rAWdVqqX8yOR9oe2LjZmlPtgx1XBAGUQ1UiHHS/flXrYXivRNC8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5351
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Convert "if (expr) return true; else return false;" into "return expr;"
> if either 'expr' is a boolean expression or the return type of the functi=
on is 'bool'.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Maybe also add ufshpb_is_pinned_region()

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufs-qcom.h |  5 +----
>  drivers/scsi/ufs/ufshcd.c   | 22 +++++-----------------
>  2 files changed, 6 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h in=
dex
> 8208e3a3ef59..51570224a6e2 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -239,10 +239,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host
> *host);
>=20
>  static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)  {
> -       if (host->caps & UFS_QCOM_CAP_QUNIPRO)
> -               return true;
> -       else
> -               return false;
> +       return host->caps & UFS_QCOM_CAP_QUNIPRO;
>  }
>=20
>  /* ufs-qcom-ice.c */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 983fac14b7cd..c60519372b3b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -939,10 +939,7 @@ static bool
> ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
>          * logic simple, we will only do manual tuning if local unipro ve=
rsion
>          * doesn't support ver1.6 or later.
>          */
> -       if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
> -               return true;
> -       else
> -               return false;
> +       return ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6;
>  }
>=20
>  /**
> @@ -2216,10 +2213,7 @@ static inline int ufshcd_hba_capabilities(struct
> ufs_hba *hba)
>   */
>  static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)  {
> -       if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> UIC_COMMAND_READY)
> -               return true;
> -       else
> -               return false;
> +       return ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> + UIC_COMMAND_READY;
>  }
>=20
>  /**
> @@ -5781,10 +5775,7 @@ static bool
> ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
>                 return false;
>         }
>         /* Let it continue to flush when available buffer exceeds thresho=
ld */
> -       if (avail_buf < hba->vps->wb_flush_threshold)
> -               return true;
> -
> -       return false;
> +       return avail_buf < hba->vps->wb_flush_threshold;
>  }
>=20
>  static void ufshcd_wb_force_disable(struct ufs_hba *hba) @@ -5863,11
> +5854,8 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
>                 return false;
>         }
>=20
> -       if (!hba->dev_info.b_presrv_uspc_en) {
> -               if (avail_buf <=3D UFS_WB_BUF_REMAIN_PERCENT(10))
> -                       return true;
> -               return false;
> -       }
> +       if (!hba->dev_info.b_presrv_uspc_en)
> +               return avail_buf <=3D UFS_WB_BUF_REMAIN_PERCENT(10);
>=20
>         return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);  }
