From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Wed, 23 May 2007 11:55:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705231153360.7749@localhost.localdomain>
References: <20070521151525.GA581@suse.de>  <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
  <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
 <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.16.235.2] ([216.16.235.2]:57361 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758472AbXEWP4j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 11:56:39 -0400
In-Reply-To: <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Wed, 23 May 2007, James Bottomley wrote:

> I'll defer to Mark on this one.  However, please remember that you
> can't just blindly remove GFP_DMA ... there are some cards which
> require it.
>
> Aacraid is one example ... it has a set of cards that can only DMA
> to 31 bits.  For them, the GFP_DMA is necessary:  The allocation in
> question is a scatterlist, which must be within the device DMA mask.

a question i asked a while back, and still haven't seen an answer for
-- given this in include/linux/gfp.h:

  #define GFP_DMA         __GFP_DMA

is there a qualitative difference between these two macros?  is there
*supposed* to be?  if there isn't, one would think that just one
variation would be sufficient.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
