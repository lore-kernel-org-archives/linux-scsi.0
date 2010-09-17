From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
	SHT->queuecommand()
Date: Fri, 17 Sep 2010 09:41:44 -0700
Message-ID: <1284741704.13344.157.camel@haakon2.linux-iscsi.org>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
	 <1284725592.26423.60.camel@mulgrave.site>
	 <4C9379AA.4000103@linux.intel.com>
	 <1284735438.26423.81.camel@mulgrave.site>
	 <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:39436 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751679Ab0IQQpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 12:45:53 -0400
In-Reply-To: <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Fri, 2010-09-17 at 09:37 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2010-09-17 at 10:57 -0400, James Bottomley wrote:
> > On Fri, 2010-09-17 at 16:22 +0200, Andi Kleen wrote:
> > > > I don't disagree with the idea of removing it, especially as it has so
> > > > few users, but replacing the host lock with an atomic here would still
> > > > vastly reduce the contention, which is the initial complaint.  The
> > > 
> > > Actually the complaint is the overhead of the spin lock. This can be 
> > > either caused
> > > by contention or by cache line bounce time.
> > 
> > The original complaint was contention.  My desire is to reduce the
> > locked path coverage, so I saw an opportunity.
> > 
> > What I was actually thinking of for the atomic is that we'd let it range
> > [1..INT_MAX] so a zero was an indicator of no use of this.  Then the
> > actual code could become
> > 
> > if (atomic_read(x)) {
> > 	do {
> > 		y = atomic_add_return(1, x);
> > 	} while (y == 0);
> > }
> 
> The conversion of struct scsi_cmnd->serial_number to atomic_t and the
> above code for scsi_cmd_get_serial() sounds perfectly reasonable to me.
> 

Actually, that should be the conversion of struct
Scsi_Host->cmd_serial_number to an atomic_t.   AFAICT there is no reason
for struct scsi_cmnd->serial_number needing to be an atomic_t.

Best,

--nab


