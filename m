From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Tue, 02 Nov 2010 14:50:24 -0400
Message-ID: <4CD05D70.2070703@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box> <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box> <4CCF0DFE.4050106@garzik.org> <20101102092111.GK25817@basil.fritz.box> <4CD03578.3050801@garzik.org>  <20101102175336.GA2167@basil.fritz.box> <1288723085.27411.8.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59379 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0KBSu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 14:50:28 -0400
In-Reply-To: <1288723085.27411.8.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Linux IDE mailing list <linux-ide@vger.kernel.org>


A proper host-lock pushdown should be two one-line changes to each driver:


1) call

	DEF_SCSI_QUEUECMD_NOLCK(function name of existing queuecommand);

2) in each driver's Scsi_Host_Template, rename .queuecommand hook from

	XXX

to

	XXX_unlocked

Then define DEF_SCSI_QUEUECMD_NOLCK() macro in some common scsi header.

Simple.  Easy to review.  Obviously correct.  Fewest LOC changed.

	Jeff




