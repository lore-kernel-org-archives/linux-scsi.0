From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: is there a clean way to disable a scsi timer
Date: Fri, 27 Sep 2002 08:26:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E7012B706D@xcm.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Jeremy Higdon' <jeremy@classic.engr.sgi.com>, linux-scsi@vger.kernel.org

I do my own timeout handling as well. My queuecommand does
scsi_delete_timer() just as you suggested. However, just to be safe, I also
do a scsi_add_timer() in my iodone routine just before I call
cmnd->scsi_done(cmnd) to put things back the way they were.

Jon Infante


-----Original Message-----
From: Jeremy Higdon [mailto:jeremy@classic.engr.sgi.com]
Sent: Friday, September 27, 2002 1:30 AM
To: linux-scsi@vger.kernel.org
Subject: Re: is there a clean way to disable a scsi timer


Misremembered the name -- sorry.

s/scsi_disable_timer/scsi_delete_timer/

On Sep 27,  1:24am, Jeremy Higdon wrote:
> 
> I have a host driver that does its own timeout and error handling.  Is
there
> a clean way to disable the midlayer timeout handling?  It appears that I
> can just call scsi_disable_timer() from the queuecommand function, but
> I'd prefer something less nasty.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
