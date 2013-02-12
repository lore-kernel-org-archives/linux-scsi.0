From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Tue, 12 Feb 2013 16:00:15 -0600
Message-ID: <511ABB6F.1000700@tributary.com>
References: <511A87CA.5010901@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D4811C@G4W3304.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:49414 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3BLWAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 17:00:22 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D4811C@G4W3304.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2/12/2013 2:57 PM, Elliott, Robert (Server Storage) wrote:
> Ideally the device driver for the SCSI initiator port would report those
> attributes, and higher level code would combine them with support
> information from the device server (REPORT SUPPORTED TMF command, REPORT
> SUPPORTED OPCODES command, etc.) to decide what is supported.


Well, for the eh_xxx_handler functions, that is basically what happens now.

The host driver can fail to set a callback for the eh_xxx_handlers if it
doesn't support the operation. At that point, even if the target device
supports a function (say target reset) if the host driver doesn't, then the
target reset will be skipped.

Of course, a number of the drivers define functions their underlying
protocol's don't support. For example, bus reset on fibre channel. Which I
personally believe is an error.


