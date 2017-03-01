From: Hannes Reinecke <hare@suse.de>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Wed, 1 Mar 2017 10:40:57 +0100
Message-ID: <482f9e21-4e3a-ba8d-3bf6-97f85fa29fcf@suse.de>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <fc019750-b054-d9f7-0d5e-e6c7128073d8@suse.de>
 <7ed64006-84cd-06a0-3894-6d635fdc435a@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdCAQnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 11:43:42 -0500
In-Reply-To: <7ed64006-84cd-06a0-3894-6d635fdc435a@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 02/28/2017 07:14 PM, James Smart wrote:
> 
> On 2/28/2017 8:34 AM, Hannes Reinecke wrote:
>> Can you clarify these?
>> Are these 'just' resource allocation problems or something else, too?
> 
> Most are resource allocation - buffer pools, dma pools, pages for
> resources, and hw resource allocation splits. However, async receive RQ
> policies are a case where initiator and target have to share the policy
> and perhaps a buffer pool, so they have to be careful. Another area is
> in ABTS handling. Initiators typically leave things up to the hardware,
> and do little if any ABTS handling. Most targets though, as CMD IU may
> be received without an assign exchange context and be buffered until the
> target is ready to do something, require that they handle ABTS's.  Some
> of the target features, when enabled, dictate host ownership of ABTS
> policy. So, if running I+T, it gets rather tricky.
> 
Ah, okay.
However, I still would favour having both integrated into the same
driver; otherwise we run into the tricky issue of having to manually
unbind drivers from a given PCI device (or declare some PCI devices as
target capable on a rather arbitrary manner).
Can't it be modelled like the NVME-FC target, with having the same
driver supporting all modes, but the admin having to decide which PCI
function is doing what?
(NB: What about SR-IOV? Are the resources shared across functions or
does each function have its own set? If so than I'd be perfectly happy
if we could set each _function_ to a given role, much like
VirtualConnect does nowadays).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
