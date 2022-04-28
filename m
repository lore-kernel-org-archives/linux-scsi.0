Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFA4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 07:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbiD1HMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiD1HMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 03:12:40 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA299687
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651129766; x=1682665766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R2SwwZyO0f9gQzKJ0CX2J3yWXXOwt7b1tgH1XzbtjX0=;
  b=Ma77EcLKN4R6wEYULyAMxK3j39MG+ghehIcuULiZVi+ahP8H6eXMEMVA
   5wi8pg86lBKJ1OUI+RZRuguCJyDVhwzK/r4s0beqHgmVYO2hUo0FeVHU8
   lzzMIkJAmbzgngCC1z1YyWRFEuIXPTuzXUmYZEDrLrbwDHFxM5cq/+h9s
   jRPpQfLH6kA5IRRQ33y9eCl9DPrRICTpiqFA7obZpIBk0LJhccLTeRIHf
   L0dF3A9hKs4JxtvSXu+K7WHkmFHbolI/Gp2pvrhWBFv33LBL3Gt4U6Wjq
   mrFSZaDhbMVSXv5TSjW0SM5FduXkFsZk3rhbUJjpozBJigp41UcVpPDcZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,295,1643644800"; 
   d="scan'208";a="203905947"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 15:09:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXoAyzc8NQzdlZ2eGEhuGmKz2LcmU+zVWutqeLtenSRTIpUIRH5j+D/LmMfz26tAnlr9kVwNHTCa8tA9lBjBtgAj6b5xxX6arM4YTWo/3yCy7bEWxUec+iT3pk9MJSZEvQE24er+fF9yaisGTwh+6N6C6GWttAyv8BABO4+TAIfXVHaf2Ta27LbGpVxIGd5wTLDQZEXUkgFgua4C7WZXTy9JPgWfYkP6YxKFgGgm9DpfGhwtTSdtXYMylwEw0GOJ19n1DKJdKdsL7uVrTtLTKlZNjw2GUfBnv4rau5nuRLncfEnNp7KPU8Xn7QduUYH70BEQ126eeofovOhevk2hYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGUlBFRj5Wb1F9EoSphpNl01918FIcLmrHyPdJ6eT5U=;
 b=ia+DE3vEW1jHDxiL0vaczRJaHyx5mDcNbUvvBKw95zhWSrkL6Jjkgq86azw7e4wWaYfB915G1PklEqSs6h13IlXITJxlL6OJormcLteBA12S992hPks5gSPlHr/SfxfCqPJ3niCpkhQxghrGMtoz4HUO+3y5h2thM5CxLxv695h8aFJ9oPFX7/Q5HubAC6TnrsJHc+NxLa5omN67pEBY5WHMRw0Crcw3itE2eNXOrrDM2AqlqOQZxhrCKlncKeUu23Ea1K0piynhfmM5TKXAeb+tTVmq5Fbnk4eQtWurvCAuwt7uHHKUZoQ5/yhk9uAXbH4WDYjdgzpLQKB81hES1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGUlBFRj5Wb1F9EoSphpNl01918FIcLmrHyPdJ6eT5U=;
 b=DCCZmxnAigGbLkjS0ZUH6uvGR34WjmkZbQEs4iLcIQ3cHjE3g5e0RpLn9jTJ7PrdGhjgWonC1hzR+GhOvOqugCTSHMLpFZIKbIQmmXV1UpDUYFyQ8XJQWun8DKpB9zW/eu0L3RnxEhRN0I1GSv0F1Kscivwqq5m/jCMyuxD1UL4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO2PR04MB2263.namprd04.prod.outlook.com (2603:10b6:102:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.21; Thu, 28 Apr 2022 07:09:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 07:09:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Thread-Topic: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Thread-Index: AQHYWpAN08aEayJanUS/vdFdW40KL60E585Q
Date:   Thu, 28 Apr 2022 07:09:23 +0000
Message-ID: <DM6PR04MB6575F913911C61D7853F5A25FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-2-bvanassche@acm.org>
In-Reply-To: <20220427233855.2685505-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933df301-bc8d-458b-9e53-08da28e60656
x-ms-traffictypediagnostic: CO2PR04MB2263:EE_
x-microsoft-antispam-prvs: <CO2PR04MB226363D6CC36DE69EE874104FCFD9@CO2PR04MB2263.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mji6a9EYBTxvjCHG9ggEpJ9qmhsFqcvQTrG8aJZLSK6+nTMl9lBpCqH6MNrQYnurpAZ66NqMN48Tww1dVlxG0A41TGbCrK1cI4XOf4hxaEJJzMVw56+VQ7hUd2hjTEOo2sdW3ESHjFZ26/ajZVzIIEQ8eBaDc2hW+68H9co+nqPlM98IcJqoXX2nXIlaFdlWa3UYeB767dV1KI4SPP3cm0f5h5xsNVVKDhsW3D/9INDvChYvEvm6qGrA5mlSw9AhoaEvtJcwaDk9xULi3Jrlx0wBAr9Y1EF01Cc4UTVhjODc/5rC4j4T1m8NtNDE7WCUs/GHNccVDFFHmvHrsRM8/EXRU4aJ0wTMTviuyNlAfWE2uqVlQ8wLHg2e/GHZtMA+vwXmdT84tNxHiqolfeAaGk/ifnTsW0INBHpbNv2mRMDjxTvweQ2ciwX5ycnLLS2sNSMh7COi4+sIIMKVfeQ3S6USkfvJRYGvhxcrWL1siKb9/SVdy3bQqmmhiI2dQKYO9NmdutcqbDY7I8gUphkEKFOuQbQzua1FfruETCf2iYo7fPB7kXESLSKpLavKuI847IZrIDs6Oe+7rB9dSpS6XnsvBed/R02cyd9PPPUUPj04iQqnJGB7iiKnYEFfkJ3Iu4aTd5xEHEsnmeMVZ0TRQDU6KE1iXSm1ORJ4e6NFRqKFFbDzNzIjBnb2LAT/CqHDS8d3h+jp2q9BwJokXr35sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(71200400001)(52536014)(508600001)(66556008)(33656002)(54906003)(64756008)(8676002)(66946007)(8936002)(7696005)(76116006)(110136005)(66446008)(66476007)(4326008)(38070700005)(38100700002)(83380400001)(316002)(186003)(6506007)(4744005)(5660300002)(122000001)(26005)(82960400001)(86362001)(9686003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cmDvA+AU+XH+1hz0VG1HelMSd+lN3uCMJRjBWJFSudPZZ0ULrCfQrzDA/Vll?=
 =?us-ascii?Q?xKkgNVHEC23DO8h7L6NwY6jcz4lyYiuQGZOzzlsRXCKB6dHcX7OMoLKepuZN?=
 =?us-ascii?Q?Ixh595R++MWAQFgL+JGVtE/BMPLvG9/IE2SVpKABDAdG7RC5PigSambHeIxp?=
 =?us-ascii?Q?QwtR09t2ghEkliX0lGFCAgOoagz+A5Y1hoTxW9W/TMMmD2AdlT9Jep1s3hZK?=
 =?us-ascii?Q?oLvDD+T0JiBuorKcbn3BbZNhGasq5lGgh1gA7bf+VoGuTCPsBEaImzUZ/4tR?=
 =?us-ascii?Q?0/r9RmhJjZdWVRtqdQ7yokumPoTKlAbDYMp/YdEiQ6YKcBXwziV7VBXbcQCt?=
 =?us-ascii?Q?1is32yatuYJAZ/zxPZbAYlEFh0cAHDqCN23mlpSdFv2sqZypZv5u/y/mGV/u?=
 =?us-ascii?Q?T4tIaw2o9Hir6kZYBrCD9CN9+GDA5EB9xEcVc43XBTXLVK/o23ij3EAAQnmF?=
 =?us-ascii?Q?f2t5PKbJ25JU+tndIKBXd3HYKddwbHeMhZrNbULXr5uF1qdI3tmapkcV6YM9?=
 =?us-ascii?Q?Y5iB4C/QTFoGuw9jSClrlEBF62MnU4QgR6K1g71au8Ns6fpvHqffeM+evKGM?=
 =?us-ascii?Q?BT3B2cuBZ7hBK1IO4BWGdtDHZMJl7O/3ykRsBB2rIayZMd1L6LdZeG2bNegK?=
 =?us-ascii?Q?Z+JC237Vpl4WYqV2dcfFK4B1dK26Pt1Gb1JSIIin6w4dCX6JF8bqQV7ydPRP?=
 =?us-ascii?Q?ltjsgaYj6R0DKCOAP1AaMszlt3fTIiZM/tsUsWNnYRaqIEHBWQyW8s1Lrik1?=
 =?us-ascii?Q?a8ZBZb8dalk/Tgph2KlGeJ37xCfMir3RSkm63YQ3C/Bi+qpDDXYgTb7gBUBl?=
 =?us-ascii?Q?PXN3P/g5QqOnMPUOS8PjsYmua6gei8R3wf2DiWcwpwkcOYy9pYS2Rfq8hBQv?=
 =?us-ascii?Q?c51n9KvgXnHBHUwA6NXwLS5Q7huKXT85l8QXxujf+pzNW75ohH6oN3fMBczu?=
 =?us-ascii?Q?jTgAdR25B7K1aolFfCMBBUTF/lbrXml2b3fcvn75Vk75jI5AC5b/mZmhyhcr?=
 =?us-ascii?Q?n6Hs7nxYPPkuMXVi2pExfXSo6TMZLr3Z29nwrLrnHuCuBr5RMIj6uQazSDk3?=
 =?us-ascii?Q?+yBmjdyeyGOAT7Sj5d5xN6MOqAxSbpaaTCfko/EyfsPJvtqni2yPjbQl07kx?=
 =?us-ascii?Q?d3MYr2tUiyWvnf/O/gbh8LFy4uFom+6pMN/wSpr7DcU8HJBTfr/o2vZqNrJD?=
 =?us-ascii?Q?istLESmVIP2asFBwiodSDAEoCR1ARr15jt9s5+w//aY+YVRZocBKlgcbHPYj?=
 =?us-ascii?Q?rCcQjhGr2TxWbBkEagL9XXYmSOX8y7Jl2ldqoKwGgAxFHaIrQQohdap5Qrgx?=
 =?us-ascii?Q?QDfe2pjvJCzZ8gklbbaX6V0NxJEu87Qsk3sa+5qtX9yrqTHk54pxXWXa81EY?=
 =?us-ascii?Q?xxa4TKTfXjXNd/+ylM1ALuSoDNm0jgc6Q98DWJUul2/nZfmoWML04sU008bT?=
 =?us-ascii?Q?8roRKVjpMJcZsvin1uznQToacpfMNDCDA/cXDlqpA4JxtQ374MXSDv76K1sH?=
 =?us-ascii?Q?IkrHCfBNI+zsVmDhV+1qRto8vVMdkbUDyd5858Ggb8qji7sn5OGFIX3efNz2?=
 =?us-ascii?Q?mrmG6MJ1ppQs8KoOKVRTN85ai36/vYsM+I7Ul9wuMdFjpwE4piDi+tMF3yWf?=
 =?us-ascii?Q?hXDaSrIt8AQ2KpFi0a3pV3d21y50SHXg1Dt97nDQkfMSa+ps7q2urYBughVX?=
 =?us-ascii?Q?zUFkUQ43Y2c5BzECbhyoyX8wiMKknvbQRWlYaLUOeShmkpHRDqaIfJUhIY+7?=
 =?us-ascii?Q?Ms2uCJT+Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933df301-bc8d-458b-9e53-08da28e60656
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 07:09:23.9651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dcn9G7FJeYE5B5hZs71Ejfr8WsesHIaB8KlYiJfAuGL5t7pzKVCtULkvrWCYySSW+wuaPgkcB26lP0I8sT14Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2263
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Wait at most 20 ms before rechecking the doorbells instead of waiting
> for a potentially long time between doorbell checks.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Nit:
An upper bound of 20msec seems reasonable.
Maybe we should create some linkage to DOORBELL_CLR_TOUT_US?
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2b4390a1106e..a3fecbb403d3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1141,7 +1141,7 @@ static int ufshcd_wait_for_doorbell_clr(struct
> ufs_hba *hba,
>                 }
>=20
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
> -               schedule();
> +               io_schedule_timeout(msecs_to_jiffies(20));
>                 if (ktime_to_us(ktime_sub(ktime_get(), start)) >
>                     wait_timeout_us) {
>                         timeout =3D true;
