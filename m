From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] aic94xx: sas code clean-up phase 2
Date: Thu, 8 Jun 2006 13:25:54 +0100
Message-ID: <20060608122554.GA9865@infradead.org>
References: <1149636947.25278.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17584 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751313AbWFHMZ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 08:25:56 -0400
Content-Disposition: inline
In-Reply-To: <1149636947.25278.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2006 at 04:35:46PM -0700, Alexis Bruemmer wrote:
> There are a few issues that remain, but before I address them I would
> like some clarification:
> 
> -all the code should be renamed to libsas to make sure this is helpers
>  for a host-based sas implementation, including the config option
> 
> 	Does this mean that you would like to see all the files										under
> the drivers/scsi/sas/ dir compressed into one drivers/scsi/libsas.c file
> or that the files should just be moved to driver/scsi and start with
> libsas_*.c 

I think it's enough code to warrant more than a source file.  Following
the libata example you could call them drivers/scsi/libsas-*.c or give it
a subdirectory.  It doesn't matter too much how to do it exactly.

> -sas_frames*.h need to be changed to avoid on the wite bitfields which
>    are completely non-portable.  That'll cause quite a bit of churn all
>    over the codebase unfortuantely.  some of those headers should be merged
>    with the current scsi_transport_sas.h, e.g. the latter should lose various
>    constants that are in sas.h
> 
> 	why?  There are bit fields in many places under drivers/scsi.  There
> shouldn't be any issues between 32 and 64 bit with the u8 definition and
> we haven't seen any issues across the two architectures we have tested
> here (ppc64 and x86_64).  I just don't see the portability issue in this
> case, so please elaborate :).

There's not gurantee about ordering of bit fields.  Besides that they defeat
us doing proper sparse endian checking.  Please use proper mask and shift
operations.

> - drivers/scsi/sas/README needs to be updated to match reality and move
>    to Documentation/
> 	
> 	What exactly do we want to talk about in this readme file.  Describe
> scsi_transport_sas.c?  Explain the driver/scsi/sas/ dir?

I don't care too much.  At least remove bits that mention things not in
the tree or are flatout wrong for the current codebase.

> - expander_conf.c should go away from the kernel tree.
> 	
> 	Is there plan to implement this somewhere else?  If not should it stay
> for the moment.

Doug's smp_utils.  If you find anything in there that's missing please
send patches to Doug.

