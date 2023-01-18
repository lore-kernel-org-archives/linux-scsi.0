Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5CEC678DB
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 19:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjARTAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 14:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjARTAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 14:00:01 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246135AA69
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 11:00:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncokzGwZPPVoV83Ksbo4/6m817rtooiBRbzYgoR3F8d09xTB9ra8/N/88O/vzcZJa939CZdrNs4y6s4Uqre+JkVvn36UYWqZo7H6+NnkNDLwtXpgmr8/VqFs2nwtfLOTQNT2/ZdtetefdTEDVcSf7xYJl4SyUDOR8E2v08wbD6DjSlDZj05Hi9IEglDkAYlRSHhYwxOu8DpShXNjjca0w6xOkuTjvq0Mz90jwIwFbYROIbF/CGOCz/tBc6pA6THt9uOA79WPrvVkOi/4LrTYsTxftJBxC/fkk0Ttz+Fjd8MI1JPy6dhScJiGa7bZQ3ORCSjgwlMLzg3uDh1N+cxSPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAYxZdmwK1/XG3jApPKNcyWGk7cUYyRlKV4VdHYoIuA=;
 b=PMx/ZKOfUT0TBY42OMbCEVepe6r/MZMLFRUEPfSFk+ttnqRVgntjImCZes7FerPYLcTZDOPSGvn92vmanAiP4ZPlbEanhA/e0A042p03KpuRXCptnZK+G7QKPVI/70AIswgw5qcrGwm6KCAzIriNx+ozWCeqW8PUQogB4a7+Ndq8ZsG4cgv9XFTAGLALCa2gJUCmdncYcLMSOBEk34G2NZAINabsZBDfcti5EI1lrqF/q/5dFrhPdNKwLl62mYg+pLVlK+Z7YS+nvO51vFcrMNEE8FUoxMRra4bbVJZWQKIUXqL+WoZGu4gzEz9w+MOjIGLWgCm5AAURKjgut1uw7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAYxZdmwK1/XG3jApPKNcyWGk7cUYyRlKV4VdHYoIuA=;
 b=Vbu17CH3JCsOYNZOaWN459JqL3lV3Uqz3qIpD2pKoeOMUtvaS2gkO9S+8hxoO+WnBksD/JK1ZB7/kBwWdd05Cx7skT6FN83FP/2IrckHvqpnSobtF0HkQh/5FFfHggqjbsCDkyqEKV0/EsPn6v5DralOef6Fs1Gz/TYelGkFYv7aaEFLDcBSWmL8ETjjuNPv5p1+zxsEmWtp1Va3zGVhUi7Z+AHfZJ9YlSD2eUqNxp5rFbkuDVlBsNk7GJbB0VEMWS9aXkvuW7q/gXWqt1sRig4Q0wCI1I3fOJQSIjFjO22LmHQfZR9WcgtYIj7Mdh/G/O9RqYeslR1ttKs+VIgekQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by PA4PR04MB7902.eurprd04.prod.outlook.com (2603:10a6:102:c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Wed, 18 Jan
 2023 18:59:57 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::913b:8afd:f0d4:9a3f]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::913b:8afd:f0d4:9a3f%7]) with mapi id 15.20.6002.012; Wed, 18 Jan 2023
 18:59:57 +0000
Message-ID: <eded75ca-ed6b-5e1a-833a-e3ebba843785@suse.com>
Date:   Wed, 18 Jan 2023 10:59:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Chris Leech <cleech@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM/BPF Topic] Making the iscsi initiator work in containers:
 network namespace changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|PA4PR04MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 4799d3e1-fe81-424a-d692-08daf9863161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQOVZFYz6wb+bSvU2rTVU7sdIT8xs68ORKNIovkjo/aidKf0MP4qodQ3UZ6AVjtz2dmT1KRkm/U/XY/Z+3FLfeagFlB4cNS2ZFx4XNEG8IqoZ3V6IdL/7JTitkL21jVettxoOfWkCJD+aRrqXYQMAfxwHwqq+jlPJWAnDWXqbjgT7a2zGY+0cBMxUMAtJb3tpkGvV64WMO1TlaX0ByQtJ0KE+HQdVwGwWsL75V+pIoqT9bymKwQVXztFThy74mwruPJG62REnqzpF/5EvTRzCkPAgO30f0RSlY0Lf5MGHMKKhXDMsA2vWuturdgkE30U3shOsDdTDM08NhSV8iX4gtXkDKdmgm6nBnzCOHVfvJCpu2707RNbpqis7M26Xrs3+TaDpVcztxPCd7qqWoIGXSKsjEK1eAOUBveKRDgO31xI+9DGAQ5QDe0OPr9pkdWSY5WlnjdC7S64h5eiLjHtqoTzYrRii5DDCBltdgJ4rlG7moDFNjk1Vrwrz1xj6l/9xOLmFW2KYoZpwPkg7SyhSwa6yTA10JqCUiHXEHq47Q99e+/e1YRF+dSMJjXnYIktlMNEhLniZOZyEvLEEgptW1+J9g/OsOGDCwEgRE8iPJCXtiz3sG/DWvSdJv82xM4pa2K9biZLWvZWB6EvCW0a4YABRfnbn/9dJZr1gMahkmTRXmPT4Uym6+fHI4UYl3e93CTtZ+qL5foAm0TKJcHCGDyOzn11BfSHVWgQtXo3avU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(36756003)(38100700002)(6666004)(41300700001)(5660300002)(8936002)(66946007)(66476007)(8676002)(66556008)(6916009)(2616005)(86362001)(4326008)(2906002)(4744005)(478600001)(6486002)(54906003)(26005)(186003)(316002)(6512007)(31696002)(6506007)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUJ6OG1rVy9DemlvTXBrbFRreU52MGRMZFBWQlVuWks1TllkSG5YOVhMTDhU?=
 =?utf-8?B?RFhDOGVhQXRwcnRCekxLWnlzTnE1MDBhVGMrc2RsM3h6OG8wRHFOdUwzY0JD?=
 =?utf-8?B?b2prckZDRjlVKzl3M2Q0NnRtazI0Y0M5ZmJYR0ZPTXdFU1M4Vm5kVG5TdEN5?=
 =?utf-8?B?UU5vdGlUdGJGbFBiZy9mdExUS0V4WUJlTWtVbVdXQTB2bzJ6RmsxbmY4bE85?=
 =?utf-8?B?cmdUajJRVG5OSTBwVnd6bkoxWUpCUGQyMEhxcXc1aVdiUWlrSGZKQ3NXZmVE?=
 =?utf-8?B?QXFicVVOT0ZGK2pNVklDMjROYVd5THM0eXRvMHFIQlVLK0hhbFJFTldZQWZY?=
 =?utf-8?B?dTJmSFBNMUFRT01ZOXlBbnk4ZWZzZm5MWC9VamdjSDc1amZzK09uK29TUTQv?=
 =?utf-8?B?dHVUWEZWYm1XdHRUcVNsK290MDdLb2laKzhMTGNKa2FMVG90L2ZkemdodlZT?=
 =?utf-8?B?eUYxL2NHNXZOamFDd3BWdjhiR05rRDhhWHRVQ3RuV1dyVTBKcHJPMWRQVTM4?=
 =?utf-8?B?Nzg5NUhReDNOMWJEMFZBTTJtam9rLzZCZlRLZXNzNjBtaVNYUkYzazFIQ0FO?=
 =?utf-8?B?UWUxTlBTaU9zWk9pTDFmdDJOdll4TEVtbHROVEV2VmJCb00zbnVhTkIyTFkw?=
 =?utf-8?B?QkJvVFlSZmlkSHExZGlDWmE1N250MjQ0bEJPMWdzeWJUOUJjOXB4NWh2VHEv?=
 =?utf-8?B?UDRGUy8wWmw4OEswWEdyMkI5dzhnamFBUlowOTN1WUViWTA4akRxek1pV1h2?=
 =?utf-8?B?NENFbUVjb2p1c1ZtdTVJWVZWYlRCd3ZDQUVHYXZ6VWxvRWZIenN4emI3dm9o?=
 =?utf-8?B?bVh4LzVFZ2hWTm9SZDhROHp2ZjZFU1Rzc3BaWlNIaGtjLzBHQWl3elpjbTdt?=
 =?utf-8?B?NSthYkNydHZNUUh2UERZRnMzREx6b3JRZmhQMWFVdEN0NWQweVRuK01pRTJt?=
 =?utf-8?B?VWFJNXBNN1ZsSFFMUWQ0RTFyMXJhM01rNnlaUjlSTHdwbmNSVGtCRUFsSllm?=
 =?utf-8?B?YVdwNVRSNTZiRzhLTFhEOHF2Uzd6ZlBETE03WGtXb1l3elZtMTJIbEsybjRY?=
 =?utf-8?B?VnVPUFcrNmFkNGFLWmNJNmdWa0NyTXE3TWw4OUV5blo1MmluNXE2bjNWT1lZ?=
 =?utf-8?B?VHZMT0hNb3piQ0xEdVBwYXkwSEZSSWErc2QrQkFNaUpreHpkK0k0aWdoOFcy?=
 =?utf-8?B?WmVYT09ZckFtL3BFWUxtM3I2ZlFHSDkxZG1TVEhWZDhpWXFEcFI3bEtmbDF6?=
 =?utf-8?B?dEdNVVpkdFcwU25scEQ0ams0QmU2azh2cVZIOHpRenROTnJ0UDhxalBkNjBF?=
 =?utf-8?B?TGZXVXI2SGk5bTVjZy9CeEJnZDZ4VlJPVnQ5SVBQem1ERk1lME5HZHhxWXBI?=
 =?utf-8?B?MVFkR0dlbFhGL3F4b3dEMCs2QTYwalJQaFVQcEJZVy9OR0Y4U0ZzZk1CUzg0?=
 =?utf-8?B?SENRa3RjYURKeE16SXBUT1ViRHRDVk8xemdXUVFnZ3hEU3M3V0Z0WVFlN1BG?=
 =?utf-8?B?WVdPZWwySFRQeVVLNkxndG42TnVjcTFFa0xBc01ORitOT2sxWlNQQmx6cUFQ?=
 =?utf-8?B?a0ZOSlZBWVFKbEZMSW5wN0hZQWNKb0k5cTdFbS9IUGJzN3ZIeW5CMTRwc05N?=
 =?utf-8?B?WjFqMlAxanNDSWVVd3pscEM4T0FSYnNFZ0xXcTNEZVNEaDNiTUhBM1hnUUVH?=
 =?utf-8?B?ZkQ5NmNid0ZoR1VMNWd2aUZlaDlCaXBLdzdlOCs5ZW5Bc3FIaVh0SGtmYnBy?=
 =?utf-8?B?RXI0VC9jT0xZeXkycVBmT081eVgwQXdIMnYwUXRyVWdyLytJK2VPWURHNWtB?=
 =?utf-8?B?bW1KUk9scWd5dDlkYkM4ZU9IN0VMYlBleC9lT1MwbmkrdzkvS2hKbDlDYjVz?=
 =?utf-8?B?N2c1bHl5YWZRTE00TElHcUNnajdnT2pOWXBTcUlWNHhEUnVwT1hGZm1uOHM3?=
 =?utf-8?B?ZzZGaHc5SWp6YTJZVFZOOHZwRGwvNmhFOVdGNUROVXZCcVhoL2ZxU1RuSGZG?=
 =?utf-8?B?ZnoyMEdxYVJQVTVWQmRGZUViaGZyNDlkZEFxMjQxbUo5bzB2WTExN3pKSjc2?=
 =?utf-8?B?VkVyWlNjWnB4YkYzVUFZSE1KSmdGcm1paXVZdzEwbjBnWUxSbXlFMDd6aWNI?=
 =?utf-8?Q?v2WMdQWo9l4YeOxmECtpmRemv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4799d3e1-fe81-424a-d692-08daf9863161
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 18:59:57.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EP2lZp1xWq07fS4bcwdDyH4rP/Jb2aHf059Ae25Ag/tf0yxpDy2jYdUf0Nyss1ld/F4m+LnYd6vucW+N4J+WRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7902
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello all:

I would like to talk about updating open-iscsi, the standard Linux iscsi 
initiator, "namespace aware" so that it can work in containers.

Most if not all of these changes appear to be in the kernel itself, 
hence I'd love to hear from others about the effort.

This work was originally started by Chris Leech, but ran into road 
blocks because there are some corner-case hard questions.

The basic problem is that iscsid, the open-iscsi daemon, talks to the 
kernel using a netlink socket, but the kernel assumes one connect, and 
that connection to be on the default network namespace.

I hope to present ongoing work status and engage in discussion that can 
help the project move forward, since many folks have complained about 
iscsid's failure to work in containers.

If Chris Leech attends, I'm sure he will be able to add in his view and 
issues discovered in this area.

Thank you.
-- 
Lee Duncan
