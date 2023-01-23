Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F463C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjAWWLf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbjAWWLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9DB392AA
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:13 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiJsW002830;
        Mon, 23 Jan 2023 22:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VhNoTpRawgQfpJtE2LYbhzHrE6egDC8SUEk8zgejKSg=;
 b=L4KI66iLwMaJ1XWMZ8xXWdue/K6OaAevvdp3glYcnAMapjdOAELmrCHszDgu957qk1eL
 bq0C8UByZ4jW0uBkmaGEPocX+CfuEEvftoMWA11suVLJ0T/U/y4LRZ9HhDQbehMwzvs1
 7trtPsqdRE6OaT3QZKWMP301rYOlC6atGNWsvZxrTmPRV+akYqK5XkPbuLVma3ansM1G
 g4gYYk91bI2C9clO+ODlQ/1HKpEDEjuEwRss7RmzQA6Ft7Sptf1DPQCzpz0OlMAz+C3p
 Y3Z7lE/hz5P/vYqajmBKenckNrj/k1Vd9fdnIZ841qqA/6GecTVywaz2IByaNnKPGb+0 hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fcc36j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLXifx040193;
        Mon, 23 Jan 2023 22:10:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g450sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOvaB2tOvajsl1Ka0mXUe7mtwX5Bf7fP6egD/BBEaKnJ2S81yxFr0qVx9wjKvOPoPUOgyJbhgx3u2x3oBTza2ClPS7o/LDXaYYBrjHj2O1O+Ayz8HEzCWPLMhiS+fvVJUO39pniYidLDhARBA5g2bh0Ge+TayYHPwBY8aBn+Ak4FNt97soJzNTixDVxVulZpv9ctixGqLiStJltylTZvG3xJG3Hv9bqZSwHuzffO+mWk7ig4EmorWqoSdCc0VPBJCQAzHYzMOp71UomSeKbJHsOLjznvlFAN7jTzHd+o9OfEWMD8tCDdJTG5dfjTKiqV9i7PQ4obd+S1qxecjm9eag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhNoTpRawgQfpJtE2LYbhzHrE6egDC8SUEk8zgejKSg=;
 b=VxBfPb3Pd9LkzJL06LrEkYN59jDb0ubFO3ufMmm5bD8BfK6l/ri//0JZpXiPsdsp0dumpMKpJdNHR4WlzJ/SzNjo6J/cXZOGrZB4XuL/7OKV821OelpFJUWu0ejPdfuXu9wIGH/cIJsCJUdy9ELdQX1g+93IbO1K9shxO4gKIGD7AkbLVkDBKkuXsOEOcJnvdVDq5VkmTngmcb2JKu4ac+0ZR1zib6t9xhzd+Pq2lJFRWVU88H59tz2ZfQgQ8hewq9tprknjwIl2NMCGANedQW4Frr6SFVVR1tpUTjyES0QDFOigVWy4DRH99NTWyzp8h/Mj3QIcsREh2DRaYiVYdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhNoTpRawgQfpJtE2LYbhzHrE6egDC8SUEk8zgejKSg=;
 b=imgWDGJnB6hXfRE8hSU7s4YOHNMv80sPUAoZcKiKznngkZLMQ1BNMM76YekS9qAza4LQasgoX3j+QHJ5sK6nsbSJ3wvpuf4XPr0gPDnmHJbi8ybLB09KeTMwK8dRHbaE9PymJvEGAjZE94TUuCs/g+zXH32u0VLKulEHqtvSTIM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v7 01/22] scsi: Allow scsi_execute users to control retries
Date:   Mon, 23 Jan 2023 16:10:24 -0600
Message-Id: <20230123221046.125483-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:610:54::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff65708-62c5-4bcd-bf3e-08dafd8eaf1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dk5/HZ2BlZ9lD8chDucX7fVK8bOd27/5DGnVNajd3ho1T+/bCipNa5h7NxoqfB9GpK2ZPp16MOpYK2qodp8rH84rWXVM4TuuEetwajddKkxzZ0x6tAVCeF7SrKbkIUHsx4ZGz6FrTUHC+dKVg1ixomcK9YbWN+/v1nWFZWCwiH7+TSSYtb0HTYX1aGj1c2AYPpjAoOS/pXy5DFWDhEnBMtYOaDAWFEgha1K8iYZ2VmUIvZNufj7PA8f5EpzoYmG1eu2YHAhuzwJ6sRXVPPF9BEo5h1QsMCm3m6VL0B+FsDfV+Y66efWQP+WfM+esqn/u7JEL4v1PjVNjdcTS3iyZJylqDfTbEQfA2NPboc/4l8V6VBKJxdteQb53V4nAzIITMRgIHZSx2kdaylAaXjzYBtomaSzgVLHqd08mze2YEcod7vp5vYoZI/ZNT67PFRqUfiWO88e0ZD+aOSVTP7pK3QvmfU6W7fsO8oNGGZyQilY/sr3IAb9IyvaNbddraE9OoCxXNrna8fk5BdVCdBpYomr/HFH68wUxw6Kg2rz2oPHnRncJlnTuprjjJ5+HxRMXmT0QNZml97+Fv8e6ARsz5Ubq+5lu5iazPlr3BTD980tUCz1ivC2jLnUX0NNBQ5TmpDxAlwz+ZmhgVmtdvAZEAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?axqU3vyHJtZSnwd9SsGXtxkZEjWwclp6REMNEaJpue1YikJEjGCKobbWbEzz?=
 =?us-ascii?Q?urqm41b7ML+kmZRTkvKT2A9r6yU/KpELn2roTaEP94IrMOrbpQr256R0lm+x?=
 =?us-ascii?Q?Md0ElvQ+frJosAeK0Fd6+p3474jUImBQVK5R8HqYKrqqmHG7yotI88x00WAI?=
 =?us-ascii?Q?CrnKVC5Rei6hePKgh1GqfaYP0QbCfjCvvWYisXIRnxU1ZUfZ/UQoECfvGrZW?=
 =?us-ascii?Q?yi57hiEWHW2v65EU600hN4lgd/OOdI6W0ttHKq1bxlvX/EGg6YpVhLErpzJd?=
 =?us-ascii?Q?2Jbj4u7gwsdVSXiStfN3wiY0Hrc508V8xU5rcbIieJxhTQxz6O5aWgTsaYhL?=
 =?us-ascii?Q?hdwAGOhkNoks5mzsgtnKxt/24NKQUxz9AkID0gztfBQjq3RPG9tBiQSyKZjS?=
 =?us-ascii?Q?/ozkMrvUSoe3hiC+4AsdKWwoW6glOXXHwhvNYD2jdni2HuI4sFS0z0BLm1+L?=
 =?us-ascii?Q?Uo2gu0wshaGnirKFF9If2Rc2McIK6lWKfBL0cYOcpUbwP2KP+o5QuqLOnmCd?=
 =?us-ascii?Q?nPMyolg+BJqSbaydKckbixMtMEVOPo65JklIkAgyoSyTFEGAANfxbtZS9UCe?=
 =?us-ascii?Q?RDy7Dlz6M6B5ZntgYJN2KhE8ERPzVpiaIoQtCRnHZQLxPD+G/uqhZ1Ayc9rL?=
 =?us-ascii?Q?pO75W5Cl0A2Yt//+/ifYWQmOCum+RJPqWaFoNvU1VMx7wwcbIT5dxIJTwJK5?=
 =?us-ascii?Q?MaYCivhSL9Q+tEhjXB2qe0HT8GKP/dE4npVI68VNPaYHtOSwzkMXi6qra3UM?=
 =?us-ascii?Q?+PzOip13+pwOD8g1sQlu1tBVKVn1jJ8CWcJyW/vXbO6JaOy4E5fJ1ZY3bYGr?=
 =?us-ascii?Q?8acMTywGYTtPPAtN3hpbvjTiOyNPUmPJKFX/ytpIEZkxGznA2Bc+PmKUhRz7?=
 =?us-ascii?Q?7FyR2H0Xl/AGLWKa6sklDBMT4N5zLAyStL5iC9zILTpKoxkj4cNEsUZgsFYn?=
 =?us-ascii?Q?oCFDvtApbzz/wiyHJq3g0EIhBj/bTU3+NZycqmgqI0WTdlrPjqPImZ6PtwYx?=
 =?us-ascii?Q?ncgLPH89AMVnD/SNzMOVObXv+w2waTNZmHjGgo2dGAN3T7SYPTJMatuwXPW0?=
 =?us-ascii?Q?zInhhtJJa3lnoQs6TnW9+D8KQo0aprCsh1G73ZvZGpwAnzfc2TDCCsXrZx9k?=
 =?us-ascii?Q?uKesYliNg3r4YJrjTZPk8dd7CLbI9biLfg1Je4yTQCo4ya06duoaBp744Xs/?=
 =?us-ascii?Q?O3ERXdLHoIYxlvdI7xzGRrKC6LU2n9ZeIif6Bex80PbI0UP/hS5hesU6sg+Z?=
 =?us-ascii?Q?nMzg/tP9vKdDhbm4HrMbiPAK4+v3yR2ceFCRTKnq031cKazPTijzZwE3XOQv?=
 =?us-ascii?Q?X2W09kfaLRyZfKMKFGI4m7/ZCRQ54FXCuA+k0EuSBSzfcQ2BGCY+pXP+hl8X?=
 =?us-ascii?Q?Zc4MJAbIqJQfpvWXtB9KjJQkKDwPOMgkg2oO3Up+uAxw8cAweGDJDVLk+Eld?=
 =?us-ascii?Q?cL4NDwGtBmefPd1Q7D1ApKbP0mGQ2RDV1NekANmRkeksElM0HIM2VZcYxzP6?=
 =?us-ascii?Q?zxRoueLLx8OLXNdXN8Xhr5lcPCM9mQuMnUg9zODn+1VEbHMWqskE3PKIu6Ci?=
 =?us-ascii?Q?Tmrq49gxeHbp4bZpPxMccgEV3Vsrob/EayYHNZ5Tymr3t73Bok36Q9nJhcXv?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MMDLjNvET+ZEhlcDe1Cu8tTJcWhCSE31+XhHX+oUxJaLqJvHqdvAguHpr7g5yf3WPOHHWRWraawJsnVaDBVgc04+yki31I9qsBKf2a91L6RX3UnVeNOTqa6XAHI1OisCRvyZKhWXyo+lUULvEL+jizGZJg90Iq3Q9UYXW7BsOpnrZGacqEg3eWygkYQDw8GRbfQKPbyPFaswZy63lkrLyJJM3d0STEM+U+vyBTx/T45Mvs9DQ+cifu12XrP3FUUMsugSuo9Q5XQ+2DPLUFT2uEPw3ZDD9AIZ/jqP8AcoVIGpp8tGzECWWvQOQ+1n2C7T56h2q4qnu9I9zhyhEOmWdJBxqqx7krBsBUTipi4x573pEffW92s3QrUskw1Cct8rH+B1NdKtBPeBIUYEZ8UcKzgr5Lt/eZH3INH8tconUlInOyM0zFK1tLQ4z7GRjf+SNJVNSdK1XYHYD5Jf6pqiT3sDDYLiO4JOkAZS3fkklGHhtGFDACth8Afpno0FXv7Weuyzo81IhFO7yx27sgUBN6YuChxALeW8EvbjfN9onVEkLxm5W8JTwcdAUk8BDKcdgKHBFGSRZSVCQYCyRXuZAB1+kOGjyBqiQXcrrPUd36pePnFqMGUt+1My7RGMAQ0CMP1oG1Kzk1Un2wTk+ZwGmXtk96U9yv3wrkxFR0QpYoitDWbYi7Gt77m0jjBfJAZiMbtRX8GLkoc309ZdgOGOIB2D/vfS9RdR6Q2XhHHsXf7fI6DC/lcCkQDk9/Cu0dBAe6vH75joo9Td2RVgt5iq1/pk8vEqQ0FwlQ9eBZWyIp9PSfXcJQTsIdr2/r3MGlZIGxyIwgOsKgMhBBRE7SxY4F8QDYXHdjWcK/w4MgwHg2AgLRvbDTbvU344Tlxwf1oB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff65708-62c5-4bcd-bf3e-08dafd8eaf1b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:49.4798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+ipdi/z7vklcML/VqifyCKei6BRk5uiBdgzzuHkjxUMM14zH0qMLst2hNdqlZYqtuGK5aIBhgUp1wEsTX0MdFG2+RV0FOzKXCLRy9pkfG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: vzw7-HWD6_AIAPBNT0GqrDF1iX8zjIvK
X-Proofpoint-ORIG-GUID: vzw7-HWD6_AIAPBNT0GqrDF1iX8zjIvK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches, make over Martin's 6.3 scsi-staging branch
because they require the scsi_execute_cmd changes. These patches allow
scsi_execute_cmd users to control exactly which errors are retried,
so we can reduce the sense/sshd handling they have to do and have it
one place.

The patches allow scsi_execute_cmd users to pass in an array of failures
which they want retried/failed and also specify how many times they want
them retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute_cmd users. We just have the special cases
where we want to retry with a difference size command or sleep between
retries.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args


