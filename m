Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFF5C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 08:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836602098B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 08:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c8TT/1Gz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="G+hzx4uK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgIMID7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 04:03:59 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5209 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMID6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 04:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599984239; x=1631520239;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=796w9MK1KU+fOhGopwF7u4xaENGsPKkYSz9y3BXXoJA=;
  b=c8TT/1GzRDQdmjVAexJnuw5DdMiCKZ+NEKXnZvfNIdBrEFVbE0i3/JZd
   iXoqXKHKy1C/1vjsMJabQQ8hSVGnVHhU1JKcRJpsmF8NWPzhzgb6Hbqd2
   uXzyzWooipCEwk+DhKYGg4dwJh1pp4Ol0+jCruFP1atkX5byoJuj7PeNf
   jMj1ZHobZ6gtMlTftUwrLzHAwiShbvqLHrbO7bY071nDYVu9xNowIDasb
   URbCituQfNVGSukg0YZAy34xAtBlZjeywufW7inxZguOHIAQMU2ss7H7i
   F0uByMVj/9RDYZYj0CXKf1aTGe+0M47EAUiiWI2gd1EAqpDQGvRDTPCUW
   w==;
IronPort-SDR: HfMcaArLUrYR7Al7btacITwH0h6f+Irq/GADQVKnEYeHFxQhNZ+1GsVLXmfzUy3VQZbsBSgkMQ
 UWnJo7xP5gZlzgfXc2eI4AUcPjZeSXMQywFHkfA5+VTl8tHbLTdmimWX5Y9B/5EwBMwUx3JXwZ
 EGjwbjOGXi7RmZmtSN+Kc5rJrqeiaVBw3/lbRalVihct09yuo/tcZ4LQGKk+o9OEraDeZ3g+/5
 FHt1o1qSi31PgQ1BPQg6E/oW4s9Z4DE7GWsnQKCfoLxz+bNwJcSiAA35D9S3VNgq0t/at0okTj
 rKI=
X-IronPort-AV: E=Sophos;i="5.76,421,1592841600"; 
   d="scan'208";a="250546937"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2020 16:03:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqBbgOKxWWEcocRXnhyBJELpYVW11CXurWE3eqg8RLSf+ctBdvMZM1tjCEhRazM59WAGP4XnhbgI18x1N52qhavd6CrYMMrxoup2ilH3ZYQU9UoWxODONMlZWabexzkidwj1Xoxmzd+sl+wFT0N9jNtkh5tKpIm+wjMJMWBA67RQZTiw89GygLnyd+sby1P9LiA1H+A1bCKNPLx1LGbC6KM0jNJDMMtXK1IhvjKr0sCTSh5IG1nPwpGOrqfIzA57WI6suOkxLZLGXhycHziN7lQVXbwwWOq+m0g4xgTfxuaqaA3avPrHknYNWYDp9vIeptQ+Fq/KCU/TJynSmzVLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=796w9MK1KU+fOhGopwF7u4xaENGsPKkYSz9y3BXXoJA=;
 b=cd48/JjRbPZauYAZrbLEQKt/f7qIrDPK/TJkXGVa9Iccl0nRwgLOP9T464tMPhhnOit4n3QDVoe1mg1nX7UlZL93f3c4VQ6w3kf+x+3Z6DgZMqF3XbMQ/ulODSvL7wq2U6qSvyR89JlCW3bXmQWAXkbsjPntUWjpknmQQI5LGj9AAwlmfId/i5xC5jMXSED5lDobURao3ilEq2CLSTAMz7AlYVvKWgqUG+0NCqc/oX60cVYPyIrjv7A5l7e+9L0o/aTs++MuSQZFPZbWQDElQkuySnMCliB6odKDlLT1J7DAgY5p06hWoQATRqvrrHwHy4P8j+KA8XlJIyAaXBQB0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=796w9MK1KU+fOhGopwF7u4xaENGsPKkYSz9y3BXXoJA=;
 b=G+hzx4uKlpLdmg00o4p/ND6uZAMlTT0PXBXWtkhd0p6TiquZ0/ulVVIGFktj8feprw6kZkQqKx3P4mg1BoanclMyqu0G0C+peDpl736PHEOYCesr/+JVFa4ul4S3TsJH/dSv2WnnHuxF1P9NvXF4NWN8Z5aDxLarbzTW+pNGMrw=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (2603:10b6:4:7e::15)
 by DM6PR04MB6041.namprd04.prod.outlook.com (2603:10b6:5:12a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sun, 13 Sep
 2020 08:03:54 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::c862:9cd5:689a:8573]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::c862:9cd5:689a:8573%5]) with mapi id 15.20.3370.016; Sun, 13 Sep 2020
 08:03:54 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Topic: [PATCH 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Index: AQHWiZOTPtFVDcwixkCLatlPQn1q6Q==
Date:   Sun, 13 Sep 2020 08:03:54 +0000
Message-ID: <DM5PR0401MB3591BFE678141A3E1EE405FB9B220@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200913060304.294898-1-damien.lemoal@wdc.com>
 <20200913060304.294898-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:142d:5701:4822:4ace:4c09:21cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2572642-03a2-4b4b-8f8f-08d857bb8efa
x-ms-traffictypediagnostic: DM6PR04MB6041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6041C4F525A7A253721BFB6A9B220@DM6PR04MB6041.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GGvL38wYBb4ZzLPFf8BOLOBWkPg7SKfyEejzOaIB7n9xlbVYz5P5LGCCdZdDq8Mnc/Pxn//xp5qhIdVSEOATOtwAfCbdizZSXUaj+s9XxUHxce9SdUGC9dwvQ3p5TOkeS61YgKxVK01DAiP7+elrG6ygT7idP5Q9370+l8UI8Bd4NrDlkinqjo6Yb6fIDOWBwoNTE6d9Rwl/kz6P4JqG/AB7+0taPui8sLZYacHIqUSiwTdvlxHRPNDy/v73gVEAFjS39UyuZsF3Rr0hmR+/wAJCV3Y6nqrd1rvYUtGNvL4zec8A0zgzXl88T49B/XxihWamwx0OLdF8f9X+3PXiLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0401MB3591.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39850400004)(8936002)(54906003)(558084003)(110136005)(4270600006)(6506007)(9686003)(7696005)(186003)(55016002)(71200400001)(66946007)(478600001)(52536014)(33656002)(66556008)(64756008)(66446008)(66476007)(76116006)(2906002)(91956017)(86362001)(8676002)(5660300002)(316002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: l5x7egN2SDdRJJUjTdyOynM0G96kVuZPoILJ5bZ8/pUXaxW//LxyHrgGBoHvnF+opJ4yfHTz7xPTzv7/AUOAxPrHhySVo5wZfMM6gbxAJdWx8kMBw/Stkzood3dg3/KikJHNNYzztPsxns9bPOmQ2MzLhU5icV8y5HnJ/wxEjFDCqYeDr+rjZ7JBbPLWa1RGksVz32EapOOOElpF4GVbsRe1cjS+R2oKmYf1wIIYNvPmRGR9wjgZgxIIvejjcMtLdWGYWODgmjq/6aJAqPjNTDeVb8IeVFl8GuxCJ52FalC3VebP6sCR3iQdxPXnMOuUm4DgQVUiUv0gt4RYvFJO8lFsfFJwp/g6LHnlBU+8WjJdO1nvt8Mq/4AMGtnnBgHh0XtgoghL2sg5A0VAxTXvD67h1BJKUsVX1U6GHemvBFf4YBWO40d7ngse3swvPQNEbTeuyD+yVD2h+loEcBlckGHZaLzavdia0nEuj5ORXGUNsv1/EXlkGGr/hb4W+13TZe+7Quwbh06+Xr4Q72DKP9L0R9wfBf6dJZFs/16ZysnjB1aPVN2QQWxmiIkcGz7WsWkH9Rpq+ivofeV0ND+6L2MpVXJX1CsyH+d+ipmSOwtzmAO4Im48+U03yTkn117vTlnfYvp+y0WngksJPu9wG+sW1sq4BF6CyMuJqBGDNV24r8JOUGtKZ6WzPX9BlFtTI0E8DwsTm5MVcfkWqLZL2w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0401MB3591.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2572642-03a2-4b4b-8f8f-08d857bb8efa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2020 08:03:54.0622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S0B9v50FmkLe0NohCNE2pZyBhuRmFHORlTTWOPn6KKmDyZBVtmN5YY5Kg042luJRhms3oer5ugW/F5NEv19EkMgtjfrGCl4YFqLmDCxvF90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With Boris' comment worked in,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
