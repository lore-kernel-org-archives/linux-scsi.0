From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi_dh_alua: Add return value and check for
 alua_rtpg_queue() to avoid DM devices I/Os hang
Date: Fri, 2 Dec 2016 03:40:20 +0000
Message-ID: <BLUPR02MB168326B3A17118AA236DBB81818E0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1479983105-7264-1-git-send-email-tang.junhui@zte.com.cn>
 <be5dbac2-6d45-1741-4eed-138aa109477c@sandisk.com>
 <OFADBB4E3F.FF85F07C-ON4825807D.0009F390-4825807D.0009FA01@zte.com.cn>
 <BLUPR02MB1683EAC61CDF43C2E9D3FA8F818E0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <OF78D5B916.DC66A918-ON4825807D.0010D67E-4825807D.001269A1@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:42176
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752102AbcLBDkW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 22:40:22 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>
Cc: "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/01/16 19:21, tang.junhui@zte.com.cn wrote:=0A=
> Hello Bart,=0A=
>> * Even if queue_delayed_work() returns 0 the qdata work passed to=0A=
>> alua_rtpg_queue() is still added to the pg->rtpg_list and hence will be=
=0A=
>> executed once the delayed work is executed. So I think that the=0A=
>> condition you described (fn() not called) cannot happen.=0A=
>=0A=
> I find it by reading code.=0A=
>=0A=
> How did you think that it will be=0A=
> executed once the delayed work is executed?=0A=
> It is not re-queued to the pg->rtpg_work again.=0A=
> It is triggered by pgpath->activate_path.work in dm-mod,=0A=
> and maybe it would never run anymore.=0A=
=0A=
Hello Tang,=0A=
=0A=
Are you aware that if queue_delayed_work() returns 0 that that means =0A=
that a work item has already been queued (pg->rtpg_work in this case)? =0A=
 From kernel/workqueue.c:=0A=
=0A=
/**=0A=
  * queue_delayed_work_on - queue work on specific CPU after delay=0A=
  * @cpu: CPU number to execute work on=0A=
  * @wq: workqueue to use=0A=
  * @dwork: work to queue=0A=
  * @delay: number of jiffies to wait before queueing=0A=
  *=0A=
  * Return: %false if @work was already on a queue, %true otherwise.  If=0A=
  * @delay is zero and @dwork is idle, it will be scheduled for immediate=
=0A=
  * execution.=0A=
  */=0A=
=0A=
Bart.=0A=
=0A=
