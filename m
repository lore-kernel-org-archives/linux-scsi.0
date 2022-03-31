Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0028C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 18:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiCaSGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 14:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiCaSGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 14:06:07 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813181AE618
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 11:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648749855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY0Pezn2W42s75adMAD6iWQD4I0I9GQHRWuUjxiYMWg=;
        b=Bd9H3/X91iCn3b7YyRwootcEhSRO36hZ6DkBvR/Txdqj7CrLQbPM+zkJ8Cyrm5PMfuDAy0
        ZGb84F7HnfBmEDUXzmN1n6j3eG5srBa4twCoD1YgG4s3bvJ+KsvApJzbzvDrYq+kCch6iN
        +tkS1sHpQUagv6jJC6hXbvLE+olOlmk=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-4-qA65pIXoPTOO87R_9-I-FA-1; Thu, 31 Mar 2022 20:04:14 +0200
X-MC-Unique: qA65pIXoPTOO87R_9-I-FA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnylwzPXvLbOKAYvGVmoFvpe/4tSkp+ALGi43JJm+s4nnxLM0o4X6OtPSE+hluzo4bcTHcEztKCHtpTApukiFY0lKPry8zRKzo1/GfAH0oQVANrdmRF7VaiuRHOvwHTqTAGk18mJHKTxiDYLFx0/Sh/mqz/LzE6APahnbJvpqrUVGYC/IDH46dy4KawFPhzwInLe/KIe/1HMmjquD8pq413JlO0ulFVEVitMcGmWB5aqvNFeWq7J78IEWMyqa/2w2p6TtHBtpEUwIhZbAsqRt5j4iCkEKm8tXwCRPtGvsMTM2HpjTvWMLJPCeFn0LkEh4e4krhpZwhZvoYZFbNbvFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NY0Pezn2W42s75adMAD6iWQD4I0I9GQHRWuUjxiYMWg=;
 b=BDIGTYdHHKplwBArM8A5lWvp0gS4jfA4x2xgVEqyBaooyeFK8OVruHqzxymGFlA9QCcou/3WyI7tG4Cfk6Q55oaoB3yjjOUiHsrIB5HT8TW5fAKCMq4LZwMLw5+CXxqXyiYlzzoQab1D6hEerWhT/wqz2c4ckfAl4bKR+qOSdBbKue/Ph6XUTfybPSAU2vUgsz823vDY8lqWihOVAlZGqqPwkqZIRTKflZqaCfdAByvfw39gGnfH5ZMyALicvw7aLEaOysZklbCUv+wuh8+/P4h3EeBwDJiJ1X2KTzBvVfdiHW119UxYftO1NRd/gmCjewfJosbymzERYPZhryiP+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DB6PR04MB3061.eurprd04.prod.outlook.com (2603:10a6:6:a::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.23; Thu, 31 Mar 2022 18:04:12 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 18:04:12 +0000
Message-ID: <18c77ee2-68e5-2cc3-206e-2cb0577dac8b@suse.com>
Date:   Thu, 31 Mar 2022 11:04:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V3 02/15] scsi: iscsi: Fix offload conn cleanup when
 iscsid restarts
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220329180326.5586-1-michael.christie@oracle.com>
 <20220329180326.5586-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220329180326.5586-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0028.eurprd06.prod.outlook.com
 (2603:10a6:20b:462::16) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 357f3faf-2b7c-41c4-e8f6-08da1340dbb3
X-MS-TrafficTypeDiagnostic: DB6PR04MB3061:EE_
X-Microsoft-Antispam-PRVS: <DB6PR04MB3061ADDA9A77D52BC8F1C719DAE19@DB6PR04MB3061.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ENFUqGQpU5HmiM3yL/53pt7Z7yzhy88SczU1KbIQLQYwMEod4R0pV8DebusnFnJUeBND5362BlSl8LgsA65Im0VHDKY5I40SSUlC3F7dwPIG8/GhTD2fRFGtC9FGQ4fxBk81MkTzu5ba1L06RlkXIAYzOPxY/XQ50f6njoYluxOMqt2D8eMFL7E9dO2Q0XZ0TQoR6WCCfsco0xNdFbqJMFVoPPMsdTBMwfZDxjaiGqYnFUYrvGOMhLJP6SdnEwQ0RVfBR2AUyocgzT+pZi6EjJ1uOi3CS6yoMl3zuqp30JlDtHRAoe51NnotG5i6/juGU99yrPS0czGpCtpW5NEgj4QKOLV07FceiWi/LxCZhL4ix9QJIlNYJJDfvUKSSVTxbg3f05G6GmWZEEhczSd87XJBYZf7C9dESkfX0LU+cVv/Jk0mluhNitPs4mg3nyxZ3VXgUPvV5whl0bOoVbizxJ/NdQaUbkGuGpzF+nv3J+Lq74IjtrBESg0WZ8Sd6IPL89VJx9Zicz6tkB/XltUmepvt6QcagD/dx4qwkqHxcIufnxfxdEy2fXQdjyiV4gJSCQ5tfI92u/mfWwSMepsE7P0hgF6tQiu9BX+vWpkfekEfVbuVnudqTuMUNaw/CSuijO+AumbNjfN0iRsvlixC4HIP8WhnkKOwwCN0TGB74FHNekgumOraYySoD/umpnA6zgM/F0zLXPgvqYNf2cBIZ07nKO54ihJEOpzwl5Gngu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(26005)(6666004)(5660300002)(316002)(508600001)(38100700002)(86362001)(83380400001)(31696002)(8936002)(186003)(6512007)(2616005)(6506007)(66946007)(8676002)(66556008)(31686004)(66476007)(53546011)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFV3akIyRHlHUnFnaHF0ZS9XNThwSzZQN0RDb0N0TWRYUnFmbWp0THU0VXhP?=
 =?utf-8?B?aGJUMjEwRHVIOWE1ODQ5dXpvTkx0TDNuMEZGdTdFd2UvNGo3MWJnbjg4RUtz?=
 =?utf-8?B?WGtPL0J3TTEyeG1VSENEK1hZYWVLMHN4NHBtd2t1aDFBZEppaUxNSUZncW53?=
 =?utf-8?B?OERnVS92L0RKWXB4Wm1PRjA5YjRkSzZKbGg2RVJPMCttRklHR1F5TzlVT3VP?=
 =?utf-8?B?QlRLa3o4cGY5djM3SWloOVlqWjJyZjZYbkM0VGxxSnhZQ1dKTTVtQ21LODBC?=
 =?utf-8?B?SmRHMlYxVXgzWVF2RXpvYlNhb1pKelNRRGRKMlpaQ01hZHBsU3Y2Skgra290?=
 =?utf-8?B?WGVlLzlMRnUrQ25talVuNVd0dExidjJWQXRhL21vRDh6UThQaFhFeXBDMWJl?=
 =?utf-8?B?OVJ2enhCWk1ORTlDOUJ6Y0Fsc0ZiSzZ4WFY2NE8rU1loVUV0REVnMlZGZ0U0?=
 =?utf-8?B?ZHA3anRVWHBtSElRN3dtWktUdzlFYmdZNThOMmlaYTJFTVJxTStBOG1MUXNK?=
 =?utf-8?B?SlJMTkwzSDlkQWRNaWtUQ1pwZzJWSU5UWlJwWnhnSGx1ZVJjRk9lbGVQNjkz?=
 =?utf-8?B?eWpMSjB1amh0LzhuWFJMQks5MW1aNis3akZLSklqYi9mRy9rb0g4a1EwdWln?=
 =?utf-8?B?dWJkV21oUWpISXprUm5mdStFVFJCZk5RTkcydzhBR2xXQVFDRTFkNncxNUxN?=
 =?utf-8?B?bkU4QmdSMDVwRzZOVFJCOU5YRzJvdldZbjBWNjlmekJOcjBBUy94ZDRYekpu?=
 =?utf-8?B?VXFSQmFzRkVXbUVZVVBucWxsY2d0UzZPaDZOY0Nvd2F4WTl6cVUwekg1WldE?=
 =?utf-8?B?S2Z2Z2VxT0tsYmwzYmFLUUxOVTBscGIxeVNOejBUYW9RTDYvK1QzZ3ZQUFlD?=
 =?utf-8?B?ZTZHS2ZwZGhIZU5MZEJ1dDFjWVVKRmtEZFg1TzdmME9lN0ppUXorQWlPRStC?=
 =?utf-8?B?YXJaVlRsbTBNbEJvdmI4Ri9MT2JDM2RyWjI2VjU0QzNlWWZ0VHI4TDdVeStE?=
 =?utf-8?B?a0tVZk8rRkJGUDVsVm1OZ2xwcnFRa1Q0VWNRY29DSzNtcC9zZWphOVlxZkpq?=
 =?utf-8?B?Yy9udU1ubWRjYzRwYWdwZ05lTFIzMmlGcS9kd0R1SEF1UmZUbXpkZ21yTklt?=
 =?utf-8?B?ZmFINHU5V1RUVjlLYXpNUzk5RFh5VDRJRjNjZy9ZQjlNdzJDaGZxOEgzcnZN?=
 =?utf-8?B?Nm5OLzNrS2xDUWZjOGxrQ3p2b0g1UTN4d2FkTm9JUG9tS1ZrbHMrSFpWdlNy?=
 =?utf-8?B?blZVam1BVDVMK281cVZQekFFbVFlVlFuNXpLVy9CMzFsOW5GR2c5enlrSEJ0?=
 =?utf-8?B?UUNHUzFYYzFYVTVaQkNmaldZYTdJNVcwUE5yRC9OdW8vQzBqRVJmaXp5UzZW?=
 =?utf-8?B?aDEvZVNySmg2cnhucFhjMWJwTGtBQ2pIdXlNWmJoNnk3eUJHMTN5aDRxN1hm?=
 =?utf-8?B?MU1vL3VpSFlIcFFCZ1k2emVUekttTGlkSytxTnhxcHZNM3VmMVlEVENRQ01W?=
 =?utf-8?B?cXczcU8wNlBDd3A5cHpmYmRBd1cvbTN2OU0vZi9wd1hXS0ZVT3lYYVBtUVk0?=
 =?utf-8?B?MnhpOEZXRTNJUUgzVVJzd2gyZmNha3RUTzgvbm1VUHFqMnBVbm9PSWphTWRo?=
 =?utf-8?B?TWN2M25LWmNVS1crRVAyWDFqOU1lQ3NWdlE4MzVMUmtZSGdtcHlWTXl6Tm9j?=
 =?utf-8?B?dkp5VXNqQjBubmsvdm9Mb01Xem5taEFmOEhnTk5pVnp6cVh6bVdtTDlWNWtB?=
 =?utf-8?B?L2dKMGo4N2VxZmVVME5YcXB4WVBMTkdhQVNUcm95MDNXTmxGOGM0eEdpQnJ4?=
 =?utf-8?B?YWlNR0VKcnlYeVBuSVYxcXR4QzloSlZ0c1gxbEw0Vm5VQTJ6K0ExQTJpL2dX?=
 =?utf-8?B?MnRkTkhsditlZEFaNHIrQWJPMFduejZTNDVtUGI4Q0VLZDAxbEpkd0JBZXNz?=
 =?utf-8?B?UG1zUkdoR2x0K1U4am5PcDNOR09OTGt6NHZlMmcweVBwMkwwKzl0TFVVNG5L?=
 =?utf-8?B?VmhWTWswZWtGRkZWL0xjZGR0TmI2S20vQWgvc1d6UTd6bERsSExKeSs0cjB5?=
 =?utf-8?B?Nnc1a3RqTGNYZDFQT2VUNlU0MUM1dkN3ZUsyYnRKdUdJMHc3WitQdXd1S0pj?=
 =?utf-8?B?dDRDeGFWYjNHT0VHYWZvMTM5Z3B6bHZaL3RBZ1hGeHhDOFFWaGFPL2lURnRO?=
 =?utf-8?B?ZnVRakp0elZpTzM0Y3dkN0NPcWF1d0Zmc1lCSklRbFRsbXZqVmNMR0FtL1hl?=
 =?utf-8?B?MEcxVU1MN1ZpQ0d3YTVFMGNuSURCelhKcnNqNmtKVXBxL2ZIVFY3Z0FDVTBl?=
 =?utf-8?B?bkNQaVpDMnFBUFpPWEtVbElOanRvZGcwVlZSRm5Id2JoVDJBRFNYQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357f3faf-2b7c-41c4-e8f6-08da1340dbb3
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 18:04:11.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24QXxLjbSSDMy8ZUnFcemZxI9c2oiCotZUAy5MhnLvkCH1BfDWBXysqeKH0VQmQiXExcZ+uq+wc9OASrdZez/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3061
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 11:03, Mike Christie wrote:
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
>   drivers/scsi/scsi_transport_iscsi.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4e10457e3ab9..4aee0441e624 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2260,6 +2260,15 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   		 * Figure out if it was the kernel or userspace initiating this.
>   		 */
>   		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +			if (conn->ep) {
> +				/*
> +				 * For offload, when iscsid is restarted it
> +				 * won't know about existing endpoints. We
> +				 * clean it up here for userspace.
> +				 */
> +				iscsi_ep_disconnect(conn, true);
> +			}
> +
>   			iscsi_stop_conn(conn, flag);
>   		} else {
>   			ISCSI_DBG_TRANS_CONN(conn,
> @@ -3704,16 +3713,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
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

