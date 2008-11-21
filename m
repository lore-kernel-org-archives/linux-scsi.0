From: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Subject: Re: Enterprise workload testing for storage and filesystems
Date: Fri, 21 Nov 2008 11:42:41 -0500
Message-ID: <4926E501.9010802@fnis.com>
References: <1226962063.3403.13.camel@localhost.localdomain> <x49y6zegjum.fsf@segfault.boston.devel.redhat.com> <4926DAFC.5070006@fnis.com> <4926DF63.1030107@hp.com>
Reply-To: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4926DF63.1030107@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/21/2008 11:18 AM, Alan D. Brunelle wrote:
> K.S. Bhaskar wrote:

[KSB2] <...snip...>

> Thanks for additional feedback Bhaskar - I've been playing with this
> on-and-off the last couple of days trying to stress one testbed (16 way
> AMD, 128GB RAM, two P800 Smart Arrays (48 disks total put into a single
> LVM2/DM volume)). I've been able to get the I/O subsystem 100% utilized,
> but in so doing really didn't stress the system (something like 80-90%
> idle).
> 
> In order to stress the whole system, it sounds like it _may_ be better
> to use 48 separate file systems on 48 separate platters (each with its
> own DB)? Or are there other knobs to play with to get more of the system
> involved besides the I/O? Is it a good idea to separate the journals
> from the DB (separate FS/platter)?

[KSB2] The intent of io_thrash is to stress the IO subsystem.  So, I am 
not at all surprised that CPU and memory were not stressed.

With the 48 platters on your system, perhaps consider creating 4 logical 
volumes each striped across 12 physical volumes.  Try 8 databases, with 
each logical volume having two databases and journal files for two 
databases that reside on different file systems.

In the real world, yes one would separate each journal file from its 
database file, at least putting them on separate platters, because if 
the journal platters, disk controller, or file system croak, you still 
have the database, and if the database underpinnings die, the database 
is recoverable from a backup and the journal file.  One aims to get 
maximum separation from the database and its journal file.

If you want to simulate an application that produces a more balanced 
load, perhaps you can set %ioUnderLock to 0 and modify io_thrash to do 
some compute intensive task (like fill a large block of memory with 
pseudo random numbers) before each IO operation.  You would probably 
want to increase the number of processes so that the IO subsystem 
continues to be driven hard.

Regards
-- Bhaskar

_____________

The information contained in this message is proprietary and/or confidential. If you are not the 
intended recipient, please: (i) delete the message and all copies; (ii) do not disclose, 
distribute or use the message in any manner; and (iii) notify the sender immediately. In addition, 
please be aware that any message addressed to our domain is subject to archiving and review by 
persons other than the intended recipient. Thank you.
_____________
