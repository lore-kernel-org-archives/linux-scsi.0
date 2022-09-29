Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FE7C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiI2CzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiI2CzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB6D3C149
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNif6a020801;
        Thu, 29 Sep 2022 02:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5MISLArN9WKkpB1Nvm+mLGf7XPpCiJsMkWkZsXc3VhE=;
 b=g0Xv/BlK62mWpt1YmSOCvZKd6UuslrDfFzUvrifrl06hcRiwEq8+ebUZ/Z7FFzO3fLDe
 o3Vz3g1njGsw9IUmC1QZfcS5Esrz8b9YsmaQs+DnfadgTzJq9fgEsYkCPVTBaNM4wS+v
 qeu+UmHnTbhtkR3YLWLAyZwtfpctoKnyrDwJjRjSy/kxjJolt+oRH9t7vvKI/XgqM2JR
 iK8Lw2T9lZIbAkmqWaUd3A482O3vPj+TM1xq4L5Xa4PlKVZRnH8TT2W8vydLCUl+VF+w
 6G4tR4xzGcsTYCN9SOZAtd7Fi7nAGyorQ7EdR7z+TlMEBz/G5gsD6ykX+WtMZS8pGz5c Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T0K0uR039524;
        Thu, 29 Sep 2022 02:54:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biyzC+Cqla0SnZIfbGZiEw7dO2NoLlxWXgJ9P/0BEeN28z2vujYkreQZA41CCtfDNYWPs55+9JKbq3/FTflu4cRRIOIbZcRrCPcu5WAIN/9Gidrdqi8yQbP6kfoT29cvbiXvV4+fwWtjS51HRqLJpX1LYC40mrhRLiBIh0GIyN1H/iE6kV+4fNgf777Hoaap8AcstZVWT0bulWFm6Msy911jsGD5EzxJSM2HlYtYLFPbk4+p++i77c8/ro0jnHlvOJBL0/4ty+rXwg5wKdZtG0Uj+G1v3Qoy5mhnRbgv+REpy8KKQTgVvnOhbYExjzT8wslASSCGlDSRzrBRgrG0Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MISLArN9WKkpB1Nvm+mLGf7XPpCiJsMkWkZsXc3VhE=;
 b=c69BEV5Ns08JEJPoFPZ5T5xKBsJBkeOno0vc34OWVq1CvlSpMcSlwTjWDplzoe1Ah/ludt6bYqRT1Ur+SvpaUYEPei7Sg9JTYh7J8MN8Y1rdz8lj6pYN2yGe4UZ+88G4eVtH0r4hiA5IqOX7YAFRrJNahlc7e5jw7af06Si5qeikz+p4JyIlKRnsVPRQmH2lgLNV9lwXuWfBLUsRssLKjTg07dtFtlCZk34o0wktM5aToQKpfVmK0iusftPZ04ZiuFdebs/DRwJWGvNjKarkwU4rDE7P7UQol9LbUDiI80TtzjqQck7v/QILWl54Q40S3U11H47t46toWJnjovwfVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MISLArN9WKkpB1Nvm+mLGf7XPpCiJsMkWkZsXc3VhE=;
 b=TSMR6c/uSZeb/AQDL+7+DHrx0emrsqtC31CV1hLFXYCHdHUOk/Ouc7wB3xpwy1L1ND1k9JOq6uab6TUgHTPQZZq8Qdn1IR5BSFE6I5ryQ3KzLc1R1JnAFDQGLhrqlezZD41VScD3kPjSX/6VDJ7sNFyUhklxV8XPCg0iDiLziPg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 17/35] scsi: ufshcd: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:49 -0500
Message-Id: <20220929025407.119804-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:610:5b::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: eb252cc7-a3ce-4722-a428-08daa1c5f2fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAQhKrpfoDkb3t2S/ObWUrFRk/BNNrELd95XDiKwF9Sq+xLo/XjPPmnNaVxDkHbaPVoHoGu7jPvj3RJ3aVt2wO/y2l3z4McRd7O5U+pb+zHHSV/4FNoTR+w2ZhnlxL1kLU3gyZ9uHVvY6+mE50TQ8Nibui7HCo5f7/sW/J7zm/X/rERBeFmVZ3PGQTd5m9lDOoLA8VkzQYnisFwlyjJzWN0hvd17vpaFqEvlbOKjoLrNghIJw7v6U6euPD9QmCrNe3aWA4StD+sQYMGEKvV/R39XjqjXUsfglBLc9lFCjJI3xuOA0OPAloG4lT0lTXXQ4yIWIyAcQLbo0R2nMn2uNHP12qVFYsWeY2IMSm4JU9H+Ig4JIMo9lpVArWlSCbe6FEkOR+gGsCJzgod/8LEjen8lKet1Gy2Dc1BKSLZbsbFYYpdscrSDPn9Jd20cR9uDOwalbLz+w0m3KF2Kn1z42OMxgohtlqUIAWdyY5FlLPCvQ80eSPgUOSU5UX0SAw5waF+cGzxBuyYmWLX9fhjcwG0v88k29ZsoRg0gvYmshTk0P2S+PaJeMCsC5h+ULl24+VYQdwlpgBAqBLRIOH1w/EyaU482o5IEi0ayMkwb//IpGx3r/57enZhZ4mj8TyNCLU3HP0TdVsx4clAyq6VPZXBA8wftgymbGme+EHU8CpJ/BeSRd4TwQkhjqY1g+yMkmwv2/6ryF5+L8Tf2gpFs1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(4744005)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkrL9BDlV19OlSCQq8QkKalfUYUiLuctCe0zyR+gJKfX+UOyfzSP0Pxrnemj?=
 =?us-ascii?Q?lfYD3XNyFgb22ThOrSKJ1LvWWFCXfuM3459CsIU0mZu2H+75X3PYeVyZvTlN?=
 =?us-ascii?Q?5l3bFoZ/53k3R5KaWxXU9teYXCoNFGQTusWRhB9klhjS7rwkzfFgYRYIC0/R?=
 =?us-ascii?Q?z/6OrLw/8Bsx15F6mKclofFWies/Bwd9KPkBXM6UC+vltqpMiEE/jxrr+dBJ?=
 =?us-ascii?Q?5Cm/CJoeSUAzjKuDPulnAHzY7esAoU9q6R2cS8Ee5aFrFx4TuefDujkOLRrg?=
 =?us-ascii?Q?O9Xs/bqS6YkcofPNfg+jTnT4etPE1b9dZrv909teBXcRHkdZW5x4WaeUQJxU?=
 =?us-ascii?Q?JSGdWJqn+OapWA4E3eFtZxZhRs2vTYxvURinLVJpQtkw+er4I3sAivm+1ZRp?=
 =?us-ascii?Q?qSHIFkk/yTfhN7xX/ZrdkmmT0t7dS4U0T/a3xbprztvMxP3Gzp/y8CsSnSYI?=
 =?us-ascii?Q?rIevIM3+4K/6ZWiX1xVdY2/DIqOcjsZmM/ZqXdgNFc4AntAXtzGd4o5AF25E?=
 =?us-ascii?Q?QDMeyhWFg9dPr9hN3Z6PmqDSO80Wls2mQu4QW2+puKSzuUgHWXcEQYkwrBWZ?=
 =?us-ascii?Q?lgemUq7aaW9hlxoutrS7/RrlXHeOk8C3k33ZECo66qTr0lp9gmMahD0BFszg?=
 =?us-ascii?Q?YuOubyJp5cZONxdIvTaI7pynZbWWb3NbLrEtg+T7VRv7ywT2VJ7ja5BFyVab?=
 =?us-ascii?Q?OdE42TLYYuzcfZB9rK9CA5y2AIkoTAHbsE+Bo57Y1trShNdr4UaeIJiT/7m2?=
 =?us-ascii?Q?0qHZ2ZAMcxy1/U6dTKLDF+5rN1nNFnWS8qiRej63R/U7x6WuzBK6s4xiVW7P?=
 =?us-ascii?Q?HPj8ufKZAWhv6/KCRaIW/LWIQfKi9KwhTsB5F4UNtbkYRFpR0mrb2gwpXK/r?=
 =?us-ascii?Q?7UvgOBSFMq181eneiAiLUkybvD4PPftt6OH4m5ImIALounSmwF+x4kXt7UAC?=
 =?us-ascii?Q?q/snLneGgjlJUrKIUQBji3Df6OB2njNU62jP3xaQPyXeHWemOLnmb3wTGImP?=
 =?us-ascii?Q?7guZptvg3eaa8ttaRggY+mjLmqzjDKHEgNJL3RV6kC+gpv0bURhcr5dX6FL5?=
 =?us-ascii?Q?NSUSJT3dS3pMip7G7WnvXAeynbmiPzz6+VOQOwUXfUaYCRyje/MBOmTXOqQ8?=
 =?us-ascii?Q?XNQilNICndXY3Oif0or5aCluB0PbSOlL1oJy7WTKDsTyiaVu+Kp8jnJFJlQU?=
 =?us-ascii?Q?k2D3vfByycPdX8tmfqNbtTdLMGFVPCJ8cLlF5HIEgAWJQ1XjZbhgVEd7/7s5?=
 =?us-ascii?Q?c6429ZdSEDKTFN6q5+XHMfvSE3BZbbW1Kjlpp1Xjzr+h6cX9I1BZt3B7/NTV?=
 =?us-ascii?Q?8X1CXrQIwWeBFw6Yy0PprO3p1CkV4kpmUA8PLsqdxlJDYETG6XnF4v+UTXwQ?=
 =?us-ascii?Q?B2PdNFVYnaNtVla7RcIwvh2YD4d+S2UM3+prQUFnICkcWZcZeiDnlR2K0b7A?=
 =?us-ascii?Q?s3Dr63TlH0mnHIDagFc0P6DAmchvYbUc6+A2WxYeX6DSiKgMx+rqSLAiOQKd?=
 =?us-ascii?Q?ABd/sHnE3Hqt8Db3WDevTlttnyD6htFMDCW6FW1RVT9XjGd+Ir6cIHMXpMNy?=
 =?us-ascii?Q?H6YDAddpfiJwAcess4HYu+719Z93qIhQEj4wrlEQ07HN/HpOQl8Y94KCDTqB?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb252cc7-a3ce-4722-a428-08daa1c5f2fa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:38.4894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dnj9CNUR7d6nPimikBs2vBiVonen9bIfxd2UiCEZ6qq14Gp50njT2I45uc/F+xNOOvr+Wl7Eud8BbKYG1EaxQo+uYxeDRkZXfUBqRfsYEzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: dj_TVVJr4VjE4PmkksSFJM5fV1n41gPL
X-Proofpoint-GUID: dj_TVVJr4VjE4PmkksSFJM5fV1n41gPL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a202d7d5240d..fdea6809ec5c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8781,8 +8781,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		remaining = deadline - jiffies;
 		if (remaining <= 0)
 			break;
-		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = remaining / HZ,
+					.req_flags = RQF_PM }));
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.25.1

