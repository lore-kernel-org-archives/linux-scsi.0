From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Some constants I don't understand in sym2
Date: Mon, 20 Sep 2004 17:12:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Sep20.171220edt.332207@cyborg.cybernetics.com>
References: <20040920202535.GS642@parcelfarce.linux.theplanet.co.uk>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:37904 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S267362AbUITVRq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 17:17:46 -0400
In-Reply-To: <20040920202535.GS642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <willy@debian.org>, linux-scsi@vger.kernel.org

> Was there ever a TERMINATED that was 0x20, or is this simply a
mistake?

SCSI-2 defines "COMMAND TERMINATED" status as 0x22.  This status value
is special because the target is supposed to have sense data available
after returning COMMAND TERMINATED status (just like after returning
CHECK CONDITION).  The sym2 driver requests sense data after seeing a
status of S_TERMINATED or S_CHECK_COND, so this looks like a typo.  The
correct value is 0x22.

> Other symbolic tags I haven't found Linux names for yet include:
>
>  #define        M_ABORT_TAG     (0x0d)
>  #define        M_CLEAR_QUEUE   (0x0e)
> -#define        M_INIT_REC      (0x0f)
> -#define        M_REL_REC       (0x10)
> +#define        M_INIT_REC      INITIATE_RECOVERY
> +#define        M_REL_REC       RELEASE_RECOVERY
>  #define        M_TERMINATE     (0x11)
>  #define        M_IGN_RESIDUE   (0x23)
>  #define        M_IDENTIFY      (0x80)
>
> Again, history lesson / pointers to specs appreciated (I have sam3r09,
> spc3r15 and spi5r06 handy).

These are SCSI-2 names for various SPI messages.  SCSI-3 gave them
different names but kept the same meanings.  Do a reverse lookup on the
message code in the SPI spec to get the new names:

ABORT TAG -> ABORT TASK
CLEAR QUEUE -> CLEAR TASK SET
TERMINATE TASK -> defined in SPI2 but not in SPI3 and above
IGNORE WIDE RESIDUE (same)
IDENTIFY (actually a bitmask - any message with the high bit set is
IDENTIFY)

As always, SCSI-related specs can be downloaded from www.t10.org

Anthony J. Battersby
Cybernetics

