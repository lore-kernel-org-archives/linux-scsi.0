Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47606C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01BF32389A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAUD5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:57:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbhAUDgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:36:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3U9FL019044;
        Thu, 21 Jan 2021 03:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PhC1KCsM/jkWtpFWwjGeTNdmghIzYjkf1rB4S06j3gE=;
 b=IQ5twMR0LBhC/nTr2qUm2RzHY+i9ZUDGF0MhbAFwk/tWKziIcvdupHqwJ9Km06U2Bhgc
 E08poCf7F7bJMWVch1MqeXPO1NxWTK5es41N1OngxSGGc4ESKw52qR1EH3CIMpoXbK0u
 JNBEoX7S1g1lsgGeyOxfiMmdGiRpvDcmuQbYe5pFOt5HAsyqTlzivNYcgrhZtWfeYtmi
 Vt2Ohi8nMnouTPSgj+qufmaE3Ix5IUnDLxwUOeDUH/jKLlsm5LQ+ZBZDmJACZVZ2MLKd
 LasPo4jqW2aS7lVlhyc013UrNasdrtpCmiod6xbo3easxazypm9JM7gqoNMxXgrTlNj2 aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qadcpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:34:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3UgA4161448;
        Thu, 21 Jan 2021 03:34:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3668qwag1n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9tBLzCg/XimzAECJL0//ilJPyZeXfMd35zQYnQ0nPLFtvGYV5UDJfH0au6IcLGwBM+CUGtfheDO/NaXaKA/OHzGpfp1SDS4OC4yzOvBVPq3/8wpQ2/ond5FUHTt+T8AxGXntuknqlh6FGrNm2mpZf6sHQAlJCTWcUQJ1kDNNW0k16GVNPDBz4M/2k28tG8OyU5+RobYHbxb9IhnsKKayUeHLDf+dOH7F9lRRhrcikOZJcYKzCOCO4IdqfPXmQFO/XiHosPj3L/A0moMHkv/lS/fG6YLAypY2emTXHTi2P0YIciKGS97oFT+lMforNT5w5HGC1tz200D7jWMZobWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhC1KCsM/jkWtpFWwjGeTNdmghIzYjkf1rB4S06j3gE=;
 b=F+Y/du9whf6rNRFD5C2i6dPQIzBOFP2D505JecVmlg1evmon6j8BXDI3jjdbJF0wCwojcMhAbO77u+ZYSnAnfqIUD6NwkOUcwWz9Rv6WAiXuvyUgr8zUfCJyd/GiZQqPM0Zs9+mfqA/QJ43G7F2ABaKNXn1GEZhfhcdfIk3ZrkPUYHqtWJXL3v1lF5/E3oIodUUw36MCOEc4zG5j4m8FbfYrSnw8ELNQqTtse3qNWGXQblS92+Pb8wD4yzqV+MD8yNBuGVK885iKEDRd2MoWeq9TShG3EBewoeCtJqEo0fC8NG+5zeNcl45/xEKa14qS7cbv6yuBSx0j3xLZrST7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhC1KCsM/jkWtpFWwjGeTNdmghIzYjkf1rB4S06j3gE=;
 b=Beevbd6m9emDElxkhDABTDFQdM5VZ8r/7KEleEKikA4hXX7R73jzKp1nS3Bt+hJGpcXv+nEEH4wTrlQB7VDTR8HcvluCN3pPvb+I72mUYxfgpZQ4cQe0dgdY1hJlMazl4OjGeSPHctmD5Xi2wzGG0fack5WJEd+v/OdYrcKmHL4=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 03:34:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:34:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.de, Muneendra <muneendra.kumar@broadcom.com>,
        michael.christie@oracle.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        emilne@redhat.com, mkumar@redhat.com, jsmart2021@gmail.com
Subject: Re: [PATCH v8 0/5] scsi: Support to handle Intermittent errors
Date:   Wed, 20 Jan 2021 22:34:39 -0500
Message-Id: <161119996965.1307.10590204038373941980.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR20CA0030.namprd20.prod.outlook.com (2603:10b6:610:58::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 03:34:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbdbee77-cb2a-4bc8-7b5b-08d8bdbd81ba
X-MS-TrafficTypeDiagnostic: PH0PR10MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4679A1025981C08253CC04218EA19@PH0PR10MB4679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMJxTvIoHyqNtt6EaHvfq0LJhC06CoEwQAyGozCRoRUzfLocEg5rSfdsL6uVr8VQMaVqWByCqFYvT+Njitoznok9MtiqLFC6uS9/EHiI8ZHA5Yoykb5oIVsgCNyA+eYu5SAivQHkFxLbW07s5uoY5myLoNptHLAnVSYQt2hRUnJLGuT4uiYR2PpQhEp+xaMW5BJ2NC2DnQxkJequglSrjlpz611b9k+kB90WFwXt8M9KrGDr4rJ98DlxGCX3iSkC10OSIGYpKl57RN+rPsfUnx5qFERFZsZsh4wwFhrA97JB26PgBSPp8OKORRTKy409n/GVDmWYRGlWpfbeFo2ZEsFxggOVV0Spb9rlgrsYs9MFlnoklI6x0v9RPERlihXO56XB0/ctmz+v42IyHccLxcAqooOXSPQe4viK0iKEVnH9h6INp8Vpke+aG3Hq4IwQVhWP/53cCTrazBe0BAzZSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(966005)(2616005)(186003)(83380400001)(16526019)(956004)(36756003)(8936002)(2906002)(7696005)(52116002)(5660300002)(6486002)(6666004)(66476007)(66556008)(316002)(66946007)(103116003)(26005)(4326008)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFBKVkx0bk1YZUROZ1kxbEwremVSMHFXZnpkSzY5R3BadlFRMGZQVEdrZ1Uw?=
 =?utf-8?B?R0dYMWdnb3lGcVp3Tk1nOE5EZUI5REo2dmVmQjBCbk1tbklwU012cWo1c0dJ?=
 =?utf-8?B?ZmVXZW5WeFdBQWxsakdkbSs2T0UzUXFEQ1c0T0krNU1rUjR2bGY0OEU5T3FV?=
 =?utf-8?B?Q3cwT0pEY0tXeUNmdVF1TFA5NXlPQ3U0Z2FlVDdSNU80cy9xZENXZ3pKR1ZQ?=
 =?utf-8?B?YnRGTkRnaTVkMk1WcWJRcDJ2ZEI4NitNME1ocVJnVkdOSldOWENxUjZJMmda?=
 =?utf-8?B?cGIwRmVxNHN6QTRlQ0VOc0VQV0FlUlkxSTVFV2ViY2lIVVhzVjBCUlZ5MStQ?=
 =?utf-8?B?NEJMaXVuVVFvQzFIcVg0VHVNQUhFVnBUR1QzQUU3K2VnUy8ydDRnMHMvUlBh?=
 =?utf-8?B?OXFueVN4S0I3RE80T1BDZ2Vvb2wwVWxvQndyNUdRNG00VllJUzVXNDdkUkg2?=
 =?utf-8?B?T01vQUQ2UDBqaGVid1dXWU1ud3IzU0hjS2s3bDVCTlQ5Unl1c0hYZXNHUnJ4?=
 =?utf-8?B?WnRGSjVRbkM2Mk9lK0FkazFtMVlUSm5BRVFuYU84U1RhMzRqOTc3N0JhQlA5?=
 =?utf-8?B?Z1ppaTNtM2d2bUI4M1BvNmxvNERRZUNkUFAxVTNIaFkyVlBBRXFHa1VkdEpj?=
 =?utf-8?B?NCtwcWRmUnFXVGlyVE5IZDY3MnFSTEpBK1VURm9mSStwUVA4cDk5K1pkUWFV?=
 =?utf-8?B?UXlKSHpHZVhyQlNkTmtRaVVDUlBuYnZvWVN0clVVc3N6NjVOWG1yWG9NODh2?=
 =?utf-8?B?bHcrODZUanFHNktzSDJyeTJ5SUYxemx6bG5vR05rWEJlVTE4K3ZDbEpGb3Fu?=
 =?utf-8?B?eFZsRWRzSU42NnIwcEJLdFZlZjYzSS9EOThBMkRIK0hJQ2ZqQWNWYUR3ZGJk?=
 =?utf-8?B?d0VDbmZzZ2R2TkZNNStrMEI0QzFiQWRnVHhYOUkvNWpqMFI1czBtT2hqbGdr?=
 =?utf-8?B?RlRtYjI5by9ZYWZEU0RqZHJud01seFo0Ylcra2NwUzcvSFA4UGl2YWUyVVQ1?=
 =?utf-8?B?YUxGUUh0bHFXem9MSEg2QXpmbG83NkVqbmZIQkVVbHA5U3h6SER6cWRMSWNX?=
 =?utf-8?B?cW9BYk9pNXIwQUJod0g3RHZzbGFDVW9uQTE2NlNMZmxUY1NhNmNQOUxzVnlI?=
 =?utf-8?B?TXdIV054VFMrdzFWTExsUzBjRDhSaTc2Vlc0amdHdkUybU54dWUzMjViZDYx?=
 =?utf-8?B?WndZbFpUU1ZydVM2Q1FBSi9RT0pDd0d2QkRXNmJrUkZ2Y0hESDdmdUJlQmNK?=
 =?utf-8?B?c0xwQkRydENqanFIMDZjY2lhK09zZjhqVE5iUGJBSEJjRlNVNEl4bkJ0ZWlp?=
 =?utf-8?Q?gbtK7R1fgC+7E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbdbee77-cb2a-4bc8-7b5b-08d8bdbd81ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:34:49.8135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Bfn7xanWWAPA3/nwqu3JIa0UuDWcQLWAsp93tN36aMi3DrGCVPErwVJ5ro5FcEolzp+lf1trnrBOqKiMhoY+O70p2WHWZ0j2c11uKqCRX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Jan 2021 03:19:03 +0530, Muneendra wrote:

> This patch adds a support to prevent retries of all the
> io's after an abort succeeds on a particular device when transport
> connectivity to the device is encountering intermittent errors.
> 
> Intermittent connectivity is a condition that can be detected by transport
> fabric notifications. A service can monitor the ELS notifications and
> take action on all the outstanding io's of a scsi device at that instant.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/5] scsi: Added a new error code DID_TRANSPORT_MARGINAL in scsi.h
      https://git.kernel.org/mkp/scsi/c/962c8dcdd5fa
[2/5] scsi: No retries on abort success
      https://git.kernel.org/mkp/scsi/c/60bee27ba2df
[3/5] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
      https://git.kernel.org/mkp/scsi/c/02c66326dc7e
[4/5] scsi_transport_fc: Added store fucntionality to set the rport port_state using sysfs
      https://git.kernel.org/mkp/scsi/c/afdd11269400
[5/5] scsi:lpfc: Added support for eh_should_retry_cmd
      https://git.kernel.org/mkp/scsi/c/7f3a79a7fd51

-- 
Martin K. Petersen	Oracle Linux Engineering
