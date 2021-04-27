Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C18AC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18251613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhD0DIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:08:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0DIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 23:08:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R37ZYv088416;
        Tue, 27 Apr 2021 03:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=ksrWjuGbucDx5jMf2z1xwGhPDUM9xfFJV8LSPoQuk01n3klvLrE7BPP3+Rveu85fb0Ys
 MljFHjKq8vgds/WXKp9Qo5HhiJTQ5gWguiSXgtbZe43+3L9FOQ1nXr//KdmYTJh+uMTe
 LfORueNe2+HdNyXaeLDR0f/6AvjGZWsbrv08iPoi1bV2glMO4RR3RQyUzdyXIWMZoGYc
 3UpZ2HVWKZL8j32uAr5eh0b2+CtyPHuB/E+OaU4bnBO3AAICXEbLwukRtYqtlfeKqzwy
 hFuFpYf5Y8H6o8ZpnlYIPS2SoOnwAqnhxmg4nitD8tqcZRft0/dDKDz6rqlZNQNVx4zy rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 385ahbm07y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R35hYE147009;
        Tue, 27 Apr 2021 03:07:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 384b55r9nh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXiWDG9b9uL+FVqaGB6vhx2zCbcOx8974Wr1dyEqc/Ljv8n7EIbiOtsBgNiP7QKies5yvFcX+Okur+HjEnEeSq9wjjQrPEtoLFkd3wDYC/k0k/Xx6kP2E53c4vbU7aMeIJcOGhyuDCWRDLFrB48Vb35D2PoN4sPauyT7JnrwlsLkMltYw8k23YO6gp3+GP/a4ls/F1lhcqmZJfmyLjoqP7mM/6a2wTO3hVa0GZL5lVuspaP6tHA+MXfmIZstUWwTGyAUCSo1jl+H4AsRbzNQqLUly9G6KAU8FEM0HA14+HvfmqaAxPViWQhN/uWePlfBZiN+vKSwFxex4Ck9NBkTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=cWa6pbmWS55jvHTwe+EmKLJRja9r+aP/B9Bs1iv5Masa+o/YmouowbANCr+msGw60YU9Mgi0e7LmDpJvds0kfv7tV9I8DSlz1oQQiv2ueDbyxnaAsoi0Od0d1PxWetsRemrASTcBArKa44DVAOLngyY15YxtH0Qc8PP4ZjwqMfSvQPmMOBYjsZVFwx3m0shuKBJdHd673BwlMsq7/DQQLHRYXpgvVAnBH6no4/W6+8odfR3pGJ9Zs5hLG76wFYKosIjhC41gZ3dfN/TTTX3196jhZLVhmgz+oEdlHTYhgUC+itnpnv5eoLOcTUyv5A+2VS9xylxg/byIMg7y7+lomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=ew+8mvfye4h55ZoeZV86+M4RUmo2TWPoWK3StgMge+CZ6h+u5t/SM551Ib4Z/D5k/l/ARRQc59NsdAQWiCvhG0waPB+w/wrsGVwpKxf0aVJNz6XmA/zerQNjBOR3cEmQhh1aXCJA0+AMmhhC/urg8kKjJamUNp3tluMuVoGxTlI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 03:07:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 03:07:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH][REPOST] lpfc: Fix bad memory access during VPD DUMP mailbox command
Date:   Mon, 26 Apr 2021 23:07:23 -0400
Message-Id: <161949269498.28290.13683506743873378262.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421234511.102206-1-jsmart2021@gmail.com>
References: <20210421234511.102206-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:806:120::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0043.namprd04.prod.outlook.com (2603:10b6:806:120::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 03:07:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0abbe77b-bc29-45a6-f093-08d90929975e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45015643DBC058E0F75E0A128E419@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8h7HLYOgc7mUfMO+2pdtIbP8RzZNri99Ew946VCasrmQQYtjM35/qgQ0KpnEDs4zCAdDg7EUmZrM1myZZ9z2etuZeSjqb08cs7sJNV5QWWz7m7EjT183ekRb+32etMRmpdCh0ea0vmTrpRexewEIxxE0rVai4gzBbDl3e/yKmJQIL4yfk4gPwAnPtb99eyIYTezU9v+LBWCnLxU8OT12U0Imsv3pGsHLgvJCUNHK8TRJKMblM/49wVOWw1iwh5RJGKz0ln7zYEjNnxh6tDarCo6LeoIAJjgTVGBLHNeFoxbf5IWuhZqYFMX486ff3wOJOp9odzs6ERElYu0WBzUsZA8LMc6rILCzBwA37Lp69LeO0azAALxLIUYFKh7n+/Aja0XOjzh1gPPJgcs0Xsq95gLh1oF+Uu84/rXS+ya9YMOoO2gBuMpf8nPu2cha1/TFU7E1XsPc7QvktEdu3BR/hxKS/U9KKSfFldLcpYowPe7up6Emf8qJ/BoJmV/Sbp75zyDN6slQPA8RAV6SQtTqxDQ6PLDJ9KrAAb5VVLk8O0CT6kkKY65XJR+uXkBsx5Vw6A2ivfXWs3HgOYBIQhZt2CUaoS0LhvGk9U6Bw16+jmhmyp9zgqMbYKJWpoc49iPQ5FVR0QDPBeO8xNnF2lAlNdBz16BXonK7D7Xewy9nvyfJoDBe5EWFoqiEhZ70LMFjhJxz88NOyPyVKft7MUvz54kVWGbrPtOCqNXrvRTmI/xZ54mvp0MsQhUQZDLc4Ob5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(103116003)(36756003)(6666004)(6486002)(26005)(4326008)(966005)(6916009)(478600001)(15650500001)(54906003)(956004)(4744005)(186003)(83380400001)(16526019)(66946007)(7696005)(86362001)(66556008)(8676002)(52116002)(66476007)(38100700002)(38350700002)(316002)(8936002)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bTFnQ0VUM0dwS3FWaHArdXBkMEF4L0JrMDcyUWQrS0ZJUUFNWXFMMk16ZnZv?=
 =?utf-8?B?RTlvaDVjbWVwdkp1dlVUZ0l5c01YY0Jqbk0vOGhvcktOZ2phYXRJN3k4M1ZP?=
 =?utf-8?B?VExiK0tkRmNYNWgxUHhRdisxZlFkZmxpZXM4UndGanNiZE9FY0RodHZ5SzBr?=
 =?utf-8?B?UDZDVTVMMElJc0RMRFllMWV0RFJpYmdLeStEdnhRQTVPZzhLcWpYK3FkSmZl?=
 =?utf-8?B?bFUyQ0hTZmZibFd3M3BUQms0T2s1dnVnWm1kSjhTamIwZ1AxK0g3bzN0RE9l?=
 =?utf-8?B?TStrRnUvY1JhUlBxMWh1TjVkOUViZEJVUUQ1Nk8xNXBmSVUwVitqSHpVYmpy?=
 =?utf-8?B?eFV4S042OTdBN3laNjdIc1FOTDVVbkI2YXBaMktPajVqRlpTMkdKOVJRS3hL?=
 =?utf-8?B?K0NSbHNoZk9HY2podUIxUVRoYi80NXRBQndkY1c3MzM0VVQyUTFCVE1NOWdv?=
 =?utf-8?B?UjNySmp1N3k5d21VS282Q2hvazQ1YUZWaVkvRytYKzBSYXZKNjRsSGIvVGlv?=
 =?utf-8?B?bzdKUEZwdTd4VC9SYWgrQjdPSXBsTEUzNjFtQnNVSkJQVitHNVVmK2pKVzNK?=
 =?utf-8?B?N1Nmcjh3ZHFDQ1VrRXUxWHJjQ3hBSDhFdlFxOG1RbGs0NmVhV1YzN3JNVGU1?=
 =?utf-8?B?NWxJMVo5SkdTbVlHS3psdnRQZnplMW5IZ1Z0aHUvYWY2NkNDV3RjTXdweDh6?=
 =?utf-8?B?MllYQTFieHZhOGlobjRTcW9URkdZZjFhdVltbGgvTG1HdnNrSmM1ZG95R05r?=
 =?utf-8?B?akYrZ1hCalp1Y2lOZmtZSG5PUU5kaFc3dHZmMjNobjJUNnhrVW5lSVVTVnl4?=
 =?utf-8?B?RFFSa3NLRFBYZlZvV0ZEckNMc0pSNXJIb011b0dwMjFJdEEyOUJwUk8vNG1u?=
 =?utf-8?B?K2E4ZGZwTmUrNjBrZ3gzbU9tVHYwbmtpOVdDMzBkZWYzYWxsdmI1WnU1OG91?=
 =?utf-8?B?cng3MUpvaUM0Uy82SVVPWlN5eEdWTjFzTkpIUCtNYVBnNVRNdlRNc1hpUVZx?=
 =?utf-8?B?Y3JyOTQ0bzZTcmg4a0NCTzNHdkdUMkljTVYxdlpGb3FzS0UxeUc0ejgvS1M5?=
 =?utf-8?B?OE1ObzhRMXZyd2lyd09meWp1S2F6enpzbjVZemZZU2xqOXNDT2hzQUNXV0xi?=
 =?utf-8?B?ekRFUEFJRTRvelV4OENpTnFNYTFUZmtVZ0FEaWFVcnJ4bW5oVDJLMWMvbXJN?=
 =?utf-8?B?algvYjI3Q3NFNnNVYmFQV0JqQlM4TnBBWUdEbkNYSG9NYUxkMllsYjBySUFx?=
 =?utf-8?B?V2xhUXh0TlZiV2VnbWhkWTJYVVZocEhIdTNQSHA3NHZPVDlCQ3lFOXZ4ekJG?=
 =?utf-8?B?clRDM3JkNTVmTnlZTzRVV3UwYWdrendSa1p0N2hvN0RmV0h1UE4rU283YlJW?=
 =?utf-8?B?NGR1R3N2WmhVbE9BVFkvQXdCdk1aalRXNDhmV0dzaFZwZzBpWWYwUU14QzdI?=
 =?utf-8?B?TnI1bEpCOUJrZUFpUGhsbGVKZFZETmIycnNPREpEWTlWcHROWWFkR1RZTnRP?=
 =?utf-8?B?cFVZcGNJb1Rzckw5SDZNa1N0bnJWOHFMdjFHcTRLUmoxa0V5VzlJUmdXeHhL?=
 =?utf-8?B?ak5QUHI0TVphMmJBMXY4bTlpcjgwaWgwN0NzSlVheHd2OFBIK0RIVGZROVVC?=
 =?utf-8?B?QzEvdXM0a2FzWVF2Q3YwM3FoamVDY1VtOTJrUi94YkFZRGwxQnRUWnJxR09o?=
 =?utf-8?B?M0gwUUxFQ2dNWk5qTXFXQWN0RzJHOGlqN2M0NVUrRk9hb3JTQXNSSWt3cXBK?=
 =?utf-8?Q?lsmYbwikWH8tjBg2oxTSsOzIicw8oaoDxu9MgGW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abbe77b-bc29-45a6-f093-08d90929975e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 03:07:28.9298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSFyfLA4MoAa4ya5f0Wt9cc+q9O4PG3OEsojgpKiXjTkgjK5zDtlzIKr5shQZK3R2SmUHTs9Z2aNNf8BCovoKZYNHsHmVn4bjEihWWT2LM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270020
X-Proofpoint-GUID: 2k5tMSo8qx9sdFIUNFih2T-YIxpDT-rv
X-Proofpoint-ORIG-GUID: 2k5tMSo8qx9sdFIUNFih2T-YIxpDT-rv
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021 16:45:11 -0700, James Smart wrote:

> The dump command for reading a region passes a requested read length
> specified in words (4byte units). The response overwrites the same
> field with the actual number of bytes read.
> 
> The mailbox handler for DUMP which reads VPD data (region 23) is
> treating the response field as if it were still a word_cnt, thus
> multiplying it by 4 to set the read's "length". Given the read value
> was calculated based on the size of the read buffer, the longer
> response length runs off the end of the buffer.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] lpfc: Fix bad memory access during VPD DUMP mailbox command
      https://git.kernel.org/mkp/scsi/c/e4ec10228fdf

-- 
Martin K. Petersen	Oracle Linux Engineering
