From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Sun, 30 Dec 2018 10:06:43 -0800
Message-ID: <1546193203.2844.9.camel@linux.vnet.ibm.com>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
         <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
         <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>
         <alpine.LNX.2.21.1812291050330.152@nippy.intranet>
         <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
         <alpine.LNX.2.21.1812291327380.152@nippy.intranet>
         <5e901432-65e2-c87b-31e3-36a394687a9a@gmail.com>
         <CAK8P3a1J3sy55nd5QbxR5AjxkLyE-RE=bDNKB9sG27xx=mZ60A@mail.gmail.com>
         <20181230185002.Horde.AdSknvcs4hP1Kh_T_Cos6w8@messagerie.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181230185002.Horde.AdSknvcs4hP1Kh_T_Cos6w8@messagerie.si.c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: LEROY Christophe <christophe.leroy@c-s.fr>, Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Finn Thain <fthain@telegraphics.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2018-12-30 at 18:50 +0100, LEROY Christophe wrote:
> Arnd Bergmann <arnd@arndb.de> a écrit :
> > On Sat, Dec 29, 2018 at 3:51 AM Michael Schmitz
> > <schmitzmic@gmail.com> wrote:
[...]
> > > (On second thought - I don't want to speculate whether there's
> > > weird compiler options that could result in the
> > > nvram_check_checksum and nvram_read_bytes symbols to still be
> > > referenced in the final link, even though
> > > IS_BUILTIN(CONFIG_NVRAM) always evaluates to false. Best
> > > leave this as-is.)
> > 
> > As far as I know, it's totally reliable with the supported
> > compilers  (gcc-4.6+). In the older compilers (e.g. 4.1), there was
> > a corner case, where it could have failed to eliminate a function
> > that was only referenced through a pointer from a discarded
> > variable, but a plain IS_ENABLED() check like the one here
> > was still ok, and lots of code relies on that.
> > 
> > Other than that, I agree either way is totally fine here, so no
> > objections to using the #ifdef.
> 
> As far as I know, kernel codying style promotes the use of  
> IS_ENABLED() etc. instead of #ifdefs when possible.

It's a preference, as with a lot of coding style stuff, which we leave
up to the maintainer.

That said, as has been pointed out, the current #ifdef has a failing
corner case when both are modular (because the code should then be
included).  The runtime macro that correctly expresses this is
IS_REACHABLE(CONFIG_NVRAM).

James
