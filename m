From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] m68k/atari - convert atari_scsi falcon_get_lock() to use wait_event()
Date: Sat, 1 Mar 2014 12:53:56 +0100
Message-ID: <201403011253.56831.arnd@arndb.de>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org> <1393660265-19384-2-git-send-email-schmitz@debian.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.24]:59963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaCALyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2014 06:54:03 -0500
In-Reply-To: <1393660265-19384-2-git-send-email-schmitz@debian.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-m68k@vger.kernel.org, geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, Michael Schmitz <schmitz@debian.org>

On Saturday 01 March 2014, Michael Schmitz wrote:
> 
> sleep_on is known broken and going away. The atari_scsi driver is one of
> two remaining users in the falcon_get_lock() function, which is a rather
> crazy piece of code. This does not attempt to fix the driver's locking
> scheme in general, but at least prevents falcon_get_lock from going to
> sleep when no other thread holds the same lock or tries to get it,
> and we no longer schedule with irqs disabled.
> 
> MSch: fixed completion conditions missed in Arnds' original RFC patch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Michael Schmitz <schmitz@debian.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org

Thanks a lot for taking care of this so quickly!

A minor note about patch processing: The normal way to forward
a patch from another person is to add your 'Signed-off-by:' line
below the one from the original submitter, i.e. in the place where
you have the 'Acked-by:'. Not sure if you just forgot to update
your patch or you weren't aware of that. Geert will be able to
fix that when he adds his own Signed-off-by line.

Also if you want to preserve authorship of the patch, you can add
as the first line before the description a line 'From: Arnd Bergmann
<arnd@arndb.de>'. Since you modified most the lines I originally
changed and the patch is very small, I don't care about having
me listed as the author, it's absolutely ok to have you listed here,
just explaining it here in case you intended differently.

	Arnd
