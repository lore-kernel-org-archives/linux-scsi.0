From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: possible scsi driver bugs with atomic_set/atomic_read and missing
 barrier
Date: Wed, 11 Mar 2009 10:36:55 +0100
Message-ID: <49B78637.1080102@s5r6.in-berlin.de>
References: <49B72F38.8090703@cs.wisc.edu> <20090311033927.GB25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60062 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZCKJiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2009 05:38:11 -0400
In-Reply-To: <20090311033927.GB25995@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Tue, Mar 10, 2009 at 10:25:44PM -0500, Mike Christie wrote:
>> atomic_set(&hba->state, SOME_STATE_VALUE);
>> 
>> in a interrupt or thread or tasklet then in another thread they will do
>> 
>> if (atomic_read(&hba->state) == SOME_STATE_VALUE))
>> 
>> Does this mean that the drivers should be doing a
>> 
>> atomic_set(&hba->state, SOME_STATE_VALUE);
>> smp_mb();
> 
> Possibly "smp_mb__after_atomic_inc()" might be correct.

Is this guaranteed to work with anything else than atomic_inc?

Mike,
it's also important to remember that barriers will be needed at the
reader place too (/if/ there actually are ordering requirements, that is).

E.g. in the writer:

	atomic_set(&hba->x, new_x);
	smp_wmb();
	hba->y = new_y;

And in the reader:

	y = hba->y;
	smp_rmb();
	x = atomic_read(&hba->x);

	do_something(x, y);

You would do this if you have a requirement that a reader needs 'x' to
always be at least as new as 'y', IOW would work incorrectly if an
outdated x would be used together with a current y.

This only works though if the reader can safely operate on an outdated
'y' + a current 'x'.  If neither current x + old y nor old x + current y
can be safely combined, then you need to wrap their write and read
accesses into lock- or mutex- protected sections.
-- 
Stefan Richter
-=====-==--= --== -=-==
http://arcgraph.de/sr/
