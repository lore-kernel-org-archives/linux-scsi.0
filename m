Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC571E8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbjJCUvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbjJCUvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:51:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E22AC
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:51:34 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4AHx025017;
        Tue, 3 Oct 2023 20:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=sxD3lxNcMM+I6m3rJ1JH4Nv3xVZVGmTmuSrCCIU1ec5dAQtcCWfQRGM5w4rvY/+v6r5v
 DCwPkNblckWFchfQEhxZzOQ963d9N/B4eeGWX+myAi8vlm3bYPZ7M+zO48ZhVigo3wro
 yhWrIGLWbiUK4jkAWc4XV5zna2ZBv9sigmcmOhXkYYQa6ejazOuNs40CB4PTB4RuhuQN
 aQ8N9o2QHVEPgTZzc4jXlLHI4/c8PebYswxFGM23M3SjDygIutHrkkCsCdhXlqUNOpoi
 gwTYSLMhkkvF2npqCoDC3QCVTO+Pk2mP/SVFaFaNCEtVgYUnVlw3/TWCIjmEdGbIuBPB MA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebqdwqft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K1L00000426;
        Tue, 3 Oct 2023 20:51:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46j5r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADWWJljbv0cwWZsZxalbSKAVWPMYqtPnl+iumocV1cjDPTsCH3MO6aVM3E31jblhKK2qgmZ6wnwaeqiFbFL9B+tI7SS/Aaaw7evEKIoTvyppPyuxHsIKUAQxlWlc627TK7W7ZHktqjWwkuFgCXbi/KezdXztMogkvuc4uX3PMcJlsKzKe7yjz2eR/GAWvZZEOb7rsv6WjzaK+Wjv6ouI64WzQYkcVxQZY4lxjWQECKk3rTCruefPN4tNZ5nzmCBkzKhmECwZiLz1q0+CU0a8EO1QhzMx0MLpTKedks/8BbxkSWiN0RHvrh/ut/LIknaRrRyjuCOV/3WHffUxqraEcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=BQe0yPLvqmybECOtTXfOE7elj+Esn8ii6lkqltWcsRUKLdyKy4FJBosxWBWMshfeRR6KTlBmvbrgQ545wVV4zxK6bDwq+egrtOxFoX5ezUKGGWya8bTRie/DdmWoWUG72KqG6nV9Fx+tM7nt5ZKndfUq+XsAWec4UDa0S50leIepvOzPswv2Ck5e9yygBvcjXcGdGHMRx9v4JtRfoH61xFg3T6TpA22P6S6/7aWdfGvu5GanDnuz5S2OARscXdd2IDh6cflvzK3L7zfT8OpPF/92W7ZdHz4yLtlorieP9IrXu92NHMSS83l3lgggv4e2sI4DJSQlB+3bQh/RirPP7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=qJEbb2j+Hn345URFQi3IWDaFpDEdHG0MIYHIkmaiJ5F8r9YDaodmDnlor4LjBGwVhHZjZ7+jHzRqLFZSUMCkDJHZcJW16cQFjmHMqlb/CiOP81AaBbV0qlgU/0xrVD2P5SNkMzAuUWnMmp9mf8LMG6fpFlbKPCDROXz7dEsiU2o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/12] scsi: sr: Fix sshdr use in sr_get_events
Date:   Tue,  3 Oct 2023 15:50:54 -0500
Message-Id: <20231003205054.84507-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:5:120::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 4354b7c1-8726-46ee-93a7-08dbc4527ff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbuLm87NVluzbB1IQZHYku4OuSFEPo7NaoaREoX5h+Pjyw4JhQkpN/jl8Zv11ORNbCZhjJoGLUN4b7s6/5V14wKJ0XE/HxZWEYzk3h/3dsneQajGSDt6TNZR8rVYCn8LAJpbtBLcPrDKGsmRi7fgI2sy9FmCtrjufbhPiGOX6Xc8QoNGYjvJKKQftbsUyR+BobQ1NZGALZqr3TkhDw+4JCQTBOqKYRp9FFQxdeJBAN2qtLXZUpePi2wimvuNi8BWZxNuxZOEfXjDCkmaaV/v6myw8gLFUmvDzK8YJCxF2Q6T2dWTAR+4vbTDenGHbUShcK66QVEGqdhRVP0Q8XWUq5ACduwQ8RlDC4NY9hd/mHCgFzlMSHQ92TbGupW3Inl4g0KgYmuGBZJkdhNrXfuod+HLF93fciqlViXbJ0zlizEio8Q+3JfP4PZIOwSmOiRpcBNLGEVYF9Afd6P24dd4r27iYj/ouSPgwbr0lGgq/uIxhAWu6fT42/oOkM6zkMkKe3X4tFbXG7pTAg+Y/a7SuK4IzhyeI5GinBUdkRCqOxZMQi2SEp6q1ku87JALM5aV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lsFXUcgWZgOlHzn9D41xas6CNGNKxwBRCGDqmytETLgB+Z7QSQTf4zBo7FrA?=
 =?us-ascii?Q?6kHpgqWrwZkigRwlHrcoOEmeFBOkeiUEeKlZpi/CVcQrp4fYvCaNCXp/o/fv?=
 =?us-ascii?Q?EFBRMP/dO0Zq3JYpkwEGEPlskBlBAQoZnEXaqzNa6gG2tXsYKPYUEApp3YBl?=
 =?us-ascii?Q?faIU8MgPOotwtAvtaMXrBsp2GLWJzO2EKL4Zc2Ax5o1yRaHcKDJopDRsyOMb?=
 =?us-ascii?Q?SndFdERPczIE2Zaqa1A8XksfodF/AnmW0nnQAGHdan9iGtFl3o9FjiSb3GAv?=
 =?us-ascii?Q?PuP7ljxCX/yrLiqb+0ZgphCKZSuU9ucD8uUU5VqGwoik23LYcZc/UTBH6TYc?=
 =?us-ascii?Q?aqS7E7VgqXAnKsV6cdoaYX3dDoJv87Sj/uDvhVQg6HipCtg/WzAGOc4PvUYa?=
 =?us-ascii?Q?IcuSiWrlyTIcmgpulf0z+Ky3FP/iWHMazUE14etCYlM4+e6NMcqOAKt718lh?=
 =?us-ascii?Q?AUrLWwTYKBrhmetz+Lm0JqmGQKXrGarzNxU2vhksuGnHOmR27upRDVLYIAWp?=
 =?us-ascii?Q?eQo45kPLYW3S9THT5JZ8davyED1NNp262QwODNg4Sh+f1h9gQ2rq7LQrIqOX?=
 =?us-ascii?Q?D4NfIZsfz4Rz9BvN8W1XCzrvxOznGPdQte1fnA6lmDsGwQVq3jtBEfnt4tQE?=
 =?us-ascii?Q?xn+UurMuEqY0JrWmrf1VD8463GPj19a6vFC2VxPXADeNGtWAUp+81MlSK913?=
 =?us-ascii?Q?afBBuJaUHH4aOeN9NFmflHNao1r8BU4+j9H8Bl6sHB9AHMpbLSg60x6GsTWU?=
 =?us-ascii?Q?ffMCQOijSfkOWTtOek0VoZZEFygWln23mxaIIbDydZeM8dzpEfa7vQ0CwKZ/?=
 =?us-ascii?Q?5luwHdxcpr+3BUYNeiSiAghTFx4SC/4xHfzCy94uQ8UotKBRmu4c0TXBq1LX?=
 =?us-ascii?Q?p1Kub/0+aplqji/SbqQSZaWG2Or4VKPAAYGPWvbPga5I6nLx9JbG+ChtvAPD?=
 =?us-ascii?Q?Gv6Jyycw33OyfZv+GgtIsQkBjSQ6SPxSLpcFysIpdIrmzcmT9lWqS3mJ9fHF?=
 =?us-ascii?Q?Q6jeuz0txN3hP9ZzgjXIBXHgja7B2c+7Xb+KJGQ7t5dVI+HH8iSUEwmeLrMp?=
 =?us-ascii?Q?OHtd5ZMQlhK0J61hItfkrrw4F/Zg4OjUpOz7b5VnsyQdgq7Gd2NH1Ies4MIt?=
 =?us-ascii?Q?Q0YdBgk+QUZhIEJkfuw6SYin7IUcm6bAKIbaWEfXagPoauK7aZc5ASQsIjZT?=
 =?us-ascii?Q?U1PNRS2CKqOasjuG4uhzH4Wqs256ZisvEulEzWLbca8WT5i+3UrkF9c7Sida?=
 =?us-ascii?Q?1YQaJXOF53iV867/5SRMB6JCLbom9XCYTrDBp/FfWV4hsSfmi0jLOolDTJWC?=
 =?us-ascii?Q?ZXnbRx5i2bTIeMmUCpfhUps7DfMtXTiFd9XjNQxSfjpHnKp75bXAGrPNx2OL?=
 =?us-ascii?Q?UoQpATuas51wgk30zErBH7KJrgTw8qBZqe3WN0Bk/TAE0jJqQh+BUNtUkaH1?=
 =?us-ascii?Q?PqfU9P9IqcJiKN4ghWVh6LTS8cvrPkPqBbG/4KIHlMf8CxDlaUXGygdHa4Ht?=
 =?us-ascii?Q?PM7160nbO75XwJo+Ah4ixqJFBUh2nK27Z+jZUML+XG2VYgpp5sb9OMtQlrQI?=
 =?us-ascii?Q?xAReI07wMoOhIjW2zYMVxNF/1o0N2bWxC2EEqesAY81t72Fs+s7CFvsuTvCE?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YsWvgrFzi7H3rpFiZAxIDgnVLgW+L1jpL7fOn7/jMO3FIIL+J5mCgh/E3X8N4WilocPjNNBr6q2p7EKHjbG7GFXRreSJY43jwmhkbOJxB+e4E085UKDtowJW4BSX4sXpj2Nu/Bc4/RtOfrv30og/BAPbonvpvI9iLFQgNsiYL6RdJCyZx31EjtJUtR1sTCKN7IMuWd0Y5Xv0+8YG7KDikKAlbv3fhICbXF2PP0moalz/HyNR/vO/gzotjHpseqrXufZmnSri92wGn/J7pu165rmqv0yKsn63KRApKYJBQgiM2ew73oe0nCJnu2hN+piLY+pSLxY0QsLubfLUOjNFz993t0S8VdZgNzR4+zTfnyzREXmr2qK83SY6tfr4GSaanJffc58WpuASxPEea1zIaYgTztLGtUEx4n9+aQ3WyjBgbwYIfbW/WeJtrpIckagAJ7IJTj7esMQOQqRfbzScKTlswOlSqxdYTBySQK38meiuwWMl6gCZzAzSbC412Wt0cpBOwD+5Eu0ZNb2FDoudruRADFgBOC6EtdsPx4U4Xjv23icZgcFreYHcPk23jUl4YnIuYP6VKdWN1d0+cU+S0/wwSAYsjZn6oQPq/RiGVhqPtwulYkOaiMN/tagW04Jpv3PJL3f10I0vU3gY4r0h0NWDvr1QUXOFsWBN1XRipsB1H6QnJO5lMkYt5Z5RTE0S7ugP1zGcz2gtibHQhMBFbHwpQE5rtusd+za4TwR50XNIBtLT9W6JdpbuVlBEEz6T9wgNgOj3p/MQfiep4GEcdPAsennNjRa+ecWmwTk4BbNuIJaDVoS5Ghz6Bx0tu2U58yA+U1DJp1AcrAUNdXK0lgxTsoPH53BkCoZDOTafKE+tzn/c5HzzRz18/DDHOdQj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4354b7c1-8726-46ee-93a7-08dbc4527ff6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:21.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7dITC8lMJNgvQ7637kznTPviKbCXida35qbWJp9b7AvqGSGzZdTQZoDJLbM13vcEt5JOX1rJ1d/3DjVvsJ9b8LpVprG3ExshECTa+k181w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310030158
X-Proofpoint-GUID: IxeN-RfX_p6DPCn-UmxodY8Wkh7CAaCi
X-Proofpoint-ORIG-GUID: IxeN-RfX_p6DPCn-UmxodY8Wkh7CAaCi
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
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 07ef3db3d1a1..d093dd187b2f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
 				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+	if (result > 0 && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
-- 
2.34.1

