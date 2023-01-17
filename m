Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1D9C54E76
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 21:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjAQVZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 16:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjAQVRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 16:17:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F08546739
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 11:39:55 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGSh8L018443;
        Tue, 17 Jan 2023 19:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=byFmYIcO+3R1zBepCJBx2j1uYy/T0chFz4oOvHuC53Fg7nmnjiSCPcXSsXZEpjvAakZ9
 heEdmbzny7jYDFilJGA1rqZwDMq0LZe9QWXZdg1mxeu1dJySL9vhn3Gv22zqZrLxVDvL
 eDmYemBViJDDvCmYx/YVV/Nu2BXdBqIzWZO8TvDyYr+oI4hS79/61A8ZH+dWwjFgzyco
 eBcNSW3LCMPLMaXz8Y2B2Me+NwQ4Lw97/cC55lO5+7scnSVvNRS4o2/bdv3A5RbDPE0U
 C5k8ebmmBEOB/g0MgH75fzKNxV6F5uL+TUyDlwScjBoZ6oeKouexDSXJAQhrPSvl7f/3 8A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k6c5rth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 19:39:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30HIYWTf015222;
        Tue, 17 Jan 2023 19:39:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n4rq4shf2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 19:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggmn4oJoY8Uygu2zkKXkp6tckVjlrZlzERovZLyOc+b6A7IWPIMtAdbwbAr6ZZPn43esGn8ZVpgKElrT0srtYzztE60I5oHnyVVzc5e3cwLBJeRLBHlzRESRvyAkjzM7+SfhYWRWbfk/flgHapom+l8L7tpjfHi2aD+wiMStXiObH8s0V2ldrCSZ2gvG6JLxXKgbe6BsrxkPlM5czKvSYiwAv8I6u2S9NNy5mLpIyk2EnE0va/KcP3SyqAPFh0nL0W4tbSvDn7WXyZuhIoszOAuc34A+cqZ5tOVPqPeMwCU3/K0ooqq6z3okRnZthm8JTMJOTfQyAmQICL98JgQ8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=hcpm3cv3p0Xj+YdMMdnPEr8JfZTRKYQVaWQFbXzo7irFQQHy1MVgj94NCM7EX8LkgIAD7dWF8tA+myAaM08r5YSX445P99QQJs3HLB1fUcYZxWB101gHOo5IBLhPiaR2sr6XIJdGehyhFA465JucaGUoFWJlOHkJYE08W0HPGC4UF2UdZl+dZ9Mi5SFuL1Cv4k1JoIG509O/gkSE77azbirridXQdS36nwmIGD5xovVtF7AjZcoycxe4TB4x5N+YOOMTksn/Yk0H3EvfoZk9zNi+ukKN2bsER85vdBPw+g/qz1+Z2aS59d9GJ80joMxhw6mdAKAMQF4YFp1PFDTMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls1Afuk+vREBx4X5LIJCcRdVZS5cGA//lszq4XVSrL0=;
 b=b2DxLxtCANhizjZVN8CGpIiuSdBAd1DazTk8756nMdXG2arBeSQYOMTP8EHxsD71ITDCNLMli3rQfKmZfV99KuVlpQA0NP/peg+rwGoquMURWSXIYPWeVqKNIPfgu3btilq168cvPMafLDuDeVKeh1Bn0W0HSk5PUJXCs6k/vwQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB7222.namprd10.prod.outlook.com (2603:10b6:8:f2::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11; Tue, 17 Jan 2023 19:39:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Tue, 17 Jan 2023
 19:39:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/2] scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress
Date:   Tue, 17 Jan 2023 13:39:37 -0600
Message-Id: <20230117193937.21244-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117193937.21244-1-michael.christie@oracle.com>
References: <20230117193937.21244-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:5:337::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: 300e4cea-7ca1-454c-6eec-08daf8c294c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUkJilUqlpEhU2N5KSXCfebRs+lo+jUptghOXDYEzmPpFizWk1idhDBdXKoR6YeDN8tpapoaqaFWJqkl1FnfG2HGxzR4uu4bFNdOOEO85CSX3wzzoNLsT7QUG9wBOurkvgBpi9tcd49Ag9y79xcKstev2fPG14TnIrAajixb5EYb6yCRgKaZ+grgIeNbf2naCYPGS1Opc6i3QjbriPEKDKCC8aaon+75nPe0lA0qbJN+Shtsw7kNSuhA+BKo8cgUv/ACsNzY+UBb0O/KPbXfTyrs6+Ecc3yOlz/Lqs3FCEEZgd0EUgNQ96+CF+ZMKVGlpygW+N5axhvf0PtjWgsX+4AO0UU7GsI6d8Vz0eo9JjRuUmDaOBYw5tOzKEchEyySkZY2V9QSUEIUsKNIr7Jje7kb5QIBRX1n8szcstQi3nhkP6Y7KTTxLXdgVye4gc9A9LNlwRHcr4SWbOB1q0lsQiq9/TG1fAZqY3FEjpzYBNSeGfZsJotm5ahNQMwHFI1UwNUYuTlzIGNYUGz3Q5seQjJAv/94GKdemGZ7hsb9OL7Pb8pXte7tK4OxbRP2+GgacuouUMhvXSk7z4+8SYNNLaBwaQ8xLajjBZo96QdCRVfAhLt5YurTR8x69jVtEd5zKE4Uawm90ikQBKhfLNleyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(36756003)(83380400001)(107886003)(6506007)(6666004)(5660300002)(6512007)(186003)(2616005)(2906002)(1076003)(86362001)(26005)(38100700002)(316002)(41300700001)(66946007)(8676002)(66556008)(4326008)(478600001)(8936002)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aBQIQswNIAggcMz7BfuGxMCTjVumwkrg5X99qPcyJi8w+EfO3Fuzh9fSaVOy?=
 =?us-ascii?Q?k20tRfri6RV4jrv78Nv/BXUUbljdgHtwtNGLTCjtU/ajWHvG6jWA0HrZuhuI?=
 =?us-ascii?Q?APMIPuoMNS0teS6AQugoAeCnnCOWs0bR9Ye3FoyGn+xK5zHZI2LsXLi933fA?=
 =?us-ascii?Q?iY+zQA8nt8T4HkZJxpxhvldxvy+yQVfexRDxyt2bZGAE4xsXnWq9cIXK9c53?=
 =?us-ascii?Q?MCO/Bxvk7d/x7ZufRqKBEPA06yk6CM+aNgQiFTJZnTHUqZIsg7hBY5uBEeHO?=
 =?us-ascii?Q?1qrQThjk53FO4lESaWr5leNS7arWnyB8NebT80+Q5y3l4kQ3et2WjLhOx7ol?=
 =?us-ascii?Q?yEORGAjRsCObNzmLfq9aAJY94jn2ibGsS/Xh28e2DH9h1S/jOUmW0SNOc28U?=
 =?us-ascii?Q?1W80uLldmHEOHpQvic0pGsRNYpFwyR5aDI28VyqO6kbBkCXfDoqlLj4mR2MR?=
 =?us-ascii?Q?h1fGt/S1XoE+zxWi7hImHNi1p9QJEG550r7V299cE2P0rq1pILzGb5zRzWTk?=
 =?us-ascii?Q?ofTIRB2c8Xsng7U1O4K3KEJY2cNr7KxXMq8/moIbVXnNJIMU+ysktPBrFamg?=
 =?us-ascii?Q?6zYbBmCk80ce+fVYqE8QXl0g0wmFzu9eEuiK7uNo9tZpTNXNOA4h6LPnoF+E?=
 =?us-ascii?Q?/qT9tcYthmReeRPPzHVKcRshIKVNGcGm2f2NTzQ8buJACq7A8wTJbrhGF9FW?=
 =?us-ascii?Q?ca7sUPBds2Ng/NxpKLUIspXTF8F0PUoGTh4OfG4c+DqkV5VFslrHpGjGedf2?=
 =?us-ascii?Q?aVtApqbv2RJvuha1oh+V9jqDc3OyIY/wBc4KvIGXuhHL1zO/YfrTN/zXCj0s?=
 =?us-ascii?Q?ZPTYNSQP1sbplt/xKXIT0rvoYZ0AuztyMQ7ULFJG8su7Id+nDU2UxUkgyoY1?=
 =?us-ascii?Q?NokZPosR7Jw5QT+EePtdVfkwT3+VgkbTfh3qTkMGNNWk8UG4fIckZbv36ByE?=
 =?us-ascii?Q?pnYcecxN1+ZeeFx1hbAPNCUz80Aw88rCZT95v5ra0+tplrbab/Q3U6pc1EBa?=
 =?us-ascii?Q?iSDXQFMI3um7zgoWzomoX6hc4+OMHNfpgJJg9P3HLhnfMPXXbqZZxcA12XCH?=
 =?us-ascii?Q?edqMgAV1MnOWD7Oneocgx4qqnhaNblSiQPKe/ly2LZNdUGQfmZzbZZX1yozX?=
 =?us-ascii?Q?VpHz+ixBOkFsmpXojThspcy7s4lmQgNhmuFFMkTPYwRHD9ajMwP/MPtBQ/PY?=
 =?us-ascii?Q?VyrizeTW4+5CS+aRyvnU7VgxMEmMzFaGEh+R5AcXMmQpRqycX+izbDjJ0bN+?=
 =?us-ascii?Q?IT6CTwL44rNi/kcd69DKXbeUOMaItl/VRz708AAr0PsGvAqro40xggpZNx5C?=
 =?us-ascii?Q?IXoZqjGqOYUw2odSOq5GNSBcazHh9DcJM1P5YcDRtmj936RBBI+u9iBULkbk?=
 =?us-ascii?Q?ZGsgkRWBzltEFJF3UgzVgZreOpYj2c/gsMyB5AigSUtUFKTtwMl0+HBfD5IL?=
 =?us-ascii?Q?WEAfOv9dPqPobZeyZPdSF3BJ8ee4rnzixKGJ63cbdYefdZwfvy+57e27Khxz?=
 =?us-ascii?Q?jjqrpFl/ovb7CjnK2D0Zl0Zt1uTXbeauspC+EQ8TZX3TALpwXEnCKcQExY/N?=
 =?us-ascii?Q?eMjUYAL+vG3+Qsr3uXkC4W9EmLwiTxWlrjkRWDaBcke+ZPgKTxjOSn2DBid8?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WNOo5rj3cDsemVMUN87KBeryLLX0IK18hCb/usgD3MtKBAMVY4umFDBqWzYS1RugKOYnKoYt7opoN5rHwhC9FMc4KFreVlMw4nbWLMnXfeHGI4O3XNNI06z8r+sA7salQaEbXkjzyOAw+K8oUR+Jb6KVrPmdI0BZdphRWxhNEZD4e2NPy8EaWaR24RGX+4tCIzCSrJu1BWyM9/P43tvP4oYAxHnXCZasqTD5ZflzrI4vUuP/3AnWVqJUoXMqtkjR6EkKQXRgIIJJHbw/wxQkDFO38H8JqOWvJt1dNJQumAKREnJaSSvXCJgznB+KM8fefAV+iESI3sWw9flyj8uHVqZLEe34p8FkWSpMRkT8qTY4zLqc39n6Dkvx29qGQhrljCV352FhbPdVzzgVdyjI/TNo1IIsmQK+xT1Z8P6QM1ppShNkoReAzf19BIbWnjj0M87WSOwsr+06R+++f3EQZNb0LzTwbnleGMltB1qdCLPAqovC6lOu1GVgawsJPCzvaNgEvE9LD/g6T2qvAYdan6uMeKuQ+nkWbwtA6GzBT4pm4XA/IuVBhC9rpE55ov8Y5suOQlpZ0TcZ4ZgM1px0TYoAcaCvoxvpwuftCCoPep/tgyeTLmIrwrTjg5+0PWHDb4pGhBz1Kw9B2GPCTA3Sd7ImYDsMDlNkf3oY0KccTmiPYcdYbEEX3ugELVjx7TxEErITEJ6375ZuazC+f22PKNEbkWeGYPvTta8iazZlP6FRjbBRRcpmdAlU6gPMz60r4KJ0FSmNfyF8NDOsGGlQmpYniNTzRf9jVXdtIzaVsQVY+BYeDgQfHQWLTBYNiJAmmgqAiThLFGSRzc62PDzgZ/kCoLVqTxjQS1fs8iUe3Xdg5IWyolEFK27m243/ejgQY6tbpk+yJwSJ5CR0vrsYURb9RKd1aGztfJMbIHRFBtI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300e4cea-7ca1-454c-6eec-08daf8c294c1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:39:43.0957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XYqQKzCJVp4jK2vSUixmSCR3r6RCXi+CaOMlMGn1erW974tgETw9Em0fQFi4/XlW2u9Z/UMBdLcoGCjn79h31dgKNqSkC5hGGHWHnddOLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170157
X-Proofpoint-GUID: ADnd-bhRT-kVuBSeFD-dk6rS9k7xOJUS
X-Proofpoint-ORIG-GUID: ADnd-bhRT-kVuBSeFD-dk6rS9k7xOJUS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If during iscsi_sw_tcp_session_create iscsi_tcp_r2tpool_alloc fails
userspace could be accessing the host's ipaddress attr. If we then
free the session via iscsi_session_teardown while userspace is still
accessing the session we will hit a use after free bug.

This patch has us set the tcp_sw_host->session after we have completed
session creation and can no longer fail.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9c0c8f34ef67..c3ad04ad66e0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -848,7 +848,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -858,6 +858,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -958,11 +959,13 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
-	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->session = session;
 
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
+
+	/* We are now fully setup so expose the session to sysfs. */
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 	return cls_session;
 
 remove_session:
-- 
2.25.1

