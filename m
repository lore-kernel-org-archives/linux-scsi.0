Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4531EC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13F464DBD
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhA1JjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:39:21 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8188 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhA1Jh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 04:37:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611826675; x=1643362675;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=7D0Vydf7x2ajNy6gouNJU0FRV0KV//UjJI4mF/RsmOQ=;
  b=bo09JYAk/UJxiDA/YpZE3n7KM3vsyWBECzGjVYmLTc4XGj2pJGeDLp5M
   QXz8UD4pfM29igJ7CwaATDtZVhvAkbOCPKabuUVRy8keF0nsdUfw7KyJu
   TuUNHE/OqIlZ/saoZZu2Fxp9qytSMwlh19dGa4i7lwNDpw219MN9XW9bs
   5AD59S5OtLHDmDCgYa9TInxQXl0/rh079UFt9pBwOPezDHcg6jq6rvhKV
   1XbyNT7Ujy+yC5kAlyF8qXaPK5pXwUHo52RT/ASZnOgNx80hvFeFA4SCi
   Pa26rv2sHnOcRzYjvt0IT3MIeckicFD1KzMeKIN/ooY5XrifhfhkaM2Vw
   Q==;
IronPort-SDR: 70el3SmYvGq3EuP4L4nmfbMcUqm1TcC3wu5KaTj0C4WhDU9Av233SUTHvdxWcphjqVHp/fZBgu
 U3nOuzC0PN9TfLgTOkAH38q2Ykojrfxusf1k+g6h9vitrNZ5uzpSLEg353wJPVfYlzCPxxfHR0
 SCkxp+ptRKeZCZLan1o/4FxDV2+nx984msnmHTCxpLAeLx6YqD0FBqcPuyCA2zKFyjAb3h1MOR
 +zNwSxuSzpZgSKdm7HWd123TF1+TkSflrTktubmyeb4zq/BIRZDSh2fW+E+1wxRjPEL/KOAr2I
 sXU=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="159706118"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 17:36:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i86qIk23QKY9ZH6HMKDiDAhfMoZ2I1SYAup7CMrhtYWDkUsyjTR6E4pusB+kf/Wpzy1r4pXq/QYpSXtVOV2rYUt3NyuAUsiJL7/QRZIf1Atxxv+kjo9NhJ0oP8hL1mjjCEO+MiU78u4BbJ1BYKglCiANgn2Gfn9Y1JpO2LH7EBhX+C130G0yvchIQ8TRyHlGKYX5lCLVCJ7FgHsKE6Y9I2yGUhQHWifcJdxftWiTOXHBJBYEJadYVwA5qidDArE1O41hLWSA/cwPmYN2Z7lIPl65p6epPxsR1n0ztTGpnYo4mKTQNC7J/2Gar6MFm6tD0NTRS8G+FBSKY3Nq95n3sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzPLJZm3i3mhbidgIFuhmzcne5X5jc4h5tFCui3vaME=;
 b=aDtHjELRga7dQDIWJE9+4bEO3R/crZjKOnlZ747Zx80hrv2U8cSRb6s/m9Te4z+S0IlK6Jif4178jwpykt+P/lCKwkpGNLY0TDRzwReWw8+lzRp6+n5+JoB60VB8xhXrI4UkdcNT7sRWmEiyZV/wzH8rCKSev2i3WHjTpo7jlCNKF6TM+/+mYcc+hpEkvt7i/WyW8OsCGXG0fwvks3cLnl21Q6xa/AQVznmcI15pgmU70EHrewxknr48kmvVGZdZtoCVWyKXLRUxgx8vK0mEETAYNC87FBbt57ZlKV14y24oi+/mJaQf/vUVTWlCjo9FkrAeS8fKcHsttDJfLlBbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzPLJZm3i3mhbidgIFuhmzcne5X5jc4h5tFCui3vaME=;
 b=xdPSmzDv7YRG5hMZYIYAm2UNLbdwVVhDyf6Y4lZ/o63h7kNt3JdwV/oxE0h2wWtpvoc2QKQROEpb72FwhAGNhDpRRjRo4KYEztRw+iV2v0oTs2YiRC0XHXl5fJICK1X1tV87w7PuFZzXMRCVxa/a+ji6FjWVPt7QZVfqqh4C6HY=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB7038.namprd04.prod.outlook.com (2603:10b6:208:1e6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 09:36:47 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 09:36:47 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Topic: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
Thread-Index: AQHW9TFKJGYilwYisE6/4O0JGnL8cQ==
Date:   Thu, 28 Jan 2021 09:36:47 +0000
Message-ID: <BL0PR04MB6514062937FF5BE302A27C8FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-9-damien.lemoal@wdc.com>
 <20210128092406.GA2607@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec1c0f5d-df73-4995-1b3d-08d8c3703bc3
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7038C1876C532EA58EC68C1AE7BA9@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AOTiba4i+GOtzNhv9sD/VYTUtEBigA6xqcXdVgYOYe4jygqAlwiFIgaa6unr/ao9sAVVsrSfsV9fcXBJvWOpK6QJ35hvI5UzeAI1kz593ajDTpDh4LpsK0IbxGeOJhyu+meNMpZCThG6BsdkxqKNO1Ba9MW4kpWTfGtERckiz102I5SjCg8TuqWqrBpSNsduoQXHzJqLBdPu1FBFhMaervcAbn5LXXtqn0UVgolgBN9zbzQRxUgubze4S3mNzcyJgbCJf+u8UvavgrnuFvh6yArQ3OuuBCPhtouwQXLFN9f0QOTgZjJM485sR2GptNSpb2z0QulXyhaVYcyRcjnsYp+0TMNNuLsxdvLbUNuyus4TUxYfbeDYMgiSj9YLhg9Le8dNP+rFNW/eZKOP8MXglFvqo7I1TwB8FlZ3KOMI+bzXRoslpLsgNIXVbtj7zKIFvWk50O4ZgZA7bBoz8gg1reaUOnkBFIhPK2KeA129EsSXxB5cLpXO4eEOv3wkIFrcUxialaqx93vWH6ZyiLh01A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(478600001)(86362001)(64756008)(71200400001)(91956017)(2906002)(55016002)(6916009)(6506007)(53546011)(8676002)(7696005)(9686003)(54906003)(66946007)(4326008)(8936002)(316002)(186003)(52536014)(83380400001)(66446008)(5660300002)(66556008)(66476007)(33656002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?s5H/cRI4TqUbx7QTfbY9UmRK04mEtKdS5Ka+zmEMx8BUKajc5ulTEM5bJ2Nk?=
 =?us-ascii?Q?sJTnO49mdPmn+WR7icT5vkNyrBzr7qcYMIDZQgDUwyKXcBrH70VOGN32/UfR?=
 =?us-ascii?Q?ALCPQ9VizGix8K/aH833Sdy8RLlCP+1W7WPEqnDXSHyvNbjVw5gMtS1rgvec?=
 =?us-ascii?Q?u8ASXM65J+J80vu9GJXmCW1bB7W/RRSExmKa6WFr3Qi6wTcgrU+LiT8Pku6M?=
 =?us-ascii?Q?Kra3DmUwOwuP9SvhYXRkPpgiPSbqnvy39nbh2FMbhrgkCRP3m4zfJET9A3bb?=
 =?us-ascii?Q?QfZjXhXFW81Dx806kMezUfq/BAqiVWS7zyEft7qZ76wFKL+sYknzimL8jRnH?=
 =?us-ascii?Q?21S1F05JBZz3gP/jE/4kTAhIZH+64KFVqZl4GEJ45JXdkOGxCrjAMMHYP2OZ?=
 =?us-ascii?Q?W9spzbGoSI6YdczBcsuh9BoxXAtxv8ZyJ8Yg52ZbweIaOwHJQcpu7aMhPkxY?=
 =?us-ascii?Q?pHDLkA/Y8kYx8nkLXBwpI0W8nrAVvoGteNgR5Zww9mlyeNBA6gt3NQYsJ4rk?=
 =?us-ascii?Q?1vdd4aycFFG+cChrugnFrLQXQKfwvo4HuKUF5LUBsefbuULq03FIHaeLrUo3?=
 =?us-ascii?Q?16Am5jzNba0FrjFvy8fjrr5mTNFykMGRzglT+/YaLM/Hc7eBYhbrtGjXby6+?=
 =?us-ascii?Q?35NbbhNm/r5y/4U6vqH4cQJTUza4iyK7eQEe1SZ+ELVc8TDY4QYJ0RAvE8Tl?=
 =?us-ascii?Q?8RqOhfX2n9q4bXMgBLNy1G1//XUpAeUC8YWEJuKsyqYfn2O6UUiBReCH91AH?=
 =?us-ascii?Q?wqtjg2Y2QixDtguPvKdCxiw9CpieUSA3FKRCqKAXDGrsDfnBPP03RHwKT9Qx?=
 =?us-ascii?Q?xca78N3DKpB7or3XqBWQ/Ly42rbUE4qa8JKBdTnhnSzvZDqWThpTFL17g4m7?=
 =?us-ascii?Q?CeVgIofHPdxBqcrLLK5GJfISMyFim8ijzByRDjXmfjlpEFto6oZ1D2G2cdhd?=
 =?us-ascii?Q?Hsd8oz+Wp30E2ghIpc816sDimCxMoEJESCnaPtNAaTO/apMBxKqUgJgkWul2?=
 =?us-ascii?Q?2dduJCqEVC0kgNbNn3aB44+0DN3OW3L7n/Sj1L1RGDRIkR+Fxkv7zoRMcDej?=
 =?us-ascii?Q?tKEnvPSlcaeftal6oKsX7MO7V947rMLnDqlMlhyd5QMQ71tfT0j4of/zO5Zc?=
 =?us-ascii?Q?yIEc/OjN4MGP8++N7A0+D10bp3o+VgylvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1c0f5d-df73-4995-1b3d-08d8c3703bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 09:36:47.7986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OsYnBH5obtG7gTTGmeM6JJmQaLVCBDAvYgXtzoXImBWzhA9ZKNkDtWPwUnaQOVnAyjsGmosKWI3gqq86rvH9nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/28 18:24, Christoph Hellwig wrote:=0A=
> On Thu, Jan 28, 2021 at 01:47:33PM +0900, Damien Le Moal wrote:=0A=
>> For host-aware ZBC disk, setting the device zoned model to BLK_ZONED_HA=
=0A=
>> using blk_queue_set_zoned() in sd_read_block_characteristics() may=0A=
>> result in the block device effective zoned model to be "none"=0A=
>> (BLK_ZONED_NONE) if partitions are present on the device. In this case,=
=0A=
>> sd_zbc_read_zones() should not setup the zone related queue limits for=
=0A=
>> the disk so that the device limits and configuration is consistent with=
=0A=
>> a regular disk and resources not uselessly allocated (e.g. the zone=0A=
>> write pointer tracking array for zone append emulation).=0A=
>>=0A=
>> Furthermore, if the disk zoned model changes at run time due to the=0A=
>> creation of a partition by the user, the zone related resources can be=
=0A=
>> released.=0A=
>>=0A=
>> Fix both problems by introducing the function sd_zbc_clear_zone_info()=
=0A=
>> to reset the scsi disk zone information and free resources and by=0A=
>> returning early in sd_zbc_read_zones() for a block device that has a=0A=
>> zoned model equal to BLK_ZONED_NONE.=0A=
> =0A=
> So creating the partition doesn't even call into the driver, which=0A=
> means we'll leak the info for now.  But I guess the next revalidate=0A=
> will simply clean it up, so it is not a major issue.=0A=
=0A=
Exactly. But the leak is only for the sd level resources now.=0A=
blk_queue_set_zoned() cleans up everything else.=0A=
The super annoying thing is that deleting all partitions leaves that disk i=
n=0A=
regular mode instead of returning it to zoned mode. Need to wait for a=0A=
revalidate or for a manual rescan for that to happen. I wonder if we should=
 not=0A=
trigger a revalidate, always, to avoid that the user sees the device type=
=0A=
suddenly changing long after the partitions were deleted...=0A=
Adding such revalidate for partition creation would solve the "leak" proble=
m (or=0A=
rather the lack of cleaning) too.=0A=
=0A=
> =0A=
> Looks good:=0A=
> =0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
