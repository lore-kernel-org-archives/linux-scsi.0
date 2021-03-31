Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3989FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C69619C2
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 06:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhCaGfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:35:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35237 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhCaGfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 02:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617172514; x=1648708514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mJvfnkBzQR3iOtNw7fuDUvFs8bjdMEkCvxKrUJ+3Mj0=;
  b=Jw8DT6F/G3XA/ntHu0W114V7ucIF6v32D8/J+5ZZxEbCbPQZKxYLS836
   BVDoIKQ0pt3k0UdwkmOJMyc8dISMq/QKjny37P0nYdBmO9nmfXt0Q04a8
   ij9z0LARw+0oH4y+vmnkU/frZQY9D7r9/nR9L1Gm7I3T8MhSIdCWLO7Hw
   tFC3II4e7ZdZ11SFPPGBa7nm2bYn3Yic6jiDFBXuleNbggNa2IqkpGBK5
   8YkodFejwKDldpmSMYZWYS+nO7RiQSouSp8m12FksCkIN0KQnPZXH6gQs
   L3KYNNeA96hZg0tHMQA79EQp1tMqet+0wF6VAM5ErL6hPLNcDF5EfaiYu
   A==;
IronPort-SDR: sPZTdRQRzhwbJHh5xT312di3PLdqVUSZoI1F5tPcYiMfDhOHQWs81pGdSNrF07dbM6C0oRWQ6y
 yaG4RrmDv0836zqi3B/djyt236Ho0MRh8WrJ0riO0PhPveBrP8jbJMslJreUSO7G9HZZb0skOq
 Tl+u9+7tP0H2tEtTyRctsglKYQUre7Wge7jZcwY0SVH1YQnQMEDeNAE4i84WP7ZVy4fXVS2RLL
 w8HYtsEctbG3veqWNEl9PC/cpSoAek4QrKqa5AvtmSoCkreNIdtnUSJm9yslw92hLFxjaGRE1v
 5nQ=
X-IronPort-AV: E=Sophos;i="5.81,291,1610380800"; 
   d="scan'208";a="167895260"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 14:35:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUsIynldPYUwwkjvyPsqt741JFWtN1+bziM94HFspboqjFVkd4AKwftSUQbInAOEKCVp+QgtepexWmQ7sPQhOwmjUq2ebGoOBQW3vkD+6usbh/nN79sp9mEXi6jJNH4jayztMh6YlfM+yCG0ufjTRgK9KSuW5iiAG2w1pSDBXweWh4ThP9LQgE4O11l8S7cPhBz7u0+QodsI9FevQQgJIHld+mAvbNbcQ5MnKlEq7ah5g9V6QatSL+NT9XYD0ZFHWwojZeQipXzL566E4vG/f6M3vdIMmdSxsM54D53wcWsRoYQ3MyJyX6Yi5HhRqJ2zbhqnVD/Bn6eNbPNPIosC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJvfnkBzQR3iOtNw7fuDUvFs8bjdMEkCvxKrUJ+3Mj0=;
 b=PbGNpdcIWmMYPuBhDwfuLyVU93gioh1DT16qOfdS0PfUN51vR7v6aKVRCe8+NgF5J1/hxZc+J28iPLyKqKd9TrAXvJ734xhH6aBsdDb9fiv8bmp7P2TbxITF2HzcdKH5Y21gGJ9Kc5DxTUrTcvl7xLhy605jGXncre+SqVNpGVd+UVtzrXDd/9t6qtYrvJUlK0a99NZlpYmBuECnbdUfIALTgoUzwoxTtO14v/pGV2QDlLodTUlYWzJV6hP8gyJjsPJrZcROPbZjBSyCwX9uaWzcRzYznQXQhrgDK7DPp3p4t1CkL8Ym8onV0GeeyDWPCyLYN3B7JnejQx2NjFL3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJvfnkBzQR3iOtNw7fuDUvFs8bjdMEkCvxKrUJ+3Mj0=;
 b=hhkHVY9PTU1GYwOm+bAg8H/WgTEE9TT7Rz4HZWLFEVlqVksFyS7FTNoLVHJkZ9hO38FtRJcSNgj/u+yFGBoIK/wt9M7qmzuvDeB/iIo4BlVRvtNv9rkF2afJoC4rvGKLX/VKs76Y2J4c5129vi2qh8scwhMfi7R3OV340ZeDfL4=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BL0PR04MB5107.namprd04.prod.outlook.com (2603:10b6:208:52::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 31 Mar
 2021 06:35:10 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a%6]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 06:35:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
Thread-Topic: [PATCH v2 0/2] Introduce hba performance monitoring sysfs nodes
Thread-Index: AQHXJdwvUu29Yvoe8UOfBP3YUvFfMaqdcd4AgAAFBQCAACsjwA==
Date:   Wed, 31 Mar 2021 06:35:10 +0000
Message-ID: <BL0PR04MB6564DA13DF093548E599DE9BFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <1617160475-1550-1-git-send-email-cang@codeaurora.org>
 <ce9a2333-437e-143a-a0f0-c5f532a2c423@acm.org>
 <6aeb31ca744b1232808bddb7397edf4f@codeaurora.org>
In-Reply-To: <6aeb31ca744b1232808bddb7397edf4f@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dfc5bf5f-7c9d-4ff7-0529-08d8f40f2226
x-ms-traffictypediagnostic: BL0PR04MB5107:
x-microsoft-antispam-prvs: <BL0PR04MB5107E893F8D9D7AB04D83913FC7C9@BL0PR04MB5107.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xM1huuCZxRjr7cu0dNDUnDcQcdDmZm6eLTZdQtHmQvD7c73dSLw9tSNpor0Qxihb2gyBos4D/i2Bfa+EjsU0541WuvIQ1cZKKJCHGfn5s54uc0Vb2pmAF7NvbIFHlpZe564pL1a3cvbHKYtgF7fkYTiL6clIRHL4xltSJGDSwn1mAljrr49d1+ceROcEnIVyCnHIoaC/ltBucY2w9dhSpRqjWBTmlg7RCznFg4vxrQw7t0lmf8lM3wR7BAnchrdbQX52eRtmOgpqKp+hysw1ugkGfbt9k40WTm9Jbv1i2lbrs3V/3NTnSy3+lh/8K+B6jz3y/sgBZ4b3B9a/vnw7o9Di0XpOc7PNYVLNAX+a+Wd1jbeHHR/K0483aInS/ztz028r08A833S6gSi6mff/HRcsVzA3nrhKi1bgPFPz/Huq3bLSMS7SaaLtMp10LU5QeSK98Tz7hOX7NoSHEoYkXffjD82D7uImFkTmEegVhJDnG5WM7zL2n60G+sOxl/3Ya950kfMF6iBVTeECFAFw7XVOrx0JIJ3ooTp1R03d9PAjks2afmvSnKSWl9fzTfhYPJIbppXgSZmNmIUqJYHcK/iYbq+1uzPtbApQ+wK0jqAZK5uZqf556PqnqVC4HMWNWUYlhYW506Ud62YyOH5j9coZbMiEdGS+szveTbbp7ns=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(86362001)(38100700001)(64756008)(66556008)(66476007)(66446008)(33656002)(66946007)(55016002)(71200400001)(8936002)(8676002)(53546011)(6506007)(110136005)(498600001)(83380400001)(5660300002)(7696005)(4326008)(186003)(54906003)(26005)(52536014)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?crf3kaiVdmtfbXSd7GHJWOaJSTxbVoYf7zNwxJRIfdw63LVNmmDia4QMj5L3?=
 =?us-ascii?Q?m5oLOKFHmYTWjA07brdTffaptU9+oXX3a19hz1tycn527d98dGmFDUhiZiLZ?=
 =?us-ascii?Q?8lXV1w4xpeochRRjWwyibjuOO8BfLuWY4z4GNCv5jtCpsRFuP8JS3tlZupM0?=
 =?us-ascii?Q?nmV3oRpBVyUnsh0ctQ825ZMpezItsNiMjmqdzUuEufj75W2oxHJfhBBw7n0x?=
 =?us-ascii?Q?FLLoU6abWT8G9UMyq32lakVtY/qlKUMEJTCVYPFTFF9YslB2gMBCXX9y0+N0?=
 =?us-ascii?Q?pcAjDekNCmPMb4EdOXGF5Zfdy2Dm8cEFlAE8IPe8BLH9+oiFPzsOtLJNxMQ0?=
 =?us-ascii?Q?ZXg3IWEKkJhow7TLYrcaaB7NJKyJw0n0XwDJQOlpDgP+q+ZrjjuneId97WuO?=
 =?us-ascii?Q?6pJ5N/VXiXZa3vTL0DkhLnfatjg4FaizOpN5cETK7HHGaKMhqLIg38EGey5w?=
 =?us-ascii?Q?3UvIGNXQt3qdyPnxOVX0Bbbk7IaFdO1JQ1CQwwI/xwqLvLVhV9CvmzghcnoV?=
 =?us-ascii?Q?EUItngDyGtdYnBb2wgXzSmFQn7te+wAu+XaBM9GH1sMc7GPwJJ0mMlLpeJ0s?=
 =?us-ascii?Q?JgwnUXVdpjHybJSJIV31cL+e9bXqf2r5uNQYGUTeSxNfjTwiiTH6R8HwaTI5?=
 =?us-ascii?Q?e0K2yCblGGqajgAZNDxHmfkX5iuwMzYv/nkgQrlAwpL3U67vCoGMzRJNp3Ad?=
 =?us-ascii?Q?qbTcdyCOGGkRLTevR3KdaXVUxe4EmGTxI4YNs/8sP3FSIicMKnbqwvHHaNUJ?=
 =?us-ascii?Q?asJ0k7J1VgI9dTKngKD0gAUg1nBucSCKUMtYHzQl2wHVT0d6Nf1SrrYxWM1n?=
 =?us-ascii?Q?6NZ9BaxE+D/VMqmiZTIp1gVA7cKEOMSkpMp1JPil1IKm6GF32X//ast8xEBn?=
 =?us-ascii?Q?2I2d7jyOGZxu3b1n0Lrx7QzO1Jo1IXoVFPmSXgLgw3nUvnf6otsYKutCae3v?=
 =?us-ascii?Q?pMS6dvnoUugyALv+tzxII5ElTuTGDNPR96NDdWFHcObqkTDjhxyViap0zuew?=
 =?us-ascii?Q?MEpKrDZHUC4dMhAJrc2ja2XAdkaKvsAjkR8ez6Q0IMzW5f/8VsL3ELtvL9Eh?=
 =?us-ascii?Q?+9sGcMaPiyFdP5e/8dNYBg5syfucFMQUHuLk98mKhbB9IjJuQedBySWEiu3/?=
 =?us-ascii?Q?uK3wZ+t7zLu4uO5iGlG1kY8NI5z9JEXOjhbRx4oqZFAHrqX5g6H1i9fAQsL8?=
 =?us-ascii?Q?sGUcFr31xQNY8WohOzLCnvAMckJHrvq9VX9lE22UhiAeriDnve3Gm2jE9ZgX?=
 =?us-ascii?Q?ysFFwE8TV8tfJG5H0vl2iFT3t8UjX7FgTGsofN05umiFHaaAjPql5wPi67CX?=
 =?us-ascii?Q?Uu5w9kFNLABCnwepE6Uae+ka?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc5bf5f-7c9d-4ff7-0529-08d8f40f2226
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 06:35:10.7100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+zuvDao5GoMpMdOTlXrCjGjhvs1R9KSE4lx7beRJ4zmNZUMkuvhm0yL9mCqbcYwCWtbfkQRLmEj/01WOPFe8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021-03-31 11:34, Bart Van Assche wrote:
> > On 3/30/21 8:14 PM, Can Guo wrote:
> >> It works like:
> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 4096 >
> >> monitor_chunk_size
> >> /sys/bus/platform/drivers/ufshcd/*/monitor # echo 1 > monitor_enable
> >> /sys/bus/platform/drivers/ufshcd/*/monitor # grep ^ /dev/null *
> >> monitor_chunk_size:4096
> >> monitor_enable:1
> >> read_nr_requests:17
> >> read_req_latency_avg:169
> >> read_req_latency_max:594
> >> read_req_latency_min:66
> >> read_req_latency_sum:2887
> >> read_total_busy:2639
> >> read_total_sectors:136
> >> write_nr_requests:116
> >> write_req_latency_avg:440
> >> write_req_latency_max:4921
> >> write_req_latency_min:23
> >> write_req_latency_sum:51052
> >> write_total_busy:19584
> >> write_total_sectors:928
> >
> > Are any of these attributes UFS-specific? If not, isn't this
> > functionality that should be added to the block layer instead of to the
> > UFS driver?
> >
>=20
> Hi Bart,
>=20
> I didn't think that before because we've already have the powerful
> "blktrace"
> tool to collect the overall statistics of each layer.
>=20
> I add this because I find it really come handy when
> debug/analyze/profile
> UFS driver/HW performance. And there will be UFS-specific nodes to be
> added later to monitor statistics like UFS scaling, gating, doorbell,
> write
> booster, HPB and etc.
We are using a designated analysis tool (web-based, a lot of fancy graphs e=
tc.) that relies on ftrace - upiu tracer etc.
Once the raw data is there - the options/insights are endless.

Thanks,
Avri
>=20
> Thanks.
>=20
> Can Guo.
>=20
> > Thanks,
> >
> > Bart.
