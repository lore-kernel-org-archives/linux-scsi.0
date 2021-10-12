Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A05CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E262610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhJLUh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12070 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233709AbhJLUhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:52 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CK7tF2007264;
        Tue, 12 Oct 2021 20:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8mm5x3D/iIjnR7LmKYtL6nlZScspBKLuI3nyzg8HCJQ=;
 b=PaQAK0bE74yQE/FyqjqmmWqyd6t3gKfO2RGrcsB/GKuE8rBuUhf1tfobs0YDCWe5ir77
 7ClrwnwKmtBMHoYvBawUnXlwn8A8g6js0Kc1J2x9cU034TJWyc78k3BED7Tu50tU6WD6
 llF7x9zKihUFW/svWcMss5AnX5X+zp9BlVKf8R3ODzrrq7F9bERQDGlIU0ImYz6A+iom
 8JTlcJqBnnm9Sj4TvQTHAd5am8OCHh8EOOIRBJMjxo9TeGK/kmWTR3x6yb/DXESJwYnu
 5x928UBV7H8ICoYwqhBRKTtNCiMAqGCtoAQU0i4KZ6LIyWIAyJIDhIIk2PMn2DX1wFfs lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq2vtctu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ78Z009550;
        Tue, 12 Oct 2021 20:35:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3bkyv9jpxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nURI47r1Pco39mFC4y6HYjJv9vVo70n0ibpbdzT3PZihes0wE0FH2nZoyKxo6KYobpl3y3Dq6NLZUw2rPZXYmjzYRdvzQ+vmojiQL7LCZbeIK5FjB+L22b10hr26XJI45JJj2TU0pOjdKNUoBo01HsIt3p4DCX4xHztOs6ldRe94J2Cv7gjPMatn2FKnRTleC3PxRjGbszSF81qfEvRpSLyA8cn5xJNjWOmlkZBqCXXkAa465wGVaU9VPasN5kvjkjInkxP8ETfgZ5ADwlkA2CCYhkHTaCA5XqnqQIZ02DwEIAjVkoLxLq0P1ZCecB3Rn3pu9k6YjtXsl2dl+9Y6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mm5x3D/iIjnR7LmKYtL6nlZScspBKLuI3nyzg8HCJQ=;
 b=eTvdS2mSh4J0tYEr4CbJ1O/U+jXi6++m377LFQaNVMgQrwQzpJ87BDhYupkJGGA36CLqRRo1AAzMrqu2tz9A1bxivKl8uzrVG9/4NCmXsOnfPkoKq+9iu1QEfZc9W5DawyAm8/rScou4WbsbAW9PjpLXuT2h4ODTsuXDIDgxQklT9Ee24jO9NxUOX4sy6BOayE/wi7Hcnfo6kUB7JdgnBazFGthSqNi7DgxKs/DTNVPriTpT/QieqsuMgJgFG4eMIVsJrpcufDAgCQXXJUObvP9q5pvZv9uLDWY1v+hWH8oJIg0UtLpS86pChsd4VpBpTMW5quYpcpD2pVOKlGEBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mm5x3D/iIjnR7LmKYtL6nlZScspBKLuI3nyzg8HCJQ=;
 b=ML9V8BuPjmtBilaakADNlp1VXcPy61wEUCjOkkCiVzWsYTnc2nCryLzmnhPGhpfQf78jVO1Q4/m3gkTbrtYXPjpmfGxyy8gCiCHikff4OJDg26rLVUgvkwkyGnSgdo3w/fT5wptpXDW1RcYGPXzZWVq22iKyCPT1do6miArr7Q4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 0/2] scsi: ufs: Do not exit reset of error functions unless operational
Date:   Tue, 12 Oct 2021 16:35:05 -0400
Message-Id: <163407081303.28503.12801630569753007972.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211002154550.128511-1-adrian.hunter@intel.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf5647fc-cf18-40a7-19a9-08d98dbfcfdc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55146F844FE218AFAB62E8328EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CdqpJ77iYftCtEtLhoIza1fxkG+5Hdl1bGQ5HPPKjnWzd7kvFFr47kZ1bmPbYhaLg+jjl90x6JmbbytV6qz2lrpo8YCdUjhYo9JKsyfcZu+1IfE53hp8tnQu5BTKJP9MyuUeQOsSoP4lHLfFw7BeZfivgl8+ZZRNeehYEiVij1Nx5voVitCi7R/lH8MMPlwdQfFH+i5yf5tYFBF9aw1xuuZ8c+3rUlW3rusFqv1jjUcll/ZuGXIFJuXYDKdmIReY7MoBCKM2OnSFobK+u25DOxGAyQYzsGzJ+naN8VGK+R1sW/UVg/78SenEu/6NRuxsKzJ8FkXbRTUY0rCP3cb5SFzvCJT54bkCEcOzqh93/8imtjIlrIGZ4hM/ATUigmC7sRt6A4PrwS4PZGltBp2VM6G304OV04Kw2fMZKnUeqwd7Bs8WBwxpqZ+k7Hhry3BUbWNwhTnqXgb99RkAgf8EBRv0wfteI4AYjvc0yNoCnQTbXD5LpJ+6pt6hpPzVieOfA10slnAtPxghF7tK0R32mPQxP1FnQ+MVWJTBJDCNDRiQ+BPivvCsanw4Oe4HR1BVbL8lgyo1xmx8hMNEOnsGpj+FOOJU7XGQPGJzdqjKwNjVDBOILw1NqGB0pqN1DyvxFgloQlDl+L3r3aclwvcCYWowzs+SmsbPU3pXcl33n6phG4yr233Bt6lsh6jvVDhDlMEeas5kZQAjclD+urTBbe+U0MjAnYboxWMhNepeZ7KAPCzOBUpcTdrZuQkTxv9jenIXaR9qk056z/pR/uao8Ry1If58N+CeFeK77K+DgQivuTG5YTfWYpnGVlPl8ZAzXendDJ9yXg/XtzuMZc5j6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(8676002)(2906002)(6916009)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(38100700002)(8936002)(54906003)(4326008)(83380400001)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTNNTHQ0c2pobHhQdXZkT1U3M1ZESTUzOFFmcmxPRURiMFNEbmxXTGNRT2RN?=
 =?utf-8?B?eFRNbFJYTkJGczk3UDdTUTNlY09KRzdYdG1Ya2xCN3FFSWhnbTF5cVh5bXhn?=
 =?utf-8?B?ckE3ekJ6MytxVEZseEswdXJMRnIzTDhjK0x0azBQRW9PNy9VNndXQlQ5WDNF?=
 =?utf-8?B?R2lLemdUZXF0bEFCQUM1QzFXT3hWbW1HR3FOOERwN3hTSGdqVzM4TFIwL2Yy?=
 =?utf-8?B?cGMwYzFXMEg1dnBaSGpKNEJOdHRmaEhSQjZ0eSsxTTNiMEg5dXU1aDBjaVZW?=
 =?utf-8?B?UWl6dHRoNWZVb2FVV3N4cHV0OUNHbzlyRHVMV2EwNCswV1BWdHhUZEZBZmc0?=
 =?utf-8?B?OG93bDdtUlBSNmhTU1lXNU1DM1B2WkpZUXM5eW5IcXhFSm9RaWYwOVkrWDMy?=
 =?utf-8?B?TGsrUitiNXJPTnFHdlNiUjIxMjVDZHBlcDFURmVaZ3hheHFnVEdGOHlsbzJ6?=
 =?utf-8?B?NFYwQWQ0NldCZ1ErNFRwWGVocmFvM2RtZGV1cDlMZTVaUno0NHE4SE41b0Js?=
 =?utf-8?B?eFM3SnNRbi9oT1did1dxRysyM1QxdlFLRWt5TmFWK2ZzVCtTakVXRENIWU5D?=
 =?utf-8?B?NVgybi9sa0Z1WVZUYXY2RDdudjRJcWtvZlFXT09FVTlHM0luWUcrUU5UdHR5?=
 =?utf-8?B?bFU2MjdpQWxYUFMvd3VTVUUraThPemFMQ2VlTVNIbUFBZFRrWHVvMjFmd1FL?=
 =?utf-8?B?N0VQZzdoZDd0TXhXb0ZBVXNUQXRJMHpNMGpiWFF0c0xFNTJ6aWY2dkxOZGcr?=
 =?utf-8?B?NmM3MG1neEs4TDVFQm8zRTRIcm54SVRmY29UZ3lWUVRVZ1JudWZwZ29IOUc3?=
 =?utf-8?B?Yks0ZEczLzZWM2lUNmhnUTBlNVRjYkt6UGNtclJWU0NyS0hyUU4zaG9LZy9m?=
 =?utf-8?B?T2I0NUNMZEpxaUdIVmRtNmlRZmhQbTFGWmozWnJ4aDdwZy9IczRoYjBhQ3lV?=
 =?utf-8?B?UUhBaFQzTHdIWkh0RHdlYXpkWmFoT3RKQXhDY0ZBZkFuMHJiUnFPNDNyek96?=
 =?utf-8?B?S3ZrbkF0SCsvT3dmcWEweDZpTjhUaFArOGsrYTJuK0g2Nm54NHlhMldXbzRG?=
 =?utf-8?B?UFhoK05QRmhiVmpYNkJERGlORTJsN0ZBelJ6QXA1Q2VSSXAvbHNnbmJKbm5F?=
 =?utf-8?B?ZUxyQTBEOTJUNDNkM0NKSmNMZG9FUDlXSWxHVThIWnlWU1Vzbi85VTcvbnBS?=
 =?utf-8?B?R3lESUd1OTJLQjJhZVpydS9nT0NGei8vWjUxY3JKOFFZQWJQSEsrUmhoL0tm?=
 =?utf-8?B?MWFsSm1ONExuRi91d1lYa2RWSGhnOTJMVTFRTUFDR0s3RDVhNzk2OFdYdzg4?=
 =?utf-8?B?YlBNZ0JlNXYwODZkODRXa3NwM2d6YnRhQ3gvUWRCdkFGRG1CRFJxQXNzZGRY?=
 =?utf-8?B?NW5tMjJNT3k1UHRoU0d0TmhybGxHQnZXYng0cWlXRDJHdU5IT3I2c05zTU1G?=
 =?utf-8?B?cTB4WTFkQWxCdkU0RGR0SmVGRVFMOENENndIRFdIK1N0dWxvRGJ2WlIrTEFF?=
 =?utf-8?B?R0lHVndwREw1SklDdko2QU9WcUNRU1VYMVhiQXhwT2l4T09nQzhaQmpjL1I4?=
 =?utf-8?B?WkhIUFZsSkx1bndkRCsvNnZ5MXNWUkwxRURIVUpvWC8yOHJwRmdNeG00Z1JL?=
 =?utf-8?B?UXRsRlNSRnVqd0VpRHh2Q1hKL2JodVovWU1kRk1sSXpNeWdHa1k0NkZiVFJH?=
 =?utf-8?B?eHY2cFZoRnptUWVEc2ZCQlZEY3Nra0VjVXNKdTJ0OU96Vm95TUUxaTcwVXE2?=
 =?utf-8?Q?HwgnxZLIm/fsf2n614LuPPmYTEc7W7E1cDqMRWg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5647fc-cf18-40a7-19a9-08d98dbfcfdc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:21.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7zI4LMlw72qtJrpybBjKyduWW+XOzpaYjh5OtmpIgc/f8WC8RB5laSbWuTMHQ+WCCmHoUuQ0jTJ8d+DVcevvYkXNdJLZL2gX9YVoj7pgks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=924
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: 1u9o_nPwf1DIJLujE60bADqO_LvVyING
X-Proofpoint-ORIG-GUID: 1u9o_nPwf1DIJLujE60bADqO_LvVyING
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2 Oct 2021 18:45:48 +0300, Adrian Hunter wrote:

> Callers of ufshcd_reset_and_restore() and ufshcd_err_handler() expect them
> to return in an operational state. However, the code does not check the
> state before exiting.  Here are a couple of patches to correct that.
> 
> 
> Adrian Hunter (2):
>       scsi: ufs: Do not exit ufshcd_reset_and_restore() unless operational or dead
>       scsi: ufs: Do not exit ufshcd_err_handler() unless operational or dead
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/2] scsi: ufs: Do not exit ufshcd_reset_and_restore() unless operational or dead
      https://git.kernel.org/mkp/scsi/c/54a4045342a8
[2/2] scsi: ufs: Do not exit ufshcd_err_handler() unless operational or dead
      https://git.kernel.org/mkp/scsi/c/87bf6a6bbe8b

-- 
Martin K. Petersen	Oracle Linux Engineering
