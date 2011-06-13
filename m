From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: linux-2.6.39 kernel panic issue when hot-plut disk during I/O
Date: Mon, 13 Jun 2011 12:15:43 -0700
Message-ID: <BANLkTi=7yhoSf2iWXikHRjSV_UhwQifvrw@mail.gmail.com>
References: <20110602234645.6352.38075.stgit@localhost6.localdomain6>
	<9CA988CDD3E54DBA829117B230B6F986@usish.com.cn>
	<F766E4F80769BD478052FB6533FA745D19FADEEADF@SC-VEXCH4.marvell.com>
	<4DE87A83.4090801@intel.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEB4F@SC-VEXCH4.marvell.com>
	<BANLkTinKGxN1TAfpK1gJ=Yc2wsVrtB250w@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D19FADEEEC5@SC-VEXCH4.marvell.com>
	<BANLkTi=xzvV+Gv0EY1GVNn+UAmrhr4-FMw@mail.gmail.com>
	<20110607213430.0081c9f3@stein>
	<F766E4F80769BD478052FB6533FA745D19FAE664A5@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1FMTPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 15:15:45 -0400
Received: by wya21 with SMTP id 21so3403547wya.19
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2011 12:15:44 -0700 (PDT)
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE664A5@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jack Wang <jack_wang@usish.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Lindar Liu <lindar_liu@usish.com>, Ankit Jain <jankit@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

[ copying Rafael as this appears to be getting into regression territor=
y ]

On Mon, Jun 13, 2011 at 12:21 AM, Xiangliang Yu <yuxiangl@marvell.com> =
wrote:
>
>
>>> > 2.6.39-rc4 work fine, but 2.6.39-rc5 has kernel panic.
>>>
>>> Still smells like a regression. =A0If you run a git bisect between =
those
>>> two versions it should be pretty straightforward to identify the
>>> offending commit. =A0There were some interesting block/scsi changes=
 in
>>> that window:
>>>
>>> Jens Axboe (5):
>>> =A0 =A0 =A0 block: kill blk_flush_plug_list() export
>> > =A0 =A0 =A0cfq-iosched: read_lock() does not always imply rcu_read=
_lock()
>> > =A0 =A0 =A0block: get rid of QUEUE_FLAG_REENTER
>> > =A0 =A0 block: remove stale kerneldoc member from __blk_run_queue(=
)
>> > =A0 =A0 =A0elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvp=
riv case too
>>>
>>> Liu Yuan (1):
>>> =A0 =A0 =A0 block, blk-sysfs: Fix an err return path in blk_registe=
r_queue()
>>>
>>> Tao Ma (1):
>>> =A0 =A0 =A0 block: Remove the extra check in queue_requests_store
>>>
>>> Tejun Heo (1):
>>> =A0 =A0 =A0 block: don't propagate unlisted DISK_EVENTs to userland
>
>>Or try linux 3.0-rc2 which as yet another block queue lifetime vs. ho=
tplug
>>fix (which is not yet available in a 2.6.39.y kernel).
>
> It still kernel panic.

In the same way?  So to recap all kernels prior to 2.6.39-rc4 do not
show this problem, and that you have individually tested v2.6.39-rc5
and 3.0-rc2 and the problem still exists, but that you don't know the
precise commit between 2.6.39-rc4 and 2.6.39-rc5 that causes the
problem?  I still think a bisect would be useful, and in the meantime
I'll see if this can be reproduced reliably with isci (but presently
isci has its own internal hotplug issues that are being worked).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
