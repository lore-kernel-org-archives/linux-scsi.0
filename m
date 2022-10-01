Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C6BC4332F
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJAJE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJAJE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:04:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949ED30554;
        Sat,  1 Oct 2022 02:04:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2911udrh008246;
        Sat, 1 Oct 2022 09:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=TrrqgZ6WYDFm7ekJ7Xe8tEbwNY19ZdXNPULm2dn4CSk=;
 b=ili0rKkLxLbF0DQEVVoBsFdWDkWABohoqXr7fREgLdhPtwEaTzzqtr3BIdBLJNL7a2X5
 ThHDjjpccdAT1rWe1+D0IXbSxxhZoZw+Jmo9kklUcFzcG1mFLBN3PZDZhozKIXqckCUX
 KTxHT9I+QSdYOPw4int+OUwBP+2NiXdcAuz4AbglxnlYNbc3WCcrd/RVK5Y1EBbV4EFq
 f0X1LIMlRY6q2z0QUuN/U1Jh/oo5mSKBJrgs0Y81GSUZC0YnuL+27b0DijBgLqsEWYIu
 m2JAsp8hs+HllrAWmOcvvn2rm9paAx5Fs1vXqnZlEOwErDFSU7gDXuCYPItwM3p8k7kh NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2gev8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:04:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29190lSw039585;
        Sat, 1 Oct 2022 09:04:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc01dkfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMiZBYFpySlC2sLp9cg4Eu6cEOrd/uEhlUihP0sNiRQSLKK8nUlZO7LIKnDisiGTqjbi16itgmp2tX/MH/4eGJA6HOvmR3MTxRpe1Hiom+navslNA3O/Pqy0Gy4t4IM9fJ8qCeYd8mtcgKnYNkOHa+5PI2+wO5DQrEGbtnBIn8Nf9vwUtPBedtCnUWsxOw2611UU2EbWxWi/m/tQkBJslW01YEecC8LGfz/EK328zPfpwU+7ao+M5NR2TYuD5ML8hrHAM3x2aYnaN910KSJw7+AjfF4gFHifl7f+mGiYbrGr3yGSSI/xWVF0Nuild3Se2i2M9VC0BCu9eeeMVtZMqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrrqgZ6WYDFm7ekJ7Xe8tEbwNY19ZdXNPULm2dn4CSk=;
 b=JTBWp964JumwMLylAR35yrTzEHGodP+jVAL6QXw+ey3y68/4Yl400t6Jzc3P6uy4v/yK05dVBZC5bWFiCXd3ozBcl+OIGv16C/caQbKPxyeb3Gtaituj9WkqaK3HyDaDZnJPeSg/n5/2Vo8gl7d4mj+3QvOj/pbQ0cTYwQwZaPxVllQE7+pHfrn2iRcvX97nLvFua6z1iQutzOc5NfVRAM4/UHYcByFS6qhE/+yjxwC/B0IpptHg5HnlzZrsAEoeqk4NQF5rzY2VeQmYSar4pj8Tsl/u9HPRFDDTUJ7tYmoYT0wsc36039IfT9BjZFypaR6JmUAHKiIP7iX7+2RAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrrqgZ6WYDFm7ekJ7Xe8tEbwNY19ZdXNPULm2dn4CSk=;
 b=gIYqYrKypck6oTYIvoB9plYHHesnyawXckAJIfwrsSlNSLJWHlFrvDda5yuEZ0eYI4ePcQEzqkETSkCAXmCRgWUeqZ0WFv4SbwzEqIhzvKLwo53TTrfahqs2e/1ozGeD7AUiuaK8eN3Q3KbOepanXW1Ug+ferZUOAn4ioPW2KeE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4703.namprd10.prod.outlook.com (2603:10b6:a03:2d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:04:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:04:46 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2 0/4] target: fix bugs in Persistent Reservations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn9jlxsv.fsf@ca-mkp.ca.oracle.com>
References: <20220909090425.14479-1-d.bogdanov@yadro.com>
Date:   Sat, 01 Oct 2022 05:04:44 -0400
In-Reply-To: <20220909090425.14479-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Fri, 9 Sep 2022 12:04:21 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:806:121::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4703:EE_
X-MS-Office365-Filtering-Correlation-Id: b1885603-e5dc-45e1-0539-08daa38bfcec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRD0VYCEKVm+UZPOlyskqa+qabQRnVsMB+lxZ5kNF/UbbFPwD+Ojx2y4TNl97ExHeJtqX2oKhD360OivxC5mLFd9wvi4uP+JRLS/6mREv+y9s8J8W0vt8XIYwzB5TdkemV1vnDmxdx80qEaRV3/SxXW137QbVT+zKOvBL7y89g4Rems9+PnF83ujpw/dXatQykwFyX+GwpG67gGlxRY1gez3To18JdfvVpJjr7jrAV11z8GPb8CA1cNG1eLaNPVh46otw7tQGBTAQuctxLZjZTCsJBJWl7AVE/Wu9XBqN7lkL6W/MvVafOhdAC5B1+9u1uXsYK4U6l7I1MB3cwz9mkcPv8kgrjLPhg4ImZYb2puw+1P/fJCr9YVke18RGbvTfRFPR557Tov5ovevx/SiMEQ/tGhWE1bihvFVZqbE/rg0JUvQBdsXVc+7hPa4QOrOV30zdKp3GMY25B3eKA4tWtcIBPfGeJQGZUtMkp3arLVhdUhN9Q7uhZiIN9HcAch0S6YKJ7B43WwGVR28iXbJ2BdhslE8I2VmTiwzFykX+8N72Z+roWtfqnKuGsUISDCmG/KcN/jdWKLT50OlEdt3Ivuo9d9g+3dsjt6OXXppGtT5M82sISGUTzQenYAQD9GHdevKRI7EwW0S1zXW0I3BExbBcsbqfvD8edKL/2e263cBcUSLXzVMu2SBv+QIcEziKheTRsFjsQ1NoFNky/U7iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199015)(478600001)(6486002)(36916002)(6506007)(6512007)(5660300002)(66476007)(41300700001)(66556008)(66946007)(4326008)(8936002)(8676002)(316002)(6916009)(54906003)(86362001)(186003)(558084003)(2906002)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WeasynakDdGshRS/ooHXXZ6eZnVhCxgYpeKLCiKoTPco5DSqf3ZjvnLAav8L?=
 =?us-ascii?Q?r5KtpBZNbicOQUr9LxdyvnHe+hUERNFQxi/xxlcFSbTuQYlMRz8nHbCQk/gB?=
 =?us-ascii?Q?e9sNorvEeSlaawyhdFKJri8NMLohl1BWnGc3luLwAGVPesG3CdvIEX5hcW+6?=
 =?us-ascii?Q?vnZRkii/y8l+umvkfvRM1svOzp8I6PJSPYQCCWrFujJK6AY8hqJ9Ri/kI7jJ?=
 =?us-ascii?Q?ncmlXIrSMJNI+qu+pP86i0QelYzvTc8cSSaEpiEdSpBN0MoqWnxVn8fB/gen?=
 =?us-ascii?Q?QoEl16ji91G1CflByR+WKE7d/9ZnmzI5CdZexM7I97IuxBzDIDIdnb1KsXBH?=
 =?us-ascii?Q?Ki2b8F4dK4QUlb9EC8qJSEYy9mXnP+gQMZtoU0Co83oC1FSG3VY/c3qPDDGu?=
 =?us-ascii?Q?L3iyel5KbPyOmButNNRcbZ/sR5yd4UhT5Lnv6YuY5UY16/BnZTB++V6r9x44?=
 =?us-ascii?Q?513TZUuIOu7lRePpy2912jd+PRl0YrJp/W7aAxMmojxA2WHHk39cymMHSn+R?=
 =?us-ascii?Q?x0QJ5XWrVjXAjm292Y1ApcFrZ70h0ZD6Hd0SWk8PueMG614ngdg45EO/Jl2B?=
 =?us-ascii?Q?wWdPQUrpsT1Q+I/ybVbfzAGeBoO4ePajx1xtJYF5fV3FCx8pnlijF/CIRrWE?=
 =?us-ascii?Q?rChw6T6LORM8TwXnq/z/acaEiF+SgmCcR+GfPOCZmceS9GiEJaHkRfnVDVIQ?=
 =?us-ascii?Q?dTIULGKmefu7XLM9Ap395nBsmLotkbEDiu0NDYJaisaPCAc8OrC0hl8ijmey?=
 =?us-ascii?Q?cuQ+y6IXe6v36Jtsk+4WDjMpUgofM5jbkGtU+umIqOZoHcEEv7rtcy/0brkz?=
 =?us-ascii?Q?51aF8HaB3mRqgmHv5vuQXKupQihU8Om4vE5KdrXRIdwZeoFVX9jIJ0wOVsub?=
 =?us-ascii?Q?1D+GSbofhjpzY1idVrt+V5KgRoQgdZulG1G0rq/xYvJOmh54y9+TeVq4hsnS?=
 =?us-ascii?Q?+1ShV4tjqo4JNSC7gwtpCL1W4dGLEkbTkl9wEuBOyfgXV+F9SG1cuh2MwHxx?=
 =?us-ascii?Q?gn6MNY3ao3fvsbNM6eC4sEYlVnJGt0NkRcaXn4jktU2aiHIASc4E+u8x4dgZ?=
 =?us-ascii?Q?mAXQnY4eH0C3Y5JzPM9DD0kVx1BDVJ/Z+D/U+7w62aj3wgNDSMBwnz4z0x3i?=
 =?us-ascii?Q?uL/nt4/47yUobBHNgJj6gy9RdB/cxobFt2kcWiLN6H87hz5v3w3RUOubs8Bn?=
 =?us-ascii?Q?bFPrdwRQgiB4/qUakO1AMuBUiHn8XF9/3lhZ5wnvYwo0El815JCXpqf53pfS?=
 =?us-ascii?Q?h3x4Bns57Uf/U0OeSRf6uksNeJQIJEUWTBaDNBHUPu/MTRtQJTXuiWFjxUqZ?=
 =?us-ascii?Q?piUQS32xk+CxEA2y2ZzSVyh8kb8anVmFCIkZOYGzHiB0t6NOslWsU6VupWZ1?=
 =?us-ascii?Q?FQXCPXSOTj1akm1jIsz7JIGHYwpz/3zH4wbDl3whzh1q9qfR0M6q4RHpKijX?=
 =?us-ascii?Q?Canh1D2f7Z4IKooeX4/JmO2aaGjn2I0QbMxVmfVXVig4KAndEVNPnnzHsu6D?=
 =?us-ascii?Q?z5kzzY8nbkU1oW2zsOkPx4aAFRhmfHSAYWoeDxsG0NPpAYfpe0OYpU2uI11E?=
 =?us-ascii?Q?Ftr4H0f6kf9lT9pSKJJm9CCr38DFh+ruOUh2XrUM8RK8pALkrrYWDWWDJ2jl?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1885603-e5dc-45e1-0539-08daa38bfcec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:04:46.7497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfQIEcv8RPa9nKCmdRUQUh8igMWls3+ZMBkYQ5cm9vtPPia4Dj6VweIwL96IVyWWlSZWG7EV0xZgG2fD0yHkYyh8pFwYPMCayJclolrPqAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=534 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010056
X-Proofpoint-GUID: joLbMcQSAYPNWYiyBWbnVx5j2afQNBN5
X-Proofpoint-ORIG-GUID: joLbMcQSAYPNWYiyBWbnVx5j2afQNBN5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> This patch set fixes few rare bugs and deviations from standard in
> PREEMPT AND ABORT and REGISTER AND MOVE operations.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
