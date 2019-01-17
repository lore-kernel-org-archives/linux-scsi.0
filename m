From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [ANNOUNCE] v4 sg driver: ready for testing
Date: Wed, 16 Jan 2019 19:56:23 -0500
Message-ID: <03036d97-7316-4a17-4ae5-15d02eb96607@interlog.com>
References: <bebb627c-0a7a-4669-87e4-ab5eb070062a@interlog.com>
 <0adbaea3-4110-708c-5ace-ad145f6daad7@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0adbaea3-4110-708c-5ace-ad145f6daad7@interlog.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org

There is an update to the SCSI Generic (sg) v4 driver adding synchronous
and asynchronous bidi command support. Plus lots of fixes and some minor
improvements. See:
     http://sg.danny.cz/sg/sg_v40.html

The kernel code is split in two in the tarball below, one targeting
lk 5.0 and the other targeting lk 4.20 and earlier ***. Each section
contains the 3 files that represent the sg v4 driver plus a meandering
17 part patchset. Those patchsets reflect the driver's rewrite rather
than a logical progression.
     http://sg.danny.cz/sg/p/sgv4_20190116.tgz

Plus there are updated testing utilities in sg3_utils-1.45 (beta,
revision 807) at the top of this page:
    http://sg.danny.cz/sg/index.html

Doug Gilbert


*** the reason for the split is the tree wide change to the access_ok()
     function.


On 2018-12-25 2:39 a.m., Douglas Gilbert wrote:
> There is an update to the sg v4 driver with some error fixes, SIGIO and
> RT signals work plus single READ, multiple WRITE sharing support. See:
>      http://sg.danny.cz/sg/sg_v40.html
> 
> with testing utilities in sg3_utils-1.45 (beta, revision 802) on the main
> page:
>      http://sg.danny.cz/sg/index.html
> 
> Doug Gilbert
> 
> 
> On 2018-12-18 6:41 p.m., Douglas Gilbert wrote:
>> After an underwhelming response to my intermediate level patchsets to
>> modernize the sg driver in October this year (see "[PATCH 0/8] sg: major
>> cleanup, remove max_queue limit" followed by v2 and v3 between 20181019
>> and 20181028), I decided to move ahead and add the functionality proposed
>> for the version 4 sg driver. That means accepting interface objects of
>> type 'struct sg_io_v4' (as found in include/uapi/linux/bsg) plus two new
>> ioctls: SG_IOSUBMIT and SG_IORECEIVE as proposed by Linus Torvalds to
>> replace the unloved write(2)/read(2) asynchronous interface ****. There
>> is a new feature called "sharing" explained in the web page (see below).
>>
>> Yes, there is a patchset available (14 part and growing) but even without
>> explanatory comments at the top of each patch, that patchset is 4 times
>> larger than the v4 sg driver (i.e. the finished product) and over 6
>> times larger than the original v3 sg driver! Part of the reason for
>> the patchset size is the multiple backtracks and rewrites associated
>> with a real development process. The cleanest patchset would have 3
>> parts:
>>    1) split the current include/scsi/sg.h into the end product headers:
>>       include/uapi/scsi/sg.h and include/scsi/sg.h
>>    2) delete drivers/scsi/sg.c
>>    3) add the v4 drivers/scsi/sg.c
>>
>> After part 2) you could build a kernel and I can guarantee that no-one
>> will be able to find any sg driver bugs but some users might get upset
>> (but not the Linux security folks).
>>
>> So there is a working v4 sg driver discussed here, with a download:
>>      http://sg.danny.cz/sg/sg_v40.html
>>
>> I will keep that page up to date while the driver is in this phase.
>> There is a sg3_utils beta of 1.45 (revision 799) package in the News
>> section at the top of the main page:
>>      http://sg.danny.cz/sg/index.html
>>
>> That sg3_utils beta package will use the v4 sg interface via sg devices
>> if the v4 driver is detected. There are also three test utilities in
>> the 'testing' directory designed to exercise the v4 extensions.
>>
>> The degree of backward compatibility with the v3 driver should be high
>> but there are limits to backward compatibility. As an example, it is
>> possible that there are user apps that depend on hitting the 16
>> outstanding command limit (per fd) in the v3 driver and go "wild"
>> when v4 removes that ceiling. If so, a "high_v3_compat" driver option
>> could be added to put that ceiling back.
>>
>> The only way to find out is for folks to try and if there is a failure,
>> contact me, or send mail to this list. Code reviews welcome as well.
>>
>> Doug Gilbert
>>
>>
>> **** I felt this was a better use of my time than trying to invent a new
>>       debug/trace mechanism for the whole SCSI subsystem. That is what
>>       _SCSI_ system maintainers are for, I'll stick to the sg driver (and
>>       scsi_debug). Add user space tools and there is more than enough work
>>       there ...
>>
> 
