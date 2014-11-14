From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCHv2 00/10] scsi logging update: the real thing
Date: Fri, 14 Nov 2014 22:59:42 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A86CF@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6611 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422639AbaKNXEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:04:10 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:30 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCHv2 00/10] scsi logging update: the real thing
> 
> Hi all,
> 
> this is the second part of my scsi logging update, covering
> CDB and sense code printing. With this patchset CDBs and
> sense code bytes will be formatted on a single line
> (where possible), and prefixed with the device and command
> tag.
> 
> To ensure CDBs and sense code bytes are not broken up during
> printk I've implemented a per-cpu buffer for formatting
> messages. One can allocate a chunk from the buffer using
> scsi_log_reserve_buffer() and return it via
> scsi_log_release_buffer().
> Both function do an implicit preempt_disable() / preempt_enable()
> to ensure we're not scheduled away from that cpu whilst writing
> into the buffer.
> 
> With that I've been able to clean up constants.c to remove all the
> #ifdef CONFIG_SCSI_CONSTANTS statements. It'll now be compiled in
> conditionally if CONFIG_SCSI_CONSTANTS is set.
> 
> Additionally I've updated the SCSI command definitions to SPC-3.
> 
> Thanks go to Stephen Rostedt who suffered my annoying questions
> during LPC.
> 

I've run with v2 for a while.  Tag prints look good;
CDBs are coming out on one line, etc.

I haven't tested every line of every patch, but I think I
exercised patches 3, 5, 7, and 8 pretty thoroughly, so you
may add this to those:

Tested-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage



