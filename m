From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath test scripts
Date: Thu, 18 Feb 2016 12:17:45 -0500
Message-ID: <20160218171745.GA15071@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946487AbcBRRRq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 12:17:46 -0500
Content-Disposition: inline
In-Reply-To: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Oct 07 2015 at  1:39am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> This is a set of scripts for kernel-side dm-multipath testing. Current
> set of scripts are stress testing of extreme situation and its coverage
> is limited. But recently found dm-mpath regressions should be detectable
> with this. I hope this helps people working on dm-multipath related code
> as a regression test set.
> 
> Though this is created as a patch for linux kernel source, it's just for
> convenience of kernel developers (I don't have a place to host this kind
> of scripts). If there are better place to contribute this, please let me know.
> 
> Please check README for how-to-run and possible improvements you could
> contribute in future.

I finally got around to trying these scripts.  Thanks for making them
available.

But unfortunately I cannot get either the scsidebug or tcmloop mode to
run against v4.5-rc4

For tcmloop, targetcli fails with:
"Could not create ISCSIFabricModule in configFS."
(fixed by enabling CONFIG_ISCSI_TARGET under TARGET_CORE)

I'm seeing all tests fail due to fio verification failure.  I'll need to
inspect this further..

But the most problematic test is ./tests/test_03_dm_failpath -- it seems
to actively break _any_ v4.5-rc kernel I try (with a never-ending flood
of messages like "device-mapper: multipath: Failing path 8:192."); I
haven't tried older kernels.

What is the last kernel version that your scripts have worked on?

Taking a step back:
These scripts don't belong in Documentation/device-mapper/mptest/ (or
anywhere in the kernel tree for that matter).

I'd really prefer it if we could port your scripts over to the
device-mapper-test-suite, see:
https://github.com/jthornber/device-mapper-test-suite

Mike
