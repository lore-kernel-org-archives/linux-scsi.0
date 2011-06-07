From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Tue, 7 Jun 2011 11:57:12 -0700
Message-ID: <BANLkTi=xzvV+Gv0EY1GVNn+UAmrhr4-FMw@mail.gmail.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
	<9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
	<F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
	<4DE87A83.4090801@intel.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
	<BANLkTinKGxN1TAfpK1gJ=Yc2wsVrtB250w@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEEC5@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1FGS5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2011 14:57:13 -0400
Received: by wwa36 with SMTP id 36so5254476wwa.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jun 2011 11:57:12 -0700 (PDT)
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FADEEEC5@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jun 6, 2011 at 8:32 PM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
>>>>Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
>>>
>>>>On 6/2/2011 8:27 PM, Xiangliang Yu wrote:
>>>>> Hi, all
>>>>> I upgrade kernel version to 2.6.39 and find out a kernel panic when I test the MVSAS driver: kernel panic if hot-plug disk during I/O. But the driver is OK in version 2.6.37
>>>
>>>>If it is a stable reproduction can you bisect it?
>>> What I use is latest kernel version (2.6.39).
>
>>Right, if the driver consistently fails in 2.6.39 and runs fine in
>>2.6.37 then you can use git bisect [1] to possibly find the commit
>>that broke things.
>>
>>git bisect start
>>git bisect bad v2.6.39
>>git bisect good v2.6.37
>><run test>
>>git bisect good/bad depending on test results.
>
>>Although you might try 2.6.38 first to cut down on the number of
>>kernels you need to test.
>
> 2.6.39-rc4 work fine, but 2.6.39-rc5 has kernel panic.

Still smells like a regression.  If you run a git bisect between those
two versions it should be pretty straightforward to identify the
offending commit.  There were some interesting block/scsi changes in
that window:

Jens Axboe (5):
      block: kill blk_flush_plug_list() export
      cfq-iosched: read_lock() does not always imply rcu_read_lock()
      block: get rid of QUEUE_FLAG_REENTER
      block: remove stale kerneldoc member from __blk_run_queue()
      elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Tao Ma (1):
      block: Remove the extra check in queue_requests_store

Tejun Heo (1):
      block: don't propagate unlisted DISK_EVENTs to userland

--
Dan
