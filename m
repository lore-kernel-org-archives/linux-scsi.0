From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 12:56:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002165606.GF30234@redhat.com>
References: <A5974D8E5F98D511BB910002A50A66470580D251@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D251@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 09:40:06AM -0700, Cress, Andrew R wrote:
> James,
> 
> A user-space hotplug event can't be guaranteed to have enough information in
> all cases.
> Possible cases:
>   1) Administrator "knows" and manually issues a hot-plug command. 
>   2) A daemon detects a SAF-TE or SES event by slot number.  
>      Not sure if we can really determine what we need from just a slot
> number?
>   3) Other external disk enclosure (JBOD) that doesn't expose a 
>      SAF-TE or SES interface.
>      This case is out in the cold without the kernel-level rescan.
> 
> I'm disregarding case (1), since my target customer environment won't
> tolerate the manual step.

You can forget 3 as well.  It's simply not reasonable to tie up a busy bus 
with very long selection timeouts to "poll scan" a bus for new insertions.  
Not gonna happen.  If the JBOD doesn't expose a reasonable interface, then 
hot plug with it isn't supported in linux.  If it exposes something other 
than SAF-TE or SES then the protocol it does support needs to be added to 
the daemon in #2 in order for it to be supported.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
