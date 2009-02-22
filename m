From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] MTP FUSION: resending patch to disable MSI interrupt
	by defualt.
Date: Sun, 22 Feb 2009 08:48:18 -0600
Message-ID: <1235314098.4531.7.camel@localhost.localdomain>
References: <20090222104911.GA6142@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34180 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875AbZBVOsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 09:48:21 -0500
In-Reply-To: <20090222104911.GA6142@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Sun, 2009-02-22 at 16:19 +0530, Kashyap, Desai wrote:
> This Patch is submitted to with reference to MSI issue with some of LSI
> controller. Disabling it by default when module is loaded. 

Point of order here: this is *not* a resend of a previous patch.  This
is a bug fix of a previously sent patch (With a change in intended
behaviour).

> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 96ac883..ea3aafb 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -91,9 +91,9 @@ MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
>  		controllers (default=0)");
>  
>  static int mpt_msi_enable_sas;
> -module_param(mpt_msi_enable_sas, int, 1);
> +module_param(mpt_msi_enable_sas, int, 0);

This is the actual bug fix, which isn't mentioned anywhere in the change
log

>  MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
> -		controllers (default=1)");
> +		controllers (default=0)");

This entire patch is also functionally identical to the second patch in
this email from Yinghai Lu:

http://marc.info/?l=linux-scsi&m=123498532419609

Open Source is a co-operative effort: The only thing you get at the end
of the day is kudos for finding (and possibly fixing) a bug, so since
Yinghai Lu did all the heavy lifting in this regard, I'll take this as
an ack of his patch.

James


