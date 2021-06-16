Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058E8C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB01613C7
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFPDvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20402 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231268AbhFPDvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jsCA002405;
        Wed, 16 Jun 2021 03:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sqllklwWg40RKREt6eVgAv5RKORRi/+1Iqt5yrG+JkM=;
 b=INh6OI2CFcBddLVe1YswQxkrusXfvxtbiGqfRYWm3GLAuxq4LPlpxp1AgRpByOyM2ZM1
 pw95q+vKgNHffa13fqJzaUkmCnPJYnYQodj0HS8O90487FBfBHMbQalZ/9LAM+bSvEOa
 RFvJifiCdQkf49mPMNspQP6JxkLPydrU0S4Wn4A3vnExdZrhvQduPaHnuVk/uRxRJPxr
 m8I91Rq8JbUu8x5j+BuMYtIe40dPe0sSTKFDNdURBvWpiUczlXytRSMfOXzB6fD6tH7R
 udzC/e0WKSyuuMWo2KeQnv5aLFYfv2jrC2aJ7+j/LoQcn1Kzo/T7T80YTCYcShWaN1gq xg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 396tjdsarq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:16 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15G3nFOH075255;
        Wed, 16 Jun 2021 03:49:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 396wanasxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALBBNsfMFWA28eRcTUQqt7TCDoHThlN37BYDkY8m6Ry+S7tewkwrjWWzWUVq4Pj+zSbhQ4yzIJStjeB6O7djIshC855BXVFJ2KlazirOAoyYtGYGeXcIfpYouZena+88+5PMezhFE4afkkhBZIqHXrwadrqtjliO5PYwakzdxxiFZmDFoR4rmjSU81fXptPlnNuqVqYcH/17KcugAjlkzrFMlpoLe8PJZHkMFIdg71qcyuQ/cWmvppYlGoNRSfb72dJcYhxdw1hLHYfRWbI0zYSScD/91OtkUXxTJeQrbErFD8L2V4oxQ+f+8jCHdoiskLXHsMkbUZBJ3BuboQWWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqllklwWg40RKREt6eVgAv5RKORRi/+1Iqt5yrG+JkM=;
 b=QVt9xL/k2IXGQC8i2cH7bS1pYn6Skna01oRgJHQ2jB20LbL6xem1Pr8TCyBBIF/lB5QUA8QPKt86pQKkMIbd2sUFx+/vG08OwKCkvKBWQdBi+vvjdCL8IbG+uNZNrk2azvuGU58RQwJZEv0vAatLUaMmPLGYQ7F5Tgnj4dja9u33/GM5rJkDL5g2TyS7mM9jWtQ3qzB7xTe/nT3COR5NFT9Q3kYq4OSPrdyfqVCSWQSdWD5JiaFU+99Sp6HvKuzY1G3/NC5bU0Xm5HLtPRR+bPSm6OyWaPdLFtlcwv4fZ8cRuASBa9HZbtCFbRbGok/UVeOXPp519iKeBiQv9nXDyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqllklwWg40RKREt6eVgAv5RKORRi/+1Iqt5yrG+JkM=;
 b=ZzIugXD7fXnzcv6ndpOWyp0UNykQqajBPhBXTxzvsT9TH2z6i4b/RhLra+Y0d7q0v6lqrPk8q1g/OQw1BPLbxn52TsgRyG8LK1w6GYIyTS7W+jVO1AczHBuR0P4Ft2ociRdGaMaRUeARPxGdTumKaLmo6HlxJpufcmIhEfrg/sc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     nguyenb@codeaurora.org, kernel-team@android.com,
        ziqichen@codeaurora.org, asutoshd@codeaurora.org,
        Can Guo <cang@codeaurora.org>, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v3] scsi: ufs: Fix a possible use before initialization case
Date:   Tue, 15 Jun 2021 23:48:51 -0400
Message-Id: <162381524896.11966.2627984284805294316.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1623227044-22635-1-git-send-email-cang@codeaurora.org>
References: <1623227044-22635-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8a2359c-6de7-4236-bb19-08d93079b494
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46639A21445788B1F6F608738E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /u4ET/GDjzlenrjqKOPoQNvRUL0cDEbrYBP0QAm4YqdO8752gr8Fg/afGCjwHKPpBtljx4/NP39mWuxqrl2Cgefv9Xc1ocUzIqoD1xwLmY0VKqCbmttDyQlAXMgEHVIkLGd3NrVRHNBE1NK/YZJgd6SrkCbg8jeEWNShnOrYgTuq+zEYMelhJWnorWeGs2rtGuEaaXShWWtCcnJ3sVBy4uR1R+t923tQrQCY4H3CVvVC4PRC70pC+VP7M7jUHNOGNJuEytIXDIwU7Z8h+5ggPz9A2yx7Vw2jQNQJxA7i9mgVAehb41W7dOL0TGPI1fXbksT6SyVlZjgTDFfpshK5Y4CcYHh2eHJ5PUYaRvX4SRz71RYDL2nwx6osdgHRFHozUdcw8G+UeXholeFqrruM5hs8MXC6Jm7d70eBsA7U6VaqmIH1/kHXpXVKZLVdnxzmMgYA+UmnVe0fM9caD5RRnsihbN52g5aZ5tfQx9CaY84Tyt116ypaFx5GnYoCIdYEPNlOFgKWkJExZKu/jjtfZT3GtpOH9kA5fQISY4yvHCl7MHloUYhuF3GZgAl3o0yN0fCitqyHXlf+oLM4SM96g7/OSqzGeUCIKfXpBo2VUdPB2NldVke6MQe1E7fq5Rv/mA0xWWccKF/njJQpLhLncK938wx49nJHcPlXmGAwELbTqPvuLvv+YC0hrNa6HOWeijKRC9ufQnHl5FUAiwOjYjdPPoC2z27fmrYkFrVbAsbCl+PlPb7ThyVHifPpuAmsmfCbH5r3+kZADHK4iip8eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(7416002)(6666004)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnJNWlpubFZXa21nWDRSTGd3Y3dQQUJkeFM5QWdwRWkxNnBGbWZpdFJxSXkz?=
 =?utf-8?B?cndId3dKdjY2Z3FKSm5mcG5PYU1pcmN1RnFXSVJmZVA3V2Z4VzFiaG92bGl5?=
 =?utf-8?B?d0FJV1Q2TytqOEtlZlB0LzlzVnNUaVU5clUvNVFCcnFRUFpNODVVSmRiakpw?=
 =?utf-8?B?MjhiRStRZ0FSSVAvNXRySUVDaGFXOXpjKzh1aU9SNkxkTlF3THBzNTRLQmpv?=
 =?utf-8?B?SlZ2eTZ1cG9Yc0t1R1I4ak5VZHcvTkZhdXRVRzR4eDVsV25OV2N1KzdGQWdv?=
 =?utf-8?B?c09vem9ZYTRmd1E5azdMS0g4Qi80eTc1MFBnajVjLzJFUWpJdjMrWDY1V3lw?=
 =?utf-8?B?NWxZWlpNSTM3c0pNQTJ1elpVY0ZjWnpJaExoWnJORFMxZC9lcUl1WDVTYlhl?=
 =?utf-8?B?R1pQdzlSQjNMd3BRWU51MHdLbnNEV1AxRkw1c1VmNmRXMmtJTkRvWGV4YUgr?=
 =?utf-8?B?akQ4b1FaOEg3cUlQeDduOTIvN05odWhOYWdqa3lDcVBza3NJczBMa1B3b1I5?=
 =?utf-8?B?cXpaNDJGTmZTQmF5ZmhERTVMYVEwR3E0WmVUUWswaXNsaWxYbXkvN2RHVmg3?=
 =?utf-8?B?Zzg1bVl4TUczaEdlOE42NlBMRThMZmhlOXk0WVVSeWFxV09ydmN4WVE2Y0FH?=
 =?utf-8?B?NWQ0TGhSK25iS1BHUVlZUFV6OWF1TjJsWUVST3pVTU5nUExZcjRxVFczS2VD?=
 =?utf-8?B?ZE1xbWs1d3p3M29EVEhjdWlBYTFmcnhYVGFpd1FnQ3Uwa1VMQU1GWkpUaitW?=
 =?utf-8?B?QXpqTzlMSGNRa2xMWkw0bmxKeW9ZRFZwaXorMXVwVjJEQzNEV2J3bXZLV1dX?=
 =?utf-8?B?QkdSczZ3MlhaNVFhMWpQQi9XY0FsMUxaajl6YXRjMVZVdEUvUkdWYWprZ25K?=
 =?utf-8?B?NjJrZ3N4NHZQc2VZMDNCVHFMTHZhWXB4SWFMZ2ljSTZNQjlwNG9sdEpzbzJZ?=
 =?utf-8?B?UkF3Z2h3TkdTMThMWmNaaVJwVEJDRU1oTmQyeXM3OTg3WlE2OEVRMVpOWHox?=
 =?utf-8?B?M1ZtOHBGdnRIdEV4dUpXZGoxTXpqNnVxbjZsNkxDT2g1YzBwVDlrSko2MWtX?=
 =?utf-8?B?OWVoaXhpL3BxYkZkaDYycUdLTHVraVlTd1Fia2taQjJRcVF5RjhESkZnbXZ4?=
 =?utf-8?B?d29CTmdKaW1JL0E0bUVCSXQyYTloK0QxeDZnMjlPNkZQYmszM0RDTW9peUtl?=
 =?utf-8?B?NXl2bERrUUU5c01KY09ycmFLNU1aazdTeEt5cFg4RTRJem5aQWhEekxJMEVa?=
 =?utf-8?B?b2k0MmhjQVlnRmE2K2w0M1dSaHMyTlJiQnhISHBnNm9yWTFtS2xoaHpYVkhG?=
 =?utf-8?B?bUtYeFEyelc4a2prUjZ2UmJxdmNjRXZpNTFjaEZJZGJ1RFY1c2NVWnpzUkd2?=
 =?utf-8?B?a0E4YVdnQlFXT2tweXFPQjVKZVpnVlcxRjJ5MXlFeTRlNVhpVmlINGxkWEZh?=
 =?utf-8?B?ZkxTb2lKOWFSNmlodXVQOUg5ckRkZlI5WSt0SHY4LzdQdEN5OUxPQzZpTXNW?=
 =?utf-8?B?NjV0NzNLc3ZLZDNoWHdFTmFySFY0OHRlK1gzSDVCVWk0UGRuZDlYODlUYzV2?=
 =?utf-8?B?NE00blhuZVpWTTZLa0lCYjZjVmRqa1dNaDBzRUwwZkdKaUxpVWtJcitkNzU1?=
 =?utf-8?B?RFp6Q01hZmZkSU5DWXh4TXgrQXdnWFRGNHlVcE5WWXlwR3pKRGM5cXhDZlpL?=
 =?utf-8?B?UDJsNmN3VHVORzByMTBnTVRRVXUyV3ZxSHdMY0hDTkdpbnA1ajY1ek12T3R1?=
 =?utf-8?Q?FezONeioPtrTqPkFSkE7/xFnLYTU7sexDzsVsdV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a2359c-6de7-4236-bb19-08d93079b494
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:13.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3H5ng4zlGLNyc7dOL/lwXairT45I+didZrH447YSfJN8ULfgU3RUA24UrFVML+rmlQ3PLZChbEMvxmD1ZR2B0lfPykutPJs6eWMK3QN6jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: XTnvJVMZpeC0QD1KqQsR9OqwsxxCaX1L
X-Proofpoint-GUID: XTnvJVMZpeC0QD1KqQsR9OqwsxxCaX1L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Jun 2021 01:24:00 -0700, Can Guo wrote:

> In ufshcd_exec_dev_cmd(), if error happens before lrpb is initialized,
> then we should bail out instead of letting trace record the error.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: Fix a possible use before initialization case
      https://git.kernel.org/mkp/scsi/c/eb783bb8bbe7

-- 
Martin K. Petersen	Oracle Linux Engineering
