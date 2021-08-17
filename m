Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE3FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D7060F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhHQDSZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42988 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233585AbhHQDSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CXPc025816;
        Tue, 17 Aug 2021 03:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=w944eToDjexviMBvqLbApeAfRi9VuwR2H1iocViVVco=;
 b=dSHYWr3jSZ1IgkBHXUz45IP5MRsfEYAi12v8BEuBnr1L0YfDjiz9TAiEnItczm3LDUyc
 IG5E+RNCnDmHl4sC1h8kQY+f+ExcZgQzuuKK/BBJ2J9vPBKBaFIxe17UppyT8dME8qVx
 Rge2ZX4jDJXZmxUwPINc/FpcMY+F/3JB/anJYaB5EvLfwEdfK98nXTdmfL44LRXf2ny6
 8U81MQB3Ay13ti6Wd5crMc2Tnr0ibxbTir8ySMf/XdFa9j+yPCJDarXbF8Khstq+njHn
 z/AQ4cKcSH6elUuV2kq8dVNLcKEqwPyswPi1Gp3lbnsRIWvHNQY6e7jtiCCUuYTLmsYK mA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=w944eToDjexviMBvqLbApeAfRi9VuwR2H1iocViVVco=;
 b=dzPwf+RCVl8bMq7wqO7KGtW0Rd4oBAO0g+0SW42PW6gjslXfVmRMf1L+ZMZ9WhmPoDMs
 Gp90Lre4poPML4xsttviCN21HHrz37qBCckLX4lz7xugssEY+Y6lU+827ZPMaaAAeLAS
 9wwd3Sc4P1/n1gyqzMv/Ahigc7cYQ+rknDSEVbZh9F+rVtOFxy0t2Qup4yxMazvgn0N0
 pc3+Ts+nw8UYztF1wsZnar0hCMLaJOXRkJ2FlWvOoIm56RCbR9dogJIqz5sLak8c4HVB
 pgBhePeg/NtGnZ6kp7BdoJ1doZHMiS3FHbKikeWppfIoVP0GdpVpPcD0Vhu1Moz136iQ hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmban64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3Axqa038849;
        Tue, 17 Aug 2021 03:17:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3aeqktadm0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7aj5nokegt46V2e8bEeGcNawJVvM3a5xP7hwdiE+WCva9r5OWYltqmC502iP1qCLSSREYGZFQeqj0VvqgatQQmHHnykaxFQllQ2I685IUJu/kaphPR/XjZBr7sgsittGFyVraC6blg5alC0jwrIxTmrDMR332j+oRwVTwSsPRHiYX+MXUAEX3CBdAwSZufx6naKGpbW3FeFmVCViEIE1dfcvLL0EbnA1TiKkQaRxqWYFC2eG8ST6znEGGxlZEXh4Sp4x9u8Pt1H+DXR3cI9B8kaHMYpg4GqytKTRq4/AH2B6X0usUiEJ6pebkct5SFSewHecF0Tnc3TRGUkL39TfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w944eToDjexviMBvqLbApeAfRi9VuwR2H1iocViVVco=;
 b=fpekc3m/BCyamSCRxoY9iuahi0bruaLa++rHzJamPqnY0TtsqJa6CK1efkwZ17HcW4SX0/IeBfYidWuQRazRHiLUstkSFLjudrdh+ARgA1lxPl8tH65NPyK4XazSjJTjIweF0+ennkw+LJULilKgOnZ2BZbBaaHse7Z5g70u61TslsZDxFr8+hMpbO0IiVa5KlUSQAN200wpXQGR4MnCfpz3XmlqJ/DTeIM8BcpyzL+01eRn8zSX+5KgfEM8IRcycHSuLoqWPYfrntt+UMzxb2tP/rfqWEWdYfoKOwcwnrT493Qw0USzMUa7SUW7jFC6OiNiLKYqi+SWuHiEOAjlPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w944eToDjexviMBvqLbApeAfRi9VuwR2H1iocViVVco=;
 b=KcVe9EH3d/IOLIyMkhWnc3XU79Vl4UV5MikWoavL85wDqpuDnlBB1LrYYHkt7U84zaP3xyfWE+pdsfN9ah4VwFxyJ++dLBjQZYyyOZ1DOxQu2xwUHB8zgBYi0g4uCKMSdrDCJ0BGNMTg8m+RvQnFYJ3TDqCeOO3no7MhxRexZSE=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/52] Remove the request pointer from struct scsi_cmnd
Date:   Mon, 16 Aug 2021 23:17:33 -0400
Message-Id: <162916990044.4875.13864301735862541745.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa47c908-859f-4c2f-6a80-08d9612d9671
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45662D103F9404BFD2CA1DB48EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShPmxLHaUHQp7wdfOW1KmbJ56+1BVW8QjdAJDtEwL56JUxNiezTbnHFtYcXKQ++ZB4NrdEXZIeVGHpUqJURYLmjb4ldtgHPtim65itS+3zzV74uHDAeGq9hf7/jquClDnDsS7rV/znc/p7KtKDbMz8kE76nFwZ443Ru0zuhwdZpLRLaUnLQRWk8ui5A5d5n5WCvlaRAVthe0EWUxNXgRLzKl6RvjYKV0226j+Phg7Dl9rg/3qM0bLUG9zibRASuakFj/4VhhgIfGl7T1JHvcuD4U40B4NweN1KbF/w8UAT4lCqcf8lWNNVvyASQa3V4YZ5lszepvA+4/15gNbHYt8pwUJBIov0tDnnrxFT6NHtwItjLC/Pht3nWIdvU1rLCsBzxavYWjM6EyKSvTBX9i0GOyEKSaQNEAs5ETGGahC36yD9t8JnQUPRmKqKdIDOWKq1k4OXTppUQi/3z81U5W8Y0lqUtG98TupJQGBSNRG7YLqdDKVNLD3jxlOvx08RlkWO95yGcpOeeeRteu0274vfMHYVJFCz362jB3PmxZSc0fNHoDKwLEfXbhe70IQBmR/OKoZ8jJRTxFQ4UIwDg+X0k9OuqDfwV+wFCS9Qz6lMwvWUSJ8HTlogSwwQkZwLBa9Y7hAMbmfwO6ouq+qS5OQmln+8Vs8GWa0SmG1gKQlxI5kjrd09BkhDUb4ZSW0j0E+V7NZ2GkLZML0ipRhpyUbdickpqVNL4jq7ekjSZWb1fu8d7QWtRuBppDxfPXWk484p2+4Hhk21FsO+dECHzPpPy8ovC7Wq0eMUTHus4XWoynoDGYWbaxzmX+I1dm5Rxj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(6916009)(66946007)(6666004)(5660300002)(2906002)(83380400001)(86362001)(186003)(38350700002)(8676002)(26005)(36756003)(2616005)(316002)(956004)(38100700002)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3YrVnY2bVZLZVZvc1MyMjNBWityRDhnU1dqcERsU0MvMUFOaUhERjJjeHFX?=
 =?utf-8?B?QjYrR0VTaloweHlsbHpSSEJHbGUrekZReitSYjlRUWdZODdrcVRJQ0gycWlX?=
 =?utf-8?B?ZVVNZlFGY3g0cFljUXh0Wm81dU5KTDZnTkFJTlVUOC94Q0dmZnI3NFR2TDJm?=
 =?utf-8?B?YjRMZ1JvUms1U0llRWlxa2M4N3F4ajJkKy9OTFg0Zit0YXg2dDIveTdvbnJi?=
 =?utf-8?B?QmFQZURBZDN2dk1sbkJlcGJtbmpFaU5XaGVlWFptM2FpVGRuY2JEVkp4WWZo?=
 =?utf-8?B?ZzJmUzV6enRGM1NYZEJqNkM0Umt2SUZ3M2grMjFhcjBPT2J2c25wYUpzd0kx?=
 =?utf-8?B?RXNjYlJZYjhEemxpSExiN29GekRRdEhVYzZPaVdKb1ZOTi9jZ3MrdVpQMHBh?=
 =?utf-8?B?ZVFqU0N1RXo3eWNWY2ZsR2NISStPakNDa2xwN1NseG9iV2xEbHBRblh1d0ZL?=
 =?utf-8?B?dzQ2NGF2dGxmUThqOHBDRmo3bENzTWxyQnNsODZTR2hSUkdGT2xQcnVDVXdO?=
 =?utf-8?B?VXMxeldKUEI3ckRQMFFHNWpKZWdLUE44QlR0N2tNbnZXYW5zQzZsZlh3em91?=
 =?utf-8?B?TzJXekN0MnoyS24zT3UzbVluOW55dG85b0tCMEhyNjhqTkJ2UHhTMUEvYm56?=
 =?utf-8?B?d0M4REZOTTB3UC9FZTRWYTZTbzRTUjc0VlFrZWJlWUt0OFAxSGZFeFIrMlBw?=
 =?utf-8?B?RVU3Qk5RODB5c28zN1JXdjhTTHBIaTF4aCtOM3IwRHFMME9JRnBsdDI5K3N3?=
 =?utf-8?B?STBVQ2ZzS0pmTmZEOEM1ODhCQXJBTEtPYmc1YWV3YitkRWNMcDU3LzU5TmYx?=
 =?utf-8?B?ajFjOHdDTHNVNFBzQ3RlYzJnWWt1c25KZGVIWld6aUwvaDQ3bmV3WXB5dHpn?=
 =?utf-8?B?SVcwWUozdGp1MjhQVEplREw1RFQ4M2VDL1lFcE5hZko0dldkY1NyK0pyQ3gy?=
 =?utf-8?B?THNOUWtsTUxMSFExVjZGSWdINkpoVDF6ajF1SzdnMFh2cEI3aWU0ZG91Uy9u?=
 =?utf-8?B?d1RFdTYweXdwL2hPcjVFOEZOZGpGVnMwS2ZhTE1HOGtOdU1EWU0xM2x3VHdp?=
 =?utf-8?B?K1gwbHlnc1E1blEwdi9IeGNlVU9pNlhOSGpQazZ6bS81S3U0bUdFN0ZJZ0p3?=
 =?utf-8?B?WG96UmVNNFhJQlFRVlNPbkg3VGlhQWhtQmtsQlZubmZXdFRHcFV3ZjdkSDU5?=
 =?utf-8?B?VFc5SEQ2ZHF5WW53Y1l4ZW4zazVpc0ZFNkRCZ0diNUtjR0o0WWxBcVNvOUNn?=
 =?utf-8?B?cXI5NnNDLzZJcmNvbUdla09rL3pVU2Z2aVFTZmVRd1JUdExvTjBFQjNTK0E0?=
 =?utf-8?B?UHpNSVF2WjZjd2RRd0Z4K2t2NWcrOHFnb0pEMTdBUFJKR0ZXZTBXLzZMOEhZ?=
 =?utf-8?B?R0hMZ3I1UU8zRDd0ckRnaEJYa3c3YVBFZXp3UmwzR3czcWN4cEQ0UWZ5VERq?=
 =?utf-8?B?bDNrSWdBdHlaVXdtTVFhb3JVY3dPNkZSZWMzeUkxRjdEbC8yalk3UFFpNWdR?=
 =?utf-8?B?cXdmeXFsdkhlbmlxeHcyQ1dPb2hSVGhLc291bGpZVUUya0ZpTUFBLzdvR1Np?=
 =?utf-8?B?S2h5RnRoSG9BSlRTbDY5NE1iWDJGaE5vbXN0YjVvK1orVUFUZUROS1dKWXRr?=
 =?utf-8?B?REFuTFZyYlJkaVlYTloyTWs4ZEoweWtadm1ja2hQUWJ0L2dibFBmSURRd1dw?=
 =?utf-8?B?K2ZLVW9wMTh1eS9VOTNCVHBaTGQ1cGlkM2kwS2pnczlwdCt5NHUxSTlTaEoy?=
 =?utf-8?Q?jNAhLDvpr0QocIv6YQn3WUem960Q0UbMvQXJPUk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa47c908-859f-4c2f-6a80-08d9612d9671
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:47.6965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIZjGzRRRpyENLXW+b8+2S28GdR/llzhNwZgbBVr00V6oMl2U+9WwAFekT14oByjXwEa0UfPZABX583avqnf3pui/5nSQbmdwRF3MhN90Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: b38MkK7HMxVtnT6PYa8oY7aYE8SeD7C0
X-Proofpoint-GUID: b38MkK7HMxVtnT6PYa8oY7aYE8SeD7C0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2021 16:03:03 -0700, Bart Van Assche wrote:

> This patch series implements the following two changes for all SCSI drivers:
> - Use blk_mq_rq_from_pdu() instead of the request member of struct scsi_cmnd
>   since adding an offset to a pointer is faster than pointer indirection.
> - Remove the request pointer from struct scsi_cmnd.
> 
> Please consider this patch series for kernel v5.14.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/52] core: Introduce the scsi_cmd_to_rq() function
        https://git.kernel.org/mkp/scsi/c/51f3a4788928
[02/52] core: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/aa8e25e5006a
[03/52] sd: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/5999ccff0fd6
[04/52] sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/c4deb5b5ddd4
[05/52] scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/3b4720fc8d1c
[06/52] scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/eb43d41de291
[07/52] ata: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/c8329cd55bf4
[08/52] RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/99247108c0f2
[09/52] RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/9c5274eec75b
[10/52] zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/d78f31ce7ef9
[11/52] 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/cd4b46cdb491
[12/52] NCR5380: Use sc_data_direction instead of rq_data_dir()
        https://git.kernel.org/mkp/scsi/c/2e4b231ac125
[13/52] aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/8779b4bdbc12
[14/52] advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/40e16ce7b6fa
[15/52] aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/11bf4ec58073
[16/52] bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/4bfb9809b877
[17/52] csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/c14f1fee18f0
[18/52] cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/d3e16aecea2b
[19/52] dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/3ada9c791b1d
[20/52] fnic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/e1c9f0cfac4f
[21/52] hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/1effbface967
[22/52] hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/84090d42c437
[23/52] ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/e9ddad785ec2
[24/52] ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/0cd75102014b
[25/52] ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/240ec1197786
[26/52] libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/cad1a780e065
[27/52] lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/4221c8a4bdd3
[28/52] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/4bccecf1c9a9
[29/52] mpi3mr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/69868c3b6939
[30/52] mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/24b3c922bc83
[31/52] mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/ce425dd7dbc9
[32/52] myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/2fd8f23aae36
[33/52] myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/43b2d1b14ed0
[34/52] ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/0f8f3ea84a89
[35/52] qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/d995da612286
[36/52] qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/44656cfb0102
[37/52] qla1280: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/3f5e62c5e074
[38/52] qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/c7d6b2c2cd56
[39/52] qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/924b3d7a3a74
[40/52] qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/ba4baf0951bb
[41/52] scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/a6e76e6f2c0e
[42/52] smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/12db0f9347ad
[43/52] snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/ec808ef9b838
[44/52] stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/bbfa8d7d1283
[45/52] sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/6c5d5422c533
[46/52] sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/77ff7756c73e
[47/52] ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/3f2c1002e0fc
[48/52] virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/7cc4554ef2c2
[49/52] xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/80ca10b6052d
[50/52] tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/cb22f89e7a12
[51/52] usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
        https://git.kernel.org/mkp/scsi/c/9c4a6d528185
[52/52] core: Remove the request member from struct scsi_cmnd
        https://git.kernel.org/mkp/scsi/c/2266a2def97c

-- 
Martin K. Petersen	Oracle Linux Engineering
