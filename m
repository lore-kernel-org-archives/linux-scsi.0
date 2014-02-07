From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: Add 'retry_timeout' to avoid infinite command
 retry
Date: Thu, 06 Feb 2014 21:46:43 -0800
Message-ID: <1391752003.22335.67.camel@dabdike>
References: <52F30B5E.8020202@hitachi.com>
	 <20140207002241.11465.87367.stgit@ltc223.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140207002241.11465.87367.stgit@ltc223.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-02-07 at 09:22 +0900, Eiichi Tsukata wrote:
> Currently, scsi error handling in scsi_io_completion() tries to
> unconditionally requeue scsi command when device keeps some error state.
> For example, UNIT_ATTENTION causes infinite retry with
> action == ACTION_RETRY.
> This is because retryable errors are thought to be temporary and the scsi
> device will soon recover from those errors. Normally, such retry policy is
> appropriate because the device will soon recover from temporary error state.



> But there is no guarantee that device is able to recover from error state
> immediately. Actually, we've experienced an infinite retry on some hardware.
> Therefore hardware error can results in infinite command retry loop.

Could you please add an analysis of the actual failure; which devices
and what conditions.

> This patch adds 'retry_timeout' sysfs attribute which limits the retry time
> of each scsi command. This attribute is located in scsi sysfs directory
> for example "/sys/bus/scsi/devices/X:X:X:X/" and value is in seconds.
> Once scsi command retry time is longer than this timeout,
> the command is treated as failure. 'retry_timeout' is set to '0' by default
> which means no timeout set.

Don't do this ... you're mixing a feature (which you'd need to justify)
with an apparent bug fix.

Once you dump all the complexity, I think the patch boils down to a
simple check before the action switch in scsi_io_completion():

	if (action !=  ACTION_FAIL &&
	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
		action = ACTION_FAIL;
		description = "command timed out";
	}


James
