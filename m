From: Christoph Hellwig <hch@infradead.org>
Subject: Re: another SCSI sync
Date: Sat, 22 Feb 2003 20:41:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030222204136.A28427@infradead.org>
References: <1045932775.1946.18.camel@mulgrave> <Pine.LNX.4.44.0302221225500.7635-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302221225500.7635-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Feb 22, 2003 at 12:34:46PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, Feb 22, 2003 at 12:34:46PM -0800, Linus Torvalds wrote:
> They are marked __exit, which means that they end up being marked unused
> _and_ in a segment that doesn't ever get loaded for built-in stuff (since 
> clearly the built-in kernel can never unload).
> 
> In general, it is just illegal to call an __exit function from something 
> that isn't __exit itself. And these functions are called from __init 
> function too.
> 
> Please fix. In the meantime, my fix is to remove the two bogus "__exit" 
> notifiers, and wondering to myself how the hell this ever worked for any 
> of you guys.

Okay, this was my fault.  It seems the old toolchain on SuSE 8.0
(gcc 2.95-based) doesn't seem to notice this yet.  Your fix is correct,
there's no other fixups needed.

