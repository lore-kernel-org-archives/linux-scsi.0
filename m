From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Fri, 22 Mar 2013 15:29:59 -0700
Message-ID: <1363991399.30339.22.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
	 <514C9386.4080606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34389 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648Ab3CVWaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Mar 2013 18:30:08 -0400
In-Reply-To: <514C9386.4080606@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, 2013-03-22 at 10:23 -0700, Andy Grover wrote:
> On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > Add basic struct iscsit_transport API template to allow iscsi-target for
> > running with external transport modules using existing iscsi_target_core.h
> > code.
> >
> > For all external modules, this calls try_module_get() and module_put()
> > to obtain + release an external iscsit_transport module reference count.
> >
> > Also include the iscsi-target symbols necessary in iscsi_transport.h to
> > allow external transport modules to function.
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/Makefile                 |    3 +-
> >   drivers/target/iscsi/iscsi_target_transport.c |   57 ++++++++++++++++++
> >   include/target/iscsi/iscsi_transport.h        |   77 +++++++++++++++++++++++++
> >   3 files changed, 136 insertions(+), 1 deletions(-)
> >   create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
> >   create mode 100644 include/target/iscsi/iscsi_transport.h
> >
> > diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
> > index 5b9a2cf..13a9240 100644
> > --- a/drivers/target/iscsi/Makefile
> > +++ b/drivers/target/iscsi/Makefile
> > @@ -15,6 +15,7 @@ iscsi_target_mod-y +=		iscsi_target_parameters.o \
> >   				iscsi_target_util.o \
> >   				iscsi_target.o \
> >   				iscsi_target_configfs.o \
> > -				iscsi_target_stat.o
> > +				iscsi_target_stat.o \
> > +				iscsi_target_transport.o
> >
> >   obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
> > diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
> > new file mode 100644
> > index 0000000..4ffd965
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_transport.c
> > @@ -0,0 +1,57 @@
> > +#include <linux/spinlock.h>
> > +#include <linux/list.h>
> > +#include <target/iscsi/iscsi_transport.h>
> > +
> > +static LIST_HEAD(g_transport_list);
> > +static DEFINE_MUTEX(transport_mutex);
> > +
> > +struct iscsit_transport *iscsit_get_transport(int type)
> > +{
> > +	struct iscsit_transport *t;
> > +
> > +	mutex_lock(&transport_mutex);
> > +	list_for_each_entry(t, &g_transport_list, t_node) {
> > +		if (t->transport_type == type) {
> > +			if (t->owner && !try_module_get(t->owner)) {
> > +				t = NULL;
> > +			}
> > +			mutex_unlock(&transport_mutex);
> > +			return t;
> > +		}
> > +	}
> > +	mutex_unlock(&transport_mutex);
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL(iscsit_get_transport);
> > +
> > +void iscsit_put_transport(struct iscsit_transport *t)
> > +{
> > +	if (t->owner)
> > +		module_put(t->owner);
> > +}
> > +EXPORT_SYMBOL(iscsit_put_transport);
> > +
> > +int iscsit_create_transport(struct iscsit_transport *t)
> > +{
> > +	INIT_LIST_HEAD(&t->t_node);
> > +
> > +	mutex_lock(&transport_mutex);
> > +	list_add_tail(&t->t_node, &g_transport_list);
> > +	mutex_unlock(&transport_mutex);
> > +
> > +	printk("Created iSCSI transport: %s\n", t->name);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(iscsit_create_transport);
> > +
> > +void iscsit_destroy_transport(struct iscsit_transport *t)
> > +{
> > +	mutex_lock(&transport_mutex);
> > +	list_del(&t->t_node);
> > +	mutex_unlock(&transport_mutex);
> > +
> > +	printk("Destroyed iSCSI transport: %s\n", t->name);
> > +}
> 
> I don't think create/destroy are the right names to use here - I suggest 
> register/unregister or something like that?
> 

Fair enough.  Renamed to register/unregister in the forth-coming RFC-v2

> Please also make sure to turn those printks in to pr_something() for the 
> final version.
> 

Done.

Thanks,

--nab


