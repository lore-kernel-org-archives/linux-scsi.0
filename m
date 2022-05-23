Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59F9C41535
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 07:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiEWHYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 03:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiEWHYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 03:24:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6437533EB2
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:18:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N59EYe020756
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 07:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : cc :
 subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=aWrhldMLjeEl0oKlq5wgqbTke5iSky5iVEtKqeOwJRY=;
 b=GcNo13LkOAC6zScGggHd9+coc8gQsder5fY2YwpDXyH6UBXBJwuYcyHzrlCSQXLOVHHM
 LlKeuyJRruFcNxxfNvCWQLzyqzo+bQxulLCEJlZymTfZavGUWZWDthoO+BUXKQeYGHDh
 tPZH1G7jspmAKsAY3h2wjiatKg0vlJIOp39XB3OzE5AfLYsKayeFEccNmw62ojaU0qLH
 /y8TyJYG3FWRL49+FZPjDA6Jn8ECuBCDQWMzTzMTeYNtI7kudQwXyu0dKMMK9wFWa4O/
 MTLPW2ZahsTdORQhtca3BcZ+eEgyBAGD5d1VqozNiuX9x+ipU7haWKI6TllJNMGma3tG Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pv22gqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 07:18:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N7A2CK037900
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 07:18:09 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1bc3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 07:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDrfIXoYIKxqx+J6F6vGugrkhTqJZDLrjzGRX/4vdYBO3+3oXe/QrnPCY6cZqnciLKKNeUnuAq5grnWXCLOniH3pyBgfzYo4cPfY1WffGD2GNDR/Lw0Q6Xg1HjIYLC2eb4Q4aDCidLbEdO3340J5Su5T+B+HEkOwMEVuzpTEmshZCuXzuWbejUWki7pgRFAGI94+92+7q6blH1a76OT7CDz9bqvjL0oZZvzQRZabhU7tUnRrLEQN8mF7evWLjiCHTCnLRQHo3uZSW7VpHvzdcrVQ/lO1vC6hW4ufeA+99mx5/0egGaKXJPOy04XAap2iEQiXQhfkBCmJihHFe3f4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWrhldMLjeEl0oKlq5wgqbTke5iSky5iVEtKqeOwJRY=;
 b=LOIvJSotnowlJ5L0bGMUbI0OjRUtaC9uZWqh7bxQmX5KLsPwLzBRNXKPFpVhL1JekLJsIigO1I6JO7H0nD53pIPekrV71oBmlZZS+IYl7Gc9x46uunUn6DwXUgCLh7QB6S+3jgDnDhGQL2t70TAggywdNfJAgx9dtC6vlEAyxF4va9RlXptX1OwiH85VCEWfwIRfDv23tQKyCDp+UlNUysyFUR44eUt7f+0JiRnRTsIjWnbGOB31fmsQP8poJnhpr6rqW+xpvuUqbHqRiLBTkM0JBi3/1pbiQSAQTj8foBacG6JpgrrHvh/7iXD3CDcOO/MfJK5Ab2CriMsheAGe6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWrhldMLjeEl0oKlq5wgqbTke5iSky5iVEtKqeOwJRY=;
 b=EJxfn5RLzU7RCpp7+YDVrZ9VHNJS/fyQV9G6I0H3vMdKDhFX9oNxGMkHMahTLkJluU6aIhigaOHiJwXJUbM++R56gzzDy4FKwYclCiF5BO3smu4v/fRI61RIoM/qwK+mBKC2tThFxJWBV618cTw8Zbv9sc2gq3jg5rrw9GPVSL0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH7PR10MB6107.namprd10.prod.outlook.com
 (2603:10b6:510:1f9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 07:18:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 07:18:07 +0000
Date:   Mon, 23 May 2022 10:17:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Abort tasks before clearing them from
 doorbell
Message-ID: <Yos1JTu75ddjVYk7@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 594f4176-41bb-45fe-ee77-08da3c8c623a
X-MS-TrafficTypeDiagnostic: PH7PR10MB6107:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB61079F1ADE328CDA4F33AC338ED49@PH7PR10MB6107.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55aCO7sv7K5l2xLwuFSODc/n3qa/5+jsEMfeLQ2mfMrUq8BA68EiGlf7XRHOTKVOsmewf07vJWn3c56u1mLNUfuxtFZgG3W1ucNCPrBHa5VlYjGBqiIEKKfBFQEPf8tjvXBDql84m5kNTtLpC1chnGaG1vYhI4j+pmkhArtBmOp6xGLPrctV12hYAQzPsicpyRpPL2n2IVdviDVHAhGwyMvyYyl0FCv5GAj8jp/8Cfk1k+mvIAbA8GzYEIlJpTz3ECC5l6xGttCtLfuzr3EiXf8mrc867lgfh4Amp9tsdb/qntYZOpW8NHJBFkG8NJGE+v40js1NPRZcPYOFMoYlr5BD/5vAnLjw6SEhzPRhi+Jg6kWy4p1NKfQhJuQ3M+ZkPqMXM8WVimInO9qdInwXhYHFGS/ZJQtWjZwHPPl4pXLJnZCENfY09KzUutpsxyp3vVMXRtNTF5iTSb26l3isfO0p7T+8kauwRfBMQupidcAkuaFZol4WkeUyJyoflwqbdYCZwB7vmZVJ68mALhTLsjT2f3Fvs6L4ewtesJx0ar28fkDJ9LO6FaSxRQ4RkoE2M2PaB7cwWZkQQa+5QEmXnwji6NMHIBMhgkq+7WKSMtpFMrHslLHX1SmQ8k/EkDohKJxcOVjC4HmR4/jULnKlDidEH12old4Pd542BovXuKxfqHa9uWtv/VQ4w4dCrCvbNaWNPIeUPZkoz0IEWhXALg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(44832011)(6666004)(6486002)(52116002)(38350700002)(38100700002)(6506007)(86362001)(5660300002)(33716001)(316002)(2906002)(26005)(9686003)(6512007)(8936002)(83380400001)(4326008)(8676002)(40140700001)(66556008)(66476007)(186003)(508600001)(109986005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+G2Pj2GlYCYgyne+60Ty3YsAuljFK5G5mD3XzFH6+yHRXOVa6qS1R/Ok47Qg?=
 =?us-ascii?Q?zWydjGCBYU0TCn1/MaIU5kxiswISsOJZ9s3SFtUm1ZA3Y7kPTGapm0E3Z/NN?=
 =?us-ascii?Q?6NiirF83ws1gtkQEa1Irqc/DV+G6N+O0LoOhNp9MAXpkKAHHgeRScA1EbKuM?=
 =?us-ascii?Q?rZrs+8DDnCSPpouehUtvQ7zdD/GXQtMDA08yXrq89TgpHvO6HVsDAUlJTxHR?=
 =?us-ascii?Q?oQVUB6NKo222DjuymUvx+pFD+WW6ZfbpZq+Orz1sSdYSm3N/Aa/Vs5DWS49c?=
 =?us-ascii?Q?ouaSVZ1nfvb8acxSjdM7XWxfX56dlFgDPXm88rY0ltOxPVuv3wKDVUBNaC3x?=
 =?us-ascii?Q?mZDN9QOPr3zltAdf5kzEDd5P4j7NNBC0dBdKQDck/hzbYaWZdYtz31re/duE?=
 =?us-ascii?Q?X6XhRPcp8Pu2YjtadkXR1vZJ5hLB0OERNzAI811FRNUqjFEY5B1aqv/Ey5R+?=
 =?us-ascii?Q?WeC28fFa9mWUUDAkwqhbAh6cqP0FeqXWaPtiVJMzRO2Ux7acUTYLC1P4YmqR?=
 =?us-ascii?Q?zH+yxaQ7HKZXmzxQ9Cis1FfBSf9Ba6w8ZNl89v7+DaTKIwnAY1Est8JKv+It?=
 =?us-ascii?Q?UfW63L75rLmBykUgux/fP+TBYDq1A+d0WgOnrXjiRTjXLS9cv07yjCerEurC?=
 =?us-ascii?Q?CA5i0RxEY17mzgVaZxLrJB/lea/60XJWBCNwC8SiYb/dvaf9ZcUmLPemceMW?=
 =?us-ascii?Q?zJKs3CZLGWWXJCcd5vfzAmPjMfgTVjLETBT0LiOqBuFfCdxOVqUFApUnQAz6?=
 =?us-ascii?Q?R1U3Dg/5P1K7X529EKx917PVTdIxr9ImMmgFOHKTrKEb88J55CN3nAksx4Ff?=
 =?us-ascii?Q?VPDOXd37p2OU9tGhF3N+OIc3JMrQN0G5H5Ulv2zSS+5wlDII+hWiH+8WP7z4?=
 =?us-ascii?Q?St8La/adb1BU4RIq4SMhTCQg1rVC9DpvckYU4bBG/gcXwHGubf24UkMhA6as?=
 =?us-ascii?Q?8oR8PCKBT/dA4j1Gbd+Su3aJSeLHNWoQO97uHT5wDLv66ZpeWAch9wNGPe/U?=
 =?us-ascii?Q?php7Ik2lneMxdlySPnGfU3gNa8rr0+Q+csVfC7tMlk22PaGQa8CNyez2Ug2j?=
 =?us-ascii?Q?ruCL4YzDfx34ZwmTwGQeDxBoxFVM6/WsfEPxKmmDw+9PeQtIp5dkfCAMRe+m?=
 =?us-ascii?Q?ycXpwssRAdnMHJ+t1nHDy0XW25r2aS2UxCRZxoYX8tBsEHf+vmzFda3WTUXh?=
 =?us-ascii?Q?YStNUmKW0YLZR+HlZPFdqG0dL1dEym7+PMRZ/X0aJPUL95VIc2sIPwWG2rOj?=
 =?us-ascii?Q?PgpKD79ijnYLmmwqncyZO7YFRlUkdXNqVat4YJ95UW9cD4S0A9ADZKeB0C+U?=
 =?us-ascii?Q?d1HRkRl23nHwtRZLX4oy5JbJOetZz2N+nwgps5CsqZph7YiBqKo+J6GJqYJz?=
 =?us-ascii?Q?BOErGzSxEnBwNEyeJldVg8Jf/ShnerPn9Ng/uhZCeyxLHtr8dtoGB4Cc6Lx0?=
 =?us-ascii?Q?AXqN0hALd9vhEJPUapTWzXia5gyl1/gt/sw4aS/qIVxGqwXFLUnVTS+e4qS1?=
 =?us-ascii?Q?5xf+W2KwDF0M4f6ltlxiMwYroFiX1lo5p324Zw8L1Bo2gSmRZGwUydYNfXtn?=
 =?us-ascii?Q?zhWHheTfj13J8tfVOOgXbUCu758d5WEmbckDhL+qU2IpybcpqwvfYf9ByO0j?=
 =?us-ascii?Q?KBoiXutIV1/mk0igNLJenfFuH7I+oPjJMKGj8FFnqh7HJ7kEkpwkRBW+u81H?=
 =?us-ascii?Q?wkpKwmfkHxIAKY04j0pt2yv7EtwXQfgNPkRshZzaQKT9AXtxscBtiXiVXjy4?=
 =?us-ascii?Q?VE4jXwuicVW1LnkScaPhsqpTmyUwZFE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594f4176-41bb-45fe-ee77-08da3c8c623a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 07:18:07.0432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVqz79hEYjeMxqI4HswOzNB8Ayom28o1Pm6NGd6Qiz7lqGJO5knp5XoD6Mg1e5JBW/I1Ms+ofjroWj5tc6Y2iKfY/91AwJbtv0DUaM4Nlo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6107
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_02:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=745 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230038
X-Proofpoint-GUID: EIRRA4_WX_oOr39_XBhrmi3q7OFYjyMx
X-Proofpoint-ORIG-GUID: EIRRA4_WX_oOr39_XBhrmi3q7OFYjyMx
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[ Can Guo's email is bouncing.  Ah well.  - dan ]

Hello Can Guo,

The patch 307348f6ab14: "scsi: ufs: Abort tasks before clearing them
from doorbell" from Aug 24, 2020, leads to the following Smatch
static checker warning:

	drivers/ufs/core/ufshcd.c:7064 ufshcd_try_to_abort_task()
	warn: missing error code here? '_dev_err()' failed. 'err' = '0'

drivers/ufs/core/ufshcd.c
    7032 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
    7033 {
    7034         struct ufshcd_lrb *lrbp = &hba->lrb[tag];
    7035         int err = 0;
    7036         int poll_cnt;
    7037         u8 resp = 0xF;
    7038         u32 reg;
    7039 
    7040         for (poll_cnt = 100; poll_cnt; poll_cnt--) {
    7041                 err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
    7042                                 UFS_QUERY_TASK, &resp);
    7043                 if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
    7044                         /* cmd pending in the device */
    7045                         dev_err(hba->dev, "%s: cmd pending in the device. tag = %d\n",
    7046                                 __func__, tag);
    7047                         break;
    7048                 } else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
    7049                         /*
    7050                          * cmd not pending in the device, check if it is
    7051                          * in transition.
    7052                          */
    7053                         dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
    7054                                 __func__, tag);
    7055                         reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
    7056                         if (reg & (1 << tag)) {
    7057                                 /* sleep for max. 200us to stabilize */
    7058                                 usleep_range(100, 200);
    7059                                 continue;
    7060                         }
    7061                         /* command completed already */
    7062                         dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
    7063                                 __func__, tag);

Error message printed on success path.

--> 7064                         goto out;
    7065                 } else {
    7066                         dev_err(hba->dev,
    7067                                 "%s: no response from device. tag = %d, err %d\n",
    7068                                 __func__, tag, err);
    7069                         if (!err)
    7070                                 err = resp; /* service response error */
    7071                         goto out;
    7072                 }
    7073         }
    7074 

regards,
dan carpenter
