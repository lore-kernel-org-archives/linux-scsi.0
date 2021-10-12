Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCB8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32B860EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJLRCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:02:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30972 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhJLRCV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 13:02:21 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CGoPp1013002;
        Tue, 12 Oct 2021 17:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iyW/b+jywM+4F9FrmlQS1PyUuJS269FaxptPbOUkdDQ=;
 b=dYmDg5OjWAiQ4eCGQxu0A+KrkaZBpTL4+xdXVs/G5XAdwpJ8H1Yu30qlVoi1SaD2RBUW
 EA1QSttkYmf03tw6S0HCs8+ZCFHpcW6iEnY6Ki5V8KwsqgimuLTyFVX8QN2YT8UJwI5v
 GGxmj6IsxCizMHUGF8oTJE/wJQA41b/OnwdmBrPWXdtlqDPvwGcrsPE9H4MGQ4lxr8t2
 mrRr35CZQnV9KiapP5Pr9LVMx6sr6SseszOu4BPY31Sl0hxYUyLHOz4HAQ6PlKhJ4/dX
 IK114lUjr1PnIMQ7jd9qodKFOtkxV550bD2pnXWksP4aV7hIUZFEbgkKiSBZrrrw8OYm Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmpwn9pvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:00:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CGp6Pg100448;
        Tue, 12 Oct 2021 17:00:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 3bkyv97ucr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CldBx2wM0NXir28O77JxFN8BN9ppZtKvzNjCJmvI44q+mM6RPwEHCV10MXNE4HtTKGX1ELx+s3b7rBXzeVmC2wL/X4E5V0fLAAGICaPuwvLQi/K6U9LZBwFU0/qboK9MQAkeREWIRMBqEUx3u8fmLblQQjYu8mtfzFZE3BfsSq/oypP1hMlY6WP8BNu97ScGm0HbkiNDWiSAy7WyiNxP+BdKLkUUQ9Bej+viO/N41mrJ96jQx1XGtKc3vUY/5AjQsoRhlIKfOtoTpvaD2gUMwClo546BskYq00TfknDw2RFkNcGdj4K9Eq4OUn/D0NUXNAqa6EcBlUlzefwykttlXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyW/b+jywM+4F9FrmlQS1PyUuJS269FaxptPbOUkdDQ=;
 b=Yn7Mk+vRqcJwxoSQsHdaD5FuRy5jjMX8KIyv2yY7i24tG8jbc6tE+ZyinxMYa41PfKspVi75hX91pyjRS2nA85hVDFRixxiVnZZh5mdVyuSauX0Hnnt8GvvuYWP1+dY7yNXOU8PVC+k7BU8MeYGOghrdFMA5vzocISzPR1CVn9Kp05d4sXQHxlCIDWkGILk2agt9bFvL3+ymWdctP/EWUumxRcgSxzalSj298FvzuW2pm6jCqruyYohH1i4mkedU9OqgH8QtcrJHDGB8csvGzl5sOMKCg9KhfWCBKxp6ZSS1x0cjkly0jIvALUQaA8AtRnEfqkiW8RhlBOchuGrekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyW/b+jywM+4F9FrmlQS1PyUuJS269FaxptPbOUkdDQ=;
 b=RzT2rNEM41k5tvd+LgL2HbQ/t572s3qlUgoIGDWeZ+k3I6sNvrnNIcgkQBeVIFCO2dGTjcsc7YrOB29wmLuMN30Re7kV1wjzTySe+0yqH2EyDt3YDVQ84XcyYdSyrVl/4xk5Jul3N0mEeQG18Q5kYeXzKQZ9Q4Pn/6QOGTVL+HU=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 17:00:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 17:00:08 +0000
To:     Ye Bin <yebin10@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Fix out-of-bound read in resp_readcap16 and
 resp_report_tgtpgs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0iiqivg.fsf@ca-mkp.ca.oracle.com>
References: <20211009075231.2489878-1-yebin10@huawei.com>
Date:   Tue, 12 Oct 2021 13:00:06 -0400
In-Reply-To: <20211009075231.2489878-1-yebin10@huawei.com> (Ye Bin's message
        of "Sat, 9 Oct 2021 15:52:29 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0132.namprd05.prod.outlook.com
 (2603:10b6:803:42::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.24) by SN4PR0501CA0132.namprd05.prod.outlook.com (2603:10b6:803:42::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Tue, 12 Oct 2021 17:00:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5f472be-dd71-4e32-0911-08d98da1bf01
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55301BF36882B7578AC613D58EB69@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1l8LuSowG5CWRi/AIxUSxnNBrMvTbFKZVDllOKLnW9x5PNHUZXW6NdUX4QmuN9XY8YIGFFA+4wXjfcM209xS4vWnfBX7IN7adbcByLyGrBGy5LF09hGXaxQFDa5A6il3n+xbkclT3yUQfM23i3A5e3ixIpmTU2RSWgHDKEAVx/pCbZ0ZtLFOGmfX68C3VRwTXlo4DxZ8H0KdseIMxNx/gqAIfz+WmemoFZkNMN4cz2EE2E8OrVik+ixqShH8QS4mgSQwq33xkt3JgdVJ8qbDjAdxvnjpajEVOp2t++iTgjI4BqgmW9XA5eaDrchjil/h2XrRn21A26V2x6v65OI3SeKbjzFZ1NWw06lVAF79J5Net3Pj5sMJ59ysWrwQmznSbURPFnk3hUdLFmzO9f/vCuSHU8ARH2Adx6gassvVkS/atpM5mTAXKPGXHC5+SO6o9huWYhbHFOE42wSb76vUKYFr1YRQGgpN25FSogMhGq4Nd7o487lLn16uTsaoYOJFbEAlheFkVrrwg2h1E7wTxhgIuTCfk8bwzT+RI6rz/myvgxOqmUgCABSGxHL7fAHDIUOMBRdtGPX60Ph9sBeHVnzUVmXKjNOW+AdY3MgJlINHDBU2fJPtcsEw9+S5D2UlRUpVAXHo+NJucLkLlOVjvkDZZ2wbIyzDuSwAYBjaA/qb0HQkwrcw6MVgcPgmu4XFX1k4XGdwVnnRkn+onDuB2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(86362001)(8936002)(956004)(7696005)(52116002)(5660300002)(316002)(26005)(54906003)(2906002)(55016002)(66476007)(186003)(8676002)(508600001)(38350700002)(38100700002)(66946007)(4326008)(6916009)(66556008)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rjPjr9SY4AoDonN0PKJzpWfiVVuIDKetzuT4hOIpsQQqlx9JcyFskv+U2c2b?=
 =?us-ascii?Q?S0TVfNpoXYSFxFFOucuGW2lE3BNI0TgUhJDBkCbEo1aL5x50Qm/Q5sLHFWue?=
 =?us-ascii?Q?9wEJX+K3hvL5TURxh2dgf7IJopgZqUTP7+Bb8ai65lCJMtidjwo6lJgR1pMd?=
 =?us-ascii?Q?VZWAk573xRg7ylZbt2HE6P77uCs6DKhMOMRkbxppfVNjh/v5kMd/ugMIttoB?=
 =?us-ascii?Q?LMBZ9yDuiz4uixq+QiLhM1sF1k2UZ+XvNK4E1UQpA5YYMBBOcTDA2CInZ7Yw?=
 =?us-ascii?Q?Y28jNi4vYsjIuMHLzq5MPocR8QUwpNrxdqc4f9vT4DC1feaIKYK7iP23EBAJ?=
 =?us-ascii?Q?L0QCxLacF3znLDIacYAxzZcgKkURQEQSNbsipgWJHt4mAcMpNtVF+GxTbkfB?=
 =?us-ascii?Q?cMBfAMTRzqNDT+LJtGEq5EQTUotXGd1my369RSRiFSkr6Uh0PGjK+dFjmnR4?=
 =?us-ascii?Q?CLFUJMZnV+yIxEtE+1LOJhs3WuaJWUBIta+GulCnMdOHPkpv9u+hnBFN8Dl/?=
 =?us-ascii?Q?2klDKanxITIrTRE7BQ8Zd+PNwexn7D9v/usjaqaLgO9tlHY727KXHdSpLma6?=
 =?us-ascii?Q?q90mugVigBLxdgGctYAStDySpGYS8RnNQH0UvPTupAeZM8g2yJ183fMTXKVD?=
 =?us-ascii?Q?APvGMIKjEyxxLHa6fEzv19KYCvDM5O5BE+aTNhFJLjkYigZcCcKT9SuVbFnT?=
 =?us-ascii?Q?AZmwda3m0rDCWGqiZnH6dY/6qEELNyKTChOqn6vqbm0br4iilr2ha5Rratny?=
 =?us-ascii?Q?qPDlhuBrnwhbxjljGtzVipoXCsBc/8N4YU/IL4oDaM2ljt/hVTlmHjq7wmJW?=
 =?us-ascii?Q?vQwdU76+aRRkvcl/oq5ItqMyLAxzw28lcznYPDqtPqC0C47aKyiFHjCTjWMP?=
 =?us-ascii?Q?PE3xV/o4aLZTEjQGrRRH+LsVqpxkNTPSQoE7shHhzO4QrbNeUKKGuOiSj8AV?=
 =?us-ascii?Q?s/YJtVNcTfXdsLxbyuse13h0MNmrZxdTs7RfFvSaVEaioI80ZTLC4Z2BVGxl?=
 =?us-ascii?Q?lpst1eTx2Q3VV/lr2VOxK3iZgwUwGspwP4NMZcS1N2O5aQ1tzJLEjjFX+p7a?=
 =?us-ascii?Q?gSClaJeDHgSGaubZXy1WHgQkwDQmSwe+rvmu0NV7paU1rfbjyFIi6SpO6Q31?=
 =?us-ascii?Q?+iOQWaIaNe4CVhbh8E21CraoX63Va58chK/3ZwzKFyOVoNhFBYHm3ZTwEBfc?=
 =?us-ascii?Q?oyKPT6iyXJ6UjYuVnuVnXnz/0I2FSfYhlZusRGlTozpzq6U6KqjLqCDL6NXW?=
 =?us-ascii?Q?WZgIbxZWgIhXg6mUb2FV+r2ejWWs6WqLcttIhfnFcffkz0Y+5UD2UL+EsT8A?=
 =?us-ascii?Q?Jo8GZ9A4A2p6LuSz5Np+SaK4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f472be-dd71-4e32-0911-08d98da1bf01
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:00:08.4956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SiScMAlJBPXkfcAM2CXlVFZNKruTKbdpFex1LId0dLqYo0rrzmbJN7r7yLyAT6LbdMtFAj8WLx1uxDorPeBR5LFpsM7hBh44A7K3gIjqsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120093
X-Proofpoint-GUID: LB6QtV9f-1QKuSz6Evq1aoKG_1iemU84
X-Proofpoint-ORIG-GUID: LB6QtV9f-1QKuSz6Evq1aoKG_1iemU84
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

>   scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
>   scsi:scsi_debug: Fix out-of-bound read in resp_report_tgtpgs

Please CC: Doug Gilbert on scsi_debug patches.

-- 
Martin K. Petersen	Oracle Linux Engineering
