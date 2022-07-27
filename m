Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67567C19F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 05:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiG0FGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 01:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiG0FGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 01:06:44 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F4B3ED46
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 22:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658898403; x=1690434403;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z5wNmEdN4dlKH34/Wpy++vkCAi0yqTGcpyc2LZPi2/k=;
  b=qn927Gf+6jz/vmucw3h/P8f9Xun0iDxq318+Y22mPBJBRsfwuNd7Hkv4
   K0wszmyrfYPs8nV7vXVZZyVppH9YdMWwwnnXWs0zTz1Yjj7/7wvgUy/a1
   0IkBKvIMsHcp9/NITVXPzFtE7GaZZnv4B3o9FoACOKolb8m90j5UP9yiC
   IkqvICGHnXEWvxT2kGrI1RR7WbcHJGSyGsAPAMVcg+JlCD65nBshUrniX
   erebQ/NKlYNmyjMl3u8tA4hQ83klPrRnTeXABtnrBR/j+2UugUbxfBkcW
   6Yjo5Gq2t/AxULyZmBDS6iV15e4a6VyI6AFd+8W2fekFJK4LsIJPPepRn
   g==;
X-IronPort-AV: E=Sophos;i="5.93,195,1654531200"; 
   d="scan'208";a="311324207"
Received: from mail-dm3nam02lp2046.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.46])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2022 13:06:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9xCSpzC0CeAh9lj96q3wTKaG9Qa00Ji1LGJHw4Cw1XovBQEZPFvzhiAZM+39dLjPMbXERpr244nmmbmRR3QWI71oOMp60mSqOSiB7I4rTq8MxpWNcV/hNt2k6SOerwATyTyxG8VyVDqm/mHXzy5PNaBnUf845BOGBUq5yzCDtLQ8/41kP0gTHdqhnZANfX7L74LUHHK9F87TOptCEEjsbsO5wuQtEVb+BdSCO98NtJyTNf4pnGQSrQC3vZu+IXz+49rjRqDDc8hHvNwC19mTSpQ19x9Vec2Gq9jGROoafhiAA/tUHVUre6LjfPQtUstothTL6nyvD7zuz2EZTWung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQptiA7oF/9TA+MTBUHk0WBxz6rgZkAmX6Oz3FfpiNs=;
 b=E28FPlyM28cXhXE17XB/KRPXKAWpNRFCKZBmZjKrPy9E5QLnp2DAVp/2aIp5X1r+d9rzNsqLg/xKgX8Xhtbvkhiq9Sa/gzqAf6+abshjSExq9yPH63uY3sgdbx1NpqqlWXqM3JP1PNB6IvJgEpP3meySAJc7s7tNS/V2OixJ7hgLMuT6j4ucQeqKB/AlpIlSGyfJab4+w8utFnHTCAeM0JrZQ7MFZTvcRXtUSSBvGDlaPZLOKIOqxr8WDn9ZCo/++NNaiJru4V4s23UsEIIafXh1FuHylhoGjcsM4WRCK/3R9mupVJu7SzfLdm+l/MKmm7TeEXEauPeF8yf+nn8sTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQptiA7oF/9TA+MTBUHk0WBxz6rgZkAmX6Oz3FfpiNs=;
 b=fICbz+9bg79rZwyQCdj1LklCGCh+XqoLt+1uzm3GLK5cF+8PNQqgQiRRfvqDSkKETcfu9TlfgN8gexnMds0ks+5Vg1u7A2z90lxf7Rw1aMdKcqliZjHHwFVgenJ4e2iUcXYZQIibhCtmLlQ3tTVUdFB/vxo2uEXmMGC5OcB/icU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3591.namprd04.prod.outlook.com (2603:10b6:4:7e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.20; Wed, 27 Jul 2022 05:06:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%8]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 05:06:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYoUJpEBYvXOGAcUaKJAM8n3WSFa2RqoAg
Date:   Wed, 27 Jul 2022 05:06:41 +0000
Message-ID: <DM6PR04MB657579C6DD153D3090E79773FC979@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
In-Reply-To: <20220726225232.1362251-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d2a29a9-c0ba-4163-56c6-08da6f8dcae9
x-ms-traffictypediagnostic: DM5PR0401MB3591:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C+WhF3ltVudsjDeXqnrVGyMElvcqY/fuh/N9Z4MIkwbHOCCWKOM7lNYb7gyGuJbSFB7kILcuyAILj1UU08+6QPK8qlCF5EYRYXim4DAvZOrfH2GY6KuIx2d6BKMPqu0X+XfuxFlxDjUpZ5roaORJmVYr9Hb+iPCfZ0MXCAq454ZWFJWU5QyD9xS23L+AxVJF7uUNXm6Xihj7Fw7KUoaIYbFXKiy7UjcwS+wDPjr/hib4+AtNhkNClyjScekFiuqGfoRB0asezdlzJ2o1NGpeCfMKK7gkhgDjCZZEM+ScQYXjmHHQU+iAfjkNsf4PN3rcuZHeSAtWOpxt/QsQ1b2BipOvm6EsSBqum+i+jhCspYW1iP5pYUEv74HH1nZUipi8mvagTwHGS0SgG+33gsmoAwHVKFnaV7IOBgCdGnrDYw2k56vdr57PC+ew2CtACAPGoHULfkknoiDs87NP+e6H2aUA33G2vyoY9Xe3ZusvAjKp3dUGjlBmNkFHKXOf4mc2G6Uem7Tx5Es/bjd4hSYYt+RZTwUOpePCuEdJPSBfU9pL6rmNtnQ6pYDqG99No3zXAiiWYjsOx1sHIaHMFH9GRvuasTkprjLpsTyJutYDe2hR+JsJZuqZmCLMWdfPs/DLFWuFu239F3t50FHFFo91cohnZtgBEKQbOkqClpVnRFWDtNryKBKILYWyPXUItAAKXoYS5TnSYM0SjpKs5lJ+REHaB+/sd/0GJoDWXV0h3/NPOvq1vnv00FK8u8I3rah317AKeu7gTBr1QijYDsZ7q9g/ELz+jkiQxkd2XP2cVJYNhZvV+BSFy0AlGEmTK00q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(186003)(82960400001)(83380400001)(54906003)(110136005)(38070700005)(122000001)(33656002)(38100700002)(86362001)(26005)(7696005)(66556008)(4744005)(8936002)(66476007)(66446008)(41300700001)(478600001)(4326008)(55016003)(66946007)(2906002)(5660300002)(9686003)(71200400001)(76116006)(64756008)(52536014)(6506007)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ggsrt7eOGhBO3vrqViwikKR2mIzxj4zorvmoC7J8b/3SmuqMM37pqmgOGNNZ?=
 =?us-ascii?Q?EBlghyDcjd1gE4Uv/dxHfODDqt5BN5HutSRdKxZlNwWe5Xg45g96c2NKgtVK?=
 =?us-ascii?Q?DdRSOPYgyI77Xep/jwr0T5JNQdLW8P9iy/jJgWASKekuUZOtCLlwd1JMcUfP?=
 =?us-ascii?Q?8gdNw0qUDDIv71n6lehjwdrOm0g/Cb4KjeF3+svYfMcKO1MLDpUIOf+gSUiO?=
 =?us-ascii?Q?tJWST2cid9DgD40HPyPy9EexWhtHaNcigj0u+ls0a9vUGhPdFkj34yHjEtFI?=
 =?us-ascii?Q?417XqHqcIX39SjFlT2SFRgmQiQtpxyqgw0gOM7REELauOgMgJS9BuLIEdki0?=
 =?us-ascii?Q?KaKJ43C1L7g1Sskma2H3wh1L/8qv6IwOX2exz6qVX8uG+svUCe/L1YQ3Cz/K?=
 =?us-ascii?Q?o5TLp8SnCat0839xsFZibXAht7NO/JNHNYTOGCa7D7o+3dFAVh/UCmG96ojw?=
 =?us-ascii?Q?AKsx/nHEMdWI6IEjrKQo+3zezxNZF3UJcnAGclnLSbQgC0wnchMXLm0A9VIz?=
 =?us-ascii?Q?86TrmJt0UnEoycamGybX3J+zQce7czC7tNMwZHG1yKjy6KuZPceGjLhvy/wy?=
 =?us-ascii?Q?DC2cQDYKj+xVCiRS3GnhtI7eD9+hP4oLLXAtA1PfiBTgyxpTLpwrkdigMipW?=
 =?us-ascii?Q?F3uVjfPGO+6yjo6Hc7D7fnDqFIuX0R0qVRAMNAcMTs1YX2iQxV786O5w4xEa?=
 =?us-ascii?Q?ah9catkBb47kDwuNRziERWbnvnvMT9tm8bU0F3cscchaeXypslswXZPrtBQp?=
 =?us-ascii?Q?ebjbYCHE2ehm3Ih+M5DLqD+tXyA9VLpYX9W/YqmsXoLQH0RLGzHi/QzZBg4F?=
 =?us-ascii?Q?NmGgZUUXhX1BObQOq+rfwFW6u3j0kfV2KpuSe+W/BGPBmZpcgu3O+NzhxIw5?=
 =?us-ascii?Q?UUQ1V9tvbLcuxKxs9LW+PCPzw/niUHYMsyDIYX6CXW8UlIUx9z27hwLO5QN+?=
 =?us-ascii?Q?77H8A/ZIsufw4JGCP4I7/CrF/q1UAj+0aS+SVMN45+/O+3Shd4WFLvI1VNnw?=
 =?us-ascii?Q?lpwcNVgkth4hQJAZCzDMy0vRDIuYkSqXoJGhJPYEVxQ40K/FiRSvEjfxj+SX?=
 =?us-ascii?Q?7QBJZ73Ul1Hgd19px/T/fz20PXd05jjEO1ExKEA1WPrYfStfarRWOMxTywIk?=
 =?us-ascii?Q?tMeIt/6u6E0UQVoz/sPyMda43Gs2eEcAnsjsXBJl7Q2xr3nKUya8ZF5f7vAQ?=
 =?us-ascii?Q?mVVjUdxH6snE+cK+F+1JOxWFvRgQ1jajcqxe0pzCG5TXvDt+fYPhf7TH562K?=
 =?us-ascii?Q?QN7lEsSzBKGo/GvCJ0DG/1UTjO8wt7Hikv0KISdjoBChOepeCxVAdARIII4H?=
 =?us-ascii?Q?KmfAmqQXSh8+ZCQ+67z/n0+aKyTsak7sQ5TblNIc1yS1+O/9Lxk7W+hi5HGA?=
 =?us-ascii?Q?Cn83NiSB353/La1t9HXB9k3nOkIvL4L+M+DSN63IJKXS/njXB0My4bCumijt?=
 =?us-ascii?Q?hNaTG/LxTegYppopCvlqY8K+r/l/rpsMY3vCnsdWRBuPqutg2sW310mTLudc?=
 =?us-ascii?Q?dClll/gci2tUn1mWWCpEMT0BH3roOq9uX6/O0QOB7lB3sUjYK2p+RXsUTodG?=
 =?us-ascii?Q?7aZ8ff9ZBVFJ634441Oxe/ESN9Z/LQtLGkLfOXIP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2a29a9-c0ba-4163-56c6-08da6f8dcae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 05:06:41.1239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZNlLv3fj9s1yKPyl/tgzJok64cBHvDzEPCXAV7NLkpDToXeMQ4EW/o0LNyM0u5a1auE1pQn31is5zer3j1HIzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3591
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Measurements for one particular UFS controller + UFS device show a 25%
> higher read bandwidth if the maximum data buffer size is increased from
> 512 KiB to 1 MiB. Hence increase the maximum size of the data buffer
> associated with a single request from SCSI_DEFAULT_MAX_SECTORS (1024)
> * 512 bytes =3D 512 KiB to 1 MiB.
>=20
> Notes:
> - The maximum data buffer size supported by the UFSHCI specification
>   is 65535 * 256 KiB or about 16 GiB.
> - The maximum data buffer size for READ(10) commands is 65535 logical
>   blocks. To transfer more than 65535 * 4096 bytes =3D 255 MiB with a
>   single SCSI command, the READ(16) command is required. Support for
>   READ(16) is optional in the UFS 3.1 and UFS 4.0 standards.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Avri Altman <avri.altman@wdc.com>

