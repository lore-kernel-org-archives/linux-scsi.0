From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/MM TOPIC] Copy offload
Date: Tue, 10 Jan 2012 14:11:27 -0800
Message-ID: <20120110221125.GB30141@dhcp-172-17-9-228.mtv.corp.google.com>
References: <4F0AC112.2000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44847 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2AJWLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 17:11:33 -0500
Content-Disposition: inline
In-Reply-To: <4F0AC112.2000709@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Mon, Jan 09, 2012 at 11:27:30AM +0100, Hannes Reinecke wrote:
> Quite a lot of discussion has come up recently on supporting Copy
> Offload (aka SCSI XCOPY) with linux.
> 
> During the course of this several topics were found which need some
> discussion:
> 
> - Interface: do we need a new syscall? Should we try to resurrect
>   the original sys_copyfile() approach from Joel Becker?
>   What are the areas and use-cases this syscall should cover?
> 
> - Scope: SCSI XCOPY is not the only possible user here, CIFS and
>   NFSv4 have similar needs. We should aim for integrating all of
>   these use-cases. However, we need to revisit them to figure out
>   if and to what extend they are really compatible.
> 
> - Implementation: The new interface is likely to reside on the
>   filesystem level. To quote Dave Chinner:
>   > e.g. for an array offload, we have to flush the source file
>   > page cache first so that the data being copied is known to
>   > be on disk, then invalidate the destination page cache if
>   > overwriting or extend and pre-allocate blocks if not. Then
>   > we have to map both files and hand that off to the array.
>   >
>   > Then there's a whole bunch of tricky questions about what
>   > the state of the destination file should look like while
>   > the copy is in progress, whether the source file should be
>   > allowed to change (e.g. it can't be truncated and have
>   > blocks freed and then reused by other files half way through
>   > the copy offload operation), and so on.
> 
> - Backends: Should we concentrate on the new 'XCOPY LITE' proposal
>   or should we try to implement the original XCOPY command, too?
> 
> I guess this'll warrant a joint session, as at least filesystem and
> storage people will be involved here.

	I'll join in for sure.  I've owed code for over a year now
(hanging head in shame).

Joel


-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec@evilplan.org
