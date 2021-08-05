Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2F7C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12726610FB
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbhHEPxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:53:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57374 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242509AbhHEPxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:53:20 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Flbs4001871;
        Thu, 5 Aug 2021 15:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KHfhURpd4a51t6gsX8SvdosA9Rx7YgVDOqn2hStkRrs=;
 b=h7nh1c+A+h0GetQWEoM3OjR38ZMy1LebxXAaeSz4/7J0e3riHDJcMM3eKa9bPtLa9xyX
 L/HoaZ4gAJ8lkFs/90z5Ec7R3ZY8Ztf9K0bg+RkkHX9+ylzfCyoC4QAKO69I6L6Fx5cY
 /dumT3lYd9Njn4Gm48kF3QKtA/9qf6c03rm3YidW2gA+kMPlFtMIkGQCy+rzQGG+FKFL
 rwilPQpWT5I4+umeA79iwoGlBvnp/yDGakE3xyl1e0FfJuhiQumy9yGXZLgl+qatZ21t
 4qIUOlp7nPnwTSazYLF3OFa/lk/UwokvDVmUT9KjTLyMKw+Xy7wWf4K0XKfUutSg2OTu DA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KHfhURpd4a51t6gsX8SvdosA9Rx7YgVDOqn2hStkRrs=;
 b=ZFwoIW0J3d274vclOQ8onpiFB0LFkxnTgizP86Cxuxki0atIF4O5mQTAryDB551mXStV
 1n5peytmZUIfE7YQyv0MuYjwo6DvWf+uThC+Nd+z/WHpM5JZgMtwAIfcTYcSgnSaAUtU
 PsnO79zGwlzPuiJxoqd55n9Tt2NFt0k7wTWjKfhNbrVfJyh8swVf4dKH3PTxzKCb42qn
 +Z5cpPMqxx4+mukHcXht0/+Es0nFL4WmlQRpeYYFewDZZIu6+ALkjMB8nFYD4OVDbkK6
 Z5/UR6XeUw+5eSDhJiB+c6J+q73y+k5jZPLbM6qUSsdJJnGeo/Knh9o8b8kJIo3sP3Sb zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7cxn4p59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:53:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FjU7b135990;
        Thu, 5 Aug 2021 15:53:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by userp3020.oracle.com with ESMTP id 3a5ga0fhm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:53:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPYcgW4xt9NWOKB2vxKw7TRdUXGjZkpUtfzer1ychIg0x3h7eMLy3k9EF3WVPl++EjGuuKH0CNPYK041jw/KastOuA9vK4bIEnMqEJmXyiy2pMvMzqnHNW1rdrGwpE7RyM5khNvi4QbOe3tBhf+zuTmJzrccRFvW3PFIHRrYGzkOGxhByJ8eyoJ49pBhvTGvlGTX4QGFYhpfxPZjSNyH6A6Adz4cZvoVLboqthY3ZBWE3R6F6szjRrSf0KjrsLhl9z5z8EZB0DMqw4he4hHoqSQVisgG+RV3Mb5bM2jrBnhSaJOs56/RMJdI8WL6fjdHIHZaEegnwRe5YsfbVDugSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHfhURpd4a51t6gsX8SvdosA9Rx7YgVDOqn2hStkRrs=;
 b=kD5jXJeGWmSM+F7idH9nqvAjOkzU9a2s9ouoD6f0dqgp9E8Df2cuGjqMwtjKtvEiS/t2i3oxzMIGrchUNK83JCMEm6Q6KaUZbHRSLJwiozpPP395mNcVJu+4Frt7M07lViNW38qXAcZZtpJZiaVU/KTeWn6NJk6mg8NdrSD/vriEJryIFmWQQYUt0QltnrCKE/NXaG2L3E4+8p8mJO+Fquhqg11Ho0j5O+CDrE57eLQnX9gffVp027JEWYJRDIunrRlWEvA5L627+ZLfLM+QXyuoez1ah02rv0r0BVe0TOPd/2/olXvzosTqvzEa1Rkun9lgtoS7vngJjabmH4+ACA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHfhURpd4a51t6gsX8SvdosA9Rx7YgVDOqn2hStkRrs=;
 b=Ou7l4AhqY7xQfFeQJGEwC3/SXrUtLx/aLl2dEyNKgkPQdnTdepIkViwRMVfWr+ZDbXKrkvhZ7a2l6bH/Lzmjva1l+MHZl94WC+fDth7YOWDy1ozdQzhAn9B/iWp3kYli12+hZUVXjX1Xxa4kAkx0OE7XARrhTCwAnnZmvBJ6rm4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Thu, 5 Aug
 2021 15:52:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:52:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 12/14] qla2xxx: Changes to support kdump kernel for NVMe
 BFS
Thread-Topic: [PATCH 12/14] qla2xxx: Changes to support kdump kernel for NVMe
 BFS
Thread-Index: AQHXieQ39RNmSMCT6UudQ5rCf74L3atlECMA
Date:   Thu, 5 Aug 2021 15:52:58 +0000
Message-ID: <5DDC19FD-8022-4AC0-8B67-8CEAF0E90A33@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-13-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-13-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef338dee-b1ae-4807-847c-08d9582918de
x-ms-traffictypediagnostic: SA2PR10MB4459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB44598F49CAF7997153DB8A3EE6F29@SA2PR10MB4459.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2U5ETpxiKQGfGLhyJjOB24HJqKovxuKzPgdWj1b21ajqHwVxmt1kp2SpXW6Wsk6yqPqYdgc6JLdIH+VO8cwDr5lmy3gCeo2kw9Rqdgelwdrxvg+8fbjQo711SiKJihn2rSNbL4I3GThQHvKUZU1Oj9KSmz1G+vbTGMmOZY+94SaqgGoVA9STec7yTcEeGXCOb7Dy6TPjAmigpiHYuy00jXuLEkJVwVNer+FfwDsA6W0AKGW7e0+1GBwmYYiENMWtpkZlBjVrTUXEfsVVj6WxNZL2gfMB7MBl2nIwdtHarmWCm8tmqOefJKrRgYEeGcZSJnqSElwKwfmYISkZwnFh0KzgUSMaARZ6ZJQSiXeaUJYG7OKhspXxvu70/FnUEsC7VwOZ/F6q5rpa+lJ+86suOKKLnZPv/ZNxugMKZ6d1c0+LN8zeNa59oJ9CB85SYC28CmuX6A4JN17sUqyOJDmv11wBPoY4MqoYj8ElOjsAFNVAjwXNJw2G83587wnaF4IENt6G+JtY5dr1yILd8LOLdG1ZauJVvNxvO6pD82CfZTB6diSV5AUcWiX3XTvF7PCdi2a54qolQNOl0fyupTXYNQUf5biDsuZSLpQMB7Omp+KVhUpQg8fw2nMBv/bnWuowPySUKstUdI8udF3ILyJZGkUhVfdk+KNj6fPGw6WPrNqzhny5gdSXKyQUH0j0gsE45URwPFfy9bKKmIeUoSZrFHKbAMik2FkjVbOE1qZeGCluyURksdnlk3aJVOnVjqwI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(26005)(478600001)(6506007)(5660300002)(53546011)(36756003)(83380400001)(6916009)(2616005)(8936002)(6486002)(186003)(64756008)(86362001)(6512007)(76116006)(66476007)(44832011)(71200400001)(33656002)(66946007)(38100700002)(122000001)(66556008)(2906002)(66446008)(54906003)(316002)(4326008)(8676002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7bVsS/EzJrApJthODgBKuwGG74eY6OTdebWVmd0Fl4qcPuE15UBnxzViRL2M?=
 =?us-ascii?Q?rrl0RQQTIFZPyL+iuXSOv7uyLCkdZCoDbeZ7hfObl44unWIEFzpXvXx54qnh?=
 =?us-ascii?Q?7ses30Mxqja5VmG9gJLCuGY5Ox0O5Rtsf4wvSp4ICOX6CMSoH1y7tkw/ak4a?=
 =?us-ascii?Q?DOMdhbHWRlmQqyUquatdWG7tDy8EbzdbTPJFecaOYNhuD9HJF9OfF9Ds9oUG?=
 =?us-ascii?Q?IrCKRFpGlt3b/TWXOjNTtwflqIUq+crd7VpusrxnTNRi4widXBMV2xZafEEg?=
 =?us-ascii?Q?QS4uGkb4OzrRVDQbjEE+rnmw7Zd26cmDhavcnaJvhgOaJ0XYwlF5W5chf+CC?=
 =?us-ascii?Q?cr3FzE6cSDEaE5HLnfWWNgG4yRMX+6DKYy7OPUmxCxV5k5TxhIjYGiE8nuob?=
 =?us-ascii?Q?AzlEvRZaJTaBzgByfijY9YK+fAU/O79FhdPn9azdVs54d9Dn2NCzTEqCocrU?=
 =?us-ascii?Q?2uufKVf7nT0wB48HGGOUW5Koi5JELlMBqC6kWiwtil5yyaEWnb42Hn9+A6At?=
 =?us-ascii?Q?S1yt3mkggfwYRfoyYqQd1/gAn5Cd9oiS8hqMCtJkm/W1150Wsy9f2rJDUbxV?=
 =?us-ascii?Q?cwTxKmMBfMlbkV3w7JOm7KRo1RC+uzJHhGJhRxpDf6qNFR5w1ctOFYiUDQnf?=
 =?us-ascii?Q?VHFHmZVAEe2bKQ3rDei6sOYDTjjNXKiEAqNwuZDxzNTzzgavtxZhkENQs9QH?=
 =?us-ascii?Q?KlhkYgkkgxy1DaeYSoB8fr6JROAF/j/dAa1jCZ0wuxbDnOwi5ecvg6yf5k5s?=
 =?us-ascii?Q?20y3YPHXUv+EwcoRYw+0X+7jg+mrPoFTe772BQ7TwgM0ra6ts3OmQxOSonEU?=
 =?us-ascii?Q?zOQLY82g5Qh5lVYJMyZwXd9/r+mkARX8gRPZcKENREwCMH6M3yBuLxaKj6w5?=
 =?us-ascii?Q?P+CADC+PZgiZ/P42XctEfSMzvyINm8I0cPw/yGJPn1u0qTiYk1sBcyZFYyVt?=
 =?us-ascii?Q?A0Ot4bf7l2dEtRaxCBxmnluf7a6ybjxvSzAhrE7+DTMNS1qKhY+bdfA9o/j8?=
 =?us-ascii?Q?d0oOEaPVvXkTav81tz+eweE0hQH0yHTQEPcrSePcdklQtIxJYGhOFQlO+9GZ?=
 =?us-ascii?Q?NF557/w7Ji9cU8skD76WclGT5JG3P8b/rD4DJBwcMovq/p0nJpb80FPkd0Oy?=
 =?us-ascii?Q?wGRBhJRxnv/8xiqScaiaS/Bo7qFyvOU3u1Wga7ybaxJE24BMCCfueBsWId8Q?=
 =?us-ascii?Q?2sOQSEs/j+NZZmKlKVvnHnyqnDNOnXPsW6tfC7j5piemG9E/8o+L5fjRrpVe?=
 =?us-ascii?Q?DZOkIflfPmcFVP3V1f6roUrH4LZa0z5hRLBRX+9WVm/+NlE3A+MOPVYhsFDN?=
 =?us-ascii?Q?aNa+MGE04A34gTJ+ds0lyE3LigbPC0PdQCAox2ScAgus5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2F33DFFF5B734459E88F01ECD9EB97E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef338dee-b1ae-4807-847c-08d9582918de
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:52:58.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2P4iV+RcQ6PrnqLIyOwqM8hlME5NTMi5MhghV8yikn569qt0bRp6h0y46bLkg0/3IQZJQcdJITYmNXSzvxt1uJJYk2ta+AHVYa/SrTbyCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050096
X-Proofpoint-GUID: IPqPu1xdpELYFnQkyHGJ9KhRkhZIMzXx
X-Proofpoint-ORIG-GUID: IPqPu1xdpELYFnQkyHGJ9KhRkhZIMzXx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> The MSI-X and MSI calls fails in kdump kernel, because of this
> qla2xxx_create_qpair fails leading to .create_queue callback failure.
> The fix is to return existing qpair instead of allocating new one and
> allocate single hw queue.
>=20
> [   19.975838] qla2xxx [0000:d8:00.1]-00c7:11: MSI-X: Failed to enable su=
pport,
> giving   up -- 16/-28.
> [   19.984885] qla2xxx [0000:d8:00.1]-0037:11: Falling back-to MSI mode -=
-
> ret=3D-28.
> [   19.992278] qla2xxx [0000:d8:00.1]-0039:11: Falling back-to INTa mode =
--
> ret=3D-28.
> ..
> ..
> ..
> [   21.141518] qla2xxx [0000:d8:00.0]-2104:2: qla_nvme_alloc_queue: handl=
e
> 00000000e7ee499d, idx =3D1, qsize 32
> [   21.151166] qla2xxx [0000:d8:00.0]-0181:2: FW/Driver is not multi-queu=
e capable.
> [   21.158558] qla2xxx [0000:d8:00.0]-2122:2: Failed to allocate qpair
> [   21.164824] nvme nvme0: NVME-FC{0}: reset: Reconnect attempt failed (-=
22)
> [   21.171612] nvme nvme0: NVME-FC{0}: Reconnect attempt in 2 seconds
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  1 -
> drivers/scsi/qla2xxx/qla_isr.c  |  2 ++
> drivers/scsi/qla2xxx/qla_nvme.c | 40 +++++++++++++++------------------
> 3 files changed, 20 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 60702d066ed9..55175e8a0749 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4022,7 +4022,6 @@ struct qla_hw_data {
> 				/* Enabled in Driver */
> 		uint32_t	scm_enabled:1;
> 		uint32_t	edif_enabled:1;
> -		uint32_t	max_req_queue_warned:1;
> 		uint32_t	plogi_template_valid:1;
> 		uint32_t	port_isolated:1;
> 	} flags;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index b0b5af21781a..ba4a5bf5600a 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -4508,6 +4508,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct=
 rsp_que *rsp)
> 		ql_dbg(ql_dbg_init, vha, 0x0125,
> 		    "INTa mode: Enabled.\n");
> 		ha->flags.mr_intr_valid =3D 1;
> +		/* Set max_qpair to 0, as MSI-X and MSI in not enabled */
> +		ha->max_qpairs =3D 0;
> 	}
>=20
> clear_risc_ints:
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 6f3c0a506509..94e350ef3028 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -108,19 +108,24 @@ static int qla_nvme_alloc_queue(struct nvme_fc_loca=
l_port *lport,
> 		return -EINVAL;
> 	}
>=20
> -	if (ha->queue_pair_map[qidx]) {
> -		*handle =3D ha->queue_pair_map[qidx];
> -		ql_log(ql_log_info, vha, 0x2121,
> -		    "Returning existing qpair of %px for idx=3D%x\n",
> -		    *handle, qidx);
> -		return 0;
> -	}
> +	/* Use base qpair if max_qpairs is 0 */
> +	if (!ha->max_qpairs) {
> +		qpair =3D ha->base_qpair;
> +	} else {
> +		if (ha->queue_pair_map[qidx]) {
> +			*handle =3D ha->queue_pair_map[qidx];
> +			ql_log(ql_log_info, vha, 0x2121,
> +			       "Returning existing qpair of %px for idx=3D%x\n",
> +			       *handle, qidx);
> +			return 0;
> +		}
>=20
> -	qpair =3D qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
> -	if (qpair =3D=3D NULL) {
> -		ql_log(ql_log_warn, vha, 0x2122,
> -		    "Failed to allocate qpair\n");
> -		return -EINVAL;
> +		qpair =3D qla2xxx_create_qpair(vha, 5, vha->vp_idx, true);
> +		if (!qpair) {
> +			ql_log(ql_log_warn, vha, 0x2122,
> +			       "Failed to allocate qpair\n");
> +			return -EINVAL;
> +		}
> 	}
> 	*handle =3D qpair;
>=20
> @@ -731,18 +736,9 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
>=20
> 	WARN_ON(vha->nvme_local_port);
>=20
> -	if (ha->max_req_queues < 3) {
> -		if (!ha->flags.max_req_queue_warned)
> -			ql_log(ql_log_info, vha, 0x2120,
> -			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n=
",
> -			       __func__, ha->max_req_queues);
> -		ha->flags.max_req_queue_warned =3D 1;
> -		return ret;
> -	}
> -
> 	qla_nvme_fc_transport.max_hw_queues =3D
> 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
> -		(uint8_t)(ha->max_req_queues - 2));
> +		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
>=20
> 	pinfo.node_name =3D wwn_to_u64(vha->node_name);
> 	pinfo.port_name =3D wwn_to_u64(vha->port_name);
> --=20
> 2.19.0.rc0
>=20

Same for this.. I would encourage to add stable for this patch?=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

