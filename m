Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47FBC48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B1A610EA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 08:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFUIPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 04:15:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:62544 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFUIPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 04:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624263200; x=1655799200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k4M9hBCaZqvBVCuDEA+oAy7GpFjt/YHCFDRZerySjuI=;
  b=D9zBmBj/1Ov0hJW7jOFtCpSmXxCfk14JJNjNdjcpojZAG+Jb73q4pnDp
   ndYjOnVcMqO6z8ohTTQM/tcUeS95KbYP/dD6H0141NYaRkgjVWzHCxsS4
   H9SPX7iZlj6rQzZl7xwkNj/utm9IgCB9tnFp1FWMxOHD/qzlXmCjmMtu+
   thhBNrmlYsUpOS1ORINeSVLAnm90ilomK8GT8OD0ASRhbUFdA4FT2hNbK
   QIMElQp6PuQm2XekXxPR3AWsWJAiZTAeUC51XUfu/0uVY+H85Yc2Wx9m8
   XXL2VIgNiO8YEHXlBE9pMgsKeUyLSk/lx+9foVPxeecOenVTPIJcr6wlj
   w==;
IronPort-SDR: 1qQQPekt0/GI5kN5DleFDJN/Y/8ZTmLVZWFngsR0vnLg41u4BFgl49FnUP6nxAlsTIiAjNRxXJ
 wXw64UYOu7v/qZEKqN3IFGclihwvz8/5xbiSZGONTlLwKNibKYaiAIvIvHU37yBZ5Gw5DW4Wa4
 5pO61uTmgUdccDBF8lrt3lAjAI1THlOpFFMEqkKdBCEl6oofuTqTxqGwHhkyf6IEzzNEhEZdEU
 ASIHJ3Eq7tRoco93Zr9WaWSEEYdXH5mZncKUvIUB7Mpr7IwlmWC2oSXmlLnaJunIKu04ETOFWP
 LKI=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="276251373"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 16:13:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1wKL5VcO0S91Pc4BHXa14dMr8BnmcKhzt4JUrsPHACRs1VqywPa84EuA7F3DFauljGo+ipsxl+ZSUaCBMER8u0p1GDrdXbLzJ8Uzs7uOCW288lEsczlAkKVeyj/4wE3AryJqHmWgh+5F+vLH9hYv0UrkgeIx6skwX6Qz9FuCW4GhQdY5lN+fQRopPHMcQr9CfafFBUj+mZxEbRAHFTAEdkQXF+TAtvUdT6XmB9E5pzCQ2DKVFRtZ0K8PvTKty0YdVnijlTGVpbpT1NBYHxD3unrVi+zuotY3buZgXbnEQLuNtWKI1hPzxJaa8izeSD3qIm3ZWcUIUxzlFEFlFJPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQujOHn3HJOeKYgaqjKKndum5M2upCs4timDJUuHJPc=;
 b=SCNeJcQycFQZyrQ9Bd5UuF+uskWst0giXmzAsqiAy1T/2l56wD1zt3/TLO4SbkGYcjnrzmHht6BQIOIo0xFsC8/3d+wqPpU5tdQmKqqByZOt0qnrGCVwyT2WTiOa8oFYr55w/edBF70UiUXhM8Dc13jdo151h2u257ecn0JsUWPaC1TzVtEvLCiDJFLsC8Q1Z/I5+n7wg62ssgq1N2IZXqLJQ+T52i7StYbNf90naS0Y5jCLe9ufJYH1ze/sp7epBYkpZaIrfxUpizRQ3brH8V1HWbFOoQEnkNZx2qqGZWKCsSlncoKv5zM9ojLrtQewBqNb0PN8DWRGpCZFpe/0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQujOHn3HJOeKYgaqjKKndum5M2upCs4timDJUuHJPc=;
 b=RkQpHaQSFi4BPAa6JRZixB9+hXdHtIlzzI0IfkxPobNag2vmR/B4DT+qFHJanBudvzhi3gUK7dFkypeTyH1Lpa1KYE0XRVJKDf74lPZvu5QjakW7boaRaSAHwlCHHDijLi0nHBpwkaMw8LJxVhsc+0romp1aBrbhwpmG8Nm9pQQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4025.namprd04.prod.outlook.com (2603:10b6:5:b0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Mon, 21 Jun 2021 08:13:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 08:13:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: RE: [PATCH RFC 1/4] ufs: Rename the second ufshcd_probe_hba()
 argument
Thread-Topic: [PATCH RFC 1/4] ufs: Rename the second ufshcd_probe_hba()
 argument
Thread-Index: AQHXZKVrEvmuJ2XA30mE//1Kb/mZWqseHgww
Date:   Mon, 21 Jun 2021 08:13:15 +0000
Message-ID: <DM6PR04MB6575B393B81E5E7D61CE9E76FC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-2-bvanassche@acm.org>
In-Reply-To: <20210619005228.28569-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33cc9abb-5054-4beb-e212-08d9348c6bc5
x-ms-traffictypediagnostic: DM6PR04MB4025:
x-microsoft-antispam-prvs: <DM6PR04MB40255EB069E1719B14DCFD0BFC0A9@DM6PR04MB4025.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:191;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Izn6dxr4n/Ue/kRBhL+m12nE4ZFTGNeuuDrGvXhaXoGBmAh3xAi6OS/GabALdF2tmSGWX9O9R7CkUQmKXVo5rcErSxTMMXZDsmSqHkNHVjyarnF/98h/NVGW2axrT1I7kaiKKBJEF8EZHleIzv2Ib9iYGcxuCIm5ZCNEMQJ6Mpw+l8XaRFt/iDqdVDl23LEzFi9oPDx7erYt9GtoNEOfq2QNyjj+WgUQ13tlaSYAv+Yd7kCfY7CHiqQaCQ4JlRlr2wu+6lQyV5gYvHQQL0O3BW9cqfL+BeFZujIF8u67n0/EkGyXnMtkBtBE+gEzkYvSpNI5HbZO7+hZVpC4KXAS+CIgnK1jG1daGC+Zf98GAUH92xM3qtaDvGwZQEvHuvGspNu3yfU85BS0QU2v/T+dnN+eY+mLoinAXOQ6f00qpbq7oq1HH08+SxpMlhKx46u4HrI2KM0JFjxtD4owrgF+PflMam9JTGnQE61aVu23KJt8mRMiiSDluCYXpqhuGUF4rJDpIqPGa36DCxsJcVZpI0VQ6J/ehdxa86JeW8YBhODxk46vbGrKuBVaI5YwCThHt6zt3lSEiHr5amazIkj+owWIQuQgtwJm7o7g4S6A2k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(316002)(9686003)(478600001)(110136005)(83380400001)(122000001)(5660300002)(38100700002)(52536014)(71200400001)(33656002)(66446008)(6506007)(8676002)(2906002)(4326008)(64756008)(76116006)(186003)(26005)(55016002)(54906003)(66476007)(66556008)(8936002)(66946007)(86362001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sm7dZfAV5d4NoX42CpKkBR3Aw8rL1xiFhZifm4/ufQzfyl523GAW54d2mP1c?=
 =?us-ascii?Q?RSpg27A2GburFbVa4yGv4ToGFP5PZT6b4a92DLwPqZMnZ5yghPNCYJaI8a66?=
 =?us-ascii?Q?lkqRRxtPdY4TCrI6Ql5FlEloPiQUN36dKYmhJmkl0evTw2Nafps63IMFMnWC?=
 =?us-ascii?Q?GMhs+R9R3ilI7kowzAGFQrawbugmGdZlJdQxKdJvgpjxCVFi+IzEK20GM69w?=
 =?us-ascii?Q?t/8wILMN2MzLn28FD91/h5sGacl9DvKN6TrYSn43x6c0I0mqKB3+6BnvXYsM?=
 =?us-ascii?Q?+y0sCdb070nZrPl4dzazrDCJuQas3puYT/GhF9A+KWqYkScWVH8JnILvNwwm?=
 =?us-ascii?Q?IRNzgx0hMGH3xbnwgtLugpoNgrsb52VKu4+M/MMJTJqoziHWqYPqDxHqBPGC?=
 =?us-ascii?Q?Ozarseiz3ZDGIA1xYpzDlInlsrfhTdCO6UdNVyP9jolQlpKAyTHBcOBjcLXH?=
 =?us-ascii?Q?3ZA+O02AWBToq2zXJxye3cqedQPgqOzyuIZvRcldm3a0kwecP975Ated9gTN?=
 =?us-ascii?Q?+p12r/gsZp0MDkPaT0YTN4VCMRhJ+/S22P60d4AT/As14kLw1vruHuSyDeYe?=
 =?us-ascii?Q?vzU7F8/UYgbHZA4tDkAHSf+XvE/hmUz+aspp8GZWIMnfnRdWbpKEOhTtrO+A?=
 =?us-ascii?Q?Kjl6IEA1Hj/C1Bn3DauMFvpmljJ0u8IyjGYuR4FvKq2jEOIz8zovha3PaA9N?=
 =?us-ascii?Q?elN93eydtXVr2QUPQIZXCF+TmB1GYomsuZu7kerqN+heLrqxDLeJDUH4wGnB?=
 =?us-ascii?Q?mAp84cARauC5mOZXTsR6Qy9w37hj26qIMEfj5Ml8C8uRYZ5NJOAFR8os7cbP?=
 =?us-ascii?Q?by54CaJpOov4Ssn8i3qyPkGioNfT2x7/MLDWWeQW0zSphaApcKqg3LwlR/u2?=
 =?us-ascii?Q?+hKC8mwrmOMdOevE+UKhG7vFQmzJTSKHTfB6RZEVaDOzTVIopHI0KqeTdYKL?=
 =?us-ascii?Q?CeUOQRZLvL+Ft1//DxNVy1PASelRJIBZNsalJ9cofcuFgwS02VCA1wVh9h5J?=
 =?us-ascii?Q?TZWLsKfA1jqBPDbBIOORJOqkLanNTbpBzHG0sXDkFI89TM3+2y6eVmj6wMiD?=
 =?us-ascii?Q?6Md/D9YnuY1oALTEti7BRHRloCLt19KZm7X5qWKNRQ9PzYGk8q/JwtpsdHyn?=
 =?us-ascii?Q?7WYbRDhImuv019BS37r3YYrlXFJ+gFJF28s2X1i6tYXIoej0Io5P5zUYek0x?=
 =?us-ascii?Q?QUee9PHFZPy586bzow/xmcqE2abxKTtoyH9fDKvBWdDHLENTmvzIt8nqEt4w?=
 =?us-ascii?Q?eD6IRF/hRNQlq3ko4JWxr8Qk2NvwO0EA9ysdzXr0+/arPpi7SSNI89rAgRqQ?=
 =?us-ascii?Q?aGx7vgnnYPJYWj0FB+9R4iF1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cc9abb-5054-4beb-e212-08d9348c6bc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 08:13:15.6766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ze8p9+OBMBGlmQqz+v2VM4v8yaKVQ3wP/Yq5bEmSd6kZ/9QC3FMwHDLYSTd43u0d7rTLR+xgeJIpqUh82MaaCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Rename the second argument of ufshcd_probe_hba() such that the name of
> that argument reflects its purpose instead of how the function is called.
> See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba() based
> on its called flow").
>=20
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 25fe18a36cd2..c230d2a6a55c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7964,13 +7964,13 @@ static int ufshcd_clear_ua_wluns(struct ufs_hba
> *hba)
>  }
>=20
>  /**
> - * ufshcd_probe_hba - probe hba to detect device and initialize
> + * ufshcd_probe_hba - probe hba to detect device and initialize it
>   * @hba: per-adapter instance
> - * @async: asynchronous execution or not
> + * @init_dev_params: whether or not to call ufshcd_device_params_init().
>   *
>   * Execute link-startup and verify device initialization
>   */
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>  {
>         int ret;
>         unsigned long flags;
> @@ -8002,7 +8002,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool async)
>          * Initialize UFS device parameters used by driver, these
>          * parameters are associated with UFS descriptors.
>          */
> -       if (async) {
> +       if (init_dev_params) {
>                 ret =3D ufshcd_device_params_init(hba);
>                 if (ret)
>                         goto out;
