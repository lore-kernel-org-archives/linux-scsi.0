Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16427C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 13:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjCONoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbjCONoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 09:44:15 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD5A616E
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 06:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678887815; x=1710423815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aHzmTX1m1HgnY3h7CErKQz6Aanmox03WKHoD3YhTfxc=;
  b=HGdawHzfcum0Zk42iwBnK7z9HVVTKbL8EUvsMdPaZzLKRpzU0yt050dY
   /Rs+g0Bzx5rAob9AS0DtmDwAh7k77NUm2unvJ0VKTZ/r6bsSV/cb/ik5Q
   hRg0vUW6pgXLrYkOUd62Gr26xnrbL1gD5YXUhNmNblAjRBKj3TlOq9DNj
   D+papOA8kb4M/iT4l/djcKyEgkH+dGZTTRV08XfIoQDktYOBeHMPGMm1N
   gVNt2znA3Z3kM2HvJzWeap7tyL08IzqsUKACYGuxwxAwhDN1Zcl2yiyPG
   A7AL64neSMrsPZ8VZsPBulRg1CWEyi7M8r6BmGZp0HnT/NXOFqDdhoUxj
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673884800"; 
   d="scan'208";a="337722493"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2023 21:43:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gC41BDk17OhdbS3OgvjHN/MgQ5nRENM+hjhLP0EkcZvf9jaqYQBcVnkXZMtfr1642VIEg8g4iCsVG2ONQ3b0aFsX/faKX5eyu1nrT6xEm8jipLtZ8W08Xn03svLq2Y9zHBgAju7TtQR7o5457l/zVsTBFhLnku/rHr6SE24NzABOJqAERM0OQCPR+2qKjymk+Rfy1l8sZAXhj4c5pBb0pA52cC8m9IvbXUU+FQulZQ8c1BS/nb4cWDdQp4cLwtFLekiAM51hrza73Ok+rwyBH5xVWw2HrML4GBEzw3AdH/EZD3wqWxwAhiuys6qOsfu/LyvcNHdUEOM5LkzJPyJ5FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VArLaASsek8utM5DF7ny36yRL7pvMTC25sGKV6LY0uE=;
 b=AocMDO9v9tu9V4bsrWbHFz0qV8PM9DSqyydI1DXYQ85lkktYTJXF2BtyT9BVsjDwaGfpoAGSnt1stzexY48UNLp+HpEMddW051G3W2aMLwxBufd2aMjDiWyC+T38fLPHEgXtprN10ztJCDI1WAkGdoh8WqbjB2TYUxfi6Pj9KpWie0gM4gSWYLPAjXufyAGQ3S0jkk63Z8l8+Wtp+Y6c1pLrQm0oj3hFwlCgKNpa6OiZ+0AKJYuGV+sVM9WWwU9IhImhOev4UJCpzA6fkXCOFxSZ9dYqHAft/fl1yVNIHyg1lw1YSWlEgmGSTGAmtVX3AQBXfowxwT0nl0PKrXcGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VArLaASsek8utM5DF7ny36yRL7pvMTC25sGKV6LY0uE=;
 b=XTEROwNs9sQTfK3WwYuKzHZOHWOZX2GyFG3Kzo23ooaUYusK0D6lUW8DX7RVGOXNu6tMKQzs928qjTgjNO2bK90xmrYlUOijy/7dXY7muVx+8fVeUOFd3Ez7wuYt+tJ2Pfie6xGmY4/LYsW2hRxZrNudT/ROc4KeOyCx9Ua+XRA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB4867.namprd04.prod.outlook.com (2603:10b6:208:56::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:43:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 13:43:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Thread-Index: AQHZVrfDqXFgb4oCmUShIwppDXdKFa772ngQ
Date:   Wed, 15 Mar 2023 13:43:24 +0000
Message-ID: <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
In-Reply-To: <20230314205822.313447-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL0PR04MB4867:EE_
x-ms-office365-filtering-correlation-id: 20223a13-72e5-4114-bee0-08db255b3fbd
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CRHxF8gyxoRXc46ivCV5XTdWuq3rE+NP1vJa4LP8uWBeQvypiz+c4hm+MWEWKJSV0KraaRpZeurAOyG344iulPR8kjEpvaFvGkGM4o8wvydZdiiI3Xmpll+82dQrcTsZTehA2jC2tbqd/kDmDXuAuJ+sql21lHJXD71TEnQe/6iWHwPY7xZTPZkXaKZBzQlNnYQUo6Zr6OUouVPZvhAG5QZtX8aqUslwpxWxsjOO+U6O5qMuVg/CN51BNrh7ff/tVSMkQK6oEAjVwq9BpMOyDM9DqvEJ20FBZ34jy2KW6OPzD9TMEDOaDCBq0RnpHk2g0dEGTtdiAc4b2yCluQIqS03CRUPiT2FwUE40XXnZvCLJ0MLyJVxASpIZfZmOAfG2aphN8bbEvsrj5msRMmJVxNppaj4H5k157NAFelpZN2TmrpB7nuBQ0pNlakzxclgQmUEWrOrqgdb8NmGl85D5b/LmnkdPK9AHQXEqjUi++aBbDluBvTGoICA/+IpeX5b/sUz4/DCgLM/Y/ZpZ4hm/1ar4x3Gj4G9aycKziElMZvFLot+f6q89uA5+Nc0rbvv/ccPEv6EHaRraWB4oR7anqnaWh8ZI/LNX6xcxWzSYoanNaFhd0vC0CnFkUZDwG4TokPrLuYRQkspxJFWEwIriFvMZUCXKdX9vb6Ebodk2wwgN5yqEQ0AJYv0LEWRjP445G6e4ybyrHrisGv2qm7nU8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(33656002)(86362001)(71200400001)(186003)(26005)(7696005)(6506007)(9686003)(55016003)(2906002)(4744005)(110136005)(38100700002)(316002)(54906003)(82960400001)(122000001)(41300700001)(8676002)(4326008)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(5660300002)(8936002)(52536014)(38070700005)(478600001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zq+zP7IiVFnc6zEuzcJTqLZpcm2CUMdkowP3jv7ThP2CBuTtRUtLZqmjb/5i?=
 =?us-ascii?Q?QqVKAat8OqktOodwVnhqePzp7hD4rlgnGJJS+cuFND64jb/rBesEatqBTj4w?=
 =?us-ascii?Q?aGKMCVzKDGE9t/3CbqSUxnr0YUOXIsxWcC40A1f1hSmbDL9FAIZHgKko+GCa?=
 =?us-ascii?Q?fJNsfzFRXijba9HfSY1fhYTw6ot0wYiksU7Ibn/e7yLHiMLMuacEiJ1XfFHy?=
 =?us-ascii?Q?oZdYWf7/CybkqZR6ujGOGY7uPt8m6B+ribAegTlpSuYhPGIkfeuJ5Ax3NLcW?=
 =?us-ascii?Q?fCKyEA9jLR8IglWsGVbrx1nF6GG1OJdx/v5y/4Gbo/w03Um+4ls3OR0A3c3O?=
 =?us-ascii?Q?nIM22cP4pOgSG5xOTb4ztIlnpqFjM6/B3sSKOE/1wy6LK1RVQYN+rnpXDfW3?=
 =?us-ascii?Q?EEWs2JfFA9+M2jCt8GXdkdTcp3NF7vRGVm4GLkcJnOKyTFnd20IF9+aK91PN?=
 =?us-ascii?Q?hfdmBc6kVCnieAvQKKjv8Kf9uEaJucs1MZaGO4rL8NvP/b4snnTJTY6F+7MW?=
 =?us-ascii?Q?ELRUgtrYiTbXv30sJ6hCUk4y60sFJXRoQuU7gQoAEOKer2EdhIBNeQ1153JH?=
 =?us-ascii?Q?Hq0OvDQarkbh9ZYOFYpYvoVPYMwTCslk1MCm65SL2dXp4R03wRq2xqoWa3ht?=
 =?us-ascii?Q?imvjY3f5wiPviIkhI3Bct4anaFRwlmjDQhtsEf7U3Xl6RQFQdK84ZUhNLa2D?=
 =?us-ascii?Q?yAEjhs41CuhLzVMvZs5W7NH3nkssF/xbl4q6kjXWzQ+OC2zwILG4rzIXAhJX?=
 =?us-ascii?Q?zadwjER1d4FGQaBFB1vFiUtg8RfsbJhGFwRV3BZZDZ65Uo1LQzrf8oHWdjQj?=
 =?us-ascii?Q?lTLN2/WT32rUVdxdHa06nGfQtDjf5Oxoe9A1nJx3P1mQQOsVK9dTj3XOnK0n?=
 =?us-ascii?Q?OfByHSRIXliISHFMpWHCkiQqWxA7SZepgH72MvrMlswjqV9xDT6RyO1/wyDZ?=
 =?us-ascii?Q?c1V33rkpDEspEC/dj4bGlPX2iKUi6fyIuj1L6JaOLb7vFyRd4PeJ+LKj8X/z?=
 =?us-ascii?Q?UWBO+dqV4hgZ6h5obKozEc6J0gh46JZMKLBy9o+c1JhHYqYIBu7u4aor6hD9?=
 =?us-ascii?Q?CuQv519bNTXpZe8vKgM3wwIJXulH0MqFdXZ+Ml3l2auTlaBnM+K3yLpdiqzY?=
 =?us-ascii?Q?G4yyxMEvpBF02Ws0RXY1WB+yyGLGWzKMe7Cc792FCX3barcwkDHyzySm0xLk?=
 =?us-ascii?Q?s5pTWmsBQ0rWurmN+3Bx4FhWmnsqczllbdCkagBZUgDi682hUpY0AmQ8a6WA?=
 =?us-ascii?Q?TFgk0ixvy2J7XBiBk3bOczQPwjhoFOV8VbWtOsOaJohrz9bkwQ3/Pb+l1riV?=
 =?us-ascii?Q?vHfdRd4cMzZ/AW4Jo60CxylcEbvRL5IVfWPPdNxOyQf9JabL2Nmj1QWL/Y6i?=
 =?us-ascii?Q?+/Wx3iS9dxQFhcsQGMyuF+U94W+ek7gYK4K3oaUVnY2pm8WFJwE8GYj+mgjw?=
 =?us-ascii?Q?Q7DU00NrVKKGVsJsdkSLytrrlzE+bZ/l7W7pSVKPrLT4BZ652yJc+p6TYGOA?=
 =?us-ascii?Q?wngV5V0XvSM2FVXmDK3tHXEx1aBixlSVjguinwYTEWJakaa/DfHmO5SXW+Df?=
 =?us-ascii?Q?D5GYSj3zQiTCAknlsiOuYDdBScFLJ86YBthLFrcA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?IwZkUen7QT5qaLgs7NmjwAKmadLEDUn7SR5+bxwib41K6E7bG36trZu8KOrN?=
 =?us-ascii?Q?6QnXAjf4gBBb98qAEXkO6wNY19AEgX9caL9PxKCpDiI9lvaxLle2re94uvcm?=
 =?us-ascii?Q?IODNhX2pYbEORkOXs34Buvs+Mta2PGNOcETiRCH9Wecw0/3XmMzHXyfaRgLF?=
 =?us-ascii?Q?aFGX1tKUtRyHzaugU/M6xADccHwuojqyrvq0FdDfmUItZIv8StgA4svqMpEH?=
 =?us-ascii?Q?U9IBlmyQwPFAoTmKhJPG5Q24tywy+Kcvt9K6TbhE3rfTNDFXbYb7O9qgtIfE?=
 =?us-ascii?Q?DbPmJ0m+fNtbXhAgahqEp+FKw4/fvAtnkojfrJpkIn8i2xke4JWglWmLgDhk?=
 =?us-ascii?Q?ywCY6gBrl2ce3FoZ+aHsLCc+RJscXzRu0QJha5jiWb8GKv0NWDKpdL7CdWg0?=
 =?us-ascii?Q?cgAod93czFwBw7TOvIu/ti3P6jt1U6QysCB2fknlxdejMVO0c+Ts7CnuzDQX?=
 =?us-ascii?Q?15J1Tov+FGQSzQO3rTzFIsSbhss0jdL8VD69FCW5IQAJD2XFlnOB2xG7lWw9?=
 =?us-ascii?Q?KJsai3geo9f7F1p2M25mdAlsKKHHHxGUogktArs4+H6YGhyzBDt19yWJdM43?=
 =?us-ascii?Q?HLmx66uhM/xEMU2HEGr12egFAY3bsXpn/tyljZGM7whMxF04sZfywb6an1lV?=
 =?us-ascii?Q?iX/wUJ3/qqIfyhvLld9D13WUJ2PMbk4rrtFsBxN3lqkioOiUKI201bfI7st2?=
 =?us-ascii?Q?7BJtwqgLhhMah7GdhrP+uQt/O7eAzwOU7aGxiHhd54qyGuBb+q5M6hCbi6mk?=
 =?us-ascii?Q?88qrNcXLEHUaBoEEBtzpsB2+cT/3iEe/tjrpgxI2CiQ0XsPm4V5/yun0NgJV?=
 =?us-ascii?Q?YBjIBRlVK+Z0pllSNwo0QKtU6UipqB+Covkp+5wkViKbrTU8qJ8DZEknqApS?=
 =?us-ascii?Q?yzccXphIXaDs3AM7YNlYtLDxa3WGypCrP//CLVeTsfPyN3U3EM6/kEP90kJ8?=
 =?us-ascii?Q?d+jq/yK8qOti90hpPUwdmYPMvlHArrJhZI7FAHq9a5zO4h7/RvBJRr8KaU1O?=
 =?us-ascii?Q?hJKfj+BLKcTvZjMltVpYh0Wmag=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20223a13-72e5-4114-bee0-08db255b3fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:43:24.4239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xf4X5PzMZXwcGQlwi/NeBo8JrNddswv2rdeoUzv/AkOw84HOcWqfalDj/PlEs/RGcHI5t50J0ckTJQrEx9QPCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4867
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Neither UFS host controllers nor UFS devices require a ten second delay
> after a host reset or after a bus reset. Hence this patch.
Bus reset handler is not implemented for ufs.

Thanks,
Avri

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 172d25fef740..ce7b765aa2af 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8744,6 +8744,7 @@ static struct scsi_host_template
> ufshcd_driver_template =3D {
>         .max_sectors            =3D (1 << 20) / SECTOR_SIZE, /* 1 MiB */
>         .max_host_blocked       =3D 1,
>         .track_queue_depth      =3D 1,
> +       .skip_settle_delay      =3D 1,
>         .sdev_groups            =3D ufshcd_driver_groups,
>         .rpm_autosuspend_delay  =3D RPM_AUTOSUSPEND_DELAY_MS,
>  };
