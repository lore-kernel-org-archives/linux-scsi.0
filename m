Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DB3EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbjFOAf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjFOAfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:35:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84482690
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:35:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJkmoY011578;
        Thu, 15 Jun 2023 00:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fVEcZOHkcUy5+Qb3LjAfgCvV+nvO+otftE5AhC7NQj8=;
 b=a/D0iuPO2ZkQ9CpVL13KHqsgLQ1duZMxkQItDI1WEHzNwyu1eCKk7CVbtCcproc94QcV
 NR9/j1WKHzY160lGx3eiF1wHPHMugVr00mJjvf1nrjzHS1qk6QQEBApCX3XwF2RU1wRe
 bN2TWp0zzfXILE2akiFe4YiDznHwgeYg9vft9jKLitA6Edjk8BdqnAenmq5DcfjcC03P
 hnluqePfIuopS2Xn/vaum7lsSU4ntHaF3z72m87pCPkByZcDEwYHnyn8lvpDT0vx+bbi
 lHUVkQa6JnKmBjgg1yuZyDl+xSVgkkRrEuK0eYK5hSp1Cw6rhaIK0JlnTSF6JSS0L6Kf UQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqurv0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:35:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35EN5Ddf014003;
        Thu, 15 Jun 2023 00:35:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm60q8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:35:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffcs5D3XSJlwj1zefghI+hk67kX09FiVjgAd/zBY4VmMzvlwRQ7x+MDI8t1oV488By74oDF4lBRSej9951J6wyqS/3kxBHWrDv1GSMF8B4r8rED6N5kghNUXu67iQLIrj0GjnKPMgcqaIEqbRD59wEOR6Dujft46e2QRUXuPojHKcgvKarufR0HL36m6FJoIx7a+kKbcokYPIwc/FKKTQxTW0VR6MYVGwxHrGqZUaCB1M+nKVIu8UmUX6HenlUARAP6+S4IbK4RVMTspImQXy4S1hv6yX5MBSCD99UAuorPbljXZAe2+faG2CZ5WNxeMvj9oedPOO+N0qWkOomjs6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVEcZOHkcUy5+Qb3LjAfgCvV+nvO+otftE5AhC7NQj8=;
 b=R+9DAuOqcMmcsLVmoCSCbFDyRHLQxCY3OlTFall/B/C6up0nivhCFZ5UQ9LsmZNz92oCfWfdU77XpUC1JgYmhLGEpl3l3kZHkLEW9m/qOByeekieLWwqUsHJ+5/fBca1gVZBcnJ3CY+FEkqf3BF8wdFDpEdYjImPJlApnmm/uY/qn2a0naEhqtB6QllobzU7kDRblQ2us8vvmcYafH6x+qDhwYY/sRuoGheCYK3AXX+GFi8JAop7PaqjO/wrLOWYrxBTxOl/+s0xPHE4rYpnzVDPfR0LG02O7iXvOjSmR4OUlaOCi8eXBhynImZ42XHdjwu6B2ryn2tTXLZyO4nimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVEcZOHkcUy5+Qb3LjAfgCvV+nvO+otftE5AhC7NQj8=;
 b=xCWdsd5eMH4/HXtbgStpcsZRaL7hMqLl6pAEWZ8a6i2axpD+Vg+jLexvxmOsQKkPy/nczv7NCUzGqB4lVS3voguJtpC6RYEEdfyaHeEsgSzAxIK4lNr4cD5HvaUizRfcB9mJ4QJ1+9AxjuYLhxM3lj9Ns7+0OuO7cFFC3pTm7V4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:35:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:35:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 2/8] qla2xxx: klocwork - Fix potential null pointer
 dereference
Thread-Topic: [PATCH v2 2/8] qla2xxx: klocwork - Fix potential null pointer
 dereference
Thread-Index: AQHZmTSoTw5vBwtWTEiVmbfqiTqIiq+LEA8A
Date:   Thu, 15 Jun 2023 00:35:19 +0000
Message-ID: <963432FA-5346-46FD-A488-1494E74701B7@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-3-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 731e138c-70eb-44c7-e00e-08db6d38659e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /sgu/glp+Mmk1H8C5QNXMPDhcTvnZzgrX3usmi8MEEEPdc4qpSsRQb4qggSNdO2xwkkfSlZMt5YxeGBfwGi2fXGK3BjiKDmyZa/sQoz/hrK56wua/0VSqGTrfqHhqEePuc/Ifnwf4A3c41U0z46ORcYBBl2mrN4dLEEnpd8hWDGe1DysLtQW72gLGM5815BPJEHWVLJHpJYWgefQwpFaFD77tFUJBOawCvjhoJxJc8aYGUgGZ6AkIjDwgVyPyuO5VROYORKXQ7dr8EJQFlwzsbOSNM0nqf31M+2SdPzxJGQNeLi+6e6rn8pMRptfj9GGgtjQaaswF4mJ1pPkugWoXF+DgGxj4ZDnwxCCcDzTJGIcwz1AlnBJgVkPY6SQZ4/P+abWX9II8fUKfpL/Lj7ehzwbwxjsSb8gxjrYDKG2aTtwMA1drn/ReLt8XX983ctB3F+PwZxlOb24qAOXmCD+yy4kOmDD1znguuWT9FIvdWQ0Y+mZvGWhpWomj9AG9E7aRTuWpHqJLe23p46icdIruKdY/YGTwd5CTENWwuQp/I+F5XIL9++AKTskv9juBskwPCPdrXzNP/yN9yJKx/vvr9do7f+LNxhJML48eaQzxaASfLM8dY7vrdL+T3XOIyWt5P4hzcq7iO59DSQlQpQEjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0PVkK7fdBel5RAAx2MH+NJYQbUC0T4cK0ba16gE19Wg7OiqoZAdPbukJcBu6?=
 =?us-ascii?Q?9q7jQW8ka99D6dHZ7BIrhfjkQkYbnKScKJH9Q9wxNu2UHulWXdHKQCS3eH5r?=
 =?us-ascii?Q?/WkwVi90h3oB849HGXr1lhVkPvDrpMrV3cKxA9u/TKDY58ehhU1UygZgx9PQ?=
 =?us-ascii?Q?GFGs+2Y6LFIeFUMFFLefV0+hjCOlfwL92E64f2b7Y9Py9yDgeHmwQxLROAIu?=
 =?us-ascii?Q?vvBf4ALTvUpAlzT1TWwMT1LuFMmJ3prLzls6ITfJ9AbUE5ufArGLAbhrvvih?=
 =?us-ascii?Q?V7dtuVs7XLK2bAJrWkwmxL42BYJ/PkeY/l8W0K0voHYH5axUJhgI9z/5OGWK?=
 =?us-ascii?Q?YHd9UC+FU0YmqKRoMCNsFv1uGCM4fLnhytD5xlvR+/fpz7so8XMpgWGqfYEX?=
 =?us-ascii?Q?C7bx6JeVB9boOm8JXgnWKRVoEjLTCsZ+Tv4rCTuZf61ookBj6gPbL/QYvXfj?=
 =?us-ascii?Q?6SYEyxNJslTqRMvTiVGdOwrXMh9VYPoqdqbCOZOgVRqevPoHl1ZLWUpLmuZO?=
 =?us-ascii?Q?Oz68imup60lngVkQ2HNXlUOKDHmR1G1R1Jfcw5b2K8gD8LQRWqPUp+Vg4VMH?=
 =?us-ascii?Q?4UAyyFZv/3H709UnRn9N1hAiFw3b4jAgyQQxcldHqG/pvxa7wQOIuSILgOg4?=
 =?us-ascii?Q?UsmjZqS99sTWhSm7/kl5jHq6n90nrHqP6wQjheWDSl7ncsca1PQViDJt/MhY?=
 =?us-ascii?Q?hzEzzvV/Urqk50LN3wpC7bXmtIRXzD5u9vwKUCr1YzSe5U2C6Jzg56/w96T5?=
 =?us-ascii?Q?nj14H/rYs37hwl9M1SQPrsDIo1C/kNV6tWQu7ipl6+7udjrgx19EdlhbVL0/?=
 =?us-ascii?Q?EaNheQjbGWLkzyX3e5ng+rQNP1PAaviw6C+LhhQ6Kquq8Deyv+Lc06HbrS+r?=
 =?us-ascii?Q?XMp8efFZ4AvcV/bicJneqixbxHYtePIjU+vn6++fASn8va2cOB2klaNE04s7?=
 =?us-ascii?Q?Mgp+XBS7GfPfe7I8aMbPdUJCT6kUAmqfZqqJfUWlwgaDHCtBdrmNNZbxXvbg?=
 =?us-ascii?Q?VoNJDzxWuNN+rYlTF+2T0PGr05ABkjhGTg6w8yE0IIzJ9wQMmQpl2JXqxY+f?=
 =?us-ascii?Q?4asJ/EmmSvpjlzFLxivI3J6FecMWOJHvWPWBlYyAkmE7Quf80cwLm0IzVCBF?=
 =?us-ascii?Q?5HWVOgwc1kmU3fD+r9hzn7Mu2ZWVpIgZ4d0OqYysfJSPB134or8yYlKhUOkT?=
 =?us-ascii?Q?4m0esP1zSIWrbZiR77G0rWroTv0LGsEOkZm+XNK4MLC61izSxJFClC7c/DTn?=
 =?us-ascii?Q?jg/IjcktP2UII0EITxgBI0RFW3S9+Hw4UxV0QQEOlfCL9ilS0krJ7D5ZOiy7?=
 =?us-ascii?Q?iE8j2BIYoXhrRpaoqWZwtAA0MzVj1/NYP8JBCZuoTVDB+F8wgc0fcJJv2Ik1?=
 =?us-ascii?Q?CHpNdZJWMSXT/+qB6/khgOR++zjDVWAPtDaJge07rLK7QHw6B9pgTbdOqGYk?=
 =?us-ascii?Q?IRZ3prdFbnM0hqyiC/iGm69lnKBG2QnEgSaqslm4vKqJTJQGFx/UYfkaX7Cy?=
 =?us-ascii?Q?Qaxbk/WKU7Ap7XSrXW3VCaAK+DYwv+n/b8r/ceiO3MgnCrdSvnc8HLpKPEJE?=
 =?us-ascii?Q?diYmHXYQIi1/q+g5Pv7ZK3YLtYFAeeU01I9bB+tlOVUjGtayF81vUHW8mMSR?=
 =?us-ascii?Q?1w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5326E9D150A4834DA2E5693D1B3DC049@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UVV6aWPl3g33S/JoVPZJzRweWnsofQ4rgYsiZ17u4gcAFfw+DiHhJK34WjgbtcfZW8sDYUAeQUtTV/A/R98XZTz/QGRJkpnaOTjRsJM1g5hwmsNTLJVMltJtiyijlnxJwxg+yIm2K8Jw+4R03WNgjAoq76l7chsxUmOwIU9qwn2EaK8zpFBq65vzmk90Pnk6Z2HMSCXNxg+e3Y1V08I2owwlmLk3aCQafyi7ON+Ybm90VGkM9H4amAILQmEUoWV9TYsit7z4q6CtfCwAfhuVhev6qJcpY6VJin/71wMPGh3XpaVXlKO4E9GLlagqOqihQ26u6mlCR0JCtcvhI9MuQ81K9HMk3Jk4H3rk46rpFAtrNZT9SMoUPm5iQIoKHZUoN8lN0p3f3y1d0B7/LCGZcb/HjMVIyKuvlkvKXv0ZkvoJJmZ6FRRCg0skM166QGKDwUx5E3ovGCWK5HBqQszrKYfCa6GrbrXpACwvJKDrf96EnTYSY47N2k14wd7/CqSCYD0abBGDYzKnXu7L0EywXniUfqW6Xqw+dG+gIHNxZbnGGSUmF/4c6P0PmD8+qZVxJg+S+LCQYJxqqr8Yz5l0lk3k9/Ak1r95CFJk6HKbyBgO0XJqjGWzf6kgZoruaJn+ih5ez9MN2hVN0LO74VJht/VlcL0O9BrTL/TUzHxmo/zutyQ+3YPlAG6DfsGxIKwVjF/sp1snER8NnsCoYS8tZzhFHs7PVCORqGP1BiZboaUUXy+oMy6n0o1f3XhpqYW8q86QWa8uhxc81Wn3gjzF31x2WjSxFPYYzic7nws72tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 731e138c-70eb-44c7-e00e-08db6d38659e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:35:19.3124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3y1efTD5YvgEmIJs2i23ZeuXc+zPVpeP/5XSTNSlrVcux4L7rkbdItN92VYzC2MfmMkzgqDX9cHHoYwalJZrNGWMrVtNU8brRe+p6NK4HmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: pEL74cCM73YrHJUuPd2PQbBf2dLMzFEg
X-Proofpoint-GUID: pEL74cCM73YrHJUuPd2PQbBf2dLMzFEg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> Klocwork tool reported 'cur_dsd' may be dereferenced.
> Add fix to validate pointer before dereferencing
> the pointer.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - check tot_dsds to suppress kw warning.
>=20
> drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 6acfdcc48b16..a1675f056a5c 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -607,7 +607,8 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd=
_type_6 *cmd_pkt,
> put_unaligned_le32(COMMAND_TYPE_6, &cmd_pkt->entry_type);
>=20
> /* No data transfer */
> - if (!scsi_bufflen(cmd) || cmd->sc_data_direction =3D=3D DMA_NONE) {
> + if (!scsi_bufflen(cmd) || cmd->sc_data_direction =3D=3D DMA_NONE ||
> +    tot_dsds =3D=3D 0) {
> cmd_pkt->byte_count =3D cpu_to_le32(0);
> return 0;
> }
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

