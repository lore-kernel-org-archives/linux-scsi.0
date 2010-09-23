From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 4/7] fc class: don't return from fc_block_scsi_eh
 until IO has been cleaned up
Date: Thu, 23 Sep 2010 00:47:00 -0500
Message-ID: <4C9AE9D4.4020305@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu> <1285219045-14645-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52634 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0IWFlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:41:07 -0400
In-Reply-To: <1285219045-14645-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 09/23/2010 12:17 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> If a lld does:
>
>          ret = fc_block_scsi_eh(cmnd);
>          if (ret)
>                  return ret;
>
> in the eh callbacks, then it could cause the following race:
>
> 1 the LLD will call fc_block_scsi_eh from the scsi eh thread.
> 2 From the FC class thread, the fast io fail tmo will fire and set
> FC_RPORT_FAST_FAIL_TIMEDOUT, then begin to call terminate_rport_io.
> 3 The scsi eh thread and the LLD will then break from the
> fc_block_scsi_eh block and will return FAST_IO_FAIL.
> 4 The scsi eh will then assume it owns the command and will start to
> process it. It will call scsi_eh_flush_done_q which might fail it or
> retry it.
> 5 But then in the FC class thread, the LLD terminate_rport_io callback
> could be processing the IO and possibly accessing a scsi_cmnd struct
> that the scsi eh thread has now started to retry or failed and
> reallocated to a new request in #4.
>
> This patch has fc_block_scsi_eh wait until the terminate_rport_io
> callback has completed before returning. This allows LLDs to not
> have to worry about the race.
>

I think this is not going to work. It looks like for drivers like lpfc 
and even qla2xxx in the ISP_ABORT case, because even after 
terminate_rport_io has completed the driver can still touch the scsi_cmnd.
