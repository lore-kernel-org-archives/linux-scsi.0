From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Fri, 22 Mar 2013 10:23:18 -0700
Message-ID: <514C9386.4080606@redhat.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422636Ab3CVRX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 13:23:29 -0400
In-Reply-To: <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Add basic struct iscsit_transport API template to allow iscsi-target for
> running with external transport modules using existing iscsi_target_core.h
> code.
>
> For all external modules, this calls try_module_get() and module_put()
> to obtain + release an external iscsit_transport module reference count.
>
> Also include the iscsi-target symbols necessary in iscsi_transport.h to
> allow external transport modules to function.
>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/iscsi/Makefile                 |    3 +-
>   drivers/target/iscsi/iscsi_target_transport.c |   57 ++++++++++++++++++
>   include/target/iscsi/iscsi_transport.h        |   77 +++++++++++++++++++++++++
>   3 files changed, 136 insertions(+), 1 deletions(-)
>   create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
>   create mode 100644 include/target/iscsi/iscsi_transport.h
>
> diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
> index 5b9a2cf..13a9240 100644
> --- a/drivers/target/iscsi/Makefile
> +++ b/drivers/target/iscsi/Makefile
> @@ -15,6 +15,7 @@ iscsi_target_mod-y +=		iscsi_target_parameters.o \
>   				iscsi_target_util.o \
>   				iscsi_target.o \
>   				iscsi_target_configfs.o \
> -				iscsi_target_stat.o
> +				iscsi_target_stat.o \
> +				iscsi_target_transport.o
>
>   obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
> diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
> new file mode 100644
> index 0000000..4ffd965
> --- /dev/null
> +++ b/drivers/target/iscsi/iscsi_target_transport.c
> @@ -0,0 +1,57 @@
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <target/iscsi/iscsi_transport.h>
> +
> +static LIST_HEAD(g_transport_list);
> +static DEFINE_MUTEX(transport_mutex);
> +
> +struct iscsit_transport *iscsit_get_transport(int type)
> +{
> +	struct iscsit_transport *t;
> +
> +	mutex_lock(&transport_mutex);
> +	list_for_each_entry(t, &g_transport_list, t_node) {
> +		if (t->transport_type == type) {
> +			if (t->owner && !try_module_get(t->owner)) {
> +				t = NULL;
> +			}
> +			mutex_unlock(&transport_mutex);
> +			return t;
> +		}
> +	}
> +	mutex_unlock(&transport_mutex);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(iscsit_get_transport);
> +
> +void iscsit_put_transport(struct iscsit_transport *t)
> +{
> +	if (t->owner)
> +		module_put(t->owner);
> +}
> +EXPORT_SYMBOL(iscsit_put_transport);
> +
> +int iscsit_create_transport(struct iscsit_transport *t)
> +{
> +	INIT_LIST_HEAD(&t->t_node);
> +
> +	mutex_lock(&transport_mutex);
> +	list_add_tail(&t->t_node, &g_transport_list);
> +	mutex_unlock(&transport_mutex);
> +
> +	printk("Created iSCSI transport: %s\n", t->name);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(iscsit_create_transport);
> +
> +void iscsit_destroy_transport(struct iscsit_transport *t)
> +{
> +	mutex_lock(&transport_mutex);
> +	list_del(&t->t_node);
> +	mutex_unlock(&transport_mutex);
> +
> +	printk("Destroyed iSCSI transport: %s\n", t->name);
> +}

I don't think create/destroy are the right names to use here - I suggest 
register/unregister or something like that?

Please also make sure to turn those printks in to pr_something() for the 
final version.

-- Andy

> +EXPORT_SYMBOL(iscsit_destroy_transport);
> diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
> new file mode 100644
> index 0000000..c885376
> --- /dev/null
> +++ b/include/target/iscsi/iscsi_transport.h
> @@ -0,0 +1,77 @@
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include "../../../drivers/target/iscsi/iscsi_target_core.h"
> +
> +struct iscsit_transport {
> +#define ISCSIT_TRANSPORT_NAME	16
> +	char name[ISCSIT_TRANSPORT_NAME];
> +	int transport_type;
> +	struct module *owner;
> +	struct list_head t_node;
> +	int (*iscsit_setup_np)(struct iscsi_np *, struct __kernel_sockaddr_storage *);
> +	int (*iscsit_accept_np)(struct iscsi_np *, struct iscsi_conn *);
> +	void (*iscsit_free_np)(struct iscsi_np *);
> +	void (*iscsit_free_conn)(struct iscsi_conn *);
> +	struct iscsi_cmd *(*iscsit_alloc_cmd)(struct iscsi_conn *, gfp_t);
> +	void (*iscsit_unmap_cmd)(struct iscsi_cmd *, struct iscsi_conn *);
> +	void (*iscsit_free_cmd)(struct iscsi_cmd *);
> +	int (*iscsit_get_login_rx)(struct iscsi_conn *, struct iscsi_login *);
> +	int (*iscsit_put_login_tx)(struct iscsi_conn *, struct iscsi_login *, u32);
> +	int (*iscsit_immediate_queue)(struct iscsi_conn *, struct iscsi_cmd *, int);
> +	int (*iscsit_response_queue)(struct iscsi_conn *, struct iscsi_cmd *, int);
> +};
> +
> +/*
> + * From iscsi_target_transport.c
> + */
> +
> +extern int iscsit_create_transport(struct iscsit_transport *);
> +extern void iscsit_destroy_transport(struct iscsit_transport *);
> +extern struct iscsit_transport *iscsit_get_transport(int);
> +extern void iscsit_put_transport(struct iscsit_transport *);
> +
> +/*
> + * From iscsi_target.c
> + */
> +extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *,
> +				struct iscsi_cmd *);
> +extern int iscsit_setup_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
> +				unsigned char *);
> +extern void iscsit_set_unsoliticed_dataout(struct iscsi_cmd *);
> +extern int iscsit_process_scsi_cmd(struct iscsi_conn *, struct iscsi_cmd *,
> +				struct iscsi_scsi_req *);
> +extern int iscsit_check_dataout_hdr(struct iscsi_conn *, unsigned char *,
> +				struct iscsi_cmd **);
> +extern int iscsit_check_dataout_payload(struct iscsi_cmd *, struct iscsi_data *,
> +				bool);
> +extern int iscsit_handle_nop_out(struct iscsi_conn *, struct iscsi_cmd *,
> +				unsigned char *);
> +extern int iscsit_handle_logout_cmd(struct iscsi_conn *, struct iscsi_cmd *,
> +				unsigned char *);
> +extern int iscsit_handle_task_mgt_cmd(struct iscsi_conn *, struct iscsi_cmd *,
> +				unsigned char *);
> +extern void iscsit_build_rsp_pdu(struct iscsi_cmd *, struct iscsi_conn *,
> +				bool, struct iscsi_scsi_rsp *);
> +extern void iscsit_build_nopin_rsp(struct iscsi_cmd *, struct iscsi_conn *,
> +				struct iscsi_nopin *, bool);
> +extern void iscsit_build_task_mgt_rsp(struct iscsi_cmd *, struct iscsi_conn *,
> +				struct iscsi_tm_rsp *);
> +extern int iscsit_build_logout_rsp(struct iscsi_cmd *, struct iscsi_conn *,
> +				struct iscsi_logout_rsp *);
> +extern int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
> +/*
> + * From iscsi_target_device.c
> + */
> +extern void iscsit_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi_session *);
> +
> +/*
> + * From iscsi_target_tmr.c
> + */
> +extern int iscsit_tmr_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
> +
> +/*
> + * From iscsi_target_util.c
> + */
> +extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
> +extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *, __be32);
> +extern void iscsit_free_cmd(struct iscsi_cmd *);
>

