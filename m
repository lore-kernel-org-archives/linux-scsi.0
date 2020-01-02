Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17856C2D0C2
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 18:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C11215A4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 18:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgABSNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 13:13:43 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33808 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABSNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 13:13:43 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id E53F228AA34;
        Thu,  2 Jan 2020 18:13:39 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Khazhismel Kumykov <khazhy@google.com>
Cc:     lduncan@suse.com, Chris Leech <cleech@redhat.com>,
        jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "'Khazhismel Kumykov' via open-iscsi" <open-iscsi@googlegroups.com>,
        linux-scsi@vger.kernel.org, Bharath Ravi <rbharath@google.com>,
        kernel@collabora.com, Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Dave Clausen <dclausen@google.com>,
        Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>
Subject: Re: [PATCH v3] iscsi: Perform connection failure entirely in kernel space
In-Reply-To: <CACGdZYJ3hasgRV4MKpizX3rSQ1Tq4R+wDREcYXFUgx720ac5sg@mail.gmail.com>
        (Khazhismel Kumykov's message of "Thu, 2 Jan 2020 12:07:51 -0500")
Organization: Collabora
References: <20191226204746.2197233-1-krisman@collabora.com>
        <CACGdZYJ3hasgRV4MKpizX3rSQ1Tq4R+wDREcYXFUgx720ac5sg@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 02 Jan 2020 13:13:36 -0500
Message-ID: <85ftgx7mlr.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Khazhismel Kumykov <khazhy@google.com> writes:

> On Thu, Dec 26, 2019 at 3:48 PM Gabriel Krisman Bertazi
> <krisman@collabora.com> wrote:
>>
>> From: Bharath Ravi <rbharath@google.com>
>>
>> Connection failure processing depends on a daemon being present to (at
>> least) stop the connection and start recovery.  This is a problem on a
>> multipath scenario, where if the daemon failed for whatever reason, the
>> SCSI path is never marked as down, multipath won't perform the
>> failover and IO to the device will be forever waiting for that
>> connection to come back.
>>
>> This patch performs the connection failure entirely inside the kernel.
>> This way, the failover can happen and pending IO can continue even if
>> the daemon is dead. Once the daemon comes alive again, it can execute
>> recovery procedures if applicable.
>>
>> Changes since v2:
>>   - Don't hold rx_mutex for too long at once
>>
>> Changes since v1:
>>   - Remove module parameter.
>>   - Always do kernel-side stop work.
>>   - Block recovery timeout handler if system is dying.
>>   - send a CONN_TERM stop if the system is dying.
>>
>> Cc: Mike Christie <mchristi@redhat.com>
>> Cc: Lee Duncan <LDuncan@suse.com>
>> Cc: Bart Van Assche <bvanassche@acm.org>
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
>>  drivers/scsi/scsi_transport_iscsi.c | 63 +++++++++++++++++++++++++++++
>>  include/scsi/scsi_transport_iscsi.h |  1 +
>>  2 files changed, 64 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 271afea654e2..c6db6ded60a1 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -86,6 +86,12 @@ struct iscsi_internal {
>>         struct transport_container session_cont;
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
>> @@ -1611,6 +1617,7 @@ static DEFINE_MUTEX(rx_queue_mutex);
>>  static LIST_HEAD(sesslist);
>>  static DEFINE_SPINLOCK(sesslock);
>>  static LIST_HEAD(connlist);
>> +static LIST_HEAD(connlist_err);
>>  static DEFINE_SPINLOCK(connlock);
>>
>>  static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
>> @@ -2247,6 +2254,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>>
>>         mutex_init(&conn->ep_mutex);
>>         INIT_LIST_HEAD(&conn->conn_list);
>> +       INIT_LIST_HEAD(&conn->conn_list_err);
>>         conn->transport = transport;
>>         conn->cid = cid;
>>
>> @@ -2293,6 +2301,7 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>>
>>         spin_lock_irqsave(&connlock, flags);
>>         list_del(&conn->conn_list);
>> +       list_del(&conn->conn_list_err);
>>         spin_unlock_irqrestore(&connlock, flags);
>>
>>         transport_unregister_device(&conn->dev);
>> @@ -2407,6 +2416,51 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>>
>> +static void stop_conn_work_fn(struct work_struct *work)
>> +{
>> +       struct iscsi_cls_conn *conn, *tmp;
>> +       unsigned long flags;
>> +       LIST_HEAD(recovery_list);
>> +
>> +       spin_lock_irqsave(&connlock, flags);
>> +       if (list_empty(&connlist_err)) {
>> +               spin_unlock_irqrestore(&connlock, flags);
>> +               return;
>> +       }
>> +       list_splice_init(&connlist_err, &recovery_list);
>> +       spin_unlock_irqrestore(&connlock, flags);
>> +
>> +       list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
>> +               uint32_t sid = iscsi_conn_get_sid(conn);
>> +               struct iscsi_cls_session *session;
>> +
>> +               mutex_lock(&rx_queue_mutex);
> This worried me a bit, but it seems we won't destroy_conn while it's
> on the err list - cool.
>> +
>> +               session = iscsi_session_lookup(sid);
>> +               if (session) {
>> +                       if (system_state != SYSTEM_RUNNING) {
>> +                               session->recovery_tmo = 0;
>> +                               conn->transport->stop_conn(conn,
>> +                                                          STOP_CONN_TERM);
>> +                       } else {
>> +                               conn->transport->stop_conn(conn,
>> +                                                          STOP_CONN_RECOVER);
>> +                       }
>> +               }
>> +
>> +               list_del_init(&conn->conn_list_err);
>> +
>> +               mutex_unlock(&rx_queue_mutex);
>> +
>> +               /* we don't want to hold rx_queue_mutex for too long,
>> +                * for instance if many conns failed at the same time,
>> +                * since this stall other iscsi maintenance operations.
>> +                * Give other users a chance to proceed.
>> +                */
>> +               cond_resched();
>> +       }
>> +}
>> +
>>  void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>  {
>>         struct nlmsghdr *nlh;
>> @@ -2414,6 +2468,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>>         struct iscsi_uevent *ev;
>>         struct iscsi_internal *priv;
>>         int len = nlmsg_total_size(sizeof(*ev));
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&connlock, flags);
>> +       list_add(&conn->conn_list_err, &connlist_err);
>> +       spin_unlock_irqrestore(&connlock, flags);
>> +       queue_work(system_unbound_wq, &stop_conn_work);
>>
>>         priv = iscsi_if_transport_lookup(conn->transport);
>>         if (!priv)
>> @@ -2748,6 +2808,9 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
>>         if (!conn)
>>                 return -EINVAL;
>>
>> +       if (!list_empty(&conn->conn_list_err))
> Does this check need to be under connlock?

My understanding is that it is not necessary, since it is serialized
against the conn removal itself, through the rx_mutex, it seemed safe to
do the verification lockless.

It can only race with the insertion, in which case, it will be safely
removed from the dispatch list here, under rx_mutex, and the worker will
detect and skipped it.

-- 
Gabriel Krisman Bertazi
