Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D07DCCA47B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbiF1CeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244994AbiF1CbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75CD252A5;
        Mon, 27 Jun 2022 19:30:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S1ZGRl002135;
        Tue, 28 Jun 2022 02:30:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t71GOLLE5OgZVtaM7g8JZ1+PsIPH2yrKmaOGCpma4Y0=;
 b=Kb8dIqizbrJKkQiJcVEQr6NoJOSOIiYSJHHxgVe03H7HN5Ri6wqC9ugFBbB7kw6sNmEJ
 hDAshenDQ1OLpzHdckvqtKl8Samr4Wi/3u3Vs8SUH0JeYFpvPvqNfW/1tIsH8rh9xi4B
 Qm2RECJ5Dx9gG5zM4Gqu0XKA1ToPntowV35CZFjhCO00wovX62LsaiBD+FQXW+eJWFFn
 ODmzLDUTR/Hs9ZQG6HinMtH0igkpdmX8iw52Y0VUdJta7dgXJ24mY1EVIEPeWQnW+cGj
 sNrRiBwcsJ/F+56HdqVgA3m8x0fTMXF2zkbDzc/U8I/PKeGKclhjq4LiDdtjxj/fJ/Jt Ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52cspg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJs9018705;
        Tue, 28 Jun 2022 02:30:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWx+eerwkV6+0mbxtSXFLzGNPFDNkZqDCxuc9j+coCpxNO+KmEDaRoxI/QTXvx0LkB1QAIXELqlPPv+yMjC+0SEQjk6plWhCp6iIEqlMpPpHgHU8E+bz1+4rqnypQ3Fvp7aALrNNN6VpijC0QLTz1jepnoQlAVWjhs2yTDQSf2dn/gZB1BX30KxXzDmrA4SbSQy/kk9lX94pOTuvE+/LAzkpGaOapoi7gMQ5vp5IU5LnuokdCz8mUB5TU+OBg3Q94hRX1g/JhXA6JBLhbDMW4viWeS1v8OyY72P/PrLBmCru4qZ8Re3bSnY0MnVzwo22WNy0av7Fb7TBz2GHHa7oMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t71GOLLE5OgZVtaM7g8JZ1+PsIPH2yrKmaOGCpma4Y0=;
 b=YK7uahQKkezzN9SvPeGGwvEySi0WVakUJVSpPtSNsO0uAtQQr3XskFG22oNTEkxQs30dUCTmhFLDJe/Xv7cBDZWnvurHRB+Qh5EC3wgYFk/qlBQe5N26xF3aDz0+eBymX3A1C/utcKxDc5E57ZniR3turzwMeQGrVYes3IZjK7P8b7f5wmCMvyvDPOmAeByTLRfSaYrQ4eyvm3BnwhJVzidOpFrcdRSiCZul+WfhnPqUjFvmmcb9pV7XVqatDWMja5WGxhErjhUoP+m5uy/Sp5Oz573K0FgeXLXTDDcn4daqD1fHr8YNzXZHyOn0y5ca8qw9DVAkeYev1S+uRB8XsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t71GOLLE5OgZVtaM7g8JZ1+PsIPH2yrKmaOGCpma4Y0=;
 b=hh/npYN5MF/92GzQ3ETXTAwwplimZcJl4vbozSNPqZ3wfubKN++Bfem+GzDTphdYQCHr2k8Obscpr77oViaP7BoLWMCyhqMmUX1SNd459DOADXcLAeGPLLbMrdHjUC6m/k9lg9Rey/H4Ty3jMyNvs2k1JT6wQUeHhOCwLNj0Hmw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 0/5] target: UNMAP/WRITE_SAME features/cleanups for 5.20
Date:   Mon, 27 Jun 2022 21:29:48 -0500
Message-Id: <20220628022953.20948-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1461107b-763b-4ef8-2af8-08da58ae1936
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpVdbqXQb5+5IGBAtvPjh63KqKfA6kQ4bBqyYP2CRsd6fBdt5wuxM/Q+P5FPMyyQlt03+7WU8pQT6VK7W/EKo/hIObo99QVugou4CbKUmwrp/AWCfhfrl7GyozePlB5vZdhcmEo0aureSoU6Jd48cSV4AD89VcZ+OSIc3NWT3MgOombN9ZUnhQqHFuyV0Zi448i4pVaqh9O7ReIgwEHb9fLdCNjuwwiKimvsA1t2oBFhBvxS0LbzA1qTb2eA4gwaj7Odv875YVpsFgbuwYbcRVmP8NQlk5SxMGs3UatMezMA4dODNAsysMHUYkfVGcBIBe5OJmDJomnlR6NWc/72k1FmF5Q2hvAPyU4RrHnX7i8c3GouQdP7M8qJPsWBVRRUS3i8I62blOHTw/GyD0xKeuYVrS431jS6T4uKNCcGwGvOKy/ySK5fThrQwLuyzTlELwuKjSVVULq6l/VXl3LcMQ6XFwycuJ0xfXDXLfDpQvDBjndb10UOgCx0Oqdfe+9RtpS++rih0QIncQBK/i22kqthxA4Sk5gufnBMkNAy7wD+I8FTnhMUC8ZJSMnN0r2e+LE8BfpBeHEc7xL+BhSbzG0TFv5OjLyVYGqst/gZPeEorohJ7C5uBUIVjKLy2HZYd48H6HtD1yPecJESC/nzfbIhpUO22PpecJ4n5WivbwVpWwW1KQlpHuT2f1q1FK7cCJgDPR+3SAXJhA7r1Z7mDjrO5zhLnc4BrRUUvOYWpXKs9mys3By8LWqKC9sbs8wgokvSimPKBHZaWpy6+0bUK3UTTItmy5VoWZPsaqsT/i8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(2906002)(52116002)(6512007)(6486002)(2616005)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AyvwLKJw16riPeHUKSO1sNwNksAWmU+3NJtBi+o9bA3ipFmeuAIcLj6sI91R?=
 =?us-ascii?Q?A4jtCNFIC342mbDSz849RVyrBOr5/racW6uRxv/D4Mq7DHP3WGE2OOiGBDHp?=
 =?us-ascii?Q?VdALuQSzgfRIjhzN1PP28EdMRkp4aOubQweY8ZEZ073ohFjdZFbd5gLSQfkl?=
 =?us-ascii?Q?L3YQLKRfGitTuPah05LnsN06AHGH/f4+PrVclGaevuBdks1vQcbkPAhRB4uc?=
 =?us-ascii?Q?I/CP9OjKR+kovSYVDFGhR4PiE7niDLLwesaD7maQBRyMZ98rIEEDMol56jgQ?=
 =?us-ascii?Q?W87vChGuGqBqFizSkZ8IbzNdQfEsPBQvudpQGZ/0mcDWwb7tKr+JQtqVSLjB?=
 =?us-ascii?Q?WoYwCw/KYEFZnnL5cmOmRgOakET4l3rs8E5U7lJlXBBDzwVrZ5ZKybQrZTen?=
 =?us-ascii?Q?tTlTeaYIC78TSgJtthq+5je2ES6Aye/E5g6aBLpWX4OoECM+HQB0B8rc9DqF?=
 =?us-ascii?Q?FJtWuJt/qtrPIojprX7Gd3k4xu5gxjtKWseWlaLHdFbqQ757wjyNzjayNmA3?=
 =?us-ascii?Q?NkoXJr9lVDJ+J4wrKeTGdQXHugyj/TaDG0Szese/o4bU/+w/7S4qwGlVhxeJ?=
 =?us-ascii?Q?SUkndzjz29BK38jDSZsLZpyhzr+RwSPYehnHvB9ri+LLauxFFjsymf4u6LSF?=
 =?us-ascii?Q?f5aT2S9itjXg51jueE1d6selYT9fJOKrslKAug1qwCP/Ac2bMv+CJwlubj3y?=
 =?us-ascii?Q?bIyRRfptxLCDDbkG5TQfy4GEdtyeBK7RbymRNB6XoCf+uLFQt1WnL4ASTwWi?=
 =?us-ascii?Q?R6akyAGsgJdsEXYtb25JA4yFV5iouuCdx7Xya2+mxeRHnJ/OSLfxCjzy80dc?=
 =?us-ascii?Q?mVH4/L6bCs0DalaYRgAML8zrY1gOLV67H2AdwZOAiLLWcMuKMhBX9RawI4a7?=
 =?us-ascii?Q?zUrMCT91Bupv80HDaPj5XfVYES6cr6/RDKwDHIh5uIA9HpSyruEAUa3k9nDF?=
 =?us-ascii?Q?746aYlNAe18TXhrr5CxPksVClFVLd+EeMeTdSw6ISTExNNpHf7sS967hBwYv?=
 =?us-ascii?Q?zWafgWSZt7Pr2iuyZrJ1YC1v7JL+U8R+UzVpjfdniro+UoO7DO1wNJ6guC6i?=
 =?us-ascii?Q?42dQX87lhthSkKOVVuK76WTusjH5Oz72dsKzjMakw8Z9jW2ZMe5wkzi8qh4i?=
 =?us-ascii?Q?N50EZAX4MLuvo9vz7EJsQsqsrf36PvYB4HjWvBdpzHqwtgOJbE3pfzVFOI3V?=
 =?us-ascii?Q?rAc1l/+G0+vxSnMLCxOsJUxzGfHu7WJIC/I70lyO74nEK+VG+/1vIx8VvsvO?=
 =?us-ascii?Q?28WTN7686gWX59DqCZEoQngWXl04XGRKPcp6rJ3ZgfQ4Iy46M/wqNFLXqd5M?=
 =?us-ascii?Q?GXOtBz3g3+ieBuHx4NJ5l2ssX0yEwmlnykjItIZXmvFsxqmXHEZv5VRUf8B3?=
 =?us-ascii?Q?Z02sK/AxIa+3nPZXIODnYRIJdhtGlSR3l7T9EVonBu/AanyexpY026NR3GUX?=
 =?us-ascii?Q?Mnc6mkwvW+59opM9XGGN6a3JypSaMmFtCXATaezpqlfDgnRCfjs7RX2yy23D?=
 =?us-ascii?Q?qPjd3Z4Qj9+UvI3h29EpGX2fDwyJ+xt8hgfZ9WWxPNJXEmw34bSh0eKzo7iO?=
 =?us-ascii?Q?hEX16Jtr4A3YVkeLb1eyCap/zlQ6vmzrIoRQJ1JwZYu77Z7kzmN5EB+vy0/O?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1461107b-763b-4ef8-2af8-08da58ae1936
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:00.3598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4K48l8YEhFO/lZzg1gcHGKeBS7RBQdhS9oYfJbLaqalaUHAR95OcDsFZa6SQ6TDoxEKYlzMhJVCAxGOXCm35UZaYi36yWd1nbXCi4CQKlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=551 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: 8yGNGbtxE2KnnagNP-PbtyqJFaVqXivt
X-Proofpoint-GUID: 8yGNGbtxE2KnnagNP-PbtyqJFaVqXivt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and:

[PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash

They perform cleanup to target_core_file's WRITE_SAME handling and allow
users to configure UNMAP/WRITE_SAME after we have done the initial device
addition/configuration.


