From: Dan Williams <djbw@fb.com>
Subject: Re: [resend PATCH] scsi_remove_target: fix softlockup regression on
 hot remove
Date: Wed, 29 Aug 2012 07:59:21 -0700
Message-ID: <1346252361.27020.8.camel@localhost.localdomain>
References: <20120829051119.26395.15980.stgit@localhost.localdomain>
	 <503DBBA0.5060108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34464 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659Ab2H2O7p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Aug 2012 10:59:45 -0400
In-Reply-To: <503DBBA0.5060108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: JBottomley@parallels.com, John Drescher <drescherjm@gmail.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

On Wed, 2012-08-29 at 06:50 +0000, Bart Van Assche wrote:
> On 08/29/12 05:12, Dan Williams wrote:
> > John reports:
> >  BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
> >  [..]
> >  Call Trace:
> >   [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
> >   [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
> >   [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
> >   [<ffffffff81421e35>] sas_port_delete+0x25/0x160
> >   [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270
> > 
> > ...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".
> 
> Including that call stack in the patch description may create the
> misleading impression that this only occurs with the mptsas driver. This
> lockup also happens with at least the iSCSI initiator. See also
> http://lkml.org/lkml/2012/8/24/340.

I don't think it does that.  The title is pretty generic, but you're
right the impact is potentially all scsi_remove_target() users.

> By the way, in order to get a patch in the stable tree the proper "Cc:"
> tag should be added in the patch description but the
> stable@vger.kernel.org e-mail address should be left out from the
> Cc-list of the e-mail with the patch.

No, we talked about that at kernel summit.  It's ok for the stable@
alias to get a few extra mails.  The patch won't be applied until it
hits mainline and in the meantime it gives a heads up to the -stable
folks, or anyone that wants to follow up on stable patches making their
way to mainline.

--
Dan


