From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during
 I/O
Date: Tue, 7 Jun 2011 21:34:30 +0200
Message-ID: <20110607213430.0081c9f3@stein>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
	<9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
	<F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
	<4DE87A83.4090801@intel.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
	<BANLkTinKGxN1TAfpK1gJ=Yc2wsVrtB250w@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEEC5@SC-VEXCH4.marvell.com>
	<BANLkTi=xzvV+Gv0EY1GVNn+UAmrhr4-FMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44706 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1FGTfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2011 15:35:41 -0400
In-Reply-To: <BANLkTi=xzvV+Gv0EY1GVNn+UAmrhr4-FMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Jun 07 Dan Williams wrote:
> On Mon, Jun 6, 2011 at 8:32 PM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> > 2.6.39-rc4 work fine, but 2.6.39-rc5 has kernel panic.
> 
> Still smells like a regression.  If you run a git bisect between those
> two versions it should be pretty straightforward to identify the
> offending commit.  There were some interesting block/scsi changes in
> that window:
> 
> Jens Axboe (5):
>       block: kill blk_flush_plug_list() export
>       cfq-iosched: read_lock() does not always imply rcu_read_lock()
>       block: get rid of QUEUE_FLAG_REENTER
>       block: remove stale kerneldoc member from __blk_run_queue()
>       elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too
> 
> Liu Yuan (1):
>       block, blk-sysfs: Fix an err return path in blk_register_queue()
> 
> Tao Ma (1):
>       block: Remove the extra check in queue_requests_store
> 
> Tejun Heo (1):
>       block: don't propagate unlisted DISK_EVENTs to userland

Or try linux 3.0-rc2 which as yet another block queue lifetime vs. hotplug
fix (which is not yet available in a 2.6.39.y kernel).
-- 
Stefan Richter
-=====-==-== -==- --===
http://arcgraph.de/sr/
