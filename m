From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 15:41:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925154153.A8733@flint.arm.linux.org.uk>
References: <20020924233941.A9952@flint.arm.linux.org.uk> <200209242314.g8ONEHU02783@localhost.localdomain> <20020924232630.GD1330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17uDMQ-0004Ig-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 15:41:55 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17uDMQ-0002gl-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 15:41:54 +0100
Content-Disposition: inline
In-Reply-To: <20020924232630.GD1330@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Sep 24, 2002 at 04:26:30PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 04:26:30PM -0700, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > send it off to Marcelo and I'll try to up-port to 2.5
> 
> If you want me to I can add it to a patch bundle I already have that
> includes ports of Russell's previous changes that apply on top of my
> 2.5 scsi_error cleanup patch.

It'll probably be better to wait for me to say "ok, I'm happy, and sending
the stuff" before doing that.

I've just re-diffed and cleaned up all my scsi patches to date, and
split them up into logical blocks:

01-scsi-cmd-retry-1.diff
01-scsi-cmd-retry-2.diff
01-scsi-cmd-retry-3.diff
02-scsi-cmd-report.diff
03-scsi-restart-ops.diff
04-scsi-door-lock-1.diff
04-scsi-door-lock-2.diff

I've updated the command retry patches to catch a couple of re-setup
places I'd missed in scsi_error.c.

I've also incorporated Patricks concern about breaking out of the
restart loop when we hit a device with the "device_blocked" flag
set.  In this case, I think we should still call the request function;
the request function performs its own "device blocked" check, so putting
such a check here would just be a needless duplicate.

I'll put the patches up on ftp.linux.org.uk later today.

I'll also be asking Alan Cox at some point in the future if he'd mind
dropping them into his tree for further testing, before sending them
to Marcelo.

(Oh, and in case anyone hasn't realised yet, I'm not on linux-scsi.)

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

