Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D42CCA486
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiFHGBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242771AbiFHFyF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:54:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCF01ECD4E;
        Tue,  7 Jun 2022 20:49:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257N6YQw010426;
        Wed, 8 Jun 2022 01:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9AvBGx53khqO51mCR/Ljk1n3NJK/SuuRECiD/OJSgLg=;
 b=l98Irg2PeTIhdApir12ZHK2WU16T4MTS4eBge+MEQTUgTD0i2BKGfCe2D+AYUnffjmrX
 zpZ6P53clRQkJPrSz6qhqNcn3EY+4lGS9wi5nyJS0Sz5G+UxbH9PmYbcwVNQMi8VG9qo
 4C6fj4pXLb06soyX0COMawGzbgy9w48Gkta4g08XSKhR3AcSMNC2zC+r4ndnpfIhKhNz
 dnJ+QiSzgOx0oiPgxEg/HcjRaDLZvhjNj9k2EVlKY3yEwfHMmKQKAcI5xSP2tDcCAAJ7
 N2Z+4A8MlcLFU+0FVl8gEj7d1liMvl4a8oWsKR+YAiPihB4vOAd+woVlfO01oRO2J8Pq 6Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsfav7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 01:55:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2581ee8R031561;
        Wed, 8 Jun 2022 01:55:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33pgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 01:55:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKgfiK8gXXecC/LmNPbefCmCpwZ7/sHVjYWnpGMnFM7gf+pP1QmoG8I6M0CYOCwJ2Mwq3NCo9m4aUcF8n1KGxXI8DjwnyhTfK/+WCzOuhKNxnsBSbtobOSFQeDt7Eubg0zjkcco2mwvInrgGsrLreZbNKRd0oiS9+kohTkew79/fWABUhOHD001W95X87e9RtwjNq1yAb9wjEq1Pa8oGnsUzJNYsfj58imolo11JOOo0Jo0KFURg6w8qaQLjYG5U0ezubGCjRYtaJ2V9YgIouFaWpJW4QAeuOHUG68vJO0lB1ATmOa7nBlv0y+HU0XmlLeXtfZNBF196bzD8mte7YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AvBGx53khqO51mCR/Ljk1n3NJK/SuuRECiD/OJSgLg=;
 b=Oo5BeThaoWs0VDr058yMKAM+e0xMjdF+nF+pRcRAvlEgq73flGZiblZ22bpjSHFBblJODKqT4ne3qyIMUG7TGv6duNSQaCkaR+EK9f5Dn6mRK0J/y8WISdtKS562rGFtUonB9QP09q19VXMhJHQ3Eo+glJRO4RpHucrAp48fQoEnYlINcyo5P+Psjh33wXCJaS1xS1Wpo9Mwn74ElyD2HUaBuAK7kyl6fIy/7vBAisP9JggR1lNq/zmBeRTNTOGOEaBcTRmZKkRE0DMQYuCEDw3ZwXrifT7khQZ1PsZmx9VXskyESi/DSQT02hGfQFs4E4/IzkDE/JAeF98ZOpt2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AvBGx53khqO51mCR/Ljk1n3NJK/SuuRECiD/OJSgLg=;
 b=d3L2UsR3ZyZuOrMcfqpJBqU5IVaLFCRr9fBW7+g2XWTFp/S5QZ4fosRFACWN5BShs3vqkgbd6i48K/XvdYOy90Go41/5aIkVoM3tTpTyFuk1t4puyx5a4wtfHeBcLWencIyGvI0cNgglyZac4QtLUTuXONjrZy1PpODE2WL3R8c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB5943.namprd10.prod.outlook.com (2603:10b6:8:ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.19; Wed, 8 Jun 2022 01:55:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 01:55:51 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v5 0/3] target: iscsi: control authentication per ACL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qvzzzoo.fsf@ca-mkp.ca.oracle.com>
References: <20220523095905.26070-1-d.bogdanov@yadro.com>
Date:   Tue, 07 Jun 2022 21:55:49 -0400
In-Reply-To: <20220523095905.26070-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Mon, 23 May 2022 12:59:02 +0300")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:5:bc::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5899c5-910a-41db-b769-08da48f2043a
X-MS-TrafficTypeDiagnostic: DM4PR10MB5943:EE_
X-Microsoft-Antispam-PRVS: <DM4PR10MB59438415886C922A064FDC198EA49@DM4PR10MB5943.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eti2DVHii/M93kjTuydbVFAABKsS+Ka9M7yX0AsHEh3IvCLRAjqNxss1HWXzG6H4qZFHcmDIwjibrn+rj8ui6fLQy78qyX77AjEudXEN8wuLNb5ejYsfjkCVUqQgQBDVjQJVVU7UY2vJNX43OWoNOu8DwKGCzOiOCnYn5fCzWoJnDTwEWo8GjSexahxwRfZpkKnx/ZGiWNMIuVjMuA/9oCZLQETvs8Lf62v+odyAHIrXd6P5oLCLJXKK+N1jccKYltjAttjqlXlmVRA6NuIZ1NdR2FPB+o5jYYxTC/Ffj6QeQlsftD9dG/+/TDx9DMCEwPg5ClfQggVdbhgKPqQbrpHUq3MkoBaUShbI+2SsB0Xdmkr79OIN3eDiaY6WiHqsJwLnLihGiX8UEKahWXP66yWSY+8BgClasKxprX7vzGkJT3f4cQSWIZs9iXSITkVfB+cvVBXEty9l1kWtjKR72Dh75Ro9+QKuo4w7GTH9rAbS8VjlWNkLT/Zfbmbqz4SEdgYqUX+eXCaQ9t9WXhLFwkf4Tz1flpsrUU/isShvfZms4R9Mi8YqnzwEpm/7Ss0dX3JSfD4ucX0BvFzxHJbHEVqHBp5vJSNjerK/+S5pNl/A0TY1AFS29/HoCC8/ceL1IVnGNlGH/IsgVWHk796+bFkfjFHVbQ80KJJAA8LVpjEGABMRFIgSzpHmnU8PYorRhq5+nSjJGcWGcA41hZHh9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(26005)(66476007)(4744005)(4326008)(5660300002)(66946007)(38100700002)(316002)(66556008)(8676002)(508600001)(186003)(36916002)(8936002)(2906002)(38350700002)(6916009)(6506007)(6486002)(52116002)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EtjunFdG3Z87jCwRloS0YgXvoNjTonGjEBchm4Ffg8KCHqtj5+iKXxVxBOEA?=
 =?us-ascii?Q?8JvxZpqIAP4ifibYokvbBGez+3om1OAinhYHiuUI5KxdYmwiyEGJlB++Ys25?=
 =?us-ascii?Q?NwEWs7Fp8YXrHODaaCg6XiYIimxkKD/9bpG6RWjweS7rvxdAXQyusICvdVZh?=
 =?us-ascii?Q?CL77E5FRfYLqibfDfklwOnhf8rOu3J0kZFtCSNdiFcz9z1CCd2VNymJ5H1RW?=
 =?us-ascii?Q?/q/pwQHY8pxIGRN3nO5zmDlmaw5ddFMEtGDYfX3/oiB7VKHrx1QodTEAluPT?=
 =?us-ascii?Q?i09/ys0PEFydU55790aWyvg3mP0PQ+lwwkuHCFU+AgVQ9Q3Xr0xpR4eGwHq2?=
 =?us-ascii?Q?RulnVaMuby0JnEZUBGP/Je21xRqODJabNoVWvPJZnm5s+ab0KC+JeQ7DZtNp?=
 =?us-ascii?Q?DuHGPuww7FevxDlO9S5EXRO7+ia/2udFfIfoQaQEkpixfxbjp3vmuU1n6Ufa?=
 =?us-ascii?Q?TsAOVMI3by3acqf+raVHlhbYZk8OvNWcDLTx87M8lGhES5kaF+BoiwQAJRB8?=
 =?us-ascii?Q?NS3Mf1m0FVTYm9PsBSGv/EbwWC6skUuYWTEVkAEynL49G1FiUameNbQXAgLy?=
 =?us-ascii?Q?sbEnpyeTpWJIKeo1K9Vr0KzNZpZrgFqFhSMxMyEdeIOyl3gMZ7qn2rZppwFy?=
 =?us-ascii?Q?IIwatQqQv7AtUIj4LfrBSwemg7AFL1frsnyFpwRwv/h8ze8uPgZJ79LzF3xb?=
 =?us-ascii?Q?tfw/Dxv0sM4zV/Hnn6vhHjTNPeeotXC7i9AedKWMaejUPxuI/zsooK0pVCCb?=
 =?us-ascii?Q?Q8z4OcPjumXhA+Tir0/S/NW9S8NoNtctGNq/RRNHajltWrlkOBfuqXD8gl/n?=
 =?us-ascii?Q?eg/XJz8dqJDS5iyMc4mHvTaBQToQtbC92EN/w6tuPmnrnG8GFVfA1+uiSWrB?=
 =?us-ascii?Q?wPvdxsOPYRiARsQNyCXEok+yHDInV5VFzPnc5ty2Ja+/RHx4ASn36gTPSeHX?=
 =?us-ascii?Q?6qoPLJ8fpSCsxDf+zS0F3nSMdhAAsupXDDZqenWi5zq5X1KJhjgmrve1MtO2?=
 =?us-ascii?Q?Zl4g0diehnWPdzgnOnrLGRLyhaDLr1RY8KMyQNtf3D0A4LDkoN/gxqaMVNJ+?=
 =?us-ascii?Q?WEmVuFP5TsloW/D9cNXLKpHKyoBFkG4q5s6bz+F2V+DaPAadayWQZ9FpHjUt?=
 =?us-ascii?Q?0DmVM+M47CI7azRZg0FoHHbsfI3D1GWbGgu2hHBQBuCU2ZjXLwQBtYK3FHkI?=
 =?us-ascii?Q?JkBYy/zFv1BkEdw9u1mnAHLbU9MAMaXF0FmkJTSKfRQTHDq8ELI94ybCn7Vu?=
 =?us-ascii?Q?k9gQcVY2/SCoNsczfdovzhPAWJpqYZ+v9bs9mfC6awrWUyF7KYJnqnxlDHwU?=
 =?us-ascii?Q?qWzr6u7+OvQbkXjksViSOHkNVvSNhcI2S5h98YWVkM83sEZG9ZEIoPEIH5tD?=
 =?us-ascii?Q?NO3Owb8kJxjHjrPT8P6W0UwoVvYiC8nwoHBGffuYYV4w5B6Zk8e6IUnZSQah?=
 =?us-ascii?Q?8OPBuiGEEpOgPP1XzR1O9gccxLru24g2zyP5/BFWMqxANEntp2uGRFgKH2pT?=
 =?us-ascii?Q?C/4Cn9KnkHHwBLFUqFncyMa4QzUOidFMjZwx0KAGXvzjwheV63VKjxQskHQ2?=
 =?us-ascii?Q?UlnU81iE/ivvk0W7apLAQdFWKf2cPmBpz6QT+RHF+21fXU3bF+TkNOKqvNDr?=
 =?us-ascii?Q?+FihjJMVJIiBJqTbbQhnRWv1AsEJ8yZWuGqTaVo9KmuumQugvKBMoCv9YvOR?=
 =?us-ascii?Q?4/UsSY0QnZTWciUiiSjM91U/NkAVKsm2CzMsD0u6Zx2xCY7sQVtvIzSJTug9?=
 =?us-ascii?Q?0f/GotStKTUNPTEii/o/8R2wFe78rSA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5899c5-910a-41db-b769-08da48f2043a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 01:55:51.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxOm9Gxo3+GTq9doMZWHodbrPxNmvXbcq6z8Mn7wiE9FXaAWhGtTPlH/1KSapNcFWmYGgH81s+wMLFlo6XKtJ7tvmpYseiW0ahd3VxchICU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5943
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_11:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=685 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080006
X-Proofpoint-ORIG-GUID: sk5ZG9BZlT-ANJDtAPh_zBKIrdiqxzn9
X-Proofpoint-GUID: sk5ZG9BZlT-ANJDtAPh_zBKIrdiqxzn9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> Add acls/{ACL}/attrib/authentication attribute that controls
> authentication for the particular ACL. By default, this attribute
> inherits a value of authentication attribute of the target port group
> to keep a backward compatibility.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
