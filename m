From: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Subject: Re: Mid-Layer handling of NOT READY conditions...
Date: Mon, 31 Jan 2005 10:46:18 +0100
Message-ID: <D7C92AAF14D74B4B98C4B349D18FF660031FF509@S64P17BIBA4>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jasmin2.sncf.fr ([171.16.4.19]:10174 "EHLO jasmin2.sncf.fr")
	by vger.kernel.org with ESMTP id S261843AbVAaJq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 04:46:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hello,

a related discussion is ongoing in the multipath area.

Edward Goggin, EMC, noted a LU can be remapped anytime, by way of an HBA
recabling, or a LUN masking reconfiguration or a LU renaming. If IO are
queued to sda (LU id == 1234), sda goes unreachable (say because of a cable
unplug), when sda come back online it may not be 1234 anymore but 4321.
Requeuing the IO to sda will then silently corrupt 4321.

There needs to be a way to ask the HBA driver to error out immediatly IO
submitted to sda.
Can you confirm a "timeout" driver module parameter set to 0 can bring us
this behaviour ?

regards,
cvaroqui
