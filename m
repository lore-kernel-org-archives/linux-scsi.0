Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14935C4167E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 21:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbiKOV3D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKOV2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 16:28:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF9E2639;
        Tue, 15 Nov 2022 13:28:49 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFJXSad016551;
        Tue, 15 Nov 2022 21:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=W6a7W2LymHPQff1DnOb+5dhR9PDMiXFpoN0Q8trv1o4=;
 b=jbbPxIgxyUSDpOsxPXcfDIb1uLl29A7ZJqhb2Q3puhX5MM7zJBKar8R+Ov78RKISeAL7
 oQlou40PGFxjGi6oD8VdAmH5358ZyjAgRoXvquAQQCUKgxkNeaovn1ndhzVXRDJ7tyKl
 ZfBLp8JzWkeQ1D6E9cMVAVPr8ew86vtthnJ/AyEsLqjTyRQ+cC7+VdK64iutR+QD79Ir
 /IAQ7AXoCdDl4vEzwAK2BeZn29Tp5tJDJzi9+lq9lxCa4Fw1NjWGL8bE+Xij1VHN+XP/
 IF4G8KW6R2vp3/oUrcjwv5nWT9u5ds/+iwArWbd7WRYI8916wTTI3LPTVH7EhRnnc6Gc Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv8ykj99h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFL04XZ034817;
        Tue, 15 Nov 2022 21:28:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1x6e5ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N77XTPICrR/YLBWPONisnDSNzu9PhBFkd5/mcvd2l888EUmraOt2/6EItq1xiYV1YuV3LAayzcNdypdobzFqqmLChaGIqOfLQ2xdrIEmzgksiPnjZCp5RYM4SyCR1b/e46QXC8a8IcjoTdsZaIee1ZJDu9qx5KPE3h8+1AYNCWO1zFec+PzfvI0/1mgMWis8MG7LKfUq/1I1LWKkDUt7Hd2UZP88eXaZwoULBj0/3ZGVGxZiwa12z8TC3BbWLf3YtEEGtvPIWlOORRNO981Nu7ZfduNSQtkK+GKUyKkZWiUr1kixlrR30cJxGYpSJ40kVhg0wy4kM4o8s2K/xg5w1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6a7W2LymHPQff1DnOb+5dhR9PDMiXFpoN0Q8trv1o4=;
 b=eYk54DIOwaQpl7jtqlmunsYmc+u1/fFE2iCxSNHECKrK5MehKPstW1yrZPyv11uocqlAkD7e/Srh8gyZ4gzxtN/CF5P2qsE0pmEGbNiT1cNTl+wfo3kK8e404GfJq244iN1mpJUVN80bp2fTFemOnyGgl+DCCtztAsuV7PAoLYnYJAPXl/ApmZiOYGb8anDB5nGly1g5RmQ6g/8S0GjVpIOq9vDcKSzf80ulLgzMzLQwfg6MesNDrHXd5xbjwjfnq5kX92ii4fm3pPgVPRVWyKIFW81AO89gz3xdSNUl7dJmCQt1J6peEXC7Yi95rMGvpthURewvZX94HDAqNIk9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6a7W2LymHPQff1DnOb+5dhR9PDMiXFpoN0Q8trv1o4=;
 b=YPiIniWcYGnxadbb2gTUqPxpctGu+w+ShA2W9R4vSe7XZmuzZvdbe+HfPUGRy+KfBg+7hITePCrYGE58bFTvHx4l3J6WZlun1xTUdz0KbvM5Bkx6AREFX/ru3s5GJNgdgngkrSHDEtc0BZrzl03drm7kOg/sdq3Y+ZYVBrGZbrg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5368.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 21:28:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:28:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 4/4] nvme: Convert NVMe errors to PR errors
Date:   Tue, 15 Nov 2022 15:28:25 -0600
Message-Id: <20221115212825.7945-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115212825.7945-1-michael.christie@oracle.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:610:57::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 6754cb73-1547-4a0c-af8f-08dac750593d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZDsXfhxpBawDVx1WqQCBenxDDb7ll4axMm88/JcGjAG2sQT4E1l4nmy3pOILEV1xxZrOIwhDI0uHTYvfmowjMGE4cxCfvAr2lxUeC21kyLRP6q+yKoGJvu//iBEic7bSqbxLAkjKF9Tch4wOedCyzlbYSBy/5G/ohhcSKqNMF1p5gh0LS7iB96sIEECJQS47Sdb5P+Txv3wWFl7e3YMRmL71p0/C4ZXRUwa+gKcB/c07mnB6OOKdl9Yl0NCdAr0bwTB5eGJD4iM4V9tdSX3JMYRnwbpp5zaojofyou51HGNEi0B8KckYmnSx9FnQMBAxpahrmiKEgGn4DfMUDItrHoI2FUJxpWRjmTe12+OSyp4JDmVRXjZ09MtsovkMtZ+jdF/8AxKQRlJanzFHXDptvqnedztqjPgiGU3a7z48Y2WllTBMNHIfxIYVoPGqmhuwefLFAkc5LJywBpRXl5+1Bq0ErjADSwiay6S5YRho9aMesvKT43fDP7nKoODY87IhKnWtbofOteXnQArhYudNTKYOaz7WpxB4m4znOLpJzICV3djkhK1bXe+aRWfNyYe0Kj6oOu6i+yrZoSo7YK0QyWr9kGAtIfz7eZF26kNxaAP/hK4D3N97TQq9PboJqb2k7slEGR66UEJUujHTWfY2Vv0Q7oz0qz2jQcYomO15syKMJsPLCPaHMbX13C6A3McAn9hSeqdWMLoQ3RitFyOGVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(1076003)(36756003)(83380400001)(6486002)(478600001)(6512007)(6666004)(2616005)(107886003)(6506007)(86362001)(26005)(186003)(38100700002)(8936002)(41300700001)(2906002)(5660300002)(316002)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nw88YcMU79nTF21hvIbYv4dFois3j/1sFm0ibkxcRZbZUd7ROpksHUMHlrGZ?=
 =?us-ascii?Q?qKBInHcLiX13MoW5pNtfOUlkH3MX2TI3j7P5+mlOm5YCLbczNYf2EWJV+sIW?=
 =?us-ascii?Q?OPOUKXg5V7Vvnj/HNwkwNOp/nvMCi4ylESP2W20ApcihVGgs4Y3GVHY0FPuh?=
 =?us-ascii?Q?AtrRGWsSbDPok5qtj3Fi0gFlDYJtDFVHt1el7JedMiDNIRkStoevO+a7un2e?=
 =?us-ascii?Q?MWbqSUBNfzClnNZmgp0Sh1YasUDrpL+6NCLxBmmFGN0KNwaUBw3hrCY7bjl/?=
 =?us-ascii?Q?XG7Xcs4CgC2qQgSoX/kpQ2MLIcz3UT1iLno5SH7xIFxDHVQXPYujADKlwBaO?=
 =?us-ascii?Q?2y4EcjajNiGDte8sS+9j7zr8H3MElrjOhgb9nFH1poYt1Z7NoJfNAYjMcwEH?=
 =?us-ascii?Q?UwpY5oWA57UA/URFUX203kCA0q7+ljBDWFG9hF61Lr0XdHoCKtUCeSDAnLOx?=
 =?us-ascii?Q?1PHVujaODXQmKHA2g0fG93H4amt4ROWbRm+eJHkGb3HRQcNesUbuCchoVbX6?=
 =?us-ascii?Q?kx3yTD+6FCC5GGKjpmECdi/Ywzqg7i2U3BqG56ziKiQSkY1QFTiYGfOi3YQ8?=
 =?us-ascii?Q?F/visbupknn0NPmwiX4YNhxnfOEbbSOyhkLPZBuez4EtuGMEgsb8MjLa/2WW?=
 =?us-ascii?Q?/FS9Umr+9VCzTKj/z972UCJnovk1/uBSV5yLHseM+8EvUCCS2pjlzyCV0k2k?=
 =?us-ascii?Q?fm0k5BdPciRncPw4tD6VTUgePR/0yVVef2L2/blJwsAVIAlnPS+ZDTsx+djQ?=
 =?us-ascii?Q?OCsk9vAp7SRcm6GnbOVoFKOUSW2xmHHAULIGgTwLPBbIFhWyR3FXQseXQpWw?=
 =?us-ascii?Q?RN/lvf7PdM4DE0lkyNO51oCteb4sEFA7YVfCozsfeHgFr+aIYNs1kAXk5APq?=
 =?us-ascii?Q?WKmhipZtl2zWYobjfNKj+IIkm5ek+yydR166+Tp4GfSlVZMPeEklK1Sl2Cms?=
 =?us-ascii?Q?9ZKH74qn0nC/kzVFZ+qEZPgTxu9lll2avlnMvKHukl9YEdFujmJbyi+8YI1o?=
 =?us-ascii?Q?kFP5k+cSTB8vYjqCNfOWg27yrByBpxfsg8+1qUnW3XZuqe1BP6WQibvCvWEh?=
 =?us-ascii?Q?gNqvkIFzGM5KUDJbeeNcc/V/ULhELUAcnJkquHYC96NfJmyyYWYq/g5pC6if?=
 =?us-ascii?Q?mXIKjFz4zq4UNLpa2n7xmf/1vpGDw09Rrzg7HDnreqkiXkyHfoWTJoJ65fqS?=
 =?us-ascii?Q?9gUHoaJmDi5jRq9TI0GkmxvcbYSbFqLAD80rr7o3V96JpUH0rCLTeIWGMi8J?=
 =?us-ascii?Q?TDhzbT5poCeYe+NWVyYKdXUMkMY9iAk2eBtoH2yEfR4e11o4cb4vKeK/fTH8?=
 =?us-ascii?Q?fIpJ65ZfKYxzb81WRJ8VVanuCtOokTJpHwi33MO8z62dxespypKvVIfymh57?=
 =?us-ascii?Q?EO6jxyJUvNuWTNTLCBkYhDIjnnreiwyMIf8NMTbpPuMGAlTklpYT3BdZlYN+?=
 =?us-ascii?Q?Q9BuSk0kn0YljuVfF/ALEXxKquWXGQLdr4DGj7Rfwsh4V/3LuhCVOvc/fJQn?=
 =?us-ascii?Q?P6k1MT+U6x0kdgPNnRYB+bGsPDobdk1hk71ayx135obvL/8Jc3xC37Ue4wpS?=
 =?us-ascii?Q?GzPQM8Gf9SB9rvLzQu0ArLy47YZTHHrysdDf5BXKMocDQmqS1a7T5nGo53mO?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?aTuTfA2tur1613YweLREuVmOpKzm6wRyOw1uSzSojIyS4Ksoqjnzt0oMb2iw?=
 =?us-ascii?Q?rXOF2ipKrOsPemb6SGILBi6TXWAXaXprcEZjvjPliQYKfdV3sZUZ6D2bBAzK?=
 =?us-ascii?Q?QCxcbBRKroW/8AqMP73UjzXPmkr1yDSPa6OrAIbY2cOcLdrNzQ5VjBmsRVmQ?=
 =?us-ascii?Q?ujlPv2vEgkFXp4T8BQg1P9KANNhxXCu3aYn+ydOEXvh3DDEyGrAferx2hPx2?=
 =?us-ascii?Q?kUu0tKC3x756h4iwYTrK00k4k7/VEmFr7hh0ZFV6/TIRgIgbLZlh5kOr6/sK?=
 =?us-ascii?Q?Bk15fT5AaQz9xG1ptvJKnvpS/tFGnZddhcS3FPtKERP3DNBmkVQ8nYlUcIUa?=
 =?us-ascii?Q?I0lWZbhRzAhl2tQbMVlGeABwZRed9rlwS94UQPu9DChJpIJ01lzo8QpPeRUs?=
 =?us-ascii?Q?2tQydLS79oE7ETQ+1gOhboOHzI5CK1iXkE2Kh0mTM5p83awRCV7TE6suaBw7?=
 =?us-ascii?Q?dUuzVtFNGJI7hXp2dIHdDSqCPCCSd8u/Ub5gtwCm8CXRDEJQj/0xkoMvnhj7?=
 =?us-ascii?Q?BF4JP+p3Q8YMTcfNIP9A6Lk3IiRm3VcfcWdPmAcXC6f6yotZASI8crAOGPxL?=
 =?us-ascii?Q?LfENGWlPCs2k8GAlsHFnvlXXG6j6qGI88ng5oOy+KTKxo7LxH7CxYoBvS+Di?=
 =?us-ascii?Q?Du0JNh1C67T8rydBjWqmkMTDSpbsJ1YPVb3OwRcGwMZjiUO2gnLKOqYVhT9O?=
 =?us-ascii?Q?97bv6ZjXDglHyEzNUg35/Pn3vHcRWSKpxwDa57tzYJQbiIVZlUCySULYRs1v?=
 =?us-ascii?Q?mjnPNQg8MRO65b/8ARmhhArvPIwYPRmcZMCXVKejtKizeCOaBKE7eflK5K8c?=
 =?us-ascii?Q?crCE/QCOVss9ybIAaModZgOkLjeXSzXXtzonVf0Qjh9PYJg6Y4y2MV4uqw15?=
 =?us-ascii?Q?k9pxP4vlnDBN/oEeUZYOu1xu5dAiIVkD84hWNayoFlZriBsGS7Ji8poxo8XE?=
 =?us-ascii?Q?pEfSHItMx7Xk/kPAF5EtUwCej/31RfOGJzRohHk/JelIMpykmgIkYqn8o3Tn?=
 =?us-ascii?Q?G/0Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6754cb73-1547-4a0c-af8f-08dac750593d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:28:33.6122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWIHqwEs7W5bfBoPj+Z/BDr3mjOFnuPDumFZQMvstF43GZyj4d/PvFtyPFTaXdaUHdFwWh2aBFl264COJjDXIy30IYjTFM8diXSa8PcuCec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150147
X-Proofpoint-GUID: kY-_N9V5CAxABxwAarLLNntVVVDkeZz8
X-Proofpoint-ORIG-GUID: kY-_N9V5CAxABxwAarLLNntVVVDkeZz8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the NVMe errors we commonly see during PR handling to PR_STS
errors or -Exyz errors. pr_ops callers can then handle scsi and nvme errors
without knowing the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 42 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dc4220600585..811de141a7ee 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2104,11 +2104,43 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
 }
 
+static int nvme_sc_to_pr_err(int nvme_sc)
+{
+	int err;
+
+	if (nvme_is_path_error(nvme_sc))
+		return PR_STS_PATH_FAILED;
+
+	switch (nvme_sc) {
+	case NVME_SC_SUCCESS:
+		err = PR_STS_SUCCESS;
+		break;
+	case NVME_SC_RESERVATION_CONFLICT:
+		err = PR_STS_RESERVATION_CONFLICT;
+		break;
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		err = -EOPNOTSUPP;
+		break;
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		err = -EINVAL;
+		break;
+	default:
+		err = PR_STS_IOERR;
+		break;
+	}
+
+	return err;
+}
+
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 				u64 key, u64 sa_key, u8 op)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
+	int ret;
 
 	put_unaligned_le64(key, &data[0]);
 	put_unaligned_le64(sa_key, &data[8]);
@@ -2118,8 +2150,14 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data);
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-- 
2.25.1

