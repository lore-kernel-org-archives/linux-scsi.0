From: Martijn Coenen <maco@android.com>
Subject: [PATCH 3/6] modpost: add support for checking symbol namespaces.
Date: Mon, 16 Jul 2018 14:21:22 +0200
Message-ID: <20180716122125.175792-4-maco@android.com>
References: <20180716122125.175792-1-maco@android.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716122125.175792-1-maco@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Martijn Coenen <maco@android.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi
List-Id: linux-scsi@vger.kernel.org

Emits a warning whenever a module refers to an exported symbol without
explicitly importing the namespace that it is defined in.

Example:

WARNING: module ums-usbat uses symbol usb_stor_resume from namespace
USB_STORAGE_NS, but does not import it.

Signed-off-by: Martijn Coenen <maco@android.com>
---
 scripts/mod/modpost.c | 70 +++++++++++++++++++++++++++++++++++++++----
 scripts/mod/modpost.h |  7 +++++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1663fb19343a..a56a8461a96a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -165,6 +165,7 @@ struct symbol {
 	struct module *module;
 	unsigned int crc;
 	int crc_valid;
+	const char *ns; /* namespace */
 	unsigned int weak:1;
 	unsigned int vmlinux:1;    /* 1 if symbol is defined in vmlinux */
 	unsigned int kernel:1;     /* 1 if symbol is from kernel
@@ -234,6 +235,35 @@ static struct symbol *find_symbol(const char *name)
 	return NULL;
 }
 
+static bool contains_namespace(struct namespace_list *list, const char *ns)
+{
+	struct namespace_list *ns_entry;
+
+	for (ns_entry = list; ns_entry != NULL; ns_entry = ns_entry->next) {
+		if (strcmp(ns_entry->namespace, ns) == 0)
+			return true;
+	}
+
+	return false;
+}
+
+static void add_namespace(struct namespace_list **list, const char *ns)
+{
+	struct namespace_list *ns_entry;
+
+	if (!contains_namespace(*list, ns)) {
+		ns_entry = NOFAIL(malloc(sizeof(struct namespace_list)));
+		strcpy(ns_entry->namespace, ns);
+		ns_entry->next = *list;
+		*list = ns_entry;
+	}
+}
+
+static bool module_imports_namespace(struct module *module, const char *ns)
+{
+	return contains_namespace(module->imported_namespaces, ns);
+}
+
 static const struct {
 	const char *str;
 	enum export export;
@@ -313,21 +343,40 @@ static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 		return export_unknown;
 }
 
+static const char *sym_extract_ns(const char **symname)
+{
+	size_t n;
+
+	n = strcspn(*symname, ".");
+	if (n < strlen(*symname) - 1) {
+		char *dupsymname = NOFAIL(strdup(*symname));
+
+		dupsymname[n] = '\0';
+		*symname = dupsymname;
+		return dupsymname + n + 1;
+	} else {
+		return NULL;
+	}
+}
+
 /**
  * Add an exported symbol - it may have already been added without a
  * CRC, in this case just update the CRC
  **/
-static struct symbol *sym_add_exported(const char *name, struct module *mod,
-				       enum export export)
+static struct symbol *sym_add_exported(const char *name,
+				       struct module *mod, enum export export)
 {
-	struct symbol *s = find_symbol(name);
+	const char *extract_name = name;
+	const char *ns = sym_extract_ns(&extract_name);
+	struct symbol *s = find_symbol(extract_name);
 
 	if (!s) {
-		s = new_symbol(name, mod, export);
+		s = new_symbol(extract_name, mod, export);
+		s->ns = ns;
 	} else {
 		if (!s->preloaded) {
 			warn("%s: '%s' exported twice. Previous export "
-			     "was in %s%s\n", mod->name, name,
+			     "was in %s%s\n", mod->name, extract_name,
 			     s->module->name,
 			     is_vmlinux(s->module->name) ?"":".ko");
 		} else {
@@ -697,6 +746,10 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 		}
 		if (strcmp(symname, "init_module") == 0)
 			mod->has_init = 1;
+		if (strstarts(symname, "__knsimport_")) {
+			const char *name = symname + strlen("__knsimport_");
+			add_namespace(&mod->imported_namespaces, name);
+		}
 		if (strcmp(symname, "cleanup_module") == 0)
 			mod->has_cleanup = 1;
 		break;
@@ -2097,6 +2150,13 @@ static void check_exports(struct module *mod)
 			basename++;
 		else
 			basename = mod->name;
+
+		if (exp->ns && !module_imports_namespace(mod, exp->ns)) {
+			warn("module %s uses symbol %s from namespace %s, "
+			     "but does not import it.\n",
+			     basename, exp->name, exp->ns);
+		}
+
 		if (!mod->gpl_compatible)
 			check_for_gpl_usage(exp->export, basename, exp->name);
 		check_for_unused(exp->export, basename, exp->name);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 8453d6ac2f77..9626bf3e7424 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -109,6 +109,11 @@ buf_printf(struct buffer *buf, const char *fmt, ...);
 void
 buf_write(struct buffer *buf, const char *s, int len);
 
+struct namespace_list {
+	struct namespace_list *next;
+	char namespace[0];
+};
+
 struct module {
 	struct module *next;
 	const char *name;
@@ -121,6 +126,8 @@ struct module {
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
 	int is_dot_o;
+	// Actual imported namespaces
+	struct namespace_list *imported_namespaces;
 };
 
 struct elf_info {
-- 
2.18.0.203.gfac676dfb9-goog
