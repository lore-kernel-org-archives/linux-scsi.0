From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath test scripts
Date: Fri, 19 Feb 2016 14:42:17 -0500
Message-ID: <20160219194216.GB21133@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
 <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993452AbcBSTmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 14:42:18 -0500
Content-Disposition: inline
In-Reply-To: <56C6D45A.6060407@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 19 2016 at  3:37am -0500,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 02/19/16 09:33, Nomura Junichi wrote:
> > On 02/19/16 02:17, Mike Snitzer wrote:
> >> What is the last kernel version that your scripts have worked on?
> > 
> > v4.4 worked fine. I'll check with v4.5-rc4 when I get a machine.
> 
> v4.5-rc4 works fine, too.

Have you been running with blk-mq?
Either by setting CONFIG_DM_MQ_DEFAULT or:
echo Y > /sys/module/dm_mod/parameters/use_blk_mq

I'm seeing test_02_sdev_delete fail with blk-mq enabled.

(and with my latest DM mpath code I'm testing for Linux 4.6: I'm seeing
a nasty deadlock from test_01_sdev_offline... so that's "fun")

> So if all tests fail for you, it might be due to difference in
> environment or kernel config.

After upgrading fio to latest fio.git I no longer see fio validate
errors.

> I'm running tests on RHEL7.2 and kernel config is based on RHEL7 kernel.
> 
> # rpm -q targetcli
> targetcli-2.1.fb41-3.el7.noarch
> # cp /boot/config-3.10.0-327.el7.x86_64 .config
> # make olddefconfig
> ...

Yes, I'm using a comparable setup.  But with localmodconfig.
