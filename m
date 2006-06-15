From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Thu, 15 Jun 2006 12:31:27 -0500
Message-ID: <4491996F.4000104@cs.wisc.edu>
References: <8889.1149988615@bebe.enoyolf.org> <448DACD5.6090205@cs.wisc.edu> <20060612211038.GB7555@ranandlinuxbox.qlogic.org> <448DDE31.2090300@cs.wisc.edu> <20060612224325.GK7555@ranandlinuxbox.qlogic.org> <448E314E.1040702@cs.wisc.edu> <20060615004352.GA3216@ranandlinuxbox.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:11650 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030897AbWFORbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 13:31:45 -0400
In-Reply-To: <20060615004352.GA3216@ranandlinuxbox.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Doug Maxey <dwm@bebe.enoyolf.org>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com, David Wagner <david.wagner@qlogic.com>

Ravi Anand wrote:
>> On Mon, 12 Jun 2006, Mike Christie wrote:
>> Ravi Anand wrote:
>>>> On Mon, 12 Jun 2006, Mike Christie wrote:
>>>> Date: Mon, 12 Jun 2006 16:35:45 -0500
>>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>> To: Ravi Anand <ravi.anand@qlogic.com>
>>>> CC: Doug Maxey <dwm@bebe.enoyolf.org>,
>>>> 	David Somayajulu <davidcs2005@gmail.com>,
>>>> 	Duane Grigsby <duane.grigsby@qlogic.com>,
>>>> 	linux-scsi@vger.kernel.org, dwm@austin.ibm.com
>>>> Subject: Re: [RFC] qla4xxx: TODO for re-submission
>>>> User-Agent: Thunderbird 1.5 (X11/20060313)
>>>>
>>>> Ravi Anand wrote:
>>>>>> On Mon, 12 Jun 2006, Mike Christie wrote:
>>>>>> Doug Maxey wrote:
>>>>>>> 5) add the block layer code.
>>>>>> Some related issues that we have discussed offlist about this and should
>>>>>> probably be discussed here are:
>>>>>>
>>>>>> - Are we supposed to follow FC's lead and remove the devices (rport,
>>>>>> session, target, scsi_device, etc) if the dev_loss_tmo fires. Currently
>>>>>> for software iscsi, we leave the devices/session. This was to reduce
>>>>>> memory allocations and because software iscsi has to basically poll the
>>>>>> connection during connect as part of the relogin process. So unlike FC
>>>>>> or hw iscsi, if we remove the devices/structs we have to end up
>>>>>> rebuilding some of them right away anyways.
>>>>>>
>>>>>> Removing the devices has the benefit of simplifying the scsi/iscsi code.
>>>>>>
>>>>>> - Scanning. We currently do scanning for open-iscsi in userspace. For
>>>>>> iscsi root this requires distro support. SUSE has it. Fedora is working
>>>>>> on it. There is also Debian and Gentoo users or maintainers posting
>>>>>> about working on it. For qla4xxx, we could stick the scanning in the
>>>>>> kernel like FC and distros would not have to worry about it, but since
>>>>>> they have to get this working for software iscsi do we just keep the
>>>>>> scanning in userspace?
>>>>> Our preference is also to have the scanning for all the HBA's which
>>>>> does the discovery of the tgt's in the kernel space. This way we are
>>>>> consistent with all the HBA's which does the port discovery like 
>>>>> the FC HBA's. Our iSCSI HBA's is similar in that regard.
>>>> Yeah, but your HBA can also function in connection mode and just use
>>>> open-iscsi's login code too. I am not saying that is that way to go. I
>>>> am just saying that there are alternatives.
>>> Agreed. But it was added later on. So the driver always used the session mode.
>> And we never redo iscsi drivers right ;)
> 
> This is the one which I wanted to send out. Please discard the previous one.
> 
> We really want to fit in with the open-iscsi model. But at this point of time
> we will have to live with this for the existing products. Reason being we are
> so far down the road with the session mode support in the driver that's it not
> possible to revert back to connection mode.
> 
> For the future products we are definitely committed to be using connection
> mode which fits in very well with the open-iscsi.
> 
> And since in the session mode, all the targets has already been discovered
> and logged in, it make more sense for  HW iscsi driver to initiate tgt port
> scan in the kernel space like we do for FC-rport. I dont think in that
> regard iSCSI/FC is any different.
>

See below.


> For open-iscsi if I am not mistaken it really initiates the scanning from
> userspace thru sysfs, but still tgt/lun scanning happens in the kernel space.

I think I see where you are going, but for both of these as you can see
from the work JamesS did with the FC class, we are more talking about
the thread work and iscsi state machine bits that are pushed to
userspace. The initiation of the scanning is a big part too, but that is
not all we are talking about.

My only opinion is that if we go to the kernel both should go. I do not
want to mess around with maintaining two paths like we have to with the
connect code. Ditto for the block/unblock code.

> 
> This really simplifies for HW iscsi from booting perspective as well.

Yeah we went over this, I agree if we always are talking about
persistent targets and if we use your FW vs the common open-iscsi db and
if we are assuming distros are not going to add open-iscsi root boot
support.

> 
> 
>>>>> As you have already stated, it simplies support from distro perspective 
>>>>> as well.
>>>>>
>>>> It does for qla4xxx, but I think you then have to go and fix it so
>>>> iscsi_tcp and iscsi_iser sync up with userspace correctly if you convert
>>>> them. Either that or we maintain two ways of scanning for iscsi drivers.
>>> I like the later part. Keeping it seperate.
>>>
>> I think I was only kidding about that option. But now we have votes for
>> every possible solution :)
>>
>> You also still have the iSNS issue. That will be in userspace, so one
>> day you will have to modify the distros to do iscsi root when using iSNS
>> and use iSNS for installer targets.
> 
> For iSNS in our case, the App's just present the targets, but it still need
> to be saved in the flash for it to persistently bound and automatically logged in.
> So again its pretty much the same in terms of behaviour from driver perspective
> even for non iSNS scenario.

So normally when you say target you mean portal. I mean for sendtargets
we set a portals as persistent not a whole target right (this is from
jsut using iscli)? For iSNS, can't we get updates that there are new
portals popping in the san? You are not saying that normally we want to
handle this by starting up a config app and setting them as persistent.
I thought we would want to dyncallically add them to the system.

What is the point of using iSNS and setting the targets as persistent in
the initiator DB anyways? I thought one of the benefits of iSNS is that
we would manage all the targets and initiator access from a central
location?
