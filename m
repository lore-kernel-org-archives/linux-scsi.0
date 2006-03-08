From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] aic79xx fixes
Date: Wed, 08 Mar 2006 12:55:13 +0100
Message-ID: <440EC621.4090207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:38812 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932499AbWCHLzO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 06:55:14 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 98B8EEF89
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:55:13 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

this is a next round of aic79xx fixes. It fixes some critical issues;
most importantly I've added a check for the BIOS settings and the error
recovery has been reworked.

Patches in detail:
01: Remove qfrozen
	Converting the qfrozen / semaphore logic to the much simpler
        complete()
02: Use tcq functions
	The midlayer provides generic tcq functions. Use them.
	Also sets the queuedepth to '1' if tcq is disabled; otherwise
	some devices are overrun.
03: Remove dead code
	Adrian Bunk memorial patch
04: Update error recovery
	Split codepaths for ABORT and BUS RESET
05: Handle Invalid sequencer interrupt
	Disable debugging output
06: Use BIOS settings
	Enable the handling of BIOS settings
07: Avoid renegotiation on inquiry
	We don't always have to smarter than the midlayer.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
