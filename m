From: Christoph Hellwig <hch@infradead.org>
Subject: Re: aic7xxx deadlock in 2.6.0-test10
Date: Mon, 24 Nov 2003 08:13:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124081319.A29562@infradead.org>
References: <20031123230853.0bc8defb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:9478 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263660AbTKXINW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 03:13:22 -0500
Content-Disposition: inline
In-Reply-To: <20031123230853.0bc8defb.akpm@osdl.org>; from akpm@osdl.org on Sun, Nov 23, 2003 at 11:08:53PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Sun, Nov 23, 2003 at 11:08:53PM -0800, Andrew Morton wrote:
> ahc_linux_register_host() is calling ahc_linux_initialize_scsi_bus() under
> ahc_lock(ahc, &s).  But scsi_report_bus_reset() is taking host->host_lock
> inside shost_for_each_device(), and that is the same (already held) lock.
> 
> 
> This patch gets things going again of course.  Could someone please take a
> look at fixing this for real?
> 
> I'm not sure why this has suddenly started happening actually.

jejb just posted another fix for it on linux-scsi, but in fact your fix
looks better to me, ahc_initialize doesn't need the host_lock because
ahc can't be reached from an other thread yet.

