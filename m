From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Sat, 5 Oct 2002 10:54:50 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210051043290.3098-100000@kai.makisara.local>
References: <20021004143217.A18636@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021004143217.A18636@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 4 Oct 2002, Patrick Mansfield wrote:

> Hi -
>
> I noticed that the tape drivers (st.c and osst.c) are not using the
> scsi_ioctl() for door locking, so they won't ever set the new
> Scsi_Device::locked.
>
> There is some auto-relock code, but AFAICT (at least st.c, searching for
> MTLOCK) it will only relock after a reset (if was_reset is still set),
> and we are calling st_ioctl() for one of these MT commands:
>
> 	MTREW MTOFFL MTRETEN MTERASE MTSEEK MTEOM
>
> The user can't even relock the door unless one of the above commands
> was sent (again, if was_reset is still set).
>
> The auto-relock in rw_checks() is never hit if was_reset is set.
>
> Kai - should st.c (and osst.c?) be using scsi_ioctl(SCSI_IOCTL_DOORLOCK/UNLOCK)?
>
st.c should definitely do it. I will do the changes very soon (together
with some other changes related to resets done by the midlayer). (The
ioctl did not exist when I put the current code into st.c and I have not
seen any pressing reason the change that until now.) The same changes
should probably be made to osst.c. I will tell the maintainers.

	Kai

