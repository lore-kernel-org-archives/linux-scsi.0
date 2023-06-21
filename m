Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB24EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 07:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjFUHDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 03:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjFUHCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 03:02:55 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8E11704;
        Wed, 21 Jun 2023 00:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1687330974; x=1718866974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h/aRZeJDTqIXw1qQU8uifeJWIsePQwufAY7I3jlbL0o=;
  b=Zt+X35d2pXG5HNvKqk8bdnnWD9w0dzWF+ibFgDd8BQ57NeDwAdIr/of8
   iUao70tBrPrvKt5IjEA5SnVWAJj8j5Lvs+vLvGTXhW1OYQsrikHM6ruXK
   Lwh5jXDiqSqMswb+c4QCcwDht354fDMowPZ2SA8MBMpaZgM744GbKcYEF
   gcJw0gPwD/Ej101CLlzctC2wTGTj+SFfi7/QR+AODUnpkcwdwpn1uuObo
   6ccfohnZbF0xgH/VokjX2u+NcKAN1Jrh7wXSdXdWNWHAjpcLHKPQGKD/9
   td0IaQO0fTinEucCuF7LTSYJ8C6YInRYH4FeuvlOf/nT/nX3RSEaWLYis
   g==;
X-IronPort-AV: E=Sophos;i="6.00,259,1681142400"; 
   d="scan'208";a="240852793"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2023 15:02:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeJilXKJ/J7TbO/OoNIfA/33LHCPKkiP2M4okF+TlOawz/j8SbaI3xLJ8BI2ggu8IOZLnraJFwLeLslL2wzwviisuJRXRcJvFp0Qmqn8wOxWJ52Mx24tevkr0uhILB3eWazMaWpm7gMvMqKnB+wQU7lUWOG/CV5pNHqgJT/QaLb+Y8bLVhg1R/Lg8W4q274x/OM2BqoOSXSQEdU+nkzlQPqhYi2WI5Kn3+SMp0V6xueYOezaUeCVRxVGcgOenyL1ivfvOnWOjIoo+LZy60uG3JJ0Ziu/GRjILDd7BE0aZ7bTpJLI8SF/+YV/P3BA8vGkIwL5V9x6dseeSdgsAy59DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zcs1sgjW+IrQXb8jUQf83cRECs30CIb00FWSHLJctoU=;
 b=BCk9JItr0pLyVaSbCKI7I2TTyiX5aMHlMBADSpZxH1HjJOlBMppcshOHNKEjdUiBNXt/nyLCRJku/ka++SV822R4zQgOs6erwauz1Yyrsl2gm6Xue9ofty0F2RVnNlEbd/VnW9OHeeQMGUGfejQOCCyKxWP950LNaCHxa4sI3WHrLJhm/naJnj7RAPsTj+pxMCHmrP/ek0ctstPVIXRp21mjFx+TkimWpJ1YaAYCi92b8azXB04gPX+UkpkxTpveCTkSnQ3VypHlYBzwY+y7U3TxB7W820ID+glSNHj2epmpt4oFr7kzDGHrcPXPp+0O3trwTvKlFYqB8sIk8aJmoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zcs1sgjW+IrQXb8jUQf83cRECs30CIb00FWSHLJctoU=;
 b=EV8bLEE0kQA+G7nXd5XnR7c9bYDs/rMPJNYtpXD9rerKY8dmGg2FqAR/v83GwORh95a3dotQbW0/B5RCKM6esrtM0UehyoC8sYr6SK4dXzpBCX772kzWn/LR8jAkGsair40hJG5yhzp60HDoBfKu1cxFTkMsfKTGJUZhNBALgVc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6558.namprd04.prod.outlook.com (2603:10b6:5:1b9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Wed, 21 Jun 2023 07:02:52 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98%7]) with mapi id 15.20.6500.036; Wed, 21 Jun 2023
 07:02:51 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Yu Kuai <yukuai3@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: block test failure with scsi_debug
Thread-Topic: block test failure with scsi_debug
Thread-Index: AQHZoz4ASIdURrbyrkmrUr8AZ5d/zq+UjrAAgABHnYA=
Date:   Wed, 21 Jun 2023 07:02:51 +0000
Message-ID: <fqix34ny4enu26rqgbohuknosejgn5uikloeam7rbzjyf5zvux@f2uuriyeddhb>
References: <1760da91-876d-fc9c-ab51-999a6f66ad50@nvidia.com>
 <zgp4nnbryukbgnv4cdtdnn3hwqvgggeknljmobk4moobiffseu@hiytoqbf7pol>
In-Reply-To: <zgp4nnbryukbgnv4cdtdnn3hwqvgggeknljmobk4moobiffseu@hiytoqbf7pol>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6558:EE_
x-ms-office365-filtering-correlation-id: 99fea171-d2fd-463b-07a1-08db722587ad
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YPmIpNf5heSyl4D0YUy378In4T29gSW9yJiMs25qSn3tCjjOWApx63mZWdiKYcODU6QBhAUAfOYaQ3lP6uF9KZJjDj11vVWFioNZ2ivhHf/uFctX2t2gWSdsVywYku+edO2guHXBBIhB9GB5msLNeSndIgLy1McOny2pEusIhoG8DzoWzpaRp4048il9OOg7yn9FkT9ptW36IAPSZLatqnpKjyBD86o4KJnHZnOYd9iMF8GjidKYO5e2fHJ+vbgtmkGrNioKCEwmEUnEUKbgAqxcnIE0Wj4dQR8+vigdA71rBySUae/dmigjRSPMKLSqD/MoyOVfJPFXa0hStCIbc/Jg6no88Nd3blgoa1g1u9uwH2sdrb4RjDEQYuJXQJku56QO9AGdmV3i0T4h4PYfgcfBX94Gz6AgaNfEySNDNlifDtt8sA9nAOXYLhtcE2DiM+GrmPcgz9Z45SoeGRal8feKTCcDhnKJAf74XmGKYg9G7Dw4f7RU2dT+tKv3W+JVxwA/ZMyrvOUV1LYVmca2HYG6P34GsF9ZD5H6/1+fiGTZXlD6wF5WaMPyFfaUyhLVs2fiXgndwtgZRBnzcR9sZcYXTSrjn7unImY5fgruj1M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(44832011)(86362001)(8936002)(33716001)(41300700001)(38070700005)(8676002)(66946007)(5660300002)(66446008)(64756008)(66476007)(66556008)(6916009)(316002)(82960400001)(83380400001)(122000001)(38100700002)(186003)(54906003)(6512007)(9686003)(26005)(6486002)(6506007)(71200400001)(478600001)(4326008)(91956017)(76116006)(2906002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ySx18FXEc0xBScZ7sx6PUIiI6yWeSOaFX0TDiAYxEqWDUUkgJiUlWnvTsmki?=
 =?us-ascii?Q?LT+9P0VDrCN734QxoFsrp+PV6ZqHkF3s/NeTZUEQypAoJjBmIAl0EGB+DCVk?=
 =?us-ascii?Q?DhndgQyXZ99JHGkvw4eRMpI3IYdMaiaJ1bDBOXbDKMkqNvoGwz2dvfOxnROL?=
 =?us-ascii?Q?Fx4slbcvBHkbD9ahRvjFAHdGB67S92Vo4bRTwNSGefTApPdQbPBuumaObuOQ?=
 =?us-ascii?Q?bHKutJWyjiTEl3XxUDmi9vSgy/4sz64U5MGz0JkjkWWAlZMpyroC0MdzcGQ6?=
 =?us-ascii?Q?XhoAntCA4MCqUZEzZi1gDgwX5fEkBJwqoCA7tNIP8YG+7xmyeagzSH16kDEB?=
 =?us-ascii?Q?q4u+1d8AJONT5eZH7f9csD3jTNpch8G0vnXR5K+x7mMhUCgT8Hk/Y7WGOba6?=
 =?us-ascii?Q?kGsTOPHVT1GVFdogcGMxCa4xR485vVFtUJIT10vjzj6ienus3HTmvBmPHVkk?=
 =?us-ascii?Q?548SUZEUJczj/svAXRMuCJ5ma/jJoEQSIw8ljI9Gex/aQFzEdzPQHRL89sut?=
 =?us-ascii?Q?0xAx9j2X22q8GOIRPppZhaA5p+p9ln27vvh1acTxksvT++L0hQxDn5xiO12U?=
 =?us-ascii?Q?DWHyOOrGg/NUgVIjmFuDkpAbIjFWYHPetLiO8FFSfM8U/dCcHVbdsD8H7gZ/?=
 =?us-ascii?Q?yhMMxu/orrl6W1BYjV0dMCktPZyLCJ/UzMbZ9WlXBolpPWhOoW2WuahtJadz?=
 =?us-ascii?Q?gUVGTX83Kr4WiUYQVEbparN4l1jvLaAGV4a9WVcGMiO/+RiG+VXf3R4huwy+?=
 =?us-ascii?Q?nWRUBBQUx+iUXGWKIj5i+PfYt3LpkkTy2kpMJerX1uZ0nmNM2B8VHceOpDaS?=
 =?us-ascii?Q?aOxoNMZQeyi2czp5BhSdiy34xVZDFsK5k919Hak7h/Jh+JypRyamzJLwpaVP?=
 =?us-ascii?Q?yR4LPQPIPck8x7glTiEtHFR7yo2xhNtmLWgsmH4kVIawY7pqmGHqSncan+z/?=
 =?us-ascii?Q?5jJ8J6nELwuLvG4oU+cgsWqSqwGgriVhpc3WuDTBfXb0MnpTv19YlkCWkh87?=
 =?us-ascii?Q?IHJg11lGHRe8nNSOOozZReKd9hCKzYr6R35LOleez/tSeDC3NwU/ooAXuUKa?=
 =?us-ascii?Q?O1iglaQpCfNgjFBEdW/77xSc5egEXXmtn4N34OFgHTCgIeNjTPQnY6s+aIo8?=
 =?us-ascii?Q?ddhwvKs1BAPhcsF+LGIbwMeMhBDhCbkCEsjsqMNdOkK+KWEIGQ4xRqgyD6vw?=
 =?us-ascii?Q?0EX99qMOUXFcNJjE2DKFe4joX3g0siC01EkZrELrt3d3Hi4RSyoM1bkctxqA?=
 =?us-ascii?Q?2XaUQ11K1C7ZlUvcT1X/nGF1wgbOJab1wC4D+eKByBsgZl6J++Va3ast+ONG?=
 =?us-ascii?Q?hqrck1TcxWBcQGDUFoi4FW8M9kTfxvUDbQmnZbAFYCKNg+y2Z7cAx+TlBV81?=
 =?us-ascii?Q?9GlUzCIc1uPVa4t0uD0LO2MI+PW/ds26AQqalkwDWrLTI54sWvxLYamVUEIU?=
 =?us-ascii?Q?qImX+RQyh/CzQYAtoz8CI9hREtDcz3yTSnWcvzadkWFASi0WtPY98hfqyw31?=
 =?us-ascii?Q?TwbP+aibpnLDZBKR7R2E7q2ta+zVuWjls3XeN9FcGE36ECxWaA4CB3jBXixT?=
 =?us-ascii?Q?IuPgSnkql0ODB7zyGwYFrQvhjkuK2hg2jA1pEkXugBmiJvxNw1oyM9BAbCd+?=
 =?us-ascii?Q?bQO2aW+DgnKo3RYencfZHqQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA2B9447806AE04EA5E62B28D55017E6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qqRJSuPXFg29gVxdMp7uNxmObFqpFc40MPnZbNKF627x2+Yw2gjjP/P15HWnqmve+r/P5sMVtkd8wp7W7EYxc2jvqza8ktqeNwqSsVaR/nZJBgRHRtRV82LXcG/zsvBIFiu0gA6gC076YbOYltlYzRhddXvKYbOtTQejrVen1w1KxLQyx5p/v/46LTyH7d9ULlNwxoF8ttj2l7JOcpRU9B6G2JnBkEYwhh67WXWCKFSJTBzFOPn2RWNfqvXReJ78yHElFcKSvtSMpUANyGA14BmJb01q/nhqr6tDmKVCLGrtVlCtfReJ4+fKweVz7rarJ5EGzvpPhPx0NBxl5C8GhUOusMNYOuZ3/j4D6pKtNytp1AY9AJplZTFvUNSqZSAHLmDOJvuU7w9/OMNTrZLNJt59kmRJ+U5jGewWdxjNQIwfxYurbCcOq3aWnL/Sn21bHfaVi6idybitPDxY617xRsUWtiMsNMfEzALrR6MCntRKmWGo/9kDtjFeGvOFebiEOG1ZqJyz0zUQUNJXLzxd/0BZVuHmy7HaZiAy9UkmldxU25Fr3FQ9Za78tDPKVWDAg9t/a83shXX4NuLQIR+/OOB19cgMunM3dVdE9F9Cd5XkutLgQovgq9y68IHSeruN9ypxXcF/mHUuXWqqVZ1NtoUlkxldymRe11Z+3uhVxj1mwHugmp8VZAyJSL4fBbfUmOLqTVdQ58WcxdaEZg2kyIxsPf+r3v52mns7ppPMQ0i6Rox1BKpgrpyUoyYMLI4RX0xpv4QfA6U2UhdVYPA1XE1mPgceTNObHEP8IGJxYMlabz4cFCKaAl7tDurV64ijtjcQDO2AXJw2uJ2MW6LlSg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fea171-d2fd-463b-07a1-08db722587ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 07:02:51.8374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BwyOW1xXnqTIY0t2Kypaoglb6Tpkg2+5A50kIIfE9N5HAEQx4HHoQ0oZeIDwXTBJsXESDVatdjt7GZbHDCYs4pSiEgvxwswbRUjAiSZuMTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6558
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CC+: Yu Kuai, linux-scsi,

On Jun 21, 2023 / 02:46, Shinichiro Kawasaki wrote:
> On Jun 20, 2023 / 06:11, Chaitanya Kulkarni wrote:
> > Hi,
> >=20
> > I found few failures, are you also getting the same ?
> >=20
> > linux-block/for-next observed block test failure :-
>=20
> Yes, I've jtried the kernel on linux-block/for-next at git hash 334bdb61b=
bea,
> and see the same failure symptoms. It looks that the first test case bloc=
k/001
> left scsi_debug in weird status, and following test cases were affected.
>=20
> I tried simple commands below and found that scsi_debug module unload fai=
ls.
>=20
>     # modprobe scsi_debug
>     # modprobe -r scsi_debug
>     modprobe: FATAL: Module scsi_debug is in use.
>=20
> I'll try to bisect and identify which commit triggers the unload failure.

The commit db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage") =
[1]
triggers the scsi_debug unload failure on my test system.

Yu, could you check the failure symptom?

[1] https://lore.kernel.org/linux-block/20230610022003.2557284-3-yukuai1@hu=
aweicloud.com/=
