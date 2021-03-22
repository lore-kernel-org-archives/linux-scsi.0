Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C04C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA8C6195D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 17:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhCVRgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:36:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhCVRgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 13:36:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MHXuTx082813;
        Mon, 22 Mar 2021 17:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8OfIfIIXS1pcKGYR0zJMA2Nx+HP0SM5w71Y+S31Sp1I=;
 b=OcCX0dc+G7WWYW2Ybk0biS2TICe1XmHXcofdkk0y26fS3fH136CHr614P49kT6js3qAk
 9eSu8yyOjZX0qL60UQs6tnzBiDh9jW5+Zscp4yTftsTQ0EKqbI+AdDyf0nVk2N0hIVhE
 /nU4v7VyGPpOCbKO9N37OIYzHTQbaK9fR7qcoob1HKSpfRPj4yy7mRSSN46rMUAUBwXz
 QIidV+IXZEuj9a6fciY+XLIsjVeHu4YPU1CpdYLNR+7ieGhFHk/fzM+9zytN34Fr6cDJ
 0HiRWI0DxNGgUaE3gX6F6tZRS55f6gaQUHwpkgFViT+iur6WkK/QT0Dy4fnvNU3rW8oT Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pmv86d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:35:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MHUMku078046;
        Mon, 22 Mar 2021 17:35:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 37dtxx7xfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 17:35:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHsyzAgx3WKgX8DeXTU4E87wK4kYDnfknGOlCtcqnr5dH19pCQue2bP1zUBlfun+T5sAqg7czTwU0A2uPPd8qj090B9OUvy/RYeYwP5+1Y4ky6J2b0g5TtatWdAmTBEmR+UuAI2iC+VWSc3BN2JbIZBxBFmsnVBPIR9d8h6WrItCelcMWt3a0eJAH/VjzR9h8C+U6WZs7PFrAHSCRUfe3Sty8+OOUTwOyEoWc39y+NBn1dGsbKOgg+5cxGQuerJUwu/wDTR29LO7OAOGURpYNaSf59p5zkAaF8aorfO/tzFqmsxac44faFk4hdWRcBY1J1Y+9Tnk3t8pfqfDdQJGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OfIfIIXS1pcKGYR0zJMA2Nx+HP0SM5w71Y+S31Sp1I=;
 b=cR9Lgroxmrh7wWSH5GBYpTnFJCJ3a4hIyEWpLhuTza5tirRsqwx6Rc1K/08BLaafJYKGyWDYVNHWiSDYWiH1bFX9auOMo0WLWVmj1q/4MC2oD45WJyQHWHOHhnHcVBj1HF7bm5paVhKQOlvHn5o24Z3sfqjU0vjIhOulRmC76wA061o9BsfhoJPLaeuW9GrydyeRQ/LLSNhr7p6yYeEIsfzJRIFO5H6jWLsbD5h2z9n9cLZhtwB0ftVu53xyG8tg6LiQ/OLJ0QnnkzRbxhXHX883Di3lPd2Ps44BkuJoOABg6jan/Vd10T16kEwNAvKRLVnEB/lP18mHHEY/izLy4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OfIfIIXS1pcKGYR0zJMA2Nx+HP0SM5w71Y+S31Sp1I=;
 b=dJ+xJvSq4gEe8/flgfRH/n9ZESTY4Ob0J8VclF5U5EwTA6oKeLfY438g+FpbQU3vKQu+RfQnq0+B5+/1eEe9D3MBW+fEjDERFFGxN0QPFLNACYJ5YO07sqVFXhzQ3xGKfGprT4iaGyrubF/2ZbAHEvF3t4AZXZgPqWygaR3IMb0=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4103.namprd10.prod.outlook.com (2603:10b6:a03:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:35:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 17:35:54 +0000
Subject: Re: [PATCH v2 1/7] target: core: add common tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
 <20210322080554.7611-2-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d8d1e9c2-4cd7-3f41-8545-99549b0704d4@oracle.com>
Date:   Mon, 22 Mar 2021 12:35:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322080554.7611-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0017.namprd21.prod.outlook.com
 (2603:10b6:3:ac::27) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR21CA0017.namprd21.prod.outlook.com (2603:10b6:3:ac::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.2 via Frontend Transport; Mon, 22 Mar 2021 17:35:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a78194d5-5d77-4cfb-9de6-08d8ed58f1b4
X-MS-TrafficTypeDiagnostic: BYAPR10MB4103:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB41031D515BF2C4D3DE3CBB9BF1659@BYAPR10MB4103.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cO737GH/zFe980Zh2nqTit+TF6ao2icj6mry62BIjWB399XxKAmFQ/IPqWFFJ/fhWbPtL5keAIjZeVFyZ1Pu3ARiqz0W4zQ9EoEVXTaLE70NdmY/Mgc4nACxvyxAV2BnNgSIU6X5+4JAVdZEV5yG5Zrl2jN25lwGh26/k/DLeO3uiCrPw9burA4eC8q/ipXh/hsAfDcH08jprOHa/5gN9uvYJW6tNZ9oulSnfodTW49g2Y23SdsL6+bDtXKa6syOCrK3Rp66qaoyoVFUL/50DNh2YorKZwDr85+NlLF5tuylJBMJQuRjLepl9WuvK2xh1yyW04Hb0NA3dJwlOFnJFq3MJd2sHnxd+soLVssgP2BpJkQkps3wx+/u2Pl8VM6HfzvpOeCQSMKG/EJaPq0xQ/cZQzuXazxEskkSSXIhGIbXfnnBbx3HxiJozrb3vKXZj3XdXqRAM8zVv3m35nNnoTCM9YE+7ON250Bfbv3I3plz8ID5NWrrdXDb1AR9yT8zwb77yWCcbP2ybJK+qIxPC0KGcwijIKB6J+Djk8q0UWHPh1cRqoY0y3D3q0GjnMr9k8ryKNBrZbD8Uu5a3vhsr7lAKeDx0iACTl6roIce2LON3RABSrkaj7ckk74/nJ9oMZ7vq+hUQLkqv6LbWdRZwWYxGxGQn/0zM8YCCdSSGahAUXHbWNIPd339A5PU2/RFJrjeRb4WrturBvEtZZjskcxe40/Sj0U8sLnk1bz7M+etDSduIvnL6ZDSGQOU6gTV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(346002)(376002)(6486002)(38100700001)(31686004)(36756003)(8676002)(31696002)(8936002)(53546011)(4326008)(83380400001)(54906003)(956004)(86362001)(16576012)(16526019)(6706004)(2906002)(66556008)(110136005)(5660300002)(316002)(66946007)(2616005)(478600001)(26005)(186003)(7416002)(66476007)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFMyM3JGMERmRkZIWHZHeC90T1RMUjlFY003Q0lqQmVlelRWUVJkSW4wL1E0?=
 =?utf-8?B?TDRoWWRkQ2djZlFDU1llYzRSdE1ST3VxeDVlVlRNa3hnVEIvNlVXbGF3dUNz?=
 =?utf-8?B?WmlRWHBnZk9HSDhBcHNVSEpvOTAvazg1SDVoT2Q2cjArTWZqdmpaZzhhanpP?=
 =?utf-8?B?VUYxdHZ2S3dFMnRUWkJQUWJZdFh0d09QVmxXRE5NRmpkdExmbWlNRVFhVS81?=
 =?utf-8?B?aHdSYkFBREhHK0V6ZzhDaDlTQ2x1TjFEYWNGNWd6eDN4L1U2V0tscGlhVnc2?=
 =?utf-8?B?NEs0ZTRJYVBJeld1Z1JVMEVrWDc2b1c5ZlZDanVYRHV5LzdTUlN6OWVPaUND?=
 =?utf-8?B?TGhtZCtFVzNEWGhNWXlPN0tQazNVNlEyemhlKzVTSjhlQmdLZ21YMnp4YWNX?=
 =?utf-8?B?aWFja2E1MmgxcW1pVjZCZXpjUlZFNFJCMjdicUN5aCtFT2VSUERQUHRCeEh6?=
 =?utf-8?B?VEVvalRtbkpEMzBiUWVwcXVkNFZ4MnFuSjBWZEhNbXdxWU9OQ3dURmxRQTFI?=
 =?utf-8?B?NXZhRmora1NuaDByVkd3dXhZUDBPRWdGTXVkVllBaHJzVjNxUXV1bHorVmVU?=
 =?utf-8?B?b3RTMTd5WTVvWk1aWmdieTYxR2lvaWo4cXp4SHU0c2NMMDc5UEIxWTZhNWl6?=
 =?utf-8?B?M0RMZ2VaRnR6KzZQcUx4eHBmdi9IeERmNTdqSHdYejRSbm0zbnc1UFgvbG9F?=
 =?utf-8?B?K3B4Nm9TYjhQdWhqOE5uSkhYVm1kUTZPbUtZZHNmOVpBYVBHeEFRNXhiRFpr?=
 =?utf-8?B?UFdoRE1YSFRLZG9CTFRMODN0cDM1c09sbXZld1B2Y1plVlZNWUN3elJIWGpm?=
 =?utf-8?B?eWY1YkRRMVROeFE1aklDZjNKWFh1UHlkNTNNeWVhTk9LSnJFYzFET21JbFVX?=
 =?utf-8?B?RGZDd3htZ2FTRnFqUnlsODZxUU5QWTN5ME1ORDVudXBrR1E4S202NVhBbUNi?=
 =?utf-8?B?MlZpenAwSVlLdGlCeU1aalVYMWh0NU9NN3JZSnVtZHZZbnl0N1laTW5YS3R2?=
 =?utf-8?B?aWdrY2ZFTjVhRG1UcW1uemlNOEsyN0ZRM0JZQ3lsbU1uT1cyNVdPb3E2S3Rv?=
 =?utf-8?B?WDJiTlp2STdudDBaV3p5ZlZWL2xjdStSVzF0czdmTHh1NmduaERYbzlseWoz?=
 =?utf-8?B?SmtwTDNzTmJFMXNRMDBDZEgrbDdRU1pna0FPN1dFTEVvbDNjd2lzWlZZZ2lp?=
 =?utf-8?B?RUFsOEo0NlFxb29MTmJ0NmJoc2JGSUZWVzM3WUhzR0pzT1orTzB6c0RTUXdY?=
 =?utf-8?B?eGpmN290UlFkYmMvUkxscEwvS1FkaDJlUU8wVWZtb1JycTFnN0ZxVEd1SUJq?=
 =?utf-8?B?b2xNMUJ1L3RtZnpCY1R1Z0dmWm0zK3lKQ0oyRDJWdi9sNW5BVHl3TTBLZ3NN?=
 =?utf-8?B?cjgvNHE4UUUrcEd6NTJxTjJucFhZcEZqSVNnS1N0di9TUjUwblZrbkpCOEt1?=
 =?utf-8?B?OVNkMUxGNHpPM3B6MjBlalhnWXFEb2hsUDlwOU9qQlBMS0lYaGF4MU9KYjcr?=
 =?utf-8?B?V3ZnOE5xL2xHNnFJSnQyeUh6OGxtMFVaT3dMeXdxa2twbk95T3JvWDZOTzBm?=
 =?utf-8?B?c1huSloxZHZFMWI5cmg4bzBZWFRQNlRvaytFUXc2Zndvd2p2aG96N2JZK1VE?=
 =?utf-8?B?YVc4dzA4OWxMRXVKYnI0MnJNVUhPUFNuczZhTUFOemRYVnFvQWhCQkJNRitw?=
 =?utf-8?B?NkpNSkxuYzFZYjYyY1F1OFdEY2h4emFET2x0YTdhYjhjR3hHOVpocHNxeE9C?=
 =?utf-8?Q?tbxO5fihChKMwnP11HEdcGq8Xp8Q3ln2bQKftrb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78194d5-5d77-4cfb-9de6-08d8ed58f1b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:35:54.2265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q93r0+7VZNxgMVWFme/ZNDbynTMPlyC0XJu6GVTujdhRBVhZj+sccGVyPm/0KAXH6nW9VEiLifpn+NfbKLSKy/LYP0gBjq1JfrP0kiR7Uxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4103
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 3:05 AM, Dmitry Bogdanov wrote:
> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change provides a way to remove code duplication in the fabric
> modules and automatically add "enable" attribute if a fabric module has
> an implementation of fabric_enable_tpg() ops.
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> v2:
>     create enable atribute only for modules with enable_tpg ops 
> 
>  drivers/target/target_core_configfs.c        |  1 +
>  drivers/target/target_core_fabric_configfs.c | 40 ++++++++++++++++++-
>  drivers/target/target_core_internal.h        |  1 +
>  drivers/target/target_core_tpg.c             | 41 ++++++++++++++++++++
>  include/target/target_core_base.h            |  1 +
>  include/target/target_core_fabric.h          |  1 +
>  6 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f04352285155..fc3949e91f9c 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -490,6 +490,7 @@ void target_unregister_template(const struct target_core_fabric_ops *fo)
>  			 * fabric driver unload of TFO->module to proceed.
>  			 */
>  			rcu_barrier();
> +			kfree(t->tf_tpg_base_cit.ct_attrs);
>  			kfree(t);
>  			return;
>  		}
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index ee85602213f7..c5e1b0d54330 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -815,8 +815,40 @@ static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
>  	.release		= target_fabric_tpg_release,
>  };
>  
> -TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
> +static int
> +target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
> +{
> +	int i, k, len = 0;
> +	struct config_item_type *cit = &tf->tf_tpg_base_cit;
> +	struct configfs_attribute **attrs;
> +
> +	if (tf->tf_ops->fabric_enable_tpg)
> +		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
> +			len += sizeof(struct configfs_attribute *);
> +	if (tf->tf_ops->tfc_tpg_base_attrs)
> +		for (i = 0; tf->tf_ops->tfc_tpg_base_attrs[i]; i++)
> +			len += sizeof(struct configfs_attribute *);
> +	len += sizeof(struct configfs_attribute *);
> +
> +	attrs = kzalloc(len, GFP_KERNEL);
> +	if (!attrs)
> +		return -ENOMEM;
> +
> +	if (tf->tf_ops->fabric_enable_tpg)
> +		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
> +			attrs[i] = core_tpg_base_enable_attrs[i];
> +	if (tf->tf_ops->tfc_tpg_base_attrs)
> +		for (k = 0; tf->tf_ops->tfc_tpg_base_attrs[k]; k++, i++)

If fabric_enable_tpg is not set then I think i is the value from above
when we did the tfc_tpg_base_attrs loop to calculate the total len needed
for the kzalloc.


> +			attrs[i] = tf->tf_ops->tfc_tpg_base_attrs[k];
> +	attrs[i] = NULL;

If fabric_enable_tpg and tfc_tpg_base_attrs attrs is not set then i is
not initialized.

I'm guessing you guys do more testing with tcm_qla. Maybe also do a quick
target creation test with iscsi and loop to hit some of the different combos.



> +
> +	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
> +	cit->ct_attrs = attrs;
> +	cit->ct_owner = tf->tf_ops->module;
> +	pr_debug("Setup generic tpg_base\n");
>  
> +	return 0;
> +}
>  /* End of tfc_tpg_base_cit */
>  
>  /* Start of tfc_tpg_cit */
> @@ -971,11 +1003,15 @@ TF_CIT_SETUP_DRV(discovery, NULL, NULL);
>  
>  int target_fabric_setup_cits(struct target_fabric_configfs *tf)
>  {
> +	int ret;
> +
>  	target_fabric_setup_discovery_cit(tf);
>  	target_fabric_setup_wwn_cit(tf);
>  	target_fabric_setup_wwn_fabric_stats_cit(tf);
>  	target_fabric_setup_tpg_cit(tf);
> -	target_fabric_setup_tpg_base_cit(tf);

Add newline

> +	ret = target_fabric_setup_tpg_base_cit(tf);
> +	if (ret)
> +		return ret;

Add newline

>  	target_fabric_setup_tpg_port_cit(tf);
>  	target_fabric_setup_tpg_port_stat_cit(tf);
>  	target_fabric_setup_tpg_lun_cit(tf);
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index e7b3c6e5d574..274fd670bf9c 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -117,6 +117,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
>  
>  /* target_core_tpg.c */
>  extern struct se_device *g_lun0_dev;
> +extern struct configfs_attribute *core_tpg_base_enable_attrs[];
>  
>  struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
>  		const char *);
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 736847c933e5..d06b3fbd8511 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -650,3 +650,44 @@ void core_tpg_remove_lun(
>  
>  	percpu_ref_exit(&lun->lun_ref);
>  }
> +

Delete extra newline.

> +
> +static ssize_t core_tpg_base_enable_show(struct config_item *item, char *page)
> +{
> +	return sysfs_emit(page, "%d\n", to_tpg(item)->enabled);
> +}
> +
> +static ssize_t core_tpg_base_enable_store(struct config_item *item,
> +					  const char *page, size_t count)
> +{
> +	struct se_portal_group *se_tpg = to_tpg(item);
> +	int ret;
> +	u32 op;
> +
> +	ret = kstrtou32(page, 0, &op);
> +	if (ret)
> +		return ret;

Add a newline.

> +	if ((op != 1) && (op != 0)) {
> +		pr_err("Illegal value for tpg_enable: %u\n", op);
> +		return -EINVAL;
> +	}
> +
> +	if (se_tpg->enabled == op)
> +		return count;
> +
> +	ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, op);
> +

Delete extra newline.

> +	if (ret)
> +		return ret;
> +
> +	se_tpg->enabled = op;
> +
> +	return count;
> +}
