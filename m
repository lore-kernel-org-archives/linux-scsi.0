From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Thu, 26 Jun 2014 21:17:34 +0000
Message-ID: <F7E1F0AA-0764-4C1D-A8FD-8DEE7770AB44@ornl.gov>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53AC3402.2080302@acm.org> <1403794551.3572.6.camel@dabdike>
 <86EE1A5C-8943-4C87-9A79-899DE85971CA@ornl.gov>
 <fbbc6688-5a52-4437-93b1-71e8ff84c36c@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fbbc6688-5a52-4437-93b1-71e8ff84c36c-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <52FAC9C7F3CB8A4DAB2A2BDA53601002@local>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "<michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "<martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Jun 26, 2014, at 12:38 PM, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> On June 26, 2014 11:41:48 AM EDT, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org> wrote:
>> On Jun 26, 2014, at 10:55 AM, James Bottomley
>> <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> 
>>> On Thu, 2014-06-26 at 16:53 +0200, Bart Van Assche wrote:
>>>> On 06/11/14 11:09, Sagi Grimberg wrote:
>>>>> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
>>>> 
>>>> Sorry that I just noticed this now, but why is a shift-right and
>> ilog2()
>>>> used in the above expression instead of just dividing the transfer
>>>> length by the sector size ?
>>> 
>>> It's a performance thing.  Division is really slow on most CPUs.
>>> However, we know the divisor is a power of two so we re-express the
>>> division as a shift, which the processor can do really fast.
>>> 
>>> James
>> 
>> I have done this in the past as well, but have you benchmarked it?
>> Compilers typically do the right thing in this case (i.e replace
>> division with shift).
> 
> The compiler can only do that for values which are reducible to constants at compile time. This is a runtime value, the compiler has no way of deducing that it will be a power of 2
> 
> James

You're right, I should have said runtime.

However, gcc on Intel seems to choose the right algorithm at runtime. On a trivial app with -O0, I see the same performance for shift and division if the divisor is a power of two. Is see ~38% penalty if the divisor is not a power of 2. With -O3, shift is faster than division by about ~17% when the divisor is a power of two.

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
