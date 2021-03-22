Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A93C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E4C619A0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVRHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:07:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhCVRGn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 13:06:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MH4dhx097341;
        Mon, 22 Mar 2021 17:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=A3IBI5jPa4CYz/Q+5uI2Tq3TrogpKbRQlJuTN8KKHt4=;
 b=VnWe4vfizoDyp0H27looDYBOWidtdIAyu9/AiMlVSTF2AtNO7ggqgmp63vSQB8d1SahH
 gl5pdzRube8D/4vqndo9GgUaFqmt4m9Z2wp1o9YF+QQK2NHHYEcz76msYyFEsIKBhn0+
 ceBVWhKda/S4hXEELqqTsVWASUd5yPQhEllfbqqtLDNeHRSGDuCREQZG+o79zi8mw/Dd
 hMoy9/MPaOvNKFMVtopnHj5MEMbYqznJBkDhajDFQqzMO83h8N31jxh1Kup3Gejhul+7
 u6w6buDK6KIORVKDnZxTyfPXPMmdi5LvTqCtr4bJjYBGsBvX2nFN5P7o1z9/0Qjn2nSC gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8fr4770-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:06:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MH65WX147189;
        Mon, 22 Mar 2021 17:06:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 37dttqucy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:06:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xk6GBR6V9Fnf4Lxm4YANY4K9ZmiBHfY3MePTVb6Y8GZhoGjC59egGQHfkhPJ4iOxqv1F8VN2qybHS1/G5NH5iK3bMDKfNdYxxAl0whcgYgVOS3Kl4xCqxA7T6G1T+s2ggz3oV8OJe92bNFLLDM1iWKg6Pi+SFQXsge11PRqzXwsgLH3+hjrPNfkDATWSSfDgOTnnSlzj2QGul12spLfJYAZXRcJCNhqOHPqN3XPxCmZijI6HMy4hLVEFjg7dF/dQciog1lUj7MnXQjqR8B7qg9LmwOgmcv4XgpEhNz1dWPOcggokZNDolj2FNd0FZX1CA61j2wFJ0imkdD3mahhQjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3IBI5jPa4CYz/Q+5uI2Tq3TrogpKbRQlJuTN8KKHt4=;
 b=KD+wqNUk4g0JhBwH2gDzT7EYrkRy35PA4Vd+Kh9EvTI+Lk4Ca1mYZb/q8DZnfFrrn3PxVPYBPSNBKiFL6HZ1NxeLxWKKSVxLcESNqOCArBbXCLDOovdrnU0a/RYue2+403lemg5atb8EVm0shnguNhSjBcnRv2Clu3A4r0N0idWJkrjQF7Bv5D+LhgdfgnW6Y6BRGBHJc5PTiFG0DlmrrVotmWCIHjhbScuGv9KpkuuqMBaZzT2seP+Dx/vbrrRXayg9xLnuNeeW+4LvfcQm6Jo+h+UOolTEAs8BMBU8vtphrqRn6H9uGul/HHbs4HfglD9SoKKF6/MIALSYJCV2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3IBI5jPa4CYz/Q+5uI2Tq3TrogpKbRQlJuTN8KKHt4=;
 b=hM5T/HpmhxJ4PbMRgfscXAJq9C9cm3TTndspq+TePoc/HjJVijKyXUAXqRUEzyqYHodwJzqtN0gBGwOmv1lFcJukLnwq07fUuNOyNr5saHMFLth7XoSNKkIM+xtdxhJqAoz7FzoXRfnChsyahZ88hp6ac0EGnDpU+2Dp9h1WBco=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:06:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 17:06:40 +0000
Subject: Re: [PATCH 1/2] target: Add the DUMMY flag to rd_mcp
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux@yadro.com, linux-scsi@vger.kernel.org,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210318094224.17524-1-k.shelekhin@yadro.com>
 <20210318094224.17524-2-k.shelekhin@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <83e2f363-978f-eba2-cff1-ff007cc139ca@oracle.com>
Date:   Mon, 22 Mar 2021 12:06:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210318094224.17524-2-k.shelekhin@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:5:bc::25) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR13CA0012.namprd13.prod.outlook.com (2603:10b6:5:bc::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Mon, 22 Mar 2021 17:06:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dea5675d-8e23-4d58-6a96-08d8ed54dbc2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47825359D88500A36A490A43F1659@SJ0PR10MB4782.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JxHWBXl8ajnEyibG4HxBCIempTfZ9gnRxTNHYVxXYiDMNkrJbqM1zPOAqLkqybkzuirHz7uhv6B0eqIRXc/+rR7oxLeXVhEH98QBpAn6LmTUCgNqaVpz+HEE3sHPYIg/itpCk6CBzqYInjRki+49qMpmNyjrv6h87cdkgdvlLC4NhcjRrkIMRap4RMrtks/mbiYtXjsR6RMr9LQRYVRd6dJOIVPHOWh/pZw/dkK8EnCqSmDUiaONduOJTLLrfIAnHlrT65bxjylmIwGe5xLCC6EVEm6rq2VdA9nUrPSYs0xYgPqYoWXohRxYL6JOkguj3/6Drrg8TAB5BVJ5Zj2z6XR8J4o2bs7XqhHs3vwQKR2bRvuRAE43ATakBowXcyXX5xyBTyMT0KKrz44fGZ5HeLvSma08AAXMG8KAtQ2iHTK/yNBl9Vd2xlC2LF91kYJmNEzbCvx6qn2jJl0sBSPcT3IGLlfAf0GQWiUYnTnRmzlKL3bSJ0NwJW6Ia3CBFbHvtjmxPzd55OR7o0ncp980fAcRaNyoWdCedtackludc0cX9NGnmpdHigdpVV8LQkia6aNKXdMOOuv4Ftg8Pd54+Ke9ZHZtx2RGXyZnWJ1hBEUpZ1JCX5/rpqK16cJ0YFvD5bf2IfitDVQ9WjaS7wQdh+2lakdHrw5LTshQ8NoWjxwsMRiCpdmm2w6HaYq4j5hs3C3fzl1SivWDi4BC18SfnoMdqRRbeaxEFB6/ENwAKDvwpRpAlUl0UKEztOXMqW+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(396003)(376002)(346002)(83380400001)(2906002)(6486002)(53546011)(4326008)(66476007)(478600001)(66556008)(2616005)(66946007)(31696002)(16576012)(316002)(110136005)(86362001)(956004)(26005)(186003)(16526019)(8676002)(5660300002)(36756003)(6706004)(8936002)(38100700001)(31686004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WGNoUFVIcTRFdTBtS3dKc2NySmgrTkxUSVZPTExjdVpqKzNnbFhZbnU2UitP?=
 =?utf-8?B?cmFjNjhaQTh5b055M2dBbEdhNXFQcDJWYXNzeDBYYXd1eDYwNXoxZHAvekdQ?=
 =?utf-8?B?YkVKSHRoU2wzeTJQYU1YazhLMW1BYmQ2MFQ4NUZ1ZkxMWlEzWkkzZjJCeENB?=
 =?utf-8?B?NFNOTm43U0VyemRLOStsQWZkZzlVRG40MEtISmdpR2RoQTIzazhFUmljcnlw?=
 =?utf-8?B?WG5yTTNPWUljQ1BVME94VHkzMlJ2K0doQkxNOXF0b1JwVHp1TEVzZU5Lc1dX?=
 =?utf-8?B?U0c5TDFEMndWVk4xS0RUTXovbFFDMFN1TWJQRVB6alUrdlI3RUNUTllZWDZx?=
 =?utf-8?B?RGV2cXc4SytGam5uTUdmMk56OFMwOWlWcHBLWnRRV01GMU55QmVWRHVGTlBi?=
 =?utf-8?B?Y3JGbVNQaGRxT0ljTHZtZlNxVExVWFNkRU15RnJ6V29yMjU1N05SQ0s0WldI?=
 =?utf-8?B?b3ZkS2NTSk9sVXlEWlFjM0RSR2xJc2lqbDBnelpzRzdGSklxVDM4NDZER2xD?=
 =?utf-8?B?RzYvNEpGUXQ0eEx1QlZlS3hreTRKSUZhTlNWOEh5eHNKL1R5VHpOZEZlTTJo?=
 =?utf-8?B?SURFK1RWdEN3ZGNNT01FRGZTVVpqMm5RRU5oQ1dMcFlBdTA3WFBFdFNoNkYv?=
 =?utf-8?B?Ym80b0cyaHNoNXpSU1Jsa3UvbFh6TSsvNWZoVHdWSFk4TG1HUVl4Z1M5OU5U?=
 =?utf-8?B?Qjdkc0NQWFJJZjdWVU9BVzhveEx1WmllV0ZXckQ3dlFFejNaQlJweWl6aVlX?=
 =?utf-8?B?UTdWUU9WNzFpQU5pNkJTV0JRcFhCcDQrQjhUVEkvS21Qay8wNWFkcDE5T2JM?=
 =?utf-8?B?SExYMDZROXJnaDNwVUhUMnhhL003VVJpaVpJUnZiTTBUeGRaeWxTeTI3cm15?=
 =?utf-8?B?aFlhQ2NVaHhPTnZ3eW5MdFZxMlB5VEJaVXRScERGdmlRZ3FJY3ZldUg5K05O?=
 =?utf-8?B?VmhKRmR5VGJCSGZLeDM0TG54YUVESEpkTzVLdHY4Rkk4eDFXaFNEQjRZb1h5?=
 =?utf-8?B?SzZKK0pKMjJYQmdhWmpmN0pLdm96NjMvTUhQWWt3YzN1ZnZmTDhDUWt1cmtC?=
 =?utf-8?B?U3pjN295TzdaQ1VrejRCVVNXQ3dPd084TzgzM0dLb0hCWkg3K2tYM3NYa2NY?=
 =?utf-8?B?NGgrMklrM20yRVhIMFJoZmVDdC8vdlZ2dDNuV0N0T0NTTkpodHJ2cjlOSGFU?=
 =?utf-8?B?VkRBRXRwdkxlM3BnNWxCQ25GbU01K2RZTCtIQXRJd28vdTkxTmUvYnZLRktj?=
 =?utf-8?B?YVUvbDJaWUhPOVQ1UXI2R2xMNVBubWMrN1VVWCtmb3JGaDRtR1BPQzlTYnV2?=
 =?utf-8?B?VzZzZWYyZDROVFFWZG5tRWxRdGNPUDRjNlF0Y0lMaDEwTWwyWWlkUE8vK2xL?=
 =?utf-8?B?K25TSkIwb3ZDNkRObXloQWlSeWdPMXQzTDkyR0hoOFh1eWtDZjAxdzJHR2NH?=
 =?utf-8?B?L1BOZGV3MVFkRWNCNmtUYmtKYVdSVkVhclRUTkRsYUZTWjEvTnZic21ONzM2?=
 =?utf-8?B?SmIyeUJSUE9sSVpJZjQxUWdDQXhWbnowSy8xdm04WEpFZ0ZvR2NQUThyMUh2?=
 =?utf-8?B?dm53Ty9XRS9WUXhsTGVzSlFPV2lQdzFaSzlPQ3ZCRENybFZyR0N5K2YvaXZh?=
 =?utf-8?B?L051djdjNGk2dk5EVjVMU3ZJTDJsZDBnZ2ptUXhPNW9SMUFRNzJCVU1zQi83?=
 =?utf-8?B?ME5rdFI5Mm90UkRsY2FzVENzalBjWERHM3NNbElBYm5GTitmbXRLeW5KVTR6?=
 =?utf-8?Q?xuX4N8jSovVxFio2BsvuMIyLn60ML16FPyz9rNS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea5675d-8e23-4d58-6a96-08d8ed54dbc2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:06:40.0578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Touk8w0YeMAXSQQtDaU+QysCBhpEU6EjeEuxjHO1SzYzp+0jhaGHJY9exdAwUAc7TIt12hPliws0hDu9dM1E7GcySo5WcrWJfVUIX3N6B+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220123
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/18/21 4:42 AM, Konstantin Shelekhin wrote:
> This commit adds the DUMMY flag to the rd_mcp backend that forces a
> logical unit to report itself as not connected device of an unknown
> type. Essentially this allows users to create devices identical to the
> device for the virtual LUN 0, making it possible to explicitly create a
> LUN 0 device and configure it's WWNs (e.g. vendor or product name).
> 
> Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  drivers/target/target_core_rd.c | 27 +++++++++++++++++++++++----
>  drivers/target/target_core_rd.h |  1 +
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index bf936bbeccfe..cdc5c3bc4b07 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -530,12 +530,13 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  }
>  
>  enum {
> -	Opt_rd_pages, Opt_rd_nullio, Opt_err
> +	Opt_rd_pages, Opt_rd_nullio, Opt_rd_dummy, Opt_err
>  };
>  
>  static match_table_t tokens = {
>  	{Opt_rd_pages, "rd_pages=%d"},
>  	{Opt_rd_nullio, "rd_nullio=%d"},
> +	{Opt_rd_dummy, "rd_dummy=%d"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -574,6 +575,14 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
>  			pr_debug("RAMDISK: Setting NULLIO flag: %d\n", arg);
>  			rd_dev->rd_flags |= RDF_NULLIO;
>  			break;
> +		case Opt_rd_dummy:
> +			match_int(args, &arg);
> +			if (arg != 1)
> +				break;
> +
> +			pr_debug("RAMDISK: Setting DUMMY flag: %d\n", arg);
> +			rd_dev->rd_flags |= RDF_DUMMY;
> +			break;
>  		default:
>  			break;
>  		}
> @@ -590,12 +599,22 @@ static ssize_t rd_show_configfs_dev_params(struct se_device *dev, char *b)
>  	ssize_t bl = sprintf(b, "TCM RamDisk ID: %u  RamDisk Makeup: rd_mcp\n",
>  			rd_dev->rd_dev_id);
>  	bl += sprintf(b + bl, "        PAGES/PAGE_SIZE: %u*%lu"
> -			"  SG_table_count: %u  nullio: %d\n", rd_dev->rd_page_count,
> +			"  SG_table_count: %u  nullio: %d dummy: %d\n",
> +			rd_dev->rd_page_count,
>  			PAGE_SIZE, rd_dev->sg_table_count,
> -			!!(rd_dev->rd_flags & RDF_NULLIO));
> +			!!(rd_dev->rd_flags & RDF_NULLIO),
> +			!!(rd_dev->rd_flags & RDF_DUMMY));
>  	return bl;
>  }
>  
> +static u32 rd_get_device_type(struct se_device *dev)
> +{
> +	if (RD_DEV(dev)->rd_flags & RDF_DUMMY)
> +		return 0x3f; /* Unknown device type, not connected */
> +	else
> +		return TYPE_DISK;

Maybe have this call sbc_get_device_type here so it matches the other drivers
and how this driver calls into lio core for other operations/fields like
parse_cdb or the attrs.


> +}
> +
>  static sector_t rd_get_blocks(struct se_device *dev)
>  {
>  	struct rd_dev *rd_dev = RD_DEV(dev);
> @@ -647,7 +666,7 @@ static const struct target_backend_ops rd_mcp_ops = {
>  	.parse_cdb		= rd_parse_cdb,
>  	.set_configfs_dev_params = rd_set_configfs_dev_params,
>  	.show_configfs_dev_params = rd_show_configfs_dev_params,
> -	.get_device_type	= sbc_get_device_type,
> +	.get_device_type	= rd_get_device_type,
>  	.get_blocks		= rd_get_blocks,
>  	.init_prot		= rd_init_prot,
>  	.free_prot		= rd_free_prot,
> diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
> index 8b88f9b14c3f..9ffda5c4b584 100644
> --- a/drivers/target/target_core_rd.h
> +++ b/drivers/target/target_core_rd.h
> @@ -28,6 +28,7 @@ struct rd_dev_sg_table {
>  
>  #define RDF_HAS_PAGE_COUNT	0x01
>  #define RDF_NULLIO		0x02
> +#define RDF_DUMMY		0x04
>  
>  struct rd_dev {
>  	struct se_device dev;
> 

