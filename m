From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 4/4] scsi_debug: add resp_write_scat function
Date: Wed, 13 Dec 2017 14:35:04 -0500
Message-ID: <dd732df7-7b92-8540-82c4-0abc705be747@interlog.com>
References: <20171212011008.27689-1-dgilbert@interlog.com>
 <20171212011008.27689-5-dgilbert@interlog.com>
 <1513107652.2999.42.camel@sandisk.com>
 <bd5c8092-76e2-f1d7-9294-aa0502fd4f3c@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39212 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbdLMTfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 14:35:07 -0500
In-Reply-To: <bd5c8092-76e2-f1d7-9294-aa0502fd4f3c@interlog.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

v2 coming, addressing some of the points below. Also there is an
issue when fake_rw=1 .

Doug Gilbert

On 2017-12-12 03:47 PM, Douglas Gilbert wrote:
> On 2017-12-12 02:40 PM, Bart Van Assche wrote:
>> On Mon, 2017-12-11 at 20:10 -0500, Douglas Gilbert wrote:
>>> -static const struct opcode_info_t vl_iarr[1] = {    /* VARIABLE LENGTH */
>>> +static const struct opcode_info_t vl_iarr[2] = {    /* VARIABLE LENGTH */
>>
>> Please leave out the array size and let the compiler determine the array size.
> 
> I like the "belts and braces" approach. Especially if offsetting an
> array element by one position would silently destroy the parser
> (which is not the case with vl_iarr but is the case with a few
> other arrays).
> 
>>
>>>       {0, 0x7f, 0xb, F_SA_HIGH | F_D_OUT | FF_DIRECT_IO, resp_write_dt0,
>>> -        NULL, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0xb, 0xfa,
>>> -           0, 0xff, 0xff, 0xff, 0xff} },    /* WRITE(32) */
>>> +        NULL, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0xb, 0xfa,
>>> +        0, 0xff, 0xff, 0xff, 0xff} },    /* WRITE(32) */
>>
>> Shouldn't this change have been included in the patch that fixes the group
>> number mask?
> 
> git add --patch
> 
> was used to break up a monolithic patch into 4 parts. However in
> the above case it refused to "split" the group_number part (shown)
> from the renaming of service actions (not shown above). At that
> point I swear at git and move on.
> 
> If folks think that hours are spent testing a kernel with 1/4 and
> 2/4 applied while 3/4 and 4/4 have not been applied then I think
> they are dreaming. IMO The split up is eye candy for reviewers.
> 
>>>   static const struct opcode_info_t maint_in_iarr[2] = {
>>> @@ -518,9 +523,10 @@ static const struct opcode_info_t 
>>> opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
>>>           {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>>>       {1, 0x9e, 0x10, F_SA_LOW | F_D_IN, resp_readcap16, sa_in_iarr,
>>>           {16,  0x10, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>>> -         0xff, 0xff, 0xff, 0x1, 0xc7} },    /* READ CAPACITY(16) */
>>> -    {0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* SA OUT */
>>> -        {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>>> +         0xff, 0xff, 0xff, 0x1, 0xc7} },/* SA_IN(16), READ CAPACITY(16) */
>>
>> Shouldn't the above change be folded into one of the other patches?
> 
> I considered the patch adding resp_write_scat to the parsing table
> and the splitting SDEB_I_SERV_ACT_IN/OUT to its 12 and 16 byte cdb
> components as very closely related, so I put them together.
> 
>>> @@ -529,9 +535,9 @@ static const struct opcode_info_t 
>>> opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
>>>       {0, 0x2f, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, NULL, NULL, /* VERIFY(10) */
>>>           {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
>>>            0, 0, 0, 0, 0, 0} },
>>> -    {1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
>>> -        vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
>>> -              0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
>>> +    {2, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
>>> +        vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0x9, 0xfe, 0,
>>> +        0xff, 0xff, 0xff, 0xff} },    /* VARIABLE LENGTH, READ(32) */
>>
>> Have you considered to use ARRAY_SIZE(vl_iarr) instead of hard-coding the array
>> size?
> 
> No. It could be done with the advantage of making the code
> a bit safer for someone who changes it, but it obfuscates
> the number elements in the bucket list (array) making it
> harder for the reader of the code (maybe).
> 
>>> +    if (cmd[0] == VARIABLE_LENGTH_CMD) {
>>> +        is_16 = false;
>>> +        wrprotect = (cmd[10] >> 5) & 0x7;
>>> +        lbdof = get_unaligned_be16(cmd + 12);
>>> +        num_lrd = get_unaligned_be16(cmd + 16);
>>> +        bt_len = get_unaligned_be32(cmd + 28);
>>> +        check_prot = false;
>>> +    } else {        /* that leaves WRITE SCATTERED(16) */
>>> +        is_16 = true;
>>> +        wrprotect = (cmd[2] >> 5) & 0x7;
>>> +        lbdof = get_unaligned_be16(cmd + 4);
>>> +        num_lrd = get_unaligned_be16(cmd + 8);
>>> +        bt_len = get_unaligned_be32(cmd + 10);
>>> +        check_prot = true;
>>> +    }
>>
>> It's not clear to me why check_prot is set to false for WRITE SCATTERED(32)
>> and set to true for WRITE SCATTERED(16)?
> 
> Me neither. I was just following what the code for WRITE(16 and 32)
> does. My guess is that the code in question is written by Martin P.
> who is effectively co-maintainer of this driver having written all
> the DIF and DIX stuff. Martin ... ?
> 
> Doug Gilbert
> 
> 
