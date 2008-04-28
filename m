From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 12:08:46 -0600
Message-ID: <20080428180846.GX14990@parisc-linux.org>
References: <20080428174742.163523860@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34944 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020AbYD1SIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 14:08:47 -0400
Content-Disposition: inline
In-Reply-To: <20080428174742.163523860@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@mvista.com>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Mon, Apr 28, 2008 at 10:47:42AM -0700, Daniel Walker wrote:
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

I did this one too ... my version had a nice little twist.

> @@ -2813,7 +2814,7 @@ qla2x00_request_firmware(scsi_qla_host_t
>  		blob = &qla_fw_blobs[FW_ISP25XX];
>  	}
>  
> -	down(&qla_fw_lock);
> +	mutex_lock(&qla_fw_lock);
>  	if (blob->fw)
>  		goto out;
>  

This one we can do as:

-       down(&qla_fw_lock);
+       if (mutex_lock_killable(&qla_fw_lock))
+               return NULL;
+


Otherwise, I think our patches are bit-for-bit identical.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
