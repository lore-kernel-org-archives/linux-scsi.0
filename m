From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: is there a clean way to disable a scsi timer
Date: Sat, 28 Sep 2002 11:47:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4DAF@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, linux-scsi@vger.kernel.org

Jon, Jeremy:

What is the intent in having the device driver do timeout handling? I ask because I've run into some issues with the midlayer timeouts not always working correctly and I've been thinking about implementing timeout processing in my driver. Was that the issue you had or was it something else?

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
