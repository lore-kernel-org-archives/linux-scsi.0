Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA523C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4E761209
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbhI3Syf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:54:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64808 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245439AbhI3Syd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:54:33 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIpbK7019800;
        Thu, 30 Sep 2021 18:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gPDsuYY0xyXcsw14rUxZ5OGmpE7DtPVjFmTmNO/pA8I=;
 b=ZPSPh0odW8dzujj5P4iykV6QFqb3NOLhuq94oQJ+KGEcm+jH284f+NVLT1W7D4Dsylpz
 aDeQkqrlcfsIKLFAgnpFdNEO7gt3jpONKPobop0ZwnGpitKuikv9N0wPrTBUkDzQc8PK
 G+8MzY1PP4XdWFwwSCpHr9APDo4dV+5NF1qMly5X8m1eh9EPMkNawJOT3pwUnzLYdCow
 yI0LsIPYrdbSygvy/ixnbYlV06X9QfaVxlIk8aJ1VtJMzv3hRXGoLraJ/8SturU956Zm
 xwTsCa4P3T+X0pLJImcwR/vTEF/wfJrVXeJEkOsj/NGmKO3wuIZ6Wdp2TPABp7uYUhnW cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdevv9uc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:52:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIoHkc104879;
        Thu, 30 Sep 2021 18:52:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 3bc3cgcd1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:52:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfhAonUz8QOaHYVrncQ13+h4xeCIWqxFeSsn3HHvosbvL5TvuPoRdoj/xjyWuQY4mEHdr0rqswxnEiOs3cGNSOFbIOpMbZ9gpS7/pTP0/AU+73IqlWcgvWuHmvdiU3GWmzOp+TSHkdejyXUt9keOFEZzE/VmiFyitVXMtySnPnivk1Fwm1E1fdvEHOdTL3Ll+p703jM1aC4qbFn2MThOnawad5lvMzfRtGKsn7Nz5R+h05GAIntebtifdetLvaY+QrqIzbMa7msZiU7dCetpOHPcl1OiRzCKzlz2VM+xw7ZdfL/UzsjeCFfqew5cfPrDn/FukZMGmzL8NXSqNJq4Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gPDsuYY0xyXcsw14rUxZ5OGmpE7DtPVjFmTmNO/pA8I=;
 b=b6DTA+UatSnHIyUNjX9BhHVYyxpa6N9oS6iSBrbyjIxRUpmkRFpvfR8mwspI0rroHAcDxfO46la3y4TizWmWhkdklAqsde/eHNPDglsbCdLLKvZgBYYO2RoCulQaDpMnobOnPcmB6fh207OJLpPtYRhCh8PDSBCBn+FbkTm+VGVKPzNYbUX54toVeNu7VaYwmS865oCdlZJZ3t+uQpwQx/H1uigun+o45Q0d75MuimfxpUgvBqcaWkPFP5jUN5EJbsCofeUfFqfhBd34V+Fl+ocRvk3KdWqgWqtGHDcQEHNBVaDTovnsT6jhofMcDEr9MEjAFC4at+XfFUy4eNhHzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPDsuYY0xyXcsw14rUxZ5OGmpE7DtPVjFmTmNO/pA8I=;
 b=JaFMt/YBPthIzgJs3pP2o7rV4G/4lBm3bsgV6I+886hJbm9nUtB3iW1U1jKa7I+ExybWrV8JONh1741I/N2BkYBQ2Ug/yZ9ejed29gAvHpu1ged+ided+NRN2IcykFsAXAnwDTycIs56y5PxEyEqhbojhipKRGe0Pc7dOJxeQvM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1594.namprd10.prod.outlook.com (2603:10b6:3:f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Thu, 30 Sep 2021 18:52:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 18:52:40 +0000
Subject: Re: [PATCH 3/3] target: iscsi: control authentication per ACL
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-4-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <2f65a5a4-6296-cd72-b143-1053665fd4b3@oracle.com>
Date:   Thu, 30 Sep 2021 13:52:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210914100314.492-4-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0050.namprd21.prod.outlook.com
 (2603:10b6:3:129::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM5PR21CA0050.namprd21.prod.outlook.com (2603:10b6:3:129::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.0 via Frontend Transport; Thu, 30 Sep 2021 18:52:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf6faee9-8f03-4942-1045-08d984437a88
X-MS-TrafficTypeDiagnostic: DM5PR10MB1594:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB15949A672CE8C0F9C28BD88BF1AA9@DM5PR10MB1594.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeH3H4A4t9iVd7U3v5FJ62r32JQHsrIgMZIYo1nLQHlko2L0y5dRGo3t1hQ9KVUTzSM0Jgowqc00uk13OyW7yDfGSlODNecVcHWBgxlKX1JANzCCshRDNkEk7XEx/RIMfVl5R21G9+OYXuAbPRrTUiEYooZSFBHqSJMNKAwvYHwy4leTrEH1abuWBzzHieRATswtN03B03PlDstGbTuymkRfs+coLjkokvvZQDvqNP84XdRE6LMwVWk0tJBzNYRyICPPZo1UcvBmcFEZlm14mqbyyCfpOKElaGYQ3fDXTNLEE2vfJIgogmcogOULk6H+3vPhbMHG1yI+DatVgTU0tUQ1mzlwB0buQ+WYe9NBs9gLjVOXeqUNyd89l6WEwCaZDtfUu2WQK25PiYOpi4UBTmZ3l+Vak11Ac5yAjhuB1pVR+MRlEM6ZkQZJgisi1uSqeuvEULuMo8dkN/fDKN+rCNXCYSQvi9qgfe+KhsJYlg7vaTjxxLdPDqBernca0nNngZ41NCLn5EygB/gT0q+B07DtwLq0Ue77Nc0ndvOvGlPTcI9PDfOqsu0XxnSTgBzzy8RYdpmXh+gXJa2UPtjS7quIcf/sVOQ5Nk7mh2NOOm+CR3RCyVdhUZmFvCwM6Ig4E4A0xaQbRQyvIEI0qohmHwl+/0L/eUkKRoZfuDrA9hIAFr0c/kslzqFID6/oSzh0SuUTasirt7ycfOF1fuvquBkn/pGAEEtne7tRS3+N5MmLt6LUqJ8bixbtFtnF/Ric/DWgFGbFYS1LdDM8H3H1sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(2906002)(956004)(8676002)(6486002)(26005)(4326008)(186003)(31696002)(31686004)(2616005)(316002)(86362001)(8936002)(508600001)(110136005)(83380400001)(6706004)(16576012)(54906003)(66556008)(38100700002)(5660300002)(66946007)(36756003)(66476007)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RC9vdVVBODBzWk91MDJRMll4U3hZNkF2Sm1iTUtxMW1ad0hFalp4ZGRsQ2Np?=
 =?utf-8?B?cFlCbU5rWnJTZkZYOXRnK3h6SER3V1JybWJjc0xodVlESXJkenpDbGNLbktM?=
 =?utf-8?B?dWFjSFYzbitjYm9wblM5Yk4vdWRuOFlWdzZ1Q0hzM1NMc1ZtaFovZGJMUzBE?=
 =?utf-8?B?dGpOOHJnVW9BQWN0Nnh2VEVFcmJMbm12Q1ZvNHNHV1lVRGc3NC9vVFU0Mk9v?=
 =?utf-8?B?VVlUMW1wUCtZN2xaTXVxdlRwQmJuTHBJYXd2ejBDY1JBeWhIZzA0Zm94N1or?=
 =?utf-8?B?TU5uRDhCaUIrWHFHNEM2YlZHTVRxaUhRc1ZQRTVsZnFuS2ZSQ2l4S2x3U1Fw?=
 =?utf-8?B?M3FHb2xOVzVQRHB2OWRNbEM4WjJtNy9xR2MzM0I4c0JBRE9UU3hHN3JSQWwy?=
 =?utf-8?B?Yi80SjZBZzNiVlA1dzlhdTAvTS9mbDh5MkJBOVV4Y3loWFlWY2xtazR3ckxx?=
 =?utf-8?B?ZmpUNHptMnlzbVIvSUFWREhpVmxWWE9mU2dxUElGbFM1a2lyNkdqZWJGRGNC?=
 =?utf-8?B?ZFVoUlcyNHZNeVBGV0xqRE81cEhjRnh6RWt2anFzRlpnR1lKUTE4VHF3M21k?=
 =?utf-8?B?NDJUczNxS0tqck1OcUIwNmQ1WThDQUdMODZlZnlISlViNDVOZ1AzL1hhSVNt?=
 =?utf-8?B?NWR2RTVVU01uS2NkRVNTTXl1c0RveUJPRW1wejVOTmRLKzcwdllwZHZBNmlI?=
 =?utf-8?B?LzVreDgyY3NNR3kzNjY5TVRtQS9Md1dwWkcraXd6Vmw0ZGFKYnRSUG1iWk40?=
 =?utf-8?B?Z3VqMHhyQmJ4YVdNTWJJMzBkZHFBWkVZZldYTng1QW50ZDhDRlhQNjFIb1E5?=
 =?utf-8?B?WHJNT0lsSERkYXpORlhPZFlYUjBSMldTTzRCMTN6S3VheEVYZUhGM0Z3S2pm?=
 =?utf-8?B?eVhjbFkzd3F5L1FmQmt4MjhKZldvc0VOai9KLzJ3eUZhNzZOTDVMSUt4MG9t?=
 =?utf-8?B?MUNVVzhOSXd1KzFiU0p6ZHBkZzA1UU1haVdrQmFUcG9CREQzUDFPUlBKa1Rw?=
 =?utf-8?B?a3hRNitneDVCWkJVQ0U1bFp3amk1SkRaL0E4TzV6RHpmT0JZNE5YM1dZOWtO?=
 =?utf-8?B?KzZmOG1RcG5MSWN4RE03U2FNTHBBRXJJWnFwVUFDSCtKZnlpRGc3SXVLTDJh?=
 =?utf-8?B?MCtmNWVML2NkVXFTM0ZPZUhyeUlwUHhTK3hGQTZZSkh2Y2NqeTRLK0Z5cSsw?=
 =?utf-8?B?bW5FRDVJamx0M1NydWVVcnlXUW5xVlF5d0tQL1F2dUYvVEFnSUk0cXFDVFo3?=
 =?utf-8?B?SDlOUm9hNFZmdnc2T2lZVkcwNmZudWo0U0Q4QUJrYzQ0ZVI4K0c4R0QzRS92?=
 =?utf-8?B?QTdQbW1SWW85a2pkVUZrSEhQQjQwZ1Q3NUQweGFJYU5TU3d3b0IyRDVDSHdE?=
 =?utf-8?B?YmdPWHlJWjJYdE51Q0tBOEcrd1FMeU9LTlFTcTZVeWFURThvamtpdktuSUhv?=
 =?utf-8?B?OTRiN0c5SFBGQ29KUXB3cDd6dk91MGxtQzVKbWtsVTR5Q0ttRE5zSEJidmVx?=
 =?utf-8?B?ellVQ3d1ZGNvaGtPU3lmUXA1Tjg0bDhMM2RIbjNSYWtqSDhEbUc3TE05Y3VE?=
 =?utf-8?B?UllaVmVtSTBKUS9vcHkxdTJpNEt3dlArMGVFOEZPeVZ1K0NTZHYrb2Z6VWRK?=
 =?utf-8?B?TUpFaHRsUi8zamRRM2JUZldmbGZtNHVwRmgzbkFaVGhuT3YzLytQdk02aHJL?=
 =?utf-8?B?ZlVxK0dpVGF2ZENNNUtkVDhwRjBYZnAvRHhDamxTZFFqcUJVUnBudTJURjBN?=
 =?utf-8?Q?5W6jtThkJVUaTNc9FU035jbsTBNJlGhIflIMly1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6faee9-8f03-4942-1045-08d984437a88
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:52:40.4417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcfSUWUBksPTEjMUtDn1/lSsCz0YgV6Zvu2Vmlmi5Oi6WYnUWoa27k3mhEbEK/Gl//eOHZ9EqYno6gpkhmAMsfB90IJaXWqmYsWObfwKH6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1594
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300115
X-Proofpoint-ORIG-GUID: FrI96a1AWgvR2BgmW4NXoUFMeSdYgsZf
X-Proofpoint-GUID: FrI96a1AWgvR2BgmW4NXoUFMeSdYgsZf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/21 5:03 AM, Dmitry Bogdanov wrote:
> Add acls/{ACL}/attrib/authentication attribute that controls authentication
> for the particular ACL. By default, this attribute inherits a value of
> authentication attribute of the target port group to keep backward
> compatibility.
> 
> authentication attribute has 3 states:
>  "0" - authentication is turned off for this ACL
>  "1" - authentication is required for this ACL
>  "" - authentication is inherited from TPG


Why the empty string for this value? Maybe 2 or -1?


> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/iscsi/iscsi_target_configfs.c  | 41 +++++++++++++++++++
>  drivers/target/iscsi/iscsi_target_nego.c      |  8 +++-
>  .../target/iscsi/iscsi_target_nodeattrib.c    |  1 +
>  include/target/iscsi/iscsi_target_core.h      |  2 +
>  4 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index e3750b64cc0c..2d70de342408 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -314,6 +314,46 @@ ISCSI_NACL_ATTR(random_datain_pdu_offsets);
>  ISCSI_NACL_ATTR(random_datain_seq_offsets);
>  ISCSI_NACL_ATTR(random_r2t_offsets);
>  
> +static ssize_t iscsi_nacl_attrib_authentication_show(struct config_item *item,
> +		char *page)
> +{
> +	struct se_node_acl *se_nacl = attrib_to_nacl(item);
> +	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);
> +
> +	if (nacl->node_attrib.authentication == NA_AUTHENTICATION_INHERITED) {
> +		struct iscsi_portal_group *tpg = to_iscsi_tpg(se_nacl->se_tpg);
> +
> +		return sprintf(page, "%u (inherited)\n",
> +				tpg->tpg_attrib.authentication);


I think we want a value of -1 or 2 for inherited then here it should print
that value.
