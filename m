From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: Optimize scsi_cmnd initialization and bug fix
Date: Mon, 28 Nov 2005 17:22:11 -0800
Message-ID: <200511290122.jAT1MKg02003@unix-os.sc.intel.com>
References: <1132819546.2832.28.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr24.intel.com ([143.183.121.16]:1511 "EHLO
	scsfmr004.sc.intel.com") by vger.kernel.org with ESMTP
	id S932321AbVK2BW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 20:22:29 -0500
In-Reply-To: <1132819546.2832.28.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote on Thursday, November 24, 2005 12:06 AM
> On Wed, 2005-11-23 at 14:50 -0800, Chen, Kenneth W wrote:
> > struct scsi_cmnd is a fairly large data structure and is used
> > to construct scsi command.  On x86-64 arch, it is 448 bytes.  
> > 
> > In scsi_get_command(), it is a bit too paranoid in zeroing the
> > data structure.  Since most of the member variables will be
> > initialized in various stage of I/O submission, i.e., in
> > scsi_prep_fn, scsi_init_io, sd_init_command, scsi_init_cmd_errh,
> > etc.  So instead of blindly zeroing the whole structure, initialize
> > to some other value later on.  All it needs in scsi_get_command
> > is to zero out a few member variables that aren't initialized in
> > the I/O path.
> 
> actually I question this optimisation. memset uses the rep stosl code
> sequence, which mean that the cpu can avoid write-allocate on the
> cachelines in question, and just plain zero them in cache. If you
> initialize the parts one by one, the cpu will need to do write-allocate
> on the cachelines, and thus has double the memory bandwidth needed than
> the existing case.
> 
> (not sure if all cpus are smart enough to avoid write allocate for rep
> stosl, but most of the newer ones are)


30 out of 38 member variables are initialized to non-zero value, about 4
are initialized by the LLDD.  Another 4 got written in the I/O return
path, though these 4 are sprinkled in the structure.  Even though memset
doesn't write-allocate, there are enough code which will bring the cache
line into the cpu anyway.  Since this is arch independent code, I'm also
trying to optimize not just x86-64, but other arch like ia64 which doesn't
have the same memset cache behavior.

Our experiments with I/O intensive db workload showed that removing memset
call has a net performance gain for db workload.

- Ken

