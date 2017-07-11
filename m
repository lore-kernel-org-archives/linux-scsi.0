From: =?UTF-8?B?5p2O5pil?= <pickup112@gmail.com>
Subject: Re: tgtd CPU 100% problem
Date: Tue, 11 Jul 2017 18:04:14 +0800
Message-ID: <CAGpjB9JXqEGfOO-DyFmoC6N_=dPOGhubM+-eZM=ZJ41DY44ytQ@mail.gmail.com>
References: <CAGpjB9JaSU45qi-_-fz7sF5sd=aEbLuNy6LL5fE2Md6zxqcgQQ@mail.gmail.com>
 <304976c9-88eb-7f4d-572c-5bd932208d52@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35580 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752167AbdGKKEQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 06:04:16 -0400
In-Reply-To: <304976c9-88eb-7f4d-572c-5bd932208d52@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

Thanks very much for reply.
I think it may be better to  assert failed to exit problem than run
the endless loop after receivered DEVICE_REMOVAL event.
Or we can sleep 5 ms to check if the conn->h.state is STATE_FULL.

2017-07-11 16:29 GMT+08:00 Sagi Grimberg <sagi@grimberg.me>:
>
>
> On 11/07/17 10:51, =E6=9D=8E=E6=98=A5 wrote:
>>
>> We have meet a problem of tgtd CPU 100%.
>>
>> the infinband network card was negotiate as eth mode by mistake,
>> after we change it to ib mode and restart opensmd for correct
>> State=EF=BC=88Active=EF=BC=89
>> the tgtd using 100% of CPU. and when we connect to it using tgtadm,
>> tgtadm hang forever.
>>
>> # how to repeat
>>
>> * tgtd export a disk throught port 3260 of iser
>> * iscsiadm login a target from tgt through infiniband
>>
>> * connectx_port_config set the mellanox infiniband to eth mode
>> * connectx_port_config set the mellanox infiniband to ib mode
>> * /etc/init.d/opensmd restart
>> * tgtadm connect to tgt will hang
>>
>> # error messge
>>
>> ```
>> Jul  1 21:32:37 shadow tgtd: iser_handle_rdmacm(1628) Unsupported
>> event:11, RDMA_CM_EVENT_DEVICE_REMOVAL - ignored
>> Jul  1 21:32:37 shadow tgtd: iser_handle_rdmacm(1628) Unsupported
>> event:11, RDMA_CM_EVENT_DEVICE_REMOVAL - ignored
>>
>> Jul  1 21:32:39 shadow tgtd: iser_handle_async_event(3174) dev:mlx4_0
>> HCA evt: local catastrophic error
>
>
> iser code in tgtd does not know how to correctly handle RDMA device
> removal events (and it never did).
>
> The event is generated from the port configuration step while
> tgt-iser is bound to it. Once the device is removed the device
> handle tgt-iser has is essentially unusable, which explains
> the qp creation failures below.
>
> Handling DEVICE_REMOVAL event handling is a new feature request.
>
>> Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1471)
>> conn:0x1380bf0 cm_id:0x1380950 rdma_create_qp failed, Cannot allocate
>> memory
>> Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1520)
>> cm_id:0x1380950 rdma_reject failed, Bad file descriptor
>> Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1471)
>> conn:0x1380bf0 cm_id:0x1380950 rdma_create_qp failed, Cannot allocate
>> memory
>
>
> And also tgt-iser cannot even reject the (re)connect request.
>
>> Jul  1 21:46:56 shadow tgtd: iser_cm_connect_request(1520)
>> cm_id:0x1380950 rdma_reject failed, Bad file descriptor
>> ``



--=20
pickup.lichun =E6=9D=8E=E6=98=A5
