From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/3] update bidirectional series to sit on top of sg_table
Date: Wed, 23 Jan 2008 12:05:50 +0200
Message-ID: <4797117E.6000205@panasas.com>
References: <1200107340.3286.79.camel@localhost.localdomain> <20080123012913Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33551 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYAWKHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 05:07:23 -0500
In-Reply-To: <20080123012913Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, dougg@torque.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Jens.Axboe@oracle.com, Pete Wyckoff <pw@osc.edu>

On Tue, Jan 22 2008 at 18:31 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: [PATCH 0/3] update bidirectional series to sit on top of sg_table
> Date: Fri, 11 Jan 2008 21:09:00 -0600
> 
>> OK, I suppose in the scheme of things, it's my turn to bear some of the
>> pain.  the SCSI bidirectional series rejects pretty badly with sg_table,
>> and since sg_table has to go in, I rebased the series on top of it.
>>
>> Additionally, I tidied up the patches to take advantages of some of the
>> features of sg_table.  I killed both use_sg and sg_count in favour of
>> using sg_table.nseg for the count.
>>
>> Just so you can test all of this to make sure I got it right, you can
>> pull the patch series from
>>
>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-bidi-2.6.git
> 
> I've just started to look at the bidi tree.
> 
> I suppose that only panasas guys have tested the bidi tree with their
> OSD target devices. To test the bidi tree, 

OSD Yes, but not only Panasas guys. Pete Wyckoff is doing bidi threw bsg
to an OSD scsi_tgt target. And Seagate guys have an OSD device they use
also threw bsg. In Panasas we used IBM's OSD-Initiator and now our own
osd_lib, an in kernel only library that will be part of the Objects-layout
drivers for pNFS.

> I added XDWRITEREAD_10
> support to scsi_debug and sgv4_xdwriteread tool to my makeshift bsg
> tool collections:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git
> 
> It just sends XDWRITEREAD_10 commands like this:
> 
> tulip:~# sgv4_xdwriteread --length 16384 /sys/class/bsg/1:0:0:0
> driver:0, transport:0, device:0, din_resid: 0, dout_resid: 0
> 
> No errors.
> 
> I'll send the patchset (over the bidi tree) to add XDWRITEREAD_10
> support to scsi_debug though I'm not sure whether it's worth adding it
> to mainline.
> -

Thanks TOMO, I think this is most valuable contribution, because now
programmers have a most simple setup they can put up, to make sure they
did not break, also the bidi path. And not need to setup the complete
OSD stack for that. Also it is a very good reference implementation
for drivers that want to support XDWRITEREAD_10. I bet the raid guys
will love it.

So Thanks
Boaz
