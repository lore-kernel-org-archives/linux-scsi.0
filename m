Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271FAC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 08:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjJZI4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbjJZI4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 04:56:46 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD40A18F;
        Thu, 26 Oct 2023 01:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698310603; x=1729846603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JeN3189PDCWhiWoDjZd4sg8MvgXHcbyXsKIsKaY6Cq0=;
  b=qQ2nW65uG4clSOILWnEiFsafsRadUjvttnD/G8AQVU+PwIgrDLsLeyM3
   om0I+It5kfELPXdVjccSGZ8mz1DqRxZwLKOTaZdqqPufB7Dy9T84wx47Y
   w8PWIRF649X2dCU+Znt88JBE9t4g3XycbVsnbKQ8oy95+nwvGhV4zx7Ge
   9H1lzfu2bKR79UuftlNRer9AhQKzajo83J793/3sVxfJRH5bbsM3F6Jjz
   hRrI79a9wv5NMkevf9BQuJDJMFTg1rd6RsGt4gZJEA797FaSX/J59KhJ6
   p3gxZhpZhuPd/bGzmis+u+xhqOawDzjtPwtQ8OVhdSkyz7Sgh1t8f5eWo
   Q==;
X-CSE-ConnectionGUID: X+HBB7HFQBmhxgUDZr+UYg==
X-CSE-MsgGUID: TFgABNmtQdCfXuvdgj66vw==
X-IronPort-AV: E=Sophos;i="6.03,253,1694707200"; 
   d="scan'208";a="721689"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2023 16:56:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZWRXOrKam9nyskLBhO6Cra+OX0EioPEopesE8jHsRZpYQ1ASeI0pdojEsx6qcLbCCnLC2Y57U7AkPkom9tos75rgyVmTMKtOKwpPpBUEWEFtUrlQQ6hn4kqzMKvo42teYtr2SH+ziBooEJ7THFhI7bXuw+0KmmV9Ti2WfGmMIWoCukVPfLw0WFzUCyFvavhx7ZKw5P4v0ZQTRJx6W9/0LiE6rDYU0kj4jr3WkwKI+q3d3Jtic2ZAUaMA+N4e0NeQg0cI1gAfOTniBu56SC7YXa4cNH+zZ0leSWCKbFWYrH/5DKifzi2DNmJmwE2VUSP9kHo6RTvyBFCPvdgqun6sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fxtF4akj1ufU9lLtn59dIJF+wL29CxE16cBqXL4980=;
 b=Nh8vrj9Mql+Tvjit65m0PwatwB8IMK+EStQyhQyvezy3sjzelFDQ+vVMM+uar0ukgbrLLqVSz3KsQYwnvuL8qtou4WNnXclUTy3Cmjd4PNNDkZHSTqvGH3I9628opLk2Z57pzA56JMjDCWNho95oPo1OPAyxo0cKM78H7tzSyz7st92GuMrF6i9VvwxjUUgT6UYXmMdgTQATpbjjb9psM2s9xB/SnpMtSV4bnvhXygiK5aqEWche1kYV/q++90rgO5n4RmvO5GUkINC3WyPL3Rxeq6FrprFGoWNlSKz9fTDXN8HrGffCZf7M2t+TrKC0CvY/o92XpW9eoxWxZDlycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fxtF4akj1ufU9lLtn59dIJF+wL29CxE16cBqXL4980=;
 b=oXa4a/Cd6TdUmPFw7+H0d1pZwVo0poh012rw2A++fab5wKIru4/IDKqAfGe8gGOQ3GjrewvlQiVsmZm353o6POg8AG0+RdDCmuZThGQpEy0oYuN+SENfN4Pmwi0zG6T1W43uYqStEK6kaUGotslxqWagl59g15CjU9fwzo/YPBs=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN0PR04MB7920.namprd04.prod.outlook.com (2603:10b6:408:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 26 Oct
 2023 08:56:40 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::47df:9a7c:5674:2ca6]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::47df:9a7c:5674:2ca6%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 08:56:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: sd: Introduce manage_shutdown device flag
Thread-Topic: [PATCH v2] scsi: sd: Introduce manage_shutdown device flag
Thread-Index: AQHaB+pVKYGhqDpUpE+cXMRl4aVOQA==
Date:   Thu, 26 Oct 2023 08:56:39 +0000
Message-ID: <ZTopuOzBqFkB9TTh@x1-carbon>
References: <20231026013909.24301-1-dlemoal@kernel.org>
In-Reply-To: <20231026013909.24301-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN0PR04MB7920:EE_
x-ms-office365-filtering-correlation-id: 65f5d769-c771-4584-55e8-08dbd601780e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yXjbF+gcdcVXJF3NwwMGUEMzP2BFja+OnD8uH82mNTTPHgGO2yTtiL1bYVLnhY21HR127aE+iL+brP9D9cxO4uu6J7hT+6xCJiwrSoHCZybUyW8AaKE53tLbDhe/7uLqFJz8tLvtZLBCQnB4wGzQF37y8LE/2K86dZ6Te3+uFevhlmV6V2Yt3OwQJinDzm67DLmR+PXFZtz9LQuPULAPrkFapDr+Yet3ea47JAEw9tzKX8M3KPOzmzr8kgTiG75IbC7DYCSt1WfM3r6HNLOnJdYNOZc/nGp9XJx7ZqCyIKbRrECXuJFtAsPdw+ToK4UkX0ZCP5CPcSqekWC12NILCAQWR+nGXKrOrNp7iVDRI2fyfnGYtTR56yFxjD7eB/v79kGbxbLI+XU2QlhiMqckEwF/lrSAoJGleyVje8GlFCdXc2eZgfcgtslyL1DDAnv6NDRs/8kKH4WrazBtnv8iQf7Og4ZTL/nDS78MAWs8P1deQnpqenCtRPl5k+2uzhGECPKBmF6RTNhpUbqAywBXv2FdNKwAyy4gZ8dBgNDmc4oZgbsaVFW5jhwZ3f6tR0Gc3ONSeCPodhhyHGcIMNDRLBDuewfVEL1finJ1qK7ayZAPDfPFTZzA6P1G2l1qAGP70ZJwgm7dpNS1vgWRDMcYrrR4pInLUcLUNBzE92bA/v0EBKlSoDBz6seFaZzSyAk7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(38100700002)(83380400001)(6506007)(71200400001)(6512007)(9686003)(33716001)(66946007)(76116006)(91956017)(122000001)(966005)(6486002)(26005)(478600001)(82960400001)(316002)(64756008)(6916009)(66446008)(66476007)(66556008)(54906003)(38070700009)(8676002)(8936002)(4326008)(41300700001)(5660300002)(2906002)(86362001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8YkWBfDfG87lqz1R4WAv9aBVu34KYw9qeeGsEb6ZJ8ELBCgJYAcqVHnEuQul?=
 =?us-ascii?Q?K2nP5o1e5RROPBJCJb79HzlFd1oeepweEzCqrI4No+x2CLOppOStxrjyJa+y?=
 =?us-ascii?Q?DpF6BarHNFShtCZZU8ZTbZflgTW94KUJKo03+oMm7HSIln5YK1YZ/GWS3MFV?=
 =?us-ascii?Q?ViFVDh4ZyKAyBCp74mdv5s95hz/htWfBXOAYwXJkgYzW1y6/0GbWIgf3c6Tk?=
 =?us-ascii?Q?yift2Q+CRfoxtRgW6lK07uz8rgHSzFGNltHU9Wpve6D/Wq864AeHYc5d9amw?=
 =?us-ascii?Q?QEIMWmTKvejWBr7CMTXABIBDNPNcZ3npQakOwDd7BivELAJmTXgwsfCTlVXr?=
 =?us-ascii?Q?Up6gNewDM/dfqgstaKc7HiFiuNVG87C71zqRv++GdivvHMg936/TDeKpk28E?=
 =?us-ascii?Q?UYBoT0Cuc3T0tP9KvlsLz8CMc+NHZBxf1cqtYEce18AxNta5peu+1vE6c7LT?=
 =?us-ascii?Q?Po637v/kvz4n9NQSxm1P8pw5RK3LbkahLf59UsyHaD2ybC96xKL7vAItpK6/?=
 =?us-ascii?Q?UVzoNaxLWYDsdRqOb4Mt1KMLiOHFjf4s8VhYFpZ/Kd2Mf2NZ9IxCqmOKLVWn?=
 =?us-ascii?Q?9gu9fqzsZ+QAIi8ioaJ+k463eMDL1N1eqsYi5iDdIDk3pPYjqb166NrXFnza?=
 =?us-ascii?Q?ov12TWuNe++3W/tWihYK9YlTt2GH5h3IYhV3fcci6Z/jQrKb8gGVhAfE1tlI?=
 =?us-ascii?Q?EFKLCl3Wd9xu/0MWcCIs0uxwg8yB0ZlSvSeU2IsueOAc4IF6j0uX1RnNa9m+?=
 =?us-ascii?Q?Q1jmAUcCZBAMnt/qhKJ+Jofanm8Jg1CP+9nuZkxUmnd1zsdVUVhgbjSZvgq4?=
 =?us-ascii?Q?WGmU1Xaz5Ww3lZilh85WFJZi+a0t3aQur123e6kQv25VFl9ojq58Ata5w2iP?=
 =?us-ascii?Q?uTLpHY4s38hpMEQdD8VowA5ve6rriOK1JKBPRNIBZ+Sy05EnRMM0/RVHiWiK?=
 =?us-ascii?Q?Hmw0EWv98RSIr0C77Sj/GVW6UUzCXqtATFZrvwSlIltyruCqodpSN45s1RbV?=
 =?us-ascii?Q?usrDJmNSzTkd4WYscz/OJe05GwKqJgZs0C00e/pHa1TGmx7siYm0Eu3KmGi+?=
 =?us-ascii?Q?HRmwlCr+v6Gt1h0cDDun4MmgZw5pYwTxpCcxIMhrWCfM0F/vzE4StKZNowuP?=
 =?us-ascii?Q?COYWzfBKVpec0y030xYx9HHvcPwHqTt4EQBkUFeHFh1erZS/7BEpIWZdGdix?=
 =?us-ascii?Q?THiQjv3IOI+L1RdNeNq4s9nNM7et9GTkfNMI+d/gNOvuGTGrnNcCdusjzBpb?=
 =?us-ascii?Q?jcwj72r34mOra424LH1H4X0QPEh4Tg1R4HPQjirdaV32Z5y+AK1RPHt/7Cm/?=
 =?us-ascii?Q?0g7u2GQ0XaHdl/FheOjNYcxjV8sEQPPMMq/63wX0Rk/WQwiPE38GYyKlkE6R?=
 =?us-ascii?Q?fLSobHu6cz1rqs2l+R/pNXVt5fQB24uLxdGzOaucfq3czJ3zKIwDCaarY4eL?=
 =?us-ascii?Q?PYSqDS8ZRKxcYLWbGM5qj3k7BiD11zWj5k5v8Bi8OCAYuapqcCJ0qJ0FtcXE?=
 =?us-ascii?Q?wuXNe8yV6qAIfyA24UZXp/RZXwuei7ZDTgGwUL3i2XzbL8z6Gx2jVUTUhP/Y?=
 =?us-ascii?Q?O4zOAtlwm/fHvIqPjVBX7dfgGgvbc+p1Blp4INJKNXarmxHxgtdlp+0DV2Mz?=
 =?us-ascii?Q?zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18D8318A2A15E0439AFA6C7337E8A13D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0uCR+2Gl0aZwpTct4LztQr47LVk1JZj+iwcTXdw9Kz3ijWyFTMeZESJHr+App+3uGne7nxWtnwNuCMimjgfGBarO5pRdhAOPKxttjGWaIKjPp5+JberoexKuUix1FoiN2N6VMeudBtQJ2Frk94iJMVaMW7dypJuFH7l6xklPF7R6CVdWQlXL/M10juxRcITgW6Au7eZrkJKqXNRvC1b+4jXABEHvCnMlfHiDCXnAKpYxK5vreS7hjHy8kCzzvewwlnf4sl2K//jjk3TwGfM2OhEkx28zEG1JqVfYsJR/zKE8kLEE3HgOfvGG0HcMhvq4EZjomzf1RXUqUkwXINgDLmWtFdq/K9WyeG49fdPP9UR861P25EFVMHYLC1RCsveKqs3qj/R/omXT55itlrACU9PgeTYWYGVD+ZrXc3Ixa55ke07RunLRwajkOxoa+QA4hhA//xIp/tSZzaZFGMMEpkk97DEwYmxW1qv6oq6EBWnqKqiSKCZOMQra9qsa5ulgMmSbAwt+bJqvbykbaRO/NZDS2s4+DMIfe1OLBnplvjuF/t3YM3GmvPsgfWR3au+S+ng2SiE7nQBpCU0Fu7afZLoS/fum1ywJ/uZCY5TZrg/9a0FFH+j56I2Gy9uPMuGmawVWEAd17XnHVvDI4DrmCpLzoDriMMVvLHVA7n94wqvz3vnYUfUNbbT26k/B8BlaLJiFhFCjYgXSmU9n7wvu5p64cieMaazA7W67C3Xxr1o+BTEoSnuB9BSg4MlkTJuGpjD/rxTSmd9Zudk/WOMtjHiXvu2m2Mvo4/E9O1Zeg29H/5FKAQmuTNydo5di+SII4TaYqzoq1wB9CsNgyFaMWFq31lO2ujCwMUJRyWTivLGbevzGRJkc0NIoGCiZeKy8a4I3sR6MrGMlAug3xGBrJQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f5d769-c771-4584-55e8-08dbd601780e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 08:56:40.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b5CCBJ88FMnP7+Ih5FLdGsur5oSzf0CJ7GcUM0JTErDtkbGFBWl2eFGc5XvO/4uQy6Xpstbe8UmcCE3Am9wdrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7920
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 26, 2023 at 10:39:09AM +0900, Damien Le Moal wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") change setting the manage_system_start_stop
> flag to false for libata managed disks to enable libata internal
> management of disk suspend/resume. However, a side effect of this change
> is that on system shutdown, disks are no longer being stopped (set to
> standby mode with the heads unloaded). While this is not a critical
> issue, this unclean shutdown is not recommended and shows up with
> increased smart counters (e.g. the unexpected power loss counter
> "Unexpect_Power_Loss_Ct").
>=20
> Instead of defining a shutdown driver method for all ATA adapter
> drivers (not all of them define that operation), this patch resolves
> this issue by further refining the sd driver start/stop control of disks
> using the new flag manage_shutdown. If this new flag is set to true by
> a low level driver, the function sd_shutdown() will issue a
> START STOP UNIT command with the start argument set to 0 when a disk
> needs to be powered off (suspended) on system power off, that is, when
> system_state is equal to SYSTEM_POWER_OFF.
>=20
> Similarly to the other manage_xxx flags, the new manage_shutdown flag is
> exposed through sysfs as a read-write device attribute.
>=20
> To avoid any confusion between manage_shutdown and
> manage_system_start_stop, the comments describing these flags in
> include/scsi/scsi.h are also improved.
>=20
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system=
_start_stop")
> Cc: stable@vger.kernel.org
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D218038
> Link: https://lore.kernel.org/all/cd397c88-bf53-4768-9ab8-9d107df9e613@gm=
ail.com/
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c  |  5 +++--
>  drivers/firewire/sbp2.c    |  1 +
>  drivers/scsi/sd.c          | 39 +++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_device.h | 20 +++++++++++++++++--
>  4 files changed, 58 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a371b497035e..3a957c4da409 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1053,10 +1053,11 @@ int ata_scsi_dev_config(struct scsi_device *sdev,=
 struct ata_device *dev)
> =20
>  		/*
>  		 * Ask the sd driver to issue START STOP UNIT on runtime suspend
> -		 * and resume only. For system level suspend/resume, devices
> -		 * power state is handled directly by libata EH.
> +		 * and resume and shutdown only. For system level suspend/resume,
> +		 * devices power state is handled directly by libata EH.
>  		 */
>  		sdev->manage_runtime_start_stop =3D true;
> +		sdev->manage_shutdown =3D true;
>  	}
> =20
>  	/*
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 749868b9e80d..7edf2c95282f 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1521,6 +1521,7 @@ static int sbp2_scsi_slave_configure(struct scsi_de=
vice *sdev)
>  	if (sbp2_param_exclusive_login) {
>  		sdev->manage_system_start_stop =3D true;
>  		sdev->manage_runtime_start_stop =3D true;
> +		sdev->manage_shutdown =3D true;
>  	}
> =20
>  	if (sdev->type =3D=3D TYPE_ROM)
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 83b6a3f3863b..6effa13039f3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -209,7 +209,8 @@ manage_start_stop_show(struct device *dev,
> =20
>  	return sysfs_emit(buf, "%u\n",
>  			  sdp->manage_system_start_stop &&
> -			  sdp->manage_runtime_start_stop);
> +			  sdp->manage_runtime_start_stop &&
> +			  sdp->manage_shutdown);
>  }
>  static DEVICE_ATTR_RO(manage_start_stop);
> =20
> @@ -275,6 +276,35 @@ manage_runtime_start_stop_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(manage_runtime_start_stop);
> =20
> +static ssize_t manage_shutdown_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> +	struct scsi_device *sdp =3D sdkp->device;
> +
> +	return sysfs_emit(buf, "%u\n", sdp->manage_shutdown);
> +}
> +
> +static ssize_t manage_shutdown_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp =3D to_scsi_disk(dev);
> +	struct scsi_device *sdp =3D sdkp->device;
> +	bool v;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (kstrtobool(buf, &v))
> +		return -EINVAL;
> +
> +	sdp->manage_shutdown =3D v;
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(manage_shutdown);
> +
>  static ssize_t
>  allow_restart_show(struct device *dev, struct device_attribute *attr, ch=
ar *buf)
>  {
> @@ -607,6 +637,7 @@ static struct attribute *sd_disk_attrs[] =3D {
>  	&dev_attr_manage_start_stop.attr,
>  	&dev_attr_manage_system_start_stop.attr,
>  	&dev_attr_manage_runtime_start_stop.attr,
> +	&dev_attr_manage_shutdown.attr,
>  	&dev_attr_protection_type.attr,
>  	&dev_attr_protection_mode.attr,
>  	&dev_attr_app_tag_own.attr,
> @@ -3819,8 +3850,10 @@ static void sd_shutdown(struct device *dev)
>  		sd_sync_cache(sdkp, NULL);
>  	}
> =20
> -	if (system_state !=3D SYSTEM_RESTART &&
> -	    sdkp->device->manage_system_start_stop) {
> +	if ((system_state !=3D SYSTEM_RESTART &&
> +	     sdkp->device->manage_system_start_stop) ||
> +	    (system_state =3D=3D SYSTEM_POWER_OFF &&
> +	     sdkp->device->manage_shutdown)) {
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index fd41fdac0a8e..d87bc57da8bf 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -162,8 +162,24 @@ struct scsi_device {
>  				 * core. */
>  	unsigned int eh_timeout; /* Error handling timeout */
> =20
> -	bool manage_system_start_stop; /* Let HLD (sd) manage system start/stop=
 */
> -	bool manage_runtime_start_stop; /* Let HLD (sd) manage runtime start/st=
op */
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for system suspend/resume (suspend to RAM and
> +	 * hybernation) operations.

Nit: s/hybernation/hibernation/

> +	 */
> +	bool manage_system_start_stop;
> +
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for runtime device suspand and resume operations.
> +	 */
> +	bool manage_runtime_start_stop;
> +
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for system shutdown (power off) operations.
> +	 */
> +	bool manage_shutdown;
> =20
>  	unsigned removable:1;
>  	unsigned changed:1;	/* Data invalid due to media change */
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
