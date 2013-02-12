From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Tue, 12 Feb 2013 20:57:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950D4811C@G4W3304.americas.hpqcorp.net>
References: <511A87CA.5010901@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:25844 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3BLVHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 16:07:05 -0500
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B0444601FC
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 20:58:59 +0000 (UTC)
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t3425.houston.hp.com (Postfix) with ESMTPS id 7F43A6C
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 20:58:25 +0000 (UTC)
In-Reply-To: <511A87CA.5010901@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I like that concept.  

Since TMFs are protocol specific, though, it is possible that the SCSI initiator port doesn't know how to send a TMF even though the device server supports that TMF.  The SCSI Architecture Model (SAM-5) standard includes an annex listing a variety of SCSI Initiator Port attributes and SCSI Target Port attributes that can limit what an application client and device server can do:
- LUN size
- Maximum CDB length
- Command Identifier size (i.e. tag size)
- Task Attributes supported (which ones) (e.g., SIMPLE, HEAD OF QUEUE, ORDERED, ACA)
- Maximum Data-In Buffer size
- Maximum Data-Out Buffer size
- Command Reference Number supported?
- Command Priority supported?
- Maximum Sense Data length
- Status Qualifier supported?
- Additional Response Information supported?
- Bidirectional Commands supported?
- TMFs supported (which ones)

How the application client determines what the SCSI initiator port supports is outside the scope of the SCSI standards - there's no SCSI command or TMF to report that information.  These attributes are first constrained by the SCSI transport protocol (e.g., SRP doesn't define an encoding for QUERY TASK), then by implementation choices (e.g., bidirectional commands and >16-byte CDBs are still not widely supported).

Ideally the device driver for the SCSI initiator port would report those attributes, and higher level code would combine them with support information from the device server (REPORT SUPPORTED TMF command, REPORT SUPPORTED OPCODES command, etc.) to decide what is supported.

---
Rob Elliott    HP Server Storage







> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jeremy Linton
> Sent: Tuesday, 12 February, 2013 12:20 PM
> To: Linux Scsi
> Subject: [PATCH] Use a more selective error recovery strategy based on device
> capabilities
> 
> Ideally, Linux should not be sending task management commands to devices
> that
> don't support the given task mgmt operation.
> 
> This patch uses the REPORT SUPPORTED TASK MGMT FUNCTIONS command to
> enable or
> disable error recovery paths for a given device. For older devices, we make an
> educated guess about what kind of error recovery the device supports. This isn't
> going to be 100% accurate as it should probably take the transport as well as
> the SCSI version into account, but it is a start.
> 
> While this patch improves the error recovery paths for modern SCSI networks,
> the
> error recovery logic continues to fall through to host reset. It also continues
> to send bus and target resets in cases where they may affect working devices. I
> have a partial set of patches which attempt to make intelligent decisions in
> these cases, but they are far more intrusive and at this point not as clear cut.
> 
> 
> Just in case...
> Signed-off-by: Jeremy Linton <jlinton@tributary.com>
> ---
