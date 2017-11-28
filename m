From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 14/22] qla2xxx: Fix nested spinlock
Date: Tue, 28 Nov 2017 21:38:57 +0000
Message-ID: <F873F5EF-0F1D-4E73-82C4-081D048BAF96@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
 <20171128193503.13695-15-himanshu.madhani@cavium.com>
 <1511898300.28512.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0065.outbound.protection.outlook.com ([104.47.34.65]:24656
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751893AbdK1VjD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 16:39:03 -0500
In-Reply-To: <1511898300.28512.20.camel@wdc.com>
Content-Language: en-US
Content-ID: <8F57810A698F774F983AF75775B1D60D@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On Nov 28, 2017, at 11:45 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-11-28 at 11:34 -0800, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> Nesting spinlocks is allowed so I think a more detailed description
> is required for this patch. It would help e.g. to explain why this
> patch is a bug fix and also what it fixes.
>=20
> Thanks,
>=20
> Bart.

Apology for using wrong subject for this patch.=20

we ran into this deadlock issue while unloading driver and stack trace show=
s following

#14 [ffff9f2e21e03db8] native_queued_spin_lock_slowpath at ffffffffad0d8802
#15 [ffff9f2e21e03dc0] do_raw_spin_lock at ffffffffad0d99e4
#16 [ffff9f2e21e03dd8] _raw_spin_lock_irqsave at ffffffffad652471
#17 [ffff9f2e21e03e00] qla2x00_els_dcmd_iocb_timeout at ffffffffc070cd63 [q=
la2xxx]
#18 [ffff9f2e21e03e40] qla2x00_sp_timeout at ffffffffc06f06d3 [qla2xxx]
#19 [ffff9f2e21e03e68] call_timer_fn at ffffffffad0f97d8
#20 [ffff9f2e21e03ed8] run_timer_softirq at ffffffffad0faf47
#21 [ffff9f2e21e03f68] __softirqentry_text_start at ffffffffad655f32

There is patch #19 (https://patchwork.kernel.org/patch/10080967/) later in =
this series which ultimately removes
this block of code protected by these spin locks. if you prefer i can merge=
 this patch with the other patch and=20
add more description

Thanks,
- Himanshu=
