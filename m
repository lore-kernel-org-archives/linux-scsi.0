From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: libiscsi: Use scsi helper to set information descriptor
Date: Wed, 13 Apr 2016 19:30:53 +0300
Message-ID: <20160413163053.GD4247@mwanda>
References: <20160413131425.GA9719@mwanda>
 <570E5D54.8070303@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21225 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbcDMQdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 12:33:18 -0400
Content-Disposition: inline
In-Reply-To: <570E5D54.8070303@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

On Wed, Apr 13, 2016 at 05:53:08PM +0300, Sagi Grimberg wrote:
> Hey Dan,
> 
> >Hello Sagi Grimberg,
> >
> >The patch a73c2a2f9123: "libiscsi: Use scsi helper to set information
> >descriptor" from Jul 15, 2015, leads to the following static checker
> >warning:
> >
> >	drivers/scsi/libiscsi.c:858 iscsi_scsi_cmd_rsp()
> >	error: XXX uninitialized symbol 'sector'.
> >
> >drivers/scsi/libiscsi.c
> >    850                  ascq = session->tt->check_protection(task, &sector);
> >
> >If "ascq" is 0x1 then there sector might not be initialized.  The
> >documentation is not clear on how that works.  Har dee har har.  The
> >oldest jokes are still the best...  :P
> 
> iscsi transports that implement this callout are expected
> to set the sector which is passed by reference.

There is only iscsi_iser_check_protection() I think. It behaves how I
described in my original email.  If ib_check_mr_status() fails it
returns without setting sector.

> 
> would it make the checker happy if we set sector to 0 before
> calling check_protection (although it's not needed by no means)?

It looks for if there is any possible way that it could be uninitialized
so that would solve the problem.

regards,
dan carpenter
