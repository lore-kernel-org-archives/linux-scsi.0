From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] scsi/mpt2sas: remove unnecesscary preempt requirement
 for MSIX
Date: Mon, 30 Apr 2012 10:59:24 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E92EA43@inbmail02.lsi.com>
References: <1335594453-30679-1-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_A6888A6805518E4EA4AF7072A28264A6067E92EA43inbmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50051 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab2D3F3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 01:29:31 -0400
In-Reply-To: <1335594453-30679-1-git-send-email-alex.shi@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Shi <alex.shi@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

--_002_A6888A6805518E4EA4AF7072A28264A6067E92EA43inbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alex,=20
I submitted this patch already.=20

James, request you to pick up the patch that I previously submitted for fix=
ing this issue. Attaching the patch that I submitted previously.


Regards,
Nagalakshmi


-----Original Message-----
From: Alex Shi [mailto:alex.shi@intel.com]=20
Sent: Saturday, April 28, 2012 11:58 AM
To: JBottomley@parallels.com; Nandigama, Nagalakshmi
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; alex.shi@inte=
l.com
Subject: [PATCH] scsi/mpt2sas: remove unnecesscary preempt requirement for =
MSIX

smp_processor_id() need used in preempt safe ENV. Otherwise, the
cpu may be preempted and run on other cpus. But here, we don't care much
the specific CPU which handler the MSI, so just replace it by
raw_smp_processor_id() to avoid preempt debug warning.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index 8a59a77..3f518ba 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1785,7 +1785,7 @@ static inline void _base_writeq(__u64 b, volatile voi=
d __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[smp_processor_id()];
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
 }
=20
 /**
--=20
1.7.5.4


--_002_A6888A6805518E4EA4AF7072A28264A6067E92EA43inbmail02lsic_
Content-Type: message/rfc822

Received: from inbmail02.lsi.com ([135.36.98.34]) by inbexch02.lsi.com
 ([135.36.98.40]) with mapi; Fri, 27 Apr 2012 16:09:31 +0530
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya"
	<Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>
CC: "jejb@kernel.org" <jejb@kernel.org>
Date: Fri, 27 Apr 2012 16:09:16 +0530
Subject: RE: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in
 preemptible
Thread-Topic: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()
 in preemptible
Thread-Index: Ac0cXnM8pd70QzkTSlG9iySK5/0NiAIAyAzA
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E92E962@inbmail02.lsi.com>
References: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
In-Reply-To: <201204170553.q3H5rgCl016528@milmhbs0.lsil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 04
X-MS-Exchange-Organization-AuthSource: inbexch02.lsi.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

James, this patch is not picked up for 3.5. Request you to push this patch =
for next release.

Regards,
Nagalakshmi


-----Original Message-----
From: nagalakshmi.nandigama@lsi.com [mailto:nagalakshmi.nandigama@lsi.com]
Sent: Tuesday, April 17, 2012 11:25 AM
To: stable@vger.kernel.org; linux-scsi@vger.kernel.org; Nandigama, Nagalaks=
hmi; Prakash, Sathya; Moore, Eric
Cc: jejb@kernel.org
Subject: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id() in pr=
eemptible

When CONFIG_DEBUG_PREEMPT is enabled, bug is observed in the smp_processor_=
id().
This is because smp_processor_id() is not called in preempt safe condition.

To fix this issue, use raw_smp_processor_id instead of smp_processor_id.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
CC: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt=
2sas_base.c
index 272fab7..b010be0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1792,7 +1792,7 @@ static inline void _base_writeq(__u64 b, volatile voi=
d __iomem *addr,
 static inline u8
 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-       return ioc->cpu_msix_table[smp_processor_id()];
+       return ioc->cpu_msix_table[raw_smp_processor_id()];
 }

 /**

--_002_A6888A6805518E4EA4AF7072A28264A6067E92EA43inbmail02lsic_--
