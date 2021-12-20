Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7E0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 19:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhLTTyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 14:54:25 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22846 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232937AbhLTTyY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Dec 2021 14:54:24 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKJNrWR013036;
        Mon, 20 Dec 2021 19:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZmeGw1RIXLUBQLuWFSyUszMiSw2dQl4aSkOmLLS+W7w=;
 b=GYWTKs3ItN/C8fVTmfd7xRWy34p7/3FbrQWIzGx84FOyMraIvdnAefJ48hvehnKdVp7k
 EYNdsT64ay4fSZeUfPVCVgykf7PjplBzF1wsGleZAVubTB1799JPQEByMIPG6JklIGeh
 AR03OzIy6aMXJzAJOTbiwhP2S114/RRs8wO43VQbFY/dq2YY5qYDH6JNblGtUfwrcHgz
 vbjz1j/5vJC1ELq9XIAmCu5F+95BpU4MGYCYZg/6llGHeFQ5OmLRq+Z0cUADBFG2VCBo
 9xPtEMSCuCQXMwM/SldSPS29yrYDxBzSHjthkF1blplQjR2550VHteeE3xX5q2lLcmB2 sQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2udc8ywf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 19:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BKJos2H001812;
        Mon, 20 Dec 2021 19:54:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3d14ruhfd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 19:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMvX3yDYxLwkci8vKDYHVnYN3WAaZy8DfzYJxyf1TxLrumaUDVSjiVK5gEoS/sUOq5rOjB4k3X/r/eARsTKg69GB2fvQmm8mIRvLKL+UgH6x/ZpWj3rrqOmF7w62sfR35JxcTKBkywu4EoC54tLnFDOroTQ7jJGOb480+1o/J3JIeyO5XiqeJBsYHC80XsBCcIz4N+cVl0Xz/4IqcL1UvP8BWMVSS5QCZVwRt2IoZRLa91clIBFQnlfltL+6KLXScmhoXIbyMvzEU2KCY/NdYq3JbTRFoyyszuWqx+59L3asnV3pnFrLuw+PJx5GzQdgzk/OkdsuEJtJrWxCuLVM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmeGw1RIXLUBQLuWFSyUszMiSw2dQl4aSkOmLLS+W7w=;
 b=gEp8ktEdRB0ZkqhAwRWYUcAj9OLAai/Sns1cJ0GRBDqjLwf3XZJxs90/4yXKLTQSQethkm1NDL/FucMjKBpVoJzkiQjlsXAf+AljopnAO5LsqIEUQa1xoJqZ7aShhPV6iDhGajYFwNR3sA6nYtpB6B7wWq1tGQxvHiBqfxf5RFwYebqMb6/NbGVvyO4sMzbCm1g6pw6WkFaxRlOef95OtE69DTi0NyaxwcXAQJhwKUOaoeubmbSpMnPMYIk6szJkmWcSdM+rbPRLEPM3ZxP7wHXRJTyZLJZKDKCSNGEWGD+doDsm6z4Sh0X7dESUir8sh0f4y+QFPWOmdITyPHMWsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmeGw1RIXLUBQLuWFSyUszMiSw2dQl4aSkOmLLS+W7w=;
 b=Ihx7NppPp47DpnHRcj3QgoqPfFhmgAkulY7x50x+byaQyHPXFHIEOAW6GNOZUJOLB7gar9Gn5N0kqEWQ5Hh9MkWDp+8P759REq0Gv8PxAWPFQlQMzy4ZV4eQp5mAfEtg2FSEhSn845+uJ6whCnWjAWKhVQCysjdlBVpwlcdx83A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5261.namprd10.prod.outlook.com (2603:10b6:5:3a0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.20; Mon, 20 Dec 2021 19:54:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4801.020; Mon, 20 Dec
 2021 19:54:08 +0000
Message-ID: <f38ccda8-f9e0-b2f2-01ae-5d9959fd02b9@oracle.com>
Date:   Mon, 20 Dec 2021 13:54:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] libiscsi: fix UAF when iscsi_conn_get_param and
 iscsi_conn_teardown concurrent
Content-Language: en-US
To:     lixiaokeng <lixiaokeng@huawei.com>, lduncan@suse.com,
        cleech@redhat.com, linux-scsi@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>
References: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
From:   michael.christie@oracle.com
In-Reply-To: <046ec8a0-ce95-d3fc-3235-666a7c65b224@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR12CA0048.namprd12.prod.outlook.com
 (2603:10b6:0:56::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edcc6f9f-8bc9-4641-c745-08d9c3f27c37
X-MS-TrafficTypeDiagnostic: DS7PR10MB5261:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5261A37257B2759D910FD3FEF17B9@DS7PR10MB5261.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:37;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPgKQQ2+dRcmhQyQ4L2uAmajJPY+GBlxLjCrruEe6RbKMo5PPwJC5XkRW5xGrPYH7iwRHiSEaMSahkHzKB/yzjYDHCeEQ4wvIwIelK0sp7NxUso4nYdcdYPWnDE6cM8jrE4GCg3InYEqy1Pg65sN8sD1jMAsRT8VqaSrOftfk7pt0HaHW8IFqdK8FTD6VkREKEkGVBcLAAKxhLOKrOEOJ33gJpTGVJ/XV0yTrErL6b1bhUMIqMPvvX78dNLVQYg32KU4CP+BtUSsXkRd2YkjXIEeKK1LO5axqobDTwAWlFtUbOwHZAPpNNg5cFc0LeknOIp9qaacRmzWrVZugskwqSjbCzTg4ENzKc/ej1h30+vFRFt7AD8jjQvEWKMcY3wSNcG3ESQsaBahcMek9o0V4nVPSMiNX5kqoHs8viETBR0Zt9Kr5Xl37cjzDopI0bhLF1k3gRmKMBlMyr1Vfk4030K0BrJjjBKSdBNJN2WoUWwUyM+k+2cFNsNyoHjJzbzKW9A/83IeKMWFYo/fuBP84DgvSe3c266EbmKczyLYiTpscxbKntzKk6MCnkN4VskOFRPOvdQ/cHIedy0UCcz4jYiZ3+PfLPr2SUSMyF+j/U1zZpo3KT1H+k8YA8GLN6BTHGjeMb5IwWkv1vTTj1R1JNFELogwVjp4XUMb3ilhRXYmQlpjdxB1JvAYZQDw5ucdl1P4NljQeW+faSfDNcBW+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(2906002)(31686004)(4326008)(6506007)(26005)(6512007)(66946007)(9686003)(186003)(8676002)(53546011)(316002)(6486002)(66476007)(66556008)(5660300002)(508600001)(8936002)(36756003)(2616005)(86362001)(38100700002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEdjUnlPRUhqS3UwVUhsYVd1UWNMR291SWtpWDlDOXNwUGZzZjZRWHJtSUZC?=
 =?utf-8?B?Z01yZzVoSGJoNnFQcFJUS0FoTDBvZStrWmhyNDlaZXNreEVWVGZLdEpLTmZ0?=
 =?utf-8?B?OHVaZUZkS1lxQnora0hyUGsvcW4zcnZ5elROcGtxaFpjazdvQTRZbEozTklD?=
 =?utf-8?B?TzA1SmNoY2Rpc2l2Qm1qS2VPS1VVQlBKTVFPUTdUb1JZUG5lR2pQSW5JaXIv?=
 =?utf-8?B?QTNVdHVVZ1Yya3hyZ2hxa1ZUQlFFNy9RK3plaS9vVlAxMnpSdFBCb2I5MXdt?=
 =?utf-8?B?UTJveUNDc2cxR2FDbXZyZzBGVlFZS2JteEpDcW8yQ0dlWnRsbDZibURLYkFU?=
 =?utf-8?B?TGl1OVFOZ2RsWVJubjNYKzBuZ2hwT2ZqOFFLckV0d0FGcVhaaDB1TXVmaTQ0?=
 =?utf-8?B?a0dvQjdOMDJ3TVc5U05NdjJKUWlnREZuWTByaGFkSTV2L0Y5dXJxbG03bWU1?=
 =?utf-8?B?Q05iR0svVkNQMkVXNHFVZjVVZkh2T1pPaWVyaDV3MWpVUWVocnNXVjJRQVc5?=
 =?utf-8?B?cVo2MW4rSENIN0Y0SUhydmRjeVNOV2hXRS8xcUxyRUhJOFlMNkFTd1ZZcGRH?=
 =?utf-8?B?NFdOdzYzVnRsdGVSMWxONVRVbFNFZEhKUDZJcVRXTnNMaGN5ekZKMTY4UGNo?=
 =?utf-8?B?cS9rYTh2a0Urd0Z5MWV0bW00a3EwQjVhMmJ0eXgxamNnOEovaFdaMGdPcUM1?=
 =?utf-8?B?WVdQQWI5SmFYcUFPcTFQVnM0K2owNXZtRlkwdnp5aDgvem5tWFpuK3d2a2NV?=
 =?utf-8?B?aFB6VUxDU1ptd3k5TkxQMUNaSzNieG5lVGRDUS9Mb1RYYTF0RWFkRHRjYlVj?=
 =?utf-8?B?VlRHbFlaWXRzTnNGd3FDbUd4T2tDdWtaWjV0L0lvSG0zSmlvOGtET2M1bzl4?=
 =?utf-8?B?RlphNk14ODlyTGQ5VStBZ1VERDdjeVM1SFlDK1RsRWVnU2dENDBibTI3TkY0?=
 =?utf-8?B?Y0wyREM4U0dkb1NOU3J5OFZXQXhXakdiY2x6RXY2NTBnNHFtRGMrWkVwREZR?=
 =?utf-8?B?dERqUzVMUE9XdzdmT2UvZ3NKWW91QlB3QlNKWW9IY1hPVXFXa2F2MXVUVndO?=
 =?utf-8?B?R1d2UEtRY2tDZ21ORGk0YnFYRGhyV0VWeER2U3dBODJScjUzZFR5ZmV1d3Vv?=
 =?utf-8?B?c0NLWE9zSjl2NkEwNVVPbzRyV1p0UTF5WTNMKzNhSmpqT0VGeDBXMUFhcDRo?=
 =?utf-8?B?MXkyVlkzdjloYkxFdWJxdHBuQWx6dXpacjBLNTVYQk9tSmJMRTF0T1pnMGly?=
 =?utf-8?B?WGtlVWlFN1ZmRHlSOXZIODZDT2F2OWhnYlI5djFDNGd5SnVkZ1hKeHlXbERI?=
 =?utf-8?B?YTZGMWdTTUFUekY0UzdZOWRYNHF5QnhxZmJJejNLL2ZVOTYwTjR3SjJhYUNS?=
 =?utf-8?B?U215aUJrLzEzcXhMcjZOeEl3RFNNVkVvRGd2OEZGL0tmaTVINi9jS2Y3bHpV?=
 =?utf-8?B?YnVmaVNoYVhkT1JmR1lLRGFGUnBZQWN6d0I0Tzk0azdQb3FqWlEzQ1hQZXZQ?=
 =?utf-8?B?Uk9sSFNVejR6eUxKQ2NrUVZWU0RJZkRZRWV4SjRkeGZmV0t3SUsyT0lpRW5Y?=
 =?utf-8?B?TTBnYjFCT1d1bU1kNWpYSCtkbnRiVXl3dDdXMm83cWVwYi9kMkQ4Wk9IVHIz?=
 =?utf-8?B?b3hoZmNpU0haK0RGall6VEdLUUV5R3p2MGN5S3M0UkRZVlFsUzFmMVdSc2o1?=
 =?utf-8?B?cjlrNDBiVitBL2Z3ZVlPZG1tN0gzVGZsSFoydzhNUEF1UERObFdmT0NUMFRN?=
 =?utf-8?B?aWVkbEhLNnlhZGVxQUt2YTByczk5cVc0ZTlsd0pQLzhnVXpaanR6c3hVM1Vm?=
 =?utf-8?B?ZWxnVzhrL0M5Wmk4dENSaVNKMXJEaUY2Snc2cGdGYm1Lc2IzQlZTT3RMQlFE?=
 =?utf-8?B?dDZGMXNCVDJxWlVsZzUvNVBBMndHd1RETlMrNmNjMHBCZjA0TjNPWHNJL1FN?=
 =?utf-8?B?U21zdytsMHU5VmtwVjFyWEh1V3FBYkRYcTQvUUJCWjhjaDUxWExGcTcvQy9D?=
 =?utf-8?B?WmVzbzFTZ0hLZGtFMUN5cWwyWEVQaktaMm0wcERaQzBsa3p5SEQyNkRqalg4?=
 =?utf-8?B?SlMyT2x5b2JJaCt3MUNraDRocWJ6bW1qMkZ4Skw3cGdQRjRCOGxmQzUxUmZa?=
 =?utf-8?B?VkZyYzBHZTU5L2RzTCthc2VYMkg3eTJNbzRxeURVSEtQNFVwS1dXK3NqbU5l?=
 =?utf-8?B?Y0g2aWZQUUg4eVZvaGVTSEVtUXl3WDRDVVJuZW9nRkpmc3JOUnZ4K1JkVzEv?=
 =?utf-8?B?aU00Sk5OajgyYjZ3bEozRWgzUm93PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edcc6f9f-8bc9-4641-c745-08d9c3f27c37
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 19:54:08.4567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EsHqqYpy0T3GnZQDYz+iF2y3PYADLRgcXPVOdHCVow/zKu0w0lhgpN/8WO6kNKQbSfajIrp9Rzwg1LECi+Oiv2qyHRzRmUmOdPT1BUwPZ0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5261
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10204 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112200111
X-Proofpoint-ORIG-GUID: Jf9aNlbKjdcaSProD0XAnRwvm0UcfHjv
X-Proofpoint-GUID: Jf9aNlbKjdcaSProD0XAnRwvm0UcfHjv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/21 5:39 AM, lixiaokeng wrote:
> |- iscsi_if_destroy_conn            |-dev_attr_show
>  |-iscsi_conn_teardown
>   |-spin_lock_bh                     |-iscsi_sw_tcp_conn_get_param
> 
>   |-kfree(conn->persistent_address)   |-iscsi_conn_get_param
>   |-kfree(conn->local_ipaddr)
>                                        ==>|-read persistent_address
>                                        ==>|-read local_ipaddr
>   |-spin_unlock_bh
> 
> when iscsi_conn_teardown and iscsi_conn_get_param happen in parallel,
> may trigger UAF issues.
> 
> Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong<linfeilong@huawei.com>
> Reported-by: Lu Tixiong<lutianxiong@huawei.com>
> ---
>  drivers/scsi/libiscsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 284b939fb1ea..059dae8909ee 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3100,6 +3100,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  {
>  	struct iscsi_conn *conn = cls_conn->dd_data;
>  	struct iscsi_session *session = conn->session;
> +	char *tmp_persistent_address = conn->persistent_address;
> +	char *tmp_local_ipaddr = conn->local_ipaddr;
> 
>  	del_timer_sync(&conn->transport_timer);
> 
> @@ -3121,8 +3123,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  	spin_lock_bh(&session->frwd_lock);
>  	free_pages((unsigned long) conn->data,
>  		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
> -	kfree(conn->persistent_address);
> -	kfree(conn->local_ipaddr);
>  	/* regular RX path uses back_lock */
>  	spin_lock_bh(&session->back_lock);
>  	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
> @@ -3134,6 +3134,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  	mutex_unlock(&session->eh_mutex);
> 
>  	iscsi_destroy_conn(cls_conn);
> +	kfree(tmp_persistent_address);
> +	kfree(tmp_local_ipaddr);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_teardown);
> 


Reviewed-by: Mike Christie <michael.christie@oracle.com>
