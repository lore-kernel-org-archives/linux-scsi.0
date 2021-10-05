Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48193C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218B2611C5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhJEE3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:29:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55836 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229694AbhJEE3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:29:32 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1953WpjI023914;
        Tue, 5 Oct 2021 04:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NEEn4EtYk/D1rZAocGuoKBzdSzjdBoBC6HaeBX2GGb4=;
 b=ZQMND6cMP2qSHWDsHNudi2Z3QLRxBMZy7aRsj5TJcaWOxih/3er8tPiZyzymXd7ZdrwX
 9LP07AN23jeKjhWeTVIa0gvSBBgEi5iKTNAN7E1XQDLUxfsxYroE+q7gp4qGrOfQF1kz
 hf+Ths24SrKVmFn1G5Mv6JmT9T7KdLrZKfBjJc5XN587lXCvPgYEj2DzSrbKsguMx9w6
 rEbfJiqxrTL4szunkNsG3TPfi5oHL+Ih7RY+HK1lyo0WK61RO0bLLWQDr9LxHc3+BxmH
 Mu6/3/pX5V0UndDxEzK89qvzZeCuHD9hJQkWKfB/SvExFC1RJzV49VpFq+kuusDbDDEu sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43gmaeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:27:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954AdTP070040;
        Tue, 5 Oct 2021 04:27:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3030.oracle.com with ESMTP id 3bf0s5vd7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:27:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EX9arEvEGH6kEh4Wu45BuduCQeDyTZvM6o+Opf6TtWtevIqb1XgPeWUqGoBlwtyo0c+Vi6DlbepMm2qp1lnjy545uWhLdFnYLSelpWCvPNhC/A9TzA1j787cZ9I+25KWwsVZ/aNTwlCDb4nSvVb/gQkO2o2g8i6f57+FkFCirz6/BKl2ho2WM0qeWyER1+yT1asXbdUBkNHQzuxguUVGdKqBOCGwvcvtCmwamFWgRO6cf+Tw1H0LiQvDdIXycnFUiimFLd2aMF2TLln0mVwpphCN/b7qmY13af+y3XGxtxfoaRuUXcKHs8KVP1MdhKQ9s6UfJkyRJKapLV7wUIyYZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEEn4EtYk/D1rZAocGuoKBzdSzjdBoBC6HaeBX2GGb4=;
 b=lkuG02COiYDUcolrMz40kBR9Fk9TDU+cme+mAoqbwrz65vRERL4ksIfPxDmU3Jwibo6jslxlNil+xb5cuUKfPwjnpjsjL8mMe1wIsYgW1GMzpQC/0XC4BJIf7d0hlQr5f2L2HnyIzr+hnwHf9Fdow8/HvmmSLW74vDX7YekgZidDQl1BY/i0z+g2E+luYeubBfIKqoLvSdLZG739rgwYQCIaTXpQ29YQN1kUNff4uhgaxam/ziVNvXRzTTGL/ZPHeu/IosFhplcJrqNxEFVLtP3HXbZAgLamwPovSmBRXIRNYO9RLx2BK+0o6cEraqG7elK3IC6RmtyRPZYP4QlSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEEn4EtYk/D1rZAocGuoKBzdSzjdBoBC6HaeBX2GGb4=;
 b=jVKbE7pgsWpwLUCVDxP4zHRVCg3jef2Vms+LCsX7v2ZDOcJy7IfywhBnAUT+dC8yskFPEu6Gr0nQyIyLIW/d5eQ4SAcn8aTvp3gAh5jM4A9E1F/+OYTwgN25NF/WTI+94IdFZhpmyWek+PGOPBMsgFngcuYNHB2R8U2EdmUtIog=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO6PR10MB5460.namprd10.prod.outlook.com (2603:10b6:5:35e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 04:27:36 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:27:35 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, steve.hagan@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH 2/7] miscdevice: adding support for MPI3MR_MINOR(243)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7dw6qsx.fsf@ca-mkp.ca.oracle.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
        <20210921184600.64427-3-kashyap.desai@broadcom.com>
Date:   Tue, 05 Oct 2021 00:27:32 -0400
In-Reply-To: <20210921184600.64427-3-kashyap.desai@broadcom.com> (Kashyap
        Desai's message of "Wed, 22 Sep 2021 00:15:55 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::14) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by BY3PR05CA0039.namprd05.prod.outlook.com (2603:10b6:a03:39b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.15 via Frontend Transport; Tue, 5 Oct 2021 04:27:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e3579b-4355-44de-ccba-08d987b874e5
X-MS-TrafficTypeDiagnostic: CO6PR10MB5460:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5460DA759B865A743893BB748EAF9@CO6PR10MB5460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNl38/0OF0wRTCPuKkIN/Cn2LfkurUc8kgU7tf+uJetE9pGdmpXib/i5Jf2qSF2p7UXZ9RizQVl06dZGHwiuDe5RxuA4IJpQ/WcHoxzrrWGu+YDQ/ExabrQ3O43Dd1Gu6gHs+9awHTRbzCuRm5g6dZZQk2N1aUQJPRb3Wu8GfLvdrpLXQXHOyscrAZCWkAiq51+vfSlCU+SWOEQgmguRieTIUi+H3LpmF1W24L2Mb6QYctQ/GAa9Rj95836gPeNzEIxIGYflgVOqY7owo2WgL0hiX3ElQ0Qtw8KNwvAVJ29PvzsFcANZS5HqZA98C3IgrfYVi5wD5L4EMq4Phxobh+ZZMKiUe+wI2+mQtndgT6CiP/p4AbPaBJ1Z9Ze4972PBx/coUR1xiVB4/qYqBLvabj3gUaARDEVggRkDADn4xSyx+c2ZWPOoLS95P5FmsDuS2dD+KkkDKFQdXdZlEBz6z4oKA9DjUpgDIASvcPaIxCSxg0MtQ8WpBu3YliMeMpGf1YcYDEn7d9jvF5/eBIjXR/Dwb257AYMG1ex6Mwei7H3CuZah4dubPkSnw1S/pBdBHZLS27h0EeH9DOUZoRRfaHf4EQSuZW8hDCXLLmIG+9y2EDZSugNEJkLlBxMqqoJN+pKs7r3pbk8WYDVHUhNl2vGsfKzPjpBbMs8ctB1FyvNcZvYi7hBLnZmLSaVP7tU2FQoj97ddFGbOFWPo0+QCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(186003)(86362001)(26005)(316002)(8676002)(4326008)(8936002)(5660300002)(6666004)(55016002)(7696005)(956004)(66476007)(36916002)(66946007)(508600001)(2906002)(6916009)(52116002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OggXlQT/mgv2Z7swQ2EufwnRud2rTLAbSNkM+hfgRfJlBbHdWPm17pjqQXux?=
 =?us-ascii?Q?NdA4CSt3f68CmUpDv0JhrGtPKSyWr4XXMoyCwnn6mdk5BWALPNilThr2p0G6?=
 =?us-ascii?Q?e8S/ICr8ymtHhR4EKJaia7hwlx8GNLmwEMsQ3zz/9jkapn+n5qLdJGX9Qc0C?=
 =?us-ascii?Q?saLN9iFlepDdKAS+snUqTcb/8cOdJXNRTSrQqnutd6DD14xsRi8wr8mXvS6g?=
 =?us-ascii?Q?RVVVWY0ZLExqhJqfTXE2O/QhvQXehlHVwnCTGT4+TFkushwRPfKbbkzjDTJc?=
 =?us-ascii?Q?gggM7jg4W1yyQ0dEw32YycKevHV/QaKMNiU/qn9oksbR9cXT7KUJMbyTArrW?=
 =?us-ascii?Q?fRVB36ZFUtFdI1QKk3rzXiILQp5EGs0N7RGUmcGUawfRVMws+jQTOdLtleo+?=
 =?us-ascii?Q?JNYblMC1Po5ZO4A3TYtpAn+tB40w7yxhqZvmzgB0Pd8j6F9dJ4ryj+LCwEvD?=
 =?us-ascii?Q?tMPrDkD3uKQH53aHXl7KPPbW77ZYwjKjdCv0DVH06CWqu67HEb6HWqh70F4Y?=
 =?us-ascii?Q?nFzQVGdF/+N8dt9CGCaQYIW2+RHc3cKh5tBCW3lmawMIX/ukgsgvUZhX0Sy4?=
 =?us-ascii?Q?PQcKhO7MoQ4Zq8KFqzj6lIsj1Cxi+2AHKYcobF7uPVlsjRQT2IPJQFYbP3IS?=
 =?us-ascii?Q?FnA4n7QHwRkNAbmxGmvhMduee8ZPz3ghEnCLSBXMRo0lifwl0FhYI8W6/d3L?=
 =?us-ascii?Q?ur8SkC78KJPcIrr3nB7QVKPWU0P9wbz6CGrPZNW25B+MD0dVuSka7oY3rpwl?=
 =?us-ascii?Q?2HNR7FEwuFEi99q+JGf4r6v2RHUo0CjsrFLkEBJvNH3YvygLjdcm+TFDPJzc?=
 =?us-ascii?Q?KD6bDBa4XNwQOPHb3jfCnbEJYKM9zBBcjf8bmUhz7W6ZGqlO7qvC/FiyLNda?=
 =?us-ascii?Q?D6Z4JZvYBcVIZg5pm/zxpsSr2qmPY1YkbQ/ehCqubW3COZGss4dkf4M2vU5e?=
 =?us-ascii?Q?vqoqp7lPp4MPU4cnjSFzXmJcpIBsWGPf4bSuGaLrqY7JwtRibNqHYwWCgB+T?=
 =?us-ascii?Q?kBFjVsX0LMsXS4Ue1z0UahmTznZQBNSsLc0/Y1cxsB12Ao23PaU1I53L8aSe?=
 =?us-ascii?Q?O5IJn9gNDtn63qNOUFUceeKJoTJFt93xgTjmwyhoamLMyecNE7iyEoqUohNS?=
 =?us-ascii?Q?WphgXbzLfjdNKPmlD1NRWJpipm8h+H6oQVNHO8acSSsxqSslsW9yfXVqgmMJ?=
 =?us-ascii?Q?aJw6l9F8hZUOlrBgzipVEYdLM54E4wzpwAPdjrFMjpmJcPRTIuGmRx487FcD?=
 =?us-ascii?Q?GRJ6Bxkov9RNuHDrX5mGNy5Y8jMaCVWLdNgqijvSg/DzPYijOhudZQ6dFRM6?=
 =?us-ascii?Q?yd/SrnYQGky4t9eU1q4kOB6I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e3579b-4355-44de-ccba-08d987b874e5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:27:35.8637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uBcmFT62AWayai/E8e5FJN3ooFMYpQfJtNHNZisMZzGNksJmGDtF2bTqN1xhcZBPirCBONYXeEneJRpLKSBW/L0IOpebJactqfO6JSpWws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=996 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050024
X-Proofpoint-GUID: 0_ESO-nL2XmFIifUG6RozfUIHTqOaPh3
X-Proofpoint-ORIG-GUID: 0_ESO-nL2XmFIifUG6RozfUIHTqOaPh3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> @@ -71,6 +71,7 @@
>  #define USERIO_MINOR		240
>  #define VHOST_VSOCK_MINOR	241
>  #define RFKILL_MINOR		242
> +#define MPI3MR_MINOR		243
>  #define MISC_DYNAMIC_MINOR	255

Has this been officially assigned by LANANA?

-- 
Martin K. Petersen	Oracle Linux Engineering
