Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B94C83F01
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbjHaBOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbjHaBOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:14:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428E3CC2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:14:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0E9FE026401;
        Thu, 31 Aug 2023 01:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=g5yPGI60w0JGqarQKeD55myaObfPkD6B3ZW4RaIxbY8=;
 b=e6hgv4RBpVHs5mOmBGF/s+Eqd+E8BMzkYHjjpqRUzLE+0Eep2rcEJ3AsjivgSboGPUqQ
 Y7eQCFrRRRlwRv0LrQBukoc4H0lryIzXkfg6iR+dQjdZPpMsSTR4/f/fJiYx0ECZdoE4
 U+9Rnxd/KHTKKig2v563HsW3GC+2u5rE1RXQEmBx8udjIGgwDmIbDtNFBjtLGfne+6Gd
 TxpwwiIaF4b4M+iiwwg44w7/S65ic0do57zN604vU+aHcRdEfzfsOztr9ysSLDjDvehY
 539YuL2GKAY4sc4i9g+4F4IkaJu2UJsu16uaiGbFzHOiM/l2o6ClQySlK4akr5d+eIYO wQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9k68re7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:14:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37UMb65K014527;
        Thu, 31 Aug 2023 01:14:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6hqa0vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9L3xUmcdpPrbkTrqpuo0dPDfevbgZi/yYtXr9bhuLYWZQM8ZokbWOdZAA3CZ9+nZnb6fJUJlLG7Ngu91xh1HOYq52qm44tigjYi2K5vM/Zago9X4atNIQiurPf5TG7XWNKHQEkQ/QxcyAc99yc8QxHP5deMyPIOFZJJRXeL7tSyFY17g00lA909m0Bj15TDfaJ3i2qMid6unE+PpWEcBXm+2WPcUlt4rijnwGg3xKtB2P4Ua6jq1K401l/A0+6vB+maUdg1TUbhiy+anWe5SJ9gUNBUeQG1+66fO+vLbBxJ0019pvva+mkTy3slx3w5XLVyx/JJOZez6NSiyqn4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5yPGI60w0JGqarQKeD55myaObfPkD6B3ZW4RaIxbY8=;
 b=I+wnMDbVWbxD7mPhVMrMNJXuy2yqT3CkgNXI5b+TfD+kuk3Ip0mUz9SBoomYRoq8N62Jm3zLCRUuV4SSyb6JXp5aItL6q068c090gubEogXk+XQa3acrkYpM/eN5kD/k7FaQq5pQ12LPpDLfoxY7t8YgQKnc/fJTKaxLMd+P7HiYuOy1NCMZpcWb9bR8zLd/coh7Hhi1fQoC9xAg5ZuuD/k15FRZx2VI+EYWGIpmeMV57vfVL5lcuICOvJukweU6mF2tNVcfhTyH1vLW00uJVz+hflG/JARdVG0pXx1FNjmBAUBrkgH/gPahsnFWEwiiKx0AxQb753N2WoRYePbnEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5yPGI60w0JGqarQKeD55myaObfPkD6B3ZW4RaIxbY8=;
 b=rLiOpiqvt4ab4FtAhTT6rNl47EDfyjN+UCAIFdc7OVKfRX/oH86eD3MXhe0JBfOsZH8UMFJ03Z73NXhkOsgp3cmQXdEXvaYybwMoEBLtlDrLaDegm3FnNWarvAg8P0Q22i4yYe9iYihiI9YKhn9s7XJ4OwunDn2ds+vSTUrljg4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6316.namprd10.prod.outlook.com (2603:10b6:510:1cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.36; Thu, 31 Aug
 2023 01:13:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.035; Thu, 31 Aug 2023
 01:13:59 +0000
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, patches@lists.linux.dev,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix unused variable warning in
 qla2xxx_process_purls_pkt()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkeoui7o.fsf@ca-mkp.ca.oracle.com>
References: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
Date:   Wed, 30 Aug 2023 21:13:56 -0400
In-Reply-To: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
        (Nathan Chancellor's message of "Tue, 29 Aug 2023 07:35:06 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: acd08bf8-c13d-42f8-5171-08dba9bf8dfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yirtasyjHRv2S4XyR40dgRhbWttdm/0+NAhbf/SEfMubN+VInn8TNCXvoRMHd62FFQRkL17sDQmNrbxCIg7y3WwGDmN8SQrqfTHPMTdiiQwumniDvau68ROiEuJwZyVFG8weLqia3+6vb+Pkc7ltDb3tvRaBRzv6X7mc6YIO5iB9SJSacfB5J3V07Eh81FaZ2mwQ4+WlyoF1uxEvUo1eV6BT4p2GkNq9+lqRL0ZsMQjAgb/5gwK5/kbGr++i8A9cRpP+8ziquaVioy9rF8NM/wORqka4PmJ96dQcx52nydWQEA7cU71sVFBMRiEhAIfmQADN+ZJQ7YjmO+cK8VZjGDulCJ19CDMc1YGTrSkmCLejyLzjFx0IiVV6jtuuPLTyD8OAlNg7a54cHmcyfd/Y3otIozICiQe+eBjRjh21dQ5kFmTTyPgtfFYbCOAo+nBnMJxqlv8ZQVgXq8mzJyRSn8BfqP1+e+xr9TjOR4hkowZD9Ptdni/4+j3hEwP1GnA2QVDYgUyXOWXBmsks6j3DBQCdBIg+5BUjL8IXysRVsxtDKkDWmqmI0TscSzS+AFbS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199024)(1800799009)(186009)(6512007)(38100700002)(41300700001)(316002)(4326008)(2906002)(86362001)(8676002)(4744005)(5660300002)(83380400001)(26005)(6916009)(8936002)(6666004)(66476007)(6486002)(6506007)(66946007)(66556008)(36916002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iar8zfn6I4ZsTPxi7LDHSzQ3P6bp5uPQ3NTr7ToGOMj/i4scC2j0k4ZSY2ys?=
 =?us-ascii?Q?2lHTxkyHPZGNrUR6v3/kTrk2OK02pSzqLuW4zWzG2976Qp5PMEHGg+cJ87zh?=
 =?us-ascii?Q?9FoYImvCTUk2AeBDEDnzD/crHvsvBOgLM0zTrtq2ml/c3Tx+XtzGsxylVIao?=
 =?us-ascii?Q?YhG8oRDt1GLWnOwuDTdqfmnr1j3tHUG/n6VZ4PfD8zqZQrP7FNP+H2/kLilg?=
 =?us-ascii?Q?Vpc9poIeLdm8kN+XVg6nihtRlM2j8gt5kgXBZ+zRHLHadHzpxoZPQx+NIhop?=
 =?us-ascii?Q?zCLmLHAEwjuI3Q2WIfHwqgbSloq2C/8W6/aiwSlAB/h8lfe+KIzeKqzCVQsq?=
 =?us-ascii?Q?DLb9xiX2ETJ/oYr1bSKH6VFBk4ZYVfwPBTFPekaN4e2LJbQojBH82wecWqSt?=
 =?us-ascii?Q?1aZQ5a0WerOp8TZ0vl0MKjAHBDsS1EHgZdp84AA+YAB908JSAjJHv6TwA51P?=
 =?us-ascii?Q?kqcQQV3v900TuvN9mmJG7xdstJmNyNhIZP1xr3Ivjhgn9Ta+ibZpJK14bjVc?=
 =?us-ascii?Q?GHTo0TMBxorDirwbGuKnDPd+Z+XnJX3EphKPGJr26jL287KpL6DIMpI0fvsR?=
 =?us-ascii?Q?wWeVJrenlEGLTeiDEpKympAZ5nEej75gmpGSp/KvpgZ5a7XSPPGnRcjjL7+B?=
 =?us-ascii?Q?SIqezlFXvUHVYLL8dsoRxw/g9dYerWSFmeGGhiyo3UwPllVmC5t8C25RFp06?=
 =?us-ascii?Q?FRFGnWzqZ2NTwRPIdWjJZkVdX4qzFD1wBx2qAu09GOrX8pATaetmMHohNIGV?=
 =?us-ascii?Q?UOdtDw3g04QRNwTa39LvHqTde+69vGU1na1/QntvfmWU7KsAG+lTqNftcyTG?=
 =?us-ascii?Q?PDvzatseQ+C//W5P2q5GlYUJV3bajjo6qRNXo4nMMXJ4P/EPYbtAOUkRjYFA?=
 =?us-ascii?Q?dgrxLDDmnLvaO/aaC1EKeP2BBy/VjNVUYKh9WTf8IQb7U2Thu2/sHgLYaa4c?=
 =?us-ascii?Q?mR+1TGTZ7Tpm05So/RqnRkgAeGo39S5dpLOK+1cnP5as/zI+fwXwM5Hjtpab?=
 =?us-ascii?Q?2VTygdxCS5rLPLSgTNrZ9OpiHgLdwvWOXL2VsEIdcFL7JjUB1/TeQn6+0fhC?=
 =?us-ascii?Q?S+8V2wMSAmx8JkBm4oIYRwzPysAOAZp5pwoqTsBdrnJWil2/Y5s8Tuta2SoF?=
 =?us-ascii?Q?YkgFYkeh/pcOQhUXkGy9x2NT2SqHBdZvp+ZJI02O4zx9VsNd1AM4BjsUGa3s?=
 =?us-ascii?Q?fQms4ES8ywHbSRP1wBYT8P9PfXPclRqZFvZcI9q99yIxBgmt4CwG65ORVp3A?=
 =?us-ascii?Q?r+b2df12nQPLMUzq2KCR1onGr6wTFa7XRFPAENUWXA3kbBUvhb7DpwVHgAow?=
 =?us-ascii?Q?ESQY5C79c5pR2XH28b1GCRC1s2/tnOyRfSSf0abNCmpDTLe9QjStvJ2eIJlX?=
 =?us-ascii?Q?yg9/Ukak8z01PPgX7RqaRNDjxP2bCv1LeSgE9MaIx1pVQJgCcJsUbXjvvDaN?=
 =?us-ascii?Q?SLctNc8DqVTt/dL3YRR5WkdzCzNH4aMfAVtl1ZvqNrBy94Ds4cTVyHdKOzJ7?=
 =?us-ascii?Q?wUYAyyPKEYCCItJFRv+UGpK1xxGPhgXhEQa/O2cAi8cCR2sMGdgY6wtXM3mg?=
 =?us-ascii?Q?O2QGzUTFT3uzuYz+/GeiHPDOH6jA62k0X/MKE35KoBemz/CdNrzxW8PTlVoB?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?WiEa9pb/USr3tHaO4TjT1j3SDLJsjxcKIVPpNPmk5bFGQNpTNa0zLkh1gWAb?=
 =?us-ascii?Q?dKNNcaKy4Oo45N3Q5Axj+sAzF1GTdSujdqKgR8kqMnSAoAC4Btx4c73A3xJ7?=
 =?us-ascii?Q?6vtLM9b3297IEwEVJNiM9dbWe1iw/fNEwUn1rww3Egu46Ng+Ilblq4BP8HVj?=
 =?us-ascii?Q?OogeCCB+QYO433TmlctgI1OQu9beBavhLGfKRMhmHvEU/YUc5TsHnA60Ppqn?=
 =?us-ascii?Q?pcjiFPwzacX4FoZ4kOkAfVxzL3a3Mem1M+QPUbLd5CCVEPZsaI2FeJpc+QTF?=
 =?us-ascii?Q?6Cnnlj5aMkAxZTsTR1oUR0MNAkaW7Kgg4VccU+qpQxYpR/DL28pe98k8cFOi?=
 =?us-ascii?Q?DbX+uydhiS5J+/CqnyRi8MZvxc0pKR/X/sMoSA7i8JdU/mdYRz5LdR7j4QrB?=
 =?us-ascii?Q?2QlxE1FGLSySURg+2izRylIwNgKzPS0vj0hPg3m+AmIqGWY3cX+tGCK6GSd6?=
 =?us-ascii?Q?PWKiyNI4SvHNZlNiVKM0f8ql+74JmA+w0LTcRItGmfBmScvnKuVFZtF3RaYR?=
 =?us-ascii?Q?lx/XnWGBsyDp+CsvxkEsA+YpAoElV1s/KoGpdatKJmAVGb6tmYJvc8IXavMU?=
 =?us-ascii?Q?Q0XvZLlH8g2Kvxd2rsol9YFsuUzaBfHrEzm+/zXiDoAR5KD9GUTFLcnJTX4+?=
 =?us-ascii?Q?Sm9M7E3LHeP/Syvi1bEMnEgkENd/RmWV8fMCsA77894md0RK/xpK2O3zQinO?=
 =?us-ascii?Q?0WdZ1A/1WU4yD+IuC2iNFWfqQhOQNMp/gp5iWpSuwbyFhGMqfgQpKJbKnmT1?=
 =?us-ascii?Q?uSbRomgVZ2fLjOhB2c2weFUpRlNY7V7ZGiEMFlNIc0JBfUqVA+E1TxOv3ANq?=
 =?us-ascii?Q?Cv9wCknVwbVoDq+/a8cql3U3ycxpCLR+ZMpO8yhPQxnBDAPLrwcw6Z9AnUOP?=
 =?us-ascii?Q?2sgqH7+v9+8j7cVbuIBrLFwrERfWrHbW2Xq4Tz+KsT4+qfMN+kVJc20/u3Or?=
 =?us-ascii?Q?AJpdYl2zLn5YfHYBrZRdpV3gauLFOGUBkNMb5SIvHIo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd08bf8-c13d-42f8-5171-08dba9bf8dfe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 01:13:59.0394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yAMze9OCGYNUEhd/qIogDNJDDoR7Uq4pOuA32b3Rg6KRxFPWALmviLskKRPx6wZuFAxu7CkyhScpq9/QkmmobJYBFzh2dFpDKvsYRI6zCL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6316
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-30_20,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=869 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308310009
X-Proofpoint-GUID: lWnFdCf2Mi135tJlULPJutR_VN2gOANX
X-Proofpoint-ORIG-GUID: lWnFdCf2Mi135tJlULPJutR_VN2gOANX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nathan,

> When CONFIG_NVME_FC is not set, fcport is unused:
>
>   drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2xxx_process_purls_pkt':
>   drivers/scsi/qla2xxx/qla_nvme.c:1183:20: warning: unused variable 'fcport' [-Wunused-variable]
>    1183 |         fc_port_t *fcport = uctx->fcport;
>         |                    ^~~~~~

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
