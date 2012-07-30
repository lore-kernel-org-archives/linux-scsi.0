From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Mon, 30 Jul 2012 09:12:42 +0200
Message-ID: <501633EA.603@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com> <50103043.5050508@redhat.com> <50104614.3080002@panasas.com> <501051DF.5040907@redhat.com> <50105F60.8050707@panasas.com> <5010F07E.7050506@redhat.com> <5010F831.9030300@panasas.com> <5010F896.8090409@redhat.com> <501140A3.9090908@redhat.com> <874notoh02.fsf@rustcorp.com.au> <50124D2E.7050407@redhat.com> <87obmym8jv.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87obmym8jv.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Il 30/07/2012 01:50, Rusty Russell ha scritto:
>> Also, being the first user of chained scatterlist doesn't exactly give
>> me warm fuzzies.
> 
> We're far from the first user: they've been in the kernel for well over
> 7 years.  They were introduced for the block layer, but they tended to
> ignore private uses of scatterlists like this one.

Yeah, but sg_chain has no users in drivers, only a private one in
lib/scatterlist.c.  The internal API could be changed to something else
and leave virtio-scsi screwed...

> Yes, we should do this.  But note that this means an iteration, so we
> might as well combine the loops :)

I'm really bad at posting pseudo-code, but you can count the number of
physically-contiguous entries at the beginning of the list only.  So if
everything is contiguous, you use a single non-indirect buffer and save
a kmalloc.  If you use indirect buffers, I suspect it's much less
effective to collapse physically-contiguous entries.  More elaborate
heuristics do need a loop, though.

Paolo
