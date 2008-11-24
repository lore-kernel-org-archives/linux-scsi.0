From: Sven Schuetz <sven@linux.vnet.ibm.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Mon, 24 Nov 2008 16:46:39 +0100
Message-ID: <492ACC5F.8070004@linux.vnet.ibm.com>
References: <1227043498.4949.21.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:42039 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYKXPqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 10:46:42 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate7.uk.ibm.com (8.13.8/8.13.8) with ESMTP id mAOFkfT5246800
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2008 15:46:41 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAOFkepp1560708
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2008 15:46:40 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAOFkeYF032398
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2008 15:46:40 GMT
In-Reply-To: <1227043498.4949.21.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com

Hi James,

thanks for the rework, looks pretty good two me :)
One first question below.

James Smart wrote:
<snip>
> +	/* fc_host Message Codes */
> +#define FC_BSG_HST_ADD_RPORT		(FC_BSG_HST_MASK | 0x00000001)
> +#define FC_BSG_HST_DEL_RPORT		(FC_BSG_HST_MASK | 0x00000002)
> +#define FC_BSG_HST_ELS_NOLOGIN		(FC_BSG_HST_MASK | 0x00000003)
> +#define FC_BSG_HST_VENDOR		(FC_BSG_HST_MASK | 0x000000FF)
> +

Shouldn't we add FC_BSG_HST_CT_NOLOGIN as well?
As far as I can see from looking over the patch (correct me when I am wrong),
the way to issue a CT request now is to send an FC_BSG_HST_ADD_RPORT for the wka
port in question (if not enumerated by the driver, which zfcp does not do), then
send the FC_BSG_RPT_CT followed by a FC_BSG_HST_DEL_RPORT. I was under the
impression the CT stuff was one of the main reasons to have devices for the
fc_host. What do you think?

> +	/* fc_rport Message Codes */
> +#define FC_BSG_RPT_ELS			(FC_BSG_RPT_MASK | 0x00000001)
> +#define FC_BSG_RPT_CT			(FC_BSG_RPT_MASK | 0x00000002)
> +
</snip>

Sven
