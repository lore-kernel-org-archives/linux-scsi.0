From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Tue, 17 Dec 2013 13:25:06 -0800
Message-ID: <1387315506.20247.320.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
	 <52B02D13.9000207@suse.de> <52B08588.6080102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52B08588.6080102@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 09:10 -0800, Andy Grover wrote:
> On 12/17/2013 02:53 AM, Hannes Reinecke wrote:
> 
> > But the LUN addressing improvements is interesting.
> >
> > What I found during development of the 64bit LUN patchset is
> > that the target core stuff has a very rudimentary LUN handling:
> > - 256 LUNs only
> > - LUNs are kept in a static array
> > - Identity mapping between LUN numbers and array indices.
> >
> > What I _really_ would like to have is to do away with the
> > LUN array, and introduce a dynamic LUN mapping.
> > This will allow us to easily implement different LUN enumeration
> > methods (Think of hierarchical LUNs ...).
> >
> > Also the assumption that a static array is always faster for
> > lookup than a linked list is wrong.
> > A static array is faster if the entire array fits into the processor
> > cache. If it doesn't we basically have an immediate
> > cache miss _for every array access_.
> > Then linked lists etc really are faster.
> >
> > So do not take things at face value; only real measurements
> > count here.
> 
> Yeah, seems true. So do either of you have any tips for how best to do 
> measurements?
> 

perf mem -t all record -a sleep 20

perf mem report --sort=mem,sym,dso,symbol_daddr,dso_daddr,tlb,locked

> BTW I was looking a little more and am now inclined to think a radix 
> tree is more suitable than rbtree. It seems ideally suited for our case: 
> want to lookup by an index (i.e. LUN) that is usually a small integer, 
> very fast lookups, yet also can grow and still be space-efficient.
> 

My understanding is that radix trees would involve less memory accesses
vs. rbtrees, and less misses when cache is cold.

--nab
