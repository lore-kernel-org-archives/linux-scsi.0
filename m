Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F012FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 07:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiEWH7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 03:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiEWH7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 03:59:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1517815718
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 00:59:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N4sJWr026102;
        Mon, 23 May 2022 07:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=x38lquQr7MBWSvtIv1aw8ur9MDYLAYcljvGmpCEwGjw=;
 b=pSnwfG/VPxT8am6R3r8qSD5Z3vsLqNbwhV47tu3FC0h9LLm6j+yhGbOOr2tD7cdeP7Y1
 cDl1tig5N/rMa2aJEcG/DA69OpV4BakNbYra3Lg4QTZcIuHXnE94DOCIb3yidkSMrvLQ
 mf5ccNoDJUVUnhMPjByWy2uEMX2D68uTiUpzwJ/FuBB+4GNMbqhn0C4YS09R4UDRK9fZ
 Il9P33MVZSM2m0sFtdlmKlQ6YSi67x/tvVxNm926ibZWi/1EckOTIrO9pBZZjX3TeTZM
 coxQphiZ3l6D7EsElppwJQ2PR+sMAg6iYPDHuCQePYpJKBfqBpe4daiBIlbncwaa0lt3 wA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qya2d5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 07:06:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24N6wHJt015713;
        Mon, 23 May 2022 07:06:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph16uds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 07:06:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2fpGa51I8fsEg+EEn85cjcSjKzUSev+o1PvyQyCBYkwLWZmXlF33CZ4M6V5M+Vz0wxGk+SPTvQrueGFtT2Ep+KrFIkb9F9VMOu/m86MmjtIVhUJy/I7ejNhZespy5gWcg4SHRn+SAYj84Lc7Ke9w4CkPyf/3QYuz4JcdUvvvQPTzQrG58F8EVN72MgO1RgX2BDywp+ULxKg9WOFZH7Thk0/zYGSQeDvFMOzceaTcAUW7t9F+rGBfunn/d9ovbM74E/o7Mclrk9bqEiK5M4Ctdzl/r+aInwpb+w8r/1WUNCEZAkqtI5RyM1j9TG6t80Zmi3b13Ot4btCAcLE8DHIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x38lquQr7MBWSvtIv1aw8ur9MDYLAYcljvGmpCEwGjw=;
 b=F3m8pnlPkkngc74y3Iw6J+fR/g6QbVJ10Mmob+bzikmEkerYPc+uzmlJrhWV+daH4+An1Rgj0wXThgPNr9QdWI20SgSwY926AApf2RDEvzyWaeWMFuQEi+Z25Wtvcwy/O7+9dQu+GAkhoO5HcRLdmCkkjYuGCAd2JGOcb2jNjJokyriuT0SmK8/32KE8esLy1bivvuMHFVmwDX0UR1FYEX6mGHIDFDaHxyCVFDGBrOujmHQxlpQbZvFA1XcILM4+CyLYgcexThixL/bSpOqxeg8c7WWzhR70/pUx6mGovzsMETHhnvVJBOLV2WYf8gYzGekwKlaqJ5LFv+c9gVdz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x38lquQr7MBWSvtIv1aw8ur9MDYLAYcljvGmpCEwGjw=;
 b=TNQoLDdQAP4y0WzCrUlCgonoHOhnbMLN+52pXg2d5Z9otFAKZHiS+tOHA65ZKAUhBntkWnsW2QjIMcLTUIG64kIUSBdVoY/pZw38Y3gJeADUmzdNchWs7TKqghLrRrJ5pNZhbSF0MLu4zIxW/Iq3egMPrFtQ6BL3T7hcF+0VkAY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR1001MB2113.namprd10.prod.outlook.com
 (2603:10b6:405:2f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Mon, 23 May
 2022 07:06:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 07:06:28 +0000
Date:   Mon, 23 May 2022 10:06:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: Try to save power mode change and UIC cmd
 completion timeout
Message-ID: <YosybAfpXHiso+22@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0107.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11988df6-a93b-4e54-87b7-08da3c8ac204
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2113:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB2113F0BF90F3BE64FB0E329A8ED49@BN6PR1001MB2113.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYxLMfiXFw8LVQScgv8mteNGlC6vGPR9Rh5CnCN+at0N8sAisvLz6j2y9tEVuuCcSnyAEqBZVn6G8FvfGkhwcBSA7h4OUmJ/2NGOdwJTPzUbQfY+zVBpJRB7kk1TEL4X6fPJDN4q5Yiiuere8/TcFiWDz91MUlPDyOv94rPvcHjv95OfF3060c/9Pp35ecz+MDiu48fnontj8Wd1nQmvuxfXyrU3T4N1tcPTqKiwb3Le0ZmfC68hp3cF6PKF++qVcEWDb+1i7cTTebYUmHHPKBQXut9jntRyHEaijZViS4ZV4PlX0fQvJlBDUalI2tskwzpWz3+vR13uH01l8ElagwqRNq7fUj3Fqf+4Gt0zadQRVVlpEfE98SerjoHgjCGLYSuCzzdFAADCZ+hf4HFwyxlZiHhc3/fF8jWTfQNMrNb/CVr0UGBdbioUNalEEZrkDr0ENoZxT8pol0mLIJCXzffWNXG591VMQGGNRDol+bX1vQwTw8OO2vAqd1Ibrthz/TJEQ1F+Y02JZq0YttsiqHkhtTg/GGdw1xyyKHgEp2l2QmiLQDaF222SJ5/o2JXupTEJ48kvO1A+OrZeQED+WJbyNVotetVszWPK5Vg3oRiO/LWB55QnAji4pOdurMtmCrkIvvFVfnm5Im9gLNP0LyyIk12X9pU2Yd/IsgCEqZxmjHuOEqrji3kUxazhTwK5jDHM8xEFQikegUT4dNgERQYknkonrTYH4+uPcBYPyuQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(44832011)(8936002)(508600001)(6486002)(5660300002)(6666004)(9686003)(6506007)(6512007)(83380400001)(38100700002)(26005)(2906002)(86362001)(66946007)(4326008)(186003)(33716001)(38350700002)(66556008)(66476007)(316002)(8676002)(52116002)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PYU6bfXJhwJJ8K1qCZ0PTL9BJXGiw2FTYMtjn3L3B+XYpYngXuvDnzs+M5Vl?=
 =?us-ascii?Q?RDRNxeaNbzGE55qvJnuhNFTpHrjIYKregIpXvExnQKLcqv1VSGXX3o7KHL7U?=
 =?us-ascii?Q?4tPYESOxR1CMoG1a8mMtQKBbKrJuSklCKRvfUYq/7DfYTIsQnjnQa4Av/HN8?=
 =?us-ascii?Q?5pyzpyeEGNqqgMxnjVDec61FRZnJUEHvkJ24uF/skpwvNIrtt9LpS/GA/K9t?=
 =?us-ascii?Q?Efniv26+nGrKBDJCukWTzU3B6HXFmpCrjZnOFIKAQA6oRY2RFf6S06snhaf+?=
 =?us-ascii?Q?I/YoIMC8g/Hv5uHSe+SjfQ+L8QJWQrH7T+FQegCTnEeOaVVROR6RxrVpeXh3?=
 =?us-ascii?Q?7bA9Xk27sleeYIr6DjpeHHu54pYD9p4D2CpOtWznKPb4FG+478ERJioNpoVe?=
 =?us-ascii?Q?PYk0qEAaAsl9d5Ue1qoAQ34XXYF7ufWCRz2+CW0oMfZRGGZoI1JjNGBtsf/x?=
 =?us-ascii?Q?/DMga14/L4IeFZgDZkW958rrtW3aE2vmZajUt6VWg9tHkcYnku5mRnXP3g1H?=
 =?us-ascii?Q?NMsnWQK4EaNSe3htvMWDRioN2P8KqbwlCQXqoO8jz+RFPvk8RMfJ6+aGdGWu?=
 =?us-ascii?Q?25Gm5N+GqIf7FiYiv7glUFwMIQtc6yFknL9rA3Mgcdn3QpOS8a/rKiwEuVAK?=
 =?us-ascii?Q?Ow1jRRDJavDMypg3+3BI387gE7P1X7gcLI7aENoDsTvXIrutlhYjqQfc+Guo?=
 =?us-ascii?Q?4b9hVl8FVeuBCF+3PIuEKnaUDUhaUMUAyBzmgw5T65IyBxz3mGJBdJrAqPMW?=
 =?us-ascii?Q?0Qj5fUbtSqubE7a0Gmk29xdh59d/yMtGgvVWLr5bBPT8dx+GQrozycdiI5qw?=
 =?us-ascii?Q?sXNe4HmWtLdsfkEP+A4iq07gYQvoi9xqenfcDjlvMmL+5SPSabMvcEtayT0z?=
 =?us-ascii?Q?vIvLQgXaOr7Wq4Sfua7hDPWE/2lDskiS/+kD8JRsFBzXVlISuMkxMNwc5CRp?=
 =?us-ascii?Q?1U3ws30vWfrJzITw+pNCRSCX6TTCIaJuaosod85KGVYe4c9GqN6Pc5KnWaW7?=
 =?us-ascii?Q?JnruxQGM/AbBjRJFpjuA0sTJnYmfBzDQ6XyQi1CK2o8JJqEljIyy6Ocfo85+?=
 =?us-ascii?Q?5Mloca2sJmT+h/5TotoOWY9vQ00VEohnJn0dVV5R/3U2hahLo0Bu6cPrrzLW?=
 =?us-ascii?Q?TuyK9hG2hHYahjS4o7IxMs5xGGkNtq6NcPfPYcsJ6AIUsa3hY6U8Hp697Nou?=
 =?us-ascii?Q?jpJe6i5NBqIgurt19LpAwYR49cE6MowEkHTGh2yvNraEam1tB+Oe1D9Kv/kM?=
 =?us-ascii?Q?ddJ6+P+DMxQ6EulcRrJTvxA66Yt+9siy3Dm89DXI7Wrh2cEfQujXlKZSWkJm?=
 =?us-ascii?Q?NaMaI0bhGVwMOqjvY+ISZqqPyWlB7viKKvA0946XTVEUC+aQN5NEgIn2wB9O?=
 =?us-ascii?Q?x0TIRhz0PRKLMis4fdzPi+Tfyhh9A2Dbp8n0HbVdWXu6blU4ZeGmYxwV0eJG?=
 =?us-ascii?Q?waLTR8Hmh+U8o6z3rTiHCIys6yC7rQYIJlMAupz2+Xd9GZLwIbmNyLEsw++m?=
 =?us-ascii?Q?3ncQrOOA1M4y0ddwyslpHa++L41zsf3oAxP0EzfSamLZ4wi5qzdsVaEo6SjS?=
 =?us-ascii?Q?GWc0mhP1ngCquFlGqPZOLeG61uwMAO8wjmbuEy2ZTNJgRZw6tXugiHLjsBWC?=
 =?us-ascii?Q?9E0TkfeEpX9NhrLc2aGI3Fjzk+5fQVb1fNOb9xD0TM4lHzOJcj6T/R3YEpG1?=
 =?us-ascii?Q?qbYcyacoXlj3SnN7ORp4zmgc32FiUCfW8kwelMdjlW+rAyH2VoU9g6h3pXyW?=
 =?us-ascii?Q?wL7DwwwPNqRqRQRy9C+KVSJgd3K392c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11988df6-a93b-4e54-87b7-08da3c8ac204
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 07:06:28.5982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InvYhrTQy+zATTNTzessrQyS9fsXx+L/6wbUWwT9ZJysvx6gHG9JQsf9CkHJMGNCVAe9YJVkRbbZpBVlscfRksNdXeoElk0bTtneswKBzBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2113
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-23_02:2022-05-20,2022-05-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=881 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230037
X-Proofpoint-GUID: p0eZHK_ttAEd1qIbeZE97enRmFtAHW91
X-Proofpoint-ORIG-GUID: p0eZHK_ttAEd1qIbeZE97enRmFtAHW91
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Can Guo,

The patch 0f52fcb99ea2: "scsi: ufs: Try to save power mode change and
UIC cmd completion timeout" from Nov 2, 2020, leads to the following
Smatch static checker warning:

	drivers/ufs/core/ufshcd.c:4048 ufshcd_uic_pwr_ctrl()
	warn: missing error code here? '_dev_err()' failed. 'ret' = '0'

drivers/ufs/core/ufshcd.c
    4004 static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
    4005 {
    4006         DECLARE_COMPLETION_ONSTACK(uic_async_done);
    4007         unsigned long flags;
    4008         u8 status;
    4009         int ret;
    4010         bool reenable_intr = false;
    4011 
    4012         mutex_lock(&hba->uic_cmd_mutex);
    4013         ufshcd_add_delay_before_dme_cmd(hba);
    4014 
    4015         spin_lock_irqsave(hba->host->host_lock, flags);
    4016         if (ufshcd_is_link_broken(hba)) {
    4017                 ret = -ENOLINK;
    4018                 goto out_unlock;
    4019         }
    4020         hba->uic_async_done = &uic_async_done;
    4021         if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
    4022                 ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
    4023                 /*
    4024                  * Make sure UIC command completion interrupt is disabled before
    4025                  * issuing UIC command.
    4026                  */
    4027                 wmb();
    4028                 reenable_intr = true;
    4029         }
    4030         ret = __ufshcd_send_uic_cmd(hba, cmd, false);
    4031         spin_unlock_irqrestore(hba->host->host_lock, flags);
    4032         if (ret) {
    4033                 dev_err(hba->dev,
    4034                         "pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
    4035                         cmd->command, cmd->argument3, ret);
    4036                 goto out;
    4037         }
    4038 
    4039         if (!wait_for_completion_timeout(hba->uic_async_done,
    4040                                          msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
    4041                 dev_err(hba->dev,
    4042                         "pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
    4043                         cmd->command, cmd->argument3);
    4044 
    4045                 if (!cmd->cmd_active) {
    4046                         dev_err(hba->dev, "%s: Power Mode Change operation has been completed, go check UPMCRS\n",
    4047                                 __func__);
--> 4048                         goto check_upmcrs;

Why is this a dev_err()?  It looks like a success path.  I suspect this
is debugging code which escaped into production.  Or alternatively, if
this is an error path the error code needs to be set and the error
message needs to be re-written to be more clear.

    4049                 }
    4050 
    4051                 ret = -ETIMEDOUT;
    4052                 goto out;
    4053         }
    4054 
    4055 check_upmcrs:
    4056         status = ufshcd_get_upmcrs(hba);
    4057         if (status != PWR_LOCAL) {
    4058                 dev_err(hba->dev,
    4059                         "pwr ctrl cmd 0x%x failed, host upmcrs:0x%x\n",
    4060                         cmd->command, status);
    4061                 ret = (status != PWR_OK) ? status : -1;
    4062         }
    4063 out:
    4064         if (ret) {
    4065                 ufshcd_print_host_state(hba);
    4066                 ufshcd_print_pwr_info(hba);
    4067                 ufshcd_print_evt_hist(hba);
    4068         }
    4069 
    4070         spin_lock_irqsave(hba->host->host_lock, flags);
    4071         hba->active_uic_cmd = NULL;
    4072         hba->uic_async_done = NULL;
    4073         if (reenable_intr)
    4074                 ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
    4075         if (ret) {
    4076                 ufshcd_set_link_broken(hba);
    4077                 ufshcd_schedule_eh_work(hba);
    4078         }
    4079 out_unlock:
    4080         spin_unlock_irqrestore(hba->host->host_lock, flags);
    4081         mutex_unlock(&hba->uic_cmd_mutex);
    4082 
    4083         return ret;
    4084 }

regards,
dan carpenter
