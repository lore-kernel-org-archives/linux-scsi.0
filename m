From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Recent removal of bsg read/write support
Date: Fri, 5 Oct 2018 19:27:47 -0400
Message-ID: <c443315d-eef2-31c9-754a-f24f0fcbb129@interlog.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
 <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
 <CA+55aFyLC8PhjZ+iV7MucSZ1aGKMT=S9=EkEAQ6T1=ZRqD-xLA@mail.gmail.com>
 <CAOuWhkbNuesaVYar6ML-qFw7RAfkPsaOYUXT4Ypfiu5=Nt1kWw@mail.gmail.com>
 <CAOuWhkYRtTqrnp1uyDWFqXFcTLhPbcqv8XzdV_jurJHstGQmuA@mail.gmail.com>
 <20181005223526.GF13613@kroah.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005223526.GF13613@kroah.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Dror Levin <drorl@infinidat.com>
Cc: torvalds@linux-foundation.org, Richard Weinberger <richard.weinberger@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On 2018-10-05 06:35 PM, Greg KH wrote:
> On Thu, Oct 04, 2018 at 09:58:37AM +0300, Dror Levin wrote:
>> CC'ing Greg.
>>
>> On Mon, Sep 3, 2018 at 11:34 AM Dror Levin <drorl@infinidat.com> wrote:
>>>
>>> On Sun, Sep 2, 2018 at 8:55 PM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> On Sun, Sep 2, 2018 at 4:44 AM Richard Weinberger
>>>> <richard.weinberger@gmail.com> wrote:
>>>>>
>>>>> CC'ing relevant people. Otherwise your mail might get lost.
>>>>
>>>> Indeed.
>>>
>>> Sorry for that.
>>>
>>>>> On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
>>>>>>
>>>>>> We have an internal tool that uses the bsg read/write interface to
>>>>>> issue SCSI commands as part of a test suite for a storage device.
>>>>>>
>>>>>> After recently reading on LWN that this interface is to be removed we
>>>>>> tried porting our code to use sg instead. However, that raises new
>>>>>> issues - mainly getting ENOMEM over iSCSI for unknown reasons.
>>>>
>>>> Is there any chance that you can make more data available?
>>>
>>> Sure, I can try.
>>>
>>> We use writev() to send up to SG_MAX_QUEUE tasks at a time. Occasionally not
>>> all tasks are written at which point we wait for tasks to return before
>>> sending more, but then writev() fails with ENOMEM and we see this in the syslog:
>>>
>>> Sep  1 20:58:14 gdc-qa-io-017 kernel: sd 441:0:0:5: [sg73]
>>> sg_common_write: start_req err=-12
>>>
>>> Failing tasks are reads of 128KiB.
>>>
>>>> I'd rather fix the sg interface (which while also broken garbage, we
>>>> can't get rid of) than re-surrect the bsg interface.
>>
>> Discussion seems to have died down but release of 4.19 is drawing near.
>>
>> Is there still any chance removal of bsg can be reconsidered? Maybe
>> postponed to the
>> next version to allow more time to adjust?
>>
>> I'm especially concerned about the possibility of this being
>> backported to stable kernels
>> which might leave us very little time to fix our code.
> 
> What is being backported to what stable kernels and why?

What has been removed from the bsg driver is the ability to use write()
to issue a SCSI command (and return before that command's response has
arrived) and to use read() to wait for the issued command to complete
and return that command's status and optionally its sense buffer.
Basically async SCSI command capability has been removed from the bsg
driver. The ioctl(SG_IO) for bsg device stays in place.

The reason is that the bsg driver has no active maintainer and its
rather serious design flaw: when a async SCSI command is issued (by
a write()) any process using any file descriptor (opened on that
device) may receive its response. Actually if you tried hard with bsg,
the synchronous SG_IO ioctl will also exhibit this behaviour.

> Is there sg patches?

Well I'm working on a patch set but it won't be ready for lk 4.19 .
Amongst other things it will remove the SG_MAX_QUEUE (16) request
limitation per file descriptor that Dror Levin is noting as a
hardship when re-porting their application from the bsg to sg driver.

Also Linus Torvalds doesn't like the write()/read() async interface used
by the sg driver and mimicked by the bsg driver. It has been in place in
the sg driver since 1992 (see lk 1.0) when it was the only user space
interface to the sg driver. Linus proposed replacing them by two new
ioctls: SG_IOSUBMIT and SG_IORECEIVE ***. I will work on a second patch
set for the sg driver to do exactly that (plus SG_IOABORT to abort a
request inflight).

> totally confused,

Hope this helps.

Doug Gilbert

*** See Linux Torvalds' post to this thread on 20180902
