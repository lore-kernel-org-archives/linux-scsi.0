Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CB6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 18:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E932E60FC4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 18:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhJ2SgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 14:36:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62936 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhJ2SgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 14:36:13 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19THHNML004532;
        Fri, 29 Oct 2021 18:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=S9acWj/IkugfxruPSbFkGFRpz9bAxldLyVsFwR4Jr4U=;
 b=jnS/zsujy3dAEuHgRPr+FYWNpir+ofgvk6/3I9TU+O4vWQSQcL1CHQk+2n56GcRoN3NY
 kMSH1ZmGSakmGNmzIh9lmo8Wxoy2Hsq8y02UUxtmy4OBtoxxPNMhxTq2a4SlSecinQtN
 cXR0AlypX8NO+nN/J1fOyeWZQe/NF8sxk+StXjQP2Z9vE9X49XZl49Vn+TALybFqRGhA
 ndvsm7sA13xWB3bjXIYKz4Qm/92bdFHNlk7aJSFdXFiJh+n06QjSqNXzsxECKJaWkinW
 UGVtYUXHkd494gpiU0oZErVemx/SPCWk6bvawPqdTv1//DiSV2E+z3hgNuIPHeQ8OtlI 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byja2hkb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 18:33:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TIFPMX159108;
        Fri, 29 Oct 2021 18:33:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3030.oracle.com with ESMTP id 3bx4gdgq21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 18:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pp5c4qfWs6OK4S0kedAPdewpMXyjgDfqkVwHF7yfUGzfPkmRg9FLqlLgj2v+dGD6+1tS47kRMkPd6d3tB6fCSYjNVO9TvlAk8ZMoPcJyoevp4XwjrfsezjaCS9UzkGf8FMnBkwQqpbnp4HWbMmg2e5g8+xmUevahWzttNBgzy6bt2/SRv1pBh9kiNFg/gtD7eIEwqUifsakICy4Lx055ykaTj7wVrEmaN2tmYzybIAyTzxv4X23IMOBClVJoqGOR9mGz7TLN5FfCN2wL5PusLItU8lxwvx1qbZnuj/Pwx/hOUq5qZzLvHG2IRwXVTdnoyjbAxFyi1sl8myMcMOlFtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9acWj/IkugfxruPSbFkGFRpz9bAxldLyVsFwR4Jr4U=;
 b=TeT77d9epoIViVQddVH010ecCdtIAISuHDi2CBl+9sJ5172dA1VTqAvXB28bX6YPUW+yOVC5UswKcRrNchHSqkS6NBPkp/IC6NncugJ7kBk/7auhxG2kLueal/jQmyr0l9jJNz2qlHIKYHVuoW8320RaYKEJAXhv06TnIu5gZTxIAUsfkLUlJyJoc5CxU7X3F+hZ30N5oXZJzF5DLh1oJ011FufY3ZgqrO1Saz0U56x2DL3EBr77W+CbA0UhfSoni1ZCC5Ec/22pKEj5+WgZErncEz1bOTxnsMP9puwXfluW71R9dl9IThhRWdz68W3dHWPR8tPYe5Yihu6Ew4YmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9acWj/IkugfxruPSbFkGFRpz9bAxldLyVsFwR4Jr4U=;
 b=glAwEcO2FvX52q/1Be14XXKpbrWFYLu3x50Otqityvenjw7QpznbpE0GavtXw6ngQhu1MxgwjqoWtTZ/+7jW1Jr0dms7qMU7PLjD+UQyO6op9k8x6jqD42xdCLueD8JULWw3qlpehXCxurc1OFjk9petq+WGB9gvSW6ARxoA/X0=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 18:33:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 18:33:30 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tugzu1ev.fsf@ca-mkp.ca.oracle.com>
References: <20211029155754.3287-1-avri.altman@wdc.com>
Date:   Fri, 29 Oct 2021 14:33:28 -0400
In-Reply-To: <20211029155754.3287-1-avri.altman@wdc.com> (Avri Altman's
        message of "Fri, 29 Oct 2021 18:57:54 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:806:d2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.6) by SA0PR11CA0075.namprd11.prod.outlook.com (2603:10b6:806:d2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 18:33:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc048cd1-096a-4916-d5bd-08d99b0a9aee
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44864751BEED0DB2FEA164268E879@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OaAFAXmqT6PTXdpkXloZ3vc4AkjM48+JuV5es4UvHBi2hw1S13j2enL49n100v664bYYLWfqMKAHd+c0wbSYaVug4rvkYe8mk21K8jtQVG5TYMl7ngoQ6sDtyMz5UkyTk6n+T71Qv9zTNU4Jsek9QKsWzCz2htPDaItuvwO7Ce2/ktYlDFp9bxDxvuCjByAn7aTHbuPU+yHQ3eHRpoq6Pa97HQa4zvcTNryL1fGiU1HHumNhl1mdWxd7BVvu4p3qCsCgmj2JEEx5Aw0O14TAILQHiPvcdQRKkVI1+8++SCu4V11UFaRRDsT5PV9E0YWzlfW6H+iZ9wYkXAiRVzbeenmQGthyHlidXJOgO1aMmRu/yIaW70Jx677uzeCwIBefn36q91QGP0y9e2XEIEjCmgZXpfLvrEG9NOTiI1Wif+/H+tG5yxV/JZAlCzVcCZTU5p2yE/OlYlK8VILvKr5zjM4iKZzc7rCLex/McLZPcAt/UhhYbeWDCwavlFfsyjYEp6YkhFMtAcAUoe16FUt0y6yEHSvZ8TSHu9WNag++1gb1CIMeTUNq7t+AaomAawB9opXq71XZuE0zvvjoD/btdr30LI86xOACygg86q4bdWrtEgZ521R8T0coMFLACT1vego3yCs93VfZs78s9w9h7SROvo8Z6eN6pVzRbFVoP64dDoUVpLfIdeKvQ0NK6QpmAj2SxpCv6tP3KJk9oW8osA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66556008)(66476007)(4744005)(508600001)(36916002)(66946007)(956004)(8676002)(5660300002)(55016002)(54906003)(4326008)(316002)(38100700002)(8936002)(83380400001)(86362001)(26005)(38350700002)(7696005)(186003)(6916009)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NMtTAE1kYv0njjQu4L3npcIhA4Bo0p4VNFRL7Oe2kDvipOjUTdZzxfHyNrIj?=
 =?us-ascii?Q?W0ZM4vaNem7EAebt6VZlQVfUU//Rh20ppRT/zNZCgCxEk28I7jjSwo+TNKeh?=
 =?us-ascii?Q?JaV5uzS3UMXBSfJEbh3OvrJcGm0Uebcel0SiPMw3G1a3WxOChS3Y2taHxUST?=
 =?us-ascii?Q?hxgk5iYmL1trjhsIpZWq8fJqA6HNNXKasi9773dozA+hX6UuhI41s8Bh9/AH?=
 =?us-ascii?Q?HBDOjxtfvc6rHRgEZlDGjNsI3XnPxQK9vp0CuVo2ec94jVVWJfCJXIlz4fkh?=
 =?us-ascii?Q?h1yPQ/YBcK61mBmKcj0HKCcupJ4f62BezaRYM4Yc/DcdnX/bNsW07sUXOY3+?=
 =?us-ascii?Q?bS8ct8us4mAH1pab1s17FSt6tfCyrk02bQaWAy1vElTpwTARCuk5PXv1Cade?=
 =?us-ascii?Q?a5pBcsWmGrNbWuMvX1QolS8WkllgQVe+Y9YzpWXVEBUrPRYk8OaZaS52lf4D?=
 =?us-ascii?Q?i7PR7ufXlj5fzHLrE+ssMVmF6LKXY+Lxudcy5rWewepmfQscsk8U39DbOiSi?=
 =?us-ascii?Q?ag7W2kA9Z9U99Rx+6Zpql0eUOiCfwvCvSWo0OlyA1M/jiKUtrLriKZY0uG1f?=
 =?us-ascii?Q?zplDZT1JvjIBjCmuC/4Wp/2eoz/G9KUPuuuknoFx9zBlmDIfUI0xppdBpmr0?=
 =?us-ascii?Q?/fdPtSAXyelcbluAAGDjSi3kyD34ijitN6Eqz0uSqXux5UJQIL8b4mv2KqzY?=
 =?us-ascii?Q?ZBvGPMIqTxOdFYkLLNSNHNLb35fwKy7HtCCxCz7b2xI9L3jsLoAT4OPo/lKA?=
 =?us-ascii?Q?0SjX0A1HV5l40DukjEk0KuvqMW3HsmcC7Bdcx/IxD2Ek7kCFTmkc8Z+y4DGs?=
 =?us-ascii?Q?J8mGjTxHOjip+kiG5xXEHoy19MQc6Cg01a6JVFs465xfLOQQQELUr/N/UmaE?=
 =?us-ascii?Q?Ni6I4v++23PrISRz0NccnxpjY5MwRRFMdy0jwLyBQBGOb9ii0eqm9JlMD5WF?=
 =?us-ascii?Q?rrWFHtsUs8mcNdUutFXIOtXYFiQ/Nv7x+Gq4ckBKj/3IC/wvvai5Dp2baz0V?=
 =?us-ascii?Q?fzqyMeZU/n9Lgba8FmwpjKe/QDO4pJq8j3be2Fy1gIixE1Pv6sehcssBzxxy?=
 =?us-ascii?Q?ztsczvIi8kgynUU3+++dgWuGSbw/E5tHBFlOcHCNXq+FZJ4eiDrCGyVjJaKr?=
 =?us-ascii?Q?Fga+6JZjrWfBplAR2exl2jzdK3RiZxYHCCaHE9xkOlY2+aFg9lF2lf2dvK7V?=
 =?us-ascii?Q?2O59dmgoptbkx8BKH1BIDSu6vUYdYvNARUrcx9osKB9nN33umNR+HGmHvq4l?=
 =?us-ascii?Q?5eWMVpNM1cv8tQDhPnf22vnnqSE0TfRs9nk6tHIvrvN5HtlDAbOLp5RLLk8w?=
 =?us-ascii?Q?VJNLRIAkbNMZzqhZiaBPGo1KCW4bPi35aZM+3rndG1z/NSdCQyjEPq/rGugX?=
 =?us-ascii?Q?g4Kj7Ta3NK+AQ5rA9G8geMaTB/xnyGbE0dTpTinNygUxpqFl6hSP1cKw+m2T?=
 =?us-ascii?Q?PoHs/pDy0TFBSSQoTQV3aUZyD+Z8wXSb18+wslh9IiVp7pqHSMbFvClWfpxn?=
 =?us-ascii?Q?NcpfT5+M3y+B0iJUn36Yn/azPC+YxtQPb4gtMSlo9v9sKAInFu9a5Pe7ACf5?=
 =?us-ascii?Q?K1AAGuc3tApT4ojZVCXdzz2+2w1KFK2Wqv05cFmZ6HQgmljpRnGbWQwgEqDY?=
 =?us-ascii?Q?HhKscxYd3Dx0NSy+d6VI/FCSBGL0c6ceymm9ufzDCPgoYU1vmc1EJUthDVr5?=
 =?us-ascii?Q?0h+nnQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc048cd1-096a-4916-d5bd-08d99b0a9aee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 18:33:30.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMICiIzyWCNgNEMrmDYnhXoWiC8j48h4ZLDU+pWnNCe2X1nqrU3b6Ngg+n15hyq2bAk52DGobaJPstP2BVd8tvnDO1NKQDmtpF1vsB82vsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10152 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=817 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290100
X-Proofpoint-GUID: rdGnpoFzZ7SldBDOsVtYIL-AjBW-GdQ6
X-Proofpoint-ORIG-GUID: rdGnpoFzZ7SldBDOsVtYIL-AjBW-GdQ6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> HPB allows its read commands to carry the physical addresses along
> with the LBAs, thus allowing less internal L2P-table switches in the
> device.  HPB1.0 allowed a single LBA, while HPB2.0 increases this
> capacity up to 255 blocks.

Applied to 5.15/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
