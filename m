Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDA8C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 16:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbiCaQRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiCaQQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 12:16:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62341E8CEE;
        Thu, 31 Mar 2022 09:15:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VEnETb030446;
        Thu, 31 Mar 2022 16:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n3Sv1TuIQgqFwPzRoKyO4J3/sgrTpptwAdutfUP76DI=;
 b=BbjVnJj6SjlA4djJg9+5UhRsG7JRUR94wAE/wjnhDK1U/CqGbV3QYuR7sj6yULi6YdmB
 jbLrLZasBRzlH9Z2ME1ZKVII4rWqlLkdsUbgcNVVQpn4PkO96vxqoVjemlX3Z9OFK/EI
 kcCf8UrIlhRE37Kt3TA0YBSri3bt8uvD5BdcgLsF1eSgn+1/EDYuhEqU64Q+RYA+Onhd
 TaIXBjILfZksPHoJ9ccvSFfhzBbTYM3A9IJnpoEYd3FSZe3UzumJa4GcWmHe1VYtm/M0
 i6Sh1Y+y9ptbQRy6BM8FvEOJiYxF7FNDaArEd0b00kMglTO5em8O/trqnh5xFnCUu4gI XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0mup4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 16:15:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22VFuZjx003794;
        Thu, 31 Mar 2022 16:15:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s94tmy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 16:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEBhtMkCVUNwINbOylgGrg6NhR1WKo74Tf0LymgYpyUZ7NyhYcmFGle3v7RKhQ72LvAjTJVe/TarIds2ttfXydLqfHqXvJFOWJLEa8ZmaFf/jXQnHQNtGpmA926kGhL+i4pkYD2SC9FuMiUI3J832q0rRrF5hnB2YJtxKfYQ2zsvyx/GJKaecP2Hpm8k7/xtiAM7Te8eTpGGcpRiay4hFDZ2JQCmZMzo9eKh9RX5IDVoB89GWUQC9Olb1SoaYroRGqkDQqU+fZlHYv2zUjN3d9tNwz89hyuAOvKPfMHdbAugebpBFv/4iO3953D2CD16iq4nOC282plvOnZB7Oq2vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3Sv1TuIQgqFwPzRoKyO4J3/sgrTpptwAdutfUP76DI=;
 b=aLc5iPOq2Q6GDLuRjAMyL3Sslh65/jD55x47r08TfEbyZ0n6jumz0XfuiReraeGiiCHNqOQ9ZIePP1UUCx30eH1aJofkPdMBL3f2+K+5szahm9PXzKLz+qFjs2bXo+6kD/WvEqj+8VyGdxSn6fs+fkjxMvNqABz8FZOx07Initt1yIYqVgIuI2Kb7wPJp7OU6Mu8LH2iOxemiERv3dvr+PN3HsvA2ZFEni8POUcEKPf4EIsyrJAv0uklAbInx9bi5N5eMkrbOPTpAix9vVE52jCVjcabxYQj8lvzyVpKdqnEMFidU+Zh0tchhqdWflgp7qUcJp6K1PsqYr2bPcFCPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3Sv1TuIQgqFwPzRoKyO4J3/sgrTpptwAdutfUP76DI=;
 b=nlpwC5QkwVdHOjEhRetcPyYR+eMDYcuoXiqPhwx8P4/fKbJ1FirgJomB+/w08L+6AYbMzUtDcDnicKzO4p94yK1Orwcz6gcslHBlhUh8MPtHdJQz+OOIV+9E0KCnNlgSdqkx9huiBQXGkyaqE3hROMfFGspsWxUWjlfqL5tdS1M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR10MB1237.namprd10.prod.outlook.com (2603:10b6:910:6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Thu, 31 Mar 2022 16:15:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5123.023; Thu, 31 Mar
 2022 16:15:05 +0000
Message-ID: <0b1f8fd5-deb3-078f-97d5-18bf429578d2@oracle.com>
Date:   Thu, 31 Mar 2022 11:15:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V2] target: allow changing dbroot if there are no
 registered devices
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220328103940.19977-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220328103940.19977-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0112.namprd07.prod.outlook.com
 (2603:10b6:5:330::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e025f0a1-c273-4083-636c-08da13319e30
X-MS-TrafficTypeDiagnostic: CY4PR10MB1237:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1237A624789DCD7BB70272E8F1E19@CY4PR10MB1237.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rebvZxTKiVUMVMTGSxneiIYFs9LxiSPWQAC0/2SPvVNLvzXvuNxc0RM7N8yPRoQmrJEERNTafBMmZcoxarhpBFuDMTslnROSWnfQwd6PkoTFXmbXbyCej+HltSY8IWliO436B5mmQqkVQ2TT2kezW+DULXutsnr1YBCxiYmovEM4UeK64NFvL+yRNzyP7i1Iu+8pKcVGcWY4SCK1X25DbmAMGCm5JkDTQ4PZTNE/EZbEDTQdofW98LNDxNXDt6a+wlwN2fRSjPcSEs/ubmrXiZ1vLdRiCasHtj0gkjXlqGXiw37MejdPskJzJNCvYE1MxKgGD3ufC+aeUKOqctc6twlcFGcy4a3xjlxbEaAvqaFxOHsSLyBWGkL14BigQqGNWz7vi7JkjMiOFH5sEdxo3L4EAXir46V9Pm4niUnUQCLvVTfYP3OHS9ee5+c4rrtiPdJEYFocM3sbwR7l2As0R+PPnn/4ortce5l9/4FtwR3V9Klz1fnzliC0Zh32OWTMqutQmrTudkW7lS/XD88a90LFGZbODNsEiAxl7M1xOHKoM9vSlKF8WLURmjxltHFSKbe+qQXfmn6qgiw8LyNSqs/+sXRxXvcbQSUe1HlrprUsC5WVEochwqLRhWNiMW1jtMPJjAS+9A3u//0amZ66Pl4xPXyBj+Li3DGLUpIycSXp5zZ8cScOWRCp01InNDjEajL/kP1nMQH3oMI5aljE616g1DZtUzXJpntbS52I1y3DhGtyqNkxGwpFnZ8ZQrzI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(36756003)(5660300002)(508600001)(31686004)(53546011)(8936002)(6486002)(2616005)(2906002)(6636002)(66556008)(66476007)(38100700002)(4326008)(31696002)(8676002)(86362001)(26005)(186003)(316002)(83380400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0NGc2hIU2FJNTZ4SkY1WWh5YzNMUlh5d0FPd1dRWmc3QUNyOWpEVUtFUm1p?=
 =?utf-8?B?WVIzcllpamVRMFllSnhwazUrNUNUdDhMZmtrc04wdTd5TWdiK0VVMEJpdWNn?=
 =?utf-8?B?V2JpSHNGbTdjNHFPaDNFZnppWE55dUdTcjRRNjlCU1hSaWkzdnhtM1g3VFRu?=
 =?utf-8?B?b1ZjUG85OGk1SmRyWloyUmdYOTE3ZHVoMWhxQ0pGNWJudGdmeHdONGJuVHA1?=
 =?utf-8?B?SS8rWEJQRFlVQUxza1hRd0V6UVltbVRnRGtnRHVTRmd1YlhmYUI3Sm5yVDli?=
 =?utf-8?B?UW1WRzBlSzkxSXB5V3ZqSWs1RENQUDM5d2xFemhzeFo3ZXpSZElwc1VvSkN1?=
 =?utf-8?B?N2VST1gvWXNBZzNFVkRIV2dHY3lEb2NNcDJQOVVrRWprZmIyKytkMzVxOTBT?=
 =?utf-8?B?NkZ1cTVwUFR6Z3FQdkhIaXdWT1ZJZmYyempVd2ZCQVFnd0pYUy9qc3dBeXpZ?=
 =?utf-8?B?bWhQUzZrUzdyNXN4aHFPaGNVeDlTeHJWWjNCdVhzSTNoNzdpL1RxdUZwTHhn?=
 =?utf-8?B?b3JVcldEQWx0Q3F4Z0JtSGZCU0NGdk5GUTdEVXo5Y2Nrci9DZXRyQWIyZTZt?=
 =?utf-8?B?N3lYcU12bzQrZWgzWDgrUTQ3R2dYcnhBZ1ByZ2FjWkNiR0dNNXNSTUo2T2g3?=
 =?utf-8?B?QnJHVlN5TkVPeHZTV2Rya2JDeHd2YU9JcUdjaERkUTB5R25JWWNIRUNKYkl4?=
 =?utf-8?B?YUFad0JGQTVwNTRlRlNkdzRkTDRTbElkMklFYUJTRzUzaFJZM2wwZVBnTEdJ?=
 =?utf-8?B?NnhtU3NwMHVEak9NR0ZaQUtlZWJPSXNuSXFPWTRka3RJTjJtNVRKd0NKWlNG?=
 =?utf-8?B?VTg2NnZxbjhva2ZGenFmVXJXMkkzNUViOGRoRGRCYzdYQmh0RVBwSGlHTjE3?=
 =?utf-8?B?cURjb3dwNDNRZGpNcVZubWt2ZDlCVC9LcEh4UlFBY3VJN3JQdm85enQ3MmFr?=
 =?utf-8?B?dmg1NnBpMUJ5WXNJQlhZUEJFQVY2ZmJpVm14SERZMnh1OFV6ZUdkdjdvTDFG?=
 =?utf-8?B?SHlEYWF6a0g3b21IYXRYQ0hhdmtXL3laU2NTUC9FRmdaalh5MjA3OFBDbFF1?=
 =?utf-8?B?M09RMnllbTY0TnpQSURNRjlMSHliNEFhZGRNVTVPbDJtQVZ1Q1l3NisxaWsv?=
 =?utf-8?B?em5WWFlOQWZVV2ZwYXpsVzNrdTdhVGRnV0FvWDc1TXJicVkxUnBlY0grVU9M?=
 =?utf-8?B?L1B3cURCMm9tSUtUdWlLbDNuQkx1ZTFqbnBaOTNDRFViMm15OVhZY1NuY0Fj?=
 =?utf-8?B?MHRRaXMyT1R0QXpYRDVZRmlPeXhlZTFsZGhJN2J2QmxHTTMrSHFVSFFZWEVT?=
 =?utf-8?B?YmF5alhIMzhyOTZYNit5eFVWMkI4UUpmanp0SWg1SXZjTUl3NEFlZEZOR2JC?=
 =?utf-8?B?NVcvTWxXa2xvQXdZUjJsR2VjU3JMaHh2WHFSeVY0dzR6YTdpVUJWYXBNYkhD?=
 =?utf-8?B?NnlXcnNpYU5zTllVOHJOUFlrRU1MY0xCdm9QT2FBczVEdmtkdDhPenlsUEoy?=
 =?utf-8?B?R2xlQk45emVBamE5SVI4MVozN0VuWXdneXlpTGFGVWZwRlAwaVBaSHo1ZHgw?=
 =?utf-8?B?SVlJaHAydTJtcVgrYU5GOFpaSnlYdUN3WVJLSExSL2JzNjdxSnpmSDdpN0RS?=
 =?utf-8?B?UkoyVERDRFFjY3hnNE8vQkZCSTJsaEQ3MFBGbWF6YVJCbEl4RHF0MGFxKzNF?=
 =?utf-8?B?Uk1maEQ2azJNSzcrMHRoNFhReEdqV29NSHg4YmlGMUpZdm5MQTdQbDlsZERI?=
 =?utf-8?B?YitUWU00UHR6a0E5dE84aHY3QXBTUnlsbHZXUzRXeWcxRmFvOXVhUjFwbm1n?=
 =?utf-8?B?Sndod3lyR1hLRlkyWnM1aHc2RnRrcy9rUTdZeGxmM0tKbkEvckFEOVp2MUYw?=
 =?utf-8?B?dWQ0Mmx4RGhIbjRuNkNOaEZsdWJlRStlQ2hKWCt6T3laZW45dnJpVDhBdlVV?=
 =?utf-8?B?bi9zR1lDaUtDK2FhcWlTWTJ4UytxL0JURUxuR3pFWFQzTml0bEFpM0htOURO?=
 =?utf-8?B?NTlRVUlMRUZIVjlYbDVXVDRJLzE3YnBqR1ByNkFpOVlaR210YzF5TkdHeEFr?=
 =?utf-8?B?RFVVb0xQdTNVRy9aQTVxeGZGOGtJQW1iVkFtMkFQM1IzSDYwWEdKTFRDcWJW?=
 =?utf-8?B?YVB4dHl2NXNGN1NzS0dySzZyZ2pRUktwTmhIRnFyaUFKVERuL2dMcjNPdzh2?=
 =?utf-8?B?VFI3TGxVUVI0c3c0Nk5OZWx6TWwrcFFWUmNtRjNYbFFHdm9BWEtxNkVINHdB?=
 =?utf-8?B?QmlxZVdpb05neHd1bXlvcDZkbXhyRDZhcTE0Tm1uQm92eE93ZVk5RU5RaHMx?=
 =?utf-8?B?MSt2U0pHTWV6cDlPSWRnMG1uSW1GRnd1eWdtbU1rWitQSWx4SjVMd0ZsbG5H?=
 =?utf-8?Q?iF0vqPrlTXyjN2Kk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e025f0a1-c273-4083-636c-08da13319e30
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 16:15:05.6205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBMqd86be46Db5k71C5B02p8iw9rd1mgSSKZpsj2/1V2SVS2Z1sb1isOc/edVYcDl2m3Pbpcg108HDo7uPjT2DLeDx7U2rLVryl22wBeuCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1237
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-31_05:2022-03-30,2022-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310089
X-Proofpoint-ORIG-GUID: hrQm5Y-XAgH-_CvrEAsLN0WGGjdTH4lQ
X-Proofpoint-GUID: hrQm5Y-XAgH-_CvrEAsLN0WGGjdTH4lQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/28/22 5:39 AM, Maurizio Lombardi wrote:
> The target driver prevents the users from changing
> the database root directory if a target module like ib_srpt has
> been registered, this makes it difficult for users to
> set their preferred database directory if the module
> gets loaded during the system boot.
> 
> Let the users modify dbroot if there are no registered devices
> 
> v2: add a mutex to protect against possible race conditions
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_configfs.c | 47 ++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 023bd4516a68..fed1e7bdc013 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -72,6 +72,9 @@ static struct config_group target_core_hbagroup;
>  static struct config_group alua_group;
>  static struct config_group alua_lu_gps_group;
>  
> +static unsigned int target_devices;
> +static DEFINE_MUTEX(target_devices_lock);
> +
>  static inline struct se_hba *
>  item_to_hba(struct config_item *item)
>  {
> @@ -105,51 +108,48 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  {
>  	ssize_t read_bytes;
>  	struct file *fp;
> +	ssize_t r = -EINVAL;
>  
> -	mutex_lock(&g_tf_lock);
> -	if (!list_empty(&g_tf_list)) {
> -		mutex_unlock(&g_tf_lock);
> -		pr_err("db_root: cannot be changed: target drivers registered");
> -		return -EINVAL;
> +	mutex_lock(&target_devices_lock);
> +	if (target_devices) {
> +		pr_err("db_root: cannot be changed because it's in use\n");
> +		goto unlock;
>  	}
>  
>  	if (count > (DB_ROOT_LEN - 1)) {
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n",
>  		       (int)count, DB_ROOT_LEN - 1);
> -		return -EINVAL;
> +		goto unlock;
>  	}
>  
>  	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
> -	if (!read_bytes) {
> -		mutex_unlock(&g_tf_lock);
> -		return -EINVAL;
> -	}
> +	if (!read_bytes)
> +		goto unlock;
> +
>  	if (db_root_stage[read_bytes - 1] == '\n')
>  		db_root_stage[read_bytes - 1] = '\0';
>  
>  	/* validate new db root before accepting it */
>  	fp = filp_open(db_root_stage, O_RDONLY, 0);
>  	if (IS_ERR(fp)) {
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> -		return -EINVAL;
> +		goto unlock;
>  	}
>  	if (!S_ISDIR(file_inode(fp)->i_mode)) {
>  		filp_close(fp, NULL);
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: not a directory: %s\n", db_root_stage);
> -		return -EINVAL;
> +		goto unlock;
>  	}
>  	filp_close(fp, NULL);
>  
>  	strncpy(db_root, db_root_stage, read_bytes);
> -
> -	mutex_unlock(&g_tf_lock);
> -
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>  
> -	return read_bytes;
> +	r = read_bytes;
> +
> +unlock:
> +	mutex_unlock(&target_devices_lock);
> +	return r;
>  }
>  
>  CONFIGFS_ATTR(target_core_item_, dbroot);
> @@ -3315,6 +3315,10 @@ static struct config_group *target_core_make_subdev(
>  	 */
>  	target_stat_setup_dev_default_groups(dev);
>  
> +	mutex_lock(&target_devices_lock);
> +	target_devices++;
> +	mutex_unlock(&target_devices_lock);
> +
>  	mutex_unlock(&hba->hba_access_mutex);
>  	return &dev->dev_group;
>  
> @@ -3353,6 +3357,11 @@ static void target_core_drop_subdev(
>  	 * se_dev is released from target_core_dev_item_ops->release()
>  	 */
>  	config_item_put(item);
> +
> +	mutex_lock(&target_devices_lock);
> +	target_devices--;
> +	mutex_unlock(&target_devices_lock);
> +
>  	mutex_unlock(&hba->hba_access_mutex);
>  }
>  

Reviewed-by: Mike Christie <michael.christie@oracle.com>
