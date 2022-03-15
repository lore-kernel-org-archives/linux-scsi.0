Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B24EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 03:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344276AbiCODbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 23:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242509AbiCODbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 23:31:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48CD488B5
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 20:30:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3E0Zv015173;
        Tue, 15 Mar 2022 03:30:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4a5HQ43DdJwdDFF5MW3vSai53rHsuxcjSslKs1gyNs0=;
 b=mhlAYkBg8DDlWiUiXxA5UcbYvzTAuI1JQ2SdoKcISKBITqNafJpIFMNBxq6EhKXws/L/
 uNO0SUQtYkpSemkaoTVD6KtEvGoV9B5cKxz4XoE67smYT+GPAzqBlMTM9g5v3PiMZHOr
 HTE/WTxScElNvbJ6LMGYxDi1iw3fqJY4v0dhGbfjTdSlbEwky3e5E7obDPOxi4GyipOW
 L30OOuHS7R7wcrOWGpxx17x5kChGUnN1CZbK/nR4GprhjnPDfOGMQcRwcXtns/aEC18M
 tv5gh5Z5NYwVgHeBbS1JGYOZJyLUzvUey7IKVEESSHCQuqWrhudy6h+oQtLeh01J3193 zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rhwr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 03:30:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F3G5rY140093;
        Tue, 15 Mar 2022 03:30:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3et64tbwar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 03:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlY1NNBuatB+jO5Ys9CVRzEMykV/eWROqU41Rpks3jTzq4LgvKCLFhrc3RxyuLXTPudWX206s2j1sIepsy7bafWL7CMJoeukq9ewvirfBZWxuCkMsmCdLPnk3OraUpkxQJx+nijrEjfMSSwuAipFnMKj3UX+neRonXN5uMBAJtvOAUI1g5kmav73w5aiqjEh3Q24xSfhPa+vEPYpXLWni5sNe6c5IVSUnDrBlN9PhRefBlaHSFbi3dS2itA08Rbx6er5MSJ6l+0pHjr0HtUCa3QCUWFmguwI1yshv22Uu6Mk71v5gE50alVvEOxjqaYmaJLbv7YonNf0Mjw+lGRWKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a5HQ43DdJwdDFF5MW3vSai53rHsuxcjSslKs1gyNs0=;
 b=Stp4UGSL9nsNQgVvqfyR/vejuyAR3PmHaXJRwwaj5UogjMzEH4z2codhVfXQVt8CYW1nEJtmedhHKNvcRAB1vJ2x6eqZAHNaz/GeRc+yAlCJWlpux7W9anuMxrEDYgy5zqU+u1/cb11w9UwNUJPUiK/784Q6LRG5o4tP4nA7N8jkNnT9QQEgeAmhSk+ERpY143qlyWsoaYKZx86o/+ThRnKTCwL/WtpuYfHWQ/vsnb097M3+2nfLAH/tFsP1kgpVBZMn/Gg+KhpDT5S6vNxd1h/n+Fi1g6l5jnimoYmNx8j35Tf4wmKj6dP0GF+UpyU+qWsoEi7a1u857ITkdhHeqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a5HQ43DdJwdDFF5MW3vSai53rHsuxcjSslKs1gyNs0=;
 b=IseaJvJhg4S0s1kjY0bM2BWhsGYUeJcmHBuNARZ1KeQ/JMA5DckcG6qoIlDE7aEFwuGEzuGH3aw/SCJvZRc5JePPOi0pEUdlVb9pgurnZ5HcxBUZkaQiu9lnDffkVm8BY5JGKcfOuKVCjtNh6ao5XHXkMEhvr1beGMpznS9MSIc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3739.namprd10.prod.outlook.com (2603:10b6:5:159::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 03:30:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 03:30:30 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Remove failing soft_wwn support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k3zevug.fsf@ca-mkp.ca.oracle.com>
References: <20220310154845.11125-1-jsmart2021@gmail.com>
Date:   Mon, 14 Mar 2022 23:30:27 -0400
In-Reply-To: <20220310154845.11125-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 10 Mar 2022 07:48:45 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0010.namprd12.prod.outlook.com (2603:10b6:4:1::20)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13a97a51-7430-4c77-79bb-08da063427ef
X-MS-TrafficTypeDiagnostic: DM6PR10MB3739:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3739EBACF9303A050CD3FFCC8E109@DM6PR10MB3739.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlKPES1GsvQd7CikqIXwY7FAh3lIVphFAI9NhRiH9ypR+FwFwdQCoNz1LcL9UhiePlsimS0i9r9PYDxLOkMO+L9BZQwlDke1SOtNXHNO8sn+BDimfnRTciXlSOiGTfwVfQNfOVzBXMQSTbaKVUIv9ORQxiwebCYmqw6rjZw8Ku34fHKBq0W61Dg5bAEeDWr8kbgqdp0Pj22JNSP3/lHNGkpl8fkPJFgqcxAKOZvuIXp7BFy/imzQmO6VY5/Y18XjNBhI8q2m1mGbtU7oHunVCt3/+a3wr/GLevTB54VCOyAcNR1RQ85iqJMPxPdxPFunHjUpjDfkiekrcHhZhbUmGnYuqei8dvAn/XsoI2QimxzaWbVp6xBQpbpLaaRWa4WFHUfSAa28LAlQps6yR+DEEYUhYfHJ9btFPn9c8uDlxz7O7UsI8H2h7vAOykzNWvIUvuqLGVVcjaV3DR4rEbUFv3q9crmApIOY0NOZ7ZJ4oLiAg7Ur2jS1XJlbNyKP16CbuoMi3FhOwPZoliAi3XHtWFcDGcbx/qr2AGvihVMULi5qrZDjCMLqSbUxGgaC89FltUie2xxF0BbkLqRD25OhUBaG5zsc5wRIoUpc7tIoJBP4UGj5E8t/1F+yieBDk5oz0JnQo98lPlgFnpbYBu6w5FHbVUHSww9y/AsrKasgROKj8RjKezvt4dzRDtBqA0yE6FCPiumsHxR1CE9gAyYnJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66556008)(38100700002)(38350700002)(36916002)(52116002)(186003)(86362001)(6512007)(6666004)(6506007)(26005)(66946007)(508600001)(6916009)(316002)(2906002)(66476007)(4744005)(8936002)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?90B8B2a3xX4anLb4hRPEZ3SD5/OCUTV0WZinTnD0m2RI//tl2b0o62OjzWbH?=
 =?us-ascii?Q?PKUaBG28iwLCHztsaEJKaM9kIZh5/TGvSwpXYHyV227v6dcR9qvcd4UB8VW5?=
 =?us-ascii?Q?HUOhLqjh+WXte/CwlwHZUhJ51i0BPKQcJ0b/Lf21VXPzYLeZwEMtqeMWTsMw?=
 =?us-ascii?Q?aU9PS3cAx2YDY9vpt3n87YH/CFDRH9QCUFrOM/fPQeDmntAeTL9MHU5dG+kZ?=
 =?us-ascii?Q?wOBgI6g/9w+fK5YuMKpz8dQSSe7tUnwUQwe8tDAF1xL5U0Lh5TUfH0hH3+8A?=
 =?us-ascii?Q?0IvKSDfqddu13Dc6yCu2yWXDeGfwHQ1yyvQ7NizObb7mvFIy5wH6MvIXcWyk?=
 =?us-ascii?Q?AbVyN61cy765VahSRJ0fe5szjI2Qp+/h5ckgNrb0H6RRoRNIbkK/l8wrBmu1?=
 =?us-ascii?Q?BimfV+bOTuUqw/4pfdCBQOEjvV1UICso83G7cCcfSxz9yckUfNTxnQFyNZDc?=
 =?us-ascii?Q?XuqJojMQw3OVRlGnGNqFSQFkcbwxTpwM7QLFbCrFEEfziD3rDEG5NfS+Fnz9?=
 =?us-ascii?Q?eeUdFempKRhwmRRZdROX7X6s4vSZCYIL3tEnU+n7zkynNY8WVbenWB1taIHo?=
 =?us-ascii?Q?BTnXePJ0JsgJfr3ysCb4b1x3AgKdgLbPcUrobw1X5dGiNPxLC7ypJU/pllVU?=
 =?us-ascii?Q?+/bOnDkD5NRPjgp1bbw1kBcvPuImDe/sszDLlYZ1zCaXKOunXUpZeljW8hOY?=
 =?us-ascii?Q?ibE8g6U+J3s3RPnxK573BxEPUWcXAYjmDSoRTGWVYSsblJD3bkatCwgfwFYF?=
 =?us-ascii?Q?PZkIeIwl/Tr65ZP9a9zyCDgBtrpM2MUsktYSSkWXi+W4SN43hen3nvTZMjP+?=
 =?us-ascii?Q?MooUKMHWbnoOrnJ+VUQD6Xb0ygIJmkvIcYaKkP1Vx2lonceq2m96VML4VAJ+?=
 =?us-ascii?Q?JJgdPcRIzW2uSRL9B1sCexMZCqE8Dw8uLKWBY+LvzLWiP/mPbbnkof7hXg4C?=
 =?us-ascii?Q?N90RjDGOaEzcOd3/gzQwGVHmA92otL5zlO9SDkzupP4kuZvmwoe6bgurE/hh?=
 =?us-ascii?Q?ojH/gl8prV1eTcX/MI0QAHmsLiDNckRiHQ5uam0trZ3DwKECQaQEN56vqo6R?=
 =?us-ascii?Q?IelMFCW6uxVKjCAhNFlnwIsGy2w1kE29FUPFEUnombTHOB2acT42/5ShVD8G?=
 =?us-ascii?Q?LpCmtSuwjOZAFaDkSFZFmNPD7BJZnucqPj8eMbeQJc9x2wUt8lMztfCv/Ubz?=
 =?us-ascii?Q?3sPCTNQJYekyhc442U85ISNhsoUzb3iZbzx0DkBUffobl6vszKaqnVyEwba8?=
 =?us-ascii?Q?KY+y3xTyZ15/X5vCf6feC+why6OI4QJSWK1YfckJYxLZTqNlaZ8k9bb9NoEO?=
 =?us-ascii?Q?CghRCf1rLoNlk1Bu8SQRMKzyQGnoYrj9CFs5IYtR2JEL5kVUmxjjdWBFARht?=
 =?us-ascii?Q?AMEKmqmJxnf7RBJ9mj3SnDx4/9Lev5y+uMbGA32KVCCbLsxU5t66xsZA0N0G?=
 =?us-ascii?Q?SK9yOlxXa9z6LSI5azmGMF9fY0w+d45N6yy29egg5pECv1Z9wPe6oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a97a51-7430-4c77-79bb-08da063427ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 03:30:30.5512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVqMjlol9nEGiDqLzyDye49tgtC9UrOrIcgjzc2GhkhwOUXu/jK3uCNQTyT0BFQfBm84E/AYkSMzoZenwO/eP9AglBl4d4adaeYk3RLOL38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3739
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=880
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150019
X-Proofpoint-ORIG-GUID: 3cJGq9tjo5xAPooV2M-6ckrOqTmuzEcD
X-Proofpoint-GUID: 3cJGq9tjo5xAPooV2M-6ckrOqTmuzEcD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> The soft_wwpn/soft_wwn functionality, which allows the driver to
> modify service parameters in an attempt to override the
> adapter-assigned WWN, was originally attempted to be removed roughly 6
> yrs ago as new fabric features were being introduced that clashed with
> the implementation.  In the end, the feature was left in with the user
> being responsible if things went south.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
