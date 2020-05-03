Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2FEC47257
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 08:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E3DE2075B
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 08:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PqwWNyg8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QSihbSW9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgECIAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 04:00:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:35851 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgECIAT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 04:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588492818; x=1620028818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uLObZhKtNb5M5h1MrlmHsxoOyzZEJdZUV0b9FRtPBpc=;
  b=PqwWNyg8AhtW7620CTC9GTwuPUFiCORUE/gLD58MQDQyRsrEhYmzRPnn
   0Y1JtOhZ10vvQakIogMJU2ts7+hQMHG+ql6LGsN9qV3vvRqZ8M9Xyv4SQ
   KeAX732uIaZ1it++D9cQXvvZLnTNzlBZ6MvTo1iDlmXmBZRzhPDncf6Mm
   goFw8y50oJZeAt0L2Qg5g4TiWSiqf7VyMF1WlnP/8tMw2GKVGlUNPAZii
   KQuK9Xu1aVhJdCRm4TRGx3xfznRPw0jSH+s8JJeHJ0rSKY5Mx1z3Uc2iN
   J+heajqeFGUiDI+MzifpaDbFilbfetcEpEPk0kFQduJoY/SzEdA7ndYR1
   Q==;
IronPort-SDR: Q3PLUB/4QMnZdr9jl17vgauuh+h10YohOB34KdzuklFiTWPf8ylyfHpg2asH4eZTmtuCE5npci
 7+y8Ae3yEuyosNr7hF3TPVhcweRFyGdPKbI1+GAt3/UxEvhM40tCGSG+e2rxeG1Wg3LDRA5KoE
 g/x8qZruQN+nrSOb3HwmxiEcVbLnkqe/nSdxRnjR2LIZ6T3t57I+rgvK3SbB30jhvC0B1AMy0z
 qw3RP6EAC6LrhckcPtYi2LsqzYUk7VvxhKRl3YMyZpmlHj/M8Xe7l3h9zw0ByIjGkudikxqPzS
 Vts=
X-IronPort-AV: E=Sophos;i="5.73,347,1583164800"; 
   d="scan'208";a="245611435"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2020 16:00:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjVF628qvswolMgv4aNpExwz5zVsC6nmHsNjrbkUCQMTHtPcpZRLrPXO3wLroXGoItfcQ1g3ftxuvCu8P7v8DTAyrBEdQNx0NUxPLE80QeyLCMzOcMxEVhZHjXXdpc/ew1iLDMzHNzKUXq5A3y0374LVUdvH2NPqKXvR2z1+K7Ffxur0k2pDCay9E5QC5w6SJeRAan3hBK9P626tl9Ki74DMUXZQACtGgWwv8+jZMAjUpJsPn1iGBPUmS6krI8kha6vLc+3cf7stX8yh9sfeB3WOm+0WS1s5bi3W4ZmKaHs2hNuUCDePEKMVT+18Vie7WVicx8+5Q+hpDBpIJCZPnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlZP4wxoFTf8tx1WBQBLjnxDPsDqe2jYDecU18l/sw4=;
 b=Dnv02xoabfEsfZ92fIDhOwzGQhzo70UjdGjrabDILErcq1OAcl2iTIPFmrskkclQ3X9NjfguNcP7ebdN37PKiW+kHhdhViPAv8TwynUVlBZzFlSsWQFrNB/1AX2pkxp410h4t9bSml/Jm8xbkygWXqtVbzxXQMASiGbIOzWfy3zA5C/twxlwjwK3wT8Hq3i8JRyvAu8zBK5Or4ejYLJbk550r8K3fvY1IEH4RkaoPGxeL91hB2yffZSg5Cvw6GWphXPSL9H5Z3YwA6IA/9aY8wvSwyV6Fx14MEpSkwvrnNeASglG/BeNYApOltoPb1+Dtl4Iuc4PsEu9YQ1wTQWW6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlZP4wxoFTf8tx1WBQBLjnxDPsDqe2jYDecU18l/sw4=;
 b=QSihbSW9Ajmzyjevb2RibDaW1usth/0M+1w3A+Xe8M/2mcRgvCE19Ggv5OKLw3n+3bYDk85NqYQ8mnyjsQ3pSKDjShPJtElVLErmzu19+glGlhqApx1KgCzcc3A6DrSYBOoZ+CA/y+/kIoySoJh5OqKcKBSgSCIQaMBrGdSY/2g=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4335.namprd04.prod.outlook.com (2603:10b6:805:2d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Sun, 3 May
 2020 08:00:13 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 08:00:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v4 6/8] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Topic: [PATCH v4 6/8] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Index: AQHWIRCrXRqrbU2HS02FXUAKk3v6OKiV+eag
Date:   Sun, 3 May 2020 08:00:13 +0000
Message-ID: <SN6PR04MB4640977062BF81B6DE7CBE51FCA90@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200503060351.10572-1-stanley.chu@mediatek.com>
 <20200503060351.10572-7-stanley.chu@mediatek.com>
In-Reply-To: <20200503060351.10572-7-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5af9a3dc-17f8-4bb9-d6f6-08d7ef3802a9
x-ms-traffictypediagnostic: SN6PR04MB4335:
x-microsoft-antispam-prvs: <SN6PR04MB43359E0FF4C1B218BE6ADDE0FCA90@SN6PR04MB4335.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0392679D18
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4nzNANSymWsAsMnu316KBxl0lkvW2aHyNiO6/UmJle3PotUzx0MKFKMMdONqnkTBXZ+qiONro3o5YboGpVOcJOHOARhfsIeTs/o/wkvMjEPl1qITDugZF3t8yNblEFYLk60dLJwUn7y7Xx4f8NTNeQvXQRoFF5bAccNtyvmLR7atxPj1H6+s3cm5R2XpUeK/lf+bldWJZQnewH7DY18Y+PwBBzQYlHPZEFMmb8lcPvvxohyAzjcEwpyLt7TcHDnR1u9J9CK0ma9knYGXjZL69jRAZn1mGOAYxEiu6V388ztY9KjsySGN1TTyiJpsCPBT0QqUpb8zYDQI54AUJNYxw4WvYSLi5jxZW8iotCjLrd8QBOSyVyT2YeiKsluLSi7qsdtH9Cp26go81IxUBLFDJtvmtFJJBQmrKnJ7+gB3RjuDjTlaNzSn5iFdm50bQgl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(396003)(376002)(366004)(136003)(2906002)(186003)(5660300002)(71200400001)(76116006)(66476007)(66556008)(6506007)(7696005)(66446008)(66946007)(8676002)(33656002)(64756008)(9686003)(86362001)(55016002)(52536014)(8936002)(26005)(478600001)(7416002)(316002)(54906003)(4326008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3IGyapVzLBYPcBcB0QsNCvciaB/l4YMNKlwbx1kfV2umgcWgrTi32fyZoLPzdA4Tm8j2npjfLNHCMHZDI11dxAymHfnPgyPbVH78/gFJS0/Qijw3Bf5NjJ6GYJJBWSbfcs+bSNziUDF8rYv3GfuxNTXyFAUiNJXRZ8qScPRZ66JWklvnM9XHsgPFWahHGK+xMjQkyZDJFG0n8gzujgAaIh0rJLOHDiO0TZAb9fDDmbuBdrT3W0ycoqgDD87xlyDeGVlErDNt5xNFxhTyo3sBIsaiANKFCpMk09ISimk26ymLv06V4gn3O9eIe5G4aQmDuwPCFrCQYjv1zwFPPHt+xg8ZdFtfF5d9bM2vQrgj0I5wDtsg0WVkqcyXE5PRUOkPa+Q9y6PZ16y2Bv5Yv8kbEbDI3DDtp1RXmzcLfm2v4f6nS6nu8LmazFUG9jPy7m/sYPmR5r8rdPVDCnmYnHwTXY80Fmq7gsnYPXiDaYmZOf7y3c7k1845/YmwCZzEaapFu1IalbPLP8lpdVVP+/11ZBJQxCg5YP4wAfymBl2/n8Klgh7wNO3iZf3hAoIoVTUyprv4YD7lMBQdyIzFIMOkWjQT1UGK0CXoEqZ5aenChIVFIY3sD5q32qGMhw97ZvvWyC2+x7cpUuhoswrfuTPjyhOne/1K9i+Kq8yCMsoIUkxuGjJ/ErA2QfB9EjLly7yyw7W95XBT+kxRVDZozSRczU5609y9gdSzlOKizVoWKcH7jHc450GQiN6bP+QEhyRbj/D+uTXet7Sty7Skhkmo03ClYf1l7C0UWIx+eILaHv8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af9a3dc-17f8-4bb9-d6f6-08d7ef3802a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2020 08:00:13.6707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sTJhWfGaqUrfd3e909bppPZOqD9IkWDP3vnQHBlMsY4s4FXmvZ08g4amnO0hi2oikUpm5/freWMFdHnfH+9sbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4335
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -       if (!(hba->dev_info.b_wb_buffer_type &&
> -             hba->dev_info.d_wb_alloc_units))
> -               goto wb_disabled;
> +       if (hba->dev_info.b_wb_buffer_type =3D=3D WB_BUF_MODE_SHARED) {
> +               hba->dev_info.d_wb_alloc_units =3D
> +               get_unaligned_be32(desc_buf +
> +                                  DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNIT=
S);
> +               if (!hba->dev_info.d_wb_alloc_units)
> +                       goto wb_disabled;
> +       } else {
> +               for (lun =3D 0; lun < hba->dev_info.max_lu_supported; lun=
++) {
max_lu_supported is determined according to bMaxNumberLU in the geometry de=
scriptor,
which can be 32. WB buffer however, is only valid only for LU 0, ..., LU7.
Better to add this new limit to ufs.h.

> +                       ret =3D ufshcd_read_unit_desc_param(hba,
> +                                       lun,
> +                                       UNIT_DESC_PARAM_WB_BUF_ALLOC_UNIT=
S,
> +                                       (u8 *)&d_lu_wb_buf_alloc,
> +                                       sizeof(d_lu_wb_buf_alloc));
> +                       if (ret)
> +                               goto wb_disabled;
I think you should just continue here, as it is ok for the query to fail.
The spec says:
The WriteBooster Buffer is available only for the logical units from 0 to 7=
 which are configured as
"normal memory type" (bMemoryType =3D 00h) and "not Boot well known logical=
 unit" (bBootLunID =3D
00h), otherwise the Query Request shall fail and the Query Response field s=
hall be set to "General
Failure".

Sorry for not noticing this earlier.

Thanks,
Avri
> +                       if (d_lu_wb_buf_alloc) {
> +                               hba->dev_info.wb_dedicated_lu =3D lun;
> +                               break;
> +                       }
> +               }
>=20
> +               if (!d_lu_wb_buf_alloc)
> +                       goto wb_disabled;
> +       }
>         return;
>=20
>  wb_disabled:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 898883058e3a..f232a67fd9b3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -861,6 +861,13 @@ static inline bool
> ufshcd_keep_autobkops_enabled_except_suspend(
>         return hba->caps &
> UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
>  }
>=20
> +static inline u8 ufshcd_wb_get_flag_index(struct ufs_hba *hba)
> +{
> +       if (hba->dev_info.b_wb_buffer_type =3D=3D
> WB_BUF_MODE_LU_DEDICATED)
> +               return hba->dev_info.wb_dedicated_lu;
> +       return 0;
> +}
> +
>  extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
>  extern int ufshcd_runtime_resume(struct ufs_hba *hba);
>  extern int ufshcd_runtime_idle(struct ufs_hba *hba);
> --
> 2.18.0
