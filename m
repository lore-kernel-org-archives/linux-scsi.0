From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Mon, 30 Aug 2004 22:51:51 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408302202420.4250@kai.makisara.local>
References: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org> <41300511.206030
  3@torque.net> <Pine.LNX.4.58.0408280922540.7958@kai.makisara.local>
 <3CC78EDC-FAAA-11D8-85F1-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:48454 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268882AbUH3Tv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 15:51:57 -0400
In-Reply-To: <3CC78EDC-FAAA-11D8-85F1-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Mon, 30 Aug 2004, Pat LaVarre wrote:

> Kai M:
> 
...
> > The severity of deferred errors depends on the device.
> > ...
> > Streaming tape drives have to
> > use largish internal buffers. This means that, for instance, write  
> > errors
> > often are deferred errors. The possibilities to report this error to  
> > the
> > user are limited but that is another thing (basically the driver can  
> > only
> > suggest to the user that the tape head is in an uknown position).
> 
> Thanks for the tape perspective, most of my time I've spent with  
> removable discs.
> 
> > The tapes seem to again be an exception from the mainstream.
> 
> I'm not sure I understand why?
> 
> Are we saying, for tape, a failure to write seen while flushing cache  
> inside the device is normal and not catastrophic?  Are we saying tape  
> buffers are commonly significantly larger than DVD-RAM buffers?  Help?
> 
The buffers in the faster drives may be quite big. For instance, I just 
looked at one LTO-2 drive specs and it had 64 MB buffer. However, this is 
not my point. If the error is not deferred, the driver can tell the user 
how much has been written but this does not help the user too much. When 
the error is signalled the user (using EIO), the user does not actually 
know if it is deferred or not. What you know is that the data up to the 
previous filemark is OK, beyond that the data is suspect unless the 
application knows the drive buffer size. To be able to easily read the 
archive, it is best to rewrite the archive on another tape. Bad tapes are 
not common but they do happen. That is why I say it is not a catastrophy 
to see a medium error of any type.

A good thing with tapes is that when the error is detected, the 
application is still living. If the last close succeeds, the data is on 
the tape. With disks it may be more complicated because there may be 
pending data from several sources and the application losing its data may 
not be around any more.

The severity of errors is largely a matter of opinion and depends on what 
you are trying to do. What we can probably agree on is that the scene 
looks a little different with different types of devices that SCSI can be  
used with. Besides disks and tapes, there are also other types (changers, 
backplanes, ...) that may need different type of processing. The high
level driver has to be able to make the decisions if it needs to. (Some 
decisions the upper level probably does not need to do like retrying and 
ABORTED command that has not done anything to the medium.)

Kai

