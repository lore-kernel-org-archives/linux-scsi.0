From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 17:47:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925004737.GC12650@beaverton.ibm.com>
References: <20020924233941.A9952@flint.arm.linux.org.uk> <200209242314.g8ONEHU02783@localhost.localdomain> <20020924232630.GD1330@beaverton.ibm.com> <20020925003335.D9952@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020925003335.D9952@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Russell King [rmk@arm.linux.org.uk] wrote:
> There is a trivial but required fix that I should backport from 2.5 to
> 2.4; that's the one that limits the number of command retries in
> scsi_error.c.  I'm not sure if Doug Ledford picked that one up though.
> Doug?

After I forward ported your restore code prior to retry I noticed
that the retry code did look correct. 

The 2.5 code copies the scsi_decide_disposition maybe_retry code block
into scsi_eh_completed_normally. While this function is similar to
decide_disposition it is called by scsi_send_eh_cmnd which is used both
for error_recovery cmds (TURs, etc) and retrying the command. The down
side here is that you get inconsistent and unexpected behavior in your
error_recovery commands depending on the retry allowed value of the
failed cmd and you also alter the retry count for the failed command.
The failed commands are also retried even if the user has said not to
(not a very nice thing to do a sequential  device).

I moved this check up higher. I also altered the retry code to not
exceed retries allowed.

I will try to post my update tomorrow, but it will not mean much to 2.4
as it is on top of the 2.5 cleanup which is very different from 2.4.

-andmike
--
Michael Anderson
andmike@us.ibm.com

