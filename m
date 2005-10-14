From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6 - SCSI Config parameter always set ?
Date: Fri, 14 Oct 2005 09:03:47 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0510140842360.31568@shark.he.net>
References: <6.1.1.1.2.20051014161632.026dc918@192.168.6.2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:15846 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750776AbVJNQDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 12:03:48 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2005 09:03:47 -0700
In-Reply-To: <6.1.1.1.2.20051014161632.026dc918@192.168.6.2>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roger While <simrw@sim-basis.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 14 Oct 2005, Roger While wrote:

> CONFIG_SCSI_QLA2XXX=y
>
> It seems as though this is always set with no method
> of unsetting it.
> Is this intentional ?
>
> It's been like this since at least 2.6.11 up to current 2.6.14rc4.

Is it causing a problem?

It does cause drivers/scsi/qla2xxx/built-in.o to be built,
total of 8 bytes on my system.

Here's a patch for it.  Comments?

---
From: Randy Dunlap <rdunlap@xenotime.net>

Make it possible to enable or disable SCSI_QLA2XXX.
This saves building drivers/scsi/qla2xxx/built-in.o
and is consistent with how SCSI_SATA can be enabled or disabled.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---

 drivers/scsi/qla2xxx/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp linux-2614-rc4/drivers/scsi/qla2xxx/Kconfig~scsi_qla2x linux-2614-rc4/drivers/scsi/qla2xxx/Kconfig
--- linux-2614-rc4/drivers/scsi/qla2xxx/Kconfig~scsi_qla2x	2005-08-28 16:41:01.000000000 -0700
+++ linux-2614-rc4/drivers/scsi/qla2xxx/Kconfig	2005-10-14 08:55:31.000000000 -0700
@@ -1,5 +1,5 @@
 config SCSI_QLA2XXX
-	tristate
+	tristate "QLogic ISPxxxx family support"
 	default (SCSI && PCI)
 	depends on SCSI && PCI

