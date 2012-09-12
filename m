From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Wed, 12 Sep 2012 09:05:41 +0100
Message-ID: <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
	 <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <504F7B65.9090603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-09-11 at 19:56 +0200, Paolo Bonzini wrote:
> The set of use cases is so variable that no single filter can accomodate
> all of them: high availability people want persistent reservations, NAS
> people want trim/discard, but these are just two groups.  Someone is
> using a Windows VM to run vendor tools and wants to have access to
> vendor-specific commands.
> 
> You can tell this last group to use root, but not everyone else who is
> already relying on Unix permissions, SELinux and/or device cgroups to
> confine their virtual machines.

This is why the whole filter thing was mutable via sysfs.  That way the
admin could set this up per device.  It sounds like this is what you
want to fix, rather than opening up more holes in an already leaky
security apparatus.  The ideal is that we would be much more restrictive
by default and give root the ability to override this both globally and
per-device to conform to whatever policy it has for the virtual
environments.

The patch which removed all of the sysfs pieces was:

commit 018e0446890661504783f92388ecce7138c1566d
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 26 16:27:10 2009 +0200

    block: get rid of queue-private command filter

So that's probably the place to start for putting it back properly.

James
