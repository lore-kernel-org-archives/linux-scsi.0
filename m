From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Tue, 17 Jul 2012 11:28:13 +0200
Message-ID: <5005302D.6010805@redhat.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>    <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>    <50044D56.6000400@redhat.com>   <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>   <50052390.7030908@redhat.com>  <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>  <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 17/07/2012 11:11, James Bottomley ha scritto:
> We don't do stuff just because the standards allows it; just the
> opposite: we try to use the smallest implementations from the standards
> we can get away with just because the more things we do, the more
> exceptions and broken devices we come across.

Yes, I realize failing only on specific sense codes as I did it in the
patch is not going to work.  However, the other way round is not
problematic (explicitly allow some sense codes, fail on all others).

Another example is "target operating conditions have changed".  QEMU
cannot report such changes because scsi_error prints a warning (fine)
and then passes the unit attention upwards.  With removable drives, this
has the same problem as resizing.

Paolo
