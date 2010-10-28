From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH 1/2] libfc: fix mem leak in fc_tm_done()
Date: Wed, 27 Oct 2010 18:18:21 -0700
Message-ID: <1288228701.1431.44.camel@fritz>
References: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab0J1BS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 21:18:27 -0400
In-Reply-To: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Mon, 2010-10-25 at 20:37 +0800, Hillf Danton wrote:
> There seems frame should get freed against memory leakage.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_fcp.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_fcp.c	2010-10-25 20:31:04.000000000 +0800
> @@ -1294,6 +1294,7 @@ static void fc_tm_done(struct fc_seq *se
>  	 */
>  	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
>  		spin_unlock_bh(&fsp->scsi_pkt_lock);
> +		fc_frame_free(fp);
>  		return;
>  	}
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> http://www.open-fcoe.org/mailman/listinfo/devel

Hi Hillf,

   I'm not sure how you're generating your patches, but it seems that
many of them (not sure if it's all) do not have a trailing whitespace
line. So, when I try to apply the patch either using 'patch' or 'git-am'
it sees the first line of the mailing list footer as part of the patch.
So the, "____________________" line is considered part of the patch and
it causes the application of the patch to fail. Here's what happens when
I try to apply the mbox for this patch.

rwlove@fritz:/var/testspace/open-fcoe-initiator$ git-am
~/Desktop/1-2-libfc-fix-mem-leak-in-fc_tm_done.patch 
Applying: libfc: fix mem leak in fc_tm_done()
fatal: corrupt patch at line 16
Patch failed at 0001 libfc: fix mem leak in fc_tm_done()
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
rwlove@fritz:/var/testspace/open-fcoe-initiator$ patch -p1 --dry-run
< .git/rebase-apply/0001 
patching file drivers/scsi/libfc/fc_fcp.c
patch: **** malformed patch at line 28:
_______________________________________________


   I'm not a patch formatting expert, but I think the lack of a
whitespace line at the end of the changes is the problem.

   I'd suggest mailing the patch to yourself first and then try applying
the mbox with 'git-am', if that works then everything should be fine.

   Also, I like to use stgit to generate and mail patches. Everyone has
their own development process, but I want to point that tool out to you
because it will take care of all of the formatting for you.

Thanks, //Rob

