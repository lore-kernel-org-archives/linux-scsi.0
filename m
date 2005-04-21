From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] drivers/scsi/st.c: decrement in_use under the lock in
 st_open
Date: Thu, 21 Apr 2005 19:40:18 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0504211920520.6548@kai.makisara.local>
References: <31176667.1114096111445.JavaMail.root@vms064.mailsrvcs.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:3552 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261512AbVDUQiN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 12:38:13 -0400
In-Reply-To: <31176667.1114096111445.JavaMail.root@vms064.mailsrvcs.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nate Dailey <nhdailey@verizon.net>
Cc: linux-scsi@vger.kernel.org

On Thu, 21 Apr 2005, Nate Dailey wrote:

> Hi, this patch changes the err_out case in st_open to decrement STp->in_use under the st_dev_arr_lock.
> 
> I'm just basing this on looking at the code (I didn't run into an actual 
> problem here), but it seems like the right thing to do; st_open and 
> release hold the lock when adjusting in_use in other places.
> 
I don't think it is necessary hold the lock when setting STp->in_use to 
zero. The problem is that the usage is not consistent in st. Either this  
patch should be included or the locking should be removed from st_release. 
I don't have any strong opinions about the best solution.

Thanks for pointing out this inconsistency.

-- 
Kai
