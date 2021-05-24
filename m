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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62866C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3852A6141A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhEXSjk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:39:40 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:50051 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232547AbhEXSjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wf6sGw5j29IlrGMdGagtRS7BKlujm4KB2qtRCD5WclU=;
        b=mxl4Eal5xYM2H/1ETgpEi2ltSVfsbZuvR5vmLsaOsrtr/o4FEs7LM73ProlJ0AC+5f95LY
        qiLjAyKDmImWXjRCfgGcspXWUJ/PN0YJRoc7PFSavMQZL2i2PB0XJiZ3PKKrqm7XtdsD2i
        u9NQO50aUQEFEyjwU/lgDqDWpaFqCWA=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-mSbtu40yMXCMW49iDYcteA-1; Mon, 24 May 2021 20:38:09 +0200
X-MC-Unique: mSbtu40yMXCMW49iDYcteA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6RaMrdnFNvwf1V1IqJh4n9DJw4Z0nFWUisaj8oKbIgLNx+4KkKAp9BF/gN38Kqsr+vGovS2XYS8ieww0dRvW3ExhLxPGxsucpTwc2cxBME4ytYzlrSuiOG6KID1IpDDITMwuuxS3fkudPIRcX30z84tI6y4vfBDO2nkgzfrnDWPlangLLBbfODhfOmva3I5hAbuTkP+b6/VEUxa4NxtTRW9+QYrYkQhlG5YX03DXnCjNz4zFhWAfdhOh3+nbxgBCjp1O7a+OGCu6y3R/LoeFclMwPZgrhTb8uc6xBn4F1JPUfbWqN6CRewVYM5rXEwsywBuDBX4j8vTHZojuonR6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wf6sGw5j29IlrGMdGagtRS7BKlujm4KB2qtRCD5WclU=;
 b=QWJSu8OK85Y6cB/fTdO5jzUXNccguMjOR/GUrpOa9s5nNOL2NP97h5pnJxV/9RH7WVv7jBqWpr4QjG0gudveIEFlJAhxj1Jum7EL0sgGeq7KG251O04HII1ADrvKemnRjSJYzMWuRrnC3rRnHYtiO5djxlGe4RijpejPCYxQMhiFqcF1xlY/ks7vDGy/G83pZvv61cwa4g1O+KDL7L2BpgslO9j8aiFz7uOW6A6wFrvziBXRWvYzaPINxXewYtF4FzKFrvKY74ypqMb0N2FChUKm9eFqWMM1N+e2A/hKp9pMZCjPh8n19ofXEnNjCpPUND43MIXhHqVg+ceQ4p0Hew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6342.eurprd04.prod.outlook.com (2603:10a6:20b:f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 18:38:07 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:38:07 +0000
Subject: Re: [PATCH 15/28] scsi: iscsi: Fix completion check during abort
 races
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-16-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <6898f9d3-fec3-d5e4-eb50-2ab0ddfa038e@suse.com>
Date:   Mon, 24 May 2021 11:38:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR05CA0127.eurprd05.prod.outlook.com
 (2603:10a6:207:2::29) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR05CA0127.eurprd05.prod.outlook.com (2603:10a6:207:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 18:38:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35a80641-bbc4-425e-cd07-08d91ee3130f
X-MS-TrafficTypeDiagnostic: AM6PR04MB6342:
X-Microsoft-Antispam-PRVS: <AM6PR04MB63425B040DCE01F3EBDE8DB3DA269@AM6PR04MB6342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kRbwzTzUwaoLtfFNp4iNC36JVvNyj2kYZ510LMMg3J9QOGpcCyjWOpa4dIvz8mQvFqBBkakmKtCZnd/OgxO8QuigEe7JkGYosBvLKiYejf0+88xEVEQe7+v/P8y6HhQTOXgcZdRG3vHvmSD81V2ujHBxFOCuC6mfgZGuccjSCMmZYouyCrvBc/NFU0NxIzLnfnu3AwH/e7alVIz4+JwE9J0ORaFoejGWz6eT0Mxoq0fsZA+xpOuAROPpyDtTqf6pRFn8f7huBN69CyWLk4zFKhc8jvq7/0rAylUEMdunLl1jyu75oX1NK3Oi6sNnUEAsb7Qtbcp8n0qPKY0lVcgLoS9NJ810UnVKfXKWgqUrO2Doph8S6FH4KU6XcMo5OlgaTckrcn+/eVfz7SxyzH782XOmokWKCyucycTPBTYxefsF3sSFlvT03Gh8MbqPcJHtZxU6pB1MiMf6jQYQPlHLscWsGT04PpG+GO9XpirHbwn5Ptk9gNPSboqKN4jGO9boMiJ6vvjVRKE7RSo4EQizzAePcsHJo/znD5ARHBQO2zN1CXas38/Jo/YwGdGzNQjNV5RW1KEGT2WpqO4Rd9uesCNZNPoxrB5Vq5GFVZxb4YQxsunDtgGlYVeOcP/8C1l3X2ryRXrCR4NSENEOwekWHkDVzz4dVnB57V5UqfPX8RuulzQa3LNF1vP/u01Kzmf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(39860400002)(376002)(4744005)(36756003)(478600001)(956004)(2616005)(186003)(16526019)(16576012)(31686004)(316002)(66556008)(66476007)(66946007)(2906002)(31696002)(8676002)(5660300002)(53546011)(6486002)(26005)(38100700002)(83380400001)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWtnT0w4eEtiMkFqcTZ2YlJzV1RyNE9yMjFpUkpSOVIyd2syd2xCOER1dEVN?=
 =?utf-8?B?NGdzWXltV1N5dzlKemdlS253RVRSWTN0TEovdUUvY0FCc3JDSklqa2tFcTNB?=
 =?utf-8?B?NzBsSWMrUDFSVnZ1dDNLdkk0TjZyQ0xmbm15bVcwOWZJSjArMWdZb0FQL1k3?=
 =?utf-8?B?KzBBYzZwYmtUVEZmNG1XbXBsKzdHNFJ0M0pIVXlLcVRUNUo3c0diZ1pZTG12?=
 =?utf-8?B?Y1BTOE9OTW0zVzRHM2FoTTFUQmpxYXFzQU1RcC9rQ00rSm8yOWtxWE1tVTFB?=
 =?utf-8?B?RkhsOWNiNmR3N0RxdUpmaUZmTXlSc3I1QTFyVVg5N3ZvOWNGUkNzNUF6U1Zh?=
 =?utf-8?B?ZWkrNlpTN01uZXJYNkg1QlVMWC9Sb1hCcUx2ZUhlZDJDM1RYd1ZuSVRtRy9S?=
 =?utf-8?B?ZFNFcXRuY3lwa3YvUlVIb29UZ01vWDBOYVYwU2pIQng1Rldhc1lMR2xaUVZx?=
 =?utf-8?B?LzM1cjV4SmhZWnJhbmxGeE04eDRib3B0U3RPQnhhYkxLVW5NaTZkRmdCc3Mw?=
 =?utf-8?B?VlA0NmlIOE9tZTB0d2ZBQlFBVHRUTXVwQ0FYejYwYmdqREhnMlNQaHZOeTQ5?=
 =?utf-8?B?SytsakR2ZDZHWm5LcXl2cmRha21nOGgxSHRla3VVLzJBSXB5MzFCeWh0NmJQ?=
 =?utf-8?B?QmRtdmdCMWNya3JzTmx5aHpNcVVhcGZvRG0yYUo4czUxRDMwdW5HQTl1VjhQ?=
 =?utf-8?B?Y3JLeG1MaGtuS3VpcTlLQ290RkxlbVlwQnZraDl0eTVtVWt4WWlrZTBDMnJC?=
 =?utf-8?B?RmFvS1pqNmQ4Ynp6NVNmZmU5UWFiWk12VXRVb0UycVJkS1huWGlDb3Irb3h3?=
 =?utf-8?B?cUZwUWJpcVE0dmNhSzB4RHhEYVNYV0ZHUHlkZ0k2NFJ2cit1aGprMmFuc0pJ?=
 =?utf-8?B?bkJ5bzlFd2d5OEV6bFRFZ2U3a0VLZHlJWWtHWDd1c0JMUzFyaDVCWVhWRXA1?=
 =?utf-8?B?TXJFUGtlMHZtL2pjTVhDV0N4QmhTeGlhb1NwVEswaWQwYTFhUmJXQkh0TU5B?=
 =?utf-8?B?YWkzMkI0R3JRMVNQMTJkbVdpTVphYWRIMlRaYmh0VGtLQ01vOGx4TWxCbHYv?=
 =?utf-8?B?dEVUVFl2Z09iMGVURjFlWFdXZ09BSEk1aTBSU1hLSkRiK3hWckFEM05TZmVL?=
 =?utf-8?B?T3orQlZiRkZDTFZHZGMyQ1RGL0hiUGIyMmp0ZCtYZ28zZzF5eVhBSHNZSlZa?=
 =?utf-8?B?UXdxeVJVU0ZiLzlVSEo4MHZsd2VUTHU2SlVVMWN6L2dMUEdORi8rL1d3UnFU?=
 =?utf-8?B?L0VsRlJ5aXZkREljcFBKWENTTUd3Vndhdi9jS2JSTndldFJDc0dsY3BlZ254?=
 =?utf-8?B?N243ZWlOMklTaU9uUDRzMnR5UnE0bGYrQ2lzMENMZFFta3ZlaFprOGRLWUZp?=
 =?utf-8?B?Y2gyK0t2dDFnMU93WE5SU1NBajlJZ0hGWjFLYUtPVWxTZXRlSURQSXhxNVZB?=
 =?utf-8?B?dnEzbUgzQmFlakJTQVdGWXZUQWp2UjF5VTZTOWtqbEtuTzdaRnJTclcyMkNo?=
 =?utf-8?B?bnVLR25reFk1MVVQVDllakpKWHZvSmVIRENjb1VWbFRRV2NVZnAyVmROSiti?=
 =?utf-8?B?MmxoaFo0Y0hwd2ZPa0pkaHdUSUNDUVV3Z09FZ3BWck9ER05ja29FdVAvcFNk?=
 =?utf-8?B?bkpjcmpqMDhvckJQdVBPRmN3QWN5ZG1CQm91UXQzMzhabkh3UWQ1NkgvOXhK?=
 =?utf-8?B?b2w3djhmbjJsSXg0blBxaVBQaWdoWjBkSXlReXJyT09MSktzOXRJS0N4eVFK?=
 =?utf-8?Q?7nLsBRHijcvfp360jqDl21Vz3t/OZSpHQuwP53B?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a80641-bbc4-425e-cd07-08d91ee3130f
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:38:07.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkpaZVClnZq1IiZ81E475d6vBBNrXxKAZSShaF0mOmizsvoeZH3jrrLDEfQExocbzQ9H6ZrGlLuLHCN1p+5U2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6342
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> We have a ref to the task being aborted, so SCp.ptr will never be NULL. We
> need to use iscsi_task_is_completed to check for the completed state.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 94abb093098d..8222db4f8fef 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2338,7 +2338,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
>  		goto failed_unlocked;
>  	case TMF_NOT_FOUND:
> -		if (!sc->SCp.ptr) {
> +		if (iscsi_task_is_completed(task)) {
>  			session->tmf_state = TMF_INITIAL;
>  			memset(hdr, 0, sizeof(*hdr));
>  			/* task completed before tmf abort response */
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

