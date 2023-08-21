Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43435EE49A0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 22:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjHUWMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWMI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 18:12:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ACF10E
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 15:12:06 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUSd009121;
        Mon, 21 Aug 2023 22:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=9TD4+ZmSoPSCpHtaiMRGYPujAm1TGuvNYuFj2jLiOdk=;
 b=ooVFmY9lRSZtty3W9dT53bZnhZ6reCCwGEM3amNBZbiH8TdC54l/Qqe9bU745LA4VY7T
 vZFdzvadlWOjvmUcN66FdAH3OL3+of4tL69SW/q1Jv2JKTvsInXJinRMnJ26qjVAGr0P
 2JDwQCIaLJDghFfFHxAXCDLwupkzeMXpvKOu4zlnCFlvWyJZ0nVX+2MZunQf5kS9Axz1
 QIsvS2rqczYeP1S3zrc6pKuV1Fdznvjuk3Y32esoi71psbLihVirn1fKIZxBerk7rwxF
 G9f/vHDEjWxZObNgYXSktwI+19eP9yJNti4DaZTYZ2srBHI0Vtr17G6LiBd591Y+CDl+ /A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjm5dv27g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:12:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LLQHvu018688;
        Mon, 21 Aug 2023 22:12:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm64hx8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCEiNp5RQBMPlS1KYxDgTE9O8ByMIBYiY1LTWMuXxUEj2bljcpacH1ZQC4/HXjQpvUhw0tA0cyX/wtqMadxWjvuhezO4Ml8ttsmeln/cj/sSFa9nqn02xtaVHwhEH/2YEMHVJGg3GJHo9P3LRP0WBS8loyjQ2ONxWXM/eiSceSfiLl7pKVPqovpjHJEmVJOUP0HHSvEkAUEDk6Cy0/VrNBgtk7AqoGGDn1BjyCa6YW05ChQstbqKnRpCWiFXGFLKBvQRREBhNxHNM9XMdpbutsCX5pANcGV9Q3XFFKTNGutzuUOErV8KITkjwIKk9zLKpkq7VJb33zqg4l7W2HsyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TD4+ZmSoPSCpHtaiMRGYPujAm1TGuvNYuFj2jLiOdk=;
 b=l6IZ05N4ePwzLEEnU3FqH911p5ASdPZD67FUxJBYcLpjvdcIgdLc1OiyQr2KLEaz8V5Lztad/1+DdibqBEI6ZKa75E00eDQbQCASAqdhGty5i45VBpHx2GUB5rQovsPA3IR/U8TVAB8NkZBcPzktZCaVYsqzqtzB0pgT+YYD8ZXCIDR1xKGWpCzlu0fYFCMUPGjc/4BBEQysyk+YBVWrC/Xo/EmSq7BNieDbofYll3CqxxzPCCXGgB1ttrhlmHd0HBfEP6Vsa+ney3p+2fVz8Tlv9rTJdOViWU1fJrkrYhbOYRSzijJb5iEYz3+96fAwHnzc3R8BFINKdeP1cAKB2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TD4+ZmSoPSCpHtaiMRGYPujAm1TGuvNYuFj2jLiOdk=;
 b=FQdAbIaebT46VVflLv2x03hXRGRR3PPYnBNV760o6g2LWul1OQz72w2aWB0DSSsF4ngZJAlEfKJe8Ppsw6PDvSmzhyQkyKufDZR3muoEzZkWOFBcafmSFx2qROUD1qHrSUYvLQ3ARe5Z/foCK/WimEg9m+9js4xN/mNATLtnoZ8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 22:12:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 22:12:00 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        <loberman@redhat.com>
Subject: Re: [PATCH v2 0/2] qla2xxx: allow 32 bytes CDB
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyzg59ls.fsf@ca-mkp.ca.oracle.com>
References: <20230817063132.21900-1-njavali@marvell.com>
Date:   Mon, 21 Aug 2023 18:11:58 -0400
In-Reply-To: <20230817063132.21900-1-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 17 Aug 2023 12:01:30 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eabbd7c-fa5b-4f38-0c2b-08dba293a451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPxKqORdYwbCiTHKKynCng1E81nCnHa76fFrsRJsMXvBDu4XPzABRqd1guZcxH6LbOXGPTxqaoaNsIhnc9Rcrb+vUoXTTay5g51NZ+KXZr4a6iBlWqEAManMnCJP786e1tPCFwfD/SymRMeYgasj8UmnhOzE06T7puQFnt+bSXpZ/X0Vd/igwx9kpiKwlg+yBrVBN3BJ27xsqVB0bo3S4Q0ae2sO3fyMik5FEEKlIeM/svvdSYDQubufW+RdLZAEQYbZ2pCWOkw7QLhDHzdQeYtdCw1+8VaO/RuZX24TJYzs+rWKDAXrv670hLvE4RkyTulaBbm4UgAx1JJY88aasM/byKxlP+WGSb8jylBgIAAFWWzoQPlAMzkjmASgdkSIOQ/TeweXn/0nziCOajLY3UwOvP4KWqjJVSJYia7PSl48LyE2qpbyiN3QDbCzUl+KwOvNnIKHxlJ2u/ZfjCn1MTAZ/OeSFBMMfg6VHZab3ULdwWVNPjKQVJGH6LpWb9i57wVk7inrgj0l6RFBCnDrjZwLFsAT4rvqTC2u1S6l2odfzCFItB2bMTW0Qt2nwqmh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(6512007)(66946007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/p6KyZh2JXTSszvO5q/qGQV3E251lOrd+z8yAME6h5RnXoPtoj5ZIBxNQYDC?=
 =?us-ascii?Q?87HmiVj6pgpYejndRNS1mMf5VS5djIirL0hhv80MWd8206/u13toSsIMvX81?=
 =?us-ascii?Q?vHirSJyfQqkeo1w4y//kclisMKTfDAZrj0S1UJs6AZW8lfEg2DREhsCRbyHU?=
 =?us-ascii?Q?9xH44oSl9nJWpXoMZYaVlebK2PFsHyixjD7NVlL5RiGYGVq9Mf0mLZJuyxix?=
 =?us-ascii?Q?yOxEocSHJzdrwJrQ8S6GVPMRESqVLgIHhyGl+6WAsViX2ywWy3J8OXPvV+i8?=
 =?us-ascii?Q?itd7Wgj4UnTH1rRkC+QANTVyg7yODpiYTd/D3usM7zdL8eEd+YPmwbpeMA/B?=
 =?us-ascii?Q?Wg2HQxJFTatg9ptXT8NYQ47TGqHQSB4ySxxOzQWlsbBSMcYRUpHHMIda3Nx+?=
 =?us-ascii?Q?GoXwwYkJb+AAd7HsOIO/ey0MN/P2YpTr4E8gHLNkJpisejIaj2SF/I4aC4vV?=
 =?us-ascii?Q?zo6nOMLgvqSPSymkQ6rBf4QlWW8aAIWwEZEaG7LzW+1FOw+DfcCQvbaxtOL8?=
 =?us-ascii?Q?sYRHffUEawdPWf7IJyqaR/zOxK/eLz6f7mwiMGPpA0zVhPjTkxufKNj6axIP?=
 =?us-ascii?Q?QLaleYLTnsw/neJQOpgL8f3QVQDYqNBjBf4iZ2mjKyikr5lUjjNUAiOEkeyO?=
 =?us-ascii?Q?cUD5YmEyeKTA2/j+bY6yAMeQUmXdXSVj6zfocJZETFnRbUSmdpP51Fz0cANC?=
 =?us-ascii?Q?HR3voODtYtoJKVEeall500fVVGX3A+MRax4aSP1EdWLFezL34IDVPtSEBRTF?=
 =?us-ascii?Q?Of4L58WGoNRzX+5OTN79yq/FY1QbbZPgq4j2bFg6qRK6qlopE+c3ICbgYILh?=
 =?us-ascii?Q?GdqRY0rLb42VHzVDZPIgY2G4iaauNvRKdPdbrG4ZWL155iPd0BmR91iBJX5R?=
 =?us-ascii?Q?DMZPJ8AmosdrB2yIoCbwnvKgyb6EeDlRD6JlWltbhXGSQDLjFZt/V9Do38sY?=
 =?us-ascii?Q?m2pumypX+s4TNjWEsipEtO2bqg4op2xAjFgHOGS+RvscZPQlthnzJHHj9a+V?=
 =?us-ascii?Q?cfSPS9lF+RI/AZ0y3ZgMD368s00khPFIwWABBM8jfPOTSZ+wVD6PNm2H7GRr?=
 =?us-ascii?Q?32Htcv4/yBji7ukQQIUdXmYDcLgN81pkfcsincaLw1cbvFasZFw5/RXJzpaQ?=
 =?us-ascii?Q?msWjXBVzMv3hYUJ0zn80HbIh7jZ2YgT7HkZgJI2zxzt6OqlNcdNVJS1UgAQi?=
 =?us-ascii?Q?cI5qPCOCjkH0Pe3/rKWc/pu5a+d7f6Dx8qqfcTop7wXd6uI2EuOh/E2q211z?=
 =?us-ascii?Q?t1m/st8jCa7Qv1SZnuvfYyHrukpozHNFz65l8douwQbf455dRvqjtuBWeDlI?=
 =?us-ascii?Q?BkMmRBhDmAYtaHcqGnwbz+3BliM3qptH8UOJwYJoPNObnCkjIj+A7GDRttfW?=
 =?us-ascii?Q?gHkzgVUQg4LoZoxLeCGkLpTN4jWynxESZ99cc5S4O8+dsFQCbiIIjj+NyttU?=
 =?us-ascii?Q?3fj23QGmTM2ewPDtlcP0sQJ9LTVkuHXclxECjZ1+4ceFOvtZs6kLo4qyf8D8?=
 =?us-ascii?Q?KDdhHN2ibnzCnhQIB99NbiL6oDljXulwMQNrjYwgHn5t8qmC65tFysKVtX54?=
 =?us-ascii?Q?XYnONgpw/miE7Ud7RswoxCWbO4ELYjw7qQM1pX1ovkVpGKtSawtNs6bthZDP?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4D3OZA1wc1z+vipgGF+i4n/2Rv76atb9NmUNQ9gfmWqL6xbe45vKXHjAH3d1OVoQGaz0pVZEP1E2nUm/9cR3uLhqJZnU0FjRDzIjUeg4Gh4CLIJHT6FLVM+GV6uzAZf13w2im56J7JqSfd6UNlro1onbRu+b3T3MnSBGe41uJ7TDPJdYjQKx31sCDLsxMlKbGWS7uGD5HcIYH6N4VNt6zGSlyK5V0WaIcfcrnyDlhiKCXpprPvH7CDLEKmv0v58RIVO2dtiu3g88T4mCgcTLx7T2k5cuWDyDwj2Rm7RSVKjzdYyTFzGzu0L+7UTeY/wLK5yZjoh81UCGP3VRRf007WpFqpKav3seUEyX0+LUNgjUagzfZFeT9BQQChwSBUicwdBii4UPsNyHK7TW3uWnI2UvpzBsLXt23R4nYUT8qqndPCP/w7nRtNniMO7nRtEv3U6j6HvVc5z9BWWqX1V3nQ+IUqjjhqQV0wYsUTvQxak4j9Tt41NrAf0emCJW8+9hoR31b8RyZoNE2WBkTQ16nQbLssCLmThkl1nKImnpR7wUHY2KRSP4qfjlFB31Dn0YfNaymTXci9NDC/EICXiwSkXqX3G9nq21KJhA5HhXGP1pzo1CSMGKLrzIGxqXuFI0OIfm/reg1SZFf9eU5OSMU9WdWnDFgg56bQ8SSBAwaKwbFmnwtCdF1yxcNQ6G+pO0Zpst/XJW029R1eFWoXZrTs+6gAZHGMJyxXCEHLxKvdYt/iyi60szaKiLUIu4PE/I8ASL/zhEc9JV4SWay8F783HL0ishZ+YV5OuvsjsyjS32Uy85vpwrNyvKcyvCFwZGtgykjmbM0jq4DZQVXsljhQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eabbd7c-fa5b-4f38-0c2b-08dba293a451
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 22:12:00.4965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9I5Kp87wfnKrxNE1iHPNUfTl4kKWrO8T7orggGxtgu7v98djVOnTSZetv/f9iEpUB1WBhnXGFo/UQ5qIjjiyqGI95E+ROy2+2/O3KK09DvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=647 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210204
X-Proofpoint-ORIG-GUID: seV4poLtLjXfe0Wb0ZA1rzJUfCAr7tVR
X-Proofpoint-GUID: seV4poLtLjXfe0Wb0ZA1rzJUfCAr7tVR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fix, allowing 32 bytes CDB, to the
> scsi tree at your earliest convenience.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
