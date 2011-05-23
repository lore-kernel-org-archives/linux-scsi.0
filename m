From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][SCSI] target: Fix double test of inquiry_prod
Date: Mon, 23 May 2011 12:21:26 -0700
Message-ID: <1306178486.29724.18.camel@haakon2.linux-iscsi.org>
References: <1303920422-31142-1-git-send-email-roland@kernel.org>
	 <BANLkTinKNKk3uW=+rDYd_9Bdqi7CXWWkag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59447 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1EWT3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2011 15:29:43 -0400
In-Reply-To: <BANLkTinKNKk3uW=+rDYd_9Bdqi7CXWWkag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Andy Grover <agrover@redhat.com>

On Mon, 2011-05-23 at 10:20 -0700, Roland Dreier wrote:
> On Wed, Apr 27, 2011 at 9:07 AM, Roland Dreier <roland@kernel.org> wrote:
> > From: Roland Dreier <roland@purestorage.com>
> >
> > The code really intends to make sure that neither inquiry_prod nor
> > inquiry_rev is NULL.
> >
> > Signed-off-by: Roland Dreier <roland@purestorage.com>
> > ---
> >  drivers/target/target_core_transport.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 9583b23..4a03098 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1725,7 +1725,7 @@ struct se_device *transport_add_device_to_core_hba(
> >         * setup.
> >         */
> >        if (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
> > -               if (!(inquiry_prod) || !(inquiry_prod)) {
> > +               if (!inquiry_prod || !inquiry_rev) {
> >                        printk(KERN_ERR "All non TCM/pSCSI plugins require"
> >                                " INQUIRY consts\n");
> >                        goto out;
> >
> 
> Hi Nick, did you ever get a chance to look at this?  Seems pretty obvious to me.

Hey Roland,

This has been included in upstream LIO v4.1, and I have been intending
to include in a non-critical for-40 series (post for-40 round 1 +
iscsi-target merge) later this week along with some of Andy's other
target core cleanups and improvements that have been merged into LIO
upstream.

James, would you mind including Roland's patch directly in scsi-misc
with my signoff after you merge the outstanding target for-40 series
items..?

Thanks,

--nab

