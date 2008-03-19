From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Wed, 19 Mar 2008 11:49:44 +0200
Message-ID: <47E0E1B8.7080805@panasas.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com> <47DFF834.8010307@sgi.com> <47E008AF.7010100@panasas.com> <47E01D57.2000201@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8491 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760611AbYCSTxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:53:40 -0400
In-Reply-To: <47E01D57.2000201@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 18 2008 at 21:51 +0200, Michael Reed <mdr@sgi.com> wrote:
> 
> Boaz Harrosh wrote:
>> On Tue, Mar 18 2008 at 19:13 +0200, Michael Reed <mdr@sgi.com> wrote:
>>> Boaz Harrosh wrote:
>>>> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>>>>> Michael Reed wrote:
>>>>>> Boaz Harrosh wrote:
>>>>>> <snip>
>>>>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>>>>> untested.
>>>>>>>> I can try this out and see what happens.
>>>>>>>>
>>>>>>>>
>>>>>>> Will not compile here is a cleaner one
>>>>>> Still in my queue.  Hopefully I'll get to poke at this today.
>>>>> Patch compiles cleanly and appears to have no effect on the misc.
>>>>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>>>>
>>>>> Mike
>>>>>
>>>>>> Mike
>>>>>>
>>>> <patch snipped>
>>>>
>>>> If you remove the original fix to sg.c
>>>> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
>>>>
>>>> and apply this patch, does it solve your original infinite loop?
>>> By removing a fix in scsi_req_map_sg and forcing sg_start_req() to always
>>> call sg_build_indirect() (and not applying my fix to sg.c) I'm able to
>>> reproduce the problem without crashing the system.
>>>
>>> With your patch applied to 2.6.25-rc4-git3 I get this....  (The mptscsih_qcmd
>>> output is evidence that the condition was generated which would have caused
>>> the infinite loop.)
>>>
>>>
> 
> < snip backtrace >
> 
>>> Mike
>>>
>> I don't understand is that a NULL dereference due to my patch? did you manage to find
>> what is the line of code that dereferences the NULL pointer.
> 
> I'm going to say "yes", it's due to your patch.  It's happened twice in
> a row.
> 
> Disabling inline functions gets me a better backtrace.  And dumping
> the dmesg buffer I see the BUG in scsi_end_blk_request().
> 
>         BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
> 

OK Thanks that makes more sense. We hit the BUG_ON().

> I guess this is what I would expect to happen.
> 
> 	blk_end_bidi_request ->
> 	  blk_end_io ->
> 	    __end_that_request_first
> 	
> __end_that_request_first returns "1" indicating that the
> request wasn't completely finished.
> 
> I guess it could be argued that this really is a bug and that the
> buffer length and bi_size should always be the same.  Would
> the same thing happen if a command returned a residual or
> an i/o error?
> 

scsi's bufflen might not match bi_size. But in my patch I complete
according to request->data_len which should match bi_size. I guess that
is the bug in sg.c. However if you look in the patch I sent you for 2.6.24
I did a WARN_ON and then proceeded to complete the request in a loop. I
guess this is a more robust approach. If you could test with 2.6.24 + my
patch we could make sure it works. Expected behavior is that you'll get
lots of WARN_ON prints in dmsg but the IO should complete.

<snip back trace>
> 
> Mike
> 

Thanks Mike for all the testing. I feel guilty of you doing my job.
Boaz
