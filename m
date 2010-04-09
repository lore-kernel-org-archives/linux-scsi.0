From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RESEND PATCH] BNX2I - Bug fixes related to MTU change issue
 when there are active iscsi sessions
Date: Thu, 08 Apr 2010 21:32:19 -0500
Message-ID: <4BBE91B3.5070705@cs.wisc.edu>
References: <1270767555.28522.109818.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37988 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0DICcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 22:32:32 -0400
In-Reply-To: <1270767555.28522.109818.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, James B <James.Bottomley@suse.de>, linux scsi <linux-scsi@vger.kernel.org>

On 04/08/2010 05:59 PM, Anil Veerabhadrappa wrote:
> James,
>     Please apply this patch to fix resources leak issue when device MTU
> is changed or ethtool selftest is executed while there are active iscsi
> sessions.
>
> Thanks,
> Anil
>
>
>      * bnx2i driver has to wait and cleanup all iscsi endpoints before
>        returning from bnx2i_stop(). This is to make sure all chip
>        resources are freed before chip is reset.
>      * As the requirements for 1G and 10G chipsets is different, added
>        per-device 'hba_shutdown_tmo' parameter to adapter structure
>      * If the connections are not torn down by the daemon within this
>        timeout period, 'cid's will be leaked in 10G device. 1G devices
>        are more flexible and do not leak any resources because the whole
>        chip ports gets reset when MTU is changed or ethtool selftest is run
>      * fixed a minor issue in bnx2i_ep_poll() which unnecessarily forced
>        error return code when driver timed out waiting for TCP connect
>        request to complete
>
> Signed-off-by: Anil Veerabhadrappa<anilgv@broadcom.com>


Looks ok now.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
