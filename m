From: "Dr. Michael Weller" <eowmob@exp-math.uni-essen.de>
Subject: Re: Is this /dev/sg security hole from 2.2.* already fixed?
Date: Mon, 8 Apr 2002 10:50:23 +0200 (MESZ)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.A32.3.95.1020408100124.31868A-100000@werner.exp-math.uni-essen.de>
References: <3CAE595B.D7824BD2@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <3CAE595B.D7824BD2@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 5 Apr 2002, Douglas Gilbert wrote:

> 
> Michael,
> Pass through drivers that allow normal users to get to
> hardware always have a worrying security aspect **. A
> system that is open to malicious users should have drivers
> like sg removed (or root only permissions on all /dev/sg<n>
> device names).
> 
> Your observations are correct. There is no need to look at
> later sg drivers as they will be similar in this respect.
> The design of the sg driver favours speed over security.
> If this was considered a major problem then it shouldn't
> be too difficult to zero out all kernel buffers obtained
> for non-root users. That would leave the situation where
> a user could see "left over" data from previous scsi 
> commands  performed on the current file descriptor: not
> a major concern in my opinion.

Ok, thanx for that info. I was just surprised noticing it when
playing around with scsiinfo (in the little time I currently have I'm
extending it a bit (/dev/sg support to get longish defect lists (>4K);
more mode pages; support for log pages.. it's more a fun style
project: look and see what those funny scsi-devices are willing to tell
you). I really would have considered it standard to clear those
buffers. At least the allocated part not used by the command.

But as I see in the API definition and hear from criticism from other
scsi tool authors (cdrecord, for example), sg does not provide info about 
residual counts (read: how many bytes actually transferred by scsi
device). It's too long since I played with the scsi mid and lower layers
to tell how difficult it would be to provide this infor.

About the security concern, and misuse of /dev/sg. Yes you are right.
In principle, /dev/sg shouldn't be accessible to malicious users at all.

But /dev/sg is required to access standard hardware used by many 'office
style' users, namely scanners and CD writers. One might wish to have a
workstation with several non-root users which can, however, access a
scanner or CD-Writer, but without risking a root exploit.

One could be attempted to trust the linux security in that those users can
be given access to a specific sg device only and that the kernel ensures
commands are only send to this device. This would leave the hole that an
intentionally or not send SCSI command might hang the bus or access data
from other scsi devices (AFAIK their exist some target 2 target copy
operations).

Probably a more sensible security approach on such a system would be to
have /dev/sg accessible by a certain uid only and all those tools
accessing it to be setuid this uid. Plus have all those tool be accessible
to a certain gid only and only selected users in this group.

> ** there was a lkml thread some time back in which Andre
> Hedrick was suggesting that commands be filtered in the 
> (proposed ?) IDE pass through driver. Most respondents
> thought that was overkill.

Yes, I read that thread and think similar (overkill). At least as far as
the driver can ensure that only a certain IDE device is accessed. If
that's not the case, the access has to be root only. Here, I think,
filtering commands even for the root user was discussed, to protect the
superuser from doing stupid things to the device. I think (as probably
most of the other people in the thread thought), that a) the root user
must be assumed to know what he does (if not there are zillions of other
places where he can do bad), and b) if not, or if one wants to aid him not
doing stupid things, the right place is a warning in the application
interfacing with the driver.

Note that this is slightly different from the /dev/sg buffer issue. I
(naively) thought, if Joe Blow User has write access to /dev/sg5 (a
scanner, say) this shouldn't allow possible read access to other users
data. I've no concerns about Joe Blow User seeing buffers previously used
on the same file descriptor (or sg device), only buffers from kernel or
other devices; I didn't look into the sg sources to say if this can be
achieved easily though.. Alternatively (to avoid wasting time clearing
buffers) one could allow the application to read back only the amount of
data actually returned by the scsi device, but that's not how the api
works currently.

Talking about wasting time clearing buffers, is read() from /dev/sg really
zero copy? Why not just copy the 'really commans return' data in read() 
and leave the rest of the user apps memory untouched? Won't that be even
faster? 

Or, one can say, we only wish to give access to /dev/sg for root (or users
as powerful as root anyway), then I agree that this is a no issue. I just
wasn't aware that /dev/sg is meant like that (It doesn't really matter for
my scsiinfo needs; I just hope linux distributions and other, standard
scanner & cdwriter application writers, consider it this way and allow
'safe' (maybe suid based) access schemes.

Well, anyway, I don't want to waste your time or anyoneelse's on the list.
I know well that rather than blathering about what /dev/sg all could do, I
should just extend it myself and suggest patches.

I was just concerned this would be a new, unknown security hole. At least
based on how *I* expected /dev/sg. If everyone is already aware about it
and this is how it is expected to work.. well, that's ok for me.

Regards & Thanx for your time answering,
Michael.

--

Michael Weller: eowmob@exp-math.uni-essen.de, eowmob@ms.exp-math.uni-essen.de,
or even mat42b@spi.power.uni-essen.de. If you encounter an eowmob account on
any machine in the net, it's very likely it's me.

