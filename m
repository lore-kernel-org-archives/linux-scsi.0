From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 09:50:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425095055.B8776@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <3EA94263.1020902@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:9457 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263298AbTDYQmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:42:35 -0400
Content-Disposition: inline
In-Reply-To: <3EA94263.1020902@rogers.com>; from tluben@rogers.com on Fri, Apr 25, 2003 at 10:12:51AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2003 at 10:12:51AM -0400, Luben Tuikov wrote:

> 1. Use the cache *first*, and if it's depleted, *then*
> use the spare command struct.

Then we would allocate and almost never use the spare. This is a bit
different as compared to the per-host spare, when we shoulid use the
spare only as a last resort.

> 2. Why spare_cmd is a pointer? Why? Why?
> Wouldn't it be much more *flexible* to be a list_head,
> so that maybe we can hook up more commands in the future?
> I.e. keep your options open...

When or if we use more than one spare we can change the code to a
list_head. I don't plan to add such code, so I see no reason to use a
list_head.

> 3. As Christoph pointed out, access to your spare is racy.

spare_cmd is protected via sdev_lock.

> 4. Why are you using list_del()???? You should use list_del_init()!
> I can easily envision a hard to catch bug (and quite rare), when
> some LLDD gets the spare and does a check on the list_head...

__scsi_get_command is always setting the list_head, whether it is the
spare or not. If the LLDD or scsi core got a command with a bad list_head,
that is a bug.

> Furthermore, cannot you see the infrastructure to which we've
> tried to get closer to?  More specifically a command struct travels
> list_heads as it comes out of the cache/spare_list and comes
> back to the cache/spare_list.

If we are not using the list_head post scsi_put_command, there is no
reason to use list_del_init (versus list_del).

-- Patrick Mansfield
