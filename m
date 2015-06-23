From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/6] target: Send UA upon LUN RESET tmr completion
Date: Tue, 23 Jun 2015 00:54:40 -0700
Message-ID: <1435046080.7460.24.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
	 <1434009689-112909-6-git-send-email-hare@suse.de>
	 <20150619130601.GB7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:32800 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbbFWHym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 03:54:42 -0400
In-Reply-To: <20150619130601.GB7783@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2015-06-19 at 15:06 +0200, Christoph Hellwig wrote:
> On Thu, Jun 11, 2015 at 10:01:28AM +0200, Hannes Reinecke wrote:
> > SAM mandates that an BUS DEVICE RESET FUNCTION OCCURRED
> > UA needs to be send after a LUN RESET tmr has completed.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/target/target_core_transport.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index a0e0d3a..bb60c0c4 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -3064,6 +3064,17 @@ static void target_tmr_work(struct work_struct *work)
> >  		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
> >  		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
> >  					 TMR_FUNCTION_REJECTED;
> > +		if (tmr->response == TMR_FUNCTION_COMPLETE) {
> > +			struct se_dev_entry *deve;
> > +
> > +			rcu_read_lock();
> > +			deve = target_nacl_find_deve(cmd->se_sess->se_node_acl,
> > +						     cmd->orig_fe_lun);
> > +			if (deve)
> > +				core_scsi3_ua_allocate(deve, 0x29,
> > +					ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
> > +			rcu_read_unlock();
> 
> This should use the target_ua_allocate_lun helper.

Fixed.

