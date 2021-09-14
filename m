Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209BBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6F9610A6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhINDqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61494 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239271AbhINDpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:41 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwMw008727;
        Tue, 14 Sep 2021 03:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=goSB7CPk3Tj8bQsO/xFx0xZioilTMrKde4yx6Tabktk=;
 b=JnF1/BYQ1rJxEdw3BTauD4mQT7lx88cMn+5ik94FNaSaimUBuHEjdu+MpTxVodE+DxrQ
 fTUgqVv+9FfK1wlEtE2BIxsy1b/M2pwxqP45xb844B1cNBJ5ZWk1RYZ2oTVIAVRRtzkm
 VvAp3AUszBkBTeBSV58WCiPAw5WXd6idsyBAwTmQVGjBZlZaWbc2lZRzr/b0jxyO9dBu
 nBfPxkmYZBQzLRV13ULlh3gSTFMuKIlTFxvk+Qc7QWOhESR5XEqZLAqE0AvaXDv5bwYN
 ADrXwc+A3DSyFPyPcU/mgZCONqv1DeOOm2o2jbe9kJVp32uwZ4SMviGNFwgjOvZm2Jce 2Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=goSB7CPk3Tj8bQsO/xFx0xZioilTMrKde4yx6Tabktk=;
 b=VFXQkdcbxME6USXF0TpmbXlsfT39cN7KYrSzQiG38+NPyUgwxC18dFY/GLeQV0Ui333P
 oPUq84wsMUbIf+RQMEVsF+MhV8z1U8YYWLGczklYLD1VboKNi88/l1DF6Y9lL3t4zhk4
 MKUwy6uJuKPUKT70lx/6OivSN40IreBQomywFEl8UQXPwP3ZfrufytakixOgtoBbh8mz
 X4+WziqNwtiJcoOe2jJkDqVK0sGRFtJzK+YS0AZuleP/r/yZkyX9csfUeYfoWz6DREXg
 Mphqko9paP8faO6aluLstadOYNNt9+fL6QwiPykgsNP3C+r0VLR0zJUp/lEpVGeQxWIZ bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd490-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LF097717;
        Tue, 14 Sep 2021 03:44:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3b0hjuesv1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjkX475pmlQuHpSYugP07DL0qsxMuJN+++Lr81tAmapWREvs0uYf/H9mKxgGfdGCvb2ASFocebYNj2pDlp4ViCr6npz5asm0wpaFLfHVKPMBl1lojFTcRaluUAsZs2ihL1I/8pj7su5h2IX+pKF1/z0OcEsse8CvHVdsZOwtu/lLCQ8gwdFcKJuwicWmaAL3SW6hQ/1WmOMmyTDPql4AekuwRyskZUozFxB+P/1QTfZ0gkxOsD9d4IthbsY3BEstm2tQcJYRSTGI46+gm4zJfscRKOU399VsFAGD6cddLx15aJPQ5fxSqqT2U2/6fuSO04CJ6CA5W2sy/63gKa2LOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=goSB7CPk3Tj8bQsO/xFx0xZioilTMrKde4yx6Tabktk=;
 b=DWB0zNK602ntZkwZ19kqag6d9R7gJNX6lcYkrjTCJ3v5OK25nfiAnPRsUXzKVa8cEDR8pW2CrirGfgjAv13nzBDctfTGp+7OK0Ko7d1v89rXUmxhEOto8cUxVmCJRN5lJtuJW+dziEpqReCm2OFC/0N13X535NSW8wimXoKyTbX3VXC1wgUvF9ERpQ7nVeBp5N1/FBggRD77AJp0jfeyljG4CCQNZaAFqgHuTg8CyT97jYwdWN+Jd7wFZiBPFMabpW48eFjQZ3RitPtVFQF+X1CH9covW5axW7TL17uixdFHbkZd6AaY7O8fKN8pPMbifu0sdtXPnYVWhJJJnM589Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goSB7CPk3Tj8bQsO/xFx0xZioilTMrKde4yx6Tabktk=;
 b=iK8/AY2iSdQAXdwius1z69LlgA2KQlo9KWsALOgbZr9gcMG1WATqRyoZCb3GTGIWABRwtNeQPcOxKcPpM03rtCj4pPtxzNdJ+NktcOsnVaDMczUu5POID1IcCzYqKm3fuGHmmG6Ie2BzfokNnhH9V6xZFDRkNcd/KHKvT6BgU/g=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: free 'scsi_disk' device via put_device
Date:   Mon, 13 Sep 2021 23:43:54 -0400
Message-Id: <163159094719.20733.17830625206174734465.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906090112.531442-1-ming.lei@redhat.com>
References: <20210906090112.531442-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53b51959-3316-4534-f6de-08d97731ed3b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47255A036EAA16CADBB1CA728EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ud8gakW7hI+aPG5SBm6rxZYmIPcpctG8NwOmOaFjGoYzS9Qae/6MXaVETNCwG7vI8MdIFYfpUboc8SdivDP/MSOsS7j4FvnvMeBQGsotGtrOhtsOjZBXGhe+tCbdVuvNCt2W3Z2rCVU7TLlJYeQK3zSXLbtfZ7u8JDqS5mbq5rc7lkbJI3IUuN84KcxEP/XE+mQ3esbroIJhmhmjJiIxqjs2Y1GHQ/8GGXDWg6w2HF65btd0RWXDzTKqp5nGmIositjWHTZUG5CfWUaOWqzdG57lf0w4hBT1pq5qCziSz3mDZMzxlk6l9czofa40iYsVZw/Hj1CGL4s4HM1KKgFSM1og/YPk/d2YEJNj8TKsrs6aCtmesqrx1SlvRREu9jLo3aO/eM9iD6oe/SXtSQgpoWsWpvn0bYvFt6w1guCcvmx5Br5xK6MQ9bLYbHNXcanY3iiKxTbjnXHxE2vqA1MwhoGfVIlVlmasayjNjfd8d4ODxj56vzAOpwkzogXWPXAoUG7VC6/g+6UdbRzgiWBLAnSD5Yqy3zOON1dQbQerGGuGyNaizET/6FF4Uzu43BixLpQQ8PmDLYG7RZXbU4dImPEHLwSNZEqas3Rzvprg/5vHySCIESvTZSauK+/s6Vu9cflLmGrYlmkRlDV3XBwOFQcMCqmf4IDGfPGHqZecWhI7EvgrWvwXip15AWyOH6olJr6BqOcUwi+pwXCDat8gehZg1A35x2mEbMDYSSlLBq0TiJTndaOv6dOwbwz1Xr5GA2gsw9oa0csE7bUXjHW0ToMm+V9m/0zN3xpqI1g2XZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(107886003)(38350700002)(66476007)(86362001)(26005)(66556008)(52116002)(6486002)(8936002)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnhqRVJhNWYxOHVWSXE1Vll5bFlpdDBud2U5RUlWZ0JpR0pUZExHUi93SklW?=
 =?utf-8?B?V0JGdFU2Wmh6Q3ZUNDhQYlBFZ3ZKbStUOURBY2YrbHY4WUFnL0YxU1IzT09x?=
 =?utf-8?B?R0FHNWdjZ2tYYkgvemVUMWc3a05ITXBmeWI2d04zQ25leDlkOEhzVU55d3lC?=
 =?utf-8?B?VmJLa3hCY0t0dER5TkFOSlNZN2lKS3pUTmxNWmVzSDdtdUJQTUF5MjVhMlph?=
 =?utf-8?B?cFBsUmVWUDRYT015K2RxbCtOU29aMkRhUGxuUzEveTFJWHN3elFYNGFyeHBP?=
 =?utf-8?B?QmNtdlR4UzZTek9EL2xuZXprNXRDZmJvRklDMS9wUGRJUzVIY1NVYTN3WXpN?=
 =?utf-8?B?T0h2ZHVYbEhjaEtkSm9vQlB6OG1NdTRwYTJyay9YZElLd3ZoOWtNU0hRVnN3?=
 =?utf-8?B?eG9GQmk5dVVLL25RZTB6aVJHZElBQnRlbjRFa2kwWk5TTUVvV2lYbHcvcFlj?=
 =?utf-8?B?czBXN200UkRKVE1NcDlRMzBQSlU1emRlSDhYWGVJeUozalYzc3ZFdHZaN0Fo?=
 =?utf-8?B?QVpRR3Mwd0RwQ2lwN0RlcXl4QnF1ZGxyZ0Rud3NLdFowWjhNaDgxZ01UV2hD?=
 =?utf-8?B?VHVWSjg0anMxOUtnK0V5b3diZmp6Q2MvWVdpZFlrMWZkNHVzVTlCUFZMaDhK?=
 =?utf-8?B?WWJncmZtQjdOa3hEWDJzWVBCZVhGM2tSKzBtN0Vjam8zTTh1bk5oTEpsT0oy?=
 =?utf-8?B?ajhEcS8yS2hnWUJ0djJwQ3g2S3lDcmNVcHVGOEo0amhCbFhtRlNaTEd0dWN6?=
 =?utf-8?B?RzVnYVJuWjc0a3BSbmc4ckpkRTVDRC9PcEdabXhxN0YrRXpXWmViaUUxY0dG?=
 =?utf-8?B?SDhweGJCS3ZFNUppMzE1TGowdzBZMjZLRnJxUldQU3M2WHc5OSs4UjRFUm9L?=
 =?utf-8?B?VTQxbE5iZkY5VmhQRGJxM2Y3T2ZScXNoSm1OVlhGRk94ajIycWVJZE1xRDhx?=
 =?utf-8?B?RFlSWEhWZHNNakIzczA1R3dmYjhnNWlPOGJlRU44Y0JNSFFPMEltMndjUGxV?=
 =?utf-8?B?MGtmNHpVS3E1bG9qN3VmdmZRNlJMS21zc3pYY0o1Z0t5bzc1ak1VYjRQTk5B?=
 =?utf-8?B?SU1WOWRyYUtlZTl2dUE1eTB4T1Z0Y0s4RDFyTDRkSGtRUnY3ZnZFL3BrVUNV?=
 =?utf-8?B?MHpaVjVsK2xoblhnZDdHb3YxS2IwelBEWWZ6dTFjamVnTTRkKzRZMGhjZkp2?=
 =?utf-8?B?aVI2a3VSQmVXYlNrb1R1SU5EYUI4VENsOWRnbkdwV044WS96VUlTV3FKanNH?=
 =?utf-8?B?eXhvVlZxdlA3UkhCRFhwUUdKWmNOakFRaVNUQVBvU2hTeEZUa3BHMUVodUw4?=
 =?utf-8?B?SWpITzhwVjZxUGhIeHEyYVpYZDExWHJTWWViS3pJdU5LWHpMbk4reE9zVHd2?=
 =?utf-8?B?dnltbHJYK0Rhb2lJemhRVVFaVmx4bzB5VDY3OXp5WUtTT3Z6cVBEdjZjWmRk?=
 =?utf-8?B?VG5KSnlRMUN6WFduVHM1VDVkSElZcy9wdzQvQmJaRzR6UkNSRzg0eWNwSDhB?=
 =?utf-8?B?cEVjalR3SmoxeTRCa3BmN0cwTWxtSWFtTUp3TjdhUkhOczJ5REMvUi9JTk9F?=
 =?utf-8?B?S2IrUzhDU280blA2dUp5M1NhTVd4WFM4aUdIcTRtNjZRNjVYZEwwbjBpeDRJ?=
 =?utf-8?B?dTA0MWFvd2htQXVhWk4yK0NnbmhOekFSN0xDRW1wZ1FlOFNSU0dlKzhCNVhn?=
 =?utf-8?B?RDk2T3hzYW1lUzV3ZzY2emFPRFE3VWhYRzBSWTArb2V2RCt6RmJCc1BFK1Er?=
 =?utf-8?Q?7s/YZSyJLjGcT8hP+lX5+vgKskMRUVUSo/RrtNL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b51959-3316-4534-f6de-08d97731ed3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:16.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvFTQj/gqQLbKmPRecprm3gGxalhkymOS/hrjZS+3l827NQRxTepgcBltu3oDq3v1ezkORdEu+HzBFoK2eKqY0VLykZj/TNxD7f8DNd/yMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=765 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: xjS20oNyHJ81ppTJWPrCW9Gxc61MTVD6
X-Proofpoint-GUID: xjS20oNyHJ81ppTJWPrCW9Gxc61MTVD6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 17:01:12 +0800, Ming Lei wrote:

> Once the device is initialized via device_initialize(), it should be
> freed via put_device, so fix it. Meantime get the parent before adding
> device, the release handler can work as expected always.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: sd: free 'scsi_disk' device via put_device
      https://git.kernel.org/mkp/scsi/c/265dfe8ebbab

-- 
Martin K. Petersen	Oracle Linux Engineering
