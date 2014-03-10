From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 1/3] VMW_PVSCSI: Fix pvscsi_abort() function.
Date: Mon, 10 Mar 2014 09:13:18 -0400
Message-ID: <1394457198.3827.270.camel@localhost.localdomain>
References: <1394311872.8462.20.camel@arvindkumar-dev1.eng.vmware.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbaCJNNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 09:13:37 -0400
In-Reply-To: <1394311872.8462.20.camel@arvindkumar-dev1.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, pv-drivers@vmware.com

On Sat, 2014-03-08 at 12:51 -0800, Arvind Kumar wrote:
> This change ensures that pvscsi_abort() function returns SUCCESS
> only when the command in question was actually completed, otherwise
> returns FAILURE. The code before change, was causing a bug where
> driver tries to complete a command to the mid-layer while the mid-layer
> has already requested the driver to abort that command, in response
> to which the driver has responded with SUCCESS causing mid-layer
> to free the command struct.
> 
> Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
> Cc: Ewan Milne <emilne@redhat.com>

This patch was verified by an OEM to fix a crash involving a double
completion.  The vmw_pvscsi driver was completing an scmd after having
previously returned SUCCESS status on the scmd from .eh_abort_handler().

Acked-by: Ewan D. Milne <emilne@redhat.com>


