From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 2/6] module: add support for symbol namespaces.
Date: Fri, 20 Jul 2018 09:54:16 +0200
Message-ID: <CAB0TPYFVSWtJ6RPRUZ1bpS-rBaV7YyPR-4B2Ogxs+FNAbiScNw@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <20180716122125.175792-3-maco@android.com>
 <20180719163208.5xvrafugpcbhh7kj@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719163208.5xvrafugpcbhh7kj@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>, USB list <linux-usb@vger.kernel.org>USB
List-Id: linux-scsi@vger.kernel.org

Hi Jessica,

On Thu, Jul 19, 2018 at 6:32 PM, Jessica Yu <jeyu@kernel.org> wrote:
> First, thanks a lot for the patchset. This is definitely something that
> will help distros as well to declutter the exported symbol space and
> provide a more cleanly defined kernel interface.

Thanks, that's good to hear!


> Hm, I'm wondering if we could avoid all this extra module-ns-dependency
> checking work if we just put the import stuff as a modinfo tag, like
> have MODULE_IMPORT_NS() insert an "import:" tag like we already do for
> module parameters, author, license, aliases, etc. Then we'd have that
> information pretty much from the start of load_module() and we don't
> need to wait for relocations to be applied to __knsimport. Then you
> could do the namespace checking right at resolve_symbol() instead of
> going through the extra step of building a dependency list to be
> verified later.

I believe I did consider modinfo when I started with this a while
back, but don't recall right now why I didn't decide to use it;
perhaps it was the lack of support for multiple identical tags. Since
both modpost and the module loader have access to them, I don't see
why it wouldn't work, and indeed I suspect it would make the module
loader a bit simpler. I'll rework this and see what it looks like.

Thanks,
Martijn

>
> Also, this would get rid of the extra __knsimport section, the extra
> ns_dependencies field in struct module, and all those helper functions that
> manage it. In addition, having the modinfo tag may potentially help with
> debugging as we have the namespace imports clearly listed if we don't have
> the source code for a module. We'd probably need to modify get_modinfo() to
> handle multiple import: tags though. Luis [1] had written some code a while
> ago to handle multiple (of the same) modinfo tags.
>
> Thoughts on this?
>
> Thanks,
>
> Jessica
>
> [1] https://lkml.kernel.org/r/20171130023605.29568-3-mcgrof@kernel.org
>
>
>> getname:
>>         /* We must make copy under the lock if we failed to get ref. */
>>         strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
>> @@ -3061,6 +3118,11 @@ static int find_module_sections(struct module *mod,
>> struct load_info *info)
>>                                      sizeof(*mod->gpl_syms),
>>                                      &mod->num_gpl_syms);
>>         mod->gpl_crcs = section_addr(info, "__kcrctab_gpl");
>> +
>> +       mod->ns_imports = section_objs(info, "__knsimport",
>> +                                      sizeof(*mod->ns_imports),
>> +                                      &mod->num_ns_imports);
>> +
>>         mod->gpl_future_syms = section_objs(info,
>>                                             "__ksymtab_gpl_future",
>>                                             sizeof(*mod->gpl_future_syms),
>> @@ -3381,6 +3443,19 @@ static int post_relocation(struct module *mod,
>> const struct load_info *info)
>>         return module_finalize(info->hdr, info->sechdrs, mod);
>> }
>>
>> +static void verify_namespace_dependencies(struct module *mod)
>> +{
>> +       struct module_ns_dep *ns_dep;
>> +
>> +       list_for_each_entry(ns_dep, &mod->ns_dependencies, ns_dep) {
>> +               if (!module_imports_ns(mod, ns_dep->namespace)) {
>> +                       pr_warn("%s: module uses symbols from namespace
>> %s,"
>> +                               " but does not import it.\n",
>> +                               mod->name, ns_dep->namespace);
>> +               }
>> +       }
>> +}
>> +
>> /* Is this module of this name done loading?  No locks held. */
>> static bool finished_loading(const char *name)
>> {
>> @@ -3682,6 +3757,8 @@ static int load_module(struct load_info *info, const
>> char __user *uargs,
>>         if (err)
>>                 goto free_module;
>>
>> +       INIT_LIST_HEAD(&mod->ns_dependencies);
>> +
>> #ifdef CONFIG_MODULE_SIG
>>         mod->sig_ok = info->sig_ok;
>>         if (!mod->sig_ok) {
>> @@ -3730,6 +3807,8 @@ static int load_module(struct load_info *info, const
>> char __user *uargs,
>>         if (err < 0)
>>                 goto free_modinfo;
>>
>> +       verify_namespace_dependencies(mod);
>> +
>>         flush_module_icache(mod);
>>
>>         /* Now copy in args */
>> --
>> 2.18.0.203.gfac676dfb9-goog
>>
>
