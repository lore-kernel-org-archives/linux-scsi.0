From: Doug Ledford <dledford@redhat.com>
Subject: Re: ide-scsi cmd_per_lun
Date: Tue, 9 Jul 2002 18:00:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020709180014.A12706@redhat.com>
References: <000701c2278e$2dc723a0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000701c2278e$2dc723a0$e0019d89@cybernetics.com>; from tonyb@cybernetics.com on Tue, Jul 09, 2002 at 05:18:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 09, 2002 at 05:18:31PM -0400, Tony Battersby wrote:
> 
> The problem boils down to the fact that ide-scsi relies on the mid-level
> (old eh) to do the auto-sense.  I was able to work around this problem by
> setting cmd_per_lun: 1 in ide-scsi.h (vanilla 2.4.17).  Doing this caused
> the request sense command to make it to the drive before any other command
> could sneak in and reset the sense data.  Can anyone tell me if this is a
> good solution?

It is the appropriate setting for any driver that doesn't automatically 
request sense itself on check condition status returns.  It does not solve 
the problem for tagged queue enabled devices though since they don't honor 
this field and will loose sense information, so in reality any driver that 
doesn't auto request sense data is broken to some extent.  The new eh code 
requires that drivers auto request sense, so this is actually likely to be 
really broken in 2.5 at the moment since the old eh code is now gone.

>  Looking at the 2.4.19-rc1 source, I see an additional field
> "can_queue: 10" in the template.  Should this be changed too?  I cannot use
> 2.4.19 for the moment, so I can't experiment with it.

No, this is only for the host wide queue, so if you had 5 ide-scsi devices 
that showed up, this limits the total number of commands sent to the 
ide-scsi driver to 10, which would be 2 each.  Obviously, this is 
different than what you are trying to set and is only limited by what the 
ide-scsi driver can actually handle in terms of outstanding commands at a 
time.

> 
> Thanks,
> Anthony J. Battersby
> Cybernetics
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
