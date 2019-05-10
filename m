From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
Date: Fri, 10 May 2019 10:16:42 +1000
Message-ID: <80e51facb280e96018a4220adf8efa6fac823a94.camel@d-silva.org>
References: <20190508070148.23130-1-alastair@au1.ibm.com>
         <20190508070148.23130-4-alastair@au1.ibm.com>
         <dc093079-43a0-0a45-f5dd-88b20702fd93@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <dc093079-43a0-0a45-f5dd-88b20702fd93@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle Valo <kvalo@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-05-08 at 17:58 -0700, Randy Dunlap wrote:
> On 5/8/19 12:01 AM, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > Some buffers may only be partially filled with useful data, while
> > the rest
> > is padded (typically with 0x00 or 0xff).
> > 
> > This patch introduces a flag to allow the supression of lines of
> > repeated
> > bytes, which are replaced with '** Skipped %u bytes of value 0x%x
> > **'
> > 
> > An inline wrapper function is provided for backwards compatibility
> > with
> > existing code, which maintains the original behaviour.
> > 
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  include/linux/printk.h | 25 +++++++++---
> >  lib/hexdump.c          | 91 ++++++++++++++++++++++++++++++++++++
> > ------
> >  2 files changed, 99 insertions(+), 17 deletions(-)
> > 
> 
> Hi,
> Did you do "make htmldocs" or something similar on this?
> 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c
> > index 3943507bc0e9..d61a1e4f19fa 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > @@ -212,8 +212,44 @@ int hex_dump_to_buffer(const void *buf, size_t
> > len, int rowsize, int groupsize,
> >  EXPORT_SYMBOL(hex_dump_to_buffer);
> >  
> >  #ifdef CONFIG_PRINTK
> > +
> > +/**
> > + * Check if a buffer contains only a single byte value
> > + * @buf: pointer to the buffer
> > + * @len: the size of the buffer in bytes
> > + * @val: outputs the value if if the bytes are identical
> 
> Does this work without a function name?
> Documentation/doc-guide/kernel-doc.rst says the general format is:
> 
>   /**
>    * function_name() - Brief description of function.
>    * @arg1: Describe the first argument.
>    * @arg2: Describe the second argument.
>    *        One can provide multiple line descriptions
>    *        for arguments.
>    *
> 
> > + */
> >  /**
> > - * print_hex_dump - print a text hex dump to syslog for a binary
> > blob of data
> > + * print_hex_dump_ext: dump a binary blob of data to syslog in
> > hexadecimal
> 
> Also not in the general documented format.
> 

Thanks Randy, I'll address these.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
