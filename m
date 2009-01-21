From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Wed, 21 Jan 2009 13:27:01 -0500
Message-ID: <497768F5.9030806@cybernetics.com>
References: <4964ABFD.9000807@nokia.com> <1232032416-21743-1-git-send-email-Aaro.Koskinen@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:3841 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZAUS1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 13:27:04 -0500
In-Reply-To: <1232032416-21743-1-git-send-email-Aaro.Koskinen@nokia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

Aaro Koskinen wrote:
> (The patch updated based on testing and comments from Tony Battersby.)
>
> Change the sym53c8xx_2 driver negotiation logic so that the driver will
> tolerate better device removals. Negotiation message(s) will be sent
> with every INQUIRY and REQUEST SENSE command, and whenever there is a
> change in goals or when the device reports check condition.
>
> The patch was made specifically to address the case where you hotswap
> the disk using remove-single-device/add-single-device commands through
> /proc/scsi/scsi. Without the patch the driver keeps using old transfer
> parameters even though the target is reset and reports check condition,
> so the data transfer of the very first INQUIRY will fail.
>
> Signed-off-by: Aaro Koskinen <Aaro.Koskinen@nokia.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_hipd.c |   35 ++++++++++++++++++++++++++---------
>  drivers/scsi/sym53c8xx_2/sym_hipd.h |    1 +
>  2 files changed, 27 insertions(+), 9 deletions(-)
>
>   

Looks good.

James, please add this to the list of pending sym53c8xx patches.

Tested-by: Tony Battersby <tonyb@cybernetics.com>

