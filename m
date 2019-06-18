From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v3 2/7] lib/hexdump.c: Relax rowsize checks in
 hex_dump_to_buffer
Date: Tue, 18 Jun 2019 10:57:00 +1000
Message-ID: <b2651117ca8a55d94b7e14e273d25199515039c3.camel@d-silva.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <20190617020430.8708-3-alastair@au1.ibm.com>
         <94413756-c927-a4ca-dd59-47e3cc87d58d@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <94413756-c927-a4ca-dd59-47e3cc87d58d@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-06-17 at 15:47 -0700, Randy Dunlap wrote:
> Hi,
> Just a comment style nit below...
> 
> On 6/16/19 7:04 PM, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > This patch removes the hardcoded row limits and allows for
> > other lengths. These lengths must still be a multiple of
> > groupsize.
> > 
> > This allows structs that are not 16/32 bytes to display on
> > a single line.
> > 
> > This patch also expands the self-tests to test row sizes
> > up to 64 bytes (though they can now be arbitrarily long).
> > 
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  lib/hexdump.c      | 48 ++++++++++++++++++++++++++++--------------
> >  lib/test_hexdump.c | 52 ++++++++++++++++++++++++++++++++++++++--
> > ------
> >  2 files changed, 75 insertions(+), 25 deletions(-)
> > 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c
> > index 81b70ed37209..3943507bc0e9 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > @@ -246,17 +248,29 @@ void print_hex_dump(const char *level, const
> > char *prefix_str, int prefix_type,
> >  {
> >  	const u8 *ptr = buf;
> >  	int i, linelen, remaining = len;
> > -	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
> > +	unsigned char *linebuf;
> > +	unsigned int linebuf_len;
> >  
> > -	if (rowsize != 16 && rowsize != 32)
> > -		rowsize = 16;
> > +	if (rowsize % groupsize)
> > +		rowsize -= rowsize % groupsize;
> > +
> > +	/* Worst case line length:
> > +	 * 2 hex chars + space per byte in, 2 spaces, 1 char per byte
> > in, NULL
> > +	 */
> 
> According to Documentation/process/coding-style.rst:
> 
> The preferred style for long (multi-line) comments is:
> 
> .. code-block:: c
> 
> 	/*
> 	 * This is the preferred style for multi-line
> 	 * comments in the Linux kernel source code.
> 	 * Please use it consistently.
> 	 *
> 	 * Description:  A column of asterisks on the left side,
> 	 * with beginning and ending almost-blank lines.
> 	 */
> 

Thanks Randy, I'll address this.


-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
