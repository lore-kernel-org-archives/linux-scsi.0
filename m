From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Fri, 4 Oct 2002 14:32:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021004143217.A18636@eng2.beaverton.ibm.com>
References: <20020926012357.B8733@flint.arm.linux.org.uk> <20021004194136.GC9544@beaverton.ibm.com> <20021004204925.D31015@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021004204925.D31015@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Fri, Oct 04, 2002 at 08:49:25PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>, Kai.Makisara@metla.fi
Cc: linux-scsi@vger.kernel.org

Hi -

I noticed that the tape drivers (st.c and osst.c) are not using the
scsi_ioctl() for door locking, so they won't ever set the new
Scsi_Device::locked.

There is some auto-relock code, but AFAICT (at least st.c, searching for
MTLOCK) it will only relock after a reset (if was_reset is still set),
and we are calling st_ioctl() for one of these MT commands:

	MTREW MTOFFL MTRETEN MTERASE MTSEEK MTEOM

The user can't even relock the door unless one of the above commands 
was sent (again, if was_reset is still set).

The auto-relock in rw_checks() is never hit if was_reset is set.

Kai - should st.c (and osst.c?) be using scsi_ioctl(SCSI_IOCTL_DOORLOCK/UNLOCK)?

-- Patrick Mansfield
