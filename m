From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Mon, 21 Oct 2002 12:16:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021161617.GA28914@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021021072801.GA3197@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021021072801.GA3197@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Mon, Oct 21, 2002 at 12:28:01AM -0700, Mike Anderson wrote:
> Doug Ledford [dledford@redhat.com] wrote:
> >     ha = IPS_HA(SDptr->host);
> > -   min = ha->max_cmds / 4;
> > -   if (min < 8)
> > -      min = ha->max_cmds - 1;
> > -   scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
> > +   if (SDptr->tagged_supported) {
> > +      min = ha->max_cmds / 2;
> > +      if (min <= 16)
> > +         min = ha->max_cmds - 1;
> > +      scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
> > +   }
> >     return 0;
> >  }
> >  
> 
> Doug,
> 	Sorry I did not get on to checking your version of this patch
> 	sooner.
> 
> I did check 2.5.44 which includes your patched version of ips.c. I am
> seeing only a queue depth of 1.
> 
> The reason is that the SERVERAID disks are virutal and the inquiry data
> they send back does is generated in the driver. The inq data does not
> have the CmdQue bit set which results in tagged_supported not being set.

Yeah, David Jeffery of Adaptec (the current maintainer of the ips driver) 
already sent a fix for this to Linus, so it should be in 2.5.44 I think.  
If not, let me know and I'll add it to my queue I'm preparing for when 
Linus comes back.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
