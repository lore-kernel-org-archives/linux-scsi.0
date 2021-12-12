Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3061C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Dec 2021 02:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhLLC4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Dec 2021 21:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhLLC4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Dec 2021 21:56:05 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3885AC061714
        for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2021 18:56:05 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639277762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnF8uWHe2dpFPPGbC/ZWu2RLegv5qCU6i6iI80qeS4w=;
        b=R60wgrrhOBihu44Vem2MTqyO9qukepjWKSbzJSl4KBVM2iiEXx+rN4wOCjPG1Xsj0QMf9i
        Jcy6ypQ1l2dzSpYF6NLK+hmDx0q0VDvTsdbW400MMrJ9k9IK6U54x6eRP0VI5Pi3UjGsHS
        T9+4E+XVKhyYgHPBuJMjjpSBx8l3y48=
Date:   Sun, 12 Dec 2021 02:56:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yanling.song@linux.dev
Message-ID: <52b05051cf00a9ad617c31f227654dcc@linux.dev>
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid
 driver
To:     "Bart Van Assche" <bvanassche@acm.org>,
        "Yanling Song" <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com, xuyun@ramaxel.com,
        yanggan@ramaxel.com
In-Reply-To: <399c013b-aaf9-1781-09a1-1acbc82b49ae@acm.org>
References: <399c013b-aaf9-1781-09a1-1acbc82b49ae@acm.org>
 <20211126073310.87683-1-songyl@ramaxel.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanling.song@linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

December 10, 2021 7:15 AM, "Bart Van Assche" <bvanassche@acm.org> wrote:=
=0A=0A> On 11/25/21 11:33 PM, Yanling Song wrote:=0A> =0A>> +struct sprai=
d_dev {=0A>> + struct pci_dev *pdev;=0A> =0A> Why a pointer to struct pci=
_dev instead of embedding struct pci_dev in this structure? The=0A> latte=
r approach is more efficient.=0A> =0AThe pointer of pci_dev is from linux=
 driver frame work probe() function, =0Aspraid driver does not allocate m=
emory for it, just save the pointer.=0A=0A>> + struct device *dev;=0A> =
=0A> What does this pointer represent? There is already a struct device i=
nside struct pci_dev. Can=0A> this member be left out?=0A> =0AThe pointer=
 of dev is from struct pci_dev. It is saved in struct spraid_dev just for=
 convenience:=0Aso that we do not need to get the dev from pci_dev every =
time when using dev.=0A=0A>> + struct spraid_cmd *adm_cmds;=0A>> + struct=
 list_head adm_cmd_list;=0A>> + spinlock_t adm_cmd_lock; /* spinlock for =
lock handling */=0A>> +=0A>> + struct spraid_cmd *ioq_ptcmds;=0A>> + stru=
ct list_head ioq_pt_list;=0A>> + spinlock_t ioq_pt_lock; /* spinlock for =
lock handling */=0A>> +=0A>> + struct work_struct scan_work;=0A>> + struc=
t work_struct timesyn_work;=0A>> + struct work_struct reset_work;=0A>> +=
=0A>> + enum spraid_state state;=0A>> + spinlock_t state_lock; /* spinloc=
k for lock handling */=0A>> + struct request_queue *bsg_queue;=0A> =0A> T=
he "spinlock for lock handling" comments are not useful. Please make thes=
e comments useful or=0A> remove these.=0A> =0AComments will be removed in=
 the next version.=0A=0A>> +#include <linux/version.h>=0A> =0A> Upstream =
drivers should not include this header file.=0A>=0AOk. Changes will be in=
cluded in the next version.=0A=0A>> +static u32 admin_tmout =3D 60;=0A>> =
+module_param(admin_tmout, uint, 0644);=0A>> +MODULE_PARM_DESC(admin_tmou=
t, "admin commands timeout (seconds)");=0A>> +=0AWill be changed to per S=
CSI host.=0A=0A>> +static u32 scmd_tmout_pt =3D 30;=0A>> +module_param(sc=
md_tmout_pt, uint, 0644);=0A>> +MODULE_PARM_DESC(scmd_tmout_pt, "scsi com=
mands timeout for passthrough(seconds)");=0A>> +=0AWill be deleted.=0A=0A=
>> +static u32 scmd_tmout_nonpt =3D 180;=0A>> +module_param(scmd_tmout_no=
npt, uint, 0644);=0A>> +MODULE_PARM_DESC(scmd_tmout_nonpt, "scsi commands=
 timeout for rawdisk&raid(seconds)");=0A>> +=0AWill be splitted into two =
attributes of scsi host:scmd_tmout_rawdisk, scmd_tmout_vd=0A=0A>> +static=
 u32 wait_abl_tmout =3D 3;=0A>> +module_param(wait_abl_tmout, uint, 0644)=
;=0A>> +MODULE_PARM_DESC(wait_abl_tmout, "wait abnormal io timeout(second=
s)");=0A>> +=0AWill be deleted.=0A=0A>> +static bool use_sgl_force;=0A>> =
+module_param(use_sgl_force, bool, 0644);=0A>> +MODULE_PARM_DESC(use_sgl_=
force, "force IO use sgl format, default false");=0A>=0AWill be deleted.=
=0A =0A> Consider leaving out all kernel module parameters. Kernel module=
 parameters are easy to introduce=0A> but can't be removed. Is it really =
necessary that the above parameters can be configured? If so,=0A> most of=
 the above parameters probably should be per SCSI host or SCSI device ins=
tead of module=0A> parameters.=0A> =0AComments as the above.=0A=0A>> +sta=
tic u32 io_queue_depth =3D 1024;=0A>> +module_param_cb(io_queue_depth, &i=
oq_depth_ops, &io_queue_depth, 0644);=0A>> +MODULE_PARM_DESC(io_queue_dep=
th, "set io queue depth, should >=3D 2");=0A> =0A> How does this differ f=
rom the SCSI sysfs attribute "can_queue"?=0A>=0AYes. it is the same as SC=
SI sysfs attribute "can_queue". =0AThe maximum queue depth supported by h=
ardware is 1024.  =0AThe parameter is to change the queue depth for diffe=
rent usages to get the best performance.=0A=0A =0A>> +static unsigned cha=
r log_debug_switch;=0A>> +module_param_cb(log_debug_switch, &log_debug_sw=
itch_ops, &log_debug_switch, 0644);=0A>> +MODULE_PARM_DESC(log_debug_swit=
ch, "set log state, default non-zero for switch on");=0A> =0A> Can this p=
arameter be left out by using pr_debug()?=0A>=0AYe. Will use pr_debug in =
the next version.=0A=0A =0A>> +static unsigned char small_pool_num =3D 4;=
=0A>> +module_param_cb(small_pool_num, &small_pool_num_ops, &small_pool_n=
um, 0644);=0A>> +MODULE_PARM_DESC(small_pool_num, "set prp small pool num=
, default 4, MAX 16");=0A> =0A> The description of the above parameter is=
 too cryptic.=0A>=0AWill add more comments:=0AIt was found that the spind=
lock of a single pool conflicts a lot with multiple CPUs.=0ASo multiple p=
ools are introduced to reduce the conflictions. =0A=0A =0A> Thanks,=0A> =
=0A> Bart.
