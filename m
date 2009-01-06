From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 5/6] bootchart: improve output
Date: Mon, 5 Jan 2009 20:13:17 -0800
Message-ID: <20090105201317.249aeae3@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZAFENg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 23:13:36 -0500
In-Reply-To: <20090105200959.04a626ac@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

>From ec57f2c6755c5439dcb273f9529f0575b6084d02 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 10:59:18 -0800
Subject: [PATCH] bootchart: improve output based on Dave Jones' feedback

Dave Jones, in his blog, had some feedback about the bootchart script:
Primarily his complaint was that shorter delays weren't visualized.

The reason for that was that too small delays will have their labels
mixed up in the graph in an unreadable mess.

This patch has a fix for this; for one, it makes the output wider,
so more will fit.
The second part is that smaller delays are now shown with a
much smaller font for the label; while this isn't per se
readable at a 1:1 zoom, at least you can zoom in with most SVG
viewing applications and see what it is you are looking at.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 scripts/bootgraph.pl |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index f0af9aa..0a498e3 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -88,7 +88,7 @@ END
 }
 
 print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
-print "<svg width=\"1000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+print "<svg width=\"2000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
 
 my @styles;
 
@@ -105,8 +105,9 @@ $styles[9] = "fill:rgb(255,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0
 $styles[10] = "fill:rgb(255,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 $styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
 
-my $mult = 950.0 / ($maxtime - $firsttime);
-my $threshold = ($maxtime - $firsttime) / 60.0;
+my $mult = 1950.0 / ($maxtime - $firsttime);
+my $threshold2 = ($maxtime - $firsttime) / 120.0;
+my $threshold = $threshold2/10;
 my $stylecounter = 0;
 my %rows;
 my $rowscount = 1;
@@ -116,7 +117,7 @@ foreach my $key (@initcalls) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
-		my ($s, $s2, $e, $w, $y, $y2, $style);
+		my ($s, $s2, $s3, $e, $w, $y, $y2, $style);
 		my $pid = $pids{$key};
 
 		if (!defined($rows{$pid})) {
@@ -125,6 +126,7 @@ foreach my $key (@initcalls) {
 		}
 		$s = ($start{$key} - $firsttime) * $mult;
 		$s2 = $s + 6;
+		$s3 = $s + 1;
 		$e = ($end{$key} - $firsttime) * $mult;
 		$w = $e - $s;
 
@@ -138,7 +140,11 @@ foreach my $key (@initcalls) {
 		};
 
 		print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
-		print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+		if ($duration >= $threshold2) {
+			print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+		} else {
+			print "<text transform=\"translate($s3,$y2) rotate(90)\" font-size=\"3pt\">$key</text>\n";
+		}
 	}
 }
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
