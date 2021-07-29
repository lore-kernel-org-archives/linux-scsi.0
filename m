Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFE4C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE526103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhG2Dil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:38:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6002 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233607AbhG2Dii (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:38:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3ao1d005955;
        Thu, 29 Jul 2021 03:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1zHip4avk/bkyBu3GMpCwJTbHKw54VG8VR/14YseLqg=;
 b=CNUY6zR5vdDz1dlR2rS0l9l3MY1zBM8HpBRveL0ndo4zBC90vz7/yhyJ8C9Y+W7bblbq
 AI0VUwO19RaHrchclJODPIFFiLPz1ss5I79+3XF2Cv7Pev2JjyslwWE8ZPQl5Nl7pMj+
 cxWHeDGMDkKssP3eEj518yly9p7SLBU35HmVYkfTNBwLlAIcwQIM4Pcdb+VYysMvh12K
 HEAXahQNyq+T3vTLGR1bYy1Dn/6x31iebJu7gKhZQBLn9hipSe1QlosEJISYKLRTguNa
 HGHdB4iKF0toEAgcVibXrMNJLN3gjcpzNBxsJUSPzHtIQItwwcZFlMGpBQu+lldplpvp lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1zHip4avk/bkyBu3GMpCwJTbHKw54VG8VR/14YseLqg=;
 b=Arh9GB2RiIwZf1EtR+/q+IVE177//JwB6WxTUtzSvYULTDpkqxO0sUhziXViRmE8iW7D
 2xWBG+J4LVYJ22J1wuKW+9/36J8W5hv9D7x7mpJgmxhhzMkyVvI1067BIgLYT+xIzQwJ
 bdvvL55m3iqOjbgpHnuWIC1pqBQrUG0+X881yhX6OiCzzmqOl38uarwxvQAfUs7B4rW2
 +PCj+HJzFDGTt1ClvX8a5bfDxBYfvKSTv7bhgxWV25HjuJ12wRzeM7o7dZ0YorO5Rl63
 OtKV6shrr4cBeoprcfZELAXcgLJbuwSrB9r2MOPFQRtoHaocTfZIqCBaH0CQMoi6HhwR Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2353e20d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Tnoa041079;
        Thu, 29 Jul 2021 03:38:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3a234dpeeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ipq93XgnIRFHC5AEcxgJ6xasY7ekpDgegdBI7NegjcNnAPBDAJgukCVbsQUQZeBrcySomzP17mlXY4fa0VoZfJPuOSkZbQH+R7ODTDAtph0M1a+Pu93he3OVlYkI9TrKTrkhIU2Mz7gdehM/LvA4xkDKBMe5vn6ew3G1DZCT1fogPiWZwMqEXf6zGwOVzBaqlt0flnBNEuO4Ff7oqsxiC24VsG4Xo8RJI53KNEstAVMVR6kAQjyrIoeDKoIQ5IuFztU9ejxdppgGi54is9xcIvnUDQpVXArgEW0He4RKRZ9+4COYRUrGchQMUVqQeBboYyP/LX+ZBO7oiqMla9hIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zHip4avk/bkyBu3GMpCwJTbHKw54VG8VR/14YseLqg=;
 b=YY0dlLRJH1pMUQENM345XTHO30wqUDkDm7ei7VzAktrrmvYMSlfxX8Ex1biniwaslYkC+rWP1xQosLm61xqSnHyO18Cm6SCRltnoR3a6H3qCEQf//FR1A1Z70cw3fXpm4bV3+UBohLamugrbrhSm9xloRsGk6eCfbs27JjLwBhZecIIl7V3UUJryiwsRnfdUyuBNBiDowwbCgUxnCnOl55NdvLHegETPxQcgG667diXuBPn8z3pif3RKaHEZUn8umAMolwMW3sSVi7TDP5/xnNqF0oUYXUPnz7xOtSV/dun92DJ6RextWWKYiAfA+oHfg0mAqsoAyQsCVi67xfCDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zHip4avk/bkyBu3GMpCwJTbHKw54VG8VR/14YseLqg=;
 b=p9hA9dHy9qaf2UVx3+mevd7qpLm1zPDgROSBTqFJqWKTgR9D9v+RQ9OaUiMMqNKcJG9Er6JRVxmabDvA3zptYtvlSyJzrf/LwSrTs+1WoypPTOdMY3C5/cEo8kHogCDDPxwrvhfFH1nREYv62OVQi6NNLqPls/1kLLjBvJf2yOk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:29 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment to pointer pcmd
Date:   Wed, 28 Jul 2021 23:38:20 -0400
Message-Id: <162752985699.3150.17680789989128575871.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721095350.41564-1-colin.king@canonical.com>
References: <20210721095350.41564-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a25034d-ff35-4320-4df0-08d95242548d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1549BDD5A6C365D05801F0498EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSM24ofdu1I+kKcKQd7zBtSUcIMIvQfGk1Wd4QWbK7oIiCBbu4+sGKGBBp99D35SkBo71gDOAqaeyXmOfTrG4HkFcAuPHX7M/llXCeo3H5CI83N1z0pReXKxyzXB35EHOKOyQ0St6Gyeag1WxS8h1mnzkGH50gWUJiuHw8CpXwWZdyjC1bxCQF95LvdCryiHiF1sJECOnEzPSOLY2tPEVBiPisUGS7Nvq8becT3Ocre9tOp1XPqesbzBDOuCLTE3L1ej41sDKqsCs9KApXncnCqvWxrArmuPLVDR62sX4dJ9WyX03PqZiqb3IWznbH5VEvq2hrnBFKC049u6D2lu1An7Vn0d8kMn+PlL1F7MV5z6hoKIwJUUGlK0A5wEeFV2noV78ZZukwFPp+/uLkgKh2sdV465SwcLVWti0mqVN31uD8i1XNe6T35M/+EYcfUatxyhTn6hJOLvHeAwdXbPfQY97WfYreQxVdQjC6IR1t8ut75CvsGWQBEgtKpaZdxNrkhVi4hEcHfvrfP2e3JQp/2cXym34zQa+dEGhN62V33l0JezF8j2J2TpaZi1TmoJV5crlYjw2CyVCbpJ9VTAXxIoEqgWx7hc+cMrfu9hhlm1++gF7KeoGDYK85iUD1BIaVjbRAeaDfYvgcUuMuwDLSlZp5ExWY1oWZGR9JqcifPSmWTkmIuQ1ahnnnfCfdKffiFSWSrd/HO7r44qklqxjII10LF2269xKcW4bzekxfzl52o+b2P0Fk6MPlCnmeRq9gDWBdAvdnynlkzq5+HFacDJ5ujpaYlOL7ogP5H2cI0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(86362001)(8936002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk10UmM2bURvWU9qUHVESTVMdzQwUFpDemRGSmd1bmo5SENaN045SkU3Wmt4?=
 =?utf-8?B?WUsxTitkZVdXWlhnUlgrU0lncFBoNkdxbHJhMml2SFViNjNSUTFoNjhxUFJH?=
 =?utf-8?B?NFNtOFN5WEc5RjE5d01JaWc2WVRvSHVSb0lqVTFleFFGNTRZODdYNDdhRHVy?=
 =?utf-8?B?aDc1L0IrYUtLK1B1L2tGK0ZHeDBIcmhmdWNqSFMra2FiY2xIaTVEZlUrS0dm?=
 =?utf-8?B?bnlxc1Z3YTRxalovQkFjZWNnN3pDMFdyNDlPeTlMYS8vUStaTzdjUi9ZcnhQ?=
 =?utf-8?B?MTluUHRYRklBdkJsc0VHTmdWRUMwRVNScmczOUh6aHNVSmJwYm5ZU1RpTXBB?=
 =?utf-8?B?T3dkSVlUSmltVVMzMjlUZmxyTjhnUGVJNWVvQWM0aS8vRzB3Sm1nMU8wanZD?=
 =?utf-8?B?RytQWVpUWVNydmdyTVdpNU9LaFFSL2RzNEgzUGFSN0FuVGdPa3E5WmoyVHVW?=
 =?utf-8?B?OUpUb0N0cDBHWmlyVDdZd3JkZGpXOW5KR3pkZkZWTkFMdWxLOUNoNkJySGE2?=
 =?utf-8?B?Y0xqU0MvTGtpRUo0Q2VHSWY4MWZDNGs3dEhsNk9TRloyRkFYSEg0anovNjFT?=
 =?utf-8?B?TUJzR0dQWm9PVjlhVlFBeXpmdmhTM0RjTEIwdExJMllXczR3d3ZTQ01TM2o0?=
 =?utf-8?B?dHVpMERhVWMyNDRIc0hpREFHdFdqUnZtL0lRZ0hlME1ZWjd6Um5rZXZkZHZM?=
 =?utf-8?B?MHpKdGowdVhkYlB3UGN1OFNncGhHRzN1QnJvS2taL3djazZYQWROWERwUlVU?=
 =?utf-8?B?ZEp1RUZ2dCtlSEZIOCtjOXpNQlBtWXh4YzR6eFhlbnAvaStQYzlYSDJaQXNU?=
 =?utf-8?B?THg4cHlrdno5dnZKQzBvcDUrclRMaXRwUTlXV00zRUJEM2Uram9wUlZZM0VD?=
 =?utf-8?B?eU5GNVlYYWI2cmk4MEZheWMyc1U5MEZGT3NKZ2VXSFJ6bldvdG9IWXZnRm41?=
 =?utf-8?B?RTgwUVcrby9RMTBaU25Ud0NJSjR5ekd1Y2lXUVVvcDA2L3A5cHFoUmhjTGJL?=
 =?utf-8?B?cmZ5Y1hTZ0V2UWdoL1hYK2daVjRjVzg5Wjk0L0lPQWxlUzdUMmw2TElJSk1G?=
 =?utf-8?B?UGdreG5memVPa1gvdGdHTjQwSDNVcnhmQWw1dFFZMXRxSHBDSG9wc3NuTjh1?=
 =?utf-8?B?aEM0VTJ3OU9nZkF3WnFMWThhTHNnd3Z0bkg4V0hoOFpMWHVCWjhMUUdXVkdN?=
 =?utf-8?B?MnBZYUlSZzhjUlU5SXN2TVpxTnZlVFg5MjZQVW1RWXNGaitxbGUrdUdVNXdN?=
 =?utf-8?B?WVRYc0VZd3RKem93WWhuQytOb3pFRWZDd1FUemcraGVRaUJ0MzJIeWtLZjBI?=
 =?utf-8?B?Vnp2bi9UMUY5NDV3ZTdLODJhcTUzdk9FQkw4YnpyUE5SVng0T09ZcGxJRkRa?=
 =?utf-8?B?aDV4N0JtS0NSTnhFYXc5aDlQV1FjU0Zod2srS3FpRmMvOHJRN2ZyQ0V2c2NE?=
 =?utf-8?B?MElEM3MxN01hN3RDc2hnTm5RMDFwcVhDMXdNL2tySXlBVk41OVZOZnZFa0dI?=
 =?utf-8?B?bUpvVjJxbWJGTlJaelg2U29hTU5mU1J2aytGMnlBcm9BSmJPWUZ3QUV5aTI5?=
 =?utf-8?B?cHRVTFBqRitLWmVZV2lsWmpXRC8yKzdrUVFIMmp5Q3hhbURRNlgxdERTQ2Nn?=
 =?utf-8?B?MTBzSVFrRHM2VTJEYW93bkpKSjE1OGczaHVVTHdzbm5vYko1OUxUMytsU3hs?=
 =?utf-8?B?emhmaWZpNzBBQzFyZFNvSlRVdXFLRmZ0dEpPTW5UZkpZOEYwRXVpbDhzWUR4?=
 =?utf-8?Q?ZZrF2cEXbuaUwNl1xDDIgVq6z5L5fHsLQC1PpPh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a25034d-ff35-4320-4df0-08d95242548d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:29.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoeBHibDYmRniS/PUKL459/F/MMSIJoISHoCReD4zBvrkLkAVcGx9FZfphwtSpRSDeMcBDzCPJgXJJrMguSseb63HovD00HS8HmmNwJBuc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: pCJkY30HD9VYgdCYQoNWlVAkf69r3bbf
X-Proofpoint-ORIG-GUID: pCJkY30HD9VYgdCYQoNWlVAkf69r3bbf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Jul 2021 10:53:50 +0100, Colin King wrote:

> The pointer pcmd is being initialized with a value that is never
> read, the assignment is redundant and can be removed.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: lpfc: remove redundant assignment to pointer pcmd
      https://git.kernel.org/mkp/scsi/c/ff2d86d04d26

-- 
Martin K. Petersen	Oracle Linux Engineering
