From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on partition
 devices
Date: Wed, 18 Jan 2012 10:00:57 +0100
Message-ID: <4F168A49.8000606@redhat.com>
References: <1326772723.2819.167.camel@deadeye>  <1326773222.2819.172.camel@deadeye> <4F1545A4.3000809@redhat.com> <1326862077.2819.210.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326862077.2819.210.camel@deadeye>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 01/18/2012 05:47 AM, Ben Hutchings wrote:
> >     Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioctl
> >     and -ENOIOCTLCMD from sd_compat_ioctl. ]
>
> But in 2.6.32, compat_sys_ioctl will end up returning EINVAL rather than
> ENOTTY for an unhandled ioctl number.

No, it won't.  The ioctl will percolate up the non-compat path and then 
sd_ioctl will return ENOTTY.

> Also, since we're denying ioctls
> for security reasons rather than because we don't know how to handle
> them, I don't think there's any harm in doing this.

There is harm.  You'll be blacklisting also the standard block device 
ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit 
userland will likely not boot anymore.  This is also somewhat exchanged 
in my original exchange with Linus.

Paolo
