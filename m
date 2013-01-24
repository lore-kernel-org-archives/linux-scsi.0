From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/13] sg_io: reorganize list of allowed commands
Date: Thu, 24 Jan 2013 14:58:45 -0800
Message-ID: <20130124225845.GD2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
 <20130124224203.GA2373@mtj.dyndns.org>
 <20130124224921.GB2373@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130124224921.GB2373@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 24, 2013 at 02:49:21PM -0800, Tejun Heo wrote:
> On Thu, Jan 24, 2013 at 02:42:03PM -0800, Tejun Heo wrote:
> > One other thing is I would much prefer if the table was made static
> > const first.  As we only allow compile-time defined tables, there's no
> > point in dynamically initializing these and the above can be static
> > initializers.
> 
> On the similar line of thoughts, wouldn't it be better to have the
> table organized by the device type first?  It would be much easier to
> comprehend which commands are allowed for each device type that way
> and FWIW it would be more cacheline friendly.  e.g. something like,
> 
> #define M(opcode)	(1 << opcode)
> 
> #define COMMON	\
> 	M(READ_6) | M(WRITE_6) | ....
> 
> static const whatever_type blk_cmd_filter_disk = {
> 	COMMON				|
> 	M(CMD_SPECIFIC_TO_THIS_TYPE0)	|
> 	M(CMD_SPECIFIC_TO_THIS_TYPE2)	|
> 	...
> };

Oops, there are way more bits than in the longest integer, so you
can't statically initialize them in pretty way (maybe it's possible
but I can't think of anything pretty).  We can still initialize the
table once during boot and throw away the init code, I guess.  Also, I
still think device -> command organization would be better than
commmand -> device.

Thanks.

-- 
tejun
