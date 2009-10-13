From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] remove invalid BUG_ON in scsi_transport_fc.c
Date: Tue, 13 Oct 2009 13:15:45 -0400
Message-ID: <4AD4B5C1.7020909@emulex.com>
References: <4AB3D773.50108@sgi.com> <4AB3DB7C.2050004@emulex.com> <4AB3DE99.3080602@sgi.com> <4ACF8BEF.6040105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37359 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZJMRQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 13:16:27 -0400
In-Reply-To: <4ACF8BEF.6040105@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This patch looks good.  Thanks Mike.

Acked-by:  James Smart  <james.smart@emulex.com>

-- james s



Michael Reed wrote:
> I was doing some large lun count testing with 2.6.31 and hit
> a BUG_ON() in fc_timeout_deleted_rport(), and it seems like it
> should have been just a matter of time before someone did.
> 
> It seems invalid to set port_state under lock, then expect it to
> remain set after releasing the lock.  Another thread called
> fc_remote_port_add() when the lock was released, changing the
> port_state.
> 
> This patch removes the BUG_ON and moves the test of the
> port_state to inside the host_lock.  It's been running for
> several weeks now with no ill effect.
> 
> Applies to 2.6.31 and 2.6.32-rc3.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
> --- a/drivers/scsi/scsi_transport_fc.c	2009-09-09 17:13:59.000000000 -0500
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-10-02 15:09:00.298487474 -0500
