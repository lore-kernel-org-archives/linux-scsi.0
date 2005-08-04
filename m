From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] cpqfc: fix for "Using too much stach" in 2.6 kernel
Date: Thu, 4 Aug 2005 11:40:23 -0400
Message-ID: <20050804154023.GA22886@redhat.com>
References: <4221C1B21C20854291E185D1243EA8F302623BCC@bgeexc04.asiapacific.cpqcorp.net> <200508041138.38216@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31638 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262609AbVHDPlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 11:41:10 -0400
Content-Disposition: inline
In-Reply-To: <200508041138.38216@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>, linux-scsi@vger.kernel.org, axboe@suse.de

On Thu, Aug 04, 2005 at 11:38:30AM +0200, Rolf Eike Beer wrote:
 > 
 > >+	  ulFibreFrame = kmalloc((2048/4), GFP_KERNEL);
 > The size bug was already found by Dave Jones. This never should be written 
 > this way (not your fault). The array should have been [2048/sizeof(ULONG)].

wasteful. We only ever use 2048 bytes of this array, so doubling
its size on 64bit is pointless, unless you make changes later on
in the driver. (Which I think don't make sense, as we just copy
32 64byte chunks).

Ermm, actually this looks totally bogus..
CpqTsGetSFQEntry() ...

    if( total_bytes <= 2048 )
    {
      memcpy( ulDestPtr,
              &fcChip->SFQ->QEntry[consumerIndex],
              64 );  // each SFQ entry is 64 bytes
      ulDestPtr += 16;   // advance pointer to next 64 byte block
    }

we're trashing the last 48 bytes of every copy we make.
Does this driver even work ?

		Dave

