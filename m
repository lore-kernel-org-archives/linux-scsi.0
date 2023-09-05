Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A250ECCF9E5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbjIEXXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjIEXXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:23:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82F7CEA
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:23:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZn1w004023;
        Tue, 5 Sep 2023 23:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Z9vdPdX7B1WPXDw67RdMWgyje7Cr6/qmcvlTZ6vl91s=;
 b=ODLw3qNgGqEfkDbOok6rSHMCnzJQfxJ1jxWBl3LZUOnhAlNdGy5MQCTj8L2T3H4RhDP7
 oMQQDCD5G5mvUoYX2wUt0lSzOdOS0WxP93swAXq75WGJsauxAkqww8FcgA3C9C0ULo5q
 mcQ6Ikl3RGmRjCZRcU8V6vkevkShk652cFe6K8INDRbdfhWSpk6yxqWzf5VhsnTx0exP
 ExSCIAkRMB3Ysk2LkkeiVEQEX+FYWR8udKO1UqwSqo+j5jSj85h8gp0OnW05pNTsdfxA
 f9xexZjG8WhWZU8IZzeA6jdlFNvECaSKa3Nh+MdarQPebzWlmLSYFiriW1f5StCCd31P Tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d82cv-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:23:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwYW3037068;
        Tue, 5 Sep 2023 23:16:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpcfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itioJaL5CYpO/pYYB90vvOEJChKNpiNC/ZjzveralLkOKO1/+3+xOGg93xEZapB81i01ggCUGWGEoPIAqC/3fx15vRMpYTqfnHu42R4fXnMZrs5k170R6npPF21hIy+wiNOKbdtDm4YLo3yVMolk8FSqoEK20HK1jUg7g119UbC4S9TXFA5SWUj6Zlh7AK4vPpO+knNKbJAo+QeCjq1xeIf2yn3PLS6WjhHtAWYnaaGZUDVse2IV1aYxZ0oMBTTNfDaUhODYQQmlnJXOCPiXHzeF20AwbBr7qi0bIXQdJRm24VlMXKXani+WJ+dyWhjFmkeWkNdi6hXfTG8qqgKrcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9vdPdX7B1WPXDw67RdMWgyje7Cr6/qmcvlTZ6vl91s=;
 b=UIWnjvKxNkEnJ8xLcfHzOm9iQ0q8+wt9GIcQFsbb3T/Pwg7D9QVp1PvFQaWZhyOvI9/7c+qjImlxAF3BAoejd78s1qR81/45bQQsHHe1hWh9XdEolzsifidvJZcovzyYlPcWCmcRaEyzFMFAa5E/atQyFVnqTTrZD5A/CTv0h0nx+R3E9AysrCY7Z5bNtkbUvONYV0xmTjZnPkRwyALl8aDY2QCaQckEUnYit6HGJYTMLIA1AEZQOreIU2nULlK+lxbfQfsBTMprcG0fDNCBYsxJlkJLkI/D/YBYGRxokdKQD7D/ispfd7O0dkeRAGPvj2nxlg2lv5Zom1ULxlc9Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9vdPdX7B1WPXDw67RdMWgyje7Cr6/qmcvlTZ6vl91s=;
 b=zUTFCWuzN2cdZMRiyrAW0GKjhypPqBHkdFfo7UUzLAlbpgPAp/gl185EOLemdysa4cEtg3IPFDS7Co/aZLMaCzrufwcSweWyCIOIZfpPmL1XnxKDFFQEH8BO88U8euhgOBfB81BfaDvLXJXz1watr5V9OM6fKycJIRQuA6gm3QM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 11/34] scsi: hp_sw: Only access sshdr if res > 0
Date:   Tue,  5 Sep 2023 18:15:24 -0500
Message-Id: <20230905231547.83945-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 722611dd-5e3d-4557-14e7-08dbae6614e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rn62RKYdbDGJYNSylWU16mX75rpngUQ7CFbue6ja17MVXKQjTdmXaYTpijwul3GyAO12QF1csTjfaALCbQlCumzqioE6H9iBztdrOophM28qgLuhEu2LLJ7IIJd3enblNEHZZWNH0ymdIBiH20e1eRduJHneWj2zRD9ACySwhavVxIItIj0XqjVmfKUvbC4d6vqDckpaIDtsWjMyFbO57llKOD5lbwM1/kdMF6Gvgqk8yRutT8Nl+NZRCi74oFovbzCgWB61oSz8ofh9l0WpgBb9LSIpSZi0IOhKvoRwTmlzj3D71xLGBLSTU0tjV0R/NSfl6oF29rm8qumIBwiPTbwPCyHjSXydhdZVjikrjzmL1HWMHru2ho+PTWYca9LxNJvYRpZHzpsAMhhAml/449EwRcXUPKHDshFZumbtCeB5Z7hDlZBuRXINGWvwArEZ5xg5XOmtnwa1bkw5NmwgTMhdmHOIQx/YrsmVgol7dE/067U4jWs277HK6vWZOUv8JCJwclRF2gQ6NLVFts3y74ouuEbhUHphvYh7kyR968cOa/CG1HjsG4UjDN4eiOYv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8St4bcvOEgKt0tytjKNQgBksUE2sIc4mzhwo1718QinpQ2dwPSLCOKdnaWA2?=
 =?us-ascii?Q?ObbsPlwb9EwDqDWW6qKAaxu8Km7QyTM5BEKO7ZaBPO7TTGmzg5DWkoYGTMri?=
 =?us-ascii?Q?IMHSIWsj0fQEGyVwBA35OnGPdfEdYPfEl2G3vm68q5P2BvJm6W9wWIKlE5ol?=
 =?us-ascii?Q?QADitUZdkNFsik8l56jF5jdFBrvDhB2YHz0VrrVYnKl4DNtCRftqPgw6y94Z?=
 =?us-ascii?Q?vlv5WUeCvbf5ppDy9gQ1QXATkfwHu74jD2f3GuokLnJLVX4Wx6AQ/RyWBvwA?=
 =?us-ascii?Q?TEIxXDRW4QO8Tcuznrog8KYONYsTlo4r+3374LuwrK6Pecu2Q+VCcRcKuoPN?=
 =?us-ascii?Q?cOn51DtBvDX8Wke3aoP4bHx5O25gQ8RJc4IgfWlhWY/0Ylyx+qVRjgRerFIH?=
 =?us-ascii?Q?sOVoCAIUhTW0Vg2MF54zWDKIJLp7kzaOd/STFWzizPAFWXGN2RsJ1SZ+xTbS?=
 =?us-ascii?Q?Ddx25zFoIDYpKD3wXZDHNyFseCMj3IMJXC6EK7Fx2hgdYSx42Jjjpk2s+xMr?=
 =?us-ascii?Q?T4IqvTS1uohYbBc+gP04MdqoVc96Eud5Iu5f9d80waEXlfhxu2GfOqppNmmJ?=
 =?us-ascii?Q?E1Wl83kWuW1Wq3f38SVq9a3eZ1yji/CA2foekMcLNMRfgHOoOzSj/OnK6EoT?=
 =?us-ascii?Q?IRlUV1SQsaju6ULg1NCuDoXlGGyiGdQl8bEJRGm2UrGji0Xjdql+s6nykDrZ?=
 =?us-ascii?Q?OJKCRbI0M40Bw8FJqJXUMDDinGF6iVI1IXsZqNbx0uaGJNlJqLzF5LlgbslY?=
 =?us-ascii?Q?dypVhysLaVOyzRs8pm8i5GJEBuigBU8zflSdO5rr4qXwXV24qLAnwXWylHoQ?=
 =?us-ascii?Q?f/dg4RgDi2CW3PzI3iWyvcxbxErQCXsc+tnXbKllZjrXeCbklHUBhoPRNnwr?=
 =?us-ascii?Q?SEES7lNUWAO73dfR+Pgr1CPnb3INsfiLdYVt7u4CRVnUfHYKbJGJYZs34NrU?=
 =?us-ascii?Q?Wg/64269mW6e+2kg4azS90g5zyQMPDoAikxNoV/4zrxlPSvtIdMqBsN6sgs5?=
 =?us-ascii?Q?J/FCbD5XXLxSuZzNjf307ycIuZhsLYmrvgi97oRcFdgnpXqWRwgbMWUUHfEp?=
 =?us-ascii?Q?iYIj9ifAwZs1pOUNizI8SI3Mb0PSd2dRTjO6stg0ZTw2iRVEGS3Ol5lrPHde?=
 =?us-ascii?Q?ZBWhub8oQEL24kCcrloyPgDFt5L8uH1VI1Boyz+qklpcMxtMt/BAx0VedLNd?=
 =?us-ascii?Q?CCw6xKSOFYeXLifNpSCEBrKoyjqN0Fxh7zM5HZbL060fNsSqy2PvAJ5rSCZY?=
 =?us-ascii?Q?ZM1W2Yl6PPTJ60MV2GNzb72SDtLbS1S6mJTOpPchHpGzsHdLjL6zmXwbkzAQ?=
 =?us-ascii?Q?z5FufPbGA5hgGDw5NHvHlqaa620Io2HcOLka3x03QQtXOzSBJAeUTehYdvGq?=
 =?us-ascii?Q?fS/qbLPsiYB1s9kNAxkjzIqprNLbYyGcHbCgEYv8cROA4UdkWpo8sAGHn5em?=
 =?us-ascii?Q?VL7L5jQ165ftmTZ5EXo7irqv7GLmsuXpy1Hn4zzOoY9O09kUQKIEpw09dtt9?=
 =?us-ascii?Q?eTBy+DqUx9+HGr3MWplX+cIYBFsMFBcXUjjibMw9Z/aleguDn1beiK3Tw+ah?=
 =?us-ascii?Q?2vUfjat8Qcan1/Zu+WTchuiNVQrhBcNeh1sZP5RJgzeG5m9glqkMSK8A5mHu?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lxOmcX/mCmDWeUtvRM8DsULHF8CHnPvmHaOkPvsziYoSSrjgcTmI+0EsON04ndVjQHVjgQeNSLmoaIgHyZfXojZV+FH9Lm938rHgMc3oH4rO2U2ntoJx4uiC9gvoIrIon1qSE8xRpSoNRALSrqKyjN5KQEODxFPFqHhJ3gFGo57Q7zHrReQIePLLtcOOwIw1Ov8V95ml+2ga1+LDWa2wxM7hojsArz6faFZgtFigSdKa0pM+OUDAvevdEpTG78RvLEYMITxLu6W5/f4xNGEMul6lL5fx1zKIpueO2qpQLznPnXHlZGdWFOKYC0Gb0ETTSsFdKxhnLseyZfvOqLDFgj9he/xfKPWDg6+8gLatujf9PBYNVwUwguTSDsW5UYDreS2jz49D0Vo2sV+F5GyDxq+UkkSL4rW7htJAdi0VgvhpMUnVJOrmdUbfjpAJ6/LcUV4dW6kGo0a/xMBDhEy5ROaZy7XocFfYiZIQ15PmJuNtzhP8fV+54EV/ulfjSUrzZ7c3hRDtX9aczhYNCZ9vlyJODSJEikSfHFEP8YSOXEdUIUtUY4ZR13o22bCU8Q/7LzzMbeCaW3pIhtokJ4xPXRkNuWTxhqLNCos4RNGf2Ug8Oa2QWFPMd9rRodS8Oc4N/nh1WY2jH+mf8MUzONoI7IeY14u+CeeNS5ZkrVVsPK1lNHq6lfprwkmz3DNXKBqhyHeK03xPy2qY0/YCWOJEbLnfkPPhj7IuawBjBU1tGdXwhobIWiW0Slb735GL62ehjLoVptW91ywmWCGeEupZj738HHQ98UKcAjBIrSzkVGU50jsyxBOmJP0ZF8pKXrTn7FFKvrWch9lf96I0G4EesvbHogVoOQov+haYvghCDphODGmDPXX+S9gkG4aLNjOs
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722611dd-5e3d-4557-14e7-08dbae6614e4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:06.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWjwqXheANyjp4OMmOQnZwQneAkgqLVt3FFtGH1t5YBzclAii1P/fUyvbMit5014iBMQfh1F9pRhhnywCCNoZrYGrLDuqkvQGjoJ6uJcyh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: iK8k5ny8DqIga4ry3EDKqFlQxeJxTkCx
X-Proofpoint-ORIG-GUID: iK8k5ny8DqIga4ry3EDKqFlQxeJxTkCx
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
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 79 +++++++++++----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..944ea4e0cc45 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -82,7 +82,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
-	int ret = SCSI_DH_OK, res;
+	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	const struct scsi_exec_args exec_args = {
@@ -92,19 +92,18 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (scsi_sense_valid(&sshdr))
-			ret = tur_done(sdev, h, &sshdr);
-		else {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending tur failed with %x\n",
-				    HP_SW_NAME, res);
-			ret = SCSI_DH_IO;
-		}
-	} else {
+	if (res > 0 && scsi_sense_valid(&sshdr)) {
+		ret = tur_done(sdev, h, &sshdr);
+	} else if (res == 0) {
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
+	} else {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending tur failed with %x\n",
+			    HP_SW_NAME, res);
+		ret = SCSI_DH_IO;
 	}
+
 	if (ret == SCSI_DH_IMM_RETRY)
 		goto retry;
 
@@ -122,7 +121,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { START_STOP, 0, 0, 0, 1, 0 };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
-	int res, rc = SCSI_DH_OK;
+	int res, rc;
 	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
@@ -133,35 +132,37 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "no sense available\n", HP_SW_NAME);
-			return SCSI_DH_IO;
-		}
-		switch (sshdr.sense_key) {
-		case NOT_READY:
-			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
-				rc = SCSI_DH_RETRY;
-				break;
-			}
-			fallthrough;
-		default:
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "sense %x/%x/%x\n", HP_SW_NAME,
-				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
-			rc = SCSI_DH_IO;
+	if (!res) {
+		return SCSI_DH_OK;
+	} else if (res < 0 || !scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "no sense available\n", HP_SW_NAME);
+		return SCSI_DH_IO;
+	}
+
+	switch (sshdr.sense_key) {
+	case NOT_READY:
+		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			if (--retry_cnt)
+				goto retry;
+			rc = SCSI_DH_RETRY;
+			break;
 		}
+		fallthrough;
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "sense %x/%x/%x\n", HP_SW_NAME,
+			    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		rc = SCSI_DH_IO;
 	}
+
 	return rc;
 }
 
-- 
2.34.1

