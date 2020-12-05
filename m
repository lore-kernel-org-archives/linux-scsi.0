Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744B7C433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394AB22D2A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgLEIMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 03:12:03 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64597 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgLEIKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 03:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607155864; x=1638691864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gFc5oZYvAh5wSQP41kBNzBxu3qs7lFBf7h+5BDapJ2M=;
  b=O/N4RHrmZtWPzZzvpaQXb/zURcp8GvEie7BvaffhcmF2FXq/R6rJySkR
   rPmkyxbzGjaAsq77QfqeFEfrqMRCFw1vlJDnx65ruJ7kl3gjD2a/J/mnY
   pM3186snTvo5UVh4C9Yxj647hddKPAKEXtekWIUESEnPR/Sqs32KP7alK
   y760GwoeZEW3sgpDhSTRTPM36PdQdoW1xk6RjuX4qBLKRhV3+k6TiVPFB
   1nFNhYmnGDfuYfKpYk5wtyQMh4Vjkmp6APWB3AoNtjYRZS2+dMwrhgW3A
   TtM25OzaQqyFR934wfY3qnWdb2LC8SVT6vPCDvxCxaYQ64MKKLhqRzFxj
   Q==;
IronPort-SDR: NUBWgbapeL//OCn8j8dprVOGULLz+HidbmynKnCfizs2YIAUtEzbggw+B2o84JGqWTNGJTX0L6
 q/kx3mbh2GAcNfcsW+gnXfrGJxtJEIr3T8kRZqRk0E1kUISCCdrROBUw1DuPSSly1XnSd0rNUj
 vcFYrCxSAncmPdbmB2eX4yJAwrGEcU85bquKZWp0GBVR3Rl4c1o8wPbq1LsbTsCaO5AypoIobO
 t46npxkPNdy8xVMXCrzvCX+Tf/zWw3OmMTpMW83EqRRZ9hfakBDzF1XLgSD4BZAfG7ffOAQkm6
 /b0=
X-IronPort-AV: E=Sophos;i="5.78,395,1599494400"; 
   d="scan'208";a="154549203"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2020 16:08:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mskxbhQzUlMJRBd5k87AE5hnhiP+EM+8clQic35GguBM+7iMQmrl/be+9Hzd0At/i+2BG+kycXO7QPyzXQVm7C1byFF0T67bH1k4YTZaoK3SswqoZ3nyiVZXAOmcCSRPB9+1wtBDdA2B+sUyK3cFGzUNpEo6nI7J7GyCIE5sCnQBZdCoxt2SNyWg9KpiGIp0kaS0Hgmtzeq0YMOpNL9NS3uPGkFOaUoQHG00LyU5IDB3saHP6ztU3wbgCjCY1LRlXvuNNjxuwijOF/b6Mn4LLSS6ZLgmWHjijCpPvU6VPnpzxKXwGTKyub3otsrgLqtb6iV1INOCua0irwK0A2+FXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaD8ZXAnKZIbm34csWyxO0eghQirkjHU3q8r7YKqEDY=;
 b=oXisNjPQevRe2tJ5NkF/w/KzFMZbUxqQZMpjnl8NZGLoo6aebt8dEks22V3H0SPTJUfxwqfS+uuX1SIYGrR+2CUVWEQsOAADMXW9BjMsw3GXafHy+zic+/rhed851emUQKKEAHKl1kI2CtNRX9uHZixkCWsoVBpr+0au/cWZ4tD/sJOuRMa/BO8h4zYLkAyUrEWOgcXLnqJH2G9Jfn8jPTpwNV0c4HmBPe4jJ+l6YqS7W3b6F2yneaeQxuKwxLh1GDNV3Eq9t/zi9h3yA0i7G/lGRxg8Xiqzme5dPYEma/VY8Va1IjVlkJkp4xhvlL14ZBb5uBe6G1DYlDPU+yVoIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaD8ZXAnKZIbm34csWyxO0eghQirkjHU3q8r7YKqEDY=;
 b=KjxjUMTCWfSwyNw/O1nU04IlZ854rtukilTmjr1v+Dn4FT/GNpWltWmF+PfGW97EM/NYX5WAFNYUaXO9NZSlTDPJmMVP0uDxejR8wCAHU5vASQTtBtsrGLeQAoJoui0JYhgGgleoWJZ9XIBuEfKgmvHLiIJgApl1rordxVN7VMM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6667.namprd04.prod.outlook.com (2603:10b6:5:247::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Sat, 5 Dec 2020 08:08:49 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 08:08:49 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Thread-Topic: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Thread-Index: AQHWycQXp6g3K07ih063gLNOLCVad6noJ+8Q
Date:   Sat, 5 Dec 2020 08:08:49 +0000
Message-ID: <DM6PR04MB657589FD4F6C04B56F4240D5FCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201203223137.1205933-1-arnd@kernel.org>
In-Reply-To: <20201203223137.1205933-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e959d3fd-9539-42a1-dbd9-08d898f4ff1e
x-ms-traffictypediagnostic: DM6PR04MB6667:
x-microsoft-antispam-prvs: <DM6PR04MB6667ED7C1D385C7079A51C06FCF00@DM6PR04MB6667.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b3II3lU9ufbOkfaKzdDUVYaNWFQDsHPpHIJqrdoBLJnXaffc5qNyhDsP4BZ9Rf6JSGH0lUjZj7W6S12xBk0d0AxGVSiP2n9pUqz6NLfwRzE7XzA/C8YnvIRKsuT8DYHpfCq+xb92rnw6XcolB98ALxpbGVS4IZ+wu3EPosIRb3zCeSa4ULQsHtSOPBJ8y+8IOxAck59o+wYgFSKtoWQ4cDpai1EDbnffhepkaAiqNYvRvSBpyOMudvMF6f3v7cukvGjwum1PsyTv+Od0ZJpCijsK3AbnDMAiBXEASz5yEDG+byisiKt3iLhOTxRiMHd4RE3DvFA10Ogrb0Xln/DOeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(186003)(54906003)(4326008)(26005)(52536014)(9686003)(8676002)(33656002)(83380400001)(7416002)(110136005)(64756008)(66946007)(55016002)(66556008)(5660300002)(478600001)(66476007)(316002)(66446008)(8936002)(7696005)(2906002)(86362001)(6506007)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Bv2rbE/mLZaZWJdJQjSVGwyD0/buw7MB8nlUFWRsF9ivMen4jUR3UrXhA4xX?=
 =?us-ascii?Q?PP0l2IfuZZnLNIh+WvTg+Rf5PiyaqPVPGMSg01oRAWLFNLmJtn40zR1rmj9u?=
 =?us-ascii?Q?zdPTskh8ZS/KYcQX+UbmXzyMk2IWX6lNV54TgqIJTfymeg6FsD5xwqhn+Iwu?=
 =?us-ascii?Q?9LY6Cc3XwjiEDpKClCPsjF2olTRGbIBcpacBMkVhw9OEmmTnID97HJvMuNNW?=
 =?us-ascii?Q?rQeMTBT3dlkfsSVGx/5C4s53+AFE7+hG4QY7p5utBhHcjAXJdUrrZVBC7cOA?=
 =?us-ascii?Q?QlIDfB+lMTW+pJo/3noGNzsUixoUc/0waK5gmdQDO+AGxVbwXl2LpeomCS3f?=
 =?us-ascii?Q?zZ83lqC6gniJWSb8jhBLVSCdBBaJ8pFQPD1hIsgSQF5lz16eFDwQ4+eKvy7s?=
 =?us-ascii?Q?68cXClFAbYWHviIjpwQ0PzzGwqeRt5xpgpzrNUmTKeniln1Gfh43X81WC7cK?=
 =?us-ascii?Q?NKqGwvZpTW/aebkdmTX6FaHxCKVYNSanu3B8Qm83Mipe5W/yJztBG3kU51wl?=
 =?us-ascii?Q?Gr4rK17bcIccMnQsaaTWJ89Ariuz13YntMCTRrJDNJoLYoOzeDqdivqptf93?=
 =?us-ascii?Q?q6WBtCpbi1hEAyC+bUo+v4Qk+wN6j+L/T807hQSZMdQHphMU86eRubXoV5pK?=
 =?us-ascii?Q?S/bwTSqgufMQwZGRY5aXeBLjLYf3gkpNb+V2wm1K+w6ZmTviosN9TYIce9tN?=
 =?us-ascii?Q?eipjUU16x2d7VKuDpKWDm43AOk7t3hb0j3osdT8U4xvbOp702bVsMYVk7P0g?=
 =?us-ascii?Q?ukIac8m/0S16SyUuXJq+DvEqmYOHKBzfQFCB6qEompRfWZ28MwWosbfLDceX?=
 =?us-ascii?Q?Zp6mELGUFln9sHvpq3XNnORPvdO6fC4cnMrnJceFnW8K7S3Hv/r19y/4Bovv?=
 =?us-ascii?Q?8flVRPpEHL+e7tgxaEepwA0H84ZqB4sqMWBnpX1KOidywTlweY2r2nVNiBeo?=
 =?us-ascii?Q?aKYKJsVZ8moyWadFBKW/K2CJhvcQzFBIZcNghjD+G3A=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e959d3fd-9539-42a1-dbd9-08d898f4ff1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2020 08:08:49.1723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYTn67zuHL/OlHEOgMMm/YOt8cVv3b/zQuqZlKDpGNhBtiPCYumZImoWPqyGr6btpUTPakjDcGspDYThHDo79A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6667
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> clang complains about a possible code path in which a variable is
> used without an initialization:
>=20
> drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitial=
ized
> whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> include/asm-generic/bug.h:63:36: note: expanded from macro 'BUG_ON'
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (=
0)
>                                    ^~~~~~~~~~~~~~~~~~~
>=20
> Turn the BUG_ON(1) into an unconditional BUG() that makes it clear
> to clang that this code path is never hit.
>=20
> Fixes: 4f3e900b6282 ("scsi: ufs: Clear UAC for FFU and RPMB LUNs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f165baee937f..b4f7c4263334 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7687,7 +7687,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba
> *hba, u8 wlun)
>         else if (wlun =3D=3D UFS_UPIU_RPMB_WLUN)
>                 sdp =3D hba->sdev_rpmb;
>         else
> -               BUG_ON(1);
> +               BUG();
>         if (sdp) {
>                 ret =3D scsi_device_get(sdp);
>                 if (!ret && !scsi_device_online(sdp)) {
> --
> 2.27.0

