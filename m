From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 12:32:33 -0400
Message-ID: <yq1vc6b561q.fsf@sermon.lab.mkp.net>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
	<519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org>
	<519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org>
	<519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org>
	<519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org>
	<519CE9FE.2030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47811 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3EVQcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 12:32:25 -0400
In-Reply-To: <519CE9FE.2030007@redhat.com> (Paolo Bonzini's message of "Wed,
	22 May 2013 17:53:34 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Paolo" == Paolo Bonzini <pbonzini@redhat.com> writes:

Paolo> First of all, I'll note that SG_IO and block-device-specific
Paolo> ioctls both have their place.  My usecase for SG_IO is
Paolo> virtualization, where I need to pass information from the LUN to
Paolo> the virtual machine with as much fidelity as possible if I choose
Paolo> to virtualize at the SCSI level.  

Now there's your problem! Several people told you way back that the SCSI
virt approach was a really poor choice. The SG_IO permissions problem is
a classic "Doctor, it hurts when I do this".

The kernel's fundamental task is to provide abstraction between
applications and intricacies of hardware. The right way to solve the
problem would have been to provide a better device abstraction built on
top of the block/SCSI infrastructure we already have in place. If you
need more fidelity, add fidelity to the block layer instead of punching
a giant hole through it.

I seem to recall that reservations were part of your motivation for
going the SCSI route in the first place. A better approach would have
been to create a generic reservations mechanism that could be exposed to
the guest. And then let the baremetal kernel worry about the appropriate
way to communicate with the physical hardware. Just like we've done with
reads and writes, discard, write same, etc.

The fact that burning CDs requires SG_IO in the first place is just a
symptom that we got that interface totally wrong. cat iso.img > /dev/sr0
would have been much more in line with how Unix works...

-- 
Martin K. Petersen	Oracle Linux Engineering
