From: Ke Wei <kewei@marvell.com>
Subject: Re: [PATCH scsi-rc-fixes-2.6] mvsas: fix error handling.
Date: Wed, 07 May 2008 18:34:08 +0800
Message-ID: <482185A0.1030605@marvell.com>
References: <47FB498A.2010107@marvell.com>  <4811FE09.10209@garzik.org> <1209139637.3087.12.camel@localhost.localdomain>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:40341 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753213AbYEGKd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 06:33:59 -0400
In-Reply-To: <1209139637.3087.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> So, it's on my list to check carefully to see what else might have been
> quietly slipped in there ... unfortunately, I haven't had much time
> recently (and probably won't until the merge window closes) to give this
> patch the thorough scrutiny it needs.
> 
> James
> 
> 
After sending REPORT_LUNS wasn't successful, kernel will call scsi_sequential_lun_scan function scans from LUN 1. It means that driver need reprobe ATAPI port. Meanwhile, the driver can not indicate which LUN num need to be assigned. As a result, system will get all invalid LUNs if reprobing for device is OK. 
So I think that I can reject multi-LUNs for SATA devices in the slave_alloc function. 

Ke

