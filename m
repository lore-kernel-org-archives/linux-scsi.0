From: Andrew Morton <akpm@osdl.org>
Subject: fdomain screwup
Date: Mon, 21 Jun 2004 22:08:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621220801.0a7784c2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:993 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266484AbUFVFI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:08:56 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i5M58tr20251
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 22:08:55 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- fdomain_setup() is marked __init, but is called from non-__init
  fdomain_16x0_detect()

- fdomain_setup() is declared in drivers/scsi/pcmcia/fdomain_stub.c as
  taking two arguments, but is implemented in fdomain_setup() taking a
  single argument.

  Please, never ever ever put extern function declarations in .c files. 
  Put it in a header file which is visible to the definition and to all
  callsites.

- fdomain_setup() is declared static, hence the linkage fails.

- fdomain_16x0_bus_reset() is implemented in drivers/scsi/fdomain.c but
  has static scope, so the call from drivers/scsi/pcmcia/fdomain_stub.c
  doesn't work.

- fdomain_16x0_bus_reset() has an extern declaration in
  drivers/scsi/pcmcia/fdomain_stub.c.  This should be moved to a header
  file which is visible to etc...

