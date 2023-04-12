Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388E9C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 01:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDLBS0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDLBSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 21:18:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38755E41
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 18:18:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLIv5g018002;
        Wed, 12 Apr 2023 01:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=11mpZ5M2fkDV7koSs7P8pIv1ximq57EZkhSp/u9tim4=;
 b=VvpoGFG3ymMx704ofFKzeRD75Gh4xjy6MM+guUeImzqqKd+DB+s66pisu1MFvhFn468K
 0h9l6/pQF7lIvyRgw/c1LKCGptRzFKUg9+tY2fbGSTxUtU8FrcxOef4QcW/K9xi+TwRS
 QLus4yh+RYdPnqRbxm4k7xjQlsIbqxM7LMBcnToW4+O04i0agp6nGlgdguXiYP7UbuQr
 Hdt3rNtkFAGIH2qmLoZT2N8Y5M4bu+rhrfv7g4HX1L54c2NbHAmvyU5qadven3eLxfuw
 2VcCKwfVBN4eydCjwBeVoTgioZe2K3iUQ7v7gQNd4pYvg3+jE0In9/B8oFOrepXuKrRo xw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etptuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 01:18:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BNsTem030990;
        Wed, 12 Apr 2023 01:18:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbp24fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 01:18:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNg0IaAHxj2S/B5RU57l3FccsHdNhrmhdaqL2CfTRNT3tJsDqla8XrydKLykL1tq3HgKTAFmb7oC8QugVKTcgVNWbSeF+WYcWxvPbzhIriYrNuVk59HN6vHi9ga9gGkquM/D9q7Fwnj8eS7TzX4dDjGeatL+iKCiYyWVsmaGcV//1pLaGevj94y8Ko27sN7ZsKE9L8nFWpcDSFKkYtQ+i2PRKPzbrFxwgVXIanNX+zdsMsnEk/1+Bilk289/1oUtIYrRr3BJOYf3I+7mAPiO0/gQ9isy3ZPVYElpx2eA1ZufgUapETU2LjfLifshBtN1zoyzTL6STtHmV2bHNfZxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11mpZ5M2fkDV7koSs7P8pIv1ximq57EZkhSp/u9tim4=;
 b=Tct4Nv5Ds267fMyatFnG2DbJ4OCxYg+c1iOwF7ROsbvGUN3ebHpvyaCfw44ZZ1K8UeH5EeI3yUGXDoJJanzvNXGsbCy6o/CeTpct86JWgNtInHv+rfg3g9ruKEL5btVl5+kIjn0893E1LGiNicst9s4jWkuyIDWsQncv+7Ndp+QCc5XmhRPNrqKvUMHtsKl+myJ20hfWs6spVWv8kIWCPth1Gi/HB1Fexk6SL2k5sZS4g2WvMT45kFg4Ea5bUmKDz6iWFuMdZergaGOukTJq/ZVL5r2AU467WZA0IJdvwcO5qf6ENzoeLELhrmNaWjsHE9LFC5w27yJCRnHxWWmlWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11mpZ5M2fkDV7koSs7P8pIv1ximq57EZkhSp/u9tim4=;
 b=GYf9V5pXe7fJhi2ZNZkmuLTL6LpG1tApc7i09oFl5/9+LhIcbyof6TnFsJ9afdezqmXMtONAK6O1D0KXCoRgOkxjsHlhNffG9qD18RIM9GVkRJKS7id5UVP+/66pu85R0kCp55FHF1/y/u2JyuimC/9TLr+AoKbpGoNEBByJQXI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6396.namprd10.prod.outlook.com (2603:10b6:303:1e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 01:18:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 01:18:20 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpi3mr: IRQ save variants of spinlock to protect chain
 frame allocation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq13555oq41.fsf@ca-mkp.ca.oracle.com>
References: <20230406101819.10109-1-ranjan.kumar@broadcom.com>
Date:   Tue, 11 Apr 2023 21:18:17 -0400
In-Reply-To: <20230406101819.10109-1-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Thu, 6 Apr 2023 15:48:19 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: 0244ef3f-a29b-445f-4470-08db3af3cd49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PFWM3BvLAZrRreISnQaYARljRRJnEiwUqk03Y9BqtZsFm1o3nv1BuzjKXPVRXxQzWajqMb8u5eOXEoKXRAmAfuWtTLo9/ud/l43NmxvcjY0HSmAZS6OxUmTjNW35HHdw6VXOEk60jzlm9jLamFnJ5znfBzljkacrbC1Dfm0ZU/uu7+ikdusOSygn0Ssj248gEr7EBIFEroW1vPr9kqOChMxxnGwiCcG53ImLBj85RaBn5ivZixb8Ydk9ss0Ql2YOyqzVrCwMhxlkZcPJs73FGRswX3kjqutp3MebHoQ1WUJ4/Mym5CRQDFX5xzUpRwooqcET824YWpEfrVSZZHrAna4lfACePPjWEoSqox19TdOWwr1+5DIfjajEXRAu3ua/alXlcxVdCuyionkQWuLZ6i5gipj+cZTvk8UeJX0exjrcvpTdotthIp8ctOCI6I3Tmjv9ank9NHDmGySGlbfLHNH193A8SEGOPxLwbNjMfIbEh7RY4AQW35WmMAnCT1/3aazMcyEAYCdYLqYsmQ6mRWiMp8w06gzbPELM/iIutO7Yf9iplZ9xPahPcgjxLersyKcLlSS+T5n4LUR3o7FBWndiXOKFUUXrw5faChwpN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(36916002)(186003)(6916009)(4326008)(8676002)(41300700001)(83380400001)(6486002)(6666004)(6512007)(6506007)(26005)(478600001)(86362001)(316002)(8936002)(66946007)(5660300002)(38100700002)(4744005)(66556008)(66476007)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kB5JNGptPJ3P7Ew1LfMbz0KMurf8JMEZ6VouNoj0e+SKe5JxlC4xDZeurIRO?=
 =?us-ascii?Q?1R1tMrNihVOfyyf/+BAcdN6sZLrIM4ya/QFqN+HSUFgJ84xFOExHEVH9vOYJ?=
 =?us-ascii?Q?ovrZOdWkvzBJ52JcIl9SZtEBjA7mGGMP7ySK28PyBtA2ZVHAD9OpsT04eGMT?=
 =?us-ascii?Q?AWCjn1TE1kCm5x1vmicAqApgjB3MB7+PVaZfMarxrjmbW66Gw2dDjErNWx2X?=
 =?us-ascii?Q?hPFS3hTUxuvDS1cKTVfXWuNaVY8imDPfx6UjGTfAUnBxsOOCDIICtlQrBYIk?=
 =?us-ascii?Q?y0gPcH6i26mqJXD8CS3hM6OT+WnP246MnI48I8ez0sp+s3RmsA4DmJpjymJa?=
 =?us-ascii?Q?vRVs/7p7AnaBz35iwsysgqBCNJrmlXChZ+r3fUSV6miLSzY6Ewg1+gUV5rIK?=
 =?us-ascii?Q?gZMQxKtWU0xDKSoGhx7iUNxzhRh9ejHb8xAnAMZl/SECr4NHg7j4ajZkMPFa?=
 =?us-ascii?Q?odtmH8sJ+k3SOyGwBGDpSWBYX5gU76vY9bfdWfTB+wossQujRF84rVjS6Aw5?=
 =?us-ascii?Q?Den/wkLHQMY4397LsZc7EMKMYGGY6HPetsoPgPX9Cz6be4dWnQ2or1g5O6/e?=
 =?us-ascii?Q?f3PkNAdhwbYIn9dqpweQjlA9gpmJWATI6/+8DV8JBMiC/w2qJRmGwjKMnA8P?=
 =?us-ascii?Q?ij0ExZZPXax4uOiEdzI9bLsgFFkjKM9WOmQYLv9DTdB1oPlmTZsYk9rQ0eV/?=
 =?us-ascii?Q?3qrlUwPfE4/NG3qVOCFXAWiuoGivwlRUADwzhYrv7PXD6gbsLJv66I8csPz8?=
 =?us-ascii?Q?0V8gaQX2h9HBAaD/e+QAP80yPXfwR1qhm+dWsHL8zlui97iCIt0cR1eZd9RC?=
 =?us-ascii?Q?Z9Sq2l7rmJ0Osz+zH5gGEpkKYZ/zAyCwru532HeNSW52s7BYO07Mug1iGaLa?=
 =?us-ascii?Q?E+6ipbz8nwtqnPcU6YojMSfgqZKzbpHBBoU9pM9GKsiL7bWhrnaxkKMJP3CV?=
 =?us-ascii?Q?VjygW8Q4MUucdKb42iRZS22os81F2a6Wn5N8FwYs0FiHlzAH+09Lwc1a7nvd?=
 =?us-ascii?Q?MUOACnJo7g2Qh6potqlXSD5+tzeHGINaVdDyuhyAc/aCeJWw7qblKzJfAflk?=
 =?us-ascii?Q?W3DlO0CTBt3LFyvu0TJcvwx5QJdXZWwbV47o05oDV2uyglDHvSSEL5lQbgKd?=
 =?us-ascii?Q?VBksCF7ap28al01Qtt4ZQIzfIPWL2YcgLXC/NfG1cEX1m+rFtJWdU8KJur3X?=
 =?us-ascii?Q?syQVzvIgzQXXs+nIYv70j/XUiI0yI9MEAvdNVu0Id5l9uTkKmI+WPgFki1HB?=
 =?us-ascii?Q?qGZiIme+pVUGxd5XnEZsivk5+XrYHY49GMiqfyW5t3NBzJTK5fs1oizgWvNp?=
 =?us-ascii?Q?/f4IY5Hd/fgI7SRfYpO5cGibwzF9Px9Vrs78kNewKjKcEAyVOQSZjiTE5V2H?=
 =?us-ascii?Q?2S74LkibpahTfOBW64HYYtKQVhDKMZKb2NorafTknoUsG+Y5oe6WBqwNcIRV?=
 =?us-ascii?Q?soo+2w6/ScrSuS6oile9hjlsJxeJULSeKTRfbg/2B8tBE7TW89BgxAEzJcn3?=
 =?us-ascii?Q?8hc/x3pXOvtdUPSBZpU9BP1IyR7dPHOfCiwtgvx54TtUKRkVzYcV9OfiE5fw?=
 =?us-ascii?Q?hxVdpecsgoDdJlbbhSdcYiFm/W4MhjQIWvLxKWIPI+vFit0t4i7xCsWf+/Vd?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gJA76eEJsi8Y+dfv+uc9wbvgjsbIskvKe0r7VrbLr11npaWGlIcd58OMScEurke4aSGb6aDa9iDNubpwZ28WZn/PPWg4JluxPJFLFWMChvBVPf2CaiMf3csdDQ6ku2jt2FZFjsHWRuM6PFcYLVRO25DImlUeguyoTRhhzoCOTrk3gs3axxPqjp6CbiquW5gHjrMJZoK+4YesVncrFRO9WMG0tl0J92SgYArIIZ+1XWepwFbwdNxnBTLonAjo+MetWHjwfJyTnGWm13b7F8Kx/UCGeHHJEbdKocbBMlqxrnQY4/muAPhuoNZtf883K2RE2nUYH2fnLECp7D2qsce2w3+C06SIdJVIDaXek47cL1+9dFLvRpQG9qrbsyqb9CHDlRUuOMm6FrRXHFXUdJ7EmOnKHbkwYk3CUg6/f5jt1vW/LRdIpgfvaXz7TaCu/6oXZE9CI8sG3/krmMFBi0U7I2UnS8wGvJBbLs4MPZw0KEcYzJPTwemzW5lGwFv6OZ1Sh40OeF+q/SwqCHUYlwTF1ssuwRS0zD1VRXIauEZ0fJIkrJmeKUdbjsTCEwg2mKc8Uqac1HHoqwZFAg2mZu2cf9M6X7EoZ5wgbF/LN2jTesfclASvYuzM5Ad4IGtAelxd+5+5JQhaxAGJDdp88gbdrWl5Bybi2TO9mnzdrWpX4Fjbn9KopzSjQW/eKdMrrTzj4q5y9hVnfITL7vm5I4b5iq1eX4iAgrao8IXho2k0CFwTanWuvcYFsxn4pNdVHEdl4lCr535eJxQggqNVtN8Wt7j7VlH7IG00DS9Y55y5e1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0244ef3f-a29b-445f-4470-08db3af3cd49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 01:18:20.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEN0orbHWcUjZY6PxYI//S/aoKQN1HBNzA8BrbKaPxGBdHN0iAu0RlPN1BNknRPUbUpX3VZHD25En+aNDE3fjnWarrglGsWtQbuy/hkLCfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=749 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120009
X-Proofpoint-GUID: rAdeWRabV0mvnW9v1_M50kh7Mm57PYRw
X-Proofpoint-ORIG-GUID: rAdeWRabV0mvnW9v1_M50kh7Mm57PYRw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Driver use spin lock without irqsave when it needs to acquire a chain
> frame to protect chain frame allocation from multiple submission
> threads. If there is any I/O queued from an interrupt context and if
> that requires a chain frame and if the chain lock is held by the CPU
> which got interrupted then there will be a possible deadlock.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
