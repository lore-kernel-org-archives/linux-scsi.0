From: Douglas Gilbert <dougg@torque.net>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Wed, 18 Dec 2002 23:14:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E006692.7020503@torque.net>
References: <3DFE998E.1080103@interlog.com> <20021217114730.GE7990@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

Willem Riede wrote:
 > <snip/>
> 
> I'll also see if I can find what the remaining problems are. I'd also be
> prepared do do "cleaning up" of ide-scsi -- what in your opinion needs
> taking care of?

Willem,
ide-scsi in lk 2.5 ...
a) needs .eh_bus_reset_handler defined in idescsi_template
    and implemented. It probably would be a dummy unless there
    is a clean way to do an ATAPI bus (or device) reset.
b) replace .detect and .release in idescsi_template with the
    slave_alloc, slave_configure and slave_destroy interface

These are documented in Documentation/scsi/scsi_mid_low_api.txt .
If you find mistakes or the explanation is not clear then
complain to me. For an example of the use of these new
interfaces see scsi_debug.c or aic7xxx_old.c

Good to see that you have fixed the ide sysfs de-registration
problem.

Doug Gilbert






