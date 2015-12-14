From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] be2iscsi: Fix WRB leak in login/logout path
Date: Mon, 14 Dec 2015 16:27:35 +0100
Message-ID: <566EDFE7.3070701@suse.de>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-9-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbbLNP1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 10:27:36 -0500
In-Reply-To: <1450073466-21077-9-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/14/2015 07:11 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> Login/Logout loop was hanging after few hours. /var/log/message showe=
d
> that alloc_wrb_handle() function was not able to allocate any new WRB=
=2E
>
> Sep 11 11:25:22 Jhelum10 kernel: connection32513:0: Could not send no=
pout
> Sep 11 11:25:22 Jhelum10 kernel: scsi host10: BM_4989 : Alloc of WRB_=
HANDLE
> Failedfor the CID : 384
> Sep 11 11:25:22 Jhelum10 kernel: connection32513:0: Could not allocat=
e pdu
> for mgmt task.
>
> Driver allocates WRB to pass login negotiated parameters information =
to FW
> in beiscsi_offload_connection(). This allocated WRB was not freed so =
there
> was WRB_Leak happening.
>
> Put WRB used for posting the login-negotiated parameters back in pool=
=2E
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |   72 ++++++++++++++++++++++++++--=
----------
>   1 files changed, 49 insertions(+), 23 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
