From: "David Horton" <dhorton@megsinet.net>
Subject: Re: Problems with SCSI device
Date: Wed, 26 Mar 2003 14:09:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303261926.h2QJQEHH085577@mail5.mx.voyager.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: gmartin@filmayer.es
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Gustavo,

I'm not sure about your situation, but with my tape drive I used the
example stinit.def file shown in the stinit man page and edited
Manufacturer and Model to match my device and that was about it.  (I
also had to take out the stuff about compression since I have an older
model that does not support it in hardware, but I doubt you'll have that
problem with the DLT.)  So my stinit.def basically looks like this:

# The XY dat
manufacturer=HP model = "HP35480A" {
scsi2logical=1 # Common definitions for all modes
can-bsr can-partitions auto-lock
# Definition of modes
mode1 blocksize=0 compression=0
mode2 blocksize = 1024 compression=0 }

With this setup I can access everything using /dev/st0.  I think the
only difference with /dev/nst0 is that it does not rewind.

My best advice at this point would be to try finding someone with the
exact same make and model of tape drive and look at their stinit.def. 
You may even be able to contact HP tech support about this as they are
getting very Linux-friendly these days and also there may be
similarities with using the tape drive on HP-UX.  Otherwise you might
try attaching the drive to a Windows box and using HP tape tools to do
some diagnostics, check for firmware updates, etc.

I hope that is at least somewhat useful.  I just can't think of what
else it could be at this time.

Dave




> Hi again,
> 
> I made some changes on my .def file. The manufacturer, model, etc seems 
> to be correct. I changed the modes and now I recive errno 5, can't open 
> tape device /dev/nst0.
> 
> I'm getting crazy with this stuff. Any other idea?
> 
> Cheers,
> GUSTAVO
> 
> David Horton wrote:
> 
> >>  Hi again,
> >>
> >>thanks Dave. No the conection with the device doesn't hang. But I still 
> >>have problems. When I try to initialize the device I get the following 
> >>error:
> >>
> >>    The SCSI INQUIRY for device '/dev/nst0' failed (power off?)
> >>    Definition for '/dev/st0' failed.
> >>
> >>What it can be this time? I have created and configured the
stinit.def   
> >>file (not .conf file 'cause in the man page for stinit is the file that 
> >>sugests)  as you told me. I don't know if it is well configured because 
> >>I don't have the specifications of my drive.
> >>
> >>Does any one of you have any idea of where the problem can be?
> >>
> >>Thanks,
> >>GUSTAVO
> >>    
> >>
> >
> >You are right, it is stinit.def.  Anyway, when I set up my DAT drive I
> >used a combination of info from /proc/scsi and HP's website.
> >
> >You can put in your product number at hp.com's support & driver's
> >section and probably dig up a .PDF manual.  The HP Tape Tools is also
> >helpful, but I think it only runs on Windows.
> >
> >As for /proc/scsi, that's where you can find parameters that you will
> >need for stinit.def such as 'manufacturer' and 'model'.  Wrong info here
> >could be causing some trouble.  For example, even though I have a
> >product labeled "HP SureStore 5000" I have to put model "HP35480A" in
> >stinit.def, because that is the generic name shown in /proc/scsi. 
> >Otherwise stinit never initializes the tape drive because it can't
find it.
> >
> >-Dave
> >
> >
> >
> >
> >  
> >
> 
> 
> 



