Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3B0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiEQBbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiEQBbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:31:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D107D2E0B1;
        Mon, 16 May 2022 18:31:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKrCQQ027282;
        Tue, 17 May 2022 01:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XSlyK1qYJyjkQQ1UDlSzr/fIAxOejV0Asccn3sxUSGU=;
 b=GV7zujSMenXjAiQP/hau/F6yxOkwBvbrQDv7jguT0D1hGZrMt5pYpu1HgLlVlwC/rc7v
 KY3wsdMsCx6bo/WsjX5QN0GsSKYPuTNwYm94+sd+Wvbdfg0ddfnx9vr6sZn6NWTmnJOd
 W9K1vjyf0sAaxgEKnLRw4y1pUt7H5XR1GREThwzlv8TUjkoL2Kju8vsUphlTtnIRRYPu
 TP/yh10DRzIn5Y7N4WVhY2CKpmN2yTp05mXB/T3ER1jQe0ZtITaKxdSLsGMXD/8N4Gqz
 fSQJRe/v4NHdcCxxClp5/MELX1uuZu1ApLEFInorUGVEY58vGXTDurEW6nc93h63DLx4 wA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371vwb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:31:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1Fcsj035923;
        Tue, 17 May 2022 01:31:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cp35uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:31:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAkclV0w//zAIHkaVigzUSFZuyt06nrI7MXmCtrqWSHgUnjwhsEJFyzEjVALrHGbsNuLsM35pjUlR0kFKV0IefxdkbJdD1alXQHaEh3tqRspJg48wEyvPwx3NzHqUH4G/Klq1YzF6Y4oUCKVyEDaqe2ezSHgbw1wrCSv/446CNGsZzS+nXvqHo7xaAQqFcqHp1sy0HqU7SeotIdoqimTPm00KLP5rehZX8CfCmEkSxrKwFlgdlpeCCi+ZoeRGl8pY/YytDGXCBJXs0VqAk5Z3cY4UFybR5Vx8iUkFDFnoo4peqsOOZhXIfXLsOQL/Wr8xCBJ+uDg+nUMmt9uA7EoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSlyK1qYJyjkQQ1UDlSzr/fIAxOejV0Asccn3sxUSGU=;
 b=lDHuRAR0fC13I68FOHNjSFWyWDIVmO4QEZaGlC2A6pKSZH2K6XlAzm46DstUmNLzYnHeMzyIkQIE5kc1/ArT+A2ER2nw+6nUK5ZHDrb8GAfrWSMdkfg5c9C28U4EHre3tKhbWNg2wVfgLU/U1hg2n1eU1l8G/+25DvDJ2Bz2g6on5FloO5cHy2n6mxMDODSkXgbnAWN4WoG5/oZ6fZRU7grKrztWDBHqNoYMMPEokW7+mcOs5cOxpjuQY0+aIxNl9I/lkVHH9B+rU7xzsaukZyCyXL50Mn+XRiPev0MmvpXn0pTMutR9cj5mKmuXlAsFi7uYLuYXaPlwulMDBgqKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSlyK1qYJyjkQQ1UDlSzr/fIAxOejV0Asccn3sxUSGU=;
 b=dhYHw4AlMUE08yT4Qy1HtXtsfILAsdMDC9sBKTTG7cs947daImlHF0Wc3EUNpAXDPLwWfHM25q3E2Zcxvl9vrzcff3f6I69wS/bGkpkj1QDbvy+TrZCkMh3jIYnd0mqFwqp4hDy878VNZYSAy5PSLfpellymyjYCJ0FpFLpbtQY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5054.namprd10.prod.outlook.com (2603:10b6:5:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 01:31:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:31:13 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Fix a NULL vs IS_ERR() bug in
 mpi3mr_bsg_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h75prlm1.fsf@ca-mkp.ca.oracle.com>
References: <YnUf7RQl+A3tigWh@kili>
Date:   Mon, 16 May 2022 21:31:11 -0400
In-Reply-To: <YnUf7RQl+A3tigWh@kili> (Dan Carpenter's message of "Fri, 6 May
        2022 16:17:33 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0055.namprd05.prod.outlook.com
 (2603:10b6:803:41::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f198f3ca-3d6f-4b98-9eb4-08da37a4ed8f
X-MS-TrafficTypeDiagnostic: DS7PR10MB5054:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5054CFC68C9E90F39286796F8ECE9@DS7PR10MB5054.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7XrbhP/kj91uypBG1kBbzsVgsRLbHfyXOzg6nc79F2CMA7BRJZr3EJypnf7pD+KrYYcQFfm1Im3qvX38KWskKoTNwTlnEfP6cGxXPEd4pHMsWNDIAO+OS4VSWyn3j9jmPb4Ro0DHfj8nxEQPZqgbwgjKpNG8q7e9XKhaWZXdCtESK8RmCMsgCQScC0DVZ3ZZVliebjZBcW2RZZgw1HCqZHNCR3W7GYpYlhRGNrZ0ZPWw+J0OCRrkZ7DsVsX0kEtxxfiIZJz6rlqj7xMv7y50NTlSy3JKWnto/LcsqgrIGPaGZrsM2sGhmlFOUuHkv1oORn2fNGk/8UflKu75hkzn5HBNLdy8UUrDhDKzqu3xKB19GUDzK913NYVG1GhiWx34v/bL+BokKpLNlKq+dIM9MxJAz9ImAZtbTzYzdDjwbbgX1bGoD1Kp98wpGT4xnwsKpH24rTkSA8Xv284yKzwCphLpILxBSnPGmB7ECmoFijlIMBsFJhaT0bzeBYgY2EvY0um2fLVF4ERCu2OCqb5xDYHckcmYP9clDV6FK0W1wauYlMOyY1sIw68N5+Agi3wZBvfL3e7rl3KEJFTpm40hkOgepd+6Nw1VY8s/C9JNJUp6ETT6ul036C5iGkL1qH+pmZpsgPi56IEB6XDWFoMamPzDjhrNO7Z6bt/o/JMxBMn+HCEUodljLwdp3QBxAjjyNEo/EAbxrOJILq58WOKjpTPKpznuIjHYWtsIfTQArg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(558084003)(508600001)(54906003)(316002)(6486002)(26005)(6512007)(36916002)(52116002)(2906002)(38350700002)(38100700002)(66946007)(8676002)(6862004)(4326008)(66556008)(66476007)(8936002)(5660300002)(6636002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DEKYGmxe9egsJsTrf2euCc6XkrwCsQFCtK2WyE0k/Ph4jwP89NrhoO540p2c?=
 =?us-ascii?Q?HniTRlW4BJRSHoZ0eZVbFTLswkrYrhqD9IOw7VFd25BzHkVOKGRiqwJvJ6p/?=
 =?us-ascii?Q?pWYRRUQidzajH6SSd5+0gBCsNvs/ZbBVNfSRMeNs9ViDYhykTanzMiZJxUL5?=
 =?us-ascii?Q?rPQdaeSW56mrso/UXucK0uM6fqbZ28Ei/CiAlb4XZjAiqyTt9A8Z/fXn392p?=
 =?us-ascii?Q?STo98pLw9h34y3OsFqFPyM/lCnUliT8U/Mkwn/3+SzdUKDd02m6Sk5x4Jaje?=
 =?us-ascii?Q?L84WXMehNzcmMzToIM0Tmk/NTqK2jHrvKCxgNR2pTCZrfNo8MCGT9ovtj0vw?=
 =?us-ascii?Q?Uxati7X8p53AXU04bspVFiKKg13Zq6sc5te0UWTs7ixQtK6123jVdULm/Fpk?=
 =?us-ascii?Q?kUyMDWvGbULgxkMl6URtBQscAhI1dODtEpbvbi3Ov+v8VCV+ryRt1pX8R/kV?=
 =?us-ascii?Q?2f403IzdpuNd9XbOKwP2OvUr7In0eECDEYYWqdN/1kyPR3hqDZtmR0blAs4O?=
 =?us-ascii?Q?633+W2mhsOEGPVXPSCdfDu8f3AFBUV0cTNn+JfGZmelTyrjfmulddGjPsngO?=
 =?us-ascii?Q?bqjvfsp2nlCXQHBb5yuRGPCx8O88IvSRXQFelnJul1BNfM/VDXjAcPRlqH6Y?=
 =?us-ascii?Q?C+naE4j4OHhgR0IzQHhsmj+w2GcGgyfYn5IyOUYNpMgMnGHAYSkM6BvIPUO2?=
 =?us-ascii?Q?pRjPf967b9gZe86+SDmey/25QM0jB0K/ytoNdTHCctnakxlJwwKPXld1Tb0C?=
 =?us-ascii?Q?vFBGhwIUZM39w8uKT204Y4OnDszKi2hz5+SsP+um+EkSdef1RMx8aG6xdwEZ?=
 =?us-ascii?Q?17hjQQcie93eqU1ayxhwCuuPiSpacO3GfQoTir3uNn8l8lc7dNLseDcR+oEJ?=
 =?us-ascii?Q?Oso8NZxYUEzgJ2kB39sBJH2jqRSEJfZE/EHoJCugsVHchVFdxfFPV3hr516Z?=
 =?us-ascii?Q?n35m0cbGLZqHtzaGYzAJ2l5XTSjgFL6EhG/kVcWImqcjupCgw3SRBEWdEVPc?=
 =?us-ascii?Q?V53PrjfTRpa+hx5g9zeabwGVYm4xEOBs9SME8jGKRjWh+7OeV/msM3yWRySs?=
 =?us-ascii?Q?Ddw3IbM8Ma+Mk7qFo9LWX+Ll/EuLSE7nEq4zg3/HyNvK3QkI4ZVzYl2FVh0b?=
 =?us-ascii?Q?7fI2G001woAQjetmifzSrkRv5UEvXYro7fSf5LwPpleuQt1L5MPRB5CR74oD?=
 =?us-ascii?Q?6CjK3nAMUztTcCiYeE/2c6FICFsLNEY2t+I5ANAQW1gaQpb6CaUuFsouy1m+?=
 =?us-ascii?Q?rmX6MIpt1FP7LhTdk6Xz4EqpUPgvhQ/KPIKJu/nkfDbBIOKhxyQYQrTwK3Ol?=
 =?us-ascii?Q?HQptNRjhXojV4G1F6ZklIBfNr57njfCgvV8lbWuOH+5+81mmKVRDh2360/XA?=
 =?us-ascii?Q?azhSt5A0iZMqsrYU0NZiUHAmBYjXtT0QmkCF4sEraHhwBljU6iedpyn4ZDAw?=
 =?us-ascii?Q?X6AVNQdM4VywEtSmpgagGst31LsvLEVeDewVOfOQnQ3J8jUSuMQP1hVwdDCD?=
 =?us-ascii?Q?5Pw+nNo4j3tiJ4PzjagN25KPIYz4b337/5e0BWjIZKmadxzKBJtor7ahA9Cg?=
 =?us-ascii?Q?vYltYE+a6n70750ogfdui2DomYuyqPD37Rlw7AOpgYnnUU2CMyzLXJP0XjQV?=
 =?us-ascii?Q?Y3+711ymCI/SYCLhQ6qXcs2FF3jc9jIzAc1wBbl6oJNTM/cybIlenBTUSVCv?=
 =?us-ascii?Q?kxhKI/v0rDQqNu8gfozNjmitM0wsxXPOX22ysW0tvw8oMS2ymnXSiWFjrxJ3?=
 =?us-ascii?Q?/tXRw5UoTJ6CzxCzEZ4XPnsk4lc5+iI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f198f3ca-3d6f-4b98-9eb4-08da37a4ed8f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:31:12.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmaGgQOP+WEkYQk7VfKtSKyuTuyxuzVlaF21QQxnahlni5m+lyhALBskM3MYRLosKHB+9IBdJty0uI8AW9yqOc+z7nTQmHEXn0CMUGLG9Ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5054
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=841 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170005
X-Proofpoint-GUID: Xp8d7nEvyPo5hlh3Bme4bznVOQkSlApz
X-Proofpoint-ORIG-GUID: Xp8d7nEvyPo5hlh3Bme4bznVOQkSlApz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The bsg_setup_queue() function does not return NULL.  It returns error
> pointers.  Fix the check accordingly.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
