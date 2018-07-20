From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 2/6] module: add support for symbol namespaces.
Date: Fri, 20 Jul 2018 17:42:07 +0200
Message-ID: <CAB0TPYFQvkTsMvfJCTSFSJAoCbmOUJz7mCQGoORs6nRcC3Fhdg@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <20180716122125.175792-3-maco@android.com>
 <20180719163208.5xvrafugpcbhh7kj@linux-8ccs> <CAB0TPYFVSWtJ6RPRUZ1bpS-rBaV7YyPR-4B2Ogxs+FNAbiScNw@mail.gmail.com>
 <20180720144916.fyqpmrtgt23sax6n@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720144916.fyqpmrtgt23sax6n@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>, USB list <linux-usb@vger.kernel.org>USB
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 20, 2018 at 4:49 PM, Jessica Yu <jeyu@kernel.org> wrote:
> Thanks. Also, it looks like we're currently just warning (in both
> modpost and on module load) if a module uses symbols from a namespace
> it doesn't import. Are you also planning to eventually introduce
> namespace enforcement?

This is something I've definitely been thinking about, and was curious
what others would think. My main concern with enforcement is that it
will start failing to load out-of-tree modules that use newly
namespaced symbols. On the other hand, I think those modules will need
to be rebuilt anyway to be able to load, because the changes to struct
kernel_symbol make them incompatible with the current kernel. That
could be another reason for having these symbols in a special section
(with its own struct namespaced_kernel_symbol); but on the other hand,
it would make the module loader more complex just to facilitate
out-of-tree drivers, and I'm not sure where the trade-off between
those two falls.

> It'd be trivial to fail the module build in
> modpost as well as reject the module on load if it uses an exported
> symbol belonging to a namespace it doesn't import. Although, I'd go
> with the warnings for a development cycle or two, to gently introduce
> the change in API and let other subsystems as well as out-of-tree
> module developers catch up.

An approach like that makes sense to me. Another alternative would be
to make it a CONFIG_ option, and let distros/etc. decide what they are
comfortable with.

Thanks,
Martijn

>
>
> Jessica
>
>
>>> Also, this would get rid of the extra __knsimport section, the extra
>>> ns_dependencies field in struct module, and all those helper functions
>>> that
>>> manage it. In addition, having the modinfo tag may potentially help with
>>> debugging as we have the namespace imports clearly listed if we don't
>>> have
>>> the source code for a module. We'd probably need to modify get_modinfo()
>>> to
>>> handle multiple import: tags though. Luis [1] had written some code a
>>> while
>>> ago to handle multiple (of the same) modinfo tags.
>>>
>>> Thoughts on this?
>>>
>>> Thanks,
>>>
>>> Jessica
>>>
>>> [1] https://lkml.kernel.org/r/20171130023605.29568-3-mcgrof@kernel.org
>>>
>>>
>>>> getname:
>>>>         /* We must make copy under the lock if we failed to get ref. */
>>>>         strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
>>>> @@ -3061,6 +3118,11 @@ static int find_module_sections(struct module
>>>> *mod,
>>>> struct load_info *info)
>>>>                                      sizeof(*mod->gpl_syms),
>>>>                                      &mod->num_gpl_syms);
>>>>         mod->gpl_crcs = section_addr(info, "__kcrctab_gpl");
>>>> +
>>>> +       mod->ns_imports = section_objs(info, "__knsimport",
>>>> +                                      sizeof(*mod->ns_imports),
>>>> +                                      &mod->num_ns_imports);
>>>> +
>>>>         mod->gpl_future_syms = section_objs(info,
>>>>                                             "__ksymtab_gpl_future",
>>>>
>>>> sizeof(*mod->gpl_future_syms),
>>>> @@ -3381,6 +3443,19 @@ static int post_relocation(struct module *mod,
>>>> const struct load_info *info)
>>>>         return module_finalize(info->hdr, info->sechdrs, mod);
>>>> }
>>>>
>>>> +static void verify_namespace_dependencies(struct module *mod)
>>>> +{
>>>> +       struct module_ns_dep *ns_dep;
>>>> +
>>>> +       list_for_each_entry(ns_dep, &mod->ns_dependencies, ns_dep) {
>>>> +               if (!module_imports_ns(mod, ns_dep->namespace)) {
>>>> +                       pr_warn("%s: module uses symbols from namespace
>>>> %s,"
>>>> +                               " but does not import it.\n",
>>>> +                               mod->name, ns_dep->namespace);
>>>> +               }
>>>> +       }
>>>> +}
>>>> +
>>>> /* Is this module of this name done loading?  No locks held. */
>>>> static bool finished_loading(const char *name)
>>>> {
>>>> @@ -3682,6 +3757,8 @@ static int load_module(struct load_info *info,
>>>> const
>>>> char __user *uargs,
>>>>         if (err)
>>>>                 goto free_module;
>>>>
>>>> +       INIT_LIST_HEAD(&mod->ns_dependencies);
>>>> +
>>>> #ifdef CONFIG_MODULE_SIG
>>>>         mod->sig_ok = info->sig_ok;
>>>>         if (!mod->sig_ok) {
>>>> @@ -3730,6 +3807,8 @@ static int load_module(struct load_info *info,
>>>> const
>>>> char __user *uargs,
>>>>         if (err < 0)
>>>>                 goto free_modinfo;
>>>>
>>>> +       verify_namespace_dependencies(mod);
>>>> +
>>>>         flush_module_icache(mod);
>>>>
>>>>         /* Now copy in args */
>>>> --
>>>> 2.18.0.203.gfac676dfb9-goog
>>>>
>>>
>
