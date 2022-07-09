Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E09C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 15:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGIP6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jul 2022 11:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIP6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2022 11:58:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A311C06
        for <linux-scsi@vger.kernel.org>; Sat,  9 Jul 2022 08:58:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 269D4OCC027006;
        Sat, 9 Jul 2022 15:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ldjo5gODYq278C/BSAcgmrn+N0DWrHuBy0ebt2Ug/Jo=;
 b=KqGJH34rel2Rz7MEdFVz7pkDA44NgWSppHgsbQra+JLSOILyEcgtVgV0ELVJOheouOZi
 4LyB8CwIXxEfjwKix0JMxDUAhx7qo2DOLeoipW/Ui1UEohS9xP2ODCIZpgJs3gVUsg0o
 fZ0WYq4n86dGnx4u4aUtd5i9d8rElvk09+co/rOkX0A5oSfBP+TBYgXzAZfuamQDocuy
 7gePnFmA5cbH71yHWu7i1LKEzf3NJTuDIVVAhFg2O1EJYc/B7wBBlTPYG97JsCmdY6Ke
 m1bLjWbCMjSa6Yqr6bJD/v5puLNL9WOn0qAJCEl4HAJu8aTzqIH+SdBVyBFqSMCymdJg gA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727s8j30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jul 2022 15:57:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 269FpTpo001539;
        Sat, 9 Jul 2022 15:57:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7040fuqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jul 2022 15:57:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSsvOta40iBSTh+sRgSGAFfuLhRjbSdVkue4MTgvoUzD71Xbnn1jIIgWzco5nMEfRXo7zJsTq/MwlP4bLQyIhrbCn/0XtBZew9qiEcChGCVmVHsV0LrvorCFrX7hx/K9lk0krp9kTmQJbdjDg+1kXP6sLWnNXhS51X8v9g3xQs5deOV5vNOIL1ctUEbXwpUQitjnSB6Btzyf81yL6lHfrrIuTzpVuuCmtjBqrI3vLtYFK/C/Kbh9ljSrLRzBA2uWf6qDynQiq+6rbYg0EGA7U1erDsTlg1OYUr3WEb76o/8ytQGQObsd163OdKsywISfTvo009jCRzhF9fwrskXULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldjo5gODYq278C/BSAcgmrn+N0DWrHuBy0ebt2Ug/Jo=;
 b=VlYYSk6xsfWJ1fpVW9ZeW4iAcNK6lg/sb1tYnRQmy9y7spGv54QRDkp6vOOVY4PzL1pgXODRqJ+CpR3f88BdotHwf9CqYwrrBet6/QJlyOzDNnEgmR5o6EYb8cCLOYQz6ymUGAZHOx+/424Jb/LVL3flpRw9cUlCsjd0KhvaymcyMI8Yty06wB6MgmCmByqBrrX9s2QOVM5aYH2fvG6y0iae8MhhmwFGawDrvar/VDHuqNF8mr80lyNFTj7RjYd+eWUGIE548D4tBJgT2HMTeP0j+w9CiQue0EGPuXyHYTzVS71gRop2KMikkMLyM3je7jvSuyez02xQKVfhZeL8rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldjo5gODYq278C/BSAcgmrn+N0DWrHuBy0ebt2Ug/Jo=;
 b=xSczAPzA4jAPwAC7AlChbHIzx+lzMJMWzlUcKLawh98VtMwG78lOpNEpQR6W0KpDrgUYcu+7CVGaUuO5PM4/Wbz2MVYARWy6DgypqKoZlOKTBSAJyAbM/sPgf/ttlfR7uFBYz7VQGdW/w2TBha8G2HGr7UkBpIoVtyJgwSs69jo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4666.namprd10.prod.outlook.com (2603:10b6:806:112::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.23; Sat, 9 Jul 2022 15:57:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.023; Sat, 9 Jul 2022
 15:57:31 +0000
Message-ID: <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
Date:   Sat, 9 Jul 2022 10:57:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Subject: Re: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets
 and devices
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220707182122.3797-1-bvanassche@acm.org>
 <20220707182122.3797-2-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220707182122.3797-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0071.namprd14.prod.outlook.com
 (2603:10b6:5:18f::48) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3442c38-513e-4c60-0b80-08da61c3bb06
X-MS-TrafficTypeDiagnostic: SA2PR10MB4666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEWkJ1WKMni52AHmX+SFRhSRiEwJ0D9373INHljTEsO1ibISWYMrPpQqszKpyQqJrCcvkOwl6aUP//lLjQqqYfIZok5zzgxcSwfUBYBwAMz7IbdHEC+7MxkaQdHu0U/8wau8mYOV9Il/l2K/xyQiLLgCfCv5AdWnDwRKZhYQ8mqTJV9M4FN/VomrZ4cpJq5iblQJzolKDYw5CJBSLuTnh1moeJiy4xLmBcXDrVAu38qS9dgojuB4gm7oxlx/LT7b2uaOIL1VIEyaks+GqGOLsajDVDEdoYBbVqp0841CAPwvreOWir/UxV5BqNaeIbm/m503Ap0EJvdRHUdieY4fdbaF2X7DlKVUnqtE8SmzUc4TvrWLqwUtfdnAQJZKW9ZfmvChWVSj26kk+WFGU4uugUgXbg5kVqrTbYS0Wourw/Qx+pIlx8vlPUSKxtX9w5Vkt+bwPnd4mKuz1Z/tlLZvCSfQcMS/kEyYceLXXSW0zuwLsdSbUrbICiRMOGsAyvGLVi7rVOVsvsqVkesdWkGHOe4qCWlx1Vkp2P/yEHXXiaZCR1vuDgyJ1iUNXobG6cEV++8L0P/GuyWnAfPRBa+3WdxrvatFwLJis/VrN/2p+YfJmMd4jvZAqjmhc1whMt+/CmVoKIJf0+uG4e1dZ5Yvxo1R7i2WkV5eWX0Ecc12n/znrpHbYPa8YxeTOL6ijNlJQ7bwh+K6SfPSomu8yVNtg6fUho82DNv94FsxxbThjd4pSRwWsikTLxUcSnykHcbxsIFKCsuDiJQduK2CpM45RNU6BTbV4FrcVVD+rzSVxjzKyHWY1VU7CP/tGYfa8Vziz7MVVV7g1QFJFY8N6ynrvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(39860400002)(396003)(366004)(2616005)(6486002)(5660300002)(6512007)(8936002)(66476007)(110136005)(66556008)(66946007)(54906003)(8676002)(26005)(4326008)(6636002)(478600001)(38100700002)(83380400001)(41300700001)(31696002)(316002)(86362001)(6666004)(53546011)(6506007)(31686004)(36756003)(2906002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2Y3UXYxTzZGc1VsaEtCWjJreHgyRnhvbHo0dVlSZHhod3R4UUpCdC85cnNo?=
 =?utf-8?B?SFdRNThxZFk3d2ZYYkUyMTlKZkJGekxHeVFuMFFINVZOcG9UcE5Zd1VTc0tS?=
 =?utf-8?B?TDYvcmlTWHVKT1NWS25TaCs4YzJQa1FYWHdHbUpCK3JNTnJNMG5kVFR0N2Vt?=
 =?utf-8?B?SUY2c1h2bGhwWjFqY1RZZVExbWVBU1UyNVhGRTJmc0NuMWxEMnV2ZjREaHNk?=
 =?utf-8?B?dDBFTS9FVjQzNXlheFdka3RhNnlOMm9XWW9jR1B3Z2FFNjBLNzZpRnRLTHBH?=
 =?utf-8?B?TlRoZ0cxYitRaUZEWTNkV0FUemEzdVcwT3ZRM0tYYU1DVGlnUG0ySzBTV2t6?=
 =?utf-8?B?dUdZZjMwWXh0czZGbE1lNVZ3QzNPMnNnWFhndHF4cGZyOXRPcDZUUVlDM0JZ?=
 =?utf-8?B?N211bU1xYTI0dWwyd1RWZ0JPYVZ3SEJXeTBwSmFNb2JiVklSQThVcmFDSmdC?=
 =?utf-8?B?V2JvdlJpZXRMZEpVOU0vL2QyN04rcDBGOTMzS296U2hFVGcvVSswNnNqWEpJ?=
 =?utf-8?B?S3ZRL01QbXJ6emNQL2FGQ3Y0SjJoa2o3VDlZTnZVTHpXc0wzcWZ4ZlhvQVAv?=
 =?utf-8?B?cGg0T0V5TlhqUVpPWjdtUnNzY3FzUW4va2tKNW9kY3UxYzVCcGZZQ1NqNEhj?=
 =?utf-8?B?dlpJNGljZW1WS0FlRzBBaUk5a0JmTzk5eFhmZUEzM1g1R2w0OCtQR2hoZldh?=
 =?utf-8?B?d1VoeVFucWFBbDhlMzVuM2Rja005bnBvejZybFRTaTRuUEkyTkNySU5mek1q?=
 =?utf-8?B?bzBVMVdzT0dpLzVJR0o1YzZMLzhydXBuS1JPcitvT1pQa0tBOGpyVS9VYVhz?=
 =?utf-8?B?OXRNUi9MbjY2OTdrOTdaYnVKRDJ6U2F0VDhkVTE5V0lRWXdMUDBjb216Q1BQ?=
 =?utf-8?B?R28zVUxQUlVvSkkyRzN2Y0VEUC9VUXVoQXdqeUE4OXArazlNenA4QUVMb2ox?=
 =?utf-8?B?S0YzSVorWnZtQWVaSDhpWG1YTXJpMnVOVEhhOS9HcjlKOFdyUHk2b3JBUis1?=
 =?utf-8?B?RGxoK2FCNEZxbG9EY3JZaFp6bGdsOEF0c2JoM1ZqNkxmVVNiR1pNSXhGMFM5?=
 =?utf-8?B?bWR3QUhadVp0VDk3S2U0VjhHRlJrWGt5RnAzOTM1bkp1YjA5Q0RZZlFLUG5h?=
 =?utf-8?B?NFdHUGppeDBpdU96K0ZITFlTeGZHbkxZRkI0VFVlMm5QSThJYUkwQm1xcUtD?=
 =?utf-8?B?YnhJNXhCN0owaWtobDZTSlJ5ck9zNzMxSUxhS2JxazYvb04xZDVIemx6TzNs?=
 =?utf-8?B?Y1lldXFEUDBqWURUZEpZREErTEpzeFpnTHNycHV4eUR5alhrQXhCbnBESVN3?=
 =?utf-8?B?R0k1WXlTWnpiby9Ed2FUWmJhN1owMEY5MjNhOW1vQjRaZ3VrbnoxRHo4cUNF?=
 =?utf-8?B?a3JMT3BNZVNpWXg4TWsyL0dzSDY2V1NVOXhMMy9hQ1hMZTNxNUlkcmNUS1dT?=
 =?utf-8?B?MDJQZGlTUlB5dUlyZVRmR3NaLyt4TTJsNVdnbXEweU9HNDlWRUI1YzI1aGQ4?=
 =?utf-8?B?U0NDS2wvV1VzckxZZFFTdDFJeUdBUThWUkJweWNoL0pQTHlSbDF0NURtMDBt?=
 =?utf-8?B?eGM5LzFpSmZTTC9ZaTV1d2pTQTVUTjNjZG9SNzRkN01OZTlwbGpqOG11RmFD?=
 =?utf-8?B?dmc4ZGVVQ3EvZ2NJYm9yaGhUcUVoVWRibi9RSWZjZXp0TG1rR2E3QytuTW1i?=
 =?utf-8?B?L0N3cGVuZUlYQlBocGpVa0E5dEs4VFNjOGpzWGpuMGNxT24vM21Ebjlad3dE?=
 =?utf-8?B?TU1lUzdRMXR0aG42T2dXaStaS2h0TUtyRVd6VWx5YkhnTWIxRmV5Qk9rZlBy?=
 =?utf-8?B?RlQvcHRhRk12T0FGUXJCT0E4Q3JuRFBHaUpuZFJHb0N4aWh5ZVhnSGUvNkIr?=
 =?utf-8?B?QlFOWWZVQnJZK0VFNWlLbXRzWVhhdjY4RUo4V2d2WnBXS21XV21TNURPYmFE?=
 =?utf-8?B?OU5CalJrb0VncHNFVHViRmxSSWV0SUNGUSs2NG5ZV2xIVlJEOFVRUklrQy91?=
 =?utf-8?B?ay8rcDhVcGpsemZyUGNCc0UxRndsY094amFuNHhaeTVSZHRsQWh4bGU5a0tR?=
 =?utf-8?B?V2g2RVgvZ3pwOXdFdzB6VGNDajF4RmlNZlZkeXNoL0xaNDNHQlA1U0JzeUds?=
 =?utf-8?B?elp2Qk1tampzL1B1TXAyWElOMng5MXo0d21PQVhkV2VqQWtRM25FNlhpQlNZ?=
 =?utf-8?B?d1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3442c38-513e-4c60-0b80-08da61c3bb06
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 15:57:31.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4k2GV5Asr62iXe7OoLFdKe5tbvFOGZVBL/cxMIP1oY9VvV8HrOzXpgVPDL37I6nQtpNPlWbNQXeuUnTOTpIUBQvSwEqiWhaFWGyzTM010x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4666
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-09_14:2022-07-08,2022-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207090071
X-Proofpoint-ORIG-GUID: 1RGqjY8PvtCnPt_ngBN_LO9fqN_IwpP_
X-Proofpoint-GUID: 1RGqjY8PvtCnPt_ngBN_LO9fqN_IwpP_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/7/22 1:21 PM, Bart Van Assche wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> Fix the race conditions between SCSI LLD kernel module unloading and SCSI
> device and target removal by making sure that SCSI hosts are destroyed after
> all associated target and device objects have been freed.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> [ bvanassche: Reworked Ming's patch ]
> ---
>  drivers/scsi/hosts.c      | 9 +++++++++
>  drivers/scsi/scsi.c       | 9 ++++++---
>  drivers/scsi/scsi_scan.c  | 7 +++++++
>  drivers/scsi/scsi_sysfs.c | 9 ---------
>  include/scsi/scsi_host.h  | 3 +++
>  5 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ef6c0e37acce..e0a56a8f1f74 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -168,6 +168,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
>  
>  	mutex_lock(&shost->scan_mutex);
>  	spin_lock_irqsave(shost->host_lock, flags);
> +	/* Prevent that new SCSI targets or SCSI devices are added. */
>  	if (scsi_host_set_state(shost, SHOST_CANCEL))
>  		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
>  			spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -190,6 +191,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
>  	transport_unregister_device(&shost->shost_gendev);
>  	device_unregister(&shost->shost_dev);
>  	device_del(&shost->shost_gendev);
> +
> +	/*
> +	 * After scsi_remove_host() has returned the scsi LLD module can be
> +	 * unloaded and/or the host resources can be released. Hence wait until
> +	 * the dependent SCSI targets and devices are gone before returning.
> +	 */
> +	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);


Do we still have a possible use after free at the target removal level?

If you have a driver supports multiple targets and target removal (any of
he FC ones, HW iscsi, etc), then you can still hit:

1. thread1 does sysfs device delete. It's now waiting in blk_cleanup_queue
which is waiting on a cmd that has the SCSI error handler running on it or
for whatever reason.

2. thread2 decides to delete the target (dev loss tmo or user request). That
hits __scsi_remove_device for the device in #1 and sees it's in SDEV_DEL
state so it returns.

3. scsi_remove_target returns. The transport/driver then frees it's rport/session
for that target.

4. The thread1 in then makes progress in the EH callback and wants to reference
the rport/session struct we deleted in #3.

The drivers want to know that after scsi_remove_target has returned that nothing
is using devices under it similar to the scsi_remove_host case.

Every scsi_device has a scsi_target as a parent (scsi_device -> scsi_target) or
grandparent (scsi_device -> transport class struct like rport/session ->
scsi_target) now right. I was thinking maybe like 20 years ago when scsi_forget_host
was made we didn't?

If so, could we move what are doing in this patch down a level? Put the wait in
scsi_remove_target and wake in scsi_target_dev_release. Instead of a target_count
you have a scsi_target sdev_count.

scsi_forget_host would then need to loop over the targets and do
scsi_target_remove on them instead of doing it at the scsi_device level.

