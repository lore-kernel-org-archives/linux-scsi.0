From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Fwd: [patch libata-dev-2.6 5/5] libata: update ATA pass thru
 opcodes]
Date: Sat, 19 Feb 2005 15:27:58 +1000
Message-ID: <4216CE5E.6000401@torque.net>
References: <42164E5E.1020505@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:53911 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261633AbVBSF1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Feb 2005 00:27:24 -0500
In-Reply-To: <42164E5E.1020505@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> I thought the "Command sets are supposed to be qualified" paragraph was 
> worth forwarding to linux-scsi.
> 
>     Jeff
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Subject:
> [patch libata-dev-2.6 5/5] libata: update ATA pass thru opcodes
> From:
> "John W. Linville" <linville@tuxdriver.com>
> Date:
> Fri, 18 Feb 2005 15:16:23 -0500
> To:
> linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
> 
> To:
> linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
> 
> 
> Update ATA pass thru opcodes to match what is specified in the current
> ATA pass thru spec (T10/04-262r7).
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> This part was controversial before, because these opcodes seemed to
> overlap with some existing opcodes.  So I contacted the author of
> the spec, Curtis Stevens: (quoted without permision)
> 
> "The command values in 04-262r7 are correct.  There was an erroneous value
> published in the minutes that subsequently got published in SPC.  This has
> been corrected.
> 
> Command sets are supposed to be qualified by the Inquiry Peripheral Device
> Type.  I am a little concerned that some portions of linux depend on opcodes
> being the same for all PDTs.  Using reusing opcodes will continue to happen
> more frequently as new applications emerge and new devices are created.  The
> SCSI opcoded are already overloaded to the point that Service Actions have
> become necessary to extend the protocol."
> 
> Honestly, I don't know if that clears things up or not.  But, Curtis
> seems pretty adamant that the values in the patch below (which match
> rev 7 of the spec) are correct.  IMHO, at worst these values are no
> more wrong than the ones already there.
> 
> So, apply this now, or apply it later... :-)
> 
>  include/scsi/scsi.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- sata-smart-2.6/include/scsi/scsi.h.orig	2005-02-01 16:22:12.390234346 -0500
> +++ sata-smart-2.6/include/scsi/scsi.h	2005-02-01 16:23:02.828491161 -0500
> @@ -113,9 +113,9 @@ extern const char *const scsi_device_typ
>  /* values for service action in */
>  #define	SAI_READ_CAPACITY_16  0x10
>  
> -/* Temporary values for T10/04-262 until official values are allocated */
> -#define	ATA_16		      0x85	/* 16-byte pass-thru [0x85 == unused]*/
> -#define	ATA_12		      0xb3	/* 12-byte pass-thru [0xb3 == obsolete set limits command] */
> +/* Values for T10/04-262r7 */
> +#define	ATA_16		      0x85	/* 16-byte pass-thru */
> +#define	ATA_12		      0xa1	/* 12-byte pass-thru */
>  
>  /*
>   *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft

Jeff,
Maybe it has been decided since but this document:
http://www.t10.org/ftp/t10/document.05/05-056r0.pdf
which is the minutes of the MMC WG from 19 January 2005
where Curtis Stevens discussed SAT concludes
(in New Business, item E):
"The MMC WG strongly recommends that op code A1h
not be used by SAT."

The reason is that A1h is the MMC BLANK command.
t10 meets again in early March.


As for the "command sets are supposed to be qualified"
comment, I think the ULDs (sd, st, sr, mc and osst)
handle that well. With the sg driver it is user beware!
Many sg3_utils utilities issue an INQUIRY
to find the PDT before issuing commands that are
PDT specific and potentially dangerous (e.g. FORMAT
UNIT for a disk).

Doug Gilbert
