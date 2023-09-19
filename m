Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FD8CD5BB9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 13:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjISNVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 09:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjISNVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 09:21:46 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31591F4;
        Tue, 19 Sep 2023 06:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695129700; x=1726665700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5Ern5EYegb8PCzuFFoTo/Qtf8FaK9pMYRtpE5IkagVw=;
  b=k/spIvQ5zbU0fxADDtvS8g9MjHXv8BSROskDPrLepfWg5YwQfzHn2jdz
   8E0ehMyCHZqYB3mm+vgxNJybHOtXLkdexM/ce/YCRNl4GjcCPjVWAp6cD
   YsYUIve+Ep5fOrIwCuYjtFL7pYqqAY43ZG0j6IaN82K2XBzAyctif9jlf
   gjaH13NhletbpHTM8OXmi3bN060whueItp3lTsLIYaLe72IBi6JsoMBGi
   y2WhGwCoGKjfKyM4iUO+9rRZQS3krbuZRXEOecyhnQUviMEQMXuh7Iyi7
   Vb6DoFHbOFV0fd5OzGG67fbKFS4BtICqxbuFwhfDJGuYkfj+HpxvLkn8L
   Q==;
X-CSE-ConnectionGUID: 1Q3Mu+fBQ7mCWO26jXINog==
X-CSE-MsgGUID: m2dydkGHRGyORG+kqJ6aBg==
X-IronPort-AV: E=Sophos;i="6.02,159,1688400000"; 
   d="scan'208";a="356416922"
Received: from mail-sn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 21:21:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYlJX7L6DkhFZ8nCpf9em03yeJeagZkh57Enxul/bB7szrnSMIFyuz/VTAUfI+vos6ZzEB69zRwUZRn+iztLuhLHRB9P6DIUHGSJzdujH9qbT8Mu+C/J9vGE7ScayNqDBaXtcYQPCAebUX3Qy3WgYlPNxWg+dfSXYpxtWuwnhmiIbEVTlF3n+yrHMXm6P1iGEux1iAD7nlSu9KuhaF/xMDNRXYt9dcUIP2JofRtXo+ygvZMvQccpBFAAPLZSLe0JKzwoi7Bmke79n5ZJtJI+k+PGxPDpDxWYmalx1PpcxLq+6GxwAGGFVTRyq9rbYpiOJnMsXDZV6Km7lJOGWVb6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjSOreRHbVndGegbOxUdlq4heKikFSeb9KCsWnx6sHI=;
 b=VU6LNcHRlmLa0UJru6RtOyK/egsgYuIAveeWbC+2nRmcjVTQcArBAvcujOf1wbPYeHS4IXNMIhgs8BR4UfudsnGzPnL/gt2xb7MUGZLwZcST7D25KniXYhOp3HNkoAYIQkk9Ra+atJVPEfa181X0LLCGDmGMNewGlwmfCz/AGT7O0rjwQPfn+XRGz7Rw/VM7/zd2WJZ3kPdG99PqqiH+j6L5mOd+oTWaDikDyhCmPKKuCsFyiOk0WG5nA/gEN/zvoSzdLBuRxjvQpCVvmTW4N9Bm1SM1orZA9jtzqqZU6y9ALWj4SN5ZqXIa9j/jmSZPcn6cNpnUq4G62PzrAvnAAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjSOreRHbVndGegbOxUdlq4heKikFSeb9KCsWnx6sHI=;
 b=pD4nxgADcMl+BrfTKQKQbSiZTHkDm0gkqtt7oW6a+uBkFUJm7ENc/zRhilfTB/wKxiicFeTxxwQa6AsiUire7bAgQ1snjnxSjojv6YF1EEBGKgEZoPrVWEyz1uuK+w+eQdCO5URJk2QcaRISXT9jeEPbWIS7tWjGVZuDJLMt06Q=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Tue, 19 Sep
 2023 13:21:31 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Tue, 19 Sep 2023
 13:21:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v3 03/23] ata: libata-scsi: link ata port and scsi device
Thread-Topic: [PATCH v3 03/23] ata: libata-scsi: link ata port and scsi device
Thread-Index: AQHZ6vw0AhT5k3s04UyP3kHnOdDdAg==
Date:   Tue, 19 Sep 2023 13:21:31 +0000
Message-ID: <ZQmgU/j8OD8t4KLs@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-4-dlemoal@kernel.org>
In-Reply-To: <20230915081507.761711-4-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7779:EE_
x-ms-office365-filtering-correlation-id: cc0f217e-e93e-428b-7682-08dbb91356ae
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x3yKxl83jlueXnZ5IVWaD7rUgzDJoz7UVaZfWmCZeTdNkPkQssGBJwh1T4RzqH0U9B80R0/xDTRPk10UIZbrHt5GQ7VNCKsFK7owWac/l9C9eLS5568DrzLVpv+ZsbB68wf7jUsphvYG0LnUdxwqvxRkSa1LGq/2RxCHS58VuGmX64BhbLKdd6q4yESwbqkb/XB90EzQ+kTwiuaiL4JK76+vXDLFTp9tZyuiuN/xVN7TwuKrI/pjMJVNQqsF32iktMjv6rN/CVO9NSkGmSmFHArc3e+24PO34yJUaiKGvV0fMwZ2pnUJ8+SocdgPgAG/N82flvRveBcfmbPnSGHG+fmz5BXXHQYL7EKvIXFdxAD+BFB+6maEIzJF90dOk1WFgTfSREftCYwqKP3qG+U6I/rdyJ/qbFwkCeF2mybL7lsTudkBz0EUFMDhNdxBg5Zy5tm1fs9mskLsuPbQ28CvkC/rKtMSdVFLwirbPMoYSpEKhFKknG/qSXJQ9czGsO6ltwz+gOr1VREtii06iR7dohf/ykksXU0TYNvN6GDhJZvBGqW8+yx+bLmkFqVpKBZmRpq+LVqnlwhdHSjPjPCJ56xgD21iyYqHrFI3F9MWWzJRBYqZZ+fysNOvEaHk8yjW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199024)(1800799009)(186009)(83380400001)(71200400001)(478600001)(86362001)(26005)(2906002)(7416002)(6486002)(6506007)(9686003)(6512007)(82960400001)(8676002)(76116006)(6916009)(316002)(66946007)(66556008)(41300700001)(64756008)(66476007)(66446008)(54906003)(33716001)(4326008)(122000001)(91956017)(5660300002)(38100700002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GMcjzqpVGI9XbhuKvfdJXTe/WSKalAnVRCx3uFmmMMALQtUna21SBhf0toYi?=
 =?us-ascii?Q?j9xkZVamHZw7LU154EmW5HDoup5e3iAezNFlkLj90U3r5Ha4D/itwpCyjFfJ?=
 =?us-ascii?Q?SpaVJ6MV0w2hd58VkrLHkmfq7S3P8Q0nSTGqUtqfEGyBLGfOIS6waaus5yIb?=
 =?us-ascii?Q?vP2AWI59Hz7zEJQAQA1m+1vr7ErmFb96jUKt+iGLJG4wAs228FNO0gQhxb1D?=
 =?us-ascii?Q?OSu1dbH0OEdyIS+KazKaxn8855eC79eAr04t40EnQcPnc4DzILWplv3NdrJS?=
 =?us-ascii?Q?h0e14R8QNu2gNRrcK8lH2UlyQ3j0Kc5W1yHNnFBxchIciwCop4lUndqyIKQu?=
 =?us-ascii?Q?ZFA9Bw6YKlQX7Ih+2gORC77RfPqFsUGzQYf6kkojt6TVzgFWofogXWkoubdt?=
 =?us-ascii?Q?j0XHmlG1JQflgOHSIpQy9MZVwtS1kQp7NlnUNxCirQlbv3gQhyi2GX+aLGrU?=
 =?us-ascii?Q?8DJvgBJthGZN6wJv+WdrNhBjBWsSJQfSuzdvd2ac/BVn+EFdKk942WlXuuSC?=
 =?us-ascii?Q?BVGjnfFVH4lF1fAnBmqaF2GEsnJsQ+myWq/eVPUH58U44qA6pGfhAViE3md5?=
 =?us-ascii?Q?wcjMlUXFmJqh/pg/DENM86URzlitHN42W96KDD9Sbu9nrsibV2ZvRjuiMMfc?=
 =?us-ascii?Q?+JImJpMRJjCv9akqNgRSPcnww6Khc57aHNoXKdyzORrwuvgFniAke2jD5rUM?=
 =?us-ascii?Q?KxsPNugyXY3G8zrrKb3IsoKkodkPJti22dr9mS+PL25bqdcD3m7MWpz3aVx8?=
 =?us-ascii?Q?MKraFqvI6EHg0EBsO3PpTtYr9Wkn4/vwywM8Io06o6eUo7TwmRSjDa8p8ZOE?=
 =?us-ascii?Q?S7UO7QhLrfTphZKXqLLdAx17I0vncv6sibdFph8SoSkTMwgGp0w6mdci9v1t?=
 =?us-ascii?Q?dFgq8fcAFgH8+mGRogUQ1xl8UhJnVZIkN8z2/RYNtmtFKjhev6h08WpOAwoG?=
 =?us-ascii?Q?AbQS93buVCurtBIEts0w9iDKiDoTo179BiDUiWTsUTSljmEKrHM0/1KmcgHD?=
 =?us-ascii?Q?sel/1CydiC8RxkIijU1zWsERw0ucKDHZiesqKOHfp/1pNFxRwvp9wHjU0Kge?=
 =?us-ascii?Q?EG21VlD2bCi+SjkGlqew0Pm7oG/KcU5fQZM0Yl3zo2SInA92zzVE4q8EAFDV?=
 =?us-ascii?Q?MoWW99H7QZ5/j3I1zW866t9JEGxsvjQUH4/FGBdWZSpWdGk7Lj8EQXcctjHW?=
 =?us-ascii?Q?6wkCT1g+Oj4ERfluMpkwAFRbhqAVOxpGpmCOcb+4RGW3j/pyE4C/CYm2b9OV?=
 =?us-ascii?Q?ysj/VeItpxQVkCIRoTN9ASLMadwEn3bGSQ3dmEGP7NbpJIS9PAbAD+s002CR?=
 =?us-ascii?Q?3A+Wy8ua0q9zoDXTYAhsVpMcllRjwcDrmwDvaf1fIGf7aNxKt89AsC99uw1b?=
 =?us-ascii?Q?MEMik1SPUgHj5cmCtQh1d7uinhI+CU6eZcjMa2gVayiU/JNFcY/352TzTLHc?=
 =?us-ascii?Q?z2f7CI1QqpyQhAJsjegRPJr1JMzNJv7wYp4tV1n2mhBVF3phLHZZ5R/1Wg6I?=
 =?us-ascii?Q?o0Oa4xbXLAuEKpFd1KN6bCKsjVuzpCglgjC3T/lPwqubPOwwS841TofqAKDg?=
 =?us-ascii?Q?Vxi5ZPMdyLc0QX3CibEpm5g9e62rQ6vtIVMRXu0nvR+tFYBPqzomO8rWM8H+?=
 =?us-ascii?Q?rQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <531CB04D47E28C4BB3F42C16560C37D5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?IEy0UhjL8qOnW6ITXfvGeJETAVMZ8MxMJ1dHiAGmpUYWzdJn6lqY+KNKuTzH?=
 =?us-ascii?Q?Ujox15xvBL4P5a1PCUeFbLNqFYXctbdnMriGACL46e9an5u6FDSjZ6tgJ5UD?=
 =?us-ascii?Q?x8ZSg0NU29unttLZGvfTlbu9LP3xs8in4JFiYKgs86E8NRS10HaTAI8OTIIY?=
 =?us-ascii?Q?s9OJIjNbfvIEfvNLOopP6RsAy/D02wT6GCId/P4YY+WdSS1ZKjf0cGG96NXc?=
 =?us-ascii?Q?gK/bfl5Rv3SlUjxHd/km5hTmPFNmaqJ62QjLsty+GMekupXV0EURMxt+mgy1?=
 =?us-ascii?Q?0/G4OYSFSupT6yC9A9+HWkvHTP/T0BgXgNZUFlwAxXkqP1rQISMqpYCRI48F?=
 =?us-ascii?Q?I03PRnEHqU72Ks5I7FYj4Fy0JASneKhDvdind9ZVqQcxYE641eV9vrTubu7H?=
 =?us-ascii?Q?cCZWe7nvNXACitLDWvmxC1t6y9Jy7OyO1a2OgOA2Xbdbzn65Ea3xN2vPrmEG?=
 =?us-ascii?Q?iD/8gHJXvDRzqsPtosln9oQPfzxneu867+TBnSSn4lCR7H9Ni1u5ZR3wo6jN?=
 =?us-ascii?Q?x9eOV4MY3nwfcqkhMwAh2QONLZ1Z6Ag/vgWacni39+AYAscDYDQSS7mRNYHp?=
 =?us-ascii?Q?EfkqMTPCaYliaeynftXQfWeBm1L/NGjMbVwxpGl8UJBiY2NSMGPWG4ZQjZr7?=
 =?us-ascii?Q?aCcgh7IIenmAhvbbltWBsUQznJc+q/ylRON3+49nUHaivbO64/8ifpaORRtX?=
 =?us-ascii?Q?ZzUl/mJjI3gLRTUlKRaIT49YQVug4e/Wd3CaV2PX5FXHSCABLEP4aQFVYQJE?=
 =?us-ascii?Q?ML34/xvTwdmujGdoJ14/5K4CaYKZ9b8uQmtjNa7Smp8xUjQanciorMlTM7oM?=
 =?us-ascii?Q?vvgMmQ3zKFJO5TLlwJU2lCrbJxN/rofkK59WYZeqqTSKU8fiJaXGqzk97Q3K?=
 =?us-ascii?Q?vB6r38p7Ziu8mY3HaNwqxT6bFfJ+Y20Qa5Ubkmy1AzxJttIvT8Nsgg8zma2n?=
 =?us-ascii?Q?nq+ngQLzGhWdtaiftfWo8R+2I4EOvH7ouoxxqCQed+omUpfOLIdwu4yZ/29V?=
 =?us-ascii?Q?2cz+?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0f217e-e93e-428b-7682-08dbb91356ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 13:21:31.2166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVz9YPOp1syQNVYlE6Sne+YvVfStA5eGNCInYwce/qx/rlyZm7snqgEWwyIeK6xXC5q6kyNVeNjDdR53geUYzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 05:14:47PM +0900, Damien Le Moal wrote:
> There is no direct device ancestry defined between an ata_device and
> its scsi device which prevents the power management code from correctly
> ordering suspend and resume operations. Create such ancestry with the
> ata device as the parent to ensure that the scsi device (child) is
> suspended before the ata device and that resume handles the ata device
> before the scsi device.
>=20
> The parent-child (supplier-consumer) relationship is established between
> the ata_port (parent) and the scsi device (child) with the function
> device_add_link(). The parent used is not the ata_device as the PM
> operations are defined per port and the status of all devices connected
> through that port is controlled from the port operations.
>=20
> The device link is established with the new function
> ata_scsi_dev_alloc(). This function is used to define the ->slave_alloc
> callback of the scsi host template of most drivers.
>=20
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for =
async power management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/ahci.h        |  1 +
>  drivers/ata/libata-scsi.c | 49 +++++++++++++++++++++++++++++++++++----
>  drivers/ata/libata.h      |  1 +
>  drivers/ata/pata_macio.c  |  1 +
>  drivers/ata/sata_mv.c     |  1 +
>  drivers/ata/sata_nv.c     |  2 ++
>  drivers/ata/sata_sil24.c  |  1 +
>  include/linux/libata.h    |  3 +++
>  8 files changed, 54 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 4bae95b06ae3..72085756f4ba 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -398,6 +398,7 @@ extern const struct attribute_group *ahci_sdev_groups=
[];
>  	.sdev_groups		=3D ahci_sdev_groups,			\
>  	.change_queue_depth     =3D ata_scsi_change_queue_depth,		\
>  	.tag_alloc_policy       =3D BLK_TAG_ALLOC_RR,             	\
> +	.slave_alloc		=3D ata_scsi_slave_alloc,			\
>  	.slave_configure        =3D ata_scsi_slave_config
> =20
>  extern struct ata_port_operations ahci_ops;
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d3f28b82c97b..eef76af1af90 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1089,6 +1089,46 @@ int ata_scsi_dev_config(struct scsi_device *sdev, =
struct ata_device *dev)
>  	return 0;
>  }
> =20
> +int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap)
> +{
> +	struct device_link *link;
> +
> +	ata_scsi_sdev_config(sdev);
> +
> +	/*
> +	 * Create a link from the ata_port device to the scsi device to ensure
> +	 * that PM does suspend/resume in the correct order: the scsi device is
> +	 * consumer (child) and the ata port the supplier (parent).
> +	 */
> +	link =3D device_link_add(&sdev->sdev_gendev, &ap->tdev,
> +			       DL_FLAG_STATELESS |
> +			       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
> +	if (!link) {
> +		ata_port_err(ap, "Failed to create link to scsi device %s\n",
> +			     dev_name(&sdev->sdev_gendev));
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + *	ata_scsi_slave_alloc - Early setup of SCSI device
> + *	@sdev: SCSI device to examine
> + *
> + *	This is called from scsi_alloc_sdev() when the scsi device
> + *	associated with an ATA device is scanned on a port.
> + *
> + *	LOCKING:
> + *	Defined by SCSI layer.  We don't really care.
> + */
> +
> +int ata_scsi_slave_alloc(struct scsi_device *sdev)
> +{
> +	return ata_scsi_dev_alloc(sdev, ata_shost_to_port(sdev->host));
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
> +
>  /**
>   *	ata_scsi_slave_config - Set SCSI device attributes
>   *	@sdev: SCSI device to examine
> @@ -1105,14 +1145,11 @@ int ata_scsi_slave_config(struct scsi_device *sde=
v)
>  {
>  	struct ata_port *ap =3D ata_shost_to_port(sdev->host);
>  	struct ata_device *dev =3D __ata_scsi_find_dev(ap, sdev);
> -	int rc =3D 0;
> -
> -	ata_scsi_sdev_config(sdev);
> =20
>  	if (dev)
> -		rc =3D ata_scsi_dev_config(sdev, dev);
> +		return ata_scsi_dev_config(sdev, dev);
> =20
> -	return rc;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
> =20
> @@ -1136,6 +1173,8 @@ void ata_scsi_slave_destroy(struct scsi_device *sde=
v)
>  	unsigned long flags;
>  	struct ata_device *dev;
> =20
> +	device_link_remove(&sdev->sdev_gendev, &ap->tdev);
> +
>  	spin_lock_irqsave(ap->lock, flags);
>  	dev =3D __ata_scsi_find_dev(ap, sdev);
>  	if (dev && dev->sdev) {
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 6e7d352803bd..079981e7156a 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -111,6 +111,7 @@ extern struct ata_device *ata_scsi_find_dev(struct at=
a_port *ap,
>  extern int ata_scsi_add_hosts(struct ata_host *host,
>  			      const struct scsi_host_template *sht);
>  extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
> +extern int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port =
*ap);
>  extern int ata_scsi_offline_dev(struct ata_device *dev);
>  extern bool ata_scsi_sense_is_valid(u8 sk, u8 asc, u8 ascq);
>  extern void ata_scsi_set_sense(struct ata_device *dev,
> diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
> index 17f6ccee53c7..32968b4cf8e4 100644
> --- a/drivers/ata/pata_macio.c
> +++ b/drivers/ata/pata_macio.c
> @@ -918,6 +918,7 @@ static const struct scsi_host_template pata_macio_sht=
 =3D {
>  	 * use 64K minus 256
>  	 */
>  	.max_segment_size	=3D MAX_DBDMA_SEG,
> +	.slave_alloc		=3D ata_scsi_slave_alloc,
>  	.slave_configure	=3D pata_macio_slave_config,
>  	.sdev_groups		=3D ata_common_sdev_groups,
>  	.can_queue		=3D ATA_DEF_QUEUE,
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index d105db5c7d81..353ac7b2f14a 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -673,6 +673,7 @@ static const struct scsi_host_template mv6_sht =3D {
>  	.sdev_groups		=3D ata_ncq_sdev_groups,
>  	.change_queue_depth	=3D ata_scsi_change_queue_depth,
>  	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,
> +	.slave_alloc		=3D ata_scsi_slave_alloc,

It seems wrong to add .slave_alloc to all different ata_port_operations str=
ucts.
The .slave_configure is added on all different ata_port_operations structs,
because the callback can be different for different drivers.

However, adding the device link is done in .ata_scsi_slave_alloc,
removing the device link is done in .ata_scsi_slave_destroy.

Thus, I suggest that we only add the
.slave_alloc =3D ata_scsi_slave_alloc,

to __ATA_BASE_SHT() in libata.h, which is currently the only
place which has .slave_destroy defined.

All the other port operations inherit from __ATA_BASE_SHT().


>  	.slave_configure	=3D ata_scsi_slave_config
>  };
> =20
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 0a0cee755bde..5428dc2ec5e3 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -380,6 +380,7 @@ static const struct scsi_host_template nv_adma_sht =
=3D {
>  	.can_queue		=3D NV_ADMA_MAX_CPBS,
>  	.sg_tablesize		=3D NV_ADMA_SGTBL_TOTAL_LEN,
>  	.dma_boundary		=3D NV_ADMA_DMA_BOUNDARY,
> +	.slave_alloc		=3D ata_scsi_slave_alloc,
>  	.slave_configure	=3D nv_adma_slave_config,
>  	.sdev_groups		=3D ata_ncq_sdev_groups,
>  	.change_queue_depth     =3D ata_scsi_change_queue_depth,
> @@ -391,6 +392,7 @@ static const struct scsi_host_template nv_swncq_sht =
=3D {
>  	.can_queue		=3D ATA_MAX_QUEUE - 1,
>  	.sg_tablesize		=3D LIBATA_MAX_PRD,
>  	.dma_boundary		=3D ATA_DMA_BOUNDARY,
> +	.slave_alloc		=3D ata_scsi_slave_alloc,
>  	.slave_configure	=3D nv_swncq_slave_config,
>  	.sdev_groups		=3D ata_ncq_sdev_groups,
>  	.change_queue_depth     =3D ata_scsi_change_queue_depth,
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 142e70bfc498..e0b1b3625031 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -381,6 +381,7 @@ static const struct scsi_host_template sil24_sht =3D =
{
>  	.tag_alloc_policy	=3D BLK_TAG_ALLOC_FIFO,
>  	.sdev_groups		=3D ata_ncq_sdev_groups,
>  	.change_queue_depth	=3D ata_scsi_change_queue_depth,
> +	.slave_alloc		=3D ata_scsi_slave_alloc,
>  	.slave_configure	=3D ata_scsi_slave_config
>  };
> =20
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 52d58b13e5ee..c8cfea386c16 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1144,6 +1144,7 @@ extern int ata_std_bios_param(struct scsi_device *s=
dev,
>  			      struct block_device *bdev,
>  			      sector_t capacity, int geom[]);
>  extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
> +extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
>  extern int ata_scsi_slave_config(struct scsi_device *sdev);
>  extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>  extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
> @@ -1401,12 +1402,14 @@ extern const struct attribute_group *ata_common_s=
dev_groups[];
>  	__ATA_BASE_SHT(drv_name),				\
>  	.can_queue		=3D ATA_DEF_QUEUE,		\
>  	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,		\
> +	.slave_alloc		=3D ata_scsi_slave_alloc,		\
>  	.slave_configure	=3D ata_scsi_slave_config
> =20
>  #define ATA_SUBBASE_SHT_QD(drv_name, drv_qd)			\
>  	__ATA_BASE_SHT(drv_name),				\
>  	.can_queue		=3D drv_qd,			\
>  	.tag_alloc_policy	=3D BLK_TAG_ALLOC_RR,		\
> +	.slave_alloc		=3D ata_scsi_slave_alloc,		\
>  	.slave_configure	=3D ata_scsi_slave_config
> =20
>  #define ATA_BASE_SHT(drv_name)					\
> --=20
> 2.41.0
> =
