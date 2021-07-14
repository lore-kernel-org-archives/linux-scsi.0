Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40CFC07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9572261374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhGNBSO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:18:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30706 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:18:13 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E0vFjk023658;
        Wed, 14 Jul 2021 01:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5wD1aG7ALWu476rWUcnmooA/F5ByUgBVmb2RSTAywbc=;
 b=WwuJpp12ThZf0OheWoxANqqEHCM/sPViB2pek9fHRsd0UEgfMa8FzD9HPnFktPXQbm0B
 PXCpNas2m7ufh4x1mKQs5f2vuyK6JZVvCdyCZrwBmyB15AcBdzUueMVFgo2DyXMNh04t
 7X0NH90ng6VmMZxYjcoLXvka+rbSIRd34Xx8RKOKtmgo51bXY7cMBHcDRW8PapZ0tnw7
 i2vtzGhGd7k+J/tU38aC5+XFW4bHx6NvCmZ1Ujw4JRmIggm4utBtW4oQ24hddxprMU+e
 j9XcUeaXESGKpCz2Wo1rJXJUyOLLnNkHQwcjWGlyJhWFTkUpUmss8xS+OG66CG9+mBwc 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb3nsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1EvWm174290;
        Wed, 14 Jul 2021 01:15:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3020.oracle.com with ESMTP id 39q3cdduu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ6hkgPNAmk7mutT5C5Hqo1YVOjUhjokohUCeHYkxZBnkr0BjvGeoEeHTFq2qqKGt2cyLSeE5QRflknQDm7vQ2OQIIQJ7q2jM9wvGW+9WhS2RUv/LmKWji6VLztK7C+O1T6vguWJCK6nEOQ3ctf2TI6ssECJ4XMQz066bdAPCRm4jazvmMeR06EOP+a1MwcdwbooKWl3/TVFQASHW1VdnZWFaIcAmPII4ZCAV3guVMCPaUYwm7pUzxRXZGW36inJQGoqudJ1QUdR+eQ59Cs0A7i+f5olE3nnTkH6sy5vgA1aqhhoC5gIffcYg1QsppoNVGU5yDWSBfbse+3x4/g/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wD1aG7ALWu476rWUcnmooA/F5ByUgBVmb2RSTAywbc=;
 b=GIGRfjpuOg+TTv0aJEKXdzgB86j6xLJi+QtxlJXvaDRCUisHS4ITi6vbkqk+iV7g/9L+/S2HkGxFKriJ/TsH+yEHcaI5s+uY1/oWo42wk0dJCMgxeCBVQwlmphpYZ5ngObJdH8xN+cFU4I8DJQapQn0lRtGF7rvRkF6wFgMGeQMTaTQKVjWZGkiG+Y4VBVFTEBX+JWoxNau37Pna1SOqBEkfATWQGfP4cn+ufyj279x/k4qEVQbBm9whCJ2EACDuWHBMnke9uoKTXO9l1qsD9L9toxn4q92cIre4LUFWZV8C6AL4E+2yseEqhmpW8P71bUTWGXTdDHgt/YjsXq1Jrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wD1aG7ALWu476rWUcnmooA/F5ByUgBVmb2RSTAywbc=;
 b=M8WPJidD3CjgifwGVeuICBnx4tUe7139SYVkt3pQsGtDnG4oucLBJpbsXnS5OcCaMl+WSm3GrXHBOv49PxW3uHt1DJYEmpjBJfG2QG8jbDvVYiiTlaEf2LgYzGsGplhMUOIZNHI+LwU6RrGw7ttXvXwZa2aWpbAPGKWGg1JDBaE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 01:14:43 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:14:43 +0000
Subject: Re: [smartpqi updates V2 PATCH 5/9] smartpqi: add SCSI cmd info for
 resets
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-6-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <27638adc-44a3-45dc-2d15-6c08fbc28f85@oracle.com>
Date:   Tue, 13 Jul 2021 20:14:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-6-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:3:5d::13) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR06CA0027.namprd06.prod.outlook.com (2603:10b6:3:5d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 01:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd9a963c-4918-402f-d2f7-08d94664c2d0
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4451BD26DC3CF9309A098B7AC7139@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gOAXSVSfqVtY6fN3HoErfYt87QUhrTu8T4n2xKF6ZERdv5xIq87yETEVgS7+2QqfiAZv1q4/08gOkQ6vxZnt4T2BYpMo1EOp3hk0RafQX7QVyqTA7y5WBlXCnlG7MPHdGFE7GnfOPXHDGS+Bl8FfnBc+0HUIzPGJGwLwleOruzUefg08fZF6eXR1d4lsqRQNw8kmY1e8T+NEmiQintvUpfL6JBtQNGMgrK51Zmu5tz3vnX1FneyNtXqMl8RTSvdewL7PYdWAznZ5C2R65WCvyQCGkNKixCO0A0JCAEl7N7NXGOFZVHrbDu0k61lD/Ea4yEQcH8Y5dMrem2PH9gDkwBvded5q8RUB8VsQZeX+7FqQ8/tEnzyKVtL94lvlz/chImrLJe/93cUh4UJfq11WeOtz0BbGaet5A1aEGgqA+sCEH0BsWLE1T9La75JZfLYPogA9Der6l/jU/CkMSo/n0LIMvnFbMbHb55IoseYvN9d4v7CAmXoloYixlgJq68c1fW/a3j2FWnuW1zk0Q/PgGddEQjEe4a+rT5JxxoRrTTYxs0HFSGSgLo+V7ngZQ5rn9FM96DpSYID5YUOuo4/ioZoXVJns+GraF06oqFxAeFoEY6GYvHJYwBATNiqu+S3Lg5BxsB6i7NplUPqbA+VcDMmeiG1sl0m9Fil9B02H+RiTWSIhldzHQdYhQmBm5KhAUjfT1T7r289uQpgeT/qluEe7SdRTwxxeYYGiqjA4MM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(83380400001)(7416002)(66476007)(16576012)(66946007)(956004)(2616005)(478600001)(316002)(36756003)(66556008)(6666004)(6486002)(8936002)(5660300002)(31686004)(186003)(4326008)(86362001)(26005)(2906002)(38100700002)(8676002)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3RHRHRPMUlPQ0E4YVd5MUZBaW5hamx5MDYzN3NQYkQxRTI3SU4xaUxnTUxX?=
 =?utf-8?B?b1g3Q0h2NklaaUNXRE5id1V4Y0p5QkQyekdPajdrTXlUR0pqTm44Z0hiZ1g4?=
 =?utf-8?B?NXFTdFFIaWVYYkFQU3duRHIzUzlGYkgzejNZb3lkdGg0SlVORVg3OTFwY3V6?=
 =?utf-8?B?ZGpIZnRkTCttZzZ6UEVBK3JpaHVPTmRMSTF0SStUamdoRkl2a29CL2poRUR6?=
 =?utf-8?B?dUZCeElqOFNKWW1DQnVlSEhqZEFVNUVtUzVuOTBJMU5nQ2NyTlJpSkxWSDBV?=
 =?utf-8?B?bUZFSWlDMDZoR3RidUM0TkljYnMyZHdxOWZsd29RN213YkxJSUhybGxuZ254?=
 =?utf-8?B?R0dFM2h0SjdNZERjK3lWdkhNZUI3VThxRmhlODJGRlF6aHpNYU5FRFR6S0JO?=
 =?utf-8?B?THNjejllOFdhUEVya3d2OVRyR1VORGRXV0FabE81MWpzU21WT0ZQelNLL1J0?=
 =?utf-8?B?TW1OczhuMnZiM2lMNi9QZ2M0Y2lhOWx0b2NqOXB6YXlocnZPUCtQMHp5dlJY?=
 =?utf-8?B?Vi92VXo4b0VYT0JsQUZobXhzNEFmUC9yTlpmckZWTXR2Q200TXM0MnRNYmxu?=
 =?utf-8?B?ejk1QXBGcmZISjhBY2JmUlhSZGN4azRablE1UmNmWFFNRHhJL3hYTWNRWC9K?=
 =?utf-8?B?ZVlIS0VKcVkzM3M1K2FBU3JYVVoxMm9hSnVvYXlwSExhSGFjVzVYSzdqY3Ra?=
 =?utf-8?B?UGlvOEJBQTVvSnBuR1ZlNDBPL0tLM0FvbEZkOGZiRVNla0ZaSEsyOVJHR2Z5?=
 =?utf-8?B?MmVsREJFaXdlcWk1R3oyZ1U3QjRrMlh3eVlUclVHZk8yL3NTaitRbEMvdkwz?=
 =?utf-8?B?Yml5cTFrOVNEVGhiRGxjM0hvNjlQaUZ4aU9aQ2xXV25yYkF2a2Vmd0lPZmZ6?=
 =?utf-8?B?ZEdDSld6UXB4Sml0NS9PS3YrczlreW1KeDBpMmtjejhZbWd2cE10NFNvOHlt?=
 =?utf-8?B?N08vWk1TckRRZUw0UEJFdSszdzRUNEdQRVBkYi9qSVU2Zjhxc1duKzlDdmR6?=
 =?utf-8?B?UGpaYWN2TW9oY3FGZUlYU3hGQ0hKcEx1eW53RFVsZ2lxOTFQWkhodDhxczdv?=
 =?utf-8?B?anF1bVNiZ2hYNGdQdzNaSU9ZNkpidE1IMkxXSmtvejJvTTl4SW1hNkltOXRD?=
 =?utf-8?B?M3FsTkNhL0xuT3FmSWg4S1ZGay82T0huSkFMVTJRdDdvaGtJcXg4aElRcmZV?=
 =?utf-8?B?ZmkxMGFGeVQ1MjhLQ1RMZi93NU1rUmZDSmx0VlN5RlZRYnRjaGlVTm1qandK?=
 =?utf-8?B?YXQrLy8zZWM5Ky96YWhCM1ZHMCtRMDZLbkJHSTlidFJ2ODhXWnlNMlRxZCtj?=
 =?utf-8?B?YnJuVU9TS0s0Mm5nSFRRUGNSbnN3N2Q3Y2hYU3VKM2hIVkFhNXVZT1NrcmhE?=
 =?utf-8?B?UjVRZ09scHJSTUZnOHdyL244a2dQRTZzV0FLcVVLYzh1aWh0OUc3SGNtV2V2?=
 =?utf-8?B?VWlHZEdaS3dISHpua1BJbGlNcFJVUkZZVHFGOEwzZFVvVGcwSXVvdm9keUky?=
 =?utf-8?B?SEdKZk9WeWszOXZkZGZuRmNEcjlMZG5vRWd1UnhWMVpaeDFIcERGSXovWjl5?=
 =?utf-8?B?dzY2UEpkRVViS0xyM05LQlFyR3UxNkp4d3dDRnJXUFpLNkgybVVPZ2FSOUZo?=
 =?utf-8?B?REJVaEZrdzI5N3lxRVpVMDl3L1BQdE9GdUxROGhoTlpRRWVyVUtKOStLRENO?=
 =?utf-8?B?QkZvN21DOU80Ui9LNEhIUVkwekNNZk4wVnhLZW9LU0NhMXY1bElWREVsZmww?=
 =?utf-8?Q?Ogj9uCY5ROarBSijYav2kPDjC/+qmlx7yfybo6E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9a963c-4918-402f-d2f7-08d94664c2d0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:14:43.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UiQvntRnwl8xZ+34aj/BvkpRSxUFobqoJTtoxSdZtGXKkPTFsRzEXdI7ZTwxuRsoARI0nA/6IyQJ7emlxaj2/w+10eedkpAM7LRbwSWlYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-ORIG-GUID: pkbJif95Jkit6NlWeG8Q9hpXqOpgbywo
X-Proofpoint-GUID: pkbJif95Jkit6NlWeG8Q9hpXqOpgbywo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> Report on SCSI command that has triggered the reset.
>   - Also add check for NULL SCSI commands resulting from
>     issuing sg_reset when there is no outstanding commands.
> 
>     Example:
>     sg_reset -d /dev/sgXY
>     smartpqi 0000:39:00.0: resetting scsi 4:0:1:0 due to cmd 0x12
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

  John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 29382b290243..ffc7ca221e27 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6033,8 +6033,10 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
>   	mutex_lock(&ctrl_info->lun_reset_mutex);
>   
>   	dev_err(&ctrl_info->pci_dev->dev,
> -		"resetting scsi %d:%d:%d:%d\n",
> -		shost->host_no, device->bus, device->target, device->lun);
> +		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
> +		shost->host_no,
> +		device->bus, device->target, device->lun,
> +		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
>   
>   	pqi_check_ctrl_health(ctrl_info);
>   	if (pqi_ctrl_offline(ctrl_info))
> 

