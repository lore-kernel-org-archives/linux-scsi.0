Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4F1C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiJCR20 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJCR2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:28:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0733B719
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:27:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOCeb019377;
        Mon, 3 Oct 2022 17:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eybmUwKCVf3RWSUTwojYhtl5sqJ31gRB+h86+xuQt9k=;
 b=OA8eDZP1BOD9k00d6jXqUuIWoUIZfDmu3gpdL+Be3S3O1DEIrKYR+Ewn1HvaKCe0Pjti
 cStKqzqnuZppTPDxDjnOkR+76/ArT1EUmTkPS+hUOqU0eJUT0gaSyrX/yusQfW0IXHhs
 CcHq4Ep40OQkh28EbH/sVxKxRqoMsIAoHuw0ykVaAmdW71aUzNLdmd45N3QtW7oJf6L+
 drRGOnxPIEpteDIT/YAdXjQXofWTT9XOSaxd0jLHx33oqA2WiKtSC1Vc7xfJgyBh/Ebh
 dTaYMhk+5A+H02OmEiiFoc/NBhQCEQn/bf6hLOZ38oJPUCXZbl0d3r6p2/TkXtIUbwTo XA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tmcc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:27:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FLv6O015597;
        Mon, 3 Oct 2022 17:27:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03fdcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:27:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnkEL0Ttxb33Ra+Xiu8bTrkjEHVwjZbrVy3yvzAQxG8/St8pFfyrpUnnXImQHKhFL+XpFU0v7Vzv/LDHl/YeuMiEDHib/nxdpLCSL1WXupxaoUvNOOpMHE1pCw7Fr1Jt4rQeDdp0LSfaTv811HU2JHy2rNQs1NEVGnnCm3ZRk7NlRnDrt3kFSk7rl0eB87FY5VK4vNaW+gNzJNNEySErXBekNB2wVO++3Br7TB5+PmZIQjmNhiB45U25GayVXq8R+hz3dAtFMnfjicTMoOKGHnACDZolMH9dy5n0N1mTIRnqQp7AaCXBeJOYrHA5e7zoVG3fCj5dtTL/IvkDHDS+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eybmUwKCVf3RWSUTwojYhtl5sqJ31gRB+h86+xuQt9k=;
 b=mslLDvDP18N+KsLgp+dbOSrtQlitMptfiFtdgynXnlc6ZxDKdlkaUa8o4NGN4Jp7kk1N665IB+SiGS+Z34SDuezsjwRWqrdEZ8AUpRD8fuhKUxvzUvN9I8B0D4gEYOYU41w0zOSPIlCSuDq8WENF/toJI88PDqE0t8T9YJIF+pBuSlsKl8eYRI6j02onf8ZaxMwT9814cW/nHMQ8X0Vs+EVArR4Reemt0Gr6w18UwAgkju70O47RYcHA40L8dnGJZ+UVN9xfaAsZCox7CQ1LVLiJc584odiqB8Zf1xQMFkBAQgw2PUdek9ap/7eAYhCcxNJ/422Ew+aKTyxWU+9eog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eybmUwKCVf3RWSUTwojYhtl5sqJ31gRB+h86+xuQt9k=;
 b=AEMizTI0Xcn2w3AQPWwnr9WPHZVcGbUZ2V9NOl684eBi3QfBfa4+5evd1u4b8FOP9s8LCK0Pb3QdsFaasr+XmLZ6VZQKP7nlyktMcixaBt78EnurHuoY5uGfH7fpx/ialWHcqTSdZ4BaAXr3TDCjVvtSqWkCRHApjwCgXzRh03k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:27:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:27:08 +0000
Message-ID: <9160ed4f-95a8-42ff-366e-f52d7816d8c3@oracle.com>
Date:   Mon, 3 Oct 2022 12:27:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 3/8] scsi: core: Support failing requests while
 recovering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-4-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220929220021.247097-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:610:60::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5338:EE_
X-MS-Office365-Filtering-Correlation-Id: a83d1aea-e421-4963-5e5b-08daa5647fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5fSMYR1V4Dej1CxI6EpNRzV8rnxp8h7RMcZrEgInEKVPRwMPL2VVEw9RMuF03nWwBNEdu5LA7p1rbGKiQIBY1+erzNx+sJWWLMEpqS/kjtOu2KfFLrnUD40LPiVVLoCNt3A5/WgvcHmq8f6jxr0pXXTh1QZDN2ZW1eNkvtgNieqNdzKSbm1VGTA8q0i91eBbxovdo6ZNw1rhtVP3tOY6R1m1G0IxWv8AYoNDHYBYZu8+uyfV6q38pi+jesEhuGPRLxcYZIJtDEOs6I9MK8/xrQF4Qkn3nmWebWH+6ljHBF20mvKoweZoB1mtfysqEdzSPvNk1784ZGK5MHWIqK/eGt2TukHYxLPUG264uo8CDjHy/fy5vFg4EqBWSKSshfO4pB0jxunp+nO6F4NIHs+HEIEMHYFnCjjhr1Nq9LDiMj4gvM+zJ8H9PRTIzUsMgSo6Oerjp250nH04kXfu+CJcAClisbuT32ItIPKP1cB5Bw0hYZUsJPysue5cjRR2U3bpzRBHt9saos/4IpP3WFVTyk3Gz5cVmJ7GPfg2+s4oUO8dGsAHkaEe57rrQ15OS1dxcu4Jo09IfZl5f001zc6YEDx6RFk0TqFMjw6eMo3yFRUcqbSuE4OOqfkn9GZbTD+HnLI2BpPAwuUezfZHGp6TOaxtZ0CDo3RuFjvVtinw3k/CZ7aLnq//Jj0ZIMdgH4M+BISW9KO4xqB2CVGM5glJ2POd1Ab73odR7GAjp4LRr4RPuavl9MZyO47bkYH2+O8mwzE7GGJO5UT7ah/0qzCacfioVI98ZkKCQertXDMf7C4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199015)(31686004)(110136005)(478600001)(6636002)(54906003)(316002)(6486002)(38100700002)(41300700001)(186003)(8676002)(66476007)(66556008)(66946007)(4326008)(8936002)(6506007)(53546011)(31696002)(5660300002)(36756003)(6512007)(86362001)(26005)(2906002)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU9kWEpETGxmQnN2NlJabm5xb0VCRjczZ1dZZmtLKzJMek9VOVVTQVNKdUJX?=
 =?utf-8?B?eWdyZS9oUjJ6dE5iVUkrMWlvTHZJbFFxNU85OThUWU1FNjdzMllyS3VrSHVa?=
 =?utf-8?B?Qy85VjVuMzV5NEtPVlMrdEQrZ3lxTHNKZG1tTWVSZ3VuSmRyMHQxN1lHVWJq?=
 =?utf-8?B?SE1JM1hqV1FkTzBZanBSWlRBS05aWFIvTTY1VkxHWVJjaklLWC9HWHdMQUYx?=
 =?utf-8?B?Z1BUUlF1L21Zc09udnJUWDhNUlJLTzMyUTdWVUNTb0FSSTBmZ3kvSVRybmxv?=
 =?utf-8?B?dEYrbHdZMGRWU2RYa3BvaHVFeVMyWFRYc1IyTlVxSEJyaEt2cFRtMDczOExJ?=
 =?utf-8?B?M2EwMndicUdqTG5FSjg3ejVTN2Q4Nk9COXZIWFQxMDlLV0FwR0tWbUtLMmNB?=
 =?utf-8?B?ZGRhZVBqRXRFWW80c04wMk1iQzRiWmtkR2JXRlkwdW5EZ3VHd0VUdXZCREtI?=
 =?utf-8?B?djU4ODB6VXZHWk5YNHZZL3NDcWFXTjdUd09pMGxOK3VKbXNQQlc3UGRnKzZ1?=
 =?utf-8?B?SUJFOW5mdElJcDBJa1VxUmEvRUE1b1NsMGJQc3ExUUdCQWxXMUh6TFRzZE53?=
 =?utf-8?B?eDlra29Da2w0cndxV1F2QzlCd2puQnNtMVovamdZL2J2TzBSaENwWDVNNnBQ?=
 =?utf-8?B?RTVDaGdFYUE3aFBaR1RVbW8vcm1KU1VTc3R5VWl2TllDSDA4bkowMHZuS3Uw?=
 =?utf-8?B?WlRDVFg5YUgvcWlkQzg3UFczOXIvS2g0ZGhrbWRmTU94NzRsOFg2L1lrK01S?=
 =?utf-8?B?cXk0YWhBbEdWZmkyajZTRDZsNERSajhiVnFkZjdrRHdNMGVyNzd6c004bnk1?=
 =?utf-8?B?dFVkNjZROXBZQnRac0hoN2JrY3N2NnZhVDBSdXRSajl3RURISEEzWGd6Yi9u?=
 =?utf-8?B?UCtFeU5VMllIaEswcXQyRmg2SDFwKzBaaTJqcnBFYnE2QlhvTjNsNDRNNUxN?=
 =?utf-8?B?cDF5U0xoOVJiU2xZeXNBNnhSOXdDbm9VcUhTbmN6Y3Z3N05udnIwNkZrZS8x?=
 =?utf-8?B?dXJ3VHJ4bUM3MW1zN0RMWmFYQ0U1ei8vbDVNa29xUm1RRHdFUldIcFI4cFNv?=
 =?utf-8?B?Q1JOME14RDJ5YldTOHNPOXVTcnZ5YUIrQUxGc01WSC91aVRsUDhEb2hVN251?=
 =?utf-8?B?MUt5eWVORWY1d1pzdTBDUkdWQ09xVHhReGFtODJ4ODZiRGFTaWl5SGNvMWth?=
 =?utf-8?B?dG4zTGNoV21hWU9IRitZV1ZaVGFQRGJjbng0M1BJcFFVOS9Jc3pjWC9RUDRY?=
 =?utf-8?B?MnRERDJvZkZnRk1RYzVFL3pwWjYzR2JuK25LM2tkd1hqN0R4M1o4akwwZjN4?=
 =?utf-8?B?K1VSdnBnOXJtRDgxRldsc2t4Qnkyb3k0Yk1LbVZRSFRPc0tjWkZ0OXZwdjNQ?=
 =?utf-8?B?ZjNBZi9SaHJ5Wmd4RHlIZXN5R0VKUzd4Vm5ncHRnekw4d1o4T1M5akhpNDBy?=
 =?utf-8?B?UjdUcldyUEpmRGxOazlsY3FJcDJXNXQyQUJJVXJsTWFuMVZ0T1BPMkZYY0wr?=
 =?utf-8?B?MUkyb2JOZ29aeDRta0JRY1dmeiszWFIwSkVqdWljS0twejFERkJCcUV2Z250?=
 =?utf-8?B?eVl4Y2J2ZkpDM1dqY2dvRjJmWW5mcWpjakN5YVQ5WXVnRmNseEd5cUFmcHdE?=
 =?utf-8?B?eGhLeXdZNHZrQU04YTVNY3dITHZtQVVKVU5JbFVWb3Jnb0djd2xINVNhQ29J?=
 =?utf-8?B?Tjg2VHQ4U2g0UjNWdjR2c2dabFNOSHZzTitFWFZhOFZpY1g2T214dE50R0Ru?=
 =?utf-8?B?MGdhbFc5L3lpTDlPTDNvdzRwbXpWK0JEYVU1bGdLNGYrRUZVMFp2eDRBN2hU?=
 =?utf-8?B?VGJsWWkxYnVQb0pQUWtVSm0zWFJqREpuQ3BZWU1LZWJuNDBVYmlLSktUTW0y?=
 =?utf-8?B?UDB2WEt1azBqdlZhVmZPbGNTSk5ySnRXRW9JaDZ5R0dLcG5JYU5OV3BsUHl1?=
 =?utf-8?B?VTlPcnV4WFZMdFdKbForRWtIVGpXYWtpL1JNSWN6T2paUCthVEU3ckRHRXNU?=
 =?utf-8?B?cnVtNWl3RjMvdUgzTnJudlZncmNRUmt6bENEbUsvVWM0cUpjeEszaGxTb0lV?=
 =?utf-8?B?L0M1ZHJDMFUxNG1kNUhRZ2pUYlI2bHp5TnVhUFE0NGYzb0hZTTZKSjFYV2pj?=
 =?utf-8?B?aFZWdGhUUTloTEY2MktQYThURGtJTk1idFhmZlIvVFpuWVYxY3BodU9EeFBD?=
 =?utf-8?B?UkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83d1aea-e421-4963-5e5b-08daa5647fa0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:27:08.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnMSrb/vbiAm8Bfuq1nSfrTWaTijO3ZHUMk/TgyBBBG+DSQRSlQtvRbF88Ey+hfUJAANQVGwTLkezXtcvg0t8dunByVz7sZyb+V+NdwxgNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030104
X-Proofpoint-ORIG-GUID: NXgvX3vADiWoNacANlCuwmSPABEBcg3c
X-Proofpoint-GUID: NXgvX3vADiWoNacANlCuwmSPABEBcg3c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 5:00 PM, Bart Van Assche wrote:
> The current behavior for SCSI commands submitted while error recovery
> is ongoing is to retry command submission after error recovery has
> finished. See also the scsi_host_in_recovery() check in
> scsi_host_queue_ready(). Add support for failing SCSI commands while
> host recovery is in progress. This functionality will be used to fix a
> deadlock in the UFS driver.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 473d9403f0c1..ecd2ce3815df 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1337,9 +1337,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>  				   struct scsi_device *sdev,
>  				   struct scsi_cmnd *cmd)
>  {
> -	if (scsi_host_in_recovery(shost))
> -		return 0;
> -
>  	if (atomic_read(&shost->host_blocked) > 0) {
>  		if (scsi_host_busy(shost) > 0)
>  			goto starved;
> @@ -1727,6 +1724,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	ret = BLK_STS_RESOURCE;
>  	if (!scsi_target_queue_ready(shost, sdev))
>  		goto out_put_budget;
> +	if (unlikely(scsi_host_in_recovery(shost))) {
> +		if (req->cmd_flags & REQ_FAILFAST_MASK)
> +			ret = BLK_STS_OFFLINE;
> +		goto out_dec_target_busy;
> +	}
>  	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>  		goto out_dec_target_busy;
>  

This might add a regression to dm-multipath or it at least makes
the behavior difficult to understand for users and support people.

If there is a transport issue and the cmd times out and the abort
does as well or fails, then we would start the scsi eh recovery. When the
driver/transport class figures out it's a transport issue we will block
the scsi_device. So before this patch we would requeue the cmd then we
would wait until the fast_io_fail (FC) or replacement_timer (iscsi) to
fire before failing commands upwards and failing paths.

With this patch we can end up doing 2 or 3 things depending on timing:
1. If the cmd hits the code above we will fail the command and cause a
path failure.

2. If driver/transport blocks the scsi_device first then we would hit the
scsi_device state check in scsi_queue_rq and not fail the path like before.

3. With or without your patch, if dm_mq_queue_rq calls the busy callback
first (this does blk_lld_busy -> scsi_mq_lld_busy -> scsi_host_in_recovery)
then it might see all the paths in recovery. It considers this a temp condition
and will requeue cmds. So in this case we will not fail the path.

I'm not sure what the correct fix is. Maybe not fast fail REQ_FAILFAST_TRANSPORT
above, or maybe add a new FAILFAST type that you could use?
