From: Jeff Garzik <jeff@garzik.org>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 14:46:35 -0400
Message-ID: <4713B58B.9050905@garzik.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933299AbXJOSuc@vger.kernel.org>
In-Reply-To: <20071015172513.GA5738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

Greg KH wrote:
> On Mon, Oct 15, 2007 at 03:36:15AM -0500, Rob Landley wrote:
>> The point I was trying to make is that it seems to me like it would be 
>> possible to keep the namespace separate here, and thus reduce the enumeration 
>> problems to the point where common cases (like my laptop) aren't impacted by 
>> them during early boot.
> 
> Proposals on how to do this would be gladly reviewed.

Agreed.


> But again, please remember that these USB devices are really SCSI
> devices.  Same for SATA devices.  There is a reason they are using the
> SCSI layer, and it isn't just because the developers felt like it :)

/somewhat/ true I'm afraid:  libata uses the SCSI layer for ATAPI 
devices because they are essentially bridges to SCSI devices.  It uses 
the SCSI layer for ATA devices because the SCSI layer provided a huge 
amount of infrastructure that would need to have been otherwise 
duplicated, /then/ massaged into coordinating between <jgarzik's ATA 
layer> and <SCSI layer> when dealing with ATAPI.

There is also a detail that was of /huge/ value when introducing a new 
device class:  distro installers automatically work, if you use SCSI. 
If you use a new block device type, that behaves differently from other 
types and is on a different major, you have to poke the distros into 
action or do it yourself.

IOW, it was the high Just Works(tm) value of the SCSI layer when it came 
to ATA (not ATAPI) devices.

For the future, ATA will eventually be more independent (though the SCSI 
simulator will be available as an option, for compat), but the value is 
big enough to put that task on the back-burner.

	Jeff
