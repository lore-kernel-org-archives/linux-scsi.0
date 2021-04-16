Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA337C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC1666008E
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbhDPVjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:39:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbhDPVi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 17:38:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GLTK7M042748;
        Fri, 16 Apr 2021 21:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=T1xYNgoWuQ0ocnOQ9Ybytnyclz5USeqXC2MPLwtzDDc=;
 b=n8UnJCNDjvpISmDILxGKJFsb8DYTbYyUsWYH1LuPEtS/WSc6uxIAuL7UVEV/8xPdLJT1
 pctLiy7Vfon4XJ3XDhQAAZFwHricG/rElfD7mlGqsHlF+dUe2CVR3j8oI4KDk121h9VQ
 yQCyOjZNhqr52rIIxtSZvpYqBnsMv/vfT2j/W9Fi6HOSg6ZTmtQ9iU8vBhF/vA2v+E7T
 d5NHG5DN8f2uqUbgxhF2wPf2UTOYotFclmLj9X5cXikMcZKolCbxdHb2sA0pRTUSWN6j
 6mNS2VyZbdRyXoKw9N7qLSJoTLXwGZEYEipGs5S3bA9yukV/mmAh9vLF2PscVMFL18k1 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nntbyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 21:38:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GLVgNa111290;
        Fri, 16 Apr 2021 21:38:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 37unsxsmyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 21:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWS2Q/PmQLzL5Vn1gISKyXgP5IAAM159iGGRvYpcS1Y4J5FHY4MvHv4Mhg5Uo33BOho04Ycn1SjyN95R6oVWjTYIf0u/y2ltehaRzz1+WGqXyVlxa30thXBzSLbSuganRmf4E7xYxqU3oVPH6Id00Z6gsnPsSZ9TnsgI7SiAQLiESaak8Pqn+mMDCxyAN79yZGZv8wtI3w/xRKQQOHv9CkvGn62nOZfQLuObIIlYb6TFYH2ptB/on7/w2UlGfQrDuCM2kzLeZc8pvXjcfnBNQYOXgwTYGDj+wTqxESc2e86s34NDPnyfHB5vpM6HqqxAi7TvXfHRNqTcm6zus2uhsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1xYNgoWuQ0ocnOQ9Ybytnyclz5USeqXC2MPLwtzDDc=;
 b=XMIGTWWfhx7F9jvlPfQ0pBoF0oHGH3sM7kNTgi/B4DynLLpgm1CDNXifUQCIxUXk/dPXX84mLqE1MFoP6lG5d97wstWWeFbuBHb1PBVMJuWKFuv7REuW+8esvkIZoOrGseWBRe9HRbL7VnSD8txHjatYowGK2CZ3tDK7N/Jj/l5K8BSYSKgMw2nWT+USB2uixhx7jvh4EP/ORD6ENZGE+IyPACfN2B76lDwNvPDIBMoRYOQdnvvrmqNUBP4yhp4yIVkYp767OR7iaJdNrIHZGTj8zsvz4QohwpiMuwf56EG5wPP9K/0aB+5z3Q2yxT/NfPn9y/mWcPJ4iSwnkU+Uug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1xYNgoWuQ0ocnOQ9Ybytnyclz5USeqXC2MPLwtzDDc=;
 b=HNFUXXlFg11Y6pLOxVoGlrpTQUdiWWF5lCQs1HfMjZHnZYjwTvcC6K4M8mhwtv17cxRvx5rrxUSN/OLKIX+6n3wImFlgzJGH25ataxqhShPsYOUq8ngA+N+w3sK8DQM+KLvy1gorchU+4zWIav48IFpfd5RjV/uRYZxY4MRaW7c=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3889.namprd10.prod.outlook.com (2603:10b6:a03:1b1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 21:38:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 21:38:29 +0000
Subject: Re: [PATCH v2] target: core: remove from tmr_list at lun unlink
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <90139902-5a5d-3e87-0b06-72f8acfcb673@oracle.com>
Date:   Fri, 16 Apr 2021 16:38:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210416092146.3201-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:5:100::44) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0067.namprd03.prod.outlook.com (2603:10b6:5:100::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 21:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df85afc1-740d-42e7-f90c-08d9011ff944
X-MS-TrafficTypeDiagnostic: BY5PR10MB3889:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3889EE4EB54689F0C742B5B3F14C9@BY5PR10MB3889.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7s3HWFO8gSW9YhGyDwdlk9AF3pFAFQtEfV7Nwi4y9X+kj7i6HVD6TAb4eQQ93SHef8KgktsJ1vDRtspqj6e69sZ1zGJ73DK6kSuc1KB4y6DCZ8/HYlh3cPgzRLVrZU8cJ9g+wmqAW7NFrrThAVf2uP2X4/mJ/6GOTCBLCyhkLD6eE4BP++o67cG7WpGlVg5Hf/UzBB00z3K7H70KpHvyUBosIrX72ozwYwrqUhzV7Q4OC+lGeFo8mTbt5DLNhlws5ioFWH7RbtGikwcftp/iWq7jDjzyQ3Huzjay32HqcMag1sCTyP+aQ79GF9L1h8ckFG15W3PHxxFcxmJPtqgvbRE/5J4DFTOXWR+jXoZGNhLYGbXjNM3eDLuSjiXOQZcFtXbPDey1pYAcM06MQmJMZAdYr2wRQU8bvHAP+KQyoF+Uh/gH4Xp86DjYMM8st3jU6c0wwfgqB2z4cihFnzlIKm1YWPmwIK89SuANsZOnCKY3YHgnjwr1kxFCTk3sqUlxvCZdAUrPgFHJNgVgM8AjLimHRLkk/CVDoqkfsHCe8J6DU41oAkSV8SvwDVcJRuextYkLshELCac3jKE7fqxx/9rGA7Ffpy9kIg4RFnog61PUwRTiy00VSzymN293dlcBcgWWi1ivwBJpWC6zsaQkNkorYkohc4U0ROjPqNWNcUTRd53lZwqFfKAb0Pr90S3OlHaCMEmh/yDGeL7jJ5WTnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(346002)(376002)(956004)(186003)(16526019)(8676002)(2616005)(66556008)(53546011)(4326008)(66476007)(26005)(16576012)(66946007)(31696002)(83380400001)(2906002)(36756003)(6486002)(110136005)(316002)(86362001)(8936002)(31686004)(5660300002)(508600001)(38100700002)(6706004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z2gxUzRWc0huNlZjUzNuRUJGSVVGOXN0U2U4UjZIMFRYVXY2YTYreW4xK0Vs?=
 =?utf-8?B?MG9MY1RDWVlMNUJ5bXNtODNiYklZVDJ3aDdLYjBvT3ZETmc3N1VnUGxmM2wz?=
 =?utf-8?B?NW9DVlExS1Y4Q25wRmNUVFA2YmxKNXQ4NC9QU3MraDF3bzVNU2liRUxhNm9J?=
 =?utf-8?B?Zi9yc2luUG5sQ1BYbTR6K0h6QWl2YjRscFM4RDd6cUdwTXJTUU1TZ3NyMVFC?=
 =?utf-8?B?MUpGTTVXMHhlQW1LRWNPTGhXeGU2ZEJJNG5IQXJhQlZucVJqWDZWZ2xBcFk3?=
 =?utf-8?B?MmkxbkxQK3lwaUFyUFJ5eTQzTlByeEhBbURtc2lWUkRHZ3BYY1VWN3JMOStl?=
 =?utf-8?B?RnE1QmdCTEVlNS80dWxvKzkxTlNNd3JOU0lSL3JaUENXR3NTc3kxNzJOaDRJ?=
 =?utf-8?B?M09kdnFSWWZsK1I2S2Vud0ZrYzZjSHZGT3VCOHFPc3liYlZTQUdjNzlaQVpj?=
 =?utf-8?B?T0pnc1U5N01vRzhwNXE0Wk1QU2lmWVNQSUUrS2hud1A2UTErRFJVQThJc1Jr?=
 =?utf-8?B?OWtOUkJSck1uSFJzRE13TVMzK0RpL3BRd2RPdW12ZlpDK2ZidUE4L2ZxOCtS?=
 =?utf-8?B?NjVjTy9zMjhaTE0yR2E1aHFGcW9vZjVucmt1cXJnS3dmRU1tMENSVHdjejJn?=
 =?utf-8?B?NzNFYWt0L2wwVktUcmdBckJUc1RRVzZhUHpuMC9NVzdVd0F0VDROdEVxa3dB?=
 =?utf-8?B?MjZzZTl3Zmc5K1E0VWU3TkRsczdjOVhOTEw3RWhrakYyaUcxYkV0eG1KOVg5?=
 =?utf-8?B?VFA4bEEwYkZLQjlDelREUzZ0VUROOGZDak15QmJnbWdFbXhTWjZkRHN2VFVa?=
 =?utf-8?B?VHZTK2xpZ1hROTh5OVhTMFBxb3ZPaXdHMExOTE5KREl4RnN1TmdrcnNmVThS?=
 =?utf-8?B?c3BXeGdvakRCSWhwazNVVVZ4cFhlQ1RBZHVuSmJhUm02MlJVRVNmV1NJZzJz?=
 =?utf-8?B?ZFpkWUxRTllKZGdDMjNwU2JuUkZJb0h0b3g2VXB4d3VMNG85SHVOUVhZOEZv?=
 =?utf-8?B?SktzYUxwMVBQT2RyZFBjYVV5UlgwVjh6Z3JBZkVydGdyZ2hTMVVWOUlDMFVW?=
 =?utf-8?B?M3JITmh5K01pZkNFRnpobVJxbmZRT1hXT0hvVUJhcFVLcXNtQ0JML2hFTkhu?=
 =?utf-8?B?Ukcvd1lmdGxBSGdrQ0VNWUtKVlJSN3VIMEtkY0tHdlNmUVFPaXVaYTVvenVL?=
 =?utf-8?B?SEpkSldWclloSkZyR05MS0plQ0lFN3QwS3UyaWU1NjhkRUd1Zk1LTGxPTkxI?=
 =?utf-8?B?ZlNIUllqUlJYYmlRT0hFN0tyMDVETmlwWlpDZnFPQ2JtL0dvRm9TN2hxekRj?=
 =?utf-8?B?NGtBQit4RlNDNnd1S3Z6QzBjSXFHL09GWmh4eVRFQ3lnUldEVlVsNTJuWE1n?=
 =?utf-8?B?d253anowdWlmVkFLS0lSSDNIRmpzeTJnS1FhQmVJbWxCNW1VTEQyRUFHdGZ4?=
 =?utf-8?B?ZzdsWU16NEhIdlNWSE5JMnVLQXVWMXMzZjBFQjhWUm1IajhocTFBVWlzeUhO?=
 =?utf-8?B?eE9Ec3UvUVNJQVVjTkRWaExUKzQzbjlQZERrbU95eGZrbDUvZ2JPTHJRWlJo?=
 =?utf-8?B?RlFMWDNMTnlpbzk3NmVCODRuam1IUEF0K3JrZVRObDk4Y2JibHBvN3ZJcG8z?=
 =?utf-8?B?ZStUVW9HSXVOQTFNS3QvRWVRMXR5aWxCVGpkOXJVZkpaOGczcEhhTEgrUGI1?=
 =?utf-8?B?YUxLV2hXY1RGZGw4WDFmZzRKTFYyaEd1U3FNYlNhWjJRWVJWUktDTHNzclh5?=
 =?utf-8?Q?O9u5WO/ZP+JGwWsinLlAYfl3NyybBgviJpZpiQT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df85afc1-740d-42e7-f90c-08d9011ff944
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 21:38:28.9395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F59nbYs1fKK/RGHabWykQJZirzHLgfpI5OeikLP3JpOuJVkdG+2S9fte8fIUGGjJG+RbCtUph0VbNqgaxZj+g9WltgCyYxauroZ4PfHytHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3889
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=854 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160151
X-Proofpoint-ORIG-GUID: GNYAdwDj9A5kiseMXU3e7JZ8zwccUpdD
X-Proofpoint-GUID: GNYAdwDj9A5kiseMXU3e7JZ8zwccUpdD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160151
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 4:21 AM, Dmitry Bogdanov wrote:
> Currently TMF commands are removed from de_device.dev_tmf_list at
> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
> up on a command status (response) is queued in transport layer.
> It means that LUN and backend device can be deleted meantime and at
> the moment of repsonse completion a panic is occured:
> 
> target_tmr_work()
> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
> - // - // - // -
> <<<--- lun remove
> <<<--- core backend device remove
> - // - // - // -
> qlt_handle_abts_completion()
>   tfo->free_mcmd()
>     transport_generic_free_cmd()
>       target_put_sess_cmd()
>         core_tmr_release_req() {
>           if (dev) { // backend device, can not be null
>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
> 

Sorry about this. I was thinking about this patch some more while
reviewing this version.

Is there another race possible?

1. We have a cmd running in lio.
2. The initiator times it out and sends tmf.
3. cmd completes.
4. target_submit_tmr has called transport_lookup_tmr_lun.
5. transport_lookup_tmr_lun has set se_dev and tmr_dev.
6. You now remove the lun and device.
7. Now you crash on the dev references.

I think we need to do a percpu_ref_tryget_live in transport_lookup_tmr_lun
like is done in transport_lookup_cmd_lun. If successful set

se_cmd->lun_ref_active = true;

If we get the ref, we drop it in transport_lun_remove_cmd like with
the non tmr case.

Combined with this patch then I think we are ok for all races.
