From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 1/1] scsi : megaraid_{mm, mbox} : irq data type fix
Date: Thu, 10 Aug 2006 11:34:40 -0600
Message-ID: <m1vep01olr.fsf@ebiederm.dsl.xmission.com>
References: <1155228887.6698.7.camel@dhcp-65-957.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422644AbWHJRfJ@vger.kernel.org>
In-Reply-To: <1155228887.6698.7.camel@dhcp-65-957.se.lsil.com> (Seokmann Ju's
	message of "Thu, 10 Aug 2006 12:54:47 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Seokmann Ju <sju@lsil.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Seokmann Ju <sju@lsil.com> writes:

> This patch fixes incorrect irq data type in the driver which led driver
> initialization failure in some cases.
> The problem was reported by Eric @. Biederman <ebiederm@xmission.com>.

We have a race going on, I read your first message then this one pops up.
But I will reply again for wider distribution.

Nacked-by: Eric Biederman.

The problem is that struct mcontroller is exported to user space
and is a packed structure so it has no free bytes.

Therefore you will break user space when you add bytes in the
middle of your structure.  We can't do that.  You either need
to add an extra field at the end (while keeping the structure size the
same) or you need to add a new ioctl that gets this information correct,
or you need to give up entirely on the idea of exporting the irq
number to user space this way.

What you need not to do is break the kernel<->user space ABI.  That
is just confusing and couples the kernel and user space in unpleasant
ways.

I believe struct mraid_hba_info has the same problem but I could not
see where it was exported to user space.

Eric
