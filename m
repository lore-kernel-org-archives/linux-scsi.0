Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7738EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 07:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiDBHJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 03:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDBHJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 03:09:15 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84659102426
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 00:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648883242; x=1680419242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IRV6GAK5koDBBVWhp4hWGtJOGGsk/7tkf+weu4sw6OI=;
  b=ElqB0wVBV+kGaQVovQnWJtBlAwhZqQTeUi9rQrCMTTIY4+QXETQqe6xX
   WygWY++tpY5+xQDO2Cg8jV0iLvMu/Rl1oirCjDaB/WOcZgdEIXEsi+i8R
   4eX2t/qjmkOtk8n8au69dvw+pEOhXJAXnk6bTcUs7BOzJjAw5878L+cQQ
   GXqFl/z0ypFpjOA3Gcm32DBNtNy2+jgJmUWffXpJTrB+ZNMUQDL7hV5z2
   NdQ1reN+LmMt37QHOCfRq83cZuIWTtGene6W16RKd69izoRo53hZigq59
   k6oAv8zxOKES0+33BThmuhDC/LHo0vCaJinQ9OgLdLhlB8BLb5yItxgeP
   g==;
X-IronPort-AV: E=Sophos;i="5.90,229,1643644800"; 
   d="scan'208";a="201742168"
Received: from mail-dm6nam08lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 15:07:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf0+TjwB4EJKvTBNiOyov8S6Gp0C6Zn5BGGzTYJqRIsPUANfXF0Ze+lMLtaA47QhrD6ZvYRkUH1dpDgB+9bvLT+tEftn8QSlnr3uAlux0aPJEfIDbSXGOER607YOl8v/dVz7y3H7XEozaJWsjqOtM24QKhcWVis7fi/wJLtL7Jn9bQmZ2I/kcBvr2Ev1FXS90drwRptB0fXRYIjXCOAA2/K96tSrh4pNxN747no5bU5NsdEU5leJYH6B5HY/dSqOOX0rCuGnzH6A3J6UJDhlMODeVpxQY2CmeZ+6X/eLHmSZHqwJvtmz2gdqthxWzs8iAN095tBkxUGhg3I1wsmNrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRV6GAK5koDBBVWhp4hWGtJOGGsk/7tkf+weu4sw6OI=;
 b=AbxECtOPNHk6deJhjQMljswpv9AChgnbBRPw/RvU+A7rQJ17xji0TMWVO2b/hh8bLG8Ew+1qv5QH/O3mC1dC2xQG5ack7pZ2XX3jgbCuPXJIWDzXkaRtCOosNVrEuKQ039iEqB9yqxND9RNLECwRcO55p9pbI3A8CiiulibKuKVX/Sdwc49PbdPNnYFU+D3heHm3407icQLyj4lFtS7r0vT/qkQs7bZ0AkDJTJSfUd2JMhGqPmzLmcBFU0l4v2fcpItgPOJYXcVsgsDH2Eo5Z/80lu2OlLaI4qWeX7xBigyljaHGrBCRqsY8GOy4GXtSCDcz19Mpu3gLmeoXgH9/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRV6GAK5koDBBVWhp4hWGtJOGGsk/7tkf+weu4sw6OI=;
 b=N8OxDXe/lfr41nElnBzypT4aHFQOQXJUtu8z8tjgKOyonwxJzBYv+b+0bbPZbsXytksOIc5fmj1pkCIVAMdSCQIPwMnEkWhkWBzZqxD0cydeGEeY1FTl0F57lmiHBzjrkNpt+jMm/UzajCnj/FJcyl09zJwUa5dyL43Fkah4NLo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7245.namprd04.prod.outlook.com (2603:10b6:a03:294::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 07:07:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Sat, 2 Apr 2022
 07:07:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: RE: [PATCH 12/29] scsi: ufs: Switch to aggregate initialization
Thread-Topic: [PATCH 12/29] scsi: ufs: Switch to aggregate initialization
Thread-Index: AQHYRU/SKtOBFRRcq02lYoT9Tw+BcKzcNb/Q
Date:   Sat, 2 Apr 2022 07:07:20 +0000
Message-ID: <DM6PR04MB65759AA6C04038525E502EA7FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-13-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-13-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f485e142-c3e1-4745-2729-08da14776de0
x-ms-traffictypediagnostic: SJ0PR04MB7245:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB7245A68D374BA4BEA9A25FA4FCE39@SJ0PR04MB7245.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xzTA5omtSqerE82NdwDLKjSlIYAKtjSnvdeGDFXLJ39SsQ1/BhF7wk7S2dKYJPO77knLsAIp4C88//kWJULwYWXAj3ObgXlXvycmjsq4UoV/T69DvQ2QYuiTAmi/eY2+gpgwFDfdjYCGnNkqYQoAV++m+1LC6Uetxz4gTjrlMw0xcghnc1d0kjAaH8sLiMEWjhN/UsA0HTTpQ+7XEYQX+rw763VMhlj8/bIN5RfRqIXyKUTuqy6klloKY9yaV0cVEwtFXWwIgQVGY0cDt05Dj+aLtVyyyDvzNhf60oEwsij/fFP1U0G+TvQgx+MHDhlGl+LAlUxfyROj3gnHPDZ4+j7SVMJhw4LRoSLc9dG88YEjl1FIj0R4lHkyCn4/mGlSAwQnPb2uXkI2dluAxBJghyUW40bEDDdfA2AtRuUIxseYWOaqm0StceFKdb/L3RU07+cL+YQOOSRrULvdmVZdOg21Zi2yA6Lfd9oP1VwUpoqZlhDOU8mmP27PUDLhKcdR6yReAiBZFbJgJqufz1CEPITfkI0xMi4jiUNWU5uPDgaGQyGGrCMkxoZwZ8qrV/eLR3AAEQjQN9v7BerouFI76r24j40C8GTBxOs2qSs9WC19vroXfp1QBAheeYFIGU4rw7sV0DGTKt03A8YlI1ICxevH6xpJC4F1GaUM/LQSpc8YcWfcn79yXlvrka/vlldJeobVYzbLt26fMDkrCF3Y2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(64756008)(8676002)(66476007)(4326008)(66556008)(508600001)(7696005)(6506007)(86362001)(76116006)(71200400001)(33656002)(55016003)(558084003)(83380400001)(66946007)(7416002)(316002)(82960400001)(8936002)(2906002)(5660300002)(26005)(38100700002)(52536014)(110136005)(54906003)(122000001)(186003)(38070700005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EeH394InTyo2edngEOPkcRmlsrN2+ngf0bJKiBLYepQi6U3lsJafBXQeyFoZ?=
 =?us-ascii?Q?aS+YQ+2mTYa+GRh082tALhe4kL4uHf1562Lf1M6QqGsmwxFQgKcp4eetOhX3?=
 =?us-ascii?Q?9Ev1XlKOd9ueHHhPj5lEulGfWLgP72pZuYrIx+pdYhGruqwahI9jDm1/nltm?=
 =?us-ascii?Q?+6uoReI2xnpmdIqArpMByIZOhzertvdE71zYvHNjfl6V5mn6DyPn9u2i2clK?=
 =?us-ascii?Q?YNevsw+J+tkg+5x2QC+mgKIyQUuh+12/ysQvYNKvzk0b5VRroxuRqtPh937d?=
 =?us-ascii?Q?yck3cyK7ItpT1mrnpIuNxfFnsXcwhURyNzICKn65GlQDZPmLoeuHVGxAezFg?=
 =?us-ascii?Q?cbqtQDVqx1raxeQLKT+AOhTLMvbJuP70opt+GbdvqnuCxrRR2ngTIlSc/4MA?=
 =?us-ascii?Q?jSvoS4QFx138OeE8lope3JtImfFdLreiyHOdfTEyQ3zyTxEHmpQIZih2FT8d?=
 =?us-ascii?Q?SE8Gze19adm3pjDF2gEAl8GEsPFzQvjEkV99p5kFYtPFCjAgSlTy4I716/TI?=
 =?us-ascii?Q?TcRIaYblXK/lxhcawlLNTURBl4LJmjPOo7bs82ijLKDqFlOdtKysi969I754?=
 =?us-ascii?Q?R0JJ0gjEVjMW2IK+l0sVNVWBADk+jdGR0ALyZMUlfcAl2/U7SNl3MV2077+V?=
 =?us-ascii?Q?8VyDHLZ2fOw5EfJ2AG122P7liIJphjatR9IHuB8oH0LEsIiWqu3Wd4E5rJU7?=
 =?us-ascii?Q?9cPTwdUepZOTqNJ9bNdMDmWV8lw4J9WSeCKiRbXtnjCsRvdij4habyxo+VbL?=
 =?us-ascii?Q?HtBhy4drE97FPhuBskb/2yjhlqKKLWplSpj20aC5mOZDzlo6ZMPy5l6j9ZIl?=
 =?us-ascii?Q?LPPAABFK7cDZ0LvVxGEw/fEcaf6bkxTRYVxXS82j/2XDs4DVEOzUuAA3hasV?=
 =?us-ascii?Q?jjJ9U4leLAeI0H3Uj7mbLlzLss5yQQduG3oeMEI9W5DiskwBJNvGV+MYueL8?=
 =?us-ascii?Q?NT4B89iXDibFGCnhznHOu0+Rl8OG7aupVVBNDxEp4nBnDmk1+xfUjuHrfD0D?=
 =?us-ascii?Q?dUVnQLQTykEBjMe3yGhUq2uH4BCx0BU5v67gQmmwjmoC0quQXsfUDHjrJPkb?=
 =?us-ascii?Q?2s5NvHpHbSaDvplAlPwsz1/lNmSUQUTneDBXlugZkTgSia3mGCAqxcUTCchG?=
 =?us-ascii?Q?Ts1Ct1DgPMx/+3t28v3fd0ez2weeWuoQIvrhKANF5XBSZbXEcJsymtXC1UsS?=
 =?us-ascii?Q?7Mzb8A5cToDKvhgeP0zN7JckVn+nfUYyBm1+wOX/LnPRYfGAuNCDuS7tWwxn?=
 =?us-ascii?Q?xEhloaAuJdt7PYYqNmWm+UECh7bNu6lMwLPKsPbgIyzFk/Vv/xuZu+6/6tLh?=
 =?us-ascii?Q?fY+SHm5XS74G5SL02hGa9tvRpH+P7TMAGNkRlzKLdg4uaPf92k40FUl/M60P?=
 =?us-ascii?Q?TdOAqH+Hfo6ZV+JfgkpmjnaQOTaTUVH4rRP3MSdXJxquoYyx0lCB8a8q1Fgw?=
 =?us-ascii?Q?TCcW5u3HfjklvW67svpPIizxylLpP8zON+96nn1iRMXsPAKDknzbXncwz3S/?=
 =?us-ascii?Q?yomTD+PZ75N7FjReGP3kot5KWNmdDmeLkB0Mt+3m/8t697d5FDLV6JzbBCDT?=
 =?us-ascii?Q?dank/i0Xr79q/tsYaKYdfNSFJuYaFfkrKU0u6rpES6stHJG/d11uWfHnSMJT?=
 =?us-ascii?Q?TV3EnRpqCK4antcNHqbkk4l/++ATDAvB2fo2MqkoWNAxYY2ufsmCUsFdWZxp?=
 =?us-ascii?Q?tVktdVvjlMXoq2M/G9GmzViRf6B0mn0JmDxJJcKRnBlnZZrFYxs/GQdGd2ER?=
 =?us-ascii?Q?hMkxzuqdmw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f485e142-c3e1-4745-2729-08da14776de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2022 07:07:20.2167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MuCcQvQ40urVLfS9Mz8SFkyUPlxWZC9mXkblcvXSPFEqUZFmrzHJAPyM+suK4ATxvnQOUDHinPIxlfcz5Bkq7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7245
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Make it easier to verify for humans that ufshcd_init_pwr_dev_param() init=
ializes
> all structure members. This patch does not change any functionality.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
