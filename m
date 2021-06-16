Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053D9C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E141E613B6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhFPDvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63232 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231251AbhFPDve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:34 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jelV005731;
        Wed, 16 Jun 2021 03:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wAFAufewgBW70vJRwFwojeuhNJgszNAsQQd4ekV7VsI=;
 b=TQPGWHJxRZSLgAANWajQCAjWVMaJmHmgaq4Ey5vzikN5WAZD4wqtVSPYWDGxan0MbH0W
 27WaXZcvKQissSQbgVvfZDAnliE5okFzNXZaKpRBNSwCgvj2dvBR11TXa3nR95UpJDEJ
 qbbbN/gKTFNiYO0e5cDP5M82elXTY56vOXQ0PhGSjxrA2Wgxvq+jGxbPuEnKHkpKrWL7
 WR2lRqEQwdfiJZtVf2wPJQMtXz1Jk0bWdVIpxFRc2x6osTOmMa/rhUJUYm2uuJ53dsET
 SHc2lPh60goY1oYh1XQgVrKmrRvyOFQQzT2U+woG7Lix9UE5vT1svo7AV26zn2IraNoN jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qsty1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3j1Fu033989;
        Wed, 16 Jun 2021 03:49:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 396was6yqy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAavwj9Eng2UJadD7WgJf0PKJffxlsYc29sC/WpwXsk5sTYHn8XYowpRkiiqJ/BZLQS67MDPE1ld8evs1R9R3xflPQ1m7kiQhW0RecPoSAIlFDimTTyhsXMpfVGMair6ngvZPuCYt96/gyP+EONlsESJh/1w+Ac4mBLVhe0aditX5Zv+E4xw/UoRvA8NfoLZYfli6V+sTZ1bEqqmewtSfa3bCG82JjuONIxxaR9JeWIvoWYUWsePat87YWZl4Qwa8+R0EgHSoiPT4+xisx1GLhBPUlnjDREnmax3Qtt4JDfRC0zJp3HPxmknjKWSL0foWuZSc6D/O+/wp62G4RWnMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAFAufewgBW70vJRwFwojeuhNJgszNAsQQd4ekV7VsI=;
 b=F9BkqeUvJ/hg/tymRquCXXiHXzTyWkUbdPzwbjm/CjBUHJsR64gFLf7Ytspeba7FKLKlr/HJPkxcjRE6xw7nv5vg7rSy13LkLU1znuEMfQ2r1mPWmjOiQ7urtajUgW2Bl6tn+6xamxBHI/84USF+pRIiQrfRhhfNGbdXgjD7FSqoQ066J9AbT3jZ/nDq8lgAQvEcdfsCJU0SYpRuZzx048Um/OrjQF++YsEACzMpu/oIIa+VAS6obwtgb824DniyiqXrH3c5ScvyJRznVFyHrbIDfMPdgBuUY4Oe4oJqtNvor3u0nRrgcaE+OW9WOQA6dBPQTPfek+ExDJwKBA3wpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAFAufewgBW70vJRwFwojeuhNJgszNAsQQd4ekV7VsI=;
 b=Ihcldn0swv/SpJBT7GjmSaFUhWswPTn3CQ+oRGKBFy4FGg3JbrQHJaty6mhR4BcXnxtnUCHnMpzKmLeQc+DqpssM/6BHTBi83U93BJoxt7ZZZwSgp1kUFV/x6vMK+jStJTsOwDUNFk32Xvf3/lo46ylZANzEv1rumwa6ngl3wlU=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH V2] qedf: Update the max_id value in host structure.
Date:   Tue, 15 Jun 2021 23:48:59 -0400
Message-Id: <162381524894.11966.2987383714687486704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602104653.17278-1-jhasan@marvell.com>
References: <20210602104653.17278-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63634509-fb50-44d4-78b5-08d93079bb5d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466380FE7DADF43FBEE183E48E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIg6CSsiGw2mSgAL5BOLOuFnmEJIpDsO5fz4L9F6fnvG1K8iueClwfcmqgkP//Qs4daRPTMR+kxIX7er4HfOal6mpbWUcdz1DGSC+MDUipvtO01BA4fH1vq28+r94st5SPxV0IUZ3c+0jBTlR4vA5al/3D282Npwz7ZYUumG/UaVizyg2VSr4+EZsUvwWI+OYqWQI0wod0Dhd7t7mNqDpl64wNnJdxA3EsdmFIhoUWf0qbFKL7IRGLt2ArJbH/SZREpjPZNZqMO3wdZrWpH3V5n1ydvTOARg52CX5Dv+AsSAaTeAJ8fwopi90s+tFsDZZUidzRtfb29hrpyqRf18JGysR2Mfwy3UbKQGnb5bBge4JREnuMAYEozJkhGFdIIKYEDejl7mAZ+7TJ2+3RO1wSWbXBvkFE9p8r4Z0duuFRTe+2HlqkaOUN4/byAptDYPlWczzeDOp2dXRn5kGewUbk/IFSYcfrkGxUJRfvnBfA5+OHY5Hg+l3EXdiudVLtk+OonaVsA+oxixITXtcHKMoON1hb2H2M0W3xn3OA2Z4ZFALJOECUg1Vd4JH7W6LMFnTupCbZP5kH9rAqodtX/DI4WEgakFGMyl+9kTa3OoAq5r2CFMH8KLDnPVjKMWABwbW4w055pJR0b/5jX3gnommWwbnI6zaEA82XolKS+DcX+BlGc+kFvwgpXiLgQgZiwsQnyYa2BB53AW0kKI1CgPTmFj7z64z3FVC22VN/dTZHLLBPWo4kp2xZE6sPxk3iPSl1UI22dM+B4Tq2Tr6fMG1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(15650500001)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(6916009)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V09Nbk9OU204T2tXK1h1OXJGQkNUTnRjTkRWOTd0WW82ZjJqMzBSWVdjM1FT?=
 =?utf-8?B?c29zcEUvUi85b0wzTWpkd3dCZVZyQXRtQjNkd29FeGdHRVpYSmFjc3hTTlZo?=
 =?utf-8?B?ckQ1eHRiWSsza1czRlZYUkJJOTZ6TTVuOWE3bi9WSWdEV0dqVldZQmZqbXJi?=
 =?utf-8?B?U21veStBNDlLV3hxOWI0TVNXc0VZdkdpYWM5YjFIVFA5VU1wSUtWZVNWaWxK?=
 =?utf-8?B?QVVjYnNFazZKZW8yVy82cVJqSHZ5ZUh6T21XdmFtM3F1OGxUaFVHcDZMekVI?=
 =?utf-8?B?Zk1QbWlvYUxvc013NGUvT0szYXY0VnFWU2pUUFk4eWlQZHdidTl0NFlyTEFz?=
 =?utf-8?B?K1hsZXA0ZVlTd1YwUmcxYU82Y1pIZWpmOXFJTWVqK3d5cUZ3S3B1cmZueWxz?=
 =?utf-8?B?SG8wSitvR2dHcEdsUG5KQjJLcXI3S2c5ZWMvSThNVlBZRzZUMFhXcDlmWisz?=
 =?utf-8?B?cGRyMHAwMXUzQkJpLzFYSjNaYitZRWFEcmdkQWRZNXI0MWt0MkprNnEvSk4v?=
 =?utf-8?B?bmxBYmh1ajlYaXpUa2N5NUdsVGIyTy82NG9meGl0MUtBd3RWRUVPakh6aG8w?=
 =?utf-8?B?NEpBVThyTUtSQTZCZ0czYS9nK2toMm8xb2EzbUNwZ05jUEdEZE9tM1ZiNHhr?=
 =?utf-8?B?NCtJTVdnWEJRcHBXR3k0WTZ4ZEU5YjY5bjlyUlYzWXQwVjdoYkhSOTdLaHJy?=
 =?utf-8?B?U0F0UVNaUktabTZudEpMaUNyMVQ3WHQ4Z044TDZnWGpMbm52U25iWXJOMC9y?=
 =?utf-8?B?VVRrUUZudHNwTmJDK0V1OSt5Q2xEQVJCOUV2KytpamVGaHN0aStDb0t2LzJm?=
 =?utf-8?B?WHNUeGNtNkVhZnJDVk03NW5uUjlESVVvYVpYRWFoUW5MS2FkSnZPL0kreW8y?=
 =?utf-8?B?S1lkZ1NZci9CMkV5UCtPQjJOOGZQSEN4dWMyVTF0SHM5YytUbUE5SWw2ckNK?=
 =?utf-8?B?YUF6N1p1aXJtU1UvczRDUzA3UjFnSWp3RGxmTXROYVYzRTdSSHVOZWtrL09Q?=
 =?utf-8?B?eUtpNzl0WU9SbHpMbmI1bDlmd3RSald6d2dFUXkvaHR0RVVFcnVzQnVremNN?=
 =?utf-8?B?UzlJSFNoUUFPWlJuamJacTY3WFRSeXdTWjNieStaMWJJQThQeDlWUmpiaFQw?=
 =?utf-8?B?TlRZUG05MVFZbjRUMGxBa0dMM0FZT2J4ZUxoSnN3Z2ZEMzBUWGErMFowcmQ0?=
 =?utf-8?B?V1BiTEl1aXJNRDN1dXpZVGJscXFKMXIyMWthYXRLTElwYzBXSWZUMnM5UWwv?=
 =?utf-8?B?VTcyQmJCei9mOWViYkZncTFIZVlRRkJoTlBaSXhvZ3hKaEZHWFExc3JsZnV2?=
 =?utf-8?B?M3hRTEdjekZsSVpQWC8rZm5uZVJPcldkZXJNNEMyYUh2YWFRRzlzNkY5MEVH?=
 =?utf-8?B?dUs3aTdwbERzRDEvSnZBNldiT1JrVHFDaUtycHhmYm9zakI5MlNKTkh1aEtC?=
 =?utf-8?B?TzAwU2c1SU1jM2JQeU1zN0Z0a2prcDE4bVpycGx4V3RtYkUwM0F1VWNOOXAv?=
 =?utf-8?B?d2FMUVdodlhWSnJZMGY1TkQrT3dwRHJFS1QvY3J1NGE0K2JpdlFORFU0MmtT?=
 =?utf-8?B?QUFQbEpNVGx2TmVHR3BJUEpsbVovR2h1ZVFzK2RUMVVoSDNOcmMveVpPNzkz?=
 =?utf-8?B?YWdxanZqeno4YVpwY0JzU01lMFJRd2ZuSlZWa1JkVW5hV0VtU2FJWFRDdzRn?=
 =?utf-8?B?STAvUy84dHppbDhTbFpvNEtuOGt5d3JsK0F6ems1OUpMaWEyTkNLWWdVTzBy?=
 =?utf-8?Q?1orhJVrrWnzN9GSgenl5bXHovnjTxzP7kmQJT3M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63634509-fb50-44d4-78b5-08d93079bb5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:24.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrdHphqImmCfA0dtxj5Tatlr+m0KHzYbvqMP3HeKH0fU8KRlw3brnI0mXp8OYPzVMsC5dDT1UzifPzmRsKG/cRkz8yRsFRi9Edm3X25RMrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=982 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: mGCiw3DeKNXy0nZ2xOawqPd8qk1qiBzW
X-Proofpoint-GUID: mGCiw3DeKNXy0nZ2xOawqPd8qk1qiBzW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Jun 2021 03:46:53 -0700, Javed Hasan wrote:

>   The max_id value defines the max id of the target that stack
>   can scan during manual scanning through scsi_host sysfs interface.
>   If default value is 8, update the value to the max sessions driver support.

Applied to 5.14/scsi-queue, thanks!

[1/1] qedf: Update the max_id value in host structure.
      https://git.kernel.org/mkp/scsi/c/1b67f3d74e45

-- 
Martin K. Petersen	Oracle Linux Engineering
