Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F38ECCA47E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 12:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbiGZMyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiGZMyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 08:54:08 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4721D30E
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 05:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658840046; x=1690376046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HUFL83BfWG0K2CyIPjJQP6T0bv7feJvIwwTwM8Zfba4=;
  b=mzzqBJNjXfttPDkKAlJi7edkqA37LyPP3NK8K/87BsYZJh72nljwMLSp
   27dG3657Nlsy0qHU2q+Y0psZKFj9u9nwb1IpVe97ZezV2DiHvSZ1m1X9K
   HK2mzLPkccNo+Xx+PVkgpjH3kzLAjrP0F9hVH9p5mNYDgHQjw8iHnvDSo
   K9eiwLb/RUR7qeByGP+VoHJhyb3U8PT66h3ZhPD04+6eUt+ZKoFE3euio
   9pl26QSEmKvrmNO3fxjTwDYrtQsnO052a0G3J/Hgn8TbzzXlTgBias1bH
   3amEFAY6p9vs7uirLuXcu98ji4alJYgxNqwca8zOaFmA5wh5FW44Feo1m
   A==;
X-IronPort-AV: E=Sophos;i="5.93,193,1654531200"; 
   d="scan'208";a="311254169"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2022 20:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY/LKihZvgx1ehivvBjJo3mfKUANAUzCIbNvOm4lyvbBO3YKAqpIkkMeS/k6iL7LsRsd9jm9wroeqeuxKWgwiHjU57ZDVrbhSwarlQR7JbJD5X3PQk6S3VyJ1ZKnYSH3t6tT9F7zDsXTn6AlUYRonBDWoTyc7lKXmkFFfoQisgPMetnKI/jdWWXeURG8YZNmxhEer1hyokBd9aOhb+PyV17tMoX20C+HZzQh9mRDzWKgcqOSETVmW8ll5EMDgLahWm4D4g4uINAEUGqiPZrsxGiX5i1sPcDhXmpmNw/49lWdJ9Pu34L4HjiJIoSFEbNgkWaABv7RloA+SYgExSe2Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4OPjQWR0J87nNmVm0s8jV2X1KNQ9oLBsSpmETfhAMQ=;
 b=Ac/pLS0EYFsOPqcuY7/4YmILEYiCj+cNGnnleY0UKQe6ale6P91JP7cMUCBB/8t41SU7flMTwac5L6LFOtSoGoitRTpR6rT0MYR5jJigtdREh5+38JNrh7P9+DK/umq3Js1bIPOXbkyqH9nCTYV1kWzq2a0l7VEnNOYjTTveBPV3QoMOzM0YHweFVD9enDX2/Xju7pA/Ta1xuSM98AcGL0pIQlr2kqAN8ilQQvZJFeNCH97Rn+pLf/JxEROwE0yyqLCR40xLWEBOJ0xfd4UDkJMfxduF8ULBBYxK+Yc8ISY4Xs/7/oiAfkW4jKB+Y/hQfbzNnzWa9/X5gECm2w6xzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4OPjQWR0J87nNmVm0s8jV2X1KNQ9oLBsSpmETfhAMQ=;
 b=H6arWNQILWmiNLPlADAEJB/yesCDPV6d3lun9Xffa4yvjcwOLZnIUT7nhy4q4Ouo057CRqzHT7ndcV6veD02G8WZGgEhjKumbV5RCWQiQGrASK7ifTWfax8WylMfNWIUxs3czQdVoDv8qMg3ExIPUwp6RAR0voWmYUkOkIgu5uk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SN6PR04MB4109.namprd04.prod.outlook.com (2603:10b6:805:47::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.20; Tue, 26 Jul 2022 12:54:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%8]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 12:54:02 +0000
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
Subject: RE: [PATCH v2] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH v2] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYoEz6xQdLmdWmM0q7DVw+WscoBa2QmMTA
Date:   Tue, 26 Jul 2022 12:54:02 +0000
Message-ID: <DM6PR04MB6575FF4ED352199899172E23FC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220725173528.849643-1-bvanassche@acm.org>
In-Reply-To: <20220725173528.849643-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9414cd17-043e-4bc3-8c8a-08da6f05ea88
x-ms-traffictypediagnostic: SN6PR04MB4109:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fXIsCEeq2DP9UwtvNYNxrNBNXcMxNOJIjHeur20gmGapLdeV3KCuwVXbySACu7KAVgAUfjJzPEU2BeVw/HC4MOsPiEunFWIOJo7FsLtjeSm74cbqw+Pk//GqiivqfSbOQoIlPc0OiEeAAIlQLeysGnhJrksWu+TdB3bNmnccNN3zt9VWTbyKaYahNshRiCO1tVhE+MH0+XkLah9LngQ9CgLHoyEVgdgf1rukwAspSstkD0KjgHUdgt6EQa4iWLwLyoP9pncsjmcTkXyjclLj0VHqY5zi38BWM5RZauW8X2jvaTxqFBOG4yBpZKq53IsGzRxO/3ydQoBQoDAlDcVq07onW1kxfrTe1bpdMkBgC6HRx0yb59xAzLGnI36CTGQMYc0ciyJBWH9Y1M28yWSgUHS2OYI0nsXq5jgINW0IesX0In/ci5TEEWMPI9Lh/BxoqkmMN/ZplyTFYgQMxjigBO+JIDapgQ/Qy5J+nVucEQq6J/ykaw0IljvDMqG691pzdURRf0OMVfG55WraXktITD+IFbJXns4ZOKlPYjn1rx8J2bPSoRfTz4JQV+TdJGQMGPLTq26y1EzebgLS+2qtj5s72imEdDDtBvTLU1lFASe9+7bxbciSTwqNRVJTBeBRkCpXxO+449icYf4xda9ill8Zu22/tLTA4IQa40qFdSAigNzGnd8sZ5XffFi/usawo7QTVFMeI3XHcFhMMSLH7e8m4zXRQxMR0hDN+kbcrkvgSHJ8jVPQDHO4iU+gXI8msk7yFgmMY3VpMLnhFQpcyHxl1kJJf9aD6cAzqzHFV3PaCQ7llQOA5IQz6zZyVXDm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(6506007)(7696005)(9686003)(478600001)(316002)(8936002)(52536014)(33656002)(5660300002)(186003)(55016003)(41300700001)(82960400001)(86362001)(71200400001)(83380400001)(38100700002)(2906002)(122000001)(38070700005)(4326008)(8676002)(64756008)(66446008)(76116006)(66556008)(66946007)(66476007)(54906003)(26005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EV3El4rpXti/Y2pYDV3vF0MZVKM6rKENVRSsB9RVTTsp6Rs8Pcf7X3ZYoxy1?=
 =?us-ascii?Q?6d7EFEm1zSuFGbC81BeCJygGP+nM7Jz14MIPDZG2xgXbWW3pr5qv6XVxgu87?=
 =?us-ascii?Q?Dv55fDqPJkT88ZoQqAMwNRY3dEcfXg61EvxRv3f7sNiUDKD22cs8WVT7KLHu?=
 =?us-ascii?Q?52iB++Epf010Ez3l+laNqLSZyoJJx5IQPgZzJfMn+3GIX+U7zmkoxxT8VkUd?=
 =?us-ascii?Q?nwVZbH3GsFIgvFvsLvmP2AE45b6e9N2gsXWuvqt3/W8bTU9qgYZIPAHdnBBR?=
 =?us-ascii?Q?guspFCc0fG+MbbtenEim/5VIGRnBvXV0R6yArsIRaHgE+12bKIQrwNDwPq6L?=
 =?us-ascii?Q?MV+5Gw2FY1IpY1hJTpUEmViCblK7KPxhPnjTzYHYfX2ZmGs4LbfdbVrzHFdA?=
 =?us-ascii?Q?I7Pkat/BuAzqn/qtGhYQVG30AmVNcXmMNTyblp7XkIzRgVRC9itJWSljSFhY?=
 =?us-ascii?Q?VtoNy6VYYkIEIjVSvwv84PEc/pTX6G6U0Z9MHm+ykB8znGhLUdlQMTtiuiw6?=
 =?us-ascii?Q?uusyKb722QgS1ZlxRv5CC6aE0CFIkx0T9ehziGP2hrihtIsXVRz9b5SLbdwp?=
 =?us-ascii?Q?+wYz/nJRMBr9/VKcVwTMphiDvPOYGavX557CffWWqYApZ8xXjNx0jiJMXiWy?=
 =?us-ascii?Q?BU46vIP9ZVfpAYAxR87wuxMAOjPGM490PEGjZhwtCVwBtzLkBVVi8ZrM5r90?=
 =?us-ascii?Q?x/MLDFNMrM9hlQDNVQ/XYMkYrPPJWk6+FbjbA4sPBUu/mnHQlzyvudYYHP7G?=
 =?us-ascii?Q?EgyiyYlVSuXf9k8uLH8uy/vUpOigIgvwPM5pr9b8XbaRKGxUP1wtF91WEQbG?=
 =?us-ascii?Q?adlxkfRBlej2qnFGfI96+O6famZRUkvfLEoRBio+b8kMmxRtYPfnSI6WlzMN?=
 =?us-ascii?Q?B0IU04364Q16gG12TZrp74OM0GHHSHVWEGbaJDKZmqoD5mu57CzqEa6INofV?=
 =?us-ascii?Q?9K1GrZ4AyfGBrcNwQ1IdQnr7xYUvMeSuqcRSSQgnQ6Tqymx/CFe3EsY1MlXW?=
 =?us-ascii?Q?qIrDE5MxTcGASfrPP9/p7qtpRzh3xvMJvkHtUaV3h879mDQA6wY8utzwbSk4?=
 =?us-ascii?Q?TiYpSBsdxRQncZ121tj5FCfEiPiEubH/7PFrHXbgk8IxdyEIVzkDeXu/zbKL?=
 =?us-ascii?Q?Zcx2wA0NaV0NFYaAKboS4+HddMc8dYbYFS8uP+UcZoLybKMofWzf1DdDole8?=
 =?us-ascii?Q?NL7wYHa0sE6ECAj3S0+TaUOu82IIf4chzKGr1TYNF+s58DJPyO46p/4E0M/1?=
 =?us-ascii?Q?AmN3w7kEQyLevf9KFTUxk2ASxsXmLE7Dt5qtBba/SryoV8bFxxyr6DtSCg3V?=
 =?us-ascii?Q?55KIbZ36/FGJNgl3mX5Pl4oFA+7tTdz24Dd8NpqFrraF5HFzaC4YdaRZI0bq?=
 =?us-ascii?Q?dADPz48SUrS0XrhD/SJFIvtbrDzUKwjKpgnvEMPRvFqYx8xJzxK5H1CD6JzQ?=
 =?us-ascii?Q?cPeV9ArD1DXt5Znp/YxLPucHMwEkgtlmZ7vpAKo83iVClxT6xl+LeM5DfE3o?=
 =?us-ascii?Q?Y9/9Eh2DW/hLBNS93pk9Tlx4ejbl+jtZq9erHrEsmASIQGUtTEPMX30V2TUU?=
 =?us-ascii?Q?vAaTU6rAw3n+Prytvx6wJbN111aEHBlZl3yA7zvl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9414cd17-043e-4bc3-8c8a-08da6f05ea88
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 12:54:02.6527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C17DLyWbjntfG0lTsJRxyePNc3W24Vj47677Z4bPYXgxjTWMrvb7NNjI2QouYEO5AWc2rP+aKVO4wQnCEcevtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart hi,

> Measurements have shown that for some UFS devices the maximum sequential
> I/O throughput is achieved with a transfer size above 512 KiB. Hence
> increase the maximum size of the data buffer associated with a single
> request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes =3D 512 KiB into
> 255 MiB.
>=20
> Notes:
> - The maximum data buffer size supported by the UFSHCI specification
>   is 65535 * 256 KiB or about 16 GiB.
> - The maximum data buffer size for READ(10) commands is 65535 logical
>   blocks. To transfer more than 65535 * 4096 bytes =3D 255 MiB with a
>   single SCSI command, the READ(16) command is required. Support for
>   READ(16) is optional in the UFS 3.1 and UFS 4.0 standards.
I still have concerns of a negative impact of a too-large-max-sectors.

I replicate your fio measurements using galaxy S22 - one of the most advanc=
ed production platform currently in the market.
See the results below: fio bs vs max-sectors.  data is the read BW[MiB/s].
Given that:
a) there isn't that much of a difference among the various max-sectors
b) max-sectors is configurable via max_sectors_kb sysfs entry, and
c) going from the benchmark world into the real world, a large write (255Mi=
B),
    interleaved by many small reads (4k), may cause high latency, up to eve=
n a timeout (!?)

I would leave the max-sectors threshold as it is, or use the moderate 1MB l=
imit.
Unless you can back the  "Measurements have shown" statement with a more co=
ncrete data.

Thanks,
Avri


	|	1MB		|	2MB		|	128MB		|	255MB
---------------------------------------------------------------------------=
-----------------------------------------
4KiB	|	14.7		|	13.3		|	15.7		|	19.5
8KiB	|	26.7		|	27.4		|	25.8		|	30.0
16KiB	|	44		|	53.2		|	46.3		|	61.2
64KiB	|	179		|	207		|	171		|	184
32KiB	|	100		|	120		|	105		|	119
128KiB	|	275		|	322		|	271		|	256
256KiB	|	440		|	452		|	417		|	378
512KiB	|	535		|	525		|	483		|	471
1MiB	|	592		|	584		|	531		|	408
2MiB	|	349		|	361		|	375		|	297
4MiB	|	502		|	492		|	515		|	441
8MiB	|	645		|	663		|	682		|	650
16MiB	|	752		|	749		|	752		|	762
32MiB	|	817		|	790		|	822		|	791
64MiB	|	1710		|	1703		|	1700		|	1692
128MiB	|	1733		|	1730		|	1724		|	1712
256MiB	|	1752		|	1748		|	1738		|	1732
