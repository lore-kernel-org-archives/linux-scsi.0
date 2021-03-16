Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150CBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 11:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7056501D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 11:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhCPL1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 07:27:49 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18313 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhCPL1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 07:27:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615894039; x=1647430039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wnexcdX/CaTq1LhP+euf6z0o03ice/id624wl3LSDxE=;
  b=cNHtUfxonufnnn77tqLXPrcEq1xEXUlYsdcdjEy3yBccn7uoL7w5MwZR
   f/6pFYal8FjKrCnNiwQ3SrZZ6NrNDRxqlmPsygBRILBHhAv06wEwGgDEy
   L7lUCNCwRRXGRoVxmpXqO4dGSCwafXpLSlhUME/u7vIyB4+zfgxratIpF
   c7zLznHABqlR8j8YkIKNXLbkrinwFut/Fc93xFlnaC6pa3v5ivQVgrsg6
   Gvm2lzhX48kHFbAP769O8ylk+kh2WQEW39tC31PiGcYHz1ORnAr0JE3eZ
   2K7FOhtgoULE8DlP6DK4zVm7L2Erd0gY96RbYf2eLisCqWvYNIvMpXoeO
   A==;
IronPort-SDR: jRRV+35hz7OyM7UzpAbrXaSzIdsn014AAlwguvVkEdMYdypBLqLiUURcRh9B1IlM9/JBBRUY9M
 HNb6BwaYo3tviC1cxA138W0xqpkG9jNAGUDkxx4ZL1QppJ8vvXGNadyzN91NBsj5vmAngwRnKg
 EFMfxbXmV2X3Wdr+nuoQ1esaMXKW8dCmAIBG2pxlMwiGze/rsBQMWQ/7xhDstHO48/Tnsv4Q9l
 qtpUXwF8iaEv6GU1B/5MPb0iYuJBrOqICGu12kuEiUs3e7dRJuZMwYbRIMN9esdbNBIe8fxSel
 43M=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="162264230"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 19:27:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcnXuF4Z/99jfrJH+hWze+XheVziawAbn3DLcqKnAB1FkiRNUfxR88Knei5ql/c+Y+RoubZC1ydRfw7mm84UVsNVAYlGcfC/z7chPLZGOPM9t5/6YKtHcKJfJI4m3BseITD6D5IcNdCuszHoyEI6mDk5DHcFfJU7AVXcS33e4hvFEMSrJCoOEGPPu8eKZeLhGcBNgGLavbMNNNfi+ZRDXdXp/u/Q5K1tBU52Tp0gST8qbViDsO6PUnNIOA2lru1flYAW2tcGoL+WXSYPJe6PGmnCrqSJCpuGYk0M1ZMvc/UgzycwKjkxZXQcs7EQxbjSfdPrpFrOiRCzZSnvu2wXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tlXJkQU4S00k0FPY8n4i049tinb77ZfUkxkBZb8YY4=;
 b=hum9n+WmH5auyWThF1wSFdxPGgFh6hs4pbaLR+XAenImpDb2CIGydEcujZxza9O0t0DWql/PoooB7q94ElE/R8as8BD4lyJhF6Oc/u/KpEgI3ZiYoytWeDi42mLmC4EvoQcegMKUnq1CC36Q+1cGMtlWWmja6zoJJyQkkMa6YbdUUUqvrsHDyWbonV3ttF0kDaCxMtTgSrBnodzM549h3xCy7cN6DRSZDBtlThl+k71cbJ4zMkeI3zbWEWuYiwtv6YgZS223r7Xvtugtb4hvSBbK/C5MtnFgaL/uHzFo6mSz139DOr11ZzrcOG7DtaUQRmo8599L5Oy8b+w4/wWytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tlXJkQU4S00k0FPY8n4i049tinb77ZfUkxkBZb8YY4=;
 b=wo2pyjO/mkg85P25ofkul8nLb/5nULTuhUXZ7fzDcS3LHPoiHe9SPyohTtyfXgF9I9YkZUoV846kOSNfp+VocM88hYA05M54/rVodWv0A5w/XRrTidwRzNcvY8mdh7iYRmBpx3DtaqckPiPbRP23pqO+bkh/ttsHAN6oxB3AWvA=
Received: from BY5PR04MB6327.namprd04.prod.outlook.com (2603:10b6:a03:1e8::20)
 by BY5PR04MB6817.namprd04.prod.outlook.com (2603:10b6:a03:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 11:27:17 +0000
Received: from BY5PR04MB6327.namprd04.prod.outlook.com
 ([fe80::54e8:5040:3709:1654]) by BY5PR04MB6327.namprd04.prod.outlook.com
 ([fe80::54e8:5040:3709:1654%2]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 11:27:17 +0000
From:   Arthur Simchaev <Arthur.Simchaev@wdc.com>
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw data
Thread-Topic: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw
 data
Thread-Index: AQHXA8HGKUtY27DSkEKVXm/ukaBroqqGpqXw
Date:   Tue, 16 Mar 2021 11:27:16 +0000
Message-ID: <BY5PR04MB6327DEDB1CB9EEBC8365E848ED6B9@BY5PR04MB6327.namprd04.prod.outlook.com>
References: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
In-Reply-To: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc08c85b-21aa-4c01-7c4d-08d8e86e7488
x-ms-traffictypediagnostic: BY5PR04MB6817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB6817B19217C2FE213D477B4EED6B9@BY5PR04MB6817.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UycABVLElt8TT/wvd6Y7Cvi9dY7Xlw9JprpYGEJgwhtfJS5OTAcqqIuqMNDUWPIBeJz3kG7rSOCdQaje9I2e9ZoOmlCa5dasNQWhAH3qcQ3Ku4GjTRssrM4WhziBIjc7OsP0tiMPIM2AGyMJd5PiI7JCut5vaAgdEghMXd6WeGcxORH838aq4CCE6Mmilm/BFLA6VkM+GFgEtNyfyhzGfkaXwz3T2T/Tmt2kBIKwSI8wYBTbl0c4YHiFGyS/LtnetPBgXY/BcNb2ORx3hpXTqJKusroguwkizBggoz46q2+FYCQRoT9dLeu2mYb+kravcBi+6v88Ccq8Nk74qCPQCV8VwZkuaomzjLAySjAJ8kFu5dtXw0g3K1N1A06hlvCy7RK/WRvEDt4kWVNur4ZzMcwfrssBv3/UHZrH5xJErTXuojftf1QhheQ/DlaFhaMBu12pJ7yffPER37csvpiPYTWDSBArfjSUAWQmJi+r9fYYHmM/+jz1rkM7jDpzg0hGZYkWHpBNcZ6VhEhe47aSaIywA5xhjT6eheWme+ghgcubXUKj2q35m+799HvecR2P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6327.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6506007)(498600001)(7696005)(76116006)(55016002)(5660300002)(66946007)(4326008)(71200400001)(66556008)(66446008)(52536014)(9686003)(83380400001)(66476007)(64756008)(110136005)(8936002)(54906003)(186003)(33656002)(86362001)(8676002)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+0W+ZvYPvKELDmJ9dkGZ8/rzatECC/4gB2TF2BY2sNQ6lbeZzuMRh5j9ELKN?=
 =?us-ascii?Q?cABGn2aXxLfyW9iQDVYyqucdJIOoIATLm5+WbjG7G4qyTeFshBr+rdbM4hpi?=
 =?us-ascii?Q?E9lGcG3/lY/GeKLDlHxpOMYQj4gVTD65YfTEl1brw129QIMnpeI1fcVZCPh3?=
 =?us-ascii?Q?11TEBZmA2/M6QZYbnL8ExS8gLU2iChj8YdNdwWA2uEJNJekoZl5rO0en42m8?=
 =?us-ascii?Q?KDYsAurmQlFgDQUeQGhsUZvkn+dRilebD78D6l7INDtLLnmhT3V6mrBpc7fQ?=
 =?us-ascii?Q?FX8K/Dhxm712RJ9vV6pivZ124GFdJvpIRNFJ9gwxAoyOY2FogMk6VL5LyzHF?=
 =?us-ascii?Q?mtvDELYwOHLu2wSloYyaJ9JUBHvUvWi4LB4RxQ9Ij/4bHo+ObcRCf13WFY1T?=
 =?us-ascii?Q?M8M2Kqy71ubWeTD/kyqQ3jT05It50mH717CV9MoYZH0mFd9q5R+8yUmVKbfW?=
 =?us-ascii?Q?Q/Muy+g1/MpIGsGGstbQPD8iaUbBxkC5D5emj0oe67aKWQHRmapYYkVJesp5?=
 =?us-ascii?Q?hOBoeX3QCDu7CHATe4B2bfZsfDKKYujSUPkal9ZNeKU+uqHtvsd0eJdHQ6mf?=
 =?us-ascii?Q?fMz+i7IylxBdHZfRc4POWaz6h8Kx4U6ec2FYZt4TKNFF2rRgOgSOd+yM60Nu?=
 =?us-ascii?Q?XGK5iQ8WA58lyQqSgLxV9C7liyStFmTZfrbmXpuleq/7WRMbf4EQdouKMTk3?=
 =?us-ascii?Q?ltLt7ymwNH9t0wrk6XQakRqgIJ0EiUn1rFpVfkia/rB26iV2g8U0E4/UX2fb?=
 =?us-ascii?Q?T/9WAIjpLIAWwkXbu62lvJGRfm/drLJpfsv5bhf/XlfqJswvmLna8wdboe6O?=
 =?us-ascii?Q?5PHKI6tXt/i/1VUmvmHwG3xFpzWvwuFbY4K4nMtyhkQVwqs9CdQuorpp8KbI?=
 =?us-ascii?Q?2GqPUiO+VO8WnBx+lwlYiAyPbMXi6RlFNpn8Z0Bv71xGLS2EhDa/1vq9DDEW?=
 =?us-ascii?Q?5ve5SBRvnNs21fMArNDHQJuDeLwadpn0uIFbf+Gj0YnRFpskJ2CYcgcXsSej?=
 =?us-ascii?Q?TFw70hCzxgW68YrxUG4Vy111JMrzPjuxcOtJzf5HWlHJjJ3+hjiLeEdKkW+j?=
 =?us-ascii?Q?wZrqvhqindke8149aYROV9GXmtcw1yBFmu1Dxk2hzOdyh4V9uetr8ZzelPsw?=
 =?us-ascii?Q?fU4syuXHbWNRzdrPqMyI9Bp0pcWLufvJk2FYyzg39RelfWIxTtxgJ4LcPuU5?=
 =?us-ascii?Q?hsatkLsttpqBi7gk1yJjMH4t/lAqO14KHs1P/RaoLNij5dsJ4azlfirG7uI4?=
 =?us-ascii?Q?XoZd62PWn7lmYlmhQ8ffPKSe1OsjvK3kRMRLSKMiIjLTaethfYbS3pC7ongt?=
 =?us-ascii?Q?4g2a+ijvNjaNzjeSf04Vio2h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6327.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc08c85b-21aa-4c01-7c4d-08d8e86e7488
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 11:27:16.9982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YFPrpL4+qHNB/7YFVfYx5DSw0fV806RFJ+jSXywRqd4xtz07feUbhkQBpd6og/ZiFKHz7VXWuS69de4ncllDnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6817
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin

Could you please consider to take this patch?

Regards
Arthur

> -----Original Message-----
> From: Arthur Simchaev <Arthur.Simchaev@wdc.com>
> Sent: Monday, February 15, 2021 7:41 PM
> To: James E . J . Bottomley <jejb@linux.vnet.ibm.com>; Martin K . Peterse=
n
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: alim.akhtar@samsung.com; Bean Huo <beanhuo@micron.com>; Arthur
> Simchaev <Arthur.Simchaev@wdc.com>
> Subject: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw dat=
a
>=20
> Currently the string descriptors sysfs entries are printing in ascii
> format. According to Jedec UFS spec the string descriptors data is
> Unicode and need-not be ascii convertible. Therefore in case the device
> string descriptor contains non ascii convertible characters, it will
> produce a wrong output. In order to fix this issue, the new
> string descriptors entries will added to sysfs directory.
> Those entries will show the string descriptors in raw format
>=20
> Signed-off-by: Arthur Simchaev <Arthur.Simchaev@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 44
> ++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-sysfs.c               | 34 +++++++++++++++++------
>  2 files changed, 70 insertions(+), 8 deletions(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index d1bc23c..f6d6a46 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -561,6 +561,50 @@ Description:	This file contains a product revision
> string. The full
>=20
>  		The file is read only.
>=20
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/string_descriptors/manufacture
> r_name_raw
> +Date:		February 2021
> +Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
> +Description:	This file contains a device manufactureer name string
> +		as raw data. The full information about the descriptor
> +		could be found at UFS specifications 2.1.
> +
> +		The file is read only.
> +
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_na
> me_raw
> +Date:		February 2021
> +Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
> +Description:	This file contains a product name string as raw data.
> +		The full information about the descriptor could be found at
> +		UFS specifications 2.1.
> +
> +		The file is read only.
> +
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem_id_raw
> +Date:		February 2021
> +Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
> +Description:	This file contains a OEM ID string as raw data.
> +		The full information about the descriptor could be found at
> +		UFS specifications 2.1.
> +
> +		The file is read only.
> +
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/string_descriptors/serial_numb
> er_raw
> +Date:		February 2021
> +Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
> +Description:	This file contains a device serial number string
> +		as raw data. The full information about the descriptor could
> be
> +		found at UFS specifications 2.1.
> +
> +		The file is read only.
> +
> +What:
> 	/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_revi
> sion_raw
> +Date:		February 2021
> +Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
> +Description:	This file contains a product revision string as raw data.
> +		The full information about the descriptor could be found at
> +		UFS specifications 2.1.
> +
> +		The file is read only.
>=20
>  What:
> 	/sys/class/scsi_device/*/device/unit_descriptor/boot_lun_id
>  Date:		February 2018
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index acc54f5..f1407ff 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -658,7 +658,7 @@ static const struct attribute_group
> ufs_sysfs_power_descriptor_group =3D {
>  	.attrs =3D ufs_sysfs_power_descriptor,
>  };
>=20
> -#define UFS_STRING_DESCRIPTOR(_name, _pname)
> 	\
> +#define UFS_STRING_DESCRIPTOR(_name, _pname, _is_ascii)
> 	\
>  static ssize_t _name##_show(struct device *dev,
> 	\
>  	struct device_attribute *attr, char *buf)			\
>  {									\
> @@ -690,10 +690,18 @@ static ssize_t _name##_show(struct device *dev,
> 				\
>  	kfree(desc_buf);						\
>  	desc_buf =3D NULL;						\
>  	ret =3D ufshcd_read_string_desc(hba, index, &desc_buf,		\
> -				      SD_ASCII_STD);			\
> +				      _is_ascii);			\
>  	if (ret < 0)							\
>  		goto out;						\
> -	ret =3D sysfs_emit(buf, "%s\n", desc_buf);			\
> +	if (_is_ascii) {						\
> +		ret =3D sysfs_emit(buf, "%s\n", desc_buf);		\
> +	} else {							\
> +		int i;							\
> +									\
> +		for (i =3D 0; i < desc_buf[0]; i++)			\
> +			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
> +		ret =3D sysfs_emit(buf, "%s\n", buf);			\
> +	}			\
>  out:									\
>  	pm_runtime_put_sync(hba->dev);
> 	\
>  	kfree(desc_buf);						\
> @@ -702,11 +710,16 @@ out:
> 			\
>  }									\
>  static DEVICE_ATTR_RO(_name)
>=20
> -UFS_STRING_DESCRIPTOR(manufacturer_name, _MANF_NAME);
> -UFS_STRING_DESCRIPTOR(product_name, _PRDCT_NAME);
> -UFS_STRING_DESCRIPTOR(oem_id, _OEM_ID);
> -UFS_STRING_DESCRIPTOR(serial_number, _SN);
> -UFS_STRING_DESCRIPTOR(product_revision, _PRDCT_REV);
> +UFS_STRING_DESCRIPTOR(manufacturer_name, _MANF_NAME, 1);
> +UFS_STRING_DESCRIPTOR(product_name, _PRDCT_NAME, 1);
> +UFS_STRING_DESCRIPTOR(oem_id, _OEM_ID, 1);
> +UFS_STRING_DESCRIPTOR(serial_number, _SN, 1);
> +UFS_STRING_DESCRIPTOR(product_revision, _PRDCT_REV, 1);
> +UFS_STRING_DESCRIPTOR(manufacturer_name_raw, _MANF_NAME, 0);
> +UFS_STRING_DESCRIPTOR(product_name_raw, _PRDCT_NAME, 0);
> +UFS_STRING_DESCRIPTOR(oem_id_raw, _OEM_ID, 0);
> +UFS_STRING_DESCRIPTOR(serial_number_raw, _SN, 0);
> +UFS_STRING_DESCRIPTOR(product_revision_raw, _PRDCT_REV, 0);
>=20
>  static struct attribute *ufs_sysfs_string_descriptors[] =3D {
>  	&dev_attr_manufacturer_name.attr,
> @@ -714,6 +727,11 @@ static struct attribute
> *ufs_sysfs_string_descriptors[] =3D {
>  	&dev_attr_oem_id.attr,
>  	&dev_attr_serial_number.attr,
>  	&dev_attr_product_revision.attr,
> +	&dev_attr_manufacturer_name_raw.attr,
> +	&dev_attr_product_name_raw.attr,
> +	&dev_attr_oem_id_raw.attr,
> +	&dev_attr_serial_number_raw.attr,
> +	&dev_attr_product_revision_raw.attr,
>  	NULL,
>  };
>=20
> --
> 2.7.4

