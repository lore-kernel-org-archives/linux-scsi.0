Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939EBC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6696C208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hNdDhsMq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BmPzpgEi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEHIkE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:40:04 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55492 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgEHIkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588927203; x=1620463203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oohcefcQRKV7CJl9dmfTQPkYlqLL7e9K80qOJtnYi6E=;
  b=hNdDhsMqogvgI6O7cvoey7q/wZ207wbtCIDHscxUxPvs/eaypje+j8Bv
   F+cHLHmE00AKIACKRIq2Yih9zLj97Lpn6AFzsO0XC6EQ9Cn0gpe1iYMFO
   HnYfq9ovcvD+s23QQnN8llwmen3CvXOEkC7TAtydHbExABeP2P2uYjcNI
   oZ8lQWV5n6BSQ1Ai4pzertKwftgF4j/WqHk/VY3LepgnGKr5yk2HYkx7O
   DvuhAhBven+VdgPp68lAudnEIThytw7Q7MY0QXWV3EJiDJYMgQh4oDaqw
   QXdMnJz66mOWR+znP69L1fBWjnMHsJSmCPlR3AtTC/qPAZqHD0lsGn+NA
   Q==;
IronPort-SDR: wrWiUH2nDG04ZJI2f9ZHRxw3tXG7PuhVCPtQonXjDx+C+5X3asw1ewy1rEChoEVrOOkJubSaTJ
 +nohaahzaTOC/tGcJ4GPOp8OzH0/qqOvaxLRhHElvqR5m58/dyig3zpXe0j7yQv1fuziol0hla
 NW/3I6ZNdWIGzI9QJDT6p64lITf12DkH0W2wexU9xPnxT2zdOiIZZxu01JGVgzuZ7Kb4lxwI4h
 kzlqG2pSYiLpEZRKO3SvP0xuEA1Hlavki6mEYgAYYjEV59l9+X8R4+up4rcqL+xC4a/o79GzdL
 mtg=
X-IronPort-AV: E=Sophos;i="5.73,366,1583164800"; 
   d="scan'208";a="137216241"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 16:40:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNILnJLfVxSy7rJY3sfrsS7ekYadsOY/LBf9dWrW+5kxlEF93VE7N9D4EjUAcn/wzlctyNmdZ4tFnGwux7Hcxv48ltigC7QiuuCmVPRH+QkTE49ONsJM3yWRUqUtkS0EDQ9M/OZV6wUQxHcTQ0Ngd8Z0nK5CS60e6/gYGROMVUJZBTgtOaZ9hqf/D8E4YFMovpPsV8ObA34sg1lQTeBBHKgll3xjSKBLdlroZ/sjbN+Vrioe1hmlM1QvHkouuh76W2Bnn6Kw67T0V8lOwCQWcdAyhLywdHZWNZiuWE7v67bCP3ytnhr1LPW8cFbJXXcydzwz8eOmBqv8ggELH8ocKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdm5WcbNsW7oTrRkZEyPKE9XA9p8yAbFu0g4pAJRwqQ=;
 b=jAfgo8lV3ak/6dtopBEhw2Y88JTG1JlK3P9VVPLz8vASKNHYbXjYVRIwBgCsZ0llWExOYJz+l7WQ49UHlvfbjGcmNB/gB2u7ulIVuDVoamps3vuCZP3NJ+mbK8ugyfVvRccMHiT0jOVm9c+URmu3utCg0x1mI+X3scpW5YCr+ct3kfE0OpUZWFufD3P+hz4A2mdM1DazCPNDXss2uKoB1b5k2pggazERkg1N3q64FeslTGrvsWES8iE2DA+4+Kfzu74T0P+DdghTSACCIUorHfReaX0+gIgkf7jKW/RbCzVoZZk1391uLRritffy1W6VBbXuPnx2ARd5cIf8VMYyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdm5WcbNsW7oTrRkZEyPKE9XA9p8yAbFu0g4pAJRwqQ=;
 b=BmPzpgEi1Rq+aAH+OLItJIKbRylo1bY6/Euo817VTvKuzRrpXtJ5WA1q2DwAiaSc7N8Qn71NFvoENpMfpn3V31WVgmFi5HetNst5UefvbxjSg9W1MiS5K3Er7UhNTyI36Ew/yjbFmE8mPA48zhVD+78w32R8E1Y8HDbU/peHknw=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5104.namprd04.prod.outlook.com (2603:10b6:805:9d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 8 May
 2020 08:40:00 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.032; Fri, 8 May 2020
 08:40:00 +0000
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
Subject: RE: [PATCH v8 0/8] scsi: ufs: support LU Dedicated buffer mode for
 WriteBooster
Thread-Topic: [PATCH v8 0/8] scsi: ufs: support LU Dedicated buffer mode for
 WriteBooster
Thread-Index: AQHWJQ7gr0gnpM8U7069v+wIJ9OSoqid3i3w
Date:   Fri, 8 May 2020 08:40:00 +0000
Message-ID: <SN6PR04MB464039C499F73656FA92014CFCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200508080115.24233-1-stanley.chu@mediatek.com>
In-Reply-To: <20200508080115.24233-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f8cbc1f-a14e-4e66-1321-08d7f32b654d
x-ms-traffictypediagnostic: SN6PR04MB5104:
x-microsoft-antispam-prvs: <SN6PR04MB5104A74DF01E73497B39B767FCA20@SN6PR04MB5104.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lyez8/Ypl+1TQcEyDKKMDp82yu+N+CbZfe37P13CSc7dPODunl/IAbIDOV7H3l/UsIo0cqokydcyap+nyHO2g9fDO2i/nprjvWJemhruI2Cfr9EX9acRSz+v5fyiWuHWWJh72ZhWAPbIgg6c/LlpYPCtu7ZT4nPnKcQGsSER+xQGwztvtnk4OZ06eXcLiTLZcRKfakLiZcSKLygKZTxvdMCd5yoVJE6TCWmqK8J8EOOZkHqOVO/roBnQa6kQ0ur3JeFu6G/EE3E1lV/gKv6YUToRfMxvJgjDLezMvi14nKwtO16V9fpwWtmjps2XYO9rIoLlw9V3/BP4zz7lgGmm92DhIZw+Qlme0aVkTMzzUvD4isp9JGUwQb0NRiAfdvSvtJD0tuqNmUPcI2+S2w92cmbFcr2Nkxo7rJy71SfwevD4jgHvETeSKUh0nz/Ai4QIVzuyxRM0DPXaeHH9wLNeldzB/EfkRGigd2N/U9KvWWK4xufvn6BXk5pw5bz9SZ5hFSJjmNJGfQqPrXpe1Rbilw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(33430700001)(64756008)(66556008)(4326008)(8676002)(33440700001)(478600001)(7696005)(26005)(5660300002)(316002)(33656002)(186003)(83300400001)(71200400001)(54906003)(110136005)(83310400001)(83320400001)(83290400001)(83280400001)(6506007)(66476007)(8936002)(9686003)(76116006)(66446008)(52536014)(2906002)(66946007)(55016002)(86362001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: j4Pk8MGPM1jKqFtsjy38Vo8EDrfLhfWtcQvGARy2FdewlDb6XqDk5EiU7SavOhotoDByRDrrhSypybAB1kcqZK95n7sOWEMQxuRNd5iFFC62Sl0dMUEG8S8vdWrPW5UwQT/8vbW7lIw6S6CmdNl/NjfoX7wzB++V6ezC3vW411l9rAllDuJL966lDp+lFAweWa//1nA0j1F/jgEf13R3qXVJSaqlmtiGb9LVibNEwO5T8V59kc6x/+Wl3EP3BxTLRA1t7ENloLPd7tc9xvhO3S18OC10v8VWc17vqED7ErY7yaRawq/Ci4sL7lhjtVImXVL3o4IBRhqz417ivdi6NcQSm0b7NcMYElP/0bktalXir42vrpMqr7ajudIbctRrH8CuotwtT602XMpQyNokkGmE/BG9hnhcxmucuD7BD59PsXPbu3bJWdr5UvmiQFEWZwQ8cEU/Kyw2y3Sd1tCrtEXd0H5AUDtJvOpkIGB9bO8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8cbc1f-a14e-4e66-1321-08d7f32b654d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 08:40:00.4138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zdg8X/2c83x+lmseifTavHxzqyn3hsRMZLbv2BdOMTmGoqEs5qDNpZfkwb+RXwVJmfSK3i0FhELvG2/qea9nnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series looks good to me.
Thanks,
Avri

>=20
>=20
> Hi,
> This patchset adds LU dedicated buffer mode support for WriteBooster.
> In the meanwhile, enable WriteBooster capability on MediaTek UFS
> platforms.
>=20
> v7 -> v8:
>   - In exported funtion ufshcd_fixup_dev_quirks(), add null checking for
> parameter "fixups" (Avri Altman)
>=20
> v6 -> v7:
>   - Add device descriptor length check in ufshcd_wb_probe() back to preve=
nt
> out-of-boundary access in ufshcd_wb_probe()
>   - Fix the check of device descriptor length (Avri Altman)
>   - Provide a new ufs_fixup_device_setup() function to pack both device f=
ixup
> methods by general quirk table and vendor-specific way (Avri Altman)
>=20
> v5 -> v6:
>   - Remove device descriptor length check in ufshcd_wb_probe()
>=20
> v4 -> v5:
>   - Check LUN ID for available WriteBooster buffer only from 0 to 7 accor=
ding
> to spec (Avri Altman)
>   - Skip checking any possible errors from ufshcd_read_unit_desc_param(hb=
a,
> lun, UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS) in ufshcd_wb_probe() and
> check returned d_lu_wb_buf_alloc (shall be zero if error happens) (Avri
> Altman)
>=20
> v3 -> v4:
>   - Introduce "fixup_dev_quirks" vops to allow vendors to fix and modify
> device quirks, and provide an initial vendor-specific device quirk table =
on
> MediaTek UFS platforms
>   - Avoid relying on common device quirk table for pre-3.1 UFS device wit=
h
> non-standard WriteBooster support (Can Guo)
>   - Fix comments for ufshcd_wb_probe() (Can Guo)
>   - Make ufshcd_wb_get_flag_index() inline and fix ufshcd_is_wb_flags() (=
Avri
> Altman)
>=20
> v2 -> v3:
>   - Introduce a device quirk to support WriteBooster in pre-3.1 UFS devic=
es
> (Avri Altman)
>   - Fix WriteBooster related sysfs nodes. Now all WriteBooster related sy=
sfs
> nodes are specifically mapped to the LUN with WriteBooster enabled in LU
> Dedicated buffer mode (Avri Altman)
>=20
> v1 -> v2:
>   - Change the definition name of WriteBooster buffer mode to correspond
> to specification (Bean Huo)
>   - Add patch #5: "scsi: ufs: cleanup WriteBooster feature"
>=20
> Stanley Chu (8):
>   scsi: ufs: enable WriteBooster on some pre-3.1 UFS devices
>   scsi: ufs: introduce fixup_dev_quirks vops
>   scsi: ufs: export ufs_fixup_device_setup() function
>   scsi: ufs-mediatek: add fixup_dev_quirks vops
>   scsi: ufs: add "index" in parameter list of ufshcd_query_flag()
>   scsi: ufs: add LU Dedicated buffer mode support for WriteBooster
>   scsi: ufs-mediatek: enable WriteBooster capability
>   scsi: ufs: cleanup WriteBooster feature
>=20
>  drivers/scsi/ufs/ufs-mediatek.c |  25 ++++-
>  drivers/scsi/ufs/ufs-sysfs.c    |  11 ++-
>  drivers/scsi/ufs/ufs.h          |  10 ++
>  drivers/scsi/ufs/ufs_quirks.h   |   7 ++
>  drivers/scsi/ufs/ufshcd.c       | 166 +++++++++++++++++++++-----------
>  drivers/scsi/ufs/ufshcd.h       |  19 +++-
>  6 files changed, 176 insertions(+), 62 deletions(-)
>=20
> --
> 2.18.0
