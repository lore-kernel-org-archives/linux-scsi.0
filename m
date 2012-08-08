From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: scsi_dh_rdac: Add empty set_params function to scsi_dh_rdac
Date: Wed, 8 Aug 2012 21:34:12 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0BCA0B31@SACEXCMBX02-PRD.hq.netapp.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0BCA09F1@SACEXCMBX02-PRD.hq.netapp.com>
 <20120808193127.GA6064@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:56458 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab2HHVe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2012 17:34:59 -0400
In-Reply-To: <20120808193127.GA6064@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, August 08, 2012 2:31 PM
> To: Moger, Babu
> Cc: linux-scsi; device-mapper development (dm-devel@redhat.com)
> Subject: Re: scsi_dh_rdac: Add empty set_params function to scsi_dh_rdac
> 
> On Wed, Aug 08 2012 at 12:10pm -0400,
> Moger, Babu <Babu.Moger@netapp.com> wrote:
> 
> > This patch adds empty set_params function to scsi_dh_rdac.
> >
> > This patch is required for the following features to work properly.
> > 1. add  retain_attached_hw_handler feature
> >
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=a58a
> 935d5a1b2ad267017a68c3a1bca26226cc76
> >
> > 2. add scsi_dh_attached_handler_name
> >
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=7e8
> a74b177f17d100916b6ad415450f7c9508691
> >
> >
> > DM layer detaches the handler if the set_params is not implemented or
> fails.
> >
> > For example if we pass following parameters from multipath:
> >
> > 	features "1 retain_attached_hw_handler" (consider rdac as
> attached_hw_handler)
> > 	hardware_handler "2 alua 1"
> >
> > If the attached_hw_handler is rdac, then DM anyway tries to call
> set_params on rdac. Because rdac does not
> > implement set_params, scsi_dh_set_params fails and DM detaches the
> handler.
> >
> > This patch fixes this problem.
> >
> > Signed-off-by: Babu Moger <babu.moger@netapp.com>
> 
> I think it'd be best to fix scsi_dh_set_params() so that it returns 0 if
> scsi_dh->set_params is NULL.  That'd avoid all scsi_dh from having to
> stub out a similar set_params to return 0.
> 
> But taking a step back, have you actually seen the problem you're saying
> this patch fixes?
> 
> This problem shouldn't exist:
> drivers/md/dm-mpath.c:parse_path will free m->hw_handler_params (and
> reset it to NULL) if a scsi_dh is already attached.  Have a look at the
> if (attached_handler_name) {} case.

My bad. I was still using one of your old patches.
http://www.redhat.com/archives/dm-devel/2012-June/msg00174.html

Things have changed after this version.  We don't have this problem with the new set of patches. 

