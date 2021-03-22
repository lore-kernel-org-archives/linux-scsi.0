Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6786C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 14:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675E56192B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 14:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCVOn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 10:43:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhCVOnf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 10:43:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MEexxC007468;
        Mon, 22 Mar 2021 07:43:32 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnw89r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 07:43:32 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12MEfpDd008479;
        Mon, 22 Mar 2021 07:43:32 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnw89p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 07:43:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQnsQWNb9GazUkSxV5l04uLWPR0zUYeQMbeapLe6cQaBlnA+niAr1f3QrPYLBEFmgkUpIwVSB/2Ys66XjmwfLOZS2gacf9ikNbHMSEqSHKXzpAN6TAMfiXeap758g8Vo3dIcSQ/l4EemoSgvTZ56L5zUdp7wot/rrxBYqxhxNIE69HPxLDP7pzv7/PFEfTdOKy6oyYZnPnwfoGOopFtUaF5vVemXtoUcB6MuKIOMcFehgLFLHt7DSoZuChcgdd660hHXZR6Pk/E0WmN+txXtWKPWeDa2SqjF6lDOqWkKsv8SOD5aBXTiBgHSXzEDL4anBe8T0wwqVSlPzFTv1kYWhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9mh0owMVsBLip9IKOcenF3vuIVtb+V4OGrfWJJBEOk=;
 b=ORrkSYVpO6HUf6OHOMJSrnoe6B8IjKmCsM0bWJaPEdFN6KISgYZPeSWUlrj4A7tttg6RBJANNh/UwpNj9jhGBz+WR47MQMR/5CGHDdUxZ3K/6Jq/3P3ktICzUEHAx4KawrNe8jv0wwNYius+QaYIkkgBZu0sU/kwH3oxSQvvKReUQkEOZ4F8yqgOCvML3bXNOl1a9sU7jz3q/6Tvp/rHPp2vW3JVbENE4z9XeYDsscqocfTQvB4tWmkGYrPXi5kJXP79tq4RDxAb/F7wW11fvm0jK1724PFbThBpGniX7YxZLs2hZNlcmdvnGehuxt6fb1U7Hrt+DinU0EHBUENuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9mh0owMVsBLip9IKOcenF3vuIVtb+V4OGrfWJJBEOk=;
 b=ehsHLEZbIlmTiC6+8i7KxT9QLv3/qDotWx5LvYc/H4oOcGVKPE31YddTXilI9RRxcOK9CyGAW7StF6kXIoDPlK8hk+FAKn6DJt1egDpLNf+H2Yn192hekozoZfWdzTzIEDE6gKkxMJ62F7CVWXg84DPj50afBorWCI4V1xe+kxE=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3314.namprd18.prod.outlook.com (2603:10b6:a03:1ad::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 14:43:30 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 14:43:30 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedi: fix error return code of
 qedi_alloc_global_queues()
Thread-Topic: [EXT] [PATCH] scsi: qedi: fix error return code of
 qedi_alloc_global_queues()
Thread-Index: AQHXE8tn5bUdZsh0c028YzY1JItj5KqQK6sw
Date:   Mon, 22 Mar 2021 14:43:29 +0000
Message-ID: <BYAPR18MB299852960224776DF536EEA3D8659@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210308033024.27147-1-baijiaju1990@gmail.com>
In-Reply-To: <20210308033024.27147-1-baijiaju1990@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.74.174.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e01dae2-97f3-4689-6bb8-08d8ed40dc3f
x-ms-traffictypediagnostic: BY5PR18MB3314:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3314747E8738532E465F48D8D8659@BY5PR18MB3314.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IQBNRbw5Vu42QPuNRv87sVCUk0JcIXWuQLJ2KauZzvaX06tDg6uH/D2gshlGMlzlL5vJCCyWOyFf0kFtAmmxa/37c/YGHLfKEUzo9Vii3ao5rlpggnn6Q2VXVwKRXdrwm5uLT5gi2JJdYTyXNDufAA3zGRvCrmYpZUOgSI86yxxKmHIBEGwb6WNQb1B8m2UZdxjfMgDJWO3kRUTGemNaURbw43DpJsnXpxc5popYdUlnj3jgiNwd0Fu0OoABKBZd/EkbFdv8r6pTn0fdtDM6Q28b03Ta2TZ2zhAdzcmeN8z89u5r1AO4cjx7yjQt0aheciUFHKYlIfjsBr/gJ9gTjp0HVhb4ZNa4jeyxatSTAtj5aD/QIv00weROlSRKXI203vUkht/gXiSBjFsNwgRsL/m0CynPt0ze26ooGGhGYJ7RpQYkfIrrwCrFcxgpwKNFYUDaIj2uIYj/MSUOJY7M2Z1n6swsaZF92fVO0H+iW/G6dNMMq5q5Y1I4jQQNR+uv9paWvTdjGSX38vWHd0pUlrOL0A2p1tgc1P2HyljfmaQOK3pY6Zo3fyYiJHHaijJZiKJJdonoMsSt9FFKQUyoLgGXHq5TZ1xuRnIWU95SZbtqcA5GrsxP3Owyg0+OxQLKMMQ/IVtjCOe5/keXLmXUqvXTInYMqJEaab5Z2A19BU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(478600001)(33656002)(53546011)(8936002)(55236004)(5660300002)(4326008)(6506007)(52536014)(66556008)(66446008)(9686003)(8676002)(55016002)(76116006)(66946007)(64756008)(66476007)(71200400001)(38100700001)(83380400001)(86362001)(7696005)(316002)(54906003)(110136005)(186003)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?19uyZ1me4rW6fEzS613vRPi+98gqO68zlSknUmf4qBBCkFsIp07YcF+nnDcN?=
 =?us-ascii?Q?Uza072hnBNn+CC2Y+23ugN0EhsDVNSOQQGJzs3bc3zCCyINcuqDEFR0tFHwS?=
 =?us-ascii?Q?agztQ3+ztZI/q+g/Z2b8pwPLRUt/3D9Io9KL+G5EuHqJcjNgPoyYi9QUg1vV?=
 =?us-ascii?Q?VXGbwNMDKykv+oOFgI32laVIRl+TMShYjil4ZjaDNYOEDoqZgq8htb0Mq+M5?=
 =?us-ascii?Q?NFuUj/zIc8cHkgNnwce1cr4IUSjMutYFRh99Jo/KG+2Tp/Fdug/rb/U3b/cx?=
 =?us-ascii?Q?IZT+rzaviinj3eQ962EB+mcni7Pg7Ax5DXt8H5U3F0TkBOVLPGKPV4t1RODL?=
 =?us-ascii?Q?vm5k9UH1QkW7yDNbAdbClpTvr26CtNoAaPNZOqJ+LQLgqsjykcYJhrF7p1YK?=
 =?us-ascii?Q?fZrcb2juITQLBP6HCt7UgE8fGwICruncWzDebt7WrvPsEt5SYm85uskiuQ2m?=
 =?us-ascii?Q?a9YmO10OV+0m+LBBH4FnF776Z6+0Z6ROwZQJEfTUlYe+S3j20vqa6K0jibNV?=
 =?us-ascii?Q?3BRh4R9Txe8J1GCteEeQOLFwR5ryDUXDrhW7DupIS7WSBzB+j4cTvCB6cAF5?=
 =?us-ascii?Q?Os2yP/xHLmunx/jObHii6JevwcWohRssHROo7cz/J9AHbJoWH25dqxPcl0k0?=
 =?us-ascii?Q?gqC7wyMzgYXbfUolkgmBxo94JHeOGgsEs6O0nyUOCCaG4pfQiJ+hqYqFmNKY?=
 =?us-ascii?Q?xpAUZqzaq3EzygUl1GIZvKQ92Ixxh26M/kA6LPARKOwccCzfhJIaHpTAgQOs?=
 =?us-ascii?Q?eTTxwe2CKtu4OkeC2yOJ4ciOTeA19B1v6XyuUGdKrYOW/H8OqQhxhqAgkMZv?=
 =?us-ascii?Q?onu5PkVu4EPXWnXat0awPk7MGH8MsuZHqndH4ggjBQnA27kTlmDDo0V0f9RL?=
 =?us-ascii?Q?GEkT1G6wluwt8WpVxbQ9C28bXjhBASId+tHu6omqMgzvli+1Pqvzd/Wb1lhn?=
 =?us-ascii?Q?NoGrEkfACb+n145f3li5jHJrYsjH+1SRsmdrn5IB7FtWes8xO6TrArkqW28Y?=
 =?us-ascii?Q?3UgponagWMFQH23H/qcD5rIydH7Edztzf/xDg0KDSwfjddtInYiEh5vv5OCY?=
 =?us-ascii?Q?Feoo3C4aWm6M1tz79N+34C/srzup6vrpJJ/Q/2XZJpCGzn+NkNn0bGvaMdhy?=
 =?us-ascii?Q?nFIecc71Tfev9Lf0E0a7/AMlwYY4jelkwxNZvrivZJBhVaSF3lwAty8WoUZV?=
 =?us-ascii?Q?xHcktUyrVsbGB0pQHXv225Z1Kd4LjOSBXLl4wKLOUu4v4RNN1uoeU+8riO0N?=
 =?us-ascii?Q?FFIjM0OsjP1lHPpr6LkNW6b+1VS6Q+ymLrJNwQX0jSPWkMDc0r1mmHf/kQgJ?=
 =?us-ascii?Q?ITNTmBIVZpoEIRiMHOAKR5UO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e01dae2-97f3-4689-6bb8-08d8ed40dc3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 14:43:30.1239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c2zDNYJwGRFacgji9neNdV/GcoLwIrSMqw6FwAEZkXAJbBXbI3qs+v7ei+SpS+NqJJhNWNpuXeweMfvaEgK05w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3314
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_07:2021-03-22,2021-03-22 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> Sent: Monday, March 8, 2021 9:00 AM
> To: Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Jia-Ju Bai <baijiaju1990@gmail.com>
> Subject: [EXT] [PATCH] scsi: qedi: fix error return code of
> qedi_alloc_global_queues()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> When kzalloc() returns NULL to qedi->global_queues[i], no error return co=
de of
> qedi_alloc_global_queues() is assigned.
> To fix this bug, status is assigned with -ENOMEM in this case.
>=20
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI drive=
r
> framework.")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c index
> 47ad64b06623..69c5b5ee2169 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1675,6 +1675,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx
> *qedi)
>  		if (!qedi->global_queues[i]) {
>  			QEDI_ERR(&qedi->dbg_ctx,
>  				 "Unable to allocation global queue %d.\n", i);
> +			status =3D -ENOMEM;
>  			goto mem_alloc_failure;
>  		}
>=20
> --
> 2.17.1

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
