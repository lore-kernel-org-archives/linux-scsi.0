From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [resend PATCH] scsi_remove_target: fix softlockup regression
 on hot remove
Date: Wed, 29 Aug 2012 06:50:08 +0000
Message-ID: <503DBBA0.5060108@acm.org>
References: <20120829051119.26395.15980.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:60064 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2H2GuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2012 02:50:14 -0400
In-Reply-To: <20120829051119.26395.15980.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: JBottomley@parallels.com, John Drescher <drescherjm@gmail.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

On 08/29/12 05:12, Dan Williams wrote:
> John reports:
>  BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
>  [..]
>  Call Trace:
>   [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
>   [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
>   [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
>   [<ffffffff81421e35>] sas_port_delete+0x25/0x160
>   [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270
> 
> ...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".

Including that call stack in the patch description may create the
misleading impression that this only occurs with the mptsas driver. This
lockup also happens with at least the iSCSI initiator. See also
http://lkml.org/lkml/2012/8/24/340.

By the way, in order to get a patch in the stable tree the proper "Cc:"
tag should be added in the patch description but the
stable@vger.kernel.org e-mail address should be left out from the
Cc-list of the e-mail with the patch.

Bart.

