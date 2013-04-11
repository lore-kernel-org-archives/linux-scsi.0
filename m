From: Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: Make camelcase test --strict and less noisy
Date: Thu, 11 Apr 2013 07:45:03 -0700
Message-ID: <1365691503.1929.15.camel@joe-AO722>
References: <1365544254.2946.53.camel@dabdike> <20130410132628.GV7511@dm>
	 <1365604558.27174.36.camel@joe-AO722> <20130410145213.GA6854@pd.tnic>
	 <1365606461.1942.3.camel@dabdike> <20130410151911.GG6857@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130410151911.GG6857@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andy Whitcroft <apw@canonical.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

CamelCase tests are a bit noisy against certain
types of code acceptable to some kernel developers.

Make the test applicable only with --strict.

Do not bleat a message on nominally acceptable
CamelCase uses that are separated by an _ like
drm_core_has_MTRR.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3fb6d86..97226fb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2937,12 +2937,12 @@ sub process {
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
-				WARN("CAMELCASE",
-				     "Avoid CamelCase: <$var>\n" . $herecurr);
+				CHK("CAMELCASE",
+				    "Avoid CamelCase: <$var>\n" . $herecurr);
 			}
 		}
 
