Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18D5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiDEGQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDEGQc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:16:32 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B7715825
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649139272; x=1680675272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yd45HSGYqVJ4FNcgjZcCvNJfJKtHukewJQ0Q20HWQ3c=;
  b=WleYKZ3L6J9iHOd8H/l8Oi7L2F2+bB+yUoMAETsyfoslSjgv1fnBsfch
   2oy57W1YWH/SPEBeo2QnqHJ3WOWAXPIpQe+XEejDRGqBuytaGACn7wMLk
   KUTPlFaWpnc2vkl2HniVwtcsy0s/tpDNXGwctGy4Cgm7x32ixDsJMQukT
   n7GYO+QC/aSsVpooRvyNb0yGrIoUKhckK+rL83Se+sWlfL+KCupT7Ct5l
   lYftGAKMFmdxHH3QLFHg0Oy3KGKj8YUKRhCg9Izh00q85Og7rsHKXJhbt
   vrthe4v+hEat6eFNlruXg8XJoEpAGjeVE44SrWPItRF3j19zbqaZ5Nofr
   g==;
X-IronPort-AV: E=Sophos;i="5.90,235,1643644800"; 
   d="scan'208";a="201950597"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:14:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2Y8uuqjYablE/F6e3WnCV2n9UJF092If1fEG2oKaBbUbRfhEH0vNANPLy8nuXE3tOGLlV8UT0aSfd6yT5oEz/ofRaNUnAkNSRKsE1ZKYSa5USlEj94QpX2CxEkSRvI8ujZtYX9xbpbE40IuXb4/Oz/5VpW+/34wlocNFLljIGEk5r1Y0x8++s3Qt8uz+dU3YzCmTAO1WkXWkuL+KXetR1hT7uEwv/W1P9MUIk6L7QS411OJxOlAHHJ95qJoEiU92GErb20bikADOsccSVHcnEai6QAR7mkXdvjz92JoeSKFhYlueI/iNsUi8WPzMCoYU5fH/Ld3SFb2gm9+2MYZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yd45HSGYqVJ4FNcgjZcCvNJfJKtHukewJQ0Q20HWQ3c=;
 b=OWlQZaO07tfW+GuNiybpbJjjBxfqac/o2ce7fEYIg51+xTm74Q95PKtepgwq26YoFpcyvemCyW6vBNB4h+XiHgy2BfuBIBzkwWhZuesBXmA6XcfIvxQAlSw9FKyLsfZ9OSlW6z971FMrLsFQjIfDQWuq9NoQIpXerHsacuk7Opa4d9RxhnNUXQyVX0YtuGpvfYK0+eY5GMNfbr0IwdpRUMOjrjS/46tDTcFx084e+J3u2h05loU0B9ZV/lhJWCCtCBWD+Ss2I2Kz0fnIKnOWvUZq8OnKWchvqlO7ZVljPf3bZMRYoFLqXFUKyCP0X3vfIUQM5/oY3CRhj3XgaDIOEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd45HSGYqVJ4FNcgjZcCvNJfJKtHukewJQ0Q20HWQ3c=;
 b=lb0TpqI8ubJx+Z8sW5vGg/xhnh5rYZmoc7F8sjxd3jae8zgnQ/TCD5jypaNgudI6/FDRSLyWQ2tv7PJ85DaJc0wpjD3L/oMZlY4k1gMuyD3HDAG4EIBi6S3oNb+HYMqQxbmXCAN00K6KrlK12vSHRSJnLvJPiMmMe+9/p4Vf7ZE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7197.namprd04.prod.outlook.com (2603:10b6:a03:291::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 06:14:29 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:14:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Thread-Topic: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Thread-Index: AQHYRU+53ppBLoiabkmFw8ebhOits6zg3gMg
Date:   Tue, 5 Apr 2022 06:14:29 +0000
Message-ID: <DM6PR04MB6575DBCF1BAC2FA1702D07CBFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-10-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d06ed57a-ab55-44d5-137a-08da16cb8b53
x-ms-traffictypediagnostic: SJ0PR04MB7197:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB7197B76D0F307C50A0CF1ADFFCE49@SJ0PR04MB7197.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ryfR+gmf4r+3KejDkvM0z+w1vyBilkzcMSoETsINsHhca7RcGh0a9VzMxBlm6kyG5SgIYMfcqIIqnhjAFxxlDfv5IFaPfp4NdUHXZeWSdnJHHbEjQYdCj1DzRiHanJOVFPiRszK76FoiBXsrzD42xb0xfhjX1XzDJh3xQ93oXed62aDRtAxl4KpMtySKdIlgmFZO26BaS+bCDUQj39i0N9IdQIIErDSC583eCip5haslhEaLAYCHjZsdOYg2+OCwwbzsxqUndfdisHdWK1gSEaKDOmgcvuUliASPD1ZVWaDuw/ZkYXwsZ9ttN3prYAiN0Y7X0+hbKBONB22Ygic7qtJZI0oeg8ZKhDR5bf2GLwSKp/EyOi2cM4NvYBbO6e1UObyOBOyQ5y2Qsbb0cIsSGcvwCe5PN376cMGrXfWoF6b0WkepGyolqgm242G+kEG2h10Oew7NnWrTuBOxjwbE3V2ikprLZFqAxZIaBRFN10pRrDDNcBppV3+NPbmcuyFd902oVUR9PBTtIIJ49l2nbOA9bKe2n8G2v7y49iXznEAsUca9zkV826SRAGtchBje5r0UN0/WnA5QRaoL/YjxFHF8Fpx72bXNmWaZZDfSnhAtFI+Q8SPKMGpreJjFX8hUEekDflfRnyKFhYC8hlRztPLjYeC0FhzVWO5ytO9/rGXj0HepKWQVfJHw6rm3obBE13VQhuFlJbl19EqTIuhE8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(508600001)(54906003)(33656002)(110136005)(122000001)(316002)(64756008)(66476007)(82960400001)(8676002)(9686003)(7696005)(6506007)(4326008)(55016003)(66556008)(66946007)(66446008)(76116006)(71200400001)(7416002)(8936002)(2906002)(52536014)(86362001)(5660300002)(558084003)(38070700005)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4lFYFm7S/ZOKRyJvLbRKENJQG7jxrDiPtELoLx1+LxSWHz264N1VmL7S38WQ?=
 =?us-ascii?Q?Mkk/lgIx/q3imoK+PfU3BpyqQf1fSc4O3TGWwRe8w/kl77s9biQHSNLwt373?=
 =?us-ascii?Q?KhsePHQUNVGxxKATScUaFVN9XlguZ2DKT3WUDx2S/0cAlIaNIpG3GLI3CNTs?=
 =?us-ascii?Q?jlVptvOeFajMbFvL+82s5iJhSq/oalF27wKyMefYQKfA9Xr+wj+cET6JLRsZ?=
 =?us-ascii?Q?spfiD4opdFiw19+C3+APCHJuEbN1G0acVs2frIbLyMx1urO9OZthNJbhwgOC?=
 =?us-ascii?Q?AZtn6wGMOwABmHi9GniyeFujPfCAELRTNFjZ+9oIoIZc5StnAreZnToZJlfz?=
 =?us-ascii?Q?CuQ8YGNkYfc/JdBEzZ1JFMfcsmAxDbj1PWl8SPqflxHe59Ym7k+R/HyunR0z?=
 =?us-ascii?Q?izlP6tTrnmqaLuMcfgIh/zx9FuEI3151UOQXbcMNznpJ8lRZJYr+nJ+DkPxR?=
 =?us-ascii?Q?/KgqNRLKbMOOIQ6pSufG19IFW11saERFBXF0e0bdzfFLWhqT6kODlW2WtXCi?=
 =?us-ascii?Q?a7LnYDGmGDXWENmjdVE1BPLQZEbOnDqdr7K7vJ9mzCZUKQW8ITMMnZwNMYs7?=
 =?us-ascii?Q?5nw6LyU7Iew9WMU8jLv0rvR9XMaT3cKlKhrdLnSjGYXGV7via/HH8qzC5Oom?=
 =?us-ascii?Q?aIPqwtIziNnylbtrJ45nFxESMshi4fMGDMQTd0W43LOQvc+ZzlPyj0AnbaLm?=
 =?us-ascii?Q?qWlyKb+seJS+GpsoVmDF185unt6cQMfAXBjBI0Se6YC34lZyz3aMcA9Td0MO?=
 =?us-ascii?Q?1zKPujCbZXepiUaEku0tAyWpKy+d60Yx5PgW0cQGt5jGrGj6OikxgdXX4+f5?=
 =?us-ascii?Q?eUXuVHNvMDp/fdA/MXFS7VbAS7UBPdB5j5ck5iK1dClLGSoV/YSdu+/M+thw?=
 =?us-ascii?Q?e/8v2U4p+DVZa+4mWxMnYr5NpXIypg6AP9K08pl3ahGZ71a5h/J58zf/Gzrq?=
 =?us-ascii?Q?w+czZl2ADxm+Cl6wQNkgCOUw1FnB2HkGzBtocJS/HYgI5N9AOlv3TfDUSE/V?=
 =?us-ascii?Q?X2ZwYP/2Kw25ID1FYtBj040OSvvRv021ZoTrwcG9rlbZkvygZkMb5sp+6MyN?=
 =?us-ascii?Q?OVYG/agYs0q05Lg/3wT9sDBn+DEK/nFMBaOa7+yUsPUOJtq5rkpCzFK9UCzX?=
 =?us-ascii?Q?kYE36vFfT5rjlTswzV2ybzLZ8GqfDCH406w/XMGuhMySZVEaMUjVV0dBlVwB?=
 =?us-ascii?Q?Eq+fXZh84qJCZIhV38ll4SvzXav945I/hGmLlqQTbaC2oAHervYVk1XkqS2h?=
 =?us-ascii?Q?9AlmqAZXOLP/v/c7Q4JjnKMKgjDdN6Fqnzb91Dn37WctA7O+CXbqK3xPGlwG?=
 =?us-ascii?Q?0FPKrTuLyWMDd0pYhLFC6Qy4pvL89p9qXSor/922KEndCxikdU4+Hpw8FoS2?=
 =?us-ascii?Q?o22LGoe24VTJXtPtr1KNjpAzI+Dm0AkLxb4axnC7TPtj0jafelBq7ePOQH93?=
 =?us-ascii?Q?vKKxP1Es5rUJ+n9s45p06L6TURiI/JOjje3xOTE8/DiK6w8kmIU2jflo+Uv0?=
 =?us-ascii?Q?ErAJS5QMtoESJ2wbyso6d0UWJf1r5KPmnuNWneRbb32XnL9+Qbxs+XNwCFf6?=
 =?us-ascii?Q?Crz53yVrINQJmEy2VCli0lZuhIz4uSonsDwbtskve2s66foA9WqvwnBYzPSU?=
 =?us-ascii?Q?Oa9ya2tcuYFE/EBxStezFeSVtfCoNhJiIR6SYQsBRmJueXqUH7zh2AN7+gFA?=
 =?us-ascii?Q?p0hMfZ/g7BQRtLjZp0y0yh24Hv6Kg9ktfa7YIbOQKNuNtdklz8bPMXw6W94h?=
 =?us-ascii?Q?ilXrKBmmOw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06ed57a-ab55-44d5-137a-08da16cb8b53
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:14:29.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bMucKBuo8f8uOOOMAKaYDjA3IM1ImFYMsYBc0KwZ4nKDYgp8U3Uu9Ih4F8904m7gbZvpFh6CDlYCXKEg5B8/Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7197
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Declare the quirks array and also its 'model' member const to make it exp=
licit
> that these are not modified.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
