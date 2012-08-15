From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] iscsi_tcp: add write permission to max_lun
Date: Wed, 15 Aug 2012 17:13:28 +0100
Message-ID: <1345047208.2976.71.camel@dabdike.int.hansenpartnership.com>
References: <1345030205-23393-1-git-send-email-revers@redhat.com>
	 <DECF1C60-0ED2-4652-BD0D-5BA4F23F5D21@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40985 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab2HOQNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 12:13:34 -0400
In-Reply-To: <DECF1C60-0ED2-4652-BD0D-5BA4F23F5D21@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On Wed, 2012-08-15 at 10:50 -0500, Michael Christie wrote:
> On Aug 15, 2012, at 6:30 AM, Rob Evers <revers@redhat.com> wrote:
> 
> > Add root write permission to iscsi_tcp max_lun parameter
> > 
> > Signed-off-by: Rob Evers <revers@redhat.com>
> > ---
> > drivers/scsi/iscsi_tcp.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > index 9220861..e8609a4 100644
> > --- a/drivers/scsi/iscsi_tcp.c
> > +++ b/drivers/scsi/iscsi_tcp.c
> > @@ -56,7 +56,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht;
> > static struct iscsi_transport iscsi_sw_tcp_transport;
> > 
> > static unsigned int iscsi_max_lun = 512;
> > -module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
> > +module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO|S_IWUSR);
> 
> 
> 
> Looks ok.
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Is there a reason not to raise the limit globally within iSCSI?  i.e. do
what everyone else does (usually 0xFFFF for a single level lun hierarchy
or ~0 for don't care), rather than have to have them twiddle a hard to
find constant, since that seems to be the intent of the patch.

James


