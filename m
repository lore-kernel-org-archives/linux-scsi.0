From: Christoph Hellwig <hch@infradead.org>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 18:46:23 +0100
Message-ID: <20060428174623.GA17119@infradead.org>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29877 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751666AbWD1RqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:46:25 -0400
Content-Disposition: inline
In-Reply-To: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>


There's also various issues around the sas code which aic94xx needs:

 - all the code should be renamed to libsas to make sure this is helpers
   for a host-based sas implementation, including the config option
 - the sas* headers should go directly to include/scsi/
 - sas_frames*.h need to be changed to avoid on the wite bitfields which
   are completely non-portable.  That'll cause quite a bit of churn all
   over the codebase unfortuantely.  some of those headers should be merged
   with the current scsi_transport_sas.h, e.g. the latter should lose various
   constants that are in sas.h
 - list_for_each_entry_reverse_safe from sas_discover.h should go to
   linux/list.h instead
 - struct domain_device is totally misnamed
 - sas_init_dev shouldn't be inline
 - in the sas headers generic on the wire stuff should be separated from
   libsas internals, e.g. most of sas_disocvery.h should become
   libsas_discovery.h or merged into libsas.h, but the smp defintions should
   go into a sas_smp.h or merged with sas_frames.h (why not sas_frame.h btw?)
   similar for sas_task.h
   generally I'd say all the headers currently in include/scsi/sas/ should
   probably be merged into just two:

    * include/scsi/sas.h for on the wire SAS defintions, best annotate with
      reference to what section in the standard they correspond to
    * include/scsi/libsas.h for all structures and prototypes of the host
      based sas code
 - drivers/scsi/sas/README needs to be updated to match reality and move
   to Documentation/
 - expander_conf.c should go away from the kernel tree.
 - sas_common.c seems to only contain duplicate code
   from scsi_transport_sas.c
 - all these //depot SCM comments should go
 - the priority queue implementation the long comment in sas_event.c
   talks about doesn't exist anymore, so kill it.  Also there's not a lot
   left in that file, and what's left doesn't make a lot of sense, as
   the one-element local sas_ha_event_fns array.  I'd suggest merging it
   into another
 - libsas should implement all methods in the sas_function_template.  They're
   supporting functionality that's in the SAS spec and are expected by
   userland to be present.  There should be no driver code involvded here,
   just libsas.  I'd move the actual template to the driver, though so
   a driver could override it, similar to what we do with the host template.
 - Various functions marked inline that shouldn't.  there's rarely a use
   for inlines except for ver ysmall functions
 - why don't sas_queue_event and as_begin_event use bitops?


this was just a quick 15 minute skip through the driver, once those are
addresses I'll do a real review.
