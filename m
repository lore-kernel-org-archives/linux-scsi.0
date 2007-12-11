From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: BUG 2.6.24-rc4-mm1 -- Boot still hangs w/ async scsi scan
Date: Tue, 11 Dec 2007 13:23:33 -0500
Message-ID: <1197397413.5296.46.camel@localhost>
References: <1196872599.5346.8.camel@localhost>
	 <20071205132043.a80853d9.akpm@linux-foundation.org>
	 <1196964862.5293.34.camel@localhost>
	 <20071206103531.ea74d4bc.akpm@linux-foundation.org>
	 <1196967663.5293.36.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7991 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbXLKSXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 13:23:08 -0500
In-Reply-To: <1196967663.5293.36.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Eric.Moore@lsi.com, Eric Whitney <eric.whitney@hp.com>

On Thu, 2007-12-06 at 14:01 -0500, Lee Schermerhorn wrote:
> On Thu, 2007-12-06 at 10:35 -0800, Andrew Morton wrote:
> > On Thu, 06 Dec 2007 13:14:22 -0500 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > 
> > > On Wed, 2007-12-05 at 13:20 -0800, Andrew Morton wrote:
> > > > On Wed, 05 Dec 2007 11:36:39 -0500
> > > > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > > 
> > > > > As reported here:
> > > > > 
> > > > > 	http://marc.info/?l=linux-scsi&m=119645761124683&w=4
> > > > > 
> > > > > against 24-rc3-mm2, I'm still seeing the hang on my HP ia64 NUMA
> > > > > platform under 24-rc4-mm1 with async scsi scan enabled.  I'm still
> > > > > seeing the message  "mptspi: ioc#: mpt_config failed" when it hangs. 
> > > > > 
> > > > > I can boot by disabling async scan.  However, I've also noticed some
> > > > > disks attached via one of the "mpt" adapters ["scsi8" in console long in
> > > > > message linked above] going "off-line" during stress tests.  This was
> > > > > under 24-rc3-mm2.  Haven't got that far yet with 24-rc4-mm1.
> > > > > 
> > > > 
> > > > Is ther any way of tricking you into
> > > > http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt?
> > > > 
> > > > Obvious culprits to start with would be git-scsi-misc and maybe
> > > > scsi-early-detection-of-medium-not-present-updated.patch.  But there are
> > > > only 20-odd scsi patches in there.
> > > 
> > > The reported hang occurs after pushing the git-scsi-misc patch.
> > 

After trying a few "suspect" hunks of the git-scsi-misc.patch, I have
verified that the commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0--as
discussed in  http://marc.info/?t=119689824100001&r=1&w=4 for a
different symptom--seems to be the culprit.  Reverting this patch allows
me to boot with async scsi scan enabled.  I'm starting a stress test to
verify that this fixes the "disk going off-line" issue that I saw
earlier.

Lee

