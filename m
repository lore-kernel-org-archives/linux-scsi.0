From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
 use from fc_queuecommand
Date: Wed, 01 Sep 2010 18:38:26 -0500
Message-ID: <4C7EE3F2.70409@cs.wisc.edu>
References: <20100831225338.25102.59500.stgit@localhost.localdomain> <1283298985.32007.530.camel@haakon2.linux-iscsi.org> <4C7DD3E8.9050700@cs.wisc.edu> <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com> <1283371821.32007.636.camel@haakon2.linux-iscsi.org> <1283375187.30431.71.camel@vi2.jf.intel.com> <20100901224503.GB4089@cleech-lnx.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41328 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0IAXdv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2010 19:33:51 -0400
In-Reply-To: <20100901224503.GB4089@cleech-lnx.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <christopher.leech@intel.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>

On 09/01/2010 05:45 PM, Chris Leech wrote:
> On Wed, Sep 01, 2010 at 02:06:26PM -0700, Vasu Dev wrote:
>>>> It looks safe to me to call scsi_done() w/o host_lock held,
>>>
>>> Hmmmm, this indeed this appears to be safe now..  For some reason I had
>>> it in my head (and in TCM_Loop virtual SCSI LLD code as well) that
>>> host_lock needed to be held while calling struct scsi_cmnd->scsi_done().
>>>
>>> I assume this is some old age relic from the BLK days in the SCSI
>>> completion path, and the subsequent conversion.  I still see a couple of
>>> ancient drivers in drivers/scsi/ that are still doing this, but I
>>> believe I stand corrected in that (all..?) of the modern in-use
>>> drivers/scsi code is indeed *not* holding host_lock while calling struct
>>> scsi_cmnd->scsi_done()..
>>>
>>
>> fcoe/libfc moved to scsi_done w/o holding scsi host_lock a while ago
>> around dec, 09 and it was done after discussion with Mathew and Chris
>> Leech from fcoe side at that time, they may have more to comment on
>> this.
>
> There's not a whole lot to comment on.  Matthew Wilcox was helping me
> look for opportunities to reduce our host_lock use, and said he didn't
> think it was needed around scsi_done anymore.  It held up under testing,
> so I submitted a patch.
>

The host_lock was not actually there for any scsi_done stuff. It was 
probably lazy programming that it was held there. For that code, the 
host_lock was held in fc_queuecommand for the rport check and for the 
setting of the SCp.ptr and fsp->cmd, and it was held in the completion 
path for the SCp.otr and fsp->cmd checks  The rport check locking got 
fixed recently and I was looking at the SCp.ptr and fsp->cmd and was 
wondering if there could be a problem where one thread completes the IO 
and sets those fields to NULL, but another thread could be completing it 
too and it would see a scsi_cmnd that is not released and reallocated by 
the other thread. So for example the fc_eh_abort code still grabs the 
host_lock when calling CMD_SP and taking a ref and checking that the fsp 
is not null.

If it is a problem then we should add some locking or some other atomic 
magic. If it is not a problem then those checks could just be removed, 
right?
