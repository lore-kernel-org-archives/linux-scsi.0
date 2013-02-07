From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 12:27:28 +0100
Message-ID: <51138FA0.1080507@suse.de>
References: <20130206195122.GA30652@sgi.com> <20130206202444.GA4771@blackbox.djwong.org> <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com> <20130207094012.GA28047@localhost> <20130207100139.GB4773@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGL1a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2013 06:27:30 -0500
In-Reply-To: <20130207100139.GB4773@blackbox.djwong.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

On 02/07/2013 11:01 AM, Darrick J. Wong wrote:
> On Thu, Feb 07, 2013 at 01:40:14AM -0800, Joel Becker wrote:
>> On Wed, Feb 06, 2013 at 03:34:49PM -0500, Chuck Lever wrote:
>>>
>>> On Feb 6, 2013, at 3:24 PM, "Darrick J. Wong" <darrick.wong@oracle.=
com> wrote:
>>>
>>>> On Wed, Feb 06, 2013 at 01:51:22PM -0600, Ben Myers wrote:
>>>>> Hi,
>>>>>
>>>>> I'm interested in discussing how to pass protection information t=
o and from
>>>>> userspace.  Maybe Martin could be enlisted for the discussion.
>>>>>
>>>>> I read that some work has already been done in this area but have=
 not been able
>>>>> to locate it.  It looks like the bio-integrity code already makes=
 it possible
>>>>> to generate the t10-dif crc in the filesystem.  It would be good =
to be able to
>>>>> get the guard and application tags back out to backup application=
s such as
>>>>> xfsdump.  Enabling other applications to generate their own tags =
in userspace
>>>>> is also interesting.
>>>>
>>>> This one's been on my list for a couple of years (and companies) t=
oo.  A few
>>>> years ago Joel Becker had support for it in his sys_dio proposal (=
that hasn't
>>>> gone anywhere), and more recently I've theorized that we could add=
 a magic
>>>> fcntl/ioctl to make the kernel recognize, say, the first iovec of =
a O_DIRECT
>>>> *{read,write}v call as the PI buffer, which I think is similar to =
how DIX gets
>>>> PI data to a disk.  But it's not like I have any code to show for =
it.
>>>>
>>>> I /think/ it's fairly straightforward to change the directio submi=
t code to
>>>> find the userspace PI buffer and amend the block integrity code to=
 attach our
>>>> own PI buffer.  You'd still have to let the block layer set the se=
ctor # field,
>>>> but afaik that won't affect the crc or the app tag.
>>>>
>>>> I hear that the NFS guys want to propose some sort of protocol for=
 transmitting
>>>> PI data (across NFS), but I haven't seen anything concrete yet.
>>>
>>> I'm writing a requirements document for the NFS protocol which I ca=
n discuss at LSF.  The use cases for NFS for now would be virtual disk =
devices (hypervisors) or direct NFS access to storage from user space.
>>>
>>> Like everyone else we are waiting for a magical VFS and user space =
API to appear that can pass PI to and from storage.
>>
>> I'm happy to chat about it.  Unfortunately, like Darrick says, sys_d=
io()
>> coding hasn't happened.  I do think we're better off with some kind =
of
>> explicit API than some magic state on the file.  I mean, even someth=
ing
>> like:
>>
>> 	ssize_t write_with_pi(int fd, const void *buf, size_t count,
>> 			      const void *pi, size_t pi_count);
>>
>> It's not as nice as a non-historical API (eg sys_dio), but it also
>> probably plays nicer with buffered I/O.
>
> I also pondered simply adding a new io_prep_* function + IO_CMD_ code=
 to libaio
> and all the other plumbing necessary to make that happen...
>
> void io_prep_preadv_pi(struct iocb *iocb, int fd, const struct iovec =
*iov,
> 		       int iovcnt, long long offset, const void *pi,
> 		       size_t pi_count);
>
This is also what I've envisioned.
Updating io_prep / async I/O is reasonably easy as its been using a=20
separate structure for passing in the I/O details.

Normal read/write calls don't really map as you simply don't have=20
enough parameter to feed PI information into the kernel.
So for that you'd need to invent a new interface / syscall.

=46or aio we just need to add additional fields to an existing structur=
e.

So yeah, I'd be interested in that discussion as well.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
