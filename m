From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: ioctl reset should wait for IOs to complete
Date: Wed, 27 Sep 2017 08:58:53 +0200
Message-ID: <f461f4f9-1740-caff-3764-0b38af402a59@suse.com>
References: <20170926172235.29530-1-lduncan@suse.com>
 <1506450273.3063.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:58070 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdI0G7C (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 27 Sep 2017 02:59:02 -0400
In-Reply-To: <1506450273.3063.10.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lduncan@suse.com" <lduncan@suse.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 09/26/2017 08:24 PM, Bart Van Assche wrote:
> On Tue, 2017-09-26 at 10:22 -0700, Lee Duncan wrote:
>> The SCSI ioctl reset path is smart enough to set the
>> flag tmf_in_progress when a user-requested reset is
>> processed, but it does not wait for IO that is in
>> flight. This can result in lost IOs and hung
>> processes. We should wait for a reasonable amount
>> of time for either the IOs to complete or to fail
>> the request.
> 
> Hello Lee,
> 
> I'm using this functionality all the time to test how SCSI target code handles
> TMFs while SCSI commands are in progress. So I would regret if the SCSI reset
> ioctl code would be modified such that it waits for outstanding requests.
> Isn't the behavior you described a SCSI LLD bug? Shouldn't such bugs be fixed
> instead of implementing a work-around in the SCSI core?
> 
Well, thing is that there is an asymmetry here; originally all SCSI EH
functions were supposed to run with no I/O in flight.
(I've modified that with the asynchronous ABORT TASK TMF, but still).
But when called with sg_reset this is no longer true, we're disallowing
new requests, but do not wait for the in-flight I/O to complete.
And we've had a customer report where calling sg_reset -t on an iSCSI
device caused I/O to become stuck as the in-flight I/O was terminated by
the target reset, but the iSCSI stack never sent a completion for that I/O.

However, we could also defer this problem until my SCSI EH rework goes
in; that clears up the sg_reset path and might clarify things a bit.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
