Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE211C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJCR5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiJCR5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267FF40BE7
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOXex015770;
        Mon, 3 Oct 2022 17:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0MquH/hLotwW8bSxlvioKZqxFxeXdZESvigAFok0neA=;
 b=PMRiNZ0utMIX1VLRbw9OL1XqWjhgPSmOAKxfs8d9ILksavh7IoEcQgDMfBz9/qdYd/zI
 rQnNSuaS7ZvdfsFiUh8pjIqH1JrlFZLr3jXEFGlqmNR5Dxb9JBr4jBS/FiXPmSfzGAHv
 eW7y+OvqpNQ7bAdqkmWbGGQqdV2RdR+w32gw9QuoBC/DvP0oWJyKGONQWu4vMW0n4tdi
 rIJzeeADDQgu/YMd9ZY7uQaHDKX2sQz570BI7AHWGYfs2HgJdb3JHWZuTITeTyLQjUio
 ompLuB1dUs/38ldNW5eXNT9I/uI+Bz8Sb4FiN1BQLyWgUVAiVGXPjjONR/BUeRWywYPJ ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FU5Qw028008;
        Mon, 3 Oct 2022 17:54:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gda0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCO4/VYbef1bEysB18S+zNyDzGyO5CdWhKc0xbPLBye9zeq0FxnMHWGD0W2mDOvcF14eHm9zIx/kGgA27juYXDzJpR3YbxkPBnem3Y0uil1oVz1q4iLK65I2I00IRqQ+K3E6opvnj8zuQ+HoQHi+14GuC3yqK6w04SpwGmpjx5PSZp9kph58En3wbOJyEN7XhCKNO6oMq7nr7O451HQDpiqpre4Je7Zg82cJZKDqMtTWKtZ4lxQb5Dn6Fki+djFsvo45ksXtK4XalN08p8wdVC7oU1QsX0kxHvXXw9C2HH1WN26rqo0ZVvu2ZnAs2y6Audt1nJq3Lwxrq1ICDSZUZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MquH/hLotwW8bSxlvioKZqxFxeXdZESvigAFok0neA=;
 b=QFcdgWjbWFILswcqqCCLHReYEhqzcEbC//0EKvsWlR5qcsPv2XDL6+fPtVFtmlp+7AWFbk/hGl+PMBCk6k5nomo0YaJmj0vfq93cyyD3CFYEvSmlw/arFpDGkAIZ1gKBV7ITFflGLuq3S/uowdzqWFeFcqgEgL2Ef4E31zq2IMcEm/8oPlZiNvzoiGxkzGFN/4qDgYb9nZoAUX+qoCJ5rZY1MsG7ovweBE9bhS8bYJ3wwyAQ6JgpndzXb6Y+m9uV10YBIIvHR+obZNGCCiING1brTEqFYUYs3LgsDwvYUYzP8tYBA0RdPMrrc7EaxE2iIvTNwCKlpC5XkvUuPlC17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MquH/hLotwW8bSxlvioKZqxFxeXdZESvigAFok0neA=;
 b=ZOwG/wZmzvNj1DQbbvxz+FL5Hofc17SiqT45DvR0F/OTID+5WbGfYIaCgsMd6BDCYgMIiEzXV/QgMepbLfBglKRKraFm7bJdo14TRCo8NIaKuO+6J+Imrref3W6KyfV8qJJnJSyp83MSGI3QAwbPvioxc0oMlz+lguELXZUuHUw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 15/35] scsi: virtio_scsi: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:53:01 -0500
Message-Id: <20221003175321.8040-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:610:54::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c6655f-5049-4767-f283-08daa56837f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KR6XCIeFCssWEFtetDyWC/EgC2hp0zZ/+2CpW5AX7oYhJ3DY5VnNyn+4zk+zRLIoiMWL0eIBOeSdveUybd//DEH7RDVh902N82CUmn67MosTTeJI+i5EFkIj9ZVFVJEy9ODfEnCfcGt5pkes5f0zIoSAnkZGP4J5vuT3m65vy4E3vxKkHnj1jMbKvCRULAHEhIqR26aifmFo6v5XXLIpP88cgEdppVqAoJaT9/xXLYeWlLIs4262Q2DjRigG/diKV2T7/5LXxRsTlpcOULE9dras2RyQvfHUydTScMofIuesK71VaMK/uVmySnYMheDbMv45+fi390CofJCbYbEodc+gqHDOZXB81terldBYRzD24wteg9XrZ46+yucjNENLDPAROjB6af1eIbzNOpfAXoksWS+FDXmWLkwPcfef11q9D0gErzEVjdlnl7Q1n5D4ZnSnUty2KlcyR12mb5VufciInZ8M2DuptZ4n8III6O8mwHd9AQpX2Erwkt/8NlyUVAt0C9hzW/qoLnXoktSXFDNU0CcrTaVakLeyvpHeF9Zha3jv+lHR/zxDSKdh+djBnpi+qL8oD7ioAb+UKRcC8YBZNVes2kiDzJpgy9lqJ0/AAKnf/dX80GemA3pxWc6sn5WDjPh/9jahtJ32wGWy5x4LOcVErs2n7SqSIXagsbMOQKq0EnNkuQN63iAxTRJ6Z11zOpcJZytKRdr8lS6qJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k7FdIvShg3Fk68g07WPx25iUV9kxDV4kIqB52N6z4oEhzi613sKsLBU9/gZJ?=
 =?us-ascii?Q?rMkBJ4ldM97DSZ2ArsPpQusA82e5eSgZvoHkKNww+3G5xkbZkd2uCE4/6HZx?=
 =?us-ascii?Q?HnepqPGqvF+MEr9jP9FUkWLzeLdSmgfpEapAkGQSuJ6rUozhWHkzsKcmXGpV?=
 =?us-ascii?Q?QMLlhCLIOAALXfYhkOeJfUhPwsq8+aZ3yZiWZHdIGUJPdE1dLmgXFEIalSO2?=
 =?us-ascii?Q?k+xb4rKRM7YH22z7djoKDxXY9Vek9aLwGdzgeCfg2HWomW8aAGofHQDxcTil?=
 =?us-ascii?Q?M93nMcScgZhEOwI8YhICXJKSL2wZOeEYIn4NYS3bB+7/fPKqR2AII15NtjK/?=
 =?us-ascii?Q?AzNEPvjwflHCZENHA6Rr+/Kg8DsG1O3w+X9TtAOLGOBtJaGRzWjGQgirIUdz?=
 =?us-ascii?Q?zdYEyD8vSJuMQE0qs8vf5u+DQzWWG9SllUfjElpQhPjLYLoBKS/C44I5Umy2?=
 =?us-ascii?Q?23m7B4NIUM8BMEK1mL97veb5bzFt2grzeh86bgTFPgSozeAvVgzejG0TLVqd?=
 =?us-ascii?Q?f432OJzZocWjinEV4f4J6JP5aI3+pLEr2EIcP+9p8sJUOg2PCoffxYTiCgVr?=
 =?us-ascii?Q?SBPq52gQd1DmsUPdPJW2m8eS9yEhQy2DWBwbCEBdE2ljuN93qShAp+4DDBRF?=
 =?us-ascii?Q?GVBNUj0RUZ42Mgm0nhFQHZO3pMJQIEALyJ+Eipljr7kj9EeY0Wsb8TUeMvXV?=
 =?us-ascii?Q?SoA8ihjrojaDCM4DYgULvtohfdgwPHRwduxaO58UHSLe13el9PT34K60n3ar?=
 =?us-ascii?Q?zSZocb7Q0kfaOp6By7nkG+Eu0Kz1HYbCNbiS5Xq/1kiK2fJHv3jyHTH84K3K?=
 =?us-ascii?Q?VAPgpaCIoVIFUrgTjh4JKrStOnDRBBlMvm05IrRrD0tXPboQpqD4jLQAVEJA?=
 =?us-ascii?Q?rfF/6DA4hV5Q7Q4IYSIrmJH8AhrNmBndbOEb+OweuflGug9ZwnofXIzSYg16?=
 =?us-ascii?Q?6pubZxY/csr78HEIG+Y3WLVgR3IgQDJ7iWioFkS+L4SBt4SHHy9nWR7oB1rV?=
 =?us-ascii?Q?C7EUf2Bhuvlf54Tn+JhDe+j+R34ddBHl66I2YGDjQfu8ttQCXLI4GpZaz/xc?=
 =?us-ascii?Q?Ha/JBUJDNzRgzVw6fzbjJ8JlZkYPlaNq+dF0hbxkfQJDJIcAlLVur3EA33pf?=
 =?us-ascii?Q?fkpZr7yhTCDWqwVYZ5i0A8cfJfpq8hPDvAsVMReRjI+L21ShrnEM1YgdH9oX?=
 =?us-ascii?Q?kozmsPVrlKX6ry1jfBOEnJ+4dFs8l3nzObYGAGtKawtb36QqIGFEPAQ6/LG9?=
 =?us-ascii?Q?txvwMh65vvw6y4PIf2Ygm923mrrcQ7dxzXwUmG7uHe4Lo8HFxheROSGK3bBW?=
 =?us-ascii?Q?ujVb6XcyVleYydT+qo2DhPrHuZ9PlMH75CH3KBfR45qqODQtpW+Hu8DuWJ+8?=
 =?us-ascii?Q?+5WmFo13DwQEVURO85WN8oS0n25alrsnYq5xxYwuK/LG7AZ6P9UtNLcEZszz?=
 =?us-ascii?Q?noYpH4w37UOi7GD1Yjnqk+y1J8OA2XXyPelGvDg0KhVwmQ44dh1s6dhQLp5F?=
 =?us-ascii?Q?yFI8Si2CPSA3MO8REWxje5Gf8S+r/3iLohZX63TplSLEZIEA6juOqKE+dbLE?=
 =?us-ascii?Q?Wr6eLmK6/YZaX9ZsArjnL3lsDHMOH/PjIVZ6EB+Q7yLKjagKR6Zec32IT0jD?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c6655f-5049-4767-f283-08daa56837f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:46.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esQOzfER9metShSwZ+5KDPrU15lYIF7px3C3A9gkLRtn23o/QLnD5OfNQ+H8J774L02FavFD+LuTKhIkS13+eYUIH9Um31nRBrBkZMUctKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: jDugkBrSaeLKxkqPQu8RorP7fxhclnwG
X-Proofpoint-ORIG-GUID: jDugkBrSaeLKxkqPQu8RorP7fxhclnwG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/virtio_scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 00cf6743db8c..c86a3c035374 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,14 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = inquiry_len,
+						.timeout = SD_TIMEOUT,
+						.retries = SD_MAX_RETRIES }));
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

