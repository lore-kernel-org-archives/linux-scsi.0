Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C61C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 00:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A78206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 00:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZykUzkaW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLKAXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 19:23:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32663 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbfLKAXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 19:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576023790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0DHq5jomRtzqdp4ZrTNBO19gEa7DeelApPK/zuSVrE=;
        b=ZykUzkaWD19gzir1O9uwr0tKvV/eMfGvlqhkJYH3axZoFm9Qw0BlpZdxom+Xnu98HxFUK0
        OeiyaRoLgbBpKwdxKTwCI5sZgeZ3Jn1lo8pTCp/LracWGtUmP5dhorA2W0eVkoReKLROzr
        4+cKQmYVuIa4Nz22mrXQCC3UYNek/cE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-YqUUItqXMga3HYiAQj_UhQ-1; Tue, 10 Dec 2019 19:23:08 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD897801E76;
        Wed, 11 Dec 2019 00:23:06 +0000 (UTC)
Received: from [10.10.120.90] (ovpn-120-90.rdu2.redhat.com [10.10.120.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5225D1001925;
        Wed, 11 Dec 2019 00:23:03 +0000 (UTC)
Subject: Re: [PATCH] iscsi: Perform connection failure entirely in kernel
 space
To:     Gabriel Krisman Bertazi <krisman@collabora.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com
References: <20191209182054.1287374-1-krisman@collabora.com>
 <5DF032BD.3070509@redhat.com>
Cc:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Bharath Ravi <rbharath@google.com>, kernel@collabora.com,
        Dave Clausen <dclausen@google.com>,
        Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>,
        Khazhismel Kumykov <khazhy@google.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5DF036E6.9080907@redhat.com>
Date:   Tue, 10 Dec 2019 18:23:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <5DF032BD.3070509@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: YqUUItqXMga3HYiAQj_UhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/2019 06:05 PM, Mike Christie wrote:
> On 12/09/2019 12:20 PM, Gabriel Krisman Bertazi wrote:
>> From: Bharath Ravi <rbharath@google.com>
>>
>> Connection failure processing depends on a daemon being present to (at
>> least) stop the connection and start recovery.  This is a problem on a
>> multipath scenario, where if the daemon failed for whatever reason, the
>> SCSI path is never marked as down, multipath won't perform the
>> failover and IO to the device will be forever waiting for that
>> connection to come back.
>>
>> This patch implements an optional feature in the iscsi module, to
>> perform the connection failure inside the kernel.  This way, the
>> failover can happen and pending IO can continue even if the daemon is
>> dead. Once the daemon comes alive again, it can perform recovery
>> procedures if applicable.
>>
>> Co-developed-by: Dave Clausen <dclausen@google.com>
>> Signed-off-by: Dave Clausen <dclausen@google.com>
>> Co-developed-by: Nick Black <nlb@google.com>
>> Signed-off-by: Nick Black <nlb@google.com>
>> Co-developed-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> Co-developed-by: Anatol Pomazau <anatol@google.com>
>> Signed-off-by: Anatol Pomazau <anatol@google.com>
>> Co-developed-by: Tahsin Erdogan <tahsin@google.com>
>> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
>> Co-developed-by: Frank Mayhar <fmayhar@google.com>
>> Signed-off-by: Frank Mayhar <fmayhar@google.com>
>> Co-developed-by: Junho Ryu <jayr@google.com>
>> Signed-off-by: Junho Ryu <jayr@google.com>
>> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>> Signed-off-by: Bharath Ravi <rbharath@google.com>
>> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
>> ---
>>  drivers/scsi/scsi_transport_iscsi.c | 46 +++++++++++++++++++++++++++++
>>  include/scsi/scsi_transport_iscsi.h |  1 +
>>  2 files changed, 47 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 417b868d8735..7251b2b5b272 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -36,6 +36,12 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_session);
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_tcp);
>>  EXPORT_TRACEPOINT_SYMBOL_GPL(iscsi_dbg_sw_tcp);
>>  
>> +static bool kern_conn_failure;
>> +module_param(kern_conn_failure, bool, S_IRUGO|S_IWUSR);
>> +MODULE_PARM_DESC(kern_conn_failure,
>> +		 "Allow the kernel to detect and disable broken connections "
>> +		 "without requiring userspace intervention");
>> +
>>  static int dbg_session;
>>  module_param_named(debug_session, dbg_session, int,
>>  		   S_IRUGO | S_IWUSR);
>> @@ -84,6 +90,12 @@ struct iscsi_internal {
>>  	struct transport_container session_cont;
>>  };
>>  
>> +/* Worker to perform connection failure on unresponsive connections
>> + * completely in kernel space.
>> + */
>> +static void stop_conn_work_fn(struct work_struct *work);
>> +static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
>> +
>>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>>  static struct workqueue_struct *iscsi_eh_timer_workq;
>>  
>> @@ -1609,6 +1621,7 @@ static DEFINE_MUTEX(rx_queue_mutex);
>>  static LIST_HEAD(sesslist);
>>  static DEFINE_SPINLOCK(sesslock);
>>  static LIST_HEAD(connlist);
>> +static LIST_HEAD(connlist_err);
>>  static DEFINE_SPINLOCK(connlock);
>>  
>>  static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
>> @@ -2245,6 +2258,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>>  
>>  	mutex_init(&conn->ep_mutex);
>>  	INIT_LIST_HEAD(&conn->conn_list);
>> +	INIT_LIST_HEAD(&conn->conn_list_err);
>>  	conn->transport = transport;
>>  	conn->cid = cid;
>>  
>> @@ -2291,6 +2305,7 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>>  
>>  	spin_lock_irqsave(&connlock, flags);
>>  	list_del(&conn->conn_list);
>> +	list_del(&conn->conn_list_err);
>>  	spin_unlock_irqrestore(&connlock, flags);
>>  
>>  	transport_unregister_device(&conn->dev);
>> @@ -2405,6 +2420,28 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>>  
>> +static void stop_conn_work_fn(struct work_struct *work)
>> +{
>> +	struct iscsi_cls_conn *conn, *tmp;
>> +	unsigned long flags;
>> +	LIST_HEAD(recovery_list);
>> +
>> +	spin_lock_irqsave(&connlock, flags);
>> +	if (list_empty(&connlist_err)) {
>> +		spin_unlock_irqrestore(&connlock, flags);
>> +		return;
>> +	}
>> +	list_splice_init(&connlist_err, &recovery_list);
>> +	spin_unlock_irqrestore(&connlock, flags);
>> +
>> +	mutex_lock(&rx_queue_mutex);
>> +	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
>> +		conn->transport->stop_conn(conn, STOP_CONN_RECOVER);
>> +		list_del_init(&conn->conn_list_err);
>> +	}
>> +	mutex_unlock(&rx_queue_mutex);
>> +}
>> +
>>  void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>  {
>>  	struct nlmsghdr	*nlh;
>> @@ -2412,6 +2449,15 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>  	struct iscsi_uevent *ev;
>>  	struct iscsi_internal *priv;
>>  	int len = nlmsg_total_size(sizeof(*ev));
>> +	unsigned long flags;
>> +
>> +	if (kern_conn_failure) {
>> +		spin_lock_irqsave(&connlock, flags);
>> +		list_add(&conn->conn_list_err, &connlist_err);
>> +		spin_unlock_irqrestore(&connlock, flags);
>> +
>> +		queue_work(system_unbound_wq, &stop_conn_work);
>> +	}
>>  
> 
> Do you need the modparam? I think you could handle this issue and the
> similar one during shutdown at the same time, and you would always want
> to do the kernel based error handler when userspace is not answering for
> both cases.
> 
> You could do the following:
> 
> - Modify __iscsi_block_session so it does the stop_conn callout instead
> of reverse, and change the iscsi_stop_conn/ISCSI_UEVENT_STOP_CONN:
> related code accordingly.

Oh yeah, on second thought, I think I like how your new function above
calls into the stop_conn callout and everything works like it did
before. Ignore the __iscsi_block_session changes. But, I would drop the
modparam, always queue the work, and then fix up the system_state check.



> 
> - In iscsi_conn_error_event you would then do:
> 
> iscsi_multicast_skb();
> iscsi_block_session();
> 
> - You can then drop the system_state check in iscsi_eh_cmd_timed_out
> because those running commands are always handled by the stop_conn call
> in __iscsi_block_session now.
> 

