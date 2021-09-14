Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7551C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A098E610A6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbhINDpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61084 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239265AbhINDpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:40 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwPV005128;
        Tue, 14 Sep 2021 03:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Se056Mb5/25AsZ+uu9WSixMfmV5rKDNRSgotLIpA95I=;
 b=G1+5IbVXnVDD144v+9WhbsFht+lxErT6iEd54yMelfDh+sII/WTz8XsqwotSpGZ04iUY
 TPgxEY/HOZQWG+F+FJVBl1sYvJKv9weVpA1C6v3YlM4pLr8EV23OIvOlpT59k0WPv5YG
 ytv+YoPlcOTnWKG0sg+eoqVQ+Cfgiwh1dShkZPPdn4yIo5aK9cJShp/3WfFjoarMTVd1
 cPZNa4CP4/I1xkWSJ/HA143duS/DKw5PaNyk64Lvj7rClVnzXnpF7dnoWoxzQVMDedQl
 xfosspyGGI30BnAOQxf2kHel10GrSYqgLVn0wQXuUFLUsZBSAURA6TbUoTyME81X5TRR aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Se056Mb5/25AsZ+uu9WSixMfmV5rKDNRSgotLIpA95I=;
 b=i75oP3OEB6pyIAvi4Gtw+6VEC2RvC/4Bl4VXDNtI8MInUAIBJjjw9VxDMxtKZjT4/9mo
 2RD7QTCaFKBg4heqrdz0OtnjU754+IfR79RoaewI707/4vwzPYGVRP4Wp7AHXJYjyr5S
 n0GnQsXdMlaMnsTQtcsBGKb850CA+HvZ2SwUS5XsFd+4IFiV+ZzUNORy7Yld2lfX5NNR
 iw0PpCZ5CkJHAGYoL8wwwBGN5AWBWwIlsXrduj2lOAORmYpStnGFBK4EJc8F07/lxS3J
 7r9rN242sDmKvhFjIjO7zpSvgKMfzS6BD2CTQsg/X5LcnPROJYs7d5fGBEGVi05xOnwf UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94wuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7at097745;
        Tue, 14 Sep 2021 03:44:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuespt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuGsXrvQkW1Y86be+mJ5DllvRSfnuh/u8FW2lOHwT0zlUFtJ/iAQTQ/U5Ha69VTEaJRGo3FspjksJ6iFxn7CgQ3EFoTqc4IZVfdjRhuGzee7rvpXPizEGEyk4VO+F+udW0inpEM+h0+dbbg5v/hmRAgLwmKH1zMzIfmDBIsP3vcpa56VFM4bPlqS/C7Jvz6fPeUI1Y6vWyo+pbnDznnYThQBguNXPaY7nUVMa3kn3YLQuwXO5L3FsMT7bNLPW3O54HAllbioMXk5bu4zRx5lvJOkRIfRsw7Ur/fl8JQ5nfp5+W6cIAIo54MA8GpBVvj6Se6XoPQAnhvXXNqNukOoqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Se056Mb5/25AsZ+uu9WSixMfmV5rKDNRSgotLIpA95I=;
 b=DhOmYkkcTNK7BNcyANDNfbbGzbA0RhhM0YCqtBHNETwdDG3MYBl2vW4a6PJ3ZKKfKYDf4Pelo9cKPTqIZlpkPae/j/bkFfB5bX6hSaZEM7imiZIBRCCr9i+tPpTqaIDBrMSk54wAFGTAWl0AAkaxZGZM6N76m+ugcuh1o0FNwsWpisVszhhCL97huJqUL4F/2YsVePdahavozukjJ3/WU4fYEH7KKiLnEDwe0Ix73DoLVae8TDySOb+rCVb6AbRqvzePWE3e1lHqMeF8g3djK1U4bMcgVSjzMeVYm1A1ZNmfvDn+lxYvzqw+Qeg5rhUesv4941m80orKCHIjabmBRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se056Mb5/25AsZ+uu9WSixMfmV5rKDNRSgotLIpA95I=;
 b=UtSiXFKZ7X6FuchlogmuAVqIRjuS/mRxWD9t0qFOVOFeiPePZQRQTfrkWxEyYx3t7w7Xk+pwq21q3yMmuOmuTbxkyxdTggnO/Py3zhJXReXF6ssXoOelLVCc075TXJyct0uqCwZF0TqppmDz6qayG+AoKCoIcTmtvGWBKADboF8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.smart@broadcom.com, cgel.zte@gmail.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, dick.kennedy@broadcom.com,
        Zeal Robot <zealci@zte.com.cm>, linux-scsi@vger.kernel.org,
        Chi Minghao <chi.minghao@zte.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove unneeded variable
Date:   Mon, 13 Sep 2021 23:43:43 -0400
Message-Id: <163159094717.20733.3744384611023971235.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831114058.17817-1-lv.ruyi@zte.com.cn>
References: <20210831114058.17817-1-lv.ruyi@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 820722a1-5355-4443-908a-08d97731e66a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45029BDD903B5CF9AE3FCE3F8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zCaze6cIa3iaua6Ii7MAQcAk1z5oien2D7RdUrF4dNvNYudVj/pK4A34NotElcKTf/haPjFB8xkEyftAUOC7zF5s/opZ+OkOf4kGO+VLv0/vmyhSyHSJDhx6EmLZxCmKcsLfE54sHBCpnH5TRYnHaa2TcN9aucZzMCuzOTVg/pQ9tAZ/EvaB2NGac2jnDrHpxwYt9j/jnTylV9TLDgBNzOiO8faPFIwArPYn4lZym6NBNPeWboiiKMMcb3cTtJs2wyp3Ws2WywcWWXwttunhflb3x/asimeB7+stHJMnG3olhaMxr8Xdrpx8euwPA8cCuStUJj3kCg0oLja//GpTBhmu0cEW7hrBCqenB/PhO5juKOETorGbK2L6+sh23pRRdEN9uhQMORDFGHK3Qwbz9av0XYlWxKzcn3EeL8gdnMegs4TQ6mw4OYYUViknduFWFiZqnDZSGI1XcbqFKQq6+0skoGd72N8RamC67I7OHHL08JthHqUL1/cTjtVm9liDGqW1eb0FFPdfbeq9RIDMHvmqegHECNN6hBkenOHGu6ydxbxRms657wA9ydrjngWeOrXwnjtGdzRKOvRusJejQleoQt3RfxrfHZmLo8sGjWJ9D9676izPG+JX3XsbHJMgiL2YUtSKwB6/wSgCECroLKaxlmO+CdvRDShMzsTNr4bD/tmJlYPLKtHNnLzOm1/RCZxdsg014BTt4MHvap92bzpBSXgwx+MYr/ONhLagP42DXD42zOkSgt95e6V2YjFeyFq9nGtlzj1OZMgGOPJiDstnvjKGieA+2MYaX5E8/7o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWwwd093K0pUN2VTdTVjMmFSallQaWlnZ2NjeFI5VUV0aUtMaGRxRS94ZXl5?=
 =?utf-8?B?K2FYTndKYWw2bGtSYlg4eFJxUEdXM2JFTnNUNkZwcDNNczBIYU40bXFaVmVQ?=
 =?utf-8?B?c0MwMFU2dTBLd0xCS1NTWmhjUnl4bGJHRnRYM09KaDYwVG9OeGNweDVmWS9y?=
 =?utf-8?B?NFFtUGFPbmdKVy80NmltU2Zrd1gzSmZQVUNlMThqN3l4N0d3My94d0tqdGlJ?=
 =?utf-8?B?bUc5aGRHdHBuL29NbFdlQWtSMlRnUlpaSkVNeElDdTl1VHVhTUNqMXdzVjFB?=
 =?utf-8?B?aHFnb0prQTVmNG9WU2l6eXFhK0JZMm52bEt3eEIxcjZ5Zi9VWGFCcmJVdWJW?=
 =?utf-8?B?Zk9OMmhleTRhVFFrd3dwQmRwTGxBTmMzVFJpRS9wYnc4T1UwSisvSEVRQ0ls?=
 =?utf-8?B?QzRzWmw3WUI5blp1R0tvWitMTUNpbHp0RUlPYlRYVmI5MXhpWFYxcms2TW1G?=
 =?utf-8?B?ekRWTkU4UTNqYVZGSmY2T2VXcjlVNFZZZitRSW9jZlJOc1NvdDUvdXBuQmd2?=
 =?utf-8?B?eDRGTkpKR0xSM1FYQTFVV0FFSis2YkJCWUYzQVhzeDJLb25UNUJkYXAzdGxO?=
 =?utf-8?B?UTRjOWoyUElXT1ZKTG9TaXdqVFowYzFXcjQvSHJpaU5TU3VDS2xQbjRvWndY?=
 =?utf-8?B?YzNsS1BLTnduQStMZDRQTjc5d21yRys4VDJFdzBvbDhUZVpWZVJLeTY0ZFdr?=
 =?utf-8?B?R2htZDdTNkE0UHNaZjJxNnVpcG56Rkx0M2h1ZUs1VXdYMGFaOVF0RVdINVFQ?=
 =?utf-8?B?TkdVM0x3UnNHcGVFaktnYXZsRXk5SmRtRlF3bmlnSXIzaW9IOGUyeVlYNTc1?=
 =?utf-8?B?UGJhc3dmNzd3M1FncENuWnVPUHRmWUF5K2RXbGJLLzdHc05CQ2RnSXRaZE9w?=
 =?utf-8?B?ZlpKU0owaEVzanZmQmVpUUJ6VTZMU2ZTQ2FtTHNHYjlSU2hKZVhHaVFwTDEy?=
 =?utf-8?B?K1BqZFFqRC9JZEFua1JHMTQ4aldDSUNNeEhzOXIzbnY0TmhES3dCMHlERWcv?=
 =?utf-8?B?UEVIMlZoVDBGZDc0c3ovT095TzFRbnBNRmQ1em1RVklocXNaTElJSFJPaGpa?=
 =?utf-8?B?aXBiditUSFYreDRYNVhHS3VLWFdkQzBqdnBPcHVmZk1WL2ljM3RuNkcrMG9J?=
 =?utf-8?B?R3F4OGgrcVczUEZaeXBOYmtsOVp0dzU5SXFZUjZablhYd2Q3OWg4MUo0MU04?=
 =?utf-8?B?ZHpXQ3Z1WFRuOHUxY1l6T0VoYzdaajhLdU5HaHNvRnZDRFdUdEdVSTRQaFlW?=
 =?utf-8?B?SmdzaWwwZ09YRXA3dXAzdXd3SElLNHk4elFOWG9pSlNFZS9oTDBVTjdrbkpm?=
 =?utf-8?B?dVhSVTk2dWtEazdNM09NNWlObFdWLzBZekVGSzBPTTNlTm0yTjhscDExUlps?=
 =?utf-8?B?cWZIcEVhWW1JKzZKQXROYzZzS0dQOThnR1c2eEJyTzZrWEkyY0RMT1hONHR3?=
 =?utf-8?B?cUhES3pDYXlKY09yNGd1SHRTcTRXRDZNT2pVTjdBdWZlaU5ZeDNETDRScmNn?=
 =?utf-8?B?amtKR1JmaFZmOFJnYzc5dFVBQ3R1SkVKa3g1SEtWQUhMbGxHQUNEY1VFdjNt?=
 =?utf-8?B?MnlmMHNYZWdtUXN4d2JlNGJDNzlVTGVtMDJzR25WR2FxSTF0djdLY3ZjTWlD?=
 =?utf-8?B?RlNjdldieTQ0ZVc5ZXlyaThJVG9ZWlc1UlBZb0VqWWdBNUhMeC9LcUtjQWxa?=
 =?utf-8?B?UkwxVFhZVEFXcDY2dE5XZnV0U0pKbWgyUnhSME5Hck9iRWhwTWF6czE1QnYz?=
 =?utf-8?Q?ydpjjMJg3QaB/8wtZGZ1X76nN8vGNgmDM+So8IG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820722a1-5355-4443-908a-08d97731e66a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:05.4324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYKK/IiT+o416+BJS0qtKSk4b2ywanZqpuuAF5dxfoEXhoaQ7dNZ5nv+PGxGLnVctCsFkB0WdChCLAkOXnmN0Iyamfijvr/axgqE0wAGJng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=907 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: Vi6zg_wMXhlpx2geYFTIAQ95wuPqvEVR
X-Proofpoint-ORIG-GUID: Vi6zg_wMXhlpx2geYFTIAQ95wuPqvEVR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 31 Aug 2021 04:40:58 -0700, cgel.zte@gmail.com wrote:

> From: Chi Minghao <chi.minghao@zte.com.cn>
> 
> Fix the following coccicheck REVIEW:
> ./drivers/scsi/lpfc/lpfc_scsi.c:1498:9-12 REVIEW Unneeded variable
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: lpfc: remove unneeded variable
      https://git.kernel.org/mkp/scsi/c/5d1e15108b8d

-- 
Martin K. Petersen	Oracle Linux Engineering
