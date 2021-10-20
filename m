Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02BBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 01:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D06A6115A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 01:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJTCBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 22:01:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46828 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTCBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 22:01:15 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JNTumJ015003;
        Wed, 20 Oct 2021 01:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Sakv/OVb2RDko0IO6YnOKoNu7Uqkaut4l2Mix8rat0c=;
 b=pfN2NwiJM5k/++wIAar2alfXHQNCmwS8IztqJJ5xkhYiVZoWiJ2nSxFiq1VNIftcqlCB
 CIvFGg+Acoy3p73qHDOS2L/feNVosCuNIY7kLFgmPAArw+2e0Dp5Iy0SWxnu+mOIpDWg
 jyUc9FXqMsvUB54HxqJm0F/yR4bu4ib1vx3lxyJcbG134zpXZFvcPcdCTv9Ap33gkjkY
 p6qPsuv+Zt1hQSis3GL8C5tETrjhz68g2lu1qNRGgoqJHZONJhaxVBsY13scjltkGtWD
 iz7IkCvwDcuILPkDepauiSR4sAZWY3D4DVnmF/mwmvg6Pe4LVjxWzCGGkv+zLBSjty/f VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsnjhwwsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 01:58:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19K1pXk5194549;
        Wed, 20 Oct 2021 01:58:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3020.oracle.com with ESMTP id 3br8gtbgte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 01:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJdMo+zSbwkOY9/x/5yOTLamn0ojNq7oUCivZHlcoWccioqakSQxJzQ0HATCPrzlpk0YTJUiE4Hy58KOgsx7aRzlsPzoFSlt1xuZHqRV4QbmDFI9/gsw5xnrrve5hdmm1oaHbuPzTylPYpq7t7edgJO5eFgyhQeON7yWPqzdP+fOZ3+RiR5hXJqqhjcVDzB73qE5MSvdChZYiu4Q+kqlTx1NIUTUHYJslduloNbt5CmNSuh9Q2E/FST+T9m1zBoOqXD73fpLCT130RUqfUq1dI4C3M4LpmGm+Zh7kaxW5EowFKuKVgLUl/FSt7+Bz/MUldEUi10O3PfRCHh++YWMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sakv/OVb2RDko0IO6YnOKoNu7Uqkaut4l2Mix8rat0c=;
 b=XVCpJsLvWmdh4D1G/glUL5UHiWLdNnfOFVy11PBfAVYqnFWoIAWY6iW8U5ctNZOniq3uCAwN6HDUQWFVT7ShgV/AuZ0pyl0u8vxl6ru1CWJFi/poStrpL8cOokZ4W1Id/X18aqcvWRicbN29JxxVaQcqC4OXYVX+1sGn0p2h23JDBzAhxojBED8RTnvUhqvFYHC6rUq6zG7sKkleqAwzNgIFE4vhwz62m892CPN3TpWLr2ti5qV+s9SfSug/0yKZJPFoglM1GZOu6EQ0wcOqfH1lsrty/89wELlHnkTwBOkZcwHFVjn9Ib8F9W+qQWsF+IbBnd5gIsjR+wxk10tCtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sakv/OVb2RDko0IO6YnOKoNu7Uqkaut4l2Mix8rat0c=;
 b=ozmnG3OwjgxNCntmxxlePjOvksD39LwYO2kzuLJtHf5Z0OGNrQPrHgDdPO6uZMT4wHK0qqDSXXCKawZJRy+49GWd9pkf919XKhbzbjbrjr0v2YbcL/7niCNxJJSRR81ZgM7HMzYKT6JWhd0Xu8ILPbnibdJlsHULwqzYL84zJ8M=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by SJ0PR10MB4672.namprd10.prod.outlook.com (2603:10b6:a03:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 01:58:53 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::1f5:12bf:3985:e2b6]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::1f5:12bf:3985:e2b6%6]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 01:58:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
Thread-Topic: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
Thread-Index: AQHXxNPv7vDkNg8t/UuhyEaJblny3KvbImcA
Date:   Wed, 20 Oct 2021 01:58:52 +0000
Message-ID: <4A68DD30-1156-42F8-BBD4-DE663EC73893@oracle.com>
References: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da82a356-ebfa-4093-3064-08d9936d2ad6
x-ms-traffictypediagnostic: SJ0PR10MB4672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR10MB46726DA89831E4FAF9365471E6BE9@SJ0PR10MB4672.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8eHORJulfasw9ClI+MubVw3WdL7XE0KyHO5/oXjrAQqJAYOBHpq9l0HkmFPl5VRh1NBtkOihTD+H94U+Cuuf4ETKxXroDyJb/ZLYSWynJApY2TQqWhytmf0G+PKeTMofqCUM8itOUGzTwUoZOGZtqjc5lXy1ap46v+eupGqWYc8mLY0jlOPvDGTngx6huT2wLIXCE65k7z+lwytHlePiMtW+2erWbmqZZUTyu781AhJ99dlaZ6X2r8oBOUvxBmASSIUGQYxPFpPNVxgcpGI8qOMqjmeJVGYcvZkqJGRTgrgDKMZtWwqzvoSP6PXvCpblh7SLk7eo1HpuaB23z44S3B5DJRGafLqSwXuTL9SrUqEywpLK5+3nvX2gsUb5B4V5ZxK7rEKSpG5dSo4xCr+LoGIo9b5JVXFqAFwJSVgLNeczTBSeqzYFRlMPKtDqskFgS5lDgnGjnM0l9lq+bAwMJhJYYDxhDZrPWuUVU61UvFiWzhJOQfQLHRzzouin2xt52M+PRtwyKcvVt+uiY/hrqhfPk8pr/UkPNWwRhuq1Atq8JgXszOkPR/6u/YqGJaHY/3IUqf3UgVF9q9ZEMY2DQ5O3pjjxSeXEmXma+Vxd2jeZmMyH9nUKOkyoQ2590yNc8KGkrg3wPtzUCnehfieeCv5wf/dPodNTr2o6WD1GDjIsz6qc+YKZwAxKppuSjRC8LcMX2vskV0wFd7EOElLORW/OS3iUUkevnuz8CIrZsJGXAFNxOaLxa9XDjlGts63s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(26005)(76116006)(38070700005)(66556008)(2906002)(64756008)(54906003)(2616005)(8936002)(83380400001)(6506007)(91956017)(122000001)(66476007)(38100700002)(186003)(53546011)(316002)(6512007)(44832011)(36756003)(6486002)(4326008)(33656002)(6916009)(508600001)(71200400001)(66446008)(8676002)(5660300002)(86362001)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ioCj9p0b/8GMwi/4iuJh5gODnowAapAH6bM0Ey2m2eTUOJkJHQQvFnfRQvCn?=
 =?us-ascii?Q?YMOkPk8qUj7v68D9bI/2HQsDAKuMwNH5cetil0rAO3wSjlFTmBx0O824KtcI?=
 =?us-ascii?Q?lN34TuCxOdgV2USVC+xTXdZq3oLGa368Yu1Req1rplMsO4up2ppkArGsPD7U?=
 =?us-ascii?Q?4pvcqhxPJ36L++5aRZ2RV0EPHIwSgi+XHkFoiXQoiNPG4CArUQse1f4Ft/W0?=
 =?us-ascii?Q?Jmq3kUJ9Qntkdt0dVuyGK1a6uH3BhFP6XIPWPws2sjH7fYox7dkjeOIul19b?=
 =?us-ascii?Q?3iDZYwY1UxXXzCxwZl1C7bWBPSPnDJdNhO/ZJDLwqkTdj/F3zJR3s05Yjo3p?=
 =?us-ascii?Q?ob1VectB1USCeiFx0qRbLmyvBGreoKCPQa529lMxWKQfXrm96Etu8/Nvgowz?=
 =?us-ascii?Q?QDY/T53iLDghAhW7NS1qux6vHZwVKruoVmufiCutmBPKlJFcS5XNCaBcXlNA?=
 =?us-ascii?Q?LcMUheGkEXXL1c4705X5TOiPfbq/O4xXabhfesLB8B5T2z4RN8+nC1L7o7iX?=
 =?us-ascii?Q?yrrNnYt6OFWF/qXbsSYJzV/kWkwIB4PGYuvLBFUmlyLsGrVOypWoO0EFmWU2?=
 =?us-ascii?Q?kdTcaXhPSsbZEVnMMepKURYZFYSeaS2SUmVdXItzqzHEBYmpb6Y+Ra2dJssh?=
 =?us-ascii?Q?jDuQAlcg8bZwNlTfB3MhtUagEdLqHJnAyZneBtG1tKQK/KpJtTaEV/F8DMse?=
 =?us-ascii?Q?IqEl8mBeLnR0uI6+aubYuukBC4L8qZioM+Q+lGBe6nq7SsW57sOC/g+hu68i?=
 =?us-ascii?Q?r5VPW36dkfR6SBpwjSVwkLQT7VSlUiR5nS2er+OZxqUxCLjEQ7BXt49cwl0J?=
 =?us-ascii?Q?xNdWrbdGroHS2oVIv0uAVqJBiXg1aY5h+sylBD2Q4P31e+6J3MeadnyyZQCV?=
 =?us-ascii?Q?UnZuyJGV4jysPtjIyf9SF9DW+VadRwV33YP9CbJxf/mOTwivdOhXLtx/KwdA?=
 =?us-ascii?Q?GpiofHCtz52kcpCjscoXltk1aRMRXvwaCRWsnF2BW8IdQ+6n/tJEmy/mZ5Ts?=
 =?us-ascii?Q?AbvYRWfqXmlB/Zs19Yfn8G1sQiFa+ntJ2Qbrdfbxb5Q6G6tNGmkhX3jnBlCu?=
 =?us-ascii?Q?tnv7KBz9tPYaf+n8nm4pzL64pHQ9Vpqrzi1dYLtE8ElWUOMuUWGPo8EJgLOk?=
 =?us-ascii?Q?inqfSPt3EKv0Bv174lEdfDzrYT21hqQXqg7tKN0vF+sVOC0YdZ24DkRKi61A?=
 =?us-ascii?Q?++Mo4sffD6gI/QO2CnLlvk9Q4ZV/suXiugg/WGMsVBSYXU7ZfiNHJDejHiGT?=
 =?us-ascii?Q?kLYQ6J4RIkXnVqvKSZFjcyqoJjHQeH930PhisL4lNfsERDbQy2ASxvjYUMQr?=
 =?us-ascii?Q?0EtOCqJQnjB1V8m7H+TUCVlMOkAqantGGDiAzfP+SqOXnw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5CA1BA5E8A334A4DB9114398ACFD53A9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da82a356-ebfa-4093-3064-08d9936d2ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 01:58:52.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 14tCgyo4bwzrn5o0U+7qINPC3TyLGhuOnINoEXRaUgSibe0OEMK1KHC1UPVrh5xQvIseGtlSaf6SKT3Mf3b6PHaju8Aj7Bh/rrzd3VNn6jI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4672
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200005
X-Proofpoint-ORIG-GUID: oeTuKC3h89JXamz76lfSYuzWN-G5kCHL
X-Proofpoint-GUID: oeTuKC3h89JXamz76lfSYuzWN-G5kCHL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 19, 2021, at 5:27 AM, Jiapeng Chong <jiapeng.chong@linux.alibaba.c=
om> wrote:
>=20
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
>=20
> This symbol is not used outside of mpt3sas_ctl.c, so marks it static.
>=20
> Fixes the following sparse warning:
>=20
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:3988:18: warning: symbol
> 'mpt3sas_dev_attrs' was not declared. Should it be static?
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 1bb3ca27d2ca ("scsi: mpt3sas: Switch to attribute groups")
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> ---
> drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 0aabc9761be1..05b6c6a073c3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3985,7 +3985,7 @@ sas_ncq_prio_enable_store(struct device *dev,
> }
> static DEVICE_ATTR_RW(sas_ncq_prio_enable);
>=20
> -struct attribute *mpt3sas_dev_attrs[] =3D {
> +static struct attribute *mpt3sas_dev_attrs[] =3D {
> 	&dev_attr_sas_address.attr,
> 	&dev_attr_sas_device_handle.attr,
> 	&dev_attr_sas_ncq_prio_supported.attr,
> --=20
> 2.19.1.6.gb485710b
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

