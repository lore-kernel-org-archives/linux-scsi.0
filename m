Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A10AC47082
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E57961090
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhEZEKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:10:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62244 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232457AbhEZEJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 May 2021 00:09:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q47mHq001212;
        Wed, 26 May 2021 04:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xrzLwq50KLE4RMAn1GzV2R6rJ8KSgP1+voY4grp+5eM=;
 b=yhvj38u7+SagyfbMyG9DqrFwc2rLr6lQsJB5m8U2rzuFEj1l5FbcodlB8pXstklEg6x2
 eWDugfkOjT+BIpFLf8jNEvUUE5OrBqjVlvfvJzqrnqf8kgzhdDfHTtKpEb0Dhuy7gkzW
 8Z6LcOrP/lDUvB2yCa7Oy48KQB+lOOyeavJkZ17Bg6fGpmgY/ov8c1vT0WmM+b9qBnTs
 sAJOL4z7VcCFjoqlMfn++uR+ov3w1Gapsoz6vvplpXxVORC1nyXflFgTlmVHntTds/si
 BvzEmNhcJykR2aqTAoj0I3NKqWp8UU3Z5yMDO6wnRkR8ZnCC4Vgux4HMMMLvBayHPTGS vA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38r1bdrwse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:48 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14Q47lKw145193;
        Wed, 26 May 2021 04:07:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 38pq2uvw5r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am3C6QYao682y1YvMjo+WzKbGggZJPUXOWJzjEAJmVlJg4VEvgF0PuKt7y09O5cN4FKM1ywimDheaNSh/GWX8yLTgV6f3BGFSLuwbnA9oU2JS7BMMd1LGnxl8/I5FPMhY+q3Vo2NPNF2dj99Jtym3R2tD506AwHfgdeE5zyooyaCOlR71MNKLghnIA2rRwMkDK1SULlxLwhRkg4QH3l1jGceRiOONkzOIEHA1yqZ94Fsl+BkEoa7tCI+DQ79cv+QNX3R9Cnip+Krwzn3/UgwZbtBQXb/8ehqUhWnQbSy9n/HEW5jp9Rn0dnqV1w/Awb5mu+X+4pKEZKRQh+zVcJXgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrzLwq50KLE4RMAn1GzV2R6rJ8KSgP1+voY4grp+5eM=;
 b=RrSQdsJ6Osj8olKWISn/zHJuPrcA1az65rj1HTGVXPap+TFm2w5IYLaGCq75DHLpxRcW1ihbaXoMzXCwwZ+JxHmyGTeVKNsj06E/bAclBtx4wqczM70ncdQJHceoZv6AjMgPhUpA2EPEocoPlaFTLWKXg0PYYfONHOMzwCcnq94l+FEs/QVyQVhVf+eWYvaWlTHtT8iR8YN2Y9oGGVfOQ/7O/egyn074Ee7VCWcxonF+gdQ9IKTw8Doa4p7WPRJFvxh6qzw94RlJn1KvZA+/Ly841yUxYsiaqzyZsYKOP5jwjXZcOwZw168+zAM57o14GWbcxIp4SuJ21IuCwNDw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrzLwq50KLE4RMAn1GzV2R6rJ8KSgP1+voY4grp+5eM=;
 b=vsZT0WC9ZdCmMG0z7FTBHur3B9jMdk8LRBLMfEfoCnciAM6wLJMVD4ozuKnELv12LA/ZB475CPIOoDbi6J+QULXJjMXBY34V/YBnG6BTSpEOLLCTR7m7B6R9GzI4vqF5Z+lZViBmDJ2l0MCfh6j+g4mcGIcROwwcX8RlMgi3jK8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Wei Ming Chen <jj251510319013@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH] scsi: fas216: Use fallthrough pseudo-keyword
Date:   Wed, 26 May 2021 00:07:23 -0400
Message-Id: <162200196243.11962.18235040415868902777.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518131823.2586-1-jj251510319013@gmail.com>
References: <20210518131823.2586-1-jj251510319013@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82eb9f05-6a3d-44cf-a638-08d91ffbd11c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469AEEED64AAC995A8D34628E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EpkXpuFUpBkU0AA3LgIidPe2Zukdaf4VAB9/WP905hp7gHnaPXb7075s/F5YrKTyxyAHDz2aZ6K7DxN1pIzrqAmq7alW/wZWD58+KY+LfXE5zHZqD53XlJfNguRFZJ5botH8Y956YnTr9/D3VhHDCicHsYj4Au1zz2GJznBmRp+2AeTYZbXg00VOHnuP5hfPis6WbrSiJpdbreBKpmivoqsKiUb2QBFn5YJiylV+1HpBWemBwt0kWWRPD4EelbJm/m4IcEC01uOcupxMZJ0godG27Hos6qCnKzU6hLqWRpAtkV5KXc4xJwvjHndkUoMdFZ2Pq+xfbVwZLri9CXe/sstf+tiqaFtmFYFKcabG1QeHT0etIyCMw/4G1SWyCm51CHKpVV0g4XMFoOVfHPoUGFhOVm1s3gk6JdzbMQwRVX+A3ObL1wF5HDLZxfWgdwwG5gnJ7taTi9DA3nWWPyCFDNx3sEOv2epmQkGYzeamTQyvuDb/OQ+ebM0FkT7dCNRNTs85U0w6AWB9XC/SLTcL1V+JzAAaVE9N/sGRqX+MgFxLz5IRzOQkCmlXk1fMzCfnGciFtVqVJJv9SIj+j2LvlI8XRaakaih51XlyKtJqz89+vcUnAt/QdTmGx3Uu/IQUWUE2h+WzQjCp2+k/ngXlTHA35Y3dUJq7VZ2gk2cfwZO84AqVHBmlWTkdfUDvXSUesOAGjB6YuOlnPOV9bn3oG0/td5EXb3WWwiqM+q+2yK8yC1TGK15hZnId54Cz6tKTgQsDbdqxmng1VcOMzdl6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0NYWmJpTWRQWUMrdnVLcjZpd3UzQ2F0TmQ3dmNSUWF3bVZtWkk0dVRQdFNs?=
 =?utf-8?B?bFlnM2YrekdPcjcxeDdDeEVZaGRIYi9Bbnk1Y05BaWpGY0REZURiK1ZZUEoy?=
 =?utf-8?B?QUtMZVhxbUFOVGZJeXZhZTR3aFBEcHZ1bERsK3pvajV5dmJkMkx2eGtTaTh4?=
 =?utf-8?B?WmtwYXJPR3JQbjlwVW0ycmZldzQrZFErVmltYm9QZEp1Z29LZDg0T0Y3VlZk?=
 =?utf-8?B?UzRzU0tuR1NLTmlxdklzR3p4cUNmZG4vS1dTTUlzMkZmTDdwMmN6YWF1N1lR?=
 =?utf-8?B?ajV1akVsd3A2aWloN3Jxdng4Z3lUNk8vRFRuNDlTUlkwNFZpNEMwVXJjaUcy?=
 =?utf-8?B?MWFYTERQTTFzMU9sTVBPOXQxc3l1YzhLQ3F0VElMVFQ2M0xybkdzR2dKa2dB?=
 =?utf-8?B?bU13RlArTWxZcmlFdktiWW9WN3FPZUFQQXJvaGliRW5hUXNHcVFiVHB0VmRK?=
 =?utf-8?B?dnN5b091Q0lYa0kvcmVKejB6emoxMkk0ay9kUHlCM292eEh0b0xYYy93UTBD?=
 =?utf-8?B?NUxnbjdMVDFoZkNoU2UzZ0pxNFVhR3B6VGNzWkJreU1IWVgxa3hRSEdWc1Ft?=
 =?utf-8?B?bW1qenBMSlM4MVNOaVlJSzNtbCtjd2tET1NCUkNOdkNHZ21MbnBEQU11NWdD?=
 =?utf-8?B?a2RyRlAwbXFiYkk4bFNPNmU5NmtsQjdSSDIrUXhON0VNUXdGa0NEbTZyRDdp?=
 =?utf-8?B?SEpqazQxSkUwZFJRc1RFVC9taUk2SGFYcVlYYjJRUFp6SzBScEl4U3pNNmIr?=
 =?utf-8?B?UzFWeWRYMmdoeUhhczg5SW4wTkVBS1pyMHc5WHBPbytNb1FMMnBUYUFUcTVn?=
 =?utf-8?B?V2l1WlRMbkJzOHpnbDJxUDNqSmprUlVzWFZqcnhOTVN0YWY5NXJWRmV5OTc1?=
 =?utf-8?B?dzFteGM1amRLT2RubktCeEpYQXFGeHNIc3hxcDkyZm5SemZXQXVHZUFkWWx0?=
 =?utf-8?B?NVN5THFTVXFSSWU2MHoxSmhaekRoaWg3VjV4Ri9uUlNJL01QREtTcXdRT3NR?=
 =?utf-8?B?ZFVvZU9ESmNucGQvTG1oMjNqOElQZ0VENVUvQWFJYU9adWpRN3JvOGUvS25t?=
 =?utf-8?B?YzdRL2xzOG0zMHRwK3FRYkt6K3ZCSTZhZmZrVDRzOU11bnNJUFI1YzBxTnRR?=
 =?utf-8?B?dWdPWldBL1poMExPSys2MGJUeXhvZ3ZUS25uMmtCM3JnODhFeHk3QUxKQUVM?=
 =?utf-8?B?bktrWGZ1SHhOdE1yNzduMHNNcGhjeXIxV0J2NzF4RWdsRWhPRGJwODQxSWhv?=
 =?utf-8?B?OFJlV0RJOC9BMDloSFVKV1h0R0xYb1V4ZExkWEhmdDF5TEVPcStWMFpwNEZ6?=
 =?utf-8?B?Umg3aVhLN1NpZDJUVy9PQXhuNnplZ2RHbHVDZ0J5YWo2a1RTeWdqVXVPZlZT?=
 =?utf-8?B?K1RJczRPdGo0RzlUOVllUTN3NDA3VTlxYys5SXo5MGFueWtUQ1BRUElidEtM?=
 =?utf-8?B?SUVxdjRVK05sRk5NeFhvNURPalhCVXBiMEMrK0pic0ZUbVQxTWxRc1B0UlVN?=
 =?utf-8?B?Y3l0SytsK2NVekRQWVRwNms3b2VhWUFCMWFGYy9SMllBckF0cnFiR1h6ZWpQ?=
 =?utf-8?B?c0h5K2RndThkYWFJMVRPWERYRkNNbG1IUXJWdjMyV0JkSVRoK2lrT1R3enpB?=
 =?utf-8?B?eVRSb0dVN2g2Yk1MQ3VwbWNId25RQy93MGtuaUQ0YUVmRFpZOGRsM25xQlRU?=
 =?utf-8?B?U2x5MTFtTUZ1ekF3RytoL0hDMzhVekRvTFc2M00zWGdvL25VRWpIOFpuR21j?=
 =?utf-8?Q?3CJCjl8/5uofGbTXvXHFeCuRnkduz4iGY5MdOgN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82eb9f05-6a3d-44cf-a638-08d91ffbd11c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:45.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cp+pwTLOa9wUprvqZvO+lrH4pwnqRqKoVa/e3S6nXNfU9VAxMSqu8C5YJxQFYeazLA64ocOFyGV6heP+KIfcNvkmyFWdq5iaVR+WWaN9iNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=722 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: k1R6p8-AB68JSmTsh91g4RVj9_yz9svK
X-Proofpoint-GUID: k1R6p8-AB68JSmTsh91g4RVj9_yz9svK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 May 2021 21:18:23 +0800, Wei Ming Chen wrote:

> Replace /* FALLTHROUGH */ comment with pseudo-keyword macro fallthrough[1]
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: fas216: Use fallthrough pseudo-keyword
      https://git.kernel.org/mkp/scsi/c/86cfe4ad248d

-- 
Martin K. Petersen	Oracle Linux Engineering
