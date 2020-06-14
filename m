Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBB6C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 09:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9296020714
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 09:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hBzZNU4i";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iKkgUsy5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgFNJxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 05:53:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61472 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgFNJxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 05:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592128410; x=1623664410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QALnb0YOaOpAsx0crWsW2SjWYuJMPn9J0pOcgtE93/8=;
  b=hBzZNU4im7A7ZkmqBccc1TIV8w78RUFTpRPOWrS5oCQdYn0mnPZrrDEL
   yGcLPfsO2MIBtr4lgSWNaNZbdJ/UNj5CnoFZaEvRXh+o6KFTAQuCZ6S89
   aBaO1RXpz56VsWcHoiMu3GSTSm3kizKpi70dfhEJ8+YaW59XqXTUCFUyK
   EwR0ly9vuE3byBCZyC+4UoVuKiyGJHVfzoYYVra/m6lWsUaxbRycVI4ki
   ivuw+e5MDQrq2K1vk5pV7pEb/bSo9W9uP/ZT494Rn23bGOkT1GtscHEWC
   ShLpuDYwJb3SE2FUHq7JTJaHlmU0i7CHtbRJ+5wzK++M0+eWD2g4fTn6I
   A==;
IronPort-SDR: 2wx60tWQItal1bTrOBqdA/2jDtV+zWct9SEToLbcL8I6jBX4EDZeVo0PlF//IfYSKqomx0ld9E
 RZKGliOp/Xj/8izJKpeEGfbLAQrfmkiIbNcVO4opAnq4bAC6exxDUR8UZWBtoKD5NsySjFpt2M
 VpOFWlLIORNd7S77oN+o8b5t4fJshPlFHDfrJlJGSI0BqjsBNXbgSD8ge5Yx4JTdd+KQqLDiuq
 6nNV589ZrZV2sTcqz3gs2m/jn5BipymAe3eci5LNiGdGl9T+0u3wTVIqDskpkCpKs/I8vFPfKI
 zvs=
X-IronPort-AV: E=Sophos;i="5.73,510,1583164800"; 
   d="scan'208";a="249115242"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2020 17:53:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bo4SGCoOADP/213tEdRY6qZwQzQyMkCDzKXL9ZFv13kdSbaTacAB4nGvDhRhDeBgHNCf/8/v6KwvRhxykrVxa1RwdvAJKwJqCktDrNHxLTzrhNGsjRjfB1M6zYt6A8l7n/5GccZi42cm0HcFenszVFxQx2fiwSf89S5Fz0cL2cHQm6pU5H4MDCsC9f/Aq8YGezPc4ijWVoHeEIMZ2SZb60jmz2LjqzStX4fet/9jkA/eW9COQNy2VG2/mwDVi/cSy3jtQL2d30nX4WPg9U0o03p1vvkByOTYdrQTGrhdfrP78S45byApMgrL3b5jYweWOW8ThTmN0IVSUKWHIXfbeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UowTRJ5JDFZT+H24K9ceVDAQwJtKPb6T0Yx+aWEil/w=;
 b=XNlmwx+KKCZp6/aY97Ym2ApOZZ5w+grj8TsEOqDhsojspykL7tStZvq6L2dNi1UJCQ6y8ig4jurAmTsvu4qpDwHs5cizl1UYDtXoh0l9/t0pRw5fBMgHJGAhuTPpeGHRt9TZyUlmSS6oVjkUxWqSPO2G/FMoCRKdQZWaZjGD4qTsbMf9LKfCWgK/mX+MWJtOxqzizdodHib9+4Lr6Uu62qK+LLxP41ECJYHyGjroAkoe9MSKwl9VB+oAWDHF1C7Cl0+/FRJQBW1yucvyZAh2iFYnPW8z4xZcOQNmcrWoxtGWp7f1sSfnhIkNSGSdrlUxqVzSbE+yIkQpf+gv2l3Qxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UowTRJ5JDFZT+H24K9ceVDAQwJtKPb6T0Yx+aWEil/w=;
 b=iKkgUsy5Hp20YtF9yFk/d+yZZ42CejPxFM71oRKi4krg67/MrdapYd4WOOlNFlPbE8QrB6fDF2k7nAuz5L1tkgx4Jp3z9AqhJ7WjW2vP4UnSEr0wwMhyRzFy1AW+I2DDs6gcYKXKI6OWSF9pLyGyGInnt0qmE18vicujm4v+8sI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2350.namprd04.prod.outlook.com (2603:10b6:804:8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Sun, 14 Jun
 2020 09:53:26 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.028; Sun, 14 Jun 2020
 09:53:26 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Asutosh Das <asutoshd@codeaurora.org>,
        "gregkh@google.com" <gregkh@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] Documentation:sysfs-ufs: Add WriteBooster
 documentation
Thread-Topic: [PATCH 1/1] Documentation:sysfs-ufs: Add WriteBooster
 documentation
Thread-Index: AQHWPoHvCtU+Wdx150Ku3J+9F2SH8qjX5J7w
Date:   Sun, 14 Jun 2020 09:53:26 +0000
Message-ID: <SN6PR04MB464016DB3CD7D3A1583169E2FC9F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1591723067-22998-1-git-send-email-asutoshd@codeaurora.org>
In-Reply-To: <1591723067-22998-1-git-send-email-asutoshd@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15935005-f86c-4fb1-5544-08d81048c8b4
x-ms-traffictypediagnostic: SN2PR04MB2350:
x-microsoft-antispam-prvs: <SN2PR04MB23500BA260C3C982EC7C16A0FC9F0@SN2PR04MB2350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04347F8039
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWPwkgxlY2cOc38fDVfr7FyNboXVyOeVYRTzAEflLuEU3z5SiNirOyC2Pt21pLigcAjVKJXmde2biov4GgIFiOkcp6wI+sd664fb9nk7awXMjP7/mP0P4AljmgNFhl7Ha7BtXF8RzmiELn1nME7RVuAx9vNjZ1EpO56hy7flxYmRcalIKnXhjliWR1RVjSqq7RblvV1gWp4Pxor+d9frbhEp6Dr5SI15VObJQHKKT0/B5ZV2snu4s8mJEJI+G6Wwls5M/rUZH5q3tDRFKz+nTBlOM4JuOal9DbSAhlSulFmYQZGHXuqQqoAhNAa8S5enpD2U81NbCIkUgX7QRV5sUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39850400004)(83380400001)(478600001)(4326008)(33656002)(5660300002)(316002)(55016002)(66946007)(71200400001)(76116006)(66476007)(54906003)(86362001)(110136005)(52536014)(64756008)(66556008)(9686003)(66446008)(8676002)(2906002)(6506007)(26005)(7696005)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 09UwbuWQAXSmQd45qDT7MNSLyZXo55/B5spkB3c/ptVML5F4DA69p5z1tR2jNZ5mEk3BD8r7JgZM8zSl+RZIQtyHUwpmzy9cjoqt/xJmv0XnRO9oMCfgHKNlMpwT2eMwJTZ0lVaVU1SskLdal700Vkryu804MKRlEZPvwxRDeXIYb1ssq6Xiq1W0tligb2uf28utdzrrrMbYHzZXwKMo7+oVEB/4iwRLUwwfLNi/4iZthnZjp/Jzt3TlsKuWXnxdOMsLp2GoUCv6Ukn3ZG8tqgxQr+x7atZ45QtyryroD81K2fZgdU6LvUTis2KWonRqbwdUyaXrkr22dApn4odYeTUXuQbArcv6yqjkanXyCzgkg42KSUP7pkWW8iPEQLLfM2jg5C7CilC4J2NLc0TWvoknd1yKhrnfF5vVRoBI4F1W12mkf0Na8wwhRzHYyIv87BXwQAmzeuxVtbSp4MTbwjk1GdB6SzuyiMTJlK9eSas=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15935005-f86c-4fb1-5544-08d81048c8b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2020 09:53:26.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gOMOPNhMnmINQP8czhJNAqO9B9ZDICwAVQKVNsjRgUl83FO7ZUukmzwEz2EJGROR4BqgJ/87JuySkhyVAvny4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Adds sysfs documentation for WriteBooster entries.
>=20
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Acked-by: Avri Altman <avri.altman@wdc.com>

Maybe insert each field following the fields of the same descriptor, attrib=
utes, flags etc.

Thanks,
Avri
=20
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 136
> +++++++++++++++++++++++++++++
>  1 file changed, 136 insertions(+)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index 016724e..d1a3521 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -883,3 +883,139 @@ Contact:  Subhash Jadavani
> <subhashj@codeaurora.org>
>  Description:   This entry shows the target state of an UFS UIC link
>                 for the chosen system power management level.
>                 The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_presv_us_en
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows if preserve user-space was configured
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_shared_alloc_unit=
s
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the shared allocated units of WB buffer
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_t=
ype
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the configured WB type.
> +               0x1 for shared buffer mode. 0x0 for dedicated buffer mode=
.
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_buff_cap_adj
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the total user-space decrease in shared
> +               buffer mode.
> +               The value of this parameter is 3 for TLC NAND when SLC mo=
de
> +               is used as WriteBooster Buffer. 2 for MLC NAND.
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_alloc_unit
> s
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the Maximum total WriteBooster Buffer si=
ze
> +               which is supported by the entire device.
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_wb_luns
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the maximum number of luns that can
> support
> +               WriteBooster.
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_red_type
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   The supportability of user space reduction mode
> +               and preserve user space mode.
> +               00h: WriteBooster Buffer can be configured only in
> +               user space reduction type.
> +               01h: WriteBooster Buffer can be configured only in
> +               preserve user space type.
> +               02h: Device can be configured in either user space
> +               reduction type or preserve user space type.
> +               The file is read only.
> +
> +What:
> /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_wb_type
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   The supportability of WriteBooster Buffer type.
> +               00h: LU based WriteBooster Buffer configuration
> +               01h: Single shared WriteBooster Buffer
> +               configuration
> +               02h: Supporting both LU based WriteBooster
> +               Buffer and Single shared WriteBooster Buffer
> +               configuration
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the status of WriteBooster.
> +               0: WriteBooster is not enabled.
> +               1: WriteBooster is enabled
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_en
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows if flush is enabled.
> +               0: Flush operation is not performed.
> +               1: Flush operation is performed.
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_during_=
h8
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   Flush WriteBooster Buffer during hibernate state.
> +               0: Device is not allowed to flush the
> +               WriteBooster Buffer during link hibernate
> +               state.
> +               1: Device is allowed to flush the
> +               WriteBooster Buffer during link hibernate
> +               state
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_avail_bu=
f
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the amount of unused WriteBooster buffer
> +               available.
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_buf
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the amount of unused current buffer.
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_flush_st=
atus
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the flush operation status.
> +               00h: idle
> +               01h: Flush operation in progress
> +               02h: Flush operation stopped prematurely.
> +               03h: Flush operation completed successfully
> +               04h: Flush operation general failure
> +               The file is read only.
> +
> +What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_life_tim=
e_est
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows an indication of the WriteBooster Buffer
> +               lifetime based on the amount of performed program/erase c=
ycles
> +               01h: 0% - 10% WriteBooster Buffer life time used
> +               ...
> +               0Ah: 90% - 100% WriteBooster Buffer life time used
> +               The file is read only.
> +
> +What:
> /sys/class/scsi_device/*/device/unit_descriptor/wb_buf_alloc_units
> +Date:          June 2020
> +Contact:       Asutosh Das <asutoshd@codeaurora.org>
> +Description:   This entry shows the configured size of WriteBooster buff=
er.
> +               0400h corresponds to 4GB.
> +               The file is read only.
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.

