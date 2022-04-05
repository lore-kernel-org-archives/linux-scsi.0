Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED222C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiDEGwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiDEGwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:52:12 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6994F8E19A
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649141415; x=1680677415;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KZw15wmk64cdLao2IIrqYE2vTB4RXIOqF49Z0fqXXWk=;
  b=XM8NKZp74N5YlAgg3q5Zd/32TnEa5Pn6COIQnUlVqiQFuFRPam2nTz7S
   jgyMw5OFpCYUaDIqcdQNnEhpMOpsK6qqa/J783V3BXjOTkFbDtrTnS2Sa
   LjJGA8Dyo9HDtESzaJCUcWUATjlkNDZH9bjsjUoCj8im8lHDR2K9Vx43c
   8u3m9SPKqDityT3F/tXzhy84zlP2gsbXjTFbYAnpYJcg6L7HhcdscG1ZJ
   d/qdhS6lpe4bKk9hPcPgCOhizouAQxVh0GoLnK6coowA1bBAvrqs/m88d
   pVt+EYGUoJyWigqLqf4/Zqyme/62ZayxgIrxzBMTm4GU9MS2moCvtMR2W
   A==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643644800"; 
   d="scan'208";a="198010169"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:50:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1vvQq5Ds2eVWdp5TNkyRTf13iN64GxY/HBDANygvhUj95PwnkEn37ZHgefHk3Ou4aZpMzW19IE0/6EAPGfENAy+CT5tsQejUcL9CeVUi/Rm+VzTsRHoLyrJ9qFNJ775ZjkFXbowe/PsQBvHB6s70X/cWw72ol9wk8RAzbmq1V7z2HBEck0BSiIf9Wohi/UD4EmZ9SdEXTzXxuRKBlbSHzEA21fIMf5+Fil74X0+NffCEea8Re577AKZTzS35Bx0JVpufZX533FRs0LxiQ4lf8E1ny2/NlpbmBkAbqKvKTNBkn0cgEr5WRReZayM63yJoEH8Fnv6+nz+8IX+W+nq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9kLsNZYiqQt/y2JI4OcHY4DsZwTh4O20mZYvxe/GnU=;
 b=AhBSEzFGKIi2Dd4UsjEBIEKOHp13gK9BoBzK8wX2E5/K++hRByAtHxOi7m835EsiY4ZwQg7FyT+XpNL1eCHEao8ms5EMNoLf1Jn99bftSI6WVXiERX6si8a2YvoD0uGDPngUU0M/7PSNXHYuJLhhu890LzdUR687TfugRjoCt92rp10jd7uF2PP3JhofPtuTYufR92Fw9xPTe0X9GOG0EiQe7peuOF2UsbY8jwC480Lt9GR1jUHoTHbi9O9tQI9WIPcpA5ZLT9cVupG/Lhv+6Rtni9PJvX2J46/yhSc6+BQy+bU2VLG57cRBl4V5erjwRpv6hKJSvGCgUWfnZqfPIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9kLsNZYiqQt/y2JI4OcHY4DsZwTh4O20mZYvxe/GnU=;
 b=RSUEy1kXWsjgXYijMpFN2EXjl/RrhYSDSm0ognUlvO4xjR7yb5oVPB1FNz9ByGnBYwb/Svqxg5UaYVFpZdVRQ/87IMXuoAUb/BgrAWMB0VjRf2Pw4kRlLOhPmBI6a/Tr1aUWf5i5BhMAsI2Prl60WByrdBHGGuI1inl3sL8sGTg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN8PR04MB6161.namprd04.prod.outlook.com (2603:10b6:408:50::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:50:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:50:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 27/29] scsi: ufs: Move the struct ufs_ref_clk definition
Thread-Topic: [PATCH 27/29] scsi: ufs: Move the struct ufs_ref_clk definition
Thread-Index: AQHYRVBQrNssIswEg0a8pemX/rRAeqzg56zA
Date:   Tue, 5 Apr 2022 06:50:10 +0000
Message-ID: <DM6PR04MB6575DE32139BD4D1ECE5EABBFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-28-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-28-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44ef6db-50a2-497b-d624-08da16d0875e
x-ms-traffictypediagnostic: BN8PR04MB6161:EE_
x-microsoft-antispam-prvs: <BN8PR04MB61613F6E0F615D9AFC32C0F3FCE49@BN8PR04MB6161.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XISl04/sHjpAs1etmLl8sLMQYJh0X0UIbRNQxBdEAMJ7LIn2J+/8sncl7Y8zFPxar3q/JBatTmOaVny5DcIh5anEl1f3ofRvhskK24MD21sVWeblSCKBFFgxbcubUugnF2QOE0nH5gaysbOOSY2dEsZoyQ7Nlyuscv+YT1/MhD08vA4m6xgF3fB18aXAFD0PT3I4gd6wv8TAucrs2g9zohi+zTbSi4lN7tsdgcKzJG1Z7v/MB86I33cLeEOLY+vVI8CI4adPjiCVykbRL0RU7qpKOth6PJv+0GJ/mFsT0rUwFMnvO2RNc1BehIIGZpgJA4LACddj3/GDqL2YQVSSZrOcAt7kEQ68sQp1XPNVc8KjI/vyrsqH35REafQYr4EjA0DBrkL5Psvb1gcV8O3K0MohqRo2t1j+GWRojKsYrZdaezDR3blvxIN73Z74Mh5NVSl4CzJ8KookqiBHwvTP/zlkGWHDrRAXTihTPx2iJZWFOg+TnUFxtAmZl/4tXVOB5cfebr5huEIs8IletHykbQo88mVbPVYMA/+lp0PyRLvo48nr3QWTGUP1I/ba9tqA8GoDPhzl7PVg1zCs8uqFFBSWdaa5XDnh35DAfDFhlylZjKYZaLO1vCZm1nNq5QFX+IotnP6Yd8yZEkebF0ZraZE8eBnWPfSqiCaGMnVtpyHQScEUSjuLz/3WZELWxm1/C8IkKzPS5dZg87cMZxaA3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(64756008)(82960400001)(66446008)(66556008)(66476007)(38100700002)(8936002)(66946007)(7416002)(83380400001)(5660300002)(122000001)(76116006)(52536014)(86362001)(316002)(6506007)(33656002)(4326008)(186003)(7696005)(71200400001)(26005)(110136005)(9686003)(54906003)(55016003)(2906002)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xKVa73msUEsNqFm2frvcAFHFYSH3aEnhy910Rmernj0FEMXtuLssgaFUOsp0?=
 =?us-ascii?Q?GSW2bPItls3iB2LcmGXJfx5wcRc4D4xh3BpuDohL7E5ig5/iut+MJVaX+KnQ?=
 =?us-ascii?Q?Pzp8E53POiCmtqYupo+AXLIM7Q1bimuyD2d3LwldLbgmKA5pznc+sJikpokI?=
 =?us-ascii?Q?0FAJq+jEKcCi2IAlQMRHdSNqYW17fOeFARRUaVy2N4IRCCmUrrrXqYfKFACw?=
 =?us-ascii?Q?+TzkgXTOLCRcGEAXCQQ+N4Di1obH0QTjYUHxdD4Y3mnjOqNVQM2oKvfycCrK?=
 =?us-ascii?Q?A5nHTrW4U55yBXB/b17J3CGAiw73FlNBYOGAE+KnM3dnfkdEaaQuxMrV1VaV?=
 =?us-ascii?Q?f22XSfhQLpVMnFskVu9QKd6A/tAK+uDV25+nY9T0skdymmmgb9fGcwlnffVv?=
 =?us-ascii?Q?oinM2iCKL2QFcOiiHO1jKXbVR61yjOoGIubsIJkDgZFtjd8wmTjvdjKMGLH9?=
 =?us-ascii?Q?EexqKNZcs37gNCweeaxjFiIOcCwEZ+E2tdo09/LszpcvwZoPzUYQ36cPsL/j?=
 =?us-ascii?Q?gLX63Uzs+XQBIqOJVeywk1p4uGYZIHEUfs34HjW6eDLNnSpT2Tj+qL36pWw9?=
 =?us-ascii?Q?fFrben03T6VZ3nC2YbFyQSNGAW7byDwSfDCzdgJCJTcdvqny9ParOBHHBrqT?=
 =?us-ascii?Q?uEyk2Aowf8af4E5DVvEpiofB7RGuOgrKAIzvg0qVK+A+ZEK6pbb7GiUXdVC6?=
 =?us-ascii?Q?DzCmGej4cVtCjnZ2ox9vo1i2JxgiLA1xvgXC9TIg8XQySuiNSg8oKO7sVtMe?=
 =?us-ascii?Q?d9r9r7sxfHRMy3/T+oXEW/80clvxJ8ajr2TrVrVsSpG4yjwrHtKVMZZnKfOu?=
 =?us-ascii?Q?xNmd406ylpMfxzXjJKENv/Sktdt1/bUr4rRdlyDHy4oasDnZdDt881xINSQ5?=
 =?us-ascii?Q?1/361VjcbSMbnxOzmWR58bcs4OlUSGmO9CHUxkzFwQkLHyZzc0kypVPhSB4o?=
 =?us-ascii?Q?jHJsHeNgV4EhXLa2Xp72/HNzbUxPKu2C1DbwbFGAIn86AYCpO8zGe24tWj1b?=
 =?us-ascii?Q?M/m2+u7sgLQbTsg4a/v8WOGRabr2FXMWR+T9lY8OqnKO2xH5LTKRnVpg6DLW?=
 =?us-ascii?Q?DkrAE70mOS04LrWO0MJEblwAlynGjStc4Y534eyc7v6XNgGpOWo5cFwgF82C?=
 =?us-ascii?Q?t8mRFrNB79/iLZaDCNyLHDHVqCdoa3mxkwf7wBL9f2wpIhEJCcxxcNV+1A+J?=
 =?us-ascii?Q?/FqjLYmJeCYEAMCXzOqA0EwYZ04ydSgd8r/zNE8LVazQP6rdNzb5LCSYwIVA?=
 =?us-ascii?Q?5y/8Ui67S8/p9qDmxO0P7UX6VQU2aqm/yUWH8aXvRFrwiKYckcWoDJ6paMR4?=
 =?us-ascii?Q?xz7kMIKPGbqo16bL1WnEDAjO8rh21Cc2qgLwGThbTmFsy+Fw34z/LkXHDNJf?=
 =?us-ascii?Q?Rng+z6Pav2BHuAGoPfB8zy/UhOz18aIF/6nzrNcGUgyFkkLz5PF77gdl+Ak5?=
 =?us-ascii?Q?zz1raAjYersu326LABQrgZIMpRfBB3WL9Ejaak08fkcCtUZ6gW/95jYzb7wa?=
 =?us-ascii?Q?UW5+P3lxit6KxFDEf+3KBGx0DJyjCuzMGoHg60lhdh+XlW4e8I6tDYnbF2Ti?=
 =?us-ascii?Q?Po5RWatk5nUHu1JD8X973xzWN3VR1PKCqnI8TBttWUYtcmCx6hCmuPPPZ5Kp?=
 =?us-ascii?Q?3fUUmO2MuA/jcEQzxvMWiaFP3aBxDmJoPYmJpfyAvg9bwT4EqdKLOFiyO7jy?=
 =?us-ascii?Q?qf636p1NtPX4vzaNAUlx0rGZIiVuJPeMcpH7KRm3X1g6yLK2lmS4PgCXuZJ3?=
 =?us-ascii?Q?o8poC44Z9g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44ef6db-50a2-497b-d624-08da16d0875e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:50:10.5557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UT7BBFiFkxtMLjRok5axj8156IbBAlNUyrUJiWhuBuJKR07xC/Y7RnTgAIeNEaunkUfSUwx3146/vfaYl+PhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Move the definition of this data structure since it is only used in a sin=
gle
> source file.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs.h    | 5 -----
>  drivers/scsi/ufs/ufshcd.c | 5 +++++
>  2 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> 225b5b4a2a7e..f52173b8ad96 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -415,11 +415,6 @@ enum ufs_ref_clk_freq {
>         REF_CLK_FREQ_INVAL      =3D -1,
>  };
>=20
> -struct ufs_ref_clk {
> -       unsigned long freq_hz;
> -       enum ufs_ref_clk_freq val;
> -};
> -
>  /* Query response result code */
>  enum {
>         QUERY_RESULT_SUCCESS                    =3D 0x00,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> bab0f1ee41e6..27738f24c4a8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7959,6 +7959,11 @@ static int ufshcd_device_geo_params_init(struct
> ufs_hba *hba)
>         return err;
>  }
>=20
> +struct ufs_ref_clk {
> +       unsigned long freq_hz;
> +       enum ufs_ref_clk_freq val;
> +};
> +
>  static struct ufs_ref_clk ufs_ref_clk_freqs[] =3D {
>         {19200000, REF_CLK_FREQ_19_2_MHZ},
>         {26000000, REF_CLK_FREQ_26_MHZ},
While at it, maybe also declare this struct as const?

Thanks,
Avri
