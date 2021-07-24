Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6708C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A598E60EBA
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhGXBe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18684 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbhGXBe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2BetQ020010;
        Sat, 24 Jul 2021 02:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k7KSpOwgXi8YsiLBzZFjIDpErfZxP+lWMMIhwB4ESIM=;
 b=tjGI3Nxh9PtTxPD6N4SC2a9Q3AldYuAXgjkWUes0qhGzO1TNnPmx6/Hz64iEdqJBPKNc
 jnq33fKW0XLy4XPxim9IYaoomCthlFfBhgBkzbBYrhIUATbAKdnlDhLjNYrUmTDw39zW
 K/Wgm0CyekzQ6SpeZpzpHDDHc2PlszcL11fKz/GtfDvJGeVjXaDZW0Ch1HS20gNQjcNZ
 zh96D2inimPAKab4d7h3t5d4sSJI4wujQ3YbdjLreqAOO4QK1em4Cv+8Qt1j6BPJPmXW
 SqFEhP3uO+DEZGJ14CsPTFhtJTAhQ71oPOin4uOGGG0Tla7d+8OtLMM00uOBB4XmLC67 eA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=k7KSpOwgXi8YsiLBzZFjIDpErfZxP+lWMMIhwB4ESIM=;
 b=CE997cAsb8Fbg1erkI6C2bFJ61pA6uN7U8ZpkKmYJedXL38hee//LChaC1glrae0lAbU
 lXFwHTEIHueltMn1g8EiBtnH46K8RYnoiPe3b/k4TpXhHwEojZ3N0aK6THst9SMyrK7H
 yjHv9TH9OmeRK0oTwTIlJz/gjEZmEQarJOpZrNHwUL017nBUYWnt+CsKdwkrqOFYztBI
 x3hKET43hdpgQ/EH0pLJiotKH7jjmejgJ1nudNBttCNT2uTozXjn3C/FqFD/QKutzhIm
 HxPhU0j9pPgb0WeAQ5Awk3EBkDmvuCfMLFdcrVJJQe0NRP6w4oHorv9MsJXEA8ACBFUj eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39yesmtuj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O2FGId188119;
        Sat, 24 Jul 2021 02:15:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3a08tyt6fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPB4B5cA6ek55SQ322AAb3Z40NDtHRZ42v0YYdgDf/ac2miFWl1+rls+68/0z2sst/1Yk+jvK83A4APU+ljMQ9oQFQr5fTh9tCGnMa6lqgTJLZcpiCZ647kMsPI3iI//W4yGvmw/lGHvKAuUNKW6yn0jfgk7jVj6ctyuUi5c/hc8GHXvXEyvAs1g3R4gd/qyok18Bz/Z7xY23L8wPeUnfD1BWXXlPKmLmSf/FiaEUcrKFDgsycMC/7fra2DeCW8FRIzEs2jqMxfYN2DfQWH1NUMIO4pBkk9CKLbDhsPhuvHATMB+0L8/WlyUVj4R25pdGItOELxbQ/o7KVQ3MEO00w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7KSpOwgXi8YsiLBzZFjIDpErfZxP+lWMMIhwB4ESIM=;
 b=jLBJjGxFm1PzHgiY0WMGH8S5X2FUZyvEA57kOsXC0a/6vrGMxnX8Y9Vg8cehbHsTcR+j44s/rzRqUseQ3sytM+nsBB7t/wFiV8pdHAkNOgP6R+6tqdA5AIHoPgnZefXakPA1aJVeKd2ll3pwe0/iKYjUl3VTMKp/hQTY9TrHWf7aHtiEOJqGCv6nKG5bnpoeQUfV4bdHqE61ldTgIzr5GV0UYh5ketDu+Sx4wratKr1u3AW7EnrS81vRS7p8QbbmKNIPhPtUTM8+rmbO4pvVzV8ISlKNOI/EiSjsFV+hlCDrC3f80BrXKM1jgxm3Lbl1RHVoA5S29yYbZKLUsc8DtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7KSpOwgXi8YsiLBzZFjIDpErfZxP+lWMMIhwB4ESIM=;
 b=KyIjOUgPJVXk6Sg5ZAt8jvQqGdM01WNhXD5+/qfq//1GSXTDOp1WCHQWCPZQNsJjkvGEppD9OnkwhT7BqZOuYquTTABvLdRf6UmLtGjmBv0gIiiZqECO6Ynozge5V49MkemlWEuII67+eKHoZL/WlKzGPnNw9nyj6TKG21IgvfQ=
Authentication-Results: mail.ustc.edu.cn; dkim=none (message not signed)
 header.d=none;mail.ustc.edu.cn; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lyl2019@mail.ustc.edu.cn, linux-scsi@vger.kernel.org,
        ketan.mukadam@broadcom.com,
        Mike Christie <michael.christie@oracle.com>,
        james.bottomley@hansenpartnership.com,
        subbu.seetharaman@broadcom.com, jitendra.bhivare@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: be2iscsi: fix use after free during IP updates
Date:   Fri, 23 Jul 2021 22:13:55 -0400
Message-Id: <162692235522.25137.11080430478077124658.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701190840.175120-1-michael.christie@oracle.com>
References: <20210701190840.175120-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eac3e10e-1fc0-4bec-7004-08d94e48ddb6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46476F40B6EE5330E1EC67F78EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JvNriwRY+3DIvfrH6jDJf4rytw2lam/4D96EnfhkwjcHBHjjb12nS0m1BigDyVmFJ/4pKJzP3GJoVZyCAcm1otTbVCA6n9KI625sn0MEQsd90fZpRgYaQQVMYXqFZ2pxFd1QMTR3/U2d9efVU8j3Kwjjq0mtBgTl1Tm3npB6OfWhozKTiT3ohaW8vOFLyyyxIQDCLo12WrBnmZRWbbo9Bopv8z1VAH844nVjNwjyf4PtgEoa74b4IOU0bKwr2mlUgJSy1EKT5XBEGVjKkb6Db6KFtSPlWb/BDgXKXyLxf6aOfoD35VOqeti4MOoD9Su7WbzDnR70Zj1Lg3xTpxfkqj4v+yDSFb+NmVMQNRLVnK5JF/rA03GzIc0EdAuyK6F8xIkGrnrjXh428I3EjadkvYI5QqxkDFq71etR2Hli6U0cX1H1ME/ThbZMlvDXeU4AwN9NEniIsB1noGYJwSYH9T9fEwIHBTczkM1eJPMYTXNONPuzZPnh+qS4LvpDdqqnfM39G906FhicX5AzF3yvpfBhTAuUHj7bw23SEA5N9WcgbLReRROE0JNzDU1oFcOmHY55YWCG1zsZGgBtQ5DiQC57RZ/zkwakBGi3ZmK9WH08ICLREoaI0/IdqkrWLYFZ6VLbs9loPtf8HScqMgk9q1Mh+tC5Z9Z/CK0GLdPXY0uwjsohTyAAGdKa+bI5sZxn3KLbN8p3H2orLq93x51YnOKDXi3Ur/IKgMVUft3nCRr4EM0jrR9+gAwoGeQDiHeYgD30nmIToUKXmX1l8JohPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(52116002)(7696005)(83380400001)(5660300002)(107886003)(4326008)(316002)(6486002)(4744005)(38100700002)(478600001)(6666004)(38350700002)(15650500001)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Znl4VEtNdDdNN3F1aUFONGxmamFObE5mTGt1NjJBK1NEaGY1T250Mk82TkdF?=
 =?utf-8?B?b0k0V0I4cFRqTjluZEttWGQ5Mm1VVk5Oc1F1cVJLOVdIa2lKK1RVN3FjbklM?=
 =?utf-8?B?RWVqdjkzWjVhS3poUUF4T2I0YUZZSnJHd0YxZXR3dFR1dy9QNE1OZlFUS1JW?=
 =?utf-8?B?VGFKR3BXSzJaOUlTcGQwYXRFTFNoZHZ1UEU0aDlScmZ2U0RIWXFZZU42VlRX?=
 =?utf-8?B?a2gzeS9hQXJaVmFnUHppMy8xVWc5eDgvSFQ1eWR5Tm5LTXVoV0hDcWVJTTZh?=
 =?utf-8?B?NDJzakpyU1ErVUxhRGNobTJiUzhMdEV0VE0ycno1V1JVblBEYlVYdUhXeTNB?=
 =?utf-8?B?ZS9QRUw1LzlDZ2FPNHpYcTFvOUNUNTRVVEpOMWZuZGhXbGdXSVBycjFWSWR4?=
 =?utf-8?B?OUFZMHBCWWRCK3NqNHdOb2w3b0dwZ2JHMk1FYUgydVJzbUVDRXVjd0pFWTE3?=
 =?utf-8?B?ZDNBTHVPaDVldld4dTMxVVJ4a3YzSVpUTjRzKzRpeXVrWE5OeFdwVitDT3RB?=
 =?utf-8?B?WjNTVEZGK0N1aVl6N09pMnlwaFNHU2lOZG5JUVNrU09OVEhyNEd2U2RQbmk0?=
 =?utf-8?B?bjdGeDZLbkhLNEJtUmZjZjUvUmE0am5JSVdvRzZvRFhQVmdCeU8zOGZwTm45?=
 =?utf-8?B?bmpCNy8ycU0wdHpNM1BlbXRHNlhVTjRyWDVlL25LNXVjY3Y0YUZhdFJJNitC?=
 =?utf-8?B?czJEamRjUkMyYXF2VUlKZW5ZS2FLNUdMSlVOWmtYaTdqSFB5VkRoQzZYZmNp?=
 =?utf-8?B?Mjhtb0tUSjBualNuMWR6LzBEODdTV2grNzBoZ0VOUGM5ZWRVRityTlZ4YlZW?=
 =?utf-8?B?eW91dzB2VnVRMStpS1d1ckNCUTF2TGhnYkdELytMT1VJeE4wdmZ0RUx1aTBm?=
 =?utf-8?B?RjZuRzdYcHpHNWIvbVB2VXd4cHdMOXFOMDBKQVZxQ05Ba3FBNWZCWUZkK3JC?=
 =?utf-8?B?dy9vSlk3dWRjZi93dVByeW82ZG1BaVd6c2szVENJcm5hYU92MXRtNklRMWNn?=
 =?utf-8?B?eTBCakVtM0lvRlJFbFA1NUhEbkZsNjBaR2FOM2NOTlNnVmhzU09tbkVQQjY4?=
 =?utf-8?B?T1hPdytUUmxpcllzamVlOFJ3SjgvTHora2VGZTFGVHBCSVNNdCsycGJMQ2FJ?=
 =?utf-8?B?NFQwVjIyc3BrVUpmZ21pM0I0RWw4azFSOHB0d1JMZ1NLc2dERzB4NXFRUEpR?=
 =?utf-8?B?YXBCcnV6U1dRODRCelhCRTFzT0Q1SGVBZDhmblBqOGVGUW84amFCY0VmUFNQ?=
 =?utf-8?B?MjZJWHVsdThyWEIycHpublJWQ0l4MTZkd1FHZU5tUlp4UlZYdmNUUDZkcDBI?=
 =?utf-8?B?VVJPV2JrQytaTnZTcWNPczlqK09tNHpkS3htQW9tUnRCNEE1UVROMjl2alZi?=
 =?utf-8?B?OVpkMGdZK0VMNHVKTEFFRE1BVlJPTVlmWDZSV0dFYWEreDZmbHg2Mzlqa29a?=
 =?utf-8?B?b25vR2tScHlIcnpoQlhSVWM5dHVjRmQvRWZVblVBOE5LajFWakRTTkxCTWwr?=
 =?utf-8?B?N0JRUkxLS1VwWTJXSzhuZ1F4K0UySlhnd0dLbWZiUXBxaysrWUJLOFk5YUc4?=
 =?utf-8?B?c2ZuY2VwM3VNQ0dySXhrN3prVWYxME1jbXZ6MHUrOXFwcXVIWTRUdFVKS2h0?=
 =?utf-8?B?bjMvb2N4blRCODdxWmR6MU1ockdrWmpsS2xVeEFHU0pyNkZRV01FR2ljL0Zp?=
 =?utf-8?B?cWoxYnp4d2JNN01CTDhQK0tSU2dtTmVSUTlMRzhGMjBXa2c2V01JNmZvQTRR?=
 =?utf-8?Q?xqB6AoWDEWEfHEvkltjFDFvGOPjpRiHpfxnDp4r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac3e10e-1fc0-4bec-7004-08d94e48ddb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:11.5710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LpsdpKrWzgRk+kM+7fHVOdvX/jDZgCVXOe0O3LN7RaMe1OjrNv7dsIx3jAPs7wTmjupTRoi7KOouMYgABhwz21e/YFwAxIYpkUoMKb1v5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=972 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107240014
X-Proofpoint-ORIG-GUID: ISNRLurmlQ-vrNEtnUsW52WkeLc0oPtY
X-Proofpoint-GUID: ISNRLurmlQ-vrNEtnUsW52WkeLc0oPtY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Jul 2021 14:08:40 -0500, Mike Christie wrote:

> This fixes a bug found by Lv Yunlong where because beiscsi_exec_nemb_cmd
> frees memory for the be_dma_mem cmd, we can access freed memory when
> beiscsi_if_clr_ip/beiscsi_if_set_ip's call to beiscsi_exec_nemb_cmd fails
> and we access the freed req. This fixes the issue by having the caller
> free the cmd's memory.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: be2iscsi: fix use after free during IP updates
      https://git.kernel.org/mkp/scsi/c/7b0ddc134608

-- 
Martin K. Petersen	Oracle Linux Engineering
