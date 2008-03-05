From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: fill in error info record bits
Date: Wed, 05 Mar 2008 14:46:23 -0500
Message-ID: <47CEF88F.7050601@garzik.org>
References: <20080305190304.GA13286@havoc.gtf.org> <47CEF462.8060607@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37598 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbYCETqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2008 14:46:25 -0500
In-Reply-To: <47CEF462.8060607@tiscali.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Roel Kluin wrote:
> Jeff Garzik wrote:
>> This describes the first dword of struct mvs_err_info, two-dword error
>> information record that is returned when RXQ_ERR bit is asserted.
>>
>> These bits are necessary for proper error handling.
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
>> index d4a6ac3..ec4dda0 100644
>> --- a/drivers/scsi/mvsas.c
>> +++ b/drivers/scsi/mvsas.c
>> @@ -511,7 +511,35 @@ enum status_buffer {
>>  };
>>  
>>  enum error_info_rec {
>> -	CMD_ISS_STPD	=  (1U << 31),	/* Cmd Issue Stopped */
>> +	CMD_ISS_STPD	= (1U << 31),	/* Cmd Issue Stopped */
>> +	CMD_PI_ERR	= (1U << 30),	/* Protection info error.  see flags2 */
>> +	RSP_OVER	= (1U << 29),	/* rsp buffer overflow */
>> +	RETRY_LIM	= (1U << 28),	/* FIS/frame retry limit exceeded */
>> +	UNK_FIS		= (1U << 27),	/* unknown FIS */
>> +	DMA_TERM	= (1U << 26),	/* DMA terminate primitive rx'd */
>> +	SYNC_ERR	= (1U << 25),	/* SYNC rx'd during frame xmit */
>> +	TFILE_ERR	= (1U << 24),	/* SATA taskfile Error bit set */
>> +	R_ERR		= (1U << 23),	/* SATA returned R_ERR prim */
>> +	RD_OFS		= (1U << 20),	/* Read DATA frame invalid offset *?
> 
> there is a question mark instead of a slash in the line above.

definitely a mistake


> also I noted 1U << 22 to 1U << 21 were missing. was that intended?

yes, intended

	Jeff


