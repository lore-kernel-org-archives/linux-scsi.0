Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD5EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0DF61A0C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351631AbhI3S0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:26:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37390 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351605AbhI3S0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:26:54 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIM5La019382;
        Thu, 30 Sep 2021 18:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pArKLB+wvS4oqVbshc9W/gzD+DMFG/zXSUIPYSujZyY=;
 b=IcMYGVyRrgv0wujuaSq45Xdm9F5HsAcQevDGPp9BYPv+dfPm6sx9DPNwO3+3teIlmFkM
 CWanh5WUpVudB8orrONTZK0y+TpEF30H828GhMHTe1i03lAxJ7jwDA/9PJYM6bzQ5miR
 72X5/yEDTAaPyxfCVWNPWYwVDP+oj7YUcjeWPw1/TRnVyR6x7baxoscr5EhX6L2A4DWS
 YdCrqQB2Hju2LUUVq/9usSZmPRz0E8jbUiFGnoFaD53Khgb+H0KUlzRmjpC/QNVeqCMq
 U1YK95SdBMM9wr3EZioLL9FaLh4XPzs3RkZXcSj+RkUyV7Q3HSbaGvDbvgVC1y//36Ys sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bde3caf6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEXOI099655;
        Thu, 30 Sep 2021 18:24:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 3bc3bn1mjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXzZogbg7xpCfwQ3UplV7Fmzd8kJvdbH1B5l19e2PpIV2IvqqONYDffs2ul27pZ48GNe7EEWIfJEjm4I96426nE7a1hd6xCKV/fYRTZq7U3wygTu+XEYumgarFDCpCNR3iPBws3aimBvHO0qKpagiBmLlDUVfeJ74DanRKaCgqeCOI/8qOWvnrdCS0Lqx2KNbCzLkI3mLQgjbGDVmxmpx3RlU15Povd/otY81q7VfaB7qspYLEkphiuidQavIQQV3vilRETGu95lMeIrRaeu8PEO7sDQ5IIt4fUsLv8zYOUyt2lrr+K57W4HO1CilRmeUSXjY5Yi47Rtyvn2jer57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pArKLB+wvS4oqVbshc9W/gzD+DMFG/zXSUIPYSujZyY=;
 b=Ndz2NPDewyCSX3j18aF/J3eXcymeYMDtHrO7LUsA534wlCIKnV6zsXjKmp+rILa3UvWKwCYo2eVDhhLaFivkwwAy790PzT9MV5ddDXQpgEfjO8eMXP+oGz3yjIgFM5e6VXDnTI4OB6/9K2dWu6dJCR13O998w5QHfQXZIjIQKPo+8FzIrYkeCXQEBjb1LKoXeUwXJViQ/NZ1iVLumnDCRfK+UGxP/9fSaKq4Lsz1Yjz+TEBCkfPt67jTyrYQ9iWR7dchf3mLRlpvrACyblRw314iJal5wjrYZ4R+pdTnkB0t+7I5ZHNmwRSZylLkCKZeUD6Iv2BFGnFtQQjVpgJk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pArKLB+wvS4oqVbshc9W/gzD+DMFG/zXSUIPYSujZyY=;
 b=qVJpV/y46V+PFEsZbsQIclYhGwed4cqJVPUsFL2pQcClPGpEATSY+/HqFKxUIhLYkiBkfwiHnZ7jJNZ/PGkTkYveO12yhG7Gao4yyOwtPW2ZNW29R5y+qm0ca/VPzYPjTYxJ3gMapAGW1SumlcMD9dhV9HU9CgU2j5Sip69k7m8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4465.namprd10.prod.outlook.com (2603:10b6:303:6d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 18:24:55 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:24:55 +0000
Subject: Re: [smartpqi updates PATCH V2 10/11] smartpqi: add 3252-8i pci id
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
 <20210928235442.201875-11-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <2789e6d5-6787-4ce2-7170-1ffb3b6f2551@oracle.com>
Date:   Thu, 30 Sep 2021 13:24:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-11-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:806:130::26) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by SA0PR13CA0021.namprd13.prod.outlook.com (2603:10b6:806:130::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10 via Frontend Transport; Thu, 30 Sep 2021 18:24:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71ea8c97-5435-4cc1-1fbd-08d9843f9a2a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44653A9809F1065080BB64A8C7AA9@CO1PR10MB4465.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZDiw24EdWShrw61XhRvdb65M8n8LXaKS7RR3nohhXZHpKnanpeFhEsC2gWA4IupAK56JPXq/p7YZMRyxJjbN5zPj/UcfOZi+hZXMzuEqxw7sLV2qe29J+VdXbME7Dhkh0UZNOJ3sdZM1rvvU39hXrW4elCw1achOC6wrIWXhfNsxh03Ulxd4ftSZ+FXC+/9vp8ql2aZZxnJtSLVmQw3aOr61Qm3A9XCuiZQT1Aj2885296jGivPNt+nweGE9kk6mM5rmsCySXo+2XvWMix1BQy7d3+78SodDkZpJZFDOA+7Clxw4rv5QUh9QpAfzlbSrnF/hXfqR/bO8mI1+ry6pHJuts5zVVCHBhk5aXedoLwuN58RI8dcvnrRQGkjbl5obwB7lzntuUyRjZlLQwiBebZiKCYx9dsIqZLMIddw/Z7rJnxRt0Kj2XYiVC3lNcmlV5tlX/ATTtsSqRXdx/seYH6bAXb6Fhdy0U18AWbTirLbYJPM/biug0UnMWEf+AQrYXSryLevynubKJEKob8jk4hhsHWZYDXHO+OtrmnrBdHc4DFzNepb5UhapJB+FmG8fHucpa68AKPz64i50hNQKuVD53iwjryCl26I3JcexYgSCEZZL6DJufajZz53Os3S7xdl1ft+pmPDbjXpEBT9H4qdK3CYKugp8hMXZbr7kTz3WN8r+ToX1NMHKtySr44CSwnygrARP3XTA1WbTL2W7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(36756003)(5660300002)(31686004)(8936002)(8676002)(316002)(4326008)(186003)(6666004)(31696002)(508600001)(66946007)(9686003)(38100700002)(7416002)(956004)(2616005)(86362001)(53546011)(6486002)(6506007)(66476007)(66556008)(6512007)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUtxL2IwcmVTbE1LWE5lMnBZbnhaY1VtaThhUXd5ZUpUR2JKVEJuSFQvbmxG?=
 =?utf-8?B?RCtjRU5mUDN5N3k4WlJFL29YWHhNL3pmcDZHUTNFbEE1MDFPeVhBb1NlSXl2?=
 =?utf-8?B?SDhSQklkOFBpWjdBMGNvZm1wcWF1ZUlHTEdjNlhZQVRoblJPYXlodXQxSHNQ?=
 =?utf-8?B?a2JBSW4vOWpISTU3ZndrVnZiU00yZFhBaWF1MlV1Ti8xSFpDRk9YV1c5OFk4?=
 =?utf-8?B?eWVBdFhEY0xVYmhsai9XVUtVc0FrazBjd1VvbmtGdkY3SnNjVjJSU285SmJR?=
 =?utf-8?B?cU90Wndvb2ZtMmVGK0VQSHlLcG5LRHZwRXdlcDVHZ2lMK3ExWWlFQnJEOGk2?=
 =?utf-8?B?d3lEYmR0alJxNVM0Wmx5VXBoT3QvMjlqbU5iMTZZTFZTMnFGSDNrTVd3SjNZ?=
 =?utf-8?B?bDhPTUlocERLVHhpdll2TEpNMU1ETFgvSkthOEFZMXZHanpQVDdVNmNjMnZ3?=
 =?utf-8?B?MmgrNVhjWWdFVFNuazh2UzVyUVY1ZFBONGdsZHRsWjZ5MjhQWitoenNwbnJO?=
 =?utf-8?B?NTZvQjIxRnZSTGhJM2xnZG1jUmlrWDRzZkVaMGhycklkZmFMbWl3YXY3VG84?=
 =?utf-8?B?KytWdTYzM2RncmV2VmZMWi9CY3F5V1JtQUlvZFhHVUlRUWNSU2huR2RPYk1G?=
 =?utf-8?B?WUVHT0FOZ0VadFFob0lPcW83aENRM1lzU0kyL1ByRzdHWTVzZWdWak9DNWkz?=
 =?utf-8?B?NkRNZmhoZEF5NXV2Y0VoaExpa2NmcXNYUE9aSHR6WGRWc2xLenNiMEwvbllI?=
 =?utf-8?B?ZEk2Wi83TG54RXRTcDFjUUthYWlsY0c3SC9KR1g5WnNNclV1bnVFZXpsU0Fy?=
 =?utf-8?B?RE5aRm9XclcvTDVPWC9rTnpidVgzZktuSHVyOVY1SHhwN1krV2FIRGRkZUpP?=
 =?utf-8?B?bVFsdXN2QTVhcCt1cjd2OGRHdnlFYzBzbFgzVkYyZnBCN3B1d2pSQjM2MkZP?=
 =?utf-8?B?b2t3K3FGcFJseHVxR2twQ3JDa1lzaEgveVpsUk5KdGp5V2pWb1hGYVFTT1Ft?=
 =?utf-8?B?UVJzTU9WWkZEbkxlOU5IV2E2RjZhaHU3R0VTeXJLTE1JSC9hSWNLaVQ5eGZj?=
 =?utf-8?B?TVJ4bm53TTlLTXJiMVN2T1Q0TVRaR3dvZFpOaS9RN1FGUTlQN00xK3ltYWRG?=
 =?utf-8?B?UUp5V3FrbmY2YzM3Q1RyeUdaZmFIejAyYXg1NEJpQmNvaEJYRU9Vc090UURs?=
 =?utf-8?B?MG41dVRXcG54aUdXZFBsRjlRODJUZVQ1Y24xRkY0ZzhtMmVOMmRRZno1MUtU?=
 =?utf-8?B?bWxhemI4S1dhUHgwSy9lM3RiMU1BdEFQOWNDZnVnYm9ZVG9ET1A5ZUFaZFFU?=
 =?utf-8?B?cHUxemVCZTNGUU1XQVZ0dXZnQ2FNdXRWejVRbXdRSU5QdDZWQkpzcldCclBs?=
 =?utf-8?B?K29TU3dJYXhKZHdENnl4aU5xMjhKY2tQQzdicFJTaTRTa21FcHd1amNoRWhF?=
 =?utf-8?B?VDRWRStaYnlxYWowNGxjQXNSMXU5ZU1ON3VZU2pLU1k0RXY1YWRtNGRZVG9V?=
 =?utf-8?B?Zkd6NmRqWUZXK0JyVFR4bm9kMThvZ1ZDKzhtV2N1VjAvbWUvMGtWalhaMURl?=
 =?utf-8?B?ampheW4zV2o1aVVaM3Z0T3VkdGU2UWFPRDcwMDh3SEpoY3dFUU8zaWNXNW5Q?=
 =?utf-8?B?elp6S3NnUm9zTHZ5bXl1Z3BoNnVqZ1pCZ1o3eVZ2ZzFmRHNwQUMvYXJKUGh0?=
 =?utf-8?B?OEl6UlRpRTE3cmpZcUVKUG1iaXF3UEVBOG5GbTlmMlFld1duZU94Nzk2VUlT?=
 =?utf-8?Q?0K84HeXlm/vgBJ30J666tlC6ZUbEWgXrUNqSW43?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ea8c97-5435-4cc1-1fbd-08d9843f9a2a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:24:55.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQADPfOX8otsHxK1pCC4EK+C5H3D4rXT8s+Sy5T+c7l1BH1SyEv/cW5HHYeSkw5sE6G6OIbSYRsm1IdM8T5e6uHfai0vqNmfdDg5Od3rDBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4465
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: VVJWlmISGetU5swOMi1irRUaOASpApZO
X-Proofpoint-ORIG-GUID: VVJWlmISGetU5swOMi1irRUaOASpApZO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Mike McGowen <Mike.McGowen@microchip.com>
> 
> Added PCI ID information for the
> Adaptec SmartRAID 3252-8i controller:
>      9005 / 028F / 9005 / 14A2
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 8be116992cb0..ffa217874352 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9287,6 +9287,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_VENDOR_ID_ADAPTEC2, 0x14a1)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       PCI_VENDOR_ID_ADAPTEC2, 0x14a2)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_VENDOR_ID_ADAPTEC2, 0x14b0)
> 

