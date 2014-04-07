From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 0/7] Performance improvements for LSI SCSI cards
Date: Mon, 7 Apr 2014 11:51:28 +0000
Message-ID: <f1c6b225cf2043ec92c0b3b8ab2c9593@DM2PR07MB302.namprd07.prod.outlook.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:46320
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754774AbaDGLvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 07:51:32 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@kernel.org" <jejb@kernel.org>
Cc: "willy@linux.intel.com" <willy@linux.intel.com>, "James Bottomley (James.Bottomley@hansenpartnership.com)" <James.Bottomley@hansenpartnership.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "Krishnamoorthy, Praveen" <Praveen.Krishnamoorthy@lsi.com>

Hi James,

This patch set seem to be fine. Please consider this patch set as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>.

Regards,
Sreekanth

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Matthew Wilcox
>Sent: Friday, March 28, 2014 2:10 AM
>To: linux-scsi@vger.kernel.org
>Cc: Matthew Wilcox; willy@linux.intel.com
>Subject: [PATCH 0/7] Performance improvements for LSI SCSI cards
>
>The host lock is a serious scalability problem on 2-socket and larger systems
>which are doing a lot of I/O.  Before removing the temporary usgae of
>DEF_SCSI_QCMD, we need to remove all uses of serial_number.
>
>An unrelated performance issue is that reusing the most recent driver-specific
>data structure to track the I/O instead of the least recently used keeps the
>cache-hot lines in use, which is a nice performance improvement.  It's already
>present in the mpt3sas driver, it just didn't make it into the fusion or mpt2sas
>drivers yet.
>
>Matthew Wilcox (7):
>  mpt3sas: Remove uses of serial_number
>  mpt3sas: Remove use of DEF_SCSI_QCMD
>  mpt2sas: Remove uses of serial_number
>  mpt2sas: Remove use of DEF_SCSI_QCMD
>  mpt2sas: Add free smids to the head, not tail of list
>  fusion: Add free msg frames to the head, not tail of list
>  fusion: Remove use of DEF_SCSI_QCMD
>
> drivers/message/fusion/mptbase.c     |  2 +-
> drivers/message/fusion/mptfc.c       | 12 +++++-------
> drivers/message/fusion/mptsas.c      | 10 ++++------
> drivers/message/fusion/mptscsih.c    |  8 +++-----
> drivers/message/fusion/mptscsih.h    |  2 +-
> drivers/message/fusion/mptspi.c      | 12 +++++-------
> drivers/scsi/mpt2sas/mpt2sas_base.c  |  8 ++++----
>drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 +-
> drivers/scsi/mpt2sas/mpt2sas_ctl.c   |  2 +-
> drivers/scsi/mpt2sas/mpt2sas_scsih.c | 24 +++++++++---------------
>drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
> drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  2 +-
> drivers/scsi/mpt3sas/mpt3sas_scsih.c | 24 +++++++++---------------
> 13 files changed, 45 insertions(+), 65 deletions(-)
>
>--
>1.9.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body
>of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html

