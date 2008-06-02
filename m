From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 15:27:10 -0500
Message-ID: <4844579E.80005@linux.vnet.ibm.com>
References: <12124164141515-patch-mail.ibm.com>  <48441AEE.6050605@garzik.org> <48441F82.6060706@linux.vnet.ibm.com> <1212425124.3369.20.camel@localhost.localdomain> <4844312C.7010403@garzik.org> <1212429428.3369.45.camel@localhost.localdomain> <484437C3.8020306@garzik.org> <48444126.8050107@linux.vnet.ibm.com> <484441E6.8020501@garzik.org> <1212435552.3369.62.camel@localhost.localdomain>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1212435552.3369.62.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-06-02 at 14:54 -0400, Jeff Garzik wrote:
>> Brian King wrote:
>>> One thing that having a per-port SCSI host buys us is that it isolates
>>> EH to the port rather than the entire SCSI host. The way that the new
>>> libata EH is designed, it can end up spending a fair amount of time
>>> in EH and may even sleep for seconds at a time, waiting for the device
>>> to come ready. Quiescing all devices on a SAS host due to a single
>>> SATA device gets *very* painful. The new libata EH does much more than
>>> just EH. It wakes up for every ATAPI check condition...
>>>
>>> Before we can move to a single SCSI host model, we will
>>> have to make some changes regarding how EH is done in libata...
>>
>> Good points.  There definitely needs to be a discussion about how to 
>> integrate libata EH with libsas model and ipr model (which are distinct, 
>> if similar).
> 
> Actually, libsas completely hijacks the strategy handler (as I believe
> libata does), so it really no longer has a host dependency, except for
> the one thread per host thing.  Most of what it does (unless it thinks
> the actual host chip is wedged) is port (as in SAS port, not phy) based,
> so I think we have the capability for doing this already.

libsas currently does hijack the strategy handler today, but if we want
to move it to the new libata EH/attach model, that's not going to work.
libata EH does much more than EH. Its really more of an exception handler
than an error handler. Anything that happens out of the ordinary wakes
the EH thread.

Ideally, I think we really want to have stacked EH as I believe we have
discussed in the past. If we hit an error, we quiesce the device, do device
level EH. If needed, quiesce the device group / port, perform EH. If 
necessary, quiesce the entire HBA and perform EH on it.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
