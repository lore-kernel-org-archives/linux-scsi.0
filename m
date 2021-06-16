Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20C4C48BDF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40C061009
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhFPC2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:28:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12862 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231233AbhFPC2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 22:28:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G2HcGg005471;
        Wed, 16 Jun 2021 02:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KsjwVHuWeDfa46e5u9cWAtS+H6GRCJz9oXPvIcdEGXo=;
 b=hu7QchuMo8XG45dEuF5q3dFH04VpIOqgdu2Y0ZyMFL5+/KtSQuHVeXpV12QBJ3bwWeQA
 E1hZmsyjUvTwyJBGxF1ke7rATXhfEWhuxFo/mrAiVu8ZkEL3NR1l2tIUzjZrN/ZfVTUT
 lSXxsVashwB3aKDTrlre49XOrvjRsvVpE9D0X9LfBuPbirhKYnLRCzeSn8T8pExdskqh
 s7C381PtnBFw93cSvX+g2p0t4QO8srtFLBe3SMOKwTSvqRcTe1aqf+NMIDbB5gePc0Bf
 IuVyV1Q+CSvr1G/cxXN4DILJAyJhEtTPhAW8x9+qSoS1Uc1pUiuPa02OdJMuzLkS9A/0 Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qsrm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:26:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G2F1an104705;
        Wed, 16 Jun 2021 02:26:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3020.oracle.com with ESMTP id 396was49g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:26:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWt3oETQTjLdjukaxt18oZtFUGLdDO6Eq4yIjuBOAp/6d8B4RmY4X7+W5TZpD4/6UqS2s1csUoetbhunvCvZiqzPi/HNXToGvAayx5/KWN7EeXMQG9F9FPNehXNiX2fk9BXscgYYvjVN1PiFuf6+WJxiimFJK47LEqYdDiBZCM5kYvX2j6VKY97+/pKMuU7uSjy1Js2ZaBJYbXKsiTwIh7SYVeiOzkSngTZ/Ej0bSWlJWRrxxVVpk9LN+GcHSv2/+LywyBxye3fPrXchAAsxelZaP3YT6vRkIC8N0p78/EHntrFbHUJdDzhkYrHrVKiJhy1F6uaCrd2UlcU23r7y7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsjwVHuWeDfa46e5u9cWAtS+H6GRCJz9oXPvIcdEGXo=;
 b=H4xTFz/aI1N8EPV4iZ+yyB6M3kcMUPavTJ3bNu8vsTTsZyd23he1LrT6WX3iaO69dHcaIHkY+TAuth+xadmD81OEJqhBspmGaTu7jpGmM2o99W4lZoB4g2uv5GEDRtsp+qrRg4BQb4twBK/EuWNNCPFau/11LV11Y0dtuVYNn5Cej7lZeH+YVgQAQgeUEwRIuktmpSqDMeEJQxNLJ2JnuPySR2buAxsW9b1aQ4XqQz6fPQk/eTMbeWuUomEC/2FZjfOSpLxSXXfc4t15meP0/q2jdSFCySYLAi8Mw7WtazaVFEWdS4ubwP5gF7P5hX+oshFl7XJntLZQXYLzVSbElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsjwVHuWeDfa46e5u9cWAtS+H6GRCJz9oXPvIcdEGXo=;
 b=Pa2kbKt6jatyA/hp6bvTzbg4XXf1vJBaA3TcgHYg0TfxowMafp1AeA2mbKtymozsWDWLl1fnwB1HSkK7pbACBqJqrY59j73Gws87p6o9GWu8Fk1EviURBRQh7ijKw0Och92qPZPs7HYvpMyrk5uiRWTzbS4VTWz5Q+s2UpJq2Hw=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 02:26:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 02:26:29 +0000
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: lpfc: Use list_move_tail instead of
 list_del/list_add_tail
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnqu5yuq.fsf@ca-mkp.ca.oracle.com>
References: <1623113493-49384-1-git-send-email-zou_wei@huawei.com>
Date:   Tue, 15 Jun 2021 22:26:26 -0400
In-Reply-To: <1623113493-49384-1-git-send-email-zou_wei@huawei.com> (Zou Wei's
        message of "Tue, 8 Jun 2021 08:51:33 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 16 Jun 2021 02:26:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65ed2cb7-8a19-49c2-1ff3-08d9306e264b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458383745A478C86F3A29D4B8E0F9@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEJFhuCloMl1ApxvJdPoEm9BzOXoAvrkcYaSSDi3vkA+JsF+7j17KJFexlrgMxH0HylHNWgmxp998pjKKP/o9Ry+E4sgUfCQ1zJdMUX3KxT4ZanjYzL9NQIDj9QFGTQfZW8iRAl2dVpm3RwdsW5mNets1XiYWQSAoSLhQ/v8rQAvqIpKPkckuPkV5VbVOdJHtqqR8UIEleKxDlZcwVATgUMDIIujlle2ZnW/NHjlkoMlJsIRNMPiQCGrvYRLSi36Zwu9jS9XjR5sIZw+4WCNgbq4VLIIEY6VQzZCt3mKsYGy8gZVEE+/SSCPd04dh5bkmxMkjHNdXvud1CiImXC38FL65Redo6MAjkPZDLIQ0BM8rwbACkJqePfSNRpohq57nr7Wbb/3PZ1uaUk69XEb/xWIDMxpdAkqTj8K4q6np/z7kpt4y792FQoP2ZmD1UrqaCYXbC0C7fCQ70wk1/CVDMw1zJi/j9fTVHzQ1qbgo9hVhligXkWBdXLP38WDi17u79/FTO2Yuc/dIBP9DMeyIlJ1eYl12ZAy04QBqjabAUBI6Z02OgEaB3NNJNV6EkxGrOO63yOQY909lcDF9xeT6yw6wIepRgmySncHQM5TUFjMXk9wS2PErGQGDrzkya+2SJzH8dSHps8liyM5BbPTsjopKCco6QJAmgmgil5OOX4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(136003)(396003)(366004)(376002)(4326008)(316002)(6916009)(66946007)(66556008)(186003)(956004)(8936002)(66476007)(5660300002)(6666004)(36916002)(38350700002)(38100700002)(2906002)(16526019)(52116002)(26005)(55016002)(558084003)(478600001)(7696005)(54906003)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1P5Vsc7KrenzVb7g3W6eEh3fS+sQ2B3ldmjKtaXEVnBtJPjbO5J6xGjTLvh?=
 =?us-ascii?Q?Acr0IPppgV/BlCG+ocEUzBkNjAGOZ3/ZT4tV0/nzrh9rkycbzvR090vCCvx4?=
 =?us-ascii?Q?a6tjbO0tx+jpt/Olr0UevLCeojO//+lh2XiG0yg2RyH/IhwrXOctOCu7tyUH?=
 =?us-ascii?Q?oE1axrYBfHGkgse9QZT+ZtOfh4HGHTmVqzsramuMDvLUgqB76sbnPy1B9jNQ?=
 =?us-ascii?Q?LMYyr4JnH2r5EFGK98QMwJBG4deSICpYksrnawMpOQbRebIg8QgxiMY7APKX?=
 =?us-ascii?Q?ZccWg3Cr3hLs14EIS2NfVHweJOyyNr3S+5ZNnLiiea36gNYmdeCHUCIOwO4v?=
 =?us-ascii?Q?IHpW5RcPuYz99EN85zzMbYTWft2j+mYatz6Sbwt6BWEHuMNUKai4MBk+IW9X?=
 =?us-ascii?Q?Cx5+t3d06HTtqHHaWXa6DNGJPR+2KX6nQJslpVz0drfp4C1EvKN1Lx8WoOG9?=
 =?us-ascii?Q?Nd9C2lt/P6DF0yDIihOzgQMWV6vkVfbsicAdK0YMAI1QV2w4y0nP0wZ3CFHY?=
 =?us-ascii?Q?Oth2zm4iUH5tWvF7/TplpGy/tBfGb9ffGhB3Nx63QRhVcvIcyLQdEjCSBx5T?=
 =?us-ascii?Q?7D+7Ria4EdG9LrsGaJldV8gXTzCyxCg3NASmfUuPW/lbTbxVdaRe8x9rbMCG?=
 =?us-ascii?Q?pLRBQTd3MesCjq6+rHpZAPpyxKsq6F6MwZCgaGAUATck7+gpHuKNF/aNl9KB?=
 =?us-ascii?Q?iARVN1LfW6BNg0KAOqzBSuPxYMNy+F9oVxvvrVx9Wng4277CpnA4uenB1tdz?=
 =?us-ascii?Q?PwXpMYvdVRZhmJarYCdWHmEsvF05+usLrIHCTzYNg8VSEK5+YOaagRmUWLLL?=
 =?us-ascii?Q?jMK1lxgY4a5VD4QMIMpudLmce+myuFw7lLZnwIemT0DVUuCUCnPSu2mxmR+F?=
 =?us-ascii?Q?2ghCrUvAPZ++HpwktG4ECbdVA21dz274nArtDBf1yQmAjNHiH73o6LxMY8Uu?=
 =?us-ascii?Q?iYkkquQNEpmIY4YyW5D9bdTVL+SjXgjjIGY8hnLz4qKqGJ0AFB7C3nXZ0kkg?=
 =?us-ascii?Q?NjeVXD9FbgUwuoRgI2wqWfyEKL59sgpspZ/85TeVKwpRyBkLCEgAcvtO3JQP?=
 =?us-ascii?Q?Y8h5aKONxbQx1YUrEEMSn8zKIiCJLnQrZItf9ZnRLIl+TQSubU++AnzkiEcl?=
 =?us-ascii?Q?UB8+ox4t0BI1jpdm7ObqtWChKSJvsFcCMm2yVmx5FjPE9jgHgJexGGBxJ77l?=
 =?us-ascii?Q?6YgO5T34WUUikUpQY2uZ6Msp7BNbIFMGz268tfDs4to+b6EKDX3nakIEBQg3?=
 =?us-ascii?Q?Kjj9TbsQttnnU/WzZfLq0FnzVL0kv3bMhwFs4U/wtljmqkbVvj+fdRNVTeWK?=
 =?us-ascii?Q?LNR0IBx0KjxgfQBasbIDrqBg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ed2cb7-8a19-49c2-1ff3-08d9306e264b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 02:26:29.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sET3QHwhlC6D+kKNP99fMJTmkUeWiqeST//gLDvC1S0ntPASHDFWGlx0StQFPO5RFixYg3k9BceHZS6B70DyRNgYOcpqTtLfN30cQgJA39A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160013
X-Proofpoint-ORIG-GUID: MPfLP0ItK8L1kbK2fbOTfV7q3BkMbozY
X-Proofpoint-GUID: MPfLP0ItK8L1kbK2fbOTfV7q3BkMbozY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zou,

> Using list_move_tail() instead of list_del() + list_add_tail().

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
