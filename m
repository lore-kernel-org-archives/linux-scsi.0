Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2C2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbiEKC3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiEKC3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:29:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DAF219374
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:29:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ALbi6n007656;
        Wed, 11 May 2022 02:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=E2asmunr1M+LpENb/SImj84OMdKE8cw713ysl4T+8cQ=;
 b=AtrZLfaBJfxnBbQej1vSfD91jmn6vKyLN6fZ9LAAulJWYDbKtTbcLaNekjSxHQRKkXjG
 krCYHk2Cdog84wZjZrOVoqRUR51X6RiDCkd54XFm40APJbuzIvt/FuC+Id4ScZmn5Cy6
 EnWrqVvVBu0YedYjtitAjfpuokhxfNdgFU7uUDVfO71e9ZNNSQCXl+HOJU2Lvwvh5/Y6
 sd1+jXNGOZ+O1y8HdjJgO1TdKt8jc9oGxQYG9sddZJUuB8sfRzka63cEZCs4yBhllQ9P
 irArr0jOjqo6QdYyEzCRyf4bgOFbCDEKi1evAzmj9DQHQgTl+sRYtXjkuO09BkAKtLr+ 1A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgn9r344-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2LPpH006292;
        Wed, 11 May 2022 02:29:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf731m31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNOTXqcMfA/zF6DG1LQpme6yDvig0HIi1xH+5tDHDGB/jEbSOTTrxt6ftgzRouZ7br7AI97M7SYLmWtKbctKFytwtp+Y4fZ55zfTUTc9qT74cjNWWtqq+W1PMAVJF0Tr7pvsQ64+tXfoa+lHISz3MPOCwnZjD9y5QA+WvKk4jdAm+k2Kh6zhur6mHo1CWq2J+Q8tUYK06Potra3EQNkjQsRw32DcbX6ODN+f/HTmlkIrbICqVmmuwVHsw7+mfkMzkSgCIH/GADSHYO/2RdE3y8/kHKv8VZ9z/CsBfujrMemg6CkiD5+1xdvffRhrq5z4AqqJbh4vhXG/6F146Lf6UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2asmunr1M+LpENb/SImj84OMdKE8cw713ysl4T+8cQ=;
 b=jC/7mimvdEIu/6r9fRORX0y36J2jG5zENFCTBMtjOaflH3QlCyhstrqRYEsVsE5NMDgP8kffEw7vVvDuKcxvOnieaFmvh9pZhxvFoG4hnyFZtfZQe2Ydl3QuhGHAYLEcYDy1GaPkyj54pNDGuJC8eBFUpUlnJtFCKf0oRCu5qpCtIbCnFNw/YPVMJF5raYxpnkVXCoPQUtTXHkVYuabBeNX7sbqztqKdezB9tHbjZU0iIqK6Nc6jHZrxZdkhmE661WYg34JIKt318vPWOQyupP06TBwjZr9Qm4X/avCcPMrp4iBpI/8JB3J8TQAxqBmqUYTMelfJ2AEOZJ5l4xkY+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2asmunr1M+LpENb/SImj84OMdKE8cw713ysl4T+8cQ=;
 b=YtcJ0uUZg+zbQAfbXS+2MxOffg1ERZSmXwhg34jocT4GcC+G1sKgZONzymimysM1+D0aFw/UW8//ebPACi3/OTKp3sGFGRLV9BarZWaD74Q234CzS4Lg0JXvUyhYT/kM6G6nIrKilh1uJODFOcm0DyOnjyqqi8V+GOP96oXMJwU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Wed, 11 May
 2022 02:29:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 02:29:16 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpi3mr: Return IOs to an unrecoverable HBA with DID_ERROR
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu9wyf7y.fsf@ca-mkp.ca.oracle.com>
References: <20220505184808.24049-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 10 May 2022 22:29:13 -0400
In-Reply-To: <20220505184808.24049-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Fri, 6 May 2022 00:18:06 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::23)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b16a1d6f-d948-4ea5-65ac-08da32f60b89
X-MS-TrafficTypeDiagnostic: PH7PR10MB6130:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB6130D4F5FBFFE28F2B29BE388EC89@PH7PR10MB6130.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3guhH5KEdNqellBI0d3CUVP4Q+QSI++OurMxIDOzvkxCAf0QLfJWxeOQeKSJmPuW58l0GeWS7I8rEqIWYcd24ENv9e6z3RQnNyjfQK8eksFlVhxO2okHysBTvNT/G3mT33ifVHBHyLA45e226dzG5G/ZyDm9sV3vyF1DQTymbqCJvt4nXmYcTmbKqSBK3Yqf+9W0GSXDqEswxd/d4MSCCRstph0y9+7GX4LM9AZWWxkLxom4DlvNwDDs9btKXN7fW4Rngjk8cVTwOAnZkEUidnbTtCe/ddobwJPgVBT+o5pWtHLgabnNTRddDkOUSGZDeNDre9MEZ89s9FVQZZxAglXkye+byJwF0tC9R+Y65lhCbCsY1oBSl1tD3YjyM/LnhtKFm1k8SnOQIqL3opn/C9TU2bFKM01YM5pHKVMHaTZVyqBMYLdclCsg4iCACxsjsYVD7sRdSNmikMaqccSPCHBkO+Sm8EksTZLm883jHeu58hAPVagHufq5VBFZ7BthWbqK00MqTkvya+HJoRPv5IRyEUNGsoJ710bnTXUa+bxHj7JL2X21C0kftD3yvNxCwckynPuuFlp7s5A4NzM6oKykPcDW+xVeWojE83S9zRjJXd5G4XSmGwCEWQ0vUsr1iBWH97Q1DgvAOYAQiF6Zh7cBLT7fPiuCgT4bOds8QM7om67o6wlTkR0IfoEwzanSF4cSyRLoyXXlOirYwC5B3gFpAHJKh9qRw0DD6OgtAhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6486002)(86362001)(2906002)(6666004)(4744005)(36916002)(5660300002)(8936002)(52116002)(508600001)(83380400001)(38350700002)(26005)(66476007)(6512007)(38100700002)(107886003)(186003)(316002)(6916009)(66556008)(4326008)(66946007)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q/+jFnr+1jv58H5FhCkzTNNUOo1rkYK6kbwuLXAaw6iN0dB/RrztMcq6Jeq7?=
 =?us-ascii?Q?8ilw+HM6shhMBk5/+5D7IMElW7UYVxdlaLXdwjRW+gQnWSlt9dhEMwWpvdOg?=
 =?us-ascii?Q?KUa3+bkDM8/MyLo3NIhAIaHH+/rFRoglKDxKL+B3W+TWxRfOb5mH4gyxHEEY?=
 =?us-ascii?Q?gu3TGCSxe9XR43/qFfEhG7iGNC4tGIB4K8rc26UtHvBxeVRPnLLZLobVZHiI?=
 =?us-ascii?Q?8tSQwTDhF5G5ocHHBGHukcPOGmPBXGTYyjewXBH6Clx5GbMqL/zItyGxYWPM?=
 =?us-ascii?Q?GAv9uhcjUwQXLVrSC1fihI9scR1IdetJTZQvthWZmRhNDX9vkG0e6FA+0aSH?=
 =?us-ascii?Q?gi5A5dWgN09jizvsNlv3/prkeKdyFCdhxKCMwG1CBWTh/3VFXDv8cqUUX1Tb?=
 =?us-ascii?Q?rHphFIJShaKYBbMIhEwaM2oeQymx/ryDf3onO40xG/AbU/FnWhjS6wVl0B3G?=
 =?us-ascii?Q?ieAo03Ti6Mr79HegkFEZSRNC8yT3yzDoluSNHe4lsHQlgv+B71gTWAERjuBR?=
 =?us-ascii?Q?2kxbtHtw5PZVLx4uDn3O1VGtxDUWuPJgsd1GSrZJWsUlkixoqZrR8rQl0bT/?=
 =?us-ascii?Q?2hYYlsTw0PH8cRkxxOl0gs3ZWf+iRn3cbmtHqben4hZ8uiulZwpsFowWMzB/?=
 =?us-ascii?Q?0AUCh7HEFIehsH9OdwdF8rCb+W02VvInxwwlLQQAy8Nu0VdZoih+GNxuWYup?=
 =?us-ascii?Q?Adr2mVrEVeNgAZ0CGtGc8hQrfdQ6bGqKq8Ljv0UHcbivhSSQozOKAhwmw53f?=
 =?us-ascii?Q?VWaksA6rUYX8raTjg58S6pMXJciov9EnknOXxj/1jL0O//XuYf+qXTo/C4gV?=
 =?us-ascii?Q?IidMyUk4mNrd+JZNIUfylQShBhWo34yunvDMCXchei5a+LEpe1i/kbzjkCwP?=
 =?us-ascii?Q?NqsF5oSqIoLAP7XR5VTwAM1uQxWlmmqagPwhaEDa8109m0NgUT1rM1npMLIN?=
 =?us-ascii?Q?X7nSooWHrGRcYNLeeLi5mmAt4z/Xrb5ZHWcGN4APc8psHRLxCq4JGtYLJUzh?=
 =?us-ascii?Q?KK8mnMSnDY/dTuSI/ICeyyFs/q3GbIKExtFjAjOEeju9idJZmLczXXv1gKYr?=
 =?us-ascii?Q?1dAePFgHqSe/WhlxilVL3DJubOPCDAKF+0ScFIs/b/JwnE+odXPIwkwmzoa2?=
 =?us-ascii?Q?VEItPj+3JL31iADkRMvYKHTXC2d977TarpTtPwoXZr1dVa16Vme9krYQbThK?=
 =?us-ascii?Q?uvycdvGqeO/tyIPu0EfUWqwJ2xdL+w2HA7POChoRQZn8oVGXpf0KUzp35/oA?=
 =?us-ascii?Q?cmMl8Ximd62H0zfNQmX8ZVMRQ2JMKtwVqwooRljdXBX+xLHC4UcfHGLJJxNo?=
 =?us-ascii?Q?/huhPqbvX47N72zHtdIiMkT+UjUXegTZZGp+a6WfwtlB1nqTBqzD6wVAoENA?=
 =?us-ascii?Q?aV1YSCi+8ggZh600rLHPLMICcPZY9lXOyheJ02hDMNAJ8mhYG7voyKE1Bx5c?=
 =?us-ascii?Q?rzgjSjatL90yAL189q1mZvhK+GDlCRRNMWicuIRU1gbTtQZyFzFQwlshP5Sc?=
 =?us-ascii?Q?cA6DVX/I5sgIyQvr7BUrYv2iZHOss3g7PfwBrXyxcjrnou8IEdvPhMN2CKKR?=
 =?us-ascii?Q?j0Fl/ASaHWhZ0uZlT/orATkqh7mAdtBpKVEF+wsE9uqOW0tC7RZ0MUSAGiln?=
 =?us-ascii?Q?lzChK7lkU4qE+FhFkRyRHZq4Bk6EIP5T5pG+XOD2YIlL+RnGYxDZHOvdftbp?=
 =?us-ascii?Q?SwV92AU4M9KoCEbuPmHv3tekFg0iX1uNhmc4eiybpp+5dfB4uuXhNWumodw8?=
 =?us-ascii?Q?8uj5h5eiKd1tZKTtKEtJrZQEwaFkl8I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16a1d6f-d948-4ea5-65ac-08da32f60b89
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:29:16.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GD3m8HsUEiFhsQOd4qj05OKawqsdZ4Im1c9+oAV3qvn4RiaIrun0+D3qKTF0SP4vRdCnh7UKGyqsh8KvaPJSRBMERfytEi0Wdin79cbAOv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=608
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110010
X-Proofpoint-GUID: hpOU2LCYQ0MsiixlNeViE43AOLuKeJG8
X-Proofpoint-ORIG-GUID: hpOU2LCYQ0MsiixlNeViE43AOLuKeJG8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Complete all new I/O requests issued to an unrecoverable controller
> with DID_ERROR status instead of returning the I/O requests with
> SCSI_MLQUEUE_HOST_BUSY. This will prevent the infinite retries of the
> new I/Os when a controller is in the unrecoverable state.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
