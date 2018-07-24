From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 0/6] Symbol namespaces
Date: Tue, 24 Jul 2018 10:09:51 +0200
Message-ID: <CAB0TPYH2G_+faZDcvoEyUmZfwP0j83P0KeZXSJdN9rJ4M1ad3w@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <CAK8P3a1F2j3PL2ng7xw9TbCQqwn_U+1D5ChH+v8qWVrxOfW3xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1F2j3PL2ng7xw9TbCQqwn_U+1D5ChH+v8qWVrxOfW3xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, USB
List-Id: linux-scsi@vger.kernel.org

Hi Arnd,

On Mon, Jul 23, 2018 at 4:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This looks nice. I don't want to overload you with additional
> requests, but it might be good to think about how this can
> be taken further, if we want to actually convert large
> parts of the kernel to it.

No worries about overloading, I'm happy with all feedback to make this better.

> I have two ideas:
>
> - It would be nice to have a simple mechanism in Kconfig
>   to put all symbols in a module into a namespace that is
>   derived from KBUILD_MODNAME, to avoid having to
>   annotate every symbol separately. This could be similar
>   to how we ended up dealing with EXPORT_NO_SYMBOLS
>   in the linux-2.4 days, with the goal of eventually having
>   a namespace for each symbol. Similarly, we could pass
>   a number of default namespaces through the Makefile,
>   e.g. if we have a directory that has lots of drivers that all
>   import the symbols from a common subsystem module.

I'm hinging on two thoughts here; I really like it because it
obviously reduces work and makes this easier to use. On the other
hand, you now have to look in multiple places to see if a symbol is
exported to a namespace/imported from a module. Perhaps it depends on
how coarse-grained the namespaces end up being. Either way, I think it
would be pretty easy to cook up patches for this.

>
> - If this is possible to implement, it would be great to have
>   a way to limit the globally visible symbols in a module
>   to the ones that are explicitly exported  even when a that
>   module is built-in rather than loadable. Not sure how this
>   is best done though. A couple of things can be done with
>   objcopy, or possibly by reintroducing partial linking (which
>   was removed not too long ago).

If I understand you correctly, this is orthogonal to symbol
namespaces, right? Though I think there is value in doing the same
thing for symbol namespaces: right now, the only way to find out if
all modules correctly import a symbol exported to a namespace is to
run an 'allmodconfig'; not having to do that would be a win. Being
able to do the same thing for the exported symbols in the global
namespace is very similar. So yeah, I think this is a good idea and
will look into this more.

Do you think these things should be a part of these series, or can it
be a follow-up?

Thanks,
Martijn

>
>         Arnd
