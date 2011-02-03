From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver
 submission - part 2
Date: Thu, 03 Feb 2011 14:55:58 -0600
Message-ID: <4D4B165E.2010805@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com> <4D316634.5030300@cs.wisc.edu> <1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com> <4D4922BE.40907@cs.wisc.edu> <1296704558.268.552.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D4A29A1.7010105@cs.wisc.edu> <4D4A3374.4010306@cs.wisc.edu> <1296716694.268.643.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43445 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1BCUz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 15:55:56 -0500
In-Reply-To: <1296716694.268.643.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: james.smart@emulex.com, andrew.vasquez@qlogic.com, robert.w.love@intel.com, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/03/2011 01:04 AM, Bhanu Gollapudi wrote:
> On Wed, 2011-02-02 at 20:47 -0800, Mike Christie wrote:
>> On 02/02/2011 10:05 PM, Mike Christie wrote:
>>> On 02/02/2011 09:42 PM, Bhanu Gollapudi wrote:
>>>>>
>>>>> Actually you do not have to wait for the scsi eh to run, right. It
>>>>> looks
>>>>> like bnx2fc would log out the port, which ends up calling
>>>>> fc_remote_port_delete and that would cause the fc timed out function
>>>>> to
>>>>> return BLK_EH_RESET_TIMER to prevent the scsi eh from running. Is
>>>>> that
>>>>> right? That type of eh strategy behavior seems like something you
>>>>> want
>>>>> to sync up with libfc or the fc class so all drivers do something
>>>>> similar.
>>>>
>>>> As per FCP-4, if the ABTS times out, we will have to explicitly LOGO the
>>>
>>> What section is that in?
>>>
>>
>> Ok read it (12.5.1, right).
>>
>>>> target and relogin back. If we rely on 60 sec eh_abort_handler, and if
>>>> ABTS times out, SCSI error handling will go to LUN RESET, TGT reset
>>>> path, which is a generic error handling than transport specific error
>>>> handling.
>>>
>>> If that is right, then it seems the other FC drivers are doing it wrong
>>> then, and you hit that problem if someone sets the scsi cmd timer lower
>>> than BNX2FC_IO_TIMEOUT. If that is right, that just does not seem right
>>> to hack around the issue in the driver too.
>>
>> So if your reading of 12.5.1 is right then libfc is wrong and it seems
>> other drivers (if they are not doing some magic in firmware) are wrong too.
>>
>> My confidence in my FCP skills are very shaken right now :) I am not
>> sure I what I was thinking when I read it and reviewed libfc. I think
>> you need to discuss this out the fcoe list people and James Smart and
>> Andrew Vasquez.
>>
>> I think some of them disagree with the other aborting commands (or maybe
>> just disagree about some of the details), so that should be discussed too.
>>
>> But if you are right then you cannot work around this in a driver
>> specific way. You need to change libfc and the fc class in a way that
>> the error strategy is correct. For example from fc_timed_out you could
>> kick off the abort. I was slightly off on the other comment about libfc
>> not doing a abort from their internal timeout handler. They do an abort
>> still, but if that fails they let the scsi eh run eventually. I thought
>> they were going to clean that up too when they removed their internal
>> timer value in the "libfc: use rport timeout values for fcp recovery" patch.
>
> James, Robert, Andrew,
>
> Can you please shed some light on this?
>

I got a response from James S offlist, and I think Bahnu is right. I am 
not sure if we have to change the driver before it is merged. That is up 
to JamesB. However, I would like to fix this in a common way (maybe a ok 
LSF topic or something).

To fix this I think we have to do:

1. For issue of sending aborts after resets, it seems we need to do 
this. libfc needs this fixed. Maybe qlogic does too (if the firmware 
does not do this then the driver needs code added). I think bfa does too 
if it does not do it in firmware (did not see any code for it in driver).

2. For the ABTS if it timed out, do a logout issue. Maybe this is time 
to finally have the transport classes help out more, because it does not 
make sense for drivers to side step the eh code.

My idea and some questions.

I was thinking that this could be kicked off from fc_timed_out instead 
of eh_strategy_handler. This would allow us to do recovery without 
having to stop the entire host. I think this will be ok, because FC 
drivers seem to support the ability to send aborts and logout of ports 
without having to stop the entire host.

1. So fc_timed_out would have the driver kick of an abort, if the port 
state is online.
2.
- If the abort times out, the fc class will have the driver do a logout 
of the port.
- If the abort completes but indicates failure, do we do want to still 
do a lun reset? If we do a lun reset and that fails, then instead of a 
target reset do the logout of the port.

4. If logout of the port fails for #2, then let scsi eh have it so it 
can reset the host and possibly offline devices

I guess it is a lot of work, so bnx2fc would probably be ok going in 
with its current eh as is IMO. Not sure though, we made lpfc do a lot of 
work to get in, but bfa did not, so who knows.
