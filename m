From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mkdir: cannot create directory
 `/sys/kernel/config/target/iscsi': Invalid argument
Date: Fri, 16 Sep 2011 15:41:59 -0400
Message-ID: <1316202119.20864.25.camel@dabdike.cust.hotspot.t-mobile.com>
References: <loom.20110719T170144-482@post.gmane.org>
	 <4E7374B1.8040502@interlog.com>  <4E7381BF.7020802@interlog.com>
	 <1316201341.12820.370.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37534 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab1IPTmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2011 15:42:05 -0400
In-Reply-To: <1316201341.12820.370.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@risingtidesystems.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Jerome Martin <jxm@risingtidesystems.com>

On Fri, 2011-09-16 at 12:29 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2011-09-16 at 13:05 -0400, Douglas Gilbert wrote:
> > Well I can answer my own question.
> > configfs doesn't seem to be mounted at /sys/kernel/config
> > and even when it is, superuser cannot create a directory
> > there. So mount configfs somewhere else:
> > 
> > mount -t configfs none /tmp/config
> 
> This should actually be:
> 
> mount -t configfs configfs /sys/kernel/config

Well, not really; they're both equally valid.  For pseudo mounts which
have no underlying device, the standard

mount -t <type> <device> <mount point>

Convention has 'none' as the <device> because <device> is just ignored
by the kernel.  The only reason for not choosing 'none' is that the
error messages tend to use the <device> (which does go into the mtab),
so if you later try to umount and something is using the mount point you
can get a funny looking error message

none busy

However, most versions of umount have been fixed to report the <mount
point> instead, so even this potential issue is moot.

James


