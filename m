Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A27CC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 04:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiFHE0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 00:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiFHEZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 00:25:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C9368901
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 18:51:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257NfEEv027448;
        Wed, 8 Jun 2022 01:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kdUEwchCguVjEJj3/Rb7q/PfzupXx06XOJdGMsNSNbc=;
 b=qAtV8D6V0V2kGDBsXJxMVdajxtr3Zat4aMStNVODwd9P3xNoNI7jmJfEuP3lKnPNWEE0
 LFUr9g0LGd2KnfRFcuewmYTxLIijDh0jXSAre4ycXzBI/NgN9m5jUZiKyhjl5MLnsRAw
 bgXgbyfL+wHWVSKqN2AJHX7TgvKYl9PQV7sKHZ9fK1V+3sGGkzHe0q6AFFCZJezLbSKT
 2AxPBhaPtruuZyg6STbVk5zPzrSAcqTw11V7uPLpJyDEWJDJX5YSeoq1NWi8zDOdzTeM
 gSRoHN0f01Cypvp+ztJ1suu7DMzYMhRWiX/U3nzA8/PonBvIdWTHZTB0VPMPa4hNN3Dt 6Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqq52t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 01:51:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2581eYlu031489;
        Wed, 8 Jun 2022 01:51:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33n25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 01:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgY+ies3FG6+pTV4On+bLUsWdr/viCgyBydpfE9utUqGMx5eIMeFriJX7cy7O0hPKjDS06UC/eq0+DGC0C+PmXzFaZp8haOZYgYA3v9y3HKX7UWSKMoEffa6LpO7j87cEn3Fl4yqFt87D6Sq1VTyClVtEST8AC2sLacmGmY1EouYFJUkk+L5XLEgPlOBR/4TD9Al+BGxjULJKvo1zB+vIv0ff6CC+w1nLqKYoJemOlbui2plHXOq0IVx1iV/ysfH2knlDez22Br/woi+uxe+yYLyA1xb9fCwhRJhGC5vYGjht6ydRrIj6zkeKQSBkTMMn02u35unigxa56b3NbdmfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdUEwchCguVjEJj3/Rb7q/PfzupXx06XOJdGMsNSNbc=;
 b=MT9SwrCKvMPQLSXHypPt5pJuh95tXIUxKqa80Asf00xJamowkggBaqKeCt3tNu1qClwXyo/VSmKJYFuRW+ElGd+avYzUrPT+DvjA6CIZN7L1KNz+aTdDGgvdrbtYWyMGdBjC6FYFK8bjxVzm8JsBqP903lfxPaRXV5Jjdx5+zK8jAguxjRNWCl3fhwUeuxuK2jmUMnp7/V34lkfC2uHZCAmqU09U0u4nIKD62CShGhm/QntJMXfKQZK8n/OJzzjDl/jVOCj/iOQW9GlqOm7WFFDZq6FO/5JXjxBQJY0YebDH+U4uGB7SqcVC2IA6LLmKVQgJnWtY/PQ9tZY7nxGuqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdUEwchCguVjEJj3/Rb7q/PfzupXx06XOJdGMsNSNbc=;
 b=FjOQaD2/z+pnmMr3Nv4DwULoq7UW2OsyRP8dWgKSRhIrWugg0ND8AHe4pksCd8bVAW7OMhgIz0FZP71A+/5HdWAAHFiVVnS22NAWWcF/IuEHeVsXT2NTtjORirPvggIqZEZ3DA1qKXUu9g7R7CjiQ9E8TNNKudgfF16Rybxf7rA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1329.namprd10.prod.outlook.com (2603:10b6:404:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 01:51:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 01:51:12 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/11] Misc EDiF bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d5rzzws.fsf@ca-mkp.ca.oracle.com>
References: <20220607044627.19563-1-njavali@marvell.com>
Date:   Tue, 07 Jun 2022 21:51:09 -0400
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 6 Jun 2022 21:46:16 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:806:d2::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0e0797d-3725-45fe-e502-08da48f15d9f
X-MS-TrafficTypeDiagnostic: BN6PR10MB1329:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1329F6010C044FC0E0DFB4468EA49@BN6PR10MB1329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hFhhPHSEalDSFbmtqsOqHVO/RLDe/BYsfunKQJpz7vn9npExRfH8ZuobNOmKWU2TQRCHbhQ07l/4Y7nmTIAzVUWguoINHggAZI/V1oqRMA+djyiVRs1zsZhtv1bcokMTtFnN/Z7u7pRWA0+JM55XEdWV/TfiH+pTmbEU1qZQXYkirj9xb/agtFrIJFjsJLCvBkhl4Wjj59sjn8wcLnoFRcM8Glr/jLnq5dW10qvOhww4mcyeSuzIyJ+uqp3MZUFdJXSt0h4S+HDrkw/EiGVqM7HahgTXxhUzlyrxtYDkY6aoM7J7UnsgKBwONGBUX4wAUEHgp5tCzW7akOuSMWuH7mWMuKmQzi8Gcogw6w1wRsz5Hc8XyRkwoZ4MoSMtSyc85w3/bWv6Sn74bGfKJynnphS87rN3UCpqjc+44qYxoEGB8wTGMrnLGwMCpKeO+rC/PUUlfDl6tFPCD7ki1336AZooAKxXD+IBHBpBL6fBWa59ft6PaWP1+lT32maArUfe6khigpRdAbuGukHR494Qu1b6zSxVWme/A0Aql+OVDjE/pCOAhgQOvPub/VHW8pn+WEO61UqE8ZuwU0XsCu0tnonsLSftoi+Nms5Uh5qiIFkksLuVGZmjWxYmhvIKWGG41unNqtZNtR4jLipvtT0J/xzwrNeb54JNIRVH6K9Dm1I6bgWBgwx6UFYWmJIdgy6NaYMyRk9/y1o/WB0c0qH4dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(186003)(5660300002)(558084003)(26005)(316002)(6512007)(38100700002)(38350700002)(52116002)(54906003)(36916002)(8936002)(6666004)(66556008)(66476007)(6506007)(66946007)(86362001)(508600001)(4326008)(8676002)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4SrYZ9BhOynuVuJxJ91ITs2JiHOzMh49rKNWvfnd/7Y5IlCG1mUb7ZLrTAG?=
 =?us-ascii?Q?zVJcjULwvPxCo+k0CIOJO8P2Sio1XHNt8uSCz4y6szxdrkf2t29CFGVSfDNC?=
 =?us-ascii?Q?kWiWSqnRaeKi+NwPeuFn/zb44FgrUEdzoEOMlGzhnzlObGGtCnvcc1WALm7b?=
 =?us-ascii?Q?rXxYWHB/w+PVN7EKj2vE1SD93LFHSjsAlR/PbO4Wotxgec+N7iVgf7yBRfjO?=
 =?us-ascii?Q?0rw1kur+/JUzboyeZWnPDIorZri+U2jBoFWpQnLsUNNqB2B7E1uTSCHMEBQP?=
 =?us-ascii?Q?0EiGZmL3p6ILKnATzw11NwgFR6R38khLllU/uq6RzxeWa7ioF/S2WmmGHnTw?=
 =?us-ascii?Q?XtHRyp3oTDGPqXpuEdxgGTIlPdih5BcNXZ8GxPC3F0wwUaYscfrK9r99RHYN?=
 =?us-ascii?Q?wEpJKnOvz0kqDmOI4LDdTBQaj+3hUexZhvUY6EQvQ1pMu5ZkawTMfZBRxZVH?=
 =?us-ascii?Q?dCaOGtY6sBwl63wDW4XrxU0BJWfct/ZR3uuDXtTnfN2KAIYciaNW3paWExLH?=
 =?us-ascii?Q?6GfxiXN2cVMy1etm9zUtO7i+VJfdnJTR9+AzANxj5tf+Hk1jFyhNkGyjUs7Q?=
 =?us-ascii?Q?B2R6Z5OrUDHzQq5Jq4wZD7ixqn3h238U+Cozz7w9zQtq7tFN5pcw6CJHQOW2?=
 =?us-ascii?Q?a0rHGR84R2ZVcn1rZ5Uh0ZWwCdc914gDb2s2bYdzWcePuOCuuV4/01BidJHh?=
 =?us-ascii?Q?fM8QLqunNjKQQdDqN5Jy/2s6fS+gmSODC6zH8i89fSOrP2WlDVpUrMj/l6iF?=
 =?us-ascii?Q?zz9E1jNTmvWDAdKboV4lU/MKDPhIJN5N4AeEPU5DjPVYqs91eqBoJ2eQ/swG?=
 =?us-ascii?Q?Hw8DRYTIbOqE2cqC+e1RJPb8nj7ij825NDk6docIkEaj2lvR5Je6r9rjmaib?=
 =?us-ascii?Q?KOOUgRaSSuRnHqu1S7Y9KW/DhF0Jq+58Xvy1/VoiqBjyPIkxoJKjQT/yiVoE?=
 =?us-ascii?Q?xH+dtrmy8etmO9nM2Bb7hXqhwMyjhn8cTIiZjhQ2u3Xw1V431upSVA0JUStK?=
 =?us-ascii?Q?VlWu7XvDQNEiJD+40MJ+4kkBjrvtnRtY4Nmhp6k8Dtjm+W0iApjjztZWeygj?=
 =?us-ascii?Q?VnYE1w+wChCmAxzX+YEKZ04ojCY7BVEdHHod21ZLsJXuHMnOAqLacP5qLiEK?=
 =?us-ascii?Q?3xdiTjit5PUzC8+VDOQ4EoAnXcbl0XE7KovWf7V7lknbs1H1RUpiA/3kRVaj?=
 =?us-ascii?Q?fcEURJWNCLdTZYClpaw9MstPWMFMUDd6nu/Yq2Oc3kZIvuPMoBnj5ZGsM/39?=
 =?us-ascii?Q?7Y+z+fAsUc33Db8DDeYbhOF9ST4ZFL6h1RVjhi/suwxAC2sn0UkFA/9BeZo+?=
 =?us-ascii?Q?VcczOO3PX6zHDKHZQUAFxcRjV0kxEKfKLW1pnXArMC8n00/gbuapRVsURwsl?=
 =?us-ascii?Q?pluypsMT4Ng186tG9Ujx8Gq8BT/0D8kkNtg1PoiZie41Q6FXg35d/no1UfPC?=
 =?us-ascii?Q?yvN/0qOYIa24mPaY+SaA17WjcIGlvQX78jZRrKGaUA+CoQsE6WgXIWifMdAt?=
 =?us-ascii?Q?gBikpWNy07of9IcfGg/PFE7TcT9EfN5frV08iL5uXO7AG1Gyj3k0JbCVD0Lu?=
 =?us-ascii?Q?TCYjxwgW0CiuU97bbDaPEGV3qB5/z6cPASDS8ZNYepB/NOBgljJGPMw5hH6P?=
 =?us-ascii?Q?7TLpUIeGkCbOIUnypntSDhu8tOTwM7cw0G9nuF/tYTrhtT7N9cctKWZt0Hdu?=
 =?us-ascii?Q?bU6iOYM92ZOgGqSH+LNogvEyHmx16VGA4oO3/KEjyRf4Fo4R0LAeVVs7Sz0N?=
 =?us-ascii?Q?jBBKIDxh/nC+shNW5KTG5oZYSwkFR7Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e0797d-3725-45fe-e502-08da48f15d9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 01:51:12.6256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQMlgYdzYWi1eY5FU9a3W/4e9f5emGfIspH0OcRqKjJnZQbiRq/t+zmczK1yZ5HNMFCiB7+TZfqmuI5IgcXOaDevT/rvwp6FfzuK1qvR7nM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_11:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=791 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080006
X-Proofpoint-GUID: Rb8awQXxlfykRZauG7dQxP9mRaN80Wof
X-Proofpoint-ORIG-GUID: Rb8awQXxlfykRZauG7dQxP9mRaN80Wof
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver misc EDiF bug fixes to the scsi tree
> at your earliest convenience.

Applied to Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
