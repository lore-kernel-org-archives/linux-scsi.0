From: David Mosberger <davidm@napali.hpl.hp.com>
Subject: Re: bogus barriers in sym53c8xx_2?
Date: Thu, 21 Aug 2003 12:34:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16197.7890.936054.41667@napali.hpl.hp.com>
References: <200308192349.h7JNnrEK017626@napali.hpl.hp.com>
	<20030820032611.GI19630@parcelfarce.linux.theplanet.co.uk>
	<20030820034318.GC25341@krispykreme>
Reply-To: davidm@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:1990 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S262874AbTHUTep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 15:34:45 -0400
In-Reply-To: <20030820034318.GC25341@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Matthew Wilcox <willy@debian.org>, davidm@hpl.hp.com, linux-ia64@vger.kernel.org, linux-scsi@vger.kernel.org

I didn't see any followup.  Gerard, do you have any comments?
I'm inclined to drop the #ifdef __ia64 part.  Also, I think
Matthew's suggestion to use rmb()/wmb() for the generic case
is a good one (though it makes no difference for ia64).

	--david

>>>>> On Wed, 20 Aug 2003 13:43:18 +1000, Anton Blanchard <anton@samba.org> said:

  >> I'm sure Gerard must have written it originally.  It's there in
  >> the earliest version of the sym2 driver I can find --
  >> sym-2.1.16a-for-linux-2.4.13.patch.gz.  A similar barrier is
  >> there in the sym1 driver (drivers/scsi/sym53c8xx_defs.h).  It
  >> seems to have been introduced around 2.4.3 (symbios driver
  >> version 1.6b -> 1.7.3a-20010304)

  >> So you're looking for a patch which looks something like this:

  >> - #define __READ_BARRIER() __asm__ volatile("mf.a; mf" : : :
  >> "memory") - #define __WRITE_BARRIER() __asm__ volatile("mf.a; mf"
  >> : : : "memory") + #define __READ_BARRIER() __asm__ volatile("mf"
  >> : : : "memory") + #define __WRITE_BARRIER() __asm__ volatile("mf"
  >> : : : "memory")

  >> Or really, might be better to just define them to rmb() and
  >> wmb()?

  Anton> I suspect so, the powerpc ones are overkill too:

  Anton> #define __READ_BARRIER() __asm__ volatile("eieio; sync" : : :
  Anton> "memory") #define __WRITE_BARRIER() __asm__ volatile("eieio;
  Anton> sync" : : : "memory")
