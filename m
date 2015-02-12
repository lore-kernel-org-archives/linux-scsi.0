From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] sg: fix read() error reporting
Date: Thu, 12 Feb 2015 18:31:37 -0500
Message-ID: <54DD37D9.9050202@interlog.com>
References: <54DB8406.4020804@cybernetics.com> <54DB953C.1090104@interlog.com> <54DB9BD7.7090605@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DB9BD7.7090605@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-02-11 01:13 PM, Tony Battersby wrote:
> On 02/11/2015 12:45 PM, Douglas Gilbert wrote:
>> On 15-02-11 11:32 AM, Tony Battersby wrote:
>>> Fix SCSI generic read() incorrectly returning success after detecting an
>>> error.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
>>> ---
>>>
>>> For inclusion in kernel 3.20.
>>>
>>> --- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-08 21:54:22.000000000 -0500
>>> +++ linux-3.19.0/drivers/scsi/sg.c	2015-02-10 09:26:09.000000000 -0500
>>> @@ -546,7 +546,7 @@ static ssize_t
>>>    sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>>>    {
>>>    	sg_io_hdr_t *hp = &srp->header;
>>> -	int err = 0;
>>> +	int err = 0, err2;
>>>    	int len;
>>>
>>>    	if (count < SZ_SG_IO_HDR) {
>>> @@ -575,8 +575,8 @@ sg_new_read(Sg_fd * sfp, char __user *bu
>>>    		goto err_out;
>>>    	}
>>>    err_out:
>>> -	err = sg_finish_rem_req(srp);
>>> -	return (0 == err) ? count : err;
>>> +	err2 = sg_finish_rem_req(srp);
>>> +	return err ? : err2 ? : count;
>> Tony,
>> Your point is well made.
>>
>> I just don't like that last line, using a gcc extension that
>> hasn't even made it into C11 (or C++11). Wouldn't:
>>       return err ? err : (err2 ? err2 : count);
>>
>> be a bit better? I think the following snippet makes the intent
>> clear but would it generate any more code:
>>       if (err || err2)

An improvement on the above line would be:
       if (unlikely(err || err2))

>> 	return err ? err : err2;
>>       else
>>           return count;
>>

Another approach is to return the good path prior to the
err_out label. This would require two calls to
sg_finish_rem_req().

However Tony's clean-up is sufficient.

> I checked before submitting, and the foo ? : bar construct is already
> used at least 455 times in the kernel, so it is nothing new.
>
> find linux-3.19 -type f -name "*.[ch]" | xargs grep '\? :' | wc -l
> 455
>
> But you are probably right; I think that with such small variable names
> your version is more readable due to the nesting.  Updated patch below.
>
> ---
>
> Fix SCSI generic read() incorrectly returning success after detecting an
> error.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>
> --- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-08 21:54:22.000000000 -0500
> +++ linux-3.19.0/drivers/scsi/sg.c	2015-02-11 13:02:56.000000000 -0500
> @@ -546,7 +546,7 @@ static ssize_t
>   sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   {
>   	sg_io_hdr_t *hp = &srp->header;
> -	int err = 0;
> +	int err = 0, err2;
>   	int len;
>
>   	if (count < SZ_SG_IO_HDR) {
> @@ -575,8 +575,8 @@ sg_new_read(Sg_fd * sfp, char __user *bu
>   		goto err_out;
>   	}
>   err_out:
> -	err = sg_finish_rem_req(srp);
> -	return (0 == err) ? count : err;
> +	err2 = sg_finish_rem_req(srp);
> +	return err ? err : (err2 ? err2 : count);
>   }
>
>   static ssize_t
>
> --
