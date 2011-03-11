From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH 1/1] AACRAID driver update patch version - 28000
Date: Fri, 11 Mar 2011 10:21:02 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A90164D651@XYUS-EX22.xyus.xyratex.com>
References: <340C71CD25A7EB49BFA81AE8C8392667104CE89A@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:45758 "HELO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752949Ab1CKSWS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 13:22:18 -0500
Content-class: urn:content-classes:message
In-Reply-To: <340C71CD25A7EB49BFA81AE8C8392667104CE89A@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com

Looks good to me overall, except a very minor nit ...

@@ -63,9 +64,11 @@ static int fib_map_alloc(struct aac_dev 
 	  "allocate hardware fibs pci_alloc_consistent(%p, %d * (%d +
%d), %p)\n",
 	  dev->pdev, dev->max_fib_size, dev->scsi_host_ptr->can_queue,
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
-	if((dev->hw_fib_va = pci_alloc_consistent(dev->pdev,
dev->max_fib_size
-	  * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB),
-	  &dev->hw_fib_pa))==NULL)
+	dev->hw_fib_va = pci_alloc_consistent(dev->pdev,
+		(dev->max_fib_size + sizeof(struct aac_fib_xporthdr))
+		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) +
31,
+		&dev->hw_fib_pa);
+	if (dev->hw_fib_va == NULL)
 		return -ENOMEM;
 	return 0;
 }

MGS: 31 (here and elsewhere) constant seems arbitrary. What about using
a manifest-define to document? If it is related to the modulus 32 for
the max_fib_size for the new controller card(s), then these need to be
tied together with a manifest.

Sincerely -- Mark Salyzyn
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


