Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B40DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E9D61368
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbhI3SzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:55:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19598 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231637AbhI3SzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:55:23 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIhbe7011113;
        Thu, 30 Sep 2021 18:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Z9qvQcL7znCRIS1akrx4TPyAUN8Ufk+j6ZI2hpCPKzg=;
 b=hDsWrxZwd6XtGEJPSq4kOXkCd6lat2+Qa2kcNMKkGsqpSu98ZgsIPWMVohC+Nlfo0mWu
 3SnhhoNAt++PTBOaoQ0b2Io239y5E83f08D19Xcs2bgKBzLD+Sh6TnhI/XabtCIMYnwe
 iL9u3jl0z+RyCxnfrpMCupwDLKAAw2g7MSg76vmuBMbChtuT1n5GqToVPOOY0wkHy5Cv
 wJL7tnZcN3KmwiNqJlLhvs4gXSKJid4hC19H5633byWG6CPEjnBN5W4oORTtVWrUPCdZ
 TLVSKHqnDTb+Lhv4EYtzxMmRcau7lzVKGMG+hn3WUlN4RVjIqLI9Or+E36yWbLXv7EtH 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdds82fwp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:53:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEX4L099698;
        Thu, 30 Sep 2021 18:23:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 3bc3bn1k5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/+DW0EZwU6Oyl8OtAFlKrNAdILfwr4WdGM+DeNaHzsie4/c/JVLLlGgd0VXoETZ9gkuNvRpVL+F3FZWt8khUdJLasNEACgOIOU06vo3up7JCHmKmmxgAfGUQ5ANXVt5dTEr9iuyWfm4B0HohOcRQsxB3iQKH4hJummU9fJUur/3tXqetn+ajhOXu7awplQ55XKHcXz87QQkbeYHO8ABU4UHVkP+adnrviEdi0WfwtBnBRE9r6Dsv8wp63SQjX4pWKXH6qgqQ+HBUxPNtR3B7SOWq3o2UD1RQj6AvkHNUXBvt3ruBUX1BqTe7Wy81NYdvRwxs6+435z84vMul3zqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Z9qvQcL7znCRIS1akrx4TPyAUN8Ufk+j6ZI2hpCPKzg=;
 b=gk4137SpasEtNG+D5spn0M4oxpAMEeDVHFGDQJcgVm0u4qsEYo8bq8WSWhrjAODeTjkvdyDOguPbQsOxdgXj3lLUOExfivxvKrl0xI8Ly2DcHTrlb+jOyM6CZ1qbu1rpcCak2iqgASqXV2/LbhNBXHWyBL5hRnaVJ2kzIBjxrx8jrK5xwqzlBR2poPYNCwC0nupns/0VhAz7Of1g2+OkGsnS2q5gqmuGNygsE1wq4SrzwEiGUQ4v3tZ3PIB0szmNjkaWJJ8DhSC1RImAya0lrtMe+dHuHljwoq5K/bac2DpqO1BMAwsUwdMJAcg0owClbuoAqxUuiDVK7bj/brD2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9qvQcL7znCRIS1akrx4TPyAUN8Ufk+j6ZI2hpCPKzg=;
 b=u5rRY/BxhbFhvpnPZsIMZsW5scfOT59syQVy2F3xojMEMquopu4XACFrZYqAfw9Ha8oIXwMMjVtPQ5NpLlngAa236HU7h2Ep6yXoTPtF7fiAakAfOJBHWKScebZYSS5IRqemPvOOun8+r8UOKDQn/aevWeoitNCzBjD/OdCx/wk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:23:56 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:23:55 +0000
Subject: Re: [smartpqi updates PATCH V2 07/11] smartpqi: add extended report
 physical luns
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
 <20210928235442.201875-8-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <16507dd1-c461-1615-2c7f-8c04a8456866@oracle.com>
Date:   Thu, 30 Sep 2021 13:23:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-8-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:208:32b::22) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BLAPR03CA0017.namprd03.prod.outlook.com (2603:10b6:208:32b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 18:23:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f66906f-03b5-4ae0-a929-08d9843f7687
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5539D21786450246A8548612C7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+37/gI5iIxAHRBlyg2o7IsTbMOkn8fGiLtuF1P4h2kwMlYsFFNPAz5hZzrS1RuiGsNV5bNvEgsj0cHAgtBzUX4TRD3zEcpqeMKq9hK2WXVJ26Jq+EF32praTxGbtS460V6H06NaeKE4kKSgooeEp00MaOLXsSD0s1Z45VYF1tvxGASxpaEtX10P7+GwxxajH0kplsf/JsfikDXvhmKb9vT4FDyYTZH/mGcugjwB9WcKtYU2/iuf6d9Qa/euCHbzzgg/Xji+BeUWeoxtWOwg4vlSQP1klq6UrX85LXfQwaGRrlxMIkxKGyeSRS7pAhuAWgCTjo71/znMbHhYlu9ihxkpl4NGOnyaClcOnMYcXIthXD1BveYH5asler2wD5jhaty6SnDGTwDDZdNKJOdv4tEJXjomRDvjTYwW1vc+XvXJkqcaXyCkoF1yLublou6JHPRDni0Avfcwn2Ci1avGww2eC+a3LU19E2UtCw5rOFKNbWbqEI9BOIJ89xNhISQkLpN2Eu4uTB19guQyPDyE9q2xdWOgg/0FgucIJ7jBGkcI/sxpaBF7ILrNOGxa5dNPtpw2qzedyfQAM745d/SldvxqWYEEGsUb1lYQHkhYagB2KCbVQuSf/t2zC9ZnEfuDkSmgodrFk5WuUfjxaIN4ybB32wBGZUbCvNkcaFBlGHHMNBCVpJElxUzt2TLaMsT7/Y1lLHJsdWPmAnlZkauesQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(30864003)(38100700002)(31686004)(5660300002)(316002)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mm5JblRUSFN5b1BWYUJ1dlpSVzI4M2JyZVhZOUR2VnhlTE10NjI2alA4SmNV?=
 =?utf-8?B?czA5L2RHeE5TWWdRMVpyUkR1WVBWTGpsMmwzMC9kSlBmcVV2Rnc2emF5Z1Bm?=
 =?utf-8?B?RE9ia0xQQXdCRFJ5R05Uck4xRGJUNUtwUlJPcWpnNXJTUlZkcDdSbGVvdndm?=
 =?utf-8?B?bVJySFJWU1RpQ0JWWmJlWDdZaEFwczlhM2ZTQ2NVYXEzR3ZRalhKK2ZDczRq?=
 =?utf-8?B?eVNuQjdEYyswd1NtOHBtYVpVclBQNkF6QlJDOUw4ZmJVUkxya1BlNFB2M0JF?=
 =?utf-8?B?SzVBRk5zRVRrSUJLbEdaeFZJcGFFM3pzMlREQjh4WUV6QTYxZ0h2Y0liZlA5?=
 =?utf-8?B?RURaVzJ3SlhNMkpoQU9uQWdEdm5IZkJ5SGQ4ZVI5aXJYUXBNQTVxWC9kQkxB?=
 =?utf-8?B?N21EUWVtZ2x3MTBESElRQUxOZm5yWjdSZTN1L2V5eWhvWmdNdk1QNmttODV1?=
 =?utf-8?B?dzFLVFRUVEVBS09XNTFZREFways3NldZZXFqc3N6RlB1KzZlb0FxYVVEeXF6?=
 =?utf-8?B?NDNLamRwc0N3bzVxbmlKTjU3eWYxZEhDZUsxL2Q2d1d4TzB1ZXNSemphNjFo?=
 =?utf-8?B?MXAvZzVET25DMDREem1sUWcreG9iRkZiZnFaNDR6TkpiN2xVdlRGc2hxckNv?=
 =?utf-8?B?YTFpb3ZLelpha25qR1haN2t1ZHphZWhvS3hiTHFtK3IreHZsUU5GRGZySWxJ?=
 =?utf-8?B?UDhHYW5NYXFYTnhDSnVOV2Q5WHpYKzZBR1BvaVE0NHFpcWRKT1NFL2NtODZD?=
 =?utf-8?B?OEpVNFJXcWd4Zk5tdGNCU2lLeTRMNDBLUDNKandzUXkwQ0cyQnFoNlpmZG9D?=
 =?utf-8?B?SUViNFlXOWdaY2hZbWI4Vmt6NStCdEo1WUFrMjVMK3pCMW1weXYxOUNIUjRq?=
 =?utf-8?B?VGl5bGgvcU1wMktTd2lHRmdIWUo3Z0VtUkZwS0hPdmNvd3pwck5XWEhqbHhW?=
 =?utf-8?B?U3hpTmQ4UnViS09RcEtoSzRpNlExUVNhRkVMT21xU3JVOURRcjloSnladUV6?=
 =?utf-8?B?cWlBSTVianl1K1FPWGpCa29mUUNMdFBRR0hQU0VveENtUWcrZWVlRDc4cEhD?=
 =?utf-8?B?a2ZLMWYyQWxROU5CRFlWaWRVb2l3U3hCTGVaU2dUVUhrem16V1J1dmo5L2hD?=
 =?utf-8?B?VkdxUFJRQzBrb1Z2Q00vVFFyYTFVTFJjSWZzTldva3V0WXVkSzRnVmF3KytY?=
 =?utf-8?B?K05CSjdUNWdqblBGcVJhQjZTSEdOVXRCTEhZTmlERFYwemt6TFlScFdTRUxy?=
 =?utf-8?B?SGhDQnhWZnAxOWF2ZG9zREh5MFFUenRGZFdLVi9LcTdoZ1JZSWFaV2k2TFRl?=
 =?utf-8?B?bVBXTnFMZ1FDUHV3ZnBmWVZudld2Ri9HNUFaSTVqa25FNVRTVlZQNWZuZEk5?=
 =?utf-8?B?Z0RmVEIvbWJhYVg0eWNZSFRXUHlOdFc4bFgwaHV3ODZMU1RWRWpHZE5oQmR5?=
 =?utf-8?B?aEJWNWtmS2Z6cks5ZFFXQ3NXbGQwZzVLWllISjZzbGZla3MvdlpLOG1qUTJD?=
 =?utf-8?B?QmNmWmczZUVRTGV6SGVGTDJhSHl2ZExKSlFrcTNxSGZCbE5zdDBnWm5yRUUy?=
 =?utf-8?B?YlFoZ3FJbEZpbyswZTI4bDU1MTJLbTFDZ3RCUHYzOE9Ga0tFbmNqT1ZoZWdn?=
 =?utf-8?B?RG56d01uVUJsbGdKd1VQbWJtTEhqQ09vcmtESUtaeTcraWQ1VFJNNFZxTENv?=
 =?utf-8?B?SDdyV3lUV0lsMHJESXJiZEdvU3lhMHZvWk05ZWhVaHhEbi9LSnRQVWNtRWZm?=
 =?utf-8?Q?80WX2nb0WyJPvn6IkmT4fRkTLSrLsMcO9LXZOb7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f66906f-03b5-4ae0-a929-08d9843f7687
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:23:55.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0OGMHaf3Z1f3AfrNwHcv7YgoHL56st4lKl6U+9GbtuTTB+5QpWH/WjFl2YzOHEH4sagCQeIdBduzFlxICmQ08YsgZrXQTq8w2u9P4epAVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: d5RDcb9YCtijkN93Hve4LJeD_2xd0qmv
X-Proofpoint-ORIG-GUID: d5RDcb9YCtijkN93Hve4LJeD_2xd0qmv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Mike McGowen <Mike.McGowen@microchip.com>
> 
> Add support for the new extended formats in
> the data returned from the Report Physical LUNs
> command for controllers that enable this feature.
> 
> The new formats allow the reporting of 16-byte WWIDs.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>



> ---
>   drivers/scsi/smartpqi/smartpqi.h              |  37 +++-
>   drivers/scsi/smartpqi/smartpqi_init.c         | 163 +++++++++++++-----
>   .../scsi/smartpqi/smartpqi_sas_transport.c    |   6 +-
>   3 files changed, 147 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index d66863f8d1cf..c439583a4ca5 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -868,7 +868,8 @@ struct pqi_config_table_firmware_features {
>   #define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
>   #define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
>   #define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
> -#define PQI_FIRMWARE_FEATURE_MAXIMUM				17
> +#define PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5		18
> +#define PQI_FIRMWARE_FEATURE_MAXIMUM				18
>   
>   struct pqi_config_table_debug {
>   	struct pqi_config_table_section_header header;
> @@ -943,19 +944,21 @@ struct report_lun_header {
>   #define CISS_REPORT_LOG_FLAG_QUEUE_DEPTH	(1 << 5)
>   #define CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX	(1 << 6)
>   
> -#define CISS_REPORT_PHYS_FLAG_OTHER		(1 << 1)
> +#define CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_2		0x2
> +#define CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_4		0x4
> +#define CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_MASK	0xf
>   
> -struct report_log_lun_extended_entry {
> +struct report_log_lun {
>   	u8	lunid[8];
>   	u8	volume_id[16];
>   };
>   
> -struct report_log_lun_extended {
> +struct report_log_lun_list {
>   	struct report_lun_header header;
> -	struct report_log_lun_extended_entry lun_entries[1];
> +	struct report_log_lun lun_entries[1];
>   };
>   
> -struct report_phys_lun_extended_entry {
> +struct report_phys_lun_8byte_wwid {
>   	u8	lunid[8];
>   	__be64	wwid;
>   	u8	device_type;
> @@ -965,12 +968,27 @@ struct report_phys_lun_extended_entry {
>   	u32	aio_handle;
>   };
>   
> +struct report_phys_lun_16byte_wwid {
> +	u8	lunid[8];
> +	u8	wwid[16];
> +	u8	device_type;
> +	u8	device_flags;
> +	u8	lun_count;	/* number of LUNs in a multi-LUN device */
> +	u8	redundant_paths;
> +	u32	aio_handle;
> +};
> +
>   /* for device_flags field of struct report_phys_lun_extended_entry */
>   #define CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED	0x8
>   
> -struct report_phys_lun_extended {
> +struct report_phys_lun_8byte_wwid_list {
> +	struct report_lun_header header;
> +	struct report_phys_lun_8byte_wwid lun_entries[1];
> +};
> +
> +struct report_phys_lun_16byte_wwid_list {
>   	struct report_lun_header header;
> -	struct report_phys_lun_extended_entry lun_entries[1];
> +	struct report_phys_lun_16byte_wwid lun_entries[1];
>   };
>   
>   struct raid_map_disk_data {
> @@ -1077,7 +1095,7 @@ struct pqi_scsi_dev {
>   	int	target;
>   	int	lun;
>   	u8	scsi3addr[8];
> -	__be64	wwid;
> +	u8	wwid[16];
>   	u8	volume_id[16];
>   	u8	is_physical_device : 1;
>   	u8	is_external_raid_device : 1;
> @@ -1316,6 +1334,7 @@ struct pqi_ctrl_info {
>   	u8		tmf_iu_timeout_supported : 1;
>   	u8		unique_wwid_in_report_phys_lun_supported : 1;
>   	u8		firmware_triage_supported : 1;
> +	u8		rpl_extended_format_4_5_supported : 1;
>   	u8		enable_r1_writes : 1;
>   	u8		enable_r5_writes : 1;
>   	u8		enable_r6_writes : 1;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c9f2a3d54663..1e27e6ba0159 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -572,10 +572,14 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
>   	case CISS_REPORT_PHYS:
>   		request->data_direction = SOP_READ_FLAG;
>   		cdb[0] = cmd;
> -		if (cmd == CISS_REPORT_PHYS)
> -			cdb[1] = CISS_REPORT_PHYS_FLAG_OTHER;
> -		else
> +		if (cmd == CISS_REPORT_PHYS) {
> +			if (ctrl_info->rpl_extended_format_4_5_supported)
> +				cdb[1] = CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_4;
> +			else
> +				cdb[1] = CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_2;
> +		} else {
>   			cdb[1] = ctrl_info->ciss_report_log_flags;
> +		}
>   		put_unaligned_be32(cdb_length, &cdb[6]);
>   		break;
>   	case CISS_GET_RAID_MAP:
> @@ -1132,7 +1136,64 @@ static int pqi_report_phys_logical_luns(struct pqi_ctrl_info *ctrl_info, u8 cmd,
>   
>   static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
>   {
> -	return pqi_report_phys_logical_luns(ctrl_info, CISS_REPORT_PHYS, buffer);
> +	int rc;
> +	unsigned int i;
> +	u8 rpl_response_format;
> +	u32 num_physicals;
> +	size_t rpl_16byte_wwid_list_length;
> +	void *rpl_list;
> +	struct report_lun_header *rpl_header;
> +	struct report_phys_lun_8byte_wwid_list *rpl_8byte_wwid_list;
> +	struct report_phys_lun_16byte_wwid_list *rpl_16byte_wwid_list;
> +
> +	rc = pqi_report_phys_logical_luns(ctrl_info, CISS_REPORT_PHYS, &rpl_list);
> +	if (rc)
> +		return rc;
> +
> +	if (ctrl_info->rpl_extended_format_4_5_supported) {
> +		rpl_header = rpl_list;
> +		rpl_response_format = rpl_header->flags & CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_MASK;
> +		if (rpl_response_format == CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_4) {
> +			*buffer = rpl_list;
> +			return 0;
> +		} else if (rpl_response_format != CISS_REPORT_PHYS_FLAG_EXTENDED_FORMAT_2) {
> +			dev_err(&ctrl_info->pci_dev->dev,
> +				"RPL returned unsupported data format %u\n",
> +				rpl_response_format);
> +			return -EINVAL;
> +		} else {
> +			dev_warn(&ctrl_info->pci_dev->dev,
> +				"RPL returned extended format 2 instead of 4\n");
> +		}
> +	}
> +
> +	rpl_8byte_wwid_list = rpl_list;
> +	num_physicals = get_unaligned_be32(&rpl_8byte_wwid_list->header.list_length) / sizeof(rpl_8byte_wwid_list->lun_entries[0]);
> +	rpl_16byte_wwid_list_length = sizeof(struct report_lun_header) + (num_physicals * sizeof(struct report_phys_lun_16byte_wwid));
> +
> +	rpl_16byte_wwid_list = kmalloc(rpl_16byte_wwid_list_length, GFP_KERNEL);
> +	if (!rpl_16byte_wwid_list)
> +		return -ENOMEM;
> +
> +	put_unaligned_be32(num_physicals * sizeof(struct report_phys_lun_16byte_wwid),
> +		&rpl_16byte_wwid_list->header.list_length);
> +	rpl_16byte_wwid_list->header.flags = rpl_8byte_wwid_list->header.flags;
> +
> +	for (i = 0; i < num_physicals; i++) {
> +		memcpy(&rpl_16byte_wwid_list->lun_entries[i].lunid, &rpl_8byte_wwid_list->lun_entries[i].lunid, sizeof(rpl_8byte_wwid_list->lun_entries[i].lunid));
> +		memset(&rpl_16byte_wwid_list->lun_entries[i].wwid, 0, 8);
> +		memcpy(&rpl_16byte_wwid_list->lun_entries[i].wwid[8], &rpl_8byte_wwid_list->lun_entries[i].wwid, sizeof(rpl_8byte_wwid_list->lun_entries[i].wwid));
> +		rpl_16byte_wwid_list->lun_entries[i].device_type = rpl_8byte_wwid_list->lun_entries[i].device_type;
> +		rpl_16byte_wwid_list->lun_entries[i].device_flags = rpl_8byte_wwid_list->lun_entries[i].device_flags;
> +		rpl_16byte_wwid_list->lun_entries[i].lun_count = rpl_8byte_wwid_list->lun_entries[i].lun_count;
> +		rpl_16byte_wwid_list->lun_entries[i].redundant_paths = rpl_8byte_wwid_list->lun_entries[i].redundant_paths;
> +		rpl_16byte_wwid_list->lun_entries[i].aio_handle = rpl_8byte_wwid_list->lun_entries[i].aio_handle;
> +	}
> +
> +	kfree(rpl_8byte_wwid_list);
> +	*buffer = rpl_16byte_wwid_list;
> +
> +	return 0;
>   }
>   
>   static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info, void **buffer)
> @@ -1141,14 +1202,14 @@ static inline int pqi_report_logical_luns(struct pqi_ctrl_info *ctrl_info, void
>   }
>   
>   static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
> -	struct report_phys_lun_extended **physdev_list,
> -	struct report_log_lun_extended **logdev_list)
> +	struct report_phys_lun_16byte_wwid_list **physdev_list,
> +	struct report_log_lun_list **logdev_list)
>   {
>   	int rc;
>   	size_t logdev_list_length;
>   	size_t logdev_data_length;
> -	struct report_log_lun_extended *internal_logdev_list;
> -	struct report_log_lun_extended *logdev_data;
> +	struct report_log_lun_list *internal_logdev_list;
> +	struct report_log_lun_list *logdev_data;
>   	struct report_lun_header report_lun_header;
>   
>   	rc = pqi_report_phys_luns(ctrl_info, (void **)physdev_list);
> @@ -1173,7 +1234,7 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
>   	} else {
>   		memset(&report_lun_header, 0, sizeof(report_lun_header));
>   		logdev_data =
> -			(struct report_log_lun_extended *)&report_lun_header;
> +			(struct report_log_lun_list *)&report_lun_header;
>   		logdev_list_length = 0;
>   	}
>   
> @@ -1181,7 +1242,7 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
>   		logdev_list_length;
>   
>   	internal_logdev_list = kmalloc(logdev_data_length +
> -		sizeof(struct report_log_lun_extended), GFP_KERNEL);
> +		sizeof(struct report_log_lun), GFP_KERNEL);
>   	if (!internal_logdev_list) {
>   		kfree(*logdev_list);
>   		*logdev_list = NULL;
> @@ -1190,9 +1251,9 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
>   
>   	memcpy(internal_logdev_list, logdev_data, logdev_data_length);
>   	memset((u8 *)internal_logdev_list + logdev_data_length, 0,
> -		sizeof(struct report_log_lun_extended_entry));
> +		sizeof(struct report_log_lun));
>   	put_unaligned_be32(logdev_list_length +
> -		sizeof(struct report_log_lun_extended_entry),
> +		sizeof(struct report_log_lun),
>   		&internal_logdev_list->header.list_length);
>   
>   	kfree(*logdev_list);
> @@ -1845,7 +1906,7 @@ static inline bool pqi_device_equal(struct pqi_scsi_dev *dev1, struct pqi_scsi_d
>   		return false;
>   
>   	if (dev1->is_physical_device)
> -		return dev1->wwid == dev2->wwid;
> +		return memcmp(dev1->wwid, dev2->wwid, sizeof(dev1->wwid)) == 0;
>   
>   	return memcmp(dev1->volume_id, dev2->volume_id, sizeof(dev1->volume_id)) == 0;
>   }
> @@ -1915,7 +1976,9 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
>   	else
>   		count += scnprintf(buffer + count,
>   			PQI_DEV_INFO_BUFFER_LENGTH - count,
> -			" %016llx", device->sas_address);
> +			" %016llx%016llx",
> +			get_unaligned_be64(&device->wwid[0]),
> +			get_unaligned_be64(&device->wwid[8]));
>   
>   	count += scnprintf(buffer + count, PQI_DEV_INFO_BUFFER_LENGTH - count,
>   		" %s %.8s %.16s ",
> @@ -2229,13 +2292,14 @@ static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
>   }
>   
>   static inline void pqi_set_physical_device_wwid(struct pqi_ctrl_info *ctrl_info,
> -	struct pqi_scsi_dev *device, struct report_phys_lun_extended_entry *phys_lun_ext_entry)
> +	struct pqi_scsi_dev *device, struct report_phys_lun_16byte_wwid *phys_lun)
>   {
>   	if (ctrl_info->unique_wwid_in_report_phys_lun_supported ||
> +		ctrl_info->rpl_extended_format_4_5_supported ||
>   		pqi_is_device_with_sas_address(device))
> -		device->wwid = phys_lun_ext_entry->wwid;
> +		memcpy(device->wwid, phys_lun->wwid, sizeof(device->wwid));
>   	else
> -		device->wwid = cpu_to_be64(get_unaligned_be64(&device->page_83_identifier));
> +		memcpy(&device->wwid[8], device->page_83_identifier, 8);
>   }
>   
>   static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
> @@ -2243,10 +2307,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   	int i;
>   	int rc;
>   	LIST_HEAD(new_device_list_head);
> -	struct report_phys_lun_extended *physdev_list = NULL;
> -	struct report_log_lun_extended *logdev_list = NULL;
> -	struct report_phys_lun_extended_entry *phys_lun_ext_entry;
> -	struct report_log_lun_extended_entry *log_lun_ext_entry;
> +	struct report_phys_lun_16byte_wwid_list *physdev_list = NULL;
> +	struct report_log_lun_list *logdev_list = NULL;
> +	struct report_phys_lun_16byte_wwid *phys_lun;
> +	struct report_log_lun *log_lun;
>   	struct bmic_identify_physical_device *id_phys = NULL;
>   	u32 num_physicals;
>   	u32 num_logicals;
> @@ -2297,10 +2361,9 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   
>   		if (pqi_hide_vsep) {
>   			for (i = num_physicals - 1; i >= 0; i--) {
> -				phys_lun_ext_entry =
> -						&physdev_list->lun_entries[i];
> -				if (CISS_GET_DRIVE_NUMBER(phys_lun_ext_entry->lunid) == PQI_VSEP_CISS_BTL) {
> -					pqi_mask_device(phys_lun_ext_entry->lunid);
> +				phys_lun = &physdev_list->lun_entries[i];
> +				if (CISS_GET_DRIVE_NUMBER(phys_lun->lunid) == PQI_VSEP_CISS_BTL) {
> +					pqi_mask_device(phys_lun->lunid);
>   					break;
>   				}
>   			}
> @@ -2344,16 +2407,14 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		if ((!pqi_expose_ld_first && i < num_physicals) ||
>   			(pqi_expose_ld_first && i >= num_logicals)) {
>   			is_physical_device = true;
> -			phys_lun_ext_entry =
> -				&physdev_list->lun_entries[physical_index++];
> -			log_lun_ext_entry = NULL;
> -			scsi3addr = phys_lun_ext_entry->lunid;
> +			phys_lun = &physdev_list->lun_entries[physical_index++];
> +			log_lun = NULL;
> +			scsi3addr = phys_lun->lunid;
>   		} else {
>   			is_physical_device = false;
> -			phys_lun_ext_entry = NULL;
> -			log_lun_ext_entry =
> -				&logdev_list->lun_entries[logical_index++];
> -			scsi3addr = log_lun_ext_entry->lunid;
> +			phys_lun = NULL;
> +			log_lun = &logdev_list->lun_entries[logical_index++];
> +			scsi3addr = log_lun->lunid;
>   		}
>   
>   		if (is_physical_device && pqi_skip_device(scsi3addr))
> @@ -2368,7 +2429,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
>   		device->is_physical_device = is_physical_device;
>   		if (is_physical_device) {
> -			device->device_type = phys_lun_ext_entry->device_type;
> +			device->device_type = phys_lun->device_type;
>   			if (device->device_type == SA_DEVICE_TYPE_EXPANDER_SMP)
>   				device->is_expander_smp_device = true;
>   		} else {
> @@ -2393,8 +2454,9 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		if (rc) {
>   			if (device->is_physical_device)
>   				dev_warn(&ctrl_info->pci_dev->dev,
> -					"obtaining device info failed, skipping physical device %016llx\n",
> -					get_unaligned_be64(&phys_lun_ext_entry->wwid));
> +					"obtaining device info failed, skipping physical device %016llx%016llx\n",
> +					get_unaligned_be64(&phys_lun->wwid[0]),
> +					get_unaligned_be64(&phys_lun->wwid[8]));
>   			else
>   				dev_warn(&ctrl_info->pci_dev->dev,
>   					"obtaining device info failed, skipping logical device %08x%08x\n",
> @@ -2407,21 +2469,21 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		pqi_assign_bus_target_lun(device);
>   
>   		if (device->is_physical_device) {
> -			pqi_set_physical_device_wwid(ctrl_info, device, phys_lun_ext_entry);
> -			if ((phys_lun_ext_entry->device_flags &
> +			pqi_set_physical_device_wwid(ctrl_info, device, phys_lun);
> +			if ((phys_lun->device_flags &
>   				CISS_REPORT_PHYS_DEV_FLAG_AIO_ENABLED) &&
> -				phys_lun_ext_entry->aio_handle) {
> +				phys_lun->aio_handle) {
>   					device->aio_enabled = true;
>   					device->aio_handle =
> -						phys_lun_ext_entry->aio_handle;
> +						phys_lun->aio_handle;
>   			}
>   		} else {
> -			memcpy(device->volume_id, log_lun_ext_entry->volume_id,
> +			memcpy(device->volume_id, log_lun->volume_id,
>   				sizeof(device->volume_id));
>   		}
>   
>   		if (pqi_is_device_with_sas_address(device))
> -			device->sas_address = get_unaligned_be64(&device->wwid);
> +			device->sas_address = get_unaligned_be64(&device->wwid[8]);
>   
>   		new_device_list[num_valid_devices++] = device;
>   	}
> @@ -6804,12 +6866,10 @@ static ssize_t pqi_unique_id_show(struct device *dev,
>   		return -ENODEV;
>   	}
>   
> -	if (device->is_physical_device) {
> -		memset(unique_id, 0, 8);
> -		memcpy(unique_id + 8, &device->wwid, sizeof(device->wwid));
> -	} else {
> +	if (device->is_physical_device)
> +		memcpy(unique_id, device->wwid, sizeof(device->wwid));
> +	else
>   		memcpy(unique_id, device->volume_id, sizeof(device->volume_id));
> -	}
>   
>   	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
>   
> @@ -7443,6 +7503,9 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
>   		ctrl_info->firmware_triage_supported = firmware_feature->enabled;
>   		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
>   		break;
> +	case PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5:
> +		ctrl_info->rpl_extended_format_4_5_supported = firmware_feature->enabled;
> +		break;
>   	}
>   
>   	pqi_firmware_feature_status(ctrl_info, firmware_feature);
> @@ -7543,6 +7606,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
>   		.feature_bit = PQI_FIRMWARE_FEATURE_FW_TRIAGE,
>   		.feature_status = pqi_ctrl_update_feature_flags,
>   	},
> +	{
> +		.feature_name = "RPL Extended Formats 4 and 5",
> +		.feature_bit = PQI_FIRMWARE_FEATURE_RPL_EXTENDED_FORMAT_4_5,
> +		.feature_status = pqi_ctrl_update_feature_flags,
> +	},
>   };
>   
>   static void pqi_process_firmware_features(
> @@ -7644,6 +7712,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
>   	ctrl_info->tmf_iu_timeout_supported = false;
>   	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
>   	ctrl_info->firmware_triage_supported = false;
> +	ctrl_info->rpl_extended_format_4_5_supported = false;
>   }
>   
>   static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
> diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> index afd9bafebd1d..dea4ebaf1677 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> @@ -343,7 +343,7 @@ static int pqi_sas_get_enclosure_identifier(struct sas_rphy *rphy,
>   	}
>   
>   	if (found_device->devtype == TYPE_ENCLOSURE) {
> -		*identifier = get_unaligned_be64(&found_device->wwid);
> +		*identifier = get_unaligned_be64(&found_device->wwid[8]);
>   		rc = 0;
>   		goto out;
>   	}
> @@ -364,7 +364,7 @@ static int pqi_sas_get_enclosure_identifier(struct sas_rphy *rphy,
>   			memcmp(device->phys_connector,
>   				found_device->phys_connector, 2) == 0) {
>   			*identifier =
> -				get_unaligned_be64(&device->wwid);
> +				get_unaligned_be64(&device->wwid[8]);
>   			rc = 0;
>   			goto out;
>   		}
> @@ -380,7 +380,7 @@ static int pqi_sas_get_enclosure_identifier(struct sas_rphy *rphy,
>   		if (device->devtype == TYPE_ENCLOSURE &&
>   			CISS_GET_DRIVE_NUMBER(device->scsi3addr) ==
>   				PQI_VSEP_CISS_BTL) {
> -			*identifier = get_unaligned_be64(&device->wwid);
> +			*identifier = get_unaligned_be64(&device->wwid[8]);
>   			rc = 0;
>   			goto out;
>   		}
> 

