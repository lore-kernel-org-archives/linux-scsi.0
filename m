From: David Miller <davem@davemloft.net>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Mon, 24 Nov 2014 16:56:23 -0500 (EST)
Message-ID: <20141124.165623.42259031853400756.davem@davemloft.net>
References: <54735052.7020807@kernel.dk>
	<20141124162249.GG5050@linux.vnet.ibm.com>
	<547367DF.5060706@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54156 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKXV41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 16:56:27 -0500
In-Reply-To: <547367DF.5060706@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: paulmck@linux.vnet.ibm.com, hch@infradead.org, mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 24 Nov 2014 10:16:15 -0700

> How about this one?

The "num" in num_possible_cpus() means a count, as in how many are
there.

It doesn't mean largest ID of members of set X, which is what you
are asking for.

Even worse, having num_online_cpus() and num_possible_cpus() count
from a different perspective is really confusing.

Usually when people want a per-cpu thing they allocate percpu
memory which hides all of these details, why don't you allocate
the map as dynamic per-cpu memory?

It will also do the NUMA node local allocations for you as well.
