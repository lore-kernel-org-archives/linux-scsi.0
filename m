From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Thu, 5 Apr 2012 14:00:57 +0800
Message-ID: <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
	<CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
	<CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 29, 2012 at 9:50 PM, Aaron Lu <aaron.lu@amd.com> wrote:

[.....]

> For the ODD to be put into suspend state, the conditions should be:
> 1 tray closed
> 2 no media inside
> I think we missed the condition 1 check now.
>
> And if we follow the two conditions, the events can be safely ignored.
>
> What do you think of blocking events for it when going to suspend and unblocking
> when resume? This could erase the unnecessary calls of the check events function
> when ODD is suspended.

Good idea.
Will try this.

> But disk_(un)block_events are not exported and can't be used in sr
> module. So I'm
> not sure how to do this.

We can simply export it.

>
> Another thing to consider is, user might want to eject the tray by
> software like the
> eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
> thinking how to do this correctly.

Assume eject /dev/sr0 is implemented as:

int fd = open("/dev/sr0", ...)
ioctl(fd, CDROMEJECT)

We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).

Thanks,
Lin Ming
