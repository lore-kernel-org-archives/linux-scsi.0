From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] libiscsi: avoid unnecessary multiple NULL assignments
Date: Mon, 13 Aug 2012 13:43:53 -0500
Message-ID: <50294AE9.10207@cs.wisc.edu>
References: <1344859172-31808-1-git-send-email-yamato@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53911 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2HMSoC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 14:44:02 -0400
In-Reply-To: <1344859172-31808-1-git-send-email-yamato@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 08/13/2012 06:59 AM, Masatake YAMATO wrote:
> In iscsi_free_task, NULL is assigned to task->sc twice: before and
> after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
> with session->lock, so multiple NULL assignments cause no trouble. But
> people reading the source code may be confused.
> 
> The second NULL assignment comes from commit:
> 
>     3e5c28ad0391389959ccae81c938c7533efb3490
> 
> It seems that the line after kfifo_in invocation was introduced
> accidentally.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Thanks for resending to the linux-scsi list and picking up my reviewed
by line. Looks ok to me.
