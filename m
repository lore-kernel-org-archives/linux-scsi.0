Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4C1C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E21611AB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbhDPCwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237939AbhDPCwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oZ4d043734;
        Fri, 16 Apr 2021 02:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=0y+OCZIt0DVgsK5oFUNw39y7Bci+yS52yEFRLfWvlqg=;
 b=AdTNgI1NFguYF1LofxdNxKNfEs9ua9KgnAoqtP04Hx7VLIHnBapfdYq/eR1rkG4bXMu6
 cikIzKYmpB+gDfSTSXlKdFmuAM4DaapA9ehIhN0X+LHmeAFZ43fGg02Hc/KsfOJsn/k3
 Rkw4R1tHVfyB4XISRKzqggcWuga1SZTpwGZ3F4EKkEnhZnwczE9Fs1uv3pOOavtbZ0vy
 vgnYq8A38AHORq+4SsD35geCWZsmQC5XmDhwpXUWqcDCrwqIedubglOK4mYtPSGgeygl
 Fyro+DPx3W7ARtgT/VNBIgGJLQAuUO2P/Xh7Z3TTY0pJbIkMQzEMYRj+fSTBwLp3IY8Q 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnqp1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2no6A173409;
        Fri, 16 Apr 2021 02:51:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 37unx3twj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGOQNKm2oG2s5K1DZsxITxexM4TZFLwv+D0Tt+WCsQVQrTZahlHuUhxxnpEa1T7OxNYeBXxfUZ8kpxNgYe3zdFBdhh0JOWzKO2nzY/AmpoqbpV0j2QBKPPK7ZWaiXDR6L+HFP1LcplSqmKgQPC/g0ruHNP1XRT35eY/wsidHZPSnM6psMdISm5EF+lWHm5RspGfsgnNiQieJ/EVmTRn6kPnnINrSTvaEeVKGiEZGLEcI0YNJXVy9KhMoGmXVkalosp5/g6qhAmt0WJ05k9KkC48PQSJSHm1v52Ao4NeM1HWOBUPg7qNhAszedV7mX68gPMraLRmx+bAaAsWYzJPAUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y+OCZIt0DVgsK5oFUNw39y7Bci+yS52yEFRLfWvlqg=;
 b=ONnz6gdog3IBP67Ef5FJXwC+TGRYfxb3OWKhphfca+vyhglyAmxV0Yw81mkJboz4oarPw0RwYrgqfxxAucg+Mx3licSPGE51PqTPv5ftplyaUyRSRa8RI1jnXyufSY7JLOuArIqhylX0mx0602O/i2yXdSEYwtG/s3jKrEYP1eHdhZorTMRouB4upi0X8jdIm5NyeZYNtnEW7ptLFS4vL3kQb2p5LJFWPfQD+lHyDTkuxJDnSNHxzcwj2M+BliKFSRpX07Dxbz13fhkjX7GKR2NRQ7iOdGo34IG+NPQW+JvITwPpf1r+DAcYHKC7NHRF/oKN5HjuO0rktaIcIgf2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y+OCZIt0DVgsK5oFUNw39y7Bci+yS52yEFRLfWvlqg=;
 b=emCl5EN7pulpWTKE6VUigAB857Pw30348Cfy1cCR7Mi+YgucrOohegpqVv+oZf9MUAuZiU+UDvmRNFrDXplhdd54hmg/uWIxsjtpLT3khTACSw9Q4lSBPfaxcBIqDm5YdvM3Lx3iwN3hW2T/YK6RjluKEuP3ZQEh514dLMyzGqI=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.orgc, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/6] hisi_sas: Some misc patches
Date:   Thu, 15 Apr 2021 22:51:12 -0400
Message-Id: <161853823943.16006.5125431877150733974.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
References: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecf105ff-15a5-4bbf-a94f-08d900828c09
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466C6A5F12E57762BCB8CE08E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faVTusXwZpY7lg2SeEvefFO1jS4gdz2NZjaQAsglMs6JyGSFl/mvxfQC366m9x6Hrpo4UW/DFaf6vdy6/tjaoFy1Sn/VZlqhxucuirrOP6zYvLuEVQa0W01xxHjd+71oTDS/4SkLE0zVTM4RXyhiATamT/L4j/dEz0+QrNYCknjqlnHQ1AplIKJF+0UsrWphmsFlt08C0nl6tMS/niRT5zbjm2dwN7hVNbJAcTElVUIlgORFOhl+IsHv47emKeKb/sA/khF2AbUf7DVYTqHWJyyOWshI0+weWJ8wph+b/M77zc9IWpUKNjHkY2ILTDh0Q6nNulC5SVrYzvNJD1i9vriELmIW3Un5ujU+DgsjA3mxLwSfVAop4fBhCE65FCvUKIxWE+xJJw3PzRkC/TQh4QQOyAJgQNxvHj7Fl5iASxPot3xmljPigGpmwaqqhVZlKpmde+MAJOpqaNDDltxhJVNK9+weoIvtwESHkInp5X7TdTa/yBCunwnkM44Xg+0gUFUwj/uvyeEYeRl8e74ZarburHijwtKilAWt3W0S1vWgWuqwD9KJkA8JGsbpzcwmNS0PqqVNwSA2iCpQXsSSgsMg+O6L1YUq5sv6jXBl1I2Th166HTtp9Pi1j7JLI0scPzDCiCGKHp08ohIsxtZcG/5I75jfBopf4ff5fVjDWvFA6qZ4Ki0qSEmuPkFoXMjEkI80a1MZXSiJklNxc51l2Vn3+lqLBVUNC5+YjGBWJzA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(316002)(83380400001)(66476007)(186003)(6916009)(16526019)(66946007)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUdKcy9vc1dFaGlCZWNYRHJWNFM3UkFkbUh5ZTZxbllmaFpuSjFJaFpyM2xM?=
 =?utf-8?B?di9qTFJteTFuRjdxeFFnQWRVRmlRNVd1OHI2aW5pUmpTcVdmSFJpUzhQUlBO?=
 =?utf-8?B?bWZjak9KQ1pKMStCdUQ0YXc0bXhsOFBzWjN3Y1dOeXlaVWtBam9aaFkyTDEz?=
 =?utf-8?B?eWJ4ck1OQ0ZNUFE0SGE2ZkFvMTRXZS83MzFseVh3QlpqOUcvZzJYYWNTK0pY?=
 =?utf-8?B?YTJldFp5dHJvT08wMWg2ZTcrZWpRaG9hYWwzOHo1OUVwTllGQkY3a214ZmlO?=
 =?utf-8?B?TjRYRGhERDNoSEhXcFBsVG1VdU95N3ZHcDFHMVhsektwenNETGNYWlRmb1l4?=
 =?utf-8?B?QUs1Q3BOenlBeUVJZTlkMThFKzdSVEErdG9rVnFWRUhsSVAxTGpSaXVrSWRi?=
 =?utf-8?B?SEtqT2VyQzZhTEVjY2NMT1N5TFlxcjRPQ0NRRkVkalBnaEplMzZxbkxwRUZN?=
 =?utf-8?B?N1F3bWlRWkdWYnBLcSt1L1NRcThNeXhHWWY3S1BGbFVka3hLckFNT2sxK1FW?=
 =?utf-8?B?WUE3NUlVWDJVUmx4OHdtR2hYYnlXYXo0MWhTS1k5UVVzcERyaUNZTS9oZmhl?=
 =?utf-8?B?dXNBcTBsN0pKWlJqcTd2UmFLdVYzZjVjNmF0SDVkTGxzbWFlaDNIdHBoVW5R?=
 =?utf-8?B?aGw3V0lLVHdta2Zua0QzRXVGQzVRZUVZQ0x5bVJmSWFsc2kxMGNuZWRaV1dY?=
 =?utf-8?B?QTlOMUtqWlVLVURtcVZlYXBzWVhpQkFRd0VNV0IyL3c3R0ZzZEdQL05JWG9k?=
 =?utf-8?B?WGlOVWUvL2xlcm1xUFc1MHA4RFJOeG51aUo2YWgyZndQdWxtaGl0SjFiY25E?=
 =?utf-8?B?U0krT1NVZSs4czZVTE9nSk1wU2p0YkRGTEtUMkk5OHVNVzNnc0hOaTlrdncw?=
 =?utf-8?B?SlFEM0E3cE5kSHA0S1Q2Vk5pMDk4MEFCdjZaQVhTUGJqeFZ1R3dLUXZRWkZ0?=
 =?utf-8?B?KzNudlZDUFNJYy9FVGNtdDFTaTNXMUc5R3NEelYrOW9JeGNWTzdoS0hvbHJi?=
 =?utf-8?B?d25NWXpRbDkveit6Um9DVW1saldYRWk0ZXo2bkI4RlNucFNLYTN2Q2VLOTQy?=
 =?utf-8?B?dEN0UDRKeWQ2MkNlNnY4QllUU09Pa0VEcnBTUGo3Q2ZYcFhLV09oeWRnbGhI?=
 =?utf-8?B?bnBMRmx5ajQzblR2M2dHL0E5M083b1pHcWlhWUhXcklUaHdpcXVrUnFXRW9n?=
 =?utf-8?B?UmRtelViUWl1aWh6L0o2L1FLN25XSmg2VFlSWi9UeUdPUmFhbnFDcTkxQWR6?=
 =?utf-8?B?aklFZlhWUm9ub3pzTlFvRC9ka1NUMXM3NklSVHVyYlNlTGxNQWljcEo4c3RH?=
 =?utf-8?B?ck5WUVRaazhzQmV0L1d0NlI2cmdCdEs1TGtLUHFBYVVEQlZoT085Vmg1dU8y?=
 =?utf-8?B?NHN4TG9aWWVjcEVicDJvWlVkUjZ1dUtrQmFyTTJUNXpKbzNPUTBxZWEwaDlB?=
 =?utf-8?B?aWw3d0dNOU4waW5IdE5pa0FWSkh5UnhZSVFNTmhtMEEwbkxTT1BzQ2IwUXhG?=
 =?utf-8?B?TW00eXBZdUFWVTFORHFYU3hlSDRucGRRaFBNelVvQ1pvQmpubVRiWUlsdnBm?=
 =?utf-8?B?MjQvdDZ0MkRrRXNycG1vZ1YvdmlHMkRhazBBNURBY3d6eXJocVJZS2lnZDgy?=
 =?utf-8?B?cjZGV0wzYjJhMGVOMmpZWURPSndtZFdaSWR2TXcwcHZ3azY4Y3hEOUhEY0RN?=
 =?utf-8?B?ZjdydFVnNXNTeXJXRCtpaE83dlhubldkUDdNeG5WcURoTU9CSUdyT05BbXpC?=
 =?utf-8?Q?rit/xbYOXNBG/DkznDNaFLv0LsR9YqaSPYO1wf5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf105ff-15a5-4bbf-a94f-08d900828c09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:34.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvIyfLAaNPeTRIOjb9Gis+mGiB7vSsTX+qF0MH1mslUnc52junvaWts4Tr2Tj+wEyCWTUaBjANNxtbc1xnlqeRT3O32UQAcw+4h1OGpEimE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: 1l96NhCu6kkmP19CihfKGhZ8hLah2ZKc
X-Proofpoint-GUID: 1l96NhCu6kkmP19CihfKGhZ8hLah2ZKc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Apr 2021 19:48:25 +0800, John Garry wrote:

> This series contains some more minor patches for the driver, including:
> - Improve debugfs code to snapshot registers prior to reset
> - Fix probe error path
> - Remove unused code
> - Print SAS address in some error logs to assist debugging
> 
> Thanks!!
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/6] scsi: hisi_sas: Delete some unused callbacks
      https://git.kernel.org/mkp/scsi/c/2843d2fb4225
[2/6] scsi: hisi_sas: Print SAS address for v3 hw erroneous completion print
      https://git.kernel.org/mkp/scsi/c/4da0b7f6fac3
[3/6] scsi: hisi_sas: Call sas_unregister_ha() to roll back if .hw_init() fails
      https://git.kernel.org/mkp/scsi/c/f467666504bf
[4/6] scsi: hisi_sas: Directly snapshot registers when executing a reset
      https://git.kernel.org/mkp/scsi/c/2c74cb1f9222
[5/6] scsi: hisi_sas: Warn in v3 hw channel interrupt handler when status reg cleared
      https://git.kernel.org/mkp/scsi/c/2d31cb20a3cd
[6/6] scsi: hisi_sas: Print SATA device SAS address for soft reset failure
      https://git.kernel.org/mkp/scsi/c/f4df167ad5a2

-- 
Martin K. Petersen	Oracle Linux Engineering
