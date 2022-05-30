Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A564C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 07:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiE3Hsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 03:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbiE3Hsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 03:48:37 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2826A72E07
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 00:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653896915; x=1685432915;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XUulJcN7/aVq3z41TjCOBzk7giED9HCnVdwD/srHHxs=;
  b=O7gTEn82rCodaM58Hs1cKFKNde74MrIWZYAXyQUaMe18yZ2tM7/ysLVN
   gWE/uJWuSM3yEcw2mhG/EtNFr7jVs+lSCvIefHKrZTYkEFf8rAAceUWfy
   PILp4kn1trRm8+6RZdrtv3ImgZGsfMgNgW3wBthNmbUxxRZA+9o3RxW7J
   eO8Hm5Qy15ppFzyenuRo1VxzjDhj4pc+X8s0P5m93hjk9tUrTF0rVCSaa
   aCBUDUZWyVCV5xjVSu0i1JDh8CtulUwGSq0NWvyNwdSFKBV56X+xswQdP
   JVSZwERJ6GexCxl1Uhq1fwqg2lHFAFuuPQkcfLit9lg0bxJhuJZ9169kB
   A==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647273600"; 
   d="scan'208";a="202592988"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 15:48:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoenuOFv4vNkKBQEy6Y3NnbAibGPahXoavRkuVH2s6ymYPWvEqQWCEgDwutyusrRk0Oacpe0vQlNhH6b2DmuaFvtvVAEjlkTKwHClYBW7yaTijbOudaXQ18iea/dpceiuxlyxCXL0bSr5JaVzr1fI2hQSDLgCtRy7UwTzneyZ9KLVl4UVr9eH2UdKCtGEC8lAwiWiJuM5/CZHKW2rg03a8ur08li65i1yBfk8OHbZZwqhWu1DvCN7ihpr+jM5rfrGVBLln89v7HvrckKzwG9bIvKfM57foKT2Z4c1p6yebPX4ynIZaOyNAuuwxaRDNnBXFc+DvXmQW6WOoYPolUieQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+xzzyfCRF9GlrGhzvYMPRnrwdBoidFse0BDEW7Tvzc=;
 b=QOb1QXmxXHJ2dD8IIfqsYNBEMY1SkRl/gkrmc9fhd2ebeM6m3TKtVqeMH/P5dreuUiwdaMWh6aK6s634T21Alo8Fdfav8q1tnd2ZEKf+V2dbl1C6SFRsCkHLuRkSWr+eiMVoqxkk46gBQtxNruE5IRn6xxdQUyuapNl0paqRQ/VpQxQu6BCvB0hqZT+mVdH9Z6q+TbcFh2L6tdJzjCoE1IEjafaAbjQ8PKlDsQq1OZwey++jwsXOczrDfgCm+K9zBDngjLDUrMakj+IZxc7aOvNDYkl9sHh0+tEHMjylzuns0p3yaJIt9MWfVpi+Q2FmuLmo6V/ZlCuimWTAviItGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+xzzyfCRF9GlrGhzvYMPRnrwdBoidFse0BDEW7Tvzc=;
 b=WoKn4dgwIcssFhms+EXna2tWuZGScSMHP8Q2m1nMTC8KMMPstOLqaXNfsxF7cTbFSPQzBzTULgWgCo4Tza2HJLjj3+amMK8xOLBev2wgFvWgqlBsbSrCHNsQYC6DNEnc6hdNZ863E3+R7ahn7tz62lI/qvtuuyGHjoeFJTLAUmg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM5PR04MB0267.namprd04.prod.outlook.com (2603:10b6:3:6f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 07:48:31 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 07:48:31 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH 2/2] scsi: sd_zbc: prevent zone information memory leak
Thread-Topic: [PATCH 2/2] scsi: sd_zbc: prevent zone information memory leak
Thread-Index: AQHYc8a6PUMFncZJBkKkLS/JLk+ysQ==
Date:   Mon, 30 May 2022 07:48:30 +0000
Message-ID: <PH0PR04MB74163AD6E7785C0F842592229BDD9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
 <20220530014341.115427-3-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 331ca195-5485-4b43-8eb3-08da4210ca75
x-ms-traffictypediagnostic: DM5PR04MB0267:EE_
x-microsoft-antispam-prvs: <DM5PR04MB0267BB82A908D331CA9025D09BDD9@DM5PR04MB0267.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z1rOLazHuPTMV/wbc04cPDGZJKvbtkL3v4owdqIcaFJN2TGO103KncE6b9dY3IiwNseOdnAhZTJ0gAyoz01WPrgLCSJai1eHzZ17QSP5YGJSpc9DuV+WdXvczWW2zFZ2R7oVmt/IucmMQMrc/PKEI4yeL7oe0mn0Ic5WTSzbTkTs177mh3g/DLKvtDgbT2XPHtiX0wqKe6JuIyXmciP8M5sluaJd3CuWl32OD9E5uJ2xjehHpPobkXP54ESiBlcFMgDpvV5gjjG8HKXGVqdIAFctzwMhSS9iI0KXiLa5rjgEF4iTC5i7U9nxSbZz9oG72RdoCwNtqTkJ4s7uLYU2W4NnO4AywLyRc+Xqb7wRaJgJlxMfP2bCgpKFYd5F145f8eT53dDdHe3zP/AjKo7y2+dYU02R4BJEDV0yfrCyfw55J5OhorLngy9aZ6uBP1NLneabDXKHPahg4HA8/Gd4eMaqAexGYl/eeyQYh0VXCk3v0MB6+sn0/d2y5k+gF46o7UbsnrjXtlaJpNzsNGtSlXIchgdZhNV7BJ5syP8QCzEkNC93KxZtR9VMJ5nBFt1+Xw6q3XsA64XuT9S2FiIvSM1w7SXGc5maWB53uQDfvPAQNMBZTvVJnP7BBtRqjiIMG6vfwjupy8otczcqm2iEO3rDh1PFai/kVU1y1twdWrT2PaCjC5Jhxu1jdDUEaxAqDaHUB91VotmZnoFU4ehJ2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(55016003)(508600001)(52536014)(71200400001)(5660300002)(6506007)(7696005)(53546011)(9686003)(8936002)(2906002)(86362001)(38100700002)(38070700005)(4326008)(8676002)(64756008)(66446008)(76116006)(122000001)(91956017)(66556008)(66946007)(66476007)(82960400001)(316002)(110136005)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D0aqKAIjxr4xEiChxKuHlChHN6EiOSfrfC6ai9JHeyu0eBonjrvW4WfvzEmL?=
 =?us-ascii?Q?k5k9a82ZdsrMFrsg3zinlSMGaeIlThEAJ3ESe/OU06TSW33UE8DpBxROIioP?=
 =?us-ascii?Q?07CYkAScFyVf5fmy7IgquWFufgxVlDLgAZq5PwUxciry6Wis2po1uv7C84SC?=
 =?us-ascii?Q?i1TW4JrBfXykWN5eIaX+g9L3cKOxFHnNAZdmhA36TWk10tfx2RGxtQ7m4CDs?=
 =?us-ascii?Q?JFg8HMaAwKukRfQ5C70Vj17I9B4SFnbXMHdzMUt39K6zmlK3txM7/bjl5qSP?=
 =?us-ascii?Q?BhQGBNc0d05mzPG00FDWLpXd+UmqM7Y21mjVgB99zQJAG+04/x2AhGQXivyE?=
 =?us-ascii?Q?SkoUV+09UN3Nd/lker3e6OR2kxWL4tK+HEsMfi2iyp/i3vkMt4hOTD4xRX2J?=
 =?us-ascii?Q?KjHZtoLPARB7Ani1VyvyxWCekcP//fXgTafdoNdnlKgtPh8BaA5znDcY79dP?=
 =?us-ascii?Q?EIMquJQoYO3nWhgd4LDyhxoOHugw6+AgdNp7yJi8ZlKPn+qRCKC7gUtKgCpz?=
 =?us-ascii?Q?x1oyZYqUVh1FJ5cM0cuHTt3/UTykOQTAj3kVPJmh2bZLvMMXT7crDbHXTEna?=
 =?us-ascii?Q?8Z6cTOxPiq+X0k4/8Z95drrmzEmgcvITRtdhBXQnZCPuGNx1+DkLLGWt14df?=
 =?us-ascii?Q?60OPnHhuwVgEmfgcX5kOtwqGJEbxL1xBEm5pXZJ1zKmVllE/Rpk/nX7Sa+i/?=
 =?us-ascii?Q?s28Xs7mQaXC/i4x56tVDtOyelmVX35zC4VFeWd32MxZoHSggBJ/WNh+wznDD?=
 =?us-ascii?Q?N6Dl3q9p+jNzxC5KROF1+XiSHaew195a9xzaKoJXiN9w0ldSPPVkoroKh3gz?=
 =?us-ascii?Q?I3sCklkCZXvLVwmJ2e/EIZ2G17+MAIjqgEY45rYGKed45FN9t/fjWu7MDlqx?=
 =?us-ascii?Q?Gv8H+fs6KA6xXJiv+s3u76tVsR/59paRaHnp9ypDCjgqJeTmUYSRbVm7+u9g?=
 =?us-ascii?Q?t+F3yZKFVmJHPxAu6w/0C+PCz2qnWZh4EwOnObIOJt/vnlvJlphr1dpspvvR?=
 =?us-ascii?Q?u+NSNZKZDWJC8GOtpBNs5vYOWPxwLc7U2hykd6zSEAxAtTcgwhhZwPRhMEpB?=
 =?us-ascii?Q?+HFREHNrGlPv9D0Tsk1aCt7LHRgzcPdbqsLzc2VXbIPLhl+2ZW+zIsx400gd?=
 =?us-ascii?Q?jZCDmfaGk2FYbWxwlx/P2uGW8Kbt5eVmBO1lmqkaWjJu7zh1iGJ/XgBF7XtH?=
 =?us-ascii?Q?XYaMFVI0kQIfcBfUPtFnfaeK00//E+BI31ZN7LN9xRqRbI5+r35GfVMBRuxy?=
 =?us-ascii?Q?vrl8mCWuqHQBnn7Hsh3QcUdslsSTo+Vy4Kvoi3Hchw/F1/L/sPNzavPu1mJc?=
 =?us-ascii?Q?1NFghJRen/bMdYS9sYIYqAb3fyjWjVOC+AYMnIpBJaCCWjUnMJw3GeifBBQ7?=
 =?us-ascii?Q?O7c89Ga4c39ZaFKcQOLmIQmWGeHQSabFEOrihVrG0DHqaI9KvQpJ0H9WvM+L?=
 =?us-ascii?Q?csKjwiE3i57bwVqI2IPyWQlYnFckDuiYfGNOLJDrHcN5xOz9vCvpXUe9zgHz?=
 =?us-ascii?Q?9T/2cKo1qDTxRjEMzau0muv+i+89KcnFfD27om6iH92qAPW0BN0KiUPW12NT?=
 =?us-ascii?Q?A2HfU5DrOS7uHnsGpXhaEn+3D4jPIcrgUbnxxQG5DAYOk5waeUrGZx7cH1VG?=
 =?us-ascii?Q?OdoIMiXqWAchZKx40mVDTrtjNepchLIwT6jHMwKGjfHasGMP9QAXbNFD2QiN?=
 =?us-ascii?Q?USpilf7ZB5k0HplysDAMYajSeTpV8mVjY+m9DVEPVeZQa3zXGPv+oWxJpzTI?=
 =?us-ascii?Q?WZ/kNxsvS8b90PvIoe1zAjcJx+pkqYYhlYnEy7GKBwf1TPrI68nU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331ca195-5485-4b43-8eb3-08da4210ca75
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 07:48:30.9333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UW6j5SUbhxRS0dY0n/dKqqMcgzcjMnagVhiSf/MaA9k9SjQD6pKWCfJWRzG0LBmwrAwLMcCaxL5T96QnUenVoW7RM9592iaqcrjYKk19ucI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/05/2022 03:43, Damien Le Moal wrote:=0A=
> Make sure to always clear a scsi disk zone information, even for regular=
=0A=
> disks. This ensures that there is no memory leak, even in the case of a=
=0A=
> zoned disk changing type to a regular disk (e.g. with a reformat using=0A=
> the FORMAT WITH PRESET command or other vendor proprietary command).=0A=
> =0A=
> This change also makes sure that the sdkp rev_mutex is never used while=
=0A=
> not being initialized by gating sd_zbc_clear_zone_info() cleanup code=0A=
> with a check on the zone_wp_update_buf field which is never NULL when=0A=
> rev_mutex has been initialized.=0A=
> =0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 15 ++++++++++-----=0A=
>  1 file changed, 10 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 5b9fad70aa88..6245205b1159 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -788,6 +788,9 @@ static int sd_zbc_init_disk(struct scsi_disk *sdkp)=
=0A=
>  =0A=
>  static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)=0A=
>  {=0A=
> +	if (!sdkp->zone_wp_update_buf)=0A=
> +		return;=0A=
> +=0A=
>  	/* Serialize against revalidate zones */=0A=
>  	mutex_lock(&sdkp->rev_mutex);=0A=
>  =0A=
> @@ -804,8 +807,7 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *=
sdkp)=0A=
>  =0A=
>  void sd_zbc_release_disk(struct scsi_disk *sdkp)=0A=
>  {=0A=
> -	if (sd_is_zoned(sdkp))=0A=
> -		sd_zbc_clear_zone_info(sdkp);=0A=
> +	sd_zbc_clear_zone_info(sdkp);=0A=
>  }=0A=
=0A=
Now sd_zbc_release_disk() has become a simple rename of sd_zbc_clear_zone_i=
nfo().=0A=
I think it can go and we can use sd_zbc_clear_zone_info() in the callers in=
stead.=0A=
