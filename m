From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [pnfs] [PATCH 05/28] pnfsblock: expose scsi interface
Date: Wed, 12 Mar 2008 20:36:06 +0200
Message-ID: <47D82296.80002@panasas.com>
References: <1205263929-8346-1-git-send-email-iisaman@citi.umich.edu>  <1205263929-8346-2-git-send-email-iisaman@citi.umich.edu>  <1205263929-8346-3-git-send-email-iisaman@citi.umich.edu>  <1205263929-8346-4-git-send-email-iisaman@citi.umich.edu>  <1205263929-8346-5-git-send-email-iisaman@citi.umich.edu>  <1205263929-8346-6-git-send-email-iisaman@citi.umich.edu>  <47D805DE.9000100@panasas.com> <20080312164306.GA3519@infradead.org> <2ea9cd5a0803121052p6569ff37l26a5448e588407ad@mail.gmail.com> <Pine.BSO.4.64.0803121400550.20573@citi.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:47178 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYCLShK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 14:37:10 -0400
In-Reply-To: <Pine.BSO.4.64.0803121400550.20573@citi.umich.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredric Isaman <iisaman@citi.umich.edu>
Cc: Jason Glasgow <jglasgow@aya.yale.edu>, Christoph Hellwig <hch@infradead.org>, Benny Halevy <bhalevy@panasas.com>, Andy Adamson <andros@umich.edu>, pnfs@linux-nfs.org, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 12 2008 at 20:10 +0200, Fredric Isaman <iisaman@citi.umich.edu> wrote:
> 
> On Wed, 12 Mar 2008, Jason Glasgow wrote:
> 
>> Christoph,
>>
>> Putting device discovery in user space a valid alternative implementation,
>> and we will pursue that model.
>>
>> -Jason
>>
>>
>> On Wed, Mar 12, 2008 at 12:43 PM, Christoph Hellwig <hch@infradead.org>
>> wrote:
>>
>>> On Wed, Mar 12, 2008 at 06:33:34PM +0200, Benny Halevy wrote:
>>>> This calls for a layering violation.
>>>>
>>>> To fill-in more context, here's an excerpt from the next patch,
>>>> showing how you use shost_class to scan all scsi disks:
> 
> The referenced code is an adhoc hack that does what we need it to for now. 
> We would *love* to be able to just call in to some scsi function that fits 
> our needs
> 
>>> Yes, absolutely.  No one outside of few places in the core scsi code
>>> should ever iterate over the scsi disks.
>>>
> 
> Is this for locking reasons?
> 
>>>> My question is how should a proper API between the scsi layer and
>>>> the block layout driver look like?
>>>>
>>>> Can you list your requirements, e.g.:
>>>> - scanning all available devices,
>>>>
>>>> - discovering new devices on the fly
>>>>
>>>> - getting notified for new devices?
>>> Neither.  pnfs shouldn't open block devices from kernelspace at all,
>>> but do it's disovery in userspace.
>>>
> 
> 
> Basically, we are given a disk signature, (an array of offset, byte
> sequence pairs) and want to match it against some visible disk (ignoring
> partitions), or know that it is not currently visible.
> 
> Thus our requirement are:
> 
> Scan all available block devices (though all available SCSI devices is a
> workable substitute).
> 
> Notification of new devices would be a helpful in optimizing rescans for 
> unmapped disk signatures.
> 
> 
> As Jason mentions, we will pursue doing this in userspace.
> 
>  	Fred
> 
> 
OK I found:
#ifndef __i386__
#undef CONFIG_SCSI_OMIT_FLASHPOINT
#define CONFIG_SCSI_OMIT_FLASHPOINT
#endif

try patch below and report
---
BusLogic: Remove total bullshit

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
git-diff --stat -p
 drivers/scsi/BusLogic.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index bfbfb5c..0f0d7f3 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -38,11 +38,6 @@
   CONFIG_PCI set.
 */
 
-#ifndef __i386__
-#undef CONFIG_SCSI_OMIT_FLASHPOINT
-#define CONFIG_SCSI_OMIT_FLASHPOINT
-#endif
-
 #ifndef CONFIG_PCI
 #undef CONFIG_SCSI_OMIT_FLASHPOINT
 #define CONFIG_SCSI_OMIT_FLASHPOINT

