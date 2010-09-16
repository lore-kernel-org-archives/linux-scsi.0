From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling	mptsas_qcmd
Date: Thu, 16 Sep 2010 15:00:08 -0700
Message-ID: <4C929368.4040903@cisco.com>
References: <1284666254.7280.54.camel@schen9-DESK> <1284670136.13344.93.camel@haakon2.linux-iscsi.org> <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39140 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0IPWAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 18:00:21 -0400
In-Reply-To: <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On 9/16/10 2:25 PM, Andi Kleen wrote:
>> I asked James about getting Vasu's unlocked_qcmds=1 patch merged, but he
>> convinced me that doing conditional locking while is very simple, is not
>> the proper way for getting this resolved in mainline code.  I think in
>> the end this will require a longer sit down to do a wholesale conversion
>> of all existing SCSI LLD drivers, and identifing the broken ones that
>> still need a struct Scsi_Host->host_lock'ed SHT->queuecommand() for
>> whatever strange & legacy reasons.
> 
> The standard way to do that would be to first move the lock down
> into the drivers (similar to how it has been done with the BKL).
> This would be a fairly mechanic mindless patch. Lots of typing,
> but not really a lot of real code review needed.
> 
> Then next step the drivers who know they don't want it can remove it.
> 
> -Andi

I see problems with this, but maybe I'm missing something.

It seems to me we can't completely move the host lock down into the
drivers since its a shared lock between SCSI and the drivers now.

If we just have SCSI drop the lock and have the LLD reacquire it,
that may open up a hole that some LLDs might not tolerate.
It also hurts performance for the LLDs that want to keep
the lock for the duration of queuecommand() by adding an extra
unlock/lock.

Obviously, some LLDs may depend on that shared lock being held,
without a drop just before the call.

So, I think the flag approach is OK, or wait until the wholesale
approach can be done.

	Regards,
	Joe
