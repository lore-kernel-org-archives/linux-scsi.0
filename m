From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Subject: Re: [PATCH v4 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Tue, 14 Jun 2016 19:39:56 -0700
Message-ID: <CAMP5XgeTaDZt84ZhghMPCDG8MttFtFQj829UnQxLAt6dU0Q97Q@mail.gmail.com>
References: <5B8DA87D05A7694D9FA63FD143655C1B54283E72@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B54283E72@hasmsx108.ger.corp.intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 14, 2016 at 2:05 PM, Winkler, Tomas <tomas.winkler@intel.co=
m> wrote:
>>>> wrote:
>>>> > Few storage technology such is EMMC, UFS, and NVMe support RPMB
>>>> >hardware partition with common protocol and frame layout.
>>>> > The RPMB partition cannot be accessed via standard block layer, =
but
>>>> >by a set of specific commands: WRITE, READ, GET_WRITE_COUNTER, an=
d
>>>> >PROGRAM_KEY.
>>>> >...
>>>>
>>>> If the same protocol is used by all these standards, why not expor=
t it directly
>>>> (including the RESULT_READ command or not even knowing the command
>>>> types)?
>>> The protocol is the  same, but the wrapping of the packets is stora=
ge type specific so
>>> I believe that the best abstraction is on those  4 operations level=
=2E I'm not sure if the code would
>>> be simpler if it would be exposed on a lower level.
>>
>> I disagree. With the two storage types you support, the packets are
>> identical. The only difference is the low level commands you use to
>> send and receive them.
> The packets are identical, but there are these little settings you ne=
ed to be aware of
> like set argument  31 in CMD23 for WRITE and PROGRAM_KEY and for othe=
rs not so
> the storage type transparency is lost, actually the UFS protocol is a=
 bit cleaner in that sense.
> I know it can be ironed somehow, but this just stresses the point.
>

Bit 31 selects reliable write. Your driver does not need to know the
command number to set this correctly if the client specifies if a
reliable write is needed.

>>> RESULT_READ  is  a command to be issued for getting preceeding writ=
e operation status, it's a kind of work around about the fact that you =
have to issue a read operation
>>> in order to retrieve data in this case a  write operation result.  =
It can be successfully hidden and final result of the operation is deli=
vered
>>> to the user.
>>>
>>
>> Yes, it is possible to hide the result read command, but that does n=
ot
>> mean you should. The rpmb protocol is designed to let two endpoints
>> communicate in a way that lets them detect tampering. While the pack=
et
>> you inject does not contain any protected data, you can still view i=
t
>> as a form of tampering.
>
> I=E2=80=99m not seeing it like injecting packets, those are merely co=
mmands embedded in the packets that need to be performed in order to co=
mplete the operation
> and there is not security value in them, the only end to end protecti=
on is truly given by the MAC verification and this is preserved.

You are sending an extra packet to send that command.

>
>>If a future rpmb protocol version adds
>> features, you could loose the ability to inject packets.
>
> The code will have to change anyhow.
>

Why would your code need to change? If your code does not inspect and
inject packets, the data in those packets can change independently
from your code.

>>
>>>> While I would prefer an rpmb specific interface over the existing =
raw
>>>> mmc command interface, all I need is an rpmb operation that lets m=
e send
>>>> and receive buffers without interruption.
>>>
>>> I currently don't see an obstacle on doing the same with proposed i=
nterface, what is the issue are seeing.
>>>
>>
>> The main issue is that you are injecting commands, so code that
>> follows the mmc spec will not work.
>
> Yes, it should be storage type independent, not mmc spec dependant.
> The interface reduces the number of data passed between user space an=
d kernel, the device power management is simpler.
>

=46rom what I can tell we have multiple storage types that use mostly
compatible specs, but you chose to "simplify" it. I strongly suggest
passing the existing protocol through as-is, and only perform packet
inspection for incompatible storage types (if or when they exist).

>>
>>>> You can find our exiting user-space code here at
>>>> https://android.googlesource.com/platform/system/core/+/master/tru=
sty/s
>>>> torage/proxy/rpmb.c.
>>>> If you use an interface more similar to this, I think your emmc an=
d ufs
>>>> specific code would be simpler. Also, if you don't need the in-ker=
nel
>>>> interface, the kernel would not need to know the details of the rp=
mb
>>>> protocol at all.
>>>
>>> My major interest is the in-kernel protocol the user space API was =
more intended for debug, but I found it would be even more useful.
>>> The store type  access is very RPMB specific  for both MMC and UFS =
and needs to do special operations for RPMB so I don't see how this awa=
reness can be removed or I'm not reading your proposal correctly.
>>
>> The interface we use specifies reliable-write, write and read
>> operations on an rpmb partition. I don't think you need to know more
>> than this in either mmc or ufs. I have not seen the ufs spec, but
>> based on your code it looks like reliable-write and write can map to
>> the same command there.
> Yes, the interface can be also abstract on let=E2=80=99s call it raw =
rpmb packet read/write level, but I didn=E2=80=99t see the value in at =
the time as RPMB operations and the steps are well defined.
> Maybe there is a place for to support for fing grained access or at l=
easting adding RESULT_READ command as well,  for the usecases like your=
s.
>
>>> Accessing RPMB is a multiple stepsoperation, the steps can be drive=
n from the user space as done in EMMC ioctl but hidning would reduce th=
e number of system calls and amount of data passed,
>>> in some sense the same as in the  new mmc  MMC_IOC_MULTI_CMD is try=
ing ot achive.
>>>
>> The main purpose of using the MMC_IOC_MULTI_CMD is not to reduce the
>> number of syscalls. It is to prevent other mmc operations from getti=
ng
>> interleaved with the rpmb packets. Some emmc chips will only respond
>> error packet if any other partitions are read from between the write
>> and read operation on the rpmb partition.
>
> I didn=E2=80=99t encountered as our interface doesn=E2=80=99t suffer =
form that issue but yes this just another reason to use the new rpmb in=
terface

The MMC_IOC_MULTI_CMD solves that problem and is already merged.

>>
>>>> I have not tested your code, but it looks like we would have to mo=
dify the
>>>> storage proxy to interpret the data it currently passes through an=
d remove all
>>>> RESULT_READ packets.
>>> Your proxy driver just sends ioctls so this wouldn't be much differ=
ence and the rpmb code on the trusty w need rewrite just rpmb_send () f=
unction,
>>> actually removing one set of buffer size. I will try to make that m=
odification if it helps?
>>>
>>
>> No I don't want you to modify the code that runs in the secure OS.
>> This would require additional code in boot loaders and proxy servers
>> using the existing MMC_IOC_MULTI_CMD command as they too would have =
to
>> interpret the packets to inject RESULT_READ packets.
>
> I=E2=80=99ve looked at the proxy and and secure OS, the rewirte is no=
t so hard, though.
> I really cannot figure to boo loader and secure OS interactions, you =
have this notion of TP and TDEA ports but those are not used from the s=
ecure OS.
> Is there a software you can point me to?

I don't have any bootloader code to share, if that is what you are
asking for. The goal is to have access to the rpmb data before loading
Linux. For this to work, the bootloader has to implement the rpmb
proxy operations (which should be as simple to implement as possible).
I don't want to maintain two protocols where the bootloader and
old-linux clients use the full rpmb protocol and new linux clients use
your rpmb protocol.

>
> Second if it won=E2=80=99t be possible to use the current implementat=
ion if the storage type change UFS or NVMe anyhow and on the othernad
> I=E2=80=99m not suggesting to kill MMC ioctl, so this won=E2=80=99t b=
e breackages of the existing software.

I don't think you need to be compatible with existing Linux user-space
code, but it would be possible by emulating the MMC_IOC_MULTI_CMD
command. You should try to be compatible with existing secure os
interfaces though, as there is no reason for this to be different for
ufs and emmc.

>
> In bottom line I will try to add raw read/write access to RPMB to sup=
port fine grained access and see if you can work with that.
>

Why not change your code to be compatible with code written against
the existing specs instead? I don't see a need for an interface where
the client has to prepare all the packets defined by the spec except
for one special packet that the kernel will inject.

>
> I really appreciate your feedback.
> Thanks
> Tomas
>
>
>
>



--=20
Arve Hj=C3=B8nnev=C3=A5g
