From: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Fri, 7 Apr 2017 16:14:30 -0500
Message-ID: <402a3e4d-0466-e315-7981-ce9c240236dc@linux.vnet.ibm.com>
References: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <0c80c6e3-168a-d8bd-d7b4-e727723bcf18@sandisk.com>
 <5297a130-5349-1796-2fe4-2336daa346ab@linux.vnet.ibm.com>
 <1491583008.2559.12.camel@sandisk.com>
 <63af0be8-f36f-a42d-9898-a7ef642a8c17@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <63af0be8-f36f-a42d-9898-a7ef642a8c17@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 4/7/17 12:01 PM, Bryant G. Ly wrote:
>
>
> On 4/7/17 11:36 AM, Bart Van Assche wrote:
>> On Fri, 2017-04-07 at 11:12 -0500, Bryant G. Ly wrote:
>>> So from this stack trace it looks like the ibmvscsis driver is 
>>> sending an
>>> extra response through send_messages even though an abort was issued.
>>> IBMi, reported this issue internally when they were testing the driver,
>>> because their client didn't like getting a response back for the 
>>> aborted op.
>>> They are only expecting a TMR from the abort request, NOT the 
>>> aborted op.
>> Hello Bryant,
>>
>> What is the root cause of this behavior? Why is it that the behavior of
>> the ibmvscsi_tgt contradicts what has been implemented in the LIO core?
>> Sorry but the patch at the start of this thread looks to me like an
>> attempt to paper over the problem instead of addressing the root cause.
>>
>> Thanks,
>>
> IBMi clients received a response for an aborted operation, so they 
> sent an abort tm request.
> Afterwards they get a CRQ response to the op that they aborted. That 
> should not happen, because they are only supposed to get a response 
> for the tm request NOT the aborted operation.
> Looking at the code it looks like it is due to send messages, 
> processing a response without checking to see if it was an aborted op.
> This patch addresses a bug within the ibmvscsis driver and the fact 
> that it SENT a response to the aborted operation(which is wrong since) 
> without looking at what LIO core had done.
> The driver isn't supposed to send any response to the aborted 
> operation, BUT only a response to the abort tm request, which LIO core 
> currently does.
>
> -Bryant
>
I think I can clarify the issue here: ibmvscsis_tgt does not send the 
response to the client until release_cmd time.  The reason for this was 
because if we did it at queue_status time, then the client would be free 
to reuse the tag for that command, but we're still using the tag until 
the command is released at release_cmd time, so we chose to delay 
sending the response until then.

That then caused this issue, because release_cmd is always called, even 
if queue_status is not.  Perhaps it would be cleaner to set some sort of 
status valid flag during queue_status instead of setting a flag in 
aborted_task?
