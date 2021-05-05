Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B58C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 23:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 222C2613B3
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 23:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhEEX3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 19:29:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhEEX3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 19:29:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 145NOe8a062130;
        Wed, 5 May 2021 23:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=56imo9SkVWZxZex3+odhmW4M/MHg50EfZRvfkZ40uac=;
 b=suNKriy2lBNmyu50CCHx1mOhO+P7em0QX53HzDS7H4l3hOGjin3a8oAkgv7xYP0UuERf
 68YjBMHZVMBZ69JK/YGB3R/xUMVCjnqM7MV44HQjF74nQUmeaJ14axiwmG4xDFn/DcAv
 RQaJ+1sh0XbvxXZZ/Aui/ptoyrFot1doD1+Sl1BmTa5f2NxGTielx+Y/xe2NopbpoqC9
 9JTlIl5JVA33eFFzlPbvcdIhaMAch39hLaTDNMiuA1K7ym37RXLaIWSv9Pm0zw+5d4Gz
 p23GlBxrVnEZoWckYfAbYvC23zqn+Dc2gOLJgqdspZnd9+1bWeMk2M78RCCuSf01I95Y 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38beetkdm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 23:28:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 145NLSnC097925;
        Wed, 5 May 2021 23:28:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by aserp3030.oracle.com with ESMTP id 38bewrkspw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 23:28:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj/ex7nvav+UevgW+de4smc9Pgnb5da1VE1KMeZZvVGDPaMUFXjrQ0dXtGb6/OpYXNLUM8WcF26PWxaXp1QnG8a768uySjWRHD1FExMGhjytPNTCCqWzQ1HxLSwlIlRdPH+Fb+/P5I1xg1lFzwHAwlwGjuqD6s6Nftlkyfmbb5LEWVsNYJec96SBfaBJLyum6kKx3N4Bb35gWPtduvZIe1aTFbExpzj1T0OTFok1fe+LXuZXwSTI2lmx+tqVNFJmShpHfMtTUg3vWLzvLf+L72yA7yYeCKQdYq/cqO5OsBAcDKX6CNQlzAEIblZqm364lU+UGcBE3atXP9viJ4Z6Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56imo9SkVWZxZex3+odhmW4M/MHg50EfZRvfkZ40uac=;
 b=NJqUEIkSr7A/JfwCBohhUN4FnEDI9Ae0l+LOYrhT59NMC3FfKtXIu+LSpbgZtEArcMlfOBhtzTYYFVaeLhrldkoqC1tXpk7TzoHn7jJ0aLuG0StyCznsSEvMaObgO5lSBbgnoeE//fVaind7fK+WYs7RdcQongnPDniarlW/pqgUsHIq2lyihuCYyiUbNmdT8hJg/OScddo0PpJQUvz7JCIgALfG04Pmo92MWdDjW0xG7anmcWRDVaMtL8AKZO2qRugQLnatzi/sk3s+BsilX6bbpXkLVMMTz/VH499C8o4lOOb9ljE69D2AcJM96DE3Hyye90Jy2ptNPN+szrYPyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56imo9SkVWZxZex3+odhmW4M/MHg50EfZRvfkZ40uac=;
 b=Y6BTbNrIPGByJS6rlZNRygN9wduIkSkCxJtMqu6MCYRkSZMhIHAIWT6Y8Kjb0Ik2P8g9GDKF1IRV5IcUCTdp1slu1rxEkvnph25kIvuT5MIOthJdofdFofhrdSi4JVt7KaoJGaXk+9eVabS+N8DveYg6tqPwfKoN4UKtEMj/UwQ=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 23:28:25 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4108.026; Wed, 5 May 2021
 23:28:24 +0000
Subject: Re: [PATCH v3 4/6] scsi: iscsi: fix in-kernel conn failure handling
To:     Lee Duncan <lduncan@suse.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-5-michael.christie@oracle.com>
 <5892b3b3-f8f0-76c1-08a3-98ab247b3546@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a2b6f3c6-535f-f696-de3c-3dc4f697d8e4@oracle.com>
Date:   Wed, 5 May 2021 18:28:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <5892b3b3-f8f0-76c1-08a3-98ab247b3546@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0061.namprd12.prod.outlook.com
 (2603:10b6:0:56::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM3PR12CA0061.namprd12.prod.outlook.com (2603:10b6:0:56::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 23:28:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efa4df9f-37e0-43f4-40a4-08d9101d7aa3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004955ABE281599159D1A6EF1599@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQNd9byCaw5tbTiqg9vyRwdy5/8QloxA71MsE5jHY9zrSHkcnvcW2wYrL7nbZ8kYxYqadh+EX7NrKw+5ff2jEBnY+a6gUa/dK/TmlKvz8zepGdPmPuufvhkY0J4vERxKt1b99KML8Fj/0UdMue2UNDz+qMPSHlxtXt7t9DmMgvd17vyMrzm787HyZPZXF/tHDrq+N6mUSgHCEmlgyIn+L8cDDM6rz6dk/hMFm+C1J6mUAQLEu+73G4qzIZzG4vbHJTEqF4AuZ1ZFCMnE3jW7Dop4QN7I9b7VjY0Y0IpZ2PUTU1Z2Cfa8TzgSGyANW2u7GL+swwpKThuwmKoSLzv+jXsj1+4cnXUtFkM8RyAkkGEB1MziLNHFa1YF41xmi7ukSWEgJswzhfCqqf/usZq/yNFVRiVEyOjhnxV7pvKrJK6haUu+4N37ex0BEfN8Z6dFusNAT0Q8CER7XdgNBv3kEqCs0QzJwy4Ob/Outb1VwgAexrpjULENu7fN0BFTwU7+AiilM8YEC1hr+nuakzcXJKHIZ0oJOIcGfszp0p/rDgp3QYF02QJK8Beb403XkHKd7zVqU/5tPnXR7iB509aEkl4FWvPrTGos3YEl3bRVobz4yV5C+LhMWSJns3AsUbTopSAnYq35x6fFIJV0ZZBSVPAnQcUSlBSW0vmPRkeMbgIGHepLL097DMOCG/PVNSVHR7gt1FXMyW9N1S+ZOYthMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(376002)(396003)(8676002)(6486002)(5660300002)(8936002)(316002)(6706004)(16576012)(186003)(86362001)(16526019)(31696002)(83380400001)(31686004)(956004)(2616005)(478600001)(38100700002)(66946007)(66476007)(2906002)(66556008)(53546011)(26005)(36756003)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SCtFRmx4K1BsK0FsSVloQ0R6MkxQbUIyZFZNeW0rbzFpMTltU3g4V3pnWDFF?=
 =?utf-8?B?MTMyUm5GMGdzSDFqYzlQdWNZbUxNdVFsSjdsbFJSL29qc0NUakcyUmsycmoz?=
 =?utf-8?B?SmduMm00NThvZlg2Mnd5RGZ0K2ppRitaSi92YW5RaHNsZXlVUnpWaTZudlBN?=
 =?utf-8?B?UzdIdHc5cUwvMUNVUUM0MVBKMktvQ1FvQlFjcG1WQy9ObU1meERuK1BLZEF2?=
 =?utf-8?B?UGtCUlBod0lLbXdReUx2MGpzZjkwc21kRFJITkF3czEzUmhmeGFxTi9TaDZT?=
 =?utf-8?B?TE5SeGZxY0VIbE9QSFdxTTl5WnJjOTFRQmkwZzNFMjZCN0VhQlZoZVB5OVA2?=
 =?utf-8?B?aTNjTktJQnFUSjRjTGVma2F2WGZDU0Z1aE5zcGNlRU9jMVoyVmNDYUdQN1Jq?=
 =?utf-8?B?OWh4SmJET0syRjl6c1RhYXlHcDJYcWtkUk5SVlB5UkEzT3FyWkY5MVdicEgz?=
 =?utf-8?B?ZTBiLzQrT3N3dFA5OS96QnpKaW45Mk10QzFkWTVFalgra3hjNE5DTkI4Zy9G?=
 =?utf-8?B?bWdCR01Pd1EyWnlXNEFpSWFGbTNNd05mQmV3NjlXSUdidldwSGc4ZFd5dTZs?=
 =?utf-8?B?eHBCTzhoZXJrT1I1eldUMHZiT3d5OEI2ZFNheEQvLzl6YzJUd2dQTmZiNjNi?=
 =?utf-8?B?VXJ1ZU9kcmUyNG4zVSswTVRKeXc3blFqNEh5QUZ3dm4rT2ZTeDVFeUgzSXk5?=
 =?utf-8?B?UWIwNjBuSzVtWWxibnBWYmZNU1A1OS81L29yYTBLclRQUWRVUHU0UkJQK293?=
 =?utf-8?B?c2VMUkRTSnBvZkJyOXltRjNuU2JaTmh3RXg2VksyWEhxZ21mK2FSWENkaEJG?=
 =?utf-8?B?eFFsREdheG1jUXVlUnMyVzJ4MzE0dm9OZWxLbk9uSytkUFVJdnV0bmRGMkk2?=
 =?utf-8?B?NThFWFc3aGs0ekxVRFoxOHBlTlBreVRCZ0tkc2JJTGtJUUt4VnBmUExjT1RP?=
 =?utf-8?B?YkxmaTdaTVBHMitzREFCb2xqeWRLWkQwRVROSWpFbmI2TjhLbVJCeUlaWHY5?=
 =?utf-8?B?WGdmMkp2OVpxczZ6ekxCa3h2VGVXb2lFN0c2Y0dDeUQrMnJCR2RVYVBJem02?=
 =?utf-8?B?RmppSEtWaU8wME12azJObTZ6VkV0RTk2R0ZzZHdQRlE5UGE5REJJc0ZnRC9l?=
 =?utf-8?B?dkMyOUszaVNEVHFNTVlvR1g0NnJ1ZEhkU1BqTXFZdFVJK3UxWm9YMDRIdGhm?=
 =?utf-8?B?VUQ1eit1T3FDK0NuSWdqSTVOUlNZS0xsNE9uTkdLTGdvY0Q4dGNwNU1MYWV5?=
 =?utf-8?B?TnhsblVlSCtOTG80VkhMcE1TTVh3NklYLy90cWZaUVJ0UzRabXZZY21kZVNE?=
 =?utf-8?B?S1Q1WFptQkhuMU5xMldCWEZQTnNRUFRDclBTMkpudWk1eTdUOG5HSjBsVVlj?=
 =?utf-8?B?aGJaK3ZlUHpNbWVxMW5VeVVhUG51UVNGTXFDMHZzNHpqYTZoZSsvcmhYN3BT?=
 =?utf-8?B?N2d5WXNUMit4YmYxTDZZQ1dvaVRCSnIxMElrd01vY29IaGJqMEE0TTNnN2VW?=
 =?utf-8?B?dkthZFlaZUJKeDlhRTQvTnlLT1FkS0twdVdpNWlBQmJXbmFHaklRSjZkM2Zr?=
 =?utf-8?B?N0xwcUNhNHpTcG1yQzV2ZTdwZU5ET2diV0hudFJPczU3NWZQeldSeWppQjZu?=
 =?utf-8?B?bGl5KzlRTEFIY2QwTEJIRXJFTDZ5OU84Q0xieDBaNGlJamZmYkhUSTRUaU5D?=
 =?utf-8?B?RUp2a0NRRE81ZWZXTHkrT3FSR1pxcDhUQzI2cnFOQTFHSnJQZnFzaDMzUHFl?=
 =?utf-8?Q?8Z3RRS9gXCV6r6mlelNnVgOdxQ4gLuhQIezOKCs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa4df9f-37e0-43f4-40a4-08d9101d7aa3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 23:28:24.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycSF7pwqF3lQOof9syRKFGcZDI1a6AB3ZTsClM/JSJ3udDf35ZZLPQx8/DEvKRmb6KdMfVUuPPuQOlMKbjGerx62uXd1tUK1wkLGEEtQgpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050162
X-Proofpoint-GUID: oR1_JG7c2WG6ANaWdqzEV9LbXBtRb5WS
X-Proofpoint-ORIG-GUID: oR1_JG7c2WG6ANaWdqzEV9LbXBtRb5WS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/5/21 5:56 PM, Lee Duncan wrote:
>> +static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
>> +{
>> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
>> +	struct iscsi_endpoint *ep = conn->ep;
> 
> You set ep here, but then you set it again later? Seems redundant.
> 

Yeah, will fix.

>> +
>> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
>> +	conn->state = ISCSI_CONN_FAILED;
>> +	/*
>> +	 * We may not be bound because:
>> +	 * 1. Some drivers just loop over all sessions/conns and call
>> +	 * iscsi_conn_error_event when they get a link down event.
>> +	 *
>> +	 * 2. iscsi_tcp does not uses eps and binds/unbinds in stop/bind_conn,
>> +	 * and for old tools in destroy_conn.
>> +	 */
>> +	if (!conn->ep || !session->transport->ep_disconnect)
>> +		return;
>> +
>> +	ep = conn->ep;
>> +	conn->ep = NULL;
>> +
>> +	session->transport->unbind_conn(conn, is_active);
>> +	session->transport->ep_disconnect(ep);
>> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
>> +}
>> +
>> +static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>> +{
>> +	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
>> +						   cleanup_work);
>> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
>> +
>> +	mutex_lock(&conn->ep_mutex);
>> +	iscsi_ep_disconnect(conn, false);
>> +
>> +	if (system_state != SYSTEM_RUNNING) {
>> +		/*
>> +		 * userspace is not going to be able to reconnect so force
>> +		 * recovery to fail immediately
>> +		 */
>> +		session->recovery_tmo = 0;
>> +	}
>> +
>> +	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
>> +	mutex_unlock(&conn->ep_mutex);
>> +	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
>> +}
>> +
>>  void iscsi_free_session(struct iscsi_cls_session *session)
>>  {
>>  	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
>> @@ -2284,7 +2374,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>>  
>>  	mutex_init(&conn->ep_mutex);
>>  	INIT_LIST_HEAD(&conn->conn_list);
>> -	INIT_LIST_HEAD(&conn->conn_list_err);
>> +	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>>  	conn->transport = transport;
>>  	conn->cid = cid;
>>  	conn->state = ISCSI_CONN_DOWN;
>> @@ -2341,7 +2431,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>>  
>>  	spin_lock_irqsave(&connlock, flags);
>>  	list_del(&conn->conn_list);
>> -	list_del(&conn->conn_list_err);
>>  	spin_unlock_irqrestore(&connlock, flags);
>>  
>>  	transport_unregister_device(&conn->dev);
>> @@ -2456,77 +2545,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>>  
>> -/*
>> - * This can be called without the rx_queue_mutex, if invoked by the kernel
>> - * stop work. But, in that case, it is guaranteed not to race with
>> - * iscsi_destroy by conn_mutex.
>> - */
>> -static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>> -{
>> -	/*
>> -	 * It is important that this path doesn't rely on
>> -	 * rx_queue_mutex, otherwise, a thread doing allocation on a
>> -	 * start_session/start_connection could sleep waiting on a
>> -	 * writeback to a failed iscsi device, that cannot be recovered
>> -	 * because the lock is held.  If we don't hold it here, the
>> -	 * kernel stop_conn_work_fn has a chance to stop the broken
>> -	 * session and resolve the allocation.
>> -	 *
>> -	 * Still, the user invoked .stop_conn() needs to be serialized
>> -	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
>> -	 * it works.
>> -	 */
>> -	mutex_lock(&conn_mutex);
>> -	switch (flag) {
>> -	case STOP_CONN_RECOVER:
>> -		conn->state = ISCSI_CONN_FAILED;
>> -		break;
>> -	case STOP_CONN_TERM:
>> -		conn->state = ISCSI_CONN_DOWN;
>> -		break;
>> -	default:
>> -		iscsi_cls_conn_printk(KERN_ERR, conn,
>> -				      "invalid stop flag %d\n", flag);
>> -		goto unlock;
>> -	}
>> -
>> -	conn->transport->stop_conn(conn, flag);
>> -unlock:
>> -	mutex_unlock(&conn_mutex);
>> -}
>> -
>> -static void stop_conn_work_fn(struct work_struct *work)
>> -{
>> -	struct iscsi_cls_conn *conn, *tmp;
>> -	unsigned long flags;
>> -	LIST_HEAD(recovery_list);
>> -
>> -	spin_lock_irqsave(&connlock, flags);
>> -	if (list_empty(&connlist_err)) {
>> -		spin_unlock_irqrestore(&connlock, flags);
>> -		return;
>> -	}
>> -	list_splice_init(&connlist_err, &recovery_list);
>> -	spin_unlock_irqrestore(&connlock, flags);
>> -
>> -	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
>> -		uint32_t sid = iscsi_conn_get_sid(conn);
>> -		struct iscsi_cls_session *session;
>> -
>> -		session = iscsi_session_lookup(sid);
>> -		if (session) {
>> -			if (system_state != SYSTEM_RUNNING) {
>> -				/* Force recovery to fail immediately */
>> -				session->recovery_tmo = 0;
>> -			}
>> -
>> -			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>> -		}
>> -
>> -		list_del_init(&conn->conn_list_err);
>> -	}
>> -}
>> -
>>  void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>  {
>>  	struct nlmsghdr	*nlh;
>> @@ -2534,12 +2552,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>  	struct iscsi_uevent *ev;
>>  	struct iscsi_internal *priv;
>>  	int len = nlmsg_total_size(sizeof(*ev));
>> -	unsigned long flags;
>>  
>> -	spin_lock_irqsave(&connlock, flags);
>> -	list_add(&conn->conn_list_err, &connlist_err);
>> -	spin_unlock_irqrestore(&connlock, flags);
>> -	queue_work(system_unbound_wq, &stop_conn_work);
>> +	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
>> +		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
>>  
>>  	priv = iscsi_if_transport_lookup(conn->transport);
>>  	if (!priv)
>> @@ -2869,26 +2884,17 @@ static int
>>  iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>>  {
>>  	struct iscsi_cls_conn *conn;
>> -	unsigned long flags;
>>  
>>  	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
>>  	if (!conn)
>>  		return -EINVAL;
>>  
>> -	spin_lock_irqsave(&connlock, flags);
>> -	if (!list_empty(&conn->conn_list_err)) {
>> -		spin_unlock_irqrestore(&connlock, flags);
>> -		return -EAGAIN;
>> -	}
>> -	spin_unlock_irqrestore(&connlock, flags);
>> -
>> +	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
>> +	flush_work(&conn->cleanup_work);
>>  	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
>>  
>> -	mutex_lock(&conn_mutex);
>>  	if (transport->destroy_conn)
>>  		transport->destroy_conn(conn);
>> -	mutex_unlock(&conn_mutex);
>> -
>>  	return 0;
>>  }
>>  
>> @@ -2967,7 +2973,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
>>  }
>>  
>>  static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>> -				  u64 ep_handle, bool is_active)
>> +				  u64 ep_handle)
>>  {
>>  	struct iscsi_cls_conn *conn;
>>  	struct iscsi_endpoint *ep;
>> @@ -2978,17 +2984,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>>  	ep = iscsi_lookup_endpoint(ep_handle);
>>  	if (!ep)
>>  		return -EINVAL;
>> +
>>  	conn = ep->conn;
>> -	if (conn) {
>> -		mutex_lock(&conn->ep_mutex);
>> -		conn->ep = NULL;
>> +	if (!conn) {
>> +		/*
>> +		 * conn was not even bound yet, so we can't get iscsi conn
>> +		 * failures yet.
>> +		 */
>> +		transport->ep_disconnect(ep);
>> +		goto put_ep;
>> +	}
>> +
>> +	mutex_lock(&conn->ep_mutex);
>> +	/* Check if this was a conn error and the kernel took ownership */
>> +	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
>> +		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
>>  		mutex_unlock(&conn->ep_mutex);
>> -		conn->state = ISCSI_CONN_FAILED;
>>  
>> -		transport->unbind_conn(conn, is_active);
>> +		flush_work(&conn->cleanup_work);
>> +		goto put_ep;
>>  	}
>>  
>> -	transport->ep_disconnect(ep);
>> +	iscsi_ep_disconnect(conn, false);
>> +	mutex_unlock(&conn->ep_mutex);
>> +put_ep:
>>  	iscsi_put_endpoint(ep);
>>  	return 0;
>>  }
>> @@ -3019,8 +3038,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
>>  		break;
>>  	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
>>  		rc = iscsi_if_ep_disconnect(transport,
>> -					    ev->u.ep_disconnect.ep_handle,
>> -					    false);
>> +					    ev->u.ep_disconnect.ep_handle);
>>  		break;
>>  	}
>>  	return rc;
>> @@ -3647,18 +3665,134 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
>>  	return err;
>>  }
>>  
>> +static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>> +				   struct nlmsghdr *nlh)
>> +{
>> +	struct iscsi_uevent *ev = nlmsg_data(nlh);
>> +	struct iscsi_cls_session *session;
>> +	struct iscsi_cls_conn *conn = NULL;
>> +	struct iscsi_endpoint *ep;
>> +	uint32_t pdu_len;
>> +	int err = 0;
>> +
>> +	switch (nlh->nlmsg_type) {
>> +	case ISCSI_UEVENT_CREATE_CONN:
>> +		return iscsi_if_create_conn(transport, ev);
>> +	case ISCSI_UEVENT_DESTROY_CONN:
>> +		return iscsi_if_destroy_conn(transport, ev);
>> +	}
> 
> Why aren't these two consecutive switch statements just one? I'm
> guessing there's a good reason, but I can't see it.
>
I thought the layout made it easier to see the cmds require
different things wrt the async stop/ep handling.

First switch are cmds we don't need the ep_mutex and to check
ISCSI_CLS_CONN_BIT_CLEANUP. We can just run the helper and return.

After that is the stop conn cmd or cmds that have issues with stop
conn/ep racing with them. In the second switch we lookup the conn
for these types of cmds.

In the last switch we handle the cmd.

I thought the iscsi_if_stop_conn function could lookup it's own conn
and then be called in the first switch since it handles running with
itself in a special way and does not need the common
ISCSI_CLS_CONN_BIT_CLEANUP check.
