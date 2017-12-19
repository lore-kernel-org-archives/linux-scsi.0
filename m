From: Joe Perches <joe@perches.com>
Subject: Re: [-next PATCH 4/4] treewide: Use DEVICE_ATTR_WO
Date: Tue, 19 Dec 2017 10:51:14 -0800
Message-ID: <1513709474.1234.66.camel@perches.com>
References: <cover.1513706701.git.joe@perches.com>
         <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
         <20171219184441.ixxh757tl44qvk5l@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20171219184441.ixxh757tl44qvk5l@pd.tnic>
Sender: linux-input-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Falcon <tlfalcon@linux.vnet.ibm.com>, John Allen <jallen@linux.vnet.ibm.com>, Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>, linux-wimax@intel.com, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-12-19 at 19:44 +0100, Borislav Petkov wrote:
> On Tue, Dec 19, 2017 at 10:15:09AM -0800, Joe Perches wrote:
> > Convert DEVICE_ATTR uses to DEVICE_ATTR_WO where possible.
> > 
> > Done with perl script:
> > 
> > $ git grep -w --name-only DEVICE_ATTR | \
> >   xargs perl -i -e 'local $/; while (<>) { s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IWUSR\s*|\s*0200\s*)\)?\s*,\s*NULL\s*,\s*\s_store\s*\)/DEVICE_ATTR_WO(\1)/g; print;}'
[]
> > diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
[]
> > @@ -560,7 +560,7 @@ static ssize_t pf_show(struct device *dev,
> >  	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
> >  }
> >  
> > -static DEVICE_ATTR(reload, 0200, NULL, reload_store);
> > +static DEVICE_ATTR_WO(reload);
> >  static DEVICE_ATTR(version, 0400, version_show, NULL);
> >  static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
> >  
> 
> # cat /sys/devices/system/cpu/microcode/reload
> cat: /sys/devices/system/cpu/microcode/reload: Permission denied

Not different behavior.  It was and remains write only.

> The reason for the code churn being?

Consistency for easier grep by use-type.


