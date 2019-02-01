From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Recent removal of bsg read/write support
Date: Fri, 1 Feb 2019 12:44:42 -0500
Message-ID: <b60e424c-9dd0-beb8-cbf5-0b4daa83c105@interlog.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
 <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
 <CA+55aFyLC8PhjZ+iV7MucSZ1aGKMT=S9=EkEAQ6T1=ZRqD-xLA@mail.gmail.com>
 <CAOuWhkbNuesaVYar6ML-qFw7RAfkPsaOYUXT4Ypfiu5=Nt1kWw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOuWhkbNuesaVYar6ML-qFw7RAfkPsaOYUXT4Ypfiu5=Nt1kWw@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Dror Levin <drorl@infinidat.com>, torvalds@linux-foundation.org
Cc: richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Updated reply, see below.

On 2018-09-03 4:34 a.m., Dror Levin wrote:
> On Sun, Sep 2, 2018 at 8:55 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Sun, Sep 2, 2018 at 4:44 AM Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>>
>>> CC'ing relevant people. Otherwise your mail might get lost.
>>
>> Indeed.
> 
> Sorry for that.
> 
>>> On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
>>>>
>>>> We have an internal tool that uses the bsg read/write interface to
>>>> issue SCSI commands as part of a test suite for a storage device.
>>>>
>>>> After recently reading on LWN that this interface is to be removed we
>>>> tried porting our code to use sg instead. However, that raises new
>>>> issues - mainly getting ENOMEM over iSCSI for unknown reasons.
>>
>> Is there any chance that you can make more data available?
> 
> Sure, I can try.
> 
> We use writev() to send up to SG_MAX_QUEUE tasks at a time. Occasionally not
> all tasks are written at which point we wait for tasks to return before
> sending more, but then writev() fails with ENOMEM and we see this in the syslog:
> 
> Sep  1 20:58:14 gdc-qa-io-017 kernel: sd 441:0:0:5: [sg73]
> sg_common_write: start_req err=-12
> 
> Failing tasks are reads of 128KiB.

This is the block layer running out of resources. The sg driver is a
relatively thin shim and when it gets a "no can do" from the layers
below it, the driver has little option than to return said errno.

>> I'd rather fix the sg interface (which while also broken garbage, we
>> can't get rid of) than re-surrect the bsg interface.
>>
>> That said, the removed bsg code looks a hell of a lot prettier than
>> the nasty sg interface code does, although it also lacks ansolutely
>> _any_ kind of security checking.
> 
> For us the bsg interface also has several advantages over sg:
> 1. The device name is its HCTL which is nicer than an arbitrary integer.

Not much the sg driver can do about that. The minor number the sg driver
uses and HCT are all arbitrary integers (with the L coming from the
storage device), but I agree the HCTL is more widely used. The
ioctl(<sg_fd>, SG_GET_SCSI_ID) fills a structure which includes HCTL. In
my sg v4 driver rewrite the L (LUN) has been tweaked to additionally
send back the 8 byte T10 LUN representation.

The lsscsi utility will show the relationship between HCTL and sg driver
device name with 'lsscsi -g'. It uses sysfs datamining.

> 2. write() supports writing more than one sg_io_v4 struct so we don't have
>     to resort to writev().

In my sg v4 rewrite the sg_io_v4 interface can only be sent through
ioctl(SG_IO) [for sync usage] and ioctl(SG_IOSUBMIT) [for async usage].
So it can't be sent through write(2). SG_IOSUBMIT is new and uses the
_IOWR macro which encodes the expected length into the SG_IOSUBMIT value
and that is the size of sg_io_v4. So you can't send an arbitrary number of
sg_io_v4 objects through that ioctl directly. If need be, that can be
cured with another level of indirection (e.g. with a new flag the data-out
can be interpreted as an array sg_io_v4 objects).

> 3. Queue size is the device's queue depth and not SG_MAX_QUEUE which is 16.

That limit is gone in the sg v4 driver rewrite.

>>>> Because of this we would like to continue using the bsg interface,
>>>> even if some changes are required to meet security concerns.
>>
>> I wonder if we could at least try to unify the bsg/sg code - possibly
>> by making sg use the prettier bsg code (but definitely have to add all
>> the security measures).
>>
>> And dammit, the SCSI people need to get their heads out of their
>> arses. This whole "stream random commands over read/write" needs to go
>> the f*ck away.
>>
>> Could we perhaps extend the SG_IO interace to have an async mode?
>> Instead of "read/write", have "SG_IOSUBMIT" and "SG_IORECEIVE" and
>> have the SG_IO ioctl just be a shorthand of "both".

Done.

> Just my two cents - having an interface other than read/write won't allow
> users to treat this fd as a regular file with epoll() and read(). This is
> a major bonus for this interface - an sg/bsg device can be used just like
> a socket or pipe in any reactor (we use boost asio for example).

Well poll() certainly works (see sg3_utils beta rev 809 testing/sgs_dd.c and
testing/sgh_dd.c) and I can't see why epoll() won't work. These calls work
against the file descriptor and the sg driver keeps the same context around
sg device file descriptors as it has always done. [And that is the major
design flaw in the bsg driver: it doesn't keep proper file descriptor context.]

It is the security folks who don't like the sg inspired (there in lk 1.0.0
from 1992) write(2)/read(2) asynchronous interface. Also, ideally we need
two streams: one for metadata (e.g. commands and responses (status and sense
data)) and another for user data. Protection information could be a third
stream, between the other two. Jamming that all into one stream is a bit ugly.

References:
   sg v3 driver rewrite, description and downloads:
      http://sg.danny.cz/sg/sg_v40.html
   sg3_utils version 1.45 beta, rev 809, link at the top of this page:
      http://sg.danny.cz/sg

Doug Gilbert
