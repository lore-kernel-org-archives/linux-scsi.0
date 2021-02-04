Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3818AC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA37E64FB2
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbhBDX2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:28:05 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57085 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhBDX17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 18:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612481917; x=1644017917;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XZqxKmp+3PY4gQkw1Hnt5S8Nddg0B8K18iN/3Oro/Ho=;
  b=FWw8u+9sID3PrOvg3WIxAAWMsNoAQKvp77TqN0Yp58S/M+L/CwnFX86x
   Wgr+uj0pyksaQODhIxXO7mauCBsQYPlg+SHHdNluMjnEz1ZtIXOBVTrIp
   HgdULpy8qsTFe/wDWGs6GnyIwxhRX+A5WY3RjqAGPirrmYsuIysuD0+PV
   DfJRr5IMsFo42OCztbDrRJUm7hjDMMR1oWwny9NRUVRCD1NsMu291Ljzy
   Xk/W/a1NacabjmJzGs9LZGA6kllIUIakoNPLmaRFGnMhuZ9Pe15FwHxef
   wfWHXYRxHEI/0gOyijhugIcSQchFldtiW5PL3VOTqshWmoT9t0pykjq09
   w==;
IronPort-SDR: ZSUSsmG7Txx+DDx7Tz+31xperqwr1i6+6vfUrFI+/PKWwcvlvHhLtbhWuoAYUeBPqQRTiZSO3I
 /gyMed9tGy6So47UBxVQM2sShRdzn7bEiSKtduO4apc/N+en8uAfyGr7WfCtQEtkgLBIuKeSzi
 DLjG6H0+/V8xL6eUUDSNzSbChjjXZH/FrAz/gAxhKnqoWjS7WfDNiHtCxUMu9oCfZLpkcdGZ0u
 MM1WszNoE7T4a5JidcI2ouhfTj//KU9OA1xJtOKJBQ16CaUIjr7M7zPQduJlWppsZQ1y5BR04f
 4H4=
X-IronPort-AV: E=Sophos;i="5.81,153,1610380800"; 
   d="scan'208";a="263282396"
Received: from mail-sn1nam02lp2050.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.50])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 07:36:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAINQF5Q5IIuNx7DfjIQDDk5OpPfddPqlKxf9J5vp0ZfuF2/XlPsXx5DBI/uVWXzY8S7JXCjYTm7sEJgjgakKstsRcOX66PqWDDc8fhONkSYnSE9MEZyf1K0b7/yqXiBwkhK0nduE27wKf0cpD9D+xLAuxoS99Dq7/543QLr+z9Tu2duBrkxEmg1lrVk9a1OwQFbOMQLEeLckg5jbu+cwUBQ92cId9wFmzeA+YZi7pa8SMVk+j1LkMoX1uqYwXgUUmmV/Sn9v8XlFAuKPWXBlO1IuYgKV0G4vpRiGYtBHUlp2zDBHQJJWn0OQTddAArSTzFqOsiL/VG6VhQlTMFH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MymgdMxif5hpQoYc+WdBnzryGqqi5W00JbYSw6R8Q7A=;
 b=ngSKccV07PJxKXzVMDCMTcV9owpV9b9PyZCP2qkvAtQGpOn5BTJBCE06GEcorxQe0yKiT8pjmrerQg3arsvYPkX0XaQH80y2oPS1YenPgNkVaprJBIGNi7IIChoJKV6+98g3UMCWWkb/a2wJDGO+fp5c02rQkdUe1vf/ggnx/Xm/VVJx0aNwqZsDMU4VmvM05It1Pwe0gTduLmRHSUndv1R5liBFG43wVfUbBsDDoc+mA+ujfenBVt0GS60aWYT9tUPk8iEqrtrAN+B15CU2lolTBVJcsKPJMFEzoa1cJ1yIeXuzZ8Q+AlAt3bJL/EcCOn/GFBgwRBdMYEaAAS4a2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MymgdMxif5hpQoYc+WdBnzryGqqi5W00JbYSw6R8Q7A=;
 b=HgNhLAmhtzqLs3dRwDJvwsfQSssQbx5wcVX1eec9Kn6b24blYOcAFc2pqh6s6mypNLm7DgeMK5H9hmZQpG6u4/RPHoGHXGuxa2zVIrunvCvqSfwZr+g6/VaV1ij3wVXz2vdjn1/YftjeDNF8Y5wN17CQJ6M8dXDWSCnxBh4ZdDo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7632.namprd04.prod.outlook.com (2603:10b6:a03:32d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 23:26:51 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 23:26:51 +0000
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
Subject: Re: [PATCH 10/11] target: replace work per cmd in completion path
Thread-Topic: [PATCH 10/11] target: replace work per cmd in completion path
Thread-Index: AQHW+uq2ZGPexKlpFU+RnHp19Qnq9g==
Date:   Thu, 4 Feb 2021 23:26:51 +0000
Message-ID: <BYAPR04MB496560C50091A46EEF709A0486B39@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-11-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00ff918a-d36d-4f60-9516-08d8c96459f5
x-ms-traffictypediagnostic: SJ0PR04MB7632:
x-microsoft-antispam-prvs: <SJ0PR04MB76325176219D65645B32BCE686B39@SJ0PR04MB7632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4Itq/MRKyL+SS9eYRzqgPks+GQHzeJcp7wfXK9W0/0VVLJrHuIRxjJ6BrOuV/nAwXbLGMWVpBx4+0tvHKaI6pkZeydhnoxDMWVQ60VEO9/tXoF++pAq5B0ghOqJ1CV2NxhTcluUuwA9bXLLOtcMDztJyb1VfpxJt3Ti+nOeWL4HkfXYZcfxZgkTAQq6/i06a5GBM9Cjaia2L1fVn+BHLh6aXutNljrvHdnAlu0rrp47+twHFtRNZWcbp/sfZ8LVxZbQQC5dxrqOJsAYWjflZIbj1ZoND10NQ5Rjibq1FqcCUTZWcxLTYzf4o21PyDmXvkNQakdS1baHI91rL4iChC9fZCxH+Vp5jV1xne6iA4n85B3z7vgfuOHTRWT6Pga5zV73VQ6fosKW5FTWsbfHVMAS4hTL0y8jpiO9xAfzzRTmSgSHOu+mGYKzSs85JoFF59rHxigNdVTQMbFeZXASi648hcRzZ0YRD+GE010f1Cy/qUrI5ZhcyH1iGx+Kd6Cm+3BcpDNMgFNZiBsDKDsIAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(8676002)(9686003)(86362001)(71200400001)(186003)(7696005)(55016002)(8936002)(5660300002)(76116006)(2906002)(66556008)(26005)(66446008)(66946007)(53546011)(6506007)(64756008)(478600001)(110136005)(316002)(52536014)(33656002)(558084003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Von181YRtzau6msIOt6sited5QcnD41FRAxWavIfGMCqk5T2hvPpq5B6GoEH?=
 =?us-ascii?Q?6tnam0KwHJXI/Au352yWV9GAivNf1yWtr6BDwTScXbfIg1tRp+8iHrAXaTwF?=
 =?us-ascii?Q?/1qlqqkx2aKz2pUGHOGfptV8G1Im53kvHqvpbx1VOz4UvZGcFO0uBMIIlYxc?=
 =?us-ascii?Q?bFHMJlc7xG9T8SI2iEJeam/zyePu5j66k3Lb/HdX+QZn4LxXs2RYTVZQvS0D?=
 =?us-ascii?Q?ctK2HgqeAyBhvuwmjXoSLYmzZ4mXOWzQzH9ylkEfh1Tp5PxQLgwuZpI+g1+K?=
 =?us-ascii?Q?AgnrBUj+7xVGXz4avaEPqByyH9sEmA35O2lckjIDIswzOr/WlDIVmvXaUswj?=
 =?us-ascii?Q?Nz1kyNLdggalo14WMdUSm17N9OlxiFFWS1241WaJktTXFGXg3zfZ9+2Nk2A5?=
 =?us-ascii?Q?nwmD/N4+rBVM5K9sEW9jbP/V5zUPWSwKk0YUfKV0lhXtaqf9sPNaq55ohZH/?=
 =?us-ascii?Q?ZXGc20S9FxB2gK+kmL8tjtklevQgFVofCOMLLjSGtWnXBAFAo+DT7N+nDMDp?=
 =?us-ascii?Q?7yD13aGNEV8b/R8UWCR5fEUPJw2i1tZeEOm3a9xXkAFIJT4sHsRDTYCZK8Qy?=
 =?us-ascii?Q?hmLLdpo/C+AZklzByFyn2IVAlrag+1rgKfVGAdurAhJLv6dXfyqIZdu917Vx?=
 =?us-ascii?Q?MF+dDOnrps6TjOQ09kZshRMc4BMGksmc2S+e72ANnJaNyhG786uECVqE8iqI?=
 =?us-ascii?Q?q3MWDbshH8huKsxP5mjP6+7GIaq9tsjonwC0aftd581aPYjjwGYBX4exExr7?=
 =?us-ascii?Q?2w94m90ykIuYW+5vt5nDucjWSfU9Z33CHtaeTyqqUmoFX0LGhVQyfnhpBF+I?=
 =?us-ascii?Q?7pr7HsgGmLqc3QwSItADJp36nLgaMA6HYsxovjgnhz8dMMzM5l/+JB3oAmLE?=
 =?us-ascii?Q?X+yD/VqbfdXJB5a1MiSmY/knlmNqVGmWrmVNb71yAqVLP6/P85CRb4kg5ggj?=
 =?us-ascii?Q?MwfeRRht0W4iXcnBq9c5GSBdoKH44wWLAFaF84t0cS7TJQAxWeCT+weQU7dT?=
 =?us-ascii?Q?Q37TYaThKcRPtELpZEOpOawusi2Lz0aQvqvttqzt2oknINxtSPN0rqfWohoh?=
 =?us-ascii?Q?klocIS6mLA+Q/5X6DlbBGt5ObYwWBO15FI/HbClTD1Kkr69MdWYHGwV/j7l9?=
 =?us-ascii?Q?zXyKv4y0UjXU0hqv9/TvS6PD7oPILM5zgRkpfhQbVhu5gFnWHLSxYa+MICeW?=
 =?us-ascii?Q?HDVBXzWYMQuEFLKnl9NYR+Md99UE+2S3HVGnlJe5QjBnedjhZMaAsDosCCvz?=
 =?us-ascii?Q?LoMA4mVCqctdChhfTJd7FTtVPfQKTEjF9SW0j4sK9dRuAlJz7mtZHluB3/GN?=
 =?us-ascii?Q?7wWDVNdaUopY1Uepdg2N7hZY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ff918a-d36d-4f60-9516-08d8c96459f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:26:51.5135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6zQhLrqKBE2SyZ6LmWF175KC6Mr5PJtN+7gw635zdQqbZRYiqtUZ4IlMwvCpBLQOzMmDVR2pTjpneCQG6zxDOkpsSsJ5IVqNOzrxq2j+HLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7632
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 03:41, Mike Christie wrote:=0A=
> +static void target_queued_compl_work(struct work_struct *work)=0A=
> +{=0A=
> +	struct se_sess_cmd_queue *cq =3D=0A=
> +				container_of(work, struct se_sess_cmd_queue,=0A=
> +					     work);=0A=
same here as previously mentioned.=0A=
