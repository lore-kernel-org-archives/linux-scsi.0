Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAA9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiDHRXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiDHRXT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 13:23:19 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC622BE6
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649438471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdLJr+EQtLck2rxUqOsFpGibnDVE0UHBxk26I+M7Ybc=;
        b=iRcb7Azio/XCWzNtaRkYK/9QFzJPkjV1eaIHJ2hU0UmghPpT6h1MlNA0iSoGGUewVGGSxL
        E4q74x1cCHuO3q+Q+AQ5/Jr+RiKe/uUKJ9DdxUc9U5TJhK+LFWkeiMmOUPQVCnPtj4yXSN
        CVkfX+VZMAtPVHK5AKR53wOecyqsT3M=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-15-Edizv0tBMw6srRTlVIzu9g-1; Fri, 08 Apr 2022 19:21:10 +0200
X-MC-Unique: Edizv0tBMw6srRTlVIzu9g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdtECK2caWko2Ro6/MFHbBYluBSZ0+PLCa0V7RDVVAU5Sji3sRhUr79a57J57fH/0H4LUAxScDQ9LtoJ78zRGIRpWOIt5QqRA/k1P8sZ/hUZsbUALF57P/WeiiC0XNLJoFZ5xfLUTx212b2e0gR6kQWXObrCkv3DhaNHNX13toCb9GrQRNUC299HrTDCDOW+KD+YEQp//m+h3Q/o4CRP+SM00IY6PTAx9pPgpZMQ48PX9TR8PySkMUdZ2bliTZK5xA0TJfonsN47CZWwHvldfoRwSrYT/ATrIIwqFmFZcLg8YAhm5FIBUTakjd3z4xSXgfL+6AiutYfPE2WeWLQLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdLJr+EQtLck2rxUqOsFpGibnDVE0UHBxk26I+M7Ybc=;
 b=lC1r3afZhHwKY9UVreCqhR16HgHabXBhgK/4bVICWjI4t0AKUpQI9SKWdU0Ts+HG9dzcTqDy4fBxnzjEuVFLde32y5z8xCe1eB7sL8+LZm0hBQ7fi1BfaqgphOtXKLOHlP4ocYWdxVKmP6lPXyj7KRwNbfuePOURVaTj3d5oX3dfb861JGT2egS7Ft+UXZEcJcGs8YDI8m4jYqvLIWarZc5nmbN905Yd2JaeB+UIjHCtLwNKxEBHNnuSrAJRreIsBykCkl1tE8F38HidfiAwYeLbrlYxetG/XGYaQqMAVQo2aKb1DLZLmWXcis8yh9KFEIbC6SaZYIXj8gqxWbfY6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5192.eurprd04.prod.outlook.com (2603:10a6:20b:e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 17:21:08 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:21:08 +0000
Message-ID: <abe613be-aaa2-3dd9-1573-54eb44819de0@suse.com>
Date:   Fri, 8 Apr 2022 10:21:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 02/10] scsi: iscsi: Fix offload conn cleanup when iscsid
 restarts
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0187.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::12) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb20b6b2-68f3-4996-de15-08da19842b3a
X-MS-TrafficTypeDiagnostic: AM6PR04MB5192:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB51920EE1E843799E8DCE3B33DAE99@AM6PR04MB5192.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DGpsbjeVSOMsMCTu4+XFLmkVKghrnw0aM4is5SYeTos71DU7rq82ncpwKqbaU1m/BD6J7bs8Y/s3SFHzgh8jqFwnOIZodsxF1B3cWcIMdpuPeFYtOJKyas2rc2AY/swhgzz8fOqz2Hqp0mShKqaLt6MqBfnBdpvttRNOr5fVo7pXLzlPq3glf6guF7sOQg4dGBkf6XeJue5CZUIRRslMHKKgrmZw4LD3o1rumIjk/EbEJB7YP3Syt8QgslrlgMTmdVN+ndIItnKl3/xeU99KtEbzzQKNG1/6556SdtY52W89dx3JE6zuOibxuIRiQBS+K/l8tF+5a1M95KcX7oQ96vU8E0vfWtGKzhyDsd/36m0p2VbGAIoc0Y0ndwgxwbsKkgdL/37Ld/sM7WK+bTtzc7CE9+oLSP4sejk9yfWB10fNsZlYv69ghVGhx4REYf5hXnFPWsSEIq5ip8iVLQuEmJ0fFJw9+00PG84RZJYVMUeVqi+B0Tom476kQvsFSX2JzfRl/dyDqBLf24z1Vj9PiKaV4sbpF4qOr6714PQi8Z/NjBeufqSj4hZCjvnqIr7d5gCs2t+XMR0PfJc+wn3MwrzNZIZZu8DG0Sk9xxsbgSQkCkFoZFSnjt0qYDiyxqIy8U+CcKIKhpvP7Mt7OiGgIVzra//rFxp7/QNGLuM7lFl4/Nm5+nWjp4Mt4B0/LYL64TTNuJEU2YwP55PgRxI+rkjPsd+qYYYd4C3TvPwxFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6666004)(186003)(6506007)(8936002)(5660300002)(6512007)(38100700002)(86362001)(508600001)(2906002)(31696002)(36756003)(31686004)(83380400001)(316002)(66946007)(66556008)(8676002)(2616005)(66476007)(26005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXNBMzBiOGwrdDR2bXhsL1BOdUptbmpBS2x2blZFOFg5V1E1ZTlWZWxFNUdm?=
 =?utf-8?B?czJjNjduMXN0M090TU0wMGlTRmZ4OTlCKzg5ZGRDK2h5dHZYUFBQN1l5THJq?=
 =?utf-8?B?S2tUTCt5d2ZjTUJXUUhVYzA5U2l4M2JTbVpBeTZSampPOW40VkVEL3hLeWUy?=
 =?utf-8?B?RHZ1NmZ3SWJ6bUxzUjJSbVRLRXNOdllPQWMxYWgvem5xSG8yd3BMVTZYV0U4?=
 =?utf-8?B?bGRIRVFFZkczV1BoVWN0WWtnSUY1Z0ZGTWQ0STRWeit4Y0hhZnRXQUhZY3FF?=
 =?utf-8?B?TkRTZkwycE5xMXBvbFZkWmZIVithK2R5Rys4NTBzUS92dlZ1cFlpTXVYb0Yx?=
 =?utf-8?B?Zi8vY0Z4dDFnUUF6bVBzWmRBNG5Rd0NIV2pBV1hOTmszd21uTDdBS29HMmgv?=
 =?utf-8?B?SEkybW40OVZrVkJtRDdFb3R2K0laUzRzMTRrR09pbkpaOXhTbklUZmwvWFZ5?=
 =?utf-8?B?MVkwVHFncU5icVloQmhDQkZTTlZpaXFBRjdQa3pYbjRaOHYwejdPSm9TNUNz?=
 =?utf-8?B?dlE0UnArTCtlNHdzUThncnZhdDhGVFNkMWRvNXR2QjZRRWFGS2NIUHVFWFBD?=
 =?utf-8?B?NDRMU1djSVNqM3QzZzcxMHhjQmxJSzFsbVpTVUN4bkE5anNmVk9UNFUyam9P?=
 =?utf-8?B?OHJmQ0FieUNGK2lZWU00RnlidXQrT3RlV01rR3hYYkRkcUxPclRqbEt2MTh6?=
 =?utf-8?B?ak1MWi96a3FCbHN4Q1h5eHM3c3ZqUDJWcEg0SDJjZ1dYcFNkdSsrbmZmY2hF?=
 =?utf-8?B?RWUxeUp6SEtkVC8vV3AxSFVCNkQvUSt0bjFGQWJTS21UZE90WFF5NER2cHlS?=
 =?utf-8?B?d0VuQy94eFR5L0pEOXdkYWhMNWpYengxN3BzUG9TbWxVcGg3K0U2clpVd0tR?=
 =?utf-8?B?RVd4bWszMzVFQ1c1Z3prMjhJWUN3RjRrblhxVXoyMmZOMGI1UXpXVXljRFdG?=
 =?utf-8?B?RCs1UEh5US9tNFFZVjh5eGdENGpiSzJpcTNUVTExc0hSdHg2M1F1Vk9IaUk1?=
 =?utf-8?B?YmxzYVdXc0JNKytCVEJjUVFtdy9QeG1MNjZ5d3NMOCtWWEtOUDNGZEVjNWpB?=
 =?utf-8?B?SUVtVnFWOXgrZnhRaEkrcFYrU3pPUkJNYnQ4NkhKN2pPemdIbjhwZVVuSkhz?=
 =?utf-8?B?UjZWd3Y5dno2OGxvampUeXNGNjNXcFM5RFE5Nk95MGJ4NkVCU2pUY2V1UEow?=
 =?utf-8?B?blI3V1NKejM5MFQzejlXSU9OOGZyY3JnYnNJYkQ2N0h1anJaMEFIRkY2azFm?=
 =?utf-8?B?NGFzTmU4T2FWdThCMnE4UXo5TU9GcUs0S3JkM1RMZjUwWmQ4cGppdFNqblhs?=
 =?utf-8?B?Mk9tMVZyaEptV1R5QjNidlNXMVNUZXdqa3lkSUZsSzVKckNoZmtqQmQvY0Ji?=
 =?utf-8?B?Mnc4S1VDWWd2RzJGOGpJV2lrNkpiK0loSEFTMTNLZXBtQmZjeWZVT2dsV3Fz?=
 =?utf-8?B?dy9xWDZqM0l0dENkaVlDM2pYcUVvdCt5RFh2NDVpbWVOM2Z0OXk2azRKSkV2?=
 =?utf-8?B?VzNRNVQxQ3RIS21aYUhBSUJXVUNUb0V0YUJMdTZ5aStUTkR5dHFMTWppS2NT?=
 =?utf-8?B?MjZ1VVFabUNUSnJscmlFbUxrUmlNa011aWlUUUVBY2NrMjltTm9wV1hLZG1n?=
 =?utf-8?B?OUFyWDAxSFZ5ejRzSks2amZ6UHNnTU5JRW0wcE9jc3Rkc1pqbUxnd01jN2Nn?=
 =?utf-8?B?Y0tpQitZcTNCVTVlVEZ6ekdaUjVuQkhMQThaWVhBSXBKVEN1bDdqTjhvV2Vx?=
 =?utf-8?B?ajlUNU5pRkhQZExiTEJiQmVKWmJwUVhkNVJTRHJUNmViRnd0bDBqakRyZGti?=
 =?utf-8?B?a2w5Z2plWVh4bGJ3cW9RZjVRdlhtSi93NkRCbjJzd2IvUUo1ZFFxT3lpYXVY?=
 =?utf-8?B?bTJuN2d4T3djdGR4RlQ0ak5MdU9hMUxqeTk2c3FOelMyUVFaRzVOUVVzNjMv?=
 =?utf-8?B?eUswbVE0TzkrakNuaXJLM0F2QldDUTY4MzJ0VFZyZmFGMHNUOEVkY3JDcCto?=
 =?utf-8?B?N3JQQTNsOWxCUzNBUGdxNmIvM241S0hRdFdId3A0TE1jN3JqYzNBSFN6cXUx?=
 =?utf-8?B?WVVyeDZUanNqcENuSUo0eEVOOGZ5WVlhNWczK0cvOXQwd2xTd0JnVlJYMHlK?=
 =?utf-8?B?U2pQK1NSUDlsWm9PNUtFdkQvYXpoS3BJQUhrVG80SU9sbTRTNFJ6Y3FwRGM2?=
 =?utf-8?B?MTVmTnRjeXgxL0JXK0xRa2lFMHUweDNRUWk1REF1dnNsM2dYVmUwQU0xUWtU?=
 =?utf-8?B?ZkppalczelVqYy9Bbjlmc2pGZFRLLzFxbklJbHZleSs4czFxVEhjU0ZyZkh2?=
 =?utf-8?B?QUNIb05TWHMydFdIYlNaaVdZYXNIU0NzMTNiVjRhSGRnaEd5Znh3Zz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb20b6b2-68f3-4996-de15-08da19842b3a
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:21:07.9095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IF/OXoQ4Gv9ciQI0H1NcCyqOcy4a7iXPjVy9eyYQL0fsGz9z96Tu7XATaduoUnnWQglOD1HgU77O/oBrPlOUvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5192
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> When userspace restarts during boot or upgrades it won't know about the
> offload driver's endpoint and connection mappings. iscsid will start by
> cleaning up the old session by doing a stop_conn call. Later if we are
> able to create a new connection, we cleanup the old endpoint during the
> binding stage. The problem is that if we do stop_conn before doing the
> ep_disconnect call offload drivers can still be executing IO. We then
> might free tasks from the under the card/driver.
> 
> This moves the ep_disconnect call to before we do the stop_conn call for
> this case. It will then work and look like a normal recovery/cleanup
> procedure from the driver's point of view.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 48 +++++++++++++++++------------
>   1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4e10457e3ab9..bf39fb5569b6 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2236,6 +2236,23 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
>   	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
>   }
>   
> +static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
> +					 struct iscsi_endpoint *ep,
> +					 bool is_active)
> +{
> +	/* Check if this was a conn error and the kernel took ownership */
> +	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		iscsi_ep_disconnect(conn, is_active);
> +	} else {
> +		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
> +		mutex_unlock(&conn->ep_mutex);
> +
> +		flush_work(&conn->cleanup_work);
> +
> +		mutex_lock(&conn->ep_mutex);
> +	}
> +}
> +
>   static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   			      struct iscsi_uevent *ev)
>   {
> @@ -2256,6 +2273,16 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   		cancel_work_sync(&conn->cleanup_work);
>   		iscsi_stop_conn(conn, flag);
>   	} else {
> +		/*
> +		 * For offload, when iscsid is restarted it won't know about
> +		 * existing endpoints so it can't do a ep_disconnect. We clean
> +		 * it up here for userspace.
> +		 */
> +		mutex_lock(&conn->ep_mutex);
> +		if (conn->ep)
> +			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
> +		mutex_unlock(&conn->ep_mutex);
> +
>   		/*
>   		 * Figure out if it was the kernel or userspace initiating this.
>   		 */
> @@ -2984,16 +3011,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>   	}
>   
>   	mutex_lock(&conn->ep_mutex);
> -	/* Check if this was a conn error and the kernel took ownership */
> -	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> -		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
> -		mutex_unlock(&conn->ep_mutex);
> -
> -		flush_work(&conn->cleanup_work);
> -		goto put_ep;
> -	}
> -
> -	iscsi_ep_disconnect(conn, false);
> +	iscsi_if_disconnect_bound_ep(conn, ep, false);
>   	mutex_unlock(&conn->ep_mutex);
>   put_ep:
>   	iscsi_put_endpoint(ep);
> @@ -3704,16 +3722,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>   
>   	switch (nlh->nlmsg_type) {
>   	case ISCSI_UEVENT_BIND_CONN:
> -		if (conn->ep) {
> -			/*
> -			 * For offload boot support where iscsid is restarted
> -			 * during the pivot root stage, the ep will be intact
> -			 * here when the new iscsid instance starts up and
> -			 * reconnects.
> -			 */
> -			iscsi_ep_disconnect(conn, true);
> -		}
> -
>   		session = iscsi_session_lookup(ev->u.b_conn.sid);
>   		if (!session) {
>   			err = -EINVAL;

Reviewed-by: Lee Duncan <lduncan@suse.com>

