Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7D8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 00:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A4C64E0D
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 00:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhBEAqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:46:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhBEAqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 19:46:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150T2pa182135;
        Fri, 5 Feb 2021 00:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1e09rGiYgRRbk+Wc4/LWBYbG3indTwRMsArSK3NR398=;
 b=eP92/n9vfteuf7LlJFZmP+GarlgaTFs1A7YAQ+uLV6MRHY6/0RcxZ5uvDFE0K3yO7xo4
 rBRRkpu/HLu+4bnQLG/BHeE6ZirI0vhhKTUZyQm7r1Rm72/AWASy4VaHUS2zLB1ZIT7r
 yxP4C4+42WOHrgQ+q5414OJK025YkVYnd/VvwCxEGP8XSR4AXBaH4/aLbPcd3oxmUwOd
 4oGk6gCsXJTG8/aklPcX9/Ym+yu65sjLLyjl5/cGPMaR0LTHI0K6Wogw6QIXylpN7zh9
 msDQPzmaazbqHxgIbJsP5uGcgWMCPTlij4Il1OwZ6sAmFBvJBoc4ZXbguGInfxMkH0Bk 5Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydm7txs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:45:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150VdCr127865;
        Fri, 5 Feb 2021 00:45:17 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by aserp3030.oracle.com with ESMTP id 36dh1t7n75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIcuPoG0gpJGy+LErjDuDhYxdfm8MyoRZy0zNPd9ain4RtnU6PJMbDu2nQOawjoFdGiD0gc/AtTLN1R0gzVlhdXmtywzsiIKpfYkruWnJ8hKgrsVzkdxUq7PGBcyuqAXkH2eOgGyViptwc7oHM3ZBwZi1MWyqI+OLWgHibkE4BNKbrH34PEpEUL8wKtDZRRCgk37MnAZRczRGlxI7oI4I9xw5dSH1ZwxSRsUVGxOohX/7EmF7/kNyI7oSW4jpf5p1SnB1qWADx4vapb1ehUC7fg0Q3fbzRXlgV3TE+DnSAiTHrXeoWG5HZSjftKI4pIheSMTRCm2yhXuFXvsVfoIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e09rGiYgRRbk+Wc4/LWBYbG3indTwRMsArSK3NR398=;
 b=MjPI2yTawZwDdLxbMvfGNoTcYzjPeQQBnFLdy4moNXalSE77au+85xclv78Z+NkMcoyDRi5Z0UJYKceNesFFnrX2gozaZZbMTnFMAUxlI8fgHB2hnJG+t418X6XN17l2YUFDI1dPYW+rhtFFQWcCPREIudosyvRBMCRkBp4b/dEkoHohWORBCaF5+6c84oECOtr/g+79DycO1Yc2ifjrnyki4ZGlvyAyKkVQDRNOrCZgDTogvL2lKG5CbjFL048Wa8cOzcfp/eQcA6Oo4C+jr8v3fdlPMlRU9PKq7FImF5KRzUKNTI/E1eqglgMRbeUp5agRR5HxVa+P7Ko/e98+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e09rGiYgRRbk+Wc4/LWBYbG3indTwRMsArSK3NR398=;
 b=XjYhTaCRLeLoBBMRo72oFOiJqh/88dBq0/PV2jBuyNJWuwmCDDIVB2pwH0kHvt4ljSfw4ZK19J9WtUwKj05Av3gJ90MAcTrnNe+AvZtOY+TkRndvd1iQBNIKwjHJqThxAxN0ce/Lv7YYg9mAP7+y1tU85h3NV1Eu4PWb6DkbxF8=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3173.namprd10.prod.outlook.com (2603:10b6:a03:153::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 00:45:15 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 00:45:15 +0000
Subject: Re: [PATCH 08/11] target iblock: add backend plug/unplug callouts
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-9-michael.christie@oracle.com>
 <BYAPR04MB4965A3E11E9A98C287A410F986B39@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   michael.christie@oracle.com
Message-ID: <8f8da9a0-d1a8-0622-9684-d869db4e5399@oracle.com>
Date:   Thu, 4 Feb 2021 18:45:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <BYAPR04MB4965A3E11E9A98C287A410F986B39@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:610:51::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by CH2PR15CA0025.namprd15.prod.outlook.com (2603:10b6:610:51::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 00:45:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51922608-8d07-4840-9eff-08d8c96f4d45
X-MS-TrafficTypeDiagnostic: BYAPR10MB3173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3173AAB5074210C0A3D6C2BFF1B29@BYAPR10MB3173.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcxU7cfgGzauHXI4QYEZU54y4y6hv0ZFQuzWr82eStcus4SGoJ/x2olyPMnTgcvHbQVAYWGVwBY44iORu5tCrwC9UV6PxTFqqBh57PZ8Mv4PRrKWcLWxlguktObuGmAq5igiFrY0cLiDcqzmgFQTZyG9T1buRHqdFVvqeCrqYSNSAdinGVoiYCk+Tbc/xKW73KL2GWkU7bMWkfEA/4YHDnNyfYQWHCu2mpTZ/e3lrRQipjv5qTw6yvNRV05Aww1Fl//2I1lx44RL/1LDpRdJ4vxcVqlqGdIo1YRKhd2dkeE8Z/b7eXIw88uJoqeCOM/mmbjUldXOl4CrOHr0urIawd/GpEgCoGVvcY0XQRb9KrzTUqzbleQIGNHtyE5sho/NB5R9aAsS8UdyrAdu22o2YAJDDErhnzy8GqZW8oibThGXTAD+tapoojfwM887gbmKYCnmPJRw/vI1L3oPddx4DiMVXX30D4sGdxsJfKZK9yjNHD0wrJrEAkNwPQxwbTWIiHvFVccG3lsJu0ii71N8FV8KydT4HpN/8QkYoGar1EJmWYnRtYO8+R6H0eQX8eHpwY8bJhKc0U2/4n9zv9o4pvCoUTtcpSmB1ZEoR2HU3uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(53546011)(956004)(26005)(316002)(8936002)(8676002)(2906002)(16576012)(86362001)(31696002)(66556008)(66946007)(5660300002)(83380400001)(6486002)(16526019)(6706004)(9686003)(36756003)(186003)(2616005)(110136005)(478600001)(66476007)(31686004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MTJ0WU02WThpcldaNnJJbDliVG9HQWUzNWMyRXBiVTRsUVFxc2E0KzExUFF0?=
 =?utf-8?B?NEFjellldWRkSk1MYkQ4MFEyMlE5RzNVcDhnUTVGSmg2a3RFOFB6Y3ZkVWRC?=
 =?utf-8?B?dkZ3OWF3OWVCV1lOQTVINlVJU05DUHAvQ3phNy9TMVhRVENwME4vMXZDbnc3?=
 =?utf-8?B?VWlheG5QWUtad3VBZFg3ZldJejVvc1dWK21yTGtwektwZG94a3dtR3djYVli?=
 =?utf-8?B?bXFYbWJhaGhaTlJ6WWRJcE9CYVB0eExFaGJvQllWQ2s5alZ1eVlDbnd6bFdW?=
 =?utf-8?B?YituRmxiNDRySXZNZjVLd0F4K05obzN0cVRrc2FXbVZQZEQ0Mk4wSTN3R2NG?=
 =?utf-8?B?K29kWDFJMnhYMytNQlpvdlZpZ205TUNrcVo2cmlGMEFEMjZySVhRdWZwQlFt?=
 =?utf-8?B?cnRzQ2U3cmlOYlRDbW5wWXkvSlFxYVo0RC9Gb2hReVAxWnJhNm1vQmIwQURT?=
 =?utf-8?B?Y0RJall6eEtpOEJsUmhGNzJsUUN4WVE2aGZjbkEvWUxQMXJhR0Q0eVd2Vjl1?=
 =?utf-8?B?VWlaMjljZ1BpNHV4RmJySEwxaUdoYXdYbzJoMVJtQVFRYUZ0UjlBeHE0R1p4?=
 =?utf-8?B?dGI2OWc5OVg0TlZObUFSa01FV29HMFJtSTVUdjNKbWFTVFlxVEVNa09xRm55?=
 =?utf-8?B?eHRkcGo1Rm9ZaFMwK1VwL1lSZ3phM01iVWlRay9wUGc5T0Jpb2JTWGVzeGd0?=
 =?utf-8?B?WlIwcHpZcm5zNVZZTzZ5YWRPTnhJd1FHTGRFK3g1QndsMUxndHlmd2hIYnpQ?=
 =?utf-8?B?UDlqenQ4RWZ2emVQYWN6Mjg4RjY3cmhUUW5OdEl0OFgvN3NCMHNOdlJyT1M1?=
 =?utf-8?B?aXI0R3FFdFRlNmM1VXNGT3BsdXZmMENsOStodnJqSVVrcTNJUFUrSWNOaWxN?=
 =?utf-8?B?bVdWSmFBNG9OcFVJWUVGeC83RmxySDNYTjU1dDZZTkIzQ0hlWnJzM2pMeTZE?=
 =?utf-8?B?cFNma1BVN3pXdDllWk10YWYvM3hVb21aS0YvTnZmN1RrUUlSNFUwZW02UEp0?=
 =?utf-8?B?Z2xXNGZEODRMQkxna1BBc3k3ZDEwSy9uaWxNa2hvYmRMeWVHYnJlL1pDWjNM?=
 =?utf-8?B?RWlHc3N3SFNrTDN3VFpnZUVQVFVQbEg1OERhODdZdEFwZU44YS9ObGd4bjA1?=
 =?utf-8?B?cXJpWDNJNnlxc3hTR1cybU44NEY5M1NjN0VFbzY0RzV4cVBKa2NTYitKSkpQ?=
 =?utf-8?B?WmFuS2RSS05HVjBmT1NrUXU5OC9qeW5CcDd2Vmc3UmlheUV4UzZ2MTJHRUt4?=
 =?utf-8?B?NllNRXgyNG5oc3A4bHhuRWZiMUtiUllOMVl4UlhsYUJxUmV4VGVmTG5KZ3ZQ?=
 =?utf-8?B?dGx5b0hKRW92WW1Jc1BvemgyVGFpdWRrT2N6anVSNGxMUnBRTTVSVVVEU0dl?=
 =?utf-8?B?bTJ4eDBncXc3VzN3dktBSzh6dHV1bnU2N0NmVU9qWXRDNjVGNlJsSUluRHUv?=
 =?utf-8?B?OHRhdW9uS3UwWng0MkhVSmV0N25GanNmelAwM3FJdW9zVGZXL2ZFdkMrbU83?=
 =?utf-8?B?c2hwZThlR2tWWkFlOU9lRStqemFYMklaUWlaanBKLzJoWDNEd3JNOS9KdGh3?=
 =?utf-8?B?SWZUUkx0b0dJRWZhMkNWQVJCaUtBZjhncnUzd0pEOXF6UWp1WEJRM0ZsOWJL?=
 =?utf-8?B?NzY5TWNUenlCTDJnZkNnNkVCbXArUHNnNlhhSnR5b09Wck9PWGp6RlFZSENC?=
 =?utf-8?B?VTZrMHdvdjdieXBFbVBhc0NWK2ZqQnFnQWhQZXBPVWNQeEtaSnBtc3hTU3lV?=
 =?utf-8?Q?eMRhj+4YfiaHty4yc/Bwag4fsamhasEreLZsr40?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51922608-8d07-4840-9eff-08d8c96f4d45
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 00:45:15.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYepx/Ukh1Y3wUMbcWQJixvReWPb3g1G3ATpJBfkN0xkqz07ulXrBXARStQfDjVLHFUDVzIFfMMf2RTEilKMQA45F8lpTADQZdWRoq+KCvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3173
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 5:23 PM, Chaitanya Kulkarni wrote:
> On 2/4/21 03:40, Mike Christie wrote:
>> This patch adds plug/unplug callouts for iblock. For initiator drivers
>> like iscsi which wants to pass multiple cmds to its xmit thread instead
>> of one cmd at a time, this increases IOPs by around 10% with vhost-scsi
>> (combined with the last patches we can see a total 40-50% increase). For
>> driver combos like tcm_loop and faster drivers like the iser initiator, we
>> can still see IOPs increase by 20-30% when tcm_loop's nr_hw_queues setting
>> is also increased.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/target/target_core_iblock.c | 41 ++++++++++++++++++++++++++++-
>>   drivers/target/target_core_iblock.h | 10 +++++++
>>   2 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
>> index 8ed93fd205c7..a4951e662615 100644
>> --- a/drivers/target/target_core_iblock.c
>> +++ b/drivers/target/target_core_iblock.c
>> @@ -61,9 +61,18 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
>>   		return NULL;
>>   	}
>>   
>> +	ib_dev->ibd_plug = kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),
>> +				   GFP_KERNEL);
>> +	if (!ib_dev->ibd_plug)
>> +		goto free_dev;
>> +
>>   	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
>>   
>>   	return &ib_dev->dev;
>> +
>> +free_dev:
>> +	kfree(ib_dev);
>> +	return NULL;
>>   }
>>   
>>   static int iblock_configure_device(struct se_device *dev)
>> @@ -171,6 +180,7 @@ static void iblock_dev_call_rcu(struct rcu_head *p)
>>   	struct se_device *dev = container_of(p, struct se_device, rcu_head);
>>   	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
>>   
>> +	kfree(ib_dev->ibd_plug);
>>   	kfree(ib_dev);
>>   }
>>   
>> @@ -188,6 +198,30 @@ static void iblock_destroy_device(struct se_device *dev)
>>   	bioset_exit(&ib_dev->ibd_bio_set);
>>   }
>>   
>> +static struct se_dev_plug *iblock_plug_device(struct se_cmd *se_cmd)
>> +{
>> +	struct se_device *se_dev = se_cmd->se_dev;
>> +	struct iblock_dev *ib_dev = IBLOCK_DEV(se_dev);
>> +	struct iblock_dev_plug *ib_dev_plug;
>> +
>> +	ib_dev_plug = &ib_dev->ibd_plug[se_cmd->cpuid];
>> +	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))
>> +		return NULL;
>> +
>> +	blk_start_plug(&ib_dev_plug->blk_plug);
>> +	return &ib_dev_plug->se_plug;
>> +}
>> +
>> +static void iblock_unplug_device(struct se_dev_plug *se_plug)
>> +{
>> +	struct iblock_dev_plug *ib_dev_plug =
>> +				container_of(se_plug, struct iblock_dev_plug,
>> +					     se_plug);
> I think something like on the new line read much easier for me atleast :-
> 
>          ib_dev_plug = container_of(se_plug, struct iblock_dev_plug,
> se_plug);

Yeah nicer. Will change this and the other one.
