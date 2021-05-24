Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACE9C2B9F8
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D2961209
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhEXP2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 11:28:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbhEXP1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 11:27:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OF9Qag118413;
        Mon, 24 May 2021 15:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pwfrh36NkILiLfWsWHX/5J5SGJw+Q/U5GxCtXxTuzPE=;
 b=b+7oJ2kVKy6elke4Dow5ZoEvQt4md3lamvPgh5Qg0HpQhnAxTmgMWKrA2Bm8uEXo4Kxp
 0TZqmzW6yya3542ldTMV7oZxfGGzSZL6iu/OvFKZ3oyQkxjKErn+WffvZM0On07fWJAy
 4G4AmP1dJJvM6ZSNNbMLSApceYOdSW9/VdeSkJHSq24WuoJ2FWRC1NM1Gbzxv3RJm34K
 KSUIV/TaMmc4V4g+eUQxp3tt7UxdcH3env2myIOokiNyF8GiKJMwbY1fxxR6A0sZVvFG
 DA50i0K/UrnzmvaDs1filnTAORWnsWD5kAPLPpL6BpyawU7RzCtjdxWGsu9p23qO061U RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp3bps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OFAkh9100156;
        Mon, 24 May 2021 15:25:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 38reh79r3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cn/nspUOU0v8ijGTPpQcQqY2zfdHt0Cp/WV2HsrN86Vye7W+U197pHVsf9qe4IRLn0zpd68kH0jz+opoGBMv8Y+ZBsNRd9DYJI1Z5rSHOwY3goDq4E+DlQkdFOiMb/BXvftUVe0XisNpFVKQ4QFF7hwifX8TEJ8fBmVzY/mWpZkBw1LrD/lz6HDZMrIefRnCRxzyoFkRJmsYxNWSni6CJDRTyx/CqrFCM1Patg4yJd2LMJXsg2byHPltifn4RvDjzgPEQwzcULiDNH40v2MlKb4eynXJtNS+U/9Ip3Dty1OCO7/m6rGpgPG64rPBX/hoiayacFT5pxNwsBW0d6Wflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwfrh36NkILiLfWsWHX/5J5SGJw+Q/U5GxCtXxTuzPE=;
 b=W/ALKm6zFiolsUAcI6MmvMQaGLx6vVldmRdK4LIHsd+qBersXm8uPpdPRF5+v1b3Ew67WjL490fu8962cVmUMaMgb9+lFDPzKwlbb6odnjEksB1uEARSnAdqALS6W7B0r2to3i4B/yNTsAAWAcX9KmTJxBH1UKEkIbTHBv6r53BCgewMm4/3mHwUcvV5h6koMxJDbprQMI7Y7ai8YW6ViPBsgkdt+Wszt3O57aM9VvKTydVCwp8URYa82B2ghG9KKKZPM9LJP1rQLAZR94km3VetTnHv4k/U9tRUfOL2adSx5Z7/UHfihlFWL4LbiwQPmpTAxL6o3SDdVmbm7kgWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwfrh36NkILiLfWsWHX/5J5SGJw+Q/U5GxCtXxTuzPE=;
 b=v/1AuxVsqh8WFe1BlSEBhY1300sfX6hAMW94D+qkt+lw34KRcq4ACHJWnvy2QC4tW7P414dHITw6Iln+rtgw7OLTy2XaRrx4+qEpiGEjOHxqY4rlKFIm55D/P2nnxy6eMx8HxuQvC/MO63ZnHYrGZEpmEcF0bm5Oi/yI4zFsK6w=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 15:25:39 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 15:25:39 +0000
Subject: Re: [PATCH v3 3/3] Change the type of the second argument of
 scsi_host_complete_all_commands()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210524025457.11299-1-bvanassche@acm.org>
 <20210524025457.11299-4-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <c6fb1e19-b46b-d85b-ef05-1f018e31fe3b@oracle.com>
Date:   Mon, 24 May 2021 10:25:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210524025457.11299-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::1c]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:91:8000::ab8] (2606:b400:8004:44::1c) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Mon, 24 May 2021 15:25:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c07b2888-0411-4d63-872c-08d91ec82fb7
X-MS-TrafficTypeDiagnostic: SN6PR10MB2573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB257324A8854166CCA5BF0FDEE6269@SN6PR10MB2573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GzXlwMsjbshFakCfOX+4LR0E46OCgNkcmUmaLGWgVZEdViVNFtA8Aya9s5z0P51h9GYwoR7bAbh1YpALnQRaqlJDKk9/ZrjvFLioLJA1rykBAfVudV18F/kNuG0Vrf4zPJDHSpkcLyTAF46A017oWy0gopjDAYlKeVQHIiNM3sGtSa/yznfrIxCBrN9kFNVZ9F2FzR8dOkWc1xsvo9clbpLapru9q28fiFuqzdEszLSP6gneZQZaTHQ0o8fyJOyi3/Fxk+XDBUI4AwmC6JfCrd13noocP2T/NL3owRNPQqF2/rlKlhw7SBhpHLzlivtO8nwZudUDJbCuie4dRCAGYzV2COfOLnjEB+xgnmLfoBgRT+UJxyY3XrnJcQ2SuYdUqNfUVPXdDBmZyCIPIjsU2jzlhGJlxp9aAxNp4OPeb4T69ftjP2NaaIRbLe/VVraKxMosXCn3vFlYDyVJA6bX+ixjcixzdz4L04/ukjHAGwBeBwlxN4KUDEZ9ZaXGyw0MNHeGiqJEhuAMjIB0tzqzKU43N2NKSG/vMwCGxRhiMPfMpttMOn5cW9MQgbqrUZis+PKspy87nNFkqNrjJ4ODeu7D1D45SvYo8qQQ2EfKk2b6GIBoAOYhjZpG8KTep9kz/YdgIwZ0slv401AXfJVrjOTho6LwxuyBi8/6Fegfd0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(53546011)(83380400001)(8936002)(4326008)(54906003)(186003)(66556008)(110136005)(6486002)(478600001)(8676002)(36916002)(316002)(31696002)(5660300002)(86362001)(6636002)(66476007)(66946007)(16526019)(38100700002)(36756003)(2616005)(44832011)(31686004)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dEo4Q0dibHBOdmFGZ3MybEJtNUptaFVTZzIrWThhdmxXS0RMaVVXNmM0K3JS?=
 =?utf-8?B?c3VTbmJZU2pwS0EzVHFsZHVxMVc5Z3VqVWtFYmVnWUVKRVNnalBqNHhJa0Y5?=
 =?utf-8?B?RXZSeW04MHRUQ0VjT0lXVkZmemR5dllpcGYxcGhEZTBZSTkrNytYTVpudFlS?=
 =?utf-8?B?WU0zR1BWNXJEWE8rSVRkUU9peDJHY2N4cmZlaDNtY3JQZkc1RFVKM1VsMEky?=
 =?utf-8?B?SURiQ3dWTVVqZHRHaFJMcmZtN0lNL1FsR2kwOUVnNHF1a21YbWpWeVhCb3hJ?=
 =?utf-8?B?ZFJ2dVBqcDlZRmZ5dkRQMjdKSTcxMlRrcWxWa0c4SGZrYW5VTlBUdk9yTHhB?=
 =?utf-8?B?dURhMVlJVERvM2JNQXMxbG1MTEtHKzRUUWZZaFFCWE45SGNRcVUvQ2p3YVZ0?=
 =?utf-8?B?SjhpZW9jbTJHdW56Ykl3ci9vTmJDbTlnekFNckZjMVg1R1p4WDcwR2dKQlpT?=
 =?utf-8?B?czZjZmdqNk12Y0Q5TnBEdHpHWnE3Tm0zbUkvMkw3aW5MWitGS1NkeE1XSzlw?=
 =?utf-8?B?QUVRYWsvZk00RGJmdkJIUC9GVFdiNWNsNm9vY0NsMkRGemtySGZoSDF2UkhU?=
 =?utf-8?B?NzYzaFlWYzI2WXFCdS96ZzVLSTNOeURIZW9aclk1eHZzb0d3VnJuRWE0aGx2?=
 =?utf-8?B?TldnTXVqNGNpWUVONkx5N1kzQnREY1hBaTV3WnNEZnBnU0RYRWFxNXc4MlpS?=
 =?utf-8?B?RFNFbGRsY24xZWlLcVgzVDZVV2t6L2x6VUVUaE1IYVpsa2xqVkdmVTlCZ3Y4?=
 =?utf-8?B?ZVhkczZMbStzcFN1TXE4aG1ySWpCblE0c1g1Qm14WjN0dUFsVWtEWTc2aU5l?=
 =?utf-8?B?cWNMeDBlNzlBR3RDZitPRi9Ic1NscXJlUGNrTjF3ZisrM3VzU3AySHdMdU9r?=
 =?utf-8?B?ZzRpbXVkQlVZejVQWWU1RC9ReUlyVEM4cEZja3Z4akRrQ09vU1VhajZUeVBM?=
 =?utf-8?B?Nm1RVWUzOUZoTElvaittdjMwQWlGYTA4cmJHMjZsTmhxN3BsOHZkTWxlWUFk?=
 =?utf-8?B?a0pUM3dWRi9jNHRLandrY0lOVWtSM2M3M0s4ZUJJSmZvMmNLb3pXMTlUYmpC?=
 =?utf-8?B?eHBDRVFZYUhWNVU4Rlp1UlpVQjgvZkJ5ckVUVDh3ZUQzZnB4T3NuTGR1eDA5?=
 =?utf-8?B?KzBVMy9zYzd6bFhHVlM5UDBocmFnR2U5M21uaFE5VEVLdWY2N1BBV1hJZmNz?=
 =?utf-8?B?MHBDbEZ0WGZaOXFUMUNDRDMzZzJvTVdNL2l2UEErbTVPRURaYzFFYWZ2L1Vx?=
 =?utf-8?B?c0VKMjZNQzE5RnlCTUpENk1QdGRDVUN0dU9PcjRZTFFaR3JncytaTEpCQURv?=
 =?utf-8?B?a1JWYnhUbzNqOStKZ0ZMMnJKS0ZxN28rVExoeUhoVFQxYWxTKytxYTg3ZTdE?=
 =?utf-8?B?Q3RScXBDa01vZnBHTXA3OXlvMXE5KytEOHBzMmlDZXpyTFlFVjFPRTdrN052?=
 =?utf-8?B?RitOc2FqeDlzdmN6QllSLzJzTmdpVHJpWWkwSk9nN1pjd2RTbnNzZlZpMDFN?=
 =?utf-8?B?d3lsaUZJd0ZNajNCaGpIU0FJbElpOGoyUVRYam0vcHJtdmovb01sNGhsSFdM?=
 =?utf-8?B?cGRpU0U1SXlSdEdXSytPb2tZY2M5YldXR2d0MDl1cWV1c3k3cEs0RkZNaU1B?=
 =?utf-8?B?TzczUEhHLy9sYkFGVm15VG9KWWJBblhYbmZhMGpsOW1TUDl6QW44ZzBhNXhS?=
 =?utf-8?B?YXViZXBUTHNhWFRYSnErMUp4NVc0M3FuR0dJMGZSOVdNNzNUVi84aDlpcGF3?=
 =?utf-8?B?TWV1QVp1aXcxWmVYMWt1TkZWNWIyZ2JWWkpqRkdSc2t1TjYyNC9UdVFNM3JP?=
 =?utf-8?B?Z01Yc2pFU3doTGJFK2dXdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07b2888-0411-4d63-872c-08d91ec82fb7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 15:25:39.3604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0r4KUcgGR1KAkK7EwUOFubcVb6qMNpCPQ/n05skUFQeLiiI/JZBWWEh+rvTZBFhUWcA1b8Zhh8jyBsdoWr4uQs/3SU618x6Idwn8iepM8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240094
X-Proofpoint-GUID: 2z8eZ4iKOnr6bwON5Q9rT7U7mrAJmPN_
X-Proofpoint-ORIG-GUID: 2z8eZ4iKOnr6bwON5Q9rT7U7mrAJmPN_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/23/21 9:54 PM, Bart Van Assche wrote:
> Allow the compiler to verify the type of the second argument passed to
> scsi_host_complete_all_commands().
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c     | 8 +++++---
>   include/scsi/scsi_host.h | 2 +-
>   2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 624e2582c3df..1387a56981f7 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -655,10 +655,11 @@ EXPORT_SYMBOL_GPL(scsi_flush_work);
>   static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
>   {
>   	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> -	int status = *(int *)data;
> +	enum scsi_host_status status = *(enum scsi_host_status *)data;
>   
>   	scsi_dma_unmap(scmd);
> -	scmd->result = status << 16;
> +	scmd->result = 0;
> +	set_host_byte(scmd, status);
>   	scmd->scsi_done(scmd);
>   	return true;
>   }
> @@ -673,7 +674,8 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
>    * caller to ensure that concurrent I/O submission and/or
>    * completion is stopped when calling this function.
>    */
> -void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
> +void scsi_host_complete_all_commands(struct Scsi_Host *shost,
> +				     enum scsi_host_status status)
>   {
>   	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
>   				&status);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index d0bf88d77f02..75363707b73f 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -764,7 +764,7 @@ extern void scsi_host_put(struct Scsi_Host *t);
>   extern struct Scsi_Host *scsi_host_lookup(unsigned short);
>   extern const char *scsi_host_state_name(enum scsi_host_state);
>   extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
> -					    int status);
> +					    enum scsi_host_status status);
>   
>   static inline int __must_check scsi_add_host(struct Scsi_Host *host,
>   					     struct device *dev)
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
