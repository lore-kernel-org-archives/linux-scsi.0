From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Mon, 8 Sep 2008 14:49:32 -0700
Message-ID: <20080908214932.GF22598@plap4-2.qlogic.org>
References: <20080904093929.GA29006@orion.carnet.hr> <20080908211331.GC22598@plap4-2.qlogic.org> <20080908.142351.00296600.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:43287 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYIHVtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 17:49:33 -0400
Content-Disposition: inline
In-Reply-To: <20080908.142351.00296600.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: joy@entuzijast.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 08 Sep 2008, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 8 Sep 2008 14:13:31 -0700
> 
> > That's odd, as fc_flush_work() is quite minimal:
> > 
> > 	static void
> > 	fc_flush_work(struct Scsi_Host *shost)
> > 	{
> > 		if (!fc_host_work_q(shost)) {
> > 			printk(KERN_ERR
> > 				"ERROR: FC host '%s' attempted to flush work, "
> > 				"when no workqueue created.\n", shost->hostt->name);
> > 			dump_stack();
> > 			return;
> > 		}
> > 
> > 		flush_workqueue(fc_host_work_q(shost));
> > 	}
> > 
> > there's not much chance here for a NULL-dereference.
> 
> There are several.
> 
> In this particular case, looking at the instruction dump, it appears
> to be shost->shost_data is NULL in this case, via the expansion of
> fc_host_work_q which is defined as:
> 
> #define fc_host_work_q(x) \
> 	(((struct fc_host_attrs *)(x)->shost_data)->work_q)

That would be be quite scary, since I would have expected
scsi_add_host() to kmalloc the required transport bits:

	int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
	{
		struct scsi_host_template *sht = shost->hostt;
		int error = -EINVAL;

		...
		if (shost->transportt->host_size) {
			shost->shost_data = kzalloc(shost->transportt->host_size,
						 GFP_KERNEL);
			if (shost->shost_data == NULL) {
				error = -ENOMEM;
				goto out_del_dev;
			}
		}

well before a driver attempted to add an rport.  host_size is set indirectly
during qla2x00_module_init()'s call to fc_attach_transport():

	struct scsi_transport_template *
	fc_attach_transport(struct fc_function_template *ft)
	{
		...
		i->t.host_size = sizeof(struct fc_host_attrs);

Hmm...  Still looking...
