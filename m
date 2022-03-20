Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB31C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbiCTApl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiCTApl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93121241A0A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JMJLUt020789;
        Sun, 20 Mar 2022 00:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iFc1rSvboUpELY2grzZRQ7UwyCYSCbyv/4yl+HlMwmg=;
 b=p2+F/GwfOPMOzyaUnOfxnvhmGKwAiosqbkkRFINzhhHv6gaA+N+Co7bhtnQdwJ3BRC95
 uvxlGqPBTXDp+vLMj45YmkyizlRDP9dGipQy3X4tRY4kJWPZAdkuPkaj5uPdae2i5B6W
 4ss0DyJgnUxi3zyTaiBn/aZ+nOMIhr35nvvNtss3CGFbq5aWWqR5g8C2nvVoXLDAsUCi
 cWvFJioLwD5TnVn/OlP7WF44Fy5L3YkOBiX7B+LrS3rBT3XiPJdmEPNEHj14loZ1bZNr
 034Ph0SYE5HGaM3Bgt2Mz9CjWeEClzejxDiSCa56Qhm0Rp/5my16zxJpeieXKjJPY8Yc 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcgw8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffaf137063;
        Sun, 20 Mar 2022 00:44:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miIWebZk4NLlrFw6LGSLUSJ0ZpoKzfKLEj1FdFbRoo6FQ6I5lmh34In2quU5fKRFWoriDO6HkfNX/NcClMFUoTXRvfHVJpW9/CTp1obhlp60yj2U1ld0Xh607Z+59pvlDE5MPM287md20ge47oCmK5ZktIgYyR+UtJDjM77pbt9G8bLZoxWWZ21Zmv26Cz0DQ9CtpAA4zD2nQVU1DLbmmVHTuq2Yb7fLMb+FsHCUO5deF+kpC/05ddSG/1IzwaqpQwtdb4sFsuy9MrCjQkPQhDhjFoKYsbM+oodr/Rwdt6lHO/XGuOJ9usyPsnuzr+f7M9rof6fmxigOBSd24KaIuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFc1rSvboUpELY2grzZRQ7UwyCYSCbyv/4yl+HlMwmg=;
 b=Yr7s91spvCX+Vq1QFlj3NYvrvE6R/pezbACJyZWCFddk2iLQebmxDsS1542zI45GSN8uJmKFqj2ZxfxJ5IHnIUVwPVcxET8/A8G84nbBTrQQuscfNQAS70vPRovmtMQ2X48JMLI9RNl7YRf3fsHc8397k07gftjrLw9EXSRhjG4nUUelUbbAZnK/FWgGU+Z0jJSRIKSfWMHYndAT7hX8bsUz5SH/ckbYG2hoYwIrUiQ3I6vfAB4h8ZOELrJreZN3k235H974r0QcOh1uFhHxmJ/vx8IZFlRRa6aR+Cy+mFW39+KtqGs+QL6e889qfeUiF6i1URxCCDeQvFiittvDZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFc1rSvboUpELY2grzZRQ7UwyCYSCbyv/4yl+HlMwmg=;
 b=I3z4UgBDQknbuZ1q13Y2GuMAbVj4ss4IrRYPIuCzC6psAd+966AR549yuHmC0F0Ryb8sXxbbKydwKO7zbqo1fk6XuLnnXZnZEidM5UnaJh9CO6y33DrBd59e2AtIKK6TXfFRymz5xVELyZiItJyfx4PaxHhxZJrCMRdGgh3RBDk=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:11 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH V2 0/12] misc iscsi patches
Date:   Sat, 19 Mar 2022 19:43:50 -0500
Message-Id: <20220320004402.6707-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3755a1f0-7d9b-4496-74b7-08da0a0abfb2
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992FD35B7B411A3C47AAA50F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7gRzGK3s5Q1SuONQjpVkjSjfaoWLaTn4BGHC+A/JNpn7kw3vc+snpO75W5WISH/XrrdNgd0FYItH1vBGi6iG5be30ucNEVl8EyNn59NSDKHKITSJm2iGEWA3P4bpzXSrrnp1Nse0n4lSUvu0+JJxu0Y/t0SxMYozD6pceB9AuouFJT0jzRA8qjWBiWzQ3+uiH2r4o8i9FwVS66MbWl0DYVhALL5EpaNkC8yql9MSuQpuRfgkzFtDeOzs0SkZV7Ii4e951eTsa5ofIBi4Ih1RPJYOlV1LiD4JXLiPGGYuZ7gN4kGNN/SHOfBLxCSdwojChxkPvP2lQvE0MFPctK023w6ldStXleVkPuEglSmo8I4B/oMYoBtzdNKsxJPKK5SX17m2cl+y5mWXr9gVXD/WD8fenMFqXSmRGVi1YylqNYRmOEJ5+ndx+PhkfaKp+tndswMMWZkDqOyhrn5qGb4FLg8xA4l/4Y/qTQxRvkw0vLuQET9AMp4J2n+8DCG4tb6kkJxXvU3jWfsResNvE/u9vEV4SNGj6smudxVQCQ6B+Qh6JLLzts3ow4p3oAd/Quf4OxW6CMkd9YafKyquDdtFpfsN6wSdxEyRiXJGs9ddh7t40J55QN3p3MqE7n/VG/Bh9AstoKKrBpe8zPrOhcfFeYuS8E9O4429IHbXQ7gYco+/LENBBsunJ8kh8+tbItXB7ESAbtSkHmYmOFT/J+V5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(36756003)(4744005)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0spzHCFqhpV4pBIgzIttKx+fMvYZ4BJ70fjoevuOCWRGNuBzbiNe7KEPKboz?=
 =?us-ascii?Q?JX/RtYnZQ2yc7kgVrVKdHKRJvrcq399jT7bx9f9X9YUk6W+U5iTvx6k3Gu79?=
 =?us-ascii?Q?ISDRfpbC+WdAW6GsvXfTA+g6Q3iK0OJOBqU0bVW5C8mzFs0OhBj9n2imfyJ1?=
 =?us-ascii?Q?nNt8g0P8XQLTHQ7IEgZDlPF6w9uON8DKPYxgTFn8+3Ad4zW04L2m8idp14/I?=
 =?us-ascii?Q?YVZLArY1jC3KCysz9D4jEUTq1fDRx4IowuLudWpOYL5qbrd/O3qv1tQQZSTE?=
 =?us-ascii?Q?vK1Rr/JEFOSYR1XgD9cwR2IAF1t65bxgME15gOf2kHuqPJBy+hFS2actUE7N?=
 =?us-ascii?Q?JLJYHHFw4jRu/zpvY/KStdDyeG11+IljgRgE9Iu/lTu3u7LqyVqyGN/WXt3X?=
 =?us-ascii?Q?O/hY0+6WkNEG7eE0rwtH9lzwdogZ+VnspfhVQgKe4r4jrRKEc1pz2mCa3gso?=
 =?us-ascii?Q?YNXK7cLLcpireue5mvPISirBClQFpcnHKhO/5UaMuJEFJB2zu+bVqJ2YhnF9?=
 =?us-ascii?Q?ySu2NiYt2ZdFPgqajjykvxKh2Vhz7GKld1DUU2umjfRBq4vJ3ukWEni7zbeN?=
 =?us-ascii?Q?5SY2gndYypCM8p2DwfE87+Cvqt+95x6u7+IEflObHlhUn5rCOG4+moO67bVa?=
 =?us-ascii?Q?UsLl08FOdgesyyP4zWGaGQUruAxFdWEJapXEJoqSnvPOH5+wVk6RWjLcr8tP?=
 =?us-ascii?Q?8MJ6Fkur3KHZOnoCHNkRLMfMJT6vayQbHk/lgNBfGbMP02xuErUIIXS6XWoS?=
 =?us-ascii?Q?3h1heNSV6r5aClxfMrdGrwhKghmFGN3+MeoLyR73E6a0vJVcX3gLCDSsD35K?=
 =?us-ascii?Q?HHND0gcu30qnhcmoyJcVP8R2NXITS5UD1QWcBncYpZanxilAXGvneQkBpCkR?=
 =?us-ascii?Q?jFfXiIvSBVsFM7Jal+dxPLGGLxweSJ+bWxowJlebBs7xWz5tKr5+UUCxJbuJ?=
 =?us-ascii?Q?P+IbjcS86K8JznNUDt7B16i1yrto98tUuiYGvlXcWKGTHvWJXYHmU786c+jT?=
 =?us-ascii?Q?Fncnil1/xQqrQioZQLdyv/NZjPu3wQ7hN83i6JEJasPUs98iu7wRkbvhzdqX?=
 =?us-ascii?Q?05cjf8dMgJMQchT6TgtvGRGzUEdM9UBYv3vxlTDJncKH7cOVBRZzPS8ijsnp?=
 =?us-ascii?Q?rTHlU0/j7MmZAdzbbudxwQpBy+IE6ThnMseabG4I7iAs++LKmSgUp38gyuc0?=
 =?us-ascii?Q?iJtxhTHU5TJqJAKGewrYXDZqspjA1RQXvUFr9DajsrHrnwhI7szYIE+YXI9M?=
 =?us-ascii?Q?fy5aWDebMlVdtO/GOYQXtCUnuImSZAmjDxpPJP+nB3UHhrN+OBk/hcB8+L0l?=
 =?us-ascii?Q?zfzYWLypre3D5ewcez5csCUg2o86XFGhPHERXjmRTJq0XsmBtQhiMtFTGn/O?=
 =?us-ascii?Q?zqimV5q6tCVsxWCAfVgoLZnDpIFiAFcm8wos+pQlYzV9CRmpcWpudXb0t9eU?=
 =?us-ascii?Q?ZjhGv7nrvwrTAlTqmVknVkqufNh43aiu83gQLnlvEDP6EopvPcU1Sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3755a1f0-7d9b-4496-74b7-08da0a0abfb2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:11.2815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dBLM9nR1ydflirMT0OzK8KqqSAowV5rK/orQQ9W8EoL5WtkWjSGGlhqTxheGxOGbkLaShQEcqtA6BUe3dVEPH5LchDo9qABss/cTFiJj/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: UKg_HyYwON3RWYgxehqTaELqqQB3FBmE
X-Proofpoint-ORIG-GUID: UKg_HyYwON3RWYgxehqTaELqqQB3FBmE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.18 branches which
contain Bart's SCp.ptr changes and some other iscsi patches.

They are mix of minor fixes and perf improvements and cleanups.

V2:
- Fix up git commit messages.
- Rename modparam that controls if we create sessions using the
network softirq or iscsi_q.
- Drop zero copy patch but leave the part that set the sendpage
version of MSG_MORE. It turns out we were never using zero copy for the
header and it was the MSG_SENDPAGE_NOTLAST that was helping.


