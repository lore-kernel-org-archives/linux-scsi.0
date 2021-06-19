Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC700C49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DC7611CD
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhFSCZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:25:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47944 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231305AbhFSCZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:25:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2BlQ4028702;
        Sat, 19 Jun 2021 02:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aihpjZuKH3yedwdidSD30g+/CrvR1RRLHq9f+jOnjnE=;
 b=U6ijhDK2uCFHCm1ebd60CNR4xImZke7or7Hba0GiDaTWpe1tUHQm6uCSaOWsUgD0wSA6
 An+loPwzqIYYXUDETuAIfmRkhF+E6xVW0HVE7SxAzfbaMZjNcxD/Y6U31jDG89SXxDE9
 Ov5edfnip8mBXt6szALLaxM0/yCe2t40oP/pP3xoUMahgXGZ8ME3PWWW+bM/t3KrW8OJ
 tmufSOruxLqrgRkwyDinJ8umhyUUyRLtQ3vaYRQUNjVqXfiIJ9a2TAm7auuNdW7NvaYQ
 B+qhC1hX2HsL3wFSBN42PaTOv8SEWjAOtjYrk11YX+/FsuIUa+iytcZ1X49LDfed57BI HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3996sn813p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:22:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2F2os009006;
        Sat, 19 Jun 2021 02:22:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3995psajut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:22:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpGVm5xQ7s7r0lgwkZVPlBwHJYffVNHxbKtbn13+oMXE+hEVZS/mXx6jhUm4oicMhTqwRTBXu0BnBPmWsPZ5vOF6JApoecBRDrC9cRP/JHgfY7N/uMGn2fBVtjF4BuaFuh/1zsrKeP6Lv1IKf/HmVOgxZ5evKb0EBG8VDEMUUxDgiNB+qIXxwSmiA3Rnoo3W3sbmyDFW/brIRzaQNyDii/nuOkyD2bcAdN9lKSH+p8buasSgU7ltAR/q7GzOk/3rsuHrkdPDBRfKgnEZ2vHCU1rFXIH0ckuIw4jKj5ubXFM65gzEuykWw1F+fN9HVj9Rx5Jkq/7PRHdbg8bEHemwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aihpjZuKH3yedwdidSD30g+/CrvR1RRLHq9f+jOnjnE=;
 b=B0Q5vqSk9YGF/kELY/uSSyIAHqf2NlITGN6sYpcPc4MsxR86+Iv+Dj5RRe7DI5MIleqnF4lsowLF398gsUZ+D0GZiW6EmIIpgkmFGDrwGhh0257NWzhFkUOCyxhZ4W6awifV3Xmkd1auNnPwTCdTQK5bf1sXLF/HOkzYuS/KgyhXxhisStvScvr8u46Oojo1xCvEatdKxPOwWjb72ALaYdS7JlesMApjG2lDZLaoEpK6CaTG3yaFOD/ObtpIp/n6XACiEB/5SgRc8FNCmV+6eTloAHK94d5WfF15TmVzfOUNEy3Wm4dIXajqFR6FbKaAoqhtcq//e4tpol1LkDy+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aihpjZuKH3yedwdidSD30g+/CrvR1RRLHq9f+jOnjnE=;
 b=imzz85cSuw6BjsTWgbKbSx/Tfi7n/2cf+uVM2cmUy9vN6fsVR0IF7Bwl8/9GEKHIxGyqms5D7mJoBMTJ++Iz2p39Xpkz6c6zDQ7ggmsdF/nLMMCQ94dJo6REw/EEdJqk2u3HCAX7jh7+ROPWQyWec2LURJZSVKh4t7WuO9pWWW4=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (20.182.136.88) by
 MWHPR10MB1485.namprd10.prod.outlook.com (10.169.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Sat, 19 Jun 2021 02:22:53 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:22:53 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: elx: efct: Fix spelling mistake "Unexected"
 -> "Unexpected"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmwizj7w.fsf@ca-mkp.ca.oracle.com>
References: <20210616142637.12706-1-colin.king@canonical.com>
Date:   Fri, 18 Jun 2021 22:22:49 -0400
In-Reply-To: <20210616142637.12706-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 16 Jun 2021 15:26:37 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0121.namprd05.prod.outlook.com
 (2603:10b6:803:42::38) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0121.namprd05.prod.outlook.com (2603:10b6:803:42::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Sat, 19 Jun 2021 02:22:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d91f3fda-2603-4e56-14df-08d932c9248e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1485209B641A67B900523E6C8E0C9@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jMYlzGhHKRkcpE0WbT1HSxdHnl16sRFqw672hgHHtwE3tlgo8laZZQPtzbjlXxNWZp2I3gUSjo5+AI2KiUYgM1mnj0NhcQtSAMnE6McvcxhL7visz4Q5j/FGT8lZyGGBLvnv9leHZEGN4VP0/r1N+yc3K/ZV22FALMbLavAbrPGVaLsHQ9/QpRDrol05PLLI6PtcZc+cDQLMEYAjADOYzOOOqsa7fk57lG7rN+YsqV2qLpsiFUf6s8seJAjIJUp+kOtrta2VRCrf0+fRHofSlxh4/UKqCzD/hbBELyVzVqIZEcRnByAYoeuLlHD6IHMSXWhFSogQmS6ASHurrUSj+BDH8vnRpUHRd6OF+/iSSDlraQRsuVRCg2wO+LV6Ah3mfoo2RHMWUfG910R9MiYRrQsQQbD6iPuhpkjZuchWZTQGGkirFy5WxHRqmGDtRe/tGuvZ62DuQ2ErRwpVGrR0JBC6Vr2UGvCxRMIB+TJer3fX7nb7TwZ3zZrwxfB646Afgag5ZgB6pE5HEJJhbTWd9x1m9ZVKzdadL5KsqCjHP6AKsRypbl9Qdao0rn+jbWCMlUpWs94TgksaVdm5Hyl3fTWitMapVq+0VSNnI7oUlJPUcPIX/MbJAYPFe5aXbpZG8dep5bMihM5uIpjh1B7lUOVi7+NY8VP+3KfFlO1qbo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(55016002)(38350700002)(38100700002)(36916002)(52116002)(5660300002)(7696005)(4326008)(316002)(186003)(83380400001)(16526019)(558084003)(6916009)(26005)(2906002)(66556008)(54906003)(8936002)(956004)(86362001)(66946007)(66476007)(8676002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IIECeEhJU9fsYJIME1ThR7Ms6Nl/LVDXbTHewxaWDDfp5oDRnrh9ircUMrZn?=
 =?us-ascii?Q?rO0iUG7+rtF1T6WjYaSDUXnJaAPG5Lq9GnJAGfDsC5RUj12GCZxCGZaIgsmR?=
 =?us-ascii?Q?URR+d/2BDDjN5to0xhJWKslx+2+c5WtQ24LRh2FSEG2tPbH2ngs37B1kyXvD?=
 =?us-ascii?Q?8HWIFiIZ2NlQaWvCtvl63F97Ts5g72AskLeM37OnhB2GRZUuFyg3+IyEKp27?=
 =?us-ascii?Q?qmMXqD+uvSZ0v2QcrSS9S+UAeFp9NO4OXFeLN4mdbvhfWSQi9VVKCZ4eban0?=
 =?us-ascii?Q?DCfYbWFFJ0Jw0hIBTVR1BWzUBiu0L7uA5QU1bTOQk3d791UvJbbywuo0toHS?=
 =?us-ascii?Q?T8b+tDu6DqrKrwg3heRMf+WJJ79JJVop/q7zuexyWYALvC19sAFZGyRJ7E4h?=
 =?us-ascii?Q?yUC1PyQ/nw37ioaBQS9JUmiX7cjZRm/T/H6XP9DehtiRYB6Wc7EHL/vWGFKV?=
 =?us-ascii?Q?Ei3cJ+f1ck8XIPguXbsEg0/iqXHuNgPvGUbcZ8JbxPvLNy1VynkiLwySE0xY?=
 =?us-ascii?Q?8mgLp/eIINxV8TzE2k20EZNYydBM/9aRmn0saviF3eDx6VtzFVgo1RZHTNFw?=
 =?us-ascii?Q?wk1+eP9WioL+WhaZHvm+6/nuKi07aqfGnN3c1P3q6rNvJN2+6nGFQuyleNN6?=
 =?us-ascii?Q?uuD+p+RHsmoqPgQb9ZVW19iaF9YOk/yWDVB/dos2brtc/HvuXbTEDNJGBrZK?=
 =?us-ascii?Q?GuONugDExmfmdNoKNIUhb1nvCTlGW+f5pdl6RnaBLXMgrfIpfFT9t7gdQct1?=
 =?us-ascii?Q?4BkYiqE9RztEhJlg3V92VSHmHIHDbRKsD29TNs3mq7dOacPxuTQZNFMCCWf8?=
 =?us-ascii?Q?sk0VKPWtYR9cXz1/U7J0wdSjVJZzyxpiN2rYUoiDtYyNCpAlVvHYM61APS+v?=
 =?us-ascii?Q?QwP4RENi/OvMULdCpHdt00C1Uc/7S/zV0c/qRgTDJ8/rR1Jqpr81So02WZxZ?=
 =?us-ascii?Q?ht8OO/GZYSsPJ58+10ue302nF+1ZHwERsYOo2lbzMT0qF0gwiXNMPdQjE3+G?=
 =?us-ascii?Q?4ekpz/QkdIEvfMVebHqUkNeLDMIpO4qqweE2n7TEtWSkfY0pevIYXuVVsAHO?=
 =?us-ascii?Q?IfVxNXQyzAgCsqI046i7jp3xz/CCZ2QIIDilpCJduUAreEaOo4XqcUI6bKQN?=
 =?us-ascii?Q?M9u4jDxnIZbmhiqlxP5nFPvyClzjN1+BKw1eUn+q52kPSEmPJAA2ynWO1e6F?=
 =?us-ascii?Q?PXLvS2+RMD1EE7pf1BLN9l6yqLxVjXI2kU/7Ie1G9Q2HZmzr+m2Fob/Ijzoj?=
 =?us-ascii?Q?HSwfGiLRu0y4s4CPacIHKmwobFjTsmZSMcLNYHhYhggyDqZJ4XDrpOTA/RD0?=
 =?us-ascii?Q?pNBcE+UfF5iXKJI4bOzJfkS8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91f3fda-2603-4e56-14df-08d932c9248e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:22:53.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFfEb4w5cJDYF3diDN9O+GSdJkzzZED06hXdnIX7sS83xxsxD7QEgO1zLy/XeskiYTRqpSCdZz8K5bo0o+bXOfCJ7yibfA9D6wGDZWZZphc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190010
X-Proofpoint-ORIG-GUID: 0xwE0HJ2s8gzwxZII9JwuSepLAencl9Y
X-Proofpoint-GUID: 0xwE0HJ2s8gzwxZII9JwuSepLAencl9Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> There is a spelling mistake in a efc_log_info message. Fix it.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
