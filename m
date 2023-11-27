Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LrHc1Fpn"
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2063.outbound.protection.outlook.com [40.107.249.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAE9EA;
	Mon, 27 Nov 2023 14:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8mnl0F9oNdikgx9GgBUcpqKTQPyL+0N25EBUJtYW5JgtlLujqH3seUNgn2Qi3rTiyYtKUN1Bc34NPcdekCNTjpDM54GXurMrDzhLlchvNXPOTS2Bceiyrr4/GHpPTs2iXPCxjzWSYgnGXtTRBPlwNMvYUWILKkoM8AjH8Kr62nLNdUFms7wtey1K3ZnO/oHod4d9NNrBTd1mHikHxI5M03GZ1PFiQ/DVB1Fk6r1aNXpOSnRH6S9FdZny/a0MUBVQcwfUnXg8E9/EiaQsciZHEGnYYZy5uJdiJfbHwFgd4YMPGfsn3WRqy8uNl9v2J6vLPWWpaCtx+6HU+7rENLSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ga4fFC8Z+pr9DeRLyrmXRIPWbXuGZKAj2pb8MPGNSU=;
 b=MXdI1Q1kImpp4fQI8pa9ePNan0EMGy+FCUpdyVgQvFS1EBzXVIfhrq0+hlkgQjdAMlaHlkkqeuRT5zCbq+/BIuuHvq4eUjYGzLwf7/YZVs8xnvrRjt5UKdBjLkU/A+lVURYoumnT+6OHpD3paun6GthKlxjf+wGh8yCsy3vyZD+S4e19/dqT0cYgFKuf2E6uWB2NtXXUMIYANqEd/Mbndd6HGmN1DORTtqK6lda+Nsj+f+qmYpvRMZ+o2uAvURNwN95C0z6J1nBzjJT1r/Ww2dIx8qg+OFxcc0AwlMlp1TViod+QGnx0sNbE28vz/22KYBD/otlSWgPuCZ4l3iGLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ga4fFC8Z+pr9DeRLyrmXRIPWbXuGZKAj2pb8MPGNSU=;
 b=LrHc1FpnfK61aLwCK1HdaJSOYA/5I0emWacQiFccofDco1fZLFQ/QCGC9I3dpaOGQrKeoy9yZg9T09uJBpytLw+Ww9MAyIP4qQgvLlfYKwIiyomaVgWXKQugmOdvPHLsYERzcIWTB5n5BoJsMu0xKQK+BrIhMXU372bypyLs6T3kEJH1asscXcQHc2ghsUVTxdfwrVBRIBHE4ClEGgPBw2NOPoUSAUhGxsOa8glwlf0ISxNjOZtilZKDxcrBgcrZn6JGpGyVK61V43TsLnd6LW4/376w3An4ShwDxMZzRp5tYdo2WoDK+IMJQixAsf0LnbEXkLeviNt23r4Rg7lTlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8913.eurprd04.prod.outlook.com (2603:10a6:20b:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.21; Mon, 27 Nov
 2023 22:08:48 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee%4]) with mapi id 15.20.7046.015; Mon, 27 Nov 2023
 22:08:47 +0000
Message-ID: <6f177238-fd34-4415-9e74-2bd90351ecec@suse.com>
Date: Mon, 27 Nov 2023 14:08:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Possible Bug? LIO does not support SCSI commands with Immediate
 Bit Set?
Content-Language: en-US
To: Mike Christie <michael.christie@oracle.com>,
 Hannes Reinecke <hare@suse.de>, target-devel <target-devel@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi <linux-scsi@vger.kernel.org>, Chris Leech <cleech@redhat.com>
References: <31851279-0884-48ba-8c4b-7d6147e59508@suse.com>
 <00eb0928-5691-4e85-a923-de9c4934856c@suse.de>
 <5301e42d-7fad-49e1-8ebd-7db569416974@oracle.com>
 <8eaf4277-04cf-4c01-a96b-760c8fedd5e5@suse.com>
 <f30da2a7-90b8-4396-9bdf-922862195a0c@oracle.com>
From: Lee Duncan <lduncan@suse.com>
In-Reply-To: <f30da2a7-90b8-4396-9bdf-922862195a0c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0402.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|AS8PR04MB8913:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd73ad5-4497-442f-3f77-08dbef956de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5cqxGoRCuV4IQ7zuJaEoc8Ko//yP6j45O42o7xAHCzeocXwj3DHgCEWCTBOlM+dCq3VoZAwkrfhJqtbTx0f38wpyFVinCnM32GxP9OVgX1QJjmxx8ntxD6HamXdYD826J9TDvRuFWg8BpD0AZagOL8M+C9ojEpOgdwSXXEHI64qiFujpl8eJXUovga4P7nafCsT/wnquPyMC8xosY0Ybp9CK+hlpq2xt9wSUGPHviri7cvg2jc1AAcAGY7BLOWn14bQP2JLR/9aKS51PbeonCp7z6AwFYzwkQwRmILzDbcGhsl3GrfRCPb464v+0FFYx3+25hZN2EBtx+0TVMitmdQJ/LDHT/aioEwwT38kk/Y537Vp1qaWb4JRemcB5LGMC/V61J4FWizu9CFGNYspIoWYtMOiyJIwzV9tz94PUjzOfbTXdQOkJ1baTaAtaIFWqi/rFd3i69AYtD9N5FLB6Sf1a/tHouXoew93NmzU32CexyFxsjKirfOfFf9II158iMQ8STt1zYmR7Dxb8t++YLzJgpXNEqxmLGQUyM4U/9VPMTWy7qksggJPE6vDx0uqsjnt6j9w47iEcEK074OBwAQvpWwl3tOv6asjOKGICEdDLRZj4NpoDrr1OlCOP0Uk55KLQ18Ff0OJe6i3OlwriK/XNmE2FGMJrhwd7eKZAAdk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(31696002)(86362001)(14773004)(83380400001)(53546011)(6506007)(26005)(6512007)(2616005)(31686004)(36756003)(38100700002)(316002)(110136005)(54906003)(4326008)(66476007)(66556008)(66946007)(5660300002)(966005)(6486002)(478600001)(6666004)(2906002)(41300700001)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?am9wQ3hPNHBSOXFTTzRQaGR6V0VrWHROMTJlRG1pMUNhaEREK2pmMllrSFRF?=
 =?utf-8?B?Y1Qyb3Vmc0o5RWVGSjJBbmV6VkhkeHBKTFhTWVZ2aEZjWDVpNlFGMDJLQUtw?=
 =?utf-8?B?UjJXbnFIak1iQ2hBdzhZSHNiNzR1U0x4ZzVJV2tRL2lLVXV6a0hRd0J1Wnpq?=
 =?utf-8?B?bS9IWCt6Uzk5ajlCREFWTkJETlJDMXk3SU1hR0dqcm9TNWs5em96UFNsb0dZ?=
 =?utf-8?B?UFNoakl3Y3VCMFJDbDJSU1AvaFBMV1psVTRKeTN3MGxwN3dibml0UnB2UkZW?=
 =?utf-8?B?d3J0am84ZzhOWWowMlRiYUlpc1dkUmJDaHJKb1pFZGgyMzZ3eGh4eXJPaUR1?=
 =?utf-8?B?aEMrWW5CSGQxYzJhQ3RkTUhnZXBzSy95aERjUzhISzI4QTNBVWtFRVVzdlVi?=
 =?utf-8?B?aXIwdjFWSC8yUUdiQjhKVStlaC84VmZhMEFYTENKV2Rza3E1MnJ6QVJ1R1Nw?=
 =?utf-8?B?UXhJVGZJUEcrUHU4R1Z3VmxPZVpoUWxSMWM0V1l3T0xpWjlVWDNCYmhoK1Ft?=
 =?utf-8?B?Uzd2U0x0S3ZvdE5mY1lwUjBrSDVqMmtLUXVObldUWGFoVFBkaXNJTG4yaEls?=
 =?utf-8?B?STNua2xnUU8zN09TQ2lmTHBqZXNNTy92bXlVVHJub0xMaFZET29DbjYzTjFV?=
 =?utf-8?B?YmNaQ0RBNWNWSC8vVkxQZEE2Z0JQTUNldUMzUUNsVzVYNkVJRXpiRVFDdElP?=
 =?utf-8?B?YUNUOGtpVTBVSmhHd0pPN09zUG9DeUYzNy85RXo2YUVYcktXaFhlTmdaWXlD?=
 =?utf-8?B?YUdhWWNaV3FhdjRMQklhSjQrZXlpZUg4bGtndG5JOEk5UVRYaWFnSUtaVXh0?=
 =?utf-8?B?eUZEREd3MTdNdGQ4MlFrMmJ0blhqOXQ2VjRscGtUUmJMaDhZRlNCaXJod05V?=
 =?utf-8?B?aXV0emZlZ21JVEx4V3QwbE5xRGFwaGFIdTFSRUZtYzQ5a3UrYWtRdC95RVlT?=
 =?utf-8?B?NlU5TUVycjYyKy9LZUhjWHJXTnFTak9teHQ4cFlKS2tPTW92Q3AzN2pETldm?=
 =?utf-8?B?NmE5OUtCUVFTWHQrMlpLcGRBalNuUlhxelRKT1dHQVdLRlBlMFRpU0p1Q0ll?=
 =?utf-8?B?QW1RK0xzWFJaODF6ejhMSHl1cHBlZjg5N1oxbmZtMzNrTHVONW1wYkw0Tkh2?=
 =?utf-8?B?emQ4WVZHS096UDBFaG9LSXh0OVBxTWNhVlhXa09qQUZlcDlsdGpacjQ0SHhU?=
 =?utf-8?B?NFUyNEUrMWMwYS85U1RaUUJKUlZxRWlUZTFzYkZ4VUNMRkRGSlZjTTkrY0c2?=
 =?utf-8?B?aGhBY0o3c0RSRmo0U25tNFZBK3FIUnR5cUpDdDBDZnRWRVljNm4xbk4xRWZX?=
 =?utf-8?B?djFxWGZiaDlRUXpZZENIR0NHVVpad3JWcDJZa3Z0MTQyWWpGUUlHR3J0NjBX?=
 =?utf-8?B?VmlGWGxIeXRnc3o1QitEY2lWcXI5NG5OU1oyMVlTVlgxbExGL3VRMEZqUGkx?=
 =?utf-8?B?MjlKNHlya0Y1c3NjOGVseU5MVjBOb0NlM2c5NXFBZlJqUUV5VnFPNG1SUUF0?=
 =?utf-8?B?bUloNEZpd2ljcVF4cEhLZitjQjI2dEE0NEVFckJhb1hxM09tL3R4aXVnQkxL?=
 =?utf-8?B?SURXbWZrUFdVSDRtc29SakU1cE1YL0sxK25ob25hdnlQa0hzdUtITzgvOXFC?=
 =?utf-8?B?VDMvZUJZd1haSU0wTUphRmR4MXFleXoxYmdSY29vOHZJZkhmSFQ1eElTWTlH?=
 =?utf-8?B?d296WVZMKzRlKzY0bEpub1UrVms0dXhGZHN5NmRaKzFSbGpodHZTTGJEbnZT?=
 =?utf-8?B?amRocXFOUEVQRHRkanZocmVGSWt1SkNMeXQ2OVFZRVM1bGw2bi9NcHlycGxJ?=
 =?utf-8?B?bmxIU2F3eGszOHJ4NDQ2ZnRCc1JQUHdoTlRxS0prQm9rTGV0SXNMNzU3QVY1?=
 =?utf-8?B?elhtWHZiUFRNc0VRT2ZQYnRjVERGTjE3N0hEZ0hIWGowcHJJZUJpNkVCMXI5?=
 =?utf-8?B?RGltVStrSDBJMm9NREVVT2djZHpkNHc4WHpmUXFqeXYrVThYSko2MmUzUjd6?=
 =?utf-8?B?YnRiUHBiVXRoNlY2bi9SR2pWN0NQOU9XY0lDaVNqbGtMWkphcXpxNmd2dXht?=
 =?utf-8?B?OVBRdlBLbXl4by8reHFtQzlMMjhHbnVRZXlmaWFjSlhtLytxN0FoNUxDNHAv?=
 =?utf-8?Q?BAvBRg8SnpHlJefH2TB9SkoUt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd73ad5-4497-442f-3f77-08dbef956de0
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 22:08:47.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bL1sCc3Y2ys+9U+hoLsFWZbSPqKGE/pQaLWk+U6rb/x136NNK0pcbTg6ihVjGNiUqTAu8yvxtl7FuUFtnPHttw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8913

On 11/27/23 12:44, Mike Christie wrote:
> On 11/27/23 2:23 PM, Lee Duncan wrote:
>> On 11/26/23 16:39, Mike Christie wrote:
>>> On 11/26/23 6:01 AM, Hannes Reinecke wrote:
>>>> On 11/25/23 19:28, Lee Duncan wrote:
>>>>> Hi Martin/list:
>>>>>
>>>>> I am trying to track down an issue I am seeing when trying to boot using iSCSI root using the fastlinq qedi converged network adapter initiator and an LIO target.
>>>>>
>>>>> In this configuration, but using a non-LIO (hardware) iSCSI target, everything "just works". But when I switch to using an LIO software target, I get this error when booting:
>>>>>
>>>>>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.
>>>>>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI
>>>>> OpCode: 0x52
>>>>>
>>>>> It looks like the fastlinq adapter is sending a SCSI write (0x12) with the Immediate bit set (0x40).
>>>>>
>>>>> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
>>>>>
>>>>>>       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>>>>>           pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>>>>                   " Scsi Command PDU.\n");
>>>>>>           return iscsit_add_reject_cmd(cmd,
>>>>>>                            ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>>>>       }
>>>>>>
>>>>>
>>>>> But I looked at rfc3720, and it looks like SCSI PDUs can have the Immediate Bit set:
>>>>>
>>>>>> 10.3.  SCSI Command
>>>>>>      The format of the SCSI Command PDU is:
>>>>>>      Byte/     0       |       1       |       2       |       3       |
>>>>>>         /              |               |               |               |
>>>>>>        |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>>>>>        +---------------+---------------+---------------+---------------+
>>>>>>       0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>>>>>        +---------------+---------------+---------------+---------------+
>>>>>>       4|TotalAHSLength | DataSegmentLength                             |
>>>>>>        +---------------+---------------+---------------+---------------+
>>>>>>       8| Logical Unit Number (LUN)                                     |
>>>>>>        +                                                               +
>>>>>>      12|                                                               |
>>>>>>        +---------------+---------------+---------------+---------------+
>>>>>> ...
>>>>>
>>>>> Where "I" is the immediate bit.
>>>>>
>>>>> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if I'm mistaken here, but it looks like LIO does not allow the Immediate bit (and hence Immediate data), even though the SPEC does allow it. But it also looks like, during negotiation phase, LIO negotiates ImmediateData like any other parameter, allowing "YES".
>>>>>
>>>>> In our testing, if we set ImmediateData=No in the target, then our problem goes away, i.e. we can now boot from an LIO target. This is because Immediate Data is negotiated off, of course.
>>>>>
>>>>> Is this a bug, or is this adapter doing something wrong? I would appreciate other viewpoints.
>>>>>
>>>>> Thank you.
>>>>
>>>> Sounds like a bug.
>>>> Can you check if this helps?
>>>>
>>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>>> index b516c2893420..ad68706ad9f7 100644
>>>> --- a/drivers/target/iscsi/iscsi_target.c
>>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>>> @@ -1060,7 +1060,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>>>
>>>> ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>>           }
>>>>
>>>> -       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>>> +       if ((hdr->opcode & ISCSI_OP_IMMEDIATE) &&
>>>> +           !conn->sess->sess_ops->ImmediateData) {
>>>>                   pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>>                                   " Scsi Command PDU.\n");
>>>>                   return iscsit_add_reject_cmd(cmd,
>>>>
>>>
>>>
>>> These are different things.
>>>
>>> Immediate data means you can have data after the header in the PDU.
>>>
>>> The immediate bit on the header has CmdSN rules which allows you to
>>> send commands without having to increment the CmdSN. It's used for
>>> things like TMFs because at that time, the window might be closed due
>>> to SCSI commands having filled it.
>>>
>>
>> Mike: it sounds like that implies that setting the immediate bit in the header is actually not allowed for regular SCSI PDUs (like Read, Write), correct?
> 
> I didn't mean to say that. I was just giving you a common use, so you
> could check it out in the linux iscsi initiator code and spec and better
> understand it if you were going to add support for it in the target code.
> 
> Scan for "immediate delivery" in the spec for more details but to
> answer you question about support it says:
> 
> https://datatracker.ietf.org/doc/html/rfc7143
> 
>     An iSCSI target MUST be able to handle at least one immediate task
>     management command and one immediate non-task-management iSCSI
>     command per connection at any time.
> 
> For software iscsi in linux, we only set use the bit for TMFs and Nops.
> We don't use it for SCSI command PDUs, but from the text above it seems
> like its supposed to be supported.

I have scanned rfc3720 quite a bit (not enough yet, though), but I 
hadn't looked at the other RFCs yet. Thanks for the reference. And even 
in rfc3720 it looked like it was supposed to be allowed.

Thanks Mike.
-- 
Lee
