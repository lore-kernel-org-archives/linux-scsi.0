Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7682C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352981AbiBHRuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiBHRuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:50:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3C1C061576;
        Tue,  8 Feb 2022 09:50:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FwqSh012771;
        Tue, 8 Feb 2022 17:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gTtovQ6Udtt6GpiumJikDtiXPOGnfmh9oODenQSK+I8=;
 b=AYpVoRA8Nd/q3ImyGbI2ET4sFd+DeNwYDhVFkMdSVL9e/uLkz85WzPVkq6EZSiyUhUbU
 P5Rw6JU0RdaK8igK8ZnzhuFDtQfFGzA1VNk4PMISInshKFvTHOi/fKhKgnxSUpsKsA3I
 ukNGbcEXZnry6/tQ1A5cnxv0No77ipf4WjSiuu3ygD511rK1Fq0jYuweCR4JcGJIT1fe
 3hQM4VyVjpodK0iKeBi7k7j2p9EtwKqDr9XK9ml4/ZKdzIMysrnu98RZFacz7pX1ZgR8
 qPvhIVFEREVnOXCfT1HSigzfB8D9bC7yXMLGs8ES8RZTD1WjgDDfpIaa9VhMT1rAc/Jn aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgj9kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:50:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218HZUNY123416;
        Tue, 8 Feb 2022 17:50:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3e1jpr81c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:50:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiYB+CrUQxCtdsMN2BiMm4083lR/lNEtnEwrYXUZm4kn0f3HBWNgFVXFJR+d09UOSWy7jJN2/rKxis3KMBs09Q5UEXi/SxRBv5j9IBWYEGxVikhzqDukqfBvZxh0EeZ8rHci9+kF4zgBjImYqXK6yXWTA89aN5Zn221vqmdLyguHz4ZAbT5GRbU328WV5x2yw1xnX84KJc7cRmky9796DWec+w+YFKNEpTb3FHGNTmMBsmlwFCkIgLiFPZI6RYU8MusBCm2nmDipBPDP/xfc11DlzTzhzmKobnGEPGuR8uLlKIamRj0rtZneUxRC1xzoplUDYXLg8P3n7xINp5m2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTtovQ6Udtt6GpiumJikDtiXPOGnfmh9oODenQSK+I8=;
 b=iXq1vGV5lS78ak6WkAYxJsNB+dUrcTQeiA15leDJTR1w63avNeTxFrKv01UgpdpfMOqyrtWug9ZHaYyXviZlx1lV9nMdTLV4nhJncJyF700XlDUyK7nCxLBkgmPvxoeto0kqYmtIVKABI5RO2j99KjybvimwNtuoiuWWoq+ih/IBp8HUv1RO56PD8oMA6RUMAJ2ZmthC6zdJ93qgOP3DI4bNk3IQlsLCvuynYaVne2DhQY80tTrJoQ9kWmFzKQUZZBduWEEsgobdwbDqkZjgEcpd/XaeFmow584P4uTtQK+cqI/H809wI2k7jrvZtm76wifE8L3iAeVqeWcX/2mn/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTtovQ6Udtt6GpiumJikDtiXPOGnfmh9oODenQSK+I8=;
 b=OfRbMZBWKXaDgtKpH8mMDCioi/c+TfkEOrhhpIXueRPWdryXrXZtHqWqt3IPpggH6mxsdzXXKwx67FL9Bs5T2LY0niYYA2n6b6viVFdapBlx8Y9EfZ7B+DiqsdcthEbeX8tJtnp8WYiVlEuzKAixRQbaGC3CkhnK+Ufj/aSzO/s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR1001MB2060.namprd10.prod.outlook.com (2603:10b6:4:31::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.11; Tue, 8 Feb 2022 17:50:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5%5]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 17:50:14 +0000
Message-ID: <7234209a-d308-622b-700e-e72907246ff4@oracle.com>
Date:   Tue, 8 Feb 2022 11:50:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] target: add iscsi/cpus_allowed_list in configfs
Content-Language: en-US
To:     mingzhe.zou@easystack.cn, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0094.namprd18.prod.outlook.com (2603:10b6:3:3::32)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f40697da-28c6-4578-6343-08d9eb2b75c5
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2060:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2060985A7E0AD57345B1198EF12D9@DM5PR1001MB2060.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDey1MIEE2EhX1ywNp6IfRKe8Ce9Mo61J9OgFX1/UdIM/jPuarWkU0BvQ3GfmZJ3PIT4Uu6+cEu1agW5qaQPD6xv5Egc3eRMbbaRpsjYUQ7dhcRF8s9ZWE8eM6N5D9w1Z44Eaj0EhtEWYciReXW0raqQ3F6CsiBPrsTRSOsodZfHfOKi4y5OBaPqD3wmoypjr++jc8j0LEYVKTrkhFFwCJXYM4gwVd0VudoH9jLrYV1KATmceFcxWnFU7RZ+P/yJB3Q7fQXg26Bu1iWV5EQwhRZn+uKmhIDIzcEYfePptsajj+A/QtpXlxrHuqtiTp0KXsIQPPC+OHWBecEQjQ3GSHaEoJdhYCHB6LN6srKwFI5Yx+W0Iccih4Fe1hLQAF3RfhaJjI5au2x6wLqGmSdCBRZO3IU6xQ+hZ+8Hwy48yiLSvUQpNqvNlTjwtAw453rZrTaXw8Sh/wmTYtB4S5mPg8AlO5T+hPyfP5Y2tHoPXCZ9Qpr6F3gwhHOTFpFO0Ax5nlAwxDlY+sRWev+r1NQE1Y1/dlvytfUEYx3Ki8hHx5kLCis7CePEt7IqYKFzbMPYQ5PF/P2lNQCuMRCfpJ3WgFQRPoGTULn22RtCEu6ORrc1Q69hA7ojmhMRoEgSq4u33aZNrLhZ8o4wmZufddvOF5z5K5iglxnoIzHYvUYXpMKmkZivHDCcMtt9lqhNz7vjaxs1TJM9vShcCuCZV1qeOf8ekfKTZq8WchX0MGz8V+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6506007)(316002)(66476007)(31686004)(26005)(2616005)(186003)(38100700002)(8676002)(508600001)(6512007)(6486002)(83380400001)(6666004)(66946007)(86362001)(53546011)(66556008)(2906002)(5660300002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVlNRmFrVlozVXJ2bVZRMmZoREw1YWFjbXU4ZHZWT1VGdXdkb1BqUStoL004?=
 =?utf-8?B?RHRjNnErdW41TGxqYTJPdjdRZDlianRObUZJTTlVRmI5UllIU1gyMmNKcGU1?=
 =?utf-8?B?WEJkYkZaa1lWcUxpUE5ZNmUxTjVqem44U1g2Rk5hOHo0V2ozUGJlV214cExE?=
 =?utf-8?B?K1pYU0JrU2NQa2lXUnlTOHBlNDRzbHNCalNmWEhjZDFOSFo5QXpMRzlPQlBH?=
 =?utf-8?B?NHNmRHVYMFROTUVlb29DaEpjU2RMRTNnV0JQbW1seHhIWlZWejkzbHZWSHAw?=
 =?utf-8?B?ZytJaE1JaEMzOFFWUHpjZXR1dXcwU0lyZ2cyd0hIRUhYY0U3NUFYYWZGVlB5?=
 =?utf-8?B?MU9OSmdyWE02WW9DdWRVOUpYNEdsOVRLaThpNFZDN2ZIdjA0TFVqaE05eWEv?=
 =?utf-8?B?VHFPZDZxK2pCbVo1QmVVc3J5RXdFOVpLTG5keW15V2s5UitJazNuRElaZ1NW?=
 =?utf-8?B?MTIxcmlrUkQ2Q2ZjZEdzMlpWQjI1UVBGWlg4SElKbGl6elI4d2tLWko0YmRJ?=
 =?utf-8?B?bXd3L1hPVzc3VGJjL1ZvS1kybStNWmlkQVJBZzB5NEd3RVdDa2ZBOUZSellV?=
 =?utf-8?B?U2x5K1FOanVWd29NS3N5bEVhNWlhaWE2UGpWbUYwc2x2UFdMWVBUM0Iwclp3?=
 =?utf-8?B?eC9oZDhSeFh1Qy9mQnNJcVBiN2VYYTA1aUZMbnZRNDVCS3FWcUdBcTVoZjBX?=
 =?utf-8?B?bE1DZENZekFtdkJTWjZzaEgySm9TR0Z2OHVKUDQ3SjlmMVRIWk1NV0UvanYx?=
 =?utf-8?B?UWE1NnRrTVpQS0dhbXlKeUZqYUhrODZEMStMY0VGamNnUmd1L1pFN3pSampN?=
 =?utf-8?B?TjlnWG1qY1dOZWJaNXJQUWhVVlZ6dUpLUExmRytkSkhLVWI4QzNQRk0xZ0dL?=
 =?utf-8?B?SWZDbWNzNGlJRUYrZHNIUDkrR0phWjFPWkVSbnp0TFdNOWJPU0VFOHJpSHFZ?=
 =?utf-8?B?SlViQ1h5c0FETW5IR2Y1UmtYeTBNeUhPcFd4bVNHblpTN2FJSldpb1BmSXpC?=
 =?utf-8?B?WVViUjV5Y3prUCtOdWJGcUhyd0VwUTVkL1Y5d282NUplOFgyR1l0eFgrVWJD?=
 =?utf-8?B?TFoxWjBtandDcTdDY3M4VDVPeEdJM0libXdWdVhka2lmdXpPWGNyQkhTN2Nm?=
 =?utf-8?B?U2NmNG1KMDV3WnZ2MDVrVnpUOThNbWRad0tjb05uYlcxN2F4NUFkRzZxSS9Z?=
 =?utf-8?B?RnhxVUNMZ25lcWVMK0Y2KzdZTTRZMlA5Z1dSQ2RncGJ2MU1WVkUxWFpIcXdR?=
 =?utf-8?B?M2hkbzlaQ2RqUkV3RHNRS1JZWkp3SkIzTXZ0RGhwRnVjWGFpTkRkQUdvMElF?=
 =?utf-8?B?YUtkelRTQXhxSWh3bW9Xb29iOXBtTjVwMmN3bzY2WExFSzFZR0lqRHVoZTZC?=
 =?utf-8?B?QUh0NTJsYndoa0RLc1dhWi9PcU5ONWZpdEtzWlFaY1M4NDh5V2tvSmdlUFpy?=
 =?utf-8?B?YnVudThyQmFZOUVFaU5mekhUSmEvbnZ5MXZaWjAwOEFTSmQ5UHhwSm93azFZ?=
 =?utf-8?B?K0E3QTk5RE9qRTNzaHU0cG02MEYwZHNTVTZGTDJrMHRJUnNuMHpvU1ltR2xF?=
 =?utf-8?B?dndsWjJKN01DZTZsSjlVWTJlU0NhWW8yMm90dEI5UkF3cmpTT05UWjZ1T21z?=
 =?utf-8?B?eE92NnRxM25YUTBjZSt2TnQ2NWRSS1B6aEhjaXkxVzNoV1NOS0VURDAzcHh4?=
 =?utf-8?B?cHlGSFVMQ09COWR2cUFFNXNNdGdwVnJsaE5rR3BGdmF4Q0ZOanZsdHdPdFhS?=
 =?utf-8?B?eGxIMk0yc2NJazhoVGZmb3dSWGNyOHE5TWovWm11V2svUGF2ZEpnSm9RU1FL?=
 =?utf-8?B?M0Eyc1NkRnRQTWRTTFk1RzFxL25VaW9GeWhyN0dhaU1tRWVIWExUTU9rVW1K?=
 =?utf-8?B?V0lnSjBQcUNhLzl1ZmM1Qjg0UDJFK2t2enl0YTllak5Bb3gxODc3L0RJY1RK?=
 =?utf-8?B?emMvQURhUDlsMHhrY05LMDFyK2t1VTErNFVCam9Oekd0TVJUcVNaVTB2Z0Jq?=
 =?utf-8?B?emRRL3FCS3RwaXJKWkZGZzNRUUxuMHFzMkUxNDNFcFZ5M2JWOEtTdlpwc3lE?=
 =?utf-8?B?TmZHTjNYajQxbUpSUXJVT0dxeEtXRUE4UkRCQm9UdVFOVGZhQUtMMlQ2NXhz?=
 =?utf-8?B?M0pzZC94S3BsbzRQNEpiWUZwOXRZajhpaURzVGF3TER4YzZOcnB3TitHOGI2?=
 =?utf-8?B?TFFxZzY1Zi9lcEROcGpJTzN6a3F5N0l2TnN0USs4OTlHWHRmMnZFNGtkczdL?=
 =?utf-8?B?QlBrdnplTEZhZU9jSDZteElyNWlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40697da-28c6-4578-6343-08d9eb2b75c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:50:14.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHemXdzRt+4gt/pfyEhmKDrIjvCXQTMojD8VBdIOhSKUMNVvFsaJ/K2jXFXbs9dAzXK3GAfAcPrS0YHi/pDFFwB2E/E5UK43OxBt5URPqes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2060
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080105
X-Proofpoint-GUID: 887pbB_Udl1lLC5kl-oCIl_xpojxJk9t
X-Proofpoint-ORIG-GUID: 887pbB_Udl1lLC5kl-oCIl_xpojxJk9t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/22 2:38 AM, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> The RX/TX threads for iSCSI connection can be scheduled to
> any online cpus, and will not be rescheduled.
> 
> If bind other heavy load threads with iSCSI connection
> RX/TX thread to the same cpu, the iSCSI performance will
> be worse.
> 
> This patch add iscsi/cpus_allowed_list in configfs. The
> available cpus set of iSCSI connection RX/TX threads is
> allowed_cpus & online_cpus. If it is modified, all RX/TX
> threads will be rescheduled.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>  drivers/target/iscsi/iscsi_target.c          | 21 ++++++++++--
>  drivers/target/iscsi/iscsi_target.h          | 17 ++++++++++
>  drivers/target/iscsi/iscsi_target_configfs.c | 34 ++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target_login.c    |  7 ++++
>  include/target/iscsi/iscsi_target_core.h     |  1 +
>  5 files changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..a18d3fc3cfd1 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -693,6 +693,11 @@ static int __init iscsi_target_init_module(void)
>  	mutex_init(&auth_id_lock);
>  	idr_init(&tiqn_idr);
>  
> +	/*
> +	 * allow all cpus run iscsi_ttx and iscsi_trx

I would just drop the comment. The "setall" in the function name
is pretty clear already.


> +	 */
> +	cpumask_setall(&__iscsi_allowed_cpumask);
> +
>  	ret = target_register_template(&iscsi_ops);
>  	if (ret)
>  		goto out;
> @@ -3587,6 +3592,15 @@ static int iscsit_send_reject(
>  void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>  {
>  	int ord, cpu;
> +	cpumask_t conn_allowed_cpumask;
> +
> +	/*
> +	 * The available cpus set of iSCSI connection's RX/TX threads
> +	 */

Probably can drop the comment too since the variable names make it
known what we are doing.


> +	cpumask_and(&conn_allowed_cpumask,
> +		&__iscsi_allowed_cpumask,
> +		cpu_online_mask);

The formatting needs some fix ups. I think __iscsi_allowed_cpumask can fit on the
line above it and then cpu_online_mask should be moved over a couple spaces to
align with the opening "(".


> +
>  	/*
>  	 * bitmap_id is assigned from iscsit_global->ts_bitmap from
>  	 * within iscsit_start_kthreads()
> @@ -3595,8 +3609,9 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>  	 * iSCSI connection's RX/TX threads will be scheduled to
>  	 * execute upon.
>  	 */
> -	ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
> -	for_each_online_cpu(cpu) {
> +	cpumask_clear(conn->conn_cpumask);
> +	ord = conn->bitmap_id % cpumask_weight(&conn_allowed_cpumask);
> +	for_each_cpu(cpu, &conn_allowed_cpumask) {
>  		if (ord-- == 0) {
>  			cpumask_set_cpu(cpu, conn->conn_cpumask);
>  			return;
> @@ -3821,6 +3836,7 @@ int iscsi_target_tx_thread(void *arg)
>  		 * Ensure that both TX and RX per connection kthreads
>  		 * are scheduled to run on the same CPU.
>  		 */
> +		iscsit_thread_reschedule(conn);


If we have multiple sessions to the same portal, could we end up racing
where session0's tx/rx threads call iscsit_thread_reschedule and
iscsit_thread_check_cpumask at the same time as session1's threads and
they end up taking the same cpus. They both could be running
iscsit_thread_get_cpumask at the same time, see he same masks values
and in the for_each_cpu loop think the same cpu is free.


>  		iscsit_thread_check_cpumask(conn, current, 1);
>  
>  		wait_event_interruptible(conn->queues_wq,
> @@ -3966,6 +3982,7 @@ static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
>  		 * Ensure that both TX and RX per connection kthreads
>  		 * are scheduled to run on the same CPU.
>  		 */
> +		iscsit_thread_reschedule(conn);
>  		iscsit_thread_check_cpumask(conn, current, 0);
>  
>  		memset(&iov, 0, sizeof(struct kvec));
> diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
> index b35a96ded9c1..cb97a316d76d 100644
> --- a/drivers/target/iscsi/iscsi_target.h
> +++ b/drivers/target/iscsi/iscsi_target.h
> @@ -57,4 +57,21 @@ extern struct kmem_cache *lio_r2t_cache;
>  extern struct ida sess_ida;
>  extern struct mutex auth_id_lock;
>  
> +extern cpumask_t __iscsi_allowed_cpumask;

I would rename to:

iscsit_allowed_cpumask


> +
> +static inline void iscsit_thread_reschedule(struct iscsi_conn *conn)
> +{
> +	/*
> +	 * If __iscsi_allowed_cpumask modified, reschedule iSCSI connection's
> +	 * RX/TX threads update conn->allowed_cpumask.
> +	 */
> +	if (!cpumask_equal(&__iscsi_allowed_cpumask, conn->allowed_cpumask)) {
> +		iscsit_thread_get_cpumask(conn);
> +		conn->conn_tx_reset_cpumask = 1;
> +		conn->conn_rx_reset_cpumask = 1;
> +		cpumask_copy(conn->allowed_cpumask,
> +			&__iscsi_allowed_cpumask);

Fix up formatting like above.

> +	}
> +}
> +
>  #endif   /*** ISCSI_TARGET_H ***/
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 2a9de24a8bbe..dc12b1695838 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1127,8 +1127,42 @@ static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
>  
>  CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
>  
> +cpumask_t __iscsi_allowed_cpumask;

Maybe better to put this in iscsi_target.c with the other vars like
it.

> +
> +static ssize_t lio_target_wwn_cpus_allowed_list_show(
> +		struct config_item *item, char *page)
> +{
> +	return sprintf(page, "%*pbl\n",
> +		cpumask_pr_args(&__iscsi_allowed_cpumask));

Formatting like above.

> +}
> +
> +static ssize_t lio_target_wwn_cpus_allowed_list_store(
> +		struct config_item *item, const char *page, size_t count)
> +{
> +	int ret;
> +	char *orig;
> +	cpumask_t new_allowed_cpumask;
> +
> +	orig = kstrdup(page, GFP_KERNEL);
> +	if (!orig)
> +		return -ENOMEM;
> +
> +	cpumask_clear(&new_allowed_cpumask);
> +	ret = cpulist_parse(orig, &new_allowed_cpumask);

Are you supposed to do a zalloc_cpumask_var/free_cpumask_var before
using new_allowed_cpumask? It looks like other callers are doing it.

> +
> +	kfree(orig);
> +	if (ret != 0)
> +		return ret;
> +
> +	cpumask_copy(&__iscsi_allowed_cpumask, &new_allowed_cpumask);
> +	return count;
> +}
> +
> +CONFIGFS_ATTR(lio_target_wwn_, cpus_allowed_list);
> +
>  static struct configfs_attribute *lio_target_wwn_attrs[] = {
>  	&lio_target_wwn_attr_lio_version,
> +	&lio_target_wwn_attr_cpus_allowed_list,
>  	NULL,
>  };
>  
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 1a9c50401bdb..910f35e4648a 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1129,8 +1129,15 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>  		goto free_conn_ops;
>  	}
>  
> +	if (!zalloc_cpumask_var(&conn->allowed_cpumask, GFP_KERNEL)) {
> +		pr_err("Unable to allocate conn->allowed_cpumask\n");
> +		goto free_conn_cpumask;
> +	}

I think in iscsit_free_conn you need a:

free_cpumask_var(conn->allowed_cpumask);

to go with this allocation.


> +
>  	return conn;
>  
> +free_conn_cpumask:
> +	free_cpumask_var(conn->allowed_cpumask);

I think you wanted conn->conn_cpumask here.

>  free_conn_ops:
>  	kfree(conn->conn_ops);
>  put_transport:
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 1eccb2ac7d02..c5e9cad187cf 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -580,6 +580,7 @@ struct iscsi_conn {
>  	struct ahash_request	*conn_tx_hash;
>  	/* Used for scheduling TX and RX connection kthreads */
>  	cpumask_var_t		conn_cpumask;
> +	cpumask_var_t		allowed_cpumask;
>  	unsigned int		conn_rx_reset_cpumask:1;
>  	unsigned int		conn_tx_reset_cpumask:1;
>  	/* list_head of struct iscsi_cmd for this connection */

