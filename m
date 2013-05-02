From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH V2 16/18] be2iscsi: Fix possible reentrancy issue in
 be_iopoll
Date: Thu, 2 May 2013 15:20:48 +0000
Message-ID: <1367508048.3133.2.camel@dabdike>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
	 <1365219519-3457-16-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54285 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759940Ab3EBPUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 11:20:52 -0400
In-Reply-To: <1365219519-3457-16-git-send-email-jayamohan.kallickal@emulex.com>
Content-Language: en-US
Content-ID: <6651C9C69F412A40839CF856E97AE358@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Shlomo Pongratz <shlomop@mellanox.com>

On Fri, 2013-04-05 at 20:38 -0700, Jayamohan Kallickal wrote:
> From: Shlomo Pongratz <shlomop@mellanox.com>
> 
>  The driver creates "NAPI" context per core which is fine,
>  however the above routine declares the ret variable as static!
>  Thus there is only one instance of this variable!
>  When this routine is called from more than one thread of execution,
>  than the result is unpredictable.
> 
>          static unsigned int ret;
>          .....
> 
>          ret = beiscsi_process_cq(pbe_eq);
>                  <--------Another thread can enter here and change "ret".
>          if (ret < budget) {
>                 ....
>          }
>                  <--------Another thread can enter here and change "ret".
>          return ret;
> 
>  Fix - remove the "static"
> 
> Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
> Acked-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

The rule here is that this needs to be Signed-off-by: from you because
you sent the patch to me (signoffs follow the transmission path for the
patch).  If you just see the patch on the list and want me to apply it,
you give me an Acked-by, but if you actually pick the patch up and send
it to me it must have a signed-off-by.

I assumed your consent and changed the tag.

James

