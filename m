Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF207CCA47B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 04:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiFHE0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiFHEZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 00:25:36 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4652A78A8
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654653162; x=1686189162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qGvxZ3oHOjZ9kyKWjGyWyaac4z1cNqepOBhFxOKhBuI=;
  b=hB/zPcz4XN0ldwEw0SF0GFlN95XGgEOH4i+eiJxUMyGTDBxyyBICMhkR
   JmyqdzeTj8X34QCFYakAjjJsy3dbufH598gqmY0gODSyPQVjbCSI6bLHp
   ipbctuZlhMhxsfsRFnSJXRfXTvQOeZA4i/DWezc8ZYWxzJKsDcHkBYboz
   5qep91kHeiowlrgtBZUmylD93VItuc1bfvZrsVBXi5PYUJij0cFuSslAZ
   rSv4W458RD96A/BLBD+PKp+saCIs/ETJoA1LVlTsHsl6d5OB06RYsm+je
   VLY95Zdu5Z90hAH22Vcc7HPt/g9SBA2khFyibm4RfvDWk0R1zVjMm/8s4
   w==;
X-IronPort-AV: E=Sophos;i="5.91,284,1647273600"; 
   d="scan'208";a="314596018"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2022 09:52:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/h0ATe4LNi7nAWlnZvmvbtNlBH4yX3VejRnASauCDcbmMEOnlvHtvuUUzGkFkJ7TFY/NeDFsiORrR/xWF0rT6uylxmph0O/BOTG8wf3Hu40nUpJNLy650jB/6RKYHyroASs6hpiKJ1VLHXQd/YuRQw7hr45ztBJu7ZAUcGrPyiYIuIa2aWQRSIHJfkrE6C7F2/2OHLhS6XpC1NCoyFHF96kwSbCjuWN6PDxcnc2F4F9EpeXIeW8i4sQOYRjCBuQn8xSCZgTr7sEDtFusCjE/aL7fQEhOH2dcseysE6HI/k9niNhDo88sYxTAweT5Etkf5DAHR/dOil8deuLyA+eJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dgk/qPhpSegTduZTwaQqF+OFahLryNdrjlXLoBMG5LE=;
 b=NPbWN3swKAgzP+UWTdXpuVkgyQ0hSQtT/8x6lKwOLKfpyyMCK10ux6BP9Voy+q5ghS8SW968ZcQfPFKyKljzASyD346DKf0p6jQFZYGADkRUN6ekAfin1eXqaPtVQPCeNPvwPoTk96AOV6NUKjrPQ7y4vD+ch8kKIrJ8p3rYgGcvoAWEyl16eUgdAeXwmtvvCsQTVxp1lvFTCp3dRCPKSZwWB5rMIDEbCvypErZqA3ETIxhkg+hDzsC5cAAHonWhsX+W/rvBu7JVA813evfX2qZfXEMMLSdaIwz3cNex2Uj9TlSrgFLN77k9MG6Qd681EiFUs5RTA00iuUphv0CTYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dgk/qPhpSegTduZTwaQqF+OFahLryNdrjlXLoBMG5LE=;
 b=0L8Dvuytvp6JSP5JFNj5OWfpFBbDgMh8dFInvjsypbl5AlYmm48XQ556FPei9c0KQ9JxtP4OM4Mu8b6YqO2TdoZ37eypke+DQ24jBRLecqeQ9mWZKYGwszyRQ7IWO6sGqjqI2kjJDiNrlZBsxc+BCtf+DAA4mAnAFuG9g9tYNug=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL3PR04MB7948.namprd04.prod.outlook.com (2603:10b6:208:343::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 8 Jun
 2022 01:52:40 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617%3]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 01:52:39 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix zone transition to full
 condition
Thread-Topic: [PATCH v2] scsi: scsi_debug: fix zone transition to full
 condition
Thread-Index: AQHYetTsF6yYTGPBbk+NOyIZxFcnCa1EvzSA
Date:   Wed, 8 Jun 2022 01:52:39 +0000
Message-ID: <YqAA5ywNC4kdRWXz@x1-carbon>
References: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74e4fb91-808a-4285-f10d-08da48f191ef
x-ms-traffictypediagnostic: BL3PR04MB7948:EE_
x-microsoft-antispam-prvs: <BL3PR04MB79480CD333A71276A13C3D92F2A49@BL3PR04MB7948.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MqMhIlC5+cyGuavhTW8xm36elCvz6dtjskY8QAye11lk5GX/pwinuXgHGDlM/+1skk9hPgTwfp8ptk7bY/CgTpWGgmbF7rwvElQIGBG8rqjz2ZXMSMKTlAAwTBhny9TQ2BZT1rwHlI+j8SlMvLU9vDZ69h7HvxGUJc8F5ms1xwAF3JQhdRwq8fIpWdeLXeT+RdmMEWBrzOE2USK3hM2una+wJiWXUyDlqUSx/7ZmoxD4imT55dg+Lh9ZHntL49IkJjAiuME/N8tARv1Nzly6QGJx4saiUyFiqRS6UAMJhEtPqyEaeic/1Md2CryUMn2dJZpsuscinK0lU04bvKou56QFJqIbAS0ROZq2/XZdI2GhSb35XNfNWGriilKbHqqr+HG4iaacag1hFk1oyAVKG7prE8yoY47cwQ92ZMG1RSrzjG1jO5y58G0H45YygMjG5n3IFMiPoBV+vNmvdPGHahuont3ixGhQX8sl7M2TAG7vAUOIeTPZixSdC379Dtz7kfvqBJ3nVs3+TsrpSEIkX+I202jVhhbtIpjIbVkayRgTaZqeoMG8WNsYmvNFpAik/q0/qznK7Qlr5g+bHAg1EdqVYXDjJdf4gFdJjUOpfFNwmvRvvBBdPUnZRpFY1wRrHr7HXEDTSiRFnBzjnSuQwrkNTPFPxCgv9YECqCrw3DldVdUt8J0rD7deXvY6QT8cSwfmLQ4bWCn7LfT4mrORuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(186003)(64756008)(66446008)(66556008)(66476007)(38100700002)(4326008)(8676002)(33716001)(54906003)(2906002)(71200400001)(66946007)(6862004)(76116006)(122000001)(5660300002)(91956017)(508600001)(38070700005)(82960400001)(26005)(8936002)(6486002)(316002)(83380400001)(6506007)(9686003)(6512007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aGIAWNrHCuMFit0fSWvnXz660e6lk+ZDAblnhTIjH35evUvUvC6UQv+6DONq?=
 =?us-ascii?Q?PmJb9NpQOBoV8sOu0DRA1xBfkLMg3ZDxvIC12cmX3UeXHgF52nTg4G7un8sK?=
 =?us-ascii?Q?Gln3M9FJXwS2WfJeiAlCO4CJvi8X4wgae4Z/PwvCXzClygHktYHfgIwLs+Qy?=
 =?us-ascii?Q?7JrzJtN2iBOlVve+tY+r3g4xfr6dZTIU9wwxovzzf+XHPsL8g1AOnVneng43?=
 =?us-ascii?Q?Hy6v5a7Goc+89O394scG88CVv1TkOrqdpEGA0Yk+1NMo+wFuvz0iiWYi7bUn?=
 =?us-ascii?Q?X2SYc246UI0TXsKedyyRuMNvX8KlJZJKv4P6IsQbnQSWLqD24X9CLK/i1CTA?=
 =?us-ascii?Q?GYdz/4wMpR46JVfoVhkjC8ZW27jIHNzg6XabUsJ439qwKFiD6SPyYizRa9hN?=
 =?us-ascii?Q?zlvRXwjtIS33JcS+xpGTypsYP69YYwKe2i+8IXfzvWYa+FyDtenyor8D7yuw?=
 =?us-ascii?Q?MvOXwkPadwWSY23xsCNdnllycqbuy3BQPDdi0EZffkCVCEVZlvrlv6WkYeaU?=
 =?us-ascii?Q?O+Ex+UFqhhL7nT0eRUfxiMU5nBaecSHZztqIhtrVTTbHc05BbS9DKjBDOPXH?=
 =?us-ascii?Q?F4w3hCFin3CKywznAlDkg7UWwxnkBITJr5Lp2gjc3EQsHZ7cG24tANMYKB7q?=
 =?us-ascii?Q?PXmpxdBHR9UyJFXDxxdGzAeMGJjG245szJi4z+fARrgrZmTjp/LuKpGeEG5w?=
 =?us-ascii?Q?obcboVP8tr3XgrK9N0Yfa+AOqQkxXcozbiL8y9c3wzNRYO4IjdLw0ux3h/hz?=
 =?us-ascii?Q?DhvJaY6NKuGjKt4i3nDl3ILbA7TSeFZq8Zy7IuxSmMyhfXYunjqkjzLuh4mt?=
 =?us-ascii?Q?sYBuyqni4TvNyVVjFEX4umn70wKSeDk0bl95/JLoQoDaVPMZUN3VFdL1fA+0?=
 =?us-ascii?Q?R69rtKJD0/cOOSXkqpUB25hJ7o8YUvY8JIRoY71D2uoT7/wrliR4YYcBiaCB?=
 =?us-ascii?Q?hF1ndSccaimyUE2dBKdahkTL2UAJmbTqBWGGGfu10kgiK2aF2DRLWgfVJkC1?=
 =?us-ascii?Q?uY4jkTdfQeDgOqHiLkmlAzIIZybE6OtMqLYAxUnGk7bVA3TWa66OFIUT+4xB?=
 =?us-ascii?Q?WdIWXvjt2vjk+rVqA7YLLGeazSs5SaaHY5DhX3+/1r9b8odWEMTTKS0bAM2j?=
 =?us-ascii?Q?+fpuCn3QqFx/vc0fvAOwMyWWrQmu7Ssv6hD7EZTQ+qCrwYU+/zNz+x7eLjkF?=
 =?us-ascii?Q?nPnikXyguPrM5vH+t2xPZ7eLGBiO2wmAARZJ9OmDK+tQX2taN5y3ObmjKFz5?=
 =?us-ascii?Q?8iMWkZ1MFKP0cAg4kvucLgQ019ku4d6sHVhYFTXptQTzysQ6+agCK+yLT/Ug?=
 =?us-ascii?Q?6BMTAV5qFqo0abzQLCxurRm6E0Flh9WQinkQGPhzEAdSSDGfr3Wt0f2nR8hC?=
 =?us-ascii?Q?J8ljgHWzED1yvLa73v8cXTPj9niEBOMg0quoviS9YcgCqrNRjlAeH13KWJVx?=
 =?us-ascii?Q?evZH3zmwDE6Na6i8lXvNrW8Mky04d/QCsGZWy7+ajPTL0Wjf0Pjsjvu/Xaft?=
 =?us-ascii?Q?lpzIWgm92yHSyssF4A6iy+aN7C5jTJ7JDbbNAxFNFkRdcjnmvnC2DMKG6xVP?=
 =?us-ascii?Q?G6J+x/TG1FE8urbPL+tKPUF51bpAgs/h5lCG6muX/w3IDhnopz2c+yEd7k7b?=
 =?us-ascii?Q?/6NdkWxZPuJVG4Aqb0ofpnJFA5wSEKwlky/HTLOVNC0ddYI8hdsp753xvFFX?=
 =?us-ascii?Q?ZM94QTRM+43AGpVHIEXfRenNcKEYfZjZD4xGJjQApAph4GoCqqQ96YIJSx5/?=
 =?us-ascii?Q?4IhbZyn1xPYdrbtFwckNi15ZTbfvKAc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCC8F815087A304AA459571F3BC5199F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e4fb91-808a-4285-f10d-08da48f191ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 01:52:39.8617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EaDS9xnXLitrweq29+4NUktA3ara6mzGOh/TuzpDONi/5YgiGMeD0oLhLaTPUlGB+DweLprPmp+uDd4uM/E3lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB7948
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 08, 2022 at 10:13:02AM +0900, Damien Le Moal wrote:
> When a write command to a sequential write required or sequential write
> preferred zone result in the zone write pointer reaching the end of the
> zone, the zone condition must be set to full AND the number of
> implicitly or explicitly open zones updated to have a correct accounting
> for zone resources. However, the function zbc_inc_wp() only sets the
> zone condition to full without updating the open zone counters,
> resulting in a zone state machine breakage.
>=20
> Introduce the helper function zbc_set_zone_full() and use it in
> zbc_inc_wp() to correctly transition zones to the full condition.
>=20
> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
> Changes from v1:
> * Simplify the patch to not modify the zbc_finish_zone() function and
>   not use the CLOSED zone condition as an intermediate state in
>   zbc_set_zone_full(). Cleanups to remove the use of the closed
>   condition as an intermediate state will be sent later.
>=20
>  drivers/scsi/scsi_debug.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
