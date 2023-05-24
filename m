Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05166C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 08:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbjEXIDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 04:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbjEXIDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 04:03:14 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7912491
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684915393; x=1716451393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vn3WQbIULUIExJmWZ8dAjMZpwRg/hH/1JP2GVhrdqr8=;
  b=bbBzMjHYNY3d37y5H83uOhZBw8Ujmk6KB3EiJr3OdhfBrg10Uq8hhBoO
   fFZfJXpR6u7ozaR3LEUONOzS4F6afNiK2YTF+V2rDFzOTSBPrLlXmBafY
   nO2Oug6Wt8FJCWKy5s9o6Q1FyqQAAZnC16ttFAwwQ0/5PDieC3CUMG+0W
   1N6B6pcPAsKZH3BAkK3OkBBqjgS3+fxmUpkKfS69cf3fhWT9LHFFLXcpv
   PBpVosMX7XQ9kY0Qta4O+X91bzp6+ljL9vlK7SEN4cTqO3fDZIu8GpsXO
   QaPB+e6Rw28olNje+YQfxe0C7JqRf3egFq548shlZOQVFtJ/VTKn+K9r9
   w==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681142400"; 
   d="scan'208";a="343608704"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2023 16:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MV9ehJJAjxm0OIbMeOVO4FJ7H+lWf+ekEyWaCBYDHdfiDIarnhM72e+esd+7PwKu21bnQU2WisIzWAoSdYcUSxAz/HbbL6dFBLNirMJNEOEX1Z3pOmMFZ+Kh+15nCzoCKSGxVQcpItIxRM5flEXbJuBIAZB5IBUIaodMrVu6TSYIvss4NnPx+R/i/p0XAnMrdyeL2DgDkPnaIVaH+DtiecPrQC66yw2wZP1LVQxQHcZb3yWANrsgWL/j696GrzKZP9brRHIJtCan8vxbJ3ozLY+54ADhrCp89k4ZnLE2OAbIIhuLUK5Z640wRp+P+YY3+KqQVJufpgx72CRhJMhEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuQ1EorQuADtLsJw+9u+cLX+X235hqDClxpCWloDRiE=;
 b=eLIKIfODKZDKKHybjTFWHEWnV0LY7iy3rg1vQ3eD1QbfquVCv/aDK6i2IxjXStDxZnglW1UZwuOWheGYvZ9P9TitYPM8Zu/IwsFBLoYdDxVza2OgqKfxWLNFdSx3jdwKpcEs3kcs2dPgomZf9pvnqCY2kpA4QafUA3VztmFbsiR12WmdSJ5acIbm2U+MCOwVVtk13gVAHTYWYOciboiIah1Ij2/Z5hZ+nvf3iNJE1x1S4Jgpkp5VaQ/iJFgAAA4ZYTbGTIEVnKXO9IDF7qVwWmxTWTa6N7Znm5VMpq2RNcuWLhsLfGUTwApIWdguVYni6JC7hdNa2maF4E1R8M0Npw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuQ1EorQuADtLsJw+9u+cLX+X235hqDClxpCWloDRiE=;
 b=hhGr9hDMI81Iz8Z9mqslcgaREIjyve8wbTqVn54IgJEoxcL+sT6DZBjKMjcNvxHr8VIEoulCFb58LUcBT4+suo9WiY/WfNa12/qVEjobuxUiyItkUg+Sf2u7dKA7hsSQR5gk3byX0m2pQsnWZI78gchNRD6XHiMD0uMH5MIg3vw=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH0PR04MB8355.namprd04.prod.outlook.com (2603:10b6:510:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.25; Wed, 24 May
 2023 08:03:10 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:03:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
Thread-Topic: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
Thread-Index: AQHZjhYtEMpFsEqqtUK/gonXFxY1Lg==
Date:   Wed, 24 May 2023 08:03:09 +0000
Message-ID: <ZG3EuV0/cwYhYUt2@x1-carbon>
References: <20230523074701.293502-1-dlemoal@kernel.org>
In-Reply-To: <20230523074701.293502-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH0PR04MB8355:EE_
x-ms-office365-filtering-correlation-id: 141037fa-4e77-47c7-83e9-08db5c2d508a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kRWr2qY5NV5tm2HCAGe5H/WDSKjzrxwG7+6Bl+1+qzXiQwUdzLrfNaBEFrqdipAuvyoc0GMgq5WpO2MfKGtnN2M5HOpv5ChUetionqL/ctKc8D/Z2sZN1KuGH3L/ymxf/xz8Px86PCy1aoe3LIX9qpbhlCVw5TU62CrLDOmCOBRR/4p80N1RQ/SB3vhkx/bJcyklmwUoQQ34uS6HuDWDSqG3Of1vw9GzKNljBzDGjAKXpnQ/wEBotMomyuum2Vfw7wArdlmpYzzR8a9WBcQ6tzJQVR/6T9uSf0wU+V2awf/eZOSA5mqrA6T00iP5921x9hef6QOjAIVOWujS7aLyu3k4ajUb7UqWONX80ea5lnSWyqzHY2MJNclojYCdluHZ7Lhx2jZIxjzNj5SEIs3cWqOU/xFpbN9aCh8/kzZr4iiW+K/Z79pVc38Bji+6xyQxphDv4zFVKlAl/6Z9JEHaI2a7mSYrcKLSY2jakg67BBgOBcjEodHzdYPK2NeF3XDR7IHAMO2xsr0IxQWZeop/24R8EMtCHDXo++ITk2oEQsIOzLJ5GrNjocmh3uRXqUpAu0KODwiW1YUcYXYOXe6QYm3UdQAX6wOhseDcrAE4Hmbx9+SRVEAp17GuAYUGan9B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(38070700005)(9686003)(26005)(6512007)(6506007)(86362001)(186003)(2906002)(5660300002)(38100700002)(122000001)(82960400001)(8676002)(8936002)(4744005)(478600001)(6486002)(66946007)(41300700001)(4326008)(6916009)(66556008)(316002)(66446008)(64756008)(66476007)(91956017)(76116006)(54906003)(71200400001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RGxoDrhtGZ+QgGfAF4U3obsy58HrxAWGVvYY/xbgd+A2Y6IjwfUNHoHvu6NB?=
 =?us-ascii?Q?pSiVlTuQrds/kiEKKzw/ybKNwdsNXTgwJoI4WwnZ/oT7iOdNV3gXejBuowTn?=
 =?us-ascii?Q?R/686qqkrFkstUdp9xz7a120T5/cECDlf/LXWvqaGzfQRX4HcakGPJ+Bp5p9?=
 =?us-ascii?Q?ryoABSsUIfAmun6P48vu4v5AaL9/9f6NbIBpQvGGIzy89xDkqvzf0fXMn/73?=
 =?us-ascii?Q?RlhJylbcLsiAb71Nw81iccEMvcZOTD6NWrX+ry1e73jmg8BkQmPjyd8yP/R9?=
 =?us-ascii?Q?78OCd5e+C98D1n5QeHmHTJucVQLU42IOR/zMkLMEKMd0KJNCb4ViF2WA/OJi?=
 =?us-ascii?Q?ywEOO9UHWz082/a8rTXjBMbLtyYyuICIoQbBSG4PgH/lOCS2sLGUPpS+Ey9r?=
 =?us-ascii?Q?Ii3otVT0EHUUL/AZE9SfSvxgw5JbgIYzz/HgxxXOJjllagbjl7QKSytHClkQ?=
 =?us-ascii?Q?L7VqiwsPkBXLcz0xgPX5d6Rj57yvTkrlWKVylZt7qK/Qmnj0nodagfk+YbJb?=
 =?us-ascii?Q?oI494//RmOsURNImFC6imdn5AyWc9iAIWEJsjEUGv2+t++hjzElfUS5wNW5K?=
 =?us-ascii?Q?3PIqo9UxL52lWKR5FZFYdGSb5fTLbNhfIcSo95ikDYs5iJNxY6vLCu1BMGxD?=
 =?us-ascii?Q?Nz6Fbe+MEMOTpxC3fDPCjlVzTyAPJDrHhfmI7cqj664ABVYiyLJ/I/zQK/C/?=
 =?us-ascii?Q?gdHSAAe+6EF5WmRxP6yz8Ou0xefHuhQHAETx3mpB5mNXiAA1dKmBefGc4+Lt?=
 =?us-ascii?Q?MQ0rZOtP21dkwjaOjbr7TGpwEvaKWXgVnR8a2qOE66nqcO2gPlTXQnxlnTyj?=
 =?us-ascii?Q?0cafBYXQEpwhrNVVU/PYoRN43nteapJUNLw1bPAx0FSA+Lb5p4GL577Rkoa0?=
 =?us-ascii?Q?xPsxyFjgUpLPrt7ETaXpFnTISPf1h0o3oCysFwcqaBeqSHu8miSV+XFWwjPx?=
 =?us-ascii?Q?TJ5j53ZQ3N5WgUpK8xJlpWwxknwaG4QC0DZ3eXSSiw8cUXCQEDDG7QvHlgbX?=
 =?us-ascii?Q?FwiiV6lu+nLbBLwrIRpOes400gT19jzRVUAeO4DBxtjXwJfD9hgkfAinFqO4?=
 =?us-ascii?Q?DqOFrqR+pg13ZTFtOq5cfeXwntgPnXDGBtD9ssoJu8Zor95Y1gpnOwR15Gny?=
 =?us-ascii?Q?fdq6PtDjVm546s/LtYaEqd2LKuqf5I5L7IiDiprFXxj4BHH30pKLadXzUixQ?=
 =?us-ascii?Q?LNPjucMpuBKnnSsRtZgyfO276bGaXx+9JwnvknnCyE/FVRuovIvwCMZmeu3I?=
 =?us-ascii?Q?efu8hM6nRklPhY0XJZBhMdKrmf1mccdOkUNG7yPTA8SQYQwC3nEFQQ1xJGgJ?=
 =?us-ascii?Q?RNOnspWl30tkSuzjgixG0/TExs47/LhGnpCcPpbMx83yd72CM15PRWW8EOsa?=
 =?us-ascii?Q?immcg1B9cRwh0Tux2sAOOnFUlsP9UrUbBsQlNbDeH7FSgPsOw56HGBTCFRFO?=
 =?us-ascii?Q?77cjCSBtqxdAIk+gc+7CLpP/IK+47FQolxUe+BOfc7ziEUMCZY4T5tVQw2Kc?=
 =?us-ascii?Q?CFiq8a+rOX0QdVwkONbgi4WKvuKA26znFZ1Tw28iduMylJ2F3OlncsXUONHh?=
 =?us-ascii?Q?P5GLyNvYLOrCn4NaD8lh7GJWIVK8idd4p6Zz34aloW7VdKv5X7rUc0S949T/?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C85755C6D9A9E42937F8A43DA67BF1F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nn6n5Phn0KhUBPzQnvGT9oBLSQdRHcKcV8eIfroMswHSSn/qfrGxdTvt/+1jdRo1DzbjrPPtcGhehpDzijgraTD/+fIY3B6OcF+cCaJSXUk+DCxvTXY1nWRSjNVpqTdb+DKZKyR17i5Pay2TmtcgEyk+OISr8aqZvj5mjJd7Xh3pHyNcd22ua0tOGLO0eXzcAviodUV6DmOSISLsZl1Ir3GpkLeIjyfl+mfrpjsbOkCXVzOxtJ8svrenoMZxSJK3hDqc+DOz+nVAKHc9japDr4TD2kDXLFsCuacXKVMWrEabFE7eDoNV+zpBrBi2ioCh0XAyBRxwVfcLJfvU+KFx0pV75GHpunahiPRA/u1eVgh54miQUw0WmRcMrgma1/FxyPz1vRxKRss3ipPau+gudxMZAHoaKwZ4rjwSPZU6A6ZI6MwEv4nB8bE/tP6CseFWSBaX/2b9ru9v3/5BQEpwd4J8LlIkuwI2/XCLfeJn0+gdi4c9s4ftdHIe7SYcap4cDAdOcp5FVgRbckfCts5wo6p8uCsSiTJnnVjUIlTZNg8nBYU/hM3XxDKqh8QVyAv9rhru5OEAjmiglm2WrWvPDPNdSLzVsWgjoa43ppU03AY8RndjNpKXz2M6UtGz5DmSYlN3fTf+udHQ5Ph/hKQNBleZih0PwGznKpb8EEbX5YxWJuywl+2GK4vINp6SMTP5zYPMcRi6uUBO/ekeY7Io0eS2tk6bUq99LS72jc49tTV7oUZfTyU5WrBQWvtckx9UMe4OsN0aAKuYRF3nwAk7uoIP6Ex3p54NSAqGYnLA7fvNDUc+U7bPCsTmRz8QaJvHBnAD+FgMSTmUrBWFuCu8Vg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141037fa-4e77-47c7-83e9-08db5c2d508a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 08:03:09.7432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35pXFUNPN6S8BePzW+Qq+EqUc8Xu7+R4fIJtyhVU8I29SlKsLD/x0p35hSt0S6GUiVy/YPUD0SMnhPT+zGoYzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8355
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 04:47:01PM +0900, Damien Le Moal wrote:
> Add missing description of the spg argument of ata_msense_control().
>=20
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page=
 translation")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 69fc0d2c2123..40d6703e2d07 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3850,6 +3850,7 @@ static unsigned int ata_mselect_control_ata_feature=
(struct ata_queued_cmd *qc,
>  /**
>   *	ata_mselect_control - Simulate MODE SELECT for control page
>   *	@qc: Storage for translated ATA taskfile
> + *	@spg: target sub-page of the control page
>   *	@buf: input buffer
>   *	@len: number of valid bytes in the input buffer
>   *	@fp: out parameter for the failed field on error
> --=20
> 2.40.1
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
