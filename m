Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D16C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 06:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbiFAGZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349858AbiFAGZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 02:25:05 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7730B6A066;
        Tue, 31 May 2022 23:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654064704; x=1685600704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PPdtjFJ2rEFDSEVw9YDEi3ZhMSUhuSGkdqyBZR2nqdk=;
  b=PpwkEND1VW3sEutMQmy4M4d8k98mWnDwXhGP2Obb8BgoiRoTjxHhhTs7
   r7u/8QI75wT+xYbXse7dQEsyab5JHzs+dLJoKImiF9+hepKnZ7R21pJR5
   T0GTz101ZEiSBmAbjhVGTGcQemXQFSXeVoB1e948PPxIG3KgQo8ryRIyy
   4jicUfw1jgMVr88n9cr5TrEhoR2LTWb4YSZrsZRatVmGIpVYMMp80v3oc
   E2139/WfkV+Nld1IeKpSpdVQtfy4xn4oKs8J3dSGayvP/Wm2/EkiZO+FC
   if1ozUAhVnQb1IFp9zVk0mAepn/U5oNloESOzNl1hBQrvVp6lOXF+O6mz
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="206822127"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 14:25:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYagJ6n2cAq2P22pguaKwtrCm1c1EL8n3I19nahkgA+zo3Aw4M9y0bjZcI7i0tjwWInwMKZLGLpF9UHsQUq+KunhciLzYnOg1W1k+hFPd0shVGFc+wvJb0TILPuaaRjehQkQ1vWtHePNyTfCI8o2EUyQlOhO3aHy+3GIvBUK41uC0wvJGQudRuWNaeQihzI0eQfx254ZsNM4IFXfQo2iOtmQ7aoau1FQ0OhwzhF1t5MqBIFOCzo+maNQOFdqa5hKppzi40Q8hC8SkMnsv5Pya+zw7MMhB7rnUY9NisXapbAeu6jWVLxdi1uq/YZ16t02BT+2lc9JVI80jjWI6DF6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnwgzjySD3T1d5z8ZhfP71lYhxUDduCRDrK++XUxRl8=;
 b=KwmXC2cFQqQ2DR8bqkRYrUBBxxw+9SaZuASK+6neVlMlGlsBCB/oNzTe45rr+sScBEeJeXMoaEnuL5NLbtRXUk8vxzNxxktFH8Bm5h9eTUGlyLKImpMlvhATxoXR6MMoQO6enl0eJ0G1klYP0k6b/NLZ6dNgrWEFa/C2tlLJ4KHRWUM0T8+W5VdePdmphUNusrj0YuPNIfO4hy9Mmcp1nrscQ+WKmsj8+H6JSMQ577xzf8/g/9UjEPvEb5vdeVeE9q+WYCLbJldWEi5as9fTUrCpS0QcvBDaoEIzpAMSz0JJDRtRyjJgSF/ZjV6DXjcpXmhSy5+E9kSPHVBB4ZywlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnwgzjySD3T1d5z8ZhfP71lYhxUDduCRDrK++XUxRl8=;
 b=ku6WSRgnHnDg3z0J9l/5vnsx8RDNsO+6GqqfXEJ7mzpFde5sPqD5PXeeQEIdzCwiXg57KgGP3y9/LtrVIQf7diVCQJMCoYFJaZyt1GNkEu1uKYczX6vXXRMwDxUV5e4g58ruhrrPUzHvzqeSzoSG5NRqHKJsSQSnNmqupI4kuRs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CY4PR0401MB3667.namprd04.prod.outlook.com (2603:10b6:910:91::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Wed, 1 Jun
 2022 06:25:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb%3]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 06:25:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Thread-Topic: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Thread-Index: AQHYdMBDNTBKeyL5CkK0kxxNxHcot606FaFQ
Date:   Wed, 1 Jun 2022 06:25:01 +0000
Message-ID: <DM6PR04MB65755C66140BDDF550DCE75AFCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <YpXD4nLc4iCxpw91@kili>
In-Reply-To: <YpXD4nLc4iCxpw91@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb03c610-5e91-4664-addf-08da43977549
x-ms-traffictypediagnostic: CY4PR0401MB3667:EE_
x-microsoft-antispam-prvs: <CY4PR0401MB366715A5857C53BA15DB1562FCDF9@CY4PR0401MB3667.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j66Qee+qHZdpP0mjg5j4j44F8LxJW9aP4OrH9dR662VnWMcLCMYZpSbOTCNoHlV5/Zly6giDipTPhTsExODo3bF08qYf7oAw950tyQ/b7KA+sep1TIVqDVd4aUYvf8Wxp2fOgsJn43gD7JnVpeTw2ESG+n+6oAviqlTjNEHX9p4RVmdgJalCEvtEqD6Jqaci8/UbvpQh8W51m3qjLOssg3u5//V6Ye+AW9iRORWm1VlD7qe5BCTLUJsMV967Qb1gpxHZhw7ez0e224eec9JIQYlyhCB22wd9jT7qMXqdx1TClnYKsqadE5/R/EDKEb1dqJvyn/ahOKZwxcdWBA0vPHbRoHcI2ddHSi2uT2lw2/TJuKGITsOHurGXBu/1hmffpToM6Pg6hkTKIu+RWsizf70Kdhf5cvh5i+a1IXsKVkcyLAq7iI/QsqUdFQgN2OSJTUxFx2D65AsxO35XfQuM0FS1LhVZkqnYR53McSHcj299L7bS4Gmc0erMeHM+Dg4ONDY86g6fCiw6A43dj1vpQhCngO5DKpbC0fO5mUDNBEXTowV1r7kQzS/Kdyudzlu7IVuYBMcCWcaqYhQHwOOjjYVi4Er3yEMvE0lazYLDA+7wDb1I5MT9D6P6KWdiQbcl+cossadNJMJo3MLMDP9DwBpYSK5ZgjORkomXtINnHM23V+yHD0HIQ18H4BfONguXtUj3SPfTzBW62Rt2bfY7GQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(52536014)(66946007)(66556008)(186003)(2906002)(33656002)(86362001)(8936002)(83380400001)(6506007)(316002)(508600001)(55016003)(71200400001)(38070700005)(82960400001)(8676002)(4326008)(64756008)(110136005)(26005)(122000001)(54906003)(66446008)(76116006)(7696005)(9686003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o1AtM4LNbM5mDCxTOt0F/6LbGA2aapUmUGJiFfysbYa7w2I//JgWuzTSDdrZ?=
 =?us-ascii?Q?1Gi34HHYlJ03HX3K0Lu0BcBthSkn6V9NLKxV6DSEqfQOTqVSIJt0F4uhKbr+?=
 =?us-ascii?Q?7ShOhgPnwxCjEAwg7oHiJd5rA9B8PFvhb+vwbWz0FijgmIF+VIlNt48+sEtk?=
 =?us-ascii?Q?KW+Pa5uGiYJBOlupCUyBsR5wu0M5U5dNzcQXvqtw0QAncP7jhiEd/12FtjCa?=
 =?us-ascii?Q?PmZ1Dfiq5xvMVCoiLK98NmLMSlPj0fUG5cxZWuQOh5kFS2QXtJ/Xou2CVhRu?=
 =?us-ascii?Q?JtZp4MZMOc4brQgEE+vB7BasjR00xa4blKqdWA82b0POrDar6rKoY3KJ6Q38?=
 =?us-ascii?Q?iSWJR4vwBOlWZJa6pt5DTHvoELbt08ngQTLtoxucLX3AF3tqJMu61wBPjWVK?=
 =?us-ascii?Q?ejsCOF4QjTuFjicWREbGJBTkjl7uTZyIN74XmuhNrx63txbKSuyTgCy/lhp/?=
 =?us-ascii?Q?rZ3D351s+Y3lEMiiswW8Ua8hNw0Tm9+Vu0C2p6ZRUlW6RR3tXDt9aVLt/LHN?=
 =?us-ascii?Q?HWNfP04P1lgkvkX7D591mdj+dXTRJCHlye9G1bLRs1/Yo445HGRJ+tu9Utxe?=
 =?us-ascii?Q?BrJidTNamO07x6uGQdjY5g6FUGxBe129A9XnccrQ4JAaL5sVFSO3LXtinnLH?=
 =?us-ascii?Q?vOoXiHQi2Mhv5Izq4UgFaCEIb9jwBG4gxp9Ex57xM62CN1L0wkq6DMPZEpkC?=
 =?us-ascii?Q?v+u3yBQZqc/kZVyBsT76YQ0v16lICRlrfagnJlfTlLZsPT82+Cho5q1uyWuI?=
 =?us-ascii?Q?51KnLeaYahlK1qL3KDc/EGzes1LKewcH47069iPNv9x1nFqqEmBzHhXPx3iQ?=
 =?us-ascii?Q?ep34ATpFVmmNeiSDnDXIx0chaJbozwrfF7PtSrymyYVIlCAbgCBB5/Nu4q/N?=
 =?us-ascii?Q?R3cF20VjGxZHNfW4bFmCqR97SPYep6J6Nbn9iwhIgm++jVLuIIhcpqDvLLJU?=
 =?us-ascii?Q?4nNY7dAJ/Bj/3timZx54zm5kcJGPzjbtdk4EEhMQDZJDA3ADsvcjore79dTG?=
 =?us-ascii?Q?s2kfYTE6LAXZB2PLxU0bzIHu/FSIJD7PEkTyPUf0v6ouxfj/Ip1nnCyvj7WQ?=
 =?us-ascii?Q?zwlOL+DnSwfXU1nbA6MOUTnylki4WXXUuv/rsekk4Vl/dhZMtVpOMH5oUFvn?=
 =?us-ascii?Q?AJYLQY3KN/8+OTD4ugdBK4l965uhkKyOMW6yvnUCb7U8axMIyXg7bnV+x7ht?=
 =?us-ascii?Q?2O+toS3vWYy3s2HyVlb7wMIm/cnh2qEYnQhDjmYtV+uBt0pLXUlYUuWwTof+?=
 =?us-ascii?Q?WAdTzLwhklSUS0xHM0ArzodnNmn2remD/9ZkGt9iHkH8qF9pR68FtZSwbnrL?=
 =?us-ascii?Q?lTxbn4mePitAApEf1Qx9GDTOuKAptZdxcDqUfTYNhkYwdt70lOADN9H0C+Pq?=
 =?us-ascii?Q?nDOOxqTEl4FPD/W9lMJpxkVVFseOsa0Uu+kW2fyIrLs6CeiCcwNWQJ0vKlbS?=
 =?us-ascii?Q?/KI8sDOojy3Wx+rUdLTFHFwgGC3swjPSzdVGIS0qmHwoi92IJ0n609HNJqMP?=
 =?us-ascii?Q?0X4ZT9drLLDbqXlCc/DnQakfB73vpQrEYytA/Bj7wVSATZi38D42mTUd+j/+?=
 =?us-ascii?Q?4agWY0n39EjJPoJAh19DXEBErM/jZQ2T/Em6Lvhs5rGhaRxuXdNmfv54AxwE?=
 =?us-ascii?Q?yGoDYd7zP/6ABB5e3WuvNtnMPkzxPOZrMiVlCLf0cM/g2m5LTk+G5Cv+4Qqa?=
 =?us-ascii?Q?zFpZb7ex5t92AkwR2iu01uw2CEhLKIyILHr8wuBQjpiY15PmJARlNnf76x6p?=
 =?us-ascii?Q?vcleZ5/xYw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb03c610-5e91-4664-addf-08da43977549
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 06:25:01.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ybl7AxoaeVYCP1TDTDPxZkhRkiFOS1YaL3GQ3kogOtKQDJGgjIpa3clMjdsYahVZIHvEZGVB60ij3h8IlWai4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3667
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Smatch complains that the if (flag_res) is not required:
>=20
>     drivers/ufs/core/ufshpb.c:2306 ufshpb_check_hpb_reset_query()
>     warn: duplicate check 'flag_res' (previous on line 2301)
>=20
> Re-write the "if (flag_res)" checking to be more clear.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
In HPB Reset, the Host set this flag as '1' to inform the device that host =
reset its L2P data.
The Device resets flag as '0' when the device inactivated all region inform=
ation.
0h: HPB reset completed or not started yet.
1h: HPB reset in progress.

Would make sense to me to contain this logic within this function,
Instead of returning just the flag value.

Thanks,
Avri
> ---
>  drivers/ufs/core/ufshpb.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
> index fb122eaed28b..95b501b824df 100644
> --- a/drivers/ufs/core/ufshpb.c
> +++ b/drivers/ufs/core/ufshpb.c
> @@ -2299,17 +2299,15 @@ static bool ufshpb_check_hpb_reset_query(struct
> ufs_hba *hba)
>                 }
>=20
>                 if (!flag_res)
> -                       goto out;
> +                       return false;
>=20
>                 usleep_range(1000, 1100);
>         }
> -       if (flag_res) {
> -               dev_err(hba->dev,
> -                       "%s fHpbReset was not cleared by the device\n",
> -                       __func__);
> -       }
> -out:
> -       return flag_res;
> +
> +       dev_err(hba->dev,
> +               "%s fHpbReset was not cleared by the device\n",
> +               __func__);
> +       return true;
>  }
>=20
>  /**
> --
> 2.35.1

