Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B88C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9939E61A2A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351491AbhI3SZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:25:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38530 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351478AbhI3SZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:25:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIN0w1018031;
        Thu, 30 Sep 2021 18:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Lgz4f3R1+t1m6B65qsnwuJCtBgWSKyrv3t+Ux0gWyk4=;
 b=Xm+Ykgpxgcx32kpR4Lg8YxWu4N8Wr5q/zC49+YeQ2if3wMAtnU7rpjt79VkSEYQvOTeW
 2aJDfjsYn14oJS2xVDRmpM1aC6j+S1AlBg5ICaqtqdFg/TwG86o+9RhRj1ReHlCqZXkC
 2/WlmaB7n2mY8MsGif2ErlPDqXbDqloDEaX6KxbxkDD9Qbj1Wy+/ZlvvYncA7csCpqGY
 s8HSCuBq4Xp0xH6NPfqpOkEBihI8/l3dZFMoV4rG9qOoUi0z5yRCQi3KKR0RKCZ3J1M5
 slDUT3pOH0dvTN0FynvgTIrdeA1QnaRGoy1MLPpI/68hdtBFPG9sQlFoW96Qa5zvZUpP QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdcquavx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:23:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIGH1H135797;
        Thu, 30 Sep 2021 18:23:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3bc3cgb37m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:23:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRaRkSQv+Wa2fT3B9mC7gSysZp1A7zDr+62epHc+seOZwrfmt1t8ZcGenkg6/xYNdIw9pVyCqHzesmWae1f0mVsCAviRl5OkAQzq6zpQX1IYID/5u46vmq5nZpgjHF54iRW3SxO0rjI7cRoEqF+VqMrUjR/8n4M1x4ZF6d74S+K8+Cu7dW2eubb8wa5KVFc4tUtL1GSehj9NKw+fw0QoUNI4BKkfLWZjViSxzRFgI1BPhormVDcjRAgDURx3zdgoF3e3Qfcy7r/v1kTsuYvj6zFbzIUzGykWoTsNJFS2MTiNd0OBYfJNA9k7Tlu1WkYUWPd4wv6vfVBNUmdnqMmeTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Lgz4f3R1+t1m6B65qsnwuJCtBgWSKyrv3t+Ux0gWyk4=;
 b=gmKkhnngKQ0B0Wr1Ye/qLEAFptCK8GS2kwBtoZzquyGTibG8qZ0f5VHthidiYIPkUqdDFXQzBUgySiKf8Hv5Nqi5zrISCpaJZBEDKq3Pngydz2I0ZovnbvhTYDfeX/1i9J7AJQS73gWNNZq4rqb6mfWzMt0Q1U+s7ik1i32X8IPMWBzfDIob3N0UKjAEsdiZ9wU0FGoCT0xG91FQxbsaWcU5LfqtGNUGRMVC0az9bufDxofhwBAy+j9awIC6jGLX7/ij67z78lgeRSCLDKYiAM7nQWI3j6E7W8z3Opwi7JCzEca4Cax5OTPZ5gl8/zqDvKJUXowxt23XKRxJADjuEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lgz4f3R1+t1m6B65qsnwuJCtBgWSKyrv3t+Ux0gWyk4=;
 b=BYoWFo7nASNdO1l075Zd+gb7w7Z1gKs3Q1OSESKz5wGrn+iWeP3JOcwZUjB0RIy7VnIJa7nfPwG1ERWZf4ZwBjuGEM3v1Jp6zjhHjRuOfjDH7ex1OjF63Nx7hsUaFj19sdTwfXXQke0ZmHBzkB93llAtKWIluCQM5Of6o/bSCpw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:23:33 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:23:33 +0000
Subject: Re: [smartpqi updates PATCH V2 06/11] smartpqi: avoid failing ios for
 offline devices
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-7-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <c042f1af-678c-f635-9020-3d66ad755901@oracle.com>
Date:   Thu, 30 Sep 2021 13:23:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-7-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:32b::16) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BLAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:208:32b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Thu, 30 Sep 2021 18:23:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d8ee392-dcfe-4fb4-646e-08d9843f691b
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB55392F5B812644DE31770DD7C7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8f/eVHAQEu49MVjRSD2abEv8uHJOqsvrzIAG+4I4J3tgKeYth0AYKPP7jX7aDwAUVp7oia6FPVKNsW4dAOcFjeIvDCZC2NlH4xxsFmKnXbSqEOf9r0ekZ2eQG5wgyGB084pwOBCgZdEzjwTf2Ysq8laqgou/CNoQ3oHMoLxVbXsOvswRhUus/xLWox/VI2IJJO8A2fcWuoU89X1WTxk/WzVUeUcvQ7vZfqkXE62ooKBuRP7CW+BmqOnMP7RqTRFgAx61wF06/cwRm/C4UVzTgPFUDX9kotguGtWpv6P3eiEOqolCLrgMNahog1POlnvk1GJvtidxpTQNPI0Zq6hW3fAI/X3bosSKZdupKAI0nZfDw/2wZunoOmidebdNi2jGpp777s+uI653RenG4r5cva3Od1bQB1mkv0V+R1jO1HlRkkYmB5x5c/sSCggjPIqh+u+v9P0fRLbZKipppP6wVrQMQ+EO1ntbHB8nL64nx9vy/O3hjISFdrVPfy4easp8eej6QSaK1bgkkgveQ+Md21CfaicrF2mRz3knQe0i+N54qn637adhqs/VYap+Rra82eL2V+iyo+e4noP7poBag/vppLmjvipeMtIZXpU8m473hg7+OO755BqcASH5fac2lQoAJTrjJiE/Xqv17N2Qd7P05tieKY8eQoeVhTGdmY7aUWpq44X3oDtUjQI1k0gLZb/de19UKDkXbAgCNjWSYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(38100700002)(31686004)(5660300002)(316002)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnhDRGZSMUxCUlB0Vy9USko4OXVZY0J1SkQ5MTVZeFJvSHJhRE1XRnlGUG9q?=
 =?utf-8?B?dFNvTTdNVHhWR0diTURaczVER1ViZFdXbWxuWG40UndyaE80QVRyUktCYVpL?=
 =?utf-8?B?b0U1Ny9jaHVaTlpFUWtzeGVENXJ2dGFNNlVaQXpTcmRsM1V1cUZITVZOWkFX?=
 =?utf-8?B?cDh4bTBsMGpGN3JiU0xvYi9QZVNzSXpHbmFnSHZDQjJ4RmJQaENPaUM3WEgr?=
 =?utf-8?B?N3g5eXIrVkFJcUROckdOOENTMFlCOXF5a3d4WFNNdGxMUnc4QlZuekkxZW83?=
 =?utf-8?B?S25EQVBjY3VXNkdrWXpYR3pzZVRkR1hCejFkeTRGVlNVTCt6M2RVbHc1Sk5S?=
 =?utf-8?B?b1grZEZUVDd4VFdXNzM1UUlYQmRqV2ZUaURpRTlQUjNhNC93L3NQRzNqYU9C?=
 =?utf-8?B?NGV1MDc2dDBGU216Qzc1d0VhY1VvbVA2V2dZK0ZrWnJ6eUY1OFFsMWJOR0kw?=
 =?utf-8?B?S2Y0S3lMTGRFajNrbVZJZkN3RU1EOTJMVG9tTjBoWUsxRnhsZUVSc3lEQ0Za?=
 =?utf-8?B?MHZFaDR6UWRrdUVESGZZTG91Nk10T3R5RndXM0xTazdZd2lsMkUwMW82M1ov?=
 =?utf-8?B?L0VpZmIwdnI1dkgxdWowbEtVc3NXemZmeDkxUjVZdUxwQ3BCZVJqOEdXMzZi?=
 =?utf-8?B?d0xtd3JJcnFrRVNQNmVHaGxPbi9jRjdrQTlUd28yNEtvMmo3M1dybG4waXFq?=
 =?utf-8?B?bUVMazZDdVZ1NmRmRGlYVTVCNGlhMFRjUzlsVnQxMVhwYmx0MTdUL1FkOWoy?=
 =?utf-8?B?dHlkY1N5am5pNHcxNWF4TTU3VXFXTGk1MmxzNXZuQlhnMDJUZkFIRGFNOGU3?=
 =?utf-8?B?UGhkT1RXNUxjbElYdzFDa0l3bWJzcG41RTN3akx1K3gyWTRBTENUNUhNeTJJ?=
 =?utf-8?B?eGFUZTNSeTBJQnI2V2VUREMwMDNKa3UrVzNWVFV4eElFcVRBeHhvbU5KcTBO?=
 =?utf-8?B?ZFBOOWljc1F4YzZ4d3hJOU9QNkh4dTRIdXhPdHZkRGdZV2o3V1hWdk4vOXhL?=
 =?utf-8?B?dmt1ZXJtRjljaU0zdlc4OXh0VW1sencyazhsL1pxMThrTGtKVk5rN0xVNUNY?=
 =?utf-8?B?K0ZScTV6QWlKQ0h1RXljb2ZYazZ1MjZ0MHNLTk9kRlBmUnA3aHM0ZVIxa2VP?=
 =?utf-8?B?VGd4Y0JZUVFZelYwZlcvNDdFakdHSitHU3diQkp5OXhOYjFJRmhLbjREWGFy?=
 =?utf-8?B?b0o1UktqcFhhTWNjQnBtcVpTSlVvazdtb2FzdUtrVFdyY25KWTV3encwbkE1?=
 =?utf-8?B?OWRuRlJoZDlldXNUTndtbjBLRlRDamVtZktGR1JMcUwzV0RKaDBJTHdCRDV3?=
 =?utf-8?B?aUR1ekVib3BmZUpZVWR2Z2lzUXgvUGVtTlI2RUlXTzIyRldkZVBMVVAzYzFs?=
 =?utf-8?B?TmhWemlibW4xODJEYm5ZN0RRRkpmdFhsZS9INDh3alQxMzMyY2EyajF4MVFV?=
 =?utf-8?B?RzNhOExHK2RtT0h5ZDZ6L0FaUjlIUGc4akpkOHRDU1ZJbkJkL01Ka1JzS2ZE?=
 =?utf-8?B?Ly9tcE9nNkgyTWgvamNKTDNiSXk0bTE5NUw1RHQvZFJpOUhvQUI0SGJnN0Jk?=
 =?utf-8?B?WXgxQTVtQzViSUhFZXJyQWI4QjFkTHZBVXJ5VWNraFkvdXc5a2MvQzZOWlAz?=
 =?utf-8?B?Z2I0emd6bjNOUWhtQjNkMUVGZ1MxZFdzV1JCckNiMmRvNEZjKzUyUW9HelFB?=
 =?utf-8?B?NDhCYWE2ampxd211QUcxa29PZUJkRmJuYjZTTTM3cnp4RnRiNTZueEZaQlVo?=
 =?utf-8?Q?G/yOH+36EeUg/xyenorQG/jHv/aFNiRpl+FqIfw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8ee392-dcfe-4fb4-646e-08d9843f691b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:23:33.1870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPbzFV2ISgpvTmzc0al4Dgd9K+va5f3GSRR8t2WkcEGGcQfsDRBmlIs2lIqqy/lSDNpGdR9zX+DZgjrEP8n4Upx8e+pIoIxmYR/fv5o3C38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300112
X-Proofpoint-GUID: NwmNP4pk4YdKMrnK3o_R2MP_9w9Uu7dy
X-Proofpoint-ORIG-GUID: NwmNP4pk4YdKMrnK3o_R2MP_9w9Uu7dy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> 
> Prevent kernel crash by failing outstanding I/O request
> when the OS takes device offline.
> 
> When posted IOs to the controller's inbound queue are
> not picked by the controller, the driver will halt the
> controller and take the controller offline.
> 
> When the driver takes the controller offline,
> the driver will fail all the outstanding requests which
> can sometime lead to an OS crash.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 838274d8fadf..c9f2a3d54663 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8544,6 +8544,7 @@ static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
>   	unsigned int i;
>   	struct pqi_io_request *io_request;
>   	struct scsi_cmnd *scmd;
> +	struct scsi_device *sdev;
>   
>   	for (i = 0; i < ctrl_info->max_io_slots; i++) {
>   		io_request = &ctrl_info->io_request_pool[i];
> @@ -8552,7 +8553,13 @@ static void pqi_fail_all_outstanding_requests(struct pqi_ctrl_info *ctrl_info)
>   
>   		scmd = io_request->scmd;
>   		if (scmd) {
> -			set_host_byte(scmd, DID_NO_CONNECT);
> +			sdev = scmd->device;
> +			if (!sdev || !scsi_device_online(sdev)) {
> +				pqi_free_io_request(io_request);
> +				continue;
> +			} else {
> +				set_host_byte(scmd, DID_NO_CONNECT);
> +			}
>   		} else {
>   			io_request->status = -ENXIO;
>   			io_request->error_info =
> 

