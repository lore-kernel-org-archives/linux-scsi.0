From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, resend] scsi: advansys: fix big-endian builds
Date: Mon, 16 Nov 2015 10:35:01 -0800
Message-ID: <20151116183501.GA25744@infradead.org>
References: <4411376.blKgWIg75B@wuerfel>
 <20151116182031.GX8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151116182031.GX8644@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Hannes Reinecke <hare@suse.de>, Matthew Wilcox <willy@linux.intel.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2015 at 06:20:31PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 16, 2015 at 05:49:23PM +0100, Arnd Bergmann wrote:
> > It turns out that the commit that introduced this used the cpu_to_le32()
> > incorrectly on an 8-bit field, which results in the sense_len to always
> > be set to zero, as the SCSI_SENSE_BUFFERSIZE value gets moved to upper
> > byte of the 32-bit intermediate.
> 
> More people need to run the sparse checker with -D__CHECK_ENDIAN__ and
> have proper endian annotations?

Ho about enabling __CHECK_ENDIAN__ by default when running sparse at
least?
