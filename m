Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8B7C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 02:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 379F260FF0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 02:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhFAC6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 22:58:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40762 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhFAC6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 22:58:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1512mviO041188;
        Tue, 1 Jun 2021 02:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8n+LDmIPZ89tEgbX/30GZ0b3oDgmTVnGJquaOKGgCXs=;
 b=L3mLrCiiloQKAsjOtTGVTZLPyPC8RPHhrWtbCCy2AZywKW6DiBpgDObAr0M66oEcr8qP
 WihGWBAx0CKAgy9FiJ4QCLXgtJvuYZqSrzkq+3FDJ6S8OAErVo6OHEKFRAnK3G+4fPCE
 G5ePXoEdGiRm0KMZBCI9cE5p6WiXlGwQSUHthvKXg7bp0vb/krT0wGP+x+q7rspaVNJ2
 SS5eJ1WKuXmw0dHLwOyj6dMJDJacj7liz+ba1RNkKm4Jv6yUsCsiLZFRIPysX8dI8iJ7
 OmPpfXgZtg8/vR8eAbkN8Oah4o1tBrwJ2xWL2qx7r8JfVuSLOGR88faKfEmdc7eAqGbJ NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cm5k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 02:57:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1512oYfi182211;
        Tue, 1 Jun 2021 02:57:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 38ubncsk6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 02:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7YcNYHgHjdIk2NhQ3ZoluAkzmGqPUqSOHNmoOx/acFyYVo2fUTRhrcDFgH7nbYF2/acAJppKEN8Zu5P2WndXUWUr4u2+t9KkeuLykepMtAAKwNhLX+PLoZZGy0Os1EAC7NyzRs8zmmoDEczTPlnsxx96sXhSBVKLs+Qyoh+khTMSCfM+iQg7quqE9uEdXX2qEGfy1h3gLpTPZawoj3/n/uncuL2PssCmFM6eeFxJmNkgK7PZeFJPWGXbgBOSNtzDg80hY5bmg+lcgvsScuXyDn/8oYGoDezGYb6W2kSv8fbR4fjPij0AZl/AWzUMk1rG7TlLnYqsCTw+EaKgfrfkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8n+LDmIPZ89tEgbX/30GZ0b3oDgmTVnGJquaOKGgCXs=;
 b=mZBLN8RjySQeNVNHgYv72glXEmPqQnQNUWWqny+ewbMM7ZXIQvZzvvs8+O9OB07DQeQJvtvcC2PuP8/uL42eQNHeDlDDxi3PbwI7MH3zNWFmy4ijTHR8l6RpHmC5YQBTPsmpYxC0PfSJJqwszYGXmlTZypWCLrV93AJZKikvNlQpWEx0bgPNjXEHYACsCkU0jeQ51WxgJ/5wUuTxxqGrSfnOwIndpbiroS3bYfgVolqO2MTni5BSZ7aVaBligj4Ltsa//+AuR0LB1GNSFvBXWD4JOgZsJUrw79dctV7bFUQI7PdsTtKf3ZM2pU3eNb0ho7pqirioq5PioO2sr9NnpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8n+LDmIPZ89tEgbX/30GZ0b3oDgmTVnGJquaOKGgCXs=;
 b=WphMND82AsAyUpApqFmDid7pFnph6dcfSog2t1uWYbwr+oLCP8S16nvcCH79mUx/cpCibcpvrBF1SvedCKMHvl0ZowoVAex8ldszNZlmKW2JsT6d2cZmxDnlbiX7Sr+u/rhzN+l7dIpFTsW+kKxSar8kG4C+CFXKqSvneG0+4DY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5451.namprd10.prod.outlook.com (2603:10b6:510:e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 02:56:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 02:56:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [Patch 0/3] Gracefully handle FW faults during HBA initialization
Date:   Mon, 31 May 2021 22:56:55 -0400
Message-Id: <162251618782.18318.4760619829197225733.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
References: <20210518051625.1596742-1-suganath-prabu.subramani@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0176.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0176.namprd11.prod.outlook.com (2603:10b6:806:1bb::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 02:56:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54db53bc-6b12-4d9e-d063-08d924a8ec09
X-MS-TrafficTypeDiagnostic: PH0PR10MB5451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB545174E113433F417004BA1C8E3E9@PH0PR10MB5451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuPTWJOpoCPgrzZ8COl65Un4XHlXt8myvgMqMLExon6jTJ266PfgytTQL0Xzt+ysqy9ECGGa6H0imDD9swzwOdR+p2xVWwBww5KGEtAMYZdLfNBYoyUbYonfEolQdG4AJwKgPGijn9UCIJQjXqsWwLPWjLYBiA/J8LqfalEnmsU4+CK1hmMaYjZEXnrxdiq9Wks78n8oqa5+KH6ixRtH777XOC8SSTob7l5Aqi+2bEkqsCm7kvl8ZXXR9iMOCkr+kuDIftu247LGiYURRdqiYAvvJWPjk4GEpkGODO/Wj9a/qlGwoalhdGv+1jSjd6Yzlb439fNJrkCzAqCVu00c3T+lPD+oCiVBuvsODzyF/TWGb+NpvnYmKV2AKjkBOdMHf/q4W9Vgn4VBGPqVp6DKRWOZOXtSnoX0WWDaADkk22yw66/ioJJ4BUQ7t/3ZZzoyoD5GjCSYLh1OdbMExHqDi/tVK8j98UJcuet/ZNv9OnX6X4rn4UnSxhGMsJ9xOqx0zuZvfRuYtRNpjYzbz7tyAPCvUUtkz6WBChVhZ7DrAYyRkXhD4pXoSeW/XmiyhUjp6LRKoMDbL8ATmTRHdGXBTI4LzevI1/0ZR6Ycr152g6R0zKKbXcOoPJT/6hxnhbw1wMgRu9mpYAt7gSfE7V61OIdJhHqJRqNRZrdh0RyBYKHmVlW7O3RDp6b1AhPBbemv4VgSeQBay2FHKuLSYQ2XSi5SfF5LQH1k6xZ9GqxpobWC3CxoZyOwPzC8EUIFnE4smOgEcu8ZegfhQVsIY32aaV1TkYIb9TVbhCj/LWx9jPgCn8Gv/RZcW4Szqr5HnVVv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(4744005)(7696005)(52116002)(5660300002)(26005)(103116003)(66556008)(66476007)(66946007)(83380400001)(36756003)(186003)(16526019)(86362001)(4326008)(2906002)(8676002)(38100700002)(38350700002)(2616005)(956004)(478600001)(966005)(316002)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZWJidFBLRGNUdHpJMERqV3RBUWRHSG5ySTVMR1ZhMHZtV1FkOUg0Q1BQblN2?=
 =?utf-8?B?MVFWb3plYzZDQUlFYXlJbzlsbDNjcWQrNW9EdGhPd3RWbTI3SHBFVlE0YzNw?=
 =?utf-8?B?akpFNGx0U0Q3QzZ5UjhFOTl3cXVmdUlWTnVDb2xtcHlZM2pDbm1xTk1nK3FR?=
 =?utf-8?B?ZXF4VFNqYUtPS0tvVG9sU0pZbXNXRGpuVkIwMEtXb3A3a2JHb3RRMXA0RmZR?=
 =?utf-8?B?aG05V1F3Y1BhQ1MrN0loVklyMFRDRmdlem81d0tJT0licUdtanl0STVNaFlH?=
 =?utf-8?B?cWo3ekdMeFFQSjQzdk1jaGtpQ0QxMlUrV0lVMU8xRFZQSmZTY1BhUUt1eXov?=
 =?utf-8?B?WUk1NTI3L3ZzOVp2bHRWR1IvN2g3RU1mb080WWphM2RCSGFsNGVHaTJSeVNo?=
 =?utf-8?B?QWtneXBRcndHa3pUZkJhdW02Ynk4amNXVmNqNjlDMjFsN2toaG4yUDlWMXBV?=
 =?utf-8?B?V0FWdytKVHNEdW1NRC8yTVpobmhIYTFJNmZWMWRWZ2R4eE9oTXFDNjFPaUVD?=
 =?utf-8?B?VjJKM3RYQ3dIeCtTNWg3YkFGQzdSMm0xeTY0ODE3SWw0ajFjdldXeTU3ejlp?=
 =?utf-8?B?aGVsMXR4SndKcCtJWHV4LzIvZVVKNXBYRzB2STBqSVBYeTFtdmwrWHhtc0dt?=
 =?utf-8?B?TnpicmVRNGJUc20xZEpGcWQzOXdEOUo4VGpTcW5FYU5jdW94MkxNTDNQaXNz?=
 =?utf-8?B?YzBDTngrNEN4ZDV1aWpJbGlBZ3JlUzJVMVVsT0xVQkk2STIxNU1KSXdpRzIv?=
 =?utf-8?B?bGxDZzdZTFBnQ2RDaC9xZ1h4cmswNGw5Z29yazgrc1VNcExrcGVyb013VStS?=
 =?utf-8?B?akRFVWhoTi9VMTQzQzVYRU1PVDc3YlU3amsxb0xxdkZuQjdDZTNKZVEwb2lZ?=
 =?utf-8?B?SEtRNUtBRXc0UEVGM1BhckdmeGxzWnZUVzlVZXc0a2RUb0RVQ25zaXdnMG1t?=
 =?utf-8?B?OFlEYzdaR1ZhcFFXcHhPMEhpU2h5WHJyS3ZMSnFXWS9WWlo1VUE5L0R3QjBR?=
 =?utf-8?B?ZldkamZ1UVNjSEpUMEhiN25wYURteGFaNlFXWjNCcy9LdTlmQ0oyTnZpTW1x?=
 =?utf-8?B?ZG16T0xOYko2TUR1TVBQMTV3NXhYWXJ4WUtDS2JYcWtkZjBjWThEaWVRbkQz?=
 =?utf-8?B?djVDcTRPb21YRmNkREp2N3B0LzQ5dElYNDlWTlNzeUlQRW55WU9Wc1B6YXEw?=
 =?utf-8?B?L09lOFlacjJReVgzTDBiOGdOSmh0Z0hYQWVZa0c2MzZ5cVFBVFZXWGZiRnE5?=
 =?utf-8?B?ZHljMUZZY0tHWVAyc2I3MndMTHAxU3IwSjVJY3VUZU85WVZxS0dKaUFvYmFW?=
 =?utf-8?B?K3RXb3dsRFhQakFBK0QwOG93dUVWajlyVFc5TG5Zb2lqM3hDb3RvSEl1NWJB?=
 =?utf-8?B?cS9FMHJOck8vTHh6YWt4enZzTS9oL2k5TGNDUVJnTlY2em1hTEFyNmYrWGhC?=
 =?utf-8?B?UGlYajRBU1h0cmlkRVE2Z2J0cm10eFowZUNIWkFSMHJoOWpRRk1ubXNLcDZk?=
 =?utf-8?B?UmtpYUJKZmd2UUZ2VCtoditQQzZYZ1VlODVHMGI1d2NaeUdlR20ydDkvbVlT?=
 =?utf-8?B?ZW9zSWM2YUsxWk12ZzdsQUZNQ05wVEQ5QUZUNWRtUHYrRzR4UXdSR0dUS3Bu?=
 =?utf-8?B?NEo2TTVCTHB4MUxBMTcwbGNrMGN4NTRYdndtbjRWK1hwVlJORExPUlRJeEYz?=
 =?utf-8?B?TEhQU3R1MmlOTDZIa1IyNmxaRWQ0VGFobkZPbUZReHYzUmc2R0llcjRPVmUz?=
 =?utf-8?Q?X2ndvf6FVugIDfu5uKUg7fxs9pW9PSTqQ0QJes+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54db53bc-6b12-4d9e-d063-08d924a8ec09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 02:56:58.5386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3HqefVWa0p91i3i6wPZSCX+gLPKt5soHyD3byTYpKED3buhUP0oFA8hBVS1kCFB98and3SYakfZ6REGqOI1ytISSi4J19jkilNZCUZyR5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10001 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010019
X-Proofpoint-GUID: vSYuZeGp-6cUCMnrnY8hZq3HfzV5rBsB
X-Proofpoint-ORIG-GUID: vSYuZeGp-6cUCMnrnY8hZq3HfzV5rBsB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10001 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 May 2021 10:46:22 +0530, Suganath Prabu S wrote:

> During IOC initialization driver may observe some firmware faults.
> Currently the driver is not handling the firmware faults gracefully,
> most of the time the driver is terminating the IOC initialization
> without trying to recover the IOC from the fault. Instead of terminating
> the IOC initialization, driver has to try to recover the IOC at least
> for one time before terminating the IOC initialization.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/3] mpt3sas: Fix deadlock while cancelling the running FW event
      https://git.kernel.org/mkp/scsi/c/e2fac6c44ae0
[2/3] mpt3sas: Handle FW faults during first half of IOC init
      https://git.kernel.org/mkp/scsi/c/19a622c39a9d
[3/3] mpt3sas: Handle FWfault while second half of IOC Init
      https://git.kernel.org/mkp/scsi/c/a0815c45c89f

-- 
Martin K. Petersen	Oracle Linux Engineering
