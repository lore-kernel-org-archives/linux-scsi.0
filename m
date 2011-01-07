From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [-next] ERROR: "strchr" [drivers/target/target_core_mod.ko]
 undefined!
Date: Fri, 07 Jan 2011 09:44:04 -0600
Message-ID: <1294415045.4895.16.camel@mulgrave.site>
References: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, scsi <linux-scsi@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-01-07 at 11:57 +0100, Geert Uytterhoeven wrote:
> Since a few days, linux-next shows:
> 
> | ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
> 
> in m68k allmodconfig builds
> (http://kisskb.ellerman.id.au/kisskb/buildresult/3754323/).
> 
> I guess this is caused by the following 3 calls to strstr():
> 
> drivers/target/target_core_configfs.c:
> +       ptr = strstr(page, "1");
> 
> +       str = strstr(buf, "_");
> 
> +       str2 = strstr(str+1, "_");
> 
> Some versions of gcc replace calls to strstr() with single-character
> "needle" string parameters by calls to strchr() behind our back.
> This causes linking errors if strchr() is defined as an inline function
> in <asm/string.h> (e.g. on m68k).
> 
> You can prevent this by explicitly calling strchr() instead.
> 
> Cfr. commit 59d309f9c8ef0bd01bf93cc0e758f1d810417bdb
> ("kgdb: Replace strstr() by strchr() for single-character needles).
> 
> Gr{oetje,eeting}s,

Surely the fix for this is not to inline it in m68k? If gcc is growing
the capability to make these types of transformations, it's not going to
stop at single entry string strstr().

If you want to keep the fast inline, there is a way (which I forget) to
drop an external reference as well, just in case.

James
