Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FF4C432BE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 02:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F23860BD3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 02:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhHCCNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:13:43 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24232 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233619AbhHCCNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 22:13:43 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1732CKBK032047;
        Tue, 3 Aug 2021 02:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=s6RkUwkJobLV8iFeeWg8hqxO0CacnUVwqn/O+02Yxy8=;
 b=u6hJ/NTIWBtffNgd/kP3X7nrp+wNI7As4xB92v3SFUECkCqbQW3WZ6NzUcXlMKTS1hKD
 Qvs53fxcTK97Ju7k5sh6GGO49f+BKXJffN1uQ6PMpAIRMbo0bA52AstfxtJqCghj+Umk
 Btitz5e5nlaVAUtqfoWJd4D8bQVtInBdc1Spg7Qs9bdRaDEwshJj39gb6rPHRXeN0626
 n4hdJmHFKMy9Yi9i+C9OSbyfmhtzX9SfB3AS1Bpdedm6VlN7UpcRkOw3+eKQlqkQw0/I
 NUGDqJPZzn9cBo6xCN+xL5YJr7K0X+ml4ARrnJo0Gldky5ccW0YX27wtWzimcyPtg9pQ 4g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=s6RkUwkJobLV8iFeeWg8hqxO0CacnUVwqn/O+02Yxy8=;
 b=JiSgRG58zwqcgjAsjGfye1pq46INjJc5xZ6f5EDsv/2cdhkP7ipnwRGW9xOv9tnMZSG6
 kmsfemMVRbIFRK3m2d0GNUKflNauwJV7h9nOuo0Lu7eEO7E8ZDi50r/Uvqm2JGiIT3Z/
 NuFjls0hm5NEWxg6GhzZCweAzbrhRFmWjpzL0Yot4CyPUfpS29lyA8vg+zKAJ5paf4Wc
 G/mDlJir2gdkfgmpn9FK1/dkFZEKcGWZRuApWSgVj/UVIBJ2M47JygUbAR0wcGYmZbji
 FnRhieirhnmVqsRnC2CRYVQbS9EmK4aJQj787dpY5OkKmxLcbB2eze5J44kDht7LbEwx qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqd9p0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:13:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17329q2Y079015;
        Tue, 3 Aug 2021 02:13:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3020.oracle.com with ESMTP id 3a4xb5w0gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:13:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVPAgaR8VoeLuSFJCIvL2RcoJOwYkiIz4QcpYp1KHtnWrMLR7EM/nM7juL9ghmlxUhtjI0igS07/JGvJMgr1Mpp7jV+6mlJKx055rgeMrayOQV97L9EJlJb0YG80beSVKGLiVEbkZ+8AxIRam5coF+kAE0Cc/QwzADRbNLm+e6B0T6VbD/C87bmhcb9eVzCQohjg9S7fwnor/SXps4lt7+uWCZQW4cCBxrIyNCn4j+WrnXCbc7kvL/Abywd/zIWsoJ+Y17IlRPoaoj05JlMll8diXiXdp9jksIrgWXVMg5a4SKAmd8fQkKyf7MmAjp7DqdLrgh6qz2BTvp8BcT7gxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6RkUwkJobLV8iFeeWg8hqxO0CacnUVwqn/O+02Yxy8=;
 b=Epf7so+BLUy3/8F99sInNUSqWD1cRIiWuabtNsjuQSDnkDxCipNRE0MICCOND0jgg9lTmhB9UkSgJPyhXCZggrLsu7BsGR4nv0fxTe6zeLdpDhS4VY5njqypd+X9tUhjemCAGyDv/hNk8mivFrh7Ohu1zqRPijlrZW9Kp2LVK5bUSDxaZv2a+RzpaZE+BXuMOVFfy6loAkPVJLvNDPjBxecVQz2baQulTznmELjArJwicCVNiyRCgyTPlii9S9v7GLZYfEixzTtucHiM11aDXu2OSVkxZ/94nf9iZbaot5rm+Ftv6y7hdtymb6rPfu59N4w0XjBsV2XU7HhMFbgE6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6RkUwkJobLV8iFeeWg8hqxO0CacnUVwqn/O+02Yxy8=;
 b=Onq4Rnq9BwuwiQLj7+wbIwnHbLSljsOz8C0IFJBZ0qrizS8eyL6VuPaBAE8uPZH/VptlKUjGUpZJ5n6/+qT8ZEnyTgM5gAq1QYPBSZpuk8rCGPPUmwmUpeGQDqX/KUhvbBJPncIDA7xQsRC8Ls0s9g3ttu42HP2ZRfJt34YQv98=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4632.namprd10.prod.outlook.com (2603:10b6:510:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Tue, 3 Aug
 2021 02:13:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 02:13:28 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [Resend PATCH v4] scsi: target: tcmu: Add new feature KEEP_BUF
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s1jl1hk.fsf@ca-mkp.ca.oracle.com>
References: <20210713175021.20103-1-bostroesser@gmail.com>
Date:   Mon, 02 Aug 2021 22:13:24 -0400
In-Reply-To: <20210713175021.20103-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Tue, 13 Jul 2021 19:50:21 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0096.namprd11.prod.outlook.com
 (2603:10b6:806:d1::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0096.namprd11.prod.outlook.com (2603:10b6:806:d1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 02:13:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22af8f66-b5e4-4248-40e4-08d956244882
X-MS-TrafficTypeDiagnostic: PH0PR10MB4632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4632161D31E410F1E94DCC9F8EF09@PH0PR10MB4632.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GR7jr36WPP2DEQ+3FVtpJdAeXLrlSYwY4qv68GiLeB5nunlT4GsTjdwbMTkSy15BJWZQXgQlDjneTNn2UbHCfeMn66i491tOY8+FE31Tf4SDDKATp6aRa1H0ifJJ+oxIX3LM6DZ16MUgIjTKWqkmoS0KHiSQT5RlZatElag706lWQcVP2IvaPjQ9YHQVhdE6JiN8fm1rr4E4TFDRzmTA5MiQe6ZAGtfekUD1XwPgujR7dHbhzUNG9XZeIm0XW5oSS2LJcj8lXgE3AOlCmMCxCX4grMJ7z8PHaXyS0erf1HOWwqicLd1i2YvwC1tReQmoW4WBvVP3+7zArfamDoR0re8OMlswEpUfG5QKfBDTx2MU+jy5Vav1m5WgKkQ7EASbQvQIMvFSHDyVS+Q9VOcnX+kwuSQIMa3fXFbJ4o3teE+zOi4BJ8wOURkHzykB381knJWsV5QeCGzhQcr/UDsRK321HlFqDFbxbUg9+8+vy7jmhK4X/2aLkPWMMeNs9eI/MJEhsnqbMlJlVSWqcAg2tobuA1FYYIqhHY/iTonHZuL5UDIgVtzDPrt+gf+LwIavW58Fd+GGEx0rBBpNhVxt4EmBiNNebTkCaUSSgfdOKxuTfCFo49e889xIztPNzy6DvkC7qgmA7HRu8syzYamX62LiDi8Rt1uL2HT12ZKT7x9F8IiRLl+V+2IStmsebjY4S+lg3OytpttQizCya820iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(66476007)(66946007)(66556008)(186003)(55016002)(4744005)(86362001)(5660300002)(956004)(52116002)(8676002)(107886003)(6916009)(7696005)(8936002)(36916002)(4326008)(54906003)(478600001)(316002)(2906002)(6666004)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D0CI1Hug1yQV+wqhYP46muwR6exBbS884VO6po/ulZhLtk/PN7AuVMv5vC3v?=
 =?us-ascii?Q?aj+4zYBDwugemnHIJVZMBzNFaB0kqC+VeT8yuXeiBo+pboUxBSMZ9SqQk6Q8?=
 =?us-ascii?Q?3NnNvNoM8CcRfs8/+legcFrvVBuid+HR6rvoCWE/AD0aOSL324KgQ2Cf5wXa?=
 =?us-ascii?Q?sLq9NEaL+do6VfC4wMz0NEIV4x2DmUIbtuMOlyuOZ5WjIsIvYRBI05LvhJzP?=
 =?us-ascii?Q?I2ah6dntqYv/0+MHxAyHQas75XE5afisv+hpdNP8m7j5qzj3Z1WhuVB2Z4IJ?=
 =?us-ascii?Q?RCydmie8krlqiQvhEUVMBasr/7htHUDNCQ1SRk2TZSahvLfmBaiCZqKzGkR/?=
 =?us-ascii?Q?3GqQIhlkKxhhlY/j1s6j3Vd6Lq8hIhtyt1rrjcXPl0uyN9VnvuwM8+Tj2mPU?=
 =?us-ascii?Q?yx2jV03CbK9Asru/i55tjrluh5Knhu/Hez4/60k0Yqv08ZCAxuCM4cQTeAYO?=
 =?us-ascii?Q?0qJoROfP5Q8VHpQOuSlGo5cIgOiJD/saOSDrCVq2EcsOTcVcqyTaDqo11ipN?=
 =?us-ascii?Q?7toIZUsmrRLt+INRsjnjznjbZiGIlQODoWMtEhnJAkQ8bN5SUcbVatdOOqsZ?=
 =?us-ascii?Q?FCCxUUF8++rk491dTntbUmTEH1yoetaTh7lB7IG0iyr8NnmBb9qQpg08cpFP?=
 =?us-ascii?Q?la43pvYXgdc411NwQvEgjjrmmU5hJd8RNp4eJJUOQ66SIJNSCElLI8OLHE0i?=
 =?us-ascii?Q?qreHLxgM7rosxnTRowGY6BIBt2lOD7DXAO+/TGIVYXXcjpee5ImzNzURt4ov?=
 =?us-ascii?Q?L+6YbZp97m5mW5NAP/o0N7pou5mJB607/qrggZ2+vc0ug5WhTmkGIZsxXu4n?=
 =?us-ascii?Q?BdJrACcDx/qiwDDaUo1/iXA3WGXjbcbhc8USI1fY89ziGgclsImeRPwztp70?=
 =?us-ascii?Q?mGtD69aiXPcMcd1ZApznWS9C7JCUQ+QZ2I5Q9vzP9FB007W2pT7B+/JIO+ZT?=
 =?us-ascii?Q?AB7UW8dKJR1DEpWoJcEyAi0HYE7XMj1XsgJOh3FOJFL9YKSnnc481GrschE8?=
 =?us-ascii?Q?pt0aH4M++g+a+kU8XuDERDMLhYVm6W81x45iR6yBWb4xdahJTn5rcv0BMBCl?=
 =?us-ascii?Q?K+j0TExgIPQyJYyIzS/QJkmN7ypczbSOFhjotQvJ40DVrO1scY5A3EMZQWRT?=
 =?us-ascii?Q?OItlpJoUZzHxMfXhD9L/nVPg+mx34UWgum4WtHiPSTFJmQSkjTCf6HcC39Tb?=
 =?us-ascii?Q?6KYxx7Rfkdw+tLbscpc/cBRn5tjFE2ZEqz6BmS7d6eI3d9DVtRykkDjmmUTb?=
 =?us-ascii?Q?6F5VM98OkoJL5mgnJSXq+Um/P14AW07jDiewYCDfFTZdbOSWUwFpdD6OY3Es?=
 =?us-ascii?Q?NeX4P5nSjZ42tpl3UP9Kf0Sk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22af8f66-b5e4-4248-40e4-08d956244882
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 02:13:28.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FESSPDE05zLlw/JgzYplqdeOGXxmtlx0FK8LNeaJps/oKtXqwq2Vz/uwI5rBlmETEaatcIAoZvUw4IC50wLX0+qyZt6lEMOR9GPEMVkKy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4632
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=677 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030010
X-Proofpoint-ORIG-GUID: emkP_ez7g2zaMrv7SJpL7wEq5uDS30Wj
X-Proofpoint-GUID: emkP_ez7g2zaMrv7SJpL7wEq5uDS30Wj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> When running command pipelining for WRITE direction commands,
> (e.g. tape device write) userspace sends cmd completion to cmd ring
> before processing write data. In that case userspace has to copy data
> before sending completion, because cmd completion also implicitly
> releases the data buffer in data area.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
