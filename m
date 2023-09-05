Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F041CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbjIEXQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbjIEXQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FFD1B6
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385N9cOR017994;
        Tue, 5 Sep 2023 23:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=m/6W3UbOmyxMJyuAbyICvD06uJId5s72vY2s/0gkdS4=;
 b=ipmGERXzNyux/cNQbi2BiWSGUGvkqdJLde/7uB5uAqlE987WOcxHRFYhXv50JUZgf/b6
 x+GS6fZvuhf4hR9hjHSW6cOzjpW2zqmGPyZqqzEia1gusu1RgOWrL11pnpJK7AH/yM5n
 OJ2KyF7HFure5/aeuK1xYYPHcMyJxepZY2lWpg2MyqZJAq92Ssk6hdCQnW7WdhGvxEO/
 h5DlGk5ZPNzfKFlXxop2aeunVSOe6H4RwOFp+djdLjN2pdMu1cpszwiHOoYZ4VHTbm1B
 FkZY4v9EgRrOfHio5+BIA84Sht7k5zMrpk5YIiHuGx9D04UR9I0agQ9viqfX1LYier/i gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdrn008x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MTji6029100;
        Tue, 5 Sep 2023 23:16:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dxtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bW4M66pEXpXIzi5JbSx6a1nkIkey9tSjncKnfRM0R3FnbNOZiJqzuwmJ2UUHp+T9QV1b2FCaJBLT+T5Q64AOfwauxoBiQ7e/kCvQvoAB3diBXghe4WMG9AmVcxCyX/IcL/qe8T/fyLxzoWFvgDcdCB8PX5226kcq+PEhaP0JRTDgPt5uchAaH12A+6R5nUecwJHdLF7bNvPATovQlmhtKE/BSRKcUdR47a6DHEn5PJ9ejb+ZfowIJbEuPjZFn1Xy8UM0U5wE5vYYh1vMtTA3qdLqUvwVdYkH4i1rGfRCQJTzUfxVNZ+OYZ5+WxbbQQm+teMhBgWn5qJ6I6E2RatFFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/6W3UbOmyxMJyuAbyICvD06uJId5s72vY2s/0gkdS4=;
 b=dsO2fXh7+GasXr9wDehAPeD6RNhw+bihN2F6Vvm2xdhchZplBW9iXCJsC7LNy+QmQpv6cIuEhs6maQm0WEpEJezQ2ZPk824uavr6Idp63kbYFGLMupziHLzHZWwAeKkhxiHWt0IwEWlOuJsMDaqxhmjIiN1GCdRvbFOldYp6Gt91xs8noyTM0R0THBlrPxPB+DEffVjceAjsJB5ly3SaHlDKUpCEhTXIJ4bofrwoeUE607baU7dtcbBy8jY+ZP5hxLneea76S7X/oGh+U0AAj+ExMaUypx8bA1ptDP6J6C4c494hnM7BPu99MUeOChBrVkgJb68yIqoW74C7pzNiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/6W3UbOmyxMJyuAbyICvD06uJId5s72vY2s/0gkdS4=;
 b=wn/FoOdMKLYHt3r3e8HEqEB6W90M2IgCZpqXIuSdlB1oB3UkM+7JQhnhroxwu9o3k1tFC7ZY8WbGAyFuwA+gUMIJNoyh5I1FJR+hxBcz7ri4BQPuWSn+mH05MUO8g56HOkbuOY5kO34Cz27Zzrt7Dl4mlKCZCeKN6TF964itPAk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:20 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 16/34] scsi: spi: Fix sshdr use
Date:   Tue,  5 Sep 2023 18:15:29 -0500
Message-Id: <20230905231547.83945-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:5:40::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 530c2e92-f82d-45c8-2d29-08dbae661d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpZIws3tnCr28qivNDgKdPWhTdHfVnt3qO8gqxBTQwX2KgVfPXcnULBuEA2J55YrZDDkY7Z5gC8UXFh4dTKO4xWki59KCPrGB76DfDe5X8sjwp6OF0VTu7XFzlU0AggtZ8N9W7KhS/XJZYzT4B0bUVRwAdO+fK2DCBvnXqxbuWd25ROJkzWSbLiNb3wOye0kAJYu8m3XIvD3XJqm0JQIULy1HbLbUFCRIFd9oxhEUzp18zfpPSey7co/sY00VXB3GFA3d8Z15weoNVaWhKFlH11beoFQ9000oNFnniADRtSGO347XbrjbvUpq6Cc50qcOLMbBRtxdusXd/SCCk2AMkCHwA0cQeyf5y0Fi5ZE9eiVPSGYpWlYw0OshKfJWbsba9+b8kzgUmFxgdGW6kPOL1YMsBcMX46STLe7zHj0hZ3ZvfbpDKdigqHAuhHulx/o1fstY0waVymEaxGjEnMIC9DkHBW0XsGREKPRxv/OdiJejvNS31RUUYbdY1oqyc9saWMfeA1kn4RWALIb6+AstuImt39VaxCTcRSzmxAW7ESMhj7Fi1hmln2ZjjMqP+/z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5DUI4uhmC7WdRUt2XJHha9kM17pbOtxl/y6dbZBSV5MENI3LLLqC7vXsFOje?=
 =?us-ascii?Q?9+Prh6WwSwqkg7gEHPnuQMb0sGxrNQVLLZPnD3bqGQdppYQr2aydAsZxRf+e?=
 =?us-ascii?Q?LaeWNX+yLkFTS3dw2x3BbCgb/5rV+1lcTVJnnCCWi3jEwDJlvBWq56E/NZgF?=
 =?us-ascii?Q?QQFVtGh4XWbM+eEV3zObtZjYy5OMGrZnUuQ3St6L95EHoaGGAV0nDeldFCj2?=
 =?us-ascii?Q?gNRiEf4gkWrZq0gfd++Tmt7xi2U9hzEAgHdCmDSpjlhuiuDafB9IzCgXR2vZ?=
 =?us-ascii?Q?/VMGOwgHZ/tpbs7qOy4bxvXutsCdm3ofNAmauQ7Ui8806DJhGz94jHoMlevk?=
 =?us-ascii?Q?K0zfGdwuxeulWRTcEltbUiQjNktR+S+Ae8cMSRhhhY2fcNxeuIbshvumG3+3?=
 =?us-ascii?Q?KQ8FngWYVlYaAStq2YXVcorbE2sXCgemuoIZNeTHBvcVnWO3ca1qQahzAn1D?=
 =?us-ascii?Q?/hzTQRfKkDOQilXMPixNa3jD2FZV5LuK7DSa+NyRwExEr9ltvFO409VEr2Co?=
 =?us-ascii?Q?P94y4XiwGih7F3DZGr71GP3TQkgEjGNf4Yx5WDW5JSYzXpHwzyr2f4pQLytN?=
 =?us-ascii?Q?VkV5JVBKk5cJ8XZHZwMWePWzjwKCcE0JADKzp0t2e6uTTa+yCaleQS6GJ3K3?=
 =?us-ascii?Q?ouDxS51OfUBlcZm/Xh/wrOvG3qeAjdm9NVxvf6mFDNIBLh0toECMIChFuv9q?=
 =?us-ascii?Q?4z2dRUzXTo6j3S8S4ZPsEhwZq3MlUM6OaItNnlMjEymz7Is6Q9QRk2NnvmrU?=
 =?us-ascii?Q?jfuM3cmFrElDJMZHNpfTDMZZV+J/9zXPfcsD4O4O1jYzOZWvtUVAKvb1PNY8?=
 =?us-ascii?Q?38uzoBN+3/MxmU67uRxbCmj8F+5xTZJ3WHCQhffdCtFUAXKu5aYKhqmhJBgp?=
 =?us-ascii?Q?kaXeExD0B20Y6lRCeWIVsZ+9gqmaOoqwLQp0JmfVYfAptFXaDBZ5ETwLl2px?=
 =?us-ascii?Q?CnheLvSJgJN++vLKU4bmY9ruZjzLtZDVVsB3uEdB1c4nKiEOgVpoGFj4yVJG?=
 =?us-ascii?Q?yuun/0Sc4oXrAs2CxRYpasKNsXwGc3qmaBS4r2Qqc594HmHqZLkBArJ37gRI?=
 =?us-ascii?Q?U6eput4NJ9svzCE0mO1qo0D+NpY2aX0GxkuUhanZ/cMEDAIbAPespAKKpyuH?=
 =?us-ascii?Q?hxjnQAcAyZg5/xgz81ZrgDjCFq4tHU24UJ02xgGym3U49Yu81YrK6FTGYqGI?=
 =?us-ascii?Q?ywzwk2Rai13l7YPD5DKqXpD3x3xdzzyjc9SVIHDaAij6LLGQSBlE3d3K0QiU?=
 =?us-ascii?Q?Rk8ynRuf5nSjwxxULVa7kzY7VRuLLunpCWrvfwcMwdgye4vVB7iEltaEpXCK?=
 =?us-ascii?Q?Taz9drkdIZf3/BCfSIGAOIttipBfhmKrplfvIMXaKOQs+4J7JA92xfpJy81k?=
 =?us-ascii?Q?VX8h2+esOjCcZXh+cb4bwTRdX/5zbDaYVdTWTIsUxp3ai3OMvF0Fc7qthRSp?=
 =?us-ascii?Q?WNoa7PHem3JIUE0m/wTLexCGV5P5upd/MHzx7UdiTDIWEfdGeq1A6lEZdEpy?=
 =?us-ascii?Q?V5Dnqhynp/CWHst7gOXufwtG5XKBy9+GbcUdnGRvjCorQt8pYpyplrqpsRwk?=
 =?us-ascii?Q?vmBStzYPpP1nbkjOP63UBH2DuOXnL4r+6M1LvBTEfN90bzAQjRfZ/Hc9TdQC?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dY4DEKftJxD9MdRIebhrQOR2aXv8ChiRv4iKqmDw15jPhDo7b2j5mC2msakf9uaMTxG9g8RVqLI0ixP6xxjTvTb6LfWc2pGzniWYg7Ub0RRS06rVdm7ZTOGHVbMmKS61Nbj8LJu7R+nuY12JhJrTk6M8ZW5SrgtRvp+L28EnpZ1kErXDDT03r2YJnDQfCf2YTltjdkST6i7gUT7dTdivmPkFMUXbytK2f7rM8ant9UsWNO+fQ7x/2uZLxnWBaxAmy/f9w8Vvq6+pfjo2IOGoA6tGVWnC1kQe8r2qdj1fqBYH0Jrue8STg7JTH1FmfUZ4jKH2FGdn//sR/Qgn8HsTyO9FEZzmHsIeRCAFfB5I//as2cP10vcGfuhTRcJyZqYauYPu67faW+CqoYYI39S7LH7NftK0RBEV/YUfP6b0NaPJaf8W4CK8QyeEIgCCxGSwoArU5VM1BcHxFIMoKGTRj0HUE9hu4VGOYGf/ZhTPZuzUBfuVrwsQjuPQILVzrukRFwuF5mpNGfmTj8f7mEAP6ku4b+hdFn1RD9qQnJ3I8Wtevp3BuZ+3IB+04gL1UjRd7o9++U5nxqw+sgyqb4Meh82jQsXQwIasz33yOEkcKEUT0NTCnutMDblekzRVSO0m7aS9JOMJhzAH7u3yrKYo3AxmoySg2Qe4q8BB66PbzVAYVEJ2gjXwPSL5dSth9uuRlVunWccpoV0f14yG5nEeDbtckHsBtnXIRpm3+E3ZTW6l3rkxF4a20g7LR9NxD4V0RdpbR9+1T+Cl+SCQZTS2SvvNh0t7/giX5LQDfBzQFv3ssz/IjivSxWbZtht4qlB7mWT9aFHQ11A024Q7rCNhm0M5PdUF4UsBts58aiBTkbH5FTT+/nl6q32kE5yCHn2h
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 530c2e92-f82d-45c8-2d29-08dbae661d78
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:20.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUsODwfXqS/WJ+bFDUcBJfBoS3fHhCaTMeUohKdj2yR5jE69A/bIN7f1FuPHJBOLHZsuwOijcE4tbZLUja3j/XRVwiMjNvmUiObwwlPPwFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: 2S1OgNSAadMhYDpD_kuIGgWPAznej7XZ
X-Proofpoint-ORIG-GUID: 2S1OgNSAadMhYDpD_kuIGgWPAznej7XZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..f668c1c0a98f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.34.1

