From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 13:04:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015130445.A829@eng2.beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015194705.GD4391@redhat.com>; from dledford@redhat.com on Tue, Oct 15, 2002 at 03:47:06PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 03:47:06PM -0400, Doug Ledford wrote:

> The scsi mid layer will never send you more than host->can_queue commands 
> at one time, so why do all the scsi driver authors feel it is necessary to 
> split their queue depth up amongst devices?  Justin Gibbs is the only one 
> that gets it right IMHO.  Set the depth on each device as deep as that 
> device can take (if that happens to be host->can_queue - 1 or such, then 
> so be it).  Then, let the mid layer and the request function worry about 
> fairness across devices.  That's its job after all.  If everyone is going 
> to moderate their queue depths like that, then we might as well yank 
> can_queue out of the host struct entirely because *it serves no purpose*.

> Now, simple scsi controllers like the aic7xxx and intelligent raid 
> controllers are two different beasts.  On simple controllers, the max 
> queue depth on a target is typically whatever that target can handle.  On 
> raid controllers, it's all up to what the firmware can handle (for all I 
> know, the ServeRAID firmware may have one queue depth limit for total 
> commands and a separate queue depth limit on each logical device).  So, I 
> can't say for sure what the ips driver can and can't do, but I'm 
> relatively sure that you are artificially limiting your own performance by 
> handling queue depths the way you are.

I totally agree the queue depth should not be limited based on the number of
devices, but there should be a maximum limit - as Justin noted with the
aic driver, using a large default queue depth (he had 253 or so) is not
good with linux.

The queue depth should be as small as possible without limiting the
performance.

-- Patrick Mansfield
