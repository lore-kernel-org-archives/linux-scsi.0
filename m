From: Borislav Petkov <bp@amd64.org>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 17 Sep 2012 19:23:45 +0200
Message-ID: <20120917172345.GH13879@aftab.osrc.amd.com>
References: <87obojef7t.fsf@schwinge.name>
 <20120616181008.GB20623@liondog.tnic>
 <87ehpddw9k.fsf@schwinge.name>
 <20120618142900.GA9710@aftab.osrc.amd.com>
 <87sjdsd64r.fsf@schwinge.name>
 <20120618155141.GF8378@aftab.osrc.amd.com>
 <877gs69oue.fsf@schwinge.name>
 <20120913125825.GB19691@aftab.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.x86-64.org ([217.9.48.20]:54231 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab2IQRXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2012 13:23:49 -0400
Content-Disposition: inline
In-Reply-To: <20120913125825.GB19691@aftab.osrc.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Sep 13, 2012 at 02:58:25PM +0200, Borislav Petkov wrote:
> Here's the script, let me know how it goes:

Here's a more correct version. I'm not saying yours won't work based
on the rdmsr and setpci output on your box, but here's a version which
should pay attention to one other workaround and work on all K8s.

HTH.

--
#!/bin/bash
# assuming a single CPU system

nb_cfg=0xc001001f
ht_tr_ctl=0x68


val="0x"$(rdmsr $nb_cfg)

# revert E131 workaround
val=$(( $val & ~(1 << 20) ))

val=$(( $val | (1 << 32) ))
val=$(printf "0x%08x" $val)
wrmsr $nb_cfg $val


val="0x"$(setpci -s 18.0 $ht_tr_ctl.l)

# clear bits [22:21]
val=$(( $val & ~( 0x3 << 21) ))

val=$(( $val | (1 << 21) ))
val=$(printf "0x%08x" $val)
setpci -s 18.0 $ht_tr_ctl.l=$val

echo "Erratum 169 workaround applied."
--

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
