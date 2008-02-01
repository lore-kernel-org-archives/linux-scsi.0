From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 1 Feb 2008 03:53:47 -0800 (PST)
Message-ID: <830195.4171.qm@web31808.mail.mud.yahoo.com>
References: <387599.14710.qm@web31814.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:30881 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753372AbYBALxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 06:53:48 -0500
In-Reply-To: <387599.14710.qm@web31814.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tony Battersby <tonyb@cybernetics.com>

--- On Thu, 1/31/08, Luben Tuikov <ltuikov@yahoo.com> wrote:
> Negate original:
>     if (driver_byte(result) == DRIVER_SENSE ||
>         (sense_valid && sense_defered))
>             Inspect sense.
> 
> Negate your proposed change "&&" ->
> "||":
>     if (driver_byte(result) == DRIVER_SENSE &&
>          (sense_valid || sense_deferred))
>                 Inspect sense.

Should read:

Negate original:
     if (driver_byte(result) == DRIVER_SENSE ||
         (sense_valid && !sense_deferred))
             Inspect sense.

Negate your proposed change "&&" -> "||":
     if (driver_byte(result) == DRIVER_SENSE &&
         (sense_valid || !sense_deferred))
             Inspect sense.

  Luben

