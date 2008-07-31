From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Thu, 31 Jul 2008 09:02:51 -0700
Message-ID: <20080731160251.GB76172@plap4-2.local>
References: <488E02DE.5080100@vlnb.net> <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net> <1217484743.25491.7.camel@galr-linux> <489181C4.70003@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28920 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYGaQCy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 12:02:54 -0400
Content-Disposition: inline
In-Reply-To: <489181C4.70003@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, Gal Rosen <galr@storwize.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Thu, 31 Jul 2008, Vladislav Bolkhovitin wrote:

> Gal Rosen wrote:
>> Andrew,
>>
>> Add checking of the flag online still does not answer the race that Vlad
>> stated before,
>
> Yes, that's true.
>
> And, since ha->flags.online set to 0 not only on shutdown, I'm afraid you 
> could introduce a new set of subtle bugs, if not for the moment, but in the 
> future, because with your patch it gets impossible to wake up the DPC 
> thread if HA is offline.

You are both missing a subtle point, it's incidental if
qla2xxx_wake_dpc() misses a 'wake-up' due the HBA being 'offline', as
the qla2x00_timer(), woken up every second, will do the wake-up if
necessary. The code changes offered, close the window as tightly as
possible without introducing needlessly complex changes.  All this
infrastructure is legacy constucts from a time long-before work-queues
and the like.

This area is one of several where we are moving to clean-up and
modernize in our upstream offering:

* dropping the heavy DPC thread in favor of work-queues.
* using proper life-cycle and reference-handling of fcport objects
  (yes, the objects will be freed after use).
* refactoring the HA respresentations for physical and virtual ports,
  the current memcpy() physical-HA to vport-HA and slight-mods is
  error-prone and doesn't scale.
* drop the illogical single physical-HA maintains all fcports across
  N-vports.

The changes above are large (170k diffs so far), and at this point are
being run-through our testing.  The hope is to get the changes
upstream during one of the next two merge windows.

Given the infrustructure mods and our focus on that front, if there's
something small and contained you can offer above what I've proposed
we'll be interested in reviewing any patches you'd push forward.

Regards,
Andrew Vasquez
