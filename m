From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 2 Aug 2016 17:19:11 -0700
Message-ID: <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
References: <a5c1a149-b1a2-b5a4-2207-bdaf32db3cbd@sandisk.com>
 <757522831.7667712.1470059860543.JavaMail.zimbra@redhat.com>
 <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
 <931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
 <1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
 <17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
 <20160801175948.GA6685@redhat.com>
 <f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
 <20160801204628.GA94704@redhat.com>
 <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
 <20160802174533.GA18714@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:38352
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753725AbcHCATV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 20:19:21 -0400
In-Reply-To: <20160802174533.GA18714@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/02/2016 10:45 AM, Mike Snitzer wrote:
> Please do these same tests against a v4.7 kernel with the 4 patches from
> this branch applied (no need for your other debug patches):
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7-mpath-fixes
> 
> I've had good results with my blk-mq SRP based testing.

Hello Mike,

Thanks again for having made these patches available. The results of my
tests are as follows:

(1) CONFIG_DM_MQ_DEFAULT=y, fio running on top of xfs

The first simulated cable pull caused the following messages to appear:

[  428.716566] mpath 254:1: queue_if_no_path 1 -> 0
[  428.729671] __multipath_map(): (a) returning -5
[  428.729730] map_request(): clone_and_map_rq() returned -5
[  428.729788] dm_complete_request: error = -5
[  428.729846] dm_softirq_done: dm-1 tio->error = -5
[  428.729904] blk_update_request: 880 callbacks suppressed
[  428.729970] blk_update_request: I/O error (-5), dev dm-1, sector 2097024

(2) CONFIG_DM_MQ_DEFAULT=y, fio running on top of ext4

The first simulated cable pull caused the following messages to appear:

[  162.894737] mpath 254:0: queue_if_no_path 0 -> 1
[  162.903155] executing DM ioctl DEV_SUSPEND on mpathbe
[  162.903207] mpath 254:0: queue_if_no_path 1 -> 0
[  162.903255] device-mapper: multipath: must_push_back: queue_if_no_path=0 suspend_active=1 suspending=0
[  162.903256] __multipath_map(): (a) returning -5
[  162.903257] map_request(): clone_and_map_rq() returned -5
[  162.903258] dm_complete_request: error = -5
[  162.903259] dm_softirq_done: dm-0 tio->error = -5
[  162.903261] blk_update_request: I/O error (-5), dev dm-0, sector 263424
[  162.903284] Buffer I/O error on dev dm-0, logical block 32928, lost sync page write

(3) CONFIG_DM_MQ_DEFAULT=n, fio running on top of xfs

This test passed once but on the second run fio reported "bad magic header" after
a large number of iterations. I'm still analyzing the logs.

(4) CONFIG_DM_MQ_DEFAULT=n, fio running on top of ext4

Ran this test three times. The first two runs passed but during the third run
fio reported again I/O errors and I found the following in the kernel log:

[  954.048860] __multipath_map(): (a) returning -5
[  954.048861] map_request(): clone_and_map_rq() returned -5
[  954.048862] dm_complete_request: error = -5
[  954.048870] dm_softirq_done: dm-0 tio->error = -5
[  954.048873] blk_update_request: 15 callbacks suppressed
[  954.048874] blk_update_request: I/O error (-5), dev dm-0, sector 159976

Bart.
