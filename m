From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: manual merge of the osd tree with the scsi tree
Date: Sun, 29 Nov 2009 08:46:39 -0500
Message-ID: <1259502399.2827.14.camel@mulgrave.site>
References: <20091127143229.108298c6.sfr@canb.auug.org.au>
	 <4B123A82.10104@panasas.com>  <4B127202.1010900@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753088AbZK2Nqi@vger.kernel.org>
In-Reply-To: <4B127202.1010900@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: open-osd <osd-dev@open-osd.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-11-29 at 15:07 +0200, Boaz Harrosh wrote:
> On 11/29/2009 11:10 AM, Boaz Harrosh wrote:
> > On 11/27/2009 05:32 AM, Stephen Rothwell wrote:
> >> Hi Boaz,
> >>
> >> Today's linux-next merge of the osd tree got a conflict in
> >> drivers/scsi/osd/osd_uld.c between commit
> >> f89b9ee4a722721ed205b8c29555ac75fbe8c2cc ("[SCSI] osduld: Use
> >> device->release instead of internal kref") from the scsi tree and commit
> >> 9b579fe8588b861dcf0c9b620757729643db4557 ("osduld: Use device->release
> >> instead of internal kref") from the osd tree.
> >>
> >> These are slightly different versions of the same patch ...
> >>
> >> And commit 01e4c32c668251e74eb179ee1207c075466c4ef8 ("osduld: No need to
> >> use dev_set_drvdata on embedded devices") from the osd also contributes
> >> to the conflict.
> >>
> > 
> > James has squashed these two patches together. Which do belong together
> > I should say. In my tree they are separate. I will change my tree to
> > match James's.
> > 
> > Thanks James, I prefer it much better this way.
> > 
> 
> James hi.
> 
> In your merge of the patch:
>     [SCSI] osduld: Use device->release instead of internal kref
> at:
>     [jejb: fold in use of container_of]
> 
> You have made a mistake, which renders the driver unusable.
> At osd_remove() you changed the use of dev_get_drvdata to an, container_of()
> but it is the *wrong* dev at this point this dev here is the grand-parent of
> the embedded dev in question.
> 
> Also at the next patch:
>     [SCSI] libosd: osd_dev_info: Unique Identification of an OSD device
> 
> a new use of dev_get_drvdata() is not converted to a container_of(), which by
> now will return NULL.
> 
> Should I repost the correct two patches (my preference)? should I send in a fix to
> current scsi-misc tree? or should I send two SQUASH-ME patches to the two bad commits
> in your tree?
>
> How do you want to proceed?

Send me the replacement patch (and tell me which commit id in my tree
it's replacing).

Thanks,

James
