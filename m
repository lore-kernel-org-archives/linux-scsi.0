From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: Tue, 19 Oct 2004 17:17:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041019161723.GO16153@parcelfarce.linux.theplanet.co.uk>
References: <1098137016.2011.339.camel@mulgrave> <200410182341.13648.dtor_core@ameritech.net> <200410190012.28071.dtor_core@ameritech.net> <Pine.LNX.4.58.0410190009260.2287@ppc970.osdl.org> <1098194090.1714.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58764 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268448AbUJSQR2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 12:17:28 -0400
Content-Disposition: inline
In-Reply-To: <1098194090.1714.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Ben Collins <bcollins@debian.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor_core@ameritech.net>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@debian.org, Linux1394-Devel <linux1394-devel@lists.sourceforge.net>

On Tue, Oct 19, 2004 at 08:54:43AM -0500, James Bottomley wrote:
> The condition codes are all migrating to SAM_STAT_ prefix, so
> CHECK_CONDITION becomes SAM_STAT_CHECK_CONDITION (and gets shifted in
> the process).
> 
> We still have a nasty namespace pollution problem on the SCSI commands
> though and cleaning this up is problematic since they permeate not just
> SCSI but large areas of other drivers as well.

How would you feel about COMMAND_COMPLETE -> SPI_MSG_COMMAND_COMPLETE,
possibly even turning them into an enum, and putting them in the new
file <scsi/spi.h>?

That would get us out of the problems with SBP defining different numbers
for the same constants.  sbp2 (a) wouldn't include <scsi/spi.h> and (b)
would use an SBP_MSG_ prefix anyway

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
