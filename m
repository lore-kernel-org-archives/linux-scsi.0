Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28E6C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiBVU6F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 15:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiBVU6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 15:58:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E747B3E53;
        Tue, 22 Feb 2022 12:57:37 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MJO1cf000633;
        Tue, 22 Feb 2022 20:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cb1XDgrtplQIBVzrhDwB8sDbK+3MWUQGPbKheuqoDOE=;
 b=xfyroqmigRnH6WBYMlRjsZJ5oJVQwalmDSvcOVPXnukijZ9a2gQkOUmmCCRPynbRrjBt
 z4lMu9f95Ws3Q+b82ilYAAodJgfPqhS/BlwhkZkDY4f/knCjSSzE+3mM2aVDt8F8kGnw
 PYcPiNSM8wimpvXSD6wH76zkQryaQ/MW87+qM6J4GTxGcE/SNnAk37w4H3Jht9AxTmPG
 sTaYomP58vXOhBtxOzXoPNMxlW4isvouT+H9XTEh6uKqTHCObm6ZSBit+6rk6nFjvS4s
 as4XLc+PXTMPkqB0eOGTIjOffk7g+7dD76sTgR5YfPqgPyHPohlWhu0vGN0nhh6w5On9 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfasnf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 20:57:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MKuTWG004589;
        Tue, 22 Feb 2022 20:57:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 3eb481jgw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 20:57:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3bSc7l88eP0KYWQtlR5fMBqPy8OK8uguNUVpYgDZttHqo2SGbKrRZ76Rgqebq+ZfARR0YffgqYwTOC3nraTduTP9PnFksisq2+nDayL2ZmBBXHQFV3spIwPAxGkp68dLtdtayo3knSJHpwNbh2jqlIMCp0bTDglnnbN/44qY7J14Dq229/CFKrvvcyEiLXehsKZ6sgTpBrEFu/cdZp7UmWKsx/QhNHoRVNF2L+6ftT4POYSRAkEmrZLuQWDy3ENyNAFPKxBBEEepqbad6Vk3S2xuve3ERZMgqPJsP/jYrC26BSUqRNt1xUVA4LPAhQ8/aNhWDtiXbHivCwfISmpkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cb1XDgrtplQIBVzrhDwB8sDbK+3MWUQGPbKheuqoDOE=;
 b=WwfL6YW5oXRXt87/kQjAkeQP81awo7LkKPrXGQ4Jb6AsXHYuPAefWiq8A/n5+HmY/Pf0KikOStnsvyqekJypTTUsUAHjgqfREbM05bO9pR8DpwzIb5vMJT/yKEx7x0tLIvJu37hqwkFP+Gm7u7Ssx6Bi0hu3Zl5KG89LksE7ZOpLXkOW723dFNCq6f7md9aL/0PAEiynsHBUvp7kaXyLAlYuGi39Erq/iVqCew+53YGhnTcH2B61esF3zehBgvkYXDtDMlrcZV8nNX47R2uIFTeIvBqZsrb3CUx5FKz5Azn4TituQmCTfi1qj7vAdRhGNP37QprIunRHSS1ped5ZmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cb1XDgrtplQIBVzrhDwB8sDbK+3MWUQGPbKheuqoDOE=;
 b=zjL0ciXNX3atJdL5Ct9bG1TpdhrIzpx4m5IMxEXNB9XZjhHA2TV/MW8bz65p9G4k72wDEixo9pTU/A83IyU4WYmzWh2PLeLgKzgW9nThr7a3nA/TeV5TxM582dTjhDzxMGEkMbIlkoe1GmhI0RAKUm80AKgv+0x2Iy5FHTwgSvM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3836.namprd10.prod.outlook.com (2603:10b6:5:1d3::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Tue, 22 Feb 2022 20:57:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 20:57:31 +0000
Message-ID: <e77b17da-f3cd-3a89-c46b-67dadae359ed@oracle.com>
Date:   Tue, 22 Feb 2022 14:57:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] target: allow changing dbroot if there are no registered
 devices
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220107151054.29734-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220107151054.29734-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:5:40::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e04620d-d5fb-4299-4cb2-08d9f645f1a5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3836:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB38365D9D47DEF5515E2E5003F13B9@DM6PR10MB3836.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4gmsnBygyreCSdlBy3e6VFXCMja0W0ggQ/njJPOs8uqUXWRuuMh+yCnxKIj5uI6V22VxVfDBS/dStYjFzyU2u/u+dg8FqUMm5ipm+Zmf7tnnzcks4yLpG5b+23cYdfisk7mnnoQLbTB86FG8i27uRx5k3nEYaY1QTztlb7ooz/MfkI9DJ+0IXCyj/54O+LsYqNd/lpI2yBoctt5RP6zh5QViWkOrEIgggX9lgaiA8RUL/z8JJYOQsntJ81MQu3JTPfg3qRerc9uQ3Ba4GmJaZpsO0VGRQSRe6hlzwGUQ82yjFZzKOchlnArflxsSKZfum+wWNu76JWawpJav5Ns6RO0Jsz1PMnJamvD8kytz/BZRZk5snxGcZFMBD4PvvL7ljgTUO7ZFOgcFZfHJ38UrVeMiwJK93sCqPslty+YgXQb714/a+ju6gjLgRnRCZK5nfpY+9aXjgz+XqoZfFRTszaIoS+jACUQRlSttNX3ObZ1tw6vgNMa+K9KPGMnLJ0AyIkHPp/BWqEXmGuNuWlP20UPER/NkcAa0UBKLi+oUb+i7EMT2xasSFdbWc+Yylff1u13Xxs8an9zz2hWTKc42/QTiAwp/xWe4eJTY+hH+wvJtg8jQugbFAzE3kfvW+zSrdHLUWgMZNXwE2FZRWkyQWREk6HNHA7UlsYtusDI/mH3FAs8K0hPYj/vNJhh8b3iU0N8K2VyM56dAlthaYNKxBJDz2Xv1gwGfLudfXEGnbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(2616005)(6486002)(6512007)(53546011)(508600001)(31686004)(2906002)(38100700002)(186003)(6636002)(5660300002)(4326008)(66556008)(66476007)(26005)(8936002)(8676002)(316002)(31696002)(86362001)(83380400001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnFheUpyLzA4T0NqRFVxMmR5b1FsZG5FOUorOVg0RjF0cmtKM1J4SkhuRjFI?=
 =?utf-8?B?NlI0MHY1czdRMERsblV2cjhRbG9adCtnVlVGV2ZlbUt2TkEyRFdkSEpQS1lM?=
 =?utf-8?B?amZkU0xXVUlZV1pCSi92MlJnYVRPejhLY2JoUFpvR09TMDQ0UFFTWjZ3cklJ?=
 =?utf-8?B?WEVHQUNtQWtTWHdRM3ljWnZRQ2ZRSFBzNnIzM2JScVZnUGV1UFdNWExGWkF6?=
 =?utf-8?B?LzQ2ejF6eW5HYVUvMzZHeVJNWi90bG0xNFRaRXgzN2F4cFV5Y2IrcFllbkts?=
 =?utf-8?B?bElNNWt6aXhoRDg3ZG0rbXNRWGRHVjhqYXRmanA3R21nVmVvcG1KUlVnYktz?=
 =?utf-8?B?NjFxUjQyL29sME9UOVJEYUFCcFFJNjlVWk5QUUdRcGlKMlBPQlRPeVZoeHJt?=
 =?utf-8?B?SUN1blIySUlLbFcySGo3WksxbUtOTHl5dlMvelZybVIyalpleEx0QnptZVNw?=
 =?utf-8?B?dG8yTjltUjQ5Unl2RThoekUwWUdhRE5aOVc4N0dKdTZnQXowa1JvMkxQNGJR?=
 =?utf-8?B?ZXpXaU1ZOWhucjVuU0d4MUREcGhzRXZ4QUs5UzYrQWJncEJzNEV2bkJWVlZV?=
 =?utf-8?B?WkRkN2VrZkdmbldsaUhyL3NVWUo2RFV3bG9GZlJkcUdZNTNzQ1lMcCtoemZJ?=
 =?utf-8?B?bFFSeXkvYlFnYmpQRHkra3pQdWl5dDU4NkxieHUwbGJ3V0xKanB5QmgrTE1R?=
 =?utf-8?B?dmxKOElvaWtVZFNGZVZaQmRKSkhlZ2FkeXp2WGl2Tm9jSG9kQlhVSVJsaHBr?=
 =?utf-8?B?OFBTY29XVkkxWlhwT1dNRVdzbksxYmFCamxTSVkyQThlTm9SR0QvekQwZWh3?=
 =?utf-8?B?akFnaVVXSE55c3oyRnNwQVNnVDNBR0VpMnlrcmhBNHRxbVFkTTBUbXA3V1Jp?=
 =?utf-8?B?aWJHM25waGltSFUwME5KVGcxUllETGd6Y3Z3Rys4cXE2am1oNW5tT1NianVT?=
 =?utf-8?B?UW1hbjNrdkMwWVJaVG9LTG5PcHROKzd2TWZxbnVFd2gzRWV0QVZzK2xheTFk?=
 =?utf-8?B?RTRDMlQyRVhLdFZWcTVCaGNGd0ZndVBLVlNoaTIvWnRIM1hwMG1RTmF5Q0NI?=
 =?utf-8?B?Sk9TMllZdnhCWk5SUUg2eWJWWTdjZTh5SzNNQ0svbkE3c3l3Qi9BdWkydVZF?=
 =?utf-8?B?UGp1V2R0bTFvVjJ1MU9MbEZ4bzNqNzdHTzJXbW5MVDVrRk03eGhFN1d6THFo?=
 =?utf-8?B?UVpNWUZQMDM0ZWR6UE05bkM2bVdtVEFiZzNkQXZyN1JXbHhsVGN1L1pPek5p?=
 =?utf-8?B?aEpqVU9YMkdyUDFkZ1l4dTE5RDNKcXBNL2d3bk0vazFyYk05YWdFSm5naWV5?=
 =?utf-8?B?WXdlbmI4R3QrOFJVeVd3TDcrZ2I1NnVUSUdlMEhCa2lwc0xlNmZyUTRBWXNu?=
 =?utf-8?B?TS9xSndBalp3NWlXdlh3UzQvT2VsU3VLNkpTc3dkTHF5Z0pZOUtSeS9DNVR4?=
 =?utf-8?B?dDlndnlWRnMvTDRNT3lXdGlET283cWdlZzNIcTczcEI2Y2ZOeVBpZ2d0L01s?=
 =?utf-8?B?NzJNN2loWGNLQ25mTHAxbHRPQXNlU2tRRjRlVUNzUklVMFgvWlF4THdWY2pM?=
 =?utf-8?B?T3kwcUsrVHFHMUt6VGhib2ZCU0xiL3JTVmxoZGpJRVhTdERtOTIzb2JnOHE2?=
 =?utf-8?B?UmZMeGpab28zbG44QlRHMVhpdDFwWlpHSVZ2V0ViSFA5VURNM09wU3hjbS9I?=
 =?utf-8?B?TnkwQnVBRmFBSkJiWmlteEFCSmZyaVhNdWZhd3J2OUVYY1ZQcTYvK1ZFV3hO?=
 =?utf-8?B?RkV3U2htOEw0cEQzVFBNS3JHd0pJdkRkUEpZMUQ0a2hSZjM4TjFNQURIZ0RD?=
 =?utf-8?B?R0diWkRMMUR1c0VHZ1A0RnJGSFpZdEo0TGlWM25NYWg3V1dUdEFPQ1hCQWFr?=
 =?utf-8?B?YTVsYU1Dc0VHNGdMWHJKa3EvL1Y2aE1GdW1xS1JQZ05IazJzVkhJaldJQmpx?=
 =?utf-8?B?SUQvU2lMV2Ezb1RzOGlSRlUzOUwrdzVvd2hXVHlKRHJoend0Y2ZGWHg1M1pn?=
 =?utf-8?B?QjcvZDJDYk81eG8xL0NWQXJVRUFKaHN6dWxOS0NHL2VIWGFPTThGTjdmd3pw?=
 =?utf-8?B?dlpDZExGa3Y1VUJOaEZhNlY1SUhQVTdka2wxN0lReTFGaE5qelc2Q2wxcU5S?=
 =?utf-8?B?TWxwc0dMVGhONlJicGxVd29ZMVJFSGF3ZmU1ejhxZnI3bkNLMStrVnBscUtw?=
 =?utf-8?B?ckdvcSs0YnR1YmhyMGVueTQyc0Z1Y003b3NFWnFyWkx2YmYrU1kvR0dPZUgz?=
 =?utf-8?B?TjYwNDlhZWs0allBVVhTSVRJT2hnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e04620d-d5fb-4299-4cb2-08d9f645f1a5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 20:57:31.8516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +78BIw092pcuwFEl2Y5LmCJOuYO1KNf+osEyR4IUWRVPXzTRTUdjvQaQUAxJFBRIC/Qcoz/YYNhrgvtm9LR3UXfo0w0X2hF5mFd2E3mKd68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3836
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220128
X-Proofpoint-GUID: bMb_7qYMSGGVW297GozlXUfyNCPI0s0o
X-Proofpoint-ORIG-GUID: bMb_7qYMSGGVW297GozlXUfyNCPI0s0o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/22 9:10 AM, Maurizio Lombardi wrote:
> The target driver prevents the users from changing
> the database root directory if a target module like ib_srpt has
> been registered, this makes it difficult for users to
> set their preferred database directory if the module
> gets loaded during the system boot.
> 
> Let the users modify dbroot if there are no registered devices
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_configfs.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 023bd4516a68..cba10829e62f 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -72,6 +72,8 @@ static struct config_group target_core_hbagroup;
>  static struct config_group alua_group;
>  static struct config_group alua_lu_gps_group;
>  
> +static unsigned int target_devices;
> +
>  static inline struct se_hba *
>  item_to_hba(struct config_item *item)
>  {
> @@ -106,38 +108,32 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  	ssize_t read_bytes;
>  	struct file *fp;
>  
> -	mutex_lock(&g_tf_lock);
> -	if (!list_empty(&g_tf_list)) {
> -		mutex_unlock(&g_tf_lock);
> -		pr_err("db_root: cannot be changed: target drivers registered");
> +	if (target_devices) {
> +		pr_err("db_root: cannot be changed because it's in use\n");
>  		return -EINVAL;
>  	}
>  

How does the locking work for this patch?

The configfs subsys mutex handles the make and drop callouts below.

For this part though, it didn't look like we are holding the same mutex,
so can target_devices increase after we've passed that check? If so, was
the idea that it's one of those things where if it races then it doesn't
really matter because it's rare and nothing is really hurt?

>  	if (count > (DB_ROOT_LEN - 1)) {
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: count %d exceeds DB_ROOT_LEN-1: %u\n",
>  		       (int)count, DB_ROOT_LEN - 1);
>  		return -EINVAL;
>  	}
>  
>  	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
> -	if (!read_bytes) {
> -		mutex_unlock(&g_tf_lock);
> +	if (!read_bytes)
>  		return -EINVAL;
> -	}
> +
>  	if (db_root_stage[read_bytes - 1] == '\n')
>  		db_root_stage[read_bytes - 1] = '\0';
>  
>  	/* validate new db root before accepting it */
>  	fp = filp_open(db_root_stage, O_RDONLY, 0);
>  	if (IS_ERR(fp)) {
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: cannot open: %s\n", db_root_stage);
>  		return -EINVAL;
>  	}
>  	if (!S_ISDIR(file_inode(fp)->i_mode)) {
>  		filp_close(fp, NULL);
> -		mutex_unlock(&g_tf_lock);
>  		pr_err("db_root: not a directory: %s\n", db_root_stage);
>  		return -EINVAL;
>  	}
> @@ -145,8 +141,6 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  
>  	strncpy(db_root, db_root_stage, read_bytes);
>  
> -	mutex_unlock(&g_tf_lock);
> -
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>  
>  	return read_bytes;
> @@ -3315,6 +3309,7 @@ static struct config_group *target_core_make_subdev(
>  	 */
>  	target_stat_setup_dev_default_groups(dev);
>  
> +	target_devices++;
>  	mutex_unlock(&hba->hba_access_mutex);
>  	return &dev->dev_group;
>  
> @@ -3353,6 +3348,7 @@ static void target_core_drop_subdev(
>  	 * se_dev is released from target_core_dev_item_ops->release()
>  	 */
>  	config_item_put(item);
> +	target_devices--;
>  	mutex_unlock(&hba->hba_access_mutex);
>  }
>  
