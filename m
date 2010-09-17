From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around SHT->queuecommand()
Date: Fri, 17 Sep 2010 16:22:34 +0200
Message-ID: <4C9379AA.4000103@linux.intel.com>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>	 <1284691571.26423.50.camel@mulgrave.site>	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com> <1284725592.26423.60.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284725592.26423.60.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


> I don't disagree with the idea of removing it, especially as it has so
> few users, but replacing the host lock with an atomic here would still
> vastly reduce the contention, which is the initial complaint.  The

Actually the complaint is the overhead of the spin lock. This can be 
either caused
by contention or by cache line bounce time.

> contention occurs because the host lock is so widely used for other
> things.  The way to reduce that contention is firstly to reduce the
> length of code covered by the lock and also reduce the actual number of
> places where the lock is taken.  Compared with host lock's current vast
> footprint, and atomic here is tiny.

That assumes that it's contention that is the problem and not simply 
bounce time.

-Andi
