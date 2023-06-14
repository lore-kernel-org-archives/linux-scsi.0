Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D73EB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243417AbjFNHV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjFNHV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E19E295E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k2JI023000;
        Wed, 14 Jun 2023 07:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=iHVSCiGw1YIqdrLU+ga8fFPDGKSv24C6TUD7O4DXpnk=;
 b=sjUqfJDky9bOU/yjk9jISfhZgF4p2Akxi0fhtPLugt8bnQpmRhtaZ3Il4X++kkP4OAHc
 sq72lgmFxHpvXMd88FOMS6xn2MnUyPZxvsb+hBPKeDIfJDHpx1B8d/815pkmQP9VaDAN
 Rw1hqjRw72mKmxRAuxMTvFD2StZ86pnfxqa/djpryURC8jYNRgNf9ekiXuU+VIf2ta0M
 4ZCA0Dk1VAqmWRU0ZYXyJ8lF+iE/JgZkmjHmbO32eGh5VdSEHHC3QSCZcYQgGasGAUwz
 9l5jZ7Jl+AoeaaULOeQ5imVnpHr6ubq6c7nwQxbiFjtwS4pGQOYB/IXv+SfbRbAoxpot CQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E59VGM021637;
        Wed, 14 Jun 2023 07:17:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56c5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMXunc+UJ7zmQSQyqATbBgAwAaN+dp7MUth/zCjuU+bmpy270k/A7JqlAxekX3OJeA5ipRAtpeHoWW92pzw7mvOvY0tq+YFikM/WmBbMe8qNq/uGPKhPOcjWxdBokiOAIG5D4vdiv+7NXofvI2RwteaOYxmj1LpYgRADQG/o/bSHEZmFsZ8x7yRsuGS3TUaP2t0r34gt90z/bxitAR6GvDP59f7xEbFs8Sbf4Q5buNeewv2ihtpSwv/eOk+3OY9P69qIiupsU6JClirZI1Yqy/qt/Hy9ER0QFTE+1BbHLxr/0VRm7DiM3tXS+NPBQIA/2llhStHZcviOjYrgAtj11A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHVSCiGw1YIqdrLU+ga8fFPDGKSv24C6TUD7O4DXpnk=;
 b=GnRms+PcGTYxEGE5vtWBOy6adU+E0jKfpnj2YubBF7DlZ0EfbdhFe2tbZ5MS7p47BgRAgqmgO2f+yR56tn0A+qDYH8zCW321iyi909oZkyWxMftRoaAztN1DKUJX7wACQQEAPrAd5sFqfh7co9Fnxl3S2SKPb8yIGP/8d72O16hUvcQBudahnRCQx+b4Pg4UnNULvFWblty7GobRLs0ntBgDns90WAnCdZzyZBcqTsXk51yCetQAt/nQPXYEjoQrU8SKrCiQvPP5eNwFTjuFzLyzvpK8ovZt3DjMV1APrHfmkX8H7uPXGAoP46Qpaap/BRqnH5tXAF6B+39A9ozDbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHVSCiGw1YIqdrLU+ga8fFPDGKSv24C6TUD7O4DXpnk=;
 b=Egk8Kn24eOZIk81mWBgKMUqN7WDM1Ku0tE7EF+ZAHj2oOU5wjd+6fKu2//UegyYzbeI4z5KSx8yyggrfdI06+Uy5EkNqw4MgFqhgQXLFkPX7BFFvglqCrcEnIS/5KISrBvNkLkDG8w3cF8llzfbZdYjsK2qwcr+uRPjikSHGfpA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 08/33] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Wed, 14 Jun 2023 02:16:54 -0500
Message-Id: <20230614071719.6372-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:5:14c::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa0e6b8-acaa-4cb9-6321-08db6ca76e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFFNO0dac2gG3WgRy+lC9ez+fJSvX4CjtrrEYJSxD9xNn3U7ExRfRicjkjPqUA7te4Bb4VXo2F8Sbr647zEkf1iJa6ZZANYCfYBpDrefWIwusd+VgFTbdVvKGluvqhB9YVur0jQS6cFKLhAveHJn0VA/m9OD7sfvZmf++jdSXWaNHeZ5wt0dy3D+h2lokuj+COJKKMHQs5Zbz7+o+3ifNgcQm7SgrneQol9fVuzt3W+Od7ANBG7AuW4PyZ8M/POAaU/kyxMgAUQMbzdqkWt3AwySBSUa/8Y9xFbezkvIRb5wJ6hcuElpV15wiy6C8n88lgS5YvitvxJ9PpymvPFT+TB3KF8czgdXKLN0RxkxLWOFgQuxKoBNTdGifWyNBRFHSFMyb15IeTTkE2ZzIJ0XI3qXY4KvyyTPV+/wfEa9/lkbYhymiGsM5JO6XiZ7tEL2QFkxYo5KJjkHndwqmZ85om3XnH3KYXUwt2koiNX9gJU6xE4TMEa5DB1utHvvZm8/W1u3wZq5UkR/yS9iUhbsVgVmBzVelYzkIAbU3FfhmB2T4MkM5fvlT/Z8ufOHOtZA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26sw392UXiNwHfSGQCmHzO5pE9VJ+0N1oUsEPDkBvug0tkaE1kQCTQEwbD5a?=
 =?us-ascii?Q?pGEMy9S2XbEcbQl2rnUfN5Fjuifc55xhYYKYsN0TxU6c4giVtKZ3mnevbZS9?=
 =?us-ascii?Q?LU2f0fjE18/s7qdDqg3YpaB7mXbnBNYFauyToq2w9d9ya6JdVby+ogCffElN?=
 =?us-ascii?Q?7Ibq5f+Q6DCmCJGCIbYWII1+FfrPmaM24TTxKKpMYYrnrpTeSS5zxcI3Z2WA?=
 =?us-ascii?Q?Dec9QD682KemuJujaOtirbX0znoTGHPAmyYYjcyWJdItWIShuYJMcIKQpbVX?=
 =?us-ascii?Q?pxurrpHPQE1U5xH+26OrmBSzwItR8rbfynZsAoBc58cSahOjWJbXYvgY2ewm?=
 =?us-ascii?Q?5kvjCn0gYFxY7GAfjzbd5pPzMVV8gZxnJ+n6Y3i+f8/gSsIkfJRGZS8sEmKU?=
 =?us-ascii?Q?G98znmwZKJEz9uQv2wmndGPwoNxmUvA4va70negNpfM94UWlweeM4PiTAo+y?=
 =?us-ascii?Q?bWgtAEH3wR/6UliN6AJwbmkOuivW08qzW6OCWjBiqnn7cbQMUxDW5AJDRDj+?=
 =?us-ascii?Q?FYhPVayRccSw8O+R466pt7nItKhGvsbvFUa440thR6QEiD7vheb06M+fHT3o?=
 =?us-ascii?Q?j74XUDg/E3/XohfLjwyh+c/xNXYFSjDBMNaVQhR3olNg/yc14a+5jgnAFe/8?=
 =?us-ascii?Q?7+89avFzuvEeUL60qcevpyKzHQpVvKQHm21glAq2PIxP1CMCOa3L4F300a38?=
 =?us-ascii?Q?1QdrGTkP2zUyJaQlhE2daDyFdiZOW9iz//6qKVN43vKaODaTC1SxzhXdGmUw?=
 =?us-ascii?Q?MZvMlzzgOdMbNko3g6wQJ0nss1pdgnoPlVNuDve7HVSljuhSlTSv8TWQDxRq?=
 =?us-ascii?Q?ea1fNjEv7mmu4e9bZZTFZ4d+zRft7Kgt9LDYR/9dePv+oHtbn+TXYg+/lpLs?=
 =?us-ascii?Q?yRRVDBYhjPkiLPKanpri+cSVkjLmUyPdfM5MnSWCcNUFl9WwvoWDdSpjcD/e?=
 =?us-ascii?Q?ntFyizWf5O0VyK9jLGo42ADhm0bVbD9+6DRTL+eaF5/YHxk5trWHyT1qTikX?=
 =?us-ascii?Q?5TQV2Kp/N28Owvxcab1rZwfpMRaBrUpgGqyrRtuFmrRoKeEpFjRTdA5NFDAf?=
 =?us-ascii?Q?q8F5QVZwhWs++VsFDMd/GboUoeJqXhwuiYX3rJr2sqYKc5528B/f2vKSTgKg?=
 =?us-ascii?Q?4tB+qgbpEeN/sfYuc7SV0rpBqCWwlw9cm47IoZWWZ5JZY75P/h51pHzRHRXU?=
 =?us-ascii?Q?ROO00IeI9Xm3B65HChf+4INIlRdw6RV0deISCUNYFtCeEA09vCdMAGUaJoWG?=
 =?us-ascii?Q?55VdJvnQPuIzbg7F2/kt11kpTQMSewo08nSkelTk3iDni8qYeGhfOKVLmROy?=
 =?us-ascii?Q?QGBoToEt7gnLCih2tBroX1savt1+2UKQPebzY/NFgxU6QByXuInyu6DwYHxx?=
 =?us-ascii?Q?giTQZkkCo1W0zARnyUI941D8xprvvjeOCW4a+F4JsV1wSkcrwnqWMEp8ksOG?=
 =?us-ascii?Q?KIJ0RK+vw+91OXMFlBkLcdwkAClBF99IxV+W95mSdsO750ERI3SZQVPw0i2f?=
 =?us-ascii?Q?6HfynL9TuLI2TWXvKCQurVMf33PNNSdCV1+VpKyE0m8+ez0vMcb9Zr5auyH3?=
 =?us-ascii?Q?y13i1bj/HWP/h5QnwdZ1+5I5baeWsGCQrrg5DqlIKhytY0qyIG8QvaJI60M0?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DTSmra++ve8lbjYsUFVb4aTcd7c9EZxO6MHCKXBQLgroLUhezTZOjdru0qZBtwbX2HjnUkC7Ar5lpiBonrwZLgnPowhDxJX0lhDbqkjZpL5XMTd6e7pN20BtGHWDwOIs68gLkF2IfjcwsfuGp0vpcMSfCzbGkaH2GdCmsgt7F8OyBrdBbS5wjzWWLsGwU4lRz/mbSrLFQ9whkKZ+pCWRoVBKBN1UOWCzNYJy2PmrG19wZ9pZujchyhz6eVoRcWYSCU5oa2bpPsnhFh1R/TVGkuJglC6qCYP/K8VLBMOsh7Ukp3vVeXpwzkOAOis53Q89HqKKAbGmAbolAVx5ey9t0TbVWAEolYwaipkd0LfTtt+0ZnuY4G9pQ77Au9s1lszaPtswTCpSF/UZAyPkGxq9DZAhyxU7r61dbdT+E+znjkH2DrXjJu4Zt/x2qK5U8hQ8EdXMHmbjP92AmGZpZ+7Nkku14H1VtaXRYq+NLhgDlbWp16kCQOxvxvBR+KKd+8gkqbv+SJ3LdvroZcBpfwsNQg6FWwfOEwp1HZiZ2cyWsKoQXPHgjfmOA3QI9h/vQsCY1XxsLrH7bKsd4Ey4SzUMuk7jgS4ZXUpqf//TIAyFpUvERBtlIU5EQ5uWPhUVPAvEfuti3qf0Pfawt7mZeabkS0/ioDL3pfwmfVPHEfhz7B1/fzuUDKS0Rtzph0wJcn/s2oLWj73Hh3EfCEzhUr8oyDv8W/gpbxRI/6/UtDJw/QgYt8kOqVEEUV1SLL1ZLAgjcV7wrNqICDJLVYNXxxNcBqq4HtS0YTRHD3rY/EAMNlupabnjKI+Iq7M0x1jnOsFNubUPfImtYNU1oPSRVPOOemF1Vns8ObbADlErLakWbDvyCJZgo4gdVvEeMgsdbC2B
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa0e6b8-acaa-4cb9-6321-08db6ca76e47
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:36.9639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmpWmWHA+UHMiU0/MCI90jCO+wYAh1cJ+mOlZds/r2CyDLUdAiuJa1m2bfPvPpX89OVb2xi0L0slcg4cNWKoDS1XWBj5Z18x8/MLL4MUaLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: Ag_fWOVbZDLEveqpJYMBMsIZvbVH4eBl
X-Proofpoint-GUID: Ag_fWOVbZDLEveqpJYMBMsIZvbVH4eBl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f2edf1d79cc2..1a1011a8ae53 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2268,14 +2268,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.25.1

