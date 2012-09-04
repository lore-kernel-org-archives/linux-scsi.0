From: Dan Williams <djbw@fb.com>
Subject: Re: [resend PATCH] scsi_remove_target: fix softlockup regression on
 hot remove
Date: Tue, 4 Sep 2012 16:01:57 -0700
Message-ID: <CAA9_cmd8+jWh+WBb50RSJFziVCbvOmULNenjwceEnd0x3mzAmg@mail.gmail.com>
References: <20120829051119.26395.15980.stgit@localhost.localdomain>
	<503DBBA0.5060108@acm.org>
	<1346252361.27020.8.camel@localhost.localdomain>
	<CAEhu1-4EuoEUD9wCj_5aPa5zuSS+PB_R9hCEu3t2cqm3Q9HBPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34951 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2IDXB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 19:01:58 -0400
In-Reply-To: <CAEhu1-4EuoEUD9wCj_5aPa5zuSS+PB_R9hCEu3t2cqm3Q9HBPw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Drescher <drescherjm@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, JBottomley@parallels.com, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

On Tue, Sep 4, 2012 at 7:02 AM, John Drescher <drescherjm@gmail.com> wrote:
> On Wed, Aug 29, 2012 at 10:59 AM, Dan Williams <djbw@fb.com> wrote:
>> On Wed, 2012-08-29 at 06:50 +0000, Bart Van Assche wrote:
>>> On 08/29/12 05:12, Dan Williams wrote:
>>> > John reports:
>>> >  BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
>>> >  [..]
>>> >  Call Trace:
>>> >   [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
>>> >   [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
>>> >   [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
>>> >   [<ffffffff81421e35>] sas_port_delete+0x25/0x160
>>> >   [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270
>>> >
>>> > ...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".
>>>
>>> Including that call stack in the patch description may create the
>>> misleading impression that this only occurs with the mptsas driver. This
>>> lockup also happens with at least the iSCSI initiator. See also
>>> http://lkml.org/lkml/2012/8/24/340.
>>
>> I don't think it does that.  The title is pretty generic, but you're
>> right the impact is potentially all scsi_remove_target() users.
>>
>>> By the way, in order to get a patch in the stable tree the proper "Cc:"
>>> tag should be added in the patch description but the
>>> stable@vger.kernel.org e-mail address should be left out from the
>>> Cc-list of the e-mail with the patch.
>>
>> No, we talked about that at kernel summit.  It's ok for the stable@
>> alias to get a few extra mails.  The patch won't be applied until it
>> hits mainline and in the meantime it gives a heads up to the -stable
>> folks, or anyone that wants to follow up on stable patches making their
>> way to mainline.
>>
>
> It appears that this did not get into 3.6 rc4 (unless I am reading the
> changlog wrong). Do I have to file an official bug report to get this
> noticed?

I know James was travelling last week, and I think he wanted some more
time to look over the removal of the restart logic... but I think we
are ok.  Prior to commit 3b661a9 we had

       get_device(dev);
       device_for_each_child(dev, NULL, __remove_child);
       put_device(dev);

Where that device_for_each_child would not restart, but also would not
consider stargets that were not yet proper children of dev.  With the
fix we find all stargets and make sure to be immune to the regression
case where scsi_remove_target() is not the final source of
scsi_target_reap().

--
Dan
