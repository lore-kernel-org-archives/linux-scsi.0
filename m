From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 21/37] iscsi-target: use native hex2bin for
 chap_string_to_hex
Date: Wed, 19 Oct 2011 21:52:22 -0700
Message-ID: <1319086342.22842.78.camel@haakon2.linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
	 <1318552929-13341-22-git-send-email-nab@linux-iscsi.org>
	 <CAHp75VcEo_TnAZXFYhmtD7n9HajV_GtShcyBGHiq8O76udwnqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcEo_TnAZXFYhmtD7n9HajV_GtShcyBGHiq8O76udwnqA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-10-14 at 11:46 +0300, Andy Shevchenko wrote:
> On Fri, Oct 14, 2011 at 3:41 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> 
> > (nab: Fix up minor compile breakage)
> Am I late for comment?
> 
> > --- a/drivers/target/iscsi/iscsi_target_auth.c
> > +++ b/drivers/target/iscsi/iscsi_target_auth.c
> 
> >  static int chap_string_to_hex(unsigned char *dst, unsigned char *src, int len)
> >  {
> > -       int i, j = 0;
> > +       int j = DIV_ROUND_UP(len, 2);
> >
> > -       for (i = 0; i < len; i += 2) {
> > -               dst[j++] = (unsigned char) chap_asciihex_to_binaryhex(&src[i]);
> > -       }
> > +       hex2bin(dst, src, len);
> len in this case should be j. That's why in broken version it called
> length. hex2bin accepts length in bytes to convert.
> 

Thanks Andy.

Fixed this up in lio-core-2.6.git and rebased the original patch into
target-pending.git.

--nab
