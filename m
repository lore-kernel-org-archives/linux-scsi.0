Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF9EC05027
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbjA2XpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbjA2XpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A566E199EB;
        Sun, 29 Jan 2023 15:45:20 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMkTqB025111;
        Sun, 29 Jan 2023 23:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=FjjQ+cE0U4bMiqsreXfmdkYYZ/11SL9odquxoIlzM6g=;
 b=yODi8n3WIlLWVXvjkKmg5jjxgL8Pb6N4ZhPzIwygkHtoPGfdtu/3ZyFBJXLANKpl6Sf+
 xHpwPIQmldVdEQ6CEuIAFROUnAoyl3l12cgSO/+4TXmcbtdfvubNFz9o90l/yyZ5DrEF
 HldqBeRqZ8KLRf8fXIkj2zZVdXrS4cEpMXxd1+YYkTs68wSjEVH9KbkUkPnS9eAqtuon
 RjiDyQvFOTd6saklEAiJmDMCJZqX9Yh2Ko0GoUjJCVpZR5D4EjJ7Lo49FEj7G5/y/oJg
 s//QZ7z7aEwJbcEqpdT1yA7YMWKT9ReZ3mvFBK8yJjCWIgAHgF4+dACARcPnIGidM2kw DQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvr8hry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJMDrS019007;
        Sun, 29 Jan 2023 23:45:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMPJlJqtnxA09k+1ZPTis7Y/87DUwrCc6EQjaQZiYx7WjcLL+o8nV6a3E+F+eeK4/bXSYgfb02Ua+OMrXac2HW2C7+PE2UFgLD7TuRPn7EM0a3SVhhe381l4WwTxJZaIQzhD2/eaj+JXpI7tNs927zp2zg2FxI1Tb8GQ27fx/LNxdofpEJd6R1GkXQsZTxd8trKY4VziThX5r2pmaVueqVfjJsW10zMbWogEnvBfXnS7FTWO/yLOqzMrmn4qp6x9hMt9XKLUyOYfrpCHktjYaGSe8ceVTYCVffyI/1q1pV/OKsB1zoSs3qTXT6/bko/kIbQbhVwGKpBstdtQ/0GV3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjjQ+cE0U4bMiqsreXfmdkYYZ/11SL9odquxoIlzM6g=;
 b=cNM2oI+SZf4vUqVW5xjUM4+CoIpMh+dHAFfG54tO5UMGkJ1PHP021wrjDGHfY7pYPqH2Ki0E5QrrvBUaVHk+Py3tLpjUmcCmYv9q2fwVG5HqLHre4PX2s38Sp389lm+mGosnA0rJP+8SQoiURlQRfTVTGVVXal8R3M4SMfD3/k8DP6KBOA1scwlMWXeGWgMx4zJ97F5pt1cjLCNbw8CaHP/fuh2EZ9qaBsHBYp7XF9iP18cI4E6WEpvul2jqWekfypjg+w12rTB/MRlpWGeeDO7mbd9PkLsn8KFMg/+FIAsVwVfQVpyd4LZavWeN5JpdFmnYpEoMj0i2LrIloyv9nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjjQ+cE0U4bMiqsreXfmdkYYZ/11SL9odquxoIlzM6g=;
 b=wkJGanO1qnpe1zX2BALnBGdW+h1LQXB3su2R9BgI/Iipt00SvFlZKfaepMZ9VnxzOh9VlSaajBkNNwV3xiF488mnJNdkx2Z0ZQo1BbDtdXL3VHBn2u9XOKYJOjS3ITGatXW6zSe42dyeh6tCxwK3GpInxic3c5g0auBhhy4E1MM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 08/14] scsi: target: Drop t_state_lock use in compare_and_write_post
Date:   Sun, 29 Jan 2023 17:44:35 -0600
Message-Id: <20230129234441.116310-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 039a22d7-1c8a-4d10-d8cb-08db0252d9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8oJede+R6N+pcKJjcy1+zTLvitMYYF3f8gJQlhz4tck0aak6woUeQF40iOqkH67vgz9FJXmJFF8xZzCEZksQSEDl7uuipuc4YXgbbwZtm+KMbKKfIwFYM7eMc/DyNW6hJbVKef0d4STlwAN9s/JVKXKGiz0B4Zd6+tGWbNSsaHCxSJopvHyrzcsZhNgm52R96DsWwjdGo/6CNIlPTPFWjsgdzk9nP3QLn1XpxKhIWywYoXXQ3H4/z8YiS4bcVlsKPpFPmFtDmv2DbGtc0gknAfecT3kbsfdG7HMbmFLAEqkbtAGu6LfXV9cgZ7LkVEQu+tcj//fi2HaXlW5irJ++MB2/Lm2YPQ/qZ6e5C/2/9KlEX5E+eHgZx00JRNHTdnQRHOCbnR70W7uQAHcbGd8oEBZ/OtohmgJ5Rdsv/yMOC9jV3Ypa9IqkuWgqPSaCXgeY64QZQ5IPN3JoFjOE/o4OffYvign7+yvrA7KvuY4fmmeTbVjKATTFHvUP7kmlzZxrMJQO3rj582+BPfcH/wzerwXao0SuZGytXf4xEQfmmf81ueGtNroFE71I8GF8mz9d7ve1Gi7P+1+P6Bc7gd7cDMFIw/I12ZzwEbuh3JIpZMNEqvqErB82NLrATfJOFwuWWj8ezOL6A/mYCAp9Q1C0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62tibihHLQT5ZclLPWRg7YwKdKuj40YMqDX8Xz2/VhRJDuT4+w0YsnTYqTAT?=
 =?us-ascii?Q?4DDwLKVVlage+bwioxgpCjxgN3X24r5t0aix8lkH0s4dLBJ361gB/mSORmph?=
 =?us-ascii?Q?6sX2Jl7WNK627yDoVkqB1FwDqdv3t73zWuOqq7GoyJnpUbOd5Jg8vp4U2WWl?=
 =?us-ascii?Q?P688BxD7+Agi9q3QzQKIB8KnWYzFwnAv2uRBWDt92+BpgfTIt3yc7qND5QLg?=
 =?us-ascii?Q?xoG8FDUdP7Vrf2Lmu7+RByjiKX3U7I1df8a3NDyvdh8Gl6zYCD//aaPFPx/u?=
 =?us-ascii?Q?2UZIDXgt9CiwCsShzAgsT0A6lws4gjdvv4UBDoelvDEtPP7nLl6gJPSFenF5?=
 =?us-ascii?Q?GehLjHezMDD7TvVnG6N2PGCEZiDsMBqPO+qwSoctp8hhG6V6cMcm9nRpc18u?=
 =?us-ascii?Q?lqbrez3237jEfsp04+jn4C+20RX3LpTcvj/Xp1mQUGGUSN0xmazhCXXrswBt?=
 =?us-ascii?Q?eQMuXF8Ib4Jutkopl3xntfF20e6IJxhSuK2DYBdssVE/CSIQU2W6u/boGj6A?=
 =?us-ascii?Q?PO3v37uE/0K+eqBC6hko02r5rnWhuTgIKB+9ikSc1uvGu0O/w17tzOKMmPkL?=
 =?us-ascii?Q?3OTnz+VZY7jUDbeuAZICCTVOMVB7tZ6T5/8tNmU8/gWojlRI6paCb/BF8QXI?=
 =?us-ascii?Q?6R1bYsLoUAwL6KO1extIzvvIpVo2qLdrcBK776AkC8q+HXs7iqR1y0hQvgu6?=
 =?us-ascii?Q?B/CM9GIMScQGEa1NKNGGFLmXZb3FejoqUKlAQzhem8aH06pxGRz1DQZy9YGO?=
 =?us-ascii?Q?H17m0DZvzI9QERgeokPcdXuNQ73EIVEYEPuRWI+2bwB2mCFpyNWJca8UlZrP?=
 =?us-ascii?Q?IdybKZ5XfsBozgEDYJ3I3COyAb2HRdlyUp5b+g9MFUc+IazpFUOTivM5581b?=
 =?us-ascii?Q?NE8wEm4bMwAqeavMsFkwmxKWwMCaQpprAGFxcTzLBlHme5rBP4/lTqLRBUaf?=
 =?us-ascii?Q?wGHhxa4DWes0G9ooOR88Uh0BTwSVxAzbt+9n0Mhl6I5b87VflpP2buoRdi4R?=
 =?us-ascii?Q?Y/BNOZJpFyBIbrR65LfpwAJ/Ma/GiwR4RC+nDuT9JAC/S2iMszn9IqUpswMi?=
 =?us-ascii?Q?R1OqkB9G80+WeGkHYxU16bYQBKQeqmZU68KjuUc0Qxo75xUI6Ymyz6EKRbEb?=
 =?us-ascii?Q?Y+SUmPWOFwZX7jGUvFpHI5nfEgqFb9eVphdLtLp6rWpDDBIZt5cIJbqv/XnZ?=
 =?us-ascii?Q?OvJRpwPggNDzyKfzn4rOrOWjFZWzsIYj48eiliGRX02CXlpuwUFvrfALS/lb?=
 =?us-ascii?Q?+Q0AfQ265FaAgu5kGrNA9O4xN3gqU/NxoZYb5jtElQ/+41h8lH8LB1JvYWD4?=
 =?us-ascii?Q?hjLuE1i8n3C8vZTorswbFPziLdwkMZSHWympZzy9fFksn8otw2fro0AQVoNz?=
 =?us-ascii?Q?kuaO7nIepgWLC8NY5YiZuCybzKqSSyi8t1DAPsXJi/p5jlg0cK44l892o+4G?=
 =?us-ascii?Q?FbyT5oTH14y0N1dPcDYwr+0NJaKLMkB0w49ipEVgXrT/XYVpZa5sm+1NBahV?=
 =?us-ascii?Q?aGGhTPgqejc08KQxGeHXeXjhjRIKhcF0TDFQFg9SkWU3tgEFJBgwIWIGHe3J?=
 =?us-ascii?Q?jVFLddQ/lGgvez5U+cKF0MP0onEINVYIM+nvjXMjTr7pLdZF7Q0y99YqhU6m?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: omJZ6ypfsCYxcQ4qadhe7bAfKszZm6wS57PNPaIih35n1VxkoTls/gMiVV5p7i+cqaqeNN2DpFelTvAXphc9YsY2so8/6vqJr2useeFFTe/rOeuDYdVs+pwCbe5ssxqzbez6W4Myg+O09kXCz8jiNIX8bZdaYkINzoRFAvj7lwyRzgp8sB7McnTCqpt8erZy5T8BpiPhhjzv5tTe7oR7FG0a15UOxMkCHl3Lh4vOhR7iKs9LKmNLzYEn0H1HSg+4LFY2xpbHZzsbv8hr/NfNqM4ap9u9mFEpSMPvBeON0AMaj7z+e+58dQILXR45rS7IGnk63YrLkYkQ7oMFXxqJlwERpYE4IJ7ZQT7tJfS/3bPL3OQRqWXuKtsKrn1Mj9P/OYtQxtKk856el50Z3HsrwsOhfAtfNdwQXKwAROMzGB0bNpOK/SqNVrVHtsfDn3Q3hoxNjpRVeqkzhnN4Z7oNil1vRVLzrVDJM23IKzMU5SvP1SXQNyNcgVjOffBT215RKTpIKi9CI8lm9ctQpRzNvfWENurMyN16HWMhMhRdEUmaFeZroI4TkCMA33OUnOzzpY8QvEfcJoOj6WEdCB+OLr8X5eqFJ6FJX0ZbK6WLaYAV5OGHmMGBS+Vr1GsWgDpJ+VmXtukWGkNW5MQL/dIDR1PDTj7DPPMSWRnKDK6uDndYRDF/+Pb00MPISdWSFPxGxS4dO3HQwYSC9G/W8948SYb3CMxnUhYWxhotW7hjIqBbyFiv1mpCd3GXXhPDiX/3yBkIKOsafzyjwbk0xYrfXTSx9tQCTNfflIdS+B7B0qZ8pAuqEMZ0CJA98/e/1vp/muuRQTRscSWaRuzxozTG32vg//EfckF3mnlL/6ZAgmK3jbVenB3z0l+ieVJ1ZPUk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039a22d7-1c8a-4d10-d8cb-08db0252d9a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:06.6496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JQggDJLCDHfuhoDOwC4mrzOkgr5Yy0BZYUv8+OiOTHv1f01vWN9VC2wyaHUGiUvX/jJyyTwBP5nYp5wRx5+NmGTx0ejZFIKPDTA6V2tYGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: fHntzYBRH5bH-hzhs6ivE0F3TImjsY6I
X-Proofpoint-ORIG-GUID: fHntzYBRH5bH-hzhs6ivE0F3TImjsY6I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the t_state_lock lock in compare_and_write_post while
checking the scsi_status because we have just set it before calling
the callback and there is no chance for races with other accesses.

This patch removes it so in the next patch we can hold the lock when
calling the callbacks.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 7536ca797606..c1cf37a1b4ce 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -352,14 +352,12 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret = TCM_NO_SENSE;
 
-	spin_lock_irq(&cmd->t_state_lock);
 	if (success) {
 		*post_ret = 1;
 
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	spin_unlock_irq(&cmd->t_state_lock);
 
 	/*
 	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
-- 
2.25.1

