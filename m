Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FACBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiKVDky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiKVDkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:40:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C680627DC3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:40:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM38TnM014539;
        Tue, 22 Nov 2022 03:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pEjH4UtKN5ldCSJRRs8gm2F8Sz2Vf3U8CsNBV9piQtY=;
 b=PDux0DcPKqqpJFuoT3YWNOTH4oBHvMTBVJThWLGF7/lcpbEuDC/O+cW14mOK2Wjj5Acu
 jv/fEG9T4V+vMqDyFrDDP5W8SvSGi72e1gS6+ROd0MIbx1/3uVzIhPBS9m5LQsLeGLzf
 zwCZBXSiHc+JDsDg7X50hcKCnKfHPM4G1dvAqpFUmET2KDBvC8N0qePV3IRC5HtgE4GI
 pSUZxTWUj+FksSYH/GqgBFB8Xauva7Wr+hF+/S5LZ3sdnfTzPdLO/RpQ8WPZfP3wQfu0
 47RYOx8kjEeTcpPNnkAOwrGkVRg2rvqIm5g+DWfWP/FExg9N1uYvpK6EGRwxOMou+JoQ GQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr2c4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3J9Lo038796;
        Tue, 22 Nov 2022 03:40:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4q0hp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmiEd+hPqqf7QNYL1LK8k5nsQ5kaL2UFRwbPuV9RvlbQaaJ3+G+1Vlim3ZYKd7Y54gakziKZgC9m1BhmXaJ1d9NJEX48la0XcTWbZWgfv2Is6mSG2uKwih7946tt7R3JmGuPe1t2f6MPGtVm//v9h5hs0f8w2ZD4L4Wyg9mLFSIeLn2ciyjtpnPgZyDCfp2VlPxQHSyAgAuFyahp6fQHP/qLfoTchu+VCy31+3LAFzl+hxkUaIDxqdkS75+O/CMKtyY2+lUo5Vy4QcX6PNgem/jDUuNOZH8s9Zq75oxMgh7B8gYISqG/sWCfFEOD73fnAbVcb8B6Fr9IKVLMSxkL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEjH4UtKN5ldCSJRRs8gm2F8Sz2Vf3U8CsNBV9piQtY=;
 b=kHTAtjxJIsgOmCuZNENVzKoXbOvKec0zaJySienx5N0Sk+ZqAx6jfNfbnqvlwdtbWtdrkFOw/ZX+ms1/nnSmNGxITFnRmP+Dh3kzVZSJiXbobdTI38vkeSyqx4ad4ke2BeuqvJBog06De0y1MHWQfKKh1rExN3oP4dh8Q2Ul8+F6ahl8008kA8XDckc+fpcPpDXNnE2e/V0YMUpcIfV9m8J6j3JIYXSUyyKgNiVu4Y5ecUNoHryyYP4852JIqJ5PAnBOpapRWWDXUWqO4PlS7WyMyC7osKs3hwT1CQKFONCNL8sWR73mxBVECxCeq6+x7LjRbKQm7jomuY5ILBCZUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEjH4UtKN5ldCSJRRs8gm2F8Sz2Vf3U8CsNBV9piQtY=;
 b=BPCm7JUTIRTibJhn5tnj4lnNzV7CV168IyCFew+w2WlXzzKOZ7tReTOLR4uRZDWxVeAJWqng9Te+l3idHKdaCmI+CjsKtgfGHHRGjOdcWcQmLMF5AqD9A4+L4ADYK52msN/28Ix94v4nkAN755kBagTvQa1LIC99BZpKIXtiRCI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/15] scsi: zbc: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:28 -0600
Message-Id: <20221122033934.33797-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0028.namprd14.prod.outlook.com
 (2603:10b6:610:60::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b8dc4f-6d26-4ac8-9d3b-08dacc3b5271
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IgovelwQmlLNknV/jMLJHn4FwGlHE4ZsDFkCAdkqN/8z+G+5mQspOXOIPUBGUdNwQptjvx6stAqujOubebQFWzkcleD99Sa/MFo1nU3iMdFI/vwpXzH5IGCzFEwqs9yjzWlqGptUuzOa0R+yByOsETL7elbNn3xOtT+c6iArpl5w0bfRDz/jI7rAxhVKXczzFy3sZS4sXe5usVpDo67OErExzF6Ro4iWOidTIktL5IKmfmfp269NxemxqlnMKNnt1bVWi8Fqs6ga0HcN5wxOyzMNLN2Ok3VwuSxUn0SVlB+kWU9uIOVJsawEKD2LSmbwKUr+89pxvrmmqwispfpuAdRH/gekD+nQ9iTGhRSScSF6UAtOno/gwE7AMYOS+7ZDVTyeJs0kfziOFn7QHA4qBy2S3A4BQ1UI18eaom/vWF/p9XgiBbCAFlm9Yr1gpALu5SmS7ffb0Ku+KjKddeAZDoZ5152ONRecq6Mgv3EHO2OBOBNngzeKKKrpZMIG22GTN66Xf1yWvSgaPvtBRHnNOwJDebD4OGvefNGLGXiwt3YoT2z57SrLvHOebeQPhAY5+0rnu4cA8y+M1HMhyw7Xvi09V+N3X3b2EwnHgUKRAEVFLm6zVXeez8ch9yy6ZSU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(4744005)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vpxGWNUZCu0hdJj/e+Fb4Lk8rqpc4z60BfW1NrFV80wStjLLpt/o7xM0ptBq?=
 =?us-ascii?Q?bdBaRht+J+4TJhX0ChTc1jLlGeoA3o7dRfgEh+OqKf19Axhi2yeZFLoA63BJ?=
 =?us-ascii?Q?6QnEjhyLiODZAHHqrqt8uA12dFZeYL1SpI6Up3ZZcGHLbwpnH1oSW0LqYWen?=
 =?us-ascii?Q?qS1egemzg1GowIUHFm6OWalOb1ZLGQFZ/nICdBykNM+4IKS7VeiDx9l3Hzvk?=
 =?us-ascii?Q?uG7fcd6xd8eJP3QpC3VgUnbSypTXXuWFG8wCyXbaRK6pOsqKdX3FlFucfu/L?=
 =?us-ascii?Q?TaxEsQvxYyB3kEwt4wT4voqmR2yu/pxMAVaLNTfm+ohdS727Q1vCa/Cljy2X?=
 =?us-ascii?Q?RSnO4Vqe6YQbfXQWpQjdOvtopnBzK7O+oWYSApaDfgWEZdiTj79to8NWRM2F?=
 =?us-ascii?Q?Dw6trTkmwVPWgu4hEpimUUzJ+NeVfQkQbya2wCmrjiUQGW4NqqQRevB6jT+A?=
 =?us-ascii?Q?sWSHpwseY/NoBf+pyNudLdQOAcmQem/5bZLt4Pkvy7CBTABwPr7uwUTI5lyC?=
 =?us-ascii?Q?dvQIjJwUOewl13kjrEKC0ptyMUcfIfcyDya3HO0AmTQmnADvLf5ezbRAnGU8?=
 =?us-ascii?Q?H1hVeAUKtg8pD0D5NsKLTwbYQwbchv8Iec932mtIQ0J3nLrbz+JrSuFgWc3B?=
 =?us-ascii?Q?woW56IwzFxz+r/8pnLuuJuMPSVyeI8W+4/lQm/oLACCRtW8iPpFoDcFGXw8d?=
 =?us-ascii?Q?ft9ChscShmHwlBVDnSixoALv9Vaj+KIwHq/T4g4KmZ7C3HA+LwK43y2Ubw6D?=
 =?us-ascii?Q?tBkcZVgwi2NaLCp2lmfEPLKR+MR+1MVDg9BIlUqVmrIl6ZsnWOwq2bijFXd9?=
 =?us-ascii?Q?dkXImGtsCosUKlr7FTDRfZlmdnagMzyrNPkRWEbqiFH2jbN0LYS6Ne6M2E0W?=
 =?us-ascii?Q?nqC0jEiDEjId82E4urWCP1Af9H6DRcgk1PQ/Zad8SCj6Ru+8oQ3vCy5InW7/?=
 =?us-ascii?Q?u+PQr3cMwro+B+nmnGQuGTKxjb/0xT53mmYp9/LqDHFOe794Uw2bgRsHcDwK?=
 =?us-ascii?Q?atykA5AOHwqRU+JAETLvVeHZ5OEB4522tAQGi8of/mtkSJtpNSZVolzt+kyZ?=
 =?us-ascii?Q?lhisXZYIY29Kh+HXSegqGl1ZdtHW9Li9VsbQWu3q7UpIvmdZ/tk4/oFnYTBQ?=
 =?us-ascii?Q?b61LgzsLT+7bkbjV1ajsstMd65JpzZDtC/lhV+ND5xLBglPYa+YxDVLDHY2n?=
 =?us-ascii?Q?czQkXHpfCHcKtuOyhh+JI4GTbyrqKJMaIuGApPfD2NThYvgQbS1vvkno1w5u?=
 =?us-ascii?Q?5CmW7ona+Sa+qtCJuySAgQmZz4bmaIa7rYv1OH8KkdhtAvQX3tErZeyWmtrJ?=
 =?us-ascii?Q?+G78I7CHoTetIkPAw2hubt+clklCXJ41yjdKvEGbYXfTr3gb1KeFL2iKZuDM?=
 =?us-ascii?Q?Ppm/jY5aDdbYlPanEfr7Zh2I1DsT1et+HPrybCRVXyUKIJTkCgMAqNeewDv3?=
 =?us-ascii?Q?FwwySgx3lIA2oLe31nIxlOXIYhEZyuzDTXjNJcEjXpdErRfuyp502pzqPbUE?=
 =?us-ascii?Q?DQW1+Ts8sngqVrkdPmOb4ZRCPbVWnF16PXFIK+BnPf0hTVCKJ+1RJJ3HxcM3?=
 =?us-ascii?Q?3cVo2DgzpJFY7V7eFg/ydtwpbMkQcKK4fpICVC8yo19huAS4Q2B9FjgiSr77?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F4H/FaTfSDRMBp+8+zktlXJu00yKGbCQ90ayZBcIfeBGqC0qdxKe0+c++jbZwHBxT7a8rlWhR2uEF6qli4/+i01bYjLR4BcF1AhmXFEBx7IsDMEBBvVUazHPJFCSTtASLS8emDs0I/pJRuTl8OFFFDapidffRtaCMmseECHRQsF99mh5/mCgvkT4Y688WmqYLMysSAlBGssgTwOX3XMf2z/LzUmPCAjeJZvCcTnZISpCTozVufycb3SWOAAE3xaIqm3ZBIULro0M1TtEyXpT5cDr/5nTRX6ESQeDwV19juKHHUpDlYC0zf5b4E8zMnfrO1dv9/16jqYTmSUGIiepbl67k51sGfKXFKi8a0iVYe8KxGYpPcE71z9usl0X6E5zOpYzsTfFPURm+cMAA/vBiOgxZpmOxVgWWoG6REa0dBsAUdSh3DfIa9OYEpH0zaHKBcHghf6x1QUrEzQUMJfvm0d13YS+vgskbUPJ7FkNWn3DTwRylPCZwvapd874rVjI5GHxFNSfXdoS75IEuv+O/O/T5ZQ6w6VhG1QGWQVbhdIeCVNxUxviaXakPrxC2l4HrHsFmK153yQ7tLsh8xSP2tCGgTmqBJwF4fTTT4DpRld10OUXz38SmU8snAJpDOdN6qfmDc5YBMa+jhHyNFSW1HPGG2pAKl3LoWgmIN+GNBXbNsOtf2yUeIKWnIP6rHjghGQaFqWpJuLM9WpMQsux8iS5K0IzFw1yDYXzy4TfoaNxynTNl5xnNeHcX8gdYDuLP+xokxBL7w3q10EfZBGlM8L16x9wDz6Mxa2iSWjHa69r/jVRoEyrxD36/c1FGziomNS1dPOTgj3WXO+u8KR47+Lvc/wJOJd15SBZxpA8iAEjsh5aEzhloQ7E025o0YF8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b8dc4f-6d26-4ac8-9d3b-08dacc3b5271
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:38.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+zhdjgixEYlsOLKAQWERjeR1/9iuj4PwxRPJ9XF1CRKgnyvfhX9o4Q8VywbP1PJF9tWtYs9A/hf6aLhjdvJncjlwbCsqsGzinY6l88ikGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: sloRHysK68MoysQ0yij-fyNddw4BS9mk
X-Proofpoint-ORIG-GUID: sloRHysK68MoysQ0yij-fyNddw4BS9mk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd_zbc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..e6bfb3a7cb94 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -157,9 +157,9 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buf, buflen, timeout,
+				  SD_MAX_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

