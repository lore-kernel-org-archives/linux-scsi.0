From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sat, 21 Aug 2010 15:43:18 -0500
Message-ID: <1282423398.3015.39.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0HUUnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2010 16:43:23 -0400
In-Reply-To: <4C701E08.2020005@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 22:42 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 08/20/2010 02:29 AM wrote:
> > "We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
> > allow TCM to access userspace backstores transparently with existing
> > kernel level TCM fabric modules, and using the generic configfs fabric
> > module infrastructure in target_core_fabric_configfs.c for the port and
> > I_T nexus control plane just as you would with any TCM backstore
> > subsystem today.
> >
> > Again, in open source you have to build upon what already exists and
> > move forward.  The original STGT kernel<->  userspace ring abstraction
> > and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
> > scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
> > what is required for handling fabric I/O processing and I_T Nexus and
> > Port management in kernel space with a userspace backstore.  It is
> > really just a matter of allowing the STGT ring request to optionally be
> > sent out to userspace as a standalone LUN instead of as a target port."
> 
> You forgot to mention one small thing. You are going to (re)use current 
> STGT interface for user space backend, which in 5 years of being 
> mainline has not gained any noticeable interest, because it is 
> fundamentally slow.

That's not exactly what the results of a speed comparison one of your
people did said, now is it?  The results were actually not much
difference on line speeds up to GigE.

Interface re-use (or at least ABI compatibility) is the whole point,
it's what makes the solution a drop in replacement.

>  It needs a complete redesign to become fast. In 
> contrast, interface provided by scst_user has just 3% overhead comparing 
> with fully in-kernel backend and allows to build storage capable of 
> handling 1,500,000 IOPSes (Kaminario).

For a replacement, first we get the current userspace code working as
is, then you can propose modifications to make it go faster.

James


