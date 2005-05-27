From: Jeff Garzik <jgarzik@pobox.com>
Subject: libata, SCSI and storage drivers
Date: Thu, 26 May 2005 22:49:45 -0400
Message-ID: <42968AC9.60705@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <20050524071320.GW9855@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050524071320.GW9855@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Tue, May 24 2005, Jeff Garzik wrote:
> 
>>Jens Axboe wrote:
>>
>>>On Tue, May 24 2005, Jeff Garzik wrote:
>>>
>>>>I can describe how this will look when libata is divorced from SCSI, if 
>>>>you would like, too...
>>>
>>>I was beginning to dispair you had given up that plan...
>>
>>hehe, nope.  I promised Linus, and I plan to keep my promise :)
> 
> 
> You promised me, too :)
> 
> 
>>I know how to do it.  Internally things have been kept as separate as 
>>possible from the SCSI layer.
> 
> 
> We should start a list of items that could potentially be moved to the
> block layer that libata currently uses.


Here are the two broad categories of things that immediately come to mind.


1.  Hardware in pre-production right now can do SAS or SATA on the same 
card.  So, real soon, a driver will need to do both SCSI and ATA 
depending on runtime conditions.

The SCSI transport class is a very nice way to connect low-level drivers 
and the class drivers (disk/cdrom/tape/...).  It works well with the 
device model, and is modular in just the right location.

I would like to develop ATA transport class(es).  In order to work well 
with SATA/SAS hardware, there will need to be at least one.

And as I hoped you have guessed.....  the ATA transport class should be 
a child of the block layer, not the SCSI layer.


2.  driver API.  Linux SCSI layer provides several services which are 
generalized to any "packet transport":
* mapping of devices to protocol buses (domain topology, etc.)
* command queueing
* error handling

For hardware like ATA or I2O, this "send-command" type of API is the 
most natural way to implement a low-level driver, particularly if the 
core code provides all the necessary queueing/mapping/EH services as well.

This infrastructure is -not- specific to SCSI at all.  And it is this 
infrastructure that allowed me to bring up libata so rapidly.

	Jeff


