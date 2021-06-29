Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A212DC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E3161D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhF2UtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:49:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbhF2UtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 16:49:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TKaIDs018048;
        Tue, 29 Jun 2021 20:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aSbowzRDXgTjXYPheLZEQprDudWyCHnFMH3jB3yfSxA=;
 b=LSrPp/KiXgEjxQUqKRBu+LpZiChEuta0s60ED2FO66JDHFydI3cZHqso90704xBmuHnr
 fRoUfyNoihWoAo3sr2KPPQdN9NHbL2wo/dy0hj/aKWrKiWRHgH5g8YJKlPYFpRoEVtR9
 ZWyEOK70tRxrFlt9VrAs2EffvpaxMJ2dyxePBDS2VuEDF8zzwzuNnnTT1nUVmevGi5Dc
 r7xj1F5p2VjatBh5XDJCmFw3vT8eB9y9VKxDS7dtCMsPUrkoNYscuIu8l93JhV5IJGSi
 RnXlajARj827vz4rgmSltc3ppV1XGIA5GIFVgwghYTuQDfgw+ipTGNdgirOqEjpo5Xlm dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqch8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:46:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TKa53c080694;
        Tue, 29 Jun 2021 20:46:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 39dt9fm7ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:46:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2cBSvk99Qe04Lo2PfnaXH/e5fzYf67CSrzL/YqetP/uH5s8YkXv4L6853g4FpsNzAVMwC2p1xCJrcvmJhUEU6jbNwQCcwXbFW8BsKRhDBw/EXnCoAS7YD3SKAJXQO8BYHXI6GatvD13PnqxY+sa9+MLoV6WBWK2k8WpPQO5e7xnWGM9dyfxvV1YTlY2nvplsVfDQ+IAW4B66NtQYBvSG9NtyD33aj3DbBA/qD55eQFqnZ0QhAQ4v0hdqu44ucdAEUPswZ5/oilSZ+A3vtNtbFmaQ/5cYIy12ybbj/QLAqbMxAbIc0m0xR9xMtNTt2UAXGB3R4oGTKu8o8sxLBbtJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSbowzRDXgTjXYPheLZEQprDudWyCHnFMH3jB3yfSxA=;
 b=AgMW6YiKUGQCw1mmYy8qDrhJ2Hgk5RNsOoNr+m3pF1i8BhDqOl5jOj9sliSmPJesXm6FNFde/Pu5YqMyApctFukEbgy0dlAQhxYGEfUfhx4A6aNM03HOZyZbZsH+F2Qv5W0OXVlHY9QBY4p1PMKDGeSNn1B5N3EpYAWZh9b4jo5gHsVx773fo0rRKftQO9LQ9I+we0Gp79mVHUm8FuQDV6xVxsLFLmgPRavTSUDKx5s5hWvkpki3X53SNCkfHScYaNw6M9KYen5SzGs2Dy4Qc0+fKZQmsamX18kegjFxOuVVRwsfi5LW4G+5XvHt5bH0DMDIQQl2ETBuJ9erq/GVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSbowzRDXgTjXYPheLZEQprDudWyCHnFMH3jB3yfSxA=;
 b=zSfHY0K9psyyfZHTm07queqLsJ1aDsj8pWnB9BHvOTqRSFK06E7RbuZ5SjZ/tkwg9P+WYa0sWnp12RfOdEYtCj8F1tL51KWBK+iPFndZ6QtWTvBFRB4TQh7DYByUQF9COIDo5tvclyXlGk+0WCw5U/0AkSPKEDm7o2fjwA5xNr0=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 20:46:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:46:33 +0000
To:     wenxiong@linux.vnet.ibm.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        brking1@linux.vnet.ibm.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 1/1] ipr: system crashes when seeing type 20 error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v95wielg.fsf@ca-mkp.ca.oracle.com>
References: <1624587085-10073-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Date:   Tue, 29 Jun 2021 16:46:31 -0400
In-Reply-To: <1624587085-10073-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        (wenxiong@linux.vnet.ibm.com's message of "Thu, 24 Jun 2021 21:11:25
        -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0156.namprd05.prod.outlook.com (2603:10b6:a03:339::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Tue, 29 Jun 2021 20:46:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b13bcd09-8ee7-42bc-3fae-08d93b3efaff
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4631E6097C611C2B59DCC1CD8E029@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LxaTdkjDocPTDPMrxOqQrRAFrZlYwjtPPvwlLEQuwXiMeQEKfzT0gZhrdQQ9lxkiiZhF82j4LVYFExa6NdgaJlbvFqYuIFCWT9tx78tVO6Cc3RK12/Cmy5yxW6E0vHAMwjVGaqQRSROalA4pax2wtkOFEr97JzB2JpMCZkaqR/1DTeEAE1EMBopDUJ8iQO3rbeZXvhZmso+no2tz27Mel0xQ6bfnQt1O0Lmrp8Q44RMvLFKNcp20QSlYV5eZ1IY7nA7Oh3aTtvXslxfRIdA9gD2dziwmIqLJXJ0zjMafrj/rnCya1Kuk74qP8EsRAInKOWAfYOXfkRHR1e/KFksxKVjrrzAeOUhhrqk6xOu8//hK6YlCQK93dQPlGh47gCglZJw2+voBw51gmYUOJqJ0ivj0UCkIVYc8sOvLApRPKt+7nMgMCgy8ly66A0Y56LKcOx+VrCslzXemZX5WwAlpcLIBzWxnU1NeR6qAWrNtpAHAQrM1BwDBxbcizG7mzNuxJZ+crIZ/eJGUBpKcr/PhtXCLQqNWhfgrhExNmCODr/UUtWViu+h9+vmmcWqO2Ayd6T+B3w3CCCNok/gXqqBJL/EGa52OMqf/Ddjz1lQOGuceep4FXnzv38buB8Z9S1cKcYnXQeeswgg4If+8FdTLgpbpdVcKIT8IYFpaypR/CjtUwTzZXuXTsTEu2FcQotX9wDSsglYiJd/o5Fx95K2zPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(366004)(376002)(136003)(8676002)(8936002)(6916009)(5660300002)(956004)(38100700002)(38350700002)(55016002)(558084003)(2906002)(66556008)(66476007)(66946007)(186003)(52116002)(478600001)(4326008)(16526019)(26005)(316002)(7696005)(83380400001)(86362001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qigte2eWhzcSNDtUcmVde8y7yBofNEVelfpRD1fneJXCrpCh/US8jY2b+P4O?=
 =?us-ascii?Q?YF0V/7DnuTdlsuw7//RrNsI4tcpAxHB3CqqcLUE1Rg4ZP4+6a2j+xBcb1ss1?=
 =?us-ascii?Q?Ce5XXzUNxKNcq03cNXg3V/eexurf7fZBRDrLsJNFxDOQW236Ck6DpXg7ko48?=
 =?us-ascii?Q?TEVY41ETdhzIh9/+04QQCj0GvfYB51DTN3SHM6Sz3uUY3inpTBm5yUYngP2h?=
 =?us-ascii?Q?Scfvaa0gG2WqxyA/PoG/J3gCYw2IgHJOf7l57dIOPgRZsSAbOQfjejMaBK7l?=
 =?us-ascii?Q?pdLDrZ41SiQXOKZx1d01cdUltrRCs7fgMbHnrgfjOfsfyaBn2wApbmgwWdUU?=
 =?us-ascii?Q?0AKb4Kk+sUXZbKkBWN4qamo1AeXiQSvSSNkhx/Ej1oxGu35HBmQxL3YBqqQu?=
 =?us-ascii?Q?7Th4WoUaDS3YNXnI69Nh8Kprz7b1tiGQs3LHxCzT3+W1F15CeSGsttMJzwpH?=
 =?us-ascii?Q?Ez8kSUOu1HnJ4vqmLtLQW6K8ktiU6pr0MX7fV0olOKUB0gsREotNDzpFUjoB?=
 =?us-ascii?Q?xxpRyAzd1E//35CTpgV4EByKTw42BsHChLwbltFom6g8K3m73eIJV95D/8yw?=
 =?us-ascii?Q?Z5RVRTjBaxQBv0OsPef8kBT752IBgRfTDS08xOWEirl3VGOQ4mpYX8tz/Qm0?=
 =?us-ascii?Q?reKS+gkBKx7xcLpxSQFrKbBNjxX1BXiSV2ve6yEh0YK8pCRDfpJ/dG7lb1Ux?=
 =?us-ascii?Q?8P+a7imtDL1aL30lw4m+GLrhbVeo5S7jPZd9KwlZB0ckQTPLCqOZtNWpjgUU?=
 =?us-ascii?Q?LljfKCI7SSSMRsGARsZl4FmlZhudVsfaQYKeBHKlN4YS3m+2y5kSKzDfNKA8?=
 =?us-ascii?Q?+zGciF14n/XEWt14fsBMJhVVsl/4FCtTS27j8B627PDndhiuj9H2PYxfKm0X?=
 =?us-ascii?Q?uf9aZbGBhI0B7QWRjB+sx0q+XEm3SdHvU8lAOuceGIkMVSDLYiT92kK7lS99?=
 =?us-ascii?Q?q5dQwBM+o6xX0cR919owd10yiD6LKmXuvFKwSJJr4DvN/4cDMibOPNKKcIF+?=
 =?us-ascii?Q?60otXLHxCXkd5mxLhPkQSoqKTryLMoM/5e9masdFmIiS6Ra72zoT5yUyDqQ8?=
 =?us-ascii?Q?pT4qls3dLyu6P/Oh6Cb6zj4eAH6AgE1XpL7PrFMqDEHHUXu8HNDJPaVctXYy?=
 =?us-ascii?Q?hkAl0ZXUIc7O5MU8/JHj8cKvHz9pc69rFh8cmj54jVhuG2h32oKVU00F1wXz?=
 =?us-ascii?Q?HJBui5SGREXnynTI8n6I+wDINmxkZ5JrPVglTMW3s8n1TQ/FuCZ6lkE4BcpC?=
 =?us-ascii?Q?/rUX1UvHl04p/SDHGeMQxzihynMiuXUjMlSx1xt73sagRqk2P1d4iLvoBzxH?=
 =?us-ascii?Q?dUWpE5uUI6NgawN5khwHhwB0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b13bcd09-8ee7-42bc-3fae-08d93b3efaff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:46:33.6919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b74i6Y3luTwTgmrFBm4t9zfy9YHe0FvyD3zwzB83CYgvHbz5TZSMpmH2lgh/zVZ7YqT2tKidkqXIo4f9N2xCN0/4jYbKxWRojIMXnZYXLv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290128
X-Proofpoint-GUID: rlcY1y2frx0qdNXaYN2E__pAG7njV7Bs
X-Proofpoint-ORIG-GUID: rlcY1y2frx0qdNXaYN2E__pAG7njV7Bs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Test team saw "4041: Incomplete multipath connection between enclosure
> and device" when IO drawers/drives have bad connections. System
> crashes when handling this type 20 errors.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
