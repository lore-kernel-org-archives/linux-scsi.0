From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 0/6] add large command support to the block layer
Date: Tue, 29 Apr 2008 13:55:13 +0200
Message-ID: <58cb370e0804290455m3892d5efi6ab293075f8277ca@mail.gmail.com>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20080429075424.GF12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:15697 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYD2LzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 07:55:16 -0400
Received: by fk-out-0910.google.com with SMTP id 19so6091856fkr.5
        for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 04:55:14 -0700 (PDT)
In-Reply-To: <20080429075424.GF12774@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Tue, Apr 29, 2008 at 9:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Sat, Apr 26 2008, FUJITA Tomonori wrote:
>  > This is an updated patchset for large command support to the block
>  > layer:
>  >
>  > http://marc.info/?l=linux-scsi&m=120817127118449&w=2
>  >
>  > We rarely handle large commands. So for optimization, a struct request
>  > still has a static array for a command. rq_init sets rq->cmd pointer
>  > to the static array. In short, rq_init() does
>  >
>  > rq->cmd = rq->__cmd;
>  >
>  > So we can access to rq->cmd and rq->cmd_len as before.
>  >
>  > This change requires everyone to initialize the request in a proper
>  > way (that is, just doing a memset() will not work). Now we have
>  > rq_init() that works for any path so this patchset can cleanly convert
>  > users of requests on the stack or kmalloced requests to use it (the
>  > previous patchset does it in a hacky way):
>  >
>  > http://marc.info/?l=linux-scsi&m=120911792725876&w=2
>  >
>  > This patchset is against Jens' for-linus branch.
>  >
>  > #1-#4 patches can be applied via Jens' tree now. #5 patch is for
>  > IDE. It cleanly can be applied to both Bart's latest quilt tree and
>  > Jens' tree though Bart's quilt tree has some pending IDE patches. #4
>  > patch depends on #4. #6 patch depends on #1-#5.
>  >
>  > I guess that the easiest way to apply this patchset would be:
>  >
>  > 1. Pushing Bart's quilt tree to mainline.
>  > 2. Rebasing Jens' tree to mainline.
>  > 3. Pushing this patchset via Jens' tree.
>  >
>  > Jens and Bart, let me know if I can do something to make the process
>  > easier.
>  >
>  > Bart, I will try to push the patchset to remove the requests on the
>  > stack for 2.6.27:
>  >
>  > http://marc.info/?l=linux-ide&m=120882410712466&w=2
>
>  I've applied all patches to the for-linus branch, it should go up
>  soonish. If anyone has problems with this, please holler SOON.

Fine with me (patches look good and survived quick testing).

My only concern is that the final series from Tomo lacked

	"block: replace sizeof(rq->cmd) with BLK_MAX_CDB"

and it is also not in for-linus branch (it has to be merged
before "block: add large command support" patch or ide-cd
will break).

Thanks,
Bart
