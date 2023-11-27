Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ib/69eGa"
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2055.outbound.protection.outlook.com [40.107.7.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FB8BD;
	Mon, 27 Nov 2023 12:23:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RayQxzhjSNWbPQ99nk00zgVxPnizArfIXe1LqbwVcDU/0kRY127WSCB6LeEfp8BWpBcMKZxc/3XTEODbMQPvUa5YVelEZCh0czQhQ9GqdcpzbOp0wo766iadI+dkP5BlSl/a9tDtiEMfeasBwsCBc23EUhNvAPETPoPoxdxxuqajuoOBCqHBKAof3LBXe9t6ezfoR3ava75Lf3gYZZmV0lW3GFVgxUZge5Tultc8NII6buaGkRM9jGiWrwzv42I6x/80Svi+EHz75SoEiIkDlbw16X4+JKiPtd6PsT5mvfdoXFJXGXPgZ17TKB7Qx3EMEiFTBHaB2DHjcTqFdX4wdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=req+AudgninvIhaIGjTPR9Dp7ACwIcEvxWnDimpDxOI=;
 b=DO0DF5BoDyK0DmIP6sKT+5E3rlZXkF74BW0za6MBZMskixiHsRnZUdsb3l14bx2F3G+8DMNTuui9N3oBy/bUDpmyO53pAn8XTVV+711Vuw17znwKOGJKAZ35oH7UZj1SLlQoXaZQ57WzBePQkxfWCYRJEyvwEpQrqPjVVLYocsvGsc2uZGO+KpfAzXPjS594IeGL1ZAZKQ4y1qc9Bq1nGE9Kt0KQ9HwEtwlKRerzpgLjaIW2Mwmw0POSCI2UXftnpTH8chNcnoUIZPfJ6QCjZFr14ICnsEfKSdZQRqYR3FpQP1wRWp8glyXqiwAkhjw5YP7SE0idRGCRnOtwLjjxTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=req+AudgninvIhaIGjTPR9Dp7ACwIcEvxWnDimpDxOI=;
 b=ib/69eGa+tw+ucu+DqGExRJDfgQ5aMX9YuciGQ0uk569Yp7f83zbumW11inW2lmn8uZOMszpY+pEUwGfeNAuZHnmyRROnXy0F9hvlAUg/XwZ7RYKaim3BQ1ycboCuModhDi/cT6b5Zuuh5l4zNs5wv9soXgK7372I4GR3wZE3SIuO1ooE5vhKg970/tpwVSpfaV3ZvwmSVPiYuiQEn+ujkxNpP4544CwwgoCMm+TCEOJq3Qv/O/0OmvM/h9S0iFZOUI8hVdTw2B/d9H2G08K9Ckq8JF23fSuVvr5ArBK5Rbecxsi9wPg+/HC6w5uvbkVJzFu64rpSDVw6sJORgnLzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DB9PR04MB8124.eurprd04.prod.outlook.com (2603:10a6:10:246::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.21; Mon, 27 Nov
 2023 20:23:37 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::3378:bd8c:6ef3:8ee%4]) with mapi id 15.20.7046.015; Mon, 27 Nov 2023
 20:23:37 +0000
Message-ID: <8eaf4277-04cf-4c01-a96b-760c8fedd5e5@suse.com>
Date: Mon, 27 Nov 2023 12:23:31 -0800
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
From: Lee Duncan <lduncan@suse.com>
In-Reply-To: <5301e42d-7fad-49e1-8ebd-7db569416974@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0224.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|DB9PR04MB8124:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c269c3-5931-493a-d0f6-08dbef86bc84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3m85shM06/xKcL/O5nnmM/Q1cDuJrA/E3Ut9GtFg2xivc4Hmz2fVU5u9JsVQOiKT6U8/pK95OAfXluSLDRkOTTIuWEtwuxOqb2YcOrs+Y3tvBkEHd1+d3usFDCwRGCQs02igBABiUFkDcJFyY/tQQPRc1ARRqhLXjLojP5hrYl6Jxjscg+JqjKfXoalMHI9y3cD3jihw+Reduk+lgL2PYDx7gbRaF7jXDcECPVxIOIHmRItLgeTy6+ansBr//7b+bQwPijxeNO6Sys+ldQN+FjICcmjNvnlU6n5NmqMAknFrwi0b+jukfKsOKr93cQW2RL1lJ2gbLJwpbeIdrds02ZlJxduT2tXq8Cb4OKYk9wBIgAhodNoaTPsEQP3UByIqztsCYGPnTHBhwXkcv6xHjDVhdCsJwsIihczKmI82L38OyVzg7ktBW0LNtkUl8AJibw55zFanT4doPaw5VL032uB2VVBEwkkyOL8WzyzHMAXFP9N7jkxpZ5e0mjU+FA5HlO20+clJEB2aS2mbQko9a7YzCQLMjAgsxureFL4MB76Mf2QDAQNGbDrno+9A+4y2xvJTKY7Y5kwrw/bv4QRDm3mTU9uM4vO2v+5W7h2EBy//zfTNR4PSNu13ygh2m0/ZD7sbVAIL9dWMje+4brzXuBYP7xRdHXq4L1JHfQHHjHI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(2906002)(31686004)(41300700001)(66946007)(110136005)(53546011)(6512007)(8676002)(54906003)(316002)(8936002)(66476007)(66556008)(6486002)(4326008)(6506007)(6666004)(478600001)(5660300002)(2616005)(26005)(83380400001)(38100700002)(86362001)(31696002)(14773004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFBkYVdjd0YxTVhRaTljTU95cE9Ja1ovSGFmbExwTEdHajlxTy9FL3IrZkZF?=
 =?utf-8?B?bEViMkswdDFoQ29sUzBOZUx1cFVLN3Ftd2diU3dpUUd0eWFXS01nSHNrYzhS?=
 =?utf-8?B?TlZtTk5na3g5Y0RORklmVEJtMkdlYUhyL25TNTdSQVp1dkhnb3JxcHA5V2NJ?=
 =?utf-8?B?ckc0dG9vQ3ZnN3VETDRnWFhkVjU0eVAwWnNEK2FvSkZEa0pEeFloNUdCY0hn?=
 =?utf-8?B?QmZrYitZakpxZHN4aWVpdXRDalhIZWV4V2pUTFJjdm84Zmd0Uk5OVHVXOFRj?=
 =?utf-8?B?QjNOakkzSzJFVjFHaDRrQlNicmdOeldNMkoyNEdDeDFDWmg0V0duMGtqdDN6?=
 =?utf-8?B?T0VBaEJRaWZjcGVYY1M3ajR2QkNWVE9XeE9hNllCcmYyTkF4RWMxTHhqN2Rj?=
 =?utf-8?B?MW1LM0VJV0c4eGpDWjNJNTFaNi8xTEYveGdVU2RHV1RMczFkSFlvYkd5WEtB?=
 =?utf-8?B?eG9BZ1grK1NzOERGR2tmMkprUlJydXJ2RGJHY25yTGFzWXhHTHl6eWQvZEw1?=
 =?utf-8?B?eER1eUhGTUg3MGxpSlBwc3pNQk9aOStEdDdMWFhaT3gxTld2YlJWWkxoSjBz?=
 =?utf-8?B?TmJBR1pvNUVUVWovaExBZWk0a1pjVzhyemdYTDgvQVJpYU9uK2lmYmV0TUZ4?=
 =?utf-8?B?dS8rNjE2UjdwbVAzckJwbEh5RHByR1Y3YTQ0U3A0TitsamRWT0h6TGxJK09E?=
 =?utf-8?B?a3BGY2Ewd3RpaWhJKzhwa3RCNGcxNGNsMFNsN3ZKcTZWaWc4bC8rY2lkam1m?=
 =?utf-8?B?c1BZK3NPMHlsdVc4eFRmTjFCZjEyRGpsWTI1NDdXbjNwM0cwbFJBYml6WVg4?=
 =?utf-8?B?cVg5bzNrVlhkdVRhMlVLR2RpaGxDOG5kQU5lMDZkN0VLZ1RKMml3Z0o0THRk?=
 =?utf-8?B?ZHoxSTdpTGhvTUZyU0JjK2FpdDJoNVFhaHVWTC9iMzZRNU50TW14ZUtDdWlX?=
 =?utf-8?B?WUg1MHozVGJYNnFGRlNPZ1lsTHVVZEFrUmR6c25Qd09SQVp5SllTMHVYV2pl?=
 =?utf-8?B?MERrQkNneG5xeDJZVXdxTUNLcTJLalJlcmc2SjN4YitoaXlWb2I5ZkpYS2xl?=
 =?utf-8?B?K0RmY1lvdnNnVHgwRUgzQ25sUDl6enUxd1MvZ3hRTm1HYTJNZjdiMjlrWmNG?=
 =?utf-8?B?bWU5dW51dFRTZHUvSno0NUdKVFBhMWFUL091V0pRSkcyNW51MWFDS1pxM3VT?=
 =?utf-8?B?VUVFSEtvUmRsdmJFdlNQbWVwYk5WNktTSFFKZjdWMDJVaHlQVHJpc0hVS2pt?=
 =?utf-8?B?a3JqaGpEbmxaNXMzNFRqMk52bWk4ZTltdTJhV2ZrWmJTbUVrcjZDRjJLc2FR?=
 =?utf-8?B?UkNBVnArTVpaU2JlYWN3eFlkY2RGM0xEWlB5ay9rM0xzeTN6N3h4Q1h5UXF2?=
 =?utf-8?B?SklQYUNhZ1QxUEFlbDA4a0NnRndPU3d0N05sSHRMSDlYREZzMnRkYWFiSDQ0?=
 =?utf-8?B?SEl6SGVmUXZtRkwwcHBDNjdoQWF5M3FRQ1ZRb0hYWU5PRFZ4TzFwWVMzZXZT?=
 =?utf-8?B?ZUZXaVNTSjlhbWVham5GTVh5TUpacjVNYy92N0R4Wms5NWk2YXpLQUJKNkFP?=
 =?utf-8?B?N1Vka3J2aVp5VUU3Um9QVGZSNkorbG96RitJaTZMWmhtM09MRFpqNVFzSmNm?=
 =?utf-8?B?WU1OTkVpZDZNcnB0Vy9GblRSU0xOT2VOK0ovbFRpQ3RtemE3bE5PTVZpTHN4?=
 =?utf-8?B?bmYvY0tWa05xRzlrdnk0VWp2OFAxejhLNnFVNWVHM29sbXh0ODBBSXppakFV?=
 =?utf-8?B?NXF1UGs5c0lOT0VvU2t1clNwMmJUVXhyd2VTaUkrczlsRFVEbEQ2bVpYVk9B?=
 =?utf-8?B?UmtEWkROOHJNTU1udG9heUdoeS9uOEp0YUQxakpuMHJVS2I0UVlFaG1qV3hJ?=
 =?utf-8?B?UU5Gb0Q0RGR5eWZhcmhmVGE2dE1TVUlySzhzbWkrRzRlL2N4V0dDZ2F0a0dN?=
 =?utf-8?B?YWNrMEpHanZSdGo2K3lWOGY1a3h4Lys4QmU3UlRkVnFkUk9EMkQ4NFkzbG1Q?=
 =?utf-8?B?WnB5VGRBbUJnYXF4SVB5RXhULzJKWk1Mbk4rcFlOako0SHVtTVVQajZFSnNM?=
 =?utf-8?B?U0VDMVRTa3hhV1ZWamZPUS9ZRUdKYW52YXkwd05JeHBnbkRSL1Jaa0xyZnpy?=
 =?utf-8?Q?xJDKcGThFoQfocg7cQtZulLBL?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c269c3-5931-493a-d0f6-08dbef86bc84
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 20:23:37.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zx3T5uYVuCGj3R4wDUswO4bFbe0Nnf9rRCyUKKvsSO2reyPl8haku0pLFjOyWDEllZqDabr8mnkEaxine/q/ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8124

On 11/26/23 16:39, Mike Christie wrote:
> On 11/26/23 6:01 AM, Hannes Reinecke wrote:
>> On 11/25/23 19:28, Lee Duncan wrote:
>>> Hi Martin/list:
>>>
>>> I am trying to track down an issue I am seeing when trying to boot using iSCSI root using the fastlinq qedi converged network adapter initiator and an LIO target.
>>>
>>> In this configuration, but using a non-LIO (hardware) iSCSI target, everything "just works". But when I switch to using an LIO software target, I get this error when booting:
>>>
>>>> 2023-09-20T14:10:32.835358-0500 worker5 kernel: Illegally set Immediate Bit in iSCSI Initiator Scsi Command PDU.
>>>> ... > 2023-09-20T14:10:32.835422-0500 worker5 kernel: Got unknown iSCSI
>>> OpCode: 0x52
>>>
>>> It looks like the fastlinq adapter is sending a SCSI write (0x12) with the Immediate bit set (0x40).
>>>
>>> The code in iscsi_target.c:iscsit_setup_scsi_cmd(): looks like this:
>>>
>>>>      if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>>>>          pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>>>                  " Scsi Command PDU.\n");
>>>>          return iscsit_add_reject_cmd(cmd,
>>>>                           ISCSI_REASON_BOOKMARK_INVALID, buf);
>>>>      }
>>>>
>>>
>>> But I looked at rfc3720, and it looks like SCSI PDUs can have the Immediate Bit set:
>>>
>>>> 10.3.  SCSI Command
>>>>     The format of the SCSI Command PDU is:
>>>>     Byte/     0       |       1       |       2       |       3       |
>>>>        /              |               |               |               |
>>>>       |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
>>>>       +---------------+---------------+---------------+---------------+
>>>>      0|.|I| 0x01      |F|R|W|. .|ATTR | Reserved                      |
>>>>       +---------------+---------------+---------------+---------------+
>>>>      4|TotalAHSLength | DataSegmentLength                             |
>>>>       +---------------+---------------+---------------+---------------+
>>>>      8| Logical Unit Number (LUN)                                     |
>>>>       +                                                               +
>>>>     12|                                                               |
>>>>       +---------------+---------------+---------------+---------------+
>>>> ...
>>>
>>> Where "I" is the immediate bit.
>>>
>>> Frankly, I'm never sure I read the SPEC correctly, so I'm not sure if I'm mistaken here, but it looks like LIO does not allow the Immediate bit (and hence Immediate data), even though the SPEC does allow it. But it also looks like, during negotiation phase, LIO negotiates ImmediateData like any other parameter, allowing "YES".
>>>
>>> In our testing, if we set ImmediateData=No in the target, then our problem goes away, i.e. we can now boot from an LIO target. This is because Immediate Data is negotiated off, of course.
>>>
>>> Is this a bug, or is this adapter doing something wrong? I would appreciate other viewpoints.
>>>
>>> Thank you.
>>
>> Sounds like a bug.
>> Can you check if this helps?
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index b516c2893420..ad68706ad9f7 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -1060,7 +1060,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>>
>> ISCSI_REASON_BOOKMARK_INVALID, buf);
>>          }
>>
>> -       if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
>> +       if ((hdr->opcode & ISCSI_OP_IMMEDIATE) &&
>> +           !conn->sess->sess_ops->ImmediateData) {
>>                  pr_err("Illegally set Immediate Bit in iSCSI Initiator"
>>                                  " Scsi Command PDU.\n");
>>                  return iscsit_add_reject_cmd(cmd,
>>
> 
> 
> These are different things.
> 
> Immediate data means you can have data after the header in the PDU.
> 
> The immediate bit on the header has CmdSN rules which allows you to
> send commands without having to increment the CmdSN. It's used for
> things like TMFs because at that time, the window might be closed due
> to SCSI commands having filled it.
> 

Mike: it sounds like that implies that setting the immediate bit in the 
header is actually not allowed for regular SCSI PDUs (like Read, Write), 
correct?

-- 
Lee
