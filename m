Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B0CC636D7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 23:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjBUXE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBUXEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 18:04:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AB81B31B
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 15:04:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMiJDg016059;
        Tue, 21 Feb 2023 23:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7QZdrKx3uSHRSOs8Docl4MpvH/VV7fVONqi/a6cyzOM=;
 b=weVsK4GhZoEBnlPPvUxOioXcsinaKulpvUezG6rln+zObraQZpz+h3oZUyieURwYd7zP
 GNdRpjH25giT0guxU8ihtHn6IBFugXIiUAlP9k/pjlJ6no7G1OpW+E6fVJd0N58riC2O
 TXOUNCPgkd68gs+Vc/hoOIoXNRNoJMNS5RN6V6808Ugm5OJeSscOyDNLa3OBLttQ0FD6
 KPYcW9POsr06pJ796Em3AtT6KeW/4uu+6BInmYxpxQU+objqv+rjfqTLA5SLcHsphzAo
 cHD2D7hHBwA6hJ9mceloZD1/PtFJZo+tLDnDybedo7u/Y99sOZITU29MSM06Sx9obbRR yA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90pmvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:04:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LM74RK023951;
        Tue, 21 Feb 2023 23:04:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45uy3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duD65CRgKgp81xLHU9gsn7u2zT/dccze4zAWz+7d3FjF4cfw+aFMCOss3Q/zwI2XgN3rH5tgnf0CCZdw519ylgDbLdwptJCVQAOZ8Os3aoB25FTgEk2Lb+PjvsGncuJ5+suqW6iIebW7hOTgP9vgme5iH7k/+71Pf3s71IorF/0JOpEl+/dQLnFnK4vNWp7Q8DnCbZfTJFRvSaGaAc69jw6FCE3NQat0m0CgeoYqnwLjcWrpnX+HSFGTenIctGgDhGUtwe9/XMclW1Gu+0kFBvJOniMzbiRKLFKc+c307jcDruvFltk1MWjsMyofuHXTpTh6+jKQ4fEDPUUi/vHMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QZdrKx3uSHRSOs8Docl4MpvH/VV7fVONqi/a6cyzOM=;
 b=kp3+wlnpWvGstgugOB4vmy0ow2v9LlfS01MgBIQqn3smQuXdNVZFa7T2z3fqPnW5N3U4X4VlDYiyb/8eYD/WY+1NiicacbgHnegP8pLa8aYJABfrhp1avlimOc6bBKvgbZgEDbwTnztYXDK0ME5ydnF+9ei22Q5p4kR36mfpTw0nBvQic/RsnH1fnaOJycr9R+ct48HarQXr15EcDKlH/CQ+i+JZtR3hcKnAMdhJKModNXjz8ROjD+FOhhPk9bim5x70a8zc+TCid3Ony0xbbafn+m+x4K2U/prmf/JtQZvOw5yGU4DCv54QYtOTUl39vtu1NTvuN85WJJW4SghI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QZdrKx3uSHRSOs8Docl4MpvH/VV7fVONqi/a6cyzOM=;
 b=f+F1Gj2eQQgsQEYEIXd4hBKuTeLpebrUAZzDOZip8zqj/bwpLNdqb2fIsGS6l6/s3uHmmp/6lmSkG8zXvei6dianWz7fBQedkMqnQXzWr40CACK7GPAaM5P8nNnl4K43TudbSprrB6LU+Ad88hIgEmm7SdaXEhxX+y+WKFwt5E8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Tue, 21 Feb
 2023 23:04:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 23:04:09 +0000
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com, hare@suse.de,
        emilne@redhat.com, mkumar@redhat.com,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] scsi:scsi_transport_fc:Add an additional flag to
 fc_host_fpin_rcv()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6vesjs2.fsf@ca-mkp.ca.oracle.com>
References: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
Date:   Tue, 21 Feb 2023 18:04:06 -0500
In-Reply-To: <20230209034326.882514-1-muneendra.kumar@broadcom.com> (Muneendra
        Kumar's message of "Wed, 8 Feb 2023 19:43:26 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c062e87-f1b1-4ecd-2a61-08db145ff051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LXlNqqWlQ0/Up+a+jtrNn/mB6Q15+gPYWPFLByQFkzvZKEW4x3N+FyjZk7wgko26DQx0ve9DICSmQP12UL+7rONaOvsZdZ3TyZnoz2PuTnF634kvIwwN+LzDg2Rn/JVWVMXtovyJVSAYxfgfkW6LZwRtXZNgpboVaKTLOvbq0gqxgCu8Ukw2+qDI+sRdqYXJ2SXwYBCUIuYI+nvEHK4cNw6WeUoJBQHaO5ss8fzqcTaTnxI/1mIsSkNv7LhTbwPCKIAykD33HI2iJ+KvrJiMn68Ld0K1eiR1D2qg7inp/VQA38Z06QAwOLd0Vr5rGlIQjwnNmqLwffGzbQtSRdbYsuKQlHiuHP9duObXtFi+QCOeYUwVNaOwala7Af+LZGfk0hchIVR9zn/5l0WeD9OwoU67/jD6opqrqIZyzUMlwPywOGUQl0j6OYlFu64TwvArZYPY8Pzg+NvCplUqNLNTDzExL1FCe4TOmQf22Ie6hXbhmJ3qyTeH8tbzsfoon7gXUt2g2HZLF8vGS07YC4ZnZzcgPij/YDWlGqapIhEjFxLUcWDbmxyPL2SFX2Qez2Y6780ahv0v2A1pD/h/T9GwuRtZ01UorNGW0MCBwcTrz3mfg9Zln48ONziG/6JeSJVTAXUnAcEWbTuYpTqK4Kb9KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199018)(38100700002)(41300700001)(6666004)(6916009)(66946007)(66556008)(4326008)(66476007)(8676002)(6506007)(8936002)(6486002)(478600001)(86362001)(36916002)(54906003)(83380400001)(316002)(2906002)(26005)(5660300002)(4744005)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?khnXcT/h6llVlnt5h5c8dxL9GbSitd5JXqhqHyC2efV7zDa5cmHNR+Dc73nj?=
 =?us-ascii?Q?2fwq0jW+/qJxZ78GjOkztoA0LOHPjYF5Eq/KHb1eP6kWXGjFDsZEh1E3tayA?=
 =?us-ascii?Q?J4UY/Wte0tVRXhMUDzn4pQPSqsITPuHfrGyb6niGIqRqKgz73bIHXzrxPRBc?=
 =?us-ascii?Q?1c3P+mQfzKJ2DhUHRDBizgpvzG2YXGwX83UTlikZ8LHchCWg2hCNowVrkiO3?=
 =?us-ascii?Q?k7X6QCNnZN560XvIPISr+8r3Y5JOE24hbWMdSE4fdEe99J/1NM8rXn9X9GX6?=
 =?us-ascii?Q?c882uZB2sAMIy7/NX0LjWTBlN1hxcoAkqIu/6HxjYFEVIl0lGYzcOVxLsqg/?=
 =?us-ascii?Q?Is4o+xJh0DO1pkD45fTwx+gMJHaU34GyT52huHSAezILMmRb0p0ho+U/4F5s?=
 =?us-ascii?Q?H+sdeUzcc+5gSRY/iwtoicd8R7gOEUxP22JT3pTnACrluFdzHwgdoMbEWLV0?=
 =?us-ascii?Q?fZv4kL3L7TV8cM5uvFkNQcJWUYIDnHPd1G/SkBDVshrBqbA4IFSIsRjpla8X?=
 =?us-ascii?Q?5Tdc2vnHYVMQUe7777QxSgh1A30EX6JOvFWn66Ip9hhbYluyXQpR/mDlVcgt?=
 =?us-ascii?Q?VGSUo2GVsvMiK8fnlsIHofP/w/ZPeIKVo0Uf17RSTQiea45+wXio2Z7uBhp0?=
 =?us-ascii?Q?7WQQ4VX9Hr3edxGIqRdFr8TnP38SDkHItbme5RXRWJ/cJBt4/J8pKfWS+Cln?=
 =?us-ascii?Q?Rcu8/Jiw+bmf3D5jZC8wLNltvOaNFJK0f7dUhiqqpY6QmY2iBua511ZOJKf1?=
 =?us-ascii?Q?g3AzjHw0Eg5wUbs0SYbDs0QB4WIzsKEhICdx3POHj+00IUkltzb9LqUhVsTA?=
 =?us-ascii?Q?eAtQinUfpvprzK6Yq6t+qRsSHDveXdtbTkLDtwEEZkeWMjKqU+AJNU2QpKTO?=
 =?us-ascii?Q?BuF9A/L6tbWCWrnzTxmy1Pl7ZOc40Gg+6ltnnf4MdjoeKfYzwef1TgETq/Ar?=
 =?us-ascii?Q?9Aq5sBqUF1deGu7LMopQsLLyjM4b/gxdlv25QUCOt5KRvL358aOUXeobUrDv?=
 =?us-ascii?Q?/Omo9c/DRcKe0iI5/xKtQoUmtNM/UsWb6lvrzLz9ngtyrr+K/mwFuD17vpIU?=
 =?us-ascii?Q?SO6gvA9gKgDtcSM9MXFmUhB/nx2M0N6WSSm8PnRZYDgaYiT8Q/hBpdSXzWBg?=
 =?us-ascii?Q?QtZUZRCLfYv5wTqZAYH5SPj33fbK6RRB8sjLFoAkBTb5pVXm+JWRDX1n4Ihc?=
 =?us-ascii?Q?z2O4dhMtNrNT7pVyZbVc41jjf7Nn2IEHFp4PurZNf83ea+33sC3RbtmX5M+A?=
 =?us-ascii?Q?ae8C7xmpTY4WtTJM77ITx7z55JgC8ddFHFY6HPhGEHpqHVmt8Cjk+xGavsK9?=
 =?us-ascii?Q?SwN83bJyawT9zdIwVLUmJnRkn73VdD9iUD48AYuZjX0hXLkxWmxqksYJ6vLY?=
 =?us-ascii?Q?D9Tkrdf5DTZhhKVIfur4jM21aJZ37QAR91ewzISuerhJXTNRL3LhOJWHVcW2?=
 =?us-ascii?Q?X0hJJc5LhkjVto7wqP99kamkgRn3Yj0FG04hMO8jwrTYtcm1CZ8C5p09+4HK?=
 =?us-ascii?Q?ZmhRA+OU+Dt6KY2hScSPpxlPkvYZDM8c2Pe7AUqGcqsDbienvpm6LseO9Qw1?=
 =?us-ascii?Q?qdRQHJxbp8KbRL+i/19V+ysO3sFOoIL75O4D8AmmcqrX8Unxu/fBwBc5nBkI?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oJQ1rdMVe+agyL8D7rfvFhDRQ9jy/Y117aN/TTzH55rqGO9w+UAN/DWA6aOuXCjZ09IRqEbf9+JgSdIBhPV3RH5qulrqxNDeZsgh52vh6afC9Pf7UKlmaKo4ltfj4HcJCGa4ESxY2rFnrwPqNLvPoGryiWYSrXHdHCrleZd8ExOzuJyvamQeP7bXM2YoVsqz/vl8J4YBRup8D333HhjzMU7MlRo2xThEt8bi5Gx6cI7hul2fsi+ELZDCAs9vodbNIuAU1BGWWeQ5YqLyROYBRl3jRDJ4WmzYqbnRgY0u/UMc5HnXQ9/rEXR1SdGpTC4BeSrBYypWsXsLLNEr13Ytlv73bR/odOldWnfk4G43bdWzdEgU8TdMwUPZ3u/7Vc+zxUpJiylPLDjL7Phwq2a9pmS5vya36Eiq19xHWS5eEXzt2VNWfAFoycurU04K1zPIUi6UrAIw+jmqI0RQHoQr16fBJBEMUDJDi95pK+7tJEwGotqwT+0UQeqOg8TOvVfCVGulwNJTAsDO69E8HEOCE863Pm7YInsKohbYX229qkdz4JB/7bashRo/Y+Fg3dwduz85iAVb3+ZBmLO/0Fh1BTGrVz/mj5rdAT8q1caAYP1lk4TOszmE5JkdFdgykBRyqY/J0AuOjjeMwefIB+ckOMTJ3PW7JLpJtWnQtHYMHd/6V6QYBidWb2+1Y3fwDF8k4LZWJg0Gg2MFBswoCe5TWKAWGn7wZdJJLqOWFX21BeBOnlPOnHoPJRaLMdcDVJOmpS8zRcprgcP/48AKcEJk5cKyK0hQ8Jbi4/RXhahfB6Ff4GvaJoiLNMCCbHqOJIpMjRl2UmdbpsmMJ9Q5BQLA8WJreufVSB7UMn0Ka4E/DPPWNJF95asta14koQhGpf9StYyx6efnBry+2Mzp2+3woA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c062e87-f1b1-4ecd-2a61-08db145ff051
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 23:04:09.3887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlysw3q+12ii8OL2bKl7mG6fbqeokNlXsPh1mRWslWCFJ4JBamgf+0veAVXY3xFDxwvnveQQ5ZL2Zbqq3owxO8Wf9/ggskPE5FpO53XI1CU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=714 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210198
X-Proofpoint-ORIG-GUID: sHdnas8_r8blSGSrUMeVKOVFjl3GRFly
X-Proofpoint-GUID: sHdnas8_r8blSGSrUMeVKOVFjl3GRFly
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Muneendra,

> The LLDD and the stack currently process FPINs received from the
> fabric, but the stack is not aware of any action taken by the driver
> to alleviate congestion. The current interface between the driver and
> the SCSI stack is limited to passing the notification mainly for
> statistics and heuristics.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
