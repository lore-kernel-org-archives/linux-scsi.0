From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [Suspected Spam:#] Question about scsi_qla_host_t.fcports list protection (qla2xxx)
Date: Wed, 16 Aug 2006 10:57:39 -0700
Message-ID: <20060816175739.GS3674@andrew-vasquezs-computer.local>
References: <44E19F93.2020305@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:52073 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S932145AbWHPR5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Aug 2006 13:57:42 -0400
Content-Disposition: inline
In-Reply-To: <44E19F93.2020305@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Tue, 15 Aug 2006, Vladislav Bolkhovitin wrote:

> Looking at the qla2xxx driver source code I noticed that 
> scsi_qla_host_t.fcports is used without any protection. For instance, 
> qla2x00_loop_reset() walks over this list. This function is called from 
> qla2xxx_eh_bus_reset(), which could be called at any time. What does 
> protect fcports from being changed, eg, by some async loop event during 
> the walking and eventually oops'ing? Do I miss something? There are many 
> such unprotected fcports list usages in the driver.

Nothing is ever removed from the fcports list during driver execution.
fcports are also only added from a single context (post init-time)
within the DPC thread.  We are safe here.

Regards,
Andrew Vasquez
