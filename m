From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: is there a clean way to disable a scsi timer
Date: Mon, 30 Sep 2002 11:31:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E7012B706E@xcm.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'Heinz, Michael'" <mheinz@infiniconsys.com>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, linux-scsi@vger.kernel.org

Michael,

I have a fibre channel driver, my issues included:

1) A device could disappear for > SD_TIMEOUT, then come back.
2) A fibre channel fabric has some input into what the timeout for a command
should be. Therefore my driver handles timing out all commands.

Back when the driver was developed, I noticed if SD_TIMEOUT did expire, the
system would hang / not recover properly.
Jon


-----Original Message-----
From: Heinz, Michael [mailto:mheinz@infiniconsys.com]
Sent: Saturday, September 28, 2002 8:48 AM
To: Infante, Jon; Jeremy Higdon; linux-scsi@vger.kernel.org
Subject: RE: is there a clean way to disable a scsi timer


Jon, Jeremy:

What is the intent in having the device driver do timeout handling? I ask
because I've run into some issues with the midlayer timeouts not always
working correctly and I've been thinking about implementing timeout
processing in my driver. Was that the issue you had or was it something
else?

--
Michael Heinz
Staff Software Engineer
Infinicon Systems, Inc.
http://www.infiniconsys.com 

> -----Original Message-----
> From: Infante, Jon [mailto:Jon.Infante@Emulex.Com]
> Sent: Friday, September 27, 2002 11:27 AM
> To: 'Jeremy Higdon'; linux-scsi@vger.kernel.org
> Subject: RE: is there a clean way to disable a scsi timer
> 
> 
> I do my own timeout handling as well. My queuecommand does
> scsi_delete_timer() just as you suggested. However, just to 
> be safe, I also
> do a scsi_add_timer() in my iodone routine just before I call
> cmnd->scsi_done(cmnd) to put things back the way they were.
> 
> Jon Infante
> 
> 
> -----Original Message-----
> From: Jeremy Higdon [mailto:jeremy@classic.engr.sgi.com]
> Sent: Friday, September 27, 2002 1:30 AM
> To: linux-scsi@vger.kernel.org
> Subject: Re: is there a clean way to disable a scsi timer
> 
> 
> Misremembered the name -- sorry.
> 
> s/scsi_disable_timer/scsi_delete_timer/
> 
> On Sep 27,  1:24am, Jeremy Higdon wrote:
> > 
> > I have a host driver that does its own timeout and error 
> handling.  Is
> there
> > a clean way to disable the midlayer timeout handling?  It 
> appears that I
> > can just call scsi_disable_timer() from the queuecommand 
> function, but
> > I'd prefer something less nasty.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
