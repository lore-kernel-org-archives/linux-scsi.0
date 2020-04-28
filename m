Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6932AC83001
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 17:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B0020757
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 17:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="if1yEGpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgD1Rux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 13:50:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728590AbgD1Ruw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 13:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588096250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8lRv+tCtSu1UNwULxaTKR3MF4r3f7PH3zkbzUaNx1RU=;
        b=if1yEGpHD/UqYI4O3ogvFv17aOdPmMOL3mQtAAxtqw9eV++o3jffSWZ+kD5G0EF3jfkcCw
        loBG9R14+3+/auaU6Gn0fVxkLKrOS+85+LG3+k/KyQWjjpgzBAaZlrs/gQIebwTv/715kR
        tiYS/8Vh0eZA9r2BQKWPq7Nc4Ee/LJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-Gudx8GXMPMqKUGcQvU2QVA-1; Tue, 28 Apr 2020 13:50:46 -0400
X-MC-Unique: Gudx8GXMPMqKUGcQvU2QVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9516F108BD0B;
        Tue, 28 Apr 2020 17:50:44 +0000 (UTC)
Received: from [10.10.112.215] (ovpn-112-215.rdu2.redhat.com [10.10.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A393C5C1BD;
        Tue, 28 Apr 2020 17:50:43 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] iscsi-target: fix login error when receiving is
 too fast
To:     Hou Pu <houpu@bytedance.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200424123528.17627-1-houpu@bytedance.com>
 <20200424123528.17627-2-houpu@bytedance.com>
 <cee3c624-4d43-fd4c-1436-cfc0c08a4321@redhat.com>
 <8f3b123e-1dc3-54ba-ae6d-90e76e5702b5@redhat.com>
 <44a02338-0923-5b57-ed26-8528bf9cde70@bytedance.com>
 <ef4dce23-dca8-c75a-0e18-c4bb49fe503a@bytedance.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <f8e06fd6-d2d5-b237-7d32-86ee3277e85f@redhat.com>
Date:   Tue, 28 Apr 2020 12:50:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ef4dce23-dca8-c75a-0e18-c4bb49fe503a@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/20 1:09 AM, Hou Pu wrote:
>=20
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 if (conn->sock) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sock *sk =3D con=
n->sock->sk;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_lock_bh(&sk->sk_c=
allback_lock);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(LOGIN_FLAGS_R=
EAD_ACTIVE, &conn->login_flags);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(LOGIN_FLAGS_WRI=
TE_ACTIVE, &conn->login_flags);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_unlock_bh(&sk->sk=
_callback_lock);
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +
>>>> Hey,
>>>>
>>>> I had one more question.
>>>>
>>>> With the above code, I think we have a race where if we clear the bi=
t
>>>> above early and iscsi_target_sk_data_ready runs while
>>>> iscsi_target_do_login_rx is still running then we could queue the wo=
rk
>>>> an extra time and get stuck. Because the bit is now not set, if
>>>> iscsi_target_sk_data_ready runs it will end up calling
>>>> schedule_delayed_work which will queue up the work again since the w=
ork
>>>> is running and not pending.
>>
>> Yes. I was trying to allow queuing the delayed work early.
>>
>>>>
>>>> If that is correct and we hit the race what happens if this was the
>>>> last
>>>> login pdu, and we are supposed to go to full feature phase next? For
>>>> example if iscsi_target_do_login_rx runs an extra time, will we end =
up
>>>> stuck waiting in iscsi_target_do_login_rx's call to:
>>>>
>>>> rc =3D conn->conn_transport->iscsit_get_login_rx(conn, login);
>>>>
>>>> ?
>>
>> For the last login pdu, we may have race as you said. thanks for
>> pointing it out.
>>
>> I was trying to image a case where we can hit the race, normally it is
>> case a).
>>
>> a). initiator send last login pdu -> target received -> target replied
>>
>> b). initiator send last login pdu -> target received -> initiator send
>> something -> target replied
>>
>> in case b). we will queue another delayed work which we should not.=C2=
=A0
>> After the target replied
>>
>> the last login pdu, conn->conn_login is freed. we might visited it in
>> the delayed wo>>
>>
>>> Just answering my own question. It looks like we do not get stuck. Bu=
t
>>> we either get nothing on the session so the login timeout fires and w=
e
>>> drop the session. Or, we get a PDU and the login thread reads it in
>>> before the normal rx thread does, but it assumes it is a login relate=
d
>>> and we most likely drop the session due to invalid fields.
>>>
>>> I think in iscsi_target_restore_sock_callbacks we want to do a:
>>>
>>> cancel_delayed_work(&conn->login_work)
>>>
>>> after we reset the callbacks and drop the sk_callback_lock lock.
>>
>> I am not very sure if we could or if it is good to cancel_delayed_work
>> from the work itself.
>>
>> If it is ok then i am ok with it. Or in another way, I think we could
>> just clear
>>
>> LOGIN_FLAGS_READ_ACTIVE and set LOGIN_FLAGS_WRITE_ACTIVE
>>
>> after iscsi_target_restore_sock_callbacks when finish process last
>> login pdu.
>=20
> That would look like (in iscsi_target_do_tx_login_io):
>=20
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c
> b/drivers/target/iscsi/iscsi_target_nego.c
> index 685d771b51d4..4d0658731382 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -328,6 +328,28 @@ static int iscsi_target_do_tx_login_io(struct
> iscsi_conn *conn, struct iscsi_log
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 padding =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iscsi_login_rsp *logi=
n_rsp;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * LOGIN_FLAGS_READ_ACTIVE i=
s cleared so that sk_data_ready
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * could be trigger again af=
ter this.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * LOGIN_FLAGS_WRITE_ACTIVE =
is cleared after we successfully
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * process a login pdu, so t=
hat sk_state_chage could do login
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * cleanup as needed if the =
socket is closed. If a delayed work is
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ongoing (LOGIN_FLAGS_WRIT=
E_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sk_state_change will leav=
e the cleanup to the delayed work or
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it will schedule a delaye=
d work to do cleanup.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (conn->sock) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 struct sock *sk =3D conn->sock->sk;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 write_lock_bh(&sk->sk_callback_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!test_bit(LOGIN_FLAGS_INITIAL_PDU,
> &conn->login_flags)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_bit(LO=
GIN_FLAGS_READ_ACTIVE,
> &conn->login_flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(LOGI=
N_FLAGS_WRITE_ACTIVE,
> &conn->login_flags);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 write_unlock_bh(&sk->sk_callback_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }

You lost me. I didn't understand this part. Would you still be doing the
above bit manipulation in iscsi_target_do_login_rx too?

Is the above code then to handle when
iscsi_target_start_negotiation->iscsi_target_do_login->iscsi_target_do_tx=
_login_io
runs?

I was thinking when you mentioned the final login PDU you were going to
do something when you detect login->login_complete is true.

This code is not my expertise area, so I might just not be understanding
something simple about how it all works.

