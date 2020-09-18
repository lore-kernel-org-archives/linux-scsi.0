Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD3FC43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E04208C3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 00:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IlDfr4U1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zVgWPwp8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgIRAgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 20:36:53 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36686 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIRAgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 20:36:53 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 20:36:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600389412; x=1631925412;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Y6OuaScCalgDOhVEPFHy/SopjIAVDngRCZKAiK385Q0=;
  b=IlDfr4U1lz42vQVpRbRAXN25DhYqJgS2LU8D+M8cEIugVpIrFw5RDXQ2
   5IRwHCweqpkvJCLkDE8hcK+Q6BIqQrrxeeEzJZ9MeJyODEnQcrDfAJeE5
   mtHXllrLSZSv8mSaV20UOJSQNw8HizvaYrX5N/DnakMqNKFdbq3N9op0x
   VKbZZ1Lbe9TvBDOEgKhasKIyxRZlwPJ53H+RmAM4RG8oN0PwnEWg0Idlz
   34pVHv25iiYTWZ46C6caRAhyCK5Yw6QwkyIs04AQxUtdRNgBCOzacirJv
   r5zjSw8LUn0/gV9NBISo7q5x5okdmRJoaFzVINhzexaL30Y7tSYwrZo3c
   Q==;
IronPort-SDR: eZiY04dOPVnzTIz5PfqepPq6tqWlN3sbAaw6pe28gPsXxDncGBwCZburtdfc4xtwtCvjgQsNLL
 c1KHZpbX3XXDgCazUaLHAZgmQu8QPuNzAXtdLBvyuLGQsH4nhG1QdC5SLK28dx1PTIjltfEDGK
 1S+qDyQP7ycswO/uBG0W5OumM4vjBcfd+jXweAlWDCawsxAGKixhThsk13GxxuoApqkgqf6dwk
 HdHMfmYSmohIW+HWFJzRH7k04xq7QTcSZq1Rq0q924MPp+02jy50qoHbL3rRzDBoB2+7irdu0n
 57k=
X-IronPort-AV: E=Sophos;i="5.77,272,1596470400"; 
   d="scan'208";a="152045569"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 08:36:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEDyEXXBCWu37VZ8jeHP/DeWP7m2HmW9XV1QW5yqSYP21fUoWS14qN3FCzJtTj5TVtPYReQSdCrj3bYaZ7SQ2EhK61OTpJaPxTFRGliuV0IuyOe5m+OdzQHmuIrgrLF9VS6g/NqwzpS0RlY/7slAr43/cDluqQFsrqkNoDvgP/xmRkROJHJU4z3qya3N3MjHEBwpbgTESWg+uZZl6YEzUCCuWBpkVluraovmlUPSQK4CSFBzMHg/fyLj64D1KdWzvzNmPlwCeZ3z/appA37InkXerxbEw9hRbxPq1rpMPvt+y3N6AyXdLqRJ7WatzmSGBh1OPQDQCNOAeMl+jKriSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbl1dDdPLJRrAI1oqPsbzUWCLMeCh4qrAP/OTYIGdsU=;
 b=N1L+fPPdnhHqXhBOhs/3QdngHjvtVpUrp5gNiVjrt05FaD5UYQ9mek7OIwo2dSFwmcAOANdwA0sfmVWRqq6f1yDU+nSOQ8TX3eKVAGM7PDo3FwEuOYalcSPbnDNfenjP7I3L+V3kVIJVkv3vj7J/ZdA3G83JuRF4qW5KbtJjtxLVGU1kxM2l2ATI/zE7r1l9dKGOQ4yvfSLiHZx7CLr2pIxFUhPiNSkaT2fO4iEN38EB8At1LgIMSSRZFgwTDbo30YLBpqh9chP2wCgYger1/A4eMJSD3ZZwtdqly8K1mrYsdm2VcYZSvHmjWY173KCe+BCdOp78oY8fS80d2BZHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbl1dDdPLJRrAI1oqPsbzUWCLMeCh4qrAP/OTYIGdsU=;
 b=zVgWPwp8d5bQv/8XwOv6Vbj8cnJ3s9MIq8L3oFt8/uqGC78+dzOruLzJOgKiW0El9jVb96IOFwbNQ43A/kCmlmnTVmfUaLw+shiaKRKVx7i/ePLZLpBBWqNBL6zUBUrOsRykFuafPqjzB/0+HCDTwm2UhYtFrB7+ObUTgK3uyMc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0760.namprd04.prod.outlook.com (2603:10b6:903:ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 00:36:47 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 00:36:47 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Keith Busch <kbusch@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 3/4] scsi: update additional sense codes list
Thread-Topic: [PATCHv3 3/4] scsi: update additional sense codes list
Thread-Index: AQHWjUjrB71b/C2wiUeMv81rykPlUg==
Date:   Fri, 18 Sep 2020 00:36:47 +0000
Message-ID: <CY4PR04MB3751B7F869D2038BC3106AD9E73F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
 <20200917231841.4029747-4-kbusch@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:c162:b6b0:12c6:8cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00b8ab22-3be5-47ff-e53d-08d85b6aed12
x-ms-traffictypediagnostic: CY4PR04MB0760:
x-microsoft-antispam-prvs: <CY4PR04MB0760E821FBA9B652C2422F9AE73F0@CY4PR04MB0760.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eo4XqbgJhvbsPI/59FsPzgwsOZjeLchk4AimEseN2BdmGyVtBve6Vt1hhLr0M+8zsKQJOgtjLjJzrt4/b9SdBvUXMZiQqhCHbGz/mP7yB7Nbxk7PvS2cyGmFFmTKOfND6YOdwuPEYwJrEs4ahkWyEzBMU3exOKd3+FDBbFA5qbTnFkfZquc0OBI72+8rutLUlW/PXaNyUfYa5tCPdS7o4GfwDH1MM3VdCJwsVIo/Kan/WBdRRyXrT9hKZ1WnXYWuhC/H4hCPxbY/FaLfsX5GQ0Qjhhn/NUUCyBElAkGyabg6SD2yHNNMq/OgEp7L9EESTBVkY1Q7iQnQjoapXEyUScpBLNO0vdMmAieA3N1Bc1PGk9p70mbOiu6zzIwsrLbU4Ttk4/EA/ukFxvCP/PjYug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(66556008)(91956017)(76116006)(66476007)(64756008)(15650500001)(66446008)(966005)(54906003)(316002)(33656002)(186003)(478600001)(8936002)(110136005)(4326008)(7696005)(86362001)(83380400001)(52536014)(66946007)(71200400001)(55016002)(9686003)(53546011)(30864003)(2906002)(5660300002)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EMRVXL9owhsSYFXDbhGT6op4YYxi8B3HNRHXfru9CBUGeYrl1OD5jdqoWCBemF/v6TSps5FTV7smz9hP//D4eKLNUlhCkfuvTOBAizbACWROJKZHeH0Z4bRwm8orNEwhsm3s71EnRo+886mD/szQWWOkHoTN1Zlkc2Z+CYjFyxYO2TccyG2lWAXr5JpBRX0WaepJRDMRB8nh4U6LgW1E5emnKiuJegb1uOxC36G81ZeldGvRe5PCmthEHn2yxd3CeEDZFfmEdEO39Otd3RW6VLitv+nLak1GPdTxiS3c6Xf5X4xQSzi/1coqtl6igAugfJZnZqHn1fbU1IzWe6cTxqXPVAGlAFGqXb61oi3WYjmh1TJPyyOvwtVaiGYTUwDTadezzlSVHtGFraRqbKJ9z84CtPbHUtClY19NySPw1d9qMYlCVeax5Ee1EGRDPpBQwWVZiJbGSf2UKRRo74D/e/KQ0wbr3NNQq7KXeZU2sSBhfM7xw3UBADhYyGtBgsQDMJ1j+1if2xPuiMq2VsHjlQe+j4lQJ1Q07vosSUyqOh7gXEuwcNCG99gQ9EqOKK1JEg86FIsz5IdoFZU7W1I5ULSB+0lBwTxIdZ7KkjwBbLFZTUWnblsx6dhVrVf5ZSGFHb07hhlACgEd71O6dKc0VF5CCf7YLVrNGTCZHaINerEtNCBJSta6b9rrE5H+Es0ZYRlMsP03ZKKpordC6YkONA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b8ab22-3be5-47ff-e53d-08d85b6aed12
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 00:36:47.3495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haFN4nwTPhhNYP+KQ25BwxF97NGb3TdImVk5j6g9NIsciV31M4W0Ca7KaljRuHOqx5k6jIqL8uFBE5Sg59oCLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0760
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/18 8:18, Keith Busch wrote:=0A=
> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> Add missing Additional Sense Codes listed in=0A=
> http://www.t10.org/lists/asc-num.txt.=0A=
> =0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
Martin already pulled this one in scsi-staging. So you can drop it from thi=
s series.=0A=
=0A=
> ---=0A=
>  drivers/scsi/sense_codes.h | 54 +++++++++++++++++++++++++++++++++++++-=
=0A=
>  1 file changed, 53 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sense_codes.h b/drivers/scsi/sense_codes.h=0A=
> index 201a536688de..805d4c13d070 100644=0A=
> --- a/drivers/scsi/sense_codes.h=0A=
> +++ b/drivers/scsi/sense_codes.h=0A=
> @@ -1,7 +1,7 @@=0A=
>  /* SPDX-License-Identifier: GPL-2.0 */=0A=
>  /*=0A=
>   * The canonical list of T10 Additional Sense Codes is available at:=0A=
> - * http://www.t10.org/lists/asc-num.txt [most recent: 20141221]=0A=
> + * http://www.t10.org/lists/asc-num.txt [most recent: 20200817]=0A=
>   */=0A=
>  =0A=
>  SENSE_CODE(0x0000, "No additional sense information")=0A=
> @@ -29,6 +29,7 @@ SENSE_CODE(0x001E, "Conflicting SA creation request")=
=0A=
>  SENSE_CODE(0x001F, "Logical unit transitioning to another power conditio=
n")=0A=
>  SENSE_CODE(0x0020, "Extended copy information available")=0A=
>  SENSE_CODE(0x0021, "Atomic command aborted due to ACA")=0A=
> +SENSE_CODE(0x0022, "Deferred microcode is pending")=0A=
>  =0A=
>  SENSE_CODE(0x0100, "No index/sector signal")=0A=
>  =0A=
> @@ -72,6 +73,9 @@ SENSE_CODE(0x041F, "Logical unit not ready, microcode d=
ownload required")=0A=
>  SENSE_CODE(0x0420, "Logical unit not ready, logical unit reset required"=
)=0A=
>  SENSE_CODE(0x0421, "Logical unit not ready, hard reset required")=0A=
>  SENSE_CODE(0x0422, "Logical unit not ready, power cycle required")=0A=
> +SENSE_CODE(0x0423, "Logical unit not ready, affiliation required")=0A=
> +SENSE_CODE(0x0424, "Depopulation in progress")=0A=
> +SENSE_CODE(0x0425, "Depopulation restoration in progress")=0A=
>  =0A=
>  SENSE_CODE(0x0500, "Logical unit does not respond to selection")=0A=
>  =0A=
> @@ -104,6 +108,17 @@ SENSE_CODE(0x0B06, "Warning - non-volatile cache now=
 volatile")=0A=
>  SENSE_CODE(0x0B07, "Warning - degraded power to non-volatile cache")=0A=
>  SENSE_CODE(0x0B08, "Warning - power loss expected")=0A=
>  SENSE_CODE(0x0B09, "Warning - device statistics notification active")=0A=
> +SENSE_CODE(0x0B0A, "Warning - high critical temperature limit exceeded")=
=0A=
> +SENSE_CODE(0x0B0B, "Warning - low critical temperature limit exceeded")=
=0A=
> +SENSE_CODE(0x0B0C, "Warning - high operating temperature limit exceeded"=
)=0A=
> +SENSE_CODE(0x0B0D, "Warning - low operating temperature limit exceeded")=
=0A=
> +SENSE_CODE(0x0B0E, "Warning - high critical humidity limit exceeded")=0A=
> +SENSE_CODE(0x0B0F, "Warning - low critical humidity limit exceeded")=0A=
> +SENSE_CODE(0x0B10, "Warning - high operating humidity limit exceeded")=
=0A=
> +SENSE_CODE(0x0B11, "Warning - low operating humidity limit exceeded")=0A=
> +SENSE_CODE(0x0B12, "Warning - microcode security at risk")=0A=
> +SENSE_CODE(0x0B13, "Warning - microcode digital signature validation fai=
lure")=0A=
> +SENSE_CODE(0x0B14, "Warning - physical element status change")=0A=
>  =0A=
>  SENSE_CODE(0x0C00, "Write error")=0A=
>  SENSE_CODE(0x0C01, "Write error - recovered with auto reallocation")=0A=
> @@ -122,6 +137,8 @@ SENSE_CODE(0x0C0D, "Write error - not enough unsolici=
ted data")=0A=
>  SENSE_CODE(0x0C0E, "Multiple write errors")=0A=
>  SENSE_CODE(0x0C0F, "Defects in error window")=0A=
>  SENSE_CODE(0x0C10, "Incomplete multiple atomic write operations")=0A=
> +SENSE_CODE(0x0C11, "Write error - recovery scan needed")=0A=
> +SENSE_CODE(0x0C12, "Write error - insufficient zone resources")=0A=
>  =0A=
>  SENSE_CODE(0x0D00, "Error detected by third party temporary initiator")=
=0A=
>  SENSE_CODE(0x0D01, "Third party device failure")=0A=
> @@ -242,6 +259,9 @@ SENSE_CODE(0x2009, "Access denied - invalid LU identi=
fier")=0A=
>  SENSE_CODE(0x200A, "Access denied - invalid proxy token")=0A=
>  SENSE_CODE(0x200B, "Access denied - ACL LUN conflict")=0A=
>  SENSE_CODE(0x200C, "Illegal command when not in append-only mode")=0A=
> +SENSE_CODE(0x200D, "Not an administrative logical unit")=0A=
> +SENSE_CODE(0x200E, "Not a subsidiary logical unit")=0A=
> +SENSE_CODE(0x200F, "Not a conglomerate logical unit")=0A=
>  =0A=
>  SENSE_CODE(0x2100, "Logical block address out of range")=0A=
>  SENSE_CODE(0x2101, "Invalid element address")=0A=
> @@ -251,6 +271,8 @@ SENSE_CODE(0x2104, "Unaligned write command")=0A=
>  SENSE_CODE(0x2105, "Write boundary violation")=0A=
>  SENSE_CODE(0x2106, "Attempt to read invalid data")=0A=
>  SENSE_CODE(0x2107, "Read boundary violation")=0A=
> +SENSE_CODE(0x2108, "Misaligned write command")=0A=
> +SENSE_CODE(0x2109, "Attempt to access gap zone")=0A=
>  =0A=
>  SENSE_CODE(0x2200, "Illegal function (use 20 00, 24 00, or 26 00)")=0A=
>  =0A=
> @@ -275,6 +297,7 @@ SENSE_CODE(0x2405, "Security working key frozen")=0A=
>  SENSE_CODE(0x2406, "Nonce not unique")=0A=
>  SENSE_CODE(0x2407, "Nonce timestamp out of range")=0A=
>  SENSE_CODE(0x2408, "Invalid XCDB")=0A=
> +SENSE_CODE(0x2409, "Invalid fast format")=0A=
>  =0A=
>  SENSE_CODE(0x2500, "Logical unit not supported")=0A=
>  =0A=
> @@ -297,6 +320,10 @@ SENSE_CODE(0x260F, "Invalid data-out buffer integrit=
y check value")=0A=
>  SENSE_CODE(0x2610, "Data decryption key fail limit reached")=0A=
>  SENSE_CODE(0x2611, "Incomplete key-associated data set")=0A=
>  SENSE_CODE(0x2612, "Vendor specific key reference not found")=0A=
> +SENSE_CODE(0x2613, "Application tag mode page is invalid")=0A=
> +SENSE_CODE(0x2614, "Tape stream mirroring prevented")=0A=
> +SENSE_CODE(0x2615, "Copy source or copy destination not authorized")=0A=
> +SENSE_CODE(0x2616, "Fast copy not possible")=0A=
>  =0A=
>  SENSE_CODE(0x2700, "Write protected")=0A=
>  SENSE_CODE(0x2701, "Hardware write protected")=0A=
> @@ -342,6 +369,7 @@ SENSE_CODE(0x2A12, "Data encryption parameters change=
d by vendor specific event"=0A=
>  SENSE_CODE(0x2A13, "Data encryption key instance counter has changed")=
=0A=
>  SENSE_CODE(0x2A14, "SA creation capabilities data has changed")=0A=
>  SENSE_CODE(0x2A15, "Medium removal prevention preempted")=0A=
> +SENSE_CODE(0x2A16, "Zone reset write pointer recommended")=0A=
>  =0A=
>  SENSE_CODE(0x2B00, "Copy cannot execute since host cannot disconnect")=
=0A=
>  =0A=
> @@ -360,6 +388,11 @@ SENSE_CODE(0x2C0B, "Not reserved")=0A=
>  SENSE_CODE(0x2C0C, "Orwrite generation does not match")=0A=
>  SENSE_CODE(0x2C0D, "Reset write pointer not allowed")=0A=
>  SENSE_CODE(0x2C0E, "Zone is offline")=0A=
> +SENSE_CODE(0x2C0F, "Stream not open")=0A=
> +SENSE_CODE(0x2C10, "Unwritten data in zone")=0A=
> +SENSE_CODE(0x2C11, "Descriptor format sense data required")=0A=
> +SENSE_CODE(0x2C12, "Zone is inactive")=0A=
> +SENSE_CODE(0x2C13, "Well known logical unit access required")=0A=
>  =0A=
>  SENSE_CODE(0x2D00, "Overwrite error on update in place")=0A=
>  =0A=
> @@ -395,6 +428,8 @@ SENSE_CODE(0x3100, "Medium format corrupted")=0A=
>  SENSE_CODE(0x3101, "Format command failed")=0A=
>  SENSE_CODE(0x3102, "Zoned formatting failed due to spare linking")=0A=
>  SENSE_CODE(0x3103, "Sanitize command failed")=0A=
> +SENSE_CODE(0x3104, "Depopulation failed")=0A=
> +SENSE_CODE(0x3105, "Depopulation restoration failed")=0A=
>  =0A=
>  SENSE_CODE(0x3200, "No defect spare location available")=0A=
>  SENSE_CODE(0x3201, "Defect list update failure")=0A=
> @@ -419,6 +454,7 @@ SENSE_CODE(0x3802, "Esn - power management class even=
t")=0A=
>  SENSE_CODE(0x3804, "Esn - media class event")=0A=
>  SENSE_CODE(0x3806, "Esn - device busy class event")=0A=
>  SENSE_CODE(0x3807, "Thin Provisioning soft threshold reached")=0A=
> +SENSE_CODE(0x3808, "Depopulation interrupted")=0A=
>  =0A=
>  SENSE_CODE(0x3900, "Saving parameters not supported")=0A=
>  =0A=
> @@ -456,6 +492,7 @@ SENSE_CODE(0x3B19, "Element enabled")=0A=
>  SENSE_CODE(0x3B1A, "Data transfer device removed")=0A=
>  SENSE_CODE(0x3B1B, "Data transfer device inserted")=0A=
>  SENSE_CODE(0x3B1C, "Too many logical objects on partition to support ope=
ration")=0A=
> +SENSE_CODE(0x3B20, "Element static information changed")=0A=
>  =0A=
>  SENSE_CODE(0x3D00, "Invalid bits in identify message")=0A=
>  =0A=
> @@ -488,6 +525,11 @@ SENSE_CODE(0x3F13, "iSCSI IP address removed")=0A=
>  SENSE_CODE(0x3F14, "iSCSI IP address changed")=0A=
>  SENSE_CODE(0x3F15, "Inspect referrals sense descriptors")=0A=
>  SENSE_CODE(0x3F16, "Microcode has been changed without reset")=0A=
> +SENSE_CODE(0x3F17, "Zone transition to full")=0A=
> +SENSE_CODE(0x3F18, "Bind completed")=0A=
> +SENSE_CODE(0x3F19, "Bind redirected")=0A=
> +SENSE_CODE(0x3F1A, "Subsidiary binding changed")=0A=
> +=0A=
>  /*=0A=
>   *	SENSE_CODE(0x40NN, "Ram failure")=0A=
>   *	SENSE_CODE(0x40NN, "Diagnostic failure on component nn")=0A=
> @@ -589,6 +631,9 @@ SENSE_CODE(0x550B, "Insufficient power for operation"=
)=0A=
>  SENSE_CODE(0x550C, "Insufficient resources to create rod")=0A=
>  SENSE_CODE(0x550D, "Insufficient resources to create rod token")=0A=
>  SENSE_CODE(0x550E, "Insufficient zone resources")=0A=
> +SENSE_CODE(0x550F, "Insufficient zone resources to complete write")=0A=
> +SENSE_CODE(0x5510, "Maximum number of streams open")=0A=
> +SENSE_CODE(0x5511, "Insufficient resources to bind")=0A=
>  =0A=
>  SENSE_CODE(0x5700, "Unable to recover table-of-contents")=0A=
>  =0A=
> @@ -692,6 +737,7 @@ SENSE_CODE(0x5D69, "Firmware impending failure throug=
hput performance")=0A=
>  SENSE_CODE(0x5D6A, "Firmware impending failure seek time performance")=
=0A=
>  SENSE_CODE(0x5D6B, "Firmware impending failure spin-up retry count")=0A=
>  SENSE_CODE(0x5D6C, "Firmware impending failure drive calibration retry c=
ount")=0A=
> +SENSE_CODE(0x5D73, "Media impending failure endurance limit met")=0A=
>  SENSE_CODE(0x5DFF, "Failure prediction threshold exceeded (false)")=0A=
>  =0A=
>  SENSE_CODE(0x5E00, "Low power condition on")=0A=
> @@ -744,6 +790,8 @@ SENSE_CODE(0x6708, "Assign failure occurred")=0A=
>  SENSE_CODE(0x6709, "Multiply assigned logical unit")=0A=
>  SENSE_CODE(0x670A, "Set target port groups command failed")=0A=
>  SENSE_CODE(0x670B, "ATA device feature not enabled")=0A=
> +SENSE_CODE(0x670C, "Command rejected")=0A=
> +SENSE_CODE(0x670D, "Explicit bind not allowed")=0A=
>  =0A=
>  SENSE_CODE(0x6800, "Logical unit not configured")=0A=
>  SENSE_CODE(0x6801, "Subsidiary logical unit not configured")=0A=
> @@ -772,6 +820,10 @@ SENSE_CODE(0x6F04, "Media region code is mismatched =
to logical unit region")=0A=
>  SENSE_CODE(0x6F05, "Drive region must be permanent/region reset count er=
ror")=0A=
>  SENSE_CODE(0x6F06, "Insufficient block count for binding nonce recording=
")=0A=
>  SENSE_CODE(0x6F07, "Conflict in binding nonce recording")=0A=
> +SENSE_CODE(0x6F08, "Insufficient permission")=0A=
> +SENSE_CODE(0x6F09, "Invalid drive-host pairing server")=0A=
> +SENSE_CODE(0x6F0A, "Drive-host pairing suspended")=0A=
> +=0A=
>  /*=0A=
>   *	SENSE_CODE(0x70NN, "Decompression exception short algorithm id of nn"=
)=0A=
>   */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
