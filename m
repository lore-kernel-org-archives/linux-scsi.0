Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85671C6FA8E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBXRpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXRpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:45:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A48BDEE;
        Fri, 24 Feb 2023 09:45:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHhpBQ003263;
        Fri, 24 Feb 2023 17:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qTGVdL5K/c7aew4NJTZFS69J1zAkzGB+C869q7nuMa8=;
 b=CbcidK9pS4zz0SQSHGg5mpkT03M56HWR+lNpH+ZQkWtfkpbuwV3zlw0PnMTJKDkNQ5pN
 1RT2nc0kWlhoMAQ9546Gh+QPQI93tBFrZOHgfxMm4CipSSNNC+WubZtaW/BsYUdypY2H
 qbp0XCaVIM5V8rvQQjz/PCVMY3W49VWvCXeZqO7l92cu3tImtMldESQ+Z95pJMcC9KFq
 L9NYtj9WmeESKs2nn1jD42xXlGvNDPrdSuIYMXhB8YJDzLl+SDTpgnHnKtcjrI42z1BB
 TyUYxDDj0JrK0prtXj2Ob/mDccS5B98aJKBAESS4zQOElVjnMEwivHVQ69naSq4d/U6q dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqcntj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OGRkS3000678;
        Fri, 24 Feb 2023 17:45:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nxsb4ku0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLGuk1zHiTRL2lsm/3vX3W++5f1uKR79RBUtBxA3azm5qGBIRl5hwwlzL/OuvDfU9PUa1p1Bt5/KNtROPdckyhCc5ekhbZEpTcCainGRLvmkpQVC0sbhX9Ti5VkKj4eOSvkq9Ksk0Z/XNfPDc91AZrwa7kr+Jxn1DTQ231UxUUFUE0+8Q5AAKznVE9kamsb9fgDayu/4qnMDDd5U1yXiRNI9kpWN2j0UK1pP7aygbxDo5zL4gC/RPvbef86IZwwDMR7IP1n4DJk4u1lAmr26NAIs8gx3ufhJRygjh1HJujJUzG+pPJAgZ/LxFWvXBvryjfPLCKa3LKrBQoWIpVAkHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTGVdL5K/c7aew4NJTZFS69J1zAkzGB+C869q7nuMa8=;
 b=EU+pemYTGVwQ8MPY8rlnMKvFNXllUL63waRQZ3W2TXP+vg/9Vz4suv93Q2rWwHhOwbW7yPs/1IPGhCBs3SLWqO5+cqbXuDBiq9alI/zw3Bpj3S4tr4OoZSmocnx+EpsK8Er0IyjG9OF477U0LA+6tzpSnU66n6K8vN1XrQMagadmVpxkjdc4UKa3T3i05g/q09IqUUEIazgNhr2ADNCCEYL+cCgD6p+AYjfcMaDkz8aLutZbvjXWyASEQ510dWYbFXHQ6pcknlDpT46rov3KxOUjFAvKwCqIwyInDN4V0iGpid38MwAPLGSQnj+P8FdXm0Zw/ArKsPGexLz5scJ3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTGVdL5K/c7aew4NJTZFS69J1zAkzGB+C869q7nuMa8=;
 b=AQId9+dJ6QLknQ4CEIm5xYFNqP2kstxNIr11rBXNYxdglqqAc90K3zGBSWsLqV66IMRGZAdmK0hZWhmk8SHZYGbkfqHOgWmdqY9VNYIqp4WNJQExPVBJOfcJFIQj68mSQbkbm5HUUH+GuFgxju0pu0u83/cUo/4smio6Fsuy/78=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v4 03/18] scsi: Rename sd_pr_command
Date:   Fri, 24 Feb 2023 11:44:47 -0600
Message-Id: <20230224174502.321490-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:4:ad::44) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: f4105db5-56cc-4112-0e61-08db168edf7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFZkWf+n9cGnV4LYXZJ6WYVbEhsjX8sr3GGpbxzxg3ZsVF6CQh5ccEPRl0PEVkawf/TWYUTy8OE9ihpGbU4rPvPzM/8QA69b25rLMS/TU0IbISgn6pxkOvPQSQ+PDZDvrEkmdfYpNaGPYY6wlpXrW+h2ggQj2NRJQZAP9LR0jiyCCBFb8AasMZAXGMszeyIzDdgktEm4Ga1uqxFEfPPWakQaqCGgIzv75otOblyyTF63DcgT7IRtUsrdi+fY19szfkWG8QmgFvdgR5g1X1ga7IqvYDr9GumdKso9dfo1J6zeZYChruk6clGlWb+ETQ5fKiBMJRdDSUmthBWILJUe4eRhD9ZyjcIrwdAk6tnLjJk1KP/G976HQOdA1/PNyf3IJy2he6BPxTlO1P6c0mZLZhGbczUfQ66rwCzz+7iJCWSvHKLM/MzrQtWkUEJBLiouKS8INX7TTgbXJgH2LfDrGh0OKEYkLW1gmNd5QpRlNIsQggPVqXYJDXnab/NCrdnqwrhr/advBWA8ub2444oeBARdgFyZ/m+O6HY0ASB94ty2GEmCP6+sfRAJXICD0AGNyb0tq167YfC5iBupEhaEZ6z0FuZzCgPfC3MEkv6/KhFUP9LV+ET21LdMW2+RFy2+wQ+gEIYLC5kqsoriyLR0cUuMTpBpWLWhwdX/3rC7HPKkkvLXAB7wD1Oy8fa5fKv3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(54906003)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Rmkz0DgGUsxhUIHb/q2IvViDBUaKpzUmR2aS93aot5KYa5QHNT4tDjlpzeE?=
 =?us-ascii?Q?VP63Urp4K0zVO92Cb3d2Mh9LwUv6bD6TP0jeAGRmAR4NeL74YGtBuC6C47Jc?=
 =?us-ascii?Q?RUWDPEVmeOqC2M21WS2heqNNzL8lw1Mch9qDwyrp1gqwkbeOvh51kR6rA2mY?=
 =?us-ascii?Q?LvJujgZJFb6q+g84hnBV9sWyRZBJ6pD5LBNDYUaLsaJfPbB2+fQsAICQpaS4?=
 =?us-ascii?Q?I6D9ZuMI1hjq+N4aW57Ccg1w+ObmJO8ssKfu6hcziBQacRYjrt0I6zigoNIO?=
 =?us-ascii?Q?9Ij6xBJzVnqUxIEU4POiyRdtFOi/xHxH3cKk1zhGsGM2+KwuKjtsuJILfCQo?=
 =?us-ascii?Q?JIP4fIDE1EP9G15Tf6qIut94rsIkyBGgVIupWs2EwZ7d4TeAvvyj4HnuMWkL?=
 =?us-ascii?Q?/AHtQpA/Rr4HBq/q4nqU75sMcFKn7mj7YLsgz2613QTEIYK13g4EOje6Wd4c?=
 =?us-ascii?Q?a7StJDAzZV4liNsoRmLaqP9AvfcoKpMRfq7Ko6vgjH0z7VaYq6wsqgjNEbh8?=
 =?us-ascii?Q?USz79cfjHG6Ehh9f6exsUkgb/h+xrjWCQOm4E/liBEBRFpDKgZHkJSrNtu3Z?=
 =?us-ascii?Q?fiqHSYEL/fh533zsQFbme2O9K6UkWeQVb7fYo7ZgdMOoIoedfFBR7xtzp09R?=
 =?us-ascii?Q?S2LSI87XzrgwrQVqv9NYbVIHAPFtpKt0Bo2EsSBePz+wojWI95lthStVVftS?=
 =?us-ascii?Q?j1b7OmDxlAljUBjNLTjx6SzCkbgWk1/Q1U8gc3VDDsUtxiE/r/hdqKw7nDpj?=
 =?us-ascii?Q?WxSzA6w7sxEiZGUfRI+7mLBwNqnWFJ2ZTZzFD5GTPoSRFXIW72xiXl8InJDk?=
 =?us-ascii?Q?pQsPpxAHyWkb9Mp7Vgw91LQErSWWOGahhFGEBh71WTVnSp9t8wNEg5KQJy58?=
 =?us-ascii?Q?sJdSDYl5Ec3VeLLmtu6l1mlqjhU/tCebN63OQHwFWOxGU+CeUYnfsZ/tbu2g?=
 =?us-ascii?Q?zNZgGKgOlqM4LGExyR80vvvb11/znymiA3eD41oL+JuuyvG5W7z8dQJE1Smg?=
 =?us-ascii?Q?HDQHGHHDmbyhtuy2as9qn0KcpO39FjbnaS/edOrniNHe+zNM+lRTTHsF27pP?=
 =?us-ascii?Q?akP+U9KGzyyKuXy+2RiJpQkQwrtPT3G3W9EEY8VWg5KZZ/5UIh8YKTzZxPpU?=
 =?us-ascii?Q?TL/b25aX6EduGsMHNFL8/yxGfVoF06gJCPuXSSv/a9bKnn04ZFrT9gvvwcyY?=
 =?us-ascii?Q?BIB3ZvhfyE3XM2woNEia9suXMnxZUhst4Ttwn6s88oyxMwG+/3MYfvZ08r48?=
 =?us-ascii?Q?Q4M7aGU4IZQJ+WCkeSk/G+SGIKYcnGQ8ch2etELjYrC42FkBYIXDMg4Dub7B?=
 =?us-ascii?Q?4f2qj19dib0A1UNMHHt67znnHOUma2vpCDCQZf67TPhciowQcOVFiSTuUYfc?=
 =?us-ascii?Q?QjRfuuqi228JvjRT1nX+vIk84p8Q4l5FCKvXuseMHx2x6TEEye2UpN9yPoS+?=
 =?us-ascii?Q?hsZRQ7TVImLgVb3bx9P+b2r1Z35BacT2A0L2vnd+AHBqL22j3bcG7ks7FdJm?=
 =?us-ascii?Q?0ePS+PuXhx0WhNrqXZfSJd4uluY08XOQDozs4vK2oT7G/+KafRHFGblTOk7L?=
 =?us-ascii?Q?4BG/BmCAPEkiP0EHOM0y9KH/8PU12rMz/H5NW0Uu9IZk63VfjXMjBjReQgyw?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?g40c9ch+povLCNrmvyzIwCpqLYqk1WmzYNS4oVfOcjYbgCSZ37/JyEwQOPpa?=
 =?us-ascii?Q?oKNGIq80C7DZL9N2j/64I4LbUXf2CC8yZ2so70++qa8snbSxdY1mzqzubVQK?=
 =?us-ascii?Q?hOYEVz9B5TzA2r5JNC282f0MFuH0ZmyEmMviwAMUMn1xiudl3OhBMr+XdrEC?=
 =?us-ascii?Q?PGH+1Vd9wngtTfWKjpk2qpjn9JKrtu0ml38LvYzU+e5JxkVqLTYqUIOKmLFp?=
 =?us-ascii?Q?zXHDYNhKATSCc4//AbPBye2cBJPj9jeOr2CgsumNGNKulbS3hct+Vod26Y+3?=
 =?us-ascii?Q?HbWBy1/ZdTJjMQbmN5l6QA6mqp8iut65/paiCG21wry2ADrGnAhapRX9AnK/?=
 =?us-ascii?Q?Hrb4NC+H9613RtvjMLf5IanyHL2NQ/H9Rs1j+EqTTlzFFKtyM0GK6EHH5Amz?=
 =?us-ascii?Q?zp3Z892c+AnVDzwEIXbvidtN+f5WV/RqOEQEHRFp1yKkenpBRM+xsgKoD+M4?=
 =?us-ascii?Q?e0b1cKsE6niccGPTXZpix7s3nVHPcpiPFxD1iyPhXPCOzGXJ1aeOEzLHjgaa?=
 =?us-ascii?Q?mkfKTlxtlS4VGbZfjb10RSwpkiKQzGGrzMKy9SY7xpTI2OuVHA/QUhxgcBDn?=
 =?us-ascii?Q?tNAEh60KHQk/I7x09ZOxbUr4Pz998wiG/eonll4D5+ZaPIsIeHB0B70iX55q?=
 =?us-ascii?Q?iUzpH22SlpaerlhrIpBmyQ1W8pelKBUFW98LUbdaO6gNE2Q4jtMt6SybffSj?=
 =?us-ascii?Q?BtKLM+g1ZQC0b8eQnVbHA3penCHLGGBaMtD2wm+fzsKciUE0sv7s5iI+r7V6?=
 =?us-ascii?Q?dPZcxPxRgwIJlvXqPjtIxlsnSTWYGHjCthKdhSbPPSfobUuuu7LuolJPa+4Q?=
 =?us-ascii?Q?Xj+eXyYJyzs/YHg1DkVo8FytqW0YWMeyVzICQcZscegFvb5dGep+KANBc/mI?=
 =?us-ascii?Q?HaMJWSlyHm56Ua1dG5Y4MZCRGq+X+JF29p6VfUFdMYJWe3ol0NHMiy+4JjQr?=
 =?us-ascii?Q?9QqqcGetdqMNKDIdnavhuHvzeEPPxFussgmmVYD1M1lCpeXlWBfmd63V7/1O?=
 =?us-ascii?Q?3hi7bmMZ8L0RqclO0Dxh7l2i7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4105db5-56cc-4112-0e61-08db168edf7b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:09.5014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhVHLjizPpshIfTwv+AjazCgjmVh2A8KtqTbwvbB96w7PLXbzZEO0bpXvQcgv6b84uleGrk5f9VlFnVAm/LUlWHmPkZF0510cGvOMf6RWbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: GDke2XZ_n7qi13MLPRk7g-SoGrtj34nz
X-Proofpoint-ORIG-GUID: GDke2XZ_n7qi13MLPRk7g-SoGrtj34nz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sd_pr_command to sd_pr_out_command to match a
sd_pr_in_command helper added in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/sd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a38c71511bc9..79377173f6a3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1743,7 +1743,7 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_command(struct block_device *bdev, u8 sa,
+static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
@@ -1786,7 +1786,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
@@ -1796,24 +1796,24 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 			     sd_pr_type(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.25.1

