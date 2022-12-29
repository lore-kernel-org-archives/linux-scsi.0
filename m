Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53A9C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiL2TEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiL2TE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3814028
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxKkK014126;
        Thu, 29 Dec 2022 19:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=qDpAoZSZUYTJTtgGDuvHqxix/7liyfIdLwc4FvDHUFJBa/W7TaeaLqFj33w2p1OT3Oyv
 UcUq0zW2xaVrTbPYtYpTGh+/M0gMZSYS2vNbVtzHUcLh+2vZPIAxZQNiRCSBr848p0Z7
 kA0S0s1xQ//0QkUmewqQYGrzjg+XtG7f2I/lIvgcfivz8XdWZ0/pbXHK5ZPLppAuJap/
 bHohGOmZpCkyuvvRzytlUeIBYGjAA5lqR5hQj/pWQ9yq3YEkDUMY8pjdAOPXxckw5NXR
 H+yeWcd01t3uROwVrYmgjN+rCQ5OiLZEKJ0IXuHhMaCRlr4je8/1T/z4ZMaN9u9ujs6D sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsaa76sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTH7LYm020403;
        Thu, 29 Dec 2022 19:02:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv77kdj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mq7mzdtF18DsGVrwrZv2vmRXSYgUPFBPG5v+UOI/t3G6Nu4aI/WjxpKeQdl0HP44vbt+q7b0rNt6+eWbrTS4UV2p6L9QRPQFpnXu+b4HfHaY6bXy7h/SEErwxkQhHE7ue7ou2PNWoarCGwslBCjbsao54jClj4bod+FsIg9woyp89iUfys9MFNcu2uZfwrZvpjgyNZlvBJjmYmYz5Co9rwUidnWUsOlN1SO0IgxF6lbmaRaokfPeGYpr+DDotIBDkB++nTux7io+AVH12mj3E9T2Z80uuhf7EJbQ3IuwwqJfNy7Xu+D3dORUKVIX1Hk2ZJO/ACyzGzNVV5t/LhOwGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=NMgv2+VmXzHKrAEMvKjtvCXb1UwTDGXwn15kBsQIzpPP8FWmp8DWYwFxY5jb12SMLSY5haKqzMVKFPLOp+dz4Q1iXCDKYHMqppGZDmbAuQmpH8VmW90tILA+tW0oZrTkX5wSuQ3PC6wVTOPyo+lmQRXkY+0JvaPqtU3QCzemayPt+HSP904CP5vg9TVgRjglJCxS8OFv1pyBADjLIFyKmnSuENiD+X8VhxN01wfWtAdS+BDow/heleytEXDGJ5Qd151ZE96HnATeBqEaj2D1i29ChbzejdIqKJcL6bcEMNTPq5vmatoZmV5zoE/P6o0YuIt7MCYhuQ7/ZtSVOnn++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=twbc9oXs2CP/mabXYDEXEqmkVxl8sWBZh+Oc61ulIXRwnWZfSDPbb5xUNKmsmGWk0IaX+kiVHEmJgVyO4mnzDHtmtYzToIZDa/B4FeL7FpsPtBYp+hj9+pOwwbbvmBWlnDSNnaRrro3/aqsvOk2YHLPVXFVTAsnTqdiYKFX93XQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 10/15] scsi: ses: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:49 -0600
Message-Id: <20221229190154.7467-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:610:58::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ccd92e-1a2d-4868-3ba3-08dae9cf323b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4cqZsa3s5lZkgnUsy7Od6FSzrEyMmlmS9uewiu98nJPJpegGdaT6/aA+J0N4kocIQfA5W8eUkBqcsu4PYCRqRL8HjUsdS+aeO9jr2hP9j14ZrTc6OL9+tsF2YGX6Xzh2h/hkpwWfJjdWNem9oCN97IYQuwYxJ84vy/4/iir7I0oPvA6e4HXB89azze9ilmBOecwzF2jc6LgihjtxhMAHaz3Q1KvWbMzOptm6kUgYiVTuL8L4K6AxJca22KnsvtY6BPlxdH8ipeeeF7imYXpLgBvFlokMhjC6Kf3LiYLaT38TRcA3U6UbGlRfRcH71gzqUHC9XVdlWnj5PrrVbKbH9LMQ4uTZmsF1tkY/7DYbJbzWPukPzrwa9UjeaHhncc1wA0ZcPzCS93lZTBsmOAu+qNaXdHCU7u756fV86omiNPl8qTKm/7aRpUTRH7eZ56iY7maniC9v2Q3lLi4EA+VT7wXxc+cL1D5ej0pWp0ktwOjiA3kgit953+vSBFSHkPyhooohsik9eNAMLvp5reBS7HL4kB5V6QyILVJmu2w1dxPoyqj6sqDWzvyU8ldg8yAmhcQzHkPhpZNrOZfGyqV6ZSPPaqCSGM1erVliMi6DhzbssfBzTwjnUvNpIYET3ViSU5IoLtYgV/Bd40gHVWl0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHdE0ZlN2TsAHvGf/OHoE8hicE8lTmvrCwF5ZDe31HB65B25fKSmOC5kH/5K?=
 =?us-ascii?Q?r5wbd+rZkT10G74zvlhplbSc/TWDlbm52ZfJzNhVaJT6awbZOPhOIu6CcQeW?=
 =?us-ascii?Q?le3Jv79zem27XRe7TYpypRqkjlWPXwPHJnbX/qxaum2SIRBLal/HTK/CpjJ1?=
 =?us-ascii?Q?mJDVitkqNxezuuzJyq/XtxBPbFEboFh/cj1hDKM+YPhrSIYuwwKupSB6HRNk?=
 =?us-ascii?Q?NQ22Pt7/zTBmBVsOGfOT33x3/E0TwTE1LDXNXXhYDgyd49WBO+/i8Q5hG0do?=
 =?us-ascii?Q?maw28+4kiSdaZ1HmDZq673wbPp1qDbwFMqKs9K39FI+2dbnhTbQrupIK1gRn?=
 =?us-ascii?Q?ZZeet9t/1Qf9C1vcoc6NPnE2DdgDyoHmOlwnThYEDaKdhWF4kEAsjlAyahMM?=
 =?us-ascii?Q?TZmYoCKN6CLRhwCNk+Ju6wRsNwrdpo5Gp7LLLNtDXq/stL6aHO/eFhz+XBKb?=
 =?us-ascii?Q?Ly8/Dps8EkFf27vD9M/PwcCNXUyRgYQaTLW9s3gXkehAPEsRIzlKHRXmoTJt?=
 =?us-ascii?Q?WsTEoNdFPMTzDnZ/7HUvexwzAIhpNy1PQ7LipI5jAYF/yQ5/1xz/5JjhkuDB?=
 =?us-ascii?Q?59YphkZGf+OEbSmpkK9uXpplhEFFFeiaoItefyFdMzXOfsykLwCNeR1EOb60?=
 =?us-ascii?Q?nqvJCP7RODHKsTQgcKyQN2mdF+6NYcCWF+Dkmaok6C6Ts5x7NJ8CEZU0fbTA?=
 =?us-ascii?Q?k5L3HFZPXguUkpx7T+i3LxLJ7e0GADvQA4NhfqI04T6WHRWBifJ2pkUYlbE7?=
 =?us-ascii?Q?opY216unZM1T+BDGgP+cpGVQ9L4TdVlj7T/vz2BSEAMN+BDKMiyagARNC4ro?=
 =?us-ascii?Q?E0w7Zi5tcy9BbYmmPwJCpnTgGkWSz5RZbDcg2ANS5lPJdWrSldQjPloGW1lN?=
 =?us-ascii?Q?Fmc0hTpZMDZn997D1QnJSVJMtqXuuwsj/f0j+cRosJXRp6inEqoyor5V79fk?=
 =?us-ascii?Q?ydgAyKNd7EnF9PdVs+3FdPuWFVr8u17oqXTybXbYPBpjvZ3/M9AJkeqWM4Wp?=
 =?us-ascii?Q?wdw6noIFwfLa8kEEL0/dp9nUO7eXJvGKWR8zmI2Jj07JLal/UKzh+TepPXHO?=
 =?us-ascii?Q?ndJVihKOwf4Zd8UPz3LUBTG7TNMefb5k39VIFlnfjUHFKKqJmMJi9hFyC6qz?=
 =?us-ascii?Q?NMw1+J2bT4PeIuKHThLdamswYuMKUYp2eakcTw/a/1Ntvnq4ONF0CwlXGFid?=
 =?us-ascii?Q?/zwDuGKHvlqPsjeFDMkG7WjBpr7HBnEuamyayW10BRE2sFx9TsYDJdenHcLm?=
 =?us-ascii?Q?zGqbCEvq67qc/x4e4JwVk8a174SKc4pM/B2ODHKAxcYdK3aIl9M6tepOkElO?=
 =?us-ascii?Q?xOXFJxCAbHyVC+L9ZrBQT8q/I9QwqHFCBkNfpMvV21ATlODqZXLd4v4SfMPr?=
 =?us-ascii?Q?vJWir+eC5/M8azk81/06W9cEEIQRG6l37OZyf68mzZeDYVElo7Z6KISzCYn4?=
 =?us-ascii?Q?93o5VPttuUG/sKCU1+EsUvtyZ/I1wxugtWfk5adFeNtICK2WcLwOYw/dgnl7?=
 =?us-ascii?Q?6sKLcOCPPiVrpZsBdc29fFnSG4R3ln/3DgEVSwLLHqMYLk4dvOfNZRQNkwsU?=
 =?us-ascii?Q?IFPFL7AgJnetet9DUcPp0QLKrMs8PtYTTVK/qmzl5JVWKga1kaMO2gdcnoO/?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ccd92e-1a2d-4868-3ba3-08dae9cf323b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:13.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uvP5hvskXeU1o0U2ubB741qaaH72e/xvR7stDNGYeRNFoJxHFEgyzR2qRA8KD+L7HYo2cZ4tShsPJDZj+MIGEyB+zFl2vAlgOwavZiARqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-GUID: E2-Uyv8EGBrSZ2id9F2EWKvldXbLwXYq
X-Proofpoint-ORIG-GUID: E2-Uyv8EGBrSZ2id9F2EWKvldXbLwXYq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ses to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ses.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..869ca9c7f23f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -89,10 +89,13 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 	unsigned int retries = SES_RETRIES;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+				       SES_TIMEOUT, 1, &exec_args);
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -130,10 +133,13 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 	struct scsi_sense_hdr sshdr;
 	unsigned int retries = SES_RETRIES;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
+					  bufflen, SES_TIMEOUT, 1, &exec_args);
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

