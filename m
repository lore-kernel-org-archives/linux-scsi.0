Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3694C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJCRxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJCRxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46436783
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOIcq006279;
        Mon, 3 Oct 2022 17:53:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=cBTz/+y7tSxuOZtCR8brj75I/2OU6A5/kxDy8DVX4LU=;
 b=Xq1ChK2YmU5f4eOLipPCDvTgB7sPUVhhlvA6tUinWij6wR7iErqBS7P6UOGzvnns1mVB
 0Rdpr+mwZUtxWPzJedCYfd9m4A4/2xh6za+QYlFZiiJfLN7b62cxydYdjT4j38qqUfg/
 OC046lbk9qL/xbyeGytVhduUip/joRL20EWrMSCQbjgwNRkj91pP7R7/v/MSbhgcMYSk
 56KExEUdX0PNDTId5bNVyz7d1DQohq+9AgiEUaZrr3YR7x1X2nKF6FVX5fECocDBnkA4
 kuEKuK9vmUaygxWE6M4oEPZ9fJjs3CIuI/js3hnQhM+ZqYoC7sNef03TTdyz4A+2Q0rk fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FKuSo030179;
        Mon, 3 Oct 2022 17:53:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09rhsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE6UgaLWJ9VTr5ETnihQQsZpQEnruK/RKTCd1eSzLz/Nw1QfURuoZWW5Fnpe03ZfmXbCcEtRVSIpA5tLTHnVJU9FoAiLOu8NDy4TGZBI52iKjceKfSp3AkYSkH+otcX+dN6esVtWNHUtKASV8N5NksiBled65XVRLn8XsExJR7P1CNgHg0YwBO6CTdEU5f8NPM8i/Wc0N+DzioLZR/rt8Jm4tl3uj7E27jjK0FjBiP5xnr8YVLN1oWEag5QEwMnm8vNBu4DzDH3KStVsfYGkEczODCfEwW7urlDp1YKgbknRUpFCytXf4OzO0wVEr22bpTq94QOB8f2I3yy/rLeHAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBTz/+y7tSxuOZtCR8brj75I/2OU6A5/kxDy8DVX4LU=;
 b=cm/XYFBs5k05YLrI/KrGnZP88v+JukW6K36QNdyDWPg+erHllfraLvreyMoqJcSnlVjQSa9gsGmvRrUDT8qd4ktkNIp1fhwAAX+VrWnBcEvK1A+egMi3zQjWTRof8fKbJWIcNWRvo7k46X7PrVz31BsSpI0wCbASt+HZS4qfygwRl7y66OrYaimJm1jWewjKJ4TNcUrS+vIE5a48uTJwYKCnyEuIUtJ8ucn5fjzaiiXhutmqN926jnKMfegUjv8b1i0mcZZ0o1TOIFBE7ov5q116GptESSlvk4w2u8ZDSUGMbySgzHnmZ8ygTuZFmlzYzPJ1MYWZblxpLuW8oZXghA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBTz/+y7tSxuOZtCR8brj75I/2OU6A5/kxDy8DVX4LU=;
 b=C997yBCwBXt1/eSxBt3fTeK/utblRsCa0LVJZ2xzrb2oiZr4C1pTW+fwOyChfC4vX3IOw8hjbgndzxhUMcAFAkq5tnFlXE5ScoHsAF7esyxcVgx6pGyHjKmTKu2flzm+xWLhLcEdUZ1S69iSJgzSJxLJvkVQTuQmgfAY/E5o/fU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v3 00/35] Allow scsi_execute users to control retries
Date:   Mon,  3 Oct 2022 12:52:46 -0500
Message-Id: <20221003175321.8040-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:610:59::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 480ab544-bdf3-4c61-2291-08daa5682ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gkzfbXi1i0F2QW+6/bXJz7sxGMJqvHiwElcKv1PSkzBqSd7NLGRo37TnxqYi7Jg5R/ye1hkas0nHHK8o/tct1KrebIFDdBgGk2zfg/RHvl7b38Qb8SgR0IJTlvr9J6tFt66ti9WaKKXDFAky9wSKW19sPnVDw+KrjNhI1oIPgZ4FatlUB385Wh7O7jxhizFgxBUlE0/1TgOPUFwGGHduB40ch8RIjqoh7v6nslypAXbRaO7hI1N659V6tsO/S2raJkqTvFGrODGx9pYCpL/RmSanjlQmT07Y/rU6+8nWf3k6rPIXzwCfvbiZm1Hh1ildr0CddwF7XoP2QfcXpHN/tgi9pxJpsQtvEm4tYZw02OZOQZF6NwczfXWk2tH5OqJL/fa1mBIb8W4FbXR9Ib4Y7LZldYfsv/9mHu2a4G9ykX04CkBc1hkaL48EYz53NAh1P++6783uTDSH5RTGKovN/HYGTnKm6sa5OWe0tgc4KmIxGBufzZtRyoSif90m0KX43t+NJxYePQU88V1m90q8nSJvvspvC58UlGmsaR95kHICzjK4U0jae6FkVM+W9qnt7TuGTTHEFnfEYz09se89COGZYR2JyX2AUrIeV1ZE+UqnM0aRhNfj555uV88SUHmBAzlSu0Mu4/RM0OlNwv1bbkMA0XdWUY/qhig11hSDIbkOFHnpJT/a4Jaa+OEVEm1FyP8V/PqIEMXQF7jxrqezQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(6506007)(6666004)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EwezV6WfF4hVf22JUEH2/VeqtoD2jq34LOg4txTur8iuaHn+9wP7B6Z9DgsP?=
 =?us-ascii?Q?FiNu1Bdq+zvC+SfSj5EUI17T+VNAAc/HwCmUuYYMU6XJ+vxyzLfzlD5GBa4z?=
 =?us-ascii?Q?vFykSq2HyI/MKU4DQLxj3lFt9mwYYIFrqgxPzJIdOS1CyDDFNMKqVlIVkfcd?=
 =?us-ascii?Q?tgmICldMCNuMmmuKhJ0DhYySiByAn7FEv4XSUHpQ+WfpIiYdvEYaiucY5jaf?=
 =?us-ascii?Q?0/C5XhnOZK9RiHCUbqS6hTzLXdNLvcyVa3WcPcBnQ+mm+wnrDA7Eh+wIgk85?=
 =?us-ascii?Q?vj9EZlui82RXlwnr0xL4HlWwBKHQR0Y7sdAKGX1LTrJx55j/exuEGaIshUD9?=
 =?us-ascii?Q?qN+2THFVXsH3GsO+jkWzY81Pr5rQoqtXhqOJKsi9Dkxi8o63gEAUsXhwDUPu?=
 =?us-ascii?Q?mrq2l+JVGoavL1I/1ctwn2XF0BOfjRIdQAKgHiMFLnQV0blcfLM0zfJwmADl?=
 =?us-ascii?Q?pHWrTsVjeAeA9Zmjifr8HqcziYa8U/AzaazOivIOQC2MyDbwptGnHkDC+54A?=
 =?us-ascii?Q?4sM0Ub7/3zg5KnylhGkEeN7Ex44YIp0mujAHEh1y4IOK6otTvrmK3rlS4QFr?=
 =?us-ascii?Q?UFoTZV3seQKKdqDEtB5Hk3kbTJxrAgWmefasWa2WDTxo9HetJDUnQRo4raL+?=
 =?us-ascii?Q?vFRIWu2U16xqWPmaOkRE22cxO+r92CFH/ymraoJUBA5QfP5w24HS1V2Tk2Zv?=
 =?us-ascii?Q?mk/VUjlpNf3en6oDUDTr+CM1iYRN5rH1Z+2qgbywUqInZRVWsxupMOwiCtVw?=
 =?us-ascii?Q?8hwme+GAWFV8Iqc4Rb6E2qzZhTOJxznPsoIZAYEMXGGtEf7wQ+Sp8IYkruhc?=
 =?us-ascii?Q?KbjyJLFy9ARCzn3C9QppfhmhigsKnJShiBnGKP+oD6zAfQA+2NaOl1LS3Ll+?=
 =?us-ascii?Q?lgA8AeyXTrPPDqtW9I33WodqFbxkUa+DS3eZI8QBEYADYw4SwtvYyI0jIYUQ?=
 =?us-ascii?Q?V6w2HuT4WIn5z8/AA556ckst0Z+pePnBsTUzNdbl/OOnJq/XmFGB85b6Bl2N?=
 =?us-ascii?Q?2pFZCIkHhTl3CZAhXXPEooqof8O6z+5G1ain4YnBCmOvCnqA4FgetbZeMJfx?=
 =?us-ascii?Q?cMZg70KqmC99wxeioYu2CiosovT/LNdNidkNrDHV30mAq6iz8UffyHUOg87k?=
 =?us-ascii?Q?/lvYJtThLnHVSEbwDXsXZUwuq3OrJkLhlZXc3BUZNSpWNtgAXEkwryBt6si+?=
 =?us-ascii?Q?Lsa6F26zhMnTicxwdpBQlQopBAs2iAOvbXhEia8wFkLp6DGGZ2kEi/XFxX6O?=
 =?us-ascii?Q?obBZI67xESGlS2JV3iu0uiIMAM/kkxtC+cbwQQYq8c81uVISOldobLNbuqCE?=
 =?us-ascii?Q?jQTHkEvyVXLGbkDfmudcwnxikrFKwyXmAxnWudsGk7gq+hmDeup8FdvVRIGL?=
 =?us-ascii?Q?SGAR6C9X2cCD4IPppGw4Jt5pI27NRha8MNRsFc4Ne17DYT15THfkSoVtoWsU?=
 =?us-ascii?Q?SFJf6t+SGdGy76EndxanfVUsGr0TfV5edQse+tKB58r+JBkK52kQVsSKLRDI?=
 =?us-ascii?Q?NwWqFNO7h3Whp1bQ+2hlFD1jmWPwLXC2lpl+FNxiFCx8vNWasBxZ34QYnl/z?=
 =?us-ascii?Q?RzsVzey6G387csGjAWPet+93IYJfTVLLLtKtDBBxviuBTQ26Qf/H78BN4lCG?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480ab544-bdf3-4c61-2291-08daa5682ad1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:24.1127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+l6TYePnrBt0SpLd0ML8vBdVQ314wwYFA9Go8hLvn2oOufhvbHFQz5KBgPIa9Rq1c7ry+lmeAeW0kuikkvRSeHqol+JNhtOYPayXX+bzS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: FRk769bdMIQRJCopZl8OUcLCdtpMgX2v
X-Proofpoint-ORIG-GUID: FRk769bdMIQRJCopZl8OUcLCdtpMgX2v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over a combo of linus's tree and Martin's
6.1-queue tree (they are both missing patches so I couldn't build
against just one) allow scsi_execute* users to control exactly which
errors are retried, so we can reduce the sense/sshdr handling they have
to do.

The patches allow scsi_execute* users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute* users.

We then only need to drive retries from the caller for:

1. wants to sleep between retries or had strict timings like in
sd_spinup_disk or ufs.
2. needed to set some internal state between retries like in
scsi_test_unit_ready)
3. retried based on the error code and it's internal state like in the
alua rtpg handling.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args



