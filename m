From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Mon, 17 Oct 2016 10:32:12 -0600
Message-ID: <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36398 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935983AbcJQQcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 12:32:14 -0400
Received: by mail-oi0-f50.google.com with SMTP id m72so218661984oik.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 09:32:14 -0700 (PDT)
In-Reply-To: <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhu Lingshan <lszhu@suse.com>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

Some more info as we hit this this morning. We have volumes mirrored
between two targets and we had one target on the kernel with the three
patches mentioned in this thread [0][1][2] and the other was on a
kernel without the patches. We decided that after a week and a half we
wanted to get both targets on the same kernel so we rebooted the
non-patched target. Within an hour we saw iSCSI in D state with the
same stack trace so it seems that we are not hitting any of the
WARN_ON lines. We are getting both iscsi_trx and iscsi_np both in D
state, this time we have two iscsi_trx processes in D state. I don't
know if stale sessions on the clients could be contributing to this
issue (the target trying to close non-existent sessions??). This is on
4.4.23. Any more debug info we can throw at this problem to help?

Thank you,
Robert LeBlanc

# ps aux | grep D | grep iscsi
root     16525  0.0  0.0      0     0 ?        D    08:50   0:00 [iscsi_np]
root     16614  0.0  0.0      0     0 ?        D    08:50   0:00 [iscsi_trx=
]
root     16674  0.0  0.0      0     0 ?        D    08:50   0:00 [iscsi_trx=
]

# for i in 16525 16614 16674; do echo $i; cat /proc/$i/stack; done
16525
[<ffffffff814f0d5f>] iscsit_stop_session+0x19f/0x1d0
[<ffffffff814e2516>] iscsi_check_for_session_reinstatement+0x1e6/0x270
[<ffffffff814e4ed0>] iscsi_target_check_for_existing_instances+0x30/0x40
[<ffffffff814e5020>] iscsi_target_do_login+0x140/0x640
[<ffffffff814e63bc>] iscsi_target_start_negotiation+0x1c/0xb0
[<ffffffff814e410b>] iscsi_target_login_thread+0xa9b/0xfc0
[<ffffffff8109c748>] kthread+0xd8/0xf0
[<ffffffff8172018f>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff
16614
[<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
[<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
[<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
[<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
[<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
[<ffffffff8109c748>] kthread+0xd8/0xf0
[<ffffffff8172018f>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff
16674
[<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
[<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
[<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
[<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
[<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
[<ffffffff8109c748>] kthread+0xd8/0xf0
[<ffffffff8172018f>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff


[0] https://www.spinics.net/lists/target-devel/msg13463.html
[1] http://marc.info/?l=3Dlinux-scsi&m=3D147282568910535&w=3D2
[2] http://www.spinics.net/lists/linux-scsi/msg100221.html
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Fri, Oct 7, 2016 at 8:59 PM, Zhu Lingshan <lszhu@suse.com> wrote:
> Hi Robert,
>
> I also see this issue, but this is not the only code path can trigger thi=
s
> problem, I think you may also see iscsi_np in D status. I fixed one code
> path whitch still not merged to mainline. I will forward you my patch lat=
er.
> Note: my patch only fixed one code path, you may see other call statck wi=
th
> D status.
>
> Thanks,
> BR
> Zhu Lingshan
>
>
> =E5=9C=A8 2016/10/1 1:14, Robert LeBlanc =E5=86=99=E9=81=93:
>>
>> We are having a reoccurring problem where iscsi_trx is going into D
>> state. It seems like it is waiting for a session tear down to happen
>> or something, but keeps waiting. We have to reboot these targets on
>> occasion. This is running the 4.4.12 kernel and we have seen it on
>> several previous 4.4.x and 4.2.x kernels. There is no message in dmesg
>> or /var/log/messages. This seems to happen with increased frequency
>> when we have a disruption in our Infiniband fabric, but can happen
>> without any changes to the fabric (other than hosts rebooting).
>>
>> # ps aux | grep iscsi | grep D
>> root      4185  0.0  0.0      0     0 ?        D    Sep29   0:00
>> [iscsi_trx]
>> root     18505  0.0  0.0      0     0 ?        D    Sep29   0:00
>> [iscsi_np]
>>
>> # cat /proc/4185/stack
>> [<ffffffff814cc999>] target_wait_for_sess_cmds+0x49/0x1a0
>> [<ffffffffa087292b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>> [<ffffffff814f0de2>] iscsit_close_connection+0x162/0x840
>> [<ffffffff814df8df>] iscsit_take_action_for_connection_exit+0x7f/0x100
>> [<ffffffff814effc0>] iscsi_target_rx_thread+0x5a0/0xe80
>> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
>> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> # cat /proc/18505/stack
>> [<ffffffff814f0c71>] iscsit_stop_session+0x1b1/0x1c0
>> [<ffffffff814e2436>] iscsi_check_for_session_reinstatement+0x1e6/0x270
>> [<ffffffff814e4df0>] iscsi_target_check_for_existing_instances+0x30/0x40
>> [<ffffffff814e4f40>] iscsi_target_do_login+0x140/0x640
>> [<ffffffff814e62dc>] iscsi_target_start_negotiation+0x1c/0xb0
>> [<ffffffff814e402b>] iscsi_target_login_thread+0xa9b/0xfc0
>> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
>> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> What can we do to help get this resolved?
>>
>> Thanks,
>>
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
