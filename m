Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7032FC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C2D64FB2
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBDX1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:27:04 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36161 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBDX06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 18:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612481217; x=1644017217;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3itwvl0lY/bqcBEdOBi8h/wr1hCOmtS8UWKKa8kiYUs=;
  b=IbiYISHrATCa7b+s/zaIIXAxHXeD1jKJLoGvCsBl/URRxEVNXfnL+R+b
   Ro9meMQ6B4vVwiSqEh6LSop0tFOBUuvPV+o5ePTuc9zhxVH7OKLaP8GjH
   nHhhVbJ3RaPwuybLag1ieZRD88cR6hFAtsXK6KmqX5L82iJ8k1j+zgpwx
   xqTtLCLCnVKEwx7Eee9r6DsdiQbJUROSHGkdMUsnvtAYLUlBvE40TlSNs
   PmFvlEIGr+EnbVJ9A0q1p5Ja4r3UEhfXYu+h/yCXoZCbIX8iM1m4YJvtt
   b184YTyYGyFfNbsG3rbVCFf4KftHtYeCb+S/kv0PwCIZxi31LY/KO97wr
   A==;
IronPort-SDR: MaD/wOtURXROJqGk6+n8XVfJCbLPxsHvm4QR0fCDfAiRXxiuwDGZlgR+v8O/8YyyfYI2yOL92r
 OzAsHh71Mgu1E7gN8F0abT7nQAYPLVjMpfysPeHE7kWMv4Fx2lEmLRpcq1vmqBnjEXAyqPu5be
 /BZtz5PgO+VbPpKNHTJ99kEPqO1qcX277m9EATP3Hq0FXrFDwECAKHcRgF5LSrFnAKA2MPfVcx
 Pj8f+yS/lcS1HNW7qBikzIW1/L5ogDbmpb13d8bl0xQXc8VLmklj3gJmoPZGNX+PqZIujFxIOq
 pmY=
X-IronPort-AV: E=Sophos;i="5.81,153,1610380800"; 
   d="scan'208";a="159184755"
Received: from mail-sn1nam02lp2059.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.59])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 07:25:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoptMChndKgmQaNMKxqJoh9OIT2xsHN2rUuB3L0scjAxZuzNVMZUzTLjTZq+BGk5dXdMFIcxGExY/2/ixgUCd4+HK/ahntOcZIzMr6L3OWzFjgs9oChfETJjQxdTJsL06lgV7af1T6T311YnWj/aWkpNFq8k1j6QaJ22uxkWutn0F5JZrmp+LhoNrIMgTRMnINug2QuxbIbQ+ZBfiKAzWfAKW7I8GmhiZDZHB/+vc1+lR2tzePuQAELCOEKMCHCBRT58Ex0mHat1CWXD9a6d4xORnoHVG2RzpqRM3i+AK2aWbvx4EEDa8lh/WZctZZX+5d0lnAGxIApVAYSpSZRDow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydDzRw2FHSHRymu7wiRx29HRqWEZUwhraKW/a0cFzKo=;
 b=IDnwEqXQdEUkTFpviHCrV+LXTVKt5kx6KvH2HXPxMZQKYS4JISSiTST+rV5zyN+mM94JY84c/Q84bSEeKZvCJSYeNx7If7NUCCguzDc++Ips/FTFH6a0NuxC1hktL8DApWKAyBYCjV1UeXwzYkWkYEj9NwPsNO1TNosOj5c5gvSDume4F4mMP9WxmTz9sx9GFZowTdCr4TLim7F96+5pyCWPa/DHeY59W/9x8zn7CElI+ad6Etw+XMIlM4nZG0PXDxt/BnNeF2IziBddq5lP2UevqSinc5Sk6rMsGaCmo3yRMQi0f0vUDYdsO1UmQo2W2ZquejTIzdMgX9Ff3yN8aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydDzRw2FHSHRymu7wiRx29HRqWEZUwhraKW/a0cFzKo=;
 b=iMwxd5xDCIT2bnVSKQb69rCTE0BEf450twt5eG7AQnBLEmiFkAncQeixt2vzukX4pN8ZkBTdxedyK9/EewLnw3QMM8e0KgxYmZwKodRV56IsgogIwYzQ4nDABzl3j3KhvsM3hTZcp00AJxvH4dCy3xLEQRiHBBD1Sd4ZDJ6PsMk=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7632.namprd04.prod.outlook.com (2603:10b6:a03:32d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 23:25:50 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 23:25:50 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 09/11] target_core_user: add backend plug/unplug callouts
Thread-Topic: [PATCH 09/11] target_core_user: add backend plug/unplug callouts
Thread-Index: AQHW+uq0eTSnV6Yom0S+P/7LucOzrQ==
Date:   Thu, 4 Feb 2021 23:25:50 +0000
Message-ID: <BYAPR04MB4965AEA5583DFC889C8D5E9D86B39@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-10-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37dd5f40-4dd0-430c-4186-08d8c964359f
x-ms-traffictypediagnostic: SJ0PR04MB7632:
x-microsoft-antispam-prvs: <SJ0PR04MB763208E9E1D09858954B3B8886B39@SJ0PR04MB7632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HIBLTsFx5Ca5hn2W8hNuub/+gsSFm8a5IcPUkIJ64pYNzL6opU/DOm3ktVKcfTWcFmCLiRXA7HlWQjq8NZpknxfMhrFQ1pSWdAHlvfVo0q92YuMyXHIkPYBR5Vs5nkMNuEYXEEwlYtHWHWkp61ZrN3cEveDksh8lfwcPyzJCL09jkVEl3RfjcOu57N2qTUGJkU3ldUPjH5Ib5UrqhxaFNmo8zDye6cFSKb/3PjUuj00Y8ZvGvNCiifL48h19rraWeqefMGf6RiCbNpEueH7U0nHZunwiuel8vsMu1dHv3nKOqjEo5uJyL6JE32FzcpmGn8QNMLIL4pYFged8ce610uVwVzfrdaqbgTZj+Nam5+k1JEhtwOtYMQCMTKcEDF/k1m89N8AHoIg4mxuP2eL2zSkP0zEJMm1i1pFIDNTFVlDMgZ/zT2lpegk5EynphiNoB/ilBupM04XsFvNkcIYujuwkdueWT8PRUGVOOEl30xXrbPuad4Q/sBDrL7piKPvYKIIoQzPJYS+35Sxp1pU+rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(8676002)(9686003)(86362001)(71200400001)(186003)(7696005)(55016002)(4744005)(8936002)(5660300002)(76116006)(2906002)(66556008)(26005)(66446008)(66946007)(6506007)(64756008)(478600001)(110136005)(316002)(52536014)(33656002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?paC5/zrRHqRIijbHh98Mz+fo03tdZ2sIkdVgqXkMok0Qk12YYH8kbGoDMVAU?=
 =?us-ascii?Q?sFWLgRtpvfzChNPZ51RCEULvLbTMadKJntXNbFAr5FZdv0Kwtmssi8WMtnga?=
 =?us-ascii?Q?vZml45Tgbj16ZRSYy0D4fBC3guYQ19mn3sOc4N0BjdqVuSR2uV2M3jaUMbmO?=
 =?us-ascii?Q?NOoxv5gjG/VE+36F1lAKbR+78NrsLrovtffTPci2XTYO/5By9m8nubfibKEq?=
 =?us-ascii?Q?TxWz95qrNyvqb5hFLkD/1hOLovVWQpbSVOanMa2rCifrNaFBYREhxpI9ek6R?=
 =?us-ascii?Q?BiiO2cwartORrtBpvVyhe3Ab24/eA/1/7wyfhFqJ1fhviq+Vx8rmGnK5qGFy?=
 =?us-ascii?Q?K5L7GYLFaqKqFqgaAC2lTggLXg/wGncNqwNvfKQY0cVVrcDMhb+Wzmr3WRMC?=
 =?us-ascii?Q?VzdbyHoHtUEIVBerPSKoSsd8XFllJW3LdlUZjwo8BtuirTG7j5ZJa/Bm9TuQ?=
 =?us-ascii?Q?PzFOvyVW7WcrVTGAq1MRKkNX3uKeUMUP+1aSYaqDKyYzmfRFGVChx0Lr+sf8?=
 =?us-ascii?Q?KXSLs+tD5QGmSmEYNxkSUy6X7gESSF+etZWPYXfsCACICtem18kX0axfGFoX?=
 =?us-ascii?Q?2jnH7m+emFObH6cWWLr7mAP4Hs+TeLERyussJjWxt/AZZgFDFauLvgZv1CcR?=
 =?us-ascii?Q?2J6o8nicCxqHihFTHAUx8bLLsM7CFSQKMh0/EgML+pJ05QXQyF1l3jwI/Hbi?=
 =?us-ascii?Q?ul+2AjOerADIzdm5byQbphEV8U4j/4ok2oVAhTbCba0V7opow+Kz1OF+NI5K?=
 =?us-ascii?Q?6aIQBQhNjvF2r3rTBh9Q+gsjOT0gIDg8qTMuXQq+YkA7YeMFHSNwaHbLRXsR?=
 =?us-ascii?Q?Ok9Vt8U9Q7z1QNeLWSUwGbfS/F3yt0qjdnokmigcJZlLuyGWS435pIUR0y0m?=
 =?us-ascii?Q?5Zn7URtOGVYKQ/7YPhnAu1643zxL1kE2RILgVQQ0ckU0s4+aCuv6n6uj/OiO?=
 =?us-ascii?Q?kSbAXBqSVXrpGNhn5C3vqoLw3dvb9BhPqZ5pSG+Jg8N4uvrMtoYaob6xi+om?=
 =?us-ascii?Q?vAYgynmxgkoPCZEgFtjcpPfkTqZbt+AN/oH2SuV6IhQXiktzKZd6txsavkrX?=
 =?us-ascii?Q?EOWjDCP1gNwpEaXLj+Y911Ds4wY70g8Xqi2wMNDvHKmK+t8q7ut3ie32COMj?=
 =?us-ascii?Q?ygLTAsgIuF4AlBwHweCCyd2EcdaTCoYKasQppaFavFlv0JoUbHPH++fOjniT?=
 =?us-ascii?Q?k4qbqgG7qhDRcMbIHbbWDEdMWOF3ekRiIdmgVmzjlFlw27NbsHYgoNo0TGdw?=
 =?us-ascii?Q?VATPXeGZ/kAxjghIejLueivZ3TuVq9ylX3vPaCiLAsNvSODA3jLEswtPye+U?=
 =?us-ascii?Q?QL0vIq1uROD8cxjejZAdWKU8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dd5f40-4dd0-430c-4186-08d8c964359f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:25:50.5397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BDKoUlm7xvRmAH52d+htlAQrZheTTAnXsQAkUa43zxVud2EzrP25Yw+Za3KuimDtISlSyDlb9QuGxw/ILIRhmJJD0w0AWhZIXwmpfe9aH9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7632
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>   * queue_cmd_ring - queue cmd to ring or internally=0A=
>   * @tcmu_cmd: cmd to queue=0A=
> @@ -1086,8 +1108,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd=
, sense_reason_t *scsi_err)=0A=
>  =0A=
>  	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);=0A=
>  =0A=
> -	/* TODO: only if FLUSH and FUA? */=0A=
> -	uio_event_notify(&udev->uio_info);=0A=
> +	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))=0A=
> +		uio_event_notify(&udev->uio_info);=0A=
>  =0A=
Do we need to keep the TODO ?=0A=
>  	return 0;=0A=
>  =0A=
> @@ -2840,6 +2862,8 @@ static struct target_backend_ops tcmu_ops =3D {=0A=
>  	.configure_device	=3D tcmu_configure_device,=0A=
>  	.destroy_device		=3D tcmu_destroy_device,=0A=
>  	.free_device		=3D tcmu_free_device,=0A=
> +	.unplug_device		=3D tcmu_unplug_device,=0A=
> +	.plug_device		=3D tcmu_plug_device,=0A=
>  	.parse_cdb		=3D tcmu_parse_cdb,=0A=
>  	.tmr_notify		=3D tcmu_tmr_notify,=0A=
>  	.set_configfs_dev_params =3D tcmu_set_configfs_dev_params,=0A=
=0A=
