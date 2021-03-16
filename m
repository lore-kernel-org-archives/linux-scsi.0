Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C916C4321A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F4265099
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhCPDPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhCPDPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39iaV057873;
        Tue, 16 Mar 2021 03:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UkdiG2kAjAYmP9hUgn4HVimRe/jqE8gAxXquAkp/5uM=;
 b=LyASN6OXliwQ07TbEvrhXt2trcgI2V7YfelL0o072TvPqicJPFwMGEqbXsZSNQwPyUmZ
 dmV7ssA1cELe7AJDTKVPwFuVQVsKW8dhiiHM5qrym7Wu8vs6I7tHWL57UgUs0rEjyacE
 NzJ0q+Fpw7DTiZapHElEXUVRlIJBh9dJGO7UiOsAOSkW62zC5pcoSlDNjpfzchsnmH5t
 GpA6ZXqrgJ7B2RHaS/GFLXm5REGn//Vs7jVXqYYJe2EyeJl3cUR9SNaB7gBIhP0lVrFo
 ijYPnGPNTaFRdkJb0au9E3wB6ZUpQu7EyQ6g6BggBemjJlVcR9vD8aMj7sexaaDz69GX TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 378p1np3ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39nhS081304;
        Tue, 16 Mar 2021 03:15:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3797aygbaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuYlSXmltpQAewjOA6qJoHmwpj10uPflYhALQRVmuMxVawv8yx4UWdDemyHZTpcd70GIMwDPgQ7WspytsNVVHzE5d3bqHSprvg1vMLYbrgUN5rra4n13NC1EIKKiHY8pyD12LzDWdD+7DCz1PkHt+wiJoHvi71i4HrsSoABLA3oJFLc+j/bQ20t/lkQxMqKCA+90HdSFrzyhKPskkvn3VfMCrXNN9FKTvs4CUKyyYmPq3zmxtnWS7BbVxgSKCMxm+zCXTjs8O11R4SgEqXo6Es6rbEgyLdZyoKSFL6vFLDWAKDCYtJ48vRdZ7qbCmKMvmRyspJWaWshd4cYNFw6Sag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkdiG2kAjAYmP9hUgn4HVimRe/jqE8gAxXquAkp/5uM=;
 b=lapNSPsGNw6ydCeMIPCgPoMOzJx3biAktso+zTTlTXI8tQuShHE56LLic/97fXrrFCG1d2rfih0v7suJm2iBthQMatCOl20Api9bPtoZFBA8qi+rMKOoel+HytlP3cNuXPDgQGL+0cm33zdLZ+/Do8Bga244OG/8hh43WxPwpjgG9fs+i75ObVOXDmiqtAwpoKSK+7aEzrZSs3gGJsGNYQouawkIB3meYpojrucLnSAy4jOBaKn0VrZ+8oCALKUWzu1FIpUY/+A24/9hfunHdAB3Cl7zthczp3JAQ3eyphHkPArzrT25/mNLPBAhyEftILtyHMKexelGffyzQZsJRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkdiG2kAjAYmP9hUgn4HVimRe/jqE8gAxXquAkp/5uM=;
 b=SG8cFymlDvxTdmULYcbQtCVZZl7p/eNan280FBdtTeydeyXS/pqmzzQiLk08oqeq0T8uvsG+G1N+v/S6VJH5c+JJTYonf0KVpAzfL3oP/ddp3W93sU+Oj5ctQB/Wsh8yBc14Z68MvxduStU5r5BB9LyRitpOEm2HNl6NENt0BBo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     menglong8.dong@gmail.com, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, avri.altman@wdc.com, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, Zhang Yunkai <zhang.yunkai@zte.com.cn>,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        beanhuo@micron.com, jaegeuk@kernel.org, stanley.chu@mediatek.com
Subject: Re: [PATCH] scsi:ufs: remove duplicate include in ufshcd
Date:   Mon, 15 Mar 2021 23:14:58 -0400
Message-Id: <161586054342.25014.9464505712969746615.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
References: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35c48f26-a621-4327-6a59-08d8e829b8f5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47093812B79C5B0C6BAD33E58E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ux/aUjfDqJ2tweuPnBGZegP/jnXC2/Qxp35fmqRkyTwjnxjm3137h52YZno89CjPXqOFg+t+wN24tlUKAmcEEFi0+00kD2jxMEpgaRJKrhwHqyJIuYBIuPrQYkWlspNt7xS5+IJjtPwVkDAVqm6LFFPbu3Plo66Jjp2s9BrZS4OPA5F5dVExB0S+hckm0GCPVTZxkTfL+UTwWtOh5Ri9DPlMSovFQA6h989TzdVBTlG0WsquQZ3TwVNEkG4An7tXvhntXKzR0mgH3nMMuQA7PR6V13Y8TIsmMkJEXKYvqkPPpDNs5/Z21otduewINdeq2qqtlLvhypJR99v88+cx+yfNYZQzamxEkoYHwjwHB3FD4Virq59Ke/0K+tor+dYqx5KdPopfCCS0LwH4TZjOZSnLrZ62lG+FsaNdrie5gUDxRGrlVJ30lAVAeG8eZFwKKn7wxNeJaINT3V1WfLXmukc4jDC4zQ6p2juReUh85VdMEYQK6Z3DvA6ii5XNgp2nPuNSw1hXqt5OAo0QYNsc+8/eh4cACEiJtd2YCvwvy4bPiXDaaC9jrjnOohJacUG1KSOWjSJl9fbQcVcRyiv68984SSnTexr/1YLS9KXSLYpQFZ9L7W6gx/IbClYNA/gUq3tm/vBbE9hCIqHo4DP76A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(7416002)(66946007)(103116003)(4744005)(316002)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(54906003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFYrb0VDYk1CbjljSW1vamNVWmFZb3FKSWlycStzVDAwLzNuOW1aTGpzNW1N?=
 =?utf-8?B?TUJGa21hUDM0YkpkU3VMaStUK3RNaGJYRjV5UzVWUVpPNzhCUzRWMzVUUVkv?=
 =?utf-8?B?cTdtQndNVEN4TWVrNzVwQnc0OGZ3MFBBT243bmJBUnpLLzc0NXFiMWdrbG1Q?=
 =?utf-8?B?ZVdtZ0NURDh6am4ybmtEVFJCUFI5eGhIRGNmL05PUmJPTGhQQnFsc202eDlV?=
 =?utf-8?B?SUQvcjJqVERzNTZGN0Jkam54d2g3U3hES3FNaVJIQWhwSzhkaE5iNXlkcW9T?=
 =?utf-8?B?N25MaWFNMDBLRHNndmhRa1A1SGRXR1IvV2g5ZjBYVXBZRDcrNEtZKzF3Q2Yz?=
 =?utf-8?B?Ung1Sm1sQmh5eVlUMWxUSjdLRDAxN1BMOFduSGp0SVVweVBqTC81TnVqc2Z3?=
 =?utf-8?B?VVFtMDZiWURTQjhHVmNTYzF6Wk9KVG8xQlpOZUFYall0eUxIVDFMQjNXZ2VF?=
 =?utf-8?B?S1oyNndOOFVCaXR4WXA3UEhEbFdmS0xjaWc4MUZubWJ3OFNpdWhwSlBmSThQ?=
 =?utf-8?B?U2dJWHlWS3hKMSt1MWJONmt5UUVXSStDdkdwV1htMUc1QWlzUTY3RDduV2wr?=
 =?utf-8?B?bjBhaDFHQlJvbDc4UW16OVB2V3ZhSmVlZG1RcGY1NmtBRy9TeEdHRVhMQkpz?=
 =?utf-8?B?aXBPakZkZUVvaE1xd2pGWXNPZGJSOFhKZ2VoZm1GTG9FNHZyb2RYUFVvajJh?=
 =?utf-8?B?bjIyUDZCT0FSRVlQUjNpMFl0UitLZ2lqdmJMRm94dFU3QVBncmw2MkpydFFT?=
 =?utf-8?B?MHRnNFMzZklTYXVYRE9UdDV0SC9Jd2Vxc1U1bXpGQjJjdDQwK3lRZ0x0NmRI?=
 =?utf-8?B?NW9aMUNHQ0lsT2VKeGg5OWMwT1RRQTVhbld4U043ZXNEMEsvNk5yWjFmYTdS?=
 =?utf-8?B?MlQ3NlhONVZkeTFrK0FFR3dPaWJDRC8zQ3VQSGJFQWhGSHkrSjBoVitJL3BC?=
 =?utf-8?B?RVFmaTZCUFEyTFZ3RDFiNGtMVWJVSmRHVHpwamo1NmhGYWdHdlcvQmozdFVD?=
 =?utf-8?B?VzF6YU1ORW5BcEg1eU8rYmpBaTU5STRIS1A1aDNzS3lBaWFNQThPUlBFcWg3?=
 =?utf-8?B?bjJ6OUxhdUJxbnNVRU43ZWFWVk81dXRLc0pWZDFIaEIxUUl3L0dsaG1pS1Iy?=
 =?utf-8?B?YTduRWprbDJVTnIxMUR3TVl2S05DNEtBK2lXaHh6WnpsblZEQ1dwWXo0ck9P?=
 =?utf-8?B?azgvdHppOWZHVkFnSTdmMjFOVHRkOGVnUUlwemZ0QUNPVTgvN2xZUUhhcWF2?=
 =?utf-8?B?WkVicGhuSnRtVDhJa1dKaWd1VDBFT3hvVXdEdS9VcmxMNUh2YXIrL3hLMGFv?=
 =?utf-8?B?Z0F3ZlpPd09RS3VuVnBGWUQyZm5NYjE2MUVUWTJoUUkwTTNsVm9ENUhDYXp0?=
 =?utf-8?B?QmtrcUVxNHNlV2JQMmhXdjl1WXZEQnkzWTFuOWxZNHA3TUFHa25hRlN3TzlK?=
 =?utf-8?B?akhhaXBGNHlUU0ZDbUhEM2tHNVpnOVU2OGNJc1F1bmZhNWFEZFVBNTVWc2lv?=
 =?utf-8?B?UGMxaXdzbGZBazdlV2dpWHBiTVlOTUxUKzRXVGhaSVBIajFTcElLTzl4Tmw0?=
 =?utf-8?B?WThwaHBLeXhMWjFwR1RtL3ZNUkJERkhtNEdhZ2hvcndhLy8vMk9vU1phejBx?=
 =?utf-8?B?SnNFWEZ3eWlDTGRHOWd1QnI0NXcxdG9iZCs3Mk80OWg4QktuS2NxR3hNL3hr?=
 =?utf-8?B?aGg4U0VpeFZXU2FSZjBCRk5RNVZYYWFPbHg0bE8vL1c3S2hqMDhuajh2Y2dL?=
 =?utf-8?Q?WEp3plginR3xQtLAf//jsPpM/tUoWCpHZiIrprm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c48f26-a621-4327-6a59-08d8e829b8f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:16.9908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHiAml8JglkW0sOlwgAJUFZ9L8GaKDzJCnbL0VxJ7tFbPB5SYbWwEydZnPIjVkUNdzblOf/pD9lw92cNrNOirnl0UC9PC5VQKK0MvEHk3K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 6 Mar 2021 03:47:06 -0800, menglong8.dong@gmail.com wrote:

> 'blkdev.h' included in 'ufshcd.c' is duplicated.
> It is also included in the 18th line.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi:ufs: remove duplicate include in ufshcd
      https://git.kernel.org/mkp/scsi/c/b4388e3db56a

-- 
Martin K. Petersen	Oracle Linux Engineering
