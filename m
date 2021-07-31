Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F409EC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18EF60EB2
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhGaDp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 23:45:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231643AbhGaDp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 23:45:28 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V3Ztwg009405;
        Sat, 31 Jul 2021 03:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=siwc0uE5DuBmr1NufN+Df8YLuXXav0vjFuEq/mihMV8=;
 b=tCAYay4tuWLhxHDRV8rOYy9ST97h0gc7mF0ydereKyL23j2f7nXBUNjRp5bgvkId6YnM
 AjOEPhyJrOLVZMQkNEKkGNLtquwg/i6GjHfGsE1XDkCK390VanBt6jBu7d/3gAyODV86
 /hC28apdO3rkWTbbCRXJR1yUY+T+NKCt74ZBoAm+ZLv6G0VOjuPB0Q65e0U6eXFm2sCA
 2Aqbw57qMAUwonJtEQGnAuWJykPcaLvSwCis5ymLvri6+nJyDMHtB9hd+sUIdD0CPsDl
 dxFJIZEintPYph1j7tUhJ/GxzkAFtOWBF2ASMe6BcT9OefcrSdI1j7imbvOxcVqXXsM0 iA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=siwc0uE5DuBmr1NufN+Df8YLuXXav0vjFuEq/mihMV8=;
 b=tRq7Xml72ICp4a56HsObsAsYBa4RZwUwMd1ZCVGejI/gIK25BAspgLSMzfcNpaWHieqO
 khI5Yz4VtO029UxGWMyCkeIPmqmEUdC/93STzkhSEErYopCVkM+7xkV21JP2Rd//2Apm
 74feDp++3iVTDBaUNjHP6G8fesOqiWHisuQOc8TJNp8KXMIMcUNqbFw9Gs/1ZmTFrOGS
 KLhhq+r34YmOOLSsoyg0QDk6TTbrB6evVws3R/IVMsJ9ShLF04ikuB7qVnUt4oGGCs30
 uEEOb/wsmeAfSOd5odSU3ZD/opWfmM9Lgb7BFCzY7AED5PYHnJNS6IKYFJf/McrPm7Sa Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4vxcg264-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:45:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V3ZqZg011997;
        Sat, 31 Jul 2021 03:45:17 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3030.oracle.com with ESMTP id 3a4vj8vg09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1FDV9fK9/HYTxGRurKbG4kqeET3csF7SdritCyqB/sh9LeXNH3zVQgtFg+FRYcRWcqIvPeNzKyA5HkElaYft1NGwomgGR+1ZZfN0I1BCy1fmALLdj92guZgOhGxdNZrXeh5BlchiCSMNTSi4oLnMq52ZWh3rTOhpQaYZgQVHRZWnazM2Dwf8v7couxPS2F+k/5+rDK2N83NQ5Y7iROKdlDFzJwHFvEwWNeS5zpc7cZVOj7+pTWKuRWJDWJE0x/5RSUDq1FZw8vR3Os7leA1Zd98tM5zDMuvfnuaiQTzyj3w2POvCP4qVoVcIn1OZvAZJjnSjQSE/fmX1EA+wTKNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siwc0uE5DuBmr1NufN+Df8YLuXXav0vjFuEq/mihMV8=;
 b=Cq43+dArOoZc9gczBxM3TQGQbSBvUAJkBXE3nq6aagiednEaX3V4aHHuGXvxn2ZfGEsh0sk81QHzjwNSoWuIs0xy2Vm7gSWSIOMcfSJv5yJUFjXkL1/IPtQ/7b4msuaW0NeYjMpMPFV5queWZ5vklVFzI1vn5uaYXy9THqu0mKS7adUdJIVvhDnQdE18JBD20cJovqhvGZgRen/Vq5X76nVErar759eiiTadHye7XRAAOMdWccBTxv1gZiSXzRESsQUSM1yKW991McdbO5eWqQ9RmqYQwWYXCnVzTQi7cTPleG/w57B6Xyo6u64hz7e/bHo8/XrxRIizFeYm5pBNgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siwc0uE5DuBmr1NufN+Df8YLuXXav0vjFuEq/mihMV8=;
 b=fbm6nz9DwkK7/qjep19bXy2UPYZMaFF6YLMA2U9BN1pqEit/rn3fEwtBgIZi/0pqbo351u5pkNFKD/M7pZYQt+qQipOCB/fHuBUsQ6hgHXGXTOh1yBkyvF65J9Y/dw1sH7LSWsUsN7wmX3I7rLsu0wjP8YHuyxQvf8inyFvpCQo=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Sat, 31 Jul
 2021 03:45:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sat, 31 Jul 2021
 03:45:16 +0000
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: Fix typo in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im0rmcu3.fsf@ca-mkp.ca.oracle.com>
References: <20210729082559.1933-1-caihuoqing@baidu.com>
Date:   Fri, 30 Jul 2021 23:45:11 -0400
In-Reply-To: <20210729082559.1933-1-caihuoqing@baidu.com> (Cai Huoqing's
        message of "Thu, 29 Jul 2021 16:25:59 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:806:130::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:806:130::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.12 via Frontend Transport; Sat, 31 Jul 2021 03:45:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f69f38-87a9-4960-8be6-08d953d59be5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4503485674A0AA2B6A217D068EED9@PH0PR10MB4503.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkYz97fovfI2LDPEXHfqLZZBUlF5Maf57xuIMVbuJyTcQzKeTL9LCGYO3L6VEpRZoDl7Wy0QgaxUhcyx/KzcH9qAUrmY0AfemmUG1Pkzs+lF5WcUPENJkbqRXFG+WoykK+E6GCnAsZIX4zKIZMXLDRzE5XQo0cmVrPVhYtqQR7Nqv7o2BNCYBwUb1DmqCTh/LRcM1aZq06QwlS7/uLjI0y8sESCLGhDwPCArqyy5NWa0e8nURtbgBTSKcwkOGPKMEGWNPCZwW+Vjp61k5LVB0nhCnRETMKD6bOIqhHaB4UbyaqnaLtOlOH0ZCXyC5KXOyLSWVyJhH04WCqV9N07slixvDUWUhkSACbFyqFtbIzqz+aQrsl2cwj155NqJ3uKE4eNfCLMuKUaX4JQpW38MRA550Pc9fGKQ+uU+XXyXwyr4WU+1maeaEQO/p6MiUt3ih0kEWsg/GzOLf1nK/QO9PEDIF3MnY6+wFoxUxZ2OmAux5ra++YDqAml/fRus8NeycNx7pzhe7qtprSPQiDhP5SVqSOyhbADC1F2YhNPBAdQB5dKrKClZkNObe03OBLzXopP5osQbXBJ5yk9I5XoRMZnmUtX17Sdyt8KZhp8cOHD97QWsD74lvF5llbWPMpKgu0oYO/Y2BbnMHaIFadrDDqENRIsIwP7vW+TAJalz+OILpKQD+SE6p/9WDQP/m3RJ+1WZ3Sz1Fec5SR5q61Dflg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(54906003)(55016002)(52116002)(508600001)(7696005)(4326008)(186003)(86362001)(2906002)(956004)(26005)(5660300002)(36916002)(8936002)(66476007)(316002)(66556008)(66946007)(6916009)(8676002)(6666004)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1TikDlOT3/7qbMMA69rdm21m/9uPT64Rm5s/yCnWuFas7n3FdCwBlddQH77H?=
 =?us-ascii?Q?DqHCTXg+o9EHUL7O0C69FMLWYB8FkBmE1uTiMBXlGPPKhESyuqvM14Z2k0mz?=
 =?us-ascii?Q?w7aYJeV99WgNe1DG2E3UEqHP6uQmdcYsRhPXgqngYO4i1K7oepeWpHlAYi5v?=
 =?us-ascii?Q?2WRF8wJZj4dgyrKEy0+tnekSfZRSb/yTVmIP2cgJRejBF7++JfOJFLEagr1d?=
 =?us-ascii?Q?FYbqkll/eGMH+6DchqWlx7jJdZvFnFVn44cVH467y7WJknB6o9ZNi2WSyqee?=
 =?us-ascii?Q?itysMT2Yfnzq/vqXqNoA1yR8YHcQZvGiYu73Acbmcc9e66n7z2Z1jpihKhQ8?=
 =?us-ascii?Q?ujuvfxAEAOkgQN5Fe+jxpXnIbHRHtg21Jxa7mjDO1j6rrGZX984BzsFHiso6?=
 =?us-ascii?Q?VMHwZJzMOJwUsYRUxlWqdxGN30h28wAnd0F4uq/dvmSGAn7LIcF73VnkIK10?=
 =?us-ascii?Q?kVg/uCcxCfJQqfjx+n39EV5hwwafucfzhjluPalgLJ9TLfP2XVi5qJrPc+eP?=
 =?us-ascii?Q?pjEp8+F1k/BlD+HXnMbU013J9161vPA00Zy0V3xjvyci6w7vyLUD/ErUwyoo?=
 =?us-ascii?Q?OvMQgtC3lDW9Zp+5R9ZPJ+BlPbCfhv7P1IPza2VpsNWk6wtQdYz3sfrJ2rOT?=
 =?us-ascii?Q?sNBe3MTT4yNRlYp9r5M5XkFu0nFeUzq21npfIx/z4jfgFi2KCu7g+BoT4R88?=
 =?us-ascii?Q?HOc0EUrFy4FxqFQjY+1fQvhlp29sAWyt8bsAnMW2R08eUNUWUUvK1v8ZRlJP?=
 =?us-ascii?Q?hfMqNjOIru3OwQbeZBL0DccsxuF3vsIG4rwZq92rNc0L+5NFUoJmwMjwwBtD?=
 =?us-ascii?Q?GHM3ScbKRvbfMGD+wb4JskbefZBklw/R0+ID+a9ANQhp9fnNPQRraKzRvHY5?=
 =?us-ascii?Q?mJQYY+ru15gAp2RVK3Y+q+bkhGVNhtJpjCPMwMnum2YWjci5XUBoVOKIrLDW?=
 =?us-ascii?Q?eipE4NLbYhvsmb8444Bk9dN/RYSb1k/fdxrTEHoRRMIiXHkkfWSbnDs69wBq?=
 =?us-ascii?Q?W7DZ0c9h7rr38s3dpqf3gZ10vy0UZXgtGvTwWquE4ht1U+Ix21B01CUHZJ3V?=
 =?us-ascii?Q?xyAiPUudFSZY2pBiyaNeAfypH4xLA3oe7zBOyLASQB+mY8aGex+YRD3GZviR?=
 =?us-ascii?Q?xd2XTp5T1d0LFeAIbLwyvPJgLiFz8unjJs0nvhx01RlPahWDveHZsNdrcS/T?=
 =?us-ascii?Q?+f9C60pfOSc92FkjPS1h0uHiAgGbQb8SiNqr548swCIr8Wfly62HtyhYJx37?=
 =?us-ascii?Q?tXVcsdUSR84ephDm4a11gzzsrGRg0/aQr1yZM1HIIu/WYN5fQdEmygxPBOgi?=
 =?us-ascii?Q?eBEonXlrWdZkjCE+zcfCuZ1h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f69f38-87a9-4960-8be6-08d953d59be5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 03:45:16.0617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TWiEqXsASSOlIRjXNZ0Ub/V+bfdJMvPS0U+2AJpnX5U2I4RuMi24E9ZHpG40A45NA3xiaEambflZMJELYYMUgqqzNUA66dZTxOBbS1ZW2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107310017
X-Proofpoint-GUID: 5zT0TAocAXGgIi3ocr2MLfsagdMRZVsf
X-Proofpoint-ORIG-GUID: 5zT0TAocAXGgIi3ocr2MLfsagdMRZVsf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Cai,

In general I am not a big fan of typo changes unless the string in
question is user-visible (printk, etc.). But if you must fix things,
please make sure the revised comments actually enhance clarity.
Mechanical changes ("the the" -> "the") rarely have the desired effect.

> @@ -2255,7 +2255,7 @@ static inline bool lpfc_rangecheck(uint val, uint min, uint max)
>  
>  /**
>   * lpfc_enable_bbcr_set: Sets an attribute value.
> - * @phba: pointer the the adapter structure.
> + * @phba: pointer the adapter structure.

Removing "the" does not really make that comment any easier to
understand. "Pointer the adapter structure" does not compute.

There are several occurrences of this typo.

> @@ -7827,7 +7827,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>   * @rrq: Pointer to the rrq struct.
>   *
>   * Build a ELS RRQ command and send it to the target. If the issue_iocb is
> - * Successful the the completion handler will clear the RRQ.
> + * Successful the completion handler will clear the RRQ.

I suspect the first "the" was supposed to be a "then".

> @@ -2285,7 +2285,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
>   * @phba: pointer to lpfc hba data structure.
>   * @fcf_index: the index of the fcf record to update
>   * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
> - * flag so the the round robin slection for the particular priority level
> + * flag so the round robin slection for the particular priority level

"slection" is not a word.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
