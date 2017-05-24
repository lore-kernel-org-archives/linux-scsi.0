From: mail1 <my.e.mail1@verizon.net>
Subject: Re: Need help with handling failed ATA pass-through command and sense
 data
Date: Tue, 23 May 2017 23:13:35 -0400
Message-ID: <c7ba63f6-b904-bb41-6624-c9e502cba529@verizon.net>
References: <Pine.LNX.4.44L0.1705231430550.1853-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omr-m016e.mx.aol.com ([204.29.186.16]:54139 "EHLO
        omr-m016e.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932903AbdEXDTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 23:19:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.1705231430550.1853-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Ewan D. Milne" <emilne@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Sorry, I don't have the experience to do this quickly. I'm out of practice building a kernel and will need time to re-learn a few things.

Can you please update the bug report and ask for someone else to try it? In the mean time, I'll do what I can.

--GeekGirl1

On 05/23/2017 02:34 PM, Alan Stern wrote:
> On Thu, 18 May 2017, Ewan D. Milne wrote:
>
>> On Thu, 2017-05-18 at 13:37 -0400, Alan Stern wrote:
>>> I had completely forgotten about this code.  :-(
>>>
>>> Looks like you put your finger on the source of the problem.  So if the
>>> device sends back essentially empty sense data (SK = No Sense, ASC =
>>> ASCQ = 0), but the USB transport indicates command failure, how should
>>> we inform the SCSI core in a way that won't cause infinite retries or
>>> obnoxious log messages?
>>>
>>> Should we be doing a better job of detecting empty sense data -- that
>>> is, do we need to check for non-empty ATA status?
>>>
>>> Or has the SCSI core improved so that it no longer does infinite
>>> retries (see commit f1a0743bc0e7 "USB: storage: When a device returns
>>> no sense data, call it a Hardware Error" and Bugzilla entry #14118),
>>> meaning that this code can be removed entirely?
>>>
>>> Alan Stern
>> We added:
>>
>> commit ee60b2c52ec8ecdcbcd2f85cc117b525f649441f
>> Author: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
>> Date:   Tue Feb 11 14:29:52 2014 +0900
>>
>>      [SCSI] Add timeout to avoid infinite command retry
>>
>> but this may not give you the behavior you want, because it bounds
>> the execution time to (# of retries + 1) * timeout.  So if you get
>> an immediate error return it could still take a while for this code
>> to give up retrying, i.e. it does not have the same properties as
>> your commit f1a0743bc0e7.
>>
>> I suppose you could decode the ATA Status Return sense data descriptor
>> but I don't know how good the compliance is among all the ATA devices.
>> Table 177 in section 1.2.2.8 of SAT-4 r06 seems to say that most of
>> the fields in the sense data are unspecified for ATA PASS-THROUGH
>> commands, so this probably explains why you see nothing else useful.
>> Perhaps the logging should be delegated to the USB or ATA code for
>> these commands, since they are not really part of SCSI?
>>
>> I have seen a case of a Fibre Channel array returning all zeroes
>> in the sense data, but this was because it was malfunctioning.
> All right, suppose we don't return DID_ERROR and don't call it a
> hardware error.  I don't know if this will help at all, and I don't
> know if it will cause any regressions.
>
> GeekGirl1, can you try applying the patch below to see if it makes any
> difference?  If you don't know how, I will attach it to the Bugzilla
> report so somebody else can try it.
>
> Alan Stern
>
>
>
>
> Index: usb-4.x/drivers/usb/storage/transport.c
> ===================================================================
> --- usb-4.x.orig/drivers/usb/storage/transport.c
> +++ usb-4.x/drivers/usb/storage/transport.c
> @@ -835,6 +835,7 @@ Retry_Sense:
>   				srb->result = SAM_STAT_GOOD;
>   				srb->sense_buffer[0] = 0x0;
>   
> +#if 0
>   			/*
>   			 * If there was a problem, report an unspecified
>   			 * hardware error to prevent the higher layers from
> @@ -846,6 +847,7 @@ Retry_Sense:
>   					srb->sense_buffer[1] = HARDWARE_ERROR;
>   				else
>   					srb->sense_buffer[2] = HARDWARE_ERROR;
> +#endif
>   			}
>   		}
>   	}
>
>
