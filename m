From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/2] SCSI: implement scsi_eh_schedule_host()
Date: Tue, 11 Apr 2006 13:43:15 -0400
Message-ID: <443BEAB3.9050704@pobox.com>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com> <442F25BD.8040000@gmail.com> <20060402160414.GM13172@htj.dyndns.org> <20060402160646.GN13172@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:10118 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750819AbWDKRn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 13:43:26 -0400
In-Reply-To: <20060402160646.GN13172@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> This patch implements scsi_eh_schedule_host() which provides a way to
> directly invoke SCSI EH without SCSI command from drivers implementing
> ->eh_strategy_handler.  This allows such drivers to use EH to handle
> exception conditions which are not associated with particular SCSI
> command.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> ---
> 
> Jeff, I think using separate variable (->host_eh_scheduled) is the
> simplest way to implement this.  Adding more semantics to ->host_busy
> and failed doesn't sound very attractive to me.

ACK, I reviewed the existing uses of host_busy and host_error (not too 
many), and this should be OK.

However, I continue to be nervous being in the error handler when 
host_busy and host_error are zero.

	Jeff



