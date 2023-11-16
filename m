Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9E5C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 10:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345029AbjKPK51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 05:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344981AbjKPK50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 05:57:26 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DAA1AB;
        Thu, 16 Nov 2023 02:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1700132243; x=1731668243;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=GoLSe11yMsdVRl3d6FYIxrPQKIvqCrBkS/4Vx3KYi7g=;
  b=ViAiv+jOZuOErPE/Fk4wQ1/ThlUFPJS94fPuokZnEnslDaBt/YPX4Lft
   yAn37k5PX+KzHu00LccxcgcPVMjgg22TGJUruzS6h6h6NO/zBTBUmRBHK
   CJ39rPmcCE85+YBxeDIDKdUvOdMXDMhOqz6WfLxDAQl31FFNak/Rk9h9w
   hhvN0muxnLuwM3GjewDUn8zxGCqhJcmM1YQAXXJYdf4E20NSITekdOeyH
   EPzAer65BN5ehdI9y7SRChJGBSL0zLAOfCsI5zFVRx6Pe2RJSNqY+Aiw8
   0qQoIWb15wB2QEC4vgYQynHBvQ3Qpq4iG2sUDh+gANfC9hgFxAKFA0zzr
   Q==;
X-CSE-ConnectionGUID: PDvvkg8zSFinLV1THuy2uQ==
X-CSE-MsgGUID: h4Q1xIXcQu6lMw35XCU1/A==
X-IronPort-AV: E=Sophos;i="6.03,308,1694707200"; 
   d="scan'208";a="2462489"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2023 18:57:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXvd84xAR8lIbO3rXkAmVdUe7UpMJ/L2gOXGwrlxRxYc5D4OvXtLzj6KLPqKZI4BCKOmVmcjnJRSiKUNE98kx+vUuhtzztNqcuLRYTyJ0gC+ByoN5UfUoiSYqcCJ/bAG9ijbCm9ix4KeZCK0fE/x8x4VGzwJ6pBgRC8VyM/EQWCP0/2RppW3j58DOCVuROaoOdvwwOj3BnvFPRdntuvVXcbM8VGe6rghrEnuR6voFePSHL7P64O6g9lOyUdnrXbv69wxz84JozANj54/MNWMmOe0gyxAjCW39m5iUp38ODBSanIPLAum2KB77nbiW8/NIrbKX1+gLG0MvDKOgkHOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlpvuQQEuuPqewXOm7YrJS5FwubGiMTDBGECwTFu9bE=;
 b=Itsgd2WFeWhST7ET/0WZjrfhuD2QounwphvGKlnj+zsFmTnf/YJN88AHNePSjb6gRam/bV2s95dcoBAXkytUwhNG+bvS65PLzNXZeU8COf32hPL58H39GRUacv0hC3sgzoM6pFhafN0sc7u0hvUy1oBaVysWCqn35Ff0W0VcCPj3fr5onFc00/3uCWBDgPXXBuX12Rg7gyyeP3gilFdJJzobdPDfMdqYd6ZqB5zBnb1JqFR3nNreQ3RktzCUBjyTVElKpLTWrU/yRfsCJ7OpMw7DzgwwnchGvTQrT7UUVGTI+ylGZDchisiCeGEE2nQdjf9Qn2s3yO4TQ9KSTtydLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlpvuQQEuuPqewXOm7YrJS5FwubGiMTDBGECwTFu9bE=;
 b=Xgxp/JrnN2Pvu6VZBg/u8QpAq6siikLhLCs4It03RFncdE0shoFZhn5z3IjrAFTcldgdir4hMi6N/YNQQZIApho6abGmF1iJY430wWQj/SYCXnrLrnneTSab0tLRmke2Yw6RppfA5iaHIMuAQ+4gxKIKdNLGNETqB0WPeXQ1DfM=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB7566.namprd04.prod.outlook.com (2603:10b6:a03:325::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Thu, 16 Nov
 2023 10:57:21 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 10:57:20 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.7-rc1
Thread-Topic: blktests failures with v6.7-rc1
Thread-Index: AQHaGHuszkE4VeL1s0+5hEVNCeFQ9g==
Date:   Thu, 16 Nov 2023 10:57:20 +0000
Message-ID: <ytcn437kppvuj6pwokthrh45asmupbbmbp5ybf56yipo4tukv2@g3qau7lqoooj>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB7566:EE_
x-ms-office365-filtering-correlation-id: 89461bfd-d89e-49b1-c8e4-08dbe692ce9d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0uJ6lrJpMzawtGOEh8C9KSyRb1r2a3f0YsJu7RaSfXyF4gqXnA+zZD2rN10KzVG/FW25Gfoct4Z4dNM5QDDyE0JzQIBNb/daN0XtOWtge9HtYDZMxaq0Ai8NtLKnG8FWYdlesLi622Rf51M1t1gX1OGw9IAB/0cYP8Mtu4+l5b1Jhf0WIS/sIIsDUZswo+5n2YOZ+ybrGEX5VS9bWORd8eDoqxh3fK/p985IzgSqlx3nc2JTOQqPHxmNnkeXqComifwG31ay0cJ0kbUPOAl+CJsjjz12JFy3HKDVsPhKYNVvtxig3bpr8QZDTy967kQqAKqQD1mR0hivWZI1CQScN/gYawpeV9BreFw+eIrtvIDmf3ZVYfMRK0AfCuD9XzIhuVKl8jh5GWGGQzuasN7wspW8hJVcgzE6bZ7DGkqkWcOZnkcthL5hzod/+QLBr2YgBx7t1W/RIhEsnNB6l4iNB4DkO1MJsgw314njebRna7NslQInTjFh4zLHmRRLgA63Fsag9jFQv3R1+/F+mvyvoUPYfgl8+ly5NMXgvDvDAbguVh9jzO6WP4vQ5T3x8s8qQ0oZcZmM4S98y2uhJsAZ0VT0GEpDzwbdVNlrq7BQiHFl7o3Hon3QahXNQwUXF9u4/cbTmRXVgrfq2/H0xdWo8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(366004)(376002)(396003)(39860400002)(346002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(66556008)(6506007)(33716001)(71200400001)(41300700001)(6512007)(9686003)(26005)(8676002)(8936002)(5660300002)(44832011)(4744005)(83380400001)(966005)(2906002)(6486002)(316002)(478600001)(110136005)(64756008)(66476007)(76116006)(66446008)(66946007)(122000001)(91956017)(86362001)(82960400001)(38100700002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ibwlLkYvgihByoAs2J/Il8PKxdYHUUNCprTeYdmtBjdqlEJUFBmgOMru0EAa?=
 =?us-ascii?Q?xSKlxHISZIDcSEEKGpUSJmpyNG6K1jDnik3mJmynNvrDzK6o/HnwNeO7m9mU?=
 =?us-ascii?Q?iKkH8lib4hynPiEBBuZFRHzc9zj3D0jFWpE4W4NSs6OY3Fp025R7OOKsulgn?=
 =?us-ascii?Q?r8Cd8BKSh5ARBrtwPptO8Ulm2S8g6s604vWxaDv+57i4E4tEeOByKBRcoH93?=
 =?us-ascii?Q?oltIBPEDy5f73iL3XptxF/OdpJvoEl6lo45P1Zdj/aTtwtwD2kp8a7IdXrUw?=
 =?us-ascii?Q?acWQkUnagPCGoflrgER/PP9KF2iNdgqFFs7GsvQuT63um9SITcE+ctBetI58?=
 =?us-ascii?Q?le+qpkM+B+a+EgWM7VT3mph7VYWaPIxuui7YnCQaKoudYZZAjdiaiZ/rMTlb?=
 =?us-ascii?Q?316ZbtkS7lvr/WnQEL/nXJa1IjBW8WiXcgrwnG/aHBGUDJgd8/Dvu63sTqvn?=
 =?us-ascii?Q?SYNI080IAf5sqNRn90ETl+DH5Drhpt9QoEE9Wb4l+IMQ+hfdUGRWXa24FuSw?=
 =?us-ascii?Q?Lxe7Jp1JuPEXhr4jnyGuc8rVZTVB3QwnyBuvkMQBBEgIyMftOwPyU7k58zGl?=
 =?us-ascii?Q?9mBPQex3tmZTFo6XiYds6eYqChoFZ8zLC4yE/j0k197AoBIunlZS8f7blusW?=
 =?us-ascii?Q?OE2w/0h0XqSBSfI1qVPNMvyIueBXmGNGaptETxfGfI7Q/YzmDtOE3/FR2oUf?=
 =?us-ascii?Q?KoULgJ1hCZfLy016IGYl8S1poJY42rNR8DPvxumiHfOubD8A79XSpiEBca9b?=
 =?us-ascii?Q?d2F8xZeTR5yzRayQ8uMO1/RUhZPei9xBGzSwmOEGPA5tA6TkEumdu/vcKLpE?=
 =?us-ascii?Q?5hxQV65WBTBearFCOGOIkDdUf54aI64jwicE0AcB/BRxS2yfeJlkMT6efRJs?=
 =?us-ascii?Q?O4KsK6qLcVX+gfCgi4hZKNRO4RH64YIi3gEYOmBcKaJFgn1SpRNlBeFRaDfn?=
 =?us-ascii?Q?m2/1OxIHpGYqqUvCIsTiq6PknnQfiX+PeA5FMQ2vBgAgJx4gi3iEHueq+JH4?=
 =?us-ascii?Q?WxEDuxUnpWPSfvj/+B7QVMxthtQ5Nvtn1L0AkGsrALlD6JJHeF3GuVDsxIwH?=
 =?us-ascii?Q?hN+GJDNciACEoFPLDXq2DzXK76sWCzxN188LjHXK0AgnTZa+S6pSqb+FTIyI?=
 =?us-ascii?Q?HDKems3bYbhkpD8PYHtZ7fgYZjakXcN0Qw+dsVXC4ihoCqDgrSakq51BBx7X?=
 =?us-ascii?Q?xDAjI1aho8PLvB+zHrjoYuQVmXkzWimsD58Yo1QD7SV1v51XcSULEdVIBjjC?=
 =?us-ascii?Q?9/rE/TUuZXeAXhZG9B+s/mFMcXdI2cRQZGkdUbrik+ADO7ynHjb9HUv5Fp4M?=
 =?us-ascii?Q?7MBMDMzwJfAsAqoroTWPRZrLGuTnfpNJ0fFixrQxyQNweahpgboGOEUh0JFj?=
 =?us-ascii?Q?JhnsW3757bLO0Y/evLBvD0cjlkWJCXZtrJHhPN1Fwm/BaHtV6/s+Jy3Xld/w?=
 =?us-ascii?Q?we+Hj43ZuTnFEfOWXQwGlNHJCdM7Z8EOi0ImNOKsep/vnG+hyDAjYyPRsAeh?=
 =?us-ascii?Q?q9dAPU3xDaVzzCnY+I1p605ahjtyI40n0geR6I/MN2oZS6FoQvOJC2c/WK0L?=
 =?us-ascii?Q?oKIf3A3j+uXJGvekESFFQjxAP8CDWgqqRudVWfm/JybUjibFOJNFGJaa9VPn?=
 =?us-ascii?Q?L/FMKbVq9uaDBDrcK33zVfw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <602ED3C3A1D8344E9902B0E4F2C68462@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jl19xa3WlN2rt1t1V1tcuSMFR+M1ouzoTNffuUlmlwFVbuauGC5xu2ET6YtZWVZUOe/frkz2iWeFW14FgXoQ/I74kiUtfz9oJVtOKOc3IL6a8sTBpq0uppxF7tGXLpJxK5D5537IGg7zjf3GtLYmppowZt/UnoY4O2OkbuOO25Sp9HbUc+yXHqvTddO75IU1HAvaBvJCYhGkm/Qg/EKqbFoZlcHFnDhjz6eebZAR/Pe1VMGpbwzBgtYueNP0FnIbTmmo0Pxds0AWvKBGXyTC4s0XE/Ctrp7GplzPiHiIgir/3PUQqZQSAmctG7VjsjCPpZxSpTCF2HIzF+VhRw2lgWD/0XrFQksXWT+jgA3/uQ7YQmNfDPs7fAvPdJpsglvnpT/TmiJV4WHkpYxHmRKWcJKzJGvhEEgUxsbKQILQti8jMxluWU2odjvHSjL15OUhuip02VOQd4bqmzQlTSDNdUaZz+zozMaB8zV1HrPYrnE90LxPIo8WUmnabAjEBWBG8hNlMGGMc9cPeja/qYYD7tHD6FNG3o2VUozIqFtWosFSR3gM+sojenz2W8iCWqCn0tGIX1aW7/9yk+ng1j1WBJ89C0Uufjo/IbXwg7KHyKFX1lO6C/vWRfPHykMOb/jo49eB8Q+Vv6KKlDe0q6yClzS/QQUYZOlx+GGkG5dADtwutvb58vHhHAVut1rvBYBzsc7YG99lOdqNs82KJrl+PdRhS19f7ERK74TMLS7YWcsqhfSHfb9A0lcBd6qdI+0+SlGCjuvbvbDnNhUUXzYAqRc5OOeMbGw11Vu33ITRd3vpzKhNvKtbmc/A/kaWRg2yeRScJzV2eVZLr+/7Gip+Ig==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89461bfd-d89e-49b1-c8e4-08dbe692ce9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2023 10:57:20.8905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nuUXGVhysXI3nOlflCqk1GJUGoZrhpBkyE+2QfWL4asMmSxDvSAC9p0sk1I6O54BGJ+a7osqHaiP0ixioVirea9pIztrDWrENzcAYPXMbws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7566
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: 8b633b4963b0) with v6.7-rc1 kernel. I
observed a couple of new failure symptoms listed below. The failures I obse=
rved
with v6.6 kernel [1] are still observed with v6.7-rc1.

[1] https://lore.kernel.org/linux-block/6qycihftrxsdvuvpsvmkbe2swy5u2isrtu6=
jiyf3khzusdzilc@34kda7iutwdq/

List of new failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: nvme/041-045
#2: nvme/* (tcp transport)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: nvme/041-045

  The test cases fail when kernel config NVME_HOST_AUTH is not set. It is b=
eing
  discussed to check the requirement on blktests side [2].

  [2] https://lore.kernel.org/linux-block/20231115055220.2656965-1-shinichi=
ro.kawasaki@wdc.com/

#2 nvme/* (tcp transport)

  Many test cases fail with WARN at kernel/workqueue.c:3400 __flush_work. A=
 fix
  patch is already available [3].

  [3] https://lore.kernel.org/linux-nvme/20231020050606.9464-1-hare@suse.de=
/=
