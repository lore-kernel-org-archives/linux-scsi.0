From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Mon, 22 May 2017 18:23:04 +0000
Message-ID: <1495477383.1017.3.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-21-himanshu.madhani@cavium.com>
         <1495237379.2581.19.camel@sandisk.com>
         <1495427279.27407.20.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38078 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933895AbdEVSXH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 14:23:07 -0400
In-Reply-To: <1495427279.27407.20.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <1C4C2A18C5CDB14A980B0F4BC1D971E1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Sun, 2017-05-21 at 21:27 -0700, Nicholas A. Bellinger wrote:
> The three lists abort_cmd_for_tag() walks from __qlt_24xx_handle_abts()
> are used to track descriptors only before __qlt_do_work() is reached,
> and before a descriptor is submitted into tcm_qla2xxx code.
>=20
> Or rather, the three lists in abort_cmd_for_tag() only contain
> qla_tgt_cmd or qla_tgt_sess_op descriptors that have not yet reached
> qla_tgt_func_tmpl->handle_cmd() code.
>=20
> Both qlt_do_work() and qlt_create_sess_from_atio() drop their respective
> descriptors from ->cmd_list before dispatching into tcm_qla2xxx ->
> target-core, which means there is no way for a descriptor to be part of
> internal lists once __qlt_do_work() is called.
>=20
> That said, the patch is correct and removes the redundant lookup.

I do not agree that this patch is makes ABTS handling fully robust. It seem=
s
like you have not noticed that the following race can occur with or without
this patch applied: if abort_cmd_for_tag() and qlt_try_to_dequeue_unknown_a=
tios()
are called concurrently, since the latter function calls list_del() after
qlt_send_term_exchange(), abort_cmd_for_tag() can return 1 and thereby trig=
ger
a call to qlt_24xx_send_abts_resp() while qlt_try_to_dequeue_unknown_atios(=
)
calls qlt_send_term_exchange() concurrently. I think an initiator could get
really confused if it receives two responses for the same exchange.

An existing issue that is not addressed by this patch is that if an ABTS is
received after qlt_do_work() has called list_del() and before __qlt_do_work=
()
triggers a call target_submit_cmd() that a command is not on any list and h=
ence
that abort_cmd_for_tag() won't be able to find it anywhere.

Shouldn't these issues be addressed properly?

Bart.=
