From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 15 Jan 2003 09:12:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030115171233.GC1910@beaverton.ibm.com>
References: <MPESCHKE@de.ibm.com> <OFD72246CF.E2385102-ONC1256CAF.0050D1E1@de.ibm.com> <200301151552.h0FFqp402401@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301151552.h0FFqp402401@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, patmans@us.ibm.com, Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> I don't have any objections, but I do have a suggestion:
> 
> It would be nice to be able to use opaque quantites for target and LUN so that 
> the FC devices don't have to do this mapping dance between targed and internal 
> name.  i.e. if a FC driver wants to use the WWN or port for the target there 
> should be nothing preventing it.
> 

I believe back in this thread I was trying to say this with my nexus
object, but maybe poorly. 

Dynix/ptx had a similar model with its unit numbers. Every node in
the config tree had one but only the object knew how to decode it. It
was just passed around as part of the config object.

> All that really matters is that the target and LUN can be rendered to
> and from a string (for printing out and for accepting from
> add/remove-single-device).  

The kobjects are close to what your are talking about (see the
kobject.txt doc in the kernel). The have a few entries that we might
not need, but the do not need to be exported to sysfs. They carry a
kobj_type pointer that provides objs to show or store the values in the
object. A transport specific lib could contain common routines
which the LLDD could use or provide there own ops.

-andmike
--
Michael Anderson
andmike@us.ibm.com

