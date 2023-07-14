Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449E3EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGNVhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjGNVhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92C33588
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4XJF019325;
        Fri, 14 Jul 2023 21:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=39561NT93TtshZ+e8b4H+vye+D1uuCaaXYP6WMQiQL0=;
 b=0Y1CXCgcpOQBmL0fQsQZFDZOcwIr6fwWC6dKILPrxVEi9vBLlkbMAQ1o+QOHltRP2slx
 y3qCEPUtrid/TXnB0XCbgo3Yz9ZF9sXyrlF2agd/p2XDeuPDzw0/K7iUajDuGvUQWXaW
 ESvArsQ1wk55rxFVz/4Wf/g/8uwcrqhkLVeZbF5dNU8S8TC4d/4KxOSWXXfL+CGjQArc
 WqyuRI1YqNFlJ7W2DLEycA7R+18xZuq5YKMPBBJmDnsjMoHVk9N+4j2z850iFCMWh3fB
 H7Mr8ci8pupb4Ck3CaoDRhfZkoPOhffxAyBDV+038xuRdro0FHWQFlKc8wthWrxcPE32 PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttjfgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJuqFY023540;
        Fri, 14 Jul 2023 21:34:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxsd0q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAmLepOETv3azXXIPvU5qZpxTiNsP5Lmr6vMJIHOJg7lF4WWTEbps5ssXyhOvYGZEkztbKXTQSyXndsjfheLT0RN9JyK7u3fQQEhjzdYusCavF3LmthDZtu6nd3+9jn4aJl54Qyxtz2A+2n43rYRHayeHtRjp8pglBkFsul+ELfCcq61p/BRmaJ0WZNEeKsi4BLnnaBQ4NNMbe2hOD/hbo9tkXybGL//F0WEkEebkfg+TiOaBxtvhwGTSSYo4HyNgbNNYfpq3lG9UAGyuKgHIzOPEWBkLCwc3nyqrB9YBrtgeO3S4MKlUkf1vk9zGipsz2iQU+7DZQGIFUlmQs4ixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39561NT93TtshZ+e8b4H+vye+D1uuCaaXYP6WMQiQL0=;
 b=D2cdAh/OeM9ar88sXSdrSKxtoTsdHRejsNwNmVPWMXRkeOyNrsSWwRBq6lxQHTuF1VUHobmUErzXFYIRYgHQKsuq5+L4CNoLgUKic8LhXSN8JLtPWoL9on6Ei3bCjhNF4xpWN2GZNVGH2MQtnmC1iEQsXQswSOqVyKNIRpXxHrE1emwqgbvzsYuMSYIZMyXVKyNtWS5chfK5V7mrzwGghoFapjluQsgTb6O5AojXbR+KQl1Yigwha+XNa0MQJtlak7OUF+a0orukARh8JiN/iTLu3BHKFsdXHZXVaYeWmAR7lpD30HptGkeqzUsua/1xzT+oZ/joXNOkENs2aHw0lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39561NT93TtshZ+e8b4H+vye+D1uuCaaXYP6WMQiQL0=;
 b=Y+JfAtSM1TOAb0wNjTc2Nl1GhMUh9ubDzTpklFI8oUHjS5wgG4cTOPlT/pmxoZyQbzyWl9CwfVSDqBQRosYr8uw9LoAgwfQKIr0t2y8rH+qpyhNY5ODCRBiUzVaCwkDbVh7oyoPzvB9jsU4pYlT53KvprAXY+w41CY1ShF2BrJY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 06/33] scsi: sd: Fix sshdr use in read_capacity_16
Date:   Fri, 14 Jul 2023 16:33:52 -0500
Message-Id: <20230714213419.95492-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:8:191::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d767aaa-18a2-47ef-2b11-08db84b21c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWxwSj9b7ZhEwjKM+Hz1CCPsBzvYKCOZQu26Dfr6xFQJbKd2gbI+hL9Kif51FvrnmP9aKmdnU7Lhl99SHYWr7nNj0Uhr0JbB9sq40DEJ9JF7ASHi3wKupi57IvZb7QCIl1tBiAbxHXDayC4Br7bcJFJ4ADp75V5jF88XQ/3aP84XtzG6J6xmvxmnvX+4GioMYC+hREElzU4m0DWdPQcRd9EIL3LdO8++/H9XcrLDpoH9foDkbUkhMxenEar4r2SSp7T4mBzgwIw2YgC3MqvAY4MCZInE0WTzzki2c1GY4U3+M/dZ2eq/tkR1LeHMQ2DRPueNnxxhosLqLFis7zbyzQ1qKYhhzgfUFgJTns0vLbVOvd7LZM/MXcpXe8AiITK1eWWRgbe7w9iPZFzmU4/SICsyzpOq5vdfds1W9RwGnj/KwozSi2D5G6XVOh23f+vcKvborgSOpD6hymudospnthZh04NFCx9R2m/6Jhu/WKaOhbofpxVxkL7+LrFyZ/o2fJ+ZADUbyIpPKlNibYjdWnYNtA1GQHX4kwEOtIStHgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(83380400001)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtC0+l1yDY2+z8F4k6PvAM/pGe9hYYzUskbl+qtu3kR6Qi4QIosUFR4OTD5a?=
 =?us-ascii?Q?yRpUmgcP9UxGAaTXiZIB8UT7fh6FHO7e3CvTmX41I5GkGrCy+2Bu6ZmkWZHA?=
 =?us-ascii?Q?7pmLYtvsvKn65EbxpYspnvDbf7DD7M0l6jq2S4IlqMkuA1icijqp3Ods4nR5?=
 =?us-ascii?Q?rDE4LbOTxlERC1DFmotcCY2urBBMfIIKVSoqeYoA2DBl9Pu3ZRN5bR+I2Yu/?=
 =?us-ascii?Q?ekau+lk+PUP8C78zjx5jpV4DMVdRqFZ7OBGe0T7wu729BKq33L8cIu+67QxD?=
 =?us-ascii?Q?4P9XrY9nHsn6YP1y4DPnaWyWGtHyUMLCaxj78JIUm7qQQ4DzkOZ0vO50Y+vt?=
 =?us-ascii?Q?Wh/YEmhk3QCZb2SRHFR6aOvMyZbvhCZEvuIGhKP5Z8YP4k+VSV0Ia+B0xBl6?=
 =?us-ascii?Q?A2aesZOnYDVktOdzeP6ORrf7YeFV9E8KEyYGbI17JXVBaiOPA4l/TyBWSmoS?=
 =?us-ascii?Q?vfki3UpCZsWzq11Rn7q6aFZ5fChZhqtptGjKVCpbx+u4bWxHYzbVFrKYFQON?=
 =?us-ascii?Q?HVohV5Z5vBePn2pTp/thja8nv2AwVYpdaynASWuhN/fXsgFxQfNlF9dg2tkR?=
 =?us-ascii?Q?YTrM2McAY1lCO+iOdxuhD86lhrZbjbxeeABCuqLZ0VVeVJIZjqPuijdPfgoD?=
 =?us-ascii?Q?sDmuP4Tx/rXgjOzmB1/xFFhx4yhhbaxs4jS8A1lkRHmVCFLflzS/KyrpdOVO?=
 =?us-ascii?Q?y66kikoObJzyN/F2ulc7h1tR5JjztAaU376xR3myWpOjsFuadbEbwLNyuY5A?=
 =?us-ascii?Q?HBBOeuGmYAxSBfs2uuOKeTp0cKo27PVQUDeVaW3cIlCibA7iI92sbeLemKEl?=
 =?us-ascii?Q?t4oapMSqDM6LVO1cxFNDlonySlZhNuLlt143B2HprQyVcpP/iFRa6KOhtaBs?=
 =?us-ascii?Q?vdorvR1/1yAlI9hDKiMIlbudaNHYbePLAK02IG2zDv9ujL4SghXx23cyIJ9o?=
 =?us-ascii?Q?JrxQ+iKknJRqykC6yMPpf5LUtgG1IyEBPHG3uYONdK8IjCLu/hO3RN+oIeMJ?=
 =?us-ascii?Q?E88M8U/iG2tk3AECPVSVsBjkHmKuBU2P9X3TB8qsG6WA4O4M5P3bA6F32BLM?=
 =?us-ascii?Q?WuYJ0UfRPgHaWVdjYG4vE+/BHv6CwqpDXFgsIvDRYf1s4vnWGVce/+Bkf3Jg?=
 =?us-ascii?Q?fssuEjPBzmkBGtnt/Q2FJJgbn2Ok7OVnkZCQRBugk5XIACjWh8l81M9oZl+w?=
 =?us-ascii?Q?zxEqdfKq+DRAJvCxEtfBYWgUw9ed1gs/VsxCVV1Zqof+gNJwPqkCxmb08xLj?=
 =?us-ascii?Q?5Cu3XwTsUW6ipL6pOSIPM1BfPMAIynyOoBiGwwYaxdhsNZMh3ME4rGlR4YJJ?=
 =?us-ascii?Q?JURqDMAyhnQrhk55SBL/EpvYPbZQYLk9Hz2x8rLe8lcXXuy+OIKjFFF0CYfY?=
 =?us-ascii?Q?4EuK712MNfPIwv7Rj9OoND+qI4SueOcrWUCWVg2idTzT7jTGL58az26LjSiE?=
 =?us-ascii?Q?GZ2CV4CHhSVM4RPf1aCHf6S/SZCyY3VwsMagFfu1Q66NGf6NsT22XmuSuN/5?=
 =?us-ascii?Q?eMrIcQEeAkjNMf+E51M4u9mK6p4YGDuqcy0Vmd0/TiGVr6/P/YWiprbhbsl+?=
 =?us-ascii?Q?DmWj+wMVzr82T4/BjRh/Qx7I9GzTuegt+4/tk13yAxsD8i+rchdPXaqgRgtK?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YG7iu2K440qSnKl1E+bHnJnLpha1VyaBJuEA3+KKU3X2pyVsVflFy/eN5knoH0dWiYHnV8g1+qx24uWYSk5WqpcI3U4QvUunGR60HBVn1rDWun6JuTVwEE96nzxEfD3noX9/UqwxDAlvqXkMaCPxNr/m9Croo/bKstxjEKiBvKVgHN+yvA3RhadAMxDRk+0l6srkYW5RFETb9LdVtkA3OLk0tNmwAY2lov+CRYuPSlMG1qMLygwp2XX+mUjgYseIKdQ/Osu0EHpaMgJF+jEkl7mHp+W6+TR8oNtB6qrK93xw5RM3a9JJ8Z9pojWTx/htjPVupWZGp5kxw2/QNY2w72Vj+3sR4l1Q5hsSzjjHtRcNtjMN+29+5zdrRyqcx0CATqXhSB5k35U/DjaulRZw7Je+vBsaldCu64DZz+O46/NTErUBtUMK+OILx29F6kh1QTpQwkg+ZYQjy7tWu6CTbZPBf2ia+VuRhOqKNBCwxXZpIJ/J9kRMjlxGAehCtCeEPuUj34FNxEdT68QpdRlvSUy74r+IxoDIUgT+BC9P+Xu2GTy2vsKRNZsVA6xU0peLMVo2ihTuUaXIQQZPLP2L+1swcOMBC7DRbmdH6bySk/0VWznGZoB8dQQLJBUBsFqm/n7NYNhGSmmgbAk8aGOt3/iyKHeqSnqPBRt9WqMusaOksD6lg8ReZhKwJ+WblTAnG3hYQ2eRbZwTn0awxXZbxFwcjmBPXbAz/LYpKPqgXnhz7Fu0i/gQfXh0tnXqz6yCg4s2jGCxZHQJQz0zMf5+dWSKYP/qJsjPhYEVqQ6nq1L0jomUeZWalL+WdN5exv2wRSrObxO869FhjbdsrkIKq6NPBL/pONJfpZsdkdsHfkqwChHrpO0ywhTfg8h1RouQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d767aaa-18a2-47ef-2b11-08db84b21c6f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:32.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpORLISgQC4bIwbFtD+jurdu9Dn//Z0I4vJcft6AVPcoSQFFw0+yImjNe1A+G8gAPvvcrrLgPWrv41dMMd9+MAJlCxEeEMqfGR+zhNbeqkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: nNQkBCGFbBij245dPb9eWJh3r1RI4xZo
X-Proofpoint-GUID: nNQkBCGFbBij245dPb9eWJh3r1RI4xZo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 68b12afa0721..755b09beff2a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2427,11 +2427,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
 					      sdkp->max_retries, &exec_args);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
-
 		if (the_result > 0) {
+			if (media_not_present(sdkp, &sshdr))
+				return -ENODEV;
+
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
-- 
2.34.1

