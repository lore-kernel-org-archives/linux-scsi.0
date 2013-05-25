From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 20:54:34 -0700
Message-ID: <51A035FA.6070409@vlnb.net>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>	<519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org>	<519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org>	<519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org>	<519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org>	<519CE9FE.2030007@redhat.com> <yq1vc6b561q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3EYDyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 May 2013 23:54:51 -0400
In-Reply-To: <yq1vc6b561q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Martin K. Petersen, on 05/22/2013 09:32 AM wrote:
> Paolo> First of all, I'll note that SG_IO and block-device-specific
> Paolo> ioctls both have their place.  My usecase for SG_IO is
> Paolo> virtualization, where I need to pass information from the LUN to
> Paolo> the virtual machine with as much fidelity as possible if I choose
> Paolo> to virtualize at the SCSI level.  
> 
> Now there's your problem! Several people told you way back that the SCSI
> virt approach was a really poor choice. The SG_IO permissions problem is
> a classic "Doctor, it hurts when I do this".
> 
> The kernel's fundamental task is to provide abstraction between
> applications and intricacies of hardware. The right way to solve the
> problem would have been to provide a better device abstraction built on
> top of the block/SCSI infrastructure we already have in place. If you
> need more fidelity, add fidelity to the block layer instead of punching
> a giant hole through it.
> 
> I seem to recall that reservations were part of your motivation for
> going the SCSI route in the first place. A better approach would have
> been to create a generic reservations mechanism that could be exposed to
> the guest. And then let the baremetal kernel worry about the appropriate
> way to communicate with the physical hardware. Just like we've done with
> reads and writes, discard, write same, etc.

Well, any abstraction is good only if it isn't artificial, so solving more problems
than creating.

Reality is that de facto in the industry _SCSI_ is the abstraction for block/direct
access to data. Look around. How many of systems around you after all layers end up to
SCSI commands in their storage devices?

Linux block layer is purely artificial creature slowly reinventing wheel creating more
problems, than solving. It enforces approach, where often "impossible" means
"impossible in this interface". For instance, how about copy offload? How about
reservations? How about atomic writes? Look at history of barriers and compare then
with what can be done in SCSI. It's still worse, because doesn't allow usage of all
devices capabilities. Why was it needed to create special blk integrity interface with
the only end user - SCSI? Artificial task created - then well solved. Etc, etc.

The block layer keeps repeating SCSI. So, maybe, after all, it's better to acknowledge
that direct usage of SCSI without any intermediate layers and translations is more
productive? And for those minors not using SCSI internally, translate from SCSI to
their internal commands? Creating and filling CDB fields for most cases isn't anyhow
harder, than creating and feeling bio fields.

So, I appreciate work Paolo is doing in this direction. At least, the right thing will
be on the virtualization level.

I do understand that with all existing baggage replacing block layer by SCSI isn't
practical and not proposing it, but let's at least acknowledge limitations of the
academic block abstraction. Let's don't make those limitations global walls. Many
things better to do using direct SCSI, hence let's do the better way.

Vlad
