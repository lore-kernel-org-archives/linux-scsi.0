From: James.Smart@Emulex.Com
Subject: RE: [Patch RFC] Add FC transport host statistics
Date: Thu, 14 Oct 2004 16:34:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C0866E3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63469 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267401AbUJNUe6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 16:34:58 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu

I'm going to backtrack on one "reasonable thing"...

> > shouldn't we instead pass an offset in terms of sizeof(u64) 
> > so we can do
> > simple pointer arithmetics like
> > 
> > 			ret = snprintf(buf, 20, "0x%llx\n", 
> > stats + idx);
> > 

Note that to do so takes a little more complexity to generate offsets rather than simply using "offsetof(struct, name)". Also, if you mix a non-uniform type in the stats array (something other than u64), using the offsetof method still works for anything that stays u64, while allowing custom get routines for the non-uniform type'd elements.

-- james

 
