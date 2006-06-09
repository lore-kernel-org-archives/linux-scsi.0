From: Michael Reed <mdr@sgi.com>
Subject: Re: fc transport creates second set of targets for devices in an
 "md"
Date: Fri, 09 Jun 2006 13:22:00 -0500
Message-ID: <4489BC48.9040208@sgi.com>
References: <448876C8.3090303@sgi.com> <44888134.70805@emulex.com> <4489A13C.9040602@sgi.com> <4489B9A5.5030104@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:48268 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751474AbWFISWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 14:22:04 -0400
In-Reply-To: <4489B9A5.5030104@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Michael Reed <mdr@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>

I tried using a mounted file system on a single device.  Same test,
disable / wait / enable.

There was no activity on the file system following the mount until
after the enable.

duck /root# ls /sdj1
 5:0:13:0: rejecting I/O to dead device
Buffer I/O error on device sdj1, logical block 516
Buffer I/O error on device sdj1, logical block 517
Buffer I/O error on device sdj1, logical block 518
Buffer I/O error on device sdj1, logical block 519
EXT3-fs error (device sdj1): ext3_readdir: directory #2 contains a hole at offset 0
Aborting journal on device sdj1.
 5:0:13:0: rejecting I/O to dead device
Buffer I/O error on device sdj1, logical block 0
lost page write due to I/O error on sdj1
ext3_abort called.
EXT3-fs error (device sdj1): ext3_journal_start_sb: Detected aborted journal
Remounting file system read-only


It would be really nice if the file system wouldn't be rendered
dead and require manual intervention following the scenario
of kicking a cable and plugging it back in after the dev_loss_tmo
expires.

I think I'm leaning toward wishing that the kernel could do a
better job of reconnecting devices following these little "accidents".

Mike



Michael Reed wrote:
> 
> Michael Reed wrote:
>> James Smart wrote:
>>> The data that would be most interesting is a recursive listing of the
>>> device via the /sys/devices tree.  This would show the host, rports,
>>> targets, and sdevs.  Getting a copy of this both before, when missing,
>>> and after they are reconnected. The additional contents to look at
>>> is : contents of /sys/class/fc_remote_ports.
>> I'll capture data and post later today.
>>
> 
> Attached.  ls_no_md.tar.bz2 and ls_with_md.tar.bz2
> 
> I noticed that more than just the devices associated with the
> md were reassigned in the ls_with_md.tar output.
> 
> Mike
