From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: 2.4.x end of tape handling error
Date: Sun, 2 Mar 2003 21:26:51 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0303022118510.2029@kai.makisara.local>
References: <mailman.1044901620.21591.linux-kernel2news@redhat.com>
 <200302101904.h1AJ4US05141@devserv.devel.redhat.com> <20030218021039.28335.qmail@scrye.com>
 <20030224235355.30878.qmail@scrye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030224235355.30878.qmail@scrye.com>
List-Id: linux-scsi@vger.kernel.org
To: Kevin Fenzi <kevin-linux-kernel@scrye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 24 Feb 2003, Kevin Fenzi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> Some more information on this problem discovered by Tim Jones
> <tjones@tolisgroup.com>:
>
> Tim> Additional news.
>
> Tim> This is actually related to the check sense bit not being
> Tim> propagated up to the ST driver.  A simpler test (beats writing
> Tim> 40GB to a tape ...):
>
...
> Tim> This is caused by the check sense not being set and the ST driver
> Tim> sending up a EIO instead of the ENOMEDIUM.
>
> So, it looks like this problem is _not_ in the st driver itself, but
> somewhere in the SCSI layer.
>
> Anyone have any ideas how to better track it down?
>
> Happy to run debug code/test cases here.
>
If you enable debugging in the st driver, it prints on the
console(dmesg)/system log the sense data it gets. (To enable debugging,
edit the st source to '#define DEBUG 1' and recompile the kernel/module).

The st driver does in some cases behave too conservatively when the EOT
early warning is found. This happens when operating in fixed block mode
and only with some drives. The drives I use for testing behave in a
different way and that is why I have not seen this problem (tracked
down with debugging output from one kind user). I have a fix ready but
testing will still take some time. This problem is not seen when
asynchronous writes and driver buffering are disabled (as suggested in
README.st when trying to rely on EOT detection).

	Kai
