From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Tue, 20 Jan 2004 15:45:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120234539.GA3161@beaverton.ibm.com>
References: <OFCD4039B7.A0F8A1CD-ONC1256E21.007FF974@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:49034 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265844AbUATXls
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 18:41:48 -0500
Content-Disposition: inline
In-Reply-To: <OFCD4039B7.A0F8A1CD-ONC1256E21.007FF974@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: patmans@us.ibm.com, brking@us.ibm.com, Martin Hicks <mort@wildopensource.com>, linux-scsi@vger.kernel.org

Martin Peschke3 [MPESCHKE@de.ibm.com] wrote:
> And a rectified hierarchy of SCSI data structures should leave its mark
> on other SCSI stack functions. I am particularly thinking of error
> recovery, which should always be limited to the actual scope of failure,
> i.e. lun, target, bus, adapter, and be enlarged on demand, i.e. from
> lun to target, and so on, if some sort of escalation is needed.
> I have seen (2.4) SCSI stacks recover for hours while there were
> probably pretty operational devices blocked due to some recovery
> going on the same adapter.

I believe the goal is finer grain control of recovery and / or transport
specific recovery. While 2.6 is better in that we do not retry the IO in
the context of the error handler we still suspend all IO and wait on
inflight IO before recovery starts.

> What about a more sophisticated blocking interface?
> Or, various types of hotplug events, e.g. a FC port (= target)
> appearing on an LLDD's radar.
> Dreaming about 2.7 ...
> 

On hoptplug events it looks like Greg set out the exported interface
patch the other day. So we can all use this common function now.

http://marc.theaimsgroup.com/?l=linux-kernel&m=107456203121162&w=2

-andmike
--
Michael Anderson
andmike@us.ibm.com

