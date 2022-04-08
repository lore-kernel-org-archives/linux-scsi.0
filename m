Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6649BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiDHRlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbiDHRl2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 13:41:28 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E178FEB
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649439561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmMWACmO/0FxrqVvMnciXLTz0r3dPHc1Q/+ccOU3m70=;
        b=EqpGEExlg0flFgsSjSyWWl8yfk8QRAH+zJyGcadR51g1jMOZU2csZZ4YX53MwpD088pfjA
        tgeB6LYrTqqCdz7Dh8EHlIqNA9uP6Ue1QwY7y3QXWxy0WvHT7qVMkDwMJeZbJrgEHWznr1
        nCM73cnr0zGRoPodk8rHejf1KyQ3dCk=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29--HcRoYi2Nn2qjsGHMSzDyQ-1; Fri, 08 Apr 2022 19:39:18 +0200
X-MC-Unique: -HcRoYi2Nn2qjsGHMSzDyQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jv8P8fo2zXaslvzJSMyA8xnn7j3D7rjJXvltPXW66D+YX4b1gHteVsr//t02PoOP+41tp34Q1AK63rq1zwval5JQLragU46DsvxpCwIqaM/k+yYyFEzmBc2d0yO0z5uR0o2cjJCRQXrHFN9ogB6XtS6q8XI499lbD/BDCa2xfD+fJR8iz1ooALyyI3YJT+hS44Cz0wktH2Y0ZvBlqml94oocvK6bUhi60Ulaqy9EW0OpegOyOXEpnWnPbqC5FBNize4IvESrKrlTG6tRYcKwJhokHbajfepJqsMelnYQMbhTLyG1lEnxYGn99KZaShNufCFwzvkyc3R+atuS/eF8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmMWACmO/0FxrqVvMnciXLTz0r3dPHc1Q/+ccOU3m70=;
 b=NlVw8mzNEEv1CScGF0oyeiZxyA4nxbMPZevzhrha34u7RZmFEcdLNr64XrSNmW43hFzEIKpPN/B1/8CE73D0UeK05B8HbUUo20//touezYfUmHDlMMWsPWzclgtoe3/vU/X9J5rKv7HWPpDnMRXNrwtb8CW97K3aL6kfT5rmCH813nfWn/gdmEag/9OqB3ACYNHBI3QXdy52aYw9tfId/64XdUBz2bDTIidPS10TIOZF5qU8UU7LusrC4pVodey3dI19UgZ+ZalPIhOcF4/FU5CQS1Yoq9rB2a+NiE+x1vNh7ilICNi+PKttiBDURTHMQSdwiKK/M+Xp1SxrBAuoCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5864.eurprd04.prod.outlook.com (2603:10a6:20b:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 17:39:17 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:39:16 +0000
Message-ID: <a1c1340a-52ff-c41d-5630-44750163b993@suse.com>
Date:   Fri, 8 Apr 2022 10:39:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::17) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ddcfaad-85cc-4e09-9db1-08da1986b44b
X-MS-TrafficTypeDiagnostic: AM6PR04MB5864:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB58642505BD069F104534E1C3DAE99@AM6PR04MB5864.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwFoIsEGKj1FR1BO84qVKGMb0Ve5jlhq5JhaLmYfNkx23MXo1Njr/hRTTbfa74uv1gL8wpfMiM7hv3shM4BPq7VUEA2keUxIDBmyyf0U3PoYWqOaUYvs+Ga2HSEU6UvQke9J6/6h4rFtF+PE+mcWcdE/+q3KuavLAVs+xrFYCh32IJZPgjyTV5x6XNW28R8Pm1d8nS7TSb2eTdwXVY6oq1K2AUDe2Y3owIF6QNTmAhwrgDvVcsWBSo/OnXH7g0WTqu0oU554EzqtXbQ2gNK/YQrIhMTuHS+U83VPeJpKhI0h+zJzwx6sozX/pqxOaNJrYhj5MZDtO4fIVO187HzWW0JHFN3xdImF/QZy6rIJsmEHyufyxWUI01l8+UEKR6qtS61VaoDfIOtNM7tAn2diO+yfDX0Hw4zmSBF7KUEclZSadtlPGe20xBPZc+0funcIBZgc2EZDQvheetr17jJ78BfNVsO8XPM/ctFW3ACplUwtDLVv9gCJtyFN9XFaZVVkqMq7dBPf8MrY487sjUn9Y9SBnkeCDWfQVCbEZT3rO5S0Q9REFyev4bJP3khg0XJtHkpU5C/TvYP23PIGY9RmBPuh2V8jHw3ygXGz9NriXUd1t2YX1P6gpxc/JnJEvPr6D8UXnrtmjVYzL+dnp2K68m+Bb+pWuD8U+bcyB9VfAF41UaRkUOutPGm4o8ntc8o8ArSl4Ia6iaN/5OSSLCopQq7hwsdtsF4llli/NakfRWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(8676002)(31696002)(36756003)(31686004)(66476007)(66946007)(66556008)(53546011)(86362001)(83380400001)(6506007)(6666004)(6486002)(2906002)(5660300002)(6512007)(508600001)(2616005)(26005)(186003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTNqdVNkeU9UZDBuRUt3U1Z5Tms0bUNkNjREaDZzalVVQUpOekJtM0daL05v?=
 =?utf-8?B?cmZjNW1FQXg0dEVOTVBPOUtJZFd2Mm1xSDJXSi9qTHlJRGN5KzM3eXdxV212?=
 =?utf-8?B?aEVObUhneGlmV0NkcFhRSnhZeE1UOERVR0M1dUZPRmZSbEVVcnlRVHJhWG5P?=
 =?utf-8?B?WjlZZmZLU2JRTEJRNE5yZWFUUDd0Q0w3OEdkdHo2dWxwczJ3S21oTHI0N0t5?=
 =?utf-8?B?WUFkVnNpOFRrU095cWk3WFlWMEpLb0gxb2xBTnpVSDFkVEFZM2E2Q2N4YTdV?=
 =?utf-8?B?TkZ1OXdYQks3Z3dBTFhYWmZ0OFhaZjFVWWFqNjRIL01yZ2h6WkttRWVyb25E?=
 =?utf-8?B?dzhHcjllWEtuSk5SYWViajhFNTJ6UlA1UnhEckIzb25IYUEweWVUUmhIaDhH?=
 =?utf-8?B?MzRKSkV3R28yWDlDR25CRzZhaDkvM21DRHBJU0ptTVl3TkNWYVlYdTFQanpJ?=
 =?utf-8?B?U0VFaEh0SDU3L0JqRTNLWGdhL0NYQmFvWkVBQnArUGxYZnhxclI5WVE2cU0x?=
 =?utf-8?B?ZWsrQVZleExjVU9XZ2YycTBuNTRuMHZxNjhKRGpoRXg2cW1vZXB0b0NRTXpo?=
 =?utf-8?B?MXNnVWhuR3pDNFpVbXA1OFhydHFBVEwyWWw1dnlJaEtQZzE5RzF1TERPb3NS?=
 =?utf-8?B?cnlNck8yZFU4SUhvdU8yODdDdWExQjJoYldnZFJadEJvTldJajEvQnozOCtv?=
 =?utf-8?B?Y0ZQU1VqMkhIYmg3K211ejFVYW1TdjdXM21tUHhJdk9FZjduMkIrV2JCSHhh?=
 =?utf-8?B?ZWNxemZGejhYOWFnNURBck9OYWZoVDJMNGw0c0JzQTJYR3NReUZLV2tsOXV4?=
 =?utf-8?B?R0x6TG9aMm8rSEh4dE9kMjlLU0FqYTQvMHQvTmZTS0M2bU1vMTJWTHJ0SGV6?=
 =?utf-8?B?a2lCQ2hWT1I4Rzdnb1dySzJ1cTZGTWM0UHU5eUQ0S0IyV24yYXpWWHRVRFdZ?=
 =?utf-8?B?UVQ5ZTlJSkZ0eGNrWGZOcUdIMlIwT0pjNCtXUGt5ckp2RjF5ckk2QTYva01J?=
 =?utf-8?B?UWZGcDFiRXMzT2l3L0VGOU5IeG5RSW5xa2xoY1FyT3BVWFFsOTcyTnJuL0I0?=
 =?utf-8?B?R1BJdzYraHNtTk01SUhWMlVFcXBoRXE2T2dTZEJKdjg5dWZ3OVJTdGNGVFhR?=
 =?utf-8?B?SmhzS2ZjanhLUDNYTDY3YnFySnRlSjFMaEQ2OStJUGVEQlA4L09ycHQrYStF?=
 =?utf-8?B?clFTSUw5a0VZaXFoazB5NzF2a3ovOGxMWTg1Ry9ZMFJiN3FUMzBMbWhIS2xH?=
 =?utf-8?B?Z3ZhejFQOUhxYm1odUtJWmlFMVI4SUZ2NDNDV0JFNnRpcXdBaTZiTlJIR0gr?=
 =?utf-8?B?bDBWNWhFbW50ZXhpTHBoUTJsMGc4NFZtS0crTmJTNldKbkFYZE1pMVVHaHp3?=
 =?utf-8?B?dTUxRzZpaWprdjJGOFpnUUhFN0Y0dXY4VTkwa3M5dksrTDk0RVJJenVOVTgz?=
 =?utf-8?B?NFRvbDZ4cWpJUEU4ODlLaW1TZ2JSSVJBcC81M3FGYVVKMkxOUjBCQllVUE9v?=
 =?utf-8?B?M0UvY2o4U3FHQzRjY2E0N0UwTTdscnhtY2NnTFA0TEZYWHRkS2Q2UkZLVkVS?=
 =?utf-8?B?ODcvK1VNYVMyNmZRalhWNGxrQjNMbi9yOC9BVTFmOFdsMGtPaXNadGVSa1d2?=
 =?utf-8?B?eVhsVkFheW9SaGFqM0R6Ty92SWhTSTNNUFlVUDNGUXoyV1ZkMmxaY2QvZE1S?=
 =?utf-8?B?TEs5dFhSRHBZd3ZWcUpkVndYNWdBdmxBbDVKUlY1cGw4cy9NaHQyZ25oc1pR?=
 =?utf-8?B?VmROaFZNczgwMDRTM0o1NVNidmpLTHFvcjYzTFI4S0k2VmpCZHV5YkZwcmk3?=
 =?utf-8?B?dmJWWXY4bWRxUldoT1BuTDZ2eE5qTXhkdDFzNUMxUWgwV09QV3AxNW9mM0lB?=
 =?utf-8?B?RHBGNzBib2dvV3FlN2NuSXFVbTlFbkZSZzQrNThUSEVnd2puUGQ4UjdVMzJl?=
 =?utf-8?B?SUY3dW5RWUdZTzFDdG1qNnI0eGN6L0g1dnQwSEhsc05kV1A4RlF6eVNnRUxR?=
 =?utf-8?B?NU51QVBqQ2h0WTJsRFBkTGhBaFpZNit0c242TkZpQnV5VGlIZU0yRG5tK2J0?=
 =?utf-8?B?QUlUZTIwbk16QUlXZXM0ZEdSZEJ2aTR5dGl2YW9IMldTaHJzTmxwdWJXSTZ5?=
 =?utf-8?B?SEcxRWtYMy8zRlc4YWQvZEV6TUk3aUlQQlhjeFdUQkZ0bXZBMzhLWWI0UlNK?=
 =?utf-8?B?TzBlSmxKZUxoYndRVU5xd3grd0tHZFFFb1FnRnJZL0NJMFlzelBEc0Z5bTMy?=
 =?utf-8?B?Z0IreFJwNjFDc3RlM0R1aTJ6VHNaUXBtV2FKeTdqVmZ6YlMxVmd1N3BxeUdp?=
 =?utf-8?B?bm5BcnhHRlp3NjAzZ3RmcU5TQ0E5ZEdLS0U1dHZEVWNUUEYvVk50UT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddcfaad-85cc-4e09-9db1-08da1986b44b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:39:16.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmLtM7XuFN5/0iQi/NZBpNNhboiBx2/H4DKvgBl+/tbH+bBHP8v9h+9gZqGFqAC4i7XBVAWBUCGSVSzp0RCEGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> We can't release the endpoint ID until all references to the endpoint have
> been dropped or it could be allocated while in use. This has us use an idr
> instead of looping over all conns to find a free ID and then free the ID
> when all references have been dropped instead of when the device is only
> deleted.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 71 ++++++++++++++---------------
>   include/scsi/scsi_transport_iscsi.h |  2 +-
>   2 files changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index bf39fb5569b6..1fc7c6bfbd67 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -86,6 +86,9 @@ struct iscsi_internal {
>   	struct transport_container session_cont;
>   };
>   
> +static DEFINE_IDR(iscsi_ep_idr);
> +static DEFINE_MUTEX(iscsi_ep_idr_mutex);
> +
>   static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>   
>   static struct workqueue_struct *iscsi_conn_cleanup_workq;
> @@ -168,6 +171,11 @@ struct device_attribute dev_attr_##_prefix##_##_name =	\
>   static void iscsi_endpoint_release(struct device *dev)
>   {
>   	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> +
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	idr_remove(&iscsi_ep_idr, ep->id);
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +
>   	kfree(ep);
>   }
>   
> @@ -180,7 +188,7 @@ static ssize_t
>   show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
>   {
>   	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> -	return sysfs_emit(buf, "%llu\n", (unsigned long long) ep->id);
> +	return sysfs_emit(buf, "%d\n", ep->id);
>   }
>   static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
>   
> @@ -193,48 +201,32 @@ static struct attribute_group iscsi_endpoint_group = {
>   	.attrs = iscsi_endpoint_attrs,
>   };
>   
> -#define ISCSI_MAX_EPID -1
> -
> -static int iscsi_match_epid(struct device *dev, const void *data)
> -{
> -	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> -	const uint64_t *epid = data;
> -
> -	return *epid == ep->id;
> -}
> -
>   struct iscsi_endpoint *
>   iscsi_create_endpoint(int dd_size)
>   {
> -	struct device *dev;
>   	struct iscsi_endpoint *ep;
> -	uint64_t id;
> -	int err;
> -
> -	for (id = 1; id < ISCSI_MAX_EPID; id++) {
> -		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
> -					iscsi_match_epid);
> -		if (!dev)
> -			break;
> -		else
> -			put_device(dev);
> -	}
> -	if (id == ISCSI_MAX_EPID) {
> -		printk(KERN_ERR "Too many connections. Max supported %u\n",
> -		       ISCSI_MAX_EPID - 1);
> -		return NULL;
> -	}
> +	int err, id;
>   
>   	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
>   	if (!ep)
>   		return NULL;
>   
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
> +	if (id < 0) {
> +		mutex_unlock(&iscsi_ep_idr_mutex);
> +		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
> +		       id);
> +		goto free_ep;
> +	}
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +
>   	ep->id = id;
>   	ep->dev.class = &iscsi_endpoint_class;
> -	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
> +	dev_set_name(&ep->dev, "ep-%d", id);
>   	err = device_register(&ep->dev);
>           if (err)
> -                goto free_ep;
> +		goto free_id;
>   
>   	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
>   	if (err)
> @@ -248,6 +240,10 @@ iscsi_create_endpoint(int dd_size)
>   	device_unregister(&ep->dev);
>   	return NULL;
>   
> +free_id:
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	idr_remove(&iscsi_ep_idr, id);
> +	mutex_unlock(&iscsi_ep_idr_mutex);
>   free_ep:
>   	kfree(ep);
>   	return NULL;
> @@ -275,14 +271,17 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
>    */
>   struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
>   {
> -	struct device *dev;
> +	struct iscsi_endpoint *ep;
>   
> -	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
> -				iscsi_match_epid);
> -	if (!dev)
> -		return NULL;
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	ep = idr_find(&iscsi_ep_idr, handle);
> +	if (!ep)
> +		goto unlock;
>   
> -	return iscsi_dev_to_endpoint(dev);
> +	get_device(&ep->dev);
> +unlock:
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +	return ep;
>   }
>   EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
>   
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 38e4a67f5922..fdd486047404 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -295,7 +295,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
>   struct iscsi_endpoint {
>   	void *dd_data;			/* LLD private data */
>   	struct device dev;
> -	uint64_t id;
> +	int id;
>   	struct iscsi_cls_conn *conn;
>   };
>   

Good idea. :)

Reviewed-by: Lee Duncan <lduncan@suse.com>

