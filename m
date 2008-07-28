From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 12:56:16 -0500
Message-ID: <1217267776.3503.112.camel@localhost.localdomain>
References: <488E02DE.5080100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42653 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813AbYG1R4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 13:56:50 -0400
In-Reply-To: <488E02DE.5080100@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Mon, 2008-07-28 at 21:33 +0400, Vladislav Bolkhovitin wrote:
> This patch fixes race on dpc_thread field of struct scsi_qla_host,
> which can lead to crash on the module unload.
> 
> This patch is against 2.6.26

I'm afraid adding a lock is almost certainly the wrong way to handle
this type of failure.  What should be done is to make sure the qla is
correctly shut down (i.e. no tasks requiring the dpc_thread can be
performed) *before* killing the thread ... it sounds like shutdown is
slightly broken in the current driver ... could you post the oops
details and we can try to work out what the problem is

James


