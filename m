From: Steven Dake <sdake@mvista.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 12:40:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB84C9A.2030702@mvista.com>
References: <200210241425.g9OEPCP02249@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James,
Responses below:

James Bottomley wrote:

>I looked at this briefly last night.  The patch seems to come in three pieces:
>
>1) Add list locking to manipulations of the host device list
>2) Add a new filesystem type for exposing SCSI information
>3) add a lot more methods for adding and removing SCSI devices.
>
>1) seems to be something we should have
>
>I'm dubious about 2).  Could you explain why you need a new fs interface as 
>opposed to using driverfs?
>  
>
The main reason I use a new fs interface is this was a port of a 2.4 
driver (and as you know
2.4 doesn't have driverfs:)  Since my customers that are using this 
software are currently
on 2.4, that is my main concern.  I had wanted to see this code reach 
the 2.5 mainline so I
could maintain it in the main kernel instead of as seperate patches for 
each kernel rev.

I plan to produce a now patch that dumps the filesystem interface and 
replaces it with driverfs
files in /sys/bus/scsi.  These things take time, but I hope to be 
finished by October 25th.

>3) duplicates existing functionality and the new bits it does add could be 
>done using a hotplug framework.
>  
>
>For all the removes, if you exposed the information you're looking for (FC 
>wwn) in driverfs, you could use the existing remove interface.
>  
>
The current remove interface is unmaintained, doesn't contain locking, 
and requires
laborious string processing resulting in slow results.  Further there is 
no usage
information (which means the usage must come by looking at 
drivers/scsi/scsi.c
which is beyond most typical users).

Another problem is performance:

Imagine scanning each disk in driverfs looking at its WWN attribute (if 
it has one)
until a match is found.  Assume there are 16 FC devices.  That is 
several hundred syscalls
just to complete one hotswap operation.

The method in the patch takes only two syscalls (open and write) to 
complete a hotswap
operation, independent of the number of FibreChannel devices.  Of 
course, the scanning
still occurs, but through a very fast function call interface (1 call 
per adaptor) as opposed to a slower
syscall interface.

This requires the adaptor to maintain a mapping of WWNs to SCSI IDs, 
however, this is already
required by most FibreChannel firmware I've seen (and hence is available 
in the driver database
already).

>For the adds, all of this would be finessed by having the FC event that 
>detected a new device on the fibre trigger a hotplug event.  You could then 
>have the hotplug trigger the existing add device interface to make the 
>component configure automatically (hotplug on fibre events like this has been 
>a hot item for a while, so having a general interface would be most welcome).
>  
>
Hotplugs on FibreChannel don't trigger "events".  What they can do is 
LIP (loop initialization
procedure) if the device has been configured in it's SCSI code pages to 
do such a thing.  Since this
is device specific I'd hate to rely on it for hotswap.

I do like your idea, though, and if I have a chance this year, I'll 
implement automatic hotplug on new
devices found during a LIP.

>If you must delay configuration and do it by wwn later, you could capture the 
>wwns to host,channel,id,lun mappings in a table on the hotplug event (and not 
>configure the device) and use the information for later configuration using 
>the existing interfaces.
>  
>
I think this would be too slow.  10 msec for my entire hotswap is 
available.  If you calculate 2msec for the actual hotswap disk 
operation, that leaves 8 msec for the rest of the mess.  Scanning 
through tables or scanning tens or hundreds of files through hundreds of 
syscalls may betoo slow.

>James
>
>  
>
Thanks
-steve

>
>
>  
>

