From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v4 5/7] lib/hexdump.c: Allow multiple groups to be
 separated by lines '|'
Date: Wed, 26 Jun 2019 11:28:01 +1000
Message-ID: <ef3aac0cb37fd7bb421db313e839809fd7649d05.camel@d-silva.org>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-6-alastair@au1.ibm.com>
         <c364c36338d385eba60c523828ad8995c792ae4d.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c364c36338d385eba60c523828ad8995c792ae4d.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-06-24 at 22:37 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> > 
> > With the wider display format, it can become hard to identify how
> > many
> > bytes into the line you are looking at.
> > 
> > The patch adds new flags to hex_dump_to_buffer() and
> > print_hex_dump() to
> > print vertical lines to separate every N groups of bytes.
> > 
> > eg.
> > buf:00000000: 454d414e 43415053|4e495f45
> > 00584544  NAMESPAC|E_INDEX.
> > buf:00000010: 00000000 00000002|00000000
> > 00000000  ........|........
> > 
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  include/linux/printk.h |  3 +++
> >  lib/hexdump.c          | 59 ++++++++++++++++++++++++++++++++++++
> > ------
> >  2 files changed, 54 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> []
> > @@ -485,6 +485,9 @@ enum {
> >  
> >  #define HEXDUMP_ASCII			BIT(0)
> >  #define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
> > +#define HEXDUMP_2_GRP_LINES		BIT(2)
> > +#define HEXDUMP_4_GRP_LINES		BIT(3)
> > +#define HEXDUMP_8_GRP_LINES		BIT(4)
> 
> These aren't really bits as only one value should be set
> as 8 overrides 4 and 4 overrides 2.

This should be the other way around, as we should be emitting alternate
seperators based on the smallest grouping (2 implies 4 and 8, and 4
implies 8). I'll fix the logic.

I can't come up with a better way to represent these without making the
API more complex, if you have a suggestion, I'm happy to hear it.

> 
> I would also expect this to be a value of 2 in your above
> example, rather than 8.  It's described as groups not bytes.
> 
> The example is showing a what would normally be a space ' '
> separator as a vertical bar '|' every 2nd grouping.
> 

The above example shows a group size of 4 bytes, and
HEXDUMP_2_GRP_LINES set, with 2 groups being 8 bytes.

I'll make that clearer in the commit message.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
