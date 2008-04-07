From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: Add more debug output to sas_scsi_recover_host or	sas_eh_handle_sas_errors
Date: Mon, 07 Apr 2008 17:16:10 +0200
Message-ID: <47FA3ABA.7080306@ipax.at>
References: <47FA2E1B.6020709@ipax.at> <1207578974.3838.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:40443 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYDGPQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 11:16:13 -0400
In-Reply-To: <1207578974.3838.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

hello james,

James Bottomley wrote:
> On Mon, 2008-04-07 at 16:22 +0200, Raoul Bhatia [IPAX] wrote:
>> is there any sens in adding more debug output to sas_scsi_recover_host
>> or sas_eh_handle_sas_errors?
>>
>> e.g. put out SAS_ADDR(task->dev->sas_addr) so that we know whether
>> the error is always occuring on one phy/port/etc. ?
>>
>> the reason for doing this is basically my problems with the aic94xx
>> driver, outlined in http://marc.info/?t=120603924200004.
> 
> Probably not really ... it looks like a standard protocol error thrown
> by a Seagate driver, as I said.

the only information from seagate was: you have the latest firmware,
please verify with a different controller.

unfortunatly, until now i haven't been able to test with another disk
and/or controller.

> Did reducing the queue depth and increasing the retries have any
> mitigating effect at all?

mhm, i cannot say for sure as i played a lot with different sequencer
version (which i directly got from adaptec). but as far as i can tell
it did not have a big impact and the errors usually start to appear
within 3-6 minutes.

during my last test (second test with kernel 2.6.20-rc8, default queue
depth) it took 22 minutes, but this happens very seldom.

> The correct fix, which is to handle the REQ_TASK_ABORT on the fly is
> still in the works.

ok, do you have any eta for this? what about luben's comment in the
previous thread?

someone from adaptec took a look into this issue. i am currently asking
whether i am allowed forward the conversation to you (or any other
kernel developer who is interested).

the discussion was basically about a pci-bus vs sas-bus (realtime-bus)
issue.

cheers,
raoul
- --
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH+jq6EaTXmVQ/cvsRAnKUAJ9ONuV1Lak/fERAUKhg5fthiAOZ3gCfWsnN
huvPOsvdov+zKVTyj5jj7pc=
=l6F2
-----END PGP SIGNATURE-----
