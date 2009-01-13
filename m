From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUILD-FAILURE] next-20090113 - drivers/scsi/aha1542.c builds
	with CONFIG_PPC=y
Date: Tue, 13 Jan 2009 11:50:12 -0600
Message-ID: <1231869012.4519.20.camel@localhost.localdomain>
References: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
	 <20090113120314.GC2364@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090113120314.GC2364@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-01-13 at 17:33 +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	next-20090113 ranconfig build on powerpc builds in drivers/scsi/aha1542
> 
> In file included from drivers/scsi/aha1542.c:41:
> include/linux/mca-legacy.h:12:2: warning: #warning "MCA legacy - please move your driver to the new sysfs api"
> drivers/scsi/aha1542.c: In function 'BAD_SG_DMA':
> drivers/scsi/aha1542.c:61: error: implicit declaration of function 'isa_page_to_bus'
> drivers/scsi/aha1542.c: In function 'aha1542_intr_handle':
> drivers/scsi/aha1542.c:495: error: implicit declaration of function 'isa_virt_to_bus'

This looks like a powerpc bug:  that driver depends on ISA &&
ISA_DMA_API which is supposed to guarantee the presence of these
functions.

James
