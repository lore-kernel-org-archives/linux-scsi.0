From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH] add cpu on/offline support in Fibre
	Channel exchange and sequence handling
Date: Mon, 11 Oct 2010 16:23:39 -0700
Message-ID: <1286839419.13422.1581.camel@fritz>
References: <AANLkTi=ViAo=uYK0JwK597WkV1x78mntFqU-Cn4u0Dju@mail.gmail.com>
	 <1286834888.13422.1572.camel@fritz>
	 <1286837386.20358.106.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0JKXXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2010 19:23:39 -0400
In-Reply-To: <1286837386.20358.106.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Hillf Danton <dhillf@gmail.com>, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Mon, 2010-10-11 at 15:49 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2010-10-11 at 15:08 -0700, Robert Love wrote:
> > On Fri, 2010-10-08 at 22:57 +0800, Hillf Danton wrote:
> > 
> > Hi Hillf,
> > 
> > Can you please prefix the libfc patches with "libfc: <title>"? Also, for
> > your other patches that have a "SCSI" prefix, I think James' system adds
> > the "[SCSI]" prefix when he applies patches so you don't need to add it.
> > 
> > > Fibre Channel exchange pool is setup in a per cpu way that
> > > entire exchange id range is divided equally across all cpus.
> > > 
> > > When cpu goes offline, the corresponding range of exchg id
> > > becomes unavailable until it is online again.
> > > 
> > > This work tries to fix the unavailability based on notifier_block.
> > > 
> > > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > > ---
> > > 
> > > --- o/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-09-13
> > > 07:07:38.000000000 +0800
> > > +++ m/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-10-08
> > > 22:24:48.000000000 +0800
> > 
> > Most patches I've seen on the various mailing lists are created by
> > diffing the files within the kernel directory, so that you don't have
> > the "/linux-2.6.36-rc/" in each hunk. It's the difference between using
> > 'patch -p1' or 'patch -p2' when applying the patch.
> > 
> > I think this is preventing git-am from applying the patches. To import
> > them I ended up having git-am fail and then manually using the 'patch
> > -p2' command, so that I could get both the commit message from git-am
> > and then the patch itself from 'patch'. I don't know about anyone else,
> > but if you post patches without the kernel directory in the diff line it
> > would help me out. Thanks.
> > 
> 
> Hmmm, I am not sure about how to do this with git-am, but when I do this
> between lio-core-2.6.git/lio-4.0 -> lio-core-backports.git patches, I
> use:
> 
> 	'git-apply --index --verbose --directory=$DIR_PREFIX'
> 
> which is described in the git-apply manual here:
> 
> --directory=<root>
>         
>         Prepend <root> to all filenames. If a "-p" argument was also
>         passed, it is applied before prepending the new root.
>         
>         For example, a patch that talks about updating a/git-gui.sh to
>         b/git-gui.sh can be applied to the file in the working tree
>         modules/git-gui/git-gui.sh by running git apply
>         --directory=modules/git-gui.
>         

Thanks nab. While looking at '--directory' I just found that there is a
'-p' option to both git-am and git-apply. It seems like it should do the
trick. Unfortunately even with that flag it still doesn't apply.

fatal: patch fragment without header at line 7: @@ -26,6 +26,9 @@

I think the problem is with the timestamp after the path that describes
the affected file. If I remove that timestamp I can get it to apply with
'git-am -p2'.

//Rob


