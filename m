From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 09 Jan 2015 10:34:12 -0800
Message-ID: <1420828452.2064.20.camel@HansenPartnership.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
	 <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
	 <1420755361.2842.16.camel@haakon3.risingtidesystems.com>
	 <1420756142.11310.9.camel@HansenPartnership.com>
	 <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
	 <1420759360.11310.13.camel@HansenPartnership.com>
	 <1420779808.21830.21.camel@haakon3.risingtidesystems.com>
	 <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu>
	 <54B01DBD.5020707@suse.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDMOV25X7AMRBJV6YCSQKGQE6SVBSNA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54B01DBD.5020707-l3A5Bk7waGM@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-01-09 at 19:28 +0100, Hannes Reinecke wrote:
[...]
> > I think you are assuming we are leaving the iscsi code as it is today.
> > 
> > For the non-MCS mq session per CPU design, we would be allocating and
> > binding the session and its resources to specific CPUs. They would only
> > be accessed by the threads on that one CPU, so we get our
> > serialization/synchronization from that. That is why we are saying we
> > do not need something like atomic_t/spin_locks for the sequence number
> > handling for this type of implementation.
> > 
> Wouldn't that need to be coordinated with the networking layer?
> Doesn't it do the same thing, matching TX/RX queues to CPUs?
> If so, wouldn't we decrease bandwidth by restricting things to one CPU?

So this is actually one of the fascinating questions on multi-queue.
Long ago, when I worked for the NCR OS group and we were bringing up the
first SMP systems, we actually found that the SCSI stack went faster
when bound to a single CPU.  The problem in those days was lock
granularity and contention, so single CPU binding eliminated that
overhead.  However, nowadays with modern multi-tiered caching and huge
latencies for cache line bouncing, we're approaching the point where the
fineness of our lock granularity is hurting performance, so it's worth
re-asking the question of whether just dumping all the lock latency by
single CPU binding is a worthwhile exercise.

James

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
