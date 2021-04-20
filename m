Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BDDC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929AA613C2
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhDTO2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:28:54 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:35953 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232450AbhDTO2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 10:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618928900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sk0jzUWcQTRQiG/ExiDfgZ7vj7eNGBP59uPzNGrqWww=;
        b=JVlz4DIkHm13zjgOyMskV/3JtJaHKhfgo8sPLLENkvEr35b1km3KIh2jJ+aSLfcBv51CBI
        SHXj5L4RhoJQcSdMBq7NEmNC7RMlkl6Tloe9pXpt4RAVTJVmQs0w501Q8D551EfA9jKoX5
        S2muCeR6HxhPxuv3ABfpaN1/2w8KDlw=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-EZN8035FNEa-dbfCzxZeDg-1; Tue, 20 Apr 2021 16:28:19 +0200
X-MC-Unique: EZN8035FNEa-dbfCzxZeDg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q35Pkav7S8Thof28KVjRKm9PE99fcP8sGE4WWVwz6giK3V0iCz9cGZcslCMPo3gDNUDgneHGBzVxg9obBLZonEpJEMXpgqdA72/XwwbcB0BLuj0oR83CS/j8kAcYs2De8qDrN5DLdb8Z3Etf2t2VY0If6XgTQZZ/o1sIfEcRHZefsA05HUvKXGGtS4F1XL+qsjiLyvOvmhvkLcgW0rJj/QVkMzH3qmlomzuohGbK5/mm79sSAtKqIoULylGyi+lX6XJE7tMVM+FkmGcN+T+Rr1QBbIIT3fb/HQlFnPel0wQfeGexZiviH2R59XdzZCqQtGrC/TWq165M7ullBBiDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sk0jzUWcQTRQiG/ExiDfgZ7vj7eNGBP59uPzNGrqWww=;
 b=ZUdSxEkCuSfaJwmX7o3OzVAXfQczYqBzlPEeOkmib/3VQpeQ30ZIeLuc/ALI4pwLV6hVutSvRvxxcL7D5jxdUqdjRmwlmMlQw+m1PCQA5EpmVU5d1maManSk/NDORI9yt/XRjXpHba68pDc1XZrh/wKFwsGkRA5orvuQOTuRAwa509mqLa90B5c2TAxlQS5bxVjfg5gKoPW8/RM3sDq4bM6ZPs7YMxCwHhIJoTF17YUJHJiSSIOUFV3GRqTuFy67hgtNfQnBtJgpf0bhPzXk9P5FzO4/fSfJdnol8oASueUzZ7dL6P8YIJrG3JoBBK/Fm07Kniev9Rd6w+MTz7Zd8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR0402MB3701.eurprd04.prod.outlook.com (2603:10a6:209:1a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 14:28:17 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Tue, 20 Apr 2021
 14:28:17 +0000
Subject: Re: [PATCH v3 03/17] scsi: iscsi: stop queueing during ep_disconnect
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a68ffcb4-73c7-cc2a-d90e-90993c44d043@suse.com>
Date:   Tue, 20 Apr 2021 07:28:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P193CA0012.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::17) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0012.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:28:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2596a969-1f86-47c3-f550-08d9040889fb
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3701:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3701385F5FA65F2F39E461CDDA489@AM6PR0402MB3701.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BlMKWT+WvuC8duztVL29Hvdfb32zuEJUUjOiBM8BGhVC9E0mD5hifQ6+UHFZWYEQdha3IJId3ERt53p8ZHM0UdUNyDoSene1du3AhsHP5+DVSKMxhxVM32nGeTbICbl3ffDmZzK7TFf738Z7yZaOkgxdq5Ls1l1AgbPsJJ2Q85Go7u/cWSqyged2LdmFfVaMGyvU7x0dTrp0wUiWUHqs2Yp9ze9QI3Z7NwFkmmoChOzfTytBCODM0rgi+hmbC2e8W37a19o8G44wf9ZW6wl01NOE2nQHlpbC4YL2VJDnJqk+lAg81kzAyu9seNnRuzwo1YrGMhd/5+X21duaIcZRkJR8650AuJ5UrStRuw4qugTVQsOcxa7HafkrJTy5KMfibgo4ABS9llDO4Hs+q9OsjJj4neHL6kQXBR8xA9Nz8694pzZVedmHA0DgoZJCA5fD9EIHywcwPD5mcNd5zzkdQUtChVnRYQNYjvDRrlA17AuW8XpD2OM6VcPkYYUQGvw/rYC2fewfQ2lR9ysNpvLk2NGAkQD0qrlBAZXLQqYT24smm+PNKCgU/vZ9klhMHQur1jbDDGFZo+mpJIeoEDZEPRBajVdCV7JMYN0FC4WRuLUa6ZvM3v7O4t3T8xJa0Gn0FMlMKZkIOZ08Vf6YE3ojqykuD1zCo/4fgCWYFga+HF0C2ZwHxbxwHeFapXV2+9e91Sbhwk5MDaSCeIRCDdRyfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(52116002)(31696002)(2906002)(956004)(2616005)(5660300002)(53546011)(38100700002)(26005)(6666004)(186003)(86362001)(83380400001)(8676002)(16576012)(66946007)(16526019)(31686004)(8936002)(66476007)(38350700002)(498600001)(66556008)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VXlsRlNlTzR2NjFzdTZ6Z21wVVBCdWNCMnIrVlRVQkVPbzRNVUZKcDNHK0dE?=
 =?utf-8?B?aFBqeE1UeHFqWDJUSVdiMFBkUjVvQXhuNmkwQmpDRU95ZkYxZzJFaXdGeUVT?=
 =?utf-8?B?elMzNGRkZ0JETnBidjBtS0o5UzhDMWFmOEgwYkNtNXJuY0ZySHY5NGNWd2U3?=
 =?utf-8?B?N1RBYy92OGhzQWQrRWpBckxjbDhCYXdSZ0RmZWN2M21BaVQ2bzd2VW56K21Q?=
 =?utf-8?B?blpYRVBKY0FpMUJ0MmZQeVNTSWpZdW5iMTJQM1VBaTNLcmtIUlNRbkJVT0tB?=
 =?utf-8?B?TlhLdGxNbjBzZXVYMkhxeENZUjVyVDlGeHU0dkhKejZHbzhhMEF6ekR0WlBL?=
 =?utf-8?B?b3YyR3pxZ21wSzdxY3docmUva3FlL2N3eEdEV0N3NjVyOHdwclpYTEc5Y2dw?=
 =?utf-8?B?V2hkOSthbVliamZrNW1KVFN1OUZEYXN0T1dQbURIUUZjN2MzczZ5TUdmRmhL?=
 =?utf-8?B?bmtXS09tODJ2T3JreC9wWjl6cEEraTVDWHBVVG1DdVVRUGFYNDZCMWovcXN3?=
 =?utf-8?B?TnFxY1V0Uks3aWNuSmNETzdsV0UvejNaNlkzLy9wT0VwbEVXMGQwZUQ2THZP?=
 =?utf-8?B?MXNWRHZVNi9VaWNmS2k1WXRDWE1QNnRneGtYamVMWXAvVFNOZk44aUNtOG5O?=
 =?utf-8?B?MUZkZlk3TkR5aFZWMkFrWm4zSjVTQUlTTlJ1M3p0WXRiTTQ2bHdkbG9zUWFU?=
 =?utf-8?B?RTdQWGFCYUZDamRWdVVrMWZBN3UxanNuZkJmVzZ6ZlBPNUlucWVCeWJIOG5Z?=
 =?utf-8?B?aFlwcldpSWV1OGhmU1BFZW1vTUN5S1FGL2tFV01zUFhTWlA0Zkd2QnN6allQ?=
 =?utf-8?B?Y2NlUmNoL3NUZlA2Y0d3V2R3MHFuUDd0akxBYUE5djVCY3NMR1RNVVNkak9k?=
 =?utf-8?B?L1lqM1ZjV3FnQlhaNWkrVXNzNzJudElBdjJybVFIc3FUc3loSkFQeWszYmZs?=
 =?utf-8?B?ejJ5REc5cXNuY0dOYzNLUi80c0lRa1RHZUtYT2syc2piMTVsaFdKcEdIN21h?=
 =?utf-8?B?UTJVdStkMiswcjk5ak5ZQnh6bnl3RW1DSGp2dWlmM0NuWmVnN002Z2hacmxH?=
 =?utf-8?B?aFd4VVZKVUJiRFU2Wm5xL1o5Y0ZUVXZXYmdUZnY5ZWJObTZlcEV0Q1EvNWd4?=
 =?utf-8?B?VklEclRYUk1FY0VQeUJTaU5MSlYwbkZldEJmSHM5ZzI3UWZPU0s5YjV0eUFB?=
 =?utf-8?B?QnhUemZLTVdYR251REVpRzU2Yzl0VjRVSzYzMlZZQ0JJNFdnQW5ad0t1T1hY?=
 =?utf-8?B?c2VjNlJiRHNqYnBYZ0cxNDNyTStZb3JxTEdkZ2JPTStIc2hFb3d2OWI3UnJV?=
 =?utf-8?B?K1NYY3JQM2NHM2RLYUZPdVZQM2x4T2orSHZKdmF6bUZRSkNGZzlzSEk4NzQr?=
 =?utf-8?B?aHpBdUxSK3RidzV1Ly9sVlkwMGhBTExVTjR0QmJ6Z20yREVYeU9KbkEvQ0d4?=
 =?utf-8?B?UVE5OXBYV2FKUGlrdmN3QlhJT2lXNTRzakd1bC9sdUdVMUdyZDdFRWtFRFJ6?=
 =?utf-8?B?NGNZYWd2cnRMK0UrWGJlbk9WTnVrU2ZhMDhOenZNSmdCT1h5ZWJ6U0cycmVR?=
 =?utf-8?B?WDk4UjFvOGl1YlFBN1lqcUw4ZkplOHlFR2VqQk5ReHMwZUxnMGJ2WmZJUzJo?=
 =?utf-8?B?T1U4MWV4c3A3WEtzQzJmU21FYUZNNjBwY3RSTDVqYTJ5dWVZbys3RUpzWFpR?=
 =?utf-8?B?ZFVDVFdEVTYvQlZEYWRpLzNJMDJxazF1UUF3S0t0OXZudk1Jd2dLRkN6cGpq?=
 =?utf-8?Q?XwPAghwrd7prpnOSloIB3v3Ngfi91Pm96P695/s?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2596a969-1f86-47c3-f550-08d9040889fb
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:28:17.3844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDdAGoglVDhEz3cGkpsX4JP2HRK3wLJC7KjDeL7aIWjCCoHYeY7vUVOBUhiyGk+jCv4NBn3+uiGC6nsSCwRWNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3701
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> During ep_disconnect we have been doing iscsi_suspend_tx/queue to block
> new IO but every driver except cxgbi and iscsi_tcp can still get IO from
> __iscsi_conn_send_pdu if we haven't called iscsi_conn_failure before
> ep_disconnect. This could happen if we were terminating the session, and
> the logout timedout before it was even sent to libiscsi.
> 
> This patch fixes the issue by adding a helper which reverses the bind_conn
> call that allows new IO to be queued. Drivers implementing ep_disconnect
> can use this to make sure new IO is not queued to them when handling the
> disconnect.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
>  drivers/scsi/be2iscsi/be_main.c          |  1 +
>  drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
>  drivers/scsi/libiscsi.c                  | 61 +++++++++++++++++++++---
>  drivers/scsi/qedi/qedi_iscsi.c           |  1 +
>  drivers/scsi/qla4xxx/ql4_os.c            |  1 +
>  drivers/scsi/scsi_transport_iscsi.c      |  3 ++
>  include/scsi/libiscsi.h                  |  1 +
>  include/scsi/scsi_transport_iscsi.h      |  1 +
>  11 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 8fcaa1136f2c..6baebcb6d14d 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -1002,6 +1002,7 @@ static struct iscsi_transport iscsi_iser_transport = {
>  	/* connection management */
>  	.create_conn            = iscsi_iser_conn_create,
>  	.bind_conn              = iscsi_iser_conn_bind,
> +	.unbind_conn		= iscsi_conn_unbind,
>  	.destroy_conn           = iscsi_conn_teardown,
>  	.attr_is_visible	= iser_attr_is_visible,
>  	.set_param              = iscsi_iser_set_param,
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 90fcddb76f46..e9658a67d9da 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5809,6 +5809,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
>  	.destroy_session = beiscsi_session_destroy,
>  	.create_conn = beiscsi_conn_create,
>  	.bind_conn = beiscsi_conn_bind,
> +	.unbind_conn = iscsi_conn_unbind,
>  	.destroy_conn = iscsi_conn_teardown,
>  	.attr_is_visible = beiscsi_attr_is_visible,
>  	.set_iface_param = beiscsi_iface_set_param,
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 1e6d8f62ea3c..b6c1da46d582 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2276,6 +2276,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
>  	.destroy_session	= bnx2i_session_destroy,
>  	.create_conn		= bnx2i_conn_create,
>  	.bind_conn		= bnx2i_conn_bind,
> +	.unbind_conn		= iscsi_conn_unbind,
>  	.destroy_conn		= bnx2i_conn_destroy,
>  	.attr_is_visible	= bnx2i_attr_is_visible,
>  	.set_param		= iscsi_set_param,
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index 37d99357120f..edcd3fab6973 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -117,6 +117,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
>  	/* connection management */
>  	.create_conn	= cxgbi_create_conn,
>  	.bind_conn	= cxgbi_bind_conn,
> +	.unbind_conn	= iscsi_conn_unbind,
>  	.destroy_conn	= iscsi_tcp_conn_teardown,
>  	.start_conn	= iscsi_conn_start,
>  	.stop_conn	= iscsi_conn_stop,
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> index 2c3491528d42..efb3e2b3398e 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -134,6 +134,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
>  	/* connection management */
>  	.create_conn	= cxgbi_create_conn,
>  	.bind_conn		= cxgbi_bind_conn,
> +	.unbind_conn	= iscsi_conn_unbind,
>  	.destroy_conn	= iscsi_tcp_conn_teardown,
>  	.start_conn		= iscsi_conn_start,
>  	.stop_conn		= iscsi_conn_stop,
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index aa5ceaffc697..ce3898fdb10f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1387,22 +1387,28 @@ void iscsi_session_failure(struct iscsi_session *session,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_session_failure);
>  
> -void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
> +static void iscsi_set_conn_failed(struct iscsi_conn *conn)
>  {
>  	struct iscsi_session *session = conn->session;
>  
> -	spin_lock_bh(&session->frwd_lock);
> -	if (session->state == ISCSI_STATE_FAILED) {
> -		spin_unlock_bh(&session->frwd_lock);
> +	if (session->state == ISCSI_STATE_FAILED)
>  		return;
> -	}
>  
>  	if (conn->stop_stage == 0)
>  		session->state = ISCSI_STATE_FAILED;
> -	spin_unlock_bh(&session->frwd_lock);
>  
>  	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
>  	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> +}
> +
> +void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
> +{
> +	struct iscsi_session *session = conn->session;
> +
> +	spin_lock_bh(&session->frwd_lock);
> +	iscsi_set_conn_failed(conn);
> +	spin_unlock_bh(&session->frwd_lock);
> +
>  	iscsi_conn_error_event(conn->cls_conn, err);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_failure);
> @@ -2220,6 +2226,49 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
>  	spin_unlock(&session->frwd_lock);
>  }
>  
> +/*
> + * iscsi_conn_unbind - prevent queueing to conn.
> + * @conn: iscsi conn ep is bound to.
> + *
> + * This must be called by drivers implementing the ep_disconnect callout.
> + * It disables queueing to the connection from libiscsi in preparation for
> + * an ep_disconnect call.
> + */
> +void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn)
> +{
> +	struct iscsi_session *session;
> +	struct iscsi_conn *conn;
> +
> +	if (!cls_conn)
> +		return;
> +
> +	conn = cls_conn->dd_data;
> +	session = conn->session;
> +	/*
> +	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
> +	 * complete or timeout. The caller just wants to know what's running
> +	 * is everything that needs to be cleaned up, and no cmds will be
> +	 * queued.
> +	 */
> +	mutex_lock(&session->eh_mutex);
> +
> +	iscsi_suspend_queue(conn);
> +	iscsi_suspend_tx(conn);
> +
> +	spin_lock_bh(&session->frwd_lock);
> +	/*
> +	 * if logout timed out before userspace could even send a PDU the
> +	 * state might still be in ISCSI_STATE_LOGGED_IN and allowing new cmds
> +	 * and TMFs.
> +	 */
> +	if (session->state == ISCSI_STATE_LOGGED_IN)
> +		iscsi_set_conn_failed(conn);
> +
> +	spin_unlock_bh(&session->frwd_lock);
> +	mutex_unlock(&session->eh_mutex);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_conn_unbind);
> +
>  static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
>  				      struct iscsi_tm *hdr)
>  {
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 08c05403cd72..ef16537c523c 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -1401,6 +1401,7 @@ struct iscsi_transport qedi_iscsi_transport = {
>  	.destroy_session = qedi_session_destroy,
>  	.create_conn = qedi_conn_create,
>  	.bind_conn = qedi_conn_bind,
> +	.unbind_conn = iscsi_conn_unbind,
>  	.start_conn = qedi_conn_start,
>  	.stop_conn = iscsi_conn_stop,
>  	.destroy_conn = qedi_conn_destroy,
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 7bd9a4a04ad5..ff663cb330c2 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -259,6 +259,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
>  	.start_conn             = qla4xxx_conn_start,
>  	.create_conn            = qla4xxx_conn_create,
>  	.bind_conn              = qla4xxx_conn_bind,
> +	.unbind_conn		= iscsi_conn_unbind,
>  	.stop_conn              = iscsi_conn_stop,
>  	.destroy_conn           = qla4xxx_conn_destroy,
>  	.set_param              = iscsi_set_param,
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 441f0152193f..833114c8e197 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2981,6 +2981,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  		conn->ep = NULL;
>  		mutex_unlock(&conn->ep_mutex);
>  		conn->state = ISCSI_CONN_FAILED;
> +
> +		transport->unbind_conn(conn);
>  	}
>  
>  	transport->ep_disconnect(ep);
> @@ -4656,6 +4658,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
>  	int err;
>  
>  	BUG_ON(!tt);
> +	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
>  
>  	priv = iscsi_if_transport_lookup(tt);
>  	if (priv)
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 8c6d358a8abc..ec6d508e7a4a 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -431,6 +431,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
>  extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
>  extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
>  			   int);
> +extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn);
>  extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
>  extern void iscsi_session_failure(struct iscsi_session *session,
>  				  enum iscsi_err err);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index fc5a39839b4b..afc61a23628d 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -82,6 +82,7 @@ struct iscsi_transport {
>  	void (*destroy_session) (struct iscsi_cls_session *session);
>  	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
>  				uint32_t cid);
> +	void (*unbind_conn) (struct iscsi_cls_conn *conn);
>  	int (*bind_conn) (struct iscsi_cls_session *session,
>  			  struct iscsi_cls_conn *cls_conn,
>  			  uint64_t transport_eph, int is_leading);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

