From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [patch 2.6.12 1/1] st: support ANSI end-of-volume processing
Date: Mon, 27 Jun 2005 22:43:30 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0506272229380.2964@kai.makisara.local>
References: <20050627191531.GC17260@tuxdriver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:54975 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261429AbVF0TkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 15:40:08 -0400
In-Reply-To: <20050627191531.GC17260@tuxdriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-scsi@vger.kernel.org, Fabien.Collin@cern.ch, Jean-Philippe.Baud@cern.ch

On Mon, 27 Jun 2005, John W. Linville wrote:

> The ANSI labelled tape standard specifies that the EOD on tape must be
> preceeded by a trailer label.  If during writing your application hits
> LEOT (Logical End Of Tape), it must be able to write the trailer label.
> However with the default tape driver (st), you cannot write anything
> after the LEOT.

This is not true. Quoting from linux/Documentation/scsi/st.txt:

"When the end of medium early warning is encountered, the current write
is finished and the number of bytes is returned. The next write
returns -1 and errno is set to ENOSPC. To enable writing a trailer,
the next write is allowed to proceed and, if successful, the number of
bytes is returned. After this, -1 and the number of bytes are
alternately returned until the physical end of medium (or some other
error) is encountered."

(Yes, this should be added to the man page ;-)

> So the patch clears the error condition so that the
> application can write the trailer label (there is some space available
> on tape media between LEOT and PEOT=Physical End Of Tape).
> 
If this new way is what users want and it does not break existing 
applications, it should be added. Especially if it is the way some other 
common system behaves. However, when the semantics are changed, the 
documentation in the kernel sources should also be updated.

-- 
Kai
