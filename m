Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10896C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB79A619E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350938AbhI3SXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:23:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15916 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235171AbhI3SXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:23:46 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UHa4Uj011131;
        Thu, 30 Sep 2021 18:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7Y7+ZP7pSFP6ruWxAvRSw5wYpyRtXoy8C7PgRCJcVYg=;
 b=VWfh13/MNKhEFV4botzFZNam2Axu6Uyhs+aAJ4fQLofEWbrFTFVO4tQYmDcIG0vGG/cV
 QxL6L+LNAzGP0WhTb4vJF3rcLKwGEZIVuddlP/McM12ypoVbHf6+E7+RsZq05LNjcDvw
 3Z7TYPnH2iMsz1lM+NaDE8YDMDOsIs8TESUp5MtmWZPUlSlKRoyU38Sir39HEduGeDLv
 Sj5dKvYV5aBjCwj+rcXg+GAp27wksNL0AD3ZGNW/a0uBVq1ScxFDreONYeZhlb/B9MZB
 LKfRhGbZE6qg7jqtk/LwRy37IwQtPQ7oyp8q9ak9ADaaflCr0+3+xZG+v/sQx9b20KzY NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdds827xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:21:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIFocY052098;
        Thu, 30 Sep 2021 18:21:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3bceu7g9nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebYfVDkBM/moLIZEj9ea5pNeByeBqX90m+J36/a7JIX/3NvKh1lfmghgJfhQX+tylncoUvJxcZfVQ9f8sr8Q2ZE97LLLvtZC1IHKQgs2w6COUb/kLUUVaJ0HjTFqox7AFzMu+KvizL+4tk6xyGgpXW0gMV97MdOmPtmjYTYjQQdtCah984Vezgna7DvWUxPs3xSNJTUbWTZ5quNbDW5z/BOoRpEjEjyxCjbKekwIcIV1gN75WXgPduqvLZR8DSOcIGyw+OOAXc2fBj7Ye2FFbfRoAvC0cKkZbxYb9bBYN+Pfz9MJuOWGnCouhKCYI6KLGpGK+ngMtn0pdZyPvzer/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7Y7+ZP7pSFP6ruWxAvRSw5wYpyRtXoy8C7PgRCJcVYg=;
 b=S15oNeQg+SjlaWmqXEi+QnGBo1d/f+JZ1DjPBEIwIHQc5EN0uqcAuJ/BYg7w3W7Q/Rw4ECLmzMKtEWz8Z3h2TEg1DLlA0ibO25kYH+/dKJnvHTj2U87D0tpCwyZWiKNgS8fm64H2JNF3x5Q1Ski/wEs0Np9RvHgwWNHtb98fxG3NTwPXTpe+OYt5Z9wajrVLDiFqE/Qk3NKsNviemgB9IJvLAk7qLKJw4udU+LwzHhBFTdJOJ+rHlFiy84KBcWMqfKQPfKh8mctSBVPW3zvnrUOPOCSXgeRzhIkIZWFVZDKBqdgsJLSMFJYGAxWnG5ZePnnR0B5WTpPSsVWS/J+ypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y7+ZP7pSFP6ruWxAvRSw5wYpyRtXoy8C7PgRCJcVYg=;
 b=RVBoL5bcDkwRhyHjq7fzpj5FOhj0Wm/eyR+GXRfcXMLaHFx40Apc3AnDSnifkTK9HWfGfRu59pPioSp66/c+ZM25UWROZ3WacCO8s1gb/nkEQ1TQK+19Cjd93gXSAuitvjV6vnZifAAVbzO0HPm+sXBMAxT2LC3NP4/jt1zV9b8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4612.namprd10.prod.outlook.com (2603:10b6:303:9b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 18:21:34 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:21:34 +0000
Subject: Re: [smartpqi updates PATCH V2 01/11] smartpqi: update device removal
 management
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
 <20210928235442.201875-2-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <b3d91ad4-b3ea-d189-1606-d565166a4fe8@oracle.com>
Date:   Thu, 30 Sep 2021 13:21:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-2-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::36) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BY5PR17CA0023.namprd17.prod.outlook.com (2603:10b6:a03:1b8::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 18:21:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c08532f6-f43f-4db2-dc23-08d9843f21da
X-MS-TrafficTypeDiagnostic: CO1PR10MB4612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4612417D680A0F0B35D08A4BC7AA9@CO1PR10MB4612.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YkzImttez6bYE5WZNZJXvaYgE9QXXt3cEXKMgjAY4IJolcpIhkW/LHv8k0Uvnhtil6jQE7DnGzEPQuEeOlUKMc5T8p3SZwa0b1SZ/cvXOQJmuzMj9S1YksVlm7y+kD/6JL++pbRcHiX8xBgwm0IJ4F59Ls4rexeEK1CTxvNeJo3/T697Qfi3IRW+v22qYfRAq8p1F26Uy+X7YCT4WJlZn3OSuSw7Lp+FYOrggJ7OIWDfpNUujATtVqAtgEM8SrTk6W8c+g73u12+2C0CDGq/bLuvKxxpYsa2O2kcVmmDDcM9Qr9QtCqJa5ljZmXjTBpDTYZOmxKKbMRitueaIi7fL2fcTkxVAghwXHilDBIK9bjqXg/CnZ4QgCTPOxa4a2Gi7ACdx5J//e1URPKMjy4isS70kUPhgbjM9f6vIwXrmKuOZw2mCTBc487/jnLn8CsKMCCSg0iRkgu/h24Or2Mj8vuRo3QGspaF0T7a9+QW8oM5/SFl1GmgP48SZ6d5BDwq75hcqpCPkmwYstCye2mijKxgdTzafNyq169birPSjOp6ewzT/8FSbmgzEPeBf+V534cgiPoCkt22ug+M/mzgNogmne4WHVpKOGa2dihba4KGiFApp5yFSuPJqrsJRN7V/CJK/Hx6phrbdE3PDa2tJwwdnq/EDdqeOLY1tG5zrI5PUFP1VxF/IDYmO7oOkZxgh7E2d6mCzX5v5u920bYD3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(5660300002)(31686004)(4326008)(6512007)(9686003)(83380400001)(2906002)(8936002)(8676002)(15650500001)(2616005)(316002)(6506007)(6666004)(36756003)(66946007)(6486002)(956004)(31696002)(7416002)(86362001)(26005)(38100700002)(66556008)(66476007)(508600001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2pITDNST3NlNWU3NU5DZFF1RG1qbTBGMVNWVjlVVXNEQVQvcVptMUVPQlZU?=
 =?utf-8?B?V3Q2bWQva2dva2MyWXlsMjR4TkE5TUVRTjc4TlJWMEZIREVhRGtGY0s3WmI3?=
 =?utf-8?B?RzRKYWd6eFBLaHgyanljVEhJUStlTjNzMGdUcHA0YTVsWnpRRmJhNUFRNjlN?=
 =?utf-8?B?Wi96ZUNhOFBBSkMrdk9ETHdlM3R4d1ZyWWZDL1NpQ0h4bDkyaFpiV1hJbHVr?=
 =?utf-8?B?R2xDclpHL0JCWUJqOW9PY2UrV2E2cEZHQUo1MFBtbkRzdlEvTytsSVJWbFQy?=
 =?utf-8?B?Y1Bna3poN1NkVFIrWmpJVHJqZmVvTTRpb3VVeGlXV3RaQmJoUTZyTk56aHNV?=
 =?utf-8?B?Rk1wbWRVdHY5dkwzZUVBdzlXVHV1ZCs3OWNQajRYQWVqcTJvRE91YkZzQ3VB?=
 =?utf-8?B?Qm5TMlZNT3V6NlRnbUEzeFRtRmR1by9HUVdEenR1YkgrYnJiS2hOR1RhenF0?=
 =?utf-8?B?eUNuSmpLZkpGVVU4aytndFZaek5iQ0VKbW1nbVpjckpDdHBlZW03MW5VcllX?=
 =?utf-8?B?NVI0Qlk2dm8yOFBYWmMxWFF6NVpSL1RHV3VTWmRNWjNKc2xLbGJGRENtMXlu?=
 =?utf-8?B?RXpieUZGcVhIZ2g2Tmd6Q3hpK2JaQVl4Z0VGbm5KbkNDT2dzcmp4b0Nqekl3?=
 =?utf-8?B?SnJnNTdxdnJGTzV1VzQ5b3d3V0xxT1E3TUZzU0RlVFBwNHN0Skw3ZWlGazM0?=
 =?utf-8?B?U2pCR0pDeXFPQzdvZ0R6QUxRcTJ6c0NNL3AxNURaZENpcXhVZ0NMd29NaDRa?=
 =?utf-8?B?ZzhoaTRsR25HTWhTbUd6UDhXa1huSGl1TVd6VlJMTThmVnU5amFwd3NNc0p4?=
 =?utf-8?B?WXQ5K1JCdXZtTkUrWC9jUUNSWnoxVU9FWVlyL3VlTE01Tjh6OGg3dFdoWERm?=
 =?utf-8?B?c0NETGRpaEJOdnJPdk9IdWg4NUF0WUxLZnBIVXZDc3RweS93QWhPS2xvWk9W?=
 =?utf-8?B?N01ScGRremo2SWdwWkltNUptbWNPbUFPdWh4MVVvTER0VVZXWTN3Y3k4cGZt?=
 =?utf-8?B?ZzVHczYzenc0c1JmbzRhdTlRNmN0ekZLaTJKRVEzSEZXN0kzeEpMNU0rMFZ4?=
 =?utf-8?B?bENrN1F3aDluWXpmUDNraDVmQTEyTFp1RkkreGVxSDZPZVA0UkNaNkNwQ09Q?=
 =?utf-8?B?THBqcGVFOENiYVJvUUtna3ZOaUtGb2JYc0dPWjc3TlNzN3RMNWVxQWszTFp2?=
 =?utf-8?B?cUNPWVk1cGM4d0hVVFA4VHNkY1ovd3Qrd0hidTVwd3hxcURxTTdqcHNIQWQx?=
 =?utf-8?B?cVZGM2lhSEZVRVZIeEdqWGpMYU9Ha2hNWUUzeXJWVXV6R2JraDRNaEdJZjNU?=
 =?utf-8?B?TFNVZkZJbC8wQmMxS2tVU0R6TmFpdTVxOEdGSEhoMElJaVlqRnlDOUVPYjNO?=
 =?utf-8?B?MzJSYzdTMTBFRitqRkNZbDhHVXFZL1dtTUVhQkVYQXprcXI4Q2VlSG1WTHdM?=
 =?utf-8?B?c0hrcWJZdTZqZlNFb3hoeW1vS1lCL2RrQVkrMU0zT05yZmFyR1B5Nk9hZ1NT?=
 =?utf-8?B?a3IwcWpaaXpESGRwTU5mVUR6ZGlndTZNOEwzQmdZTE5RQ1JYU2E3WXQ0a0NS?=
 =?utf-8?B?aHVEREV0Mm1vdnJhT3hMSGZkeDZuVFMzbVdXQS84Q3lwTk9OUS9uSFYrS1FB?=
 =?utf-8?B?RXVaU291Y3h3YWlPR1M4aFZrS0V3Y1YyR3l0ZlZ0bjhCcDB6aGo2TjE0UXNQ?=
 =?utf-8?B?Zlh5eVdMSzlVTlQxeGU0VkliMDJyeVQ4RmRFNGlxZkw0bHNMTkVNV3Q1cXJQ?=
 =?utf-8?Q?qCAzQouv1SR7C0VAPG9txpy+5Ap9TsmWuxJpJBQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08532f6-f43f-4db2-dc23-08d9843f21da
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:21:33.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNAvXYLxbMQPIHt9RqagPwFRgbY8uI1qW0VGIcKVltjzyhPSYHtvceit8gNh2Mjlq4eGsT+cp/wWhqWAE0cSOjxU6gbkrFWlVlehxaHJMrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300112
X-Proofpoint-GUID: 3QBy16_KZ--xce0P6KycJh5-BjBKvvRG
X-Proofpoint-ORIG-GUID: 3QBy16_KZ--xce0P6KycJh5-BjBKvvRG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> Update device removal path to handle issues for:
>    rmmod - Correct stack trace when removing devices.
>    rmmod - Synchronize SCSI cache.
>    Update handling for removing devices using sysfs.
> 
> This patch also aligns the device removal code with
> our out-of-box driver.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 64 ++++++++++++---------------
>   1 file changed, 28 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ecb2af3f43ca..97027574eb1f 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1693,8 +1693,6 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
>   {
>   	int rc;
>   
> -	pqi_device_remove_start(device);
> -
>   	rc = pqi_device_wait_for_pending_io(ctrl_info, device,
>   		PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
>   	if (rc)
> @@ -1708,6 +1706,8 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
>   		scsi_remove_device(device->sdev);
>   	else
>   		pqi_remove_sas_device(device);
> +
> +	pqi_device_remove_start(device);
>   }
>   
>   /* Assumes the SCSI device list lock is held. */
> @@ -1986,7 +1986,7 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
>   	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
>   		scsi_device_list_entry) {
>   		if (device->device_gone) {
> -			list_del_init(&device->scsi_device_list_entry);
> +			list_del(&device->scsi_device_list_entry);
>   			list_add_tail(&device->delete_list_entry, &delete_list);
>   		}
>   	}
> @@ -2025,15 +2025,13 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
>   		if (device->volume_offline) {
>   			pqi_dev_info(ctrl_info, "offline", device);
>   			pqi_show_volume_status(ctrl_info, device);
> -		}
> -		list_del(&device->delete_list_entry);
> -		if (pqi_is_device_added(device)) {
> -			pqi_remove_device(ctrl_info, device);
>   		} else {
> -			if (!device->volume_offline)
> -				pqi_dev_info(ctrl_info, "removed", device);
> -			pqi_free_device(device);
> +			pqi_dev_info(ctrl_info, "removed", device);
>   		}
> +		if (pqi_is_device_added(device))
> +			pqi_remove_device(ctrl_info, device);
> +		list_del(&device->delete_list_entry);
> +		pqi_free_device(device);
>   	}
>   
>   	/*
> @@ -2328,6 +2326,25 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   	return rc;
>   }
>   
> +static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
> +{
> +	unsigned long flags;
> +	struct pqi_scsi_dev *device;
> +	struct pqi_scsi_dev *next;
> +
> +	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
> +
> +	list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
> +		scsi_device_list_entry) {
> +		if (pqi_is_device_added(device))
> +			pqi_remove_device(ctrl_info, device);
> +		list_del(&device->scsi_device_list_entry);
> +		pqi_free_device(device);
> +	}
> +
> +	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
> +}
> +
>   static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   {
>   	int rc;
> @@ -6120,31 +6137,6 @@ static int pqi_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> -static void pqi_slave_destroy(struct scsi_device *sdev)
> -{
> -	unsigned long flags;
> -	struct pqi_scsi_dev *device;
> -	struct pqi_ctrl_info *ctrl_info;
> -
> -	ctrl_info = shost_to_hba(sdev->host);
> -
> -	spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
> -
> -	device = sdev->hostdata;
> -	if (device) {
> -		sdev->hostdata = NULL;
> -		if (!list_empty(&device->scsi_device_list_entry))
> -			list_del(&device->scsi_device_list_entry);
> -	}
> -
> -	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
> -
> -	if (device) {
> -		pqi_dev_info(ctrl_info, "removed", device);
> -		pqi_free_device(device);
> -	}
> -}
> -
>   static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
>   {
>   	struct pci_dev *pci_dev;
> @@ -6938,7 +6930,6 @@ static struct scsi_host_template pqi_driver_template = {
>   	.ioctl = pqi_ioctl,
>   	.slave_alloc = pqi_slave_alloc,
>   	.slave_configure = pqi_slave_configure,
> -	.slave_destroy = pqi_slave_destroy,
>   	.map_queues = pqi_map_queues,
>   	.sdev_attrs = pqi_sdev_attrs,
>   	.shost_attrs = pqi_shost_attrs,
> @@ -8169,6 +8160,7 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
>   {
>   	pqi_cancel_rescan_worker(ctrl_info);
>   	pqi_cancel_update_time_worker(ctrl_info);
> +	pqi_remove_all_scsi_devices(ctrl_info);
>   	pqi_unregister_scsi(ctrl_info);
>   	if (ctrl_info->pqi_mode_enabled)
>   		pqi_revert_to_sis_mode(ctrl_info);
> 

