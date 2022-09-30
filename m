Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25390C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiI3ACW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiI3ACV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:02:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3A2115A5E;
        Thu, 29 Sep 2022 17:02:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMiVHp026414;
        Fri, 30 Sep 2022 00:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SRvYYBKAJQw+g+HoqqzXZfCD34lYjZhO+54oq5geLjk=;
 b=YBFH7v+YWdkxrb0zwcht7JknbImcdPc7j0T6JVLLz9aiMSNGF7yc9D7EM52ib7wazghG
 OTJ/nyYzCFXw/dnlFfJLZ6bmZ1tTiWoOIdNTGBPe1I2gb+BxDiLH3bYzSRVt+r34s0AT
 uTi5wt6wfWfV+Aqvr3ILU1e8ucxyW5Q3tYyK0+ZmAhhAJqu8zsjBLMqyPLcxDce2DkAu
 RT1+HREOixSLpAJ+AgAx0SlXKOpasE97P6Eg5XNS8LwWwcap1/Z11z+cbcJ6QRBuV0o3
 /Nc7ybVSIJPRpj5XAtDICNhEvJokFFcgoJEF8PHy0/KmJ5GcMjQordhOTLVhDy2R/3qI DQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13pcd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:02:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TLV2uD039492;
        Fri, 30 Sep 2022 00:02:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprx4s5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvv2fg1HjKOBMBQjFfNtUGIGakIuCt/XiKc0m8VnN/wdIW7hyofy6BWCd/cInj3wpOQhr9mWHhCdKPMJmNeeq8MXS9nVAzB7f0jY5UEqXXz4kQJN6aR+45J/qN1IGK2pJ1C9HbgGXKPP4wq+iUGKhh8TflRSPdtURMzxrldn+IPptYQawrYoc1yNv+fjjx+atDGU1dRv83X5grQ0dVCwDwibg1hm/s/e4OwYUGGjY4eFUGvVQ+rEYbbwFSy1wvHsBdnauA3GsRuGRBxUfixkCLwOix/wyweEplKvDYwqQGMA8IRMrYUrkMUZ3HzgbyMl3eKcjcMHqwkss5ASi3tFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRvYYBKAJQw+g+HoqqzXZfCD34lYjZhO+54oq5geLjk=;
 b=RbO//qQln9VxoJbx0WESFKCJ37O7+Aeo9PwvQxN2uhXDWAP7Bf1tynq6X0itdGh4hc444/KJBTrOWocFYTvGVrn1D3eZlycs6Bf68N2Z2YXXO/ThuUNz1NT0HkWc6uWPKMzvUgnsQm/CnI3y58l3bF+9OALneyIabN9Ba6Hc8OkWgfi+AsrzxUVlrwyuIZnwKqnZ170jtUwrkcXUWklZfnYm/ibSne2jEaDyyiWU8d38nupUVKGeEBgK1vCp+WFXCrK8ilcoaMIni2foOCqWE4tdudIk/nqg7tWgfkaSzf4E9LcGUQ6+MgewiMoukqJGymZs+qY64HDzNpQ2rQV1dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRvYYBKAJQw+g+HoqqzXZfCD34lYjZhO+54oq5geLjk=;
 b=Qol4XD7F0LQ55DWVViLaXee5rXh6X+w2P2juMM8WZt3oxBGh5h9g7ogD2t+/h73k0H+FFGPY88Wg4ltqVfKovkYPw4lcsQkV4kOgBYg5trkG9XSiimEZG1m5O3F+GRc5vpXitlfIBHeLWAU25Ud5O8itKG2xVCmHRp7u/Rwyr+o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4918.namprd10.prod.outlook.com (2603:10b6:408:12e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Fri, 30 Sep 2022 00:02:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 00:02:14 +0000
Message-ID: <5f730538-6738-86b9-fefe-da09ad9e0a47@oracle.com>
Date:   Thu, 29 Sep 2022 19:02:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 7/7] target: core: check RTPI uniquity for enabled TPG
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-8-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906154519.27487-8-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0016.namprd05.prod.outlook.com (2603:10b6:610::29)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed2e56c-22fb-4202-661c-08daa27707a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/YyRNls20NZGthHCtGBI6cU6F414jicUW7Q0nEkQAjOt5fdwPxxRBMCQqdxe4H9FuuxbqGVJfGsVl0aLELrh8dImn09ILM/oaJCoAeKMfFTrE5ItapdR4boHraIN9pzHAezIVzlrTT57RN4PXeiosvv+bKfj6UNFxP4WeJbQV1xBM62Kah4mLRHSAIIjKUWbbK6J9i0lYOaJlWN1WnnxMFIC1X+sfAc0t8zKYq0VA86Soj+Ag+9ViZBHEg+bomOZuIU5NeG4LoTBQ8ZG8oCF5LHpWJOcpUkjPOkyNiDdamf+Fdn2FLzXjsfRCLZCvFWdQoU4LI38fGyi5v4JQ/O9Im334sHp6HFSbYvuEohwsQ5yu0PcMMBNdTJdT6O0Gq2yvrz9G72VAfnO1PHOc2bqhER9OMLjpT+Vuvyob1SxJgP9BTH+GQahfCzEqTFqThfikkkjf52UYEHVGUV954aOTe1+ZqZFjJPVnhDDqlTy1zlX/a4BlsbjkXlv2lZ3zSh8FxggSH2zYGo606IlLjuZeist5DlYZeq3FUXCpB+ZEbt4IG6hwdOJhDrIbpjGWS/ZWDfikTqk4JJEcuszVItxTmx9t5PnqugAvghKxIcgq7gWPM7rfrFWTJKP6Pz99DyK+XX/gw3mY15SHVI1w6d3Av+Y0PTaNeOQ/ZhD1crsMj1556XkPpr2JtDVOvBX7lKWue58aizYKADG6Ee0sXw8RTV6LcsXP1ALRk/f0dPKf8m/wnp6YtCQ2XwBsbx+sUmxJ47uPqpVDTIn850lOb+o+Gr0TIbxBO1r+616lL8n/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199015)(31686004)(186003)(2616005)(83380400001)(8676002)(6512007)(478600001)(38100700002)(6506007)(53546011)(41300700001)(31696002)(86362001)(5660300002)(26005)(8936002)(6486002)(2906002)(316002)(36756003)(110136005)(66946007)(66556008)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE1aYm9lOHhEenV0NG0vSk1POEVINlhNell2cjBvQVlTcTJiRm5FMjMvR2hD?=
 =?utf-8?B?UFVKNEF0OGJaZE9mZS9uUkl6Y0VyblVibHA2OThON0RyckVTOUNSQUtlS2Zx?=
 =?utf-8?B?S1JHSVR6a1ZKMEEydWM4NEdhc1ZUalFmVThGVVdkaHljTnBnVTJVTVUzRkhB?=
 =?utf-8?B?SHlodmc5UGNIM08wY2cvWDQweEVLUm5ucVliUFBrd0xld2ttdjVzeFNWY21U?=
 =?utf-8?B?S25Fd25iTmpGOEllU3dJeDFYQmhnKzRLYllGY3krNjRiQ1R2RzRYV2VXNlUx?=
 =?utf-8?B?UnkybUE3UktoZm5RSEIveE5CbmZhQ0lRVmx1UkJRc2hmNG1NSUJvN01ZVC93?=
 =?utf-8?B?NERpMGwxeERhSzAxOExnWmY2SjZiQlFDV1gvWUI5VnRDeGZmUmsyWmtxT24v?=
 =?utf-8?B?U0dnWjlsWFZFQ0FidlM5K0l3WFUvak1BYVduSnFmUDRWZ1VtVG9CTWhFWE1w?=
 =?utf-8?B?N2RMbHk3Q2owUFJORVVZOVNCYXNadHA3K2hsYlpmYXZkZ0wvYkJwaDg4cGJR?=
 =?utf-8?B?NDBVb2RKaXpKRHRraDJ6Y2RiSWRtZlVsQ3V2NHlGSTlkRlB6TlNXazFRSmxU?=
 =?utf-8?B?WkZNcE1nSDhkTzdaNi9aMU4xZjE1V0ltMTE2dGE4N05oZWdxU2I4RktzcDdL?=
 =?utf-8?B?aUg2R1U5emhhVi9IM2RNNk5qOFY0RlhPeVRFRkwxZkI0ZU9WcUttcjRGbkdx?=
 =?utf-8?B?R0FBVFBDRk9PNGNwZ2NHYUJJb05HRVpCQlE1L0l1VUQyYTRKeWRzZHVzUWU4?=
 =?utf-8?B?L1V6cElzNmF6SERVOFZaMW9Xb3RoSnF1QmZlREx6MHg5L0FibmhIbDM3MkRS?=
 =?utf-8?B?NHlZU0M3cTY0K2FGWHdmNndnVkczY0laQnpXdkhXcnMxU1pZMitBSXh0Qm5n?=
 =?utf-8?B?WGhtSlk3U0FVa25HKy9KYmV3cmxSdGtOZlhrT1UrOUtmZEhua0ZETlN4bzVK?=
 =?utf-8?B?R0pjUVNsd1hvVks1djEzRmVBT3p0MmN3Vk9zT0tuQ3JKMmRyeUNZd3dqQi9L?=
 =?utf-8?B?NUVwWEszMkhHUkVVRTdqMDUvczlLVmVoYkZvR3VpMFhJa1RDQXc0TmgvUEZx?=
 =?utf-8?B?eFZ0dGtvUU1sTXJQRlBIQXR6MSsyc2FiZmFpUWRONzIrWHFTYzh1VU5QMGp5?=
 =?utf-8?B?OFRtNWRtalpGNk1taWl1M0VIU0FRVjl5MjJleVJmYXp5MlVKK0pnNzVuS1hF?=
 =?utf-8?B?RCtjOVZMbjNWeWpzQlVSd25kc25PNGNVbFZoRVFaRm9HN3VQU2dGdHREU29M?=
 =?utf-8?B?aDlNNHN1TU1CbCtKZkJOVjVuZFhrSDl1RkJrdldRRXVVZW5JSHVaS3MwRU5y?=
 =?utf-8?B?L0tyVy9CNVU5WWE0ekNMY3VJTmZpcCtMRzZ4elMyT1RLVm15dklNMHRuUnBY?=
 =?utf-8?B?NEpveldjSWVzOVoveXpJU1IxczFhUzg0bitsZ09uVHI4a1F0UTlBYmtLeTNl?=
 =?utf-8?B?dHFWSjFqc3A2aHZYa2tMT2RPc25ldEFINE92NTBGemNpMmRzS1EybHo4OExw?=
 =?utf-8?B?VTV1eDF5SXNRK0VyZGc1UHhrbTFRRzZKeVgrTitOd3VBQTFtZFh2TnY2SFFn?=
 =?utf-8?B?MDBXVjllR2JscVB2aERkekdURXZqaVNvMm9zNFBCWmlKZ0ZFWVF2eUpiaWc3?=
 =?utf-8?B?bVcxSkVUc0NHQUFEVFFhZ2JJOUlqZnVSYTY1YVpnM2JWMERqWS9MNEpyakxU?=
 =?utf-8?B?VWo2R1V2YUZUTWJlMGxDYTB0TTErSlN5VnErczUxdjNTaFVEUjdUUjFQOHFO?=
 =?utf-8?B?YlpaYTlpclFhVTJXcWVqQzI5emgyL29iaEM4MUM2RTJIQzZOQXpOTllFRVE4?=
 =?utf-8?B?b1VRRHAwQzRZS0lBUDRtRldaYjdWL0xiUVE2SjNZRXlrS05OMm9sbGRhMjFZ?=
 =?utf-8?B?ZldrZXN4cDFxVm5rWGI4QXUrVVF0dTNaMXhlblF5cmpUS2VHTlJLVEZ1THBO?=
 =?utf-8?B?bmlCeVlXTGVyZHFzWmcyRjdUa2tWbkJ4VFJhSkVoNE01cm1HOXhWZUZLZ0pp?=
 =?utf-8?B?bDBUbTRyU040Y1Nja3hpWHBzcmhCZUZaUktYZ2psWUcvNnp5T0JoWWpsVjNW?=
 =?utf-8?B?NnR4L3FFeXFreWU3bkNhclJXMWl3d00yam93R2d6TU8xUGJHSFZnd3dDWW9N?=
 =?utf-8?B?aEYvenRRS2ZYUVdjdGpIaVJWdk1wWWxua2Z6RkVhLzRnWWY0S3dmeU1BOUdU?=
 =?utf-8?B?S1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed2e56c-22fb-4202-661c-08daa27707a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 00:02:14.1037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3k6FHBPhjQaLMEOr3fLVfOneEBPnSor2vabOUjuvm8Hz2vxe0j7wc5+1GHj7w4kjgQJiokoymoMoVzS7jMsQkT1panUxFr3BlrIPkCjskg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4918
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290149
X-Proofpoint-ORIG-GUID: kR9zjt3rYKYzKEw7foQwzAf_oZhuCKl5
X-Proofpoint-GUID: kR9zjt3rYKYzKEw7foQwzAf_oZhuCKl5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
> Garantee uniquity of RTPI only for enabled target port groups.
> Allow any RPTI for disabled tpg until it is enabled.
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_fabric_configfs.c | 29 +++++++++++++-
>  drivers/target/target_core_internal.h        |  2 +
>  drivers/target/target_core_tpg.c             | 40 +++++++++++++-------
>  3 files changed, 56 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index a34b5db4eec5..fc1b8f54fb54 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -857,6 +857,7 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
>  						   size_t count)
>  {
>  	struct se_portal_group *se_tpg = to_tpg(item);
> +	struct se_portal_group *tpg;
>  	int ret;
>  	bool op;
>  
> @@ -867,11 +868,37 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
>  	if (se_tpg->enabled == op)
>  		return count;
>  
> +	spin_lock(&g_tpg_lock);
> +
> +	if (op) {
> +		tpg = core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
> +		if (tpg) {
> +			spin_unlock(&g_tpg_lock);
> +
> +			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
> +			       se_tpg->se_tpg_tfo->fabric_name,
> +			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
> +			       se_tpg->tpg_rtpi,
> +			       tpg->se_tpg_tfo->fabric_name,
> +			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
> +			return -EINVAL;
> +		}
> +	}
> +
> +	se_tpg->enabled |= 0x10; /* transient state */

Just use a mutex and hold it the entire time if you can and
drop this. Or add a proper enum/define for the states and make a real
API since this is exported to userspace, and it's going to be difficult
to explain to users that state.


> +	spin_unlock(&g_tpg_lock);
> +
>  	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
> -	if (ret)
> +
> +	spin_lock(&g_tpg_lock);
> +	if (ret < 0) {
> +		se_tpg->enabled	&= ~0x10; /* clear transient state */
> +		spin_unlock(&g_tpg_lock);
>  		return ret;
> +	}
>  
>  	se_tpg->enabled = op;
> +	spin_unlock(&g_tpg_lock);
>  
>  	return count;
>  }
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index d662cdc9a04c..d4ace697edb0 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -116,6 +116,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
>  		struct list_head *, struct se_cmd *);
>  
>  /* target_core_tpg.c */
> +extern struct spinlock g_tpg_lock;
>  extern struct se_device *g_lun0_dev;
>  extern struct configfs_attribute *core_tpg_attrib_attrs[];
>  
> @@ -131,6 +132,7 @@ void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
>  struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
>  		const char *initiatorname);
>  void core_tpg_del_initiator_node_acl(struct se_node_acl *acl);
> +struct se_portal_group *core_get_tpg_by_rtpi(u16 rtpi);
>  
>  /* target_core_transport.c */
>  extern struct kmem_cache *se_tmr_req_cache;
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 85c9473a38fd..ef2adbe628e0 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -34,7 +34,7 @@ extern struct se_device *g_lun0_dev;
>  static u16 g_tpg_count;
>  static u16 g_tpg_rtpi_counter = 1;
>  static LIST_HEAD(g_tpg_list);
> -static DEFINE_SPINLOCK(g_tpg_lock);
> +DEFINE_SPINLOCK(g_tpg_lock);
>  
>  /*	__core_tpg_get_initiator_node_acl():
>   *
> @@ -476,7 +476,7 @@ static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
>  		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
>  		 * for 16-bit wrap..
>  		 */
> -		if (se_tpg->tpg_rtpi == tpg->tpg_rtpi)
> +		if (tpg->enabled && se_tpg->tpg_rtpi == tpg->tpg_rtpi)
>  			goto again;
>  	}
>  	list_add(&se_tpg->tpg_list, &g_tpg_list);
> @@ -738,12 +738,26 @@ static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
>  	return sprintf(page, "%#x\n", se_tpg->tpg_rtpi);
>  }
>  
> +struct se_portal_group *
> +core_get_tpg_by_rtpi(u16 rtpi)
> +{
> +	struct se_portal_group *tpg;
> +
> +	lockdep_assert_held(&g_tpg_lock);
> +
> +	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
> +		if (tpg->enabled && rtpi == tpg->tpg_rtpi)
> +			return tpg;
> +	}
> +
> +	return NULL;
> +}
> +
>  static ssize_t core_tpg_rtpi_store(struct config_item *item,
>  				   const char *page, size_t count)
>  {
>  	struct se_portal_group *se_tpg = attrib_to_tpg(item);
>  	struct se_portal_group *tpg;
> -	bool rtpi_changed = false;
>  	u16 val;
>  	int ret;
>  
> @@ -753,11 +767,14 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
>  	if (val == 0)
>  		return -EINVAL;
>  
> -	/* RTPI shouldn't conflict with values of existing ports */
> +	if (se_tpg->tpg_rtpi == val)
> +		return count;

This test above and the chunk at the end looks like it should have been
in patch 6.


> +
>  	spin_lock(&g_tpg_lock);
>  
> -	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
> -		if (se_tpg != tpg && val == tpg->tpg_rtpi) {
> +	if (se_tpg->enabled) {
> +		tpg = core_get_tpg_by_rtpi(val);
> +		if (tpg) {
>  			spin_unlock(&g_tpg_lock);
>  			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
>  			       se_tpg->se_tpg_tfo->fabric_name,
> @@ -769,17 +786,12 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
>  		}
>  	}
>  
> -	if (se_tpg->tpg_rtpi != val) {
> -		se_tpg->tpg_rtpi = val;
> -		rtpi_changed = true;
> -	}
> +	se_tpg->tpg_rtpi = val;
>  	spin_unlock(&g_tpg_lock);
>  
> -	if (rtpi_changed)
> -		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
> -	ret = count;
> +	core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
>  
> -	return ret;
> +	return count;
>  }
>  
>  CONFIGFS_ATTR(core_tpg_, rtpi);

