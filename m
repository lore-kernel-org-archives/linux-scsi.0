From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 04/15] target: Move cmd->prot_op check into
 target_check_write_prot
Date: Tue, 31 Mar 2015 22:54:27 -0700
Message-ID: <1427867667.9176.197.camel@haakon3.risingtidesystems.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-5-git-send-email-nab@daterainc.com>
	 <55190206.90207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51397 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbDAFy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2015 01:54:29 -0400
In-Reply-To: <55190206.90207@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2015-03-30 at 10:57 +0300, Sagi Grimberg wrote:
> On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch moves the existing target_execute_cmd() check for
> > cmd->prot_op into it's own function, so it's easier to add
> > future support for WRITE STRIP.
> >
> > Cc: Martin Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_transport.c | 31 ++++++++++++++++++++++---------
> >   1 file changed, 22 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index aef989e..6a24151 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1738,6 +1738,25 @@ void __target_execute_cmd(struct se_cmd *cmd)
> >   	}
> >   }
> >
> > +static int target_check_write_prot(struct se_cmd *cmd)
> 
> This is not really a check routine, it actually does something with
> the protection information. Maybe a better name would be
> target_write_prot_action() or something in that form.

Makes sense.  Renamed to target_write_prot_action()

