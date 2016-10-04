From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Tue, 4 Oct 2016 09:55:45 +0200
Message-ID: <20161004075545.j52mg3a2jckrchlp@linux-x5ow.site>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2016 at 11:14:57AM -0600, Robert LeBlanc wrote:
> We are having a reoccurring problem where iscsi_trx is going into D
> state. It seems like it is waiting for a session tear down to happen
> or something, but keeps waiting. We have to reboot these targets on
> occasion. This is running the 4.4.12 kernel and we have seen it on
> several previous 4.4.x and 4.2.x kernels. There is no message in dmesg
> or /var/log/messages. This seems to happen with increased frequency
> when we have a disruption in our Infiniband fabric, but can happen
> without any changes to the fabric (other than hosts rebooting).
> 
> # ps aux | grep iscsi | grep D
> root      4185  0.0  0.0      0     0 ?        D    Sep29   0:00 [iscsi_trx]
> root     18505  0.0  0.0      0     0 ?        D    Sep29   0:00 [iscsi_np]
> 
> # cat /proc/4185/stack
> [<ffffffff814cc999>] target_wait_for_sess_cmds+0x49/0x1a0
> [<ffffffffa087292b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
> [<ffffffff814f0de2>] iscsit_close_connection+0x162/0x840
> [<ffffffff814df8df>] iscsit_take_action_for_connection_exit+0x7f/0x100
> [<ffffffff814effc0>] iscsi_target_rx_thread+0x5a0/0xe80
> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> # cat /proc/18505/stack
> [<ffffffff814f0c71>] iscsit_stop_session+0x1b1/0x1c0
> [<ffffffff814e2436>] iscsi_check_for_session_reinstatement+0x1e6/0x270
> [<ffffffff814e4df0>] iscsi_target_check_for_existing_instances+0x30/0x40
> [<ffffffff814e4f40>] iscsi_target_do_login+0x140/0x640
> [<ffffffff814e62dc>] iscsi_target_start_negotiation+0x1c/0xb0
> [<ffffffff814e402b>] iscsi_target_login_thread+0xa9b/0xfc0
> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> What can we do to help get this resolved?
> 
> Thanks,
> 
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,
I've encountered the same issue and found a hack to fix it at [1] but I think
the correct way for handling this issue would be like you said to tear down 
the session in case a TASK ABORT times out. Unfortunately I'm not really
familiar with the target code myself so I mainly use this reply to get me into
the Cc loop.

[1] http://marc.info/?l=linux-scsi&m=147282568910535&w=2


-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
