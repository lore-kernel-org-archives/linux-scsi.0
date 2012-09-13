From: Borislav Petkov <bp@amd64.org>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Thu, 13 Sep 2012 14:58:25 +0200
Message-ID: <20120913125825.GB19691@aftab.osrc.amd.com>
References: <87obojef7t.fsf@schwinge.name>
 <20120616181008.GB20623@liondog.tnic>
 <87ehpddw9k.fsf@schwinge.name>
 <20120618142900.GA9710@aftab.osrc.amd.com>
 <87sjdsd64r.fsf@schwinge.name>
 <20120618155141.GF8378@aftab.osrc.amd.com>
 <877gs69oue.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877gs69oue.fsf@schwinge.name>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 07, 2012 at 11:14:33AM +0200, Thomas Schwinge wrote:
> I have now finally been able to check this, and yes, I'm already using
> the latest version of the BIOS, which is Phoenix cME FirstBIOS Desktop
> Pro version 5.00 R1.07.2264.A1 (a.k.a.  5.00.1.07, 25.04.2006) for
> Fujitsu Siemens Esprimo E5600, mainboard D2264-A1, CPU AMD Sempron 3000+.

Ok.

> > If there's no newer BIOS, we can try applying the workaround at boot in
> > an init script to fix your issue.
> 
> How'd that be done?

Well, you need to run the following script when the machine boots. I.e.,
you'd probably have to add it to /etc/init.d/ and make it run at some
runlevel, sometime early-ish, before a user can login.

Here's the script, let me know how it goes:

--
#!/bin/bash
# assuming a single CPU system

nb_cfg=0xc001001f
ht_tr_ctl=0x68


val="0x"$(rdmsr $nb_cfg)
val=$(( $val | (1 << 32) ))
val=$(printf "0x%08x" $val)
wrmsr $nb_cfg $val


val="0x"$(setpci -s 18.0 $ht_tr_ctl.l)
val=$(( $val | (1 << 21) ))
val=$(printf "0x%08x" $val)
setpci -s 18.0 $ht_tr_ctl.l=$val

echo "Erratum 169 workaround applied."
---

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
