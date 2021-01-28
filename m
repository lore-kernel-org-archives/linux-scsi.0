Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FCEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA18964DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhA1FSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:18:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:34587 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhA1FSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:18:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611811112; x=1643347112;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ddp9Z4rqMdeOjy1Q1EFsmTP+4KLuZAIjrc92pM5wQIc=;
  b=oHUSc4f8ar0YpRu//20rPAm/M51tkLodAwd3egfFq0REkC0IjwrbwukC
   AaaUa/nQmwO8/ZGPMHqPzca+aGOXNF52/zjxQ4SBcGBy4bsJfDcWa9rRX
   JgbUdi/y8XEdo2xadD3b1GEgiYpvpSw9fjjyxZVlgu6VaPNXOHdiXy7Xa
   XgDr1/LxuV5/xfaJ9SB0ZgC5ieY8JgFmxIA1670IRw2DBhimPL5JwE708
   aa5X9QYv47I2dPbB00geqZJ4hfVCsUoQf9SILBAAnw/4IjrZcRN6BgXy3
   +xpi3E3im2weUu7k3CGGfw3P85rjBr/lCAvd5lr1SpI69kYfic/Hs7Dn4
   Q==;
IronPort-SDR: nuNDVrU+hcYN4yFXQSVbrcpYvQfXRlm5dEAk9VuCtDaBWai7DK9kGzoJDGaJlpkPlIkmqQZzSz
 ulNf7yfkDHh96+trTlZlejxf0lB51Fu3+jK+Xk/htYoG38LkqtEMCOWgQ/pnLbjcbiTEW8dn/a
 KZ9g9oHZuFhjwHsdg8aaIZv8KhhYkoyE/01pG++HMHqp8VF7kSW8gG92STTecxkfRI7z2jCMxs
 eEdAbANDyM0mw1Xa5P0VaGtHUjPu7PQtYzckT0VpBYGHX8F6ytGA+MXLtrwnY9BoZVancrYtIy
 LQQ=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="162957234"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:17:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=av5gt1doDjX60G62NXCR5diJJwmtiaVY90zB1XQZfAA6HJAMC6Ln8Qg/8QFYdZ3rb2L/dED8B8m9YWixlAes43CRhIw+WEsA/AFDjoLCqK07nCBnfsgu9bL0kfD6P4dHJLDzOpB9yhm5WsIAbBd4+4D+RV0TpsvjEVKSwoZIccjRNZJ8FteJIWoCY4Po0W+CtEd9+ATurX2jujKkxWPbK9baSbPzb0cdKl/mrZgN7AVbi/Js5qdO+VMmiO3WghZWAOMyKW6SxcD0AUL9OQjPWfKe+St48pbFbwbGPDrc55EK6ws0iKVXDSznyR6hFjFcUOfYwE8P+wkSBOkxk+Gbcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddp9Z4rqMdeOjy1Q1EFsmTP+4KLuZAIjrc92pM5wQIc=;
 b=Q1YsE0lCI3DbBc0tIcDmsqIKO5n8bDbpZylngWQC6evpycL9H/XL3UDL7+vhe9i7YMl4abGo5TmsBhKXy6jalNSz/iTBcU2Ijbwamhi93yPoFdpCYBUKApmJDA0FbosodoYavFfeDFUGoh3gIap1jTGPR/VRQSKui2iIPWQjcit4JvPmpZSkzw1Y2VElWFrITzE5Ftx5W+FfT6rBFLCB0A/v2HOSz+rOCFSimeTHM1BdRFbDuFZR4TPCYeAi5QGwydFY33P5NXYAQ8kwWwcDiiMFX7uYyb3eC+OWh5ZXzW0V37XOsEq17gvlrDzjxg7hlbnCBOzsF7o3+fI536Sh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddp9Z4rqMdeOjy1Q1EFsmTP+4KLuZAIjrc92pM5wQIc=;
 b=fVxZUpWd5G40Co/SfZk2OaE+hA+wtsad0BU+kHeE+wmw0Ana2s35zHwT3fBZnR3eCj1izqXLE0wH3HpPx5uKEKvXF/XOUsrpMV5fzo1vnW46ZuP0rF+bwW9DV+2U6ay7lLJ7cKu5oeBu3sbUk/3mKzmVH0nmZ0vHIjj/QP3Byw8=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5591.namprd04.prod.outlook.com (2603:10b6:a03:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 05:17:24 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016; Thu, 28 Jan 2021
 05:17:24 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 6/8] zonefs: use zone write granularity as block size
Thread-Topic: [PATCH v4 6/8] zonefs: use zone write granularity as block size
Thread-Index: AQHW9TC8dTbXC33JOEevBZloEgFWUw==
Date:   Thu, 28 Jan 2021 05:17:24 +0000
Message-ID: <BYAPR04MB4965377962784FD8065FAF9886BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-7-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8cc21c79-a94b-4669-3dbe-08d8c34bff5a
x-ms-traffictypediagnostic: BYAPR04MB5591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB559140C0FFC3E72E0AF8A13E86BA9@BYAPR04MB5591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9GeqJsrdhgOM8fPDdNu40OWHhkiYzJnAs8Fh7MKDkPzw6s9z663o2sZiO5TjVeKpqLY7yYJ5sOyj14tr696CXb8WSoUZ6dgOCUEz4dJA/yd88840H2BwBTsCnQRC5oiapqUrs4QPCWai9WYF0UZleHxf9J60jmbxW55KfbRpCRlNfsreFfRKEO6tBd9YyYyxxGNi5B1kiY1xWapirLD3gUwjN+feGBk4cTSBBY+qehvQfjUnhBZCSowZApVXJHSgkrCODevpG9WnY0JydTE8KxDdFu4FClB9rgGoi4n5CnWNkLbWlR+0/2H0YAaH0IVaPzWLtGKbyVW9MOy5NZHYFcp6Y7L0HTw5WhOZQUAQI0nf2wGDGSsLRXBct6x/47yj8DvrUI+gvHlleZPzqWR8bWRPBKaRA+YuwKI22lMDGNOO4Z5rjL6ol0t0VCpXmMHw695kHte7eB01/28zvd4bOM3BMDafHd7Q7eA2OdKf8LWVH7ITokChG/dRLfvjg6zTXt+iM8xvZDJ6lAaLrWbZBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(4326008)(66476007)(110136005)(54906003)(71200400001)(33656002)(316002)(6506007)(4744005)(83380400001)(52536014)(66556008)(86362001)(478600001)(2906002)(9686003)(5660300002)(26005)(7696005)(55016002)(66946007)(66446008)(186003)(8936002)(76116006)(53546011)(64756008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8Sb1P7nCEyl2qonN5RduF9FjFtRtKuGhPBBhkZ6GzDy9xHGWS8h1oQLIg4n+?=
 =?us-ascii?Q?P9MLV5oe+k8WBMjBeGLiX6QCze0uwcjcPhruOBfbMTdUeOsLvg13UfatDAqn?=
 =?us-ascii?Q?taOKGNg50jE3KAR6xlbF0hEiPQuIeOV1tk14wpwUcoTeNAPMe9WxFTdEygab?=
 =?us-ascii?Q?RP9qHSXCjrXi3CIR9kaQhKDub+DjSVsRZ+u+4wtP3kWx1ln4EhZ2KGwLI/YY?=
 =?us-ascii?Q?w03YCfFDlW77dm243xBeFS12/oV7SukWzbfWZoLqgoOfDKqM6kkFw1sW1gFw?=
 =?us-ascii?Q?8rSDt9z+El0ZhcT6QJpgrH2Uj0mh1DLLRX59Iw3iMefIyCoOwyZl1wG7+h1I?=
 =?us-ascii?Q?N6OaH+NPGJVJwjSPezpS4Q0V6xMwmHWJi4hUrxegMt7V80UIAA8eN3vN+osF?=
 =?us-ascii?Q?2GxLj4oRF8+eKnC7J9rl3mdBrkdaaodqLv/5MXlwv/eS61NSN1BKjZ1oZegC?=
 =?us-ascii?Q?XGAKyY/Bm341fYTpN3xmYeHV7rBjrHkopLsbDPgors45QZhd0UglMhZ57oy2?=
 =?us-ascii?Q?EHJ6aJek5z/cRvO+9UeVn8nFoMu3+auwD9qnKvqNmwWZJWKJZP9dkAiwxzKE?=
 =?us-ascii?Q?mIemZSSCuvD55sfDWNaZd1DJxzqLYk/geglzj+JU5fte7AuuYZk7CzgYLle7?=
 =?us-ascii?Q?DVwuuaPZGNI+kDNke3QdAomqm3t2Wt+CPhObdefN1uPhifQKXpZo7JQBvGk1?=
 =?us-ascii?Q?pqLzyKmDinecfySHnWEE8c7HOm+APbNdwwBOiDymzTS9dzxxbOttOJZeSV9t?=
 =?us-ascii?Q?+qsGjLkB4SZSeGBo+A2khDQZ9NEEkkEfRuovT2AXa+9E8OlsqA/3d8W63bAR?=
 =?us-ascii?Q?Q87RHs37cfg0dNbIPXd2Lmj3/rLCRNI6uUqbXS5T/tfXYLQeXu/Oycjd/sy1?=
 =?us-ascii?Q?bxS0TiEJKT4sNSlu92JHOV2cRsTP+7/tXLVoMlg9X1X3o+3C1sXN7hY4/vnH?=
 =?us-ascii?Q?rbJ3P/MHIqk1RXd5m6E9Obhq+5UJo6rWf/DjdUd6iisvCN0lXDOvg9mGR/Ob?=
 =?us-ascii?Q?7T2m44pgSAgyNgImlTIYyHuKSiU8BtCiWRTJo4me8Um2KIKK6QQ4AeN1mwoN?=
 =?us-ascii?Q?4FLcvQ7+4IRpvYAXgGAgRikvjpuNqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc21c79-a94b-4669-3dbe-08d8c34bff5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:17:24.5843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jw99Akq+VF1Y51/MpXqlyc9D/tv6nVFVIpKnnCaY9MbXIqfhkDPlEKcOXMK+s0wjYK5AObBOYiGs2xZPLYjsVIzh+LReO0m4H2v/W1Jo3bA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5591
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 20:47, Damien Le Moal wrote:=0A=
> Zoned block devices have different granularity constraints for write=0A=
> operations into sequential zones. E.g. ZBC and ZAC devices require that=
=0A=
> writes be aligned to the device physical block size while NVMe ZNS=0A=
> devices allow logical block size aligned write operations. To correctly=
=0A=
> handle such difference, use the device zone write granularity limit to=0A=
> set the block size of a zonefs volume, thus allowing the smallest=0A=
> possible write unit for all zoned device types.=0A=
>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
