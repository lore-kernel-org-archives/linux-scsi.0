From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in
	the bio/request structs
Date: Tue, 03 May 2016 16:44:02 -0400
Message-ID: <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	(mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org's message of "Fri, 15 Apr 2016 14:15:35 -0500")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org writes:

> The following patches begin to cleanup the request->cmd_flags and
> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
> attributes and state of the request. For bi_rw we use it for similar
> info and also the priority but then also have another bi_flags field
> for state. At some point, we abused them so much we just made cmd_flags
> 64 bits, so we could add more.
>
> The following patches seperate the operation (read, write discard,
> flush, etc) from cmd_flags/bi_rw.
>
> This patchset was made against linux-next from today April 15
> (git tag next-20160415).
>
> I put a git tree here:
> https://github.com/mikechristie/linux-kernel.git
> The patches are in the op branch.

Hi, Mike,

That git tree doesn't seem to exist.  I did manage to apply your patch
set on top of next-20160415, though.

So... what testing did you do? ;-) I ran into the following problems:
- git clone fails
- yum segfaults
- many blktrace/blkparse issues, including incorrect cpu recorded in
  traces, null task names, and blkparse outputting nothing for a trace
  file several gigabytes in size.

After that, I decided to back out your patches and test the base
linux-next kernel.  That kernel has none of those issues.

So, either I'm missing some dependencies, or I think we've got some
issues to iron out before this thing goes in.  Before I dig any further,
am I missing something?

Cheers,
Jeff
