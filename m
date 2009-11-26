From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: BUG at scsi_lib.c:1108 [Was: mmotm 2009-11-24-16-47 uploaded]
Date: Thu, 26 Nov 2009 12:17:02 +0200
Message-ID: <4B0E559E.8020309@panasas.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>	<4B0D4949.4090109@gmail.com>	<1259162399.2535.8.camel@mulgrave.site>	<4B0D9221.2050103@gmail.com> <20091126081359.414c8216@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22781 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759332AbZKZKRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2009 05:17:00 -0500
In-Reply-To: <20091126081359.414c8216@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On 11/25/2009 11:13 PM, Neil Brown wrote:
> On Wed, 25 Nov 2009 21:22:57 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> It doesn't make sense at all. How can empty merge cause a regression?
>> And md/for-next doesn't produce the BUG.
> 
> I've hit that situation before.  Two separate changes in separate
> branches conspire to cause a problem.
> 
> md/for-next contains code to handle barriers properly for all levels,
> not just RAID1.
> It is possible I got this wrong in some way, and some new sanity check
> in a separate branch is firing, or it is possible some other bug in
> barrier handling has been added and now that MD sends barriers, it is
> being triggered.
> 
> What I did to find the actual offending patches is to got to one of the
> heads just before the merge, and cherry-pick all the patches from the
> other branch, and then bisect that.
> 

cherry-pick is hard work.
Stand on the merge point and do:
git rebase -i HEAD^

That will cherry-pick all these for you in one easy command ;-)

Boaz
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

