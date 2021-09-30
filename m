Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5758C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9112A619F9
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351373AbhI3SY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:24:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21044 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351350AbhI3SY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:24:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIIDYh018050;
        Thu, 30 Sep 2021 18:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ixAl8pN3AgAhWdE/KHoYIK4rHZ9AhBx2LMfQDalcvCY=;
 b=hiN9K7ZirBIyUyp2V+Vxsx2KbH3PIMlRNp0b9oRsVZ+cXPXLypJ2hSu0Fi18fbHmn1zJ
 3sHVmyExxTPUJpjq/V5KBjT4U5RbrRaOhZwNS7knCPDIerEalR9JZGIVsn7T0hOwCxMU
 xjAWK1j3Uw1VSFiZSV+NoYi0vbE0lWJdOYLJB6UE7sIA8RZh0o3dIdbrP55l/LfGVpFW
 DCS/3/L5rWCjZ+0l30IYJSD9ZI2k08nk2bnw5uGVtT6fuSpfR61CqQcZYftfSD6cCafb
 XWVQwbkU23YVZvtnyxUqtUa+avLZsXRVpJdhAv69gHB56AQ2L/8fddgqcm0qW795NAVZ UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdcquavm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEYiA099806;
        Thu, 30 Sep 2021 18:22:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3bc3bn1h7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGBTdg+M7tSkzB0fC+phXXhh+y9fJLF+PV0wlNudo81YKjTzXf+dhCT0tUicXtaKwoGSBfDLPbtXHAutlz1t68NzLdIAceM+nCQIjy3NGAlb/BrdAn4So2CEdJJV4InK96Gqtpg7Lb6Rnml/Ipj8kRCHhtE2/Vvq4tMVDwd7fBon5h0Dig6AFW3pOMxiNzBnJrNxVYPi4BmaNOMB88lGLGQRKBslQpjmhi46WY7Hi0Ki2+R10/NJb7O19mXUCiDTGpKQj4v8YPZbEfQKYguuQoixPg76vRMerufWoa/iQJUh3BUFAJJ1AFLU8yCGUCdDE8FlRD4E1z8yTLhQOxHdrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ixAl8pN3AgAhWdE/KHoYIK4rHZ9AhBx2LMfQDalcvCY=;
 b=hf8HK/EjPb5pmNAZK+BzKCzUUUHkxvGRvwF8kMZS6fpwlVmYw2LQakmr/Shk6Kl3y1HgUoUSx28fww5UBESAQXlz7y8xqrA56O5za/H/r3ocpgQQsNNF/XIFyC87JJ1bc+OZXOrYnLhmdr7ZRoDf8iAdgFuarmGRxf6GS/oq9qIlBW28PgtpLFl6nRrwkuWUXuygKDnSGVaA0LZ6QqlGupRyCN7jq8ccLcq0oNKC0C1i73iEegKf2fkTdHhAr/TdsH0nvSFO4MPaZcOWHEIHx52NRi18KYwcofiUBl+9IimczyRa9uAKrnL+JBX6D4+VzxaVKH8oJk9WQ0OFwevaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixAl8pN3AgAhWdE/KHoYIK4rHZ9AhBx2LMfQDalcvCY=;
 b=YDNSmAnD1yalBbnnNsuyWJ81Jwva+xFwI3TAc0ET+gVW4eLuqMjQH97kJ0wdxszM0bZA6LkY/DUBcZ7CzYJWp2UkCastov5Qksub+Q7XfnSUgCkTNYvM7+IVa3ovN8uhh72u9B8mwKFJ2xNYrlkvdfHXjXrPmGcwOyRhMTiypOI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:22:55 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:22:55 +0000
Subject: Re: [smartpqi updates PATCH V2 04/11] smartpqi: update LUN reset
 handler
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
 <20210928235442.201875-5-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <1bc024a0-1a56-9cf7-ad9c-21258a85928d@oracle.com>
Date:   Thu, 30 Sep 2021 13:22:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-5-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BY5PR17CA0002.namprd17.prod.outlook.com (2603:10b6:a03:1b8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 18:22:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c05b903-9a2d-474e-1c76-08d9843f52af
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5539B42C67163B9F7384AB8BC7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:30;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhDsumT/pDTe/0CHK27IUG17OWE2Y/OQBKmkc1Pm2MP4Ct7VJ37qzMZvi9LK+J8vwyDoUR+lXGmqhbAWjn76Nh+ebZUfenKt+qNg2sIpm8B2wom2xwcfBky0LkXumgG+nEPmGp81DNgNeAinEdt63xqFyvnZsqQhjEEz+CM7JkRQTZxH9naQpzG1Q23yFJcKzy1FIuvOManQ+lXygSQHVAiuawN+V+bHzsLxgqRk6eG1AT73OF3HytEuZYe7Nu8qt2ngYADAjMl0KkFrhDFp265ilIpMosPeRy5YFg2f7h7rkMXlW/o7m23fVAsAYqulm94Pgm3Vfvg2JLtbUp6brSuqfvOpKAiMior4Cdy5dTGCUcOp2oxiMs1SOqCtVQV4b20XdpAPrcyVBV4Il4NZMjLleYqN6kJuU5KejPW+r8LrSVyNCgdwbMaMMvBQEhcuTn8BMvLsM3rNrcqJojZ5q55sgCewEsVpTQTVqwGaVQbXbabDKpuUWe/UeRIAw8y0kLF04y1Fs28lYa8EbUlwSUivUBtxWwwqlHnqQSvY9FbKY8IyHHJ+qJuPAHiHxz4qja8ILKnPDurlJuqNR2WKHvGpxT2AAMbF2Rc4CY5NjPWhRHQU1IRtasbybjr3E/XL8r/zKsPoIziEx42Mu3TtcdLLXeF1q3fMGKeguUeO27e/aIjvoMUyIFdfJID3bim47f/fVCh36XOQZtilW9CbCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(38100700002)(31686004)(5660300002)(316002)(15650500001)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUdBVndYNXpOdFh4RG5HZEY4NCtTNFV4RUVPUWNFREs2SkNNWlNKU3VlZy9F?=
 =?utf-8?B?M2lBTGhTRzZhckszU01ZbTJPcDdxVzF5ejNyb2RsS3JPU0JhYURpTXhXQWEx?=
 =?utf-8?B?SHhVMkEwQUtQVGNBNUhkbFlzMThHRncrRmdsc1JXbXI2blZRRGRwU0FpUW9I?=
 =?utf-8?B?TDUyWDNsVUEvdUJESnNPQmkxczgwYU5DWWErNXorS2VPbTBDRXBoQWIzV1Jm?=
 =?utf-8?B?UFE4aldQNENHNmVDbE83QkdReXRCL29hajdpbWh4WXRWSWNIZzZmRXR5YkZE?=
 =?utf-8?B?TFEreEVKUWpuTTg5QkVBMUFLc0ZsdG1oZXhRN3NZc0s0Y3JmKzBDcnlQUCtj?=
 =?utf-8?B?ZHh3aTltMVhUbUM4dmFFZ0dlM0JhWnFlOTlranFoWDhNRHU0NFRyMXd6dW9Y?=
 =?utf-8?B?T3hPK2JuZ3pUWjVWQXJvcW9uY045OCs0V2daRWlzb210MWR0SjZlWW1MNnZD?=
 =?utf-8?B?SXFlblY3NGRSQ1lQRWVMWUx1OWFrQmUyd1ZUblNIY1NLUUR0d1ZUdFlUT1dK?=
 =?utf-8?B?bml0emEvbVpWbHFncWRMTVNEMC9vRXZQMi9jR1lSMVBBeU1iK0R5eENQcExm?=
 =?utf-8?B?Wm1MYXc0d2FZNjRILytnczkyaXdmK3V5TGNWOEV4RkxZVjI2dFIzVTh5Q3gv?=
 =?utf-8?B?RjdnSFRlYnpvaG94My9lcFBGN21kVjM2aUIxOHk3TkM3eFNBMjhiQndBaGpz?=
 =?utf-8?B?bTBDaHFua2wxTGtlQStNY1dQTGFwV3VQUFVGSjV2ZlBmMmFTQlhnYUZ2QndQ?=
 =?utf-8?B?WFVxMWdsY1plbTBINFBwNmVwTWZGNENkUXYxZjcrcnZpVTlyUUNBSHZKditj?=
 =?utf-8?B?Njd5MSt1VVoySGhGL1NCNVkwSmgyWVZrSmVVWTdvRGtTeDVGV2Q0NGJCbVFv?=
 =?utf-8?B?cHU4ME9FRUVmNHdrLzdYUG1heTRzaFBBLzExMDgraG1BM2liRlM4VDNkdnpW?=
 =?utf-8?B?TG5ocTdMY2xlMGtLMEg0NmMveS82VlNoL0VoeVpwZEx0ckFEUjN3QTlrNzEx?=
 =?utf-8?B?Z3FpaVhWaGVMU1dRSENYWE5yK2hJS0pkbUMvYnd6Ry91NzRZOGsrb2RET0hl?=
 =?utf-8?B?bkpDWXJmd29DaVpXdU1vbVFuRU1jd3llK0pleFV0L2J0VVhodkczUTRuVjlk?=
 =?utf-8?B?ZTJKT2lxNVpDUjJMeGVZMUdlVTArQm00U3NnbzZBcGRDTTBScUtqazk5Tkty?=
 =?utf-8?B?K0VYQjJtNG5nam9TZDJoYmZxcnMrMDhZdzVCMER4cmYzbFpVT3BMNHoyVWV1?=
 =?utf-8?B?ZlZrSUxQNTliUk5GaFhZTW44MmJtN2FGK3lrRkx5eVBNTWR0MFROZVc2QzVU?=
 =?utf-8?B?N2krdXZtNUxrZXF5Y0l3ZDJLUWpGcmZvNWxLSXVmUjZGZ3JNdHlqM0ljV2Nk?=
 =?utf-8?B?c3V2OHZUUU1tVXJEakViK081a3BySHRNRlBBdnl1Qk14U1V1VW54WGVoR05O?=
 =?utf-8?B?SUo1NXRGcVJ1QVdIdFRvODJZREl0Y3BwN014QmpmVWZCRmp4SWFCUHVYdUJs?=
 =?utf-8?B?V0gzeGk0a2V1Q3RRamdYdkQwS3FqNktjeXNiMkFPMDBkdHFaaUlTMmxDdno3?=
 =?utf-8?B?OE0zalhFNUppdUdoRkhhMFppUFNwWUJUVStPUTR5VkY5c292Mm5ZRGxsNU8r?=
 =?utf-8?B?Q0NoeUVOak9vd2UxYXl1TDZqNU1UZG9SZVUvcGVMRFpVY21EN0JOQ0ZBdUVR?=
 =?utf-8?B?aHBaaXZXTGNnUXNjL2lNV3ZlY1AvbTV4L2hRSzFHbTlJaEFBaU43UjVBaVQ4?=
 =?utf-8?Q?Nt3yEXZu37OFxGP+iKJvrnqpxytqV62+Er/KEhN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c05b903-9a2d-474e-1c76-08d9843f52af
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:22:55.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPOOThWd2ztXBKioFR1m8N8UBnKzHamq5/JoAvbYIzemkU3rQ2qumwY3ZEIRz2FKd0NG3OW6zJ4EI6WJGlHcuHmzRQvXt+U3RqlmoyxbaZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: 0WhE9xZacAekCewBruxoxwGAhwjKgn57
X-Proofpoint-ORIG-GUID: 0WhE9xZacAekCewBruxoxwGAhwjKgn57
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Enhance check for commands queued to the controller.
>   - Add new function pqi_nonempty_inbound_queue_count that
>     will wait for all I/O queued for submission to controller
>     across all queue groups to drain. Add helper functions
>     to obtain queue command counts for each queue group.
>     These queues should drain quickly as they are already staged
>     to be submitted down to the controller's IB queue.
> Enhance check for outstanding command completion.
>   - Update the count of outstanding commands while waiting.
>     This value was not re-obtained and was potentially causing
>     infinite wait for all completions.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 105 ++++++++++++++++----------
>   1 file changed, 66 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index b6ac4d607664..01330fd67500 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -5799,64 +5799,91 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
>   	return rc;
>   }
>   
> -static int pqi_wait_until_queued_io_drained(struct pqi_ctrl_info *ctrl_info,
> -	struct pqi_queue_group *queue_group)
> +static unsigned int pqi_queued_io_count(struct pqi_ctrl_info *ctrl_info)
>   {
> +	unsigned int i;
>   	unsigned int path;
>   	unsigned long flags;
> -	bool list_is_empty;
> +	unsigned int queued_io_count;
> +	struct pqi_queue_group *queue_group;
> +	struct pqi_io_request *io_request;
>   
> -	for (path = 0; path < 2; path++) {
> -		while (1) {
> -			spin_lock_irqsave(
> -				&queue_group->submit_lock[path], flags);
> -			list_is_empty =
> -				list_empty(&queue_group->request_list[path]);
> -			spin_unlock_irqrestore(
> -				&queue_group->submit_lock[path], flags);
> -			if (list_is_empty)
> -				break;
> -			pqi_check_ctrl_health(ctrl_info);
> -			if (pqi_ctrl_offline(ctrl_info))
> -				return -ENXIO;
> -			usleep_range(1000, 2000);
> +	queued_io_count = 0;
> +
> +	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
> +		queue_group = &ctrl_info->queue_groups[i];
> +		for (path = 0; path < 2; path++) {
> +			spin_lock_irqsave(&queue_group->submit_lock[path], flags);
> +			list_for_each_entry(io_request, &queue_group->request_list[path], request_list_entry)
> +				queued_io_count++;
> +			spin_unlock_irqrestore(&queue_group->submit_lock[path], flags);
>   		}
>   	}
>   
> -	return 0;
> +	return queued_io_count;
>   }
>   
> -static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
> +static unsigned int pqi_nonempty_inbound_queue_count(struct pqi_ctrl_info *ctrl_info)
>   {
> -	int rc;
>   	unsigned int i;
>   	unsigned int path;
> +	unsigned int nonempty_inbound_queue_count;
>   	struct pqi_queue_group *queue_group;
>   	pqi_index_t iq_pi;
>   	pqi_index_t iq_ci;
>   
> +	nonempty_inbound_queue_count = 0;
> +
>   	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
>   		queue_group = &ctrl_info->queue_groups[i];
> -
> -		rc = pqi_wait_until_queued_io_drained(ctrl_info, queue_group);
> -		if (rc)
> -			return rc;
> -
>   		for (path = 0; path < 2; path++) {
>   			iq_pi = queue_group->iq_pi_copy[path];
> +			iq_ci = readl(queue_group->iq_ci[path]);
> +			if (iq_ci != iq_pi)
> +				nonempty_inbound_queue_count++;
> +		}
> +	}
>   
> -			while (1) {
> -				iq_ci = readl(queue_group->iq_ci[path]);
> -				if (iq_ci == iq_pi)
> -					break;
> -				pqi_check_ctrl_health(ctrl_info);
> -				if (pqi_ctrl_offline(ctrl_info))
> -					return -ENXIO;
> -				usleep_range(1000, 2000);
> -			}
> +	return nonempty_inbound_queue_count;
> +}
> +
> +#define PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS	10
> +
> +static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
> +{
> +	unsigned long start_jiffies;
> +	unsigned long warning_timeout;
> +	unsigned int queued_io_count;
> +	unsigned int nonempty_inbound_queue_count;
> +	bool displayed_warning;
> +
> +	displayed_warning = false;
> +	start_jiffies = jiffies;
> +	warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
> +
> +	while (1) {
> +		queued_io_count = pqi_queued_io_count(ctrl_info);
> +		nonempty_inbound_queue_count = pqi_nonempty_inbound_queue_count(ctrl_info);
> +		if (queued_io_count == 0 && nonempty_inbound_queue_count == 0)
> +			break;
> +		pqi_check_ctrl_health(ctrl_info);
> +		if (pqi_ctrl_offline(ctrl_info))
> +			return -ENXIO;
> +		if (time_after(jiffies, warning_timeout)) {
> +			dev_warn(&ctrl_info->pci_dev->dev,
> +				"waiting %u seconds for queued I/O to drain (queued I/O count: %u; non-empty inbound queue count: %u)\n",
> +				jiffies_to_msecs(jiffies - start_jiffies) / 1000, queued_io_count, nonempty_inbound_queue_count);
> +			displayed_warning = true;
> +			warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
>   		}
> +		usleep_range(1000, 2000);
>   	}
>   
> +	if (displayed_warning)
> +		dev_warn(&ctrl_info->pci_dev->dev,
> +			"queued I/O drained after waiting for %u seconds\n",
> +			jiffies_to_msecs(jiffies - start_jiffies) / 1000);
> +
>   	return 0;
>   }
>   
> @@ -5922,7 +5949,7 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
>   		if (pqi_ctrl_offline(ctrl_info))
>   			return -ENXIO;
>   		msecs_waiting = jiffies_to_msecs(jiffies - start_jiffies);
> -		if (msecs_waiting > timeout_msecs) {
> +		if (msecs_waiting >= timeout_msecs) {
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"scsi %d:%d:%d:%d: timed out after %lu seconds waiting for %d outstanding command(s)\n",
>   				ctrl_info->scsi_host->host_no, device->bus, device->target,
> @@ -5957,6 +5984,7 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
>   {
>   	int rc;
>   	unsigned int wait_secs;
> +	int cmds_outstanding;
>   
>   	wait_secs = 0;
>   
> @@ -5974,11 +6002,10 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
>   		}
>   
>   		wait_secs += PQI_LUN_RESET_POLL_COMPLETION_SECS;
> -
> +		cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding);
>   		dev_warn(&ctrl_info->pci_dev->dev,
> -			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete\n",
> -			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun,
> -			wait_secs);
> +			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete (%d command(s) outstanding)\n",
> +			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun, wait_secs, cmds_outstanding);
>   	}
>   
>   	return rc;
> 

