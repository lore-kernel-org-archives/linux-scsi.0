From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 2.4.28 - AIC driver causes kernel corruption (as a
	module)
Date: Tue, 11 Jan 2005 13:48:04 -0600
Message-ID: <1105472884.10378.17.camel@mulgrave>
References: <41E427D3.2020201@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18604 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262614AbVAKTs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 14:48:28 -0500
In-Reply-To: <41E427D3.2020201@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Bellon <mbellon@mvista.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-11 at 12:24 -0700, Mark Bellon wrote:
> -		scsi_unregister_module(MODULE_SCSI_HA,
> -				       &aic79xx_driver_template);
> +		ahd_linux_exit();

Well, this is pretty much identical to the 2.6 fix for the same problem
except that you forgot to remove the __exit designation from ah
[cd]_linux_exit().  This is required to prevent hanging pointer
references.

James


