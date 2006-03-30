From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 08:46:34 -0600
Message-ID: <1143729995.3328.1.camel@mulgrave.il.steeleye.com>
References: <1143653396.3248.34.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at>
	 <1143656547.3248.36.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at>
	 <1143657838.3248.39.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at>
	 <1143659029.3248.42.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at>
	 <1143666681.3248.48.camel@mulgrave.il.steeleye.com>
	 <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
	 <20060330125816.GG13590@parisc-linux.org>
	 <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24973 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750702AbWC3Oqm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 09:46:42 -0500
In-Reply-To: <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-03-30 at 16:20 +0200, Ingo Flaschberger wrote:
> +       if (bflags & BLIST_NOREPORTLUN)
> +               return 1;
> +       if ((starget->scsi_level < SCSI_2) &&
> +                       (starget->scsi_level != SCSI_UNKNOWN))
> +               return 1;
> +       if (starget->scsi_level < SCSI_3 &&
> +                       ((!(bflags & BLIST_REPORTLUN2) &&
> +                       (starget->scsi_level != SCSI_UNKNOWN)) ||

Actually, this one's still not quite right.  The default for
SCSI_UNKNOWN needs to be not to do a report lun scan *unless*
BLIST_REPORTLUN2 is set ... that way we won't disrupt the functioning of
current SCSI_UNKNOWN devices (i.e. just drop the last SCSI_UNKNOWN check
and add BLIST_REPORTLUNS2 to the flags of the compaq array type).

James


