From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Thu, 27 Oct 2016 11:00:56 +0200
Message-ID: <4157cbe0-8110-49e2-ea18-ef6c76706338@suse.de>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
 <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
 <1477434237.3079.84.camel@linux.vnet.ibm.com>
 <1477437481.2385.7.camel@sandisk.com>
 <1477439413.3079.101.camel@linux.vnet.ibm.com>
 <e3531f72-596e-359c-93bd-3855291d7ba0@sandisk.com>
 <1477497160.2724.11.camel@linux.vnet.ibm.com>
 <1477498520.2550.1.camel@sandisk.com>
 <bec8981d-b061-928a-24f9-683dc7eaa936@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59299 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934542AbcJ0JNw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:52 -0400
In-Reply-To: <bec8981d-b061-928a-24f9-683dc7eaa936@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gabriel@krisman.be" <gabriel@krisman.be>

On 10/26/2016 07:38 PM, Brian King wrote:
> On 10/26/2016 11:15 AM, Bart Van Assche wrote:
>> On Wed, 2016-10-26 at 08:52 -0700, James Bottomley wrote:
>>> On Wed, 2016-10-26 at 08:42 -0700, Bart Van Assche wrote:
>>>> Can you elaborate on this? Since the sense buffer is available in 
>>>> scsi_io_completion() and since that function already calls 
>>>> scsi_command_normalize_sense() this function seems like a good 
>>>> candidate to me to add retry logic for REQ_TYPE_BLOCK_PC requests.
>>>
>>> UAs are used to signal AENs to userspace control processes that use
>>> BLOCK_PC, like CD changers, burners and scanners.  If we eat UAs
>>> inside scsi_io_completion(), we could potentially break any userspace
>>> control system that relies on AENs.
>>
>> Ignoring the SCSI error handler, the call sequence for reporting UAs to
>> user space is as follows: scsi_softirq_done() ->
>> scsi_decide_disposition() -> scsi_check_sense() -> scsi_report_sense().
>> This means that scsi_report_sense() is called before
>> scsi_io_completion() is called. I think this means that what
>> scsi_io_completion() decides cannot affect UA reporting to user space?
> 
> I think what would break if we just started eating UAs in scsi_io_completion
> for BLOCK_PC is applications that are building BLOCK_PC requests and then
> checking the sense data in the completed command for a UA. I think this is what
> James was referring to. If we wanted to collapse some of this retry logic,
> it seems like we might need a way to differentiate between different types of BLOCK_PC
> requests. A new cmd_flag on struct request, or more generally, a way for scsi
> or any user of struct request to pass driver specific data along with the request.
> This is something I've wanted for ipr, which I've sort of worked around currently.
> 
I'm fully with you here.

BLOCK_PC is currently used indiscriminately for all non-filesystem
commands, ie for commands where the raw cdb is passed in via req->special.

As such, is has a dual meaning:
- A pre-filled CDB
- do not evaluate the sense code

If we could split this up in having one flag for a pre-filled CDB and
another one for evaluating sense code we should be able to resolve this
situation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
