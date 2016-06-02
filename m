From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Subject: Re: [PATCH v4 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Thu, 2 Jun 2016 15:35:40 -0700
Message-ID: <CAMP5XgeqtSXjFZ4o5nSjDRxde=jUSxci=ugJtSFFqvcm7McP8Q@mail.gmail.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
	<CAMP5Xgfo-4h3DYki0VWhQFjBtAE9=f9dqCZQV8VDvfJ3Rc_2UQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B5427E98E@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5427E98E@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 2, 2016 at 6:17 AM, Winkler, Tomas <tomas.winkler@intel.com=
> wrote:
>>
>> On Wed, Jun 1, 2016 at 2:41 PM, Tomas Winkler <tomas.winkler@intel.c=
om>
>> wrote:
>> > Few storage technology such is EMMC, UFS, and NVMe support RPMB
>> >hardware partition with common protocol and frame layout.
>> > The RPMB partition cannot be accessed via standard block layer, bu=
t
>> >by a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
>> >PROGRAM_KEY.
>> >...
>>
>> If the same protocol is used by all these standards, why not export =
it directly
>> (including the RESULT_READ command or not even knowing the command
>> types)?
> The protocol is the  same, but the wrapping of the packets is storage=
 type specific so
> I believe that the best abstraction is on those  4 operations level. =
I'm not sure if the code would
> be simpler if it would be exposed on a lower level.

I disagree. With the two storage types you support, the packets are
identical. The only difference is the low level commands you use to
send and receive them.

> RESULT_READ  is  a command to be issued for getting preceeding write =
operation status, it's a kind of work around about the fact that you ha=
ve to issue a read operation
> in order to retrieve data in this case a  write operation result.  It=
 can be successfully hidden and final result of the operation is delive=
red
> to the user.
>

Yes, it is possible to hide the result read command, but that does not
mean you should. The rpmb protocol is designed to let two endpoints
communicate in a way that lets them detect tampering. While the packet
you inject does not contain any protected data, you can still view it
as a form of tampering. If a future rpmb protocol version adds
features, you could loose the ability to inject packets.

>> While I would prefer an rpmb specific interface over the existing ra=
w
>> mmc command interface, all I need is an rpmb operation that lets me =
send
>> and receive buffers without interruption.
>
> I currently don't see an obstacle on doing the same with proposed int=
erface, what is the issue are seeing.
>

The main issue is that you are injecting commands, so code that
follows the mmc spec will not work.

>> You can find our exiting user-space code here at
>> https://android.googlesource.com/platform/system/core/+/master/trust=
y/s
>> torage/proxy/rpmb.c.
>> If you use an interface more similar to this, I think your emmc and =
ufs
>> specific code would be simpler. Also, if you don't need the in-kerne=
l
>> interface, the kernel would not need to know the details of the rpmb
>> protocol at all.
>
> My major interest is the in-kernel protocol the user space API was mo=
re intended for debug, but I found it would be even more useful.
> The store type  access is very RPMB specific  for both MMC and UFS an=
d needs to do special operations for RPMB so I don't see how this aware=
ness can be removed or I'm not reading your proposal correctly.

The interface we use specifies reliable-write, write and read
operations on an rpmb partition. I don't think you need to know more
than this in either mmc or ufs. I have not seen the ufs spec, but
based on your code it looks like reliable-write and write can map to
the same command there.

> Accessing RPMB is a multiple stepsoperation, the steps can be driven =
from the user space as done in EMMC ioctl but hidning would reduce the =
number of system calls and amount of data passed,
> in some sense the same as in the  new mmc  MMC_IOC_MULTI_CMD is tryin=
g ot achive.
>
The main purpose of using the MMC_IOC_MULTI_CMD is not to reduce the
number of syscalls. It is to prevent other mmc operations from getting
interleaved with the rpmb packets. Some emmc chips will only respond
error packet if any other partitions are read from between the write
and read operation on the rpmb partition.

>> I have not tested your code, but it looks like we would have to modi=
fy the
>> storage proxy to interpret the data it currently passes through and =
remove all
>> RESULT_READ packets.
> Your proxy driver just sends ioctls so this wouldn't be much differen=
ce and the rpmb code on the trusty w need rewrite just rpmb_send () fun=
ction,
> actually removing one set of buffer size. I will try to make that mod=
ification if it helps?
>

No I don't want you to modify the code that runs in the secure OS.
This would require additional code in boot loaders and proxy servers
using the existing MMC_IOC_MULTI_CMD command as they too would have to
interpret the packets to inject RESULT_READ packets.

> Thanks for interest and your review.
> Tomas
>
>



--=20
Arve Hj=C3=B8nnev=C3=A5g
