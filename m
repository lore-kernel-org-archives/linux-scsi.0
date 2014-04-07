From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/9] target: Pass in transport supported PI at session
 initialization
Date: Mon, 07 Apr 2014 10:28:06 +0300
Message-ID: <53425386.7090507@dev.mellanox.co.il>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com> <1396517753-23546-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> In order to support local WRITE_INSERT + READ_STRIP operations for
> non PI enabled fabrics, the fabric driver needs to be able signal
> what protection offload operations are supported.
>
> This is done at session initialization time so the modes can be
> signaled by individual se_wwn + se_portal_group endpoints, as well
> as optionally across different transports on the same endpoint.
>
> For iser-target, set TARGET_PROT_ALL if the underlying ib_device
> has already signaled PI offload support, and allow this to be
> exposed via a new iscsit_transport->iscsit_get_sup_prot_ops()
> callback.
>
> For loopback, set TARGET_PROT_ALL to signal SCSI initiator mode
> operation.
>
> For all other drivers, set TARGET_PROT_NORMAL to disable fabric
> level PI.
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c   |   13 +++++++++++++
>   drivers/infiniband/ulp/srpt/ib_srpt.c     |    2 +-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c        |    2 +-
>   drivers/target/iscsi/iscsi_target.c       |    6 ++++++
>   drivers/target/iscsi/iscsi_target_login.c |    4 +++-
>   drivers/target/loopback/tcm_loop.c        |    2 +-
>   drivers/target/sbp/sbp_target.c           |    2 +-
>   drivers/target/target_core_transport.c    |    8 +++++---
>   drivers/target/tcm_fc/tfc_sess.c          |    3 ++-
>   drivers/usb/gadget/tcm_usb_gadget.c       |    2 +-
>   drivers/vhost/scsi.c                      |    3 ++-
>   include/target/iscsi/iscsi_transport.h    |    1 +
>   include/target/target_core_base.h         |   19 ++++++++++++-------
>   include/target/target_core_fabric.h       |    5 +++--
>   14 files changed, 52 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index f5cc4af..c98fdb1 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2196,6 +2196,18 @@ isert_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   	device->unreg_rdma_mem(isert_cmd, isert_conn);
>   }
>   
> +static enum target_prot_op
> +isert_get_sup_prot_ops(struct iscsi_conn *conn)
> +{
> +	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +	struct isert_device *device = isert_conn->conn_device;
> +
> +	if (device->pi_capable)
> +		return TARGET_PROT_ALL;
> +
> +	return TARGET_PROT_NORMAL;
> +}
> +
>   static int
>   isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
>   		bool nopout_response)
> @@ -3252,6 +3264,7 @@ static struct iscsit_transport iser_target_transport = {
>   	.iscsit_queue_data_in	= isert_put_datain,
>   	.iscsit_queue_status	= isert_put_response,
>   	.iscsit_aborted_task	= isert_aborted_task,
> +	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
>   };
>   
>   static int __init isert_init(void)
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index f03aafd..bcfb398 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2580,7 +2580,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   		goto destroy_ib;
>   	}
>   
> -	ch->sess = transport_init_session();
> +	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(ch->sess)) {
>   		rej->reason = __constant_cpu_to_be32(
>   				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index b23a0ff..68fb66f 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1482,7 +1482,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>   	}
>   	se_tpg = &tpg->se_tpg;
>   
> -	se_sess = transport_init_session();
> +	se_sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(se_sess)) {
>   		pr_err("Unable to initialize struct se_session\n");
>   		return PTR_ERR(se_sess);
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 96aee43..78cab13 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -511,6 +511,11 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   	__iscsit_free_cmd(cmd, scsi_cmd, true);
>   }
>   
> +static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)

I think it is more correct that this routine will return a bitmap (u32) 
and not the enumeration itself.

> +{
> +	return TARGET_PROT_NORMAL;
> +}
> +
>   static struct iscsit_transport iscsi_target_transport = {
>   	.name			= "iSCSI/TCP",
>   	.transport_type		= ISCSI_TCP,
> @@ -526,6 +531,7 @@ static struct iscsit_transport iscsi_target_transport = {
>   	.iscsit_queue_data_in	= iscsit_queue_rsp,
>   	.iscsit_queue_status	= iscsit_queue_rsp,
>   	.iscsit_aborted_task	= iscsit_aborted_task,
> +	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
>   };
>   
>   static int __init iscsi_target_init_module(void)
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index e29279e..8739b98 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -259,6 +259,7 @@ static int iscsi_login_zero_tsih_s1(
>   {
>   	struct iscsi_session *sess = NULL;
>   	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
> +	enum target_prot_op sup_pro_ops;
>   	int ret;
>   
>   	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
> @@ -320,8 +321,9 @@ static int iscsi_login_zero_tsih_s1(
>   		kfree(sess);
>   		return -ENOMEM;
>   	}
> +	sup_pro_ops = conn->conn_transport->iscsit_get_sup_prot_ops(conn);
>   
> -	sess->se_sess = transport_init_session();
> +	sess->se_sess = transport_init_session(sup_pro_ops);
>   	if (IS_ERR(sess->se_sess)) {
>   		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
>   				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index bdc1ad8..c886ad1 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1018,7 +1018,7 @@ static int tcm_loop_make_nexus(
>   	/*
>   	 * Initialize the struct se_session pointer
>   	 */
> -	tl_nexus->se_sess = transport_init_session();
> +	tl_nexus->se_sess = transport_init_session(TARGET_PROT_ALL);
>   	if (IS_ERR(tl_nexus->se_sess)) {
>   		ret = PTR_ERR(tl_nexus->se_sess);
>   		goto out;
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index ad04ea9..e7e9372 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -210,7 +210,7 @@ static struct sbp_session *sbp_session_create(
>   		return ERR_PTR(-ENOMEM);
>   	}
>   
> -	sess->se_sess = transport_init_session();
> +	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(sess->se_sess)) {
>   		pr_err("failed to init se_session\n");
>   
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 9393544..9c820ba 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -235,7 +235,7 @@ void transport_subsystem_check_init(void)
>   	sub_api_initialized = 1;
>   }
>   
> -struct se_session *transport_init_session(void)
> +struct se_session *transport_init_session(enum target_prot_op sup_prot_ops)
>   {
>   	struct se_session *se_sess;
>   
> @@ -251,6 +251,7 @@ struct se_session *transport_init_session(void)
>   	INIT_LIST_HEAD(&se_sess->sess_wait_list);
>   	spin_lock_init(&se_sess->sess_cmd_lock);
>   	kref_init(&se_sess->sess_kref);
> +	se_sess->sup_prot_ops = sup_prot_ops;
>   
>   	return se_sess;
>   }
> @@ -288,12 +289,13 @@ int transport_alloc_session_tags(struct se_session *se_sess,
>   EXPORT_SYMBOL(transport_alloc_session_tags);
>   
>   struct se_session *transport_init_session_tags(unsigned int tag_num,
> -					       unsigned int tag_size)
> +					       unsigned int tag_size,
> +					       enum target_prot_op sup_prot_ops)
>   {
>   	struct se_session *se_sess;
>   	int rc;
>   
> -	se_sess = transport_init_session();
> +	se_sess = transport_init_session(sup_prot_ops);
>   	if (IS_ERR(se_sess))
>   		return se_sess;
>   
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index ae52c08..0475142 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -211,7 +211,8 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
>   		return NULL;
>   
>   	sess->se_sess = transport_init_session_tags(TCM_FC_DEFAULT_TAGS,
> -						    sizeof(struct ft_cmd));
> +						    sizeof(struct ft_cmd),
> +						    TARGET_PROT_NORMAL);
>   	if (IS_ERR(sess->se_sess)) {
>   		kfree(sess);
>   		return NULL;
> diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
> index f9afa4a..f34b6df 100644
> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> @@ -1731,7 +1731,7 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
>   		pr_err("Unable to allocate struct tcm_vhost_nexus\n");
>   		goto err_unlock;
>   	}
> -	tv_nexus->tvn_se_sess = transport_init_session();
> +	tv_nexus->tvn_se_sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(tv_nexus->tvn_se_sess))
>   		goto err_free;
>   
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4a47335..cf50ce9 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1745,7 +1745,8 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
>   	 */
>   	tv_nexus->tvn_se_sess = transport_init_session_tags(
>   					TCM_VHOST_DEFAULT_TAGS,
> -					sizeof(struct tcm_vhost_cmd));
> +					sizeof(struct tcm_vhost_cmd),
> +					TARGET_PROT_NORMAL);
>   	if (IS_ERR(tv_nexus->tvn_se_sess)) {
>   		mutex_unlock(&tpg->tv_tpg_mutex);
>   		kfree(tv_nexus);
> diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
> index 8d19339..33b487b 100644
> --- a/include/target/iscsi/iscsi_transport.h
> +++ b/include/target/iscsi/iscsi_transport.h
> @@ -22,6 +22,7 @@ struct iscsit_transport {
>   	int (*iscsit_queue_data_in)(struct iscsi_conn *, struct iscsi_cmd *);
>   	int (*iscsit_queue_status)(struct iscsi_conn *, struct iscsi_cmd *);
>   	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
> +	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
>   };
>   
>   static inline void *iscsit_priv_cmd(struct iscsi_cmd *cmd)
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index ec3e3a3..9ec9864 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -442,15 +442,19 @@ struct se_tmr_req {
>   };
>   
>   enum target_prot_op {
> -	TARGET_PROT_NORMAL = 0,
> -	TARGET_PROT_DIN_INSERT,
> -	TARGET_PROT_DOUT_INSERT,
> -	TARGET_PROT_DIN_STRIP,
> -	TARGET_PROT_DOUT_STRIP,
> -	TARGET_PROT_DIN_PASS,
> -	TARGET_PROT_DOUT_PASS,
> +	TARGET_PROT_NORMAL	= 0,
> +	TARGET_PROT_DIN_INSERT	= (1 << 0),
> +	TARGET_PROT_DOUT_INSERT	= (1 << 1),
> +	TARGET_PROT_DIN_STRIP	= (1 << 2),
> +	TARGET_PROT_DOUT_STRIP	= (1 << 3),
> +	TARGET_PROT_DIN_PASS	= (1 << 4),
> +	TARGET_PROT_DOUT_PASS	= (1 << 5),
>   };
>   
> +#define TARGET_PROT_ALL	TARGET_PROT_DIN_INSERT | TARGET_PROT_DOUT_INSERT | \
> +			TARGET_PROT_DIN_STRIP | TARGET_PROT_DOUT_STRIP | \
> +			TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS
> +

We only look at the supported protection operations, what about 
supported types?
Do we assume that all types are supported if sup_prot_ops is not empty?
This is fine for the current state, but I think we will require to 
address that.

>   enum target_prot_type {
>   	TARGET_DIF_TYPE0_PROT,
>   	TARGET_DIF_TYPE1_PROT,
> @@ -605,6 +609,7 @@ struct se_node_acl {
>   struct se_session {
>   	unsigned		sess_tearing_down:1;
>   	u64			sess_bin_isid;
> +	enum target_prot_op	sup_prot_ops;
>   	struct se_node_acl	*se_node_acl;
>   	struct se_portal_group *se_tpg;
>   	void			*fabric_sess_ptr;
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 1d10436..22a4e98 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -84,10 +84,11 @@ struct target_core_fabric_ops {
>   	void (*fabric_drop_nodeacl)(struct se_node_acl *);
>   };
>   
> -struct se_session *transport_init_session(void);
> +struct se_session *transport_init_session(enum target_prot_op);
>   int transport_alloc_session_tags(struct se_session *, unsigned int,
>   		unsigned int);
> -struct se_session *transport_init_session_tags(unsigned int, unsigned int);
> +struct se_session *transport_init_session_tags(unsigned int, unsigned int,
> +		enum target_prot_op);
>   void	__transport_register_session(struct se_portal_group *,
>   		struct se_node_acl *, struct se_session *, void *);
>   void	transport_register_session(struct se_portal_group *,
