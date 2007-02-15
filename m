From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] wd33c93.c: Fast SCSI with WD33C93B
Date: Thu, 15 Feb 2007 17:53:08 -0600
Message-ID: <1171583588.3412.50.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.58.0702121514080.433@Indigo2.Peter>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:60721 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422739AbXBOXxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Feb 2007 18:53:14 -0500
In-Reply-To: <Pine.LNX.4.58.0702121514080.433@Indigo2.Peter>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: post@pfrst.de
Cc: linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>, Tim Yamin <plasmaroo@gentoo.org>

On Mon, 2007-02-12 at 15:20 +0100, peter fuerst wrote:
> Attached are patches, which help to utilize more of the WD33C93B SCSI
> controller's capabilities.

OK, the patch didn't quite apply, so I fixed it up and removed the
unused i variable in wd33c93_proc_info()

> 1st Stage:
> 
> 1) Added/changed all the necessary code to enable Burst Mode DMA. Only
>    Single Byte DMA was used before.
> 
> 2) Added/changed all the necessary code to enable Fast-10 SCSI transfers.
> 
> 3) The original driver inadvertently used a transfer period of 1000-800ns
>    (the lowest possible transfer rate) for asynchronous data transfers,
>    instead of the (configurable) default period intended for this purpose,
>    if the target responded to a SDTR not with a Reject-message, but with
>    a zero-SDTR. This issue was fixed.
>    Moreover, in case of a Reject the driver used the default-period's
>    initialization-value instead of its (maybe smaller) current value. The
>    missing assignment was added.
> 
> 4) The driver's commandline- and proc-file-interface was augmented to
>    handle the new options properly.
> 
> 2nd Stage:
> 
> The original driver used to rely on a fixed table (sx_table) to select
> transfer periods and map them to register values. This table contained
> periods for (only) the lower limits of the respective input-clock-frequency
> ranges (8-10/12-15/16-20 MHz). Although it seems, that no problems ocurred
> with this setting so far, it seemed desirable to adjust the transfer periods
> closer to the really attached, possibly 25% higher, input-clock, since
> 
> a) the wd33c93 may really use a significant shorter period, than it has
>    negotiated (eg. thrashing the target, which expects 4/8MHz, with 5/10MHz
>    instead).
> b) the wd33c93 may ask the target for a lower transfer rate, than the target
>    is capable of (eg. negotiating for an assumed minimum of 252ns instead of
>    possible 200ns).
>    And indeed, this issue shows up as an approx. 10% lower transfer rate.
> 
> I'd preferred to fix this by simply replacing the lower-limit period-values
> (252,376,500,624,752,876,1000) by upper-limit values (200,300,400,500,600,
> 700,800). IMHO these would do no harm, if used with actually lower input-
> clock frequencies, and automatically provide best performance.
> 
> But for to keep the driver's former state available, to keep it as the default
> state, so that there's no difference, when the driver is used by existing,
> unchanged platform-drivers, i choose the more complicated approach of always
> calculating an appropriate table for the respective clock-parameter.
> 
> The disadvantage is, that a platform-driver, that can and wishes to benefit
> from the higher input-clock-frequency on its system, must be changed (e.g.)
> from calling wd33c93_init(... WD33C93_FS_16_20) to calling
> wd33c93_init(... WD33C93_FS_MHZ(20)).

Actually, if you're going to be doing all this, can we shift this driver
over on to a more modern API.  The detect/register thing has been
deprecated for a few years now.  Finally, we probably also need to
attach it to the SPI transport class so it can do things that FAST-10
hosts need, like configuration via domain validation.

I can probably help you with both of these.  The 53c700.c is a good
template, because it also has the same clock setting requirements and it
is already hooked in to the transport classes and the modern API.

James


