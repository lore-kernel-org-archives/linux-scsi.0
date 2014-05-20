From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Tue, 20 May 2014 10:40:05 +0200
Message-ID: <537B14E5.2090100@redhat.com>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org> <537B04F5.4080808@acm.org> <537B0E05.80308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaETJMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 05:12:06 -0400
In-Reply-To: <537B0E05.80308@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>

Il 20/05/2014 10:10, Bart Van Assche ha scritto:
> REQ_ATOM_COMPLETE is already set before scsi_eh_scmd_add() is called
> since that function is only invoked after the block layer has marked a
> request as "complete". The only callers of scsi_eh_scmd_add() are
> scsi_softirq_done(), scsi_times_out() and scmd_eh_abort_handler(). That
> last function is invoked (indirectly) by scsi_times_out().

Yes, and answering my own question, you cannot have a dangling pointer 
in eh_abort_handler (unless you have a driver bug).  This is because 
once eh_abort_handler is called, you know the interrupt handler will not 
trigger the softirq and scsi_finish_command won't be called.

Paolo
