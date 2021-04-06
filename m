Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F782C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F0D613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhDFEAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:00:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDFEAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:00:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136405W2102536;
        Tue, 6 Apr 2021 04:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hCbGXBE4M6qgG8UfehPKTVdlyam+lV5G1ay9t3E0SO0=;
 b=GoFn7dOqhGNQHvngXqmFuwVGNLYLs84zO6c4TxAWFdv1iS+PVusFs2foK0iw/4m9z/SR
 rJMfs1iS0gljJrmGlwDfyOfU99xZLTTm6s6T6Q4LmKCuzmFsEWh6A+/+VPWEvJNbTcWl
 EMmyP+9VPXPqLxMghrxrsiBNX7knrJryl9tnz8qbVGrRi37tax59SJj3VqNwdytnNnTc
 RZv1Xr8TXOfl72fAVTQnFshhbUgZ6I7LRxNJALpyBA0WDkYocUxmhhrFFgpvL+BMWIpm
 sBoMuB/hy2qUuB8GCOPTw+ySb9p7FSheGiB8sZie+W1alKqi9MJ6rmHzCikVHO/I4qek +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37q3bwkxyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:00:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1363p0lf090808;
        Tue, 6 Apr 2021 04:00:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 37q2ptpx2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anpNfcFuVixLKPCWdESox0Eb0IuZVtkyOmO1TfSvVZD/1B9QqTQCbuxZ6RHHd9OSm/zzqVSOo/nDs0ohk7hzlmprqHyI3S4hZkdl2O1YdmBFtzfPCNn9y06K9eJFIsavaQc22kzsO6U2ggBtQmcT8Tna0i/aQTFz/ZoXIGbCT1CX4KxoiDlzAjLFjn5lVnlnCN/7o3t7ZXx6FhFD48A5mPbIwZYKFMhOyGVogZBXRje4X6WPGTExuqcv1kFAUEVrbt9t/HMKgvMgyG0Dl9U+tNfyLz+ylBEG2C2MBS02LpldKw15/K9MsLCLYci00zWOWR+P12u9ge2GwwRu97p2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCbGXBE4M6qgG8UfehPKTVdlyam+lV5G1ay9t3E0SO0=;
 b=mMdz0JJNABZUQLj5nkPpKOmzyZc6jxU3+qP0pUgI+4Jap4yFje3LyvPmho83Z+n1zcjBQyRR/UPeH5+8WdVH1jDsR+elEI7MGgUMEzOc6mkzx+Qcv8susP8826oY6c3Rd7RGiLsynOKURtUTOKxuwbbYlRrLjIimGOsj4E+ISjUxzf8EO3LlsUitFX6LZ/SpCZ2bCktiTxcb7kXxChVAL4uB9yViTMJgo5LssTxqw22rrRMlAHGQB2F3rWejpRZ/chuBpX34LXviqCBRBRqYoVsLp6B9QASY7n9VjACBlP3dFN7Bp5RQ1fzT3iFawODGCxLVe88rtt8o9smLAJZxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCbGXBE4M6qgG8UfehPKTVdlyam+lV5G1ay9t3E0SO0=;
 b=rre9UlCw0c1ApeiLSVg+Bwi6PIzTwEHUeYHv5Nhpz0UPlitHAhZahBJ4oHJmVUBzsjMe/TXr4RSkLoXjGwvcO8Udi1D37/9wjbWzl7GeTA+EREvh10Q0PFe7ChgbVtdQsikFgfMEXjXCKqvukAP3TW2TQmNPBo/SmudbZKYC/44=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 04:00:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:00:37 +0000
To:     Joe Damato <ice799@gmail.com>
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: disable ASPM for mpt3sas / SAS3.0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eefocbf6.fsf@ca-mkp.ca.oracle.com>
References: <1616701889-77537-1-git-send-email-ice799@gmail.com>
Date:   Tue, 06 Apr 2021 00:00:34 -0400
In-Reply-To: <1616701889-77537-1-git-send-email-ice799@gmail.com> (Joe
        Damato's message of "Thu, 25 Mar 2021 12:51:29 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0201.namprd03.prod.outlook.com (2603:10b6:a03:2ef::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Tue, 6 Apr 2021 04:00:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf868934-915c-4d16-b471-08d8f8b088fd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46787786E8DBAFFFDB6C8F098E769@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhhYbyboDHoBO9JxjHXedjkI0+h6pZsK3s6YsAfcEghKtinHy/OoJupD5zd0zhReXYQ/63TN/t+dOkta4Wdyr3GETcAnYKdbforEH6pBdg9qghjylvG3A12eBdQPW8hVItGF/mT5DR6890YYZbmfr5bZfC2vtXATTS6qKKvMcJzSdcdxLzVX+usMaHoRi3Kz9e5+EIK9BUo7YndiAXCmP8PTU0iMixd7EwkURIUgU92Lp1z3ymNfBb1+3thn17o/4FWsNo1sGT0Ug4Ct8cPAu6BptdDs4rIaUFTM8C3ui7m2I+txU1mi1z8b97ssq6yOX+P2IkGYmzlMX9ljxWE68YBdHRcU8y7xlt/JVFdp7znzLjTuQPYNtf8wCWkqysAKmFCi47KAYIrsKBGmMm5rOnUId8OR6F7MF62GwMVkkY3hVoI/BCjZrCnWVVJN+y03gfYT6LFKIK0B0cmKrqKpJ1zgpOXaDEd6rd+K6WIWIbpTwyNKBx6JwxRU2vwvCiuuh+ZTm37PZ7YIbhm7Gg312WkbIk9DdkL5lzAwu21tkPSdue/p4BRgqVlGZshggrg3Xw/l4Ryr2k31sbG62If2gMmY0WXLvaFl4xyPoh6rAWlWg5Xt9VltNQzOjst54xzQRcNpdh7mN5DiKdz7JzGz3QLS7L+Z9WfbjOBx609wJKZ+lrO7r7xZtSqQg3aQZi/ezrCvsAeqAfoSto5Dv0Yj98whQmfDzxbm/Y27cYXE1GA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(39860400002)(376002)(66476007)(66946007)(8936002)(38350700001)(4326008)(55016002)(66556008)(6916009)(5660300002)(8676002)(4744005)(86362001)(38100700001)(36916002)(478600001)(956004)(2906002)(26005)(186003)(52116002)(7696005)(83380400001)(16526019)(316002)(42413003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5JV4pqTlzkVk8hNax3mJA/Jplmtja+JPya0kZNrLQHirjFBCr9pQ3ngRWpXX?=
 =?us-ascii?Q?y6rVEUXSSCW/9zAxreZ6tX4Eaj8LrkMMi32jTNqW8pOM+ha/r7LR/ZZOcovn?=
 =?us-ascii?Q?kqhLU38e/9EJXJuerRdzvUAJFf8rEO482aqqy/pQlDz8LsD/r6bNGZvFJ2HM?=
 =?us-ascii?Q?/is5n52jt7QWF7/lelPUaU5bhEVnVhLyFnez3tu5tkrPjQv1ZOBInmT8I5wG?=
 =?us-ascii?Q?cuXRcWkOan+MNS41ixrMf9UpIalUrybMfuB8MCD8FCDitagszg80hcPnKvWK?=
 =?us-ascii?Q?sS4sU391i6UjII1B98oQR5dd8HFWhKDHY7/c4yrmjKuW3V7VYlKAexn2OzEI?=
 =?us-ascii?Q?BHyEKu2G/lPIadRgYpX8+wQu8Kk6BFgHHoUhrKQYR3+kdk4m6z8Qp14pxJ3b?=
 =?us-ascii?Q?yZ381gRlTF87byTFS0e8u74Yszg3J7pqAF+q12ozUS2BIa5yk+JrDEBV2c2A?=
 =?us-ascii?Q?Qvvw7nJw/w+lQgIf/XNeSjy9eOjgDLu9FqXgyFiVX33l0KqQTLL5URo706T5?=
 =?us-ascii?Q?bMWiL17JSpVgYle2XOOCo88qm9f1K+6w5pcx2xdFaiXJRJSnKw05K6vcPfge?=
 =?us-ascii?Q?HmrVzfIiExC4iFyM5Ae7Yoq0MFqh9KO2og4wXF42Tno4DY9t2Ra00iw7kxbo?=
 =?us-ascii?Q?lRPRAJLzRkbvsn85nbPG1LTZFUSotCDsW68SXskWE4SnzMxjFM/pepWCn6Qf?=
 =?us-ascii?Q?1tLeh3WmheRIV5qKRMESzMBzTCA4bOjETzai3dKCUClWWZqjjss+Dilv0NPw?=
 =?us-ascii?Q?Tk+zt4bRD0saQJL7nM4enlii/jHxd+7fdXfJpl4yAd1su+lELgGF/VVClPlf?=
 =?us-ascii?Q?GBrPQOHuQpXGwM4p2AitCWc2NWeDFQVqp8JAxEHxboEbo6BsMR4bBlG/1bEq?=
 =?us-ascii?Q?0DRgHAP/VIblf2kkC2FhI34+PQNaGhTT3OOeziy/qDRXnlp9W2FtfBZeOcUT?=
 =?us-ascii?Q?JRs7JnV3/HL541EY/LBBWqXsiTSqFaPKQvf6nVmoWoeR2fFvIS/qOSSf6z6X?=
 =?us-ascii?Q?CiKm9aK4M5/DVgkDoiVAeulKX4khWd44usUhvRjhLWVG96Oj/4HL4VvFET/7?=
 =?us-ascii?Q?pJGR+G4RqmLdkJsD++J/LA0HFgLAD+ytIFF5pg+gsZNMrVm7D+j33MsZhuYQ?=
 =?us-ascii?Q?ctoRmw6O4gXP+oGTKUe5YKHruZgM7+ynovThlDivRsxxre/tVlLP8cKpI2Y5?=
 =?us-ascii?Q?EvPIFUIzevTLXk5tMrIGPEmeNoREc9aOJTctBHtzQguS/F05ipOGgoomRebv?=
 =?us-ascii?Q?lIdpGgJRetpMIWCjITV+3nFBeo/RNcJ2hrYRid8nmm9a+79j/tarKZV2D81X?=
 =?us-ascii?Q?xOEKeyl1G4ttYtLxC14aOgz0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf868934-915c-4d16-b471-08d8f8b088fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:00:37.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bU4n851JJWXRZD6Oq0wa6MW+RQNBZ2zrG4jjJpQ1+JMYt/f2iRGqddk9COw+pWCeMloDEYPv7XwCoSceqfpTUR7KsG2FgQmcq3I4qOC8xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=784 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060022
X-Proofpoint-GUID: e3b-wdh85U-Q6rhnOt8lcf99ACBC2qiA
X-Proofpoint-ORIG-GUID: e3b-wdh85U-Q6rhnOt8lcf99ACBC2qiA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=982 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Joe,

> Noticed commit ffdadd68af5a ("scsi: mpt3sas: disable ASPM for MPI2
> controllers") disables ASPM for SAS-2.0 HBAs, but this change was not
> replicated for SAS-3.0 HBAs. This change replicates this behavior.

Do you have a system that exhibits problems with ASPM enabled?

-- 
Martin K. Petersen	Oracle Linux Engineering
