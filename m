Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0415C47092
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92305613AE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFBNrH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:47:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFBNrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:47:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152DjGar051377;
        Wed, 2 Jun 2021 13:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xKLHw23W69DQtHpMDCzYEKg/vLBKPjGHh/QHMu+9iOE=;
 b=vJREmUhNxU3CNc2/MVMP00J8OU2ZgwzyNpm+5uFCKT1RN0ikvTENhtcyFkcLLZYmku8X
 e50Oto0C9oOJ6IT93MRjIqNsZdv9Lc9yz8ECKTr3cI+iOLfD9Y598qhGY8PkJxva8G4Z
 OqMHg/5bemEW2eklyNZj7/7rUrqDupoyePrUrocBbymmjMlEaVjwvWfXRv64/DTkL3zj
 95kejE6n0nM23j6MGa7+MGN3CkDuyVfqcckQQzGWws8K69YNA0zTrtYkEd+zgzZCBOh6
 AgICpvL57WxaNACP46atR+vDqAAf06ZFKTYzGLvlZqUi3ieh+FuhYB/khdZQxasf4HTo 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4crp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 13:45:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152DefO4192749;
        Wed, 2 Jun 2021 13:45:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3020.oracle.com with ESMTP id 38x1bcx7wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 13:45:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIWpSMxWcZ43zVC+K5HYyU7WSKM7EBMn6/zzuKjznSDG3zGbnJ41p4DDIgyc2jfWpFH8JpdgYox/PzDPJQHx68g+3XPNXwXPFNgau1bWHmLCI6eeJ+zkjztKGw/sv8NOd+cHim+wHKc3u2ibiFDv6ydR8jNj/PNnL626qaIgqJIUMIcQ8NHJGOd6ziSVzK0NmPtey3AIfpIYeOnkY1y0vr2xtRxahLYXAdVHlMtBiUzPU22dBgdZJG6RTAigbaWm1epj0VDMGm0AxF7FhlPVEFEGKjC2DlaeKoYbrBEOzLcH5BHKSarBGty79Py1Ivua37bmaXkBThSjyAv+AaNAdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKLHw23W69DQtHpMDCzYEKg/vLBKPjGHh/QHMu+9iOE=;
 b=ogqdqE3FsRPPthWHcbUXK651nWLZN4BI93z2LkrHFRBfjMyVSectb7JtevO8Jf5yydzaCCLnoRqrzg2kgCeX6tmR9YXmqUFDYCELJZZVtnSdwk9cgBNlSomMO/pFjwPld83HOCn3a3rRn4nyFv8otZzxer0Gs4dQWa+COTEr7fJshfilBEhKKFexELvuHFXj2FVaFUnlX+GqlNr1InCNACugZzjiYS+5eJ3/sUXJsCbEZHKvYfJ3qrcKcdvh8nHHsHK8f4SDSpNcXiVlNB2OU+ze3tgc0Yqumcjl7EHq0U5osHIgY9p1OpUa5yKF8du2gTyidfGDidnrumg37vCxJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKLHw23W69DQtHpMDCzYEKg/vLBKPjGHh/QHMu+9iOE=;
 b=b3w4+xuClJNqJwivBohKW1dmaEO2ZdNw7TGAJv+KOezAh6Q8eFXfPA4PHe7ndiS25McVURsJ1elN6V6aPGV/M5mrW80oxKpsK8e18wf3S3Ptk2YAVTTeMSv+aQGlhzNZvwFrvubPT2oz0sF/EV5nMRUhLwRHEDXfE49SSy6fuw0=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 13:45:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 13:45:18 +0000
Subject: Re: [PATCH V2] qedf: Update the max_id value in host structure.
To:     Javed Hasan <jhasan@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210602104653.17278-1-jhasan@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <5fdeb02b-8e09-7968-708a-e8b92cf9b47b@oracle.com>
Date:   Wed, 2 Jun 2021 08:45:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210602104653.17278-1-jhasan@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::27]
X-ClientProxiedBy: SA0PR11CA0106.namprd11.prod.outlook.com
 (2603:10b6:806:d1::21) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::a72] (2606:b400:8004:44::27) by SA0PR11CA0106.namprd11.prod.outlook.com (2603:10b6:806:d1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Wed, 2 Jun 2021 13:45:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 645f8b8a-767b-4449-a181-08d925cca8b1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4683:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4683E44BA6D2BA537E7BD605E63D9@SA2PR10MB4683.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVRhCQUsI/bnBFDYvB1GJNMWrKnyFiv+KKjKf61azOx3ED0Majg+nrTcH9ewnirDuFRf2hjjJE06n6r8VKecQmIbUZew8coxP4KV1gkdDjpDUUZ3I1s7QJy9X0/kIR2TGe3shICUuSEBZJz84YdLRn8I9xyH6Hmnh3AdsqlqU6o+1ZKOOF2k4qz3oQ5jDsGSVmBlNtwA+kCAiELlwJISbMXJX/+DRYRH5w2XC4L4JAKLq1/p0Uofd+Zkci7Z4G566isIMb+KshhXe5ho19dqCK0O9z59MA3Xq9QfV/XYmgpr7feBqO4YRcMns2rhkHh21mA4+4zl0f/udhQO0IuSGzxw4yZDcqs4mlopeDpneY6InKOKmo3VXLHweC9QxssLzYQvizNN4qCOxtvrk9v/ZgfSuoLfiRRUzidr6tjBlnDvwTQEkZlk74ej/SkHq/F7S+icdppLcCYz6GOC3Z76aa2RbNw71kU60Njmym7f48X3UmdTonfRBweeeoyGfmlybs0birz9Aft4gu3K4HJEDchYRauSGho6JmAdYuQs/HiPuSysPokX4u7ulHHly43EQg5GZrhPSuQ3a7AyRqwj+yvp0gAs7pWkznlRqp016/bOYaPm5dmWI0GHeDa9oy5hGoiqfmqpMttlg8kgx68GVATK+PZTTJbi5dKSQCOiB38ruRbkeIocUDdlLX/9kh1u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39860400002)(346002)(396003)(36916002)(6486002)(66476007)(6636002)(316002)(66556008)(5660300002)(66946007)(36756003)(83380400001)(86362001)(186003)(31696002)(16526019)(53546011)(2906002)(8676002)(4326008)(2616005)(478600001)(38100700002)(44832011)(15650500001)(31686004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWZmZ0w4WGE4UTk2OWZkNDR4RW1kenBRVFp3ZWJLaU1GaU10OUpMejdaWTZK?=
 =?utf-8?B?S0diMTJZckY1UGZxbjRUQ3M4ME1CTDQyQ0QrQ3FYcDhleEpON1paWm5lMFUv?=
 =?utf-8?B?UUdrTFNmVVdpY3RqN201eVpsWFhST0dSdGlFR0FGanJ1QXpKSTlOYUg3eklv?=
 =?utf-8?B?cXZsdmRDY0d6TUhWVk1xYWZ0OGJuWEo0Q29HbXNWV2hFall6dGs4QzFrYWQ5?=
 =?utf-8?B?Q2xRWjY4TFg4MUtuSm5MN3ladmF2KzFjRXhWSGlEaXBTQUVPREdNTDkzbWc0?=
 =?utf-8?B?dHVobE81WWdCeldkR1l1YXptQWFXZTRVZ3JJdzBiUkVyV3pEejh6ZVBBblZr?=
 =?utf-8?B?QThYeTMxYTZxMW1LaEU4U3U4SGRHMStUVEk5WGtBT2JENlgzdnZMUW0yVVFM?=
 =?utf-8?B?OXZzaW5teDhsMjJWRGxSSHBRaVNUbU1VbU5WOUl1MlVna0RqNm8wM0d0ZU5E?=
 =?utf-8?B?K0NCblcyT0Zad2JqeEM1MHY1b1FGdUpuN1hxQzVkNFVwRXhvRnNqV3F5d2Mw?=
 =?utf-8?B?aVB3RlUyTjBQTndPV25wWm9CMWNNNlMzNGxWMlNZSzRJYnlCRXlvZHpsUEJ0?=
 =?utf-8?B?RGhjUktuT1d1K1Q2RlNIeEV6MDY1YVRDWUk1K3M2YjN2bTdQQk1IMC8zV1pp?=
 =?utf-8?B?OS9vUUtiUVYycnI4VjhhS05FWGNON25EdHAvTnBCWlV0M1FHWFBMR0tENmdQ?=
 =?utf-8?B?NU9mSUVwanVIZ3NLRzZoOGNTRTAwTk5oSXQvZXpMVVN0Lzl6dHJtWmRkU0tx?=
 =?utf-8?B?UWRmUndFcTMzYmdMZDV1Z3M0Ty9nWnVwTHlpMVhLejgzWDZndE9oV09YWEVS?=
 =?utf-8?B?QW4veFdrUkp4bE5Cc2NsNjl4M3Z5ZU9vSmFabXBJTks2aU5ZTGN3OSszY3JB?=
 =?utf-8?B?TkJleXc0M2FLWE9Kbld0Y3VaNGJRRHQ1aEhlNjBIRmwzck81bEVUTktmWHhr?=
 =?utf-8?B?TkUzcjA2akpKNjdrNU5ic1Fic1o5RFFzcjF2UkN0OWhpVUxtZjZwdXRaTGFX?=
 =?utf-8?B?dWViNVZ6T2dKeWJnMU9zc2JKOVNDSStyMG90VnNFTjA2RmE3ZmJjUTFidDJF?=
 =?utf-8?B?NzJTWDg1OVZvNkpaNmR1VUI2ZnZRNkFVbStCNmd4ZDhIQXZXVHRtOW9BSGNr?=
 =?utf-8?B?Z3J3bFFuZ1JhcTFmSDJMZkY4alBualAyRnFoVHROczBYcFZBUGFYVjdTSkNx?=
 =?utf-8?B?a0Z0dnpOVUNEbE41b2FVWVVmUGt1Wm93NHdnNVhuZ2p0QkY0R0lrbXM4RExJ?=
 =?utf-8?B?MmRtaVhTVFdYeCs1TmdibkloL2NQQWQ3Q0lRT1FSRTZlaTZMbytMY2xkOEgr?=
 =?utf-8?B?bE0wTTRCclFJSmxZY0Rka3A4bS9XUEJVN09WblN3N291U1BLak1sWnA2MDVK?=
 =?utf-8?B?dlZlTW5XZ3hWMXFQbjgzMkU2QXpZNFYzVEI5QjZhU3pxT2tLOGJOT1JwOVAz?=
 =?utf-8?B?SGNvQ2Rud244U0ZveVA2bktkUXp0d1FBTU5QRGk1SzBNcGRDaXFWR3BBY2xv?=
 =?utf-8?B?cE02S01CRzBJa1VBczFuNFhKVUNIN0FyVnByNldZMnZpWC9sNUo1Wm1LT2tq?=
 =?utf-8?B?RW0vSGJLRzkvQ2RlbXZPN3FCQVBEdzI2QmxCa1J6S25FZHlGczJmbVJBeE5x?=
 =?utf-8?B?dmIxQlllVEFOVDBrcy8wZ2ZxTTZMR1BOSE9oN1hYN0U4SkhZNTNvNE1sdkJh?=
 =?utf-8?B?dW1JcnJ2ZlFBSG9yWm9HWkJISmRDUEswVHUrQ2N2aDBOM0p6RHFqNTl3VjVh?=
 =?utf-8?B?eFFWbDZwRDZlb3o4TTlNYVh0anpUdndoWW10L3lZSVlkQkhTd2ROdU41TGxh?=
 =?utf-8?B?K05XaEpDMk84aHpxUUZNdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645f8b8a-767b-4449-a181-08d925cca8b1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 13:45:18.5993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GytqMgsM7lNNhUVITgldGSs1qhhxswueerO3YzsFykAukNEMMzL8jRzM4lUDWJcIkudOfuAXsfAMzAZREQKKRXGRBDJ+LLXfZaa5lBnoVT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020089
X-Proofpoint-GUID: Z5A1Jw06GiqHUZbLRhStyOyeFxVTHgj-
X-Proofpoint-ORIG-GUID: Z5A1Jw06GiqHUZbLRhStyOyeFxVTHgj-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/21 5:46 AM, Javed Hasan wrote:
> From: Saurav Kashyap <skashyap@marvell.com>
> 
>    The max_id value defines the max id of the target that stack
>    can scan during manual scanning through scsi_host sysfs interface.
>    If default value is 8, update the value to the max sessions driver support.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> Changes in v2:
>   - Added description and signed-off.
> ---
>   drivers/scsi/qedf/qedf_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index c5f37277..322046f4 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2089,6 +2089,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
>   	vn_port->host->max_lun = qedf_max_lun;
>   	vn_port->host->sg_tablesize = QEDF_MAX_BDS_PER_CMD;
>   	vn_port->host->max_cmd_len = QEDF_MAX_CDB_LEN;
> +	vn_port->host->max_id = QEDF_MAX_SESSIONS;
>   
>   	rc = scsi_add_host(vn_port->host, &vport->dev);
>   	if (rc) {
> @@ -3855,6 +3856,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
>   		host->transportt = qedf_fc_transport_template;
>   		host->max_lun = qedf_max_lun;
>   		host->max_cmd_len = QEDF_MAX_CDB_LEN;
> +		host->max_id = QEDF_MAX_SESSIONS;
>   #ifdef USE_BLK_MQ
>   		host->use_blk_mq = qedf_use_blk_mq;
>   		if (shost_use_blk_mq(host)) {
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
