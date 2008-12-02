From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Tue, 2 Dec 2008 16:36:23 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B27D798D1@azsmsx505.amr.corp.intel.com>
References: <20081118222051.2289.81361.stgit@fritz>
	<20081118222111.2289.35843.stgit@fritz> <87tz9xh1o6.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58824 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYLBXpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 18:45:32 -0500
In-Reply-To: <87tz9xh1o6.fsf@basil.nowhere.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@redhat.com" <jgarzik@redhat.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "davem@davemloft.net" <davem@davemloft.net>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "jeykholt@cisco.com" <jeykholt@cisco.com>

Andi Kleen wrote:
> Robert Love <robert.w.love@intel.com> writes:
> 
<snip>

>> +static int fc_disc_debug;
>> +
>> +#define FC_DEBUG_DISC(fmt...)			\
>> +	do {					\
>> +		if (fc_disc_debug)		\
>> +			FC_DBG(fmt);		\
>> +	} while (0)
> 
> In 2.6.28 there is dynamic_printk.h now to handle this.
> 
I was looking into making this change, but the dynamic_printk
doesn't do what we want. We have this code in each of our layers
to allow us to turn on debugging at a sub-module level, as far as I
can tell this isn't supported by the dynamic_printk.

I then thought that we could convert our debug statements to
pr_debug() calls (I'm not sure what 'pr' stands for, but I think 
that's what I should use). However, that would cause us to do excessive
printing if the kernel was configured with DEBUG (how do you set
this?). This is especially true in the EM where code is executed
frequently and some of our debug statements happen often when the
EM debug define has a value. Also, it would mean that when debugging
Open-FCoE, we'd have all kernel debug statements, not just our own.

What I really want is the ability to dynamically turn on or off
our port code debug statements (LP, RP and disc) and then have a
compile option for our I/O path and EM. We think that adding module
parameter to toggle some of these prints would probably work best
for our needs, but it's low on our priority list right now.

Open-iSCSI uses a method similar to what we're doing, just not to
the degree that we're doing it and I didn't find much use of pr_debug
in drivers/scsi/* or include/scsi/*.