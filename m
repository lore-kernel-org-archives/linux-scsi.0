From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI trees, merges and git status
Date: Mon, 18 Apr 2005 21:17:51 -0500
Message-ID: <1113877071.4998.111.camel@mulgrave>
References: <1113856118.4998.70.camel@mulgrave>
	 <Pine.LNX.4.58.0504181429570.15725@ppc970.osdl.org>
	 <1113866092.4998.92.camel@mulgrave>
	 <Pine.LNX.4.58.0504181651241.15725@ppc970.osdl.org>
	 <1113869594.4998.103.camel@mulgrave>
	 <Pine.LNX.4.58.0504181724170.15725@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39810 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261279AbVDSCSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 22:18:03 -0400
In-Reply-To: <Pine.LNX.4.58.0504181724170.15725@ppc970.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: git@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-04-18 at 17:29 -0700, Linus Torvalds wrote:
> 2.6.12 is some time away, if for no other reason than the fact that this 
> SCM thing has obviously eaten two weeks of my time. So I'd be inclined to 
> chalk this up as a "learning experience" with git, and just go forward.

Fair enough.  If you pull from

rsync://www.parisc-linux.org/~jejb/scsi-misc-2.6.git

That will pull in the rest of my scsi-misc-2.6 tree (which includes all
of the rc fixes).  I've done a test pull and merge and checked the
resulting against BK, so hopefully there should be no more screw ups.

Doing this exposed two bugs in your merge script:

1) It doesn't like a completely new directory (the misc tree contains a
new drivers/scsi/lpfc)
2) the merge testing logic is wrong.  You only want to exit 1 if the
merge fails.

James

git-merge-one-file-script: bec009e2c37bacc9e6f9cad1cfa5fd56752c7bf1
--- a/git-merge-one-file-script
+++ b/git-merge-one-file-script
@@ -13,6 +13,11 @@
 # do any merges that migth change the tree layout
 #
 
+# if the directory is newly added in a branch, it might not exist
+# in the current tree
+dir=$(dirname "$4")
+mkdir -p "$dir"
+
 case "${1:-.}${2:-.}${3:-.}" in
 #
 # deleted in both, or deleted in one and unchanged in the other
@@ -40,7 +45,11 @@ case "${1:-.}${2:-.}${3:-.}" in
 	orig=$(unpack-file $1)
 	src1=$(unpack-file $2)
 	src2=$(unpack-file $3)
-	merge "$src2" "$orig" "$src1" || echo Leaving conflict merge in $src2 && exit 1
+	merge "$src2" "$orig" "$src1"
+	if [ $? -ne 0 ]; then
+		echo Leaving conflict merge in $src2
+		exit 1
+	fi
 	cp "$src2" "$4" && update-cache --add -- "$4" && exit 0
 	;;
 


