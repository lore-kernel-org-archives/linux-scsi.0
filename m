From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 13:10:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015201022.GB1049@beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015194705.GD4391@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Doug Ledford [dledford@redhat.com] wrote:
> I actually sent a patch to linus already to do this but it hasn't come 
> through yet.  However, my patch and yours differ in one key point that I 
> don't understand.
> 
> The scsi mid layer will never send you more than host->can_queue commands 
> at one time, so why do all the scsi driver authors feel it is necessary to 
> split their queue depth up amongst devices?  Justin Gibbs is the only one 
> that gets it right IMHO.  Set the depth on each device as deep as that 
> device can take (if that happens to be host->can_queue - 1 or such, then 
> so be it).  Then, let the mid layer and the request function worry about 
> fairness across devices.  That's its job after all.  If everyone is going 
> to moderate their queue depths like that, then we might as well yank 
> can_queue out of the host struct entirely because *it serves no purpose*.
> commands and a separate queue depth limit on each logical device).  So, I 
> can't say for sure what the ips driver can and can't do, but I'm 
> relatively sure that you are artificially limiting your own performance by 
> handling queue depths the way you are.

I never seen the mid layer handle device starvation correctly. It might
be because in scsi_queue_next_request we do this:

/*
 * Just hit the requeue function for the queue.
 */
  q->request_fn(q);

before we check for starved.


-andmike
--
Michael Anderson
andmike@us.ibm.com

