From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Mon, 31 Dec 2018 09:45:16 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1812310933450.444@nippy.intranet>
References: <cover.1545784679.git.fthain@telegraphics.com.au>         <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>         <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>        
 <alpine.LNX.2.21.1812291050330.152@nippy.intranet>         <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>         <alpine.LNX.2.21.1812291327380.152@nippy.intranet>         <5e901432-65e2-c87b-31e3-36a394687a9a@gmail.com>        
 <CAK8P3a1J3sy55nd5QbxR5AjxkLyE-RE=bDNKB9sG27xx=mZ60A@mail.gmail.com>         <20181230185002.Horde.AdSknvcs4hP1Kh_T_Cos6w8@messagerie.si.c-s.fr> <1546193203.2844.9.camel@linux.vnet.ibm.com> <alpine.LNX.2.21.1812310839050.444@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1812310839050.444@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: LEROY Christophe <christophe.leroy@c-s.fr>, Arnd Bergmann <arnd@arndb.de>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 31 Dec 2018, Finn Thain wrote:

> On Sun, 30 Dec 2018, James Bottomley wrote:
> 
> > 
> > That said, as has been pointed out, the current #ifdef has a failing 
> > corner case when both are modular (because the code should then be 
> > included).  The runtime macro that correctly expresses this is 
> > IS_REACHABLE(CONFIG_NVRAM).
> > 
> 
> No, in the case of CONFIG_NVRAM=m, the conditional code is deliberately 
> excluded. This is discussed in the patch description. The convention on 
> PPC32 is that device drivers drop support for NVRAM in this situation. 
> 
> I've adopted the PPC32 convention here because M68K drivers and PPC32 
> drivers have to co-exist (I'm thinking of valkyriefb, but there are other 
> examples).
> 

I agree with your comment in principle, that these drivers should be using 
IS_REACHABLE(CONFIG_NVRAM), not defined(CONFIG_NVRAM).

$ grep -lrw CONFIG_NVRAM drivers/
drivers/video/fbdev/matrox/matroxfb_base.c
drivers/video/fbdev/platinumfb.c
drivers/video/fbdev/controlfb.c
drivers/video/fbdev/valkyriefb.c
drivers/video/fbdev/imsttfb.c
drivers/scsi/atari_scsi.c
$ 

But I think this is not the fault of this patch; it's just a historical 
accident.

Having said that, I will rework this series to convert all of the above 
drivers to IS_REACHABLE(CONFIG_NVRAM). I think it would be an improvement.

Besides, it seems likely that some rework involving ppc_md will be needed 
too because as Arnd pointed out, it would be good to avoid two sets of 
nvram accessor methods.

-- 
