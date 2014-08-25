From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 13:26:07 +0200
Message-ID: <53FB1D4F.5070606@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbaHYL0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 07:26:12 -0400
In-Reply-To: <53FB1ACD.1040208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/25/2014 01:15 PM, Paolo Bonzini wrote:
> Il 25/08/2014 12:28, Bart Van Assche ha scritto:
>>
>> From SPC-4: "7.5.8 Control mode page [ ... ] A task aborted status (TAS)
>> bit set to zero specifies that aborted commands shall be terminated by
>> the device server without any response to the application client. A TAS
>> bit set to one specifies that commands aborted by the actions of an I_T
>> nexus other than the I_T nexus on which the command was received shall
>> be completed with TASK ABORTED status (see SAM-5)."
> 
> Note the "aborted by the actions of an I_T nexus other than the I_T
> nexus on which the command was received".
> 
> In practice, this means that TASK ABORTED should only happen if you use
> the CLEAR TASK SET tmf and TST is not set to 001b (i.e. _not_ to "per
> I_T nexus") in the Control mode page.  It should never happen for a pen
> drive.
> 
> Setting TASK ABORTED aside, the important part is that an abort can do
> one of two things:
> 
> - complete the command, and then eh_abort should return after the driver
> has noticed the completion and called the ->scsi_done callback for the
> Scsi_Cmnd*.
> 
> - abort the command, and then the driver should never call the
> ->scsi_done callback for the Scsi_Cmnd*.

Thanks Bart and Paolo, your insights into this are greatly appreciated.

So with uas there are separate usb transaction for cmd, data in, data out
and sense for each tag. At the time of abort, usually one of data in / data
out and a sense usb transaction will be outstanding.

There already is logic in the driver to kill the data in / out transactions
if a sense gets returned (usually with an error) before they are done.

So if I'm reading this correctly, then on a successful abort, the sense
transaction (if not already completed by the target) should be cancelled as
it will never complete, correct ?

I wish the uas spec contained some more details on this, but it is very
vague wrt task management (well it is vague in general, task management just
is extra hard to test).

Regards,

Hans
