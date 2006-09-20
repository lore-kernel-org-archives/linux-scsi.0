From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg driver for large page_size, lk 2.6.18
Date: Wed, 20 Sep 2006 18:20:49 -0400
Message-ID: <4511BEC1.8030809@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090508040509040806060208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58048 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932395AbWITWUz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 18:20:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: david.falkinder@hp.com

This is a multi-part message in MIME format.
--------------090508040509040806060208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This sg driver patch addresses the problem with larger
page sizes reported by Brian King in this post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115867718623631&w=2
Some other related matters are also addressed. Some of these
prevent oopses when the SG_SCATTER_SZ or scatter_elem_sz are
set to inappropriate values.

The scatter_elem_sz has been tested up to 4 MB which should
make the largest data transfer with one SCSI command, 32 MB
less one block, achievable with a relatively small number
of elements in the scatter gather list.

For consideration in lk 2.6.19 . The patch is against lk 2.6.18 .

  ChangeLog:
    - add scatter_elem_sz boot time parameter and sysfs module
      parameter that is initialized to SG_SCATTER_SZ
    - the driver will then adjust scatter_elem_sz to be the
      max(given(scatter_elem_sz), PAGE_SIZE)
      It will also round it up, if necessary, to be a power
      of two
    - clean up sg.h header, correct bad urls and some statements
      that are no longer valid
    - make the def_reserved_size sysfs module attribute writable

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------090508040509040806060208
Content-Type: application/x-gzip;
 name="sg_2618scat.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sg_2618scat.diff.gz"

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
--------------090508040509040806060208--
