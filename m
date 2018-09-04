From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Recent removal of bsg read/write support
Date: Tue, 4 Sep 2018 06:10:30 +0200
Message-ID: <c3674988-25fe-0a4d-4ce0-ec8aa9a241b4@interlog.com>
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

On 2018-09-03 10:34 AM, Dror Levin wrote:
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
> 
>> I'd rather fix the sg interface (which while also broken garbage, we
>> can't get rid of) than re-surrect the bsg interface.
>>
>> That said, the removed bsg code looks a hell of a lot prettier than
>> the nasty sg interface code does, although it also lacks ansolutely
>> _any_ kind of security checking.
> 
> For us the bsg interface also has several advantages over sg:
> 1. The device name is its HCTL which is nicer than an arbitrary integer.
> 2. write() supports writing more than one sg_io_v4 struct so we don't have
>     to resort to writev().
> 3. Queue size is the device's queue depth and not SG_MAX_QUEUE which is 16.
> 
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
> 
> Just my two cents - having an interface other than read/write won't allow
> users to treat this fd as a regular file with epoll() and read(). This is
> a major bonus for this interface - an sg/bsg device can be used just like
> a socket or pipe in any reactor (we use boost asio for example).

The advantage of having two ioctls is that they can both pass (meta-)data
bidirectionally. That is hard to do with standard read() and write() calls.
The command tag is the piece if meta-data that goes against the flow:
returned from SG_IOSUBMIT, optionally given to SG_IORECEIVE (which might have
a 'cancel command' flag).

The sg v1, v2 and v3 interfaces could keep their write()/read() interfaces
for backward compatibility (to Linux 1.0.0, March 1994 for sg v1). New, clean
submit and receive paths could be added to the sg driver for the v3 and
v4 twin ioctl interface. Previously the sg v4 interface was only supported
by the bsg driver. One advantage of sg v4 over v3 is support for bidi
commands. Not sure if epoll/poll works with an ioctl, if not we could add a
"dummy" read() call that notionally returned SCSI status. The SG_IORECEIVE
ioctl would still be needed to "clean up" the command, and optionally
transfer the data-in buffer.

Tony Battersby has also requested twin ioctls saying that it is extremely
tedious ploughing through logs full of SG_IO calls and that clearly
separating submits from receives would make things somewhat better.

Doug Gilbert
