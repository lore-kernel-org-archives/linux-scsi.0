From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/15] loopback: Add fabric_prot_type attribute
 support
Date: Tue, 31 Mar 2015 23:22:08 -0700
Message-ID: <1427869328.9176.216.camel@haakon3.risingtidesystems.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-12-git-send-email-nab@daterainc.com>
	 <55190445.6030600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56019 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbDAGWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2015 02:22:10 -0400
In-Reply-To: <55190445.6030600@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Hannes Reinecke <hare@suse.de>, Jerome Martin <tramjoe.merin@gmail.com>

On Mon, 2015-03-30 at 11:07 +0300, Sagi Grimberg wrote:
> On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch updates loopback to add a new fabric_prot_type TPG attribute,
> > used for controlling LLD level protection into LIO when the backend
> > device does not support T10-PI.
> >
> > Also, go ahead and set DIN_PASS + DOUT_PASS so target-core knows that
> > it will be doing any WRITE_STRIP and READ_INSERT operations.
> >
> > Cc: Martin Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/loopback/tcm_loop.c | 54 ++++++++++++++++++++++++++++++++++++--
> >   drivers/target/loopback/tcm_loop.h |  1 +
> >   2 files changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> > index f4618e7..797c731 100644
> > --- a/drivers/target/loopback/tcm_loop.c
> > +++ b/drivers/target/loopback/tcm_loop.c
> > @@ -697,6 +697,13 @@ static int tcm_loop_check_prod_mode_write_protect(struct se_portal_group *se_tpg
> >   	return 0;
> >   }
> >
> > +static int tcm_loop_check_prot_fabric_only(struct se_portal_group *se_tpg)
> > +{
> > +	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
> > +						   tl_se_tpg);
> > +	return tl_tpg->tl_fabric_prot_type;
> > +}
> > +
> 
> So now loopback devices can finally protect transfers with
> read_verify=0, write_generate=0?
> 

(Adding Jerome CC')

Yes.

However, a non zero tl_fabric_prot_type TPG attribute value needs to be
set before I_T nexus creation occurs in order for the loopback session
to report se_sess->sess_prot_type in SBC/SPC control bit emulation code.

Also, rtslib needs to be updated to optionally set prot_fabric_only=1
before nexus creation occurs to enable this code.

--nab

