From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
Date: Thu, 16 Sep 2010 16:28:55 -0700
Message-ID: <1284679735.13344.123.camel@haakon2.linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTi=QXj0Do_PDvFmu5v8Py_tm_uJdDh_PQu_96M2v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=QXj0Do_PDvFmu5v8Py_tm_uJdDh_PQu_96M2v@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chetan Loke <chetanloke@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-16 at 19:26 -0400, Chetan Loke wrote:
> On Thu, Sep 16, 2010 at 6:35 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> 
> > and LLDs have adopted over the years.  The changes involved here are really
> > quite straight forward, but please note that none of this code has been tested
> > with actual hardware yet, and is intended for generating comments for the relivent
> > SCSI LLD driver maintainers and other interested folks.
> >
> 
> NO. Why not try testing it w/ an abort storm first else we will
> seriously end up screwing the filesystems....

The only real issue here would be an immediate struct
Scsi_Host->host_lock dead lock for those LLDs that still use legacy
unlock() > do_work() -> lock() in their SHT->queuecommand() caller.
This is *not* going to happen under heavy load with a bunch of
outstanding WRITEs, but immediate the first couple of times that
scsi_dispatch_cmd() gets called, so there is really little to no fear of
filesystem corruption with these patches.

Anyways, please feel free to test them yourself with an TMR ABORT storm
if you so desire..

Best,

--nab
