From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Fri, 14 Apr 2006 21:02:09 +0900
Message-ID: <443F8F41.1060002@gmail.com>
References: <20060414084914.63147.qmail@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.177]:8870 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932204AbWDNMCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 08:02:21 -0400
Received: by pproxy.gmail.com with SMTP id i49so66511pye
        for <linux-scsi@vger.kernel.org>; Fri, 14 Apr 2006 05:02:18 -0700 (PDT)
In-Reply-To: <20060414084914.63147.qmail@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Luben.

Luben Tuikov wrote:
[--snip--]
>> note is that libata might not have sdev to call that function with when 
>> it wants to invoke EH for hotplug.
> 
> Let's separate the domains.  You are doing a good thing in separating
> your SATA code into a "layer", and then you have LLDD which actually drive
> the HW by which you access the interconnect.  (Sounds familiar? ;-) )
> 
> Now enter SCSI (as in SAM).  How can you tell SCSI "do eh for me, but
> neither a device nor command has failed and I cannot give you either one of them"
> as you're saying you'd like to do above?  See?  It is a protocol thing!  That is,
> you want to handle such things in your layer.
> 
> But since the device abstraction and the command abstraction is _shared_ with
> SCSI Core, you have to call "scsi_req_abort_cmd()" and "scsi_req_dev_reset()"
> in order to request SCSI Core to call you back with that type of request when
> it feels that is is comfortable in calling you to abort the task or
> reset the device.

So, what's your suggestion here?  Do you think libata should do such 
things with its own mechanism?

>>>> Also, your routine calls more specific eh routines and you should try
>>>> to be more general.
>> Please, elaborate.
> 
> "scsi_times_out()"
> 
>> I think it's good have some infrastructure in SCSI.  e.g. libata can do 
>> everything itself but it's just nice to have SCSI EH infrastructure to 
>> build upon (EH thread, scmd draining & plugging...).
> 
> You have to admit, SCSI is a lot more than SATA.  For this reason,
> deriving an abstraction from your SATA code that would work for SCSI
> isn't an easy feat.
> 
> For example, why do you absolutely have to do anything in your eh_timed_out()
> callback?  Just atomicly mark your task abstraction as "aborting/aborted" and
> return EH_NOT_HANDLED so that you can get called back in your eh_strategy with
> a list of commands that need error recovery (ER, from now on).  This is _all_ that
> you're going to do in your eh_timed_out() callback.
> 
> By also having everything go through eh_timed_out() you can inspect at that instant
> if the command has completed and if not, mark it as aborted/aborting, else it has
> completed, give it to SCSI Core to complete it for you.
> 
> When your ER strategy gets called with a list of commands to be recovered,
> it is not necessarily the case that they ended up there because all of them timed
> out.  But one thing is for sure, they are all marked aborted/aborting and they
> all went through eh_timed_out() and were not done at that time.
> 
> Maybe some of them completed ok, and you'd want to "return" them, but cannot since
> they were marked "aborted/aborting"... it is this dis-syncrhonization or late-completion,
> which you can achieve.
> 
> Also consider that the "device failed" you can get from any of the commands on the
> er list when your er strategy gets called.  Pick the first command, take a look at the
> device, device dead, search the rest of the list for any commands also going to that
> device and "recover" them and the device, then go to the next command.
> 
> Consider, the SATA layer's task/device abstraction is shared with the LLDD and this
> is why you want to use things like eh_timed_out().  For commands and devices it is
> most likely the LLDD which will call them and you would want to get notified
> somehow of this (via the eh_timed_out()).
> 
> Also you want ER to always flow in the same direction from the same starting point
> going to the same ending point.
> 
> This is the reason to have scsi_req_abort_cmd() and scsi_req_device_reset(), callable
> from anywhere by anyone.

Point taken about scsi_req_abort_cmd().  scsi_req_abort_cmd() it is, 
then.  To proceed from here....

* sort out things about scsi_eh_schedule_port()/scsi_req_dev_reset()

* re-post patch for scsi_req_abort_cmd() and push it through either 
scsi-misc or libata-dev.  Luben, can you please re-post the patch?

Thanks.

-- 
tejun
