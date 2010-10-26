From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [RESUBMIT][Patch] scsi_dh_rdac: retry IO for 06/3f/03
 in rdac_check_sense fn
Date: Tue, 26 Oct 2010 14:18:54 -0500
Message-ID: <4CC7299E.2030508@cs.wisc.edu>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46170 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0JZTSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 15:18:40 -0400
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/26/2010 08:53 AM, Chauhan, Vijay wrote:
> Resubmitting this patch to get the attention.
>
> This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath.
>

Is it getting failed by accident? In scsi_io_completion we check for UAs 
and will retry if the removable bit is not set. That check is after 
scsi_end_request though (is the scsi_end_request call failing the IO).

Did you guys also want REPORTED_LUNS_DATA_HAS_CHANGED to be retried too. 
I think scsi_dh_alua's REPORTED_LUNS_DATA_HAS_CHANGED maybe should be 
genericly retried, because it seems for both errors we will want to 
retry for all devices.
