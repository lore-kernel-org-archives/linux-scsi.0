From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: scsi: in2000 scsi_cmnd convertion
Date: Fri, 24 Nov 2006 17:01:43 -0600
Message-ID: <1164409303.2813.21.camel@mulgrave.il.steeleye.com>
References: <45659882.1060201@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55707 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1757508AbWKXXCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 18:02:21 -0500
In-Reply-To: <45659882.1060201@nachtwindheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henne <henne@nachtwindheim.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2006-11-23 at 13:48 +0100, Henne wrote:
> -    volatile Scsi_Cmnd *input_Q;       /* commands waiting to be started */
> -    volatile Scsi_Cmnd *selecting;     /* trying to select this command */
> -    volatile Scsi_Cmnd *connected;     /* currently connected command */
> -    volatile Scsi_Cmnd *disconnected_Q;/* commands waiting for reconnect */
> +       volatile struct scsi_cmnd *input_Q;
> +                                       /* commands waiting to be started */
> +       volatile struct scsi_cmnd *selecting;
> +                                       /* trying to select this command */
> +       volatile struct scsi_cmnd *connected;
> +                                       /* currently connected command */
> +       volatile struct scsi_cmnd *disconnected_Q;

This doesn't preserve the indentation of the original.

Plus, I think if you lose the volatile then a lot of pointless casts
like this one:

> -       tmp = (Scsi_Cmnd *) hostdata->input_Q;
> +       tmp = (struct scsi_cmnd *) hostdata->input_Q;

Can be eliminated entirely (its sole job is to drop the volatile again).

James


