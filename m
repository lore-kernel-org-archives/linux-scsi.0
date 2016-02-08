From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 3/4] qla2xxx: Add DebugFS node for target sess list.
Date: Mon, 8 Feb 2016 17:43:39 +0000
Message-ID: <D2DE0F32.D6BD5%himanshu.madhani@qlogic.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
 <1454604319-27947-4-git-send-email-himanshu.madhani@qlogic.com>
 <1454820035.10001.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454820035.10001.17.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <FDB089D72492594CB683075A3A4806A7@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nic, 


On 2/6/16, 8:40 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Himanshu & Quinn,
>
>On Thu, 2016-02-04 at 11:45 -0500, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@qlogic.com>
>> 
>>  #cat  /sys/kernel/debug/qla2xxx/qla2xxx_31/tgt_sess
>>  qla2xxx_31
>>  Port ID   Port Name                Handle
>>  ff:fc:01  21:fd:00:05:33:c7:ec:16  0
>>  01:0e:00  21:00:00:24:ff:7b:8a:e4  1
>>  01:0f:00  21:00:00:24:ff:7b:8a:e5  2
>>  ....
>> 
>> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_def.h    |    1 +
>>  drivers/scsi/qla2xxx/qla_dfs.c    |   55
>>++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/qla2xxx/qla_target.c |   56
>>++++++++++++++++++++++++------------
>>  3 files changed, 93 insertions(+), 19 deletions(-)
>> 
>
>So looking at this patch beyond the debugfs part, it does change where
>->check_initiator_node_acl() gets call during qlt_create_sess().
>
>I assume this is related to new debugfs attribute, and these changes
>(plus others in qlt_del_sess_work_fn) are not bug-fixes on their own,
>correct..?
>
>Aside from that, I don't have an objection to merge as v4.6 for-next
>code if QLogic finds it useful for debugging.

Yes. The changes in this patch are strictly for making information
available via debugFS
and not bug-fixes on their own. This information has been requested by few
customer who
finds this information useful for debugging and in addition they use this
information in
their configuration scripts as well.


>
>
>
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h
>>b/drivers/scsi/qla2xxx/qla_def.h
>> index 9872f34..e6c5bcf 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -2929,6 +2929,7 @@ struct qlt_hw_data {
>>  
>>  	uint8_t tgt_node_name[WWN_SIZE];
>>  
>> +	struct dentry *dfs_tgt_sess;
>>  	struct list_head q_full_list;
>>  	uint32_t num_pend_cmds;
>>  	uint32_t num_qfull_cmds_alloc;
>> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c
>>b/drivers/scsi/qla2xxx/qla_dfs.c
>> index cd8b96a..34272fd 100644
>> --- a/drivers/scsi/qla2xxx/qla_dfs.c
>> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
>> @@ -13,6 +13,47 @@ static struct dentry *qla2x00_dfs_root;
>>  static atomic_t qla2x00_dfs_root_count;
>>  
>>  static int
>> +qla2x00_dfs_tgt_sess_show(struct seq_file *s, void *unused)
>> +{
>> +	scsi_qla_host_t *vha = s->private;
>> +	struct qla_hw_data *ha = vha->hw;
>> +	unsigned long flags;
>> +	struct qla_tgt_sess *sess = NULL;
>> +	struct qla_tgt *tgt= vha->vha_tgt.qla_tgt;
>> +
>> +	seq_printf(s, "%s\n",vha->host_str);
>> +	if (tgt) {
>> +		seq_printf(s, "Port ID   Port Name                Handle\n");
>> +
>> +		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
>> +		list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
>> +			seq_printf(s, "%02x:%02x:%02x  %8phC  %d\n",
>> +					   sess->s_id.b.domain,sess->s_id.b.area,
>> +					   sess->s_id.b.al_pa,	sess->port_name,
>> +					   sess->loop_id);
>> +		}
>> +		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +qla2x00_dfs_tgt_sess_open(struct inode *inode, struct file *file)
>> +{
>> +	scsi_qla_host_t *vha = inode->i_private;
>> +	return single_open(file, qla2x00_dfs_tgt_sess_show, vha);
>> +}
>> +
>> +
>> +static const struct file_operations dfs_tgt_sess_ops = {
>> +	.open		= qla2x00_dfs_tgt_sess_open,
>> +	.read		= seq_read,
>> +	.llseek		= seq_lseek,
>> +	.release	= single_release,
>> +};
>> +
>> +static int
>>  qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
>>  {
>>  	struct scsi_qla_host *vha = s->private;
>> @@ -248,6 +289,15 @@ create_nodes:
>>  		    "Unable to create debugfs fce node.\n");
>>  		goto out;
>>  	}
>> +
>> +	ha->tgt.dfs_tgt_sess = debugfs_create_file("tgt_sess",
>> +		S_IRUSR, ha->dfs_dir, vha, &dfs_tgt_sess_ops);
>> +	if (!ha->tgt.dfs_tgt_sess) {
>> +		ql_log(ql_log_warn, vha, 0xffff,
>> +			"Unable to create debugFS tgt_sess node.\n");
>> +		goto out;
>> +	}
>> +
>>  out:
>>  	return 0;
>>  }
>> @@ -257,6 +307,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
>>  {
>>  	struct qla_hw_data *ha = vha->hw;
>>  
>> +	if (ha->tgt.dfs_tgt_sess) {
>> +		debugfs_remove(ha->tgt.dfs_tgt_sess);
>> +		ha->tgt.dfs_tgt_sess = NULL;
>> +	}
>> +
>>  	if (ha->dfs_fw_resource_cnt) {
>>  		debugfs_remove(ha->dfs_fw_resource_cnt);
>>  		ha->dfs_fw_resource_cnt = NULL;
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c
>>b/drivers/scsi/qla2xxx/qla_target.c
>> index 46c6679..a754aa4 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -641,7 +641,8 @@ void qlt_unreg_sess(struct qla_tgt_sess *sess)
>>  {
>>  	struct scsi_qla_host *vha = sess->vha;
>>  
>> -	vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
>> +	if (sess->se_sess)
>> +		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
>>  
>>  	if (!list_empty(&sess->del_list_entry))
>>  		list_del_init(&sess->del_list_entry);
>> @@ -856,8 +857,12 @@ static void qlt_del_sess_work_fn(struct
>>delayed_work *work)
>>  			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
>>  			    "Timeout: sess %p about to be deleted\n",
>>  			    sess);
>> -			ha->tgt.tgt_ops->shutdown_sess(sess);
>> -			ha->tgt.tgt_ops->put_sess(sess);
>> +			if (sess->se_sess) {
>> +				ha->tgt.tgt_ops->shutdown_sess(sess);
>> +				ha->tgt.tgt_ops->put_sess(sess);
>> +			} else {
>> +				qlt_unreg_sess(sess);
>> +			}
>>  		} else {
>>  			schedule_delayed_work(&tgt->sess_del_work,
>>  			    sess->expires - elapsed);
>> @@ -905,6 +910,19 @@ static struct qla_tgt_sess *qlt_create_sess(
>>  			if (sess->deleted)
>>  				qlt_undelete_sess(sess);
>>  
>> +			if (!sess->se_sess) {
>> +				be_sid[0] = sess->s_id.b.domain;
>> +				be_sid[1] = sess->s_id.b.area;
>> +				be_sid[2] = sess->s_id.b.al_pa;
>> +
>> +				if (ha->tgt.tgt_ops->check_initiator_node_acl
>> +				    (vha, &sess->port_name[0], sess, &be_sid[0],
>> +				     sess->loop_id) < 0) {
>> +					spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>> +					return NULL;
>> +				}
>> +			}
>> +
>>  			kref_get(&sess->se_sess->sess_kref);
>>  			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
>>  						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
>> @@ -951,22 +969,6 @@ static struct qla_tgt_sess *qlt_create_sess(
>>  	be_sid[0] = sess->s_id.b.domain;
>>  	be_sid[1] = sess->s_id.b.area;
>>  	be_sid[2] = sess->s_id.b.al_pa;
>> -	/*
>> -	 * Determine if this fc_port->port_name is allowed to access
>> -	 * target mode using explict NodeACLs+MappedLUNs, or using
>> -	 * TPG demo mode.  If this is successful a target mode FC nexus
>> -	 * is created.
>> -	 */
>> -	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
>> -	    &fcport->port_name[0], sess, &be_sid[0], fcport->loop_id) < 0) {
>> -		kfree(sess);
>> -		return NULL;
>> -	}
>> -	/*
>> -	 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
>> -	 * access across ->tgt.sess_lock reaquire.
>> -	 */
>> -	kref_get(&sess->se_sess->sess_kref);
>>  
>>  	sess->conf_compl_supported = (fcport->flags &
>>FCF_CONF_COMP_SUPPORTED);
>>  	BUILD_BUG_ON(sizeof(sess->port_name) != sizeof(fcport->port_name));
>> @@ -985,6 +987,22 @@ static struct qla_tgt_sess *qlt_create_sess(
>>  	    fcport->loop_id, sess->s_id.b.domain, sess->s_id.b.area,
>>  	    sess->s_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
>>  
>> +	/*
>> +	 * Determine if this fc_port->port_name is allowed to access
>> +	 * target mode using explict NodeACLs+MappedLUNs, or using
>> +	 * TPG demo mode.  If this is successful a target mode FC nexus
>> +	 * is created.
>> +	 */
>> +	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
>> +	    &fcport->port_name[0], sess, &be_sid[0], fcport->loop_id) < 0)
>> +		return NULL;
>> +	else
>> +		/*
>> +		 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
>> +		 * access across ->tgt.sess_lock reaquire.
>> +		 */
>> +		kref_get(&sess->se_sess->sess_kref);
>> +
>>  	return sess;
>>  }
>>  
>
>
