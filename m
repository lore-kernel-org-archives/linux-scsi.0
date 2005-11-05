From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.14
Date: Sat, 05 Nov 2005 13:25:00 -0500
Message-ID: <436CF8FC.5070906@pobox.com>
References: <1131207491.3614.5.camel@mulgrave>	 <Pine.LNX.4.64.0511050942490.3316@g5.osdl.org> <1131214408.3614.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040103030006050702040901"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932173AbVKESZK@vger.kernel.org>
In-Reply-To: <1131214408.3614.11.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040103030006050702040901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> Heh, they're all drwx--S--- 
> 
> I've had no end of strange trouble like this since I moved from my own
> version of git to the one installed on hera.
> 
> I think I've found and changed all the directories and verified the
> individual object permissions.  Could you try again?

With the latest git...

> [jgarzik@pretzel scsi-misc-2.6]$ git pull
> fatal: unexpected EOF
> Fetch failure: master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

Do you have standard permissions (chmod -R og+rX) on your repo, and, are 
you using rsync to push to kernel.org?

I've attached my rsync-based push script.  git people seem to dislike 
rsync, but this tends to work every time, for all users.

	Jeff



--------------040103030006050702040901
Content-Type: application/x-sh;
 name="push.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="push.sh"

#!/bin/sh

echo Updating server info...
git-update-server-info

echo Uploading...
rsync -e ssh --verbose --delete --stats --progress -az .git/ master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

--------------040103030006050702040901--
