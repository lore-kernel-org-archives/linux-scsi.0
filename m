From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG 2.6.24-rc4-mm1 -- Boot still hangs w/ async scsi scan
Date: Thu, 6 Dec 2007 10:35:31 -0800
Message-ID: <20071206103531.ea74d4bc.akpm@linux-foundation.org>
References: <1196872599.5346.8.camel@localhost>
	<20071205132043.a80853d9.akpm@linux-foundation.org>
	<1196964862.5293.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbXLFSgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 13:36:11 -0500
In-Reply-To: <1196964862.5293.34.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Eric.Moore@lsi.com, Eric Whitney <eric.whitney@hp.com>

On Thu, 06 Dec 2007 13:14:22 -0500 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Wed, 2007-12-05 at 13:20 -0800, Andrew Morton wrote:
> > On Wed, 05 Dec 2007 11:36:39 -0500
> > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > 
> > > As reported here:
> > > 
> > > 	http://marc.info/?l=linux-scsi&m=119645761124683&w=4
> > > 
> > > against 24-rc3-mm2, I'm still seeing the hang on my HP ia64 NUMA
> > > platform under 24-rc4-mm1 with async scsi scan enabled.  I'm still
> > > seeing the message  "mptspi: ioc#: mpt_config failed" when it hangs. 
> > > 
> > > I can boot by disabling async scan.  However, I've also noticed some
> > > disks attached via one of the "mpt" adapters ["scsi8" in console long in
> > > message linked above] going "off-line" during stress tests.  This was
> > > under 24-rc3-mm2.  Haven't got that far yet with 24-rc4-mm1.
> > > 
> > 
> > Is ther any way of tricking you into
> > http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt?
> > 
> > Obvious culprits to start with would be git-scsi-misc and maybe
> > scsi-early-detection-of-medium-not-present-updated.patch.  But there are
> > only 20-odd scsi patches in there.
> 
> The reported hang occurs after pushing the git-scsi-misc patch.

OK, thanks.

>  I'm
> looking into it now, but it's rather large and I'm a neophyte in this
> area.  If James can point me at a broken-out quilt series for this
> patch, I'd be willing to try to bisect that--

I doubt if such a thing exists.

> assuming that it IS
> bisectable.

Often git trees are not bisectable.  But they should be.

Your best bet is to do a git-bisect on
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

http://www.kernel.org/doc/local/git-quick.html

