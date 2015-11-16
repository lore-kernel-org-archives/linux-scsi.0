From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH, resend] scsi: advansys: fix big-endian builds
Date: Mon, 16 Nov 2015 18:20:31 +0000
Message-ID: <20151116182031.GX8644@n2100.arm.linux.org.uk>
References: <4411376.blKgWIg75B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60473 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbKPSUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2015 13:20:42 -0500
Content-Disposition: inline
In-Reply-To: <4411376.blKgWIg75B@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Hannes Reinecke <hare@suse.de>, Matthew Wilcox <willy@linux.intel.com>, linux-arm-kernel@lists.infradead.org

On Mon, Nov 16, 2015 at 05:49:23PM +0100, Arnd Bergmann wrote:
> It turns out that the commit that introduced this used the cpu_to_le32()
> incorrectly on an 8-bit field, which results in the sense_len to always
> be set to zero, as the SCSI_SENSE_BUFFERSIZE value gets moved to upper
> byte of the 32-bit intermediate.

More people need to run the sparse checker with -D__CHECK_ENDIAN__ and
have proper endian annotations?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
