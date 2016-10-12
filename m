From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Open-FCoE] Issue with fc_exch_alloc failing initiated by
 fc_queuecommand on NUMA or large configurations with Intel ixgbe running FCOE
Date: Wed, 12 Oct 2016 17:46:16 +0200
Message-ID: <000ebf71-9b7a-e6f6-ff8f-0f06eeef64fa@suse.de>
References: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com>
 <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
 <1476197489.4019.68.camel@localhost.localdomain>
 <1476286016.4019.105.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932835AbcJLPqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 11:46:22 -0400
In-Reply-To: <1476286016.4019.105.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, vasu.dev@intel.com, robert.w.love@intel.com
Cc: Laurence Oberman <loberman@redhat.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, fcoe-devel@open-fcoe.org, "Curtis Taylor (cjt@us.ibm.com)" <cjt@us.ibm.com>, Bud Brown <bubrown@redhat.com>

On 10/12/2016 05:26 PM, Ewan D. Milne wrote:
> On Tue, 2016-10-11 at 10:51 -0400, Ewan D. Milne wrote:
>> On Sat, 2016-10-08 at 19:35 +0200, Hannes Reinecke wrote:
>>> You might actually be hitting a limitation in the exchange manager code.
>>> The libfc exchange manager tries to be really clever and will assign a
>>> per-cpu exchange manager (probably to increase locality). However, we
>>> only have a limited number of exchanges, so on large systems we might
>>> actually run into a exchange starvation problem, where we have in theory
>>> enough free exchanges, but none for the submitting cpu.
>>>
>>> (Personally, the exchange manager code is in urgent need of reworking.
>>> It should be replaced by the sbitmap code from Omar).
>>>
>>> Do check how many free exchanges are actually present for the stalling
>>> CPU; it might be that you run into a starvation issue.
>>
>> We are still looking into this but one thing that looks bad is that
>> the exchange manager code rounds up the number of CPUs to the next
>> power of 2 before dividing up the exchange id space (and uses the lsbs
>> of the xid to extract the CPU when looking up an xid). We have a machine
>> with 288 CPUs, this code is just begging for a rewrite as it looks to
>> be wasting most of the limited xid space on ixgbe FCoE.
>>
>> Looks like we get 512 offloaded xids on this adapter and 4096-512
>> non-offloaded xids.  This would give 1 + 7 xids per CPU.  However, I'm
>> not sure that even 4096 / 288 = 14 would be enough to prevent stalling.
>>
>> And, of course, potentially most of the CPUs aren't submitting I/O, so
>> the whole idea of per-CPU xid space is questionable.
>>
>
> fc_exch_alloc() used to try all the available exchange managers in the
> list for an available exchange id, but this was changed in 2010 so that
> if the first matched exchange manager couldn't allocate one, it fails
> and we end up returning host busy.  This was due to commit:
>
> commit 3e22760d4db6fd89e0be46c3d132390a251da9c6
> Author: Vasu Dev <vasu.dev@intel.com>
> Date:   Fri Mar 12 16:08:39 2010 -0800
>
>     [SCSI] libfc: use offload EM instance again instead jumping to next EM
>
>     Since use of offloads is more efficient than switching
>     to non-offload EM. However kept logic same to call em_match
>     if it is provided in the list of EMs.
>
>     Converted fc_exch_alloc to inline being now tiny a function
>     and already not an exported libfc API any more.
>
>     Signed-off-by: Vasu Dev <vasu.dev@intel.com>
>     Signed-off-by: Robert Love <robert.w.love@intel.com>
>     Signed-off-by: James Bottomley <James.Bottomley@suse.de>
>
> ---
>
> Setting the ddp_min module parameter to fcoe to 128MB prevents the ->match
> function from permitting the use of the offload exchange manager for the frame,
> and we no longer see the problem with host busy status, since it uses the
> larger non-offloaded pool.
>
Yes, this is also the impression I got from reading the spec.
The offload pool is mainly designed for large read or write commands, so 
using it for _every_ frame is probably not a good idea.
And limiting it by the size of the transfers solves the problem quite 
nicely, as a large size typically is only used by read and writes.
So please send a patch to revert that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
