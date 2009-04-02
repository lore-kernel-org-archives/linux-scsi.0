From: Matthew Wilcox <matthew@wil.cx>
Subject: crash unrelated to sym53c8xx
Date: Thu, 2 Apr 2009 06:49:24 -0600
Message-ID: <20090402124924.GP8014@parisc-linux.org>
References: <20090402075404.GA9784@develbox.linuxbox.cz> <20090402112338.GO8014@parisc-linux.org> <20090402122610.GB9784@develbox.linuxbox.cz> <20090402122808.GC9784@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49658 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZDBMtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 08:49:42 -0400
Content-Disposition: inline
In-Reply-To: <20090402122808.GC9784@develbox.linuxbox.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, nikola.ciprich@linuxbox.cz

On Thu, Apr 02, 2009 at 02:28:08PM +0200, Nikola Ciprich wrote:
> Hmm,
> maybe a bit usefull can be begin of crash message, he got on console:
> 
> databox [488754.946366] BUG: spinlock recursion on CPU#1, swapper/0
> databox [488754.950343]  lock: f70ddbe0, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 1

Yes, that's somewhat more useful ... the tail of the stack trace in the
photo indicates this isn't (at least directly) a bug in the sym53c8xx
driver.  Can you get the rest of the crash message?  netconsole might
help here if you don't have a serial console.

> 
> On Thu, Apr 02, 2009 at 02:26:10PM +0200, Nikola Ciprich wrote:
> > Hi Matthew,
> > well, I've got VERY crappy screen photo, my collegue made using his cellphone, You can check
> > it on http://nik.lbox.cz/downloads/sym53c8xx-crash.jpg
> > But we can quite easily reproduce the problem, I'll try to do it today evening and make a
> > better screenshot...
> > I'll report further then.
> > Regarding warning, couldn't it then be surpressed, if it's harmless? Kernel then gets tainted,
> > which makes me a bit nervous :-)

There's a few reasons this warning hasn't been fixed yet:

 - It only appears on module unload.  Most people don't unload sym53c8xx.
 - The problem that it's warning about is only a problem on ARM.
   There's not a huge userbase of ARM users with sym53c8xx cards.
 - Fixing it requires a fairly large rewrite of how sym2 manages its
   memory.  I've done about half the work required, but I've basically
   run out of interest.

> > regards
> > nik
> > 
> > On Thu, Apr 02, 2009 at 05:23:38AM -0600, Matthew Wilcox wrote:
> > > On Thu, Apr 02, 2009 at 09:54:04AM +0200, Nikola Ciprich wrote:
> > > > Hi,
> > > > we're experiencing problems using changer connected on LSI Logic / Symbios Logic 53c875 adaptor (using sym53c8xx module).
> > > > Sometimes changer gets stuck, and reloading sym53c8xx module is the only way to help. But it alwas issues following warning,
> > > > and on subsequent mtx usage, the whole machine usually crashes...
> > > 
> > > The warning is actually harmless.  What error messages do you get when
> > > the machine crashes?
> > > 
> > > -- 
> > > Matthew Wilcox				Intel Open Source Technology Centre
> > > "Bill, look, we understand that you're interested in selling us this
> > > operating system, but compare it to ours.  We can't possibly take such
> > > a retrograde step."
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > -- 
> > -------------------------------------
> > Nikola CIPRICH
> > LinuxBox.cz, s.r.o.
> > 28. rijna 168, 709 01 Ostrava
> > 
> > tel.:   +420 596 603 142
> > fax:    +420 596 621 273
> > mobil:  +420 777 093 799
> > www.linuxbox.cz
> > 
> > mobil servis: +420 737 238 656
> > email servis: servis@linuxbox.cz
> > -------------------------------------
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> -------------------------------------
> Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28. rijna 168, 709 01 Ostrava
> 
> tel.:   +420 596 603 142
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
> www.linuxbox.cz
> 
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
