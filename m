From: =?UTF-8?B?5p2O5pil?= <pickup112@gmail.com>
Subject: tgtd CPU 100% problem
Date: Tue, 11 Jul 2017 15:51:43 +0800
Message-ID: <CAGpjB9JaSU45qi-_-fz7sF5sd=aEbLuNy6LL5fE2Md6zxqcgQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We have meet a problem of tgtd CPU 100%.

the infinband network card was negotiate as eth mode by mistake,
after we change it to ib mode and restart opensmd for correct State=EF=BC=
=88Active=EF=BC=89
the tgtd using 100% of CPU. and when we connect to it using tgtadm,
tgtadm hang forever.

# how to repeat

* tgtd export a disk throught port 3260 of iser
* iscsiadm login a target from tgt through infiniband

* connectx_port_config set the mellanox infiniband to eth mode
* connectx_port_config set the mellanox infiniband to ib mode
* /etc/init.d/opensmd restart
* tgtadm connect to tgt will hang

# error messge

```
Jul  1 21:32:37 shadow tgtd: iser_handle_rdmacm(1628) Unsupported
event:11, RDMA_CM_EVENT_DEVICE_REMOVAL - ignored
Jul  1 21:32:37 shadow tgtd: iser_handle_rdmacm(1628) Unsupported
event:11, RDMA_CM_EVENT_DEVICE_REMOVAL - ignored

Jul  1 21:32:39 shadow tgtd: iser_handle_async_event(3174) dev:mlx4_0
HCA evt: local catastrophic error

Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1471)
conn:0x1380bf0 cm_id:0x1380950 rdma_create_qp failed, Cannot allocate
memory
Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1520)
cm_id:0x1380950 rdma_reject failed, Bad file descriptor
Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1471)
conn:0x1380bf0 cm_id:0x1380950 rdma_create_qp failed, Cannot allocate
memory
Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1520)
cm_id:0x1380950 rdma_reject failed, Bad file descriptor
```

# what we found

we have download the lastest 1.0.70 source code and found the problem
in usr/iscsi/iser.c:iser_nop_work_handler()

```
list_for_each_entry(conn, &iser_conn_list, conn_list) {
if (conn->h.state !=3D STATE_FULL)
continue;
task =3D conn->nop_in_task;
if (!task)
continue;
conn->nop_in_task =3D NULL;
iser_send_ping_nop_in(task);
}

```
because the conn->h.state will not be STATE_FULL it become a dead loop
of first 3 lines.

Can any one find the reason and fix the problem.

--=20
pickup.li
