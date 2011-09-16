From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: mkdir: cannot create directory
 `/sys/kernel/config/target/iscsi': Invalid argument
Date: Fri, 16 Sep 2011 12:29:01 -0700
Message-ID: <1316201341.12820.370.camel@haakon2.linux-iscsi.org>
References: <loom.20110719T170144-482@post.gmane.org>
	 <4E7374B1.8040502@interlog.com>  <4E7381BF.7020802@interlog.com>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47162 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1IPT3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 15:29:04 -0400
In-Reply-To: <4E7381BF.7020802@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, Jerome Martin <jxm@risingtidesystems.com>

On Fri, 2011-09-16 at 13:05 -0400, Douglas Gilbert wrote:
> Well I can answer my own question.
> configfs doesn't seem to be mounted at /sys/kernel/config
> and even when it is, superuser cannot create a directory
> there. So mount configfs somewhere else:
> 
> mount -t configfs none /tmp/config

This should actually be:

mount -t configfs configfs /sys/kernel/config

> 
> Then in reference to this page:
>    http://linux-iscsi.org/wiki/Target/configFS
> 
> change this line:
>    export TARGET=/sys/kernel/config/target/core/
> to
>    export TARGET=/tmp/config/target/core/
> then continue.
> 
> BTW The target infrastructure creates this noise in the log:
>    "Unable to load target_core_stgt"
> There is no such module that I can see.
> 
> 
> And I still can't do what I want: to use the target
> infrastructure to make a disk image in a file look
> like a SCSI device on the local machine. No iSCSI,
> SRP, FCxxx, SAS, UAS nor SOP ... just _SCSI_ !!
> 

I just sent an email off-list with the various wiki pointers to tcm_loop
for local SCSI LLD device access.

Using the rtsadmin shell is definately the easiest way to configure
target core backends and tcm_loop target ports.  Installing this from
www.risingtidesystems.com/git source is still a bit challenging atm, but
we'd be happy to send you an rtsadmin-frozen build offlist for your own
use.  Please let us know if you prefer rpm or debs.  ;)

--nab

