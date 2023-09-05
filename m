Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3495CCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbjIEXQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjIEXQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161BDCE0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZn0M004023;
        Tue, 5 Sep 2023 23:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=9NonmR+JLLDIXvaWETvFNFaSn8aUlYH5NTGf9yVPnWE=;
 b=m4tAVaJnqcZntuHTUA/ICtAk5EO02lj8jI3uD6kRXEYg7xzp+ieIajhEfsI4vPy8kBSv
 bjVtoed3FeV17heUxniwsCwOe58zqEwsK0PBh/nyVoGOSS6QTm+mwrilpGgLD+TYSMHK
 jPboIkk2q2c37MtnMRkS4GBFAcLsNy03P4r1OzV1Z8jhEkyQ0ur9ps4KmDkjOn0oxhXg
 OdaymgQYpAfOalNawMTjUcp8XZAI5lLK3Mff2xmZ9dG6+cYll5jREt+Etj36D6/4X4Qd
 4On+UlrEYd6Jc1xnX0YGNaY96AeeycrIDxRUcMl4sbijbucwfqfs3Ejsdzzng+yKhWlJ yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d81y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LV2Ue007675;
        Tue, 5 Sep 2023 23:16:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5exba-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ8CLDR1WqsZl7A+UUZrN4/afNTL/CFJ8ze+NKHaQftNJNIdv0AOmWE0UePH6cHE5HVwiaCOSraJZ992TNExbv1xJ6jN/65B5mNo8DEkmcAjMGX9ZS0nBsLeOd/HjGl7Q4DEmtPQqUkRXwn4UN5Wu8Q83a0R8DfgK+acxPLzRKcjhoUJ7ucmQ+2xtS1JP2M/tkA8Q9gdN8DsRVtMnvkixYvrkkuLGdOGPqV3XdOG9PCVzWNK7Tx8a/yte/uJk7tkGEN/Oc0IhmyfTz5q+VwFKiGovpet9nv/D1NQAygtg0noFgqMoWcIu8pM6Yhq2fx4Gnybf7ATbPQKz/ogwQLUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NonmR+JLLDIXvaWETvFNFaSn8aUlYH5NTGf9yVPnWE=;
 b=Uqwhx8yiUOOD6sqJTZITfqIAtxpKLXRDuFc7PlJZxm/jCI7A4ETw4BGHzjfwH04DMix7QEfh8bekPfXblNHpOhNskgxONjXRyBgz7nBsVIrHMqQLDe3yg1hz2VavpNaaqbLRNTYfbrwkN0pOBG76xuYMFtMrxjNuBjvSzwQaqiD+r+TmDWFdoqHiyXTdHlOS08hNRRBbrZ9EtT6V3OS1NcxPB/eHSts4Zwp764XekIl5nTog4hHLaX6Zur+vSKlDz0kY2KhxR0uI55p1LWefGllmZcAoszxSy8BQB1vJsfU5HdzJrWiLe1455xdxUbZieIwEpc8wzDDYorGsY6L5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NonmR+JLLDIXvaWETvFNFaSn8aUlYH5NTGf9yVPnWE=;
 b=Ez+U0fNxknedVTFzwGdUTSb5ukqtBeB9HSkI2Aldns6JtYt7hd75sTFrQu3QRsBLUWELcI82s6qtqL9MSmohwXIALho2/X1bRp0afuWZKsQF2RrkK1qCse9P1I2rGPHzhv5mYoFWTXas0M5lAuX1Pn2U5bLFKNk02Qi1/hh78Qk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date:   Tue,  5 Sep 2023 18:15:20 -0500
Message-Id: <20230905231547.83945-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7fd321-0c36-4af5-4b62-08dbae66112a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +T6bvG19Lyx2YISOAxa8uhpHSvzHPjw2e0Ch7DpCdvr6B2b02LwrLZz16XjnXwzTsmpOjx6ACaYWYrPy//360PK0pLfL7Pe/iarcrpL6Z6C69BA2x6phUDpFA3wnY07mkNssA39kyIHIDWhaLwFCvUTPbNRNS1PDkcACNC07K4kxOtVqWL9ITUse1WrWk7uP0SNhhnXs+XPShlpat/G2/JVn368NrE69QUHENR4EKrIDphf8iFVVe67P4OVZLXJwnxM9QQ5q1i66vWb63ubhSxxCyMN3qM1R6rl+ur15WgnyzKZxlAVNmVFyepTB2F1bUHLkJ3WIkUL7Ed6HPlNK6Dq3XBYr8rwIR99OazKAAV/qzBZa8Xp5pxZFJGvQB2JzMcXn/wamcU3A3poHEFWvB6O9tK5KZmNHzvhcqYN8f6Np3ZFG0/o5RIcaeIgWG1L6dXJamSSjpebXpf6n267gnAoOJvzvcIXbtKaJ9JrbZ+Y1Pj0saxTxwRfHMoXvPpGQdTYXbTfSSzfWSYNsIhq1Q8T4NNvQppN57VuzzqXVGowW0rPJRRFjGzDozXYN8+3x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b9xGX5vWqFSj+UaETVnzFoKTihDdWSt2DmTGwTos7qw9Rat1HMasD3vpcrju?=
 =?us-ascii?Q?scU2pWZ6VAa5yN0yuliJ8T0OtRtBTOD30Ndd/KhSx0aEHV4dU/oIdqZ+OlGw?=
 =?us-ascii?Q?KFcDifXYcEuQBkYCogNFccMRFNXuujRsxzebohFwRW477khi/w+r57A9IstV?=
 =?us-ascii?Q?KeNFpEpofI9d01wdZm5ZhsEMT63OI1NnfqlTD/rmKMEPet0DyU73e/jVw5hh?=
 =?us-ascii?Q?PFQbIZysqaZPM5a4RvoViO3AcQ9jyb9mYf6HHDJEw8Mshi30aJycV4N6w/I7?=
 =?us-ascii?Q?CQrqjwUlH5oNeWhNM3hDCNLjAv1uWx6P/J0OBuJ5ZB3DrsbSA0C3nszDbCMK?=
 =?us-ascii?Q?Y7AW3DP4M7lgTCS+NHac8ni1MLKbIftKgd7LWaMzSm7fxd7MfjOPw7u+v97q?=
 =?us-ascii?Q?aBHYWLuWOEG3eraAOVhFtJSSadlXOTnaFcJU3YWPD9sipKY87GqmOxG6hygR?=
 =?us-ascii?Q?PUbuzEyUic9f/AlinZjoPQhIccXotLtFx+JJkFYvIERHjXIPAVQxljiThU6I?=
 =?us-ascii?Q?KVQ+I83gvj9Mnb0YQQPMplICr4eSz/7g/hQ+VYpvjBa1UH0a7QWF0qyTKxwB?=
 =?us-ascii?Q?Gz3YWBeOmt8wyKdgmlVU8qCSdVda9Jkgu1Je5cl2RrnLxwp9ipaWdbhYMFva?=
 =?us-ascii?Q?Urj17/dsjm4nxEPMF15F4fwLgS939+geNDTyEytENnkw8IJyZz5p89UsdTvp?=
 =?us-ascii?Q?KInA87ewo1sWWp74SzPjth0t2zLm99bwS53wkDb9vB3+oEgxRde+zX3HHEAH?=
 =?us-ascii?Q?OmAt2BWulFH9bSFZTtrw7yyFV2ji4EPYVak94P3Tyiu5JUkughuPTiv7CBAt?=
 =?us-ascii?Q?HDva5cSgxRmkin7Jf5kXCoeDW45A10uOzSk7Y0zvS4l0mTEQmOwdgBsnLLEf?=
 =?us-ascii?Q?PEcEim4/lliaIIYbOHqnP7Th6sbgN9uRMBfblVDJk83cLQkmk0BePa1pLfHG?=
 =?us-ascii?Q?lgcPutWbt4DXKfNG3qdZr8zXePNj22Af6E8zlQMozsNugdPthk9t5GtKLwvF?=
 =?us-ascii?Q?HrRVaLxwQHmLHelHwSgEz85cEVqYt8U6q2TehMpHrAfPFL3ciezxtugHn8Tb?=
 =?us-ascii?Q?xa+vqtDnxm54yL/jmMQTqp1o2wjLnOYmRJ/+DljPs/39af6TXuVsp38zi/A+?=
 =?us-ascii?Q?xDsW1iXwkuZxjRnoaXSfGGw4qhvwUfO8uXQ+3Esn+XJ4TqbfGeO/wEow1VVF?=
 =?us-ascii?Q?cxgFHCTM+/daTEOwGSpLXHs9qhoxWKDSjyVuwPhsHGla40GNDFM5HOWqdwmq?=
 =?us-ascii?Q?VS4TtyzeoiMdQOCgO3zUMhTDGajbA/iU+aJv7uMvTDpNg7skx2d/VeTok6za?=
 =?us-ascii?Q?NR/OxV7zsLE8KHu1GQKe7DKCyvj7pk7r0+HIaUIeXz3BCzMqc4AdsnYfWY45?=
 =?us-ascii?Q?f5klYqeNU9P+ize3Bv1Y734WdhjBJC69ANJhMUl+d0LVrLJ7ntVHs80bnARi?=
 =?us-ascii?Q?dHe0ZIsdEPRnzTC/deUq/bYz9nuKYCOMQfnnT/1URq2L4qK0mHPY9/5hJ7hh?=
 =?us-ascii?Q?zDJC7mVQq66TwmSglzPNhv6sdaFFzbL4dQJfXirzG0yCbUA52maR5RNeBFUK?=
 =?us-ascii?Q?edcymXcrijdULCj4JyYc1buZdqkMifiaoh6fyrVQuNttShiDamoJIRD8HttR?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rRxOua3CSG5qPL7lpaC+BesXXhakHgsQ92eO31p8hdDuy0oFSnOuuySR9WOLzs5I0169FTmYlWHczn7lT7PH8BABgaYlQoAuAa2WE46UBz8PRY9iTMWGyjRZiYd7Vvp1HXtEV58bOggK+UFCYW3JakLol/F1VN62ITJZDxKr6s/d6YaNWooydqeClx+BpTbjge4+mG0EkeBFTZDR3qnFI3C4NG19w3ztm4X+T5OtZORB/xFbbwVxIHLmG0h48kvOenQGUM6PqfT2cyM5BqAEWGTDCCZwaLFdNu24c13EdQ40ChDuhw9Hni17pZWQgcTYqZ7W0iQQS6ub8H/2cyY9mLUfzhLWycTxuJx5j2iJczpSkYZR/lqxtV7WM0L8bXXNKL9mG7aANy+mVSCHSFobCh8jrMdtAsGIDW5cVqarsHeYyt/h+KJ9kLxoGSkR9sNRgRL8IrebB19PU1FWvBC5l+aT8pgqHSuynD5xxwvMV/QxPx0XDtRtYUAT3eUw2D+UYII+fqslUd0brXOCBpushR4HZPiDGbKOUTXD9U35MMsOXxGWnTFBbqeOR3mUkcluDdA3WnbpmctAmaURXki19MFWgdbUxfM4+x/WXr035quE37WXS9B0K4brBEgJA38TmIYbcOE4QrexDmjYN7geo38UlX4ajrAr0afDDZWcby3O1dZ+IoZFtJwS/pfteaYrl6kQTyK1FSK31wgQrv7uwoVagyeJpG+gt0Bvot7q2ISSZTp+tmLEh44Kai00Jhnzx35jk+BI9ntCs64sGTIlDjO6AKBcJNAAf2A009hNATmkSgc+s/mdBzpkSTAjURV4JdjHS7oAef/inTHq6WWz1KbnXT0C383OUnRLYr4wb97D7FV8mKyEmz/6iVZtPwr1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7fd321-0c36-4af5-4b62-08dbae66112a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:00.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVEAHlgM068xTYYLMtai8Jp7q8O4HT589jpHx65BswBVpRF/eQ0XjudwXxb/41I7r66UXwnCfGqe+op7XZkYCwy4yT3rK+Qlw0BivmCjOuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: uH839_FiN0e9PvHPBgXm2AW1Go3gg38H
X-Proofpoint-ORIG-GUID: uH839_FiN0e9PvHPBgXm2AW1Go3gg38H
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
reties, and the other errors (not including medium not present) get up
to 3 retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 110 ++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 70178c1f3f8e..69188b13f5e2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2363,55 +2363,91 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
-	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+	static const u8 cmd[16] = {
+		[0] = SERVICE_ACTION_IN_16,
+		[1] = SAI_READ_CAPACITY_16,
+		[13] = RC16_LEN,
 	};
+	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00) {
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+		}
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.34.1

