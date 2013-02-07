From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 13:33:55 +0100
Message-ID: <51139F33.90307@suse.de>
References: <20130206195122.GA30652@sgi.com> <20130206202444.GA4771@blackbox.djwong.org> <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com> <20130207094012.GA28047@localhost> <20130207100139.GB4773@blackbox.djwong.org> <51138FA0.1080507@suse.de> <51139940.3000902@panasas.com> <51139B13.6070008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51139B13.6070008@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On 02/07/2013 01:16 PM, Boaz Harrosh wrote:
> On 02/07/2013 02:08 PM, Boaz Harrosh wrote:
>> On 02/07/2013 01:27 PM, Hannes Reinecke wrote:
>>> On 02/07/2013 11:01 AM, Darrick J. Wong wrote:
>>>> On Thu, Feb 07, 2013 at 01:40:14AM -0800, Joel Becker wrote:
>>>>> On Wed, Feb 06, 2013 at 03:34:49PM -0500, Chuck Lever wrote:
>>>>>>
>>>>>> On Feb 6, 2013, at 3:24 PM, "Darrick J. Wong" <darrick.wong@orac=
le.com> wrote:
>>>>>>
>>>>>>> On Wed, Feb 06, 2013 at 01:51:22PM -0600, Ben Myers wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I'm interested in discussing how to pass protection informatio=
n to and from
>>>>>>>> userspace.  Maybe Martin could be enlisted for the discussion.
>>>>>>>>
>>>>>>>> I read that some work has already been done in this area but h=
ave not been able
>>>>>>>> to locate it.  It looks like the bio-integrity code already ma=
kes it possible
>>>>>>>> to generate the t10-dif crc in the filesystem.  It would be go=
od to be able to
>>>>>>>> get the guard and application tags back out to backup applicat=
ions such as
>>>>>>>> xfsdump.  Enabling other applications to generate their own ta=
gs in userspace
>>>>>>>> is also interesting.
>>>>>>>
>>>>>>> This one's been on my list for a couple of years (and companies=
) too.  A few
>>>>>>> years ago Joel Becker had support for it in his sys_dio proposa=
l (that hasn't
>>>>>>> gone anywhere), and more recently I've theorized that we could =
add a magic
>>>>>>> fcntl/ioctl to make the kernel recognize, say, the first iovec =
of a O_DIRECT
>>>>>>> *{read,write}v call as the PI buffer, which I think is similar =
to how DIX gets
>>>>>>> PI data to a disk.  But it's not like I have any code to show f=
or it.
>>>>>>>
>>>>>>> I /think/ it's fairly straightforward to change the directio su=
bmit code to
>>>>>>> find the userspace PI buffer and amend the block integrity code=
 to attach our
>>>>>>> own PI buffer.  You'd still have to let the block layer set the=
 sector # field,
>>>>>>> but afaik that won't affect the crc or the app tag.
>>>>>>>
>>>>>>> I hear that the NFS guys want to propose some sort of protocol =
for transmitting
>>>>>>> PI data (across NFS), but I haven't seen anything concrete yet.
>>>>>>
>>>>>> I'm writing a requirements document for the NFS protocol which I=
 can discuss at LSF.  The use cases for NFS for now would be virtual di=
sk devices (hypervisors) or direct NFS access to storage from user spac=
e.
>>>>>>
>>>>>> Like everyone else we are waiting for a magical VFS and user spa=
ce API to appear that can pass PI to and from storage.
>>>>>
>>>>> I'm happy to chat about it.  Unfortunately, like Darrick says, sy=
s_dio()
>>>>> coding hasn't happened.  I do think we're better off with some ki=
nd of
>>>>> explicit API than some magic state on the file.  I mean, even som=
ething
>>>>> like:
>>>>>
>>>>> 	ssize_t write_with_pi(int fd, const void *buf, size_t count,
>>>>> 			      const void *pi, size_t pi_count);
>>>>>
>>>>> It's not as nice as a non-historical API (eg sys_dio), but it als=
o
>>>>> probably plays nicer with buffered I/O.
>>>>
>>>> I also pondered simply adding a new io_prep_* function + IO_CMD_ c=
ode to libaio
>>>> and all the other plumbing necessary to make that happen...
>>>>
>>>> void io_prep_preadv_pi(struct iocb *iocb, int fd, const struct iov=
ec *iov,
>>>> 		       int iovcnt, long long offset, const void *pi,
>>>> 		       size_t pi_count);
>>>>
>>> This is also what I've envisioned.
>>> Updating io_prep / async I/O is reasonably easy as its been using a
>>> separate structure for passing in the I/O details.
>>>
>>> Normal read/write calls don't really map as you simply don't have
>>> enough parameter to feed PI information into the kernel.
>>> So for that you'd need to invent a new interface / syscall.
>>>
>>> For aio we just need to add additional fields to an existing struct=
ure.
>>>
>>> So yeah, I'd be interested in that discussion as well.
>>>
>>
>> Me too, in multiple fronts. It's part of my general concern about
>>     "things we would like for user-mode servers"
>>
>> I think that the current aio and libaio Interface is broken for a lo=
ng
>> time, for multitude of reasons. For instance the nested structure de=
finitions
>> are COMPAT broken, and lots of missing pieces. (For example search i=
n archives
>> for why bsg does not support sg-lists.)
>>
>> And there are all these additions that everyone wants on top, that c=
all for
>> a new interface anyway.
>>
>> So I would like to see a deep fixup of this interface, with an aio v=
ersion2
>> that can take into considerations, all of future needs including the=
se
>> above. Kernel code will be very happy to be implemented with the new=
, interface
>> and a COMPAT layer could be put in place for the old interface.
>>
>> All interested parties should bring to the table what is the extensi=
on/changes
>> they need. And we can try and union all of them together.
>>
>> (My addition is for support of sg_lists to bsg, in a way that makes =
Tomo happy
>>   I know that qemu was wanting this for a while as well as the multi=
tude of
>>   user-mode servers)
>>
>
> I wanted to add that there is another LSF/MM thread going on about:
> 	"[LSF TOPIC] What to do about O_DIRECT?"
>
> All these guys should be participating here, so to change core struct=
ures
> and behavior to a better model, that helps us here, and not against u=
s.
>
> (Again libaio should be changed in concert with Kernel's new API, and=
 we
>   can sacrifice old user-mode performance, with a COMPAT layer. Distr=
o
>   maintainers should consider replacing libaio, together with the new
>   Kernel, so it is only those that do their own mix-and-match, who ca=
n
>   fix that mismatch too)
>
And while we're at it, I still would _love_ to connect aio_cancel()=20
and blk_abort_request().

That way we could sensibly abort an I/O and get out of the darn 'D'=20
state.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
