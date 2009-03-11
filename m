From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: possible scsi driver bugs with atomic_set/atomic_read and missing
 barrier
Date: Wed, 11 Mar 2009 09:45:29 +0100
Message-ID: <49B77A29.70806@s5r6.in-berlin.de>
References: <49B72F38.8090703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59874 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZCKIqq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2009 04:46:46 -0400
In-Reply-To: <49B72F38.8090703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

Mike Christie wrote:
...
> In the Documentation/atomic_ops.txt it says:
> 
> 	atomic_read does not guarantee that the runtime
> 	initialization by any other thread is visible yet, so the user of the
> 	interface must take care of that with a proper implicit or
> 	explicit memory barrier.
> 
> Does this mean that the drivers should be doing a
> 
> atomic_set(&hba->state, SOME_STATE_VALUE);
> smp_mb();

Barriers --- or locks even --- are required if there are dependencies
between the state variable and other data.

(Use a barrier if you need to ensure ordering of accesses.  Use a lock
if you need to combine multiple operations into an atomic whole.  Lock/
unlock also imply barriers.)
-- 
Stefan Richter
-=====-==--= --== -=-==
http://arcgraph.de/sr/
