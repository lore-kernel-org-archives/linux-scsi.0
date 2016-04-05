From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: make location of /var/target configurable
Date: Mon, 04 Apr 2016 19:15:48 -0700
Message-ID: <1459822548.30528.3.camel@haakon3.risingtidesystems.com>
References: <cover.1459278305.git.lduncan@suse.com>
	 <1459654584.13184.39.camel@haakon3.risingtidesystems.com>
	 <570311AF.4070709@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50419 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981AbcDECQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 22:16:26 -0400
In-Reply-To: <570311AF.4070709@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, Andy Grover <agrover@redhat.com>, Jerome Martin <jxm@netiant.com>

On Mon, 2016-04-04 at 18:15 -0700, Lee Duncan wrote:
> On 04/02/2016 08:36 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2016-03-31 at 11:05 -0700, Lee Duncan wrote:
> >> These patches make the location of "/var/target" configurable,
> >> though it still defauls to "/var/target".
> >>
> >> This configuration is accomplished via the configfs
> >> top-level target attribute "dbroot", i.e. dumping
> >> out "/sys/kernel/config/target/dbroot" will normally
> >> return "/var/target". Writing to this attribute
> >> changes the loation where the kernel looks for the
> >> target database.
> >>
> >> ** NOTE/QUESTION: no sanity checks are done on the path passed in,
> >>    but it seems like *some* should be done. At least checking that
> >>    it's an abosolute path (i.e. starts with '/')? Opinions?
> >>
> > 
> > Wrt to sanity checking db_root at configfs attribute store time, how
> > about doing a filp_open() + S_DIR(f_inode->imode) + filp_close() of the
> > requested path to verify it's really a directory..?
> 
> That seems reasonable. I will try that out and add it assuming it works. :)
> 
> > 
> > Also, it would probably be a good idea to limit when db_root can be
> > changed.  Eg, only allow db_root to be changed when no active target
> > fabric drivers have been registered (list_empty(g_tf_list)), and require
> > userspace to set a different db_root after modprobe target_core_mod
> > completes, but before any fabric drivers are loaded.
> > 
> 
> I will also try that.
> 
> Would it be worthwhile to have a module parameter for target_core_mod to
> set the root, so it could be accomplished at the right time? (As much as
> I like playing with configfs.)
> 

target_core_mod + related drivers have been able to avoid mod params
thus far, so unless there's a reason why it can be done with a configfs
attribute (eg: it breaks existing userspace somehow), I'd prefer to
avoid that unless it's really necessary.

