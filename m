From: Doug Ledford <dledford@redhat.com>
Subject: Re: Is sector no. related to partitions in scsi drivers?
Date: Wed, 28 Aug 2002 21:44:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828214459.B31167@redhat.com>
References: <Pine.SOL.4.33.0208282057580.23561-100000@frack.cse.psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.SOL.4.33.0208282057580.23561-100000@frack.cse.psu.edu>; from jzhang@cse.psu.edu on Wed, Aug 28, 2002 at 09:06:38PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jianyong Zhang <jzhang@cse.psu.edu>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2002 at 09:06:38PM -0400, Jianyong Zhang wrote:
> 
>   I'm wonder where this request's sector number will be converted to one
> related to the whole disk. Is it done by the firmware of controller?

No.  The aic7xxx driver couldn't care less what the sector number in the 
request item is.  The sd.c code handles converting request struct items to 
physical sectors on the disk and then encodes the physical sector number 
directly into the actual scsi command that it builds.  The scsi command is 
then sent to the device by the aic7xxx driver and the aic7xxx driver never 
even bothers to look and see what sector the command is going to (it 
doesn't need to).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
