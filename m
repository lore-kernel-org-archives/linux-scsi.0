From: Doug Ledford <dledford@redhat.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 3 Oct 2002 12:41:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021003164131.GF30853@redhat.com>
References: <dledford@redhat.com> <20021002002854.GF28265@redhat.com> <200210031425.g93EPiF02579@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210031425.g93EPiF02579@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 03, 2002 at 10:25:44AM -0400, James Bottomley wrote:
> dledford@redhat.com said:
> > What I need, people to test this with the old aic7xxx driver (which
> > implements the new code paths, no other drivers do) and people to test
> >  with other drivers to make sure it doesn't break them.  If I don't
> > hear  complaints then I'll move on to my next change which is far more
> > intrusive  on drivers in general. 
> 
> After fixing up the 53c700 to use the new adjust queue depths stuff, I can 
> confirm it's working fine for me here (well, actually I fixed the generic scsi 
> tcq code to use it, but only the 53c700 driver uses this).

Excellent ;-)  However, a couple questions.

1)  When/How is the lldd notified that tagged queueing has been enabled 
and the depth to which it is enabled?

2)  How does the lldd tell the midlayer (and hence the block layer) to 
reduce the queue depth?


Content-Description: tmp.diff
> ===== scsi.h 1.22 vs edited =====
> --- 1.22/drivers/scsi/scsi.h	Thu Aug 15 16:01:28 2002
> +++ edited/scsi.h	Thu Aug 15 16:18:53 2002
> @@ -882,7 +882,7 @@
>  
>          if(SDpnt->tagged_supported && !blk_queue_tagged(q)) {
>                  blk_queue_init_tags(q, depth);
> -                SDpnt->tagged_queue = 1;
> +		scsi_adjust_queue_depth(SDpnt, 1, depth);
>          }
>  }
>  
> @@ -892,7 +892,7 @@
>   **/
>  static inline void scsi_deactivate_tcq(Scsi_Device *SDpnt) {
>          blk_queue_free_tags(&SDpnt->request_queue);
> -        SDpnt->tagged_queue = 0;
> +	scsi_adjust_queue_depth(SDpnt, 0, 2);
>  }
>  #define MSG_SIMPLE_TAG	0x20
>  #define MSG_HEAD_TAG	0x21


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
