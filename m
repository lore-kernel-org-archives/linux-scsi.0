From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid 2.00.09
Date: Fri, 17 Oct 2003 13:39:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133951.D27349@infradead.org>
References: <1065576771.2684.1.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:52999 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263454AbTJQMjx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:39:53 -0400
Content-Disposition: inline
In-Reply-To: <1065576771.2684.1.camel@fuzzy>; from James.Bottomley@steeleye.com on Wed, Oct 08, 2003 at 07:02:46AM +0530
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, atulm@lsil.com

- * Copyright =A9 2002  LSI Logic Corporation.
+ * Copyright =C2=A9 2002  LSI Logic Corporation.

Strange encoding?

@@ -358,6 +368,21 @@
 		adapter =3D (adapter_t *)host->hostdata;
 		memset(adapter, 0, sizeof(adapter_t));
=20
+		/*
+		 * Allocate a pci device structure for allocations done
+		 * internally - all of which would be in memory <4GB
+		 */
+		adapter->ipdev =3D kmalloc(sizeof(struct pci_dev), GFP_KERNEL);
+
+		if( adapter->ipdev =3D=3D NULL ) goto fail_attach;

	This is wrong.  We have the consistent_dma_mask for this.

+
+		got_ipdev_f =3D 1;

this got_foo / did_foo stuff is crap - use proper gotos for unwinding,

+
+		adapter->host_lock =3D &adapter->lock;
+
 		scsi_assign_lock(host, &adapter->lock);

still b0rked.  The driver shouldn't use scsi_assign_lock which
it's one of the last users of but just use host->host_lock directly
everywhere.
	=09
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
