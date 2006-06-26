From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [Fastboot] [RFC] [PATCH 2/2] kdump: cciss driver initialization issue fix
Date: Mon, 26 Jun 2006 11:52:28 -0600
Message-ID: <m1veqnst2b.fsf@ebiederm.dsl.xmission.com>
References: <E717642AF17E744CA95C070CA815AE550E1555@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932128AbWFZRw7@vger.kernel.org>
In-Reply-To: <E717642AF17E744CA95C070CA815AE550E1555@cceexc23.americas.cpqcorp.net>
	(Mike Miller's message of "Mon, 26 Jun 2006 11:51:52 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: vgoyal@in.ibm.com, Maneesh Soni <maneesh@in.ibm.com>, Andrew Morton <akpm@osdl.org>, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Miller, Mike (OS Dev)" <Mike.Miller@hp.com> writes:

> Thanks Eric, that helps me understand. Section 8.2.2 of the open cciss
> spec supports a reset message. Target 0x00 is the controller. We could
> add this to the init routine to ensure the board is made sane again but
> this would drastically increase init time under normal circumstances.

Where does the init time penalty come from? How large is the
init penalty?  I suspect it is from waiting for the scsi disks to spin up.
But I am just guessing in the dark.

> And I suspect this is a hard reset, also. Not sure if that would
> negatively impact kdump. If there were some condition we could test
> against and perform the reset when that condition is met it would not
> impact 99.9% of users.

I am wondering if it is possible to look at the controller and
see if it is in a bad state, (i.e. in some state besides just coming
out of reset) and if so issue a reset.  If this really is a long operation
that would be the ideal way to handle it.

If the amount of time is really user noticeable and testing for it
is impossible then it is probably time to talk kernel command line
options.

Although it might simply be appropriate to handle commands completing
you didn't start.  I am not at all familiar with that particular piece
of hardware so I can't make a good guess on what needs to happen there.

> Thoughts, comments, flames?

Good question.

It is a bit of a pain but not too hard to setup a test environment
so you can reproduce this if you are interested.  Vivek should
be the authority there.

Eric
