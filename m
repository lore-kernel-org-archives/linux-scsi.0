From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Fri, 8 Apr 2011 12:37:56 +0100
Message-ID: <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
	<20110401154327.GA6593@mtj.dyndns.org>
	<20110405065129.GC2872@amit-x200.redhat.com>
	<20110406100620.GA4142@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110406100620.GA4142@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 6, 2011 at 11:06 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Apr 05, 2011 at 12:21:30PM +0530, Amit Shah wrote:
>> > But I don't think this is the correct place to do it. =A0The probl=
em
>> > happens because block layer consumes the event but doesn't remembe=
r it
>> > when the time for revalidation comes. =A0It should be done by bloc=
k
>> > layer, not sr. =A0Hmmm... looking at the code, the new disk event =
code
>> > should handle this correctly. =A0Was 2.6.38 showing the problem to=
o?
>>
>> Yes, 2.6.38 shows the same problem. =A0I went back to ancient kernel=
s
>> (2.6.31 on Fedora 11-alpha) which had the previous media_changed
>> infrastructure and those places too show the same behaviour (with th=
e
>> TEST_UNIT_READY way of detecting media changes).
>
> Can you please the patch attached in the following bz and see whether
> it makes any difference?
>
> =A0https://bugzilla.kernel.org/show_bug.cgi?id=3D13029

Hi Tejun,
There is a related issue I have been discussing with Amit:
https://lkml.org/lkml/2011/3/23/156

On media change the inode size is not updated by the sr driver or the
universal cdrom driver.  A userspace process that holds a /dev/sr0
file descriptor open across media change causes all processes on the
system to see the old medium size when they do lseek(fd, 0, SEEK_END).

I think it would make sense to refresh the inode size on media change
so that even open file descriptors see the new size and a single
process cannot force a stale value for all other userspace processes
on the system.

Thoughts?

Stefan
