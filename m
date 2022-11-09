Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBC0C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 19:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiKIT07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiKIT05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 14:26:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86E426108
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 11:26:55 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9JI22v026946;
        Wed, 9 Nov 2022 19:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GGJiw9OvZlp4yN/X5bUoAF8LbKsRUWFbKR0l+aHyFKY=;
 b=qdklEOlqBlM/cJbx8VvVv9auPE5Sba376oRSABMWy7Wa2aVrw2/QtQ9B0pm/lTCZz0Pv
 cMEPs924kG4xaiglwg0jXgN99TW6D/8RsAr+hOUm6xDHCvve/IdOh3GSynCDUFFE1Oml
 ZDvLdEC5KK3/b2JqDZi7uBzVY0dilHi7h2NUio9kAnACD1YNcPXSwOGWF15hNrTrFDGL
 SXvpSDN1LHA4HOz3owosaIPJaWutX15AN5cnCo16GLr7zJhfEFl8KyopFwftfHz8XepA
 0patVJnbL55Jv0xE8b66MegIrxkSGJ1vx5TfuKhv99pArMNEOwBbAGC1TnLS27xb2viI +w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krhf9044d-70
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 19:26:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9HWXbF019007;
        Wed, 9 Nov 2022 18:51:26 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctna4e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 18:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUPBA4KQgVMexx3yt7EdGVqAqCT4qOpkHxUzaBbMOBjjNSFTveV4DXF5FEil5Dp78B/0C1pST5gx/o9uxarXpsMI2N371H6GF2KvCZA9BksqVzY6Zpvq7clZPfFu/24S/QUTtzncXFfmAT9jceXpO4yP0bSkip40BtykhogBYROBgP1B756akixYNjytTpW6bfGqa/v2O8sAu9pV0UFx1h90T8TTnG115tgvb9HcHJ1A4gJgxW5eTJLkDyDtfzlFpABJ4tEB1dvkVOC/q4xjHrbvVLYjE/lwBsEGZo3Z5Znu2xNj6FhLTwdweQjUbKaQ10FAn1R7n8/jX3hSs8ZZ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGJiw9OvZlp4yN/X5bUoAF8LbKsRUWFbKR0l+aHyFKY=;
 b=TPYSV/9oH5ff3IWEMxuPGKxTuaRRR5e+KW1UMSP1mXzmpueW7XdYHulfBi318L7/MGIjAjmfX4uZ69S51hr/YsHaZgD5XCtNQ0trv9Kr/bXehU4VyX5icDJDNsdbHJQIFatPafRNMgDVo1TgDAyenCSnxVbtpabA1ZQ+zc6Ssmr8KNHOR4iYMzSjmI/8HlqeoSH75mt8tA9vRHikjncSmKMHu+Od9czQ49kC9Aq4ng17IIk6jJoq38J5ShvbZ/E+gDhLWn5jAEu5tj74Eg1DWqwhfXxnMx4rs3e8yr5bL14nCu9y2EKx6degxRKDJvLdFVf6hsiYCzZbVmlAEmBEiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGJiw9OvZlp4yN/X5bUoAF8LbKsRUWFbKR0l+aHyFKY=;
 b=Yx1YQesAx5weCLu1u4aGo4qUlRjtBUGlozve82prMSKvVZFlmTtVDs48wxMx3tkHAiuaAXNPoxtX68yHVy5rHuD6w+8qpaZdtoHUCkdGumIgOvvbWdJNNB8mLyxrbW4/w10cE0cDzL43T6Ba+M760aaFA+B/cwTy61xtFW69yeQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5206.namprd10.prod.outlook.com (2603:10b6:408:127::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 18:51:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:51:18 +0000
Message-ID: <41b1cacb-94cc-ad69-11a7-b13452080389@oracle.com>
Date:   Wed, 9 Nov 2022 12:51:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] scsi: iscsi: fix possible memory leak when
 transport_register_device() fails
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
References: <20221109092421.3111613-1-yangyingliang@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221109092421.3111613-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:610:11a::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5206:EE_
X-MS-Office365-Filtering-Correlation-Id: 701d8fbd-5cff-4b27-3e8e-08dac283630f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Tk8voPMrNMV7Jf7lb3xkBKgkEv0+0oEqVxoWMaRuR21HUQ9oSdCPG9MBGEIOkjlPl/2CtELw/u9JieD7ycMGNYeXErAb/rkXJaY4uRCMeyFgz2PFDCyKzqm+J/dHaOAkAG/SnXJBvPuyIbYVH1HyPLc+inC8wx/6lXWnnolQN2WybSCRyQoLs5Tx4qo+oeFd4mikk8T8heaFV55q3IrnmrvC5aG1Nm64fri1AAW2fRgxoOeZSRGytcVu34VWvXrtQyl1UiOURkcgEVX4Ngzz3XuPcQI18mfMwWfHtCOQayWwMEZkp8MgLUvtT3rcslqTPDkscQmnoUYN5P/jguo9r6ERuOOskWBwsmiYLrNLlJk54ZaWDSGj49fMVOYI547y/EIdX1OBMYpZuJ3aVlBfooebxVSCQKgR42kvhvE+7fPvLrsFR14Jw6eH6CT2zKH4mvati4En8496aFUIg1grAUWenqmMBwr9X/thJngDmPPF2O5AHgw0pi1egHGC8/AYAjSVn3YLZJ9HnlIUeySf4oTqpfORLdev+XKak6XWbysr5O0HMRzMv86Fnupj8sI9YlSXwzBVkxuy+KDX053JsBG+pFA47tnGJ2HnMQbRy0UzVs6gpVXnxNf0fWU4hQ0pRJG+UxUeDYDnLBjOGSr0oxXOMP3Q91216iXEXe0LjJ48jjv6kpoSknjQWSepwzWokt67Ii2nCr3iIbHDnEm+2aI0UCijcVbGX+tqAgC4lnPP106l4qmgLQHLPf0owwpplsC+L6B64Xyv+2jiBhSieI8jo0TJqZHuglAI6bSon0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199015)(31696002)(36756003)(86362001)(4326008)(2906002)(186003)(5660300002)(2616005)(83380400001)(53546011)(26005)(6506007)(38100700002)(66476007)(66946007)(316002)(66556008)(6486002)(31686004)(6512007)(8936002)(41300700001)(478600001)(8676002)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVFuRnUyLyt3UDNVZXZwSFZzMDhUcWtsS0lTN1doOE9TRmRVMmJqUVd4Wkxj?=
 =?utf-8?B?aENoTUkzcWZqYkFkbE5XeHo4QlZEWERrQUl4dS9kZjZCSjJUK3BXaGl4bTNQ?=
 =?utf-8?B?QmpHb1ZBQUZ1RjVzSFdmb1NYNWVKdktwbHJTZXhPcFhEd2p6Tm5DSEFiRFJD?=
 =?utf-8?B?dUdRckZUTmxsY1Vyc09aMmhpRU1aK1FkbEdxMzVXQzJReHhVMWdsZWE3aUNi?=
 =?utf-8?B?ZGtjK0lnaHFPUU9SN0RucjBLWmtrRjNiOWE5c1RCQmFWZmxyTnFDVE1iU0Nh?=
 =?utf-8?B?SWFURXpCbmFrOHNudktnTStocDdGUDhNSDBHTjYyNEpTSnJuL3l0ek82WFdX?=
 =?utf-8?B?THhBVnFSMlJpOUJxdHAzTkVFbDVIUFVFbW02MHhRQTU5TndVRFU1Q2Q2b1dm?=
 =?utf-8?B?dTZ6MDV2bEtDU2MzN3U3V1NDblkwRmVmcndRdTl1eHUyS1hyQ0g0eHY3VE5n?=
 =?utf-8?B?OGI2MnNybVBXbXNQWUFTMlQrdHVsOGJrNVFwd3NITmtjVGlpMm5ERzBzYmQv?=
 =?utf-8?B?aXNocFFFaTF0d1V0K3c1YUwrRFdIZ2lNbGFQU0ZRdDdRTjBWS0FpNm5FelZn?=
 =?utf-8?B?eTRweGpkckpmTFU4Z1BMZUxraVQxNEExWk8rczcxdWVLSTRhck94NDB6SzEx?=
 =?utf-8?B?U2tjY1kzUTQwb2RVTGV5VWZIMmd0WVE4V3diNkRNVngyQVVNZHZYWGtEQ1BG?=
 =?utf-8?B?MmdqWmtLdWlySFFxbkxxaHUzWlFmd0FWWVVWdWtYNlQ4WjduMllJckVFblJS?=
 =?utf-8?B?MHB3WHBVS0F4TlZwMmR1VGs3N1JXSzBvdHRoeURyc0o3RTJvYXV5QlJNTWsv?=
 =?utf-8?B?NlBTRFo3SnRDemMvQ1Y3TDRqVW84OGx2UlpzUlljQ0E5SytwYkJGdWkrcGNt?=
 =?utf-8?B?T2YzVUZGZlZaNExqcjlQWnp1Wldja0kwSXJGWHcyZmRWZFBRc1ZVTkVPbWdm?=
 =?utf-8?B?dHVyR210S0xzb2pqVXlrc2wydUx4TW1xTVlmWGZ6YlBLMlFVL0U3dFNSaFZE?=
 =?utf-8?B?MVZlWUpGbnJhWFZHWlVpS3AzVW52SUVxdVkxQjgvaWduMDYzSnRLc1NJSW9N?=
 =?utf-8?B?L3BMZG5uSmRIOGVOczNPRVM3ZTNHcmJpa1NjUzVwMEJJeFlReGFZQkViSFlm?=
 =?utf-8?B?OThNczJjTEIvSG1iZGhOaSs1bjdVbmlqUHM4enRDNWkyTDRMQzJFdnFYZENM?=
 =?utf-8?B?eEZaakdLMmtVTm1WYTVDaDM1V0Rvbm1WUkx1MU9ta1oyRlp1eEdwMG5QVTk4?=
 =?utf-8?B?NVRCU3I1M3lHMlJXYjhLQjE0UVdScEx1a2xna1p6L1o2d1ZTelpoMFFqQnZI?=
 =?utf-8?B?OEt1bzlIWFRZYUM4N2xzcG5YNmpIeDYxKzhscERhYnhyTjRhNFV0aTBndFcw?=
 =?utf-8?B?UmFqWC9icVM4eS9qNDZocFcrQTcreUIvd0E0QkYyNjhnOU9zbGJyQ2VTSkky?=
 =?utf-8?B?S1pLUHY1cHNoZUY0TnZaR2dkVFl6OGxScTRpSk9ab2Q5RkxNRzNSbk1UWlNt?=
 =?utf-8?B?ck00eHRaY01SYmdhaFByQ2RBZWpmOWsxanJsdDUxT0g0am0yQUI0dmEyclpL?=
 =?utf-8?B?R0FYTjJ0VHN5bXEzc1NkeEh1NDhRRFFuV0RWejFaMlB6Y2lmQ1IzNXpZWVRD?=
 =?utf-8?B?ZnRWTDEvQ0xzclREU3VlTFlrODF2TTNtV3hVbyt5ZTdIV2F2dlFNUng1MmZh?=
 =?utf-8?B?djNFRGdKbmtJWjlkZXRFZWM1a29oYXNpWTV3WWRUTDh5Tlg4NnhKc29Jdndr?=
 =?utf-8?B?NmRvTGlZcTcxSnBHNWZGNWZBTlpZaTJMY3FnNVp2aUtTajNaTkVPL3hmNHg2?=
 =?utf-8?B?bXllSFNDaWNUbDhaWVV6TmtQcDJhbzVNblV4L1U4b2hwM2oxN08yRUw5ZVJR?=
 =?utf-8?B?ZDVxcWROdUw4RU1JcHY5MG1BaXRNaEpNOFNvcjlJR0k0blJtUGNZSGNrampy?=
 =?utf-8?B?YmFtSXFrSEFNaUNsS2VqSnpxTzVuSWhidjJMTDFmS3hLdStlUmlFdzFma3ZV?=
 =?utf-8?B?akF4YndPc3ZUY204U1hHN3lDeTJqSTFsbGVEUzdGanh3eS9yMnRKbXErOXdQ?=
 =?utf-8?B?eWNjYWhRUEtsWnN4N2w0L2tlRituc0pGSTFUK1ppMnMwZWV5UzVIaDFSWHN1?=
 =?utf-8?B?bFdwQWFZNmc1ZklvMXNweksrQzJZQTdhRFpQang4dG90V0UzMEJCU3JOL2RQ?=
 =?utf-8?B?ZWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701d8fbd-5cff-4b27-3e8e-08dac283630f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:51:18.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jPvp3Lu3y+PHxnpUQQ1/C/g4zmjgwnkEdo4fpCag8BNzFj/BVgk0+K4QvrTHyu0mVb7UH8lrybmZ7MRyA/1mcFEw8jIkncvn0DUxJl2/kI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090142
X-Proofpoint-ORIG-GUID: DmeByGxIB68nPma9Cnmhx1fKUygTD4Lf
X-Proofpoint-GUID: DmeByGxIB68nPma9Cnmhx1fKUygTD4Lf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 3:24 AM, Yang Yingliang wrote:
> If transport_register_device() fails, transport_destroy_device() should
> be called to release the memory allocated in transport_setup_device().
> 
> Fixes: 0896b7523026 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Transport class update for iSCSI")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index cd3db9684e52..88add31a56e3 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2085,6 +2085,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  	return 0;
>  
>  release_dev:
> +	transport_destroy_device(&session->dev);
>  	device_del(&session->dev);
>  release_ida:
>  	if (session->ida_used)
> @@ -2462,6 +2463,7 @@ int iscsi_add_conn(struct iscsi_cls_conn *conn)
>  	if (err) {
>  		iscsi_cls_session_printk(KERN_ERR, session,
>  					 "could not register transport's dev\n");
> +		transport_destroy_device(&conn->dev);
>  		device_del(&conn->dev);
>  		return err;

Why doesn't transport_register_device undo what it did and call
transport_destroy_device? The callers like iscsi don't know what
was done, so it seems odd to call transport_destroy_device when
we got a failure.


