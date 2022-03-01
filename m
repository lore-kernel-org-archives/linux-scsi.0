Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9831EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 19:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiCATVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 14:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiCATVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 14:21:23 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E83E52E22
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 11:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646162440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDlDth5ggx5pO89R2vL++L0cFqfRLT6z6Xp4oLlAKks=;
        b=JP7pmIgmosS/7Gbvif9HAJRnUOd+oLXiAFLug0UMrs0dvSLj2OAJKKJH0w9iiVHqbtiFmt
        KW4NehaIcdiD3XAHnaL3CHD5S7cpd3m+xDWOnEtEU01k3oGxFHfMSRwOoMctkYhjHvqaJB
        rtgUBLuAI2Lx+ocmLuB5+J2o6Hel2ro=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-10-_heMHfKsO_2hueyfxZQnTg-1; Tue, 01 Mar 2022 20:20:39 +0100
X-MC-Unique: _heMHfKsO_2hueyfxZQnTg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXBoKQZvorCYe4X6dzyzPaqEP9UldNJEomq9mgLiUbus8iEgQT/O/nGwbzS1Hu+xvMcb+VPqOqDkSgY2av7Fl2/fBM4+v0xXzCLjouAurHD8hHqH8U004poXfKn20slnmjkT8Au8uDjbN1ukBnGsCBHWYfR8YIUikrRlnb4OB2pS7RG0dRFN3NvVN59wNdYsqJuS+27RZmpn94u9DRd2pBdBk0dZNW4lO1fgTdn5ORkAVCcM1yjEoQVow5Dy7vLdmmaIc49Wy5dBmRqI/BQL+dRuo0QX9oMYkqjclUWw/X46JnTe+ND5xbjwGzVX5wAYrb3Mq4C/CWqs5b7+9iTG8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDlDth5ggx5pO89R2vL++L0cFqfRLT6z6Xp4oLlAKks=;
 b=nzxsptVqS6QKm9p+L0gZ1TRtgZ4HG1mQVREZqv+Wv3otM8iIfo4Epup0zO+GD6rI9p6YprRt3CjBhk6iNtLL/QPkewpdUn+R7OE9UpOVT5HQds1izqoh4wrhachLVv0W1Bl50wyhvFI50KjG+t/TXtf2OxJjIBqLvfm8CPeCVWFrqMn8ZrwNT6Yps+o0mlOSDHtkW9NtCvEqsBBmm5Ov9iuH8I0z4im3wjq7n697HXHbglTdzZcouMDIWYIk5GuNEH1C02zUD9DbinffBbX00p7/dKdhxlzDkfgkHj+VVqeBJbmSHIdzbchrdj2g0Bta51spVQyziujsa2yGOrCbXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DB7PR04MB4859.eurprd04.prod.outlook.com (2603:10a6:10:18::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 19:20:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 19:20:38 +0000
Message-ID: <ab4cb09f-cecb-0c1c-36e7-07db2556bc61@suse.com>
Date:   Tue, 1 Mar 2022 11:20:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [LSF/MM/BPF TOPIC] network storage transports managed within a
 container
Content-Language: en-US
To:     Chris Leech <cleech@redhat.com>, lsf-pc@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
References: <1cc5dd40-47e5-0756-db22-42e4e86468c5@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <1cc5dd40-47e5-0756-db22-42e4e86468c5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0010.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7904734-a982-49b8-fc91-08d9fbb89135
X-MS-TrafficTypeDiagnostic: DB7PR04MB4859:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB48598FA91535D700B986B2DFDA029@DB7PR04MB4859.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ef6hccKG5b3gIWZxClbRYPt1o1jZ+SpTkoO9TAXRufojJeHRjdN+Nb26auVuoR3A4yF42hVkZVG2WJp58uHZCiZ82nqFBS5UArXE+HhQH/5IdvDdvEdVgr1xegpb+i+DvvfxKIHKEoaAlnoB7fJpyXfAbFAasOpAMCkQUYqqhIXZNd/2HqyIErTOltPVF92kw0wk7qWar6wUgROlyQPpmQG1QzoUqcqiXeo3JrtTVMCgN5G6Q2hPR6VKAHw0MZZnXkJqEOe/5NV5IT2OSd1RVxORql37AL1I3lPb4lHWYVoRWtglJQsVRLyLJMjL28hX0UvtZNUF7AATr1zmhlD8VNnMafmJWjk88jaf/y4mQ5sQmmHvCHZBOmEJRJhqYSJ9sLJxShENzQyBnHuVitpTBusCpvcrfSdX2ZVckXGZpq97jpAMGQmYAcS70EjPJeQHzXvFpGScUyKETqRKmDT5FUe9yHXbG3rTSYoaFplFdQ8+cv2CANJ1Wr4OTmFeO71aB+OOsJcHTjeZd+HUcN9D2HzdM+S0y7wCjcUKOnQGD++/Orn0ed+kZoEzhkuX5PA1eNzcMWZ004y6qEnLWOaO/hHhikJK9JQT4QrHJDoR03Rt2d86tYoPCbNqVKUupgogaVW2Uh0f2LeuFHbAuL9Ur2LcCf2YVYLCYEHLpNlYxTFxuBVIMND9PX3f0lH2pyh33qknOA7V6YpwM6pZg+dOszvw0xKz31DFb78H85dMYjchwabWMp8W6GcZ36enKGb0UhDkoryrooTq6l50od3c0C5ElVp3ZEeCAI7RSd7ZnerMJHWXu5MVe+CTDON9sPbC7oNjs/7hvaWtO4auoD2aCyUfiW5zakI/ctaO5HPhXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(186003)(26005)(66476007)(66556008)(66946007)(6486002)(36756003)(966005)(31686004)(508600001)(6506007)(6666004)(53546011)(38100700002)(316002)(8676002)(2906002)(6512007)(83380400001)(86362001)(31696002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnhzQ0tzOFdyR0l6bkljUzBBREV4aTM4ZHhDaUFTYmFlNHh1dEE3SWtmTlR3?=
 =?utf-8?B?VFhRNjJkR3JqZy9OanNDRkorOVQ0VnJ6UEtkdzYwRHBaOVRGNER3ZU9TMC82?=
 =?utf-8?B?bllaL05lREh3cFZuYUVGMk11cWNjNW1CbmFZUWpwOFU4UGx0MXhBWnpaR0pv?=
 =?utf-8?B?MElxZzd0V05JeXRXS3BOM3NTR3ZqdU9DVDFxMzhYdXJEcVRXSVJnQkxYTFJz?=
 =?utf-8?B?YXZ1Vk9hOUIyeFZnOUhGMUFBNnplNkFKSThTWEQyc24zL0FZRnFDb3Zra2tM?=
 =?utf-8?B?UkJWL0RXYnNrV3c2cytZVGVyK2t6YUdSaVlxSklWTEJvNk5nU0NaWlRaeHNl?=
 =?utf-8?B?STBsRmwyVGliWDZPWnVKcXdWQkJsSE5OUlV2Z0VQNFcvMytDQjRUeDRoSTRV?=
 =?utf-8?B?bWRGUC9TMnNsejlMaDA4QWhmT21KMCtKZzllZytSQmo3Y2RZa2U3MUJrMFlH?=
 =?utf-8?B?RmJXdW5EQXI4NHg4aEYzblZCY0VkcXh0b1d4MU1uTE1LMEwxRFBxSC9acERI?=
 =?utf-8?B?d2RoL0dyZFYwdnlPTmRkUWUzRktPOG1waUN5UXN1UHF1RmoxV0ZYRSs5dC80?=
 =?utf-8?B?N1RJZitDNkxFdmZ5MEtGaTZzMlFBbHJGcFN2OS96QWNXaVZBdzBHZlpFM1R4?=
 =?utf-8?B?MVVQZzhvSUNkN0lqNFE5eE1JTC9EazNROGtldndtM1pXczhkS3hFSmNPYkpv?=
 =?utf-8?B?WFBpUDU3ckFzMzNPOTluNVprUDUvUmsyT01ZL0RWdlY2eHZTaFVGNmVZS1BM?=
 =?utf-8?B?VHVDeWlMSUxRdlh2bWdUdHBiNzZyM0QyaFFsQU1abnAydWVXRHJQdXhxTFp1?=
 =?utf-8?B?V3dyZEJGcXRuUm5aQS9lblQvcFl2NytxY1FMdmFIR1YrdCtucGJDNzZuNTRP?=
 =?utf-8?B?Q2F4QW83WXlkNHVnVEdidlkvanh1Z3FwaS9hSzdIVDFxWTRJWktsd3hYNytt?=
 =?utf-8?B?Q1hhbUtIemU1a3pVL21BUTVJV3lXRFJFcUp6SWtZMDVVaXJCUzY2MGJJNUZS?=
 =?utf-8?B?RVpZYmdqS2lRaU9HR3dCZXFxVE8yMEZZUUVyaTB1R2w5WWptVktHdnNPaE1l?=
 =?utf-8?B?d2RReDgyais3WkdmeGR6UHZmTkpVdlZPWHZPbGNvUDdvbldSUmUvMWVibWpJ?=
 =?utf-8?B?VjFzUFhaMjI4c2h0elVrWGZxcnBoSHVWUHZQSGpESVdDS1FsVWpuRGtWV0ti?=
 =?utf-8?B?dmxCbVNWdzlEN1BwRVE1Nnd1WWJ5aElHallVY0lIUnRnUEFRNWZURXBENVI4?=
 =?utf-8?B?QSsrc0cvcWFUR3BqZ3NRU09nTE56NkJGWEd0S3N2RnE0V1B4VEpKNzNmWGgr?=
 =?utf-8?B?TkpUcWRuNFhheUdnU3gxN1pqNFFjQjBXQ1FqRnF0cEQ5NTlySEswRDdFejdx?=
 =?utf-8?B?ZHlxUEw3cVgwNGY3dEFnZ1pvVXlVcmpuNW9XbStteHZzeXR1Y1Y1aVZ0L0E2?=
 =?utf-8?B?RzRjazI4anYzdC9oUVd6aUFFM1k0R1c2amt0Mi9EUGlkVnRZb2FkYnNCaEdi?=
 =?utf-8?B?bWlLR2pBS3p0dVdrMHhKTGo3QUlodXNORStvMVcxNFZIMWdPUTBhM2M2Q0sr?=
 =?utf-8?B?aVkxc2dQOXVMSEZqZEJyRktDZ01kZ2wydWJ1MHQzeDNFU1NUenA2N0xwak9w?=
 =?utf-8?B?MkZJMHZMOFBZK1VOS1I3bUE5djBncFk2SytwR0ExcEF4V2Z5TWxKY3ptaFVa?=
 =?utf-8?B?ODNsclpsZzVvVHhhYklEbExWcFlRcjVLNTVlbXh0RzBKTnZyb1BtdkYrNktW?=
 =?utf-8?B?bk9qc0FoWVdPOXR6bk15WTduVjlUZkplYzNYMU92aHJzTnpFamVhTkFCbFJW?=
 =?utf-8?B?elF0V0VsUWdFQWJKNXBiRUo2aXFYdW5pSEZDa1pTT1cyeUhMaERzNFUzU0px?=
 =?utf-8?B?bnhUVitVYXhIaU5ZN0JFU1hoMWRzTjA0Z3c3UUJDeDlRUEljZ0dHeEo4bnIr?=
 =?utf-8?B?cmVWWGw2N1llZ3BuQmx0dDFyTzQ3L1NiMFU4eEtER3RPMFFmbG5KQzhEbDVN?=
 =?utf-8?B?aHJLU0FLeEhpN21XN0pOTngvYUw2NWFJcVpEY1JMUDRPNzU2OWRkbXE2RHds?=
 =?utf-8?B?OUFNNTIvYnlQSjZZVnFzSXZOVSs4ZjM1T0UxWDlWeElBeHBXZ0JvNTJsSTFS?=
 =?utf-8?B?UUVTZEk5SEpCN09jNmppcFFueFhBa2NTT1JoWUk2aldQZ0lRMERhMFVUUW00?=
 =?utf-8?Q?Yg2A9lr/ZcftKTYmkaa0FLM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7904734-a982-49b8-fc91-08d9fbb89135
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 19:20:38.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hLem63UTrMG/KncfjX7TWDZm8cmLy3TNHxLr2uONYJAspI7WCheVKOv/NXdYQjzEyPuy5yU7XP4aw5xeAYUpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4859
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/22 18:04, Chris Leech wrote:
> There are various challenges when users start trying to manage SAN
> attachments from within a container, and how we deal with network
> namespaces.  I think it would be worth a discussion around what can be
> agreed on as desired behavior, and what it means to attach block
> devices from a containerized environment.
> 
> iSCSI has a number of issues here with the kernel to iscsid
> interfaces, netlink and sysfs, which are largely fixable without
> needing to break anything.  But for kernel maintained network
> connections, there's an issue of interacting with namespace lifetimes
> without a process.
> 
> NVMe/TCP has avoided complex user-space control planes, but when I
> checked subsystem connection occurred within the active namespace of
> nvme-cli, but afterwords all fabrics subsystems were visible,
> controllable, and disconnectable from any namespace.
> 
> 
> Lee Duncan had submitted a proposal to discuss this for iSCSI last
> year [1], partially based on some older work I did that never
> completed [2] (I need to update that code)
> 
> [1]
> https://lore.kernel.org/linux-scsi/e9f0297a-a914-ba83-f706-5a2d508c666b@suse.com/
> 
> [2] https://github.com/cleech/linux/commits/iscsi-netns-old-wip
> 
> - Chris Leech
> 

I would certainly be interested in attending this.

-- 
Lee Duncan

