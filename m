Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C314EC46467
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbjALDJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbjALDI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61749146;
        Wed, 11 Jan 2023 19:08:55 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C33WB0006221;
        Thu, 12 Jan 2023 03:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jtUqB2MmXjEwNF+qFeuG06kaHGxGV/qOGjWff30RY0g=;
 b=TrP0o6PtY/1hKhPCduhd26ejcI/cl9ZmWT1xwbILN9uYeiZbMBcN3V5Daj65dk/OMWvq
 QgQWMBKICi0uzBY40pstorc1oCeVWUvDBuf4Csued6o3Y11ZtQOAO4gfZH7z/VxpmLTK
 46d+7W25TnnYj6ZAYJ25WB/Nnd7DkyR1cc2Vy2CwlfgSOed1CVFvaTZSKUIaT9hSDyJd
 4g7vZASeutrZ6hd2SPrUquGScTX/IALA5sDDlxX67nEvUXQ0Zfq/6X+e0JjGUVRZoif2
 LPCcsh9DNSzrNuJANkd7THh72QBB5z4vOYQLLoepM8NN4BZUJ2bhTxuAJlYJVw2Cza39 Ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n25k7gah5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YD034176;
        Thu, 12 Jan 2023 03:08:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOrBrSvaf7b3Tv372uzAchGuiTM/QsTyfkMNCNISEL5/oJbz+XQJtUqIEgxGcGCLvoqBZ1sJ2I0KAl1JRcr2pHfksLQ70E/Ek2Ke4paAln5Cwoyzb7LqzJq/CZNEhgxaZWMTBdtMqDysnyDHopVBDecNoHQXPm+DVmZ7Y1Z3fC1Wm7Zj2Aoi/IxGKA8OTQaeiH0tzzohXsr6ApgNK8L+FFW4gZBb4ISZxa8PYEdf/72io3/Mw36SS/XLkG8mGZ4nj2reAsu5/XzinUUhjwBplc+a/hRNdnb0qL5zmrHOUNu788gc9fmYZxyzkkvpQxi4lvSZwlC/p/9/0+FKanHoTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtUqB2MmXjEwNF+qFeuG06kaHGxGV/qOGjWff30RY0g=;
 b=aa4PrrFgyEYX1an3Pf188nxoJeQ82jEzCafMSIpBIx7U4trcSx+/KmYgx9ukI7KI45x5qaTE/G2bfqKY6FxB624uwGo/wcCJDL25ouP/IJitDten8+KLZipwYcJeC1BT+PJt4xNBwvprjq53e+oPyLLjLTmd0gL8MXg9rxo5r8fMcfA8l86WUpLh8hdKPKldAgGusVuDLb1c4fCW7N8KmqLd6fH3BIrLLULqhwyvkZSRpztloJd2PK6gVPwf8Ihu4ESOO0XLVDouIz0UcT3iSqqryLBGFVdI+RQO58MjD5opeDclllMGW/enceXWPm+YMHqOt88g/j0WPBvGx5imPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtUqB2MmXjEwNF+qFeuG06kaHGxGV/qOGjWff30RY0g=;
 b=zB+2IJv2s4Z/SlelSZ0dwFjtgPifHn5IEvAq/PJ86Pq6N7ekSa88mTKlPR1DxvdMTtATY1LozFYHnx/RRcAXuI12icGfj/N1zM/cBMBbAaPUufSmdJRF6j7X2NnPgKs1hdxbdsZzjaBlEDX8tP2VvA04pTzETurDHmzeM5V8kig=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/13] scsi: target: iscsit: Fix TAS handling during conn cleanup
Date:   Wed, 11 Jan 2023 21:08:25 -0600
Message-Id: <20230112030832.110143-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:610:59::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf9953c-d52a-4893-7400-08daf44a50fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5K1igyhelZTqcAPsrb+yh3y5BneBHjP1S51G31VT3SJ8DH0A8LzEGbuDVPAMq7lK+QDnl1+5cpMmQlJlm0OT5fhZdv3Apeag/WndXTYqCQr0/QSLr7AQEck03qeu+hyS5xe9OxtJxNwBqyXRAPd6Hoz7SV7rqbURntjNCZ4JVYEeE20onPjFlzhfu1yl3HalCGG1xK1kW5zwvrra9Rr8A83oZKEULn7xpanfFK5T22CToYhaPUKNML9Bi1HPPQPgPyBOoycw88d+baq18JKOdhTG53XJ3v0mO4ZcNN5V81Ncsmjr4gGNFk1WtCpebMOnwg7yCZVRdOd96TgZbgQvW7WugqaDtQVideBZY+rVJusY9N8idfyrnzsqg+tYipE/wUOvQ/xsr7MuQgIWweiMNeu9zwRWeFwDVMzYd+xdHCw8V6qoGImRp8RF92SRmDSQ/dpe6+P7PXH02/jvn8gQ3M4lw0To01V2uA3x/rAOpi3tnaEgu8vMlWmfW5CXfcxSXyRU2cjkoSAk50Tgerw7luJYyaccBNPes+c3erukh4hvsFkEIII/SJ13QlvezTPU6JjNEzT1JFTWuujGUCMDc6ycomTdgk6t7Yg7MqJbYof8HIFLHM8AuzLqaw7v0cFyBluyI1j3FmSnQWMePg59A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYVCbDU/mfKaT2ESWz5ef0CXpYUyFy2316VLt4L4ag2wbXs9NF5w1Oc7R+1s?=
 =?us-ascii?Q?IzescdAGcEQhBbJWcQMj7pcWMgmlBCawzI/wSUAu+BR164yhrUmJf7qSepV5?=
 =?us-ascii?Q?MLWIgv+xoNlxDPG7b/ejCy9nWzpFJwzyd4t0/+KO71gGYpSecyMGNwADRdSc?=
 =?us-ascii?Q?QUwfBoO8C6wBJi8tC+WyVfQeksIckeg0ofk4YyvqS1ztLyuUnD0QJvdgu+4b?=
 =?us-ascii?Q?IZpx5vOhMRJueOB8wT5pIzxyuspm7A2sLw3OxEKouvIQjJTx8/cyRQR9UXWc?=
 =?us-ascii?Q?A3uABfbBmJ71vLHlH1hbWv5fhTNM4JD6q4Rzygkf9RpTC/L3PDbeD0oXgWzC?=
 =?us-ascii?Q?5eMgwt20q/4d67JOh+gfjFO/gmyQmPkSOBrsYmgEMMdJriT7MoZNkvpC7rSl?=
 =?us-ascii?Q?dzg6fxw85SXggdYvQIB0h2dfInHgH5PSL91HY0P4C5ll+kUjoIhkQesjDihO?=
 =?us-ascii?Q?8JFxv4ITncgGKZ5DvjT3dQvO8s3Sdu6gZmZuRbd0Ev2eTWN+zJu/3j8eOxSp?=
 =?us-ascii?Q?g0JhtUC8ZkV61sG0Ayw9hWO5fT2Jaiu0UIxtbJWBbUw+MuPv4hjx6RS0a3kQ?=
 =?us-ascii?Q?chxOvRBweO5vk7SCQ3KQUMu9yzCvskBaFatoC68M+U4xuVbn/Jz8f3EXsPf/?=
 =?us-ascii?Q?usH3Sa3bklPWxxH7LYcHDOti6Ej9/8Bs2jhq0EB9pyTtp4vRZ7lLHKXSuG2d?=
 =?us-ascii?Q?AZt0MUOJsGtuuB4pUJpexCyKUuGIA8LwI+KXSkg5+aFAyLBELQUlvTzlbJle?=
 =?us-ascii?Q?kQ4HkT2cNRimCd+tbrL4ndRo9NK4a6l9gTbPZYowR3jXiVVfKLHmgH/4GK+/?=
 =?us-ascii?Q?12pqZumaPHw5zKVOZPnStkL4/u+C7gwK95ks7hYFSqCchd1tzRC8I3pB6E8p?=
 =?us-ascii?Q?VjkvvYcezq5PXyfp7DBzrxO3FA08AZ9Nr+DrpqhEQvEYQ/YNe+2Xldj8zH5s?=
 =?us-ascii?Q?pF/ThMJSKZ+GzVVdJyX54NiUBHmXX5Jib3Uls2/FUIwn5NU3gT7cdt7BHAAK?=
 =?us-ascii?Q?YFrkLpO0DnVu/nPL0Ej+MRVZRN4GuIQFP33v4FkRb3S/PtJGD12T92i6T2t3?=
 =?us-ascii?Q?ng1RSvthzRZ84jknUQpINpLVNkXPOBjJS2qSacaou61Zbtb0WTbR8HoOKuqa?=
 =?us-ascii?Q?3xMPezX8x75l4uQc59tELjSrcbyun+1TYLo9svzhSNXhj2AyeyLGNheldmec?=
 =?us-ascii?Q?gBv4N8svHe+EMd67R17fWgpt7flHbP61cR59vdX8j+KJhaSX5pEWClXyEh+V?=
 =?us-ascii?Q?uRHxsmD0ozzqcQzNn5JZ/otoWxgvVCMGfuQ6VF7pYM1c0FuHzTJMJbCueQCk?=
 =?us-ascii?Q?IGT5fi5m5W81Rwt72qH4lZqizZxwtvQptBaPSotRDsNdassjd/kw2Vs8g8su?=
 =?us-ascii?Q?5GmC7ZPLenLn5FUUFGfdjW5N2iKRhgW8uateKho5GK0ZFHo13uDoCWF23slO?=
 =?us-ascii?Q?L0CLb9Ixg+3umgWJcEEaqgzSTQQsMi0BaoLEB393CnmvldE4jMnzUB7vSKVX?=
 =?us-ascii?Q?eyZfcKkSERxtKoe1apAVcZH+A2uUo5LbBexFD4ZBHbHZnDWuOjwx3AmJ+1bX?=
 =?us-ascii?Q?b7pQW5oMNjY+7rEwf0769L7QQwAb2BiRQOqboifp07XWsCaQwiLTsHqnEPCj?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SzVfpk24/yAp2nJQEZAqSrDZzJQN2k6SmMSm9o/F2fX+zsoklgEyCC/6m9Lonl3rTcXZfPH7zZ+DGldQlbl9/o6mQlSWxeTBEcsy/5Ir8mwWe1KpVkgISxdRQsuC6xMKWOL7A1R1HzNn4ORiXsTaR8BEynecsN4sSgCgVRPqQTC9bLLLZ6OTKRP4ZQ6dHJbCrERhQ1Fwon+ZqrZfr5vTxWaj3e9xGgfr3fc16VTCpr2koB40Wb6P1ZACo0ly5T3Yq71nuQlUrdeh44Z3CJCjkOhClgP98bPxw0W6+q8OAAdelmHbGIa9B7u5P5wY6sQx7bZXjiHdahySIVMXDJwMdgTrO2PCEEh8H/BtsHN7gbLHEgPDkZaNM43vn2OM9OtAjYYhuIFz3Q6yIgob17P+NaooKvHAR3kiJhhPyvSVR4rUQfROuLagRkacI5HJ1LWCWuyIUsD+ZrtiADiQrAUsiggigaHhNjvqIs5Hrmy6Ryo14x+7b6yVrzbF5eHR1JBu4X0WTQgnGJeKaGOd/rGBcU1R+4W9vLW46U9jmxA5SD7Q74DD5keXCtS4MajtiBTaFKTBz7k06GYa/y3UQlz/W0M4rAVj1XmwfMid+FI/qFrTzBqsv3BmKSHvJ70U2d+WBD+/9s6+mIGibrt4wpxYsjXxrpmklzWszaqr7EHqskiANN43+Ssp98iPQUvbNpU5whyvf1kqbdrsZTGeER7QXoH6W9vRD47xw85hEA4cBhldAqOlUZAMeJ9H+1Hf9auzC63TXUeIARHwFZXba6auXAENSqFkgpFyQNaXYke0vZw+iOV5Oo3cGNkL0RewojUbNt7fTc1q2ecFWJlabVCzhOFi3ovJoRLKqtRkw988Qn/qehZ/FAuE21ZH3CX3Tcrg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf9953c-d52a-4893-7400-08daf44a50fd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:45.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvtYRJ80nsU2U9GYxfjb1M2vDfTH74FjN6yhi0LTDRsowOm0nJWuuUcW+5JL96fgeL80XiZ90Q6OwpVcirl9jjNiMt+s/RChA+V7rH0FWuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: HvY1MOV2b891mLmrvasO1aUIjDK8oGZ3
X-Proofpoint-ORIG-GUID: HvY1MOV2b891mLmrvasO1aUIjDK8oGZ3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If CMD_T_TAS is set on the se_cmd we must call iscsit_free_cmd to do the
last put on the cmd and free it, because the connection is down and we
will not up sending the response and doing the put from the normal IO
path. This patch adds a check for CMD_T_TAS in
iscsit_release_commands_from_conn so we now detect this case.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83b007141229..2a011afa6dff 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4222,7 +4222,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 
 		if (se_cmd->se_tfo != NULL) {
 			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (se_cmd->transport_state & CMD_T_ABORTED &&
+			    !(se_cmd->transport_state & CMD_T_TAS)) {
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
-- 
2.31.1

