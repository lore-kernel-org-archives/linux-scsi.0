Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47C2C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B963E61919
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhEKD06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:26:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhEKD0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EduU149464;
        Tue, 11 May 2021 03:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sedSW8fG1O2MkxhXHaKxNFLscWtn03+8H9ImL4eHg50=;
 b=sNng2wB3nx/D+FlwAUjwsU9b6O14gA3XVDXrhL1uD81G3/FaKaEthh8S6np1Fw2jBayg
 vpyMeqVLwjHJyN6VDXMQhAPS8jexJoiMi2EW8wybnTEZ3N+/Xlo5xG4zC+s5/vJwMFRb
 yM/VCGG5J4bbFSjiGM7HyOyaMuF5uBzHxFKmeh8/IfG+lv7ViBoKdJBa+YGdqXFw0N7c
 Dhc1xI7IammCk8NvVGQhrpb5jFXFYO7eU/5T1Bu+RE7voZ/nMxxAYOiHIQWzcE+oXVDg
 66blyLvlnP1MLuqYUPzMJeO+CSNAstEz62GIUEQ39xHEgPmkPzeqJ4CmhJEQA/85E25h +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38dk9nd7bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Get7153372;
        Tue, 11 May 2021 03:25:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 38djf87kx2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFenXjMacWJzp+L+u9PpdfVx1ehO604Nt5lCQNwCt3aT9iNm8comTPHpYGuNsCIirYAEPH4R/zMYhl+5btEJzeYQQSE8bgwc6pFLr1k58mxmX9U0FrID2mZeKMdUD2IXsIN1VINiXduLax/HzkwQ9T/93mLt/fTT7tlWScRNtvEwdnaqKD14b0QJi8GPALhQm3mhy8y36vUbyziXlZWNDkUFaETAm+sdcApSMDnfVnwms8+33LuzOP5o8vFt+R0wadE4KX5ErKNiL8RanRd5NIaIbcSa9QG8XOYwSJjg7cJBQraiboSWChQbur2kJ+J/JU6EmTicoXd/k7mecfQRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sedSW8fG1O2MkxhXHaKxNFLscWtn03+8H9ImL4eHg50=;
 b=YDwhdSSmkEzhA0livPQGwcKCppZKBVawic98zWGtqOKveo3oeXIeosoBEkH70tAl7uBHnoFVcBVc/qgYf1NjfhA+1pBGtepi5Yvy/fQzlmRQDeD9+ebPL9xQ764+L7Ba/UfclV53wIwrYF9k+xhZVZWn9VCrjkr+RhsXUqbDqa9JEMtRBqC8kX7wd38vr8R0RVRZlyyjl2kDi5qAePBt+bsydg7bBIenLxgcoxaBAvnz0Gl3juPSFQcc8Nx/5ZUbKOnqJOz40Pq5XmM1zWR42U8xCkha8RZPzeg4fH2XmC120xttG+IZ/ESvOV2oV6PVhQtfpX55nX/VJI+zWzI5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sedSW8fG1O2MkxhXHaKxNFLscWtn03+8H9ImL4eHg50=;
 b=M6DfSFnzZuoSdjOpxfuXhWmIUe9qrnEaTs4xsyCUNJgv0WUyA6XouKgp9FTboxT4Ox/hP1Wfg3ox7X5LC+1RigaE2N32cwtocnN2oF/vdWB+hhB+wYB1a0U67rP9JBMptXraKAOzboMZKQFoeophUtvsNA6q7L1FzPBorE8Al/0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ching Huang <ching2048@areca.com.tw>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: arcmsr: update driver version to v1.50.00.04-20210414
Date:   Mon, 10 May 2021 23:25:24 -0400
Message-Id: <162070348783.27567.12960546704875624737.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1ca5474a5c6fea59bf13cdf84f7bd17f0b20f562.camel@areca.com.tw>
References: <1ca5474a5c6fea59bf13cdf84f7bd17f0b20f562.camel@areca.com.tw>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28752630-d80a-4d7d-9dff-08d9142c7370
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440887A4DC6FB1880CEC33A38E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iaLWzZOfAAGu8AkuyMjYP9EuTQdWgq35gCCyzaSc0Z4Jb5clegy1k1gIH+ZnfB8TdZuJblkBC+z/xN3QTSK1x5nD3+bVEa1f2h3abVV1fNNsW6UBwI152NlyqAccasJp5SRm75t+uSNnq6I/0NaKNUchQfhh8pxsRMbvUNUuRV0i4EocJxTd8jgxmhJ5WZ/3iuJ1wPUSlBJzRBSgfdD/SQ3odBUTLsXYwJl8r+AIOIXAqThq6D/Ha8MIaBDAUHTSe5oERF6aUOu7PL/NGfYkMpPuihHFC5RFrK6Si/6GLvA3l4WKtO9QBAVuB6lbghd0Sp41ysFObY2GsJsmA11QtV/Qjv1QCw3N4gYqDbcBCWrtRQ0ozSyq3lxKhpIfcPfi3z14USQ87yztrrcEFDuXKf18snCYCb33xrI+KHTkwvjVlQhdkFmHfBsYC3xkIhp0Mo4YjQr/cxdKGVDXegy8QJwMEPsQpkU0fGtayeW0mKo8QAXNfBW5UdFrXsuT8nEvBi4zByuT7Yuox0MlFVUptUYDwed677+jsgaUCOaB+sC/9+aWmlStOOeUzuFXtYdPiOxoRFwux6tDIOvPtxHc391EDlZqSvfBYnLOvOftenYx8wUDCGc+sblCQWfKpkuXP5uxbpeVT8XVK9LbX0td310WH1rwP+5AqzqFVsKSbm+G6rQSNB/LZKbAJJrlBMv0JQ69N75E+BzBqKr1XUT9CbwgROpBAS8wuvsQXPl/+rY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(107886003)(5660300002)(66476007)(16526019)(110136005)(558084003)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(15650500001)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cmZ1bVdFNlB3UW9sWXFNSW9Qd3lleGVkTWVHdWZnZHNETEtGb3BtVXM0SGZZ?=
 =?utf-8?B?Z2JjMVBRQXV6c095K21TTVp2cmpSeFcwN3NkTWZzVVFDbWZvcUMvS2FGQmN0?=
 =?utf-8?B?eGRLWXQ2azRncjZEa21EOGovMHVVWXZIaFpsYk80eVVqK0ZpZEFVNXZuLzUy?=
 =?utf-8?B?Tm1zTGVGZmRKeGVnYzA2YXUrQ01pTEhDQU1oZHk0TFFCYllyUVM0bE1VWFBT?=
 =?utf-8?B?TXpJSDZpaXJXNlkxM1JveVlabVpSTU9kR0dSMHl0TVQ1MDg1aThuUFBJb2FN?=
 =?utf-8?B?Vjdnb3RlYmJORncxSG5ocGFKVndVUy93cjBkMjZyakg1dERGNE5Pd0FkSGR1?=
 =?utf-8?B?bzZLRHdKWGtoek42STFtdGxTNXRiaTNpSkRZN3pBS2pVUENJeGRlZ09RQzc1?=
 =?utf-8?B?cFYxdm5KcWh3MUJQSGdNemVSVE5jRVY0QWQwRGRUK2oxM0o5N3ZiMVZaQktN?=
 =?utf-8?B?ckpPcVg1aVBJNDN4bmRLKzBpbHYxOWlub0xUUERTTnpMdEtxTWNhVzYvUmIx?=
 =?utf-8?B?UjBaN0lJbGQwdlNwV21OOXNYQlZRYXZBRk91TVRXMS9vTzFWVlNWb0JRandq?=
 =?utf-8?B?ckF4dlNjbHNTT241WWdFdHgyMVVDSm9tcExpclRxR3EyQ3FuNDlNMDhZc2xa?=
 =?utf-8?B?VmY1cWV5S0dXeHRzZXpKdmVTVmRJYU5UQ0FvQnd6OGZENjYrenRsUERiZER3?=
 =?utf-8?B?ODJIZjJuMEZ6TnhwZFJlcmFVNnNmWVU1NUxCUlA1ckFxYnFtWVZsemxLSUZq?=
 =?utf-8?B?Z3lTNXhyTElaemhJek0vYlRDdHIzMVlxV2FPZHc2Nkl3RTM4akJwYjNFSXNz?=
 =?utf-8?B?ZXNBQVNRT242cnErbW1pMkw2bGxNVnA0MzJSWjZlVmZNMTExb0srUkN2OVJh?=
 =?utf-8?B?NlJvTW5WNWZ6dW1hYnd3L0l0cldWMThFWlhUN0l3dndNaGRIMWpOWTNELzIv?=
 =?utf-8?B?VkYvcEREb3VpYzQrZ2FhRERiNk1IZWRxVm42Z2FZS2xGTXJ2RHpBMkxSTXNG?=
 =?utf-8?B?UzBDQllYUVl6Q2o3bGQ2dkpjS2JCYkNVTDVCLzlKWmZRY0cyN1kzTFUwYkE0?=
 =?utf-8?B?SFNhT2sxbVQwU1pxWmFTSUtmT0NudGJsK3kxZEVxeXRtbGZxY1ZsM21ra1Yw?=
 =?utf-8?B?bk5pRDJBZ3pqMHRmbFFYZTl6aFpxU2pyZE5TdVFVN0NIdmNmRGdtd1kvaTg1?=
 =?utf-8?B?MVgxalY5cW0wQ2tGYWV3UTlDVVdIU0JIUmFuaTQreTlqaWlJbWJ0NEczY3Zn?=
 =?utf-8?B?amlnTVVDVk5oWC9iVlA2cy91aFZCczlTdmF5YzVFM0Z4bFl1RzZMVUY1Zzc3?=
 =?utf-8?B?SlFoUzdaZXpEQTYreHFjTmp0Y2dlbEQrZ3BNR3JmK003VU1VN29LRTFXb2xO?=
 =?utf-8?B?QSszUytDOVZWTncxelVXb3lKTkZYTW0vaWtFYXV0SnkwZTJrdVd2OEJ6UWF5?=
 =?utf-8?B?M202Z3M4aUJmMGdsTVhUYlg0NzhTU0ZXZEVtNlFCTmdnR0w4QzlsNk1qbCtp?=
 =?utf-8?B?ME1naG1UdWRUVGFNcXJEZFh4ekV4T1lFK0RzRk9mcWdqU3RuWk4xYTRpWjdm?=
 =?utf-8?B?MW8zYjhDaWk5SCs3RWNxNTZLeHlzS0xEVkp5NkNKLzZvbWRrcnF3YXJ1LzVa?=
 =?utf-8?B?emY2UkFpWm1HL3Bsc09XNFovYURlcVcrb0FFd3g0aFRSVmZPTWJkQjhwNHVH?=
 =?utf-8?B?QzR4UTd2SkRZcTQyTW9KR29qZDcySWtUSE5DSG0xa21uK28vVlhwNG9oQkZu?=
 =?utf-8?Q?2SYcqPdw6gmYYpw6N3rlEFJH6hQTSLtDoRBpAdP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28752630-d80a-4d7d-9dff-08d9142c7370
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:39.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJBa6jy9vwtQyeb5Dh8jp/vFSfl3MMnRLp7jSxelL5ywkqdWdRXYSgZ/To1PLGUBVSrD+CX20/gM8QHYX8xlmRcYywcUYiXqQdZ3LH7xkZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-ORIG-GUID: J2gYD_1tqbSEtrzsewzBun0ajH9-jxjS
X-Proofpoint-GUID: J2gYD_1tqbSEtrzsewzBun0ajH9-jxjS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2021 11:58:02 +0800, ching Huang wrote:

> Update driver version to v1.50.00.04-20210414.

Applied to 5.14/scsi-queue, thanks!

[2/2] scsi: arcmsr: update driver version to v1.50.00.04-20210414
      https://git.kernel.org/mkp/scsi/c/fbdfd5163939

-- 
Martin K. Petersen	Oracle Linux Engineering
