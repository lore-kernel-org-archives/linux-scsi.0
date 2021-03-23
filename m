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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA66C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 00:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B348C619A3
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 00:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhCWALi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:11:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:37758 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230393AbhCWALQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 20:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616458274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrshHiOuwCjWQYnYTDFpusuxerwIqDUaLWNoSOFY3n4=;
        b=ebmNPWb/oEVEL1hAWKEWU2WECJn2rq3SPgrVMi3sRNLOxUwuHqVvWT1pWE5W8lQVN14/j7
        o/oJg5gGY7sjKRILgMXMz1EJkgoHAOF2uUfr6G5LNsaHi+VAniMRkTzZCHpvgjfaLF6Uz7
        gu0UdoMTWBdaiNSDy6iek7S1Amo8A9Q=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-pSt8OwzONWyC0Oxc_pK9sg-1; Tue, 23 Mar 2021 01:11:13 +0100
X-MC-Unique: pSt8OwzONWyC0Oxc_pK9sg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8x06pSbpid9Tz/pPe67G8W7J6QmE3a4xz1Rs0IdMj0+TiDWtNeLhMBs2QyMzdxWOLp96kewIFj3wByVRGTRZcuJwHFJlV6NgrfGZJlQcHLnNlHR2iw7kmHXB1TQs1uRRWfml8z142WwakstooUUSQFiY6jtsgwj0Bf7ZY8lZYgVrlUHYANV2bs5lJSFVyL+8DMU8hd1b5EOrZeDSatCS7VME9bkRRxKidocSPWigY7U62Y5ukSlHGsEsnDWrpDKWwfe2cEjG25LDDdyMbpVE7jIv8MT4zEIh6oZNOEW5YB109prgMva/H5zI1rfDSPh0wdsN3E78THdXpgcZOlxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrshHiOuwCjWQYnYTDFpusuxerwIqDUaLWNoSOFY3n4=;
 b=Q5oKeT7jwHnQ3XNyNlnqjJfUl4Qme8bIgoWWLcwnvo37JBnkJyk7q9L0wtgqAe2jCZ4IZFtxACG41DSvNd2eiPqAD4AUh8ZtpzR5JJqn8lgwopbw8luRBJ/I28PAh7i4/swN310tKnFerAwElCey5XzX/2q8EgDWkkovNjadmAWQ+yX+Ch3YEoiiFfqrIhE1gAOztu9TsgybicCGyDc65KfKB9gO/f1TFP2dCb+45z6Yw2oy+xDJS9ZkXsNu9yFqXF8pdYICKbI84rdfHP6CIyi03vnyIlWwExs778+hjqHAuJ4kxFIJosH5e8eaQPRTtef6WUBrZfbxCFX5FQV11A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR0402MB3813.eurprd04.prod.outlook.com (2603:10a6:209:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 00:11:12 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 00:11:11 +0000
Subject: Re: [PATCH V4] iscsi: Do Not set param when sock is NULL
To:     Mike Christie <michael.christie@oracle.com>,
        Gulam Mohamed <gulam.mohamed@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210310062651.179792-1-gulam.mohamed@oracle.com>
 <66c54dc7-d594-ad07-7c35-face5a57d9a7@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <880cd683-4e65-47c3-1351-03b62cccdb61@suse.com>
Date:   Mon, 22 Mar 2021 17:11:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <66c54dc7-d594-ad07-7c35-face5a57d9a7@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR02CA0180.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::17) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR02CA0180.eurprd02.prod.outlook.com (2603:10a6:20b:28e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 00:11:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7d23ef-e441-4dda-691a-08d8ed902a4d
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3813:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3813A0ED4CD6EF36B06A65D7DA649@AM6PR0402MB3813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/eTsi8qq7rY62wIlYVng2pm81nbCf1jriDQCm1I8jWrtiE3MOE8OIzIrakHDtF3vpF1feO08kJeL/oxTkrZLYJE670mBDPztlqQXcCui3CT/d1B9INhJjmmUNlYAjAKYSN52eCqPrf2ScglwKD5F8wJi05ZFdWAs/fWUoxUmGfyRzzNmQa6Z2Kximq7zPMCrxA4KAXwxr8nbZlpNlbFqBVYICRpbTW6H+Qx3N1OFCZoTVf1XQRtQQEclMzP8zBFAz+moBjtAjKOu0+ectMhBz6eFiv4AQhnjNi5CuxL5PomMXAmDoeTQ0rwpqeV9+hj0cUJlNlmmhVdzdWVwIPucluuX0VRNFrvwEOVmpr4sogdQZh9AF1A6AuZyhCtq4csDbfD3h9ZrXz0DjFSfUs/qbuTl2qr+RRoGV2JCFoT+lI/faSsuTyQG9nfCSglPj1J680pr4yZ8pqsFlHyJA5Pnm9fSsxBJkwCz6jgwJF1WcwGMkU6h8eJxF3jf9bo6i8rYFQzQW/nuncp+Uyaq4RZNdiZoJYU57DKotjH7MLugB5wX1Jm2Y/GdVjF29FLOAf2UhfKhkheieKEyGVic0ZwnnOT27SmridV3TMN4hFPUPLwjStR/VXrbUT+EDZqAYePP6mk/HIFszhMnug8mS3bJRQbCcrLYKCevZChce9Q+XrjrcDwzpvGKShYZ9ST584uyndpcDPaxgNZkqhmdfU4Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39840400004)(16526019)(52116002)(6486002)(66946007)(2616005)(16576012)(8676002)(956004)(186003)(316002)(6666004)(86362001)(38100700001)(31686004)(66476007)(26005)(66556008)(83380400001)(5660300002)(8936002)(110136005)(31696002)(53546011)(36756003)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YnAwdi93bWhsUmlaa3krK3pPYmtPWWZNMTg2d1ByT1NnY20rSXRJVSt0R1U0?=
 =?utf-8?B?Rm5ad0FreGR3bEZ5V1F1V2NvclBKZjBUb0I0Yis5N0xVaVJwajhYbFB2blF2?=
 =?utf-8?B?UnJZaFNjU2JJbUVuZkFyZHRGMWtQTzRSZVFHTEFEK3A5V3Nsc3BUN1BvNUdP?=
 =?utf-8?B?ZHBvbzFtUmI4YThGSEQ2MkJVWGlCWkg3NFl6WW10c254MlVVSCtiSFVuLzdZ?=
 =?utf-8?B?Y0tSSzUzblZ4RXVISDJNVjQ0R3o4YTBxSnJncTZSWnhNWU1vSGJzTVM0N24z?=
 =?utf-8?B?Wmc1TCtmbmNUT1VuVnBnWUtFRW9VZ0dzcmhWSkU5M3FxMXRYbXNLaTBLVHBy?=
 =?utf-8?B?Ti9Od0Jwbk1ra3EvNXpwVkN1d2xrKzZvTlZnQlRLOUh6Q3ZaQlBnVU5tK0w5?=
 =?utf-8?B?TFpKZ2hqT1NWMVNwbGJIQm5HV0k4dXZ3aHlMVDdDSkZrMDU2SFlIeElEQWR3?=
 =?utf-8?B?MlMvNGpmY1hKcGdZS08zVlVzcFJCWUY1bHV1WXBhb2pvRkFqaUJ5eUx4eTM3?=
 =?utf-8?B?eUVOZHR2K290WDA2SjlxL1lwMG8yT2FPdHU5RTc4RE9LeWpyVlJNS3ZoaWVx?=
 =?utf-8?B?dFVtcjJlc2VmYzlzcXJzM1Z2bUZCV2pqSjFFb29pVXY4bi85NFdFclJoallE?=
 =?utf-8?B?NkppRlhjQ0tkc3VUd1NVMGNtMDV4N2xabWlKckFaYnV6ZXBYRGI1WVptdDRN?=
 =?utf-8?B?Mm1hZHZSV3pOV0FWQWh1R2FoV0FFRjR5RnJPdHUzSVpTSldRVmM2dlIxQXQy?=
 =?utf-8?B?RStLWFhZdjhyY1EvN2ZZckFGaGtPMG1RZTRCTGVRZ0x3Y21QbWx4M1ByTFlL?=
 =?utf-8?B?SVdJak9PRjByeHN1dUlRdW9rUmRodGV0UnNYVlpKOFhyclhHUFh0SW52eU9s?=
 =?utf-8?B?cmFtbWRFdm5SRG5UQ0ZxeGhqaVNXN3ZTdlBFVXIvTGx3UnNaOCt1UWNZWjZz?=
 =?utf-8?B?b2dQZjdtd1BJUjNONTdJNGxSK3Ixa3JsQTJTL1dXOFd0NmJ5YjRnZjJVZjJ3?=
 =?utf-8?B?YTdhb0ozRjIyVXgrYXpNZG5TTzdBak83b1I3dmdWZmlyTUR5Tis1SlRXVVQr?=
 =?utf-8?B?Vm9XZjFuY2N4MjlVZGxhc1ovYXBSU0Njb2RzaGtramF3L3IvVDg1aUp4czdY?=
 =?utf-8?B?OHZMNXpSWGFER3BST3lRRzdTeWN6L2Z6Rk9acnp1WVNTZThDSXBMcEhDa0ZD?=
 =?utf-8?B?SHFUejBpbllUS3RRd3VMcmF1R290MFdpVVB3OWRnbkI3aUVzSmhRN2ZKRE5V?=
 =?utf-8?B?OUd6TnFmTlhGNWVsbE45TlgvRXV6ZVJWeC9STzdqbTg5SlBzZ09KWkZnM0I2?=
 =?utf-8?B?TXl0MVdySjM0bmhSb0ZLR25XdUxKTFJ4NnlpUTdudFZLNjJOYzh0cjRzL1hR?=
 =?utf-8?B?KytNZzJrV1Vqbk12WGxBVFdoY2dBaXNlZHBYQnQvUjRuR2lUaWhnVUVvUk1o?=
 =?utf-8?B?TmttTXgrK3hzVGpTRHpZSGJHYUVtdlpSSldTTm5PdmpkeWIvWFp1cnhMWHhx?=
 =?utf-8?B?ZTdFd0xzaE9tZzR4ODQ3eDFqZ2tzejVqSTdML1NCUjJhbFRkakMwRktrc2lC?=
 =?utf-8?B?bnFMazRYUGpYVUwyR0ZteHoza3dQeUdJN1J6cHNmZloxcU1KOVFyM2lPQy80?=
 =?utf-8?B?eEg2NXpiemZiNEtWNjhST0lrbXpVQzZ0bFFDcFZrM3VCaDVKV1JFZDhJdmZL?=
 =?utf-8?B?TkRZSjBOd2VQYWRPelp3a1VXYVJzYnRva0taL1FUZlJXUkdYNmhQWForVURU?=
 =?utf-8?Q?i2YCQAl27HUZU01HlO/12WBjR67KsaS0Jr5YEGz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7d23ef-e441-4dda-691a-08d8ed902a4d
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 00:11:11.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLBy6UI28sIIHlRgRJebUJqGklZ+25gb+HFOvm1NHbg+q88mtFRJax5B2kyZGXm2hTbA7/E1NRPmiz3g7+leuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3813
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 12:22 PM, Mike Christie wrote:
> On 3/10/21 12:26 AM, Gulam Mohamed wrote:
>> Description
>> ===========
>> 1. This Kernel panic could be due to a timing issue when there is a
>>    race between the sync thread and the initiator was processing of
>>    a login response from the target. The session re-open can be invoked
>>    from two places:
>>     a. Sessions sync thread when the iscsid restart
>>     b. From iscsid through iscsi error handler
>> 2. The session reopen sequence is as follows in user-space
>> 	a. Disconnect the connection
>> 	b. Then send the stop connection request to the kernel
>> 	   which releases the connection (releases the socket)
>> 	c. Queues the reopen for 2 seconds delay
>> 	d. Once the delay expires, create the TCP connection again by
>>            calling the connect() call
>> 	e. Poll for the connection
>> 	f. When poll is successful i.e when the TCP connection is
>> 	   established, it performs:
>> 	       i. Creation of session and connection data structures
>> 	      ii. Bind the connection to the session. This is the place
>> 		  where we assign the sock to tcp_sw_conn->sock
>>              iii. Sets parameters like target name, persistent address
>>               iv. Creates the login pdu
>> 	       v. Sends the login pdu to kernel
>> 	      vi. Returns to the main loop to process further events.
>> 	          The kernel then sends the login request over to the
>> 	          target node
>> 	g. Once login response with success is received, it enters full
>> 	   feature phase and sets the negotiable parameters like
>> 	   max_recv_data_length,max_transmit_length, data_digest etc.
>> 3. While setting the negotiable parameters by calling
>>    "iscsi_session_set_neg_params()", kernel panicked as sock was NULL
>>
>> What happened here is
>> ---------------------
>> 1. Before initiator received the login response mentioned in above
>>    point 2.f.v, another reopen request was sent from the error
>>    handler/sync session for the same session, as the initiator utils
>>    was in main loop to process further events (as mentioned in point
>>    2.f.vi above).
>> 2. While processing this reopen, it stopped the connection which
>>    released the socket and queued this connection and at this point
>>    of time the login response was received for the earlier on
>>
>> Fix
>> ---
>> 1. Add new connection state ISCSI_CONN_BOUND in "enum iscsi_connection
>>    _state"
>> 2. Set the connection state value to ISCSI_CONN_DOWN upon
>>    iscsi_if_ep_disconnect() and iscsi_if_stop_conn()
>> 3. Set the connection state to the newly created value ISCSI_CONN_BOUND
>>    after bind connection (transport->bind_conn())
>> 4. In iscsi_set_param, return -ENOTCONN if the connection state is not
>>    either ISCSI_CONN_BOUND or ISCSI_CONN_UP
>>
>> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
>> ---
>>  drivers/scsi/scsi_transport_iscsi.c | 16 +++++++++++++---
>>  include/scsi/scsi_transport_iscsi.h |  1 +
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 91074fd97f64..19375f1ba4b2 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -2475,6 +2475,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>>  	 */
>>  	mutex_lock(&conn_mutex);
>>  	conn->transport->stop_conn(conn, flag);
>> +	conn->state = ISCSI_CONN_DOWN;
>>  	mutex_unlock(&conn_mutex);
>>  
>>  }
>> @@ -2899,8 +2900,13 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>>  			session->recovery_tmo = value;
>>  		break;
>>  	default:
>> -		err = transport->set_param(conn, ev->u.set_param.param,
>> -					   data, ev->u.set_param.len);
>> +		if ((conn->state == ISCSI_CONN_BOUND) ||
>> +		        (conn->state == ISCSI_CONN_UP)) {
>> +		        err = transport->set_param(conn, ev->u.set_param.param,
>> +						data, ev->u.set_param.len);
>> +		}
>> +		else
> 
> The else should go on the line above
> 
> } else
> 
> and I'm not 100% sure but some people prefer:
> 
> } else {
> 	return -ENOTCONN;
> }
> 
> because the first chunk has {}s so this balances it.
> 

I actually prefer brackets all the time :O, so I'm good with that too.

