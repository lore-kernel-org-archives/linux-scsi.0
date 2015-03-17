From: Alireza Haghdoost <haghdoost@gmail.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Date: Mon, 16 Mar 2015 20:12:16 -0500
Message-ID: <CAB-428kqj2KChEGmjqSXLhM4TMM-dsgK7LzkQXxgp5En4jBVRg@mail.gmail.com>
References: <20150316060020.GB28557@dastard> <1426519733.4000.11.camel@HansenPartnership.com>
 <20150316203207.GD28557@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150316203207.GD28557@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, xfs@oss.sgi.com, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 16, 2015 at 3:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 16, 2015 at 11:28:53AM -0400, James Bottomley wrote:
>> [cc to linux-scsi added since this seems relevant]
>> On Mon, 2015-03-16 at 17:00 +1100, Dave Chinner wrote:
>> > Hi Folks,
>> >
>> > As I told many people at Vault last week, I wrote a document
>> > outlining how we should modify the on-disk structures of XFS to
>> > support host aware SMR drives on the (long) plane flights to Boston.
>> >
>> > TL;DR: not a lot of change to the XFS kernel code is required, no
>> > specific SMR awareness is needed by the kernel code.  Only
>> > relatively minor tweaks to the on-disk format will be needed and
>> > most of the userspace changes are relatively straight forward, too.
>> >
>> > The source for that document can be found in this git tree here:
>> >
>> > git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation
>> >
>> > in the file design/xfs-smr-structure.asciidoc. Alternatively,
>> > pull it straight from cgit:
>> >
>> > https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc
>> >
>> > Or there is a pdf version built from the current TOT on the xfs.org
>> > wiki here:
>> >
>> > http://xfs.org/index.php/Host_Aware_SMR_architecture
>> >
>> > Happy reading!
>>
>> I don't think it would have caused too much heartache to post the entire
>> doc to the list, but anyway
>>
>> The first is a meta question: What happened to the idea of separating
>> the fs block allocator from filesystems?  It looks like a lot of the
>> updates could be duplicated into other filesystems, so it might be a
>> very opportune time to think about this.
>
> Which requires a complete rework of the fs/block layer. That's the
> long term goal, but we aren't going to be there for a few years yet.
> Hust look at how long it's taken for copy offload (which is trivial
> compared to allocation offload) to be implemented....
>
>> > === RAID on SMR....
>> >
>> > How does RAID work with SMR, and exactly what does that look like to
>> > the filesystem?
>> >
>> > How does libzbc work with RAID given it is implemented through the scsi ioctl
>> > interface?
>>
>> Probably need to cc dm-devel here.  However, I think we're all agreed
>> this is RAID across multiple devices, rather than within a single
>> device?  In which case we just need a way of ensuring identical zoning
>> on the raided devices and what you get is either a standard zone (for
>> mirror) or a larger zone (for hamming etc).
>
> Any sort of RAID is a bloody hard problem, hence the fact that I'm
> designing a solution for a filesystem on top of an entire bare
> drive. I'm not trying to solve every use case in the world, just the
> one where the drive manufactures think SMR will be mostly used: the
> back end of "never delete" distributed storage environments....
> We can't wait for years for infrastructure layers to catch up in the
> brave new world of shipping SMR drives. We may not like them, but we
> have to make stuff work. I'm not trying to solve every problem - I'm
> just tryin gto address the biggest use case I see for SMR devices
> and it just so happens that XFS is already used pervasively in that
> same use case, mostly within the same "no raid, fs per entire
> device" constraints as I've documented for this proposal...
>
> Cheers,
>
> Dave.


I am confused what kind of application you are referring to for this
"back end, no raid, fs per entire device". Are you gonna rely on the
application to do replication for disk failure protection ?

I think it is a good idea to devise the file system changes with a
little bit concern about its negative impact on RAID. My impression is
that these changes push more in-place parity update if file system
deployed on the top of parity based RAID array since it would convert
most of random IOs to sequential IOs that might happen to be in the
same parity stripe.

--Alireza
