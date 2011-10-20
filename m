From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 22/37] tcm_fc: remove custom hex_to_bin in ft_parse_wwn
Date: Wed, 19 Oct 2011 21:52:52 -0700
Message-ID: <1319086372.22842.79.camel@haakon2.linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
	 <1318552929-13341-23-git-send-email-nab@linux-iscsi.org>
	 <CAHp75VdK3vugbcKi60fp0XqgPa5BwN=LRNVuUg=Vcn2aUqg3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdK3vugbcKi60fp0XqgPa5BwN=LRNVuUg=Vcn2aUqg3BQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-10-14 at 12:47 +0300, Andy Shevchenko wrote:
> On Fri, Oct 14, 2011 at 3:41 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch converts ft_parse_wwn() to use hex_to_bin() instead of custom
> > conversion code.
> 
> > @@ -94,13 +95,10 @@ static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
> >                        return cp - name;
> >                }
> >                err = 3;
> > -               if (isdigit(c))
> > -                       nibble = c - '0';
> > -               else if (isxdigit(c) && (islower(c) || !strict))
> > -                       nibble = tolower(c) - 'a' + 10;
> > -               else
> > +               val = hex_to_bin(c);
> > +               if (val < 0)
> Just realized the patch has removed a bit of original logic. Above
> line should be like
>   if (val < 0 || (strict && isupper(c)))
> 

Same here, fixed in lio-core-2.6.git and rebased into the original patch
in target-pending.git.

Thanks!

--nab
