From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Thu, 26 Jan 2006 11:11:01 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601261033010.23310@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com> <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9416 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964774AbWAZQL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 11:11:29 -0500
In-Reply-To: <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Chip Coldwell <coldwell@redhat.com>, Patrick Mansfield <patmans@us.ibm.com>, Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Wed, 25 Jan 2006, Kai Makisara wrote:

> On Tue, 24 Jan 2006, Chip Coldwell wrote:
>
>> On Tue, 24 Jan 2006, Patrick Mansfield wrote:
>>
>>> On Tue, Jan 24, 2006 at 12:52:36PM -0500, Chip Coldwell wrote:
>>>
>>>> Put
>>>>
>>>> options st try_direct_io=0
>>>
>>>>
>>>> in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
>>>> significantly (factor of >5) degrates read performance.  I don't know
>>>> about writes.
>>>
>>> For tape???
>>
>> Yes, for tape.  We verified this with a DAT72 DDS drive.
>>
> How did you do the tests? I would like to be able to reproduce this
> finding because there is something wrong somewhere. With any decent read()
> and write() byte counts (the 64 kB you mention in another message is
> decent) you should not find direct i/o slower than using the driver
> buffer. I have not seen anything like this with my DDS-4 drive (same
> speed as DAT72).

We used an Adaptec HBA connected to a DAT72 drive with nothing else on
the bus:

scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10-RH1

Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: SEAGATE  Model: DAT    DAT72-000 Rev: A060
   Type:   Sequential-Access                ANSI SCSI revision: 03

Target 6 Negotiation Settings
         User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
         Goal: 80.000MB/s transfers (40.000MHz, 16bit)
         Curr: 80.000MB/s transfers (40.000MHz, 16bit)
         Transmission Errors 0
         Channel A Target 6 Lun 0 Settings
                 Commands Queued 6
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0

This is using the Red Hat Enterprise Linux v4 kernel (2.6.9-27.ELsmp),
which differs from the latest 2.6, in particular in the st driver.  (I
could test the latest 2.6 and will do so if you think it could make a
difference).

I put some zeros on the tape

RHEL4# dd if=/dev/zero of=/dev/st0 bs=1k count=1000000

and test read performance, first without direct I/O

RHEL4# cat /sys/bus/scsi/drivers/st/try_direct_io 
0
RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
1000000+0 records in
1000000+0 records out

real    2m35.418s
user    0m0.639s
sys     0m5.804s

and then with direct I/O

RHEL4# cat /sys/bus/scsi/drivers/st/try_direct_io 
1
RHEL4# time dd if=/dev/nst0 of=/dev/null bs=1k
1000000+0 records in
1000000+0 records out

real    5m1.899s
user    0m1.224s
sys     0m16.456s

so with direct I/O, read performance is about a factor of two slower.
I believe this is because the driver doesn't do read-ahead when doing
direct I/O (after all, how could it?).

I did the test again with larger blocks (the buffer in the tape drive
is 32K), first without direct I/O

RHEL4# cat /sys/bus/scsi/drivers/st/try_direct_io 
0
RHEL4# time dd if=/dev/nst0 of=/dev/null bs=32k
31250+0 records in
31250+0 records out

real    2m30.688s
user    0m0.028s
sys     0m2.871s

then again with direct I/O

RHEL4# time dd if=/dev/nst0 of=/dev/null bs=32k
31250+0 records in
31250+0 records out

real    2m30.687s
user    0m0.063s
sys     0m0.677s

So in this case, performance is no worse or better with direct I/O
than without.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

