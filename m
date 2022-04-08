Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F090AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiDHAPn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiDHAPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC89E6175
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237KMSco006371;
        Fri, 8 Apr 2022 00:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6pf0PAs5kacWp9T2pDllsVAXS3+UU6F9DKke0zn6yJs=;
 b=tXUrPX5h0b+Vms/xKhK5eGXMB25C962oMmh7mAhyIAYESWxBYI8R64rk60jyT/3IGDVp
 PyQCJuLT0V3IUtFVj3b1d2oK0sqbAH3wX+3ZGMtLSNY/2pqFZ+TIHJklY4nVo/mmFyH4
 lHja3AH1DkjVmo/aJ1r5P0tshOQzqcK4l1TrqbaN0WBWo1YYt1LBRnbL4DtmAGC6hGbc
 59O4HCVi4XXJuNwkbNA3OnN/QJe02huB1ig5lF1YtRFZKU+2GM5gQ6rRvPxEzywAM+nJ
 vHW2amC5tjutjohngac6Ghzu0Y8FKiSRN6HGF+bSI/yOAW4RtMV8im4flVWdyjVR1yq+ FA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31nh87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHDx013838;
        Fri, 8 Apr 2022 00:13:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewlu7Npuv5nDB3zQVHs8ut3tFE6KTjyx9csLfq4iB0Z78AGD4MgGikmODZsiuYDip+2yiFrRr+N1gP80P2pcpaCdSyyPIe5JKo5IKVPCsGJJl2q0U3J9633xo7CwwvR0y9rw9Q0ygLMXcVWr7XYassY22KkmApx85WPhqCFj/eiZSqq5SLrNUjhd+5QwVp6+vOBJFgD50chj+B8fciTDwENxYghs09T7ZEZq9xcHUANrmwB/1Edwjxrq71BKm96AJXr4iAJO0NsdhNchQu0L+5w3+Mx/Ox/bIV6v+DVnFTOlDHlGOMdtIX1sFt+HTcXZB2xr8YL+z9LzCIsHH99EBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pf0PAs5kacWp9T2pDllsVAXS3+UU6F9DKke0zn6yJs=;
 b=VoF0+mRN8Qvj36o94Tlsh+/vYZ8mfpe6gKxxnxO5/KMqWUh7PEtiXjZEL6Xki3XRMymB3ZVlNMPI3PUqtNqjjoSgAERdeVNWrzWqH2c/WdMsstYd2UVWJeQOoMl7wgutpCDYAhs/7PRtQIfp9ZPZkvbVxEGJp43lRD0gRsIlbiv1yfq0GBRuxF3TBAsD2dEqxiE8MaK6I4Q8UtJ3kYgVmmVZ+JxSrnM5V7xTQB4layUV1lz3jbukkefF4OMgG884vagsq3cjx4qVWIYVkZ4m9za0WQEKteXHd47NI2i7IF6rEFrOAtJ40fe06FEh8kpwiFdw9lO3ta7DYXwT3jEWBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pf0PAs5kacWp9T2pDllsVAXS3+UU6F9DKke0zn6yJs=;
 b=YooQWNhldxkStZK/X6SDp3AOLVoVyEqdy0ZsyFBoBavsFOgkYDw2p6Xy2eHJA6sVO3DaKboagEW48650oP+RtpSz68tYHaY20reLdnp+hs7Z3iPrsw0EOZYyGR5eLaTCX0IyCSJY1CCs0oD9EAHS4fYugACT3xeWLaPwJAEJKLs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 00/10] iscsi fixes
Date:   Thu,  7 Apr 2022 19:13:04 -0500
Message-Id: <20220408001314.5014-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49672bc1-37bb-4020-11db-08da18f497c1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5550B642C0E1FA168B0C8BD9F1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HzuUcUXpcw7BQ6pE8LDuYybdllH0vaEfkLRocb0ZEfrA3XmnD8N9SjbL129yqv57djyhPX5yD4VGBMYVlCoe6z1EzbLpOkWZizx/N43ULaRXp/xGgE71DBwXBan310ByK+CbAfB6bDNepiLL204yVQl8cF7q0gzwT8Jb5WUAyhPTWS2fIv/SASLEEGnf4KL42Y+XYtYX7s1GDdV0Dp/Pv2FUQTVCEQT8QlhZlmiSe2KgSaMOT8zjY4qfXMrE9UETcS9qknh5rRFoLIYRhWXxX0mRgZ00fYE7jekRHs2lXDYC5YlWbXu8Dx6M7/u2eK/Ud6mPvdNoYycDLQPg8Zl1MuRkCvdkZRv7vz0QQ5UxaGeUEwx3AGYZawz+e43Vd4scXQaDrgCO5eHPOrGjvr2t0XMjvFwDRCis0Xk1wXz9+lfBPeXkD4zpX2kS52k+raDUkFBRLhLPAqB/2LmkdU8Oqu0B7ifoDj3sgrD85LXN9BlQSMNbl8mOTl7GxLetYu2fY9qTp15A2RHMK1pF0DnAEgiaF03YGEBLuh//PoSD8LeCmCOgJTA9e5cUyHGnGPIvZaVT/Y47BDR9Poe4nMYQhkZugf653f8xrJ/wK4680j0Xcs0Jp5UYyB13NH1q4DYR9pqNRGvFWFQoomPQYAQf3aTUSFIG+M5NTcBPBajArizANGEWfn3xqm/wE8VHs4H96kYSAjiRh0NnOvOXe1cVEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(36756003)(38350700002)(508600001)(38100700002)(52116002)(66556008)(2906002)(66946007)(558084003)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2zFlgI3eAKbGlT5wuccd1IpV1Q6zBJzrX/UOiQRCI2CM4TPzZaZRYKIsbVkC?=
 =?us-ascii?Q?70FH6RfPn9nH3pgC4wQ98gj0c1SoEG9P6Jyov39GDayMcfdlZKJ2NmRgjySK?=
 =?us-ascii?Q?3Zw2Kyygnz0aVg282s+wKlt1zb8yntHEHeO0r/whqz9vnMW/mxd/eVIe7+Ey?=
 =?us-ascii?Q?3MFw2P08us6IURIKtzF88/9Pu1Elq220tk7yDo/ngYxMz+ynghIk6DozilXS?=
 =?us-ascii?Q?+AL2D6+etvOPWB3t8QUtYGhQhyXczRAkbidnH7I/2ZBZLB6Igtwh8wnrSh02?=
 =?us-ascii?Q?G+3rnqiUrhv2uksu/74mniN7yIJ9WClNgoZyxDcyvacWjtVfZoXU1iQX8yRQ?=
 =?us-ascii?Q?CO3Fp407gFk/8CF3rwPP2l44d2Q7HBH5CFL+7IsuYlHWiUQSBvDOkk/tWqkv?=
 =?us-ascii?Q?b1G4RTqpgBLOcbh0dJ7M6SWixXZaFHwUnxjW6DGRd+vsFvQSPwLoebN2FpKj?=
 =?us-ascii?Q?J5+y2NH6CPpACPKTom25s5ZlFdMnxSEGuoAq3kXte3etTNtJFw6o9HkIm6IS?=
 =?us-ascii?Q?Nvow53vjjYUbaew55SN0v7w+5sc2wZLo1cUDcatGDA6QLLKgj3mhKJmZsIW8?=
 =?us-ascii?Q?3NKg61F68fUq+XKcBYktwZP+MnyKTYn2MPErQcEftmkzdXgO6+6b5a+vIO2L?=
 =?us-ascii?Q?6lImoLJ1flFzUklD7M55WHxh1TPGXqUkBzjgNtJsDSzLzhhulRMwI848fvIo?=
 =?us-ascii?Q?ZaI2s7XFE7UZoTmM5nk43MQXjuiayfImp0FItEOwpIs5GAdSA34g9UcUn011?=
 =?us-ascii?Q?s/crZop9xIcdS32RLeyMsdOcDBBSxLqDUNHqKJFH67ZubN2Gyirb3koAIdbd?=
 =?us-ascii?Q?H/DORucPt8xO1utqYWeXpBTEQrZbMCQPC3taYhEGxAFROcOV+3+xwnk4FmNw?=
 =?us-ascii?Q?iHUAZehk+ydQJ3HSD0wfi8F0dEtKAz5oK0ERySdfzkY9K4LaDLgR/4lVdfQW?=
 =?us-ascii?Q?Oz7cUuW7P8MQlqSCf4g1pF4CDUkp+ib8ZVUNyf0Zb4FfeBVKmQXwYIDxRONS?=
 =?us-ascii?Q?zkx0eJb6gGrcsoBh799yCHn0sjf4DlTiszgrCAEqPx9UxLMskw9Q5+hy5l4b?=
 =?us-ascii?Q?GYFu9ZBHyr4DxJ1Hv7NgQt5LQiySAEIbiwn8JTeRWHpjROxIE3ZszAorIOL3?=
 =?us-ascii?Q?JLcSMmFM4W4PLX1gDnzZ3UQbNTSripqUSXD0V9H85C6g4qiVMmVRl8DHvqgc?=
 =?us-ascii?Q?1dMt21Z/S2jacmq1S/C/JRbhNiHlJtTPxPHZtT2DomAqt/6kb73PixJrK4HT?=
 =?us-ascii?Q?bsnZGHiLEtItYPOHklLaCuFIIaQRV0Rl9zMbth0v+g41WEY1WdzlawRtNgYJ?=
 =?us-ascii?Q?BA28dpX7nsshsS9RQ9PgTTjThE6rWexqJwT+aVlpjKbAZOycNdhdi7+AGCKd?=
 =?us-ascii?Q?5xz874+KjZKlatAD2Dw1eC3YQXhOIl+cYndo+zbm6ZzXG2NU/YcXXSaGnyhd?=
 =?us-ascii?Q?4EUaAnylU0pWt62Nmbl0y8sDzg64LWu1fF7X0RdGr762gs0b222nsecO0H12?=
 =?us-ascii?Q?IOhG8SwZI8Z+WYRZ+YF6V1iuqsJIQYSDQ7/s3HPtjwVaI1ePjeAggFiSQSSL?=
 =?us-ascii?Q?1QQRvYvdQkjpFVJqJiOTnxevw3i52Z7le907tLzU5dHF6JYg0xibn13N7Q76?=
 =?us-ascii?Q?n7pEIgfB+exbKmSh+enYFIqf3ZfWuQy1UErhTwuTZZbwBPy23mVhtw+KfGUF?=
 =?us-ascii?Q?niCeNa5J8BZ9pRgqylfjyQObbDSl3znUa0BMVXHw0W1+dyBJ8JkRxb4VnBEH?=
 =?us-ascii?Q?ZPiEtfttcB8XLejFlcc4qIOKgQ0FKOg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49672bc1-37bb-4020-11db-08da18f497c1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:22.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szrBjRebWtq5DN3b9WyFMcK+RoUVgmGVMX6/RIu+DbUv5hmMQBQrpMpxiCvIFDdhqCv/4iSJU0a1QVAS9np0RqM7ONJKx/TJUeOmmQ2k9RI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=682 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-GUID: df6GQx53-qoGFiR_drmJHcNS64xhcOXs
X-Proofpoint-ORIG-GUID: df6GQx53-qoGFiR_drmJHcNS64xhcOXs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patchset was made over Linus's tree and contains fixes for
boot/iscsid restart, more fixes for the in-kernel recovery patch, a data
corruption regression and fix for qedi connection error handling.



