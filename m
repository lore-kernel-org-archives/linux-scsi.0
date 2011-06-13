From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during
 I/O
Date: Mon, 13 Jun 2011 00:21:46 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE664A5@SC-VEXCH4.marvell.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
	<9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
	<F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
	<4DE87A83.4090801@intel.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
	<BANLkTinKGxN1TAfpK1gJ=Yc2wsVrtB250w@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEEC5@SC-VEXCH4.marvell.com>
	<BANLkTi=xzvV+Gv0EY1GVNn+UAmrhr4-FMw@mail.gmail.com>
 <20110607213430.0081c9f3@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36955 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab1FMHYO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2011 03:24:14 -0400
In-Reply-To: <20110607213430.0081c9f3@stein>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Dan Williams <dan.j.williams@intel.com>
Cc: Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>> > 2.6.39-rc4 work fine, but 2.6.39-rc5 has kernel panic.
>> 
>> Still smells like a regression.  If you run a git bisect between those
>> two versions it should be pretty straightforward to identify the
>> offending commit.  There were some interesting block/scsi changes in
>> that window:
>> 
>> Jens Axboe (5):
>>       block: kill blk_flush_plug_list() export
> >      cfq-iosched: read_lock() does not always imply rcu_read_lock()
> >      block: get rid of QUEUE_FLAG_REENTER
> >     block: remove stale kerneldoc member from __blk_run_queue()
> >      elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too
>> 
>> Liu Yuan (1):
>>       block, blk-sysfs: Fix an err return path in blk_register_queue()
>> 
>> Tao Ma (1):
>>       block: Remove the extra check in queue_requests_store
>> 
>> Tejun Heo (1):
>>       block: don't propagate unlisted DISK_EVENTs to userland

>Or try linux 3.0-rc2 which as yet another block queue lifetime vs. hotplug
>fix (which is not yet available in a 2.6.39.y kernel).

It still kernel panic.
