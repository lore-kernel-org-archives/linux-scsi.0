From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/6] Symbol namespaces
Date: Mon, 23 Jul 2018 16:28:41 +0200
Message-ID: <CAK8P3a1F2j3PL2ng7xw9TbCQqwn_U+1D5ChH+v8qWVrxOfW3xw@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716122125.175792-1-maco@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martijn Coenen <maco@android.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>linux
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2018 at 2:21 PM, Martijn Coenen <maco@android.com> wrote:
> As of Linux 4.17, there are more than 30000 exported symbols
> in the kernel. There seems to be some consensus amongst
> kernel devs that the export surface is too large, and hard
> to reason about.
>
> Generally, these symbols fall in one of these categories:
> 1) Symbols actually meant for drivers
> 2) Symbols that are only exported because functionality is
>    split over multiple modules, yet they really shouldn't
>    be used by modules outside of their own subsystem
> 3) Symbols really only meant for in-tree use
>
> When module developers try to upstream their code, it
> regularly turns out that they are using exported symbols
> that they really shouldn't be using. This problem is even
> bigger for drivers that are currently out-of-tree, which
> may be using many symbols that they shouldn't be using,
> and that break when those symbols are removed or modified.
>
> This patch allows subsystem maintainers to partition their
> exported symbols into separate namespaces, and module
> authors to import such namespaces only when needed.
>
> This allows subsystem maintainers to more easily limit
> availability of these namespaced symbols to other parts of
> the kernel. It can also be used to partition the set of
> exported symbols for documentation purposes; for example,
> a set of symbols that is really only used for debugging
> could be in a "SUBSYSTEM_DEBUG" namespace.

This looks nice. I don't want to overload you with additional
requests, but it might be good to think about how this can
be taken further, if we want to actually convert large
parts of the kernel to it. I have two ideas:

- It would be nice to have a simple mechanism in Kconfig
  to put all symbols in a module into a namespace that is
  derived from KBUILD_MODNAME, to avoid having to
  annotate every symbol separately. This could be similar
  to how we ended up dealing with EXPORT_NO_SYMBOLS
  in the linux-2.4 days, with the goal of eventually having
  a namespace for each symbol. Similarly, we could pass
  a number of default namespaces through the Makefile,
  e.g. if we have a directory that has lots of drivers that all
  import the symbols from a common subsystem module.

- If this is possible to implement, it would be great to have
  a way to limit the globally visible symbols in a module
  to the ones that are explicitly exported  even when a that
  module is built-in rather than loadable. Not sure how this
  is best done though. A couple of things can be done with
  objcopy, or possibly by reintroducing partial linking (which
  was removed not too long ago).

        Arnd
