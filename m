Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4E0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88EB065093
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhCPDUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:20:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbhCPDUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:20:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39rab058199;
        Tue, 16 Mar 2021 03:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AZ1jRX+0ssqJuTZjvSF+tZB0wcLvslrwSLtF07vGVeI=;
 b=Xf1H3CEMf3Q1RDz83HbIBJLe6Nb6s/FFN5jQPRY0rA8M7OFLUbNi9BStdGtFBJ0f0qmF
 p43LsbHNzb2Sze9/b1yn9nq7Awk2hbRogTWjWSOEM1u82fmnqaBVJK1eHQGXx9kDK1UF
 9AFHvSvAQNas2FJZd+aPDs2qdpurF4pxHBOT8DQiquTYFAF9+782ocU4HHRo2u4aIAY1
 0sGq3bQqik1IeQPrK1u7f2BXJD4WIZrWBT8Egqf+7vChY6a0O+T64rlKhKB1I2zGZJUl
 i4EacVUhEfaX6TV25FfXTcfAjGAiMehvwezeC3y5b+0OeE6/Q/tJGODgHjKPhDGnY0Y6 GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1np3tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dji138200;
        Tue, 16 Mar 2021 03:14:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3797a0naca-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQCNT4lWql/AZJ0ys3NOrmEcfThpDMnJe8IJpQLpuPL7n8ApfZsKLCl3YUAe5rMQH9S+n5j/Rf7i05lTIlp/0qKkTyj2YHRSASZnyEd0+M9iicYJJ8P0rUPzFQx1olppOPofn6R93B2Zms3jQasS5aj6tTUknj68znRXlltFdOIUokoeI3/kAa4Nw1yctenqWyOY63Tlwl8DMuPsdE9PuYjpDAuhhxhJLPVm897M/0o+hi0mhDSfpwE3lihYzuovrjIh7embGyEHAOV/T7ShLHvEBZ2Zd7bl60FFlcRzJUwKdaAe6PVWijDTumHbB1uOR4HSbJdrFVFL0T67y6XrDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ1jRX+0ssqJuTZjvSF+tZB0wcLvslrwSLtF07vGVeI=;
 b=SCc+9/qBsVlz7ba2EDCljCE/B0pky0sYzoZRQm9lyA5yzTcBTPRKMAKz/Wz1NZhMtn+kbY1UeaH+FIkCsFxTDVvJumf8AI+NTVp50258F9iUel5a8QRom9tHetLIbnBbQSETYutGBsFwdx/W/WyKFMo3imDCe2dim/5mlm7U8+WOJo4TUQc8kxztF5CXmhT0Nq8MwRRVjqV7zxn7/jXaM89g83RckZR27gX6+W01D/PI/4wZEdpWQDDJpKmf/ABmpNtF8vixUY40KSzWcyk/F1lRgvnYEYFEASmQ3VlHEizUnkyI1aRfdUjiCHNJ1vtNV9Mr6Ni4gsHVWLreeP6z5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ1jRX+0ssqJuTZjvSF+tZB0wcLvslrwSLtF07vGVeI=;
 b=YUrmoWOqwhpL+3R/AnK0jvuV7yGHf4H15gVmEIoW1fJKXDhADpUzDce1u17ucZst+UoZ6iBYzyaw3jNFA/p7UbW5B5Rk+ca3FFXutqZOn4WyCz3tRn7k2IHWgYSDYjGUvwXboD897gQ/5Msq5GLq3yxrYw2zIOqrHfQJk2xRHbE=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:14:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:14:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH] scsi: lpfc: Fix some error codes in debugfs
Date:   Mon, 15 Mar 2021 23:13:55 -0400
Message-Id: <161586434246.11995.6781618921892343461.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YEsbU/UxYypVrC7/@mwanda>
References: <YEsbU/UxYypVrC7/@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0119.namprd03.prod.outlook.com (2603:10b6:a03:333::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 03:14:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d60c3e-36b9-4b6d-9e13-08d8e8298d37
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB470964553CE435668EF579228E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJmgynAytpQk3DxoPr3i6q/IZU4yZn/fWW8yQNF4vLCE6eGlyZS8jDTZwl2cIyp9Zt8F0g205VtewwOpp1vW/5LdSN+T2Tr77VJU2VaBxitlafgDhzq4lLXRUucTSOMtr+OChMdG/jjTMmzmqNFIRyB8OJusLnVto5LgjhsKyeUrqsvaSzZ01amblkCNQl8FCRtFwT5zpdTZjMouawsgv73nRBbxrGgA218qoF3X41w+I3HVx+v9uqlyw0SQII+5FXVyppBKHDlOSWdM3Ng8DZ7bdGXZgmPC6I7LfOVJMFdSZbHQYSOLbTGWlSNr6Mwr6hX7xfCAqeQFZOpF3ma6cKtQMSLv4mtRuJVUwsTbMfA28w7X5g/dC6Y6YjHWKBGbRGKpVSObxOkzPi+gzU0s110g59o1c+o2DMqMBjXPLUacUOmGY/QZ6O2/9TrWOHD7HgtiJjQwq2c13qLUtPk+B/4/DFb4SfC4VT+MolG4dmzLr9/wMqUHvdnKcl0Lfbz6IJRDB2BugDqVJf/TtSHkTi9v/Qt/0i8H1jYzuCsxbihA+HIpZJwiEByR23R9o5pM2gkRMWr0JveRZ1ok/kcSaXt0imRSAqSyAVd6lZ358zYeHIsdIBQXKEQupW7qU8nn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(4744005)(316002)(110136005)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(6636002)(52116002)(54906003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K3hTa3FoTkZpdHV0RXJVeEd4NnRHbWR3VUlrSUlubi81R0V0N1pGcHhkR1pP?=
 =?utf-8?B?cTdQMS91N1lmMEdjZjJWb1JmRmNxc0ZOaW1tRVNoNmlWOVdMWjQxVkZnQTJP?=
 =?utf-8?B?ZW4wekN2a1lnazREVlY0UW1uSG5vcmFyNHl2V0FDTnNhcHFVUGFnUlljQk5L?=
 =?utf-8?B?a1piaVVPbGZTcnNBeDVVdmFYbnY0MlNjNFBETW9aaUVyMXBsajN1L0EwWmNt?=
 =?utf-8?B?VDJnTzRnYnpKZnc2RU9vQ3d3RjhDdFJMN3hpK1dTNFFZR0R5U2hnTjIyeXZ0?=
 =?utf-8?B?TGFBMXdOdjlITlBxY3pPeGNNREpLMndlT3QrZWdBKzc3VFdKS2xwRXRIcjdH?=
 =?utf-8?B?QjE2TW5ieTJ3Sk9VemR2aDF2aFJuZno2QXBiNDAyam9DTVN0aEplYmcyc0kw?=
 =?utf-8?B?Z3ZxZDNmVlRMRGVoQXlQeE9aWkVnQ3pPR2xUcFFPMkgxTnAzTi8wMTBLclMr?=
 =?utf-8?B?emQyM0hodjllRDdFTjNtcjVJZVNxajJVa3pheDRPMnFaUWdieXZiTytiR25G?=
 =?utf-8?B?SkZrSEN3d2hpVUo1TE4zbHZ0Q2NZZFQzTVh2anl5N052TkNsUHRBT3ZPc3Zm?=
 =?utf-8?B?VkJ2aGllVUpRS0hVOWhLNG80dE5Ec0IxNFlWWVhhZ2htQmFyRFd4eEhacTFE?=
 =?utf-8?B?UVE3UnRKampiRzRoVjlFakZoeGFRd0JBZHd6VUYvTkt3SnJ3U3ZibGVsVm9L?=
 =?utf-8?B?bGxjVnhrTDMrNXdyUWMrdUtIL0R4OEhFNFVNRXdWTGlaWmhPcUVPL2JBM040?=
 =?utf-8?B?Z0c3SnJJSldyUHpGWFFURWhhNlFlSjcyUnB3L1NtSlFodjg5ZWpKYkNtT21B?=
 =?utf-8?B?WUV3SU9qeWpzQUJrb0hsZFUxUnVXT2xhekpDbU9rVWs0c1AvRlhhc0pzdXMy?=
 =?utf-8?B?MGZLYlBJd1RmSGprNTdPcGdjSU5GeEswSjBiZHFXQ3dZdDNXNG94bG91WkRq?=
 =?utf-8?B?MzFBQlJVeVhnZmZ4VVNrN1FSQ2VMWitzNmgxbGpha2Yxb2hyWTEwaldEcjRY?=
 =?utf-8?B?ajZWOEE2RFNtdzJKT3JKdkF2TVhGS0h5UUU1eUh6N21CQVY5NXZ4N2piUk5M?=
 =?utf-8?B?VVZUVWpBb1lqY3R0NzhTdXpuZEp6Q1M3NGJlZjlHRnhRSHphbk1xMHIvT0Q5?=
 =?utf-8?B?MjNrZlNPekQ3alAyRXc4aWovemhObEtDY1EvMDgwV3FhQWRDb21wazFROXlt?=
 =?utf-8?B?Z0NyVFNobnVaYThVNHlrNFI3ZnFJblpXUC9oK0VrY0Q2ci92ZzZ0Vkt3Y1g0?=
 =?utf-8?B?V0NWYklWaERVcTUrdmE3VjJOVjhvQTJJRWI1MEg3akxTYVEvcmYzNTBsQWtk?=
 =?utf-8?B?cTFPYTBETGpsSDNGWGtaVmpnWFNoUnZqMG9zeU16a3VqRThnZkNPa25SNFFl?=
 =?utf-8?B?Qk5tWlMydHE4a0tNemJHcTc0WDZQSy8yNEdqVzY5R3BkZEJNaFMzd1VlVXV0?=
 =?utf-8?B?SEJMbHFWRjJuMjlTYzlMbjE4N3R4Q3lWK1dmV0x1dENkbmlhR0ZaTjdFT0ZZ?=
 =?utf-8?B?VE4xTzRqL0FOK3hOeUFCM3BJK2s0dGJibjk2MVJqNkpRK1dHaWRSam93R2hO?=
 =?utf-8?B?ZFI3SkxzV0Zxdnl3RTNQVTVrT2NRdUREWGdJKzF3SVFyVDhvUEUxMHhGTnor?=
 =?utf-8?B?aytqejg5Ny9pOU9Zd2c0cE5zeVEyMnRlTEFSVVFIbFdhUnhML0ZUOTRJK2da?=
 =?utf-8?B?d1IzTG1MbER4M0hZc0x3R0JqWVlwMDlHZFBiYkpKVnNWZlUxMGtZUkpCSXNZ?=
 =?utf-8?Q?VOmFozpfcTThfBOUo8YodXbu9+JPU0S+dTPHiPZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d60c3e-36b9-4b6d-9e13-08d8e8298d37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:14:03.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PR12jL8qBjq7BydPzWEAbwqjjQpTEl0v/2bAeyia0JGTbY0/tv+VZEABIdrU2p8/BdogcdRkO58TFRDHUlIqGhnPe6r48Oesz5qpDO5eCls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 12 Mar 2021 10:42:11 +0300, Dan Carpenter wrote:

> If copy_from_user() or kstrtoull() fail then the correct behavior is to
> return a negative error code.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix some error codes in debugfs
      https://git.kernel.org/mkp/scsi/c/19f1bc7edf0f

-- 
Martin K. Petersen	Oracle Linux Engineering
