Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3A4C34031
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 06:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D0D20801
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 06:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Pa3mrgJU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rI9PQQUb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgBTGUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 01:20:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22769 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgBTGUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2020 01:20:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582179622; x=1613715622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1KahjHCuwgcxukeQmjCX+ECQvIKAvnoC0fRy0r+M5xg=;
  b=Pa3mrgJUMdhSxPRnbtRcSbFVRID+qgc0iRzAXQeGZLuSaGHmvLgDJIU5
   6baQJ4SCYcjeBPDgoyvSiX7+ukaXSDdKtCkz4xn252mOsdRwJMqf3qiBx
   m1LrMoT9BH5JH0vc6CIhCipeWPTt85PnhwxPW8ymkrcPkPhYAT/AOHmvD
   yqOSOhB6YEHj4kGIGNCitZQvcas45ZBqGbuJK9hv7KJvVAHju/wTtYYGg
   NVRMWd3uo8i4TIQUK0gZkAwWBwd7ISMy/mjhHbrXgYbJ46/nfQAMENcS1
   ZnzuTcOlotPH5iJwcctVgQEI7jNsJr+y+Gcclkn3g5LzAAEi6MsysqHUe
   w==;
IronPort-SDR: 4asB45K+lkxvzQB9RQ3nOJ2luaWtHascoSWQCyb9m2aB34NPxcpiBb/cHdlEJgVTnQzLZPPanr
 eEuz50gGiQdnyZwwAIszP3Ja7logTDraxD0HNmajEOI8tO5WjdmJ4kWyNivZbNRhWaJdfFdcwN
 WuU8RRokHxohPCeZmrQJneDjX3R9kLUE6PeUHbSGf+z6iBEwZm6MmJ31ydp4Q0tX9bqVZniQLQ
 FRHJTVdZiBUkIqCnEnnVvj9hDbywwV8kNhv7NTlu2vdpjEIASMRCg8YcxKcaMD28nnB1zx2xUa
 odM=
X-IronPort-AV: E=Sophos;i="5.70,463,1574092800"; 
   d="scan'208";a="130776957"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2020 14:20:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjOwodqX87dEWMq+inw73xEqPtaTer3qksxs4p87Xob2H7uUwICQJ1g0oYfI0cf5+CvbXtgLGfcpcoqJ3poR7j393n/lTLPSaL2udbAJE6CRSm5AmuCt4L3AJv3bJjvvZUEgeLNscNFiCEjqSQXCCcnXWgCynq635fmLUCoJL8KJJ03bXIgfDvg39W7j8ifvVMdx5HWkKYbDLb+oYtVqCxmcf0X4Y4grbMz8cWi4EhsER6CD0c27UpkvhDqBKNRbO4hJuqMU55PcQ8quuSQuIxfTgKjiSEy1TYCjeVj0UXCFmlXe1MYgchR+x0hn1EsvCAudDIzQTJGINCWqchDqqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82/fcUnDyl4GO8eAtMYMZzgJG7xxmMSL2bZ4gJd7dPQ=;
 b=dCx7Q4sW9EwlnTY+V28iOSzUCxU+bsFUXGUY1FWe2xFJW2y6DBrftWgoQQyPPro5pnvbwUxU2mGO64HN45XefeyFAHDIK+XtTVuZEYQqUXKG7hfM7n6tgaCMOf691AIHI7d0mkkrl42UsV87BD94XoekwSkQzjv+MjJZfzpQPBc9sETwIEuEYWAQXajwETeCUf5EdDvHt9/Va62HK4DEBfLgLtFE+78UChuyahWY9PWu6bkUw1/U3aMOMDpfdjQquQtYibaGepQ1N/G0Y7qGr6+09tcWTwQZRH2uOmz1CUHtS4MbHf2r5dSa1HeyrwJFK/UmVWKYwclGHvZ+bgyuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82/fcUnDyl4GO8eAtMYMZzgJG7xxmMSL2bZ4gJd7dPQ=;
 b=rI9PQQUbyqXlrjVNfYNUUipYHHjnmCK6xkdugItwMIzq/tbNS2ashNGhlXFoDu4rU30v26C5lvxt31hR/pacdXFoDqnNY5KYPF/2s8YQks7hgK1qb8lZ+hPbB90tRaN5dXiBdrxicCNfMWfMvQGGGsoL7KNoIgK/xsD//C4wmFY=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17)
 by MN2PR04MB6141.namprd04.prod.outlook.com (2603:10b6:208:da::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25; Thu, 20 Feb
 2020 06:20:19 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 06:20:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS
 devices
Thread-Topic: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS
 devices
Thread-Index: AQHV3MaMtgu8HMpv5UGzOGGhOPfwHKgjsEbg
Date:   Thu, 20 Feb 2020 06:20:19 +0000
Message-ID: <MN2PR04MB6991569990279CA1985BE92DFC130@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48fc2f2f-7566-4e3b-9568-08d7b5ccf57b
x-ms-traffictypediagnostic: MN2PR04MB6141:
x-microsoft-antispam-prvs: <MN2PR04MB61413F5A9C4EDDD03F28C59AFC130@MN2PR04MB6141.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(189003)(199004)(71200400001)(64756008)(4326008)(33656002)(316002)(66446008)(478600001)(66946007)(52536014)(55016002)(66556008)(2906002)(110136005)(7696005)(54906003)(76116006)(9686003)(66476007)(5660300002)(7416002)(4744005)(26005)(81166006)(81156014)(86362001)(8936002)(6506007)(186003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6141;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENkrAAgtuCgsOERnAm91pyiz9VFKBvdQXp8v/k2JgVRHmXphHWOxdbdrDD2uCHIlRTVD3UB6/bzjQEBIXMvkSwa9pVIXSXmuChQhHippEIP38AR01jaDxeoUDlTcE1pe04yw/gt9ro9JHbcPX75AwAJECYo9ifKfaZpWqSokeyDKdwDlX/eeMUMhTqypfVOSmBQ2tn4R+loExl/eryb8xwVLzGwla+ry5Hyob/7vWaD+tels9GrGmEhH9WTnOeD3KLPlnGwM+GI58oCSvK5Kcs9YrKQnV3b7bti4mEn010Vm0VX4HU1FFzsoMCH+m7Ze+3PjQ6ycdGpobXY1xqOJ7DtH+nzB+p5BeGdfJybFIDUgsST1OkLCOcbzVPeeBikSyJ/d2AEBW6eVcbVRFXTkwXEdABLfBxun6OPiHreiU+h1Z75pX9xUlnqFe7bWhiy3
x-ms-exchange-antispam-messagedata: rUnyCsAd+cWkol5UQ30fZ7WKtNjLy+ZTxsU74rZOUFYA0mY0fNql2Zbgfypd0FQzzYhyMWySRH7qM0AV+aVMrd1NMBT2fdWkmbcB9Alttax+3jxAKHtBfJknm7yohKIAencTfWCvJ2QbtiLvlife4A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fc2f2f-7566-4e3b-9568-08d7b5ccf57b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 06:20:19.2020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: El7XmBK+hVePOoPkRogk51i/CyNIa9EhenpRw/icNr60LBt68IKdtejbB2T2j/0w0TlR4IT6pnrdOK2RtOaAtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6141
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>=20
>  /**
>   * ufs_dev_fix - ufs device quirk info
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1fe0a97..a066f00 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -239,6 +239,8 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] =3D {
>                 UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
>         UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
>                 UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
> +       UFS_FIX(UFS_VENDOR_WDC, UFS_ANY_MODEL,
> +               UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
We are objecting to apply this quirk categorically for all SOC vendors.
Please use a vendor-specific quirk for that.

Thanks,
Avri
