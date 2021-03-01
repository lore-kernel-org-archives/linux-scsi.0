Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F095EC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C6F64E89
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhCANCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:02:19 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25672 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhCANCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603724; x=1646139724;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=QXnMeQKL1PFwwHzRIWhXm1hUaTZY0efh7DGOdiy7HNOsBe7SvCFKYfYY
   GAvvEkptZyHYtVUvgBOUjY4V2H2BEUpRphnwfl7B2DQRfgoaS9kEpiK4A
   byJcYmeBVAC6vdxuKwQgMi2xADgCfE0GojH5iWdM1dOOdu+4IbBGqXyRv
   W2kNehjwzJ/Ojxs3CyjIgPA8Rv5/lx4przpp2dzYRd4DUXT4y+/3gwCBc
   2yrsF4Ms6u+ueGZNs91DFO/Iqz46u1nYgOY7CMXUHo/3SPFqV+8tXk/ig
   zDbQtaOymBQwJ2QapOwDTHIYALXIrE/rB+EXIXOl+qBjU9alYbHY5VI9O
   A==;
IronPort-SDR: 9ZwJrUh/RVcBfm2nfcBuDoZWdXp+DAnkCeVAHQvnZRFgza4C4grLPmkk10/ApHRZidRny5HtS8
 UfIE9l0aAzEitsoSueqwhDkoccxLySv5YzVBuJ2B02Qavmfj/Uh5hxoBbImbzdMbLct3fZxcGj
 HNclem/lUu+LcPLu3OtnnljSZ1bBtKe/lWxthh/0EnzIv2kFk9Trd+DzDvTUewVgK9/QRvBVwa
 mydGPbZVALy8roqMwffVzJ+VEbtSio5DRq6yWH8szRuCV0O1k6EEjZrSLcvyZwHG60eH7CNle6
 jMQ=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660722"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:01:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuIzAm80v4fFXseJs3NL0AQGm9rU+FyLZBJJJGmjWhjS6VumBdSKIo1Ghf93JZWh2lf9Ir0Q176MaGSsOsbQ3hBqMML4GScsp5fH2IINFVYZwoZJRPPXF8TagSFQaCjaElBMcXZVJCoUUXGTX642sLf2qOGdSINrw/B2+/lT0A2l8SBepXhULhlPgOIlPHWiCuZjb+7AQefrvnBBA7ospLdQ/eRXroqUsapoFBs0QoXRy/kZ4LaReeEOvVbjnw5CFVJDdejQJdmooW4BGwns2MEB5jy2u4l6dWxRpNqEdaRNtllNSW0VSpS511J5mqbUbzun5W9X+o7DNDabdLqFrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=VxJ0umloXQzNbVOfWUokNOflEB6RGqfihjDK3rIIUi9qaGZQlk/GhyXXayk5jCi8l01xxaznxo46BplVvWpDVQTzJhmYX+tlrdfP1apxEK9HVZ6jLXw3uUU+rTi3dW4l0gYK/vFn0qtN2y5LWt//iZOA1YsvKvlfJ/L+saFgrrvaWrUkiPmD+MV9YvHRYYmTJNzQMk8tuv1GBc/cIXM5NBHXMCXUw1lxLW62992fpeO7JwrsX0gGbhd72hQ4xKkzmEDTHkqWtadEU0WpS6hDnKqJPlF0rpxzZ+O7h3XtDZPtA26txwRZkZderyXBgy3F014u7bJo4PIoeFNTLsKbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=xm8Y7N14Q1C3FDcEHo0EzBWwzEb5IPx+mipqUUgCjBwJBL14DGZHwsDBIYihBGT2crpM26ZzYkbLmAF343P6dZOuoaV2jw+8ieJPpYVqgSG1vii6PmxQLcyD1sNMro2igzevE+gp5e9n7U4AM0Hg7cYCsGF6ym8Z8ZZCBsWIV+g=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:01:12 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:01:12 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 17/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 17/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZdT7zMwW/8V3ESzjF6cYKSwaw==
Date:   Mon, 1 Mar 2021 13:01:12 +0000
Message-ID: <PH0PR04MB7416CE2B581279A0AEDD2FA29B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-18-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 23b9e8c2-0cee-48a6-6047-08d8dcb21723
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB73188C979DF9CC89909B95EC9B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: boIslw8ZkDI2MqkqEO9f95hLG4B5EE/YBt5sTwlNJHwaow0RD+H0hReaTHaVtItiLWMWC307P1old89xnHw2lA8lUUD3vZ0hlXqDJ9DUB7cOACo3EdQu8f74KaSR+HgQW4hWwhZ++yBVtFg7iEHpbcEE9hhimyVIr03IVPClN05F+U9ElR8pV4SkFJ7NjIhgXrBGBhQuqigfeUs7PvZiNgzu28A5UqSrNtvcQiJd9gix0wSBGRIgT+F17tIC9BkN1Y3pRXZHvPmj3ev8ihBU0eegAAhU0ZERdGLVCRXZw630mogzMjLTvBznIe4ZLS5JBAOwycRCKuQmUyJzZU0ykEMPdTT0E1sMCqULqW0pqfu8R2mNhf2ard1R79Pd/JPvkgKNh8EG26f2YVm+tUZkllHHMvEjtedkqu+ngnmIIr83D2I6ttDZjOyebO6oZ4OnuVCL9B/VOY1D5VPG6vIhXXX+A1gAXjHVBOJKEFfFtSX2pZ+jRxsz+4ondInZ+tYZlhcHAAs/gDstmVdcS0dxVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oPqzpa5DFFC8ql7rETgw9lgLp6aqKoqdGoShT0pDIEsOSKjt//qsMbOxwjXC?=
 =?us-ascii?Q?Z72gRSDK5bni5UQmuod+MucnhyzE77dmtpECTV8YBwQ0sV/zrwG4SJFIqlCm?=
 =?us-ascii?Q?BsWGxnRI3iGuWDVXlKBdqGmavhQJ2UeV1NOqi90QXsK+uFjMfP5YPdYV0QBM?=
 =?us-ascii?Q?ZiLLm38Dh+FkvBkzSytuv3QytXnt8YK37jd9oPTt6O2UYIjJEtZViTQ2gD+q?=
 =?us-ascii?Q?R2tDz82bFqekJ6dCqiZKZ0bSfqsFZApb0wF7lVR+wXanOWHu8sbfV9i57ouV?=
 =?us-ascii?Q?nAC8+fVKXjin1qYH9XHKbbyyJkpA9XhFiRS7V8TVtutPpXinKyinehU1KDyR?=
 =?us-ascii?Q?CkxNoOTqPiNN7sDJlB/PgCRF5sDzLhB5vEZC7uEuwbwDUTlQW780aZgJ1YSd?=
 =?us-ascii?Q?8/bqKgc3Njzca6zgEkwB+7JdCSSvdy44oP4eQZfr1QVrERv5dT40eXvW1w6y?=
 =?us-ascii?Q?ZrVs8nyazDGx1+gm0w390K+amL9l/f5IFhhOu5JuSlpieTcJhI1867NMrLd0?=
 =?us-ascii?Q?9XcKQ9mgOnO3+lGDknLBdP8vELbji+8iHbuIT+7/uQN9Ri/SROnhd5G8wM25?=
 =?us-ascii?Q?YcwTvRcMyFxZIHwy65K09RZCg9p+4AWP6hPDtLLy96nZq84dv51xH9Qgw1wK?=
 =?us-ascii?Q?m0iuYSDDiIkJzQH8k/HxM6qPtHVPl5BMxRW1geIDDm8sF+k0dNIZeIx7T9tL?=
 =?us-ascii?Q?zgjmYiA4wTixDkS71YmCLeVzqmXn3UcnUf0epajpF2k/TycgkvYH0sfNbL4L?=
 =?us-ascii?Q?L1zJkTPFpm0X5SVgXrBWvoJIipCWrbKiLYjz/2853PqYAVu+9lkhr04LZLhV?=
 =?us-ascii?Q?0zc2y4ezKVtWs92f+42DPAljc4qG5gxHgdVyYyI3auYcidyiJtz4hZGzE7Pc?=
 =?us-ascii?Q?Sf+KhWrPDjFpvFrcdGWmQHov4UK+zjRiT5iIiZu6RPonf1WxM17J2IBgct+i?=
 =?us-ascii?Q?yM3yVqTLqlu2eG2fs+LHQt587mFu7RZF5zPUGYqWIqKyLNaQshpQ5LffCXv0?=
 =?us-ascii?Q?XHE6GGw8Y1zx583XRe2LVZjjJ75kmq2wHvDsYb/Q/1SHsDK9+MpKyscS5fnY?=
 =?us-ascii?Q?iUsB9fpFjEvLGGbeH2loNgNicmvO9mMe6f3PdgSukwMkORXu6yJNejG5Hf+o?=
 =?us-ascii?Q?c/j9CwJZqNmg9udyBG4xM1hdvD0ObhEvpdtQeCIaxr7YmZLvpVvKhJDX02n2?=
 =?us-ascii?Q?mz2LNskz24fX4nwv78TlUJPEiJlMkCgdcqT1+s7mvi9Pz0R7WU3cNpuu3iV/?=
 =?us-ascii?Q?eGyBVhQ+bMu9WLX3iX9y2Ql5w/XW6jI8AZ3vFoH1eRM9zI89TZ/v+lU89hiQ?=
 =?us-ascii?Q?fuvGW4eEbZFQhRxI5OCDouZx/yKuPD9/n3pgtfsf17R7Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b9e8c2-0cee-48a6-6047-08d8dcb21723
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:01:12.2492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cf2pXRLFcojIMSmF/8u4E6o57wb+jljMsm1UOS00yU3Nx7HWf0Xm1/lJ0pSFxnt2YfxBJOxIcFKUphhgXjQW1XnnKJDpY6V+6roSZcaSeqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
