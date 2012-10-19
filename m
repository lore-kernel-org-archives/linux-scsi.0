From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/3] block: add queue-private command filter,
 editable via sysfs
Date: Thu, 18 Oct 2012 17:22:50 -0700
Message-ID: <20121019002250.GB13370@google.com>
References: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
 <506D60FC.7090801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <506D60FC.7090801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

Sorry about the delay.  -EWASTRAVELING and it seems Jens was too.

On Thu, Oct 04, 2012 at 12:12:12PM +0200, Paolo Bonzini wrote:
> Il 25/09/2012 17:30, Paolo Bonzini ha scritto:
> > The set of use cases for SG_IO is quite variable that no single filter can
> > accomodate all of them.  The current filter is tailored very much to
> > CD burning, and includes many MMC-specific commands that may have
> > other meanings in different standards.  Someone may want to remove
> > those commands; at the same time, people that trust their users may
> > want to add persistent reservations, trim/discard, or even access to
> > vendor-specific commands.
> > 
> > Filters used to be mutable via sysfs, but the implementation was
> > never enabled.  Add it back, and let the admin set this up per device.
> > 
> > A simple bitmap does not let you do things like enabling command A with
> > option B on a specific device for a certain block range.  However, the
> > question is really whether this is needed---in fact, neither of the known
> > uses for the filtering need it.
> > 
> > In one use case, the administrator then needs the ability to configure
> > devices easily, for example to be much more restrictive on non-MMC
> > devices.  It must be done with the same tools it uses for other aspects
> > of the policy---which will be a combination of DAC (Unix permissions and
> > ACLs) and sysfs.  Different SCSI standards may give different meanings
> > for the same byte value, but a simple bitmap is enough for this.
> > 
> > In the virtualization case, the problem is really that you want to
> > pass through everything or almost everything, while still running as
> > confined as possible (i.e. CAP_SYS_RAWIO is not a choice).  But in this
> > case a more complex filtering can be done just as easily in userspace,
> > in the virtual machine monitor.  While the userspace filter can be
> > subverted if the guest can escape the QEMU jail, the bitmap still lets
> > you block some commands at the kernel level if really necessary.
> > 
> > One alternative is a ioctl to disable the filter altogether, to be
> > used together with SCM_RIGHTS file descriptor passing.  This works in
> > the virtualization case but not for policy decisions.  So this patch
> > series provides the sysfs knob.  It is a tweaked revert of commit 018e044
> > (block: get rid of queue-private command filter, 2009-06-26).

If your use case at hand is mostly virtualization, I personally would
prefer the latter solution instead of extending in-kernel SG_IO
filter.  It could be that I'm just not aware but I don't think there
have been too many complaints regarding other use cases.  This type of
deep inspection and filtering has fairly strong tendency to be
unpopular.  Userland configurable one is even scarier and I don't
think too many would know and make use of it in the end.

Jens, what are your thoughts?

Thanks.

-- 
tejun
