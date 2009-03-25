From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: eh_abort_handler and calling scsi_done
Date: Wed, 25 Mar 2009 08:52:50 -0500
Message-ID: <49CA3732.2060508@linux.vnet.ibm.com>
References: <20090324114137.GA8616@schmichrtp.de.ibm.com> <49C8E055.2060108@linux.vnet.ibm.com> <20090324174609.GA13556@linux.vnet.ibm.com> <20090325085235.GA4214@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37460 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762108AbZCYNww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 09:52:52 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2PDmAhD020556
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 07:48:10 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2PDqgVJ054794
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 07:52:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2PDqbQe016089
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2009 07:52:38 -0600
In-Reply-To: <20090325085235.GA4214@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Christof Schmitt wrote:
> On Tue, Mar 24, 2009 at 10:46:09AM -0700, Mike Anderson wrote:
>> Brian King <brking@linux.vnet.ibm.com> wrote:
>>> Your assessment sounds correct to me. The other caveat to note is that
>>> if for some reason in your eh_abort_handler you don't think the command
>>> is still outstanding, you should return SUCCESS for this as well.
>>>
>>> -Brian
>>>
>>> Christof Schmitt wrote:
>>>> I am investigating what is required from a LLD when SCSI commands time
>>>> out and the SCSI EH calls the eh_abort_handler. The documentation in
>>>> scsi_eh.txt states:
>>>>
>>>>     <<scsi_eh_abort_cmds>>
>>>>
>>>> 	This action is taken for each timed out command.
>>>> 	hostt->eh_abort_handler() is invoked for each scmd.  The
>>>> 	handler returns SUCCESS if it has succeeded to make LLDD and
>>>> 	all related hardware forget about the scmd.
>>>>
>>>> From this and from looking at the code, i would conclude:
>>>>
>>>> 1) If the LLD returns FAILED from the eh_abort_handler, then the
>>>>    command is still allowed to be active in the LLD and the LLD can
>>>>    call scsi_done any time later (probably latest when the
>>>>    eh_host_reset_handler flushes everything that is still pending).
>>>>
>>>> 2) While the abort is pending, but before returning SUCCESS from
>>>>    eh_abort_handler, the LLD can still call scsi_done for the SCSI
>>>>    command to be aborted (the SCSI command might be returned with a
>>>>    status "aborted" if the abort succeeds, or "good" if it was
>>>>    completed just before the abort reached the storage system).
>>>>
>> In cases 1 and 2 above calling scsi_done can be done but will cause
>> the request to be stopped in blk_complete_request
>> (scsi_done->blk_complete_request) as the timed out handler has
>> already taken ownership of the command.
> 
> I am not too familiar with the blk completion handling. Would calling
> scsi_done for the cases above cause any problems? If there are reasons
> not to call scsi_done here, then this could be mentioned in the scsi
> documentation file.

No. There is no requirement to call scsi_done for aborted commands,
but there is also no harm in doing so.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


