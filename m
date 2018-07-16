From: Martijn Coenen <maco@android.com>
Subject: [PATCH 4/6] modpost: add support for generating namespace dependencies.
Date: Mon, 16 Jul 2018 14:21:23 +0200
Message-ID: <20180716122125.175792-5-maco@android.com>
References: <20180716122125.175792-1-maco@android.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716122125.175792-1-maco@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Martijn Coenen <maco@android.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi
List-Id: linux-scsi@vger.kernel.org

This patch adds an option to modpost to generate a .ns_deps file per
module, containing the namespace depedencies for that module.

This file can subsequently be used by other tools to automatically add
newly introduced namespaces to the modules that require them, saving a
lot of manual work.

Signed-off-by: Martijn Coenen <maco@android.com>
---
 scripts/mod/modpost.c | 58 +++++++++++++++++++++++++++++++++++++++----
 scripts/mod/modpost.h |  2 ++
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a56a8461a96a..be33d60d5527 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -39,6 +39,8 @@ static int sec_mismatch_verbose = 1;
 static int sec_mismatch_fatal = 0;
 /* ignore missing files */
 static int ignore_missing_files;
+/* Write namespace dependencies */
+static int write_ns_deps;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -2151,10 +2153,15 @@ static void check_exports(struct module *mod)
 		else
 			basename = mod->name;
 
-		if (exp->ns && !module_imports_namespace(mod, exp->ns)) {
-			warn("module %s uses symbol %s from namespace %s, "
-			     "but does not import it.\n",
-			     basename, exp->name, exp->ns);
+		if (exp->ns) {
+			add_namespace(&mod->required_namespaces, exp->ns);
+
+			if (!write_ns_deps &&
+			    !module_imports_namespace(mod, exp->ns)) {
+				warn("module %s uses symbol %s from namespace "
+				     "%s, but does not import it.\n",
+				     basename, exp->name, exp->ns);
+			}
 		}
 
 		if (!mod->gpl_compatible)
@@ -2457,6 +2464,38 @@ static void write_dump(const char *fname)
 	free(buf.p);
 }
 
+static void write_ns_deps_files(void)
+{
+	struct module *mod;
+	struct namespace_list *ns;
+	struct buffer ns_deps_buf = { };
+
+	for (mod = modules; mod; mod = mod->next) {
+		char fname[PATH_MAX];
+		const char *basename;
+
+		if (mod->skip)
+			continue;
+
+		ns_deps_buf.pos = 0;
+
+		for (ns = mod->required_namespaces; ns; ns = ns->next)
+			buf_printf(&ns_deps_buf, "%s\n", ns->namespace);
+
+		if (ns_deps_buf.pos == 0)
+			continue;
+
+		basename = strrchr(mod->name, '/');
+		if (basename)
+			basename++;
+		else
+			basename = mod->name;
+
+		sprintf(fname, ".tmp_versions/%s.ns_deps", basename);
+		write_if_changed(&ns_deps_buf, fname);
+	}
+}
+
 struct ext_sym_list {
 	struct ext_sym_list *next;
 	const char *file;
@@ -2473,7 +2512,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:mnsST:o:awM:K:E")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:mnsST:o:awM:K:Ed")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2517,6 +2556,9 @@ int main(int argc, char **argv)
 		case 'E':
 			sec_mismatch_fatal = 1;
 			break;
+		case 'd':
+			write_ns_deps = 1;
+			break;
 		default:
 			exit(1);
 		}
@@ -2545,6 +2587,12 @@ int main(int argc, char **argv)
 		check_exports(mod);
 	}
 
+	if (write_ns_deps) {
+		/* Just write namespace dependencies and exit */
+		write_ns_deps_files();
+		return 0;
+	}
+
 	err = 0;
 
 	for (mod = modules; mod; mod = mod->next) {
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 9626bf3e7424..92a926d375d2 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -126,6 +126,8 @@ struct module {
 	struct buffer dev_table_buf;
 	char	     srcversion[25];
 	int is_dot_o;
+	// Required namespace dependencies
+	struct namespace_list *required_namespaces;
 	// Actual imported namespaces
 	struct namespace_list *imported_namespaces;
 };
-- 
2.18.0.203.gfac676dfb9-goog
