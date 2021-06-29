Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD11C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5888C61D4D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhF2EN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65156 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232066AbhF2ENN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:13:13 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T47KLr021979;
        Tue, 29 Jun 2021 04:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=H5YOHDUerAgoEwLZXTUbwh8WxxHrpp/JcAQk9vvmrNQ=;
 b=FIPwhBCc1KbWJw/QH+y1lW9T/educ/44Z94rBKmh8/2xGR80hVPU6v9fdAMOOWlIwVqr
 4A3yhtPCsOmCEJG4QRa4K68WRLczsgCw4S44e3/4LxvsuynPTwl5CMYpNAoeAmLGH5bF
 bLUD4aUzkkD1u0hBLn2VvlrHvXy7rk40+aXaOIfQ9Lgp1yXVkxFHvzLWU6P43RkcYxl6
 voZleZjlAuHJRNBckIFfAZs1+K2NzrDl3n98CPf2e+M4zLxhphH2mN3ZzVq5Oum7pJr2
 3Ip0VBo9KTWEJD+YZqkdzJR7pln25XCQaEiURyZo+s2JNcBvw12CE4YeW12eF+4uxy2J bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f1hcjsd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49pBo150664;
        Tue, 29 Jun 2021 04:10:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 39dv24tfen-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSs5OpSnTgrtueJ28+lAcVX06SjOv9KzR5ulSvLuGygzFUJvyaO91ieF46XYCDVdJUwi4h9aFe/mZu1VjrpzYPHEkCcG4h9f73EQPiqKWEcrdwcRwITGmFXSB4A5jgfSSlDw54yIZR3KsR501PF3PG+MN0sPp8wkwMyEcVjoMVEkBn26wEWsH1HSUgOqwrdBDnI7rp1yPf77fts1Ulg0EZmf7lfndKIuK71U8sNR3Ah/oqNNkM7i0RRDEM6ZzuFRmueUTjLN/rxa2JTnYEDlXBk0NCSCNOIdyk53KGzMQUN4WYOFHiz2q+GfSCMQiXox1oAc6zgpGw+AwWui30ZWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5YOHDUerAgoEwLZXTUbwh8WxxHrpp/JcAQk9vvmrNQ=;
 b=IVNX3KkgMLPQMt+s6jAxcvJEKdDnSwSWDtUlBKVEXiFL/UeufuFWNJa7YoKXRKaKfmPnUn/SfRsUH74PcGxRom3RGUVpGg2VM0yWFtNL4NSrSQC2frfRDB+AFTcdXUaf8pXQqVije6RRGX0IYaVo/KUDDiNKQDV4ZvpPNyCKyB4MbQSamwY4nIn3kQ+z1jJ3M2uFl1rHYncp4BuW3j5+Kj/eQApgS6hgcV0FR9pK0GSPMxBZJNI9KZCWj8gHT6XARSmEqo/C34/zjssZQpsx298PSnvzotG5FVR/i8zIxTe28qldPzx8ujERE9ZJrv/iZCcuW3zZbc2XbsosBy/1vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5YOHDUerAgoEwLZXTUbwh8WxxHrpp/JcAQk9vvmrNQ=;
 b=YOewQcsWGtIpKxXbo8B8YYaTJ8zoAsriPSF+Wt+KVZ8wJkalsfHb0Bwvpa8KugS96V7aAvMeNBbqJBR4G1ZxSxDPW7sPOoGVcvm7tZp9+rj1UnPKbWLTjRBvUpLrCjd8BWP6XRaIp8eUnOrkGJn1EY/hcJI1Zi0USbykw5+ePV0=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 04:10:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] virtio_scsi: do not overwrite SCSI status
Date:   Tue, 29 Jun 2021 00:10:07 -0400
Message-Id: <162493961196.16549.199367417824259702.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622091153.29231-1-hare@suse.de>
References: <20210622091153.29231-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31104453-aed0-4616-21f8-08d93ab3d01e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471128AB520721550D9C70568E029@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFT+HHeW7QcVL/ja/8+2rR87Ly+nnOSFYoOTOKNa5EC/2ADUJoNgcZk+/wej0qv4ZcLkLrCp+7IO0cd1wbmSSZMZcACD/HyVaGJnmbiEhhtzfWpAt5dM+X4AuWprs6NB65X1J7jc/Fl1g10lVUL51KhbRNhPNz4hTr9ichcAuS1jhZZeiNQM+TLZQ7MvG+70D1ii78+WyodSdfVbHQgjqaAAvapmsCOdY78mb6LDXfDanNw7f4PYksguiUk0KdccKFGRQ+BkFr86hrXDgqRvsTSAG9jxDRByI1Q6RsCUf2VTrHzLg4aFx8Wowy+lRJmgA4enod+8Api/EmWZMRSrrHyBS1EXfC8oFSxgGjKRACYX4pt86Tj9MEbgEaHovz3og4wIAw3Jn8lgJdmeGAlXkhbkSnI+g/h5mFPLmHskORS2H6QJvgzBwDORsSCKei8+a5EsSzxISsdb67p/VFiF4aB0ePvmEKPDSSwzJrVIxJJqh2J8oRJ7wja6tgCsRrGz/DZOUy9zn6guEECHUk3IeDi1ZMf6qdxtTx6u2x+AX0GodpTVrWrbIIeMhufQaVNAUireTBBCPF7P8vGISyU77URNTqNUUv9TzeKaa/RMvHhJOW3yg4sSb7ek9OgizSwvaSdC7O9kx63ywRsZSmiZ29GuAw4LOza7T+srvjyYehLrEc+kv4o0jZdownDCWidT74A4DtIFLWVFuzSZoH5blCWuZ2Koaiq7KTBrVT2SKaMSjWQ3i70BLtITw5/WVNbFl3rmNTRvIxyy+v2L8y+gJSfA1xRuiOuntPiSjMp6SfwMVHzKqMSBUIIj7xvOaOXY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6666004)(316002)(6486002)(966005)(26005)(38100700002)(38350700002)(16526019)(186003)(103116003)(54906003)(4326008)(956004)(478600001)(5660300002)(7696005)(52116002)(2906002)(2616005)(66946007)(4744005)(8676002)(86362001)(8936002)(36756003)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW5hN05OTnF3UmR6ZklMUVFuL0NmVlZ0Z09oQnBNZE1tcktCRnl6WFRyV2xh?=
 =?utf-8?B?RjRZd01pUE1TeW81djlmVFEvdVlTQXFnZWd0SGNQOXRBazZPWE9tdC9odnFa?=
 =?utf-8?B?NUEyV1JpQS9TVG9NdVpDZVRGNTkxempLay9GYnM4MzN2bXdNSG1zUTNuSllB?=
 =?utf-8?B?akpSMmlrcW5CNXBYWDZrT1EzT2NreWFTb2oyUjQ3NXVKNm41M1ZBemoyajZW?=
 =?utf-8?B?QXpNMkg0TzlwcnRNaGcvaGp5N082RFFiY0Y5ZmF0bHBVV2p3TUJlM3pOWGZ4?=
 =?utf-8?B?MGl1RXNhMTNUeTFoK001M1IvSkpyS3FRc1Z6OFhIUTkrRGJqbWhyNGxJR1lv?=
 =?utf-8?B?Z2lST3orcHpYNW8rQStUakFkckdXM3F2ekZhb2tGdXpQUlZNeTVXQTA3dzIv?=
 =?utf-8?B?aTFKNFh3S0FlN2JzZXZqT1Q5WGRBaVRqK3gwNldkRFhOeGM5NHVxZzdxeXpI?=
 =?utf-8?B?WWpYQ1NLS3UzdFZqTXNNWnJPNlZ4cnB5ZGkwNkRXTXhKVGdER2pwd2hyNXhM?=
 =?utf-8?B?QTdwTjhCYStZcU5OU2FCbzc3OEt2UEMvVkd0VG1OcEpEYk5MY2ltMG9wdHc5?=
 =?utf-8?B?U0ZpaVBHdVdmSno2bzY4ZVQxeVRTckNxKzF2RlVEQTVFSHA4UXQxeCtGb08v?=
 =?utf-8?B?am1jUFJsYzFNTlNlZ3doamQ5UnE4V3Y1RHhnVUFlYXJyQjdia1dnM2EzcCtr?=
 =?utf-8?B?bk1yd3J3by9MWDk1ZDhmVmM0VXd3OW8xQWVCa1FxVVI2ellOa1UwVDlTaDUr?=
 =?utf-8?B?ZUdGbTJZNjAwNWVYb2thNjdTSnFyd29KVHpkV3hZWjZjdXhCZ3J6Ykc5akta?=
 =?utf-8?B?WHJPMnY1cjdXbmtza1R1R2hlenNRc0ZWZDg0Ry80Z0JKTkVhWkxkTm4xcEhl?=
 =?utf-8?B?aHNhcXNaVjhWZ1RJSUVMaUNGSGF6VnU0bjJvMEVMWjROTjc2TTg2cHVQdWNI?=
 =?utf-8?B?WnFRVWFURlM0MHpCQytKRVpveXpob2YzN0FIWnZ2ZEcxK2t3NmtRR2U0WXFk?=
 =?utf-8?B?U0xVQnIxa0x4WmZPcHJWM0pJSnd1bTJuc1ZPODNDUUt2T2xPNjFFc0N1MWw2?=
 =?utf-8?B?RVQ1RHJaazJYZWplOStJMURHajRSbC9lTnU1WjJaSndmUGtCdXpjSC9FTFh5?=
 =?utf-8?B?NHVuQVZlRlNidzVSK1ZYd1JTb2RwblcrRnl5SU1UNmJ4OWtmazBsNms4RUdp?=
 =?utf-8?B?QXVqSHF4a0lsSXpONjVobG1sR1FxaVZjcTlicWwwWVIrdkhTY1ZJY2NDMXJC?=
 =?utf-8?B?dG1UTm03L1A1Zmp0RVJhZndPU1ZWN2FyWHJwRGhaY2JZY0dBSk1YMlp5dDAw?=
 =?utf-8?B?V3paV3I2UmkveWNaay8rbmpoVHdlM2JHaExURXdJYlI0L2U1aHZDQUNabGMv?=
 =?utf-8?B?ZXR0NHUrVlZzODhMV0tiTE1uRW5leDdPYmxYZWZibnNVQ0wrdHlEMkFRa0hw?=
 =?utf-8?B?bThPL2p3cFFjNks2b2VQSnpVK0M3NGxrVkZxcCtTUjM3UThHQkg4ZkFmaTZC?=
 =?utf-8?B?bXlGUENjenhxNWJQV1JqYzk1dVhkY29QRXMzajFPR2cvWnpVSlY5czFRRys5?=
 =?utf-8?B?Q3QwcStsYkZNSEd1b1ExejhrSHRDM0dNcGxiVHdGNnE0WTVOaHRtU0lITzB0?=
 =?utf-8?B?bmE3c3NPZDh4VzNGSytzbk1seDJUejQ5b0FyUnhNTFRtbVZMZFJIek5welo1?=
 =?utf-8?B?bXgvTEFra3JHTmZOQ2xFUnUzRWsrbW13aHE5NTE3ZVg4QXQzNUpPaFdZam9M?=
 =?utf-8?Q?WCwO+/eSSNo7l7SFDYOkiEH7fTjc2r1mLJA5o8j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31104453-aed0-4616-21f8-08d93ab3d01e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:21.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xkiiQzZZ8PJzVk0ZN6Ge9ux8h44Xs97d7G8KjxGZlU8lSjaAkC8b+7We1ejCc92oPnp+g57fFBfFbNn/YaHTPpdKEANGQ6aMcQcdJEXtgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=895 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-ORIG-GUID: CsxBW0-XSC2Yg8ab7IZOeKxB2oLuvl_F
X-Proofpoint-GUID: CsxBW0-XSC2Yg8ab7IZOeKxB2oLuvl_F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Jun 2021 11:11:53 +0200, Hannes Reinecke wrote:

> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.

Applied to 5.14/scsi-queue, thanks!

[1/1] virtio_scsi: do not overwrite SCSI status
      https://git.kernel.org/mkp/scsi/c/c43ddbf97f46

-- 
Martin K. Petersen	Oracle Linux Engineering
