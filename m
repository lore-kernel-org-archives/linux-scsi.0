From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: checkpatch: kill the bogus camelcase check
Date: Tue, 09 Apr 2013 14:50:54 -0700
Message-ID: <1365544254.2946.53.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It's making checkpatch unusable on most drivers because it's spewing
tons of bogus warnings.  The problem is the assumption that studly caps
is always wrong: it isn't if the variables are named after the various
conventions in the hardware programming guides (which are usually
written by Microsoft people).

In order to encourage people to use checkpatch, it has to be *useful* it
can't stray too far into dogmatic things like this that are essentially
unfixable by most people who submit patches.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..5588dd3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1398,8 +1398,6 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
-	my %camelcase = ();
-
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
 	#
@@ -2925,19 +2923,6 @@ sub process {
 			}
 		}
 
-#CamelCase
-		while ($line =~ m{($Constant|$Lval)}g) {
-			my $var = $1;
-			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
-			    !defined $camelcase{$var}) {
-				$camelcase{$var} = 1;
-				WARN("CAMELCASE",
-				     "Avoid CamelCase: <$var>\n" . $herecurr);
-			}
-		}
-
 #no spaces allowed after \ in define
 		if ($line=~/\#\s*define.*\\\s$/) {
 			WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
