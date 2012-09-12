From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] block: add back command filter modification via sysfs
Date: Wed, 12 Sep 2012 14:56:27 +0200
Message-ID: <5050867B.2080605@redhat.com>
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com> <1347449133-26476-4-git-send-email-pbonzini@redhat.com> <20120912134124.55d968ef@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120912134124.55d968ef@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 12/09/2012 14:41, Alan Cox ha scritto:
>> > +	if (!q->cmd_filter) {
>> > +		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
>> > +					GFP_KERNEL);
>> > +		blk_set_cmd_filter_defaults(q->cmd_filter);
>> > +	}
>> > +
> This also needs CAP_SYS_RAWIO otherwise you have a capability escalation
> path.

Seems more like for CAP_SYS_ADMIN, since it can affect other processes
than the one writing to the file.

> I'm not really in favour of this patch as is. It's not as flexible as
> doing it with a BPF filter which if we are going to have a new API is
> going to be cleaner, faster and has a clear understood API plus tools.
> 
> With BPF you can do things like enabling command A with option B on a
> specific device for a certain block range.

I liked the BPF idea, either with SCM_RIGHTS or cgroups, but I do wonder
if it's overengineered.  There are two uses for the filtering:

- non-privileged users who want to burn a CD or something like that.
For this, a bitmap is more than enough.  Customizing the bitmap lets
userspace fix the case of different meanings for the same byte value in
different SCSI standards.

- virtualization who wants to pass through almost everything, but still
run as confined as possible.  In this case a more complex filtering can
be done just as easily in userspace (i.e. QEMU).  Of course this means
the filter can be subverted if the guest can escape the QEMU jail, but
the "almost everything" takes care of that, for example you could still
block WRITE BUFFER commands.

I would be okay with a ioctl to disable the filter altogether (four
options: regular filter, no filter, no SG_IO at all, choose depending on
CAP_SYS_RAWIO).  Then you can use file descriptor passing with
SCM_RIGHTS, and do everything in userspace.  But it doesn't work too
well with the first usage above, besides being a larger patch.

Paolo
