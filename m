From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 29 Nov 2005 16:24:52 -0600
Message-ID: <1133303092.3492.58.camel@mulgrave>
References: <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <1132056707.6134.11.camel@localhost.localdomain>
	 <20051122083631.GA21523@infradead.org>
	 <1132695837.8928.11.camel@localhost.localdomain>
	 <1133110038.3331.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2693 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964787AbVK2WZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 17:25:08 -0500
In-Reply-To: <1133110038.3331.20.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On Sun, 2005-11-27 at 11:47 -0500, James Bottomley wrote:
> I assume your problems is also that the 53c7x0 chip on the MAC is also
> on a BE bus, so I think what you want is another flag:
> 
> 53c700_BE_BUS
> 
> which causes all the io macros to be ioread/write<n>be.  Which will
> avoid the nasty double swap we do on PA.

How about the attached.  I've tested it out on parisc and it works
fine ... in fact I'm tempted to commit it simply because we now avoid
the double swap for every I/O operation.

James

diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -232,21 +232,23 @@ struct NCR_700_Host_Parameters {
 #ifdef CONFIG_53C700_LE_ON_BE
 #define bE	(hostdata->force_le_on_be ? 0 : 3)
 #define	bSWAP	(hostdata->force_le_on_be)
-/* This is terrible, but there's no raw version of ioread32.  That means
- * that on a be board we swap twice (once in ioread32 and once again to 
- * get the value correct) */
-#define bS_to_io(x)	((hostdata->force_le_on_be) ? (x) : cpu_to_le32(x))
+#define bEBus	(!hostdata->force_le_on_be)
 #elif defined(__BIG_ENDIAN)
 #define bE	3
 #define bSWAP	0
-#define bS_to_io(x)	(x)
 #elif defined(__LITTLE_ENDIAN)
 #define bE	0
 #define bSWAP	0
-#define bS_to_io(x)	(x)
 #else
 #error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined, did you include byteorder.h?"
 #endif
+#ifndef bEBus
+#ifdef CONFIG_53C700_BE_BUS)
+#define bEBus	1
+#else
+#define bEBus	0
+#endif
+#endif
 #define bS_to_cpu(x)	(bSWAP ? le32_to_cpu(x) : (x))
 #define bS_to_host(x)	(bSWAP ? cpu_to_le32(x) : (x))
 
@@ -460,14 +462,15 @@ NCR_700_readl(struct Scsi_Host *host, __
 {
 	const struct NCR_700_Host_Parameters *hostdata
 		= (struct NCR_700_Host_Parameters *)host->hostdata[0];
-	__u32 value = ioread32(hostdata->base + reg);
+	__u32 value = bEBus ? ioread32be(hostdata->base + reg) :
+		ioread32(hostdata->base + reg);
 #if 1
 	/* sanity check the register */
 	if((reg & 0x3) != 0)
 		BUG();
 #endif
 
-	return bS_to_io(value);
+	return value;
 }
 
 static inline void
@@ -491,7 +494,8 @@ NCR_700_writel(__u32 value, struct Scsi_
 		BUG();
 #endif
 
-	iowrite32(bS_to_io(value), hostdata->base + reg);
+	bEBus ? iowrite32be(value, hostdata->base + reg): 
+		iowrite32(value, hostdata->base + reg);
 }
 
 #endif


