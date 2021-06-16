Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CDEC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11C861055
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhFPClZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:41:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28670 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231959AbhFPClX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 22:41:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G2bR3D012454;
        Wed, 16 Jun 2021 02:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=muBpZxDJEOADbxlE+/+dA4mZG+nbFz8e6LzE6WbUm5k=;
 b=psObTFeLjoH47zvWHqYZrU1EAbq6guv0/7YqCUUxiqWcfCEGT9HGCQYQkKEyAs7iTWQt
 sC9jDs6AlIWAYkHGJlMlDb36K1dclAKbY4XPraggBgjeWiFI53KRJQdxHY25PLAm1wNA
 i/eNQMIIIZkV+1p9XfyrfyJYnuEbcUvyxfDD/c6HNW+d8JJn3fJybzCNdv4YbQo68X+2
 jjK5V0Bu8iq0hFhD2pZswOYPvvyatBTGLbNsd9f8Ljhj/EZ0DckVWlnJ0303gOUFDKJ9
 0esjzgwX7PmF7ddteiE/RIpz8CBJ9iYZG5kak7YwRoIjUzsEexMHESejQ0xOw9ieG6y5 bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 396tjds8u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:39:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G2ZGLn171720;
        Wed, 16 Jun 2021 02:39:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 396watwg0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:39:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgYBe1Zyc1FGRGYNrB4+jAGyP5MZaZzVuzYDkoZBnhoElstMc75vuNUrisrPzCrdW+ZzPZT6ZdmJNt4A6Ve4frbJFmtZ01dXFHGJy5jb0jrKIfoA/Tnwv2go1PIVjRLtpr5pWihBu7iCXD8jtINO1feARfO1uK8fOZ6Rr1nYr6fSPsgaHM9h114K5XZY6qudcwerDQ/w+5oRe+S/CpXZhe04ITNS+wy1yn+LvqId55uk24SP9eGV3Rrx3rECkRggW8RBE4eR7aj81KEifH2yxcpuYkgP5hSuqZli7KWDTK/W3HuN8JtoVsBbOdPNTMB2nyHYbn6Tf5Cgyunlcn6lxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muBpZxDJEOADbxlE+/+dA4mZG+nbFz8e6LzE6WbUm5k=;
 b=QwX8UijY6PW6lPN3xhSBhPUS3v0/mT/Pl7Onvz7eF3jHMjSbHyK299BG3xRz0rZJFAvd53MayGAmxNVMtFc4jZDEiErTipOye7l4dqa/tpHOVg4wQRh7kUd32yOgjLVINHVqUk1wJQmI/Dm830z7//6S9/4wI3bdND60OiZZHcaKW2ZWoXydTu9vA6sMSn1uhNOe9073BtmeK0x2tLlP9FQSRxCJP23Jm0LeH2TfH2DZ/rLxgT5kbI1T9TDhFBGNZiG2ulSq+XM5mT6RbuxDzaZhISamzKNhsnJk5NJ+CQRg99SUkkqyGWj7N6TbuEhtVxzkBPEhd6Y4ZBdQjX1RpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muBpZxDJEOADbxlE+/+dA4mZG+nbFz8e6LzE6WbUm5k=;
 b=oUrZhGvtSqyrbIOY3N51gegFFcd7eAj9XQzxY4FBjt+L1y93vl+dqQMRQxPA/a29HwWs7qtyKTdLeBvHd1R92khP7R9+HRtM/pAE/JVY/CNTCaFEMQ6orZZAScH/P2DPTBUxI8NleaTtXaGQQvGJJfIcpOyplbc99rHYBow6Gz4=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5436.namprd10.prod.outlook.com (2603:10b6:510:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 02:39:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 02:39:06 +0000
To:     Baokun Li <libaokun1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <linux-scsi@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Use list_move_tail instead of
 list_del/list_add_tail in qla_target.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsxi5y9p.fsf@ca-mkp.ca.oracle.com>
References: <20210609072321.1356896-1-libaokun1@huawei.com>
Date:   Tue, 15 Jun 2021 22:39:04 -0400
In-Reply-To: <20210609072321.1356896-1-libaokun1@huawei.com> (Baokun Li's
        message of "Wed, 9 Jun 2021 15:23:21 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:332::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0080.namprd05.prod.outlook.com (2603:10b6:a03:332::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Wed, 16 Jun 2021 02:39:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a80edf1-0624-4c6d-43f0-08d9306fe978
X-MS-TrafficTypeDiagnostic: PH0PR10MB5436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5436DA91E3EB4541237F80788E0F9@PH0PR10MB5436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQZLqEqriySJmO8OJtxpQbvVzzjEtWflLREH8SHYXVclLpatG3CiuOI5+/O1qvF9BBVdXeJdu7Ovm0WmBx8C8z/uU/gm41ar8wvVHQ5cgSIEW1sNmgv/fJjZKvvURiMAuw0eHILM5oVJdp2lVgLXItqRJ7pXm28MRGYBO3vBAATuDz6wudO7of8qWl3QOyLnI/OXLs21tYlvtKBrX3nnI/2kFBhJtvByUEd80+K82jt/1G/bV+2iHaq5A5Omg4fCrsV4cvsTuFqvGDvRs2n7Xh0ou99CM9RPp4pP0TeQAptTxIzAzq0DQYe0t2r/c7rdmhZ3aXVHdgXeHaAo2+mKZZWpuBWZFh68PurKFeMZQ0Ihd2vbqUDD8IcsQKE7lrBhw0JFmuaSEphZwA3wQdh6SCdbGwVEZn2aa3vGeWyvDURa5gOXw8lhjB9GDu8d1A9gjQIxmB1Q3g15fB/xmWaxR4rK+3m12fdJonTgXlEobVAibgfu0PM4tBY2Uuyc374TIL1MmEExYnyITXGIfHFaidu+rN04Qb4U9WsZlSN6MuoGGxi10rBQFGpyNdOed+O1vwptjLJni9rLTDY4tIYCbgxpzyD7z2Y76q+1d9oph11EIRzTEQIPok8WMe7jZL2mXZBi2MSUWGKLtbw+KcZetw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(346002)(366004)(5660300002)(16526019)(316002)(36916002)(4326008)(52116002)(186003)(54906003)(956004)(7696005)(38350700002)(26005)(478600001)(7416002)(66476007)(55016002)(558084003)(38100700002)(2906002)(86362001)(6916009)(66946007)(8676002)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48yD0Wd5puIPiUcHtc5Oq0CGsbmnvZlUfAEUJVpg0NAo4KlRAsjOVZi7XdOa?=
 =?us-ascii?Q?TJx2DpRjV8XGYwzGvnLEMhYpJggK5M6TleETwc+Ce1h5h8+IXJo66TC32qcl?=
 =?us-ascii?Q?Cf9iXZVNxUgHWM6jVjaHCqKm4hg/8OVtFQFbSWYib71GA5jRZ8Ah30BcYO3z?=
 =?us-ascii?Q?wH+Ukdbcdt/7+QHGwf2lUXSwokuu4ABhUgO5RHpCMOoWjow6sMaRIK3fpNLK?=
 =?us-ascii?Q?7lEBVdD3OdY1eDMWe5aNTtX+JNduj2OpeXfUQL38USOjYmosYy86Ith5M6GA?=
 =?us-ascii?Q?QUigWY1dIZrQPK1+FIAXHgbvO/AwoVPUHEqC3gh4dUZtjF7gOWBhfTdHlkWQ?=
 =?us-ascii?Q?Wmpa1uaAGSjccKL9EuglH9dMmkzwUnAGli0B/JA3AdrcJNT+Tkz1KMlbUO9/?=
 =?us-ascii?Q?dhoUv686puh15oJxlRTa2qtMT4VEq15LumUn7zfGaZ0qcvrbxsnJp2ofuZa7?=
 =?us-ascii?Q?tcX1tzwDvYmtZtAsrMjFLXvEPyYJwXe+opz3paV4T4PTud7meUZYRkyxfoSG?=
 =?us-ascii?Q?uodP/g/nLseubl0/d9m/kj3J3h6RNUJTUU/oQ2QQlLznDwrEuvzuFnc2UvLM?=
 =?us-ascii?Q?9SmREehGmgeP8vwWAZ9gl99PSV2aqb8V7dzONLEqCTgQcR6gRdjabqYcYTPp?=
 =?us-ascii?Q?hcV5FfJUi3x3dBV5MuifsW+JrZbElFAKlXxiqciM6/9UMoEDgqSrH7M0e3u4?=
 =?us-ascii?Q?cH8Kq5Ru6vdapqFVwxy1nXam4v2mXVVT+/pGEZ4aakrrTLQeuQoTRXR1snKl?=
 =?us-ascii?Q?sJLf6SKDDremZNPmBh5k0GQHDOGGR9jB6ju6/6HmF2CTiMtTy5sENEkaSCdk?=
 =?us-ascii?Q?HAmB+JAl1yqtZThc0n9AzoRrXczlKgqwjSi+TpYnQqoG+HgIDLQGq7Dpx0IC?=
 =?us-ascii?Q?RgZw1FP3g1d3aAdcQNWchnKrIDfhWE2sWahXzZEOgGjdEjBF8LHLR6TmbMWz?=
 =?us-ascii?Q?FNT+xogzni8VnVrEeeusWL7OEihKYJfxz78HhuRNJ5TF2r/LoXQSALJkc///?=
 =?us-ascii?Q?1xT2ZRGvH4XH31iA7jSVw+J2CmN/0l1/TuDvSNTJc3LudsAt+yChYmN7mV/P?=
 =?us-ascii?Q?1btmsNLCd1/po7gnoHR9oacsP6EDmrCajlLBdo/pWy/nfWpzhboHhpEJAyun?=
 =?us-ascii?Q?mlOb1jXsjk7GKoRk80Qs4pe9m/JQ8/1pAit3ajv1gxpZYvx2tVkyJUemgweb?=
 =?us-ascii?Q?hCPZyCskCBSI7zoERzij1QuLs+toYb+4jvgvhQdEFTYApFFD+6I6HW0ymJ6Y?=
 =?us-ascii?Q?NrJtMYdqpbUPqeg/s3RKDLawmBvOT+MdT7kE2OmH9rHtpYn2SSdeX8wxCWbD?=
 =?us-ascii?Q?M10f3SfU72GsDBfDvuXbCJ1q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a80edf1-0624-4c6d-43f0-08d9306fe978
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 02:39:06.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MrYE/Zkzwa11L/V3S/ePmvlATIVAkHUJlM6xtDNXD6vPGZA3xD59SIuw6cWqUTNAXANqJQvFdkfLiY2J8osjaCovXCOTlmScDWAg5djgUvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5436
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160014
X-Proofpoint-ORIG-GUID: DHm3zoBAPl6j6V009SwqLbjT0EwVU9SS
X-Proofpoint-GUID: DHm3zoBAPl6j6V009SwqLbjT0EwVU9SS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Baokun,

> Using list_move_tail() instead of list_del() + list_add_tail() in
> qla_target.c.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
