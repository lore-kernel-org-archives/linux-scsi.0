Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEE4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7836364ED2
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhBZCXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhBZCXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2Jtue065218;
        Fri, 26 Feb 2021 02:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LtKI/zD7jDNuxSeSqgEsaQHxum2B9zuY+JGxvxCx6Ww=;
 b=pi8x0K7/93bRrJVDtUXtCSPlGreq1jSNkc46H87fVofanR1tzNXiAV/lZ2QKibCdVQpx
 YShUeBX3zBbvbh7JrDfszIWg1MjKpHhb8wpHOavm2xtq7DNp3GSCxzflpeTYQ74hytY6
 BzJEHRfv3FDKfevJ8jcu2lvLBYxAHpIMPj3LVxuXBBbpK9S6qNhLNwrbR2TtP0R43mMC
 6LREcxA9xy2DSuOkOs1QLkKc7uyXX9bY/D10pFjwAoyZIF2LA3oKLDoo1TLP5hSSHbuZ
 M526aGoBPFCDXM1rhfUsychJneeSuJ/n4fy3MyhoRxaAEjZzmrQnfVBFaiKdmULiKfB3 Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36vr62avps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2Kg3k107163;
        Fri, 26 Feb 2021 02:22:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 36ucc21p3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRDgtl/jKyWEBPKt/S4ZccsXlIue49eSj1U9uFqT5UQui9mACeN8TtDhMOY3zueZHgCaDTJ7wmM+CogrIVUQRkdOMQu+RshCJVhoY4RhZWkTYNPuVC9P+Mo0cHu2Xb6y8nsJmYEsPdjWZVGDb7TABwK2SO+CFkklgoAicfVqpwpeUHIKBuDPRJf2XOTDMKVKnQDuKwFpfFLFj7PwsjzBdBK/8GjtW8z7+NGs2xAJro3+G60H3lr1jfkPvrMrmipjIaroL1UgFRC/ODjdhNAGlwg4lymjDcrqF7EqU3CzXatjqVD4sDFHwralH72kFK1QIa19hk3fvHGKELMrBRJxeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtKI/zD7jDNuxSeSqgEsaQHxum2B9zuY+JGxvxCx6Ww=;
 b=k5yCVJl3tHXrz/24g4R7bda0apQnZ5nDnuW+1nfljlbDI6HSH6PmPX1nh87jLqoGcaowS+mrzzRI+k4/Y2L/ZctwF3GZJ+TeJDoVmMUs62YL+n3UTkk+6GXKNMTgZneb5N15vo11Wbki/C4EqS3bUSoiZoJPTfNOD/NlEZwE07/19U+XnCcjEhX1xykXP9/3YL0vXJjBnruDGa6n3MCA6oWjBskm7eY4NHB4IeAcCyodYguRgTL+8M7Qn0ncg2pbw67DJtJLcPO3CKFFrs43Rwl4QQEaxhfnruxfoTDYBiBzgbrkNklDhqqIdFetq0RHlOuUdN3ZtM1+UqBP/7We1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtKI/zD7jDNuxSeSqgEsaQHxum2B9zuY+JGxvxCx6Ww=;
 b=Uzzw2qgIwD5so/fGmrfgTXGYyTIg2RylWw/mAnuuYttz6EbqXZpklRYGIetXIUm1y9Py4vK0hEdJy6e7z0BjBU2Z54+HY64hcXtnjaGQqf/li1VTpoON8bPNQ2iXA61edFdJq/ipoBnsXc4SZaN+cotNlIB2YIOPfQBJHMVrgcY=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Fri, 26 Feb
 2021 02:22:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Aleksandr Miloserdov <a.miloserdov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, r.bolshakov@yadro.com
Subject: Re: [PATCH 0/2] Fix target not properly truncating command data length
Date:   Thu, 25 Feb 2021 21:22:04 -0500
Message-Id: <161430583250.29974.15305408399145846701.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209072202.41154-1-a.miloserdov@yadro.com>
References: <20210209072202.41154-1-a.miloserdov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e42743b-968a-4578-0758-08d8d9fd55bd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501A99561E712F14D67C0008E9D9@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwu6Kb3zB+TLgbwkm8vdGPXWOqiIoL8aY/hbEMrAmcpmK0xWzskDJBY45J3300/Ni6t21dQelO6DJdpkqHZhvjkm2C2ePDyaEZxF5Q0+bQreWMbuQ+E/hDwLTXKpvSmPcuikLK/D3s6qQwaNeKotRg1dP+FkYE54YMG6kNM4TfXxT5jhee3NRcgJc6w+8B7TZTwOhmpZnMLXO7HvcNDp1ljuUl9dhWYkSWWCs8dG615Lp0CChsPGtPQRG7tnLhJwHlk7O7k346Vm2UFv60V6CXIouuTfw8MZYHCigeob/wUh362jwtcHQxWJ8S1cINgYMmmUnolgM5MEVZX2ZPqFB55YC47fTrMwK7Hy4/ZcuohcwuA9ub8SmB+E0t4ns70QiouU1xxAFo1kGPbY+kY8CrPs/mP1pTKNPV6sCeYhASj45BZqUvhlPhPTkJm9yJmEbbPEB5ayNARKpbIsp/7z/oO7cM4KRjgpSrRP4HptmJHF0z4hWxiJilOz4vRtXDybMZIpMKYMamyWgjvNXFV3sTyU72v+Gf4B+HgekSiKOyLjzr69uJv37/952eA5yaeQSgyliNRx/Hln1LzxI+ln+/6e7E2KRkDsvpaUxMrqwAE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(66946007)(186003)(103116003)(966005)(478600001)(26005)(36756003)(7696005)(66556008)(86362001)(83380400001)(2906002)(4326008)(956004)(6486002)(2616005)(16526019)(6666004)(4744005)(8936002)(316002)(8676002)(5660300002)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TTZvU2lJUFExOUg5a2RBcEh2TlVMMGx1Tkl2eTdQd3NvRTFUTG50RmszMHFD?=
 =?utf-8?B?V1dYTy92WGxmUmJBVllqSDExaFdlZ2xCTXAyYyt3b2tVSVdBMFVlOWRqMjZv?=
 =?utf-8?B?YzhBYndmNkI2SGJ4RXNFRzVvM21RMktyajJZNFJqWG13Nno0RmxlMm5XeWhS?=
 =?utf-8?B?MXR2eFBGaXVGTm91dGJhOWUyVHc3eXpzMnJTYmlPbG1QWXlINllidEFjOWda?=
 =?utf-8?B?YUpjcTJRMkErSC9xL2wxaGFTMFkvclpNNDRoazJLVE5iS0N2ank5SXRBcUUw?=
 =?utf-8?B?U1lMa1FoOWJZQ0NSKzg5ZzJYU3l4eEhpTTRBQUNtQXEwRVNsbDlyM1o0S0Y3?=
 =?utf-8?B?MlhEVmtZMndzQjA0Z2NYakIxeEhoUy8yclhEOXBCQ0dMRE9MKy85cFFNWEti?=
 =?utf-8?B?YWVtbVhNRDQ2NVBGTHNWdmpWM3lZeGdEcHdTMnNDSVBTdXZQZVo5TEltWlVF?=
 =?utf-8?B?TWp6OFcrSGFsZkdhVDF5UEtqNGljZEI3d1MvRml0RHByM2pqT3VBbWYzWlRV?=
 =?utf-8?B?WFd6ejhnVGxzK3NhTXhTbzFvNlQrVHB6TXZ6V3kwRUFGTklOUVErS0FOY1Yr?=
 =?utf-8?B?QVdkQS9va2lFSk10S2c2djhXT09mNERlQmFTWUprWFYrU1p3UHlPenp6NDhD?=
 =?utf-8?B?NVBZd2xZWGlaaUltZTBJZXVRSWxKV2hoU1JxdDNHOVZ5L0MzZklPUWg4Mkkx?=
 =?utf-8?B?elhvMXpkY3V5WFMrVy82OVNqS0V1RHAvUzlLN0o0RElPMHJ5eWIvZzhybVVm?=
 =?utf-8?B?YjcrNWFrYTEzUi9RRitIc080Mi9uVEJ6MzFwYVVBeTJlRG5rNlVvdGFOTURL?=
 =?utf-8?B?d2YveHJWVXpBbnZ0VlVYdDR2T3U2d1RpTW13anM5KzBKeVFtSXRIbHpsaUZi?=
 =?utf-8?B?NE1VeDdoUVZVZXR6MVFWM0NxTFd2ZC9yazdCbXBSUk95cENqY0JocUM2cE9k?=
 =?utf-8?B?Nm5FYU1YME5ZNnNtVzgyYWQyZEc2VHRoQnl2ZzZnUUZFZS9NemMzTzZQaWhk?=
 =?utf-8?B?Ykd3VXlYWW1zSWlJRnI5SzRGUU5YdFY2T2FDa0d4b0Myd2Y4YnFDeEVUdWEx?=
 =?utf-8?B?ZTI2UFNkWFZSNkhYUDhWVmhFYkk3eU5Xdk9nNGdzbmVMckVTNlZOQ2JHOW5s?=
 =?utf-8?B?ZlQrKzRIWnoxY1VsTzd2a2xHczBxNURDZzBmZWc0ckxQd0JVVWZNZkgydlN0?=
 =?utf-8?B?cXVGclpQNnhxQ3lIT3dQeDhNcU1vVCtYa0crRCtMY1B2dFB3NmxIbFFsb3Fw?=
 =?utf-8?B?OGxZb0F4Z20xcTdaWFhxUVJjWFJrTEo4emxkOXFja2dTUG4rV3RKY2wxUDZV?=
 =?utf-8?B?V25HT0NnMml2NFByOVV5ek13ZC9CL2R0THptYkZLeEVVZHVONmIrSy9RQksw?=
 =?utf-8?B?VndsWHQyRVJnK3UycGhKd3BiZEUrOEFnTFpXL0RrRXFOSDQyN3lhN2tITjNt?=
 =?utf-8?B?ZjZNZ2pYcVJaUmlZK0x6SjhxSEt5R1ZNc1NaVmoxZDNhZmt3RWMwSzNJd2Yv?=
 =?utf-8?B?ekk4NDBYTTNwQ0JUQkxhU2pRWnBkTGYwNmFpekJnU1FNbCt5Nk1VbjVPZ2Nr?=
 =?utf-8?B?RVphUUhBMHUzUHg5cWxBMmV3RDZaSDNESGFjWmJvbHM3amdmM2xibjUvNTBi?=
 =?utf-8?B?Ui8vR1IzdUxpdTVzVlQrN2R5NGNwV1JaNWxJRGF5cEdwenI4aktVWDNDNnJy?=
 =?utf-8?B?cGQ2RWV6UHVCck9XN3dmNUpDN2NOZGJMd0NoMVZoTjJCWEkwZnVHVUsxTHB2?=
 =?utf-8?Q?OEoOIx8k+kxFAU8ysko+b6ylZzpTL5NKt6G5Mnu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e42743b-968a-4578-0758-08d8d9fd55bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:16.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uy96li4aYKursEIv5R/gGYlV0TgiooiMt4X+6MY9qxigBcIjsmtYRQDD04SsBoh8CDHTGtVWRkrh3lgp7Cff+z7I3zsZVDE0cslkyR565So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=935 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Feb 2021 10:22:00 +0300, Aleksandr Miloserdov wrote:

> SPC-5 (4.2.5.6 Allocation length) requires to terminate transfers to the
> Data In Buffer when the number of bytes or blocks specified by the
> ALLOCATION LENGTH field have been transferred or when all available data
> have been transferred, whichever is less.
> 
> PERSISTENT RESERVE IN service actions in TCM don't follow the clause and
> return ALLOCATION LENGTH of data, even if actual number of data in reply
> is less (e.g. there are no reservation keys).
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: target: core: Add cmd length set before cmd complete
      https://git.kernel.org/mkp/scsi/c/1c73e0c5e54d
[2/2] scsi: target: core: Prevent underflow for service actions
      https://git.kernel.org/mkp/scsi/c/14d24e2cc774

-- 
Martin K. Petersen	Oracle Linux Engineering
