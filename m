From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Tue, 29 Mar 2011 15:57:21 -0400
Message-ID: <20110329195721.GI24485@redhat.com>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>
 <20110329173338.GD24485@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>
 <20110329184501.GG24485@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2T5c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2011 15:57:32 -0400
Content-Disposition: inline
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: rwheeler@redhat.com, James.Bottomley@hansenpartnership.com, lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Tue, Mar 29, 2011 at 12:13:41PM -0700, Shyam_Iyer@Dell.com wrote:

[..]
> > 
> > Sounds like some user space daemon listening for these events and then
> > modifying cgroup throttling limits dynamically?
> 
> But we have dm-targets in the horizon like dm-thinp setting soft limits on capacity.. we could extend the concept to H/W imposed soft/hard limits.
> 
> The user space could throttle the I/O but it had have to go about finding all processes running I/O on the LUN.. In some cases it could be an I/O process running within a VM.. 

Well, if there is one cgroup (root cgroup), then daemon does not have to
find anything. This is one global space and there is provision to set
per device limit. So daemon can just go and adjust device limits
dynamically and that gets applicable for all processes.

The problem will happen if there are more cgroups created and limits are
per cgroup, per device. (For creating service differentiation). I would
say in that case daemon needs to be more sophisticated and reduce the
limit in each group by same % as required by thinly provisioned target.

That way a higher rate group will still get higher IO rate on a thinly
provisioned device which is imposing its own throttling. Otherwise we
again run into issues where there is no service differentiation between
faster group or slower group.

IOW, if we are throttling thinly povisioned devices, I think throttling
these using a user space daemon might be better as it will reuse the
kernel throttling infrastructure as well as throttling will be cgroup
aware.
 
> 
> That would require a passthrough interface to inform it.. I doubt if we would be able to accomplish that any sooner with the multiple operating systems involved. Or requiring each application to register with the userland process. Doable but cumbersome and buggy..
> 
> The dm-thinp target can help in this scenario by setting a blanket storage limit. We could go about extending the limit dynamically based on hints/commands from the userland daemon listening to such events.
> 
> This approach will probably not take care of scenarios where VM storage is over say NFS or clustered filesystem..

Even current blkio throttling does not work over NFS. This is one of the
issues I wanted to discuss at LSF.

[..]
> Well.. here is the catch.. example scenario..
> 
> - Two iSCSI I/O sessions emanating from Ethernet ports eth0, eth1  multipathed together. Let us say round-robin policy.
> 
> - The cgroup profile is to limit I/O bandwidth to 40% of the multipathed I/O bandwidth. But the switch may have limited the I/O bandwidth to 40% for the corresponding vlan associated with one of the eth interface say eth1
> 
> The computation that the bandwidth configured is 40% of the available bandwidth is false in this case.  What we need to do is possibly push more I/O through eth0 as it is allowed to run at 100% of bandwidth by the switch. 
> 
> Now this is a dynamic decision and multipathing layer should take care of it.. but it would need a hint..
> 

So we have multipathed two paths in a round robin manner and one path is
faster and other is slower. I am not sure what multipath does in those
scenarios but trying to send more IO on faster path sounds like right
thing to do.

Thanks
Vivek
