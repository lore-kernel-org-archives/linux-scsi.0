From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Thu, 6 Mar 2003 15:33:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303061533.39375.oliver@neukum.name>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303052049.16538.oliver@neukum.name> <20030305223504.GB4014@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030305223504.GB4014@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

> > What exactly is a refcount supposed to do? It doesn't help the main
> > problem. You must prevent new references arising. This requires locking
> > and flags.
>
> Refcounting is need for proper freeing so it needs to be part of the
> solution. We need to have the refcounting implementation prevent gets
> post "offline"
>
> Yes, currently the kobject_get does not contain any support for
> preventing the incrementing of the ref count. This needs to be wrapped
> by the implementor (I believe as I do not see the object state support
> being implemented in the core code).

True but it misses an important part of the problem. It mixes references
through IO in progress with devices attached to a host. These are independent
issues.

> It is not required, but lack of any online state in a driver will
> possibly cause extended time to cancel the IO. We would not want
> excessive checking in the main IO path so there will be code that races
> with "offline" and makes it to queuecommand.

The main IO path is independent of the problems arising from offlining a
host. This issue must be dealt with in connection with offlining a _device_.

However offlining a host causes additional problems because devices
can be added and taken away from a host.
It takes a flag to make sure that no further devices can be added to the
host. This does not influence the main IO path, only device detection
and removal, which are not critical to performance.

	Regards
		Oliver

