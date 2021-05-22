Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCF8C2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0152660E08
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhEVEnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50502 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230058AbhEVEnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 May 2021 00:43:12 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14M4dG7Z002711;
        Sat, 22 May 2021 04:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MsgfUp2H25dI6Z4rLOhC1tM/3eyxXK73sBo9lKyc63w=;
 b=BRkj2VVrVI5TYQaLIqjJ5XjPjnu1/XerkoUYfuWoUuS7KRlXAfpynd4URao9W+4fVLtY
 WS8NRl8AtR4KBjQq0vnP36DgUc3+8C8rvg+wW3K0p1Hg4eRfPEYZiLtZRV7h4+66IcJz
 fEzxmegS8Hz405cAIB0BX8Du1Dlmz3t5uQLslmkDuLnoHesKDA6Rj9pevsRFrofMg2iK
 Dlc/pHz9VR+1NQaaSQJ+s94DM3XwFNCXX5Rwg/Ft9Fti9BD3d/UcOsrzDlyiETHez1lX
 X4F+7xGBN4wDFVEpMBbwBqLFTkdZxQ/tRE4Zkl09PyFlgqbQ3LOXnF7b1OhPMNoCEnBK bg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38psjs00qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:46 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14M4fjnD080034;
        Sat, 22 May 2021 04:41:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3030.oracle.com with ESMTP id 38pq2rp5mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDfzNF83Zz/CFqk57W7NiWyd7r+02ruWvz9iGn4uqICcKVyiOSuyJLI63Eu+/GBCsq6jQUWjpsbeR79BDnsnaO2Hj0dJd4IN/4Yy6fTBA9JRYl2Kx0fTLlGQw6x41cjMwaAI7OJaZ6k+kNT+LjSJhOYQCKuVHwNnVF1ifFLwVLnIWwGALLgSISNxTjU9qwwnlqStPjzVMONOUl1JSoWrUhJsl1XG6lmXEsmLqd5mlK1nCDmJPFPuEnihCEOEqIOLnuZrfbMA4ABBce2J+Onr5ZTHuLCZ8IWegQLd4iSwhyRVi4QlLf1zc/9EfWZLsjssv8YD+MmiWAKu8j41uRoRCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsgfUp2H25dI6Z4rLOhC1tM/3eyxXK73sBo9lKyc63w=;
 b=PuymXDP6cIp7Ou7WlT2erqGEoy8Ffeg7F0v2lT2izXBC10JBPHWJ4pVgl8W2246EMIY9+3xFHQ5Qh0L5quvm7TBbqGghdhMsXQABj/1rWVA+ETFNOi4Z81tduz1aT7oQPbcYskD1Cz4YX/yiZLIhvP6ow48PHeXX659j+Smo8Oec4GwDFfSWyy73ETOcS/uO/C3x/7gta9SnfzlfSbaQa5corfgxqO36hc6L9Rhq2iocg0JhmLNIR7iqcYu75FcjZmS6zYACm/uWb4gSozVisgDrk+0r4DSxdtDHppIdx57jtcWXU9TbmNUE9RKeKTNzx8eRQphui8TfroLN7MDdgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsgfUp2H25dI6Z4rLOhC1tM/3eyxXK73sBo9lKyc63w=;
 b=tbrAWcQ3c2SCzANTSxtKEHWck6SYHken9BjpF6NuRd2I3Hl5vB0IJoSN6gJQoxWDJVn7vyeXBePJeWPfyZUB47Asrt2jpIjbGluQNoZY589cNs+Dq/HNZUA6kXO6v0yY65yO5gG6EH6Zi52zXJPTuR+ELTjK8qBwENZ9SdicTlM=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:41:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nigel Christian <nigel.l.christian@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: Remove redundant initialization
Date:   Sat, 22 May 2021 00:41:34 -0400
Message-Id: <162165846772.5888.12654307876380553286.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YJ2mMHNqAgTNVVj+@fedora>
References: <YJ2mMHNqAgTNVVj+@fedora>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e79142bb-1374-4341-4bba-08d91cdbe60d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548175BB71C8BF3F5331A2068E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIxUR1+FfXyKCauPbXMb69s0tYj/6JNc0XGaKXEmJc7221TDaPksrdummYQeR2nCdKReohCVauy1/4PnQsVmdZ1RIHcp33u9vEaiVn1x/68IIzO/0fklXcgoOjcZPq1q2FOkMN1N1ADnXUS/gDEWdEi6FQjrWQDEPJuXNNDIHxB/PCoSQSYxv0G1NbDRXLGXcyT7oO8Mn5CN7t3QJL2zfCJhn6CGo7tQgCS9dC7e66SHZQ/LWszKtJq5G4YTjtsgaUlzMfykni8V73qtrXeYbTN5wBVtqq8AfnFSCYZxeJNBoIHeifa9uypENKRC7ozR0BmjCzXF86WSwbvAWl08ezOFH3CO+jBSSeL+U++Hp6ZMPRbDJDn8Rh8czS5a69mF6l0MXxGeFq0DIstDJsT9lF65gBbDn1GEfZGx0VjrriJcGzoQl8PRpAvw9rRQNcsA7fJsDziRPVRoUzaWH72p2iT8JDVbuaRqtU0jtQFFrAoDav5GpUZbPgLc6eIkyK/BHKmQDwxHaABZuLVPMFfMxd3ALIzxJW+UPOOvAJDrjrScXGTwYZQrzHnEJTSnPGWdcvPphdKyKyvwfv/Ld7fUq6ek0NNIrSxMqP1vfyUjIQCkCT/q8S1VOQVEjlTcx6K0Swb7gOR20uOJE6JppR7x+8jV+ZadOUHNSHrn7iiBXEWGtKMAKDbuK+dJXFC2hPvaMFQHjWfnhjC5SVJQu5tyNJlpp9qZXWEnPFa3GcK9bJKgkLNJK3UiNZqrntmvqePHncWP61K2LBS3GV2cx9o1Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(110136005)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1FyUG5hd1dDVlVFbnVtZWtZUmtHYmhHallBOXBENmNzb0Q3blFyUnNwdVRr?=
 =?utf-8?B?MURFeEtKUW1BTEZRa0JieW5jK1Y4QzFlNExSWnl1V0lJY1Ayc3FkdW9kZ05C?=
 =?utf-8?B?N2hCN1JiMTVlbzAyNHphb0JPWjl0UXFlcmozUENORzNxOHUyN29PMzVpY0Ey?=
 =?utf-8?B?b3NGTkhaaXJ4aWNQNklWQlB5U1pUUnlvNm45OFpQNk02bWE5N0RCUE5abFR1?=
 =?utf-8?B?SzcxWkc1NlZPVnhUZnpiRzhaRWl3SS9saWhSSm1HTHVNYVU0WkJkdzE2R0ox?=
 =?utf-8?B?WEMxTWVTdDZsTFNZd3JTVHdaNmh3WFBiUXVsYWtqYTdhc0hZR3FtSXZKWllj?=
 =?utf-8?B?bFlneU1IVllvRENUTFEvaDNZRlR6NzdiWC9rUnI4MFQ0aVNwRWFKUmMvY0cr?=
 =?utf-8?B?OUowOENQZXBxcVdpdy9oK09WUHRNWm5nNFdDRjFXK0xUMTJjVU9KWkRLVDN4?=
 =?utf-8?B?UUo0bFp5NXBDSHFzaTR5ZS9JalFSK0ttckdzZFpqQlBZVmRWdzM3MTBUaHhY?=
 =?utf-8?B?UFNTTllGYVdkTjdFNlhERllSdzJOL0NmdWF6QVJEdWUvNnBTTmhQWlJJaHNH?=
 =?utf-8?B?OTNsbS9Ud2JHb0JaKzU1dnhsblpCY2JDclJ3S0tHSGpvbC9JREhvMGI1VmdS?=
 =?utf-8?B?dmZmcTFpVEJ3cDNkTWFGcXB3c0FQYXZGaWcya2FZbnBlZGNCSit6cWFRVEhK?=
 =?utf-8?B?bXZkaEZjN01oS0xUbUpaNHA0eFVwNkZrM1hOT0ZSNUg1UFNUcHlIYUY4RkFZ?=
 =?utf-8?B?Y0E3U2pGVFdET09tRlBiSTZUMkNRenRuZ3kzdHBlbTVUdmdtZW5tQmE5ZzZt?=
 =?utf-8?B?ZUg1THNEdUVWV3lwMjdaVEpJeEc1dkNUYkpDOERZelA0TTg4Q2lSYmtKWFNS?=
 =?utf-8?B?MnZ0Ym9NOTFUaFA3eHJyOG5ZaUc4T1NHSEpGS2VlUVZwSjFjUkVOM3dUc2RF?=
 =?utf-8?B?SWh2ZFRKc0JySnNOeUMwbTdZUCsxWGw0aW9wUGtEWFNFMUNWSnFHdmswM1Rj?=
 =?utf-8?B?Qzd5c0NZa1NMWG5tMExwdkNrcVNCWEd4TkxHaE9HMHhTRVJKUGg3WWpQUFFs?=
 =?utf-8?B?QjdLaTdFQzFMTzl5b25GSElidXYrdThnckZYa0hGQjl6NmxaWWJEb3g3di9W?=
 =?utf-8?B?c29ndVl6NmhwSmliWEVaWWpDR1duYWVqMU1oN1cxUFZIUUgreXhWWTRQNkda?=
 =?utf-8?B?ZnF6dHcwL0ZxUUg1Wk1iR3Q3Y1VONTNBM2sveE5Rb2Njd1ZrQjVFbjRXTncv?=
 =?utf-8?B?clluK0RjTENNOFVzMDVndEJNdnZvbjduTVhtTFFBTENkMURlUnVoN2wvY0tM?=
 =?utf-8?B?VEVscWJSWUsyZ0cwVzJTMEFoSVNLQSttaHhpZzYxOFBubXg0OURZbEd3Zm43?=
 =?utf-8?B?aXFBM0Ntd3JkZnVwcWJORTFLYkZNanRlYnFxVUJsMzVDbU5Ybk96bk5HSkhQ?=
 =?utf-8?B?RGErN3ZNK3A0dkV2QnZ6cnVWaGR4b2tiRmt6SlpsM2V0d2dGVmpaZHFSM3ZD?=
 =?utf-8?B?M201bnRteW1hN0JyWERxMGdJNUxjRHBoQ2ZtNVdSRXQvdnI4a25MVHZtVkpm?=
 =?utf-8?B?ZS9ScWlnWFQwNzhBSWdOb0V6RmlKaUFmeXY1T3pwdkhBVGk0NlFyeWY2ajJU?=
 =?utf-8?B?bksxTmFVemh4U2hTaVJRQmxrZnBBZFRCNmtVTUdYK3o2TkZJUFJpQ093SjNk?=
 =?utf-8?B?SWJXZlNnbktieTNva3p1V3E1bzZ2WGVmR3FFTjRENEFxNHdqc1lvWE5GeUYw?=
 =?utf-8?Q?XnkBicUHmalx6Ih7c6nByS6QVhmy418ZyDD35Bt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79142bb-1374-4341-4bba-08d91cdbe60d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:43.4345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATm2cJJWLdWfntx6iRVtrYR3L571puQDqAp70dGPOC6EatUJ1xY9ihBIXvPmqXW1kAnUuLdEoGcEyH9t1ELbJ1eqNw/tGxn6MQc9l86LW+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=956 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: rdDox0nsnBTuo5G7HESBgSf_vee6iuiK
X-Proofpoint-ORIG-GUID: rdDox0nsnBTuo5G7HESBgSf_vee6iuiK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 May 2021 17:20:32 -0500, Nigel Christian wrote:

> The nested for loop variables i and j in beiscsi_free_mem() are
> initialized twice. The values outside of the loops are redundant
> and can be removed.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: be2iscsi: Remove redundant initialization
      https://git.kernel.org/mkp/scsi/c/0edca4fc633c

-- 
Martin K. Petersen	Oracle Linux Engineering
