From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/6] Symbol namespaces
Date: Tue, 24 Jul 2018 11:08:21 +0200
Message-ID: <CAK8P3a0SFua3OVzyoWxL+xtozyra5Q5D=GypkOt4hdJ0L3L5Aw@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <CAK8P3a1F2j3PL2ng7xw9TbCQqwn_U+1D5ChH+v8qWVrxOfW3xw@mail.gmail.com>
 <CAB0TPYH2G_+faZDcvoEyUmZfwP0j83P0KeZXSJdN9rJ4M1ad3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAB0TPYH2G_+faZDcvoEyUmZfwP0j83P0KeZXSJdN9rJ4M1ad3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martijn Coenen <maco@android.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, USB
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 24, 2018 at 10:09 AM, Martijn Coenen <maco@android.com> wrote:
> Hi Arnd,
>
> On Mon, Jul 23, 2018 at 4:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> This looks nice. I don't want to overload you with additional
>> requests, but it might be good to think about how this can
>> be taken further, if we want to actually convert large
>> parts of the kernel to it.
>
> No worries about overloading, I'm happy with all feedback to make this better.
>
>> I have two ideas:
>>
>> - It would be nice to have a simple mechanism in Kconfig
>>   to put all symbols in a module into a namespace that is
>>   derived from KBUILD_MODNAME, to avoid having to
>>   annotate every symbol separately. This could be similar
>>   to how we ended up dealing with EXPORT_NO_SYMBOLS
>>   in the linux-2.4 days, with the goal of eventually having
>>   a namespace for each symbol. Similarly, we could pass
>>   a number of default namespaces through the Makefile,
>>   e.g. if we have a directory that has lots of drivers that all
>>   import the symbols from a common subsystem module.
>
> I'm hinging on two thoughts here; I really like it because it
> obviously reduces work and makes this easier to use. On the other
> hand, you now have to look in multiple places to see if a symbol is
> exported to a namespace/imported from a module. Perhaps it depends on
> how coarse-grained the namespaces end up being. Either way, I think it
> would be pretty easy to cook up patches for this.

Ok, maybe try it and see where we get with it?

>> - If this is possible to implement, it would be great to have
>>   a way to limit the globally visible symbols in a module
>>   to the ones that are explicitly exported  even when a that
>>   module is built-in rather than loadable. Not sure how this
>>   is best done though. A couple of things can be done with
>>   objcopy, or possibly by reintroducing partial linking (which
>>   was removed not too long ago).
>
> If I understand you correctly, this is orthogonal to symbol
> namespaces, right?

Right, the only connection here is that both try to limit the
scope of which symbols are available where. This can definitely
be done without symbol namespaces. The implementation I
had in mind with objcopy might end up using the same
KBUILD_MODNAME as a prefix for internal symbols (which
are not exported to modules), but that is a different problem.

Another related area is the question what happens to symbols
that we want to share between two built-in parts of the kernel
without exporting them to modules. E.g. if we might want to
put all of vfs into one built-in module and make its symbols
private to that module, while all of the mm subsystem is in a
separate built-in module. The symbols that are needed for
communicating between the two could simply be exported
with EXPORT_SYMBOL_GPL(), but we that would open the
surface to loadable modules that can't access them today.
Using namespaces could solve that problem by limiting the
scope in another way, or we could come up with a different
method to annotate them, such as using the gcc visibility
 attributes.

> Do you think these things should be a part of these series, or can it
> be a follow-up?

If you think you can do the first thing easily, I'd say we should
try to come up with an idea of where we want to take this in
the long run. For limiting the scope of global symbols, that may
well be a much bigger task to do upfront, so unless you have an
idea for how to do that, maybe keep it in mind but let's not make
it a dependency.

      Arnd
