Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CCDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEEC964F1B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhCSDqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:46:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhCSDqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:46:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Xbhs173119;
        Fri, 19 Mar 2021 03:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2CibIP03BkLByKeu2e2R28/dEryrSvp4QCPweP7heb4=;
 b=r+ePENSvpi5JOsyylGm9IFSfwzVuaqp02jnfNLYlPB5XQyyu/xasFr9kcq+Atb8b5fRT
 r/J8NGwuuHxlJwPf662yT4DRgBSlue77a2LF0oVuAd6z5fy74fnvQCVFK7a6kVWHduhN
 ess5r8QhLYONKy4Zg9s21bY6xjupWcKIFgkirJAY9v2dATkGferaFUuzLf3aMAWR66iw
 apcEmmdVEYYCsA4BkPUg0KR+PKfwkRtgGnL5RUMk8DmKecT2kogKyFoPBAjwPLm1r0DA
 cxlkuiFcOIlv98K/7L3N7+DGzZTZhylW0U2c8h0atlS/hRzoi2NvVSdjIbB8v8e8cCyc WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 378jwbskdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Vc6E007675;
        Fri, 19 Mar 2021 03:46:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 37cf2b928m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEOr6HNzqZzqQYb2Vee9WRJcEaGVMyzWuDY0P8sovML01wBO7DwQkfcVUZvamUMyiBwvbhGbOc83L6dSYphSShJT1uwuDegwOAcZwCgpzAyAm0Rzqn0XcIKZJe9fcI9cNEDtnEJ3X4DuSx33PnT17pNM4JDNFytZ1Hug7GLsoeqdNxhWz2do0hlopBfGsgfsVb7wvyTEzpCFvDMN44yRMvSrz/SxZCz1JZxH+f24f15btFIac54IH6Z6+kbF/6tZ9cVxrtdZCw4gyZn12Z53FvemvI2Yp+ZPfmiugPpyRMXr+prxovO/qEXiZwKJdBceZomwTYYPYJ+gX2Sanx3azQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CibIP03BkLByKeu2e2R28/dEryrSvp4QCPweP7heb4=;
 b=XY1lw5mGhZysMLGLuRQ+FLNzG4lMtgS5aHU0Faegte6jlRAhjHD5Wvz+LKUB+kL149BvokOnitkyw4dlY3MrSoMwQotLGP5D5/gg1W2SK6c5d2KFs9/xyUbrrOPBN1reqjw6lkQ9e39sRlBXNX6GZKZB/J0BzTytsLSg7+YXbliVphqFtldkt5amswTohbMbscBjDI/2YJwnkMwh1l4ETcrM2BUPqMUwjRZNDgrfVS4PD62nHaC+RQHm7ygVfHMdRUuug2pxHyuMMrSBHp1uVlq7BcqgD2U6FUs5EBqlgOeG2B5STvd9+ONcg8KCPfhsAFipWckAAy8plR1QlhjZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CibIP03BkLByKeu2e2R28/dEryrSvp4QCPweP7heb4=;
 b=D9505l7k33JTWeptSv+23rr/twPcqFAM2O4BMuyAJPcEIMxO7YeWer9HtOjPYJT312eJwiOoPAMw6oDiyKUn3XWgiMnQczDmw8K8cgJdnyUEsALKxvb2qeDnwhcKkdw/LhgYqGoXV/G4RbHCwltjStwWY0WemHCQ9JGeczoupp4=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jian Dong <dj0227@163.com>,
        stanley.chu@mediatek.com, matthias.bgg@gmail.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Yue Hu <huyue2@yulong.com>,
        dongjian <dongjian@yulong.com>
Subject: Re: [RESEND] scsi: ufs-mediatek: Correct operator & -> &&
Date:   Thu, 18 Mar 2021 23:45:55 -0400
Message-Id: <161612550236.18396.9242807934418664297.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615896915-148864-1-git-send-email-dj0227@163.com>
References: <1615896915-148864-1-git-send-email-dj0227@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0078.namprd03.prod.outlook.com (2603:10b6:a03:331::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 03:46:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a68a1ce5-81d9-4aec-28a2-08d8ea898438
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4616DB2A56A55DD855EDB1E48E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wF8Ne0f/2BwtWVmZJmEeaVNN1FSFo615VwhbAbA1dEXulBG31k6GdAfvvYy6wWl9PBiDtIwnM8lttD+BaPfBw/WIxcLJ+YCboexNR/kzjZHe60vRYYdzp3GzomzQxyKhbuU5h3mSijwp+iRm7dMoZDRhOQ0v9LFKnQlaa/oTP1l8MqzSD0IkEH8GPOZNXgAqPc3qWC562BlmcvzxjMgls0Dufn05DM1u/U6OOhMsuwwLBiSkvfuIcvRIa+iSYp7O/0Ho+5hwo3ssovQu+c5mQxVsVKEA7+pOEWxbx/1dx+LaXy+Yd1AuA9DNKqeyOYhRLlWtOW7kDJLtY1OGyQDqiur0IWv16khkckcZr5QmeY3gLXcPbG1sM211rGUMK9vP3q6a5docu2i0taONT0y3r6i9ONbxeQ86RiUr/vEdD06bxwb61tL7ofPDmqun+UujR/844+md6r2wx1YRlybh5ZIOy5o2pvFIKzLuqpODaIqx3SJVl6Nh6A4jY55XMbifRbfYzK9UlLIMzl4Redz7GvDOXcrC7Rp3DzyMgGKIRGuSlkdxb/hG/LDLIrKmM1CaOJ5R0ZiJ8ivvQXVpKeTQfzeB+bCjPtOtSSlLRIbWGxwd84gdKfx5glWSTh7f6PEYgpBCZXGxegfVT5MDGnqOW5uLoBccd9WqJ1XbNUuGA7+rJvBMBUBLKa1th1KEKDVxnxnZsGJJmOfX0z1tF1T6XcimGLBcnmsS8z5NcohJF1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(956004)(86362001)(5660300002)(26005)(6486002)(16526019)(2906002)(66946007)(52116002)(66476007)(7696005)(2616005)(4326008)(8676002)(4744005)(6666004)(66556008)(478600001)(316002)(966005)(54906003)(36756003)(186003)(103116003)(38100700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OEM4VDlYSTFRK2tTOTVKQVhUSE10VDUwZTVOOVlDUVg0QllsbGE5bW9NUmxO?=
 =?utf-8?B?ZFR1SlBsZ2s0dEgwRnRzYzVKVU9QYjlOZHE1NzRjWENXMWUvL2lWRG9CSm5V?=
 =?utf-8?B?U3NPQ3paMnBzTG44UUluQ1k5TnE5Nno5RVg3anZ3SFZtNEFSYTZPYmxLSStj?=
 =?utf-8?B?T2NDTktzS1EySFJnbTlvMXlGbytFMmZlRXpaZGk1ZlIwMHNaVjFraStjT2t5?=
 =?utf-8?B?STRmUUJsVnFHcXJBMGI3TkppNkVkMlBobWxicnB4aFRHWXRVOVVOSnh2eEEy?=
 =?utf-8?B?VllQTENtSG9hczltUWdMYmE5VTlRWXl2QVJ0SEFpbEh6SGVwQjI2Q2ExS1cx?=
 =?utf-8?B?K2ZCWUZEWXFST1dDdmdsbzNmb2wyRFFCTjVBMHE2SzUzejZUNkt1OUppZ1hx?=
 =?utf-8?B?Y3hjcGhlR1EwWjBmUjljbEo5RDRrRnk4YndISjNUdW9UcDY1cmZNTDdoUWxp?=
 =?utf-8?B?dnRUL1dOcU1BaTBlTVV4S2FydU9nNnc3UTYrc2dqTVhxeFVrVGFEWFBCcWQy?=
 =?utf-8?B?K1dHa1A4S2dRTFFmUXpDRXRZT3dtRXg2SVBaeHFNdmtXSmJheWwyU2p1UVdP?=
 =?utf-8?B?eVVHLzNDUWx4amZrcWdoNms2V1FkWjhJK3ZSZVU0SUFFVVJNSWZmTEFzZk03?=
 =?utf-8?B?djRlSE0vaDNTQ3BTejFZUWxZaDBEUUlrUDdlSTVQaC81ZVdWRVYzTThyU3N0?=
 =?utf-8?B?b1o4YThuWjBqYjYycjNJb01lcFpRSDArOHcxSkQvYnhkbFY1TEQ0RXpEczgz?=
 =?utf-8?B?OWRmWkhNSXVKOUozNVpQQWJyeG4rTnJDTFhkeE5RUTJDUlZFUkxhcHFyUllj?=
 =?utf-8?B?a1FvQ1l4bFpBRm9JQTB6TzNHZEdIbStQVGxML09KUGNMODVGQUhKQmZvc3Zm?=
 =?utf-8?B?KzBENFdKMy9lK015OXIzVzBUV280YWN0bVZwQzJmaVRISk55dDhBcHRseGhw?=
 =?utf-8?B?bWlVOFR3THJ2VDhuWFprRjg1UFovZVFkQkMveW82MUVsSjYra2t0YS9WTjA5?=
 =?utf-8?B?TE51WnNaZVdwZFJnaEtvdmNHQmhnOFpqVmpZc3pRUHVJb0JFbWFsVHBsNnpk?=
 =?utf-8?B?djZJendVcG9pMnZBcEMxV20zdW9NSk1rNW40SE9ma2VrYm1tdnBiQ3M4Njgx?=
 =?utf-8?B?Y2RZL2V4WHBINHZhUmgxRkVVK3VFMldsUkFBa2FyWW1XbytkUC9vcFhxNTk1?=
 =?utf-8?B?T3IzNWJoWGdHdHFGTmxMYVJnUW93R3JmemFndU9pQVNNbThLQmM3TXNWbDdZ?=
 =?utf-8?B?Z0dZUEF2VC9wdC94RHZsa2FONEpRY3l4NlJaY1VickRHU1lhMEViNWJqNVE2?=
 =?utf-8?B?U2RWNWMzTjB2ajdRVmpXaHhiWlJMWTBsRVRrM0pwUGdMUjd6OE0yenYzY0dY?=
 =?utf-8?B?MVRjU3RqclMrekRYeXRHMWpQVkZML09WaDNGQ3ZYSXdhSmNSSVpwUGlZT1Vy?=
 =?utf-8?B?My85OWhyK3VSSHJjV0hqYWRaN3dRbmNDTE5qVmxZYlYzVE9lVDZrazhVazl2?=
 =?utf-8?B?dmNUMFFOVjhkRDB5MDBpbXFXZWtVa2xCUUxycXF1YU9pQWFwTFlYblN1UVB3?=
 =?utf-8?B?QUNBVDNrRyt2VDdUYmJ0R3hvOVV1bk02emEwRTlqQ0lqZHVFL1hnYkdEY3No?=
 =?utf-8?B?ZFFWdWJQZ1hEbFZHU04xWXJ4T0lyR0NvSTRaSHliS2FaZFl2a3h4cjU5eEhy?=
 =?utf-8?B?OUpBekt3UktFenY0eHRVTGVQYm9BVjBmOENSbHlidkpGeGZRMzhOT1lHV0hl?=
 =?utf-8?Q?/I1qHzffpGQlZhhIhPCix+E1hWfPfLgx1HFeLVb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68a1ce5-81d9-4aec-28a2-08d8ea898438
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:02.4319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlCKXtzZlOZkpGlvt15RVXydQKdAWPrmQ4fKkb/GBQS2NFRpFRijzQra+fD/ZW/L29iivIUrLMF40ZiVdNu8/vZO8x99ezy/+F9Uscw+G3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=893 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Mar 2021 20:15:15 +0800, Jian Dong wrote:

> The "lpm" and "->enabled" are all bool type, it should be using
> operator && rather than bit operator.
> 
> Fixes: 488edafb1120 (scsi: ufs-mediatek: Introduce low-power mode for device power supply)

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: ufs-mediatek: Correct operator & -> &&
      https://git.kernel.org/mkp/scsi/c/0fdc7d5d8f37

-- 
Martin K. Petersen	Oracle Linux Engineering
