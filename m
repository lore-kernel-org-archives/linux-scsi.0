From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 2/6] module: add support for symbol namespaces.
Date: Thu, 26 Jul 2018 09:44:51 +0200
Message-ID: <CAB0TPYFrnEd8KqTz7Hd-Q9__3Hr2_vZne3VMNpUpPosf=wcysg@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <20180716122125.175792-3-maco@android.com>
 <CAB0TPYEOVHcFGFLTjVvk7R0VSgSnXZRi1PjSYXONJSjqd4NewQ@mail.gmail.com>
 <20180725155507.umb5oatduquxwlmt@linux-8ccs> <CAKi4VA+wvVxPxVSP6ruSR++TYvavKPNAQ5XhREF_9ZxeOKQirg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKi4VA+wvVxPxVSP6ruSR++TYvavKPNAQ5XhREF_9ZxeOKQirg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Jessica Yu <jeyu@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2018 at 6:48 PM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> this might be because you are looking to the wrong project
> (module-init-tools) rather than kmod that replaced it some years ago?

Oh yes indeed, thanks for pointing that out :-)


>> Just scanning the depmod source code, it seems really trivial to just
>> have depmod accommodate the new symbol name format. Adding Lucas (kmod
>> maintainer) to CC.
>
> Yep, that would be easy and allow depmod to be backward compatible
> since we would do nothing if the symbol doesn't have the suffix.
> As for dependency on a new version, this seems trivial enough to be
> backported to previous releases used on distros so even if they are
> not rolling they would get a compatible depmod.

Thanks for the suggestion. I had also considered modifying the script
that generates System.map to strip out the namespace; but that seems a
bit hacky since it will then mismatch with the actual symbol table
that's in the kernel image. The situation with depmod has gotten me a
bit worried that perhaps there are more tools that look at System.map
or the kernel's symbol table that won't be able to understand the new
format. But of course those could be updated, too.

Another alternative I was considering is leaving the namespace out of
the __ksymtab symbols, and instead for the symbols that have a
namespace, have an entry in __ksymtab (without namespace) and an entry
in a new section __ksymtab_ns (with namespace). We can then discard
__ksymtab_ns when building the final executable/modules, since that
information is not needed at runtime (it's encoded in struct
kernel_symbol). What makes this a bit more complex is that modpost
takes the fully linked version of vmlinux which would already have
__ksymtab_ns stripped, so we'd need to use objcopy to copy out that
section so modpost can use it to read vmlinux's namespaced symbols.
Modules wouldn't have that problem, since modpost processes modules
before their final linking step.

This last approach is more complex than just modifying depmod, but it
does have the benefit that we won't be break userspace tools depending
on the kernel __ksymtab section symbols. On the other hand, perhaps
userspace tools would like to have the namespace information at some
point.

For now I'll keep things as is and write up a patch for depmod, but if
others prefer the __ksymtab_ns approach I described above I don't mind
making that work.

Thanks,
Martijn

>
> CC'ing linux-modules@vger.kernel.org to keep track of this there
>
>
> thanks
> Lucas De Marchi
>
>>
>> Thanks,
>>
>> Jessica
>>
>> >
>> >>
>> >> On x86_64 I saw no difference in binary size (compression), but at
>> >> runtime this will require a word of memory per export to hold the
>> >> namespace. An alternative could be to store namespaced symbols in their
>> >> own section and use a separate 'struct namespaced_kernel_symbol' for
>> >> that section, at the cost of making the module loader more complex.
>> >>
>> >> Signed-off-by: Martijn Coenen <maco@android.com>
>> >> ---
>> >>  include/asm-generic/export.h |  2 +-
>> >>  include/linux/export.h       | 83 +++++++++++++++++++++++++++---------
>> >>  include/linux/module.h       | 13 ++++++
>> >>  kernel/module.c              | 79 ++++++++++++++++++++++++++++++++++
>> >>  4 files changed, 156 insertions(+), 21 deletions(-)
>> >>
>> >> diff --git a/include/asm-generic/export.h b/include/asm-generic/export.h
>> >> index 68efb950a918..4c3d1afb702f 100644
>> >> --- a/include/asm-generic/export.h
>> >> +++ b/include/asm-generic/export.h
>> >> @@ -29,7 +29,7 @@
>> >>         .section ___ksymtab\sec+\name,"a"
>> >>         .balign KSYM_ALIGN
>> >>  __ksymtab_\name:
>> >> -       __put \val, __kstrtab_\name
>> >> +       __put \val, __kstrtab_\name, 0
>> >>         .previous
>> >>         .section __ksymtab_strings,"a"
>> >>  __kstrtab_\name:
>> >> diff --git a/include/linux/export.h b/include/linux/export.h
>> >> index ad6b8e697b27..9f6e70eeb85f 100644
>> >> --- a/include/linux/export.h
>> >> +++ b/include/linux/export.h
>> >> @@ -22,6 +22,11 @@ struct kernel_symbol
>> >>  {
>> >>         unsigned long value;
>> >>         const char *name;
>> >> +       const char *namespace;
>> >> +};
>> >> +
>> >> +struct namespace_import {
>> >> +       const char *namespace;
>> >>  };
>> >>
>> >>  #ifdef MODULE
>> >> @@ -54,18 +59,28 @@ extern struct module __this_module;
>> >>  #define __CRC_SYMBOL(sym, sec)
>> >>  #endif
>> >>
>> >> +#define NS_SEPARATOR "."
>> >> +
>> >> +#define MODULE_IMPORT_NS(ns)                                           \
>> >> +       static const struct namespace_import __knsimport_##ns           \
>> >> +       asm("__knsimport_" #ns)                                         \
>> >> +       __attribute__((section("__knsimport"), used))                   \
>> >> +       = { #ns }
>> >> +
>> >>  /* For every exported symbol, place a struct in the __ksymtab section */
>> >> -#define ___EXPORT_SYMBOL(sym, sec)                                     \
>> >> +#define ___EXPORT_SYMBOL(sym, sec, ns, nspost, nspost2)                        \
>> >>         extern typeof(sym) sym;                                         \
>> >>         __CRC_SYMBOL(sym, sec)                                          \
>> >> -       static const char __kstrtab_##sym[]                             \
>> >> +       static const char __kstrtab_##sym##nspost[]                     \
>> >>         __attribute__((section("__ksymtab_strings"), aligned(1)))       \
>> >>         = #sym;                                                         \
>> >> -       static const struct kernel_symbol __ksymtab_##sym               \
>> >> +       static const struct kernel_symbol __ksymtab_##sym##nspost       \
>> >> +       asm("__ksymtab_" #sym nspost2)                                  \
>> >>         __used                                                          \
>> >> -       __attribute__((section("___ksymtab" sec "+" #sym), used))       \
>> >> +       __attribute__((section("___ksymtab" sec "+" #sym #nspost)))     \
>> >> +       __attribute__((used))                                           \
>> >>         __attribute__((aligned(sizeof(void *))))                        \
>> >> -       = { (unsigned long)&sym, __kstrtab_##sym }
>> >> +       = { (unsigned long)&sym, __kstrtab_##sym##nspost, ns }
>> >>
>> >>  #if defined(__KSYM_DEPS__)
>> >>
>> >> @@ -76,52 +91,80 @@ extern struct module __this_module;
>> >>   * system filters out from the preprocessor output (see ksym_dep_filter
>> >>   * in scripts/Kbuild.include).
>> >>   */
>> >> -#define __EXPORT_SYMBOL(sym, sec)      === __KSYM_##sym ===
>> >> +#define __EXPORT_SYMBOL(sym, sec, ns, nspost, nspost2) === __KSYM_##sym ===
>> >>
>> >>  #elif defined(CONFIG_TRIM_UNUSED_KSYMS)
>> >>
>> >>  #include <generated/autoksyms.h>
>> >>
>> >> -#define __EXPORT_SYMBOL(sym, sec)                              \
>> >> -       __cond_export_sym(sym, sec, __is_defined(__KSYM_##sym))
>> >> -#define __cond_export_sym(sym, sec, conf)                      \
>> >> -       ___cond_export_sym(sym, sec, conf)
>> >> -#define ___cond_export_sym(sym, sec, enabled)                  \
>> >> -       __cond_export_sym_##enabled(sym, sec)
>> >> -#define __cond_export_sym_1(sym, sec) ___EXPORT_SYMBOL(sym, sec)
>> >> -#define __cond_export_sym_0(sym, sec) /* nothing */
>> >> +#define __EXPORT_SYMBOL(sym, sec, ns, nspost, nspost2)                 \
>> >> +       __cond_export_sym(sym, sec, ns, nspost, nspost2,                \
>> >> +                         __is_defined(__KSYM_##sym))
>> >> +#define __cond_export_sym(sym, sec, ns, nspost, nspost2, conf)         \
>> >> +       ___cond_export_sym(sym, sec, ns, nspost, nspost2, conf)
>> >> +#define ___cond_export_sym(sym, sec, ns, nspost, nspost2, enabled)     \
>> >> +       __cond_export_sym_##enabled(sym, sec, ns, nspost, nspost2)
>> >> +#define __cond_export_sym_1(sym, sec, ns, nspost, nspost2)             \
>> >> +       ___EXPORT_SYMBOL(sym, sec, ns, nspost, nspost2)
>> >> +#define __cond_export_sym_0(sym, sec, ns, nspost, nspost2) /* nothing */
>> >>
>> >>  #else
>> >>  #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
>> >>  #endif
>> >>
>> >>  #define EXPORT_SYMBOL(sym)                                     \
>> >> -       __EXPORT_SYMBOL(sym, "")
>> >> +       __EXPORT_SYMBOL(sym, "", NULL, ,)
>> >>
>> >>  #define EXPORT_SYMBOL_GPL(sym)                                 \
>> >> -       __EXPORT_SYMBOL(sym, "_gpl")
>> >> +       __EXPORT_SYMBOL(sym, "_gpl", NULL, ,)
>> >>
>> >>  #define EXPORT_SYMBOL_GPL_FUTURE(sym)                          \
>> >> -       __EXPORT_SYMBOL(sym, "_gpl_future")
>> >> +       __EXPORT_SYMBOL(sym, "_gpl_future", NULL, ,)
>> >> +
>> >> +#define EXPORT_SYMBOL_NS(sym, ns)                               \
>> >> +       __EXPORT_SYMBOL(sym, "", #ns, __##ns, NS_SEPARATOR #ns)
>> >> +
>> >> +#define EXPORT_SYMBOL_NS_GPL(sym, ns)                               \
>> >> +       __EXPORT_SYMBOL(sym, "_gpl", #ns, __##ns, NS_SEPARATOR #ns)
>> >>
>> >>  #ifdef CONFIG_UNUSED_SYMBOLS
>> >> -#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
>> >> -#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
>> >> +#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused", , ,)
>> >> +#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl", , ,)
>> >>  #else
>> >>  #define EXPORT_UNUSED_SYMBOL(sym)
>> >>  #define EXPORT_UNUSED_SYMBOL_GPL(sym)
>> >>  #endif
>> >>
>> >> -#endif /* __GENKSYMS__ */
>> >> +#endif /* __KERNEL__ && !__GENKSYMS__ */
>> >> +
>> >> +#if defined(__GENKSYMS__)
>> >> +/*
>> >> + * When we're running genksyms, ignore the namespace and make the _NS
>> >> + * variants look like the normal ones. There are two reasons for this:
>> >> + * 1) In the normal definition of EXPORT_SYMBOL_NS, the 'ns' macro
>> >> + *    argument is itself not expanded because it's always tokenized or
>> >> + *    concatenated; but when running genksyms, a blank definition of the
>> >> + *    macro does allow the argument to be expanded; if a namespace
>> >> + *    happens to collide with a #define, this can cause issues.
>> >> + * 2) There's no need to modify genksyms to deal with the _NS variants
>> >> + */
>> >> +#define EXPORT_SYMBOL_NS(sym, ns)                              \
>> >> +       EXPORT_SYMBOL(sym)
>> >> +#define EXPORT_SYMBOL_NS_GPL(sym, ns)                          \
>> >> +       EXPORT_SYMBOL_GPL(sym)
>> >> +#endif
>> >>
>> >>  #else /* !CONFIG_MODULES... */
>> >>
>> >>  #define EXPORT_SYMBOL(sym)
>> >> +#define EXPORT_SYMBOL_NS(sym, ns)
>> >> +#define EXPORT_SYMBOL_NS_GPL(sym, ns)
>> >>  #define EXPORT_SYMBOL_GPL(sym)
>> >>  #define EXPORT_SYMBOL_GPL_FUTURE(sym)
>> >>  #define EXPORT_UNUSED_SYMBOL(sym)
>> >>  #define EXPORT_UNUSED_SYMBOL_GPL(sym)
>> >>
>> >> +#define MODULE_IMPORT_NS(ns)
>> >>  #endif /* CONFIG_MODULES */
>> >>  #endif /* !__ASSEMBLY__ */
>> >>
>> >> diff --git a/include/linux/module.h b/include/linux/module.h
>> >> index d44df9b2c131..afab4e8fa188 100644
>> >> --- a/include/linux/module.h
>> >> +++ b/include/linux/module.h
>> >> @@ -268,6 +268,12 @@ void *__symbol_get(const char *symbol);
>> >>  void *__symbol_get_gpl(const char *symbol);
>> >>  #define symbol_get(x) ((typeof(&x))(__symbol_get(VMLINUX_SYMBOL_STR(x))))
>> >>
>> >> +/* namespace dependencies of the module */
>> >> +struct module_ns_dep {
>> >> +       struct list_head ns_dep;
>> >> +       const char *namespace;
>> >> +};
>> >> +
>> >>  /* modules using other modules: kdb wants to see this. */
>> >>  struct module_use {
>> >>         struct list_head source_list;
>> >> @@ -359,6 +365,13 @@ struct module {
>> >>         const struct kernel_symbol *gpl_syms;
>> >>         const s32 *gpl_crcs;
>> >>
>> >> +       /* Namespace imports */
>> >> +       unsigned int num_ns_imports;
>> >> +       const struct namespace_import *ns_imports;
>> >> +
>> >> +       /* Namespace dependencies */
>> >> +       struct list_head ns_dependencies;
>> >> +
>> >>  #ifdef CONFIG_UNUSED_SYMBOLS
>> >>         /* unused exported symbols. */
>> >>         const struct kernel_symbol *unused_syms;
>> >> diff --git a/kernel/module.c b/kernel/module.c
>> >> index f475f30eed8c..63de0fe849f9 100644
>> >> --- a/kernel/module.c
>> >> +++ b/kernel/module.c
>> >> @@ -1166,6 +1166,51 @@ static inline int module_unload_init(struct module *mod)
>> >>  }
>> >>  #endif /* CONFIG_MODULE_UNLOAD */
>> >>
>> >> +static bool module_has_ns_dependency(struct module *mod, const char *ns)
>> >> +{
>> >> +       struct module_ns_dep *ns_dep;
>> >> +
>> >> +       list_for_each_entry(ns_dep, &mod->ns_dependencies, ns_dep) {
>> >> +               if (strcmp(ns_dep->namespace, ns) == 0)
>> >> +                       return true;
>> >> +       }
>> >> +
>> >> +       return false;
>> >> +}
>> >> +
>> >> +static int add_module_ns_dependency(struct module *mod, const char *ns)
>> >> +{
>> >> +       struct module_ns_dep *ns_dep;
>> >> +
>> >> +       if (module_has_ns_dependency(mod, ns))
>> >> +               return 0;
>> >> +
>> >> +       ns_dep = kmalloc(sizeof(*ns_dep), GFP_ATOMIC);
>> >> +       if (!ns_dep)
>> >> +               return -ENOMEM;
>> >> +
>> >> +       ns_dep->namespace = ns;
>> >> +
>> >> +       list_add(&ns_dep->ns_dep, &mod->ns_dependencies);
>> >> +
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static bool module_imports_ns(struct module *mod, const char *ns)
>> >> +{
>> >> +       size_t i;
>> >> +
>> >> +       if (!ns)
>> >> +               return true;
>> >> +
>> >> +       for (i = 0; i < mod->num_ns_imports; ++i) {
>> >> +               if (!strcmp(mod->ns_imports[i].namespace, ns))
>> >> +                       return true;
>> >> +       }
>> >> +
>> >> +       return false;
>> >> +}
>> >> +
>> >>  static size_t module_flags_taint(struct module *mod, char *buf)
>> >>  {
>> >>         size_t l = 0;
>> >> @@ -1415,6 +1460,18 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
>> >>                 goto getname;
>> >>         }
>> >>
>> >> +       /*
>> >> +        * We can't yet verify that the module actually imports this
>> >> +        * namespace, because the imports themselves are only available
>> >> +        * after processing the symbol table and doing relocation; so
>> >> +        * instead just record the dependency and check later.
>> >> +        */
>> >> +       if (sym->namespace) {
>> >> +               err = add_module_ns_dependency(mod, sym->namespace);
>> >> +               if (err)
>> >> +                       sym = ERR_PTR(err);
>> >> +       }
>> >> +
>> >>  getname:
>> >>         /* We must make copy under the lock if we failed to get ref. */
>> >>         strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
>> >> @@ -3061,6 +3118,11 @@ static int find_module_sections(struct module *mod, struct load_info *info)
>> >>                                      sizeof(*mod->gpl_syms),
>> >>                                      &mod->num_gpl_syms);
>> >>         mod->gpl_crcs = section_addr(info, "__kcrctab_gpl");
>> >> +
>> >> +       mod->ns_imports = section_objs(info, "__knsimport",
>> >> +                                      sizeof(*mod->ns_imports),
>> >> +                                      &mod->num_ns_imports);
>> >> +
>> >>         mod->gpl_future_syms = section_objs(info,
>> >>                                             "__ksymtab_gpl_future",
>> >>                                             sizeof(*mod->gpl_future_syms),
>> >> @@ -3381,6 +3443,19 @@ static int post_relocation(struct module *mod, const struct load_info *info)
>> >>         return module_finalize(info->hdr, info->sechdrs, mod);
>> >>  }
>> >>
>> >> +static void verify_namespace_dependencies(struct module *mod)
>> >> +{
>> >> +       struct module_ns_dep *ns_dep;
>> >> +
>> >> +       list_for_each_entry(ns_dep, &mod->ns_dependencies, ns_dep) {
>> >> +               if (!module_imports_ns(mod, ns_dep->namespace)) {
>> >> +                       pr_warn("%s: module uses symbols from namespace %s,"
>> >> +                               " but does not import it.\n",
>> >> +                               mod->name, ns_dep->namespace);
>> >> +               }
>> >> +       }
>> >> +}
>> >> +
>> >>  /* Is this module of this name done loading?  No locks held. */
>> >>  static bool finished_loading(const char *name)
>> >>  {
>> >> @@ -3682,6 +3757,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
>> >>         if (err)
>> >>                 goto free_module;
>> >>
>> >> +       INIT_LIST_HEAD(&mod->ns_dependencies);
>> >> +
>> >>  #ifdef CONFIG_MODULE_SIG
>> >>         mod->sig_ok = info->sig_ok;
>> >>         if (!mod->sig_ok) {
>> >> @@ -3730,6 +3807,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
>> >>         if (err < 0)
>> >>                 goto free_modinfo;
>> >>
>> >> +       verify_namespace_dependencies(mod);
>> >> +
>> >>         flush_module_icache(mod);
>> >>
>> >>         /* Now copy in args */
>> >> --
>> >> 2.18.0.203.gfac676dfb9-goog
>> >>
>
>
>
> --
> Lucas De Marchi
