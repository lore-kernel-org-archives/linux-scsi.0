From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 1/4] Encapsulate scsi_do_report_luns
Date: Thu, 07 Mar 2013 17:30:38 +0000
Message-ID: <1362677438.9043.6.camel@dabdike.int.hansenpartnership.com>
References: <1362663515-3476-1-git-send-email-revers@redhat.com>
	 <1362663515-3476-2-git-send-email-revers@redhat.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA726C@G9W0745.americas.hpqcorp.net>
	 <5138BB1F.9080904@tributary.com>
	 <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35002 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab3CGRam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 12:30:42 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DA733C@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

On Thu, 2013-03-07 at 17:01 +0000, Elliott, Robert (Server Storage)
wrote:
> Good point; INQUIRY, REPORT LUNS, REQUEST SENSE, and NOTIFY DATA
> TRANSFER DEVICE do not report unit attention conditions.

Well, yes they do, at least on several devices I have here.

Can I point out again that we can't code to SAM ... we have to code to
what already exists. SAM is useful as a guideline, but it isn't gospel.
In particular where the real world does something SAM says it shouldn't
(like sending UA to INQUIRY), we have to go with the real world.

This also means we can't go through the linux SCSI subsystem changing
behaviour based on what SAM says the behaviour should be.  Most of what
the SCSI subsystem does is an accumulation based on years of trying to
fix it for annoying and out of spec devices.

James


