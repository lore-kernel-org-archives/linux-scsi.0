From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Fri, 31 Jan 2014 08:52:16 +0100
Message-ID: <52EB5630.2010401@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org>	   <1372101557.2013.76.camel@dabdike.int.hansenpartnership.com>	   <51C8A668.3060700@cs.wisc.edu>	  <1372112866.2013.104.camel@dabdike.int.hansenpartnership.com>	  <51C95C79.2080804@acm.org> <1372167923.2806.13.camel@dabdike>	 <51C9B7D1.9040702@acm.org>	 <FBC61EDC-F703-4E3F-9980-70D41EE9484F@cs.wisc.edu>	 <52EAAC20.2040607@acm.org> <1391147936.2181.160.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:46077 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327AbaAaHwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jan 2014 02:52:21 -0500
In-Reply-To: <1391147936.2181.160.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/31/14 06:58, James Bottomley wrote:
> On Thu, 2014-01-30 at 20:46 +0100, Bart Van Assche wrote:
>> On 06/25/13 18:13, Michael Christie wrote:
>> Sorry but I'm afraid that making the SCSI core invoke a callback
>> function from a device, target or host release function would create a
>> new challenge, namely making sure that all these callback functions have
>> finished before the module is unloaded that contains the SCSI host
>> template and the code implementing such a callback function. That
>> challenge is not specific to the SCSI infrastructure but is a general
>> question that has not yet been solved in the Linux kernel (see e.g.
>> "[PATCH] kobject: provide kobject_put_wait to fix module unload race"
>> for a more general discussion about how to ensure that kobject release
>> functions are invoked before the module is unloaded that owns the
>> release function - http://thread.gmane.org/gmane.linux.kernel/1622885).
> 
> For callbacks, that's easy: it's module_get/module_put

Adding a module_get() call in scsi_add_host() and a module_put() call in
scsi_host_dev_release() would cause a behavior change that would be
reported by end users as "system hangs during shutdown". Today it is
possible to unload a kernel module via rmmod that created one or more
SCSI hosts. Since user space does not remove SCSI hosts during system
shutdown, trying to unload a SCSI LLD kernel module that had created one
or more SCSI hosts would cause the module unload to fail because of a
non-zero module reference count.

>> In case it is not clear why I'm reviving this discussion: now that the
>> "improved eh timeout handler" patch is upstream (commit
>> e494f6a728394ab0df194342549ee20e6f0752df) there is an additional way in
>> which the SCSI core can invoke an EH function concurrently with or after
>> scsi_remove_host() has finished, namely from the TMF work queue
>> (tmf_work_q).
> 
> But the fundamental guarantee is that the eh thread for the host (the eh
> context if you will) has to be dead before the host can be removed and
> the module unloaded.  The thread doesn't die until all the work is done.

Maybe I'm misunderstanding something, but as far as I can see
kthread_stop(shost->ehandler) is invoked from scsi_host_dev_release().
That last function is called by the last scsi_host_put(). And LLD's
invoke scsi_host_put() after scsi_remove_host(). In other words, the
SCSI error handler thread and TMF work queue are still active when
scsi_remove_host() returns.

Should I repost the patch at the start of this thread ?

Thanks,

Bart.
