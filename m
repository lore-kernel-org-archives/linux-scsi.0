Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0238CD3421
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 22:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjIRW7G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjIRW7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 18:59:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A068F;
        Mon, 18 Sep 2023 15:58:59 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38IK53Lw016874;
        Mon, 18 Sep 2023 22:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=wEl8GOGtj0IgViW7+GgofbioOfSHnAH6cyoH5nF8H84=;
 b=Plkr7jtsqboAD74eNNFivvwOJj520vRLQJH91hkGFmMpcdkJQYWVpkbFMawZqFkofxH8
 xnpZhQS4P1PCygYyshLGgnTFpBs8oQBvJNPmmFwVci/dD9u1wBYa5Nf4JOaLu82nXY6S
 SUFpA4UBoqvO/ORa/GoOR7mpxGfWJGT59oDXu4UgJ7J285jfyIpq4a4hsB/zQJ0UTBl8
 zz/3UW5TCRc0tS5I6njKnXJ+EJioO+qZ8OqIYRDnjPW/E4IYAF4fWHgqliBagVXsSsjp
 BBb84dpSdSnx6xY3mgmI6VUu8O0WMgJINixbE6yes/228nl7wt60FzJ/D8h4Ugk5oJxl jA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t539ckq92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 22:58:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38ILtFTF027102;
        Mon, 18 Sep 2023 22:58:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t55u9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 22:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYjUDIg3EMAnwwxGtS5feT2j3QjS4IaNh3pX6yf9M0jnWr4wtzNGrj2U9MlS+sJLYcOkFNyAh36DElNJu/GL0P/J82WqOMopcOxtPtNYwN8rjNTIiCxy2YxXilnWyhDX1Cj3Eliu7G6qV3hcvXxywbarDPQu2LnwHatfpQHE3vJvXk+1xySnwxKJ+g+gS3JcaAav45o8HjgSkryFYiUg+nNi9UCXYmEi8bayGrqjidk/C/gNcXHqJg3CLqKACt7sXhRf0PojH/u2mX/ddECbZkvlA3WYkSm2xSovoJMzEjvPaOxeOq0NyIh6MJN9pe3rveUEqYxzOjhKsJn59w1Z6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEl8GOGtj0IgViW7+GgofbioOfSHnAH6cyoH5nF8H84=;
 b=HLZ09gOxWzGbiC54HVC6mSesVCWlLVJjJKQFIe7pSl3p1H/5DT3q8htPDwqarqZ/bX6/DLMLBPikPZyLH3iIGT8qYyAyqsXscd3JPAcOn9aspWyMNqamVxmC7Yb9XU6069eVlBezby+8KyDO5n+lO6CUXQPj+/YGb+0UYmogoK1xj2lnZ1tay4M4gFx1/2cYFJPp/wou/607TPwnS+LuJ7tVryugQdwKhdLQQtqqmhV6fckxJO6Ls1r2/BZLRI3LQwk55zd0FZIQ8Jks7EvAsEdGPz44qOKX8Gzt4t9HnzvPf30XLd18O7+AIiMqoPaPbjvNOCycOQ7iQrlRZoa7Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEl8GOGtj0IgViW7+GgofbioOfSHnAH6cyoH5nF8H84=;
 b=XOHxaE9NRum3uWUg8wNDvB40sOUOlygLpO1aPNXysORIWLu8DyT/Q+Pga86OdjJZE25BmCyXNy2uMfZfx0upYEo61OOAYAAVdrQ7cxbJzzpaxSqj20w3BH92ojUYJ1DQFcvBoNj/tw/HojffH3VRDoYceF2UWLH5/3yrePWsFpI=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by CH2PR10MB4327.namprd10.prod.outlook.com (2603:10b6:610:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Mon, 18 Sep
 2023 22:58:49 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::c7f5:ba96:986e:53fc]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::c7f5:ba96:986e:53fc%6]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 22:58:49 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, mchristi@redhat.com,
        bvanassche@acm.org, junxiao.bi@oracle.com
Subject: [PATCH] scsi: target: fix deadlock by recursive locking
Date:   Mon, 18 Sep 2023 15:58:48 -0700
Message-Id: <20230918225848.66463-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::28) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|CH2PR10MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e098399-d476-4adc-40d2-08dbb89ad24c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bH5OZ9VmzOQ2CNorj0gtI8S2Hdw6y6pllHjdSVfzDDIFl3z1S5kaorIOCLtno5Ea4y59otf7TwqF+RHw4Be605i3/s7bCohbt/S/Lgrt/C9SQOXdOvPlqWz3Wl3c5+rQHgFcS15YA8WjHWvbhDBhKHdFxhR2IlfozSivzjUH13SNtuGd5L/VNfldZgRbxgvDyHR8QuxJYFkeU/0BI5TV0nOJuQ8NJSMTmb5XUnhOARbhfcUYf7M9by7QSX393iPZEhRX9+ulcKRjeQ9VAYuwvz5bkb6a+5aN0saArhp3w1exPcs/JWIAahqFOWDV48pixHnahyeAQmbfHXcyrMIqyKfzYi8oAaZY6fpsmOgQPp61fv64x5osRtFiA/A+gwyC00lzrTobOQeZUjeqlQ8lY8HaA9JFno4zVGZeLLrDiB75cVoiU6cPwzOs+p0lliEjAZb+lG4p3XAZJzJJwdnHOXYkL1rmAKuBHkHghMUIWWh1SrDUdIWsOoilXUqUMy26dvTjNatezQaIEGJGFb/wl/FD6d3GqRL5M8yAbEMJOGbknsTkCCmq1rIO7dNfFug
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(316002)(107886003)(8936002)(8676002)(4326008)(41300700001)(1076003)(26005)(2616005)(6512007)(83380400001)(478600001)(6486002)(6506007)(38100700002)(36756003)(86362001)(66476007)(66946007)(66556008)(2906002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P7G3NomQ60o7WPvBY11BZmomPdfiuxYE0sdt6hvZgtu7Ehcgdi+cSfpnQnUO?=
 =?us-ascii?Q?kUoRGLnpMGaQPHzudJHleYbvcvhZEVG45gVFAD63Cd+lMRmCBEe6LBghxpZV?=
 =?us-ascii?Q?o/ZRwm9rVvarlYd6dTRrwpy+pB4yQgQc4BUCciilrar59YNhkuOYSXwfimWP?=
 =?us-ascii?Q?RPQeLAyqjQ4B9GV7LKx/Es7iNjWL/nUeG9WLcrRPfRLFu5QFQrHykaLXz9Bi?=
 =?us-ascii?Q?J8pC0q3c0QaQbjLSqVE4leJqzjMRMgDlRpG62/eUl1cQX9RZFd1bNiiS9W/v?=
 =?us-ascii?Q?ofD2G+sNCiUha+2GRvY+Yzj/5BLHub9LJ4RZ98/LG2SeupSb32EILc4+lnvd?=
 =?us-ascii?Q?ko37NZ5jrIGqsCwmf8XJ16wzjkTkFndX7/tdUwAhs2xJbluCS4pfEQWSheiD?=
 =?us-ascii?Q?71OdK34FvbhGLBMm1SQlkyUYe8Izowpi8YkIhirMC/1a3UF9msIfMX7wUqii?=
 =?us-ascii?Q?dGfxB0s3IGHQ3pIlmT+MwR4k/uHY+gLFpT/rcH1tlBLc1UH62J5gWWc2oweK?=
 =?us-ascii?Q?Fa70H24rZ1ZbWWadLk8o92OWABdMGoad4em1+EGY0tCCkDHgtiNCy9qnDb8R?=
 =?us-ascii?Q?CjjGAbHGndeoMKOvLBJ5CmSIIO/fLj0y7uwDDZ+IKSgiKOTjTXvMsLlIPs9N?=
 =?us-ascii?Q?1mCt0fgiB2Mi911GxwjaJDsSVYRnsSXn0Vp/1fvpq2MSUP8n2ijkf3MhQ5Hx?=
 =?us-ascii?Q?fJpBkclU0LQyx9ROV61zqgN+44hLblEQUvk/G63bKt+rGEy8cB+f7GWC2s8d?=
 =?us-ascii?Q?NkFhZfiAeT2vVxx3zA+NzF0hX2sKVGEc09SM61TIAOPdXQz7DccEiBTGsBFm?=
 =?us-ascii?Q?fifKajHm07/JeZ/J3xLlTy4WQA7sKaOBV3DL9y5bLV49ksmjD5713IZEZZkX?=
 =?us-ascii?Q?64TA9O6BXrzcbYmum6ZvJLgoGUewWKIXzqpWhwx7WCKiqVFHSLoSjzLnamft?=
 =?us-ascii?Q?k/n4sW9K3rk6NEmjm+CK+n9RYRIDSKfnO2xz4gVERlA21FKu+FqT7WI2SCtF?=
 =?us-ascii?Q?7yRWd390C0e86CoMzE1sOQ5oWrTiLNd7dMmevv4OofcSMiO0iudLGE2XNNm3?=
 =?us-ascii?Q?fQBO70FKt9WA6EWgwl+J8Njpi2TaUK+w07Nb/x1oo9jF9pdWEkEOqsS2FJuq?=
 =?us-ascii?Q?DeZ9p2t6JKZY6xZIeEE6Vv5cDq2hqBCd+yWn/NWykOQ1cIehi+qy9i3UFgwy?=
 =?us-ascii?Q?nXnL6rrx4MN54yq8iVUtCmrIVPUfaFFp+F/x+WQcpNBhY+cqonaEj3qVx3ds?=
 =?us-ascii?Q?ZwLZc6Yb3Ps9e98OBu+OYPEe2BRkTlSUdemlPeYa4vZCQ5FMYggOuKOLE8LY?=
 =?us-ascii?Q?PEfu+Uzyuhfzc3CY5APriXwp6q0cTdF+fUwY9uO5vxDIjOpg5q6gaTxqAqp4?=
 =?us-ascii?Q?l6cGphM5sFNfYd+lwhUfj1ZiBCtLay1QpdaPF+l9SFl5xVQvqoIf//EcFHUp?=
 =?us-ascii?Q?Ek3dJX03o59/hGTAE+MB4VpxOjAge5kzHe+X9pRH+ER2IBtXCVQHKS1IRJSR?=
 =?us-ascii?Q?QqpZ/GMJLnHP0dtGXkQ4zmGCxvyxaygg+yW0nd33bIQGvy5c72OWMQiz72dZ?=
 =?us-ascii?Q?spylWfTua4bluXk6A2aQnK+PCr1RMpilCxE3qquB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HDnHj9BvLgz+P347LFCZI7ZiInEIpNjNJjUwLeA5tSi+V0HoTMOW9lws86W2Xe0YOtCVLNke5NYldU4e46g5g5xHuE2HLGCiU4m6of4lXTJ4QzkvzQibfLZun9a2YSH07UJ5l4iHm8eVeMLrbEeYgqsYywl1x99ekdnums5BA6xW4/JySj9zwAIrZDpcuTFkc7IZGgwjd4dW9/5gEzzDresi2A3lzEG6IxFWLk+KrmGhqGrMaxVJiz61JbTxHMSew/arxL/Ie3WM/IHMXcC8KBhOnTuqFAZzRUU0bxzISI2mlSm7wYJlooBvovrskOFPuaC+B12aG4thMbwdPJRaKZOooQz2LRX8SMU4+9iEc5BFxdLw/ulBStWd4DSwToFEnrcEr2ocShNCh6jWn0x3BsXXAf15RSc5ZuBIMKN8p4Dq9Qc/Vl4lrC8+sr/piyXcmE11RK7+PIoaqknlF2025DXEl1uTqJtFXgOMIOjiBmR8aJdYSRlo7jmy8hWHEy5ObKKw/hJxFBjC+UYtGKJZvxRNG+mrISPsWqMcAx+edrjqjZJmanlM+3hL2RN6GjSuj9Nkr5V1JdQWKFoU5Tq83mFhhFOEv82IPPaScRsy3OcZBt8HpXVTH+m/GjUGF0BWdPYHHoysvl7fiBWZKd2JBB1GIE+4U7zAPUlTupgxluWEHJXepSdfNobWaiFjfnJW20otLM/wTY9flwrqq6cSbH2tp+yD4OLjukJAXIgS1gjzDHHoNJSRs9wlaYfbL1k98IWZENmoWBD5fELcYx6Owi9ITn0kXH+eKFdDKZ8qZSzoL1T0d47m8FrQ28rTpOMW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e098399-d476-4adc-40d2-08dbb89ad24c
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 22:58:49.7276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVh4DWGD+yVx84X8bs7dqqrBRLPdY+xxT2xjwL4sxrWi+gY9uHOwdgI/c3zFqRjQ5k58qID5q5uJ+UPSnXukwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-18_11,2023-09-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309180199
X-Proofpoint-ORIG-GUID: MNnB1rNscH0GDCwcjWt9o8UQCnjfaxHm
X-Proofpoint-GUID: MNnB1rNscH0GDCwcjWt9o8UQCnjfaxHm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following call trace shown a deadlock issue due to recursive locking
of mutex "device_mutex" , first lock acquire in target_for_each_device()
and second in target_free_device().

 PID: 148266   TASK: ffff8be21ffb5d00  CPU: 10   COMMAND: "iscsi_ttx"
  #0 [ffffa2bfc9ec3b18] __schedule at ffffffffa8060e7f
  #1 [ffffa2bfc9ec3ba0] schedule at ffffffffa8061224
  #2 [ffffa2bfc9ec3bb8] schedule_preempt_disabled at ffffffffa80615ee
  #3 [ffffa2bfc9ec3bc8] __mutex_lock at ffffffffa8062fd7
  #4 [ffffa2bfc9ec3c40] __mutex_lock_slowpath at ffffffffa80631d3
  #5 [ffffa2bfc9ec3c50] mutex_lock at ffffffffa806320c
  #6 [ffffa2bfc9ec3c68] target_free_device at ffffffffc0935998 [target_core_mod]
  #7 [ffffa2bfc9ec3c90] target_core_dev_release at ffffffffc092f975 [target_core_mod]
  #8 [ffffa2bfc9ec3ca0] config_item_put at ffffffffa79d250f
  #9 [ffffa2bfc9ec3cd0] config_item_put at ffffffffa79d2583
 #10 [ffffa2bfc9ec3ce0] target_devices_idr_iter at ffffffffc0933f3a [target_core_mod]
 #11 [ffffa2bfc9ec3d00] idr_for_each at ffffffffa803f6fc
 #12 [ffffa2bfc9ec3d60] target_for_each_device at ffffffffc0935670 [target_core_mod]
 #13 [ffffa2bfc9ec3d98] transport_deregister_session at ffffffffc0946408 [target_core_mod]
 #14 [ffffa2bfc9ec3dc8] iscsit_close_session at ffffffffc09a44a6 [iscsi_target_mod]
 #15 [ffffa2bfc9ec3df0] iscsit_close_connection at ffffffffc09a4a88 [iscsi_target_mod]
 #16 [ffffa2bfc9ec3df8] finish_task_switch at ffffffffa76e5d07
 #17 [ffffa2bfc9ec3e78] iscsit_take_action_for_connection_exit at ffffffffc0991c23 [iscsi_target_mod]
 #18 [ffffa2bfc9ec3ea0] iscsi_target_tx_thread at ffffffffc09a403b [iscsi_target_mod]
 #19 [ffffa2bfc9ec3f08] kthread at ffffffffa76d8080
 #20 [ffffa2bfc9ec3f50] ret_from_fork at ffffffffa8200364

Fixes: 36d4cb460bcb ("scsi: target: Avoid that EXTENDED COPY commands trigger lock inversion")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/target/target_core_device.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b7ac60f4a219..b6523d4b9259 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -843,7 +843,6 @@ sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
 EXPORT_SYMBOL(target_to_linux_sector);
 
 struct devices_idr_iter {
-	struct config_item *prev_item;
 	int (*fn)(struct se_device *dev, void *data);
 	void *data;
 };
@@ -853,11 +852,9 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 {
 	struct devices_idr_iter *iter = data;
 	struct se_device *dev = p;
+	struct config_item *item;
 	int ret;
 
-	config_item_put(iter->prev_item);
-	iter->prev_item = NULL;
-
 	/*
 	 * We add the device early to the idr, so it can be used
 	 * by backend modules during configuration. We do not want
@@ -867,12 +864,13 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 	if (!target_dev_configured(dev))
 		return 0;
 
-	iter->prev_item = config_item_get_unless_zero(&dev->dev_group.cg_item);
-	if (!iter->prev_item)
+	item = config_item_get_unless_zero(&dev->dev_group.cg_item);
+	if (!item)
 		return 0;
 	mutex_unlock(&device_mutex);
 
 	ret = iter->fn(dev, iter->data);
+	config_item_put(item);
 
 	mutex_lock(&device_mutex);
 	return ret;
@@ -895,7 +893,6 @@ int target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 	mutex_lock(&device_mutex);
 	ret = idr_for_each(&devices_idr, target_devices_idr_iter, &iter);
 	mutex_unlock(&device_mutex);
-	config_item_put(iter.prev_item);
 	return ret;
 }
 
-- 
2.39.2 (Apple Git-143)

