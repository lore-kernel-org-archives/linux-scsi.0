From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Wed, 9 Mar 2005 23:21:14 +0100
Message-ID: <20050309222114.GF4105@marowsky-bree.de>
References: <422BFCB2.6080309@yahoo.com> <20050309050434.GT3163@waste.org> <422E8EEB.7090209@yahoo.com> <20050309060544.GW3120@waste.org> <422E96D9.6090202@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from gate.in-addr.de ([212.8.193.158]:46048 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262093AbVCIWVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 17:21:04 -0500
Content-Disposition: inline
In-Reply-To: <422E96D9.6090202@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>, Matt Mackall <mpm@selenic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2005-03-08T22:25:29, Alex Aizman <itn780@yahoo.com> wrote:

> There's (or at least was up until today) an ongoing discussion on our=
=20
> mailing list at http://groups-beta.google.com/group/open-iscsi. The=20
> short and long of it: the problem can be solved, and it will. Couple=20
> simple things we already do: mlockall() to keep the daemon un-swapped=
,=20
> and also looking into potential dependency created by syslog (there's=
=20
> one for 2.4 kernel, not sure if this is an issue for 2.6).

BTW, to get around the very same issues, heartbeat does much the same:
lock itself into memory, reserve a couple of pages more to spare on
stack & heap, run at soft-realtime priority.

syslog(), however, sucks.

We went down the path of using our non-blocking IPC library to have all
our various components log to ha_logd, which then logs to syslog() or
writes to disk or wherever.

That works well in our current development series, and if you want to
share code, you can either rip it off (Open Source, we love ya ;) or we
can spin off these parts into a sub-package for you to depend on...

> The sfnet is a learning experience; it is by no means a proof that it=
=20
> cannot be done.

I'd also argue that it MUST be done, because the current way of "Oh,
it's somehow related to block stuff, must be in kernel" leads down to
hell. We better figure out good ways around it ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
