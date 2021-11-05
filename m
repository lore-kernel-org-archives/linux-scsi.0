Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5E7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D116112D
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhKEWNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 18:13:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17460 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230081AbhKEWNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 18:13:47 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5LllhV024656;
        Fri, 5 Nov 2021 22:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=f7g8tsa9dK5p+O+5X8aOG3EDGw+/YuBUET1VHuW2WhQ=;
 b=LHIktiWPIMXTzJrLatjWelhkEMC5KO2a4QvZMDjoACBzqSYLIqloKQys9meOOYlBuOTh
 +MSJx7ISRFFmIzQBtxHhIhaMwALvWYKPLK5yfrUVfU6Y36XUAf18IDOJTqTrH3SkRZ60
 T1f0y9TUc0pIBcu3nWJU1bf4XYrfBa9pPzXzDKPTY93Vqz1pFg6Sz+UEBKf1MBuhB+99
 AIIazWdgwWtTXC5+hXQhF18s12HOApHhFZtvNhE3UVfsc2P3xZxGHRNJSn4N2/uRe4CD
 2h8B8DM25kNY/0kFF0sINLcNPg4M7JMYd1LA38z8ZiiIxYlkTgGYcCZqhwq/A/Qt7IIu ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7f4ydf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5M1Btp064362;
        Fri, 5 Nov 2021 22:11:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3c4t5dkemt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8mGF1NKndm9eBTR/5ioANkhWdS8Wsem3bNAA9ydsT+ixwM7bTAq29WsO6bdowM02v78nxPQd5aD+aidGBvYMyrnyduvl+ANPUK9OP5/bXnRA8CobWrPd8w2vKft6MmmtsVt49dj4CUT5nkWbitaVxbz3hEE9Hqw/Tp6tt82Ssu/RTJJECOdHl7scPUlp2LRvb8sWkV/6HriS0FvRs5vVoKTWIZuOdb+A3P0Sn0IwZ6XHjSQhsJj3eB7cORKNolW/zng3k5poRJwQeUW3K+Jt2Gx4aR1nriMdtRS97q2Rg9ncuI2jnx1D6nVliudz2Ugq+AYe5iNAnz710pEQOHy1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7g8tsa9dK5p+O+5X8aOG3EDGw+/YuBUET1VHuW2WhQ=;
 b=ikNG421ur1dN+acPmPoyRWUwQ5YW4Es1LuqSjsgpRmcPbfE0qy6vO3Zau1friyt4/zuUoiHE+V6+PZ0zLNfLF8lahfsLwU4xt9xLUbylmz/DxzcZcwF7eoVPHK0j+Z4GF0bBg3rh+P7lzMzs8+mmUCxGUzsJvKoW9hSSHwuR9mWz5EmeF3zpjneJ/FMtfTIhDjIAV99B08wIIa6rZta/GICRRXJIjajo41FPH5hmqyi6xU05n4JPFYVP0gQe2joZ81rN1+fEBm0Jdh8I7zT2zd7CzUnoY57tYskdKYUtiwZ89t3DUDFWrUuxFQK9nVZE5cZ+lWlsnfqNoDIRPkCwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7g8tsa9dK5p+O+5X8aOG3EDGw+/YuBUET1VHuW2WhQ=;
 b=dSIire6q5YvRX7cTclDX7+XMZjCF7fwBlxIJEw2GBMx2OxKnZIVcesZqOe9HthLBl1R1y4/PUHBv16B8FeoWqlBLeyebM6V2Nrtwnmt71UZtsHsXSDQbTDRrSmCQgTkHOa42csORU2r4G4CILOT2CIdZaVHOOw1ySNV+Rro5qoQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2588.namprd10.prod.outlook.com (2603:10b6:5:ba::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Fri, 5 Nov 2021 22:10:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 22:10:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/2] iscsi: Unblock session then wake up error handler
Date:   Fri,  5 Nov 2021 17:10:47 -0500
Message-Id: <20211105221048.6541-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211105221048.6541-1-michael.christie@oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM3PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:0:54::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM3PR11CA0011.namprd11.prod.outlook.com (2603:10b6:0:54::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 22:10:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25c75348-d4fb-4eb1-5162-08d9a0a92482
X-MS-TrafficTypeDiagnostic: DM6PR10MB2588:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2588EF1BA459E548D4D6A179F18E9@DM6PR10MB2588.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmIqG+7hJcrav17y1Rhz2p1BCSCz2xoyr3P5MDBrfuXSHEPdJ9il5gj2JRwtJ29K/n+h9+TrHrEYmPEta0UrBoiEdawtJ8enB6Gpuz/nYhJZxeoKvKhIlC0jjnNGRJALWgbOzB+3X4LCrAts0lRnNM+RcHmBKy9Q6bBu+tyeX/+QiZ3GKZAiPNlaOU0crBXKibD9pSp2vsM5jOdb33w0dI+vpRpUb8dqdtcGzN/ZnoasbgUDvIHaalw+0HmJ3rYvAKRfzQhDFzT5sRqYEzZqmf4D9w5teleKs5y9K9C2qNIQQdZ0rqhixoXSbliIIqjMCCVtRIyq/WQKV2UgZWimONtE1Ur45EYjFmgVC4HkShQ/ct2nbv8oeni0fLmZxJQ7M3YYKmlMh4YJDBZzwv6EHV7IhZ/jAnYMAO55ZsmWZSbdAriv6cEm51fq9lu4Yf/IUIPwaSRazLO3stQjZ28ritZ/Z5k8KOhbZdERtgn8h5KGylFizNj1/NJKMf0vT+5Tx2eRNTXqoOvGKHrWmYr0pIwG0ftz0CcoopUA9w75Ops1z8Lh4eEGdGLRi5WzK1E950NA1JWPC1eBHPqbJGy8fMMlIMiH5G2+wsCKR180ek2eoRNfuctr9YUnF3aRMgumr3FcXNhG1CDp/iw1FC0baOJS/WjhKozzI0d5X0QCYkfLupFXGy4ENBeARqWGENHl6wW22cy7RR8YzJQhzaf/sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(6666004)(107886003)(186003)(26005)(316002)(4326008)(86362001)(8936002)(6486002)(6512007)(8676002)(508600001)(52116002)(956004)(66476007)(66556008)(66946007)(2616005)(5660300002)(2906002)(6506007)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mw8E8FHg4Ry5irbxN+s/pDFIiOP+NyqBsin81GeOGznydtWHpraIS79HKL/1?=
 =?us-ascii?Q?IzOLItmv4pYkCQqYO783J7bip0q83u+nRSCgd5/XYUrVtpFTeWlESKhkEvMt?=
 =?us-ascii?Q?IIkl5UfwSIg4YZAhHHD21t8xafgO6jMCiQVokPvvZ54kz7BkI+2z3CSvliTX?=
 =?us-ascii?Q?e5Ctvcw46cjzulJddvSPgVaNusE4ZMtzTwPZxDtzoZfRVrIGlHUvtZf3BfR+?=
 =?us-ascii?Q?UIHnqKiAeoUfQhCUx/tbzf1iU2OUBj6oc6OJhYsH23vylqXHn783iUxmtwiM?=
 =?us-ascii?Q?ZgKEMJBdpDw8vbUjZsvPnQ/c2L3JNT/+FS1bIMXSHClgJHIeR9yvNFDMnd0Z?=
 =?us-ascii?Q?LJWmI/VXKPA0Oub7cc7BmiAkK1CubgpaeVdUymKgaT4jm8ZcTn8wTdSeXXUD?=
 =?us-ascii?Q?rd9QtUIiidoVZPJj9qKz7toeeC/dxgOuhEl7AWL6wkQdPEgjRsLFa9efuXW0?=
 =?us-ascii?Q?wEB9yz1JiqVg0KRaaJG00Ws6fPR+OcCnIvrf0ebyqlImU79HTyqxHzlb4YA5?=
 =?us-ascii?Q?ePOBkqGMPUaW416uNo6tYI2f0O9KAROmZiHmQMNv3T4FjWSI3ny2dsgmA0XR?=
 =?us-ascii?Q?FTJa3A+6CBSLiqlisGSdjBNCSQynfIknEfYw3ILxUm9k0OPLdzMWuhvzoE8Q?=
 =?us-ascii?Q?dBE/SkK8QY/xLp3dzBWSJ3NxRn259YiP1j5ybhvoZW3Fb+E4tYSbcGdperV2?=
 =?us-ascii?Q?E1fxDLYPqrlMRJDYIkcgS6tzvGb36JS5uZ+WGZoKoqmF83Dwfrc/Pc5nSD2c?=
 =?us-ascii?Q?bOR3MDrK+3WB7OQc2cHe+6VmvupixUij9tu3J4sRBTo8K9DYjzJqPHiqTX0z?=
 =?us-ascii?Q?tq896sM2uorblL2IRmABbf2An1cjSywRv4lMfjOHOZC2s8jria6xOqzWF/2j?=
 =?us-ascii?Q?TmM6k6JJnKHhBDBvAR4nrWRF3zttEuNmf89w1/9Xzlf2Dhy0wScNI7JEiZY/?=
 =?us-ascii?Q?c6zu1L75OAPk7Bd9ix+/5xPlBfvWMk3L4ycUQY6E0bYWwaV+Sbn8m4B9XDx3?=
 =?us-ascii?Q?IBg+xYrMptjKczEBNrFhTtT4deVop9QizuIxRO3mNS6L2L1D9vf9tgQnlR7W?=
 =?us-ascii?Q?EWInF3d3U/ChJrBZVyFY0TNnBmppxodz/X44U1ktRJI9eSStkKEcyomQJBlv?=
 =?us-ascii?Q?EZ4H+oojVCARxJ5c/75symGE1pmEVkorZNDnZLTsa3C+ySiQIVhP0FCtKrsQ?=
 =?us-ascii?Q?edDszPiFkExJHv/1O2OKMDWwzZMjaHQUMsgd2qYf3M6id1N34XoWxaCqCLI6?=
 =?us-ascii?Q?Y4yGiKeGpQf5gODt/t6lCqVaT66gG0h2ZGPp2B/0S6605bd95dw1JBMYGIgZ?=
 =?us-ascii?Q?hS5lPNOE3NgoWtuT925akrg7JrYMqAGetrNUce69t+YlMTMr13vhA+uFFJM1?=
 =?us-ascii?Q?o1z2sTSC7Ya8FVSLQIZHUedTTiSfDQyMaYZ2Gn01l1/KHidPVpJbO9rX4OIB?=
 =?us-ascii?Q?Ao0jfiYg56ylLPRd4KLUvC77nkAiGK0kG2cRISof0AnwLSbUql1K2m7qUziL?=
 =?us-ascii?Q?ePEQZ/goNXrAwlSi1xkvn5dvWmA+aRHGg+zEhg15CqzutPyckd3TAM3A0XKc?=
 =?us-ascii?Q?Wr+KIaKqLEf/dpqdsXHR0b73XDnStu0/ySn7JFtQbPjOT/6NTsYrUK+zTRC5?=
 =?us-ascii?Q?SHDUU22eH2sH3WWciGBk9w2d0naEKsBnHPm26WpUSVWVs9jhTUj7D198IbnK?=
 =?us-ascii?Q?Mknjvw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c75348-d4fb-4eb1-5162-08d9a0a92482
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 22:10:57.3632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6boUHLsVstOFyKC4ZUSNzH+VtN9h4QsYUAEZSwu7SG65cwuCeiOu52FOqSX+Mz+nNUKAoMcudel8K53yX7n0oIBxR8RvchNxMTk2LI/UYLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2588
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050119
X-Proofpoint-ORIG-GUID: AGYcr35PFKkJgdq_CZgEYQEEM1JCg3kE
X-Proofpoint-GUID: AGYcr35PFKkJgdq_CZgEYQEEM1JCg3kE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can race where iscsi_session_recovery_timedout has woken up the error
handler thread and it's now setting the devices to offline, and
session_recovery_timedout's call to scsi_target_unblock is also trying to
set the device's state to transport-offline. We can then get a mix of
states.

For the case where we can't relogin we want the devices to be in
transport-offline so when we have repaired the connection
__iscsi_unblock_session can set the state back to running. So this patch
has us set the device state then call into libiscsi to wake up the error
handler.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 78343d3f9385..554b6f784223 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1899,12 +1899,12 @@ static void session_recovery_timedout(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&session->lock, flags);
 
-	if (session->transport->session_recovery_timedout)
-		session->transport->session_recovery_timedout(session);
-
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
+
+	if (session->transport->session_recovery_timedout)
+		session->transport->session_recovery_timedout(session);
 }
 
 static void __iscsi_unblock_session(struct work_struct *work)
-- 
2.25.1

