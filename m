From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 11/11] compat_ioctl: move tape handling into drivers
Date: Sun, 9 Sep 2018 05:37:58 +0100
Message-ID: <20180909043746.GF19965@ZenIV.linux.org.uk>
References: <20180908142837.2819693-1-arnd@arndb.de>
 <20180908142837.2819693-11-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180908142837.2819693-11-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 08, 2018 at 04:28:17PM +0200, Arnd Bergmann wrote:
> MTIOCPOS and MTIOCGET are incompatible between 32-bit and 64-bit user
> space, and traditionally have been translated in fs/compat_ioctl.c.
> 
> To get rid of that translation handler, move a corresponding
> implementation into each of the four drivers implementing those commands.
> 
> The interesting part of that is now in a new linux/mtio.h header that
> wraps the existing uapi/linux/mtio.h header and provides an abstraction
> to let drivers handle both cases easily.

Ugh...  Frankly, this bool compat passed all way down looks wrong.
I can live with that; the question is whether block folks will be
OK with that thing...
