From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()
 inpreemptible
Date: Fri, 20 Apr 2012 16:30:48 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E89B20C@inbmail02.lsi.com>
References: <20120418031441.GA10862@parisc-linux.org>
 <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com>
 <20120418041359.GB10862@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_A6888A6805518E4EA4AF7072A28264A6067E89B20Cinbmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49913 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab2DTLAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 07:00:55 -0400
In-Reply-To: <20120418041359.GB10862@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "jejb@kernel.org" <jejb@kernel.org>, Alex Shi <alex.shi@intel.com>

--_002_A6888A6805518E4EA4AF7072A28264A6067E89B20Cinbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Accepted.=20
Resent the patch.
Please see attached mail.

Regards,
Nagalakshmi


-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx]=20
Sent: Wednesday, April 18, 2012 9:44 AM
To: Moore, Eric
Cc: Nandigama, Nagalakshmi; stable@vger.kernel.org; linux-scsi@vger.kernel.=
org; Prakash, Sathya; jejb@kernel.org
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() i=
n preemptible

On Tue, Apr 17, 2012 at 09:35:49PM -0600, Moore, Eric wrote:
>  Jan Schmidt suggested using raw_smp_processor_id()  back in February, se=
e this: http://marc.info/?t=3D132974687100003&r=3D1&w=3D2
>=20
> Alex Shi recently suggested using preempt_disable() and preempt_enable() =
to solve the same issue, see this: http://marc.info/?t=3D133274303900003&r=
=3D1&w=3D2
>=20
> I believe the stack traces are there in both email discussion, they occur=
 when CONFIG_DEBUG_PREEMPT is enabled.
>=20
> I would rather go with the solution giving the best performance.   James =
Bottomley is there on the discussion with  Jan Schmidt, he suggested using =
get_cpu() and put_cpu().

I use get_cpu() / put_cpu() in the NVMe driver in similar circumstances.
It's not noticable in the profiles :-)

Where my usage differs from the patch for mpt2sas is that I hold a
reference to the CPU over the submission.  This works out well for
me because I have per-CPU state.  Might be worth considering for your
driver ...

--=20
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

--_002_A6888A6805518E4EA4AF7072A28264A6067E89B20Cinbmail02lsic_
Content-Type: message/rfc822

Received: from coshub01.lsi.com (135.142.2.64) by inbexch01.lsi.com
 (135.36.98.37) with Microsoft SMTP Server (TLS) id 8.3.213.0; Fri, 20 Apr
 2012 16:28:29 +0530
Received: from milmhbs0.lsil.com (147.145.1.30) by coshub01.lsi.com
 (135.142.2.64) with Microsoft SMTP Server id 8.3.213.0; Fri, 20 Apr 2012
 04:58:27 -0600
Received: from localhost ([135.24.234.21])	by milmhbs0.lsil.com
 (8.12.11/8.12.11) with ESMTP id q3KAwPlo019992;	Fri, 20 Apr 2012 03:58:26
 -0700
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>, "Nandigama,
 Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Moore, Eric"
	<Eric.Moore@lsi.com>
CC: "jejb@kernel.org" <jejb@kernel.org>
Date: Fri, 20 Apr 2012 16:28:39 +0530
Subject: [RESEND] [PATCH] [SCSI] mpt2sas : Fix unsafe using
 smp_processor_id() in preemptible
Thread-Topic: [RESEND] [PATCH] [SCSI] mpt2sas : Fix unsafe using
 smp_processor_id() in preemptible
Thread-Index: Ac0e5IU1rXe4ZOeZSr6eB5N8RCX96A==
Message-ID: <201204201058.q3KAwPlo019992@milmhbs0.lsil.com>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: coshub01.lsi.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-scanned-by: MIMEDefang 2.39
user-agent: Heirloom mailx 12.4 7/29/08
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

When CONFIG_DEBUG_PREEMPT is enabled, bug is observed in the smp_processor_=
id().
This is because smp_processor_id() is not called in preempt safe condition.

To fix this issue, use get_cpu() and put_cpu() instead of smp_processor_id.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
CC: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index 272fab7..0f47f56 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1792,7 +1792,10 @@ static inline void _base_writeq(__u64 b, volatile vo=
id __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-       return ioc->cpu_msix_table[smp_processor_id()];
+       int cpu =3D get_cpu();
+       put_cpu();
+       return ioc->cpu_msix_table[cpu];
+
 }

 /**

--_002_A6888A6805518E4EA4AF7072A28264A6067E89B20Cinbmail02lsic_--
