Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA25C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 15:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4105324953
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 15:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rGa1FZrj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="O4QUbBDR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgEBPcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 11:32:32 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9623 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgEBPcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 11:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588433550; x=1619969550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=04E+l5kWK4GkVHwVhbdQBMiNlor+7v66LC6zWJWB2dk=;
  b=rGa1FZrjKScMFD/RL80lH4Vpe+3cUSpzVIzF6jDgchOWyBVfAbKDa6J2
   SSdMBcV+2B5juxDEJ44W/vrW3nuIkdwlskwmgoK4fdRBZvah+2wlEcq93
   P5zUwIAsBBK5l29qXqhgAnxpxKyjH4+iqJ7U7+jSHzethccmswX6HTw25
   nuarTwY/ydBrNQT91UCjX3lAtm4hzzrzqx2By9eqwhm9+f/6CygI78Oex
   avR2F6D9hUfcNKJvuMTZnEZ+2EQosfkSy6W7oaIw6HNWKUnKkcq8BXZ1t
   ijT4Rq1NUICdMIxqFPB8X2Wkvcv7gIFnI9k1kXIUOepqWDcr2F1jfqKZQ
   A==;
IronPort-SDR: kEkk8QVHflhMfH30NyjoKOD9CrnaLt5hCSUEgbOZnJUuQof68IaSXF0Yi33fIFVahcKuX+s92h
 UmbaOrvdRRimGMLyExYI35OAZrRU4ZENmE6NdOp1HUKPm13tpxkTeva/usPH8g/O/97Zl20P5z
 uPuTDlU7Z/iBvq8/jTl8qJ4labsbQPURLWFaNXBQEMKv+VPemsfOnj1yX7BQaW7SWae9x1CikO
 wwtYR8aTZf1Bv90vQ3SWHOYOyJKg48apb3tl9sx6Ps2bZVArF+2aXhQUChd3uTnE3mPtzftxqZ
 4cU=
X-IronPort-AV: E=Sophos;i="5.73,343,1583164800"; 
   d="scan'208";a="136748102"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2020 23:32:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3bum2u8aosVERSZioXwB3PzsGx8TZ6oEG6qwRFUzHYkbcLvosRwzBdExgbPcYFbUYHjZfKonIglXYPq35vBG+ZadLTA0S0ELTo/kmP5yulBDpLsDZidu7OlbYh4KjOIzQXh3AxqVWBbjnsxcmOZIwbBvGMm6Nf8De3rkewq1o1LB4sB4lJwHF+61o1Faa4IDf7PhUM0gUcLlXs8u5d52JP3aPqhIQ1/vk8HKyaBGQdW/sBOThOlFObz+TBIMvZg6MFZ27w4SW/l5C2PUvABLbf1kibR3HxtNimhpA6a4eLSm42147KuuCmyi6jYY2fBImbhQkPATfd7qdLhozP5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwStFu/X5ULPg/f/dpLqjNW2z539iJpOz7g5RJbT6PE=;
 b=ePXalTKbWmxECxO3v/EUheIXF5UCFVW627Ee1tBuA45SxGw7cJIpfdG2PQIdPam+LFni7GtXzO7hKsIp916lI/mW9Fm6yfiL+TrDCP21k/BskBQgMp+8SwgFvf2w409W1dfMBAnBCjxszaVoxOMbf+zn41aAnOHadwo4hXwMdc714mz+ay3v2tRiXhTTI0hxvTk7dxNzoBF4hjCzo5HJyS10iC9nN5WRwC+SGLmxGNru+MuCRFK3kgQjesZS0J9z+MZj8+w/HjrAd0DmUR29h6tWDU962OTjOw8UX81u10YvFeNEs++/qwPTG/dWCVSdPVyvrsgM1DDYes9Cw+i57Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwStFu/X5ULPg/f/dpLqjNW2z539iJpOz7g5RJbT6PE=;
 b=O4QUbBDR55bpVomdTHrs1r6rGpfY2h9dtdFC96ne2CjebkhBum6zHAopCEFt05XgvW82+Z7bTZ3UEzghB1secBmPJqnd+H5X7aNFD8I/+XPxYg1vLkFeDJNDU/wwj6bPUW7sttGeKTdsjlo1IUBAwovzrRG6eHOuKqzuT2Dj6cc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4991.namprd04.prod.outlook.com (2603:10b6:805:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Sat, 2 May
 2020 15:32:28 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 15:32:28 +0000
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
Subject: RE: [PATCH v3 3/5] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Topic: [PATCH v3 3/5] scsi: ufs: add LU Dedicated buffer mode support
 for WriteBooster
Thread-Index: AQHWH8ZIhJa0kw+eXUm7uWPkstnlKaiU68jw
Date:   Sat, 2 May 2020 15:32:27 +0000
Message-ID: <SN6PR04MB4640A20146AFE35717580149FCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
 <20200501143835.26032-4-stanley.chu@mediatek.com>
In-Reply-To: <20200501143835.26032-4-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 934e1fa2-609c-4ebb-a80d-08d7eeae0596
x-ms-traffictypediagnostic: SN6PR04MB4991:
x-microsoft-antispam-prvs: <SN6PR04MB4991F84DC71D463B8ADEE385FCA80@SN6PR04MB4991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 039178EF4A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J+hO5pWi9ABZoPVaFNbVMdWByy9PLkXGnUKe5gG8NXiecP98sDdZEsxJjVDks3+m0kzp8S8kTpeWSory1ubw6oxNJdvqfAbqKvJH152l3hY6fMxNmT2KCvZtcXW6228nlpxDvhxJteVHCXoQ96PU2puDb8VLEBRXHmm/EQXnnRjPEA4BXpPIu8D0OG6io2LD3iD+1PuZPcyOVX1nLNyJygQCDH/OcGy750U2FXvIAribmNIAn5CBNX/B7NallqCKPnEXUwxsFmBPtoX4IDTJeHU5qzaJIySdUK3m5dL5Q4B4MFrwu8vT/brFOAYNjh6C+mbJhONjzBPxfVZI96n4k38T5hASEYGhbUiHS4EMuYC3SnwfJKd+uXQYmuABhrmLa3AGJ64T+wWNMx7F6aQLEQuEUNWlZhZlJKOooZXnt20td6d+xXhHoMpAZ6VykKNe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(54906003)(110136005)(6506007)(316002)(4326008)(2906002)(186003)(71200400001)(26005)(66556008)(66946007)(76116006)(64756008)(66476007)(86362001)(66446008)(52536014)(55016002)(478600001)(8936002)(9686003)(7696005)(5660300002)(33656002)(7416002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MFtsjXgm8o7qi2FGlcTkbw+1Fq7a2Nf1YF9Tfq9lJbg/8FHpz7lUwFZC7fCUu6GeJzhN6AGbLqSbnNxeOzIXU1Gz3qLaiXaDxBtd9LiKKLLeBtQ9wzukLcHJ00gdDsssEHs1hpVR2gJ+2TtB2oXrK47WG2dPZZI07Ze73g63U0PdbYiIVl/Lt4R/uG9g35WPWnJEqG2d+Ut3zAJre8zXFQG1p3RNSF4b0x517VacmC8YVBxsJsfjWjPoJ4G2gFec9lt9l1vM3iOxW16XAOX9Eu1PCOxsSQPeAADk1Bul0xoU17pOaXtX7v2tEYLtnqTAQBq2ndD1dgDsqzMSUnwtuVSkqdxvrw0v+aA5Z4KZZbTKzQ23+CEPuPMPEab4Ybt9GI/uWr6Be+EGFfFMmU6VUih9kQv4/38QtOfLif1Z8keTO1OegfZX9vbBQnrewYCfNk2ydITzm+YcsYToNJL5m3gMp7RFqUCQTdQgUlDe3qEJ+TQm3EPSbDAF/FgPl1PVaI2tBXAVGkeDQ9jHKgQ1TXPCnu7WbvKiuh1S0U8e4Xdr8PbJ7+aSXSsQZjGyssxN6jVIcoq7TM378IbLIT/sU/HQBSRcXj/g63Z9IxW59bsfF6cTOM/1RDhcibAo5sglkbURkVjrcutt6Rv3MpqoullGqJunYbvXVzw9JU3GyKqOBxgs0Q/w9eitu5gSWL8xInwJ1E/fQ/Tg6tIlQIW/tp7d4EktATYzMvVcmJkTw1NdDRhb9oyTRJGuMPWQMiCHfzw/Cp6CTCSZfJdR4qmEvWm+90jSOvAbjwXVW52jNlc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934e1fa2-609c-4ebb-a80d-08d7eeae0596
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2020 15:32:28.0145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8i+BFtxoCKBros1RhpY6pTct2X611QYv2hhJ3Ag5v511rGcsUf2HN2eYADI+vMzRuo3UyRsno9HW77+AAU98NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4991
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Hi Stanley,
Few more nits.
Thanks,
Avri

>=20
> According to UFS specification, there are two WriteBooster mode of
> operations: "LU dedicated buffer" mode and "shared buffer" mode.
> In the "LU dedicated buffer" mode, the WriteBooster Buffer is
> dedicated to a logical unit.
>=20
> If the device supports the "LU dedicated buffer" mode, this mode is
> configured by setting bWriteBoosterBufferType to 00h. The logical
> unit WriteBooster Buffer size is configured by setting the
> dLUNumWriteBoosterBufferAllocUnits field of the related Unit
> Descriptor. Only a value greater than zero enables the WriteBooster
> feature in the logical unit.
>=20
> Modify ufshcd_wb_probe() as above description to support LU Dedicated
> buffer mode.
>=20
> Note that according to UFS 3.1 specification, the valid value of
> bDeviceMaxWriteBoosterLUs parameter in Geometry Descriptor is 1,
> which means at most one LUN can have WriteBooster buffer in "LU
> dedicated buffer mode". Therefore this patch supports only one
> LUN with WriteBooster enabled. All WriteBooster related sysfs nodes
> are specifically mapped to the LUN with WriteBooster enabled in
> LU Dedicated buffer mode.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 14 ++++++++-
>  drivers/scsi/ufs/ufs.h       |  7 +++++
>  drivers/scsi/ufs/ufshcd.c    | 60 +++++++++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h    |  1 +
>  4 files changed, 70 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index b86b6a40d7e6..a162f63098e5 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -622,16 +622,28 @@ static const struct attribute_group
> ufs_sysfs_string_descriptors_group =3D {
>         .attrs =3D ufs_sysfs_string_descriptors,
>  };
>=20
> +static bool ufshcd_is_wb_flags(enum flag_idn idn)
Inline?
And just return (idn >=3D QUERY_FLAG_IDN_WB_EN &&  idn <=3D QUERY_FLAG_IDN_=
WB_BUFF_FLUSH_DURING_HIBERN8)

> +{
> +       if (idn >=3D QUERY_FLAG_IDN_WB_EN &&
> +           idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8)
> +               return true;
> +       else
> +               return false;
> +}
> +


>=20
> +int ufshcd_wb_get_flag_index(struct ufs_hba *hba)
> +{
> +       if (hba->dev_info.b_wb_buffer_type =3D=3D
> WB_BUF_MODE_LU_DEDICATED)
> +               return hba->dev_info.wb_dedicated_lu;
> +       else
No need for else.
Maybe make this static inline in ufshcd.h?

> +               return 0;
> +}
> +
