From: Zhu Lingshan <lszhu@suse.com>
Subject: Re: iscsi_trx going into D state
Date: Sat, 8 Oct 2016 10:59:12 +0800
Message-ID: <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:44223 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbcJHC7V (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 7 Oct 2016 22:59:21 -0400
In-Reply-To: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi Robert,

I also see this issue, but this is not the only code path can trigger 
this problem, I think you may also see iscsi_np in D status. I fixed one 
code path whitch still not merged to mainline. I will forward you my 
patch later. Note: my patch only fixed one code path, you may see other 
call statck with D status.

Thanks,
BR
Zhu Lingshan

在 2016/10/1 1:14, Robert LeBlanc 写道:
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
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

