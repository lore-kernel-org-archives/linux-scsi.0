From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: 19 May 2003 17:47:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
	<1328050000.1053359007@aslan.btc.adaptec.com>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:6411 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S262525AbTESPmB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 11:42:01 -0400
In-Reply-To: <1328050000.1053359007@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin T Gibbs <gibbs@scsiguy.com> writes:

Justin> I will perform a more careful review later today, but my main
Justin> concern about this change is that it looks like it will
Justin> prevent the probing of VLB cards in non-EISA systems.

No, VLB cards are treated as EISA cards in the core EISA code. You
have to enable CONFIG_EISA_VLB_PRIMING though :

config EISA_VLB_PRIMING
        bool "Vesa Local Bus priming"
        depends on X86_PC && EISA
        default n
        ---help---
          Activate this option if your system contains a Vesa Local
          Bus (VLB) card that identify itself as an EISA card (such as
          the Adaptec AHA-284x).

          When in doubt, say N.

With this option, the magic sequence to wake up VLB cards is run while
enumerating the bus. Does it address your concerns ?

Thanks,

        M.
-- 
Places change, faces change. Life is so very strange.
