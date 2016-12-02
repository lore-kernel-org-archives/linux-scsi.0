From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi_dh_alua: Add return value and check for
 alua_rtpg_queue() to avoid DM devices I/Os hang
Date: Fri, 2 Dec 2016 02:58:00 +0000
Message-ID: <BLUPR02MB1683EAC61CDF43C2E9D3FA8F818E0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1479983105-7264-1-git-send-email-tang.junhui@zte.com.cn>
 <be5dbac2-6d45-1741-4eed-138aa109477c@sandisk.com>
 <OFADBB4E3F.FF85F07C-ON4825807D.0009F390-4825807D.0009FA01@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0062.outbound.protection.outlook.com ([104.47.41.62]:16219
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751364AbcLBC6C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 21:58:02 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>
Cc: "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/01/16 17:49, tang.junhui@zte.com.cn wrote:=0A=
>> Bart wrote:=0A=
>> Please drop this patch. I think the alua_rtpg_queue() caller should=0A=
>> ensure that pg !=3D NULL.=0A=
>=0A=
> Failure may also be occurred in queue_delayed_work(),=0A=
> since it would cause serious problems,=0A=
> so I think we are worth checking for it.=0A=
=0A=
Hello Tang,=0A=
=0A=
Have you been able to trigger the condition explained in the patch =0A=
description or is this only something you think that can happen based on =
=0A=
your interpretation of the source code? My comments about the checks =0A=
that have been added are:=0A=
* All alua_rtpg_queue() callers pass a non-NULL pointer as first =0A=
argument which means that the return statement under "if (!pg)" in =0A=
alua_rtpg_queue() is never executed.=0A=
* Even if queue_delayed_work() returns 0 the qdata work passed to =0A=
alua_rtpg_queue() is still added to the pg->rtpg_list and hence will be =0A=
executed once the delayed work is executed. So I think that the =0A=
condition you described (fn() not called) cannot happen. From =0A=
alua_rtpg_work():=0A=
=0A=
	list_splice_init(&pg->rtpg_list, &qdata_list);=0A=
         [ ... ]=0A=
	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {=0A=
		list_del(&qdata->entry);=0A=
		if (qdata->callback_fn)=0A=
			qdata->callback_fn(qdata->callback_data, err);=0A=
		kfree(qdata);=0A=
	}=0A=
=0A=
Bart.=0A=
=0A=
