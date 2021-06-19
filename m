Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3E6C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE4361222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFSCbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:31:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:31:07 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2BqAq021555;
        Sat, 19 Jun 2021 02:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NTWpbErSLvW3AE+kIcpsJ4QEY2Ma2ptixuLVjLp+h+k=;
 b=F00YDR7TdUN+bKTrTRh1T7otxT8YcDsZtabuoygARhaIQnykOhtLMqbwyvvgbcfjFuke
 CqtJRv6ar4RifZoACtJRVHqcE/moS4nuniuazUEPdlmjv8AfvHshSyje0gnm+OvXDEQH
 7PYjX1hmAOms5asouXit0LREC5b49z0RESjF556N4rpoTO/hJuDkYDXQV+9K9we6fOoR
 orWOjvf6d7Dyq+66n1r1rK3+0Wgk1DTIiPzTpKOxL8wB8GPE2KuJrqsW5sw9iTXiPk29
 2mknDP/0usqh9jXyt2VdYyya6MqDUd/DwQHYsapK/hPsXEJOlhxLjTTWt56fxhUvAf39 RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c180mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:28:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2FT7g181641;
        Sat, 19 Jun 2021 02:28:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 3996ma1eue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWimLPNa2MnM1wDTmzr6k3onV245QvdXzada1mVMghEJOgjIRi7HYmO1zy0zT1IwAMlafALli3l4f7Ro+NTJjkY67WhKYz+7yQ+f83PkVJ/0TzpqJlbC9mJL8G6MzdGaC82NdW8zoWEQ/U5bkzYpB0qnSkWj4MmRfzQMVjG3dnKC3rieiJOQ1jKpFv9KKaZA37no/HUKidOeGsfgEhv6X+UK49TrIvwxH/M/cyD4SAJBAC4pQ4Cgdyb5CLVhUWX47hRaxTOPWm4gcyZo+zE7NIfMt58yMKF0dNtEhIr5yZXo84KHLCQrUn9UaW/QZ+BjwW2wr+rQN918Mtl1fDFWww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTWpbErSLvW3AE+kIcpsJ4QEY2Ma2ptixuLVjLp+h+k=;
 b=XwqB/7mAiAJ/3wNdDp6P3Csv7ur9oWVt6ZUvzgo46ULV1VFcwKnYjIBIf/2Vf66Hi1MXUBxZOPmbJAixqDT8USnFxGZt0oEMzVaNDcCIl41TOaOxYpaOhlDwuWFnlO8fG4Dvp6gAQ05K4vWfWep6HeIARyWZLC7mi1KbAASGJ8G7nD4TyyHibS638CEaQ0boSlVyoyFCWTBtyM0iXgtqCPFJyfXpL5rM3GNSF+1TfYhG8oyGTnPEC147x17GsJPkZkIgPg3n92eWMajZAjCAdHOYdPmXny2gomJcCunS7HYI42urMhvqiD/oG7JJf+iHp5D6W8umyMQ8NhmqFCwP9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTWpbErSLvW3AE+kIcpsJ4QEY2Ma2ptixuLVjLp+h+k=;
 b=XDj+nwvEPi7vzTpzt5hx38B9xbFFu7GYrAc1AbYIb3zfHcSy4FeiAQZcpLg9fhCLl0vn1JzUlpMjTObdvsOWMKcAKcWKuOOWd0bzTTcgFohqcY69sbimdfIJhH7loB3Sc4epCP8zRNWFjLLJ1bZ8YLpGEJQtuKUxKdpnGQ5ia/A=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (20.182.136.88) by
 MWHPR10MB1485.namprd10.prod.outlook.com (10.169.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Sat, 19 Jun 2021 02:28:49 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:28:49 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: elx: libefc: Fix less than zero comparison
 of a unsigned int
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eecyziy2.fsf@ca-mkp.ca.oracle.com>
References: <20210616170401.15831-1-colin.king@canonical.com>
Date:   Fri, 18 Jun 2021 22:28:46 -0400
In-Reply-To: <20210616170401.15831-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 16 Jun 2021 18:04:01 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 02:28:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631f0bf4-f2e8-4b15-f759-08d932c9f893
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB14852847E61EB2EA80D0F87D8E0C9@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGcTKLiGVCJBu7MzE2AdrFJHMh+KJF0bTMY+QbnfOkuYpMmPphawqwRgJPMv0vEpmc/thvmaC3cTLd5Rz9PeAwkaITpomQXybCEdnBsIJVDO2xJq9QccW/fXFPkr1eAWcEhonBIWbogWcNFnkGWOmGlYYn/WwHu9WzwJJFv1FzbcYOuVnIJ2ZgRR6g12dHQKj4NxqOoz4iBMFXO3DC+4mY2kPhzNOuV5sybZ3+2J0TlY+bhJLtU5q5VvLzctGP4fcalirERHbCp8y/EA08AlvFetIRvvTQqFSDPH3OHH5R7OWxru97cQhVpEO3bQ/a6Xu23eg+mgXpLvT3lk9I/a8C8fxkLVzU80D659I2BmtkwYYL68SKk8h/Wu+yN9yyHnKnI2fiCDokQUnjutWS5l81CMCkmUV7Yizk/L1ND0Cib2NSat9RfJGO1CkKuOoPRT7suAKrwqFzzaUJSA7O/NTEqiMVRSEEqXg0qjQu56ifSp7Q+Nz9ewnx1fbDZOeycyiO+RYJkub77iv5c371Kz4y/CJPIUSMqoVwcc1i8AdgvQ6VwVLC+hK1vY/AKTcpf5kqxEz6Jd4JIr02O5gIkRfeBsROrPmISDu4zkDSseY8UZ/Ly34uhmp7hwt6tq/a/6kd4uHjEzsa8JtMj7I6qYxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(66556008)(8936002)(54906003)(478600001)(66476007)(66946007)(956004)(86362001)(8676002)(4326008)(55016002)(7696005)(38350700002)(38100700002)(36916002)(52116002)(5660300002)(316002)(558084003)(2906002)(6916009)(26005)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?57MQuvKXs8PkpagrI18MqNyQJlWCG7llYJV3MZl16134rqTYpna+HnGChd8z?=
 =?us-ascii?Q?PcoY84eM7K3milm+M29jdxu8zksIOWlUz+Y2SEyCDwOFh6SEGwwPWuIhVflg?=
 =?us-ascii?Q?/bbZBv7nYWURDfDnjS1U2v12hOZSQIHOjUimOQ7lah8Kc8eE/X3dsEF0p7Wg?=
 =?us-ascii?Q?O+3CgaoyfUZjuqjawlI8oPaGLd0GA2VbJuuzGExwNEiBxYWz1VP9eWQvYqfA?=
 =?us-ascii?Q?Bn3mTC5zXg3FDaJL/ROnuC5BHnnRmxlFNOhU0VpdzwGrM+KKOnXHBbiCPXPD?=
 =?us-ascii?Q?4v4FZz/pFIMZkBJygE+JwpGntaUQSEY3Rr/4p09rpfFdilQQf52SOr/A4rXl?=
 =?us-ascii?Q?mkI5AQ0+1TiQaLSOwdvgDSj/JCu2Qj9/rJuy6bzbPB76IFxlBdlSCS+Scht1?=
 =?us-ascii?Q?N8mTs37vJ5fx9XSu0b8sIEaVC2T5I/x3O/VFgY9xzi5HLXPcf4MXuwe8t/ks?=
 =?us-ascii?Q?jPKQRV8/IytTfRhUoQHElP3wJVPcM88UNTz+vAFma9gcoh2lK+t9Yholy2vW?=
 =?us-ascii?Q?ga+MtXpsEGFevLPZ9nYFDvrv2yk8Tu6MFAfFj4ogscGGS4uoJMb1TLXrPfdA?=
 =?us-ascii?Q?wbf436sXgFepD6WYDUbgcYddYRLcLdR1uJBubqQpd5nQUjCuXo8zdKJ+CA+B?=
 =?us-ascii?Q?MQjRP/KkneO35X79RjOuSDESYXbRmVcxUncfWYmjHnOeGTdNNbV8VJEOYn8u?=
 =?us-ascii?Q?lhHzrFUeMRmS0L0CD0ZoOCKhtPqjrUykquT5FVTBlQAapzMEdgJZ0YmKzjeR?=
 =?us-ascii?Q?vu0g9YTUA8q8Vz+pirjhfcabbhfhU77b7Jy7GOLvTpdfWhWfaoqRaeqx0FK+?=
 =?us-ascii?Q?v6vIUrLaBKWEf0AugipL7ygRsIRXPVC1OGVPsuU/pYWsrSGTocPEBdOXT84w?=
 =?us-ascii?Q?lJnxg61qmtQc6dsbfYCLIRmnaaXKKZvZYOmmWsz4O10Veb5w7NAhnFC2BaFL?=
 =?us-ascii?Q?Hbb94TSYcwzyzWGNpZ+5H1QEdfeqxOec1P3SGYDjCsW2WZhLcr27USYQYl8I?=
 =?us-ascii?Q?uTRmZ0LgZ9vr+4KJIGSvZjRT9huL6YLellZXHR5Rt758JDR42FH+Q0quiEPx?=
 =?us-ascii?Q?HiQLYrC9vXFPmYwRo2sALLu3iVXbiowTpg+Kc9hyUPAjDiFWWZQud8c4BMGL?=
 =?us-ascii?Q?xFIwnFgmhr8bd/LcmoHN7CJdXDMJIV41DuMxBbLXg1JtTAvm+ZDEe+aKVGBW?=
 =?us-ascii?Q?BMgvALu5YFkliXULbn9vlZyXq6rDaYrd4KgK3dmFgAVfiRUwNNXqtUgTip+P?=
 =?us-ascii?Q?mOcWJeVS93/f7EsdnhW9vQXSUxgfT5fDpKR1QR37Ye1JIpL2dvHuTrU2Jvkc?=
 =?us-ascii?Q?qtZBHQz317rMRPx+YT7CX+QA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631f0bf4-f2e8-4b15-f759-08d932c9f893
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:28:49.0893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMSJFYBpbZkbIoYePpXI8/Vap3flklOVElmbqIVx9JR3wmpJDVME8dTSbXncgKCgQA7lSIRdwWhn5FASmyiDrBUAd0XxsqsscjMRhlYJglE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-ORIG-GUID: 2LHIHFGReXmkDpRaQfYkzRyw1nMbYbOP
X-Proofpoint-GUID: 2LHIHFGReXmkDpRaQfYkzRyw1nMbYbOP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The comparison of the u32 variable rc to less than zero always false
> because it is unsigned. Fix this by making it an int.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
