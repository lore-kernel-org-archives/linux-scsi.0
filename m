Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40EBC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7758864EC8
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhCANBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:01:03 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51666 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbhCANA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603658; x=1646139658;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=BS6K12vrcJDvp23CillVaKd5QfRoQi51K4lrSFRxUZ6EJNmppvEaXhVz
   TD+5Yq+fZmQPNLJbA0VfIrN4agomabHrj/jj4viE4F2s+afD7PcEawLyz
   QZ3qFSK2Y8yOJYVmb3U+asy0bhDWEyd19FJt+sbYEkIHnDMHK9egRERs8
   TF0I9FutKomBFvMstmQN/QwtsvUxtUXJXWrX6NLxqsh5dgYVCBoygxGM/
   VFBbLZ7Pk2KPCTUguFMkfWN5NQ+cXLYIwvf7xFDDmhCnttsdgZeMHWITE
   GS2cVOI5InmsDaV4xygCgHo4SV6iLeC8hpznAJ7ZUGfqA7+EqHPT8HRdH
   A==;
IronPort-SDR: Ra0bfnTD+cGp0QeZILlfk7tAuQIswbFQxm2DOULCfridgnFy6EjRP9TRhbySjba3vFefEghge+
 pFwYpGX/ESsynqRuTvXzFJ2QvMktau0Rjhq5vhnklYLPwfH80HCEruaHha3kbJ578JQQlX/SxT
 P9w2QQ0Gmj2lu7bG+El2Se/DlLYhoqJ60OW/YQ6GsX3TK7zItjIB7lnNpzTFmSY94+oaGfa4wP
 Mtc75XQ8MrhNaoeyg01FAY3PyYmlzlGiwR2zf+Yl3jpbQUInyo5A2TUb0DbCyg5Ag9sxdbD4Cc
 lzQ=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="162231283"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:59:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKH74iTb9H3E8zAE1DAY0YkohCERg7vKToSc3VvBmV52Z+9PUrr0p8H0SxZ8r89DSUG6htU6oXUY7e/bLz2ogFQwMTIBNzox7DI6yqeXAfesgYaC8Apkz8rPA2qH5HbBbS9vZtz1Nnm3iTKy2xN67NefxxBv/V7r1GyTEq8aI0wtHDtvvc9UKCXipAuvkTrMHlWgNpwet5VmOLvfvBATU9p6qCaTS7W1vZRtsssITwU1NaIzNZbwNd9CcklYcvmzWxFFOzjdnjcnLibgmlUElXWAXBn0bBHLjefdGYhw5xHVacQTSvhl05GyPfLLIdnwlW+QrPOfQNm0OHnC3XJ3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=npAvGidPL/68IC99GB/HdkKWGuJx40Exhe/A3Zn9Xyu/VVMRIrh9Ky1E3lLeyoA5cBFzwEe8bb5gCVDwZUJWcWDQnM9HUzRui283yT3G2phg+i9iRgVcmstL+BlWDKo7mo8iJq9an2cW27Zhff/37jrhj5XIrhtgFVp62RKjqGXOd9Zv6T8F1Br3ZyD8HHdovRyPDL4bEX3msbZbRh8mahYr7gjp+s/rcMOGI9qA2t3AsWPcF7GyTCYnvFbVGJoX5iTEmqv47TVzHD3OJzjrg7z3/hit9ZupeVK6K3Cy7fb9FK7hyoaowgep0ck8HgU6lvbfDu5Gz+LQbT9k21jHPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=qw+9UXSd0uIM1ZMQGM4nInQ/sAIHb8erDjg+61rc62DhZdhPZq0s06RVHFCLuZkpszmvCTT0flh55Adxf9mkHZEKzRs21D6t5bG2n3dXxAZURMYmxHcTmoqSviQLF1G5Q96mh3Ouaq7QUBIrlm7UsjdG+yJZuo5mUN5WiNrVxCk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 12:59:48 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:59:48 +0000
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
Subject: Re: [PATCH 14/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 14/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZcBoNAgtUYDN06PckxAfsYQFw==
Date:   Mon, 1 Mar 2021 12:59:47 +0000
Message-ID: <PH0PR04MB74166FF193F7739E64437C259B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-15-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d85fff65-0e3d-47f3-97f8-08d8dcb1e4e8
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7318D9BBA5B252E3F8EC21889B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/P8UtItWUERbjigGE2BsUawdlc1XebSubKv5lo9vTKrcDv/v46YVEYIj2LdaOw8bjR93CnUpal3nVbmMxQuW/CIAyQT0B/aXZhS2xrxiilMllicSHMqCN6cMdxLpK4RLT+MybRHxoU0R0OofvaVkfTrEI6h9N8WwO4bnMBRORU9o0tj5eLfFKPWuCioQdznv4lZLQODkgIzRucdVE4I+IkhU3e8jPHIt3UgL20U/uf2CdsA7avv0m9FJw/0HzI2knSnCdhU5JKHra9c3y2RChfOaIMNclp1ugG5rwZ64puxJ9fy+HwGGblZGauziR/W/iMFemg+SfH+VPKpAlOv20sZZlUNOszAWxfof7tqC9lPXFEykfLnYl/iiZAve4h24XujGbEwdGvfD+U2Mc9QaOjCMNB0EhRNb6ETB6FP1BfbExvh/kbt0383kjUlvunXp0f9XoUI0E9Ly2x1KcWKgcICFt0Xyp9MTZaU57gttpLE16RVyAF7tKmf8bYVsz+FHwTuCENSCcK0yVEjFkV77g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KzWqlFxr81ABPnVL8aQxrag2IKw/zTPyeCuEV2wMVHuPkp9Jbs2/x7MdtbXj?=
 =?us-ascii?Q?S4aaxvXTV5xyvYbPQ/jxB0BuM6l1tGBbfPy5E0IiHgg1Vu7NRoyyuBoiv9II?=
 =?us-ascii?Q?Zh5IfmZG5QS45SlvPqiHAwXZaxlz7Wv0WuiiMXglUXiHO9RbXl5KdE0rr4qc?=
 =?us-ascii?Q?RBsigTiQnSa0kRT2hFYArInA9etA/2VfKPeYoVwHW+uUT9M2dwo67MdjjMED?=
 =?us-ascii?Q?Serp9dc0mxq11TDZsy+h8nFOS10f/C7QZJ6Qqn74yDG4HIHOe6q1QRecSlER?=
 =?us-ascii?Q?igplcam9HnKos4a50tnXZybehqXnggQvQ0pWbTbMG2FCvO3UO2HotZkDZfX/?=
 =?us-ascii?Q?un0+kfNxFxi/gLoP8tOMsPF/jrLdhtf/t6DSM0XzV2hzxnGmwDI4QGj2AZNe?=
 =?us-ascii?Q?C318IlnVUWLFTqflW47MXDjhSp4mM3mug/uapDsxmkqshwJQ8rIrHjEPihCC?=
 =?us-ascii?Q?o5JYkysJbozbLfMm0Q2QN6Jj4mmPsT3T6DwNXMx3iwsMUdygUyvHyz0nSMAA?=
 =?us-ascii?Q?77mNLBvcTYi8YZ/KhT2DB3MyS05wlHBET7A3XKlNjcELmNOLZy36XoiXP3lh?=
 =?us-ascii?Q?XPjNH3aakXqhQwBAMqdOwPeiYM/k2W6ZdD1pFm9kqMPcigokuMgwoye/o+xI?=
 =?us-ascii?Q?1H37/R7KgtjSjXGo4najJQZVo42SWIDqbR/60U8S4u1gPT8z5HzWPOkzOVDG?=
 =?us-ascii?Q?j2vQUDCujUTA9J1M1JTiICK+FJaxCShBXOJHumeui7845oNMc/IWxRhLDrWq?=
 =?us-ascii?Q?csKIGnaeW/T4VO3CKuc6SAxICjXFSzN3NQMO1CRwignLEDj/qXI37RVDExW0?=
 =?us-ascii?Q?gwoMM9c9JOi2H44wrvjp1F6vyai9MDUdhFcWpjI/YszC9evS/h2V/I9PI734?=
 =?us-ascii?Q?y9ZvSCqyTWoVd/p2PABLTUvgBc6DJH8u3/BJVCvhKbkZdmQxMgMb6ezBe36M?=
 =?us-ascii?Q?DV7oTWj73DZgKYl8BZHV7TjVNMcf0PNE4CEzPBeRtZnP1qhAWC+F9jKjN1eS?=
 =?us-ascii?Q?UJ8Q2CXThZsS7M+KNpYlzMc3aLDAhV8lM1aVlBsSmnVZ+jIe9j6avX6ZKZc3?=
 =?us-ascii?Q?WZDTw8GauRlSzcJ6lj0PrJqABiHrPdKgQVmatr9hwY3Nm8+fz4lduknTtHup?=
 =?us-ascii?Q?4SnsSHEQNOUz9y/cTUKj73jnIJGBpfRvYq9xV/JE6WOOolxWT0fJYU+srfp2?=
 =?us-ascii?Q?Xt6vm/txlwAn0wsqQGOu787F7mXd+mKPg1phfr45QhvRRfE7tQqkkLCteKrD?=
 =?us-ascii?Q?Zoy0MK19rG3h2I9G0zrhCULu4QLL99Py80oRrHG7FumS7zyh1LWbgSY+Q3Hl?=
 =?us-ascii?Q?UWNHoI1a6a9uTS64/13lCHBC683EYcxG+wxn8RBjbjExmw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d85fff65-0e3d-47f3-97f8-08d8dcb1e4e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:59:47.9242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRhWRhX18wL8UjUMVn3FpbA8PnbV+x9VNJTHaDpY7M6F5PFPEXY33WS47ujEwS8Y7eOk/LU0D9oUOIyM9S6fAtqKgbF6i8IHTiqGf/P9oMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
