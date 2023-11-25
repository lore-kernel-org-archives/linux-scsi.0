Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P9GMFzPV"
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2088.outbound.protection.outlook.com [40.107.241.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D6FB6;
	Sat, 25 Nov 2023 10:28:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHMHn2jws3UGTt8422G8KtSrODsh+kT1dT74/dXh1atlo28KYgQOloTWzzCiX2lxPXxI8xYLMm0MOR8Ns0ujb63bMidrxuPNFq0AqsbvKJSq3WPyBZU5CVVFU7QU+30AW656tjQGdkT1dUpOaPojKoNS5xtBjS+lkOX0g0PhCoBKJjE65ZUs8UmEmp32ooaC6sRoKpp3db9l/162HkXLXxPaoqExNmoR8LlZGb1LR8Rm9alfcLbXfn+17UgQHQ4S5Xbnd7+iA+rvebpw0KcUMUxFbQE0btRvX5nOyTSfVsFUh+iLje8iDtne5QvA4po1AsBJc/KH0u7KoX0ekZKIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TArVZY40VRgn40zXXmOtDkpPxzckcsYuS2WnnEQmQGs=;
 b=bUeZUW4mIc0MS3U0STXpuELSWsvFdq1dWJjgmyQ3JFILhUg+rz+KNSMdQYDnSZ+tFoCkJCGXE939BsvpAAjNMslLUxUUPC5nzFfr2bxSSz4k55cJHKCSppjNodlYv1rfFra6jOmeaqd5YQw2abWLDnZZ6PPIOcDrYqabAndwrkATYs5ee2Hb56bFLI9MobSObFNeYgbeDOSDq5Q+x/KhxN65AU7I5ZGTVvl4fYMozLQ9jXZzBDj0hVKa+XzYCWn+gyhXvOWB52kubh3CBE0UsP6rnN+uaE7/s9dZlfvH9FyrJ1qiHEkxLI6dfOJanok5YN9RfNg2sABsaOcRO0jguA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TArVZY40VRgn40zXXmOtDkpPxzckcsYuS2WnnEQmQGs=;
 b=P9GMFzPVGc+9Pk/3BkFkRDxwi6A8rQldRblOoGxQbI4RFd+9sdMfuIZ9ZSo9mVcXA8DXI2z1OC9LaWt57pmrL4oEL7ZXQtKR1fBPJiix44gYNjCIblJsrAwfoCSGX6VnRXNDA0pXdRj6Djkce97Xhb43MLg1NLu5ux+ICyWbNFr3ZXv3sAC65XALUun42aPLplpRJo77+zJyOCyOpE0YTTH3VBNPe9axEC9drBCK9BaGkJuiddk2HqGT6lba1Y2wqZHW0i76g0V/PX+U5sBQzKRoRQLW/dG7xlkan1ifEmKW0aya7MxOk2XvMId5rRg2DAqnSJ1QkfGEMEjsl6oLBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS4PR04MB9692.eurprd04.prod.outlook.com (2603:10a6:20b:4fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.17; Sat, 25 Nov
 2023 18:28:57 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee%4]) with mapi id 15.20.7046.015; Sat, 25 Nov 2023
 18:28:56 +0000
Message-ID: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
Date: Sat, 25 Nov 2023 10:28:51 -0800
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, Chris Leech <cleech@redhat.com>,
 Mike Christie <michael.christie@oracle.com>
From: Lee Duncan <lduncan@suse.com>
Subject: Possible Bug? LIO does not support SCSI commands with Immediate Bit
 Set?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0235.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::6) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|AS4PR04MB9692:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c6ed876-2d7f-4c72-0b63-08dbede46297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kkh8q/TgzCfYyIHmllHhHd6/MHBqrwsPUR7secy/TUsfSr7GjN8PXtsVoBAFiTHoJ+fhrtRW/PO6yAO5afyDb+vxN1U7Xu6iGHcvXAMaaOCwUfHFKi7BGS/JaUql6q/cLpOBNdjOBG0e5nKBRcWseZgohdgosuYbwO7VmFbE/LU939aL2W74AOoRWEoBziq9UprosvoeyNfSffJqPJ1TnxYDF3r7CMv1G+HTM9E59zqGfMaCV2VUgVWcu67m21tPKlbvmp0V1A5lM+e9HVLXOA4zI10HPjvY+BPxOxUmiSdT0fWZLXnzhDgIZhPwRewHVb3qAvtAs3O6fkGZoxwc/gDkLK0/oGCzjs7hqamk8yFkAbZJ77L/Ey0rTCpB4bNjOPoYMKTyP3inpWLH+waqpRDgB7wKrvetRSbvqyGk8DYB00w5isc6epNj2sibcHqpr09HbHPcwV7tqU1TqacAB/yI9+iljMtCV6LcPgegDHJTtDTGyaFweakLOAUDsZW0WNGsd3ry/gl2JUWudxQAiWOGv913/Lq1Uvcgrp9rDNSTgMXh7G0JEmEeLEpWudsjbGC7nQP3wB0bMHPdybQPEnuJvosNPujrgqZTBAjHGStuDQTInaABK0Zu5HGKyT5G9hFEEDeRlrqk9QlH3CdJqVYaMsFm7r14pAJ6WRKqpMA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(54906003)(66946007)(6916009)(316002)(66556008)(66476007)(8936002)(8676002)(4326008)(6486002)(478600001)(31696002)(36756003)(86362001)(5660300002)(41300700001)(2906002)(38100700002)(2616005)(6506007)(6512007)(6666004)(26005)(14773004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUhVRWg2Y3hLeUo5RzJYM3JwNlE5WVVzR0FiT3Rsd2ptc3ZLeGN0QmpYTDdr?=
 =?utf-8?B?NktpMlJTbmF2d2hHRmE3c1kvT1h5N0w1ZmdNMUY2VXMwcnlkYXkyRVc1UVBu?=
 =?utf-8?B?SlQydWhseWtvSzJTNE1SWjhnZ09nZExVUDIrbFhua0VLYlk4dTFUU3hQWW9G?=
 =?utf-8?B?ZGRsS0lSN2l2VFQycUVjYkpBNnFhcWVZZDZnL3pFV1NpeFNtbDJlTGszUUpO?=
 =?utf-8?B?L1NIRHdXVTZUVlpONEUvd3VZa0lTdmRIL1VmSWJma1puTzRYUG9Cd0REYXQ2?=
 =?utf-8?B?cmF3U2ZDTkdZZmhJTFNXNm1zZVE3UGdYOHdwKy8vb0ZtMjlVQ1dKZStidW0r?=
 =?utf-8?B?OVprMFJMUW0rTTdqaWtBbEZSS1VENlJFUk80dEhpMWI4N0RSeG5aNm1RblJY?=
 =?utf-8?B?T0tRTlF4cXhrOXVoWWNPOHc2Q1dGVGVpQWY1T1d4NUw2YnA1dkc2a1J1dG1O?=
 =?utf-8?B?UlROS3k0Z3FLdlZyOEJPVmk2WXVIZERJLzFUUENLZ0JyZFU4NjBpRVdzSEJ4?=
 =?utf-8?B?a3JUelM3Snd0YUtkWVNRcUsvNC9PR1hQaytFYjhQM2p1NlVVU3NpMHR3RUQv?=
 =?utf-8?B?N1RsVzVRSkxMaFZjaDQ4Q04yOU5ZSzVNMVpJVm5DRGFaZksrUmcxbURyc3lR?=
 =?utf-8?B?UG5BWnhHeGZJdzViQUJkK2tYem9LRVhxN1RGRG1INWRLTGR6SGNzcGp2NWNZ?=
 =?utf-8?B?N1UwUEtMVEJEaCtSaHUxYkwrcWxCakVvdEluTExnQkpuNmY2S1plWWFxVzM5?=
 =?utf-8?B?cVdMT3NJZ0s2OWNZWStMTmZQQmR6ZXV4OGxyR0FpRWZPbW9HS0QvN3JkeGU0?=
 =?utf-8?B?NUNzOEZjOGNyeGxUbVZjVzMzZmFmN2o1RG1yNkk2cTJSYW5zVlJ4cW8yU3kx?=
 =?utf-8?B?dHpjaXRWaFZYckk1KzB5T1IxYnpZNTgxTVU5RWlZTFByZWVrek1HcDJWVG9J?=
 =?utf-8?B?QkZGQldlSGc3eXlKS1NxdzhPbkpEZWNGY0hwbGpJT1VsdGYzeHExY0pOYUhB?=
 =?utf-8?B?UlVyaXFJVC9Ec29UdWtEU3grZGs2OUZIZ0VhNUF3ZkNQdjY3dzlITjEvaEcw?=
 =?utf-8?B?MXJWYVVtL25Cc05la2hiS2p4Y0JCbjJXN0MwK2VzdnRjc0RhUFBHVHZrWklT?=
 =?utf-8?B?M0h1RkoxblFOK2FjRktBUFJjVlVVM3ZwekcwcFFJaXBodlc0Ny9LSEY2dTZP?=
 =?utf-8?B?WHVxTGt0M2xYc0VJay9jN2txSVk3VjJxMkljWFBnaXp5YTEyci9UaWVsYUta?=
 =?utf-8?B?ckw4VGZwMWdaeEQzZnlkRmxrVVdoMmdDUnZuN0FFMUd4ekVyTWFTQ1ZFQ3Za?=
 =?utf-8?B?NzhGbnk5OXNpTTBHNERuTUppd2o1YkJlZjB4UWZpWTdzcVdYcXBxRG5HTlhX?=
 =?utf-8?B?NkFyYStkdEZjNXQrTWY2S1lCb3kvVklyajlzb3lwcHJqQmN3aXBvTUlqM2tp?=
 =?utf-8?B?T3Y4V2tMM1NOM3NuYlVocUNSaHJSR2lHZ0hTalcyUE5RNkwrMjgzb1lGTzRh?=
 =?utf-8?B?bXhKa3dnVk94T29mdlVDaElqSjlBSThvOXVwY0llWDdtSkYwVWNRQ2Y2UDVn?=
 =?utf-8?B?QUgydG9ZTmlUbE9uMWNIeDFOOXNKdDk3cTF6dWt1V080a2F4YU9Xd29XRE5s?=
 =?utf-8?B?TG1RUmMxc1A1dWwrR1N6dTk2RE12alY0bTFwSTlEZC9GRHRiOVdUZlg3cHRi?=
 =?utf-8?B?OG10bDVCVjdnWWJ2bjVqMHN2R1dhd2JtWnl6WXRkR3lCcE14bkhpTG4xZDhI?=
 =?utf-8?B?SjlqT29xUHVDbW5kdjlpTlNjTjQrOXhCL3ZxSzR6NlMyeHMzNHNVdnh5em8v?=
 =?utf-8?B?ellrUUgrOUE2bnpSYjNnRnVtR2l0Q1NWUTlpZUloYW0yYlh4WmgxQzVBcTFi?=
 =?utf-8?B?ZGJwY096OHBFdGp2TVhEeXVjTTRKY3dLOHdCZmE3Nll4V1h2R2VtUmxIbzR3?=
 =?utf-8?B?cFcveDFQQ3hrR2VVRjkySFBXNWhQVktsZjl2UUs2bG9NbjZTWGtHVG5wMFI1?=
 =?utf-8?B?Vk4zZHdYbURzVXRvNUlXekdQTStPdm8rNk9KajZHU2VUT2dWUWpsRnVsZnQz?=
 =?utf-8?B?b0dXU1JrOEJidWt2QzB6WHViY2ltbkhyRUlFUWQvSEovR0dlZG4wMXZzdloy?=
 =?utf-8?Q?zy4MpAP9RpfEbqRUt8XEqID4g?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6ed876-2d7f-4c72-0b63-08dbede46297
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2023 18:28:56.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gw4bsv3R+E9E0cZJxvx1L3MvmoUQgEjdR9kTCofU0rQad5tUg+jLKQVW9NcoiE57GTKDyQ7j+N84wFu+kBfAHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9692

Hi Martin/list:

I am trying to track down an issue I am seeing when trying to boot using 
iSCSI root using the fastlinq qedi converged network adapter initiator 
and an LIO target.

In this configuration, but using a non-LIO (hardware) iSCSI target, 
everything "just works". But when I switch to using an LIO software 
target, I get this error when booting:

> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.
> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI 
OpCode: 0x52

It looks like the fastlinq adapter is sending a SCSI write (0x12) with 
the Immediate bit set (0x40).

The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:

> 	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
> 		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
> 				" Scsi Command PDU.\n");
> 		return iscsit_add_reject_cmd(cmd,
> 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
> 	}
> 

But I looked at rfc3720, and it looks like SCSI PDUs can have the 
Immediate Bit set:

> 10.3.  SCSI Command
>     
>    The format of the SCSI Command PDU is:
>             
>    Byte/     0       |       1       |       2       |       3       |
>       /              |               |               |               |
>      |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>      +---------------+---------------+---------------+---------------+
>     0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>      +---------------+---------------+---------------+---------------+
>     4|TotalAHSLength | DataSegmentLength                             |
>      +---------------+---------------+---------------+---------------+
>     8| Logical Unit Number (LUN)                                     |
>      +                                                               +
>    12|                                                               |
>      +---------------+---------------+---------------+---------------+
> ...

Where "I" is the immediate bit.

Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if 
I'm mistaken here, but it looks like LIO does not allow the Immediate 
bit (and hence Immediate data), even though the SPEC does allow it. But 
it also looks like, during negotiation phase, LIO negotiates 
ImmediateData like any other parameter, allowing "YES".

In our testing, if we set ImmediateData=No in the target, then our 
problem goes away, i.e. we can now boot from an LIO target. This is 
because Immediate Data is negotiated off, of course.

Is this a bug, or is this adapter doing something wrong? I would 
appreciate other viewpoints.

Thank you.
-- 
Lee Duncan
